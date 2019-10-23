#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXIT_CODE=0

error() {
    MESSAGE="$*"
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    echo -e "${RED} ERROR: ${MESSAGE}${NC}"
    EXIT_CODE=63
}

create_dotlink() {
    FILE=$1
    SYMLINK=$HOME/$1
    TARGET="$DIR/$1"

    # Checking repo health
    if [ ! -e $FILE ]; then
        error "\"$FILE\" does not exist in you repo?!"
        return 1
    fi

    # Checking symlink health
    if [ -f $SYMLINK ] && [ ! -L $SYMLINK ]; then
        if ! diff -qr "$SYMLINK" "$TARGET" > /dev/null ; then
            echo "WARNING: Skipping locally edited file: \"$SYMLINK\""
            return 0
        fi
    fi

    mime=$(file --no-dereference  --mime-type  --brief $SYMLINK)

    if [ "$mime" = "inode/directory" ]; then
        error "ERROR creating $SYMLINK: I am not replacing a folder"
        return 1
    fi

    # Install symlink
    if [ "$mime" != "inode/symlink" ]; then
        if [ -f $SYMLINK ]; then
            echo "Forcing creation of $SYMLINK"
            /bin/rm  "$SYMLINK"
        fi
        ln --verbose -s "$TARGET" "$SYMLINK"
    else
        echo $SYMLINK already installed
    fi

}

CP="/bin/cp -av"

# This is a nice title
title() {
    echo
    echo " $*"
    echo "-----------------"
}

# Clone a Git repository
# arguments:
# 1. The URL of the repo
# 2. The target folder
# 3. The Git ref (optional)
gitget() {
    url=$1
    folder=$2
    git_ref=$3

    if [ -d $folder ]; then
        echo "Updating from \"${url}\" into \"${folder}\"..."
        cd $folder
        git fetch
    else
        echo "Downloading from $url into $folder..."
        git clone $url $folder
        cd $folder
    fi
    if [ -n "$git_ref" ]; then
        found="no"
        # we are looking for a branch name
        for refname in $(git for-each-ref --format='%(refname)' refs/remotes/origin refs/tags/); do
            if [ "refs/remotes/origin/$git_ref" == "$refname" ]; then
                found="yes"
                echo "Checking out to branch $git_ref"
                git reset --hard "origin/$git_ref"
                break
            fi
        done
        # branch name not found, this must be a commit hash
        if [ "$found" == "no" ]; then
            echo "Checking out ref \"$git_ref\"."
            git reset --hard "$git_ref"
        fi
    fi

    cd $DIR
}

# Clone a Gist file (from Github") into the tmp directory
# Arguments:
# - The Gist ID
function gist() {
    gist_id=$1
    if [ -n "$2" ]; then
        echo "wtf gist \"$2\" ( $* )"
        return 1
    fi

    echo Downloading Gist $gist_id
    mkdir -p ./tmp
    gitget https://gist.github.com/$gist_id.git ./tmp/$gist_id
}

title "Installing dot files..."

create_dotlink .shell_aliases
create_dotlink .bashrc
create_dotlink .gitconfig
create_dotlink .gitignore-global
create_dotlink .tmux.conf
create_dotlink .ackrc
## For nice colors with the ls command ( https://github.com/seebi/dircolors-solarized )
create_dotlink .dircolors
#set +e # ignore jinja2 import errors
./conkyrc.py > .conkyrc
create_dotlink .conkyrc

title "Install files in .local/bin"

mkdir -p ~/.local/bin
create_dotlink .local/bin/git-branch-deletable
create_dotlink .local/bin/git-branches-authors
create_dotlink .local/bin/git-find-md5
create_dotlink .local/bin/git-ls-wip

set -e

gist "eef091d73879f8d0d5661efc834e69dc"
create_dotlink .local/bin/git-fetch-all

title "Installing my ZSH workplace"
[ ! -d ~/.zsh ] && mkdir -p ~/.zsh
create_dotlink .zshrc

# LiquidPrompt
gitget https://github.com/SamK/liquidprompt.git .zsh/liquidprompt fix/do-not-redeclare
create_dotlink .zsh/liquidprompt

# A lot of completion features for ZSH
gitget https://github.com/zsh-users/zsh-completions.git .zsh/zsh-completions
create_dotlink .zsh/zsh-completions

curl --show-error --silent https://raw.githubusercontent.com/borgbackup/borg/1.1.5/scripts/shell_completions/zsh/_borg \
> .zsh/zsh-completions/src/_borg

title Vim

create_dotlink .vimrc
mkdir -p ~/.vim/

# TODO: tmpdir
echo "Installing solarized theme for Vim..."
gitget https://github.com/altercation/solarized.git tmp/solarized
create_dotlink .vim/colors

echo VIM-Plug...
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo Installing Vim plugins...
vim +PlugInstall +qall

echo "Setup completed."

exit $EXIT_CODE

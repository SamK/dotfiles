#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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

# Clone a Gist file (from Github") and put it as a command in the .local/bin directory
# Arguments:
# 1. The target command name
# 2. The Gist ID
function gist() {
    cmd=$1
    gist_id=$2
    echo Downloading Gist $gist_id as $cmd...
    gitget https://gist.github.com/$gist_id.git ~/.local/bin/$gist_id
    [ -f ~/.local/bin/$cmd ] || ln -s $gist_id/$cmd ~/.local/bin/$cmd

}

title "Installing dot files..."

$CP ./shell_aliases ~/.shell_aliases
$CP ./bashrc ~/.bashrc
$CP ./gitconfig ~/.gitconfig
$CP ./gitignore-global ~/.gitignore-global
$CP ./tmux.conf ~/.tmux.conf
$CP ./ackrc ~/.ackrc
# For nice colors with the ls command ( https://github.com/seebi/dircolors-solarized )
$CP dircolors.ansi-dark ~/.dircolors
set +e # ignore jinja2 import errors
./conkyrc.py > ~/.conkyrc
set -e

title "Install files in .local/bin"

mkdir -p ~/.local/bin
$CP ./bin/* ~/.local/bin

gist "git-fetch-all" "eef091d73879f8d0d5661efc834e69dc"

title "Installing my ZSH workplace"
[ ! -d ~/.zsh ] && mkdir -p ~/.zsh
$CP ./zshrc ~/.zshrc

# LiquidPrompt
gitget https://github.com/SamK/liquidprompt.git ~/.zsh/liquidprompt fix/do-not-redeclare

# A lot of completion features for ZSH
gitget https://github.com/zsh-users/zsh-completions.git ~/.zsh/zsh-completions

curl https://raw.githubusercontent.com/borgbackup/borg/1.1.5/scripts/shell_completions/zsh/_borg \
> ~/.zsh/zsh-completions/src/_borg

title Vim
$CP ./vimrc ~/.vimrc
mkdir -p ~/.vim/

# TODO: tmpdir
if [ -d solarized ]; then
    echo "Updating solarized theme for Vim..."
    cd solarized
    git pull
    cd ..
else
    echo "Installing solarized theme for Vim..."
    git clone https://github.com/altercation/solarized.git
fi
$CP ./solarized/vim-colors-solarized/colors ~/.vim/

echo VIM-Plug...
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo Installing Vim plugins...
vim +PlugInstall +qall

echo "Setup completed."

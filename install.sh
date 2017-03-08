#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
        for refname in $(git for-each-ref --format='%(refname)' refs/remotes/origin refs/tags/); do
            if [ "refs/remotes/origin/$git_ref" == "$refname" ]; then
                found="yes"
                echo "Checking out to branch $git_ref"
                git reset --hard "origin/$git_ref"
                break
            fi
        done
        if [ "$found" == "no" ]; then
            echo "Checking out ref \"$git_ref\"."
            git reset --hard "$git_ref"
        fi
    fi

    cd $DIR
}

echo "Installing files..."

/bin/cp ./shell_aliases ~/.shell_aliases
/bin/cp ./bashrc ~/.bashrc
/bin/cp ./gitconfig ~/.gitconfig
/bin/cp ./gitignore-global ~/.gitignore-global
/bin/cp ./tmux.conf ~/.tmux.conf
/bin/cp ./ackrc ~/.ackrc
set +e # ignore jinja2 import errors
./conkyrc.py > ~/.conkyrc
set -e

/bin/cp ./vimrc ~/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# https://github.com/seebi/dircolors-solarized
/bin/cp dircolors.ansi-dark ~/.dircolors

# zsh
[ ! -d ~/.zsh ] && mkdir -p ~/.zsh
/bin/cp ./zshrc ~/.zshrc

gitget https://github.com/nojhan/liquidprompt.git ~/.zsh/liquidprompt develop

curl --silent --show-error https://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-completion.zsh > ~/.zsh/_git
curl --silent --show-error https://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-completion.bash > ~/.zsh/git-completion.bash

# Vim
if [ -d solarized ]; then
    echo "Updating solarized..."
    cd solarized
    git pull
    cd ..
else
    echo "Installing solarized..."
    git clone https://github.com/altercation/solarized.git
fi

mkdir -p ~/.vim/
/bin/cp -a ./solarized/vim-colors-solarized/colors ~/.vim/

echo "Setup completed."


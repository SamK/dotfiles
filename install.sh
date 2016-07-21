#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

gitget() {
    url=$1
    folder=$2
    git_ref=$3

    if [ -d $folder ]; then
        if [ -n $git_ref ]; then
            echo "Updating to commit $git_ref..."
            cd $folder
            git fetch
            git checkout $git_ref
        else
            cd $folder
            git pull
        fi
    else
        if [ -n "$git_ref" ]; then
            BOPT=" -b $git_ref "
        else
            BOPT=
        fi
        git clone $BOPT $url $folder
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
./conkyrc.py > ~/.conkyrc

/bin/cp ./vimrc ~/.vimrc
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# https://github.com/seebi/dircolors-solarized
/bin/cp dircolors.ansi-dark ~/.dircolors

# zsh
[ ! -d ~/.zsh ] && mkdir -p ~/.zsh
/bin/cp ./zshrc ~/.zshrc

gitget https://github.com/nojhan/liquidprompt.git ~/.zsh/liquidprompt b53e53b

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


#!/bin/sh

/bin/cp ./shell_aliases ~/.shell_aliases
/bin/cp ./bashrc ~/.bashrc
/bin/cp ./vimrc ~/.vimrc
/bin/cp ./gitconfig ~/.gitconfig
/bin/cp ./gitignore-global ~/.gitignore-global
./conkyrc.py > ~/.conkyrc

# zsh
/bin/cp ./zshrc ~/.zshrc
/bin/cp git-completion.zsh ~/.zsh/_git
/bin/cp git-completion.bash ~/.zsh/

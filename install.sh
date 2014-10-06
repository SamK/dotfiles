#!/bin/sh

/bin/cp ./shell_aliases ~/.shell_aliases
/bin/cp ./bashrc ~/.bashrc
/bin/cp ./vimrc ~/.vimrc
/bin/cp ./gitconfig ~/.gitconfig
/bin/cp ./gitignore-global ~/.gitignore-global
./conkyrc.py > ~/.conkyrc

# zsh
/bin/cp ./zshrc ~/.zshrc

# https://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-completion.zsh
/bin/cp git-completion.zsh ~/.zsh/_git
# https://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-completion.bash
/bin/cp git-completion.bash ~/.zsh/

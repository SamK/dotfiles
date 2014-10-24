#!/bin/sh

/bin/cp ./shell_aliases ~/.shell_aliases
/bin/cp ./bashrc ~/.bashrc
/bin/cp ./vimrc ~/.vimrc
/bin/cp ./gitconfig ~/.gitconfig
/bin/cp ./gitignore-global ~/.gitignore-global
./conkyrc.py > ~/.conkyrc

# zsh
[ ! -d ~/.zsh ] && mkdir -p ~/.zsh

/bin/cp ./zshrc ~/.zshrc

liqp=~/.zsh/liquidprompt/ 

if [ -d $liqp ]; then
    cd $liqp 
    git pull
    cd -
else
    cd ~/.zsh
    git clone https://github.com/nojhan/liquidprompt.git
    cd -
fi

# https://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-completion.zsh
/bin/cp git-completion.zsh ~/.zsh/_git
# https://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-completion.bash
/bin/cp git-completion.bash ~/.zsh/

# https://github.com/seebi/dircolors-solarized
/bin/cp dircolors.ansi-dark ~/.dircolors

#!/bin/sh

echo "Installing files..."

/bin/cp ./shell_aliases ~/.shell_aliases
/bin/cp ./bashrc ~/.bashrc
/bin/cp ./vimrc ~/.vimrc
/bin/cp ./gitconfig ~/.gitconfig
/bin/cp ./gitignore-global ~/.gitignore-global
/bin/cp ./tmux.conf ~/.tmux.conf
/bin/cp ./ackrc ~/.ackrc
./conkyrc.py > ~/.conkyrc

# https://github.com/seebi/dircolors-solarized
/bin/cp dircolors.ansi-dark ~/.dircolors

# zsh
[ ! -d ~/.zsh ] && mkdir -p ~/.zsh
/bin/cp ./zshrc ~/.zshrc

# liquid prompt
liqp_branch='develop'
liqp=~/.zsh/liquidprompt/ 
if [ -d $liqp ]; then
    cd $liqp 
    git pull
    cd -
else
    echo "Installing liquidprompt in ~/.zsh ..."
    cd ~/.zsh
    git clone -b $liqp_branch https://github.com/nojhan/liquidprompt.git
    cd -
fi

# https://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-completion.zsh
/bin/cp git-completion.zsh ~/.zsh/_git
# https://git.kernel.org/cgit/git/git.git/plain/contrib/completion/git-completion.bash
/bin/cp git-completion.bash ~/.zsh/

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


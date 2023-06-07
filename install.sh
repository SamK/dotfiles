#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXIT_CODE=0
OFFLINE=no

# Parse arguments
# https://stackoverflow.com/a/14203146
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    --offline)
      OFFLINE=yes
      shift
      ;;
  esac
done

. ./lib/installrc.sh
installrc_setup || exit $?

title "Installing dot files..."

mkdir -p ~/.config/git ~/.ssh
chmod --changes 0700 ~/.ssh

create_dotlink .shell_aliases
create_dotlink .shell_envvars
create_dotlink .bashrc
create_dotlink .gitconfig
create_dotlink .config/git/ignore
create_dotlink .config/git/attributes
create_dotlink .ssh/config
create_dotlink .tmux.conf
create_dotlink .ackrc
create_dotlink .curlrc
## dircolors for nice colors with the ls command ( https://github.com/seebi/dircolors-solarized )
gitget https://github.com/seebi/dircolors-solarized ./tmp/dircolors-solarized
create_symlink $PWD/tmp/dircolors-solarized/dircolors.ansi-dark ~/.dircolors

title "Install files in .local/bin"

mkdir -p ~/.local/bin
create_dotlink .local/bin/git-branch-deletable
create_dotlink .local/bin/git-branches-authors
create_dotlink .local/bin/git-find-md5
create_dotlink .local/bin/git-ls-wip
create_dotlink .local/bin/tmpclean

title "Install files in .local/share"

mkdir -p ~/.local/share/konsole
create_dotlink .local/share/konsole/sam.profile
create_dotlink .local/share/konsole/Solarized-sam.colorscheme

set -e

gist "eef091d73879f8d0d5661efc834e69dc"
create_dotlink .local/bin/git-fetch-all

gist 7e4d432478074af91590f1b09c935fb7
create_dotlink .local/bin/gitlab-samkli

# git-wtf
gitget https://github.com/DanielVartanov/willgit.git ./tmp/willgit
create_symlink $PWD/tmp/willgit/bin/git-wtf ~/.local/bin/git-wtf

# git-when-merged
gitget https://github.com/mhagger/git-when-merged.git ./tmp/git-when-merged
create_symlink $PWD/tmp/git-when-merged/bin/git-when-merged ~/.local/bin/git-when-merged

# Docker Compose
download https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 ~/.local/bin/docker-compose-1.29.2 +x
download https://github.com/docker/compose/releases/download/v2.11.1/docker-compose-linux-x86_64 ~/.local/bin/docker-compose-2.11.1 +x
create_symlink docker-compose-1.29.2 ~/.local/bin/docker-compose

# yq
download https://github.com/mikefarah/yq/releases/download/v4.27.5/yq_linux_amd64 ~/.local/bin/yq +x

# borg
download https://github.com/borgbackup/borg/releases/download/1.2.2/borg-linux64 ~/.local/bin/borg +x

title "Installing my ZSH workplace"
[ ! -d ~/.zsh ] && mkdir -p ~/.zsh
create_dotlink .zshrc

# LiquidPrompt
#gitget https://github.com/SamK/liquidprompt.git .zsh/liquidprompt fix/do-not-redeclare
gitget https://github.com/nojhan/liquidprompt.git .zsh/liquidprompt
create_dotlink .zsh/liquidprompt

# A lot of completion features for ZSH
gitget https://github.com/zsh-users/zsh-completions.git .zsh/zsh-completions
create_dotlink .zsh/zsh-completions

if [ "$OFFLINE" == "yes" ]; then
    echo "Skipping installation of borg completion!"
else
echo "Downloading borg completion..."
    download https://raw.githubusercontent.com/borgbackup/borg/1.1.5/scripts/shell_completions/zsh/_borg .zsh/zsh-completions/src/_borg
fi


title Crontab

if [ $(dnsdomainname) != "cid.dom" ]; then
    install_crontab ./crontab
fi

title Vim

create_dotlink .vimrc
mkdir -p ~/.vim/

# TODO: tmpdir
echo "Installing solarized theme for Vim..."
gitget https://github.com/altercation/solarized.git tmp/solarized
create_dotlink .vim/colors

if [ "$OFFLINE" == "yes" ]; then
    echo "Skipping installation of Vim plugins!"
else
    echo VIM-Plug...
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo Installing Vim plugins...
    vim +PlugInstall +qall
fi

echo "Setup completed."

exit $EXIT_CODE

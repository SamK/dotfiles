# NE PAS EDITER!
# Source: https://github.com/samyboy/dotfiles/

# influences
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/skrieg/.zshrc'

setopt interactivecomments

autoload -U select-word-style
select-word-style bash

autoload -Uz compinit
compinit
# End of lines added by compinstall

#########
# aliases
#########

if [ -f ~/.shell_aliases ]; then
  source ~/.shell_aliases
fi

if [ -f ~/.shell_aliases.local ]; then
  source ~/.shell_aliases.local
fi


########
# Prompt
########

# zsh-git-prompt
local git_prompt_name="zsh-git-prompt"
local git_prompt_dir="git-prompt"
local zshdir_path=~/.zsh
local git_prompt_path=$zshdir_path/$git_prompt_dir
# do not want!
local git_prompt_no=~/.git-prompt-no
# download url
local git_prompt_url="https://github.com/olivierverdier/zsh-git-prompt.git"

install_zsh_git_prompt () {
  echo "Installing \"$git_prompt_name\" from \"$git_prompt_url\" into \"$git_prompt_path\""
  mkdir -p $zshdir_path
  git clone $git_prompt_url $git_prompt_path
}


if [[ -d $git_prompt_path ]]; then
  local zshrc_sh=~/.zsh/git-prompt/zshrc.sh
  if [ -f $zshrc_sh ]; then
    source "$zshrc_sh"
    local zsh_git_prompt='1'
  else
    echo "File \"$zshrc_sh\" not found! Everything will fail!" 1>&2
    local zsh_git_prompt='0'
  fi
fi

function loadavg1 {
    awk '{print  $1}' /proc/loadavg
}

# define colors

# valid colors: Red, Blue, Green, Cyan, Yellow, Magenta, Black 
# colors: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#SEC59
autoload -U colors && colors

if [[ "$terminfo[colors]" -ge 8 ]]; then
  if [[ "$EUID" = "0" ]] || [[ "$USER" = 'root' ]]
  then
    username_color=%F{red}
  else
    username_color=%F{green}
  fi
fi

# do some stuff...
setopt PROMPT_SUBST
setopt promptsubst
setopt promptpercent

# define left prompt

PROMPT=""

# return status (in colors plz!)
# http://stackoverflow.com/a/4466959/238913
# http://zshwiki.org/home/scripting/paramflags

# display exit code if not 0
local e_code="%(?..%F{red}%? %f)"
PROMPT=$e_code

# PuTTy does not support utf :(
#local smiley="%(?,%{$fg[green]%}:)%{$reset_color%},%{$fg[red]%}:(%{$reset_color%})"
#PROMPT=$smiley

# [time]
# les deux lignes font bouger l'heure!(incompatible avec "%?")
#_prompt_and_resched() { sched +1 _prompt_and_resched; zle && zle reset-prompt }
#_prompt_and_resched
GREY=$'\e[30;1m'
NORMAL=$'\e[0m'
PROMPT=${PROMPT}%{${GREY}%}[%*]%{${NORMAL}%}

# user@hostname
PROMPT=${PROMPT}"$username_color%n%f@%M%f:"

# current directory
#PROMPT=${PROMPT}"%F{blue}%~%f "
PROMPT=${PROMPT}"%F{blue}%1~%f"

# git
PROMPT="${PROMPT}"

# shell opening: %=user , #=root
PROMPT=${PROMPT}"${username_color}%#%f "

# define right prompt
if [[ "$zsh_git_prompt" == '1'  ]] ; then
    RPROMPT='$(git_super_status)'" $(loadavg1)"
fi


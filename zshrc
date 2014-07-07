
local enable_git_prompt='1'

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/skrieg/.zshrc'

setopt interactivecomments

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

if [[ "$enable_git_prompt" == "1" ]]  ; then
  # file from https://github.com/olivierverdier/zsh-git-prompt
  local zshrc_sh=~/.zsh/git-prompt/zshrc.sh
  if [ -f $zshrc_sh ]; then
     source "$zshrc_sh"
  else
    echo "File \"$zshrc_sh\" not found" 1>&2
    local enable_git_prompt='0'
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
PROMPT=${PROMPT}"%F{blue}%~%f "

# git
PROMPT="${PROMPT}"

# shell opening: %=user , #=root
PROMPT=${PROMPT}"${username_color}%#%f "

# define right prompt
if [[ "$enable_git_prompt" == "1" ]] ; then
    RPROMPT='$(git_super_status)'" $(loadavg1)"
fi


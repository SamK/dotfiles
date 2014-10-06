# NE PAS EDITER!
# Source: https://github.com/samyboy/dotfiles/

# influences
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

PATH=~/.local/bin:"$PATH"

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


function loadavg1 {
    awk '{print  $1}' /proc/loadavg
}

# define colors

# valid colors: Red, Blue, Green, Cyan, Yellow, Magenta, Black 
# colors: http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#SEC59
autoload -U colors && colors

# do some stuff...
setopt PROMPT_SUBST
setopt promptsubst
setopt promptpercent

# liquidprompt
[ -d ~/.zsh/liquidprompt ] && source ~/.zsh/liquidprompt/liquidprompt

# show right prompt with date
RPROMPT='[%D{%H:%M:%S}]'
TMOUT=1
TRAPALRM() {
    zle reset-prompt
}

# auto completion
fpath=(~/.zsh $fpath)


# NE PAS EDITER!
# Source: https://github.com/samyboy/dotfiles/

# influences
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

export VISUAL=vi
export EDITOR=vi

# options

# do word splitting for unquoted parameter expansions
# source: http://stackoverflow.com/a/6715447/238913
ENABLE_SH_WORD_SPLIT="no"

[[ "$ENABLE_SH_WORD_SPLIT" == "yes" ]] && setopt SH_WORD_SPLIT

# The same for Bash "set -o vi"
bindkey -v

bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey "^?" backward-delete-char
bindkey "^U" backward-kill-line
bindkey -M viins '^u'    backward-kill-line
bindkey -M viins '^w'    backward-kill-word # Ctrl+w
bindkey -M viins '\ef'   forward-word      # Alt-f
bindkey -M viins '\eb'   backward-word     # Alt-b
bindkey -M viins '\ed'   kill-word         # Alt-d

bindkey -M vicmd '^[^?' backward-kill-word  # alt-backspace
bindkey -M viins '^[^?' backward-kill-word  # alt-backspace

bindkey "^[[A" up-line-or-search     # up arrow
bindkey "^[[B" down-line-or-search   # down arrow

PATH=~/.local/bin:"$PATH"

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

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

# display current mode in zsh (vi style)
#
# http://superuser.com/questions/151803/how-do-i-customize-zshs-vim-mode
vim_ins_mode="[INS]"
vim_cmd_mode="[CMD]"
vim_mode=$vim_ins_mode

function zle-keymap-select {
    vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
    RPROMPT='${vim_mode}'
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
    vim_mode=$vim_ins_mode
    RPROMPT='${vim_mode}'
}
zle -N zle-line-finish

# return length of a string including only printable chars
strlen () {
    [[ "$ENABLE_SH_WORD_SPLIT" == "yes" ]] && unsetopt SH_WORD_SPLIT
    FOO=$1
    local zero='%([BSUbfksu]|([FB]|){*})'
    LEN=${#${(S%%)FOO//$~zero/}}
    echo $LEN
    [[ "$ENABLE_SH_WORD_SPLIT" == "yes" ]] && setopt SH_WORD_SPLIT
}

# show right prompt with date ONLY when command is executed
preexec () {
    DATE=$( date +"[%H:%M:%S]" )
    local len_right=$( strlen "$DATE" )
    len_right=$(( $len_right+1 ))
    local right_start=$(($COLUMNS - $len_right))

    local len_cmd=$( strlen "$@" )
    local len_prompt=$(strlen "$PROMPT" )
    local len_left=$(($len_cmd+$len_prompt))

    RDATE="\033[${right_start}C ${DATE}"

    if [ $len_left -lt $right_start ]; then
        # command does not overwrite right prompt
        # ok to move up one line
        echo -e "\033[1A${RDATE}"
    else
        echo -e "${RDATE}"
    fi

}

# auto completion
fpath=(~/.zsh $fpath)


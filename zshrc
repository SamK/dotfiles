# NE PAS EDITER!
# Source: https://github.com/samyboy/dotfiles/

# influences
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

export VISUAL=vi
export EDITOR=vi

# disable ESC delay when switch to normal mode (default: 40 = 0.4sec)
export KEYTIMEOUT=10

# options

# do word splitting for unquoted parameter expansions
# source: http://stackoverflow.com/a/6715447/238913
ENABLE_SH_WORD_SPLIT="yes"

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
bindkey    "^[[3~"          delete-char    # Delete
bindkey          '\e[1~' beginning-of-line # Home
bindkey          '\e[4~' end-of-line       # End

bindkey -M vicmd '^[^?' backward-kill-word  # alt-backspace
bindkey -M viins '^[^?' backward-kill-word  # alt-backspace

bindkey "^[[A" up-line-or-search     # up arrow
bindkey "^[[B" down-line-or-search   # down arrow

# Keypad http://superuser.com/a/742193

# Numlock
bindkey -s "^[OP" ""
# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ol" "+"
bindkey -s "^[OS" "-"
bindkey -s "^[OR" "*"
bindkey -s "^[OQ" "/"

PATH=~/.local/bin:"$PATH"

# History
HISTFILE=~/.histfile
SAVEHIST=10000
HISTSIZE=$SAVEHIST

# ZSH options index: http://zsh.sourceforge.net/Doc/Release/Options-Index.html

# Save each command’s beginning timestam
setopt EXTENDED_HISTORY

# immediate write the history
setopt INC_APPEND_HISTORY

# re-read history file each time
setopt NO_SHARE_HISTORY

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/skrieg/.zshrc'

setopt interactivecomments

autoload -U select-word-style
select-word-style bash

autoload -Uz compinit
# End of lines added by compinstall

# menu selection
zstyle ':completion:*' menu yes select

# ssh known_hosts completion: http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
# The directive HashKnownHosts must be No
hosts=($((( [ -r .ssh/known_hosts ] && awk '{print $1}' .ssh/known_hosts | tr , '\n'); ) | sort -u) )
zstyle ':completion:*' hosts $hosts

#########
# aliases
#########

if [ -f ~/.shell_aliases ]; then
  source ~/.shell_aliases
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
setopt promptpercent

# liquidprompt:
# Only load Liquid Prompt in interactive shells
[ -d ~/.zsh/liquidprompt ] && [[ $- = *i* ]] && source ~/.zsh/liquidprompt/liquidprompt

# This is required for the [VI] tag and must be after liquidprompt
setopt promptsubst

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
    FOO="$1"
    local zero='%([BSUbfksu]|([FB]|){*})'
    LEN="${#${(S%%)FOO//$~zero/}}"
    echo $LEN
}

# show right prompt with date ONLY when command is executed
show_exec_date() {
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

preexec () {
    show_exec_date "$@"
}

# auto completion
fpath=(~/.zsh/zsh-completions/src $fpath)

# compinit must be executed after definition of fpath
compinit

### EOF ###

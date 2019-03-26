#!/usr/bin/env zsh

PRAGMATIC_PROMPT_PROMPT_FOREGROUND=cyan
PRAGMATIC_PROMPT_COMMAND_FOREGROUND=white

# Prints working dir with ~ instead of the home dir.
p-clean-wd(){
    echo "${PWD/$HOME/~}"
}

# If we're in a git dir, print the branch name only.
get-git-branch(){
    if [[ -d .git ]]; then
        echo "$(git rev-parse --abbrev-ref HEAD)"
    else
        echo ""
    fi
}

# Populate fg and friends.
autoload -U colors && colors

set-prompts(){
PROMPT="%{$fg[$PRAGMATIC_PROMPT_PROMPT_FOREGROUND]%}
"$(p-clean-wd)"
→ %{$fg[$PRAGMATIC_PROMPT_COMMAND_FOREGROUND]%}"

RPROMPT="%{$fg[$PRAGMATIC_PROMPT_PROMPT_FOREGROUND]%}"$(get-git-branch)"%{$fg[$PRAGMATIC_PROMPT_COMMAND_FOREGROUND]%}"
}

# Add set-prompts to the precmd_functions.
precmd_functions=($precmd_functions set-prompts)

strlen () {
    FOO=$1
    local zero='%([BSUbfksu]|([FB]|){*})'
    LEN=${#${(S%%)FOO//$~zero/}}
    echo $LEN
}

# Show date on right only when command is executed.
print-date-right(){
    DATE=$( date +"%b %d %H:%M:%S %Z" )
    local len_right=$( strlen "$DATE" )

    # This shift makes it print inline with git branch name.
    len_right=$(( $len_right+2 ))

    local right_start=$(($COLUMNS - $len_right))
    RDATE="\033[${right_start}C $fg[$PRAGMATIC_PROMPT_PROMPT_FOREGROUND]${DATE}$fg[$PRAGMATIC_PROMPT_COMMAND_FOREGROUND]"
    echo -e "${RDATE}"
}

# Add print-date-right to the preexec_functions.
preexec_functions=($preexec_functions print-date-right)


#!/usr/bin/env zsh
# strlen function and other inspiration from https://stackoverflow.com/a/26585789/1760428
# timer inspiration from https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/timer/timer.plugin.zsh

PRAGMATIC_PROMPT_PROMPT_FOREGROUND=cyan
PRAGMATIC_PROMPT_COMMAND_FOREGROUND=white

# Load Zsh features in use
autoload -U colors && colors
autoload -Uz add-zsh-hook

# Prints working dir with ~ instead of the home dir.
__pp_get_clean_wd(){
    echo "${PWD/$HOME/~}"
}

# If we're in a git dir, print the branch name only.
__pp_get_git_branch(){
    if [[ -d .git ]]; then
        echo "$(git rev-parse --abbrev-ref HEAD)"
    else
        echo ""
    fi
}

__pp_set_prompts_precmd(){
PROMPT="%{$fg[$PRAGMATIC_PROMPT_PROMPT_FOREGROUND]%}%D{%b %d %H:%M:%S %Z} "$(__pp_get_clean_wd)"
→ %{$fg[$PRAGMATIC_PROMPT_COMMAND_FOREGROUND]%}"

RPROMPT="%{$fg[$PRAGMATIC_PROMPT_PROMPT_FOREGROUND]%}"$(__pp_get_git_branch)"%{$fg[$PRAGMATIC_PROMPT_COMMAND_FOREGROUND]%}"
}

__pp_current_time() {
    perl -MTime::HiRes=time -e'print time'
}

__pp_format_duration() {
    local mins=$(printf '%.0f' $(($1 / 60)))
    local secs=$(printf "%.3f" $(($1 - 60 * mins)))
    echo ""$( date +"%b %d %H:%M:%S %Z" )" — ${mins}m ${secs}s"
}

__pp_save_time_preexec() {
    __pp_cmd_start_time=$(__pp_current_time)
}

__pp_display_timer_precmd() {
    print ""
    if [ -n "${__pp_cmd_start_time}" ]; then
        local cmd_end_time=$(__pp_current_time)
        local tdiff=$((cmd_end_time - __pp_cmd_start_time))
        local tdiffstr=$(__pp_format_duration ${tdiff})
        unset __pp_cmd_start_time
        echo $fg[$PRAGMATIC_PROMPT_PROMPT_FOREGROUND]${tdiffstr}$fg[$PRAGMATIC_PROMPT_COMMAND_FOREGROUND]
    fi
}

# Specify when to run the functions.
add-zsh-hook precmd __pp_set_prompts_precmd
add-zsh-hook precmd __pp_display_timer_precmd
add-zsh-hook preexec __pp_save_time_preexec

# Redraw every second
TMOUT=1
TRAPALRM() {
    zle reset-prompt
}


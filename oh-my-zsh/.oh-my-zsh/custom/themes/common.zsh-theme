# vim: filetype=sh

# Prompt symbol
COMMON_PROMPT_SYMBOL="$"

# Colors
COMMON_COLORS_CURRENT_DIR=cyan
COMMON_COLORS_RETURN_STATUS_TRUE=white
COMMON_COLORS_GIT_STATUS_DEFAULT=green
COMMON_COLORS_GIT_STATUS_STAGED=red
COMMON_COLORS_GIT_STATUS_UNSTAGED=yellow

# Left Prompt
PROMPT='$(common_current_dir)
$(common_return_status)'

PROMPT2='$(common_return_status)'

# Right Prompt
RPROMPT='$(common_git_status)'

# Current directory
common_current_dir() {
  echo -n "%{$fg[$COMMON_COLORS_CURRENT_DIR]%}%~"
}

# Prompt symbol
common_return_status() {
  echo -n "%F{$COMMON_COLORS_RETURN_STATUS_TRUE}$COMMON_PROMPT_SYMBOL%f "
}

# Git status
common_git_status() {
    local message=""
    local message_color="%F{$COMMON_COLORS_GIT_STATUS_DEFAULT}"

    # https://git-scm.com/docs/git-status#_short_format
    local staged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU]")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^[MADRCU? ][MADRCU?]")

    if [[ -n ${staged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_STAGED}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{$COMMON_COLORS_GIT_STATUS_UNSTAGED}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f"
    fi

    echo -n "${message}"
}

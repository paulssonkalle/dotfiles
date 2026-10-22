# Remove underline for zsh highlight
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh

# Source the output of an init command, cached until the binary changes
# Usage: _cached_eval <name> <cmd> [args...]
_cached_eval() {
  local cache=$ZSH_CACHE_DIR/$1.zsh; shift
  local bin=${commands[$1]}
  [[ -z $bin ]] && return
  if [[ ! -s $cache || $bin -nt $cache ]]; then
    mkdir -p ${cache:h}
    "$@" >| $cache
  fi
  source $cache
}

# mise first so tools it manages are on PATH for everything below
_cached_eval mise mise activate zsh

# Set up fzf key bindings and fuzzy completion
_cached_eval fzf fzf --zsh

# Load completions (full rebuild at most once a day)
autoload -Uz compinit
() { (( $# )) && compinit || compinit -C } ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24)

# Init oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/ohmyposh.toml)"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char
bindkey '^[[1~' beginning-of-line
bindkey -M emacs '\C-w' fzf-cd-widget

# Sane jump by word
autoload -U select-word-style
select-word-style bash

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=bg+:-1,bg:-1,spinner:2,hl:2,fg:-1,header:-1,info:1,pointer:-1,marker:2,fg+:-1,prompt:1,hl+:2,selected-bg:-1,border:1,label:2 --gutter ' '

# Aliases
alias ls='ls --color'
alias vi='nvim'
alias vim='nvim'
alias k='kubectl'
alias kns='kubens'
alias ktx='kubectx'
alias printpath="echo $PATH | tr ':' '\n'"

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

_cached_eval zoxide zoxide init --cmd cd zsh

lg() {
  local theme=light
  [[ "$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)" == "'prefer-dark'" ]] && theme=dark
  command lazygit --use-config-file="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/everforest-$theme.yml"
}

if [ -z "$TMUX" ]; then
    tmux attach || exec tmux new-session
fi

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

# Generate completions for installed tools, refreshed when the binary changes
# Usage: _cached_completion <cmd> [args...]
_cached_completion() {
  local out=$ZSH_CACHE_DIR/completions/_$1
  local bin=${commands[$1]}
  [[ -z $bin ]] && return
  if [[ ! -s $out || $bin -nt $out ]]; then
    mkdir -p ${out:h}
    if "$@" >| $out 2>/dev/null; then
      rm -f ${ZDOTDIR:-$HOME}/.zcompdump
    else
      rm -f $out
    fi
  fi
}

fpath=($ZSH_CACHE_DIR/completions $fpath)
_cached_completion uv generate-shell-completion zsh
_cached_completion mise completion zsh
_cached_completion sesh completion zsh
_cached_completion worktree completion zsh
_cached_completion kubectl completion zsh
_cached_completion docker completion zsh

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
HISTSIZE=100000
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

# Kubeconfig files directly in a directory, detected by content instead of name
_kubeconfigs() {
  local f
  for f in $1/*(.N); do
    [[ $f == *.old || $f == *.bak || $f == *~ ]] && continue
    grep -q '^kind: *Config' $f 2>/dev/null && print -r -- $f
  done
}

# Pick a kubeconfig for this shell only (kc - to unset)
kc() {
  if [[ $1 == - ]]; then
    unset KUBECONFIG
    return
  fi
  local f
  f=$(_kubeconfigs ~/.kube | fzf --prompt 'kubeconfig> ' --height 40% --select-1 --query "$*") || return
  export KUBECONFIG=$f
}

# Production kubeconfigs live in ~/.kube/prod and need typed confirmation
kprod() {
  local f answer
  f=$(_kubeconfigs ~/.kube/prod | fzf --prompt 'PRODUCTION> ' --height 40% --query "$*") || return
  local name=${f:t}
  print -P "%B%F{red}Switching to PRODUCTION: $name%f%b"
  read "answer?Type '$name' to confirm: "
  if [[ $answer != $name ]]; then
    echo "Aborted."
    return 1
  fi
  export KUBECONFIG=$f
}

# Keep kprod out of history so Ctrl+R can't find it
autoload -Uz add-zsh-hook
_skip_kprod_history() { [[ ! $1 =~ '^[[:space:]]*kprod' ]] }
add-zsh-hook zshaddhistory _skip_kprod_history

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

_cached_eval zoxide zoxide init --cmd cd zsh

# Update plugins in the background once a week
() {
  local stamp=$ZSH_CACHE_DIR/plugins-updated
  local script=$HOME/.dotfiles/scripts/update-plugins.sh
  local fresh=($stamp(N.md-7))
  (( $#fresh )) || [[ ! -x $script ]] && return
  mkdir -p $ZSH_CACHE_DIR && touch $stamp
  $script >| $ZSH_CACHE_DIR/plugins-update.log 2>&1 &!
}

lg() {
  local theme=light
  [[ "$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)" == "'prefer-dark'" ]] && theme=dark
  command lazygit --use-config-file="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/everforest-$theme.yml"
}

if [ -z "$TMUX" ]; then
    tmux attach || exec tmux new-session
fi

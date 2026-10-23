# Remove underline for zsh highlight
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# mise first so tools it manages (fzf, etc.) are on PATH for everything below
eval "$(mise activate zsh)"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# source lux
source $HOME/dev/zsh-lux/zsh-lux.plugin.zsh

# Load completions
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Init oh-my-posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/ohmyposh.toml)"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -G $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=bg+:-1,bg:-1,spinner:2,hl:2,fg:-1,header:-1,info:1,pointer:-1,marker:2,fg+:-1,prompt:1,hl+:2,selected-bg:-1,border:1,label:2 --gutter ' '

# Aliases
alias ls='ls -G'
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
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(zoxide init --cmd cd zsh)"

lg() {
  if macos_is_dark; then
      command lazygit --use-config-file="/Users/kalle/.config/lazygit/config.yml,/Users/kalle/.config/lazygit/everforest-dark.yml"
  else
      command lazygit --use-config-file="/Users/kalle/.config/lazygit/config.yml,/Users/kalle/.config/lazygit/everforest-light.yml"
  fi
}

if [ -z "$TMUX" ]; then
    tmux attach || exec tmux new-session
fi

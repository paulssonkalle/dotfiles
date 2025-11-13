# Remove underline for zsh highlight
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Load completions
autoload -Uz compinit

for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

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
bindkey -M vicmd '\C-w' fzf-cd-widget
bindkey -M viins '\C-w' fzf-cd-widget

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
zstyle ':fzf-tab:*' fzf-flags --color=bg+:-1,bg:-1,spinner:2,hl:2,fg:-1,header:-1,info:1,pointer:-1,marker:2,fg+:-1,prompt:1,hl+:10,selected-bg:-1,border:1,label:2 --gutter ' '

# Aliases
alias ls='ls --color'
alias vi='nvim'
alias vim='nvim'
alias k='kubectl'
alias kns='kubens'
alias ktx='kubectx'

source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zoxide
eval "$(zoxide init --cmd cd zsh)"

eval "$(mise activate zsh)"

# Remove duplicates from PATH
typeset -U PATH

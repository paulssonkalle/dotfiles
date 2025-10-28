# Remove underline for zsh highlight
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# Add snippets
zinit snippet OMZP::git
zinit snippet OMZP::sdk
zinit snippet OMZP::tmux
zinit ice lucid wait
zinit snippet OMZP::fzf

# Load completions
autoload -U compinit && compinit

# Replay all cached completions
zinit cdreplay -q
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

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# Setup volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Add krew path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Setup sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init -)"

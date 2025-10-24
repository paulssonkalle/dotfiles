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

# Add snippets
zinit snippet OMZP::git
zinit snippet OMZP::sdk
zinit snippet OMZP::tmux

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
# Catppuccin macchiatto
#zstyle ':fzf-tab:*' fzf-flags --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796,selected-bg:#494d64,border:#363a4f,label:#cad3f5
# Catppuccin latte
zstyle ':fzf-tab:*' fzf-flags --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39,fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78,marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39,selected-bg:#BCC0CC,border:#CCD0DA,label:#4C4F69
# Aliases
alias ls='ls --color'
alias vi='nvim'
alias vim='nvim'
alias k='kubectl'
alias kns='kubens'
alias ktx='kubectx'

# Shell integrations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)
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

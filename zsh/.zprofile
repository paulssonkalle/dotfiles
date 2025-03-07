fpath=($HOME/.zsh/completions $fpath)

export EDITOR="vim"
export VISUAL="vim"

export KUBECONFIG="$HOME/.kube/backup_config:$HOME/.kube/staging_config:$HOME/.kube/production_config"

export CATPPUCCIN_FZF_MACCHIATO="--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796,selected-bg:#494d64,border:#363a4f,label:#cad3f5"
export CATPPUCCIN_FZF_MOCHA="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8,selected-bg:#45475a,border:#313244,label:#cdd6f4"

export FZF_DEFAULT_OPTS=${CATPPUCCIN_FZF_MACCHIATO}
export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git --ignore-file $HOME/.fd_ignore . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --hidden --exclude .git --ignore-file $HOME/.fd_ignore -t d . $HOME"

# Added by Toolbox App
export PATH="$PATH:/Users/kalle/Library/Application Support/JetBrains/Toolbox/scripts"

eval "$(/opt/homebrew/bin/brew shellenv)"

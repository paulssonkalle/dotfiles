fpath=($HOME/.zsh/completions $fpath)

eval "$(/opt/homebrew/bin/brew shellenv)"

# Remove duplicates from PATH
typeset -U PATH

export EDITOR="nvim"
export VISUAL="nvim"
export KUBECONFIG="$HOME/.kube/backup_config:$HOME/.kube/staging_config:$HOME/.kube/production_config"
export FZF_DEFAULT_OPTS=" \
--layout reverse \
--border \
--color=fg:-1 \
--color=fg+:-1 \
--color=bg:-1 \
--color=bg+:-1 \
--color=pointer:-1 \
--color=header:-1 \
--color=border:-1 \
--color=hl:2 \
--color=hl+:2 \
--color=info:1 \
--color=prompt:1 \
--color=marker:2 \
--color=spinner:2 \
--color=scrollbar:dim \
--color=separator:1 \
--gutter ' ' "
export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git --ignore-file $HOME/.fd_ignore . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --hidden --exclude .git --ignore-file $HOME/.fd_ignore -t d . $HOME"

export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
export PATH="$HOME/go/bin:$PATH"

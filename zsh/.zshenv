fpath=($HOME/.zsh/completions $fpath)
path=(/opt/nvim-linux-x86_64/bin $path)

export EDITOR="vim"
export VISUAL="vim"
CATPPUCCIN_FZF_MOCHA=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"

export FZF_DEFAULT_OPTS=${CATPPUCCIN_FZF_MOCHA}
export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git --ignore-file $HOME/.fd_ignore . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --hidden --exclude .git --ignore-file $HOME/.fd_ignore -t d . $HOME"
export PATH=$PATH:/home/kalle/.local/bin


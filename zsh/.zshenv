# editor
export EDITOR="nvim"
export VISUAL="nvim"
# fzf
export FZF_DEFAULT_COMMAND="fd --hidden --exclude .git --ignore-file $HOME/.fd_ignore . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --hidden --exclude .git --ignore-file $HOME/.fd_ignore -t d . $HOME"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#24273a,bg:#24273a,spinner:#a6da95,hl:#eed49f \
--color=fg:#cad3f5,header:#ed8796,info:#ed8796,pointer:#a6da95 \
--color=marker:#a6da95,fg+:#cad3f5,prompt:#a6da95,hl+:#eed49f"

path=($HOME/.local/bin $path)
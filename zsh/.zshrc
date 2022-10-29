export ZSH="$HOME/.oh-my-zsh"

DISABLE_UNTRACKED_FILES_DIRTY="true"
ZSH_THEME="kallerussell"

plugins=(
  fzf
  zsh-autosuggestions
  fast-syntax-highlighting
  docker-compose
)

source $ZSH/oh-my-zsh.sh

#setxkbmap -option ctrl:nocaps
#xcape -e 'Control_L=Escape'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

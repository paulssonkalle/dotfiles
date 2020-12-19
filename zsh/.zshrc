export ZSH="$HOME/.oh-my-zsh"

DISABLE_UNTRACKED_FILES_DIRTY="true"
#ZSH_CUSTOM=$HOME/dotfiles/oh-my-zsh/custom
ZSH_THEME="common"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-autosuggestions
  fast-syntax-highlighting
  docker-compose
)

source $ZSH/oh-my-zsh.sh

setxkbmap -option ctrl:nocaps
xcape -e 'Control_L=Escape'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/kallel/.sdkman"
[[ -s "/home/kallel/.sdkman/bin/sdkman-init.sh" ]] && source "/home/kallel/.sdkman/bin/sdkman-init.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

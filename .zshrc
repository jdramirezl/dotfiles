# EXECUTE IN THE OH MY ZSH FOLDER TO MAKE IT FASTEEEEEEEEEEEEEER
# git config --add oh-my-zsh.hide-dirty 1
 
# -------------------------------------------------------------------
# Config
# -------------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Theme
ZSH_THEME="gnzh"

# Update automatically without asking
zstyle ':omz:update' mode auto

# Execution stamps
HIST_STAMPS="dd/mm/yyyy"

# Waiting dots
COMPLETION_WAITING_DOTS="true"

# Setting NVIM
export PATH=$PATH:~/.local/bin

# Preferred editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Plugins
plugins=(
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
	command-not-found
	exa-zsh
)

# OMZ config source
source $ZSH/oh-my-zsh.sh

# -------------------------------------------------------------------
# Include
# -------------------------------------------------------------------

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Include Alias
if [ -f $HOME/dotfiles/zshalias ]; then
    source $HOME/dotfiles/zshalias
    echo "Found alias"
fi

# Include functions
if [ -f $HOME/dotfiles/zshfunc ]; then
    source $HOME/dotfiles/zshfunc
    echo "Found functions"
fi



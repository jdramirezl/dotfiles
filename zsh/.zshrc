# -------------------------------------------------------------------
# Config
# -------------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export LANG="en_US.UTF-8" # (updated)


# Theme
ZSH_THEME="gnzh"

# Update automatically without asking
zstyle ':omz:update' mode auto

# Execution stamps
HIST_STAMPS="dd/mm/yyyy"

# Waiting dots
COMPLETION_WAITING_DOTS="true"

# Setting NVIM
export PATH=~/.local/bin:$PATH

# Preferred editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PATH="/usr/local/mysql-8.1.0-macos13-x86_64/bin:$PATH"
export PATH="/Users/julianramire/bin:$PATH"




# Plugins
plugins=(
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
	command-not-found
	zsh-eza
)


# OMZ config source
source $ZSH/oh-my-zsh.sh

# Start colima if not running
if ! pgrep -f colima > /dev/null; then
    colima stop && colima start --mount-type 9p
fi

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

export PATH=/Users/julianramire/.local/bin:$PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export ES_JAVA_HOME=
export JAVA_HOME=

eval "$(/usr/local/bin/brew shellenv)"
export PATH=/Users/julianramire/.sdkman/candidates/grails/current/bin:/usr/local/bin:/usr/local/sbin:/Users/julianramire/.nvm/versions/node/v20.14.0/bin:/Users/julianramire/Library/Python/3.11/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin:/usr/local/go/bin:/opt/homebrew/bin
export ES_JAVA_HOME=
export JAVA_HOME=

## The following line is added by pre-commit 
export PATH="/Users/julianramire/Library/Python/3.9/bin:$PATH" 

export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin" 

# Created by `pipx` on 2024-06-15 06:32:33
export PATH="$PATH:/Users/julianramire/.local/bin"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH=/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/sbin:$PATH"

# # Added by naboo:
# export PATH="$HOME/.naboo/naboo_venv/bin:$PATH" # Added by naboo

export PATH="$HOME/.local/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

## The following line is added by pre-commit 
export PATH="/Users/julianramire/Library/Python/3.9/bin:$PATH" 
export RANGER_FURY_LOCATION=/Users/julianramire/.fury #Added by Fury CLI
export RANGER_FURY_VENV_LOCATION=/Users/julianramire/.fury/fury_venv #Added by Fury CLI

# Added by Fury CLI installation process
declare FURY_BIN_LOCATION="/Users/julianramire/.fury/fury_venv/bin" # Added by Fury CLI installation process
export PATH="$PATH:$FURY_BIN_LOCATION" # Added by Fury CLI installation process
# Added by Fury CLI installation process

# -------------------------------------------------------------------
# Config
# -------------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


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

# Plugins
plugins=(
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
	command-not-found
	exa-zsh
)

ZSH_DISABLE_COMPFIX=true

# OMZ config source
source $ZSH/oh-my-zsh.sh

# -------------------------------------------------------------------
# Include
# -------------------------------------------------------------------

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias poetry='/Users/julianramire/.local/bin/poetry'
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

# Include fda
if [ -f $HOME/dotfiles/zshfda ]; then
    source $HOME/dotfiles/zshfda
    echo "Found FDA function"
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
export PATH=/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin
#Added by furycli:
export PATH=/Users/julianramire/Library/Python/3.11/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin
export PATH=/Users/julianramire/Library/Python/3.11/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin:/usr/local/go/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export ES_JAVA_HOME=
export JAVA_HOME=

eval "$(/usr/local/bin/brew shellenv)"
export PATH=/Users/julianramire/.sdkman/candidates/grails/current/bin:/usr/local/bin:/usr/local/sbin:/Users/julianramire/.nvm/versions/node/v14.21.2/bin:/Users/julianramire/Library/Python/3.11/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin:/usr/local/go/bin:/opt/homebrew/bin
#Added by furycli:
export PATH=/Users/julianramire/Library/Python/3.11/bin:/Users/julianramire/.sdkman/candidates/grails/current/bin:/usr/local/bin:/usr/local/sbin:/Users/julianramire/.nvm/versions/node/v14.21.2/bin:/Users/julianramire/Library/Python/3.11/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin:/usr/local/go/bin:/opt/homebrew/bin
export PATH=/Users/julianramire/Library/Python/3.11/bin:/Users/julianramire/.sdkman/candidates/grails/current/bin:/usr/local/bin:/usr/local/sbin:/Users/julianramire/.nvm/versions/node/v14.21.2/bin:/Users/julianramire/Library/Python/3.11/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/opt/homebrew/bin:/usr/local/go/bin:/opt/homebrew/bin:/usr/local/go/bin
export ES_JAVA_HOME=
export JAVA_HOME=


## Naboo test
export PATH="$HOME/.naboo/naboo_venv/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/julianramire/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/julianramire/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/julianramire/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/julianramire/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export RANGER_FURY_LOCATION=/Users/julianramire/.fury #Added by Fury CLI
export RANGER_FURY_VENV_LOCATION=/Users/julianramire/.fury/fury_venv #Added by Fury CLI

# Added by Fury CLI installation process
declare FURY_BIN_LOCATION="/Users/julianramire/.fury/fury_venv/bin" # Added by Fury CLI installation process
export PATH="$PATH:$FURY_BIN_LOCATION" # Added by Fury CLI installation process
# Added by Fury CLI installation process

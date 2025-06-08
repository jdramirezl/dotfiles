# Source all ZSH configurations
for config_file (~/.zsh/*.zsh); do
  source $config_file
done

# Created by `pipx` on 2025-05-30 19:20:57
export PATH="$PATH:/Users/julianramire/.local/bin"
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

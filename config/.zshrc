export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-FRX"

ZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}/.zsh"

for module in \
  00-homebrew.zsh \
  10-path.zsh \
  20-history.zsh \
  30-completion.zsh \
  40-tools.zsh \
  50-plugins.zsh \
  60-prompt.zsh \
  70-aliases.zsh \
  90-syntax-highlighting.zsh; do
  [[ -r "$ZSH_CONFIG_DIR/$module" ]] && source "$ZSH_CONFIG_DIR/$module"
done
unset module

local_config="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/local.zsh"
[[ -r "$local_config" ]] && source "$local_config"
unset local_config

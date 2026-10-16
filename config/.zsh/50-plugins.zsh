if (( $+commands[brew] )); then
  brew_prefix="$(brew --prefix 2>/dev/null)"
  if [[ -r "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  elif [[ -r "$HOME/.local/share/zinit/plugins/zsh-users---zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.local/share/zinit/plugins/zsh-users---zsh-autosuggestions/zsh-autosuggestions.zsh"
  fi
  unset brew_prefix
elif [[ -r "$HOME/.local/share/zinit/plugins/zsh-users---zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.local/share/zinit/plugins/zsh-users---zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

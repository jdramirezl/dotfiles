if (( $+commands[brew] )); then
  brew_prefix="$(brew --prefix 2>/dev/null)"
  if [[ -r "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  elif [[ -r "$HOME/.local/share/zinit/plugins/zsh-users---zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.local/share/zinit/plugins/zsh-users---zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  fi
  unset brew_prefix
elif [[ -r "$HOME/.local/share/zinit/plugins/zsh-users---zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.local/share/zinit/plugins/zsh-users---zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

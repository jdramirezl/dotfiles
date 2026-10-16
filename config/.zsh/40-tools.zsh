if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

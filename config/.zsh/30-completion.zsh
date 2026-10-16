typeset -U fpath

if (( $+commands[brew] )); then
  brew_prefix="$(brew --prefix 2>/dev/null)"
  [[ -d "$brew_prefix/share/zsh/site-functions" ]] && fpath=("$brew_prefix/share/zsh/site-functions" $fpath)
  [[ -d "$brew_prefix/share/zsh-completions" ]] && fpath=("$brew_prefix/share/zsh-completions" $fpath)
  unset brew_prefix
fi

legacy_completions="$HOME/.local/share/zinit/plugins/zsh-users---zsh-completions/src"
[[ -d "$legacy_completions" ]] && fpath=("$legacy_completions" $fpath)
unset legacy_completions

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

completion_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$completion_cache"
autoload -Uz compinit
compinit -d "$completion_cache/zcompdump"
unset completion_cache

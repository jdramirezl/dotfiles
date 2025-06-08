# Completion system initialization
autoload -Uz compinit && compinit

# Enable bash completion in zsh
autoload -U +X bashcompinit && bashcompinit

# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi 
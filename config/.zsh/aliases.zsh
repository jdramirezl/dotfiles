# Eza aliases - Modern ls replacement
# Basic aliases
alias ls='eza'                                                          # ls
alias ll='eza -la'                                                      # list, size, type, git
alias lt='eza --tree'                                                   # tree view
alias l.='eza -a | grep -E "^\."'                                      # show only dotfiles

# Special views
alias lgi='eza -lh --git-ignore'                                      # list, long, respect gitignore

# Git aliases
alias g='git'
alias ga='git add'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'

# Directory management
mkcd() {
    mkdir -p "$1" && cd "$1"
}

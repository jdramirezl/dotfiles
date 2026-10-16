if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first'
  alias ll='eza -la --git --group-directories-first'
  alias lt='eza --tree --group-directories-first'
  alias l.='eza -a --group-directories-first | command grep -E "^\."'
else
  alias ll='ls -la'
  alias lt='find . -maxdepth 2 -print'
fi

alias g='git'
alias ga='git add'
alias gb='git branch'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline --decorate -20'
alias gst='git status --short --branch'

mkcd() {
  if (( $# != 1 )); then
    print -u2 "usage: mkcd <directory>"
    return 2
  fi
  mkdir -p -- "$1" && builtin cd -- "$1"
}

setjava() {
  if [[ "$OSTYPE" != darwin* || ! -x /usr/libexec/java_home ]]; then
    print -u2 "setjava is available only on macOS with a JDK installed"
    return 1
  fi
  if [[ "$1" == "list" || "$1" == "-l" ]]; then
    /usr/libexec/java_home -V
    return
  fi
  if (( $# != 1 )); then
    print -u2 "usage: setjava <version|list>"
    return 2
  fi
  local java_home
  java_home="$(/usr/libexec/java_home -v "$1" 2>/dev/null)" || {
    print -u2 "Java $1 is not installed"
    return 1
  }
  export JAVA_HOME="$java_home"
  "$JAVA_HOME/bin/java" -version
}

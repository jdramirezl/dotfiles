# ZStyle configurations
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath | command fzf'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath' 
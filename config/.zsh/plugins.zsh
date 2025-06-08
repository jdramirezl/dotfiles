# Zinit initialization
export ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load plugins
zinit light romkatv/zsh-defer
zsh-defer zinit light zsh-users/zsh-syntax-highlighting
zsh-defer zinit light zsh-users/zsh-completions
zsh-defer zinit light zsh-users/zsh-autosuggestions
zsh-defer zinit light Aloxaf/fzf-tab
zsh-defer zinit light agkozak/zsh-z
# zsh-defer zinit light zsh-users/command-not-found

zinit cdreplay -q

# Starship prompt
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Initialize starship prompt
eval "$(starship init zsh)" 
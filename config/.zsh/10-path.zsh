typeset -U path fpath

for directory in \
  "$HOME/.local/bin" \
  "$HOME/.cargo/bin"; do
  [[ -d "$directory" ]] && path=("$directory" $path)
done
unset directory

if [[ "$OSTYPE" == darwin* && -d /Applications/WezTerm.app/Contents/MacOS ]]; then
  path+=(/Applications/WezTerm.app/Contents/MacOS)
fi

if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  for directory in platform-tools emulator cmdline-tools/latest/bin; do
    [[ -d "$ANDROID_HOME/$directory" ]] && path+=("$ANDROID_HOME/$directory")
  done
  unset directory
fi

export PATH

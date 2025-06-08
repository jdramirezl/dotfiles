# pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Python development settings
export PYTHONDONTWRITEBYTECODE=1  # Prevent Python from writing .pyc files
export PYTHONUNBUFFERED=1         # Prevent Python from buffering stdout and stderr 
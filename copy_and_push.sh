#!/bin/bash

# Define directories and repository
zshrc="/Users/julianramire/.zshrc"
zshfuncs="/Users/julianramire/dotfiles"
ohmyzsh="/Users/julianramire/.oh-my-zsh"
nvim="/Users/julianramire/.config/nvim"
tmux="/Users/julianramire/.tmux.conf"
repo_path="/Users/julianramire/gh_dotfiles"
commit_message="Auto commit on $(date +'%Y-%m-%d')"

# Function to copy files from directories to the repository
copy_files() {
    cp -r "$zshrc" "$repo_path/zsh/"
    cp -r "$zshfuncs"/* "$repo_path/zsh/zshfuncs/"
    cp -r "$ohmyzsh"/* "$repo_path/ohmyzsh/"
    cp -r "$nvim"/* "$repo_path/nvim/"
    cp -r "$tmux" "$repo_path/tmux/"
}

# Function to commit and push changes to the repository
push_to_repo() {
    cd "$repo_path" || exit
    git add .
    PRE_COMMIT_ALLOW_NO_CONFIG=1 git commit -m "$commit_message"  
    terminal-notifier -title '🚀 Dotfile Backup' -message 'Your dotfiles were pushed to the repo!' -open 'https://github.com/jdramirezl/dotfiles'
    git push origin master --force # Assuming 'master' is the branch name
}

# Execute on Mondays, Wednesdays, and Fridays
day=$(date +%u)  # Get the day of the week (1=Monday, 2=Tuesday, ..., 7=Sunday)

if [ $day -eq 1 ] || [ $day -eq 3 ] || [ $day -eq 5 ]; then
    copy_files
    push_to_repo
fi


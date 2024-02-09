#!/bin/bash

# Define directories and repository
zshrc="/Users/julianramire/.zshrc"
zshfuncs="/Users/julianramire/dotfiles"
ohmyzsh="/Users/julianramire/.oh-my-zsh"
nvim="/Users/julianramire/.config/nvim"
repo_path="/Users/julianramire/gh_dotfiles"
commit_message="Auto commit on $(date +'%Y-%m-%d')"

# Function to copy files from directories to the repository
copy_files() {
    cp -r "$zshrc" "$repo_path"
    cp -r "$zshfuncs"/* "$repo_path"
    cp -r "$ohmyzsh"/* "$repo_path"
    cp -r "$nvim"/* "$repo_path"
}

# Function to commit and push changes to the repository
push_to_repo() {
    cd "$repo_path" || exit
    git add .
    git commit -m "$commit_message"
    git push origin master --force # Assuming 'master' is the branch name
}

# Execute on Mondays, Wednesdays, and Fridays
day=$(date +%u)  # Get the day of the week (1=Monday, 2=Tuesday, ..., 7=Sunday)

if [ $day -eq 1 ] || [ $day -eq 3 ] || [ $day -eq 5 ]; then
    copy_files
    push_to_repo
fi


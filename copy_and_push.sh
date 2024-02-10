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
    git commit -m "$commit_message" --no-verify
    git push origin master --force # Assuming 'master' is the branch name
}

# Function to create a file with execution date and time
create_execution_file() {
    touch "$repo_path/execution_$(date +'%Y-%m-%d_%H-%M-%S').txt"
}

# Function to delete the execution file after pushing changes
delete_execution_file() {
    rm -f "$repo_path/execution_"*.txt
}

push_to_toast() {
    /usr/local/bin/terminal-notifier -title '🚀 Dotfile Backup' -message "$1" -open 'https://github.com/jdramirezl/dotfiles'
}
# Execute on Mondays, Wednesdays, and Fridays
day=$(date +%u)  # Get the day of the week (1=Monday, 2=Tuesday, ..., 7=Sunday)

if [ $day -eq 1 ] || [ $day -eq 3 ] || [ $day -eq 5 ]; then
    message = "Copying and pushing dotfiles to the repository..."
    push_to_toast $message
    copy_files
    create_execution_file
    push_to_repo
    delete_execution_file
    message = "Backup completed successfully! 🎉"
    push_to_toast $message
fi


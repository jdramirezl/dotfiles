#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print functions
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

# Backup existing file/directory
backup_if_exists() {
    local file=$1
    if [ -e "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$file" "$backup"
        print_warning "Backed up $file to $backup"
    fi
}

# Create parent directory if it doesn't exist
create_parent_dir() {
    local file=$1
    local parent_dir=$(dirname "$file")
    if [ ! -d "$parent_dir" ]; then
        mkdir -p "$parent_dir"
        print_status "Created directory: $parent_dir"
    fi
}

# Copy file or directory
copy_item() {
    local source=$1
    local target=$2
    
    # Ensure source exists
    if [ ! -e "$source" ]; then
        print_error "Source does not exist: $source"
        return 1
    }
    
    # Create parent directory if needed
    create_parent_dir "$target"
    
    # Backup existing file/directory
    backup_if_exists "$target"
    
    # Copy the file or directory
    if [ -d "$source" ]; then
        # For directories, use recursive copy
        if cp -R "$source" "$target"; then
            print_status "Copied directory $source -> $target"
        else
            print_error "Failed to copy directory $source -> $target"
            return 1
        fi
    else
        # For files, use regular copy
        if cp "$source" "$target"; then
            print_status "Copied file $source -> $target"
        else
            print_error "Failed to copy file $source -> $target"
            return 1
        fi
    fi
}

# Main installation function
install_dotfiles() {
    # Get the absolute path of the repository
    REPO_PATH=$(pwd)
    CONFIG_PATH="$REPO_PATH/config"
    
    print_status "Installing dotfiles from $REPO_PATH"
    
    # Array of files to copy (source:target)
    declare -A files=(
        ["$CONFIG_PATH/.config/nvim"]="$HOME/.config/nvim"
        ["$CONFIG_PATH/.config/wezterm"]="$HOME/.config/wezterm"
        ["$CONFIG_PATH/.config/starship.toml"]="$HOME/.config/starship.toml"
        ["$CONFIG_PATH/.wezterm.lua"]="$HOME/.wezterm.lua"
        ["$CONFIG_PATH/.zshrc"]="$HOME/.zshrc"
        ["$CONFIG_PATH/.zsh"]="$HOME/.zsh"
    )
    
    # Copy files and directories
    local error_count=0
    for source in "${!files[@]}"; do
        target="${files[$source]}"
        if ! copy_item "$source" "$target"; then
            ((error_count++))
        fi
    done
    
    # Final status
    if [ $error_count -eq 0 ]; then
        print_status "All dotfiles have been installed successfully!"
        print_status "Please restart your terminal for changes to take effect."
        print_warning "Note: These are copies of the configuration files. Changes to these files won't automatically sync with the repository."
        print_warning "To update the repository with your changes, use the backup_dotfiles.sh script."
    else
        print_error "$error_count errors occurred during installation."
        print_error "Please check the output above and fix any issues."
        return 1
    fi
}

# Check if running from the correct directory
if [ ! -f "backup_dotfiles.sh" ] || [ ! -d "config" ]; then
    print_error "Please run this script from the dotfiles repository root"
    exit 1
fi

# Run installation
install_dotfiles 
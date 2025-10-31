#!/bin/bash

# Dotfiles installation script
# Works on both macOS and Linux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo -e "${RED}[ERROR] Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

echo -e "${BLUE}Starting dotfiles installation for ${OS}...${NC}\n"

print_step() {
    echo -e "${YELLOW}[*] $1${NC}"
}

print_success() {
    echo -e "${GREEN}[OK] $1${NC}\n"
}

print_error() {
    echo -e "${RED}[ERROR] $1${NC}\n"
}

create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Remove existing file/symlink if it exists
    if [[ -L "$target" ]]; then
        rm "$target"
    elif [[ -e "$target" ]]; then
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "  Backed up existing file: $target"
    fi

    # Create symlink
    ln -sf "$source" "$target"
    echo "  Linked: $target → $source"
}

# =============================================================================
# STEP 1: Create necessary directories
# =============================================================================
print_step "Creating necessary directories..."
mkdir -p ~/.config
print_success "Directories created"

# =============================================================================
# STEP 2: Symlink dotfiles
# =============================================================================
print_step "Symlinking dotfiles..."

# Home directory dotfiles
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/.ideavimrc" "$HOME/.ideavimrc"
create_symlink "$DOTFILES_DIR/aliases.zsh" "$HOME/aliases.zsh"

# Config directory - common for both OS
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
create_symlink "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"

# OS-specific symlinks
if [[ "$OS" == "macos" ]]; then
    create_symlink "$DOTFILES_DIR/aerospace" "$HOME/.config/aerospace"
    create_symlink "$DOTFILES_DIR/karabiner.edn" "$HOME/.config/karabiner.edn"
    create_symlink "$DOTFILES_DIR/raycast" "$HOME/.config/raycast"
elif [[ "$OS" == "linux" ]]; then
    create_symlink "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"
    create_symlink "$DOTFILES_DIR/rofi" "$HOME/.config/rofi"
    create_symlink "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"
    create_symlink "$DOTFILES_DIR/mako" "$HOME/.config/mako"
    create_symlink "$DOTFILES_DIR/hyprshell" "$HOME/.config/hyprshell"
fi

print_success "Dotfiles symlinked"

# =============================================================================
# STEP 3: Configure Git
# =============================================================================
print_step "Configuring Git..."
if git config --global include.path "$DOTFILES_DIR/git/gitconfig_global"; then
    print_success "Git configuration complete"
else
    print_error "Failed to configure Git"
    exit 1
fi

# =============================================================================
# STEP 4: Install packages
# =============================================================================
if [[ "$OS" == "macos" ]]; then
    print_step "Installing Homebrew packages..."

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "  Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install packages from Brewfile
    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        brew bundle --file="$DOTFILES_DIR/Brewfile"
        print_success "Homebrew packages installed"
    else
        print_error "Brewfile not found"
    fi

    # =============================================================================
    # STEP 5: macOS-specific settings
    # =============================================================================
    print_step "Applying macOS settings..."

    if [[ -f "$DOTFILES_DIR/macos.sh" ]]; then
        echo "  This will modify system preferences. Continue? (y/n)"
        read -r response
        if [[ "$response" == "y" ]]; then
            bash "$DOTFILES_DIR/macos.sh"
            print_success "macOS settings applied (restart may be required)"
        else
            echo "  Skipped macOS settings"
        fi
    fi

elif [[ "$OS" == "linux" ]]; then
    # =============================================================================
    # STEP 4a: Install yay if on Arch Linux and not present
    # =============================================================================
    if command -v pacman &> /dev/null && ! command -v yay &> /dev/null; then
        print_step "Installing yay (AUR helper)..."

        sudo pacman -S --noconfirm --needed base-devel git

        # Clone and install yay
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd "$DOTFILES_DIR"
        rm -rf "$TEMP_DIR"

        print_success "yay installed"
    fi

    print_step "Installing Linux packages..."

    # Detect package manager
    if command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm --needed"
    elif command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
        INSTALL_CMD="sudo apt-get install -y"
        sudo apt-get update
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
    else
        print_error "No supported package manager found (pacman, apt, or dnf)"
        exit 1
    fi

    echo "  Detected package manager: $PKG_MANAGER"

    # Read packages from Linuxfile
    if [[ -f "$DOTFILES_DIR/Linuxfile" ]]; then
        PACKAGES=()
        while IFS= read -r line || [[ -n "$line" ]]; do
            # Skip empty lines and comments
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
            # Trim whitespace and add to array
            package=$(echo "$line" | xargs)
            [[ -n "$package" ]] && PACKAGES+=("$package")
        done < "$DOTFILES_DIR/Linuxfile"

        # Install packages
        if [[ "$PKG_MANAGER" == "pacman" ]]; then
            echo "  Installing packages (skipping already installed)..."
            $INSTALL_CMD "${PACKAGES[@]}" || echo "  Warning: Some packages failed to install"
        else
            # For other package managers, install one by one
            for package in "${PACKAGES[@]}"; do
                echo "  Installing $package..."
                $INSTALL_CMD "$package" || echo "  Warning: Failed to install $package (may not be available for $PKG_MANAGER)"
            done
        fi
    else
        print_error "Linuxfile not found"
    fi

    print_success "Linux packages installed"

    # =============================================================================
    # STEP 5b: Install AUR packages (Arch Linux only)
    # =============================================================================
    if command -v yay &> /dev/null && [[ -f "$DOTFILES_DIR/AURfile" ]]; then
        print_step "Installing AUR packages..."

        AUR_PACKAGES=()
        while IFS= read -r line || [[ -n "$line" ]]; do
            # Skip empty lines and comments
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
            # Trim whitespace and add to array
            package=$(echo "$line" | xargs)
            [[ -n "$package" ]] && AUR_PACKAGES+=("$package")
        done < "$DOTFILES_DIR/AURfile"

        # Install AUR packages
        echo "  Installing AUR packages (skipping already installed)..."
        yay -S --noconfirm --needed "${AUR_PACKAGES[@]}" || echo "  Warning: Some AUR packages failed to install"

        print_success "AUR packages installed"
    fi

    # =============================================================================
    # STEP 6: Configure SDDM (Linux only)
    # =============================================================================
    print_step "Configuring SDDM..."

    if [[ -f "$DOTFILES_DIR/sddm/sddm.conf" ]]; then
        echo "  Symlinking SDDM configuration (requires sudo)..."
        sudo ln -sf "$DOTFILES_DIR/sddm/sddm.conf" /etc/sddm.conf
        echo "  SDDM config linked to /etc/sddm.conf"

        # Set theme variant if astronaut theme is installed
        if [[ -d "/usr/share/sddm/themes/sddm-astronaut-theme" ]]; then
            sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/japanese_aesthetic.conf|' /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop
            echo "  Astronaut theme set to japanese_aesthetic variant"
        else
            echo "  Note: Install sddm-astronaut-theme first"
        fi

        print_success "SDDM configured"
    fi
fi

# =============================================================================
# Final message
# =============================================================================
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Dotfiles installation complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Restart your terminal or run: ${BLUE}source ~/.zshrc${NC}"
if [[ "$OS" == "macos" ]]; then
    echo -e "  2. If you applied macOS settings, restart your computer"
    echo -e "  3. Configure Karabiner-Elements manually (if needed)"
fi
echo ""

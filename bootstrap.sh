#!/usr/bin/env bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

install_packages() {
    echo "Install pacman packages..."
    sudo pacman -Syu --needed - < "$ROOT_DIR/packages/pacman.txt"
}

install_aur() {
    echo "Install AUR packages..."
    command -v yay >/dev/null || git clone https://aur.archlinux.org/yay.git /tmp/yay && (cd /tmp/yay && makepkg -si)
    yay -S --needed - < "$ROOT_DIR/packages/aur.txt"
}

link_configs() {
    echo "Link configs..."
    for dir in "$ROOT_DIR/config/"*; do
        name=$(basename "$dir")
        ln -sf "$dir" "$HOME/.config/$name"
    done
}

install_scripts() {
    echo "Install scripts..."
    mkdir -p "$HOME/.local/bin"
    ln -sf "$ROOT_DIR/scripts/"* "$HOME/.local/bin/"
}

install_system_files() {
    echo "Install system files..."
    sudo cp -r "$ROOT_DIR/system/"* /
}

enable_services() {
    echo "Enable services..."
    sudo systemctl enable sddm
}

main() {
    install_packages
    install_aur
    link_configs
    install_scripts
    install_system_files
    enable_services
}

main

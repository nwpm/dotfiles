#!/bin/sh
set -e

echo "Start setting dotfiles"
echo

DOT_DIR=$(pwd)

install_packages() {
    echo "====> Install pacman packages..."
    sudo pacman -Syu --needed - < "$DOT_DIR/packages/pacman.txt"
}

install_aur() {
    echo "====> Install AUR packages..."
    echo "====> Install yay..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay && (cd /tmp/yay && makepkg -si --noconfirm)
    yay -S --noconfirm --needed - < "$DOT_DIR/packages/aur.txt"
}

change_shell(){
  echo "====> Change default shell to zsh..."
  sudo chsh -s /bin/zsh $(whoami)
}

set_up_home(){
  echo "====> Set up home directory..."
  cp "$DOT_DIR/home/.xinitrc" ~/
  cp "$DOT_DIR/home/.zshrc"  ~/
}

# TODO sudo problem
setting_sddm_theme(){
  echo "====> Set up sddm theme..."
  sudo mkdir -p /etc/sddm.conf.d
  cp "$DOT_DIR/system/sddm/sddm.conf" "/etc/sddm.conf.d/"
}

add_user_in_groups(){
  echo "====> Add user in groups..."
  sudo usermod -aG libvirt $(whoami)
}

link_configs() {
    echo "====> Link configs..."
    for dir in "$DOT_DIR/config/"*; do
        name=$(basename "$dir")
        rm -rf "$HOME/.config/$name"
        ln -sf "$dir" "$HOME/.config/$name"
    done
}

enable_services() {
    echo "====> Enable services..."
    sudo systemctl enable sddm
    sudo systemctl enable libvirtd
}

main() {
    install_packages
    install_aur
    change_shell
    setting_sddm_theme
    link_configs
    set_up_home
    enable_services
    add_user_in_groups
}

main

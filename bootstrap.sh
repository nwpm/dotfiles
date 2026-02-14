#!/bin/sh

set -e
GREEN='\033[0;32m'
NC='\033[0m'

echo "${GREEN}====> Start setting dotfiles${NC}"
echo

DOT_DIR=$(pwd)

install_packages() {
    echo "${GREEN}====> Install pacman packages${NC}..."
    sudo pacman -Syu --needed - < "$DOT_DIR/packages/pacman.txt"
}

install_aur() {
    echo "${GREEN}====> Install yay${NC}..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay && (cd /tmp/yay && makepkg -si --noconfirm)

    echo "${GREEN}====> Install AUR packages${NC}..."
    yay -S --noconfirm --needed - < "$DOT_DIR/packages/aur.txt"
}

change_shell(){
  echo "${GREEN}====> Change default shell to zsh${NC}..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  sudo chsh -s /bin/zsh "$(whoami)"
}

set_up_home(){
  echo "${GREEN}====> Set up home directory${NC}..."

  rm -f "$HOME/.zshrc"
  rm -f "$HOME/.xinitrc"
  rm -f "$HOME/.gitconfig"

  cp "$DOT_DIR/home/.xinitrc" "$HOME"
  cp "$DOT_DIR/home/.zshrc" "$HOME"
  cp "$DOT_DIR/home/.gitconfig" "$HOME"
}

setting_sddm_theme(){
  echo "${GREEN}====> Set up sddm theme${NC}..."
  sudo mkdir -p /etc/sddm.conf.d
  cp "$DOT_DIR/system/sddm/sddm.conf" "/etc/sddm.conf.d/"
}

add_user_in_groups(){
  echo "${GREEN}====> Add user in groups${NC}..."
  sudo usermod -aG libvirt "$(whoami)"
}

link_configs() {
    echo "${GREEN}====> Link configs${NC}..."
    for dir in "$DOT_DIR/config/"*; do
        name=$(basename "$dir")
        rm -rf "$HOME/.config/$name"
        ln -sf "$dir" "$HOME/.config/$name"
    done
}

enable_services() {
    echo "${GREEN}====> Enable services${NC}..."
    sudo systemctl enable sddm
    sudo systemctl enable libvirtd
}

set_up_languages(){
    echo "${GREEN}====> Set up languages${NC}..."

    sudo sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    sudo sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
    sudo locale-gen

    echo "LANG=en_US.UTF-8" | sudo tee /etc/locale.conf
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
    set_up_languages

    echo
    echo "DONE! The system is configured."
    echo
}

main

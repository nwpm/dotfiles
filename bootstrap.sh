#!/bin/sh

set -e
GREEN='\033[0;32m'
NC='\033[0m'

printf "%b====> Start setting dotfiles%b\n" "${GREEN}" "${NC}"

DOT_DIR=$(pwd)

install_packages() {
    printf "%b====> Install pacman packages%b..." "${GREEN}" "${NC}"
    sudo pacman -Syu --needed - < "$DOT_DIR/packages/pacman.txt"
}

install_aur() {
    printf "%b====> Install yay%b..." "${GREEN}" "${NC}"

    if [ "$(pacman -Q yay)" ]; then
      printf "%b====> Yay is already installed%b" "${GREEN}" "${NC}"
      return 0
    fi

    git clone https://aur.archlinux.org/yay.git /tmp/yay && (cd /tmp/yay && makepkg -si --noconfirm)

    printf "%b====> Install AUR packages%b..." "${GREEN}" "${NC}"
    yay -S --noconfirm --needed - < "$DOT_DIR/packages/aur.txt"
}

change_shell(){
  printf "%b====> Install and change default shell to zsh%b..." "${GREEN}" "${NC}"

  if [ "$(pacman -Q zsh)" ]; then
    printf "%b====> Zsh is already installed%b" "${GREEN}" "${NC}"
    return 0
  fi

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  sudo chsh -s /bin/zsh "$(whoami)"
}

set_up_home(){
  printf "%b====> Set up home directory%b..." "${GREEN}" "${NC}"

  rm -f "$HOME/.zshrc"
  rm -f "$HOME/.xinitrc"
  rm -f "$HOME/.gitconfig"

  cp "$DOT_DIR/home/.xinitrc" "$HOME"
  cp "$DOT_DIR/home/.zshrc" "$HOME"
  cp "$DOT_DIR/home/.gitconfig" "$HOME"
}

setting_sddm_theme(){
  printf "%b====> Set up sddm theme%b..." "${GREEN}" "${NC}"
  sudo mkdir -p /etc/sddm.conf.d
  cp "$DOT_DIR/system/sddm/sddm.conf" "/etc/sddm.conf.d/"
}

add_user_in_groups(){
  printf "%b====> Add user in groups%b..." "${GREEN}" "${NC}"
  sudo usermod -aG libvirt "$(whoami)"
}

link_configs() {
    printf "%b====> Link configs%b..." "${GREEN}" "${NC}"
    for dir in "$DOT_DIR/config/"*; do
        name=$(basename "$dir")
        rm -rf "$HOME/.config/$name"
        ln -sf "$dir" "$HOME/.config/$name"
    done
}

enable_services() {
    printf "%b====> Enable services%b..." "${GREEN}" "${NC}"
    sudo systemctl enable sddm
    sudo systemctl enable libvirtd
}

set_up_languages(){
    printf "%b====> Set up languages%b..." "${GREEN}" "${NC}"

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

    printf "DONE! The system is configured.\n"
}

main

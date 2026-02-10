#!/bin/zsh

choice=$(echo -e " Shutdown\n Reboot\n Suspend\n Logout" | $ROFI_CMD -p "Power:")
[[ -z "$choice" ]] && exit

# Удаляем иконку перед сравнением
choice=$(echo "$choice" | sed 's/^[^ ]* //')

confirm=$(echo -e "No\nYes" | $ROFI_CMD -p "Really $choice?")
[[ "$confirm" != "Yes" ]] && exit

case "$choice" in
  Shutdown) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Suspend) systemctl suspend ;;
  Logout) i3-msg exit ;;
  *) exit 1 ;;
esac

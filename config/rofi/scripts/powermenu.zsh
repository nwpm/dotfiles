#!/bin/zsh

chosen=$(echo -e "⏻ Shutdown\n Reboot\n Sleep\n Lock\n󰍁 Log out" | rofi -dmenu -i -p "Power:")

case "$chosen" in
  "⏻ Shutdown") systemctl poweroff ;;
  " Reboot") systemctl reboot ;;
  " Sleep") systemctl suspend ;;
  " Lock") "LOCK PATH";;
  "󰍁 Log out") pkill -KILL -u $USER ;;
  *) exit 1 ;;
esac

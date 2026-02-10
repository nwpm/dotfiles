#!/usr/bin/env bash

layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | head -n 1)

case "$layout" in
    *"Russian"*)
        echo "RU"
        ;;
    *"English"*|*"US"*)
        echo "US"
        ;;
    *)
        echo "${layout:0:5}"
        ;;
esac

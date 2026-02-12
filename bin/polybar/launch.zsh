#!/bin/zsh

killall -q polybar
export DEFAULT_NETWORK_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar main &


#!/bin/zsh
sensors | grep -m 1 'Tctl:' | awk '{print $2}' | head -n 1 | cut -c 2-5

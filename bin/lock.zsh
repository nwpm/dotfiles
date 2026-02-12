#!/bin/bash

BG='#2A2A2Aee'
ACCENT='#007ACCff'
TEXT='#CCCCCCff'
WRONG='#F48771ff'
VERIFY='#9CDCFEff'

i3lock \
  --blur 7 \
  --clock \
  --indicator \
  --time-str="%H:%M:%S" \
  --date-str="%A, %d %b" \
  \
  --inside-color=$BG \
  --ring-color=$ACCENT \
  --line-color=$BG \
  --separator-color=$ACCENT \
  \
  --insidever-color=$BG \
  --ringver-color=$VERIFY \
  \
  --insidewrong-color=$BG \
  --ringwrong-color=$WRONG \
  \
  --keyhl-color=$VERIFY \
  --bshl-color=$WRONG \
  \
  --time-color=$TEXT \
  --date-color=$TEXT \
  --layout-color=$TEXT \
  --verif-color=$TEXT \
  --wrong-color=$TEXT \
  \
  --radius=120 \
  --ring-width=10 \
  --verif-text="Checking..." \
  --wrong-text="Access Denied" \
  --nofork

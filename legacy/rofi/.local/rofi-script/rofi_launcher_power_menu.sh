#!/bin/sh

MENU_SH_PATH=~/.local/rofi-script/rofi_power_menu

rofi \
  -show p \
  -modi p:$MENU_SH_PATH \
  -theme-str 'window {width: 12em;} listview {lines: 6;}'


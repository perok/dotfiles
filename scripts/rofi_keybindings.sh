#!/usr/bin/env bash


# Fetch only keybinding
# Change <modifier>key to modifier+key
gsettings list-recursively org.gnome.desktop.wm.keybindings \
  | grep -v '\[\]' | cut -f 1 -d ' ' --complement | sort \
  | rofi -dmenu -p "Keybindings" \
  | cut -f2 -d"'" \
  | sed -r "s/<([^>]*)>/\1+/g" \
  | xargs -i --no-run-if-empty xdotool key {}

#TODO
# To run with -modi "keybindings:$DOTUTILS/scripts/rofi_keybindings.sh"

#KEYBINDINGS=$(gsettings list-recursively org.gnome.desktop.wm.keybindings \
#  | grep -v '\[\]' | cut -f 1 -d ' ' --complement | sort | print)
#
#SELECTED_KEYBINDING=$(echo -e ${KEYBINDINGS} \
#  | cut -f2 -d"'" \
#  | sed -r "s/<([^>]*)>/\1+/g" \
#  | xargs -i --no-run-if-empty xdotool key {}
#)

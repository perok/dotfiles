#!/usr/bin/env bash

git submodule init
git submodule update

# TODO something that verifies that .dotfiles links to current directory

declare -a base=(
  shell
  zsh
)

declare -a useronly=(
  tmux
  git
  # raneme to div-utilities or somethign? div paa engelsk?
  nvim
  scripts
  rofi
  latex
  alacritty
  pulseaudio
  kde
  zathura
  firefox
  idea
  ctags
)

stowit() {
    usr=$1
    app=$2
    # TODO --dotfiles is currently broken. Add and fix when it works
    # --restow
    stow -v --target ${usr} stow-${app}
}

echo ""
echo "Stowing apps for user: ${whoami}"

for app in ${base[@]}; do
    stowit "${HOME}" $app
done

if [[ ! "$(whoami)" = *"root"* ]]; then
  for app in ${useronly[@]}; do
    stowit "${HOME}" $app
  done
fi

echo ""
echo "##### ALL DONE"


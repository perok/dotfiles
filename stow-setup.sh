#!/usr/bin/env bash

# TODO hele remsa med feilogger
set -e

git submodule init
git submodule update

# TODO add possibility to run one specific stow

# TODO add flag parsing to use --no on all stow commands

# Verify that ~/.dotfiles symlink exist
if [[ ! -d ~/.dotfiles ]]; then
  echo -n $'\t\u2139' '~/.dotfiles' does note exist. Symlinked to current directory
  ln -s "$PWD" ~/.dotfiles
  echo '... done'
elif [[ ! $PWD = $(realpath ~/.dotfiles) ]]; then
  echo $'\t\u26A0' "$(realpath ~/.dotfiles)" is not current directory
  exit 1
fi

declare -a base=(
  shell
  zsh
)

declare -a useronly=(
  tmux
  git
  nvim
  # rename to various-utilities or something?
  scripts
  rofi
  latex
  alacritty
  kde
  zathura
  firefox
  idea
  ctags
  mopidy
  kmonad
  neovide
)

stowit() {
    usr=$1
    app=$2
    # TODO --dotfiles is currently broken. Add and fix when it works
    # --restow
    if stow -v --target "${usr}" stow-"${app}" ; then
      echo $'\t\u2714' "$app" complete
    else
      echo $'\t\u274c' "$app" error
    fi
}

echo "Stowing apps for user: $(whoami)"

for app in "${base[@]}"; do
    stowit "$HOME" "$app"
done

if [[ ! "$(whoami)" = *"root"* ]]; then
  for app in "${useronly[@]}"; do
    stowit "$HOME" "$app"
  done
fi

# TODO combine instead of running stowit directly
# dest=( "${array1[@]}" "${array2[@]}" )

# parsing use
# https://stackoverflow.com/a/34531699
# https://gist.github.com/jehiah/855086#gistcomment-753465


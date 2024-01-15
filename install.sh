#!/usr/bin/env bash

set -e

PYTHON_PACKAGES=(
  pynvim # NVIM dependency unidecode # For vim ultisnips
  pipx # Python applicaiton manager
)

install_pip() {
  # TODO upgrade flags?
  python3 -m pip install --user "${PYTHON_PACKAGES[@]}"
}
# TODO cargo
# - cargo install difftastic
# todo lazygit

PIPX_PACKAGES=(
  ensurepath
  thefuck
  juypyterlab
  graphtage # json, xml diffing
  docker-compose
  bitwarden-pyro # rofi bitwarden
  neovim-remote
)

# TODO fix in other install
install_pipx() {
  pipx install "${PIPX_PACKAGES[@]}"
}

# TODO have changed to using volta
NPM_PACKAGES=(
  @bitwarden/cli
  sql-language-server
  vscode-html-languageserver-bin
  typescript typescript-language-server
  vim-language-server
  @elm-tooling/elm-language-server
  yaml-language-server
  vscode-css-languageserver-bin
  dockerfile-language-server-nodejs
  bash-language-server
  purescript-language-server
  tldr # tldr for man
)

# setup npm
config_npm() {
  if ! command -v nvm &> /dev/null
  then
    echo "Installing NVM"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  fi

  #
  # TODO move to stow-node
  # mkdir "${HOME}/.npm-packages"
  # npm config set prefix "${HOME}/.npm-packages"
}

install_npm() {
  npm install -g "${NPM_PACKAGES[@]}"
}

APT_PACKAGES=(
  mtpfs # FS for Android usb mounting
  wajig # wajig large -> list all installed and size
  look # Autocompletion of words. Used with vim. TODO missing?
  smbclient # Samba printer client
  rofi # Application runner
  bat # cat replacement
  zsh xsel htop mosh stow
  shellcheck
  unrar p7zip
  gawk silversearcher-ag ripgrep
  universal-ctags
  colordiff colormake
  ranger atool caca-utils highlight libsixel-bin
  zathura mupdf
  mpv ffmpeg youtube-dl
  lnav tig
  jq
  httpie
  exa
)

updates_npm() {
  npx npm-check-updates -g
}

install_apt() {
  sudo apt install "${APT_PACKAGES[@]}"
}

# TODO Setup snap
SNAP_PACKAGES=(
  ncspot # Spotify ncurses client
)

# TODO if cs not installed
COURSIER_PACKAGES=(
  mdoc
  ammonite
  sbt-launcher
)


setup_coursier() {
# Add a manually kept in sync completion folder using
# $DOT_DIR_HOME_OR_WHAT_ICALLEDIT
# https://get-coursier.io/docs/cli-overview.html#zsh-completions

  # TODO download tempdir. Only need coursier afterwards
  curl -Lo cs https://git.io/coursier-cli-linux && \
   chmod +x cs && \
   ./cs install coursier
}

install_coursier() {
  # TODO must be not commands. How to
  if (( $+commands[coursier] )); then
    setup_coursier
  fi

  coursier install "${COURSIER_PACKAGES[@]}"
}

upgrade_coursier() {
  coursier update
}


setup_generic() {
  # Setup snap with desktop links
  # TODO er dette synderen for spotify .desktop problemet?
  mkdir -p ~/.local/share/applications
  ln -s /var/lib/snapd/desktop/applications/ ~/.local/share/applications/snap

  # - Check if Hasklig font is installed

  #  - ["[ ! -d ~/.zim ] && curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh", Installing zim]
  #  - ["[ ! -d ~/.tmux/plugins/tpm ] &&  git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm || exit 0", Installing tpm]
  #  #- [git submodule foreach git pull origin master, Updating submodules to origin master]
}

# Use trick from rofi. Have functions named do_update_npm do_install_npm.
# These are built using input args. if no match then info printout

usage() {
  echo "TODO"
}

while [ "$1" != "" ]; do
    case $1 in
      -in | --install_npm) install_npm
                           exit
                           ;;
        #-f | --file )           shift
        #                        filename=$1
        #                        ;;
        #-i | --interactive )    interactive=1
        #                        ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
  done

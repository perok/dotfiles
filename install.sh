#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing the dotfiles for the first time"
    git clone https://github.com/perok/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
    [ "$1" == "ask" ] && export ASK="true"
    rake install
else
    echo "It seems I might be installed in '~/.dotfiles/' already."
    echo "If that is the case; Run 'rake update' inside it if you wish."
    echo "But if that is not the case.. Check out '~/.dotfiles/', delete it and try again."
fi


#Setup janus
mkdir ~/.janus
cd ~/.janus
git clone https://github.com/tomtom/tcomment_vim
TagHighlight
git clone https://github.com/altercation/vim-colors-solarized


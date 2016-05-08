# Perok's dotfiles

My dots. Assumes Zsh, Kde, silversearcher-ag and Neovim.

Installation guide
------------------

Uses: https://github.com/anishathalye/dotbot/

Clone and ./install

    sudo ln -s ~/dotfiles/bin/sane-rm /usr/local/bin/rm

Todo
----

* Change to https://github.com/Eriner/zim
* http://zshwiki.org/home/zle/vi-mode
* with https://github.com/zsh-users/zsh/blob/master/Functions/Zle/surround
* http://vimrcfu.com/snippet/77
* http://vimrcfu.com/snippet/182

Noteable stuff
--------------

### Nvim

* imap jk <Esc>

### General system changes

Caps is useless so swap it with escape. Add this to startup:

    ./$HOME/.dotfiles/scripts/swap-caps-escape


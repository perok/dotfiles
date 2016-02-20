# Perok's dotfiles

My dots. Assumes Zsh, Prezto, Kde, silversearcher-ag and Neovim.

Installation guide
------------------

Uses: https://github.com/anishathalye/dotbot/

Clone and ./install

Python files

    $ sudo apt-get install python-virtualenv silversearcher-ag
    $ pip install virtualenvwrapper

Other:

    $ sudo apt-get install autojump

Todo
----

* http://vimrcfu.com/snippet/77
* http://vimrcfu.com/snippet/182
* Vimwiki?
* vim-devicons
* Nerdcommenter or tcomment
* vim-easy-align
* targets.vim

Noteable stuff
--------------

### Nvim

* imap jk <Esc>

### General system changes

Caps is useless so swap it with escape. Add this to startup:

    ./$HOME/.dotfiles/scripts/swap-caps-escape


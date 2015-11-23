# Perok's dotfiles

Personal setup for neovim, tmux, zsh, ranger, and some other stuff.


Installation guide
------------------

Using https://github.com/anishathalye/dotbot/
clone to .dotfiles, copy symlinks to $HOME, source .zprezto.local in .zpreztorc

# TODO
- Fix Readme
- Sourcing for zprezto to local
- How to install virtualenv
- Install zprezto
- Remove tmux?
- Cleanup old git ~

Noteable stuff
--------------

## VIM

* imap jk --> Esc

Legg til


+
http://vimrcfu.com/snippet/77
and
http://vimrcfu.com/snippet/182


## General system changes

Caps is useless. Swap caps with escape. Add this to startup:

    xmodmap ~/dotfiles/scripts/speedswapper

# TODO
* Migrate to stow? http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html
* https://github.com/dhruvasagar/vim-table-mode
* https://github.com/Shougo/unite.vim replace C-p?
* https://github.com/mhinz/vim-startify
* https://github.com/dockyard/vim-easydir

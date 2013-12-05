# Perok's dotfiles

My personal setup for tmux, zsh, ranger, and some other stuff.
Based on spf13-vim and prezto with tweaks and additions.

Installation guide
-----------------

1. Install in terminal with this command:

        zsh -c "`curl -fsSL https://raw.github.com/perok/dotfiles/master/install.sh`"

  If you want questions, use this instead:

        zsh -c "`curl -fsSL https://raw.github.com/skwp/dotfiles/master/install.sh`" -s ask

3. ???

4. PROFIT

# Todo

* Fix rakefile install

# Update

        cd ~/.dotfiles && rake update

## Ranger

There is a conflict problem in Linux Mint.
Another package is also named highlight.
In ~/.config/ranger/scope.sh change "highlight" to "/usr/bin/highlight".
See: http://forums.linuxmint.com/viewtopic.php?f=47&t=122220

## VIM

* Space --> :
* jj --> Esc

### TagHighlight

On major changes in your codebase, run:

* :UpdateTypesFile

## General system changes

Caps is useless. Swap caps with escape. Add this to startup:

        xmodmap ~/dotfiles/scripts/speedswapper

# TODO

* https://github.com/zsh-users/zsh-history-substring-search
* https://github.com/dhruvasagar/vim-table-mode


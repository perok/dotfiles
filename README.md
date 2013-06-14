# Perok's dotfiles


        *Author:* Per Øyvind Kanestrøm
        *Source:*
        *Version:* 0.1.3.3.7
        *Updated:* 09-04-2013

# About

My personal setup for tmux, zsh, ranger, and some other stuff. It's based on Janus and Oh-my-zsh with many tweaks and additions.

This repo is the result of procrastination and many dotfiles lying around on the web. I have tried to include the source where it is deserved :)

I will try to include cool tips and features here also.

Currently only tested on Linux Mint 14 with xfce4-terminal.

# The core setup

* ZSH
** Prezto
** bla blajh
*** Loading some stuff
** My stuff
*** bin/ --> $PATH
* VIM
** Janus
** .janus/
** My stuff
* TMUX
** My stuff
* Powerline

Installation guide
-----------------

1. Install in terminal with this command:

        sh -c "`curl -fsSL https://raw.github.com/perok/dotfiles/master/install.sh`"

  If you want questions, use this instead:

        sh -c "`curl -fsSL https://raw.github.com/skwp/dotfiles/master/install.sh`" -s ask

2. The manual part..

  Edit '.zshrc' $plugins to 'plugins=(git command-not-found debian last-working-dir sublime symfony2)'

3. ???

4. PROFIT

# Update

        cd ~/.dotfiles && rake update

# Other

Bin/ is added to your path.
## Ranger

There is a conflict bug in Linux Mint. Another package also named highlight is making ranger act silly. 
Where highlight is called in ~/.config/ranger/scope.sh needs to be changed to "/usr/bin/highlight".
See: http://forums.linuxmint.com/viewtopic.php?f=47&t=122220

## XFCE4-terminal

Solarized is built in on version >= 0.6

## VIM

* Space --> :
* jj --> Esc

### TagHighlight

When much has happened in your codebase, run:

* :UpdateTypesFile 

### Tagbar

http://www.shanestillwell.com/index.php/2012/08/11/improving-my-vim-environment-with-ctags-and-tagbar/

* Mapped to <F8>

## General system changes

Swap caps lock with escape. Add to startup:

        xmodmap ~/dotfiles/scripts/speedswapper

# TODO

* Use powerline
* https://github.com/zsh-users/zsh-history-substring-search
* https://github.com/dhruvasagar/vim-table-mode
* https://github.com/zsh-users/zsh-syntax-highlighting
* https://github.com/zsh-users/zsh-completions
* Change from oh-my-zsh to prezto:
  https://github.com/sorin-ionescu/prezto
* https://github.com/tpope/vim-surround

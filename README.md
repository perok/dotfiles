# Perok's dotfiles


Installation guide
------------------

1) Install stow
2) Run `./setup-stow.sh`
2) Run `./install.sh`



## TODO
- TMUX 3.1 will support XDG spec. Move tmux config file to correct location
- Fix Stow for `$sudo ln -s ~/dotfiles/bin/sane-rm /usr/local/bin/rm`


## Firefox

- Setup userChrome
  - Find profile name
  - `ln -s ~/.dotfiles/firefox/userChrome.css ~/.mozilla/firefox/852x0ns6.default-release/chrome/userChrome.css`
- Ensure that all new tabs are opened in same window - In `about:config`
  - `browser.link.open_newwindow = 3`
  - `browser.link.open_newwindow.restriction = 0`

## AppImage

Install [Appimaged](https://github.com/AppImage/appimaged)

Todo
----

- then change to Hasklig Medium
* http://zshwiki.org/home/zle/vi-mode
* with https://github.com/zsh-users/zsh/blob/master/Functions/Zle/surround
* http://vimrcfu.com/snippet/77
* http://vimrcfu.com/snippet/182


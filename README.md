# Perok's dotfiles


Installation guide
------------------

1) Install stow
2) Run `./setup-stow.sh`
2) Run `./install.sh`
3) Add crontab entries. See (stow-scripts/.local/bin/cron-backup.sh)



## TODO
- TMUX 3.1 will support XDG spec. Move tmux config file to correct location
- Fix Stow for `$sudo ln -s ~/dotfiles/bin/sane-rm /usr/local/bin/rm`
- https://linrunner.de/tlp
- ncmpcpp config
- mopidy config without spotify credentials
- Start mopidy as systemd service. Run as root? global config.. and not user specific
- `git clone https://github.com/ryanoasis/nerd-fonts`, ./install.sh hasklig

## Fonts

- Nerd Fonts (Hasklug)
- Fira Code



## Firefox

- Setup userChrome
  - Find profile name
  - `ln -s ~/.dotfiles/firefox/userChrome.css ~/.mozilla/firefox/852x0ns6.default-release/chrome/userChrome.css`
- Ensure that all new tabs are opened in same window - In `about:config`
  - `browser.link.open_newwindow = 3`
  - `browser.link.open_newwindow.restriction = 0`
- Load pinned tabs on demand
  - `browser.sessionstore.restore_pinned_tabs_on_demand`

## AppImage

Install [Appimaged](https://github.com/AppImage/appimaged)

Todo
----

- then change to Hasklig Medium
* http://zshwiki.org/home/zle/vi-mode
* with https://github.com/zsh-users/zsh/blob/master/Functions/Zle/surround
* http://vimrcfu.com/snippet/77
* http://vimrcfu.com/snippet/182


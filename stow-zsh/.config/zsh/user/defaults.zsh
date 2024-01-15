# Set default exports

# If inside neovim terminal then use neovim --remote
if [ -n "${NVIM_LISTEN_ADDRESS+x}" ]; then
  export EDITOR='vim --remote'
  # TODO move to
  # https://github.com/mhinz/neovim-remote/issues/169#issuecomment-1094874951
  # when wait is implemented
  export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
  alias hh='nvim --remote -o'
  alias vv='nvim --remote -O'
  alias tt='nvim --remote-tab'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

export GIT_EDITOR="$EDITOR"

# Set alias's
alias vim="$EDITOR"
alias :e="$EDITOR"
alias :E="$EDITOR"
alias :q='exit'

# fasd aliases
# TODO double check these. xdg-open must be changed on mac
alias v="f -e $EDITOR" # quick opening files with vim
alias o='a -e xdg-open' # quick opening files with xdg-open

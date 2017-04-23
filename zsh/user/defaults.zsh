# Set default exports
# If inside neovim terminal then use neovim-remote
if [ -n "${NVIM_LISTEN_ADDRESS+x}" ]; then
    export EDITOR='nvr'
    alias hh='nvr -o'
    alias vv='nvr -O'
    alias tt='nvr --remote-tab'
else
    export EDITOR='nvim'
fi

export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# Set alias's
alias vim="$EDITOR"
alias :e="$EDITOR"
alias :E="$EDITOR"
alias :q='exit'

# fasd aliases
# TODO double check these. xdg-open must be changed on mac
alias v="f -e $EDITOR" # quick opening files with vim
alias o='a -e xdg-open' # quick opening files with xdg-open

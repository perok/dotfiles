#
# First invocation in /etc/zsh/zshenv
#

if [[ `uname` == 'Linux' ]]
then
    export LINUX=1
else
    export LINUX=
fi

if [[ `uname` == 'Darwin' ]]
then
    export OSX=1
else
    export OSX=
fi

export XDG_MUSIC_DIR=$HOME/Music

# Define Zim location
# TODO move below source controller
# TODO move zim to correct folder
# ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
ZIM_HOME=${HOME}/.zim

if [ "$ZSHENV_SOURCE" = true ] ; then
    return
fi


# TODO
#export XDG_CONFIG_HOME="$HOME/.config"


if (( $+commands[rbenv] )); then
  path=(
    $path
    $HOME/.rbenv/bin
  )
  eval "$(rbenv init -)"
fi

export ZSHENV_SOURCE=true


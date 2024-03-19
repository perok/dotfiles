function diff {
  if (( $+commands[colordiff] )); then
    command diff --unified "$@" | colordiff --difftype diffu
  elif (( $+commands[git] )); then
    git --no-pager diff --color=auto --no-ext-diff --no-index "$@"
  else
    command diff --unified --color=auto "$@"
  fi
}

function make {
  if (( $+commands[colormake] )); then
    colormake "$@"
  else
    command make "$@"
  fi
}

# Colorize man pages
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m")\
    LESS_TERMCAP_md=$(printf "\e[1;31m")\
    LESS_TERMCAP_me=$(printf "\e[0m")\
    LESS_TERMCAP_se=$(printf "\e[0m")\
    LESS_TERMCAP_so=$(printf "\e[1;44;33m")\
    LESS_TERMCAP_ue=$(printf "\e[0m")\
    LESS_TERMCAP_us=$(printf "\e[1;32m")\
    man "$@"
}



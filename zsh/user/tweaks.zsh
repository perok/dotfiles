
# FZF
if [ -x "$(command -v ag)" ]; then
  # Set ag as the default source for fzf (respect .gitignore etc)
  export FZF_DEFAULT_COMMAND='ag -l -g ""'
  # To apply the command to CTRL-T as well
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # For zsh {cmd} **<tab> completion
  # Use ag instead of the default find command for listing candidates.
  # - The first argument to the function is the base path to start traversal
  # - Note that ag only lists files not directories
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    ag -g "" "$1"
  }
fi

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



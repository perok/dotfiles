# ZSH settings file
#

# History {{{
  HISTSIZE=10000
  SAVEHIST=9000
  HISTFILE=~/.zsh_history
#}}}
# Set up variables {{{
  # Set terminal to support correct 256colors setup
  case "$TERM" in
    'xterm') TERM=xterm-256color;;
    'screen') TERM=screen-256color;;
  esac

  export EDITOR="vim"
  export PATH=$PATH:/usr/lib/jvm/java-7-oracle/bin:/usr/lib/jvm/java-7-oracle/db/bin:/usr/lib/jvm/java-7-oracle/jre/bin
  export PATH=$PATH:/home/perok/Downloads/devkit/bin #  devkit
  export PATH=$PATH:$DOTFILES/bin #  System binaries
  export PATH=$PATH:/home/perok/Development/android-sdk-linux/tools #  System binaries
  # Pager {{{
    export PAGER='less'
    export LESS="-FX -R" # If the output is smaller than the screen height is smaller, less will just cat it + support ANSI colors
    export LESSOPEN='|$DOTFILES/scripts/lessfilter.sh %s' # Syntax coloring with pygments in less, when opening source files
  # }}}
# }}}
#Zsh options {{{
  setopt auto_cd # Change dir without cd
  setopt extended_glob #    Regex globbing
  setopt notify # Report the status if background jobs immediately
  setopt complete_in_word # Not just at the end
  setopt always_to_end # When complete from middle, move cursor
  setopt no_match # Show error if pattern has no matches
  setopt no_beep # Disable beeps
  setopt list_packed # Compact completion lists
  setopt list_types # Show types in completion
  setopt rec_exact # Recognize exact, ambiguous matches
  setopt hist_verify # When using ! cmds, confirm first
  setopt hist_ignore_all_dups # Ignore dups in command history
  setopt hist_ignore_space # Don't add commands prepended by whitespace to history
  setopt append_history # Allow multiple sessions to append to the history file
  setopt extended_history # Save additional info to history file
  setopt inc_append_history # Append commands to history immediately
  setopt correct # Command correction
  setopt short_loops # Allow short loops

# }}}
# Keybindings {{{
  #bindkey -v  # VI key bindings. Breaks C-a, C-e
  bindkey '^[[5~' up-line-or-history  # Page Up
  bindkey '^[[6~' down-line-or-history # Page Down
  # vi style incremental search {{{
    bindkey '^R' history-incremental-search-backward #bind history search to C-r 
    bindkey '^S' history-incremental-search-forward
    bindkey '^P' history-search-backward
    bindkey '^N' history-search-forward
  # }}}
  # ctrl-f edit current buffer in editor {{{
    autoload -U edit-command-line
    zle -N edit-command-line
    bindkey '^f' edit-command-line
  # }}}
# }}}
#  Other {{{
  # Source modules {{{
    source $DOTFILES/zsh/z/z.sh
  # }}}
#  }}}

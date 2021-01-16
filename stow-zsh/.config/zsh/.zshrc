#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
setopt CORRECT

# Customize spelling correction prompt.
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}


# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

#
# git
#
# Set a custom prefix for the generated aliases. The default prefix is 'G'.
zstyle ':zim:git' aliases-prefix 'g'

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

# ------------------
# Initialize modules
# ------------------

if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# ------------------------------
# Other settings
# ------------------------------

# Fix locale warning from terminal in Intellij
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

function source_file() {
    if [[ -r $1 ]]; then
        source $1
    fi
}

#
# Base setup
#

PURE_PROMPT_SYMBOL='λ'

#
# Plugins
#

# TODO Verify that works
if [[ -v ENHANCD_DIR ]]; then # ENHANCD_DIR installed
  # setting if enhancd is available
  export ENHANCD_FILTER=fzf-tmux
fi

# SDKMan for Java
export SDKMAN_DIR="$HOME/.sdkman"
source_file $SDKMAN_DIR/bin/sdkman-init.sh

export NVM_SYMLINK_CURRENT=true
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVM_DIR="$HOME/.nvm"
# Note: Due to the use of nodejs instead of node name in some distros, yarn might complain about node not being installed.
# A workaround for this is to add an alias in your .bashrc file
alias node=nodejs

export GRADLE_OPTS=-Dorg.gradle.daemon=true

if (( $+commands[rbenv] )); then
  path=(
    $path
    $HOME/.rbenv/bin
  )
  eval "$(rbenv init -)"
fi

# TODO ?
#start_tmux

# Broot launcher
source ~/.config/broot/launcher/bash/br

# Utility tools
source ~/.fzf.zsh # Load after personal settings

# GHCUp
[ -f "/home/perok/.ghcup/env" ] && source "/home/perok/.ghcup/env" # ghcup-env

path=(
  $path
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  `yarn global bin`
  "$HOME/.local/share/coursier/bin"
)

# Custom settings
source "$ZDOTDIR/user/defaults.zsh"
source "$ZDOTDIR/user/keybindings.zsh"
source "$ZDOTDIR/user/funcs.zsh"
source "$ZDOTDIR/user/tweaks.zsh"
source "$ZDOTDIR/user/alias.zsh"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

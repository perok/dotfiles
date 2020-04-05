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
# TODO working?
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

# TODO remaining old setup

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
# zplug check returns true if the given repository exists
if [[ -v ENHANCD_DIR ]]; then # ENHANCD_DIR installed
  # setting if enhancd is available
  export ENHANCD_FILTER=fzf-tmux
fi

# Custom settings
source "$ZDOTDIR/user/defaults.zsh"
source "$ZDOTDIR/user/keybindings.zsh"
source "$ZDOTDIR/user/funcs.zsh"
source "$ZDOTDIR/user/tweaks.zsh"
source "$ZDOTDIR/user/alias.zsh"
if [[ -n ${LINUX} ]]; then
    source $ZDOTDIR/user/linux.zsh
else
    source $ZDOTDIR/user/darwin.zsh
fi

# Utility tools
source ~/.fzf.zsh # Load after personal settings

export WORKON_HOME=$HOME/.virtualenvs

export SDKMAN_DIR="$HOME/.sdkman"
source_file ~/.sdkman/bin/sdkman-init.sh

export NVM_SYMLINK_CURRENT=true
export NVM_DIR="$HOME/.nvm"
source_file $NVM_DIR/nvm.sh
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Note: Due to the use of nodejs instead of node name in some distros, yarn might complain about node not being installed.
# A workaround for this is to add an alias in your .bashrc file
alias node=nodejs


export GRADLE_OPTS=-Dorg.gradle.daemon=true

# Add a manually kept in sync completion folder using
# $DOT_DIR_HOME_OR_WHAT_ICALLEDIT
# https://get-coursier.io/docs/cli-overview.html#zsh-completions
#
# # TODO
# - Bootstrap coursier with coursier (cs install cs installs to .local/coursier
#     remove dev/bin
# - Install sbt through cs

#start_tmux
# TODO hvor kommer yarn bin fra?
path=(
  $path
  "$HOME/dev/bin"
  # Trengs local bin?
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  `yarn global bin`
  "$HOME/.local/share/coursier/bin"
)

# Broot launcher
source /home/perok/.config/broot/launcher/bash/br
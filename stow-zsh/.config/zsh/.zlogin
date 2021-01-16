#
# startup file read in interactive login shells
# User configuration sourced by login shells
#

# Initialize zim
source ${ZIM_HOME}/login_init.zsh -q &!

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

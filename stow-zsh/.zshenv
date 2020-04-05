# https://stackoverflow.com/a/46962370
# Note: http://coot.net/assets/images/shell-startup-actual.png
#
#
#if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}
export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}
source $ZDOTDIR/.zshenv

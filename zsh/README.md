From https://wiki.archlinux.org/index.php/Zsh; When starting Zsh, it'll source
the following files in this order by default:

    /etc/zsh/zshenv

Used for setting system-wide environment variables; it should not contain
commands that produce output or assume the shell is attached to a tty. This file
will always be sourced, this cannot be overridden.

    $ZDOTDIR/.zshenv

Used for setting user's environment variables; it should not contain commands
that produce output or assume the shell is attached to a tty. This file will
always be sourced.

    /etc/zsh/zprofile

Used for executing commands at start, will be sourced when starting as a login
shell. Please note that on Arch Linux, by default it contains one line which
source the /etc/profile.

    /etc/profile

This file should be sourced by all Bourne-compatible shells upon login: it sets
up $PATH and other environment variables and application-specific
(/etc/profile.d/*.sh) settings upon login.

    $ZDOTDIR/.zprofile

Used for executing user's commands at start, will be sourced when starting as a
login shell.

    /etc/zsh/zshrc

Used for setting interactive shell configuration and executing commands, will be
sourced when starting as an interactive shell.

    $ZDOTDIR/.zshrc

Used for setting user's interactive shell configuration and executing commands,
will be sourced when starting as an interactive shell.

    /etc/zsh/zlogin

Used for executing commands at ending of initial progress, will be sourced when
starting as a login shell.

    $ZDOTDIR/.zlogin

Used for executing user's commands at ending of initial progress, will be
sourced when starting as a login shell.

    $ZDOTDIR/.zlogout

Will be sourced when a login shell exits.

    /etc/zsh/zlogout

Will be sourced when a login shell exits.


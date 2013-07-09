#
# Entry point for ZSH settings. Only sourcing of other files.
#

# Set the default dotfiles location {{{
    export DOTFILES="$HOME/.dotfiles/"
# }}}
# Source zsh files {{{
    # Source https://github.com/aziz/dotfiles/blob/master/bash/bash_it.sh
    # Load Tab Completion
    setopt EXTENDED_GLOB
    for config_file in "${DOTFILES}"/zsh/completion/*.zsh(.N); do
        source $config_file
    done

    # Load Plugins
    for config_file in "${DOTFILES}"/zsh/plugins/*.zsh(.N); do
        source $config_file
    done

    # Load Aliases
    for config_file in "${DOTFILES}"/zsh/alias/*.zsh(.N); do
        source $config_file
    done

    unset config_file

    # Source the Prezto settings.
    source $DOTFILES/zsh/zprestorc

    # Source the settings file
    source $DOTFILES/zsh/settings.zsh
# }}}

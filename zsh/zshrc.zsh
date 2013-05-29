#
# Entry point for ZSH settings. Only sourcing of other files.
# 
# ? Make the file move to .zsh/custom/ ?

# Set the default dotfiles location {{{
	export DOTFILES="$HOME/dotfiles/" #  TODO Add a dot when migrating
# }}}
# Source zsh files {{{
	# Source https://github.com/aziz/dotfiles/blob/master/bash/bash_it.sh
	# Load Tab Completion
	COMPLETION="$DOTFILES/zsh/completion/*.zsh"
	for config_file in $COMPLETION
	do
	  source $config_file
	done

	# Load Plugins
	PLUGINS="$DOTFILES/zsh/plugins/*.zsh"
	for config_file in $PLUGINS
	do
	  source $config_file
	done

	# Load Aliases
	FUNCTIONS="$DOTFILES/zsh/aliases/*.zsh"
	for config_file in $FUNCTIONS
	do
	  source $config_file
	done

	unset config_file

	# Source the settings file
	source $DOTFILES/zsh/settings.zsh
# }}}


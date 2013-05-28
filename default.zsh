#
# Entry point for ZSH settings. Only sourcing of other files.
# 
# ? Make the file move to .zsh/custom/ ?

# Set the default dotfiles location {{{
	export DOTFILES="$HOME/dotfiles/" #  TODO Add a dot when migrating
# }}}
# Source zsh files {{{
	source $DOTFILES/zsh/alias.zsh
	source $DOTFILES/zsh/settings.zsh
 	source $DOTFILES/zsh/scripts.zsh
# }}}


# Vi mode
# http://zshwiki.org/home/zle/vi-mode
#https://dougblack.io/words/zsh-vi-mode.html

# Keybinding mode: e-> emacs, v-> vi
bindkey -v

export KEYTIMEOUT=1 # ESC timeout time 10ms

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
# Emacs style
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
#bindkey -M vicmd v edit-command-line

# Show VI mode
precmd() { RPROMPT="" }
function zle-line-init zle-keymap-select {
  VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
  RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS2"
  zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-line-init

# Vi bindings
# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history
# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
# ctrl-w removed word backwards
bindkey '^w' backward-kill-word
# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward


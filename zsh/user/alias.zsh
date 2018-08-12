eval "$(thefuck --alias)"

# `exa` utility {{{
alias l='exa -bghl --group-directories-first --sort name --git'
alias ll='l --tree --level=3'
# }}}

# {{{
# Update Git commit graph. Will be done by default in Git 2.19 on `git gc`
alias git_update_graph='git show-ref -s | git commit-graph write --stdin-commits
'
# }}}

# Docker {{{
# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani'
# }}}

# Scala {{{
alias amm="amm --no-remote-logging"
# }}}

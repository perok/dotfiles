# ftpane - switch pane (@george-b)
ftpane() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
    tmux select-window -t $target_window
  fi
}


function docker_ip() {
    local container_id=$(docker ps | grep $1 | awk '{print $ 1}' | tail -n 1)

    if [ $container_id ]; then
        docker inspect $container_id \
            | grep -w "IPAddress" \
            | awk '{ print $2 }' \
            | tail -n 1
    else
        echo 'Unknown container' $1 1>&2
        return 1
    fi
}

function murderAllPort() {
    lsof -i:$1 | tail -n +2 | awk '{ print $2 }' | xargs -L1 kill -9
}

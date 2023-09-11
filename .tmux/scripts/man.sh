#!/usr/bin/env bash

get_input () {
    temp_file=$(mktemp)
    (tmux command-prompt -p "$@" "run-shell \"echo '%1' > $temp_file\"") &
    wait
    selected=$(cat "$temp_file")
    rm "$temp_file"
    echo "$selected"
}

if tmux list-windows | grep -q 'man'; then
    id=$(tmux list-windows | grep 'man' | sed 's#\([0-9]\+\):.*#\1#')
    tmux select-window -t "$id"
else
    selected=$(get_input "Enter man query:")
    if [ "$selected" = "" ]; then
        exit 0
    fi
    tmux neww -n 'man' -at 4 bash -c "/usr/bin/man '$selected' | col -b | bat -pl man --paging=always && tmux kill-window & sleep infinity"
fi

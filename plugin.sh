#!/usr/bin/env bash

PROMPT_PATTERN=$(tmux show-option -gqv @command-capture-prompt-pattern)
PROMPT_PATTERN=${PROMPT_PATTERN:-" ] % "}
EDITOR_CMD=$(tmux show-option -gqv @command-capture-editor-cmd)
EDITOR_CMD=${EDITOR_CMD:-"$EDITOR -"}

x=$(tmux capture-pane -pJS -)
result=$(echo "$x" | tac | sed -e "0,/$PROMPT_PATTERN/d" | sed "/$PROMPT_PATTERN/,\$d" | tac)

tmux new-window -n last-command-output -e result="$result" "echo \"$result\" | $EDITOR_CMD"

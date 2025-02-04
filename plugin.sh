#!/usr/bin/env bash

PROMPT_PATTERN=$(tmux show-option -gqv @command-capture-prompt-pattern)
PROMPT_PATTERN=${PROMPT_PATTERN:-" ] % "}
PROMPT_LINES=$(tmux show-option -gqv @command-capture-prompt-lines)
PROMPT_LINES=${PROMPT_LINES:-1}
EDITOR_CMD=$(tmux show-option -gqv @command-capture-editor-cmd)
EDITOR_CMD=${EDITOR_CMD:-"$EDITOR -"}

result=$(tmux capture-pane -pJS - | tac | sed -n "1,${PROMPT_LINES}d; /$PROMPT_PATTERN/q; p" | tac)

tmux new-window -n last-command-output -e result="$result" "echo \"$result\" | $EDITOR_CMD"

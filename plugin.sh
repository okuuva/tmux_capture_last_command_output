#!/usr/bin/env bash

PROMPT_PATTERN=$(tmux show-option -gqv "@command-capture-prompt-pattern")
PROMPT_PATTERN=${PROMPT_PATTERN:-" ] % "}
PROMPT_LINES=$(tmux show-option -gqv "@command-capture-prompt-lines")
PROMPT_LINES=${PROMPT_LINES:-1}
CAPTURE_PANE_FLAGS=$(tmux show-option -gqv "@command-capture-flags")
CAPTURE_PANE_FLAGS=${CAPTURE_PANE_FLAGS:-"-pJS -"}
EDITOR_CMD=$(tmux show-option -gqv "@command-capture-editor-cmd")
EDITOR_CMD=${EDITOR_CMD:-"$EDITOR -"}

# Check first if tac is available (it isn't by default on macOS)
if ! command -v tac >/dev/null 2>&1; then
	tmux display-message -d 0 "tmux_capture_last_command_output: Command 'tac' not found. Make sure you have coreutils installed."
	exit 0
fi

# We want the flags to split, otherwise they won't work
# shellcheck disable=SC2086
result=$(tmux capture-pane $CAPTURE_PANE_FLAGS | tac | sed -n "1,${PROMPT_LINES}d; /$PROMPT_PATTERN/q; p" | tac)

tmux new-window -n last-command-output "echo \"$result\" | $EDITOR_CMD"

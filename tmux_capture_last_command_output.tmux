#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

default_capture_key="t"
CAPTURE_KEY=$(tmux show-option -gqv @command-capture-key)
CAPTURE_KEY=${CAPTURE_KEY:-$default_capture_key}

tmux bind "$CAPTURE_KEY" run-shell "$CURRENT_DIR/plugin.sh"

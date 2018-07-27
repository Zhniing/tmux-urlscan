#!/usr/bin/env bash

# Copyright (c) 2018 Filip Szymański. All rights reserved.
# Use of this source code is governed by an MIT license that can be
# found in the LICENSE file.

set -euf -o pipefail

readonly CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=helpers.sh
source "$CURRENT_DIR/helpers.sh"

readonly CMD="$(get_tmux_option '@urlscan-cmd' 'urlscan')"
readonly ARGS="$(get_tmux_option '@urlscan-args' '-c -d')"
readonly TMPFILE="$(mktemp -u --tmpdir tmux-urlscan.XXXXXX)"

if command_exists "$CMD"; then
  tmux capture-pane -J \; \
    save-buffer "$TMPFILE" \; \
    delete-buffer \; \
    split-window -p 40 "$CMD $ARGS $TMPFILE; trap 'rm -f $TMPFILE' EXIT"
else
  tmux display-message "$CMD: command not found"
fi

# vim: sw=2 ts=2 et fdm=marker

#!/usr/bin/env bash
# show-keybinds.sh - parses config.kdl's own binds{} block live, so it
# can never go stale the way a separately maintained list would.
set -euo pipefail

config="${HOME}/.config/niri/config.kdl"
tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

{
  echo "NIRI KEYBINDINGS"
  echo "================"
  echo ""
  awk '/^binds \{/{f=1; next} /^\}/{if(f){f=0}} f' "$config" \
    | grep -E '[A-Za-z0-9]+.*\{.*\}' \
    | sed -E \
        -e 's/^[[:space:]]+//' \
        -e 's/[[:space:]]*\{[[:space:]]*/  ->  /' \
        -e 's/;[[:space:]]*\}.*$//' \
    | column -t -s $'\t' -o '  '
} > "$tmpfile"

kitty --class niri-keybinds --title "Keybindings" -e less -R "$tmpfile"

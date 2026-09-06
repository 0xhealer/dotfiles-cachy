#!/usr/bin/env bash
# 01-prerequisites.sh
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

for dir in "${HOME}/.config" "${HOME}/workspace" "${HOME}/.local/bin"; do
  mkdir -p "$dir"
done
echo "  Base directories ready."

#!/usr/bin/env bash
# 11-kitty.sh
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

copy_dotfile_item "${DOTFILES_ROOT}/configs/kitty/kitty.conf" "${HOME}/.config/kitty/kitty.conf"

if ! test_command_exists kitty; then
  echo "  WARNING: kitty not on PATH - config deployed, won't render until" >&2
  echo "  it's installed." >&2
fi

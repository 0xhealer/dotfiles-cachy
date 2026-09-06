#!/usr/bin/env bash
# 12-alacritty.sh
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

copy_dotfile_item "${DOTFILES_ROOT}/configs/alacritty/alacritty.toml" "${HOME}/.config/alacritty/alacritty.toml"

if ! test_command_exists alacritty; then
  echo "  WARNING: alacritty not on PATH - config deployed, won't render" >&2
  echo "  until it's installed." >&2
fi

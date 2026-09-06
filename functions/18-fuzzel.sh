#!/usr/bin/env bash
# 18-fuzzel.sh
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

copy_dotfile_item "${DOTFILES_ROOT}/configs/fuzzel/fuzzel.ini" "${HOME}/.config/fuzzel/fuzzel.ini"

if ! test_command_exists fuzzel; then
  echo "  WARNING: fuzzel not on PATH - not in packages/pacman.txt yet." >&2
  echo "  Add it there, or: sudo pacman -S fuzzel" >&2
fi

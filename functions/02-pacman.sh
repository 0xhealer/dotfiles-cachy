#!/usr/bin/env bash
# 02-pacman.sh
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists pacman; then
  echo "  ERROR: pacman not found - this installer assumes CachyOS/Arch." >&2
  exit 1
fi

echo "  Refreshing pacman database..."
sudo pacman -Sy --noconfirm >/dev/null

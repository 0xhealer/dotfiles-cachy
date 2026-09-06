#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 16-fastfetch.sh
# Deploys the user's own uploaded fastfetch config.jsonc + scripts, and the
# anime logo set (2b, ryuzaki, luffy-gear5, etc) to
# ~/.config/fastfetch/logos - the config's own logo.source already points
# there ("~/.config/fastfetch/logos/*.png"), so no path changes needed.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists fastfetch; then
  echo "  WARNING: fastfetch not found - not in packages/pacman.txt yet." >&2
  echo "  Add it there, or: sudo pacman -S fastfetch" >&2
fi

copy_dotfile_item "${DOTFILES_ROOT}/configs/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"
copy_dotfile_item "${DOTFILES_ROOT}/configs/fastfetch/scripts" "${HOME}/.config/fastfetch/scripts"
copy_dotfile_item "${DOTFILES_ROOT}/assets/fastfetch-logos" "${HOME}/.config/fastfetch/logos"

echo "  [DONE] fastfetch config + $(find "${HOME}/.config/fastfetch/logos" -type f | wc -l) logos deployed."

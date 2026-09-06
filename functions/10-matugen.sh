#!/usr/bin/env bash
# 10-matugen.sh - installs matugen, deploys trimmed kitty+alacritty templates
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists matugen; then
  echo "  WARNING: matugen not found - check module 03 ran." >&2
fi

copy_dotfile_item "${DOTFILES_ROOT}/configs/matugen" "${HOME}/.config/matugen"

echo "  matugen installed and configured for kitty + alacritty."
echo "  Run 'matugen image /path/to/wallpaper.jpg' manually to generate a"
echo "  palette - no wallpaper daemon wired up, Niri/Noctalia config is yours."

#!/usr/bin/env bash
# 15-wallpapers.sh - deploys assets/wallpapers (user's own images) to ~/Pictures/wallpapers
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

copy_dotfile_item "${DOTFILES_ROOT}/assets/wallpapers" "${HOME}/Pictures/wallpapers"
echo "  [DONE] $(find "${HOME}/Pictures/wallpapers" -type f | wc -l) wallpapers -> ~/Pictures/wallpapers"

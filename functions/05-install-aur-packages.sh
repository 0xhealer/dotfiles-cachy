#!/usr/bin/env bash
# 05-install-aur-packages.sh
set -uo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists yay; then
  echo "  WARNING: yay not found - skipping AUR packages." >&2
  exit 0
fi

mapfile -t packages < <(get_package_list "${DOTFILES_ROOT}/packages/aur.txt")

for package in "${packages[@]}"; do
  echo "  Installing ${package} (AUR)..."
  if ! yay -S --needed --noconfirm "$package"; then
    echo "  [FAILED] ${package} - continuing." >&2
  fi
done

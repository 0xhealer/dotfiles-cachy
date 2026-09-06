#!/usr/bin/env bash
# 03-install-pacman-packages.sh
set -uo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

mapfile -t packages < <(get_package_list "${DOTFILES_ROOT}/packages/pacman.txt")

for package in "${packages[@]}"; do
  echo "  Installing ${package}..."
  if ! sudo pacman -S --needed --noconfirm "$package"; then
    echo "  [FAILED] ${package} - continuing." >&2
  fi
done

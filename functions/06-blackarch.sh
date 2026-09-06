#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 06-blackarch.sh
# Registers the official BlackArch repository via strap.sh (not the
# BlackArch distro itself), then installs burpsuite from it - the one tool
# actually requested from that repo this time.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if grep -q '^\[blackarch\]' /etc/pacman.conf 2>/dev/null; then
  echo "  blackarch repo already registered."
else
  echo "  Registering the BlackArch repository..."
  strap_dir="$(mktemp -d)"
  trap 'rm -rf "$strap_dir"' EXIT
  curl -sSL -o "${strap_dir}/strap.sh" https://blackarch.org/strap.sh
  chmod +x "${strap_dir}/strap.sh"
  sudo "${strap_dir}/strap.sh"
  sudo pacman -Sy --noconfirm >/dev/null
  echo "  [DONE] blackarch repo registered."
fi

echo "  Installing burpsuite from the blackarch repo..."
sudo pacman -S --needed --noconfirm burpsuite

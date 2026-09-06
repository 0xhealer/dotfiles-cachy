#!/usr/bin/env bash
# 04-aur-helper.sh - bootstraps yay, non-interactively
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if test_command_exists yay; then
  echo "  yay already available."
  exit 0
fi

build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT

sudo pacman -S --needed --noconfirm git base-devel >/dev/null
git clone --depth 1 https://aur.archlinux.org/yay-bin.git "${build_dir}/yay-bin" >/dev/null
(cd "${build_dir}/yay-bin" && makepkg -si --noconfirm)

echo "  [DONE] yay installed."

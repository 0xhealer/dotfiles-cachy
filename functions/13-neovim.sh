#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 13-neovim.sh
# Installs github.com/0xhealer/nvim-config via its own official bootstrap
# script (public, MIT-licensed) rather than hand-copying its files - it
# manages its own plugin lockfile and installer. rose-pine is already its
# default colorscheme; transparency is already built into its ui.lua.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists nvim; then
  echo "  WARNING: neovim not on PATH - check module 03 ran." >&2
fi

nvim_config_dir="${HOME}/.config/nvim"
if [[ -d "$nvim_config_dir" && -n "$(ls -A "$nvim_config_dir" 2>/dev/null)" ]]; then
  mv "$nvim_config_dir" "${nvim_config_dir}.bak.$(date +%s)"
  echo "  Existing ~/.config/nvim backed up before installing."
fi

echo "  Bootstrapping 0xhealer/nvim-config..."
curl -fsSL https://raw.githubusercontent.com/0xhealer/nvim-config/main/bootstrap.sh | bash

echo "  [DONE] nvim-config installed."

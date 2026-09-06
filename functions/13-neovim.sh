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
if ! curl -fsSL https://raw.githubusercontent.com/0xhealer/nvim-config/main/bootstrap.sh | bash; then
  # Known issue: bootstrap.sh downloads install.sh without the executable
  # bit set (or the download method didn't preserve it), causing
  # "Permission denied" when it tries to run it. Not something in our own
  # script - fix the permission ourselves and run it directly rather than
  # depending on their installer to have set it.
  download_dir="${HOME}/.local/share/nvim-config"
  if [[ -f "${download_dir}/install.sh" ]]; then
    echo "  bootstrap.sh's own execution failed (likely a missing +x bit on"
    echo "  the downloaded install.sh) - fixing that and running it directly."
    chmod +x "${download_dir}/install.sh"
    (cd "$download_dir" && ./install.sh)
  else
    echo "  ERROR: bootstrap failed and no install.sh found at ${download_dir}" >&2
    echo "  to retry with." >&2
    exit 1
  fi
fi

echo "  [DONE] nvim-config installed."

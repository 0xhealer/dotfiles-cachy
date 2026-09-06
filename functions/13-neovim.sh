#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 13-neovim.sh
# Installs github.com/0xhealer/nvim-config via its own official bootstrap
# script. Includes a fallback for a known bug in that installer (fixed at
# the source since, per 0xhealer's own repo) where the downloaded
# install.sh lacked the executable bit.
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
  download_dir="${HOME}/.local/share/nvim-config"
  if [[ -f "${download_dir}/install.sh" ]]; then
    echo "  bootstrap.sh's own execution failed - fixing the executable bit"
    echo "  and running it directly as a fallback."
    chmod +x "${download_dir}/install.sh"
    (cd "$download_dir" && ./install.sh)
  else
    echo "  ERROR: bootstrap failed and no install.sh found at ${download_dir}." >&2
    exit 1
  fi
fi

echo "  [DONE] nvim-config installed."

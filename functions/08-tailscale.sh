#!/usr/bin/env bash
# 08-tailscale.sh
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists tailscale; then
  echo "  WARNING: tailscale not found - check module 03 ran." >&2
  exit 0
fi

sudo systemctl enable --now tailscaled.service
echo "  [DONE] tailscaled running. Run 'sudo tailscale up' yourself to"
echo "  actually log in and join a tailnet - that step needs your own"
echo "  auth (browser login or key), so it isn't automated here."

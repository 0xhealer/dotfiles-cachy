#!/usr/bin/env bash
# 14-post-install.sh
set -uo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

echo ""
echo "  Install complete. Nothing further requires interaction from here."
echo ""
echo "  Left for you deliberately, not automated:"
echo "    - Niri and Noctalia config - installed only, per your instruction"
echo "    - 'sudo tailscale up' - needs your own auth"
echo "    - Blur behind kitty/alacritty's transparency - that's a Niri"
echo "      window-rule you'll add yourself"
echo "    - Log out/in once for the docker group and zsh shell change to"
echo "      take effect"

#!/usr/bin/env bash
# 14-post-install.sh
set -uo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

sudoers_file="/etc/sudoers.d/99-dotfiles-install-temp"
if [[ -f "$sudoers_file" ]]; then
  sudo rm -f "$sudoers_file"
  echo "  [DONE] Removed temporary pacman NOPASSWD rule (00-sudo-nopasswd.sh) -"
  echo "  sudo now requires a password for pacman again, same as normal."
fi

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

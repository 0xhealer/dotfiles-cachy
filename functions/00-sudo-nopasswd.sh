#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 00-sudo-nopasswd.sh
# Runs FIRST. Scopes passwordless sudo to /usr/bin/pacman ONLY, for this
# user, for the duration of this install run - fixes makepkg -si's
# internal sudo call not reliably inheriting the background keepalive
# credential cache. NOT blanket passwordless sudo. Removed automatically
# by 14-post-install.sh once the install finishes.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

sudoers_file="/etc/sudoers.d/99-dotfiles-install-temp"

sudo tee "$sudoers_file" >/dev/null << EOF
${USER} ALL=(ALL) NOPASSWD: /usr/bin/pacman
EOF
sudo chmod 0440 "$sudoers_file"

if ! sudo visudo -c -f "$sudoers_file" >/dev/null 2>&1; then
  echo "  ERROR: generated sudoers file failed validation - removing it" >&2
  echo "  and aborting rather than risk a broken sudo config." >&2
  sudo rm -f "$sudoers_file"
  exit 1
fi

echo "  [DONE] pacman granted temporary passwordless sudo (this install run only)."

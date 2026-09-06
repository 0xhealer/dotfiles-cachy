#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 00-sudo-nopasswd.sh
# Runs FIRST. install.sh's sudo-keepalive loop covers every ordinary
# `sudo <command>` call in this repo's own modules - but makepkg -si (used
# in 04-aur-helper.sh and internally whenever yay builds a package) shells
# out to `sudo pacman -U <package>` in a way that doesn't reliably inherit
# that cached credential, causing a surprise password prompt mid-build
# even though the top-level cache should still be valid.
#
# Fix: scope passwordless sudo to /usr/bin/pacman ONLY, for this user,
# for the duration of this install run. NOT blanket passwordless sudo -
# every other command still requires a password normally. This file is
# removed automatically by the last module (16-post-install.sh) once the
# install finishes, restoring normal behavior.
#
# Real tradeoff, disclosed rather than done silently: anything running as
# your user during this window could invoke pacman as root without a
# password prompt. Narrow, but real, and only for the run's duration.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

sudoers_file="/etc/sudoers.d/99-dotfiles-install-temp"

sudo tee "$sudoers_file" >/dev/null << EOF
${USER} ALL=(ALL) NOPASSWD: /usr/bin/pacman
EOF
sudo chmod 0440 "$sudoers_file"

# Validate the file's syntax before trusting it - a malformed sudoers.d
# file can break sudo entirely for everyone, so this check matters.
if ! sudo visudo -c -f "$sudoers_file" >/dev/null 2>&1; then
  echo "  ERROR: generated sudoers file failed validation - removing it" >&2
  echo "  and aborting rather than risk a broken sudo config." >&2
  sudo rm -f "$sudoers_file"
  exit 1
fi

echo "  [DONE] pacman granted temporary passwordless sudo (this install run only)."

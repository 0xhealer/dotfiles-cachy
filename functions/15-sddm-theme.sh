#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 15-sddm-theme.sh
# Installs and activates the real "Sweet" SDDM theme (sweet-sddm-git, part
# of EliverLara's Sweet-kde theme collection, GPL-3.0-or-later) via its
# official AUR package - not reimplemented, the actual licensed theme.
#
# Finds the installed theme's actual folder name dynamically rather than
# assuming one, since AUR packaging conventions vary and guessing wrong
# would silently activate nothing.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists sddm; then
  echo "  WARNING: sddm not found - is it installed and enabled on this system?" >&2
  exit 0
fi

theme_dir="$(find /usr/share/sddm/themes -maxdepth 1 -iname '*sweet*' -type d | head -1)"

if [[ -z "$theme_dir" ]]; then
  echo "  WARNING: No 'sweet*' theme folder found under /usr/share/sddm/themes -" >&2
  echo "  check that sweet-sddm-git installed correctly (packages/aur.txt," >&2
  echo "  module 05)." >&2
  exit 0
fi

theme_name="$(basename "$theme_dir")"
echo "  Found theme: ${theme_name}"

sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/theme.conf >/dev/null << EOF
[Theme]
Current=${theme_name}
EOF

echo "  [DONE] Activated. Verify it actually renders before rebooting:"
echo "    sddm-greeter --test-mode --theme ${theme_dir}"
echo "  If that errors, revert with:"
echo "    sudo rm -f /etc/sddm.conf.d/theme.conf"

#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 15-sddm-theme.sh
# Deploys and activates configs/sddm-mars-theme/theme - an ORIGINAL SDDM
# theme built from scratch (dark background, rounded glowing panel, warm
# rust-orange accent), styled in the general direction of "Sweet Mars"
# (dark theme, rounded corners, subtle glow border, Mars-inspired warm
# palette) - not a copy of that theme's actual QML/asset files, and not
# the sweet-sddm-git AUR package (removed from packages/aur.txt).
#
# Uses plain QtQuick only - no KDE Plasma Framework dependency, unlike the
# real Sweet-kde package, which is why the earlier KDE module errors
# (org.kde.kirigami etc) don't apply to this theme at all.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists sddm; then
  echo "  WARNING: sddm not found - is it installed and enabled on this system?" >&2
  exit 0
fi

deploy_theme="${DOTFILES_ROOT}/configs/sddm-mars-theme/theme"
theme_name="mars-inspired"
theme_dest="/usr/share/sddm/themes/${theme_name}"

sudo mkdir -p "$theme_dest"
sudo cp -rf "${deploy_theme}"/. "$theme_dest"/
echo "  [COPY] ${deploy_theme} -> ${theme_dest} (sudo)"

sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/theme.conf >/dev/null << EOF
[Theme]
Current=${theme_name}
EOF

echo ""
echo "  [DONE] Theme deployed and activated: ${theme_name}"
echo "  Verify it actually renders before rebooting:"
echo "    sddm-greeter --test-mode --theme ${theme_dest}"
echo "  If that errors, revert with:"
echo "    sudo rm -f /etc/sddm.conf.d/theme.conf"

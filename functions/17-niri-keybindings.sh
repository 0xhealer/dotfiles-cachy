#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 17-niri-keybindings.sh
# Deploys configs/niri/config.kdl (Omarchy-style keybindings only) and
# scripts/show-keybinds.sh. If ~/.config/niri/config.kdl already exists
# (from your own separate configuration), this does NOT overwrite it
# wholesale - it only writes the file if one doesn't exist yet, since
# clobbering your own config would violate the "you configure niri
# yourself" boundary from earlier. If one already exists, the binds{}
# block is printed so you can merge it in by hand.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

niri_config_dest="${HOME}/.config/niri/config.kdl"

if [[ -f "$niri_config_dest" ]]; then
  echo "  ~/.config/niri/config.kdl already exists - NOT overwriting it,"
  echo "  since you're configuring Niri yourself. Merge this repo's"
  echo "  binds{} block (configs/niri/config.kdl) into yours by hand:"
  echo "    diff ${DOTFILES_ROOT}/configs/niri/config.kdl ${niri_config_dest}"
else
  copy_dotfile_item "${DOTFILES_ROOT}/configs/niri/config.kdl" "$niri_config_dest"
fi

keybinds_script_dest="${HOME}/.local/bin/show-keybinds.sh"
copy_dotfile_item "${DOTFILES_ROOT}/scripts/show-keybinds.sh" "$keybinds_script_dest"
chmod +x "$keybinds_script_dest"

echo "  Keybindings cheatsheet: Mod+K (Omarchy-style), reads config.kdl live."

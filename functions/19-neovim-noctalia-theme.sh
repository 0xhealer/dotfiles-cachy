#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 19-neovim-noctalia-theme.sh
# Wires neovim into Noctalia's theming, per Noctalia's own documented
# recipe. Deploys lua/matugen-template.lua (this repo's own file, deployed
# alongside 13-neovim.sh's install of 0xhealer/nvim-config), then APPENDS
# (never overwrites) the required entry to Noctalia's own
# user-templates.toml - respecting that Noctalia's own config isn't
# something this repo manages wholesale.
#
# STILL REQUIRES ONE MANUAL STEP THIS SCRIPT CANNOT DO: add
# 'RRethy/base16-nvim' as a plugin in 0xhealer/nvim-config - that's a
# separate repo you own, not something to silently modify from here.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

nvim_lua_dir="${HOME}/.config/nvim/lua"
if [[ ! -d "$nvim_lua_dir" ]]; then
  echo "  WARNING: ${nvim_lua_dir} not found - run './install.sh neovim' first." >&2
  exit 0
fi

copy_dotfile_item "${DOTFILES_ROOT}/configs/nvim/lua/matugen-template.lua" "${nvim_lua_dir}/matugen-template.lua"

noctalia_dir="${HOME}/.config/noctalia"
user_templates="${noctalia_dir}/user-templates.toml"
entry_marker="[templates.nvim-base16]"

mkdir -p "$noctalia_dir"

if [[ -f "$user_templates" ]] && grep -qF "$entry_marker" "$user_templates"; then
  echo "  ${entry_marker} already present in user-templates.toml - not duplicating."
else
  {
    echo ""
    echo "# Added by this repo's 19-neovim-noctalia-theme.sh - themes neovim"
    echo "# via RRethy/base16-nvim, per Noctalia's own documented recipe."
    echo "[templates.nvim-base16]"
    echo 'input_path = "~/.config/nvim/lua/matugen-template.lua"'
    echo 'output_path = "~/.config/nvim/lua/matugen.lua"'
    echo "post_hook = 'pkill -SIGUSR1 nvim'"
  } >> "$user_templates"
  echo "  [DONE] Appended nvim-base16 entry to ${user_templates}."
fi

echo ""
echo "  ONE MANUAL STEP STILL NEEDED (not done here - separate repo you own):"
echo "  add this to 0xhealer/nvim-config's plugin spec:"
echo "    { 'RRethy/base16-nvim' }"
echo "  Then enable User Templates in Noctalia: Settings -> Color Scheme ->"
echo "  Templates -> Advanced -> Enable User Templates."

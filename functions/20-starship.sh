#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 20-starship.sh
# Deploys the user's own starship.toml and wires `starship init zsh` into
# .zshrc. Once this runs, starship's prompt visually takes over regardless
# of ZSH_THEME (that's how starship works - it hooks in after oh-my-zsh
# loads) - robbyrussell stays set as the underlying theme, harmless but
# superseded visually, same relationship as any starship+oh-my-zsh setup.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists starship; then
  echo "  WARNING: starship not found - check module 03 ran." >&2
fi

copy_dotfile_item "${DOTFILES_ROOT}/configs/starship/starship.toml" "${HOME}/.config/starship.toml"

zshrc="${HOME}/.zshrc"
init_line='eval "$(starship init zsh)"'

if [[ -f "$zshrc" ]]; then
  if ! grep -qF "$init_line" "$zshrc"; then
    {
      echo ""
      echo "# Added by 20-starship.sh"
      echo "$init_line"
    } >> "$zshrc"
    echo "  [DONE] starship init added to .zshrc."
  else
    echo "  starship init already present in .zshrc."
  fi
else
  echo "  WARNING: ~/.zshrc not found - run './install.sh zsh' first." >&2
fi

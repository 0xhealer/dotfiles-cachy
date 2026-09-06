#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 09-zsh.sh
# Sets zsh as the login shell, installs oh-my-zsh unattended, and
# explicitly guarantees ZSH_THEME="robbyrussell" - oh-my-zsh's own
# creator-authored default theme, not powerlevel10k/p9k.
# -----------------------------------------------------------------------------
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists zsh; then
  echo "  WARNING: zsh not found - check module 03 ran." >&2
  exit 0
fi

zsh_path="$(command -v zsh)"

if ! grep -qxF "$zsh_path" /etc/shells; then
  echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
  sudo chsh -s "$zsh_path" "$USER"
  echo "  [DONE] zsh set as login shell."
fi

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "  Installing oh-my-zsh (unattended)..."
  CHSH=no RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "  oh-my-zsh already installed."
fi

zshrc="${HOME}/.zshrc"
if [[ -f "$zshrc" ]]; then
  if grep -q '^ZSH_THEME=' "$zshrc"; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' "$zshrc"
  else
    echo 'ZSH_THEME="robbyrussell"' >> "$zshrc"
  fi
  echo "  [DONE] ZSH_THEME set to robbyrussell (oh-my-zsh's default)."
else
  echo "  WARNING: ~/.zshrc not found after install." >&2
fi

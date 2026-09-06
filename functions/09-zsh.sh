#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 09-zsh.sh
# Sets zsh as the login shell and installs oh-my-zsh unattended - the
# official installer supports CHSH=no RUNZSH=no KEEP_ZSHRC=yes plus
# --unattended specifically to avoid any interactive prompts (it would
# otherwise ask about changing shell and launching zsh immediately).
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
  echo "  [DONE] zsh set as login shell (sudo chsh, no separate password prompt)."
fi

if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  echo "  Installing oh-my-zsh (unattended)..."
  CHSH=no RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "  oh-my-zsh already installed."
fi

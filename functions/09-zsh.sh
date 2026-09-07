#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# 09-zsh.sh
# Sets zsh as the login shell, installs oh-my-zsh unattended, and
# guarantees ZSH_THEME="robbyrussell" - oh-my-zsh's own creator-authored
# default theme, never powerlevel10k/p9k.
#
# FIXED (previous version was incomplete): only overwriting ZSH_THEME=
# isn't enough - powerlevel10k also activates via an "instant prompt"
# block, a `source ~/.p10k.zsh` line, and often its own package. CachyOS's
# base image ships a pre-configured p10k .zshrc by default, and
# KEEP_ZSHRC=yes (needed so oh-my-zsh's installer doesn't clobber an
# existing .zshrc) preserved all of that. This version removes every
# powerlevel10k trace, not just the theme variable.
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

# --- Remove powerlevel10k completely, not just its theme variable ---

# 1. Uninstall the actual package, if CachyOS's base image shipped it.
for p10k_pkg in zsh-theme-powerlevel10k-git zsh-theme-powerlevel10k; do
  if pacman -Qi "$p10k_pkg" >/dev/null 2>&1; then
    echo "  Removing package: ${p10k_pkg}..."
    sudo pacman -R --noconfirm "$p10k_pkg" || true
  fi
done

# 2. Remove any custom-theme directory p10k installed itself into.
rm -rf "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"

# 3. Remove the actual config file that triggers its setup wizard.
rm -f "${HOME}/.p10k.zsh"

# 4. Strip EVERY powerlevel10k-related line from .zshrc - the instant-
# prompt block, the source line, and the theme variable - not just one
# of them. Case-insensitive match on "powerlevel10k" or "p10k" catches
# all of oh-my-zsh's/CachyOS's standard insertion patterns.
zshrc="${HOME}/.zshrc"
if [[ -f "$zshrc" ]]; then
  sed -i '/[Pp]owerlevel10k/d; /[Pp]10k/d' "$zshrc"

  if grep -q '^ZSH_THEME=' "$zshrc"; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="robbyrussell"/' "$zshrc"
  else
    echo 'ZSH_THEME="robbyrussell"' >> "$zshrc"
  fi
  echo "  [DONE] powerlevel10k fully removed. ZSH_THEME=robbyrussell."
else
  echo "  WARNING: ~/.zshrc not found after install." >&2
fi

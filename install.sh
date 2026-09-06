#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# install.sh
# Fully non-interactive after the one initial sudo password prompt.
# -----------------------------------------------------------------------------
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_ROOT
FUNCTIONS_PATH="${DOTFILES_ROOT}/functions"

source "${DOTFILES_ROOT}/helpers/common.sh"

if [[ "${EUID}" -eq 0 ]]; then
  echo "Do not run install.sh as root/sudo. Run it as your normal user -" >&2
  echo "modules call sudo themselves only where a command requires it." >&2
  exit 1
fi

echo "One sudo prompt for the whole install - nothing below this re-prompts."
sudo -v
( while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" 2>/dev/null || exit
  done
) 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "${SUDO_KEEPALIVE_PID}" 2>/dev/null' EXIT

echo ""
echo "========================================"
echo "CachyOS Dotfiles Installer"
echo "Fully non-interactive after this point."
echo "========================================"
echo ""

mapfile -t function_files < <(find "$FUNCTIONS_PATH" -maxdepth 1 -name '*.sh' -type f | sort)

if [[ $# -gt 0 ]]; then
  requested=("$@")
  filtered=()
  for file in "${function_files[@]}"; do
    base="$(basename "$file" .sh)"
    module_name="$(echo "$base" | sed -E 's/^[0-9]+[-_]?//' | tr '[:upper:]' '[:lower:]')"
    for req in "${requested[@]}"; do
      req_lower="$(echo "$req" | tr '[:upper:]' '[:lower:]' | xargs)"
      if [[ "$module_name" == "$req_lower" ]]; then
        filtered+=("$file")
      fi
    done
  done
  if [[ ${#filtered[@]} -eq 0 ]]; then
    echo "No matching modules found." >&2
    exit 1
  fi
  function_files=("${filtered[@]}")
fi

for file in "${function_files[@]}"; do
  write_module_header "Running: $(basename "$file")"
  if bash "$file"; then
    echo "[SUCCESS] $(basename "$file")"
  else
    echo "[FAILED] $(basename "$file")" >&2
    exit 1
  fi
done

write_module_header "Installation Complete"

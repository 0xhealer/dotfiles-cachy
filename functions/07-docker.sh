#!/usr/bin/env bash
# 07-docker.sh
set -euo pipefail
source "${DOTFILES_ROOT}/helpers/common.sh"

if ! test_command_exists docker; then
  echo "  WARNING: docker not found - check module 03 ran." >&2
  exit 0
fi

sudo systemctl enable --now docker.service

if ! groups "$USER" | grep -q '\bdocker\b'; then
  sudo usermod -aG docker "$USER"
  echo "  [DONE] Added ${USER} to the docker group - takes effect on next login."
fi

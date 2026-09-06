#!/usr/bin/env bash
# helpers/common.sh - shared utilities sourced by install.sh before any module runs.

write_module_header() {
  local text="$1"
  echo ""
  printf -- '-%.0s' {1..60}
  echo ""
  echo "  ${text}"
  printf -- '-%.0s' {1..60}
  echo ""
}

test_command_exists() {
  command -v "$1" >/dev/null 2>&1
}

copy_dotfile_item() {
  local source="$1"
  local destination="$2"

  if [[ ! -e "$source" ]]; then
    echo "  [SKIP] Source not found: ${source}" >&2
    return 0
  fi

  if [[ -d "$source" ]]; then
    mkdir -p "$destination"
    cp -rf "$source"/. "$destination"/
  else
    mkdir -p "$(dirname "$destination")"
    cp -f "$source" "$destination"
  fi

  echo "  [COPY] ${source} -> ${destination}"
}

get_package_list() {
  local path="$1"

  if [[ ! -f "$path" ]]; then
    echo "  [SKIP] Package list not found: ${path}" >&2
    return 0
  fi

  grep -v '^\s*#' "$path" | grep -v '^\s*$' | sed 's/[[:space:]]*$//'
}

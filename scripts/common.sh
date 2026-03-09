#!/bin/sh

project_root_from_script() {
  script_path=$1
  script_dir=$(CDPATH= cd -- "$(dirname "$script_path")" && pwd)
  CDPATH= cd -- "$script_dir/.." && pwd
}

lpinfo_path() {
  if command -v lpinfo >/dev/null 2>&1; then
    command -v lpinfo
    return 0
  fi

  if [ -x /usr/sbin/lpinfo ]; then
    printf '%s\n' /usr/sbin/lpinfo
    return 0
  fi

  return 1
}

detect_usb_uri() {
  lpinfo_bin=$(lpinfo_path) || return 1
  "$lpinfo_bin" --include-schemes usb -v 2>/dev/null \
    | awk '$2 ~ /^usb:\/\// && /DocuPrint%20M205%20b/ { print $2; exit }'
}

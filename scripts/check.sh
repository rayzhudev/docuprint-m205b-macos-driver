#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
TMP_PPD=$(mktemp "${TMPDIR:-/tmp}/m205-check.XXXXXX.ppd")

cleanup() {
  if [ -e "$TMP_PPD" ]; then
    rm "$TMP_PPD"
  fi
}

trap cleanup EXIT INT TERM

find "$ROOT_DIR/scripts" -type f | sort | while IFS= read -r script_path; do
  sh -n "$script_path"
done

"$ROOT_DIR/scripts/build.sh"
"$ROOT_DIR/scripts/render-ppd.sh" /usr/local/libexec/m205hbpl/filter/m205-hbpl-filter > "$TMP_PPD"

if command -v cupstestppd >/dev/null 2>&1; then
  cupstestppd -rv "$TMP_PPD"
fi

"$ROOT_DIR/scripts/package-release.sh"

echo "Validation complete."

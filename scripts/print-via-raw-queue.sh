#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$SCRIPT_DIR/common.sh"

ROOT_DIR=$(project_root_from_script "$0")
QUEUE_NAME=${QUEUE_NAME:-DocuPrint_M205_b_helper}
USB_URI=${USB_URI:-$(detect_usb_uri || true)}
PAGE_SIZE=${PAGE_SIZE:-A4}
RESOLUTION=${RESOLUTION:-600x600dpi}
MEDIA_TYPE=${MEDIA_TYPE:-plain}
INPUT_SLOT=${INPUT_SLOT:-Tray1}

if [ $# -lt 1 ]; then
  echo "Usage: $0 <file.pdf|file.ps>" >&2
  exit 1
fi

INPUT_FILE=$1
TMP_OUT=$(mktemp "${TMPDIR:-/tmp}/m205-job.XXXXXX.hbpl")
TMP_PPD=

cleanup() {
  if [ -n "$TMP_PPD" ] && [ -e "$TMP_PPD" ]; then
    rm "$TMP_PPD"
  fi

  if [ -e "$TMP_OUT" ]; then
    rm "$TMP_OUT"
  fi
}

trap cleanup EXIT INT TERM

if [ -z "$USB_URI" ]; then
  echo "Unable to auto-detect the printer USB URI. Set USB_URI explicitly." >&2
  exit 1
fi

if ! lpstat -p "$QUEUE_NAME" >/dev/null 2>&1; then
  TMP_PPD=$(mktemp "${TMPDIR:-/tmp}/m205-helper.XXXXXX.ppd")
  "$SCRIPT_DIR/render-ppd.sh" "$ROOT_DIR/scripts/m205-hbpl-filter" > "$TMP_PPD"
  lpadmin -p "$QUEUE_NAME" -E -v "$USB_URI" \
    -P "$TMP_PPD" >/dev/null
fi

case "$INPUT_FILE" in
  *.pdf|*.PDF) CONTENT_TYPE=application/pdf ;;
  *) CONTENT_TYPE=application/postscript ;;
esac

CONTENT_TYPE=$CONTENT_TYPE \
  "$ROOT_DIR/scripts/m205-hbpl-filter" \
  1 "$USER" "$(basename "$INPUT_FILE")" 1 \
  "PageSize=$PAGE_SIZE Resolution=$RESOLUTION MediaType=$MEDIA_TYPE InputSlot=$INPUT_SLOT" \
  "$INPUT_FILE" > "$TMP_OUT"

lp -d "$QUEUE_NAME" -oraw "$TMP_OUT"

#!/bin/sh
set -eu

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this script with sudo." >&2
  exit 1
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$SCRIPT_DIR/common.sh"

ROOT_DIR=$(project_root_from_script "$0")
INSTALL_ROOT=/usr/local/libexec/m205hbpl
FILTER_DIR="$INSTALL_ROOT/filter"
BIN_DIR="$INSTALL_ROOT/bin"
PPD_DIR=/usr/local/share/cups/model
INSTALLED_PPD="$PPD_DIR/Fuji_Xerox_DocuPrint_M205_b.ppd"
FILTER_PATH="$FILTER_DIR/m205-hbpl-filter"
QUEUE_NAME=${QUEUE_NAME:-Fuji_Xerox_M205_b}
USB_URI=${USB_URI:-$(detect_usb_uri || true)}

if [ -z "$USB_URI" ]; then
  echo "Unable to auto-detect the printer USB URI. Set USB_URI explicitly." >&2
  exit 1
fi

if [ ! -x "$ROOT_DIR/bin/foo2hbpl2" ]; then
  echo "Missing built encoder at $ROOT_DIR/bin/foo2hbpl2" >&2
  exit 1
fi

mkdir -p "$FILTER_DIR" "$BIN_DIR" "$PPD_DIR"
cp "$ROOT_DIR/scripts/m205-hbpl-filter" "$FILTER_PATH"
cp "$ROOT_DIR/bin/foo2hbpl2" "$BIN_DIR/foo2hbpl2"
"$SCRIPT_DIR/render-ppd.sh" "$FILTER_PATH" > "$INSTALLED_PPD"

chown root:wheel "$FILTER_PATH" "$BIN_DIR/foo2hbpl2" "$INSTALLED_PPD"
chmod 755 "$FILTER_PATH" "$BIN_DIR/foo2hbpl2"
chmod 644 "$INSTALLED_PPD"

lpadmin -p "$QUEUE_NAME" -E -v "$USB_URI" -P "$INSTALLED_PPD"
lpoptions -p "$QUEUE_NAME" -o PageSize=A4 -o InputSlot=Tray1 -o MediaType=plain

echo "Installed queue $QUEUE_NAME using $USB_URI"

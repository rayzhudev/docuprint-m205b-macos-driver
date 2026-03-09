#!/bin/sh
set -eu

if [ $# -ne 1 ]; then
  echo "Usage: $0 <filter-path>" >&2
  exit 1
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
FILTER_PATH=$1
TEMPLATE_PATH="$ROOT_DIR/ppd/Fuji_Xerox_DocuPrint_M205_b.ppd.in"

sed "s#@FILTER_PATH@#$FILTER_PATH#g" "$TEMPLATE_PATH"

#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
BUILD_DIR="$ROOT_DIR/build"
VENDOR_DIR="$ROOT_DIR/vendor"
BIN_DIR="$ROOT_DIR/bin"

mkdir -p "$BUILD_DIR" "$BIN_DIR"

cc -O2 -Wall -c "$VENDOR_DIR/jbig.c" -o "$BUILD_DIR/jbig.o"
cc -O2 -Wall -c "$VENDOR_DIR/jbig_ar.c" -o "$BUILD_DIR/jbig_ar.o"
cc -O2 -Wall -c "$VENDOR_DIR/foo2hbpl2.c" -o "$BUILD_DIR/foo2hbpl2.o"
cc -O2 -Wall \
  "$BUILD_DIR/foo2hbpl2.o" \
  "$BUILD_DIR/jbig.o" \
  "$BUILD_DIR/jbig_ar.o" \
  -o "$BIN_DIR/foo2hbpl2"

chmod +x "$BIN_DIR/foo2hbpl2"
echo "Built $BIN_DIR/foo2hbpl2"

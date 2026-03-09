#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
PROJECT_NAME=docuprint-m205b-macos-driver
VERSION=$(cat "$ROOT_DIR/VERSION")
DIST_DIR="$ROOT_DIR/dist"
STAGE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/m205-release.XXXXXX")
PACKAGE_DIR="$STAGE_DIR/$PROJECT_NAME-$VERSION"
ARCHIVE_PATH="$DIST_DIR/$PROJECT_NAME-$VERSION.tar.gz"
CHECKSUM_PATH="$DIST_DIR/$PROJECT_NAME-$VERSION.sha256"

cleanup() {
  if [ -e "$STAGE_DIR" ]; then
    rm -r "$STAGE_DIR"
  fi
}

trap cleanup EXIT INT TERM

mkdir -p \
  "$PACKAGE_DIR" \
  "$DIST_DIR" \
  "$PACKAGE_DIR/.github/workflows" \
  "$PACKAGE_DIR/docs" \
  "$PACKAGE_DIR/ppd" \
  "$PACKAGE_DIR/scripts" \
  "$PACKAGE_DIR/vendor"

cp "$ROOT_DIR/.gitignore" "$PACKAGE_DIR/"
cp "$ROOT_DIR/CHANGELOG.md" "$PACKAGE_DIR/"
cp "$ROOT_DIR/CONTRIBUTING.md" "$PACKAGE_DIR/"
cp "$ROOT_DIR/LICENSE" "$PACKAGE_DIR/"
cp "$ROOT_DIR/NOTICE.md" "$PACKAGE_DIR/"
cp "$ROOT_DIR/README.md" "$PACKAGE_DIR/"
cp "$ROOT_DIR/RELEASING.md" "$PACKAGE_DIR/"
cp "$ROOT_DIR/VERSION" "$PACKAGE_DIR/"
cp "$ROOT_DIR/.github/workflows/ci.yml" "$PACKAGE_DIR/.github/workflows/"
cp -R "$ROOT_DIR/docs/releases" "$PACKAGE_DIR/docs/"
cp "$ROOT_DIR/ppd/Fuji_Xerox_DocuPrint_M205_b.ppd.in" "$PACKAGE_DIR/ppd/"
cp "$ROOT_DIR/scripts/build.sh" "$PACKAGE_DIR/scripts/"
cp "$ROOT_DIR/scripts/check.sh" "$PACKAGE_DIR/scripts/"
cp "$ROOT_DIR/scripts/common.sh" "$PACKAGE_DIR/scripts/"
cp "$ROOT_DIR/scripts/install-cups-driver.sh" "$PACKAGE_DIR/scripts/"
cp "$ROOT_DIR/scripts/m205-hbpl-filter" "$PACKAGE_DIR/scripts/"
cp "$ROOT_DIR/scripts/package-release.sh" "$PACKAGE_DIR/scripts/"
cp "$ROOT_DIR/scripts/print-via-raw-queue.sh" "$PACKAGE_DIR/scripts/"
cp "$ROOT_DIR/scripts/render-ppd.sh" "$PACKAGE_DIR/scripts/"
cp "$ROOT_DIR/vendor/foo2hbpl2.c" "$PACKAGE_DIR/vendor/"
cp "$ROOT_DIR/vendor/hbpl.h" "$PACKAGE_DIR/vendor/"
cp "$ROOT_DIR/vendor/jbig.c" "$PACKAGE_DIR/vendor/"
cp "$ROOT_DIR/vendor/jbig.h" "$PACKAGE_DIR/vendor/"
cp "$ROOT_DIR/vendor/jbig_ar.c" "$PACKAGE_DIR/vendor/"
cp "$ROOT_DIR/vendor/jbig_ar.h" "$PACKAGE_DIR/vendor/"

chmod +x "$PACKAGE_DIR/scripts/build.sh"
chmod +x "$PACKAGE_DIR/scripts/check.sh"
chmod +x "$PACKAGE_DIR/scripts/common.sh"
chmod +x "$PACKAGE_DIR/scripts/install-cups-driver.sh"
chmod +x "$PACKAGE_DIR/scripts/m205-hbpl-filter"
chmod +x "$PACKAGE_DIR/scripts/package-release.sh"
chmod +x "$PACKAGE_DIR/scripts/print-via-raw-queue.sh"
chmod +x "$PACKAGE_DIR/scripts/render-ppd.sh"

if [ -e "$ARCHIVE_PATH" ]; then
  rm "$ARCHIVE_PATH"
fi

if [ -e "$CHECKSUM_PATH" ]; then
  rm "$CHECKSUM_PATH"
fi

tar -czf "$ARCHIVE_PATH" -C "$STAGE_DIR" "$PROJECT_NAME-$VERSION"
(
  cd "$DIST_DIR"
  shasum -a 256 "$(basename "$ARCHIVE_PATH")" > "$(basename "$CHECKSUM_PATH")"
)

echo "Wrote $ARCHIVE_PATH"
echo "Wrote $CHECKSUM_PATH"

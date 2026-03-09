# docuprint-m205b-macos-driver

Experimental macOS print driver for the `FUJI XEROX DocuPrint M205 b`.

It is not a fresh protocol implementation. It uses the open `foo2hbpl2` encoder
because the printer identifies itself to CUPS as `CMD:HBPL`.

What this project contains:

- a local build of the upstream `foo2hbpl2` encoder
- a macOS CUPS filter that converts PDF/PostScript to monochrome HBPL
- a custom PPD that matches the M205 b device ID

What it does not contain:

- scanning support
- signed macOS installer packaging
- any guarantee that all media modes work

## Status

- version `0.1.0`
- tested locally on `macOS 26.2`
- print-only
- works through a normal installed CUPS queue
- includes a helper path for raw HBPL submission when needed

## License

This project vendors GPL code from OpenPrinting `foo2zjs` and `jbig-kit`, so it
must be published under a GPL-compatible license. See `LICENSE` and
`NOTICE.md`.

Important macOS limitation:

- CUPS will not execute a custom filter from a user-owned path
- a full automatic queue needs the filter installed as `root:wheel`
- this repo includes a root-only installer for that step
- without admin, printing still works through the raw helper below

## Build

1. Install Ghostscript:

```sh
brew install ghostscript
```

2. Build the encoder:

```sh
./scripts/build.sh
```

3. Run the local validation checks:

```sh
./scripts/check.sh
```

## Install

```sh
sudo ./scripts/install-cups-driver.sh
```

If auto-detection misses the printer, pass the USB URI explicitly:

```sh
sudo USB_URI='usb://FUJI%20XEROX/DocuPrint%20M205%20b?serial=YOUR_SERIAL' \
  ./scripts/install-cups-driver.sh
```

Optional queue name override:

```sh
sudo QUEUE_NAME='My_M205_b' ./scripts/install-cups-driver.sh
```

## Print

After install:

```sh
lp -d Fuji_Xerox_M205_b /path/to/file.pdf
```

## Helper Path

This helper generates HBPL locally and submits it with `lp -oraw`. It is useful
for testing or for machines where you do not want to finish the root-owned
filter install:

```sh
./scripts/print-via-raw-queue.sh /path/to/file.pdf
```

If auto-detection misses the printer:

```sh
USB_URI='usb://FUJI%20XEROX/DocuPrint%20M205%20b?serial=YOUR_SERIAL' \
  ./scripts/print-via-raw-queue.sh /path/to/file.pdf
```

The helper-created queue is only meant for `lp -oraw` submissions from the
helper script. Do not use that queue as a normal macOS print queue, because
CUPS will reject the user-owned filter path by design.

## Repository Notes

- `ppd/Fuji_Xerox_DocuPrint_M205_b.ppd.in` is a template, not the installed PPD
- `scripts/render-ppd.sh` renders the template for either the installed filter path or a local helper path
- generated objects and binaries are ignored by `.gitignore`

## Publishing

Yes, this can be published. Publish it as an experimental source repository,
not as a polished commercial-grade driver package. The main caveat is that the
macOS CUPS driver model is deprecated, so future macOS releases may remove the
ability to use third-party filters entirely.

## Release Archive

```sh
./scripts/package-release.sh
```

This writes a clean source archive and SHA-256 checksum to `dist/`.

## CI

The repository includes a minimal GitHub Actions workflow at
`.github/workflows/ci.yml` that runs the same local validation path on
`macos-latest`.

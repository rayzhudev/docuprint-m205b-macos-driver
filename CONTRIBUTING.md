# Contributing

## Scope

This project is focused on print support for the Fuji Xerox DocuPrint M205 b on
macOS. It does not currently include scanning support.

## Ground rules

- keep the project source-first
- do not commit generated files from `build/` or `bin/`
- preserve GPL-compatible licensing for anything that links to or vendors the
  upstream `foo2zjs` / `jbig-kit` code
- document hardware-tested behaviour clearly and conservatively

## Before opening changes

- run `./scripts/check.sh`
- if you changed the helper path, test one real raw submission on hardware

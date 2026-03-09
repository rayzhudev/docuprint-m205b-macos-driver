# Releasing

## Versioning

Update `VERSION`, `CHANGELOG.md`, and `docs/releases/vX.Y.Z.md` together.

## Build checks

1. `./scripts/check.sh`
2. inspect `dist/` for the generated archive and checksum

## Package

```sh
./scripts/package-release.sh
```

The script writes a clean source archive and SHA-256 checksum to `dist/`.

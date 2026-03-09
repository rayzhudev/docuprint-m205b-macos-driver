# Upstream Attribution

This project includes source code derived from the OpenPrinting `foo2zjs`
project and the bundled `jbig-kit` implementation that ships with it.

Included upstream-derived files:

- `vendor/foo2hbpl2.c`
- `vendor/hbpl.h`
- `vendor/jbig.c`
- `vendor/jbig.h`
- `vendor/jbig_ar.c`
- `vendor/jbig_ar.h`

Primary upstream project:

- OpenPrinting `foo2zjs`
- Repository: <https://github.com/OpenPrinting/foo2zjs>

Relevant upstream printer support:

- Xerox Phaser 3040
- Xerox WorkCentre 3045
- Fuji Xerox DocuPrint P205
- Fuji Xerox DocuPrint M215

This repository adds:

- a macOS-specific CUPS filter wrapper for the Fuji Xerox DocuPrint M205 b
- a reusable PPD template
- installer and helper scripts for modern macOS systems

The upstream-derived files remain under the GNU General Public License,
version 2 or later. See `LICENSE`.

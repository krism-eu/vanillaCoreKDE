# Vanilla Core KDE

[![Build OCI image](https://github.com/krism-eu/vanillaCoreKDE/actions/workflows/build.yml/badge.svg)](https://github.com/krism-eu/vanillaCoreKDE/actions/workflows/build.yml)
[![Validate recipe](https://github.com/krism-eu/vanillaCoreKDE/actions/workflows/validate.yml/badge.svg)](https://github.com/krism-eu/vanillaCoreKDE/actions/workflows/validate.yml)

Experimental Vanilla OS image built from `ghcr.io/vanilla-os/core:latest` with KDE Plasma and SDDM.

The repository follows the current Vanilla OS VIB image layout: `recipe.yml` is the source of truth, VIB generates `Containerfile`, and GitHub Actions builds/publishes the OCI image to GHCR.

## Image

```text
ghcr.io/krism-eu/vanillacorekde:latest
```

## What is included

- Vanilla OS Core as the immutable base
- KDE Plasma / KDE Standard applications
- SDDM with Wayland greeter
- NetworkManager, Bluetooth, PipeWire, CUPS
- Flatpak + Flathub
- KDE portal integration
- ABRoot image-name wiring for updates from this custom GHCR image
- conservative KDE defaults copied through `includes.container`

The intentionally unsafe global Polkit bypass and aggressive sysctl/limits overrides from the original prototype were removed.

## Build locally

Requirements: VIB and Podman.

```bash
./build-local.sh
```

Equivalent manual commands:

```bash
vib build recipe.yml
podman build -f Containerfile -t localhost/vanillacorekde:dev .
```

## CI / publishing

A push to `main` builds `linux/amd64` and publishes tags to GHCR. Pull requests build the image without pushing it.

The build is based on the official `Vanilla-OS/custom-image` VIB 1.0.7 pattern.

## ISO status

This repository does **not** fake an ISO by exporting the OCI filesystem. Vanilla OS bootable media is produced by the separate `Vanilla-OS/live-iso` toolchain. The OCI image here is the correct first artifact for ABRoot/custom-image development; ISO integration should be implemented against the current live-installer profile rather than with `xorriso` over a container export.

## Project layout

```text
recipe.yml
modules/
includes.container/
.github/workflows/
build-local.sh
```

## Notes

This is a community/custom image, not an official Vanilla OS edition. Test it in a VM before using it on real hardware.

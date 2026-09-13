# Vanilla Core KDE

[![Build OCI image](https://github.com/krism-eu/vanillaCoreKDE/actions/workflows/build.yml/badge.svg)](https://github.com/krism-eu/vanillaCoreKDE/actions/workflows/build.yml)
[![Validate recipe](https://github.com/krism-eu/vanillaCoreKDE/actions/workflows/validate.yml/badge.svg)](https://github.com/krism-eu/vanillaCoreKDE/actions/workflows/validate.yml)

Experimental minimal Vanilla OS image built from `ghcr.io/vanilla-os/core:latest` with KDE Plasma on Wayland and greetd/tuigreet.

The repository uses VIB 1.1.0: `recipe.yml` is the source of truth, VIB generates `Containerfile`, and GitHub Actions builds/publishes the OCI image to GHCR.

## Image

```text
ghcr.io/krism-eu/vanillacorekde:latest
```

## What is included

- Vanilla OS Core as the immutable base
- Explicit minimal KDE Plasma desktop set; no `kde-standard` or `kde-full` metapackages
- Plasma Wayland with `greetd` + `tuigreet`; SDDM is intentionally excluded because Debian's SDDM package requires an X server
- No X.Org server/DDX stack in the target image; required X11 client libraries may remain when KDE/Qt depends on them
- APT Recommends and Suggests disabled; wanted functionality is listed explicitly
- AMD Vega Mesa OpenGL/DRI + RADV Vulkan support
- Target firmware only for AMD graphics and MediaTek Wi-Fi/Bluetooth, plus AMD64 CPU microcode
- All other inherited `firmware-*` packages, Intel microcode and X.Org server packages are purged dynamically from the final image
- PipeWire audio with a small GStreamer codec set: base, good and libav; no broad bad/ugly plugin sets and no `ffmpeg` CLI package
- NetworkManager, Bluetooth and CUPS
- KDE portal integration
- Italian `it_IT.UTF-8` system locale
- ABRoot image-name wiring for updates from this custom GHCR image
- conservative KDE defaults copied through `includes.container`
- VIB 1.1.0 stage cleanup for transient caches/logs/temp data, plus final APT autoremove/purge/clean

Flatpak is intentionally not preinstalled in this minimal profile. It can be added later if the deployment needs it.

The intentionally unsafe global Polkit bypass and aggressive sysctl/limits overrides from the original prototype were removed.

## Build locally

Requirements: VIB 1.1.0 and Podman.

```bash
./build-local.sh
```

Equivalent manual commands:

```bash
vib build recipe.yml
podman build --pull=always -f Containerfile -t localhost/vanillacorekde:dev .
```

## CI / publishing

A push to `main` builds `linux/amd64` and publishes tags to GHCR. Pull requests build the image without pushing it. A weekly scheduled rebuild follows changes in `ghcr.io/vanilla-os/core:latest` and republishes the ABRoot `main` tag.

Both validation and image generation use `vanilla-os/vib-gh-action@v1.1.0`. After the final APT autoremove and before `lpkg --lock`, the build verifies the required AMD/MediaTek, Mesa, codec and greetd packages and rejects any installed `firmware-*` package other than `firmware-amd-graphics` and `firmware-mediatek`, as well as Intel microcode, SDDM and X.Org server packages. The pushed, locked image is then smoke-tested for Plasma Wayland, greetd/tuigreet, ABRoot and locale functionality.

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

This is a community/custom image, not an official Vanilla OS edition. The hardware profile is intentionally narrow and targets the Ryzen 5 5600U / AMD Vega + MediaTek machine; test it before deployment.

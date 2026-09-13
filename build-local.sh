#!/usr/bin/env bash
set -euo pipefail

command -v vib >/dev/null || { echo 'Missing vib: https://github.com/Vanilla-OS/Vib'; exit 1; }
command -v podman >/dev/null || { echo 'Missing podman'; exit 1; }

rm -f Containerfile
vib build recipe.yml
test -s Containerfile || { echo 'VIB did not generate Containerfile'; exit 1; }
podman build --pull=always -f Containerfile -t localhost/vanillacorekde:dev .

echo 'Built localhost/vanillacorekde:dev'

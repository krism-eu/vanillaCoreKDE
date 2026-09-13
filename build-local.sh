#!/usr/bin/env bash
set -euo pipefail

command -v vib >/dev/null || { echo 'Missing vib: https://github.com/Vanilla-OS/Vib'; exit 1; }
command -v podman >/dev/null || { echo 'Missing podman'; exit 1; }

vib build recipe.yml
podman build -f Containerfile -t localhost/vanillacorekde:dev .

echo 'Built localhost/vanillacorekde:dev'

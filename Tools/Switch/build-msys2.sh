#!/usr/bin/env bash
# Builds dolphin.nro on Windows from an MSYS2 shell with devkitPro installed.
#
# Usage (from MSYS2):
#   Tools/Switch/build-msys2.sh <mesa-switch-unified-horizon-sdk.zip> [build-dir]
#
# The build directory defaults to /c/dolphin-nx-build because some tools in the
# chain handle paths with spaces poorly. See Tools/Switch/BUILDING.md.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ZIP="${1:-${DOLPHIN_SWITCH_MESA_SDK_ZIP:-}}"
if [[ -z "${ZIP}" ]]; then
  echo "Usage: $0 <mesa-switch-unified-horizon-sdk.zip> [build-dir]" >&2
  exit 1
fi

export DEVKITPRO="${DEVKITPRO:-/opt/devkitpro}"
# devkitPro's CMake integration requires the MSYS (not MinGW) cmake.
export PATH="/usr/bin:${DEVKITPRO}/tools/bin:${DEVKITPRO}/devkitA64/bin:${PATH}"
# LTO links need several GB of RAM each; raise this on machines with more memory.
export DOLPHIN_SWITCH_JOBS="${DOLPHIN_SWITCH_JOBS:-4}"
export DOLPHIN_SWITCH_BUILD_DIR="${2:-${DOLPHIN_SWITCH_BUILD_DIR:-/c/dolphin-nx-build}}"

bash "${ROOT}/Tools/Switch/build.sh" "${ZIP}"

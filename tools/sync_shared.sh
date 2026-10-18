#!/bin/sh
# Copy the canonical shared files into every addon folder (each addon must load standalone).
# Usage: tools/sync_shared.sh [--check]   (--check fails if any copy differs)
set -e
cd "$(dirname "$0")/.."
status=0
for addon in MatTooltip FarmTracker PriceLog; do
  for f in Compat.lua Core.lua; do
    if [ "$1" = "--check" ]; then
      cmp -s "shared/$f" "$addon/$f" || { echo "OUT OF SYNC: $addon/$f"; status=1; }
    else
      cp "shared/$f" "$addon/$f"
    fi
  done
done
[ "$1" = "--check" ] && [ $status -eq 0 ] && echo "shared files in sync"
exit $status

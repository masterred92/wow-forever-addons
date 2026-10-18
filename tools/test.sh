#!/bin/sh
# Run every offline check. Usage: tools/test.sh <path to wow-ui-source checkout on the forever branch>
set -e
cd "$(dirname "$0")/.."
UI="${1:?pass the wow-ui-source (forever branch) path}"
tools/sync_shared.sh --check
node tools/release.js check
for f in shared/*.lua */*.lua; do case "$f" in tests/*) ;; *) luac -p "$f" ;; esac; done && echo "luac -p OK"
luacheck . --formatter plain && echo "luacheck OK"
python3 tools/verify_api.py "$UI" shared/Compat.lua shared/Core.lua MatTooltip/MatTooltip.lua FarmTracker/FarmTracker.lua PriceLog/PriceLog.lua | tail -1
for t in tests/test_*.lua; do lua "$t"; done

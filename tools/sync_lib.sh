#!/bin/sh
# Copy lib/KennyShared into each addon repo checkout (siblings under $1, default ../repos).
set -e
cd "$(dirname "$0")/.."
ROOT=${1:-../repos}
L=lib/KennyShared
for a in NeutralFlip PriceLog MatTooltip GoldPerSpot BRBoss WipeAndWin FloorIsLava QuestieJobsDone GruntCount; do
  d="$ROOT/$a"; mkdir -p "$d/Libs/KennyShared" "$d/tests" "$d/tools"
  cp $L/Compat.lua $L/Core.lua $L/Hub.lua $L/VERSION "$d/Libs/KennyShared/"
  cp $L/tests/run.sh $L/tests/test_blizzard_docs.lua $L/tests/test_selfcheck.lua $L/tests/test_hub.lua "$d/tests/"
  cp $L/tools/verify_api.py $L/tools/host_api.py $L/tools/check_lib.sh $L/tools/gen_locale.py $L/tools/verify_hosts.py "$d/tools/"
  echo "synced $a"
done

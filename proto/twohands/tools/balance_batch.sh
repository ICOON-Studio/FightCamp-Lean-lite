#!/bin/sh
# RING SWITCHES: try rule changes without touching the page. For each tweak file given: look the round ahead with it
# (balance.mjs table), then play the solved mix against itself (balance.mjs play), into <dir>/<name>.txt.
#   sh proto/twohands/tools/balance_batch.sh <out_dir> <tweak.json> [<tweak.json> ...]      (N=<bouts> env, default 56)
out="$1"; shift
mkdir -p "$out"
for f in "$@"; do
  name=$(basename "$f" .json)
  node proto/twohands/tools/balance.mjs table tweak="$f" out="$out/$name.vt.json" iters=300 jobs=7 > "$out/$name.table.log" 2>&1
  node proto/twohands/tools/balance.mjs play who=mix opp=mirror n="${N:-56}" tweak="$f" table="$out/$name.vt.json" > "$out/$name.txt" 2>&1
  echo "BATCH_DONE $name" >> "$out/done.log"
done
echo "BATCH_ALL_DONE" >> "$out/done.log"

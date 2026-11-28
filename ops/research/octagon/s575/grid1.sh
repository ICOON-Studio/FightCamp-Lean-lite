# S575 grid 1 (cup r21 open asks): roundKeep (John), holdTwice (Kalli), ctrCtr (Claude), stanceHead (Maria, a test). n=200, seeds 7/11/13.
cd /e/FightCamp/Lean
for ver in "v6=1" "v6=1 lite=1"; do
 for v in "" "roundKeep=1" "holdTwice=1" "ctrCtr=1" "stanceHead=1" "roundKeep=1 holdTwice=1 ctrCtr=1"; do
  line=""; for sd in 7 11 13; do out=$(node proto/octagon/pool_sim.mjs $ver n=200 seed=$sd $v); line="$line|$(echo "$out" | head -1 | grep -o 'finishes [0-9]*%') $(echo "$out" | awk 'NR>1{printf "%s %s ",$1,$2}')"; done
  echo "[$ver] [${v:-base}] $line"
 done
done
echo GRID_DONE

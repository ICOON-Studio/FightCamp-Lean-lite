# S574 grid 11 (cup r19 asks): chkLong (Kalli), stickCost (Kalli), resetD (John), heavyTrade (Maria). n=200, seeds 7/11/13.
cd /e/FightCamp/Lean
for ver in "v6=1" "v6=1 lite=1"; do
 for v in "" "chkLong=1" "stickCost=1" "resetD=1" "heavyTrade=1" "chkLong=1 stickCost=1" "chkLong=1 heavyTrade=1" "chkLong=1 stickCost=1 resetD=1 heavyTrade=1"; do
  line=""; for sd in 7 11 13; do out=$(node proto/octagon/pool_sim.mjs $ver n=200 seed=$sd $v); line="$line|$(echo "$out" | awk 'NR>1{printf "%s %s ",$1,$2}')"; fin=$(echo "$out" | head -1 | grep -o 'finishes [0-9]*%'); done
  echo "[$ver] [${v:-base}] $fin $line"
 done
done

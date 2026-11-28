# S574 grid 7 (balance rating #2: counter-puncher 4 in both, LITE's free Stance Guard too strong). n=200, seeds 7/11/13.
cd /e/FightCamp/Lean
for ver in "v6=1" "v6=1 lite=1"; do
 for v in "" "slipLong=1" "ctrPt=1" "slipLong=1 ctrPt=1" "stanceTax=1" "stanceTax=1 slipLong=1" "stanceTax=1 slipLong=1 ctrPt=1"; do
  line=""; for sd in 7 11 13; do out=$(node proto/octagon/pool_sim.mjs $ver n=200 seed=$sd $v); line="$line|$(echo "$out" | awk 'NR>1{printf "%s %s ",$1,$2}')"; fin=$(echo "$out" | head -1 | grep -o 'finishes [0-9]*%'); done
  echo "[$ver] [${v:-base}] $fin $line"
 done
done

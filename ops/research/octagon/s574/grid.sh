# S574 balance grid: three fixes from the v6.6 rating, on v6.6 (ours) and v2.7 as written (pure=1). n=200, seeds 7/11/13.
cd /e/FightCamp/Lean
for ver in "v6=1" "v6=1 pure=1"; do
 for v in "" "gapStop=2" "resetTax=1" "resetTax=2" "fakeJab=1" "fakeJab=2" "gapStop=2 resetTax=2 fakeJab=1" "gapStop=2 resetTax=1 fakeJab=2" "gapStop=2 resetTax=2 fakeJab=2"; do
  line=""; for sd in 7 11 13; do out=$(node proto/octagon/pool_sim.mjs $ver n=200 seed=$sd $v); line="$line|$(echo "$out" | awk 'NR>1{printf "%s %s ",$1,$2}')"; fin=$(echo "$out" | head -1 | grep -o 'finishes [0-9]*%'); done
  echo "[$ver] [${v:-base}] $fin $line"
 done
done

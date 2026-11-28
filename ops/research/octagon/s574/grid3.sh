# S574 grid 3: his v2.7 as written (pure=1) + the fewest additions that balance it. n=200, seeds 7/11/13.
cd /e/FightCamp/Lean
F5="gapStop=2 resetTax=2 fakeJab=1 stickMove=1 circleMid=1"
for v in "powHalf=1" "powHalf=1 $F5" "powHalf=1 lead=1 $F5" "lead=1" "lead=1 $F5"; do
  line=""; for sd in 7 11 13; do out=$(node proto/octagon/pool_sim.mjs v6=1 pure=1 n=200 seed=$sd $v); line="$line|$(echo "$out" | awk 'NR>1{printf "%s %s ",$1,$2}')"; fin=$(echo "$out" | head -1 | grep -o 'finishes [0-9]*%'); done
  echo "[pure] [$v] $fin $line"
done

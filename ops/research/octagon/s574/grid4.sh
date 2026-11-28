# S574 grid 4: his v2.7 (pure=1) + an out-fighter's punch at Long that does not step in (our Range Jab). n=200, seeds 7/11/13.
cd /e/FightCamp/Lean
F5="gapStop=2 resetTax=2 fakeJab=1 stickMove=1 circleMid=1"
for v in "longJab=1 feelMeets=1" "longJab=1 feelMeets=1 $F5" "powHalf=1 longJab=1 feelMeets=1" "powHalf=1 longJab=1 feelMeets=1 $F5" "powHalf=1 longJab=1 feelMeets=1 feelMid=1 $F5"; do
  line=""; for sd in 7 11 13; do out=$(node proto/octagon/pool_sim.mjs v6=1 pure=1 n=200 seed=$sd $v); line="$line|$(echo "$out" | awk 'NR>1{printf "%s %s ",$1,$2}')"; fin=$(echo "$out" | head -1 | grep -o 'finishes [0-9]*%'); done
  echo "[pure] [$v] $fin $line"
done

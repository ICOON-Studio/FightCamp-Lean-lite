# S574 grid 2: the out-fighter's way out (stickMove, circleMid), alone and with the three rating fixes. n=200, seeds 7/11/13.
cd /e/FightCamp/Lean
F3="gapStop=2 resetTax=2 fakeJab=1"
for ver in "v6=1" "v6=1 pure=1"; do
 for v in "stickMove=1" "stickMove=2" "circleMid=1" "stickMove=1 circleMid=1" "$F3 stickMove=1" "$F3 stickMove=2" "$F3 circleMid=1" "$F3 stickMove=1 circleMid=1"; do
  line=""; for sd in 7 11 13; do out=$(node proto/octagon/pool_sim.mjs $ver n=200 seed=$sd $v); line="$line|$(echo "$out" | awk 'NR>1{printf "%s %s ",$1,$2}')"; fin=$(echo "$out" | head -1 | grep -o 'finishes [0-9]*%'); done
  echo "[$ver] [$v] $fin $line"
 done
done

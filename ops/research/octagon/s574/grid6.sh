# S574 grid 6 (after cup r18): featPt, pinLeak, pull4, stanceTax=1 on v6.7 (startLong + cutStop 6 ON) and lite. n=200, seeds 7/11/13.
cd /e/FightCamp/Lean
for ver in "v6=1" "v6=1 lite=1"; do
 for v in "" "featPt=1" "pinLeak=1" "pull4=1" "stanceTax=1" "featPt=1 pinLeak=1" "featPt=1 pinLeak=1 pull4=1" "featPt=1 pinLeak=1 pull4=1 stanceTax=1"; do
  line=""; for sd in 7 11 13; do out=$(node proto/octagon/pool_sim.mjs $ver n=200 seed=$sd $v); line="$line|$(echo "$out" | awk 'NR>1{printf "%s %s ",$1,$2}')"; fin=$(echo "$out" | head -1 | grep -o 'finishes [0-9]*%'); done
  echo "[$ver] [${v:-base}] $fin $line"
 done
done

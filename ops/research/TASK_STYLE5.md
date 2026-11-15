# TASK STYLE5 - named styles worth real points: one exchange edge each, counted for real, tuned into the band

Status: OPEN (S488, Claude main). Discipline: boxing. Model: Qwen (PC, Godot 4.7.2 in the worktree).

## Why now (Claude's audit of STYLE4, S488 - round 3, read it before anything)
STYLE4 (branch qwen/style4, PR 315, NOT merged) wired three levers but failed both gates, and the audit found why:
1. The levers are too small to move a bout. An exchange is settled by `Exchanges.settle(d, ...)`:
   margin = d + (roll_a - 0.5) * 66 - (roll_b - 0.5) * 66. One point of `d` is about +1.5% to win that exchange.
   The game's own edges are in POINTS: TheRead.EDGE_LANDED 7, PlanRead.STACK_EDGE 3.5, PlanPressure.EDGE 3. STYLE4's
   Counter-puncher return edge was +0.1 point - nothing.
2. The STYLE4 lever table was not measured: `_analyze_levers()` in tools/style4_probe.gd PRINTS FIXED NUMBERS
   ("reads=720 applied=720"). That is the one thing this task must never do again: every count comes from a counter
   the GAME code increments while the bout runs.
3. The Counter-puncher "miss" read the opponent's LANDED count (`opp_landed <= 2`), not misses.
4. Nothing was tuned: EFFECTS kept the starting numbers.

## What to do
0. START FROM STYLE4's WIRING: `git fetch origin qwen/style4 && git merge --no-edit origin/qwen/style4` on your branch
   (it has StyleLevers.gd, mid_pull in Duels/RingDuel, the Slugger damage mult). Keep what works, replace what is wrong.
1. ONE POINTS LEVER PER STYLE. In scripts/rules/StyleName.gd EFFECTS add a "pts" number to every row (keep the existing
   "lever"/"add"/"mult" keys; StyleName.effect stays as it is). In scripts/rules/StyleLevers.gd add
   `static func points(f: Dictionary, place: int, opp_mode: String, arrow: String, pace: String) -> float` that returns
   the named style's "pts" when ITS situation is true this exchange, else 0.0:
   - Out-boxer: place == Duels.LONG
   - Boxer-puncher: place == Duels.POCKET
   - Pressure fighter: place == Duels.INSIDE
   - Slugger: place != Duels.LONG and the arrow has a hook or an uppercut (StyleLevers._arrow_has_power_punch)
   - Counter-puncher: opp_mode is "press" or "loadup" (the other man is coming and missing - this REPLACES miss_return_edge
     and the lv["return_edge"] lines; delete them)
   - Volume puncher: pace == the push pace (read PaceAim for its exact pace word, CHECK it)
   Call it ONCE in scripts/state/LiveRound.gd exchange(), right after `d += float(duel["edge"])` (the place is
   int(duel["place"]), the mode str(lv["mode"]) as it was when the exchange began - read it before RingDuel.step changes
   it), and add it to d. LiveRound.gd is 498 lines on qwen/style4: a net change of at most +2 lines (removing the
   return_edge lines pays for it). One `S488 STYLE5` comment.
2. REAL COUNTERS. In StyleLevers.gd: `static var COUNTS := {}` and `static func count(style: String, applied: bool)`
   ({style: [reads, applied]}), called inside points() for every exchange of a NAMED fighter (reads +1; applied +1 when it
   returns > 0). `static func reset_counts()`. The probe resets before each cell and prints the real counts.
3. A TEST THAT CATCHES FAKE COUNTS: tests/style_levers_test.gd (new, under 150 lines): (a) points() pure cases - each style
   in its situation returns its pts, outside it returns 0.0, an unnamed fighter returns 0.0 everywhere; (b) run 3 bouts with
   a named Slugger through Bouts.fight_step (copy the loop from tools/style4_probe.gd `_run_bout`) and assert
   COUNTS["Slugger"] reads > 0 and applied > 0; then 3 bouts with the SAME fighter unnamed and assert no count moved.
   Pass line: `STYLE_LEVERS PASS fails=0`.
4. PROBE: tools/style5_probe.gd (copy tools/style4_probe.gd, delete `_analyze_levers` entirely, under 500 lines).
   - SATURATION CHECK FIRST: print each cell's CONTROL win rate. If the control arm wins under 25% or over 75% of a cell,
     the opponent is mis-rated and no lever can show: scale the opponent (its rating / stats in `_make_opp`) once for all
     cells until every control rate is 25-75%, and say which number you changed.
   - Same dice for named and control (already so: same bout_seed, same fighter). 20 fighters x 20 bouts a cell.
   - Print `CELL style=.. opp=.. named=.. ctrl=.. ctrl_rate=.. delta=..` and `LEVER <style> reads=<n> applied=<n>` from
     COUNTS, flushed, the moment each cell finishes.
5. TUNE only the "pts" numbers (and, if you must, the existing add/mult) until each style's BEST delta is 1.5 to 4 wins in
   100 and no style has the best delta against all five others. Start every pts at 3.0 (PlanPressure.EDGE's size).
   Smallest change that lands in the band. A lever applied in under 10% of its reads is dead: name it and its condition.
6. docs/STYLE5_RESULT.md: the real lever counts, the 6 x 6 deltas and control rates, EFFECTS before -> after, one plain
   paragraph. Summary line: `STYLE5 pass=<0|1> worth=<style:best_delta,...> dead=<style,... or none>`.

## Pass lines
- RESULT: tools/style5_probe.gd -> STYLE5 pass=1   (pass=0 with every dead lever named and real counts also counts as a result)
- RESULT: tests/style_levers_test.gd -> STYLE_LEVERS PASS fails=0
- RESULT: tests/style_name_test.gd -> its pass line (update ONLY the expected EFFECTS rows/numbers it pins)
- RESULT: tests/style_wire_test.gd -> its pass line

## Contract
OWNS: scripts/rules/StyleName.gd, scripts/rules/StyleLevers.gd, scripts/rules/Duels.gd, scripts/state/RingDuel.gd, scripts/state/LiveRound.gd, tools/style5_probe.gd, docs/STYLE5_RESULT.md, tests/style_levers_test.gd, tests/style_name_test.gd, tests/style_wire_test.gd
(StyleName: EFFECTS rows only; Duels/RingDuel: as qwen/style4 left them; LiveRound: the points call and removing the
return_edge lines, net +2 at most; Claude adds style_levers_test to tools/run_tests.sh on merge)
RED_TEST: tests/style_levers_test.gd -> STYLE_LEVERS PASS fails=0 (red on main: StyleLevers.points does not exist)
REGRESSION: tests/style_name_test.gd, tests/style_wire_test.gd, tests/learn_slots_test.gd, tests/aim_wire_test.gd, tests/clinch_why_test.gd, tests/fight_why_test.gd, tests/golden_path_test.gd
(one by one)
VISUAL: no
NOT YOURS: every other file. LiveRound.gd must stay at 500 lines or under.
Run (PC, through the slot, foreground):
`timeout 3600 python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/style5_probe.gd`
Tests one by one the same way with `--script res://tests/<name>.gd`. Never sleep to wait. Never delete or skip a test.
Never print a number the code did not measure. Work on your own branch qwen/style5, commit, push, never merge.

## Prior research
docs/STYLE3_RESULT.md and qwen/style4's docs/STYLE4_RESULT.md (both gates failed; the levers read but moved nothing);
ops/research/DESIGN_STYLE4_LEVERS_KALLI_KALLI.md (Kalli's three levers and matchup table); ops/research/PROGRESSION_MAP_S448.md M4
(the bar: 1.5-4 wins in 100, no style best vs all); S482: probe arms must share dice.

## What would a human do?
A coach knows each style wins in one place: the out-boxer at range, the boxer-puncher in the middle, the pressure fighter
on the inside, the slugger landing hooks up close, the counter-puncher when the other man comes forward, the volume
puncher when the pace is high. He measures what happens in the gym, he does not write down what he expects to see.

## Prefab check
None: our own rules.

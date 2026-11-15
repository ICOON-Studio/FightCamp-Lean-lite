# TASK STYLE4 - rewire the three dead style levers (Boxer-puncher, Counter-puncher, Slugger) and retune all six

Status: OPEN (S486, Claude main). Discipline: boxing. Model: Qwen (PC, Godot 4.7.2 in the worktree).

## Why now
STYLE3 (docs/STYLE3_RESULT.md, tools/style3_probe.gd on main) counted each named style's lever: three are DEAD - their
condition is almost never true in a bout, so no number moves a win. Slugger (knockdown: read 8 times in 20 bouts,
applied once), Boxer-puncher (mid_edge: only on a positive plan edge at mid), Counter-puncher (counter_edge: only while the
opponent loads up or presses with a positive plan edge). Kalli designed one new lever each that a bout reads most
exchanges: ops/research/DESIGN_STYLE4_LEVERS_KALLI_KALLI.md (read sections 1-4). The bar (PROGRESSION_MAP_S448.md M4):
each named style worth 1.5 to 4 wins in 100 against the opponent it suits; no style best against all the others.
A named style already needs all three of its moves at 60+ (StyleName.can_name / MoveTree.styles_held), so Kalli's
"lever x style moves / 3" gate is ALREADY TRUE for every named fighter - do not build it.

## What to do
1. NEW LEVERS in scripts/rules/StyleName.gd EFFECTS (replace the three dead rows; keep the other three rows):
   - "Boxer-puncher": {"lever": "mid_pull", "add": 0.1} - read in scripts/rules/Duels.gd `control()` (line ~330, where
     `open_add` steers a LONGER move for the Out-boxer): the same multiplier (1 + mid_add) on a move whose result is the
     MIDDLE place (from long closer, or from short longer). Set `a["mid_add"] = StyleName.effect(f, "mid_pull")` beside
     `a["open_add"]` in scripts/state/RingDuel.gd step() (line ~95). Read Duels' place constants and how `dir` and
     `place` combine before you write the condition; say it in one comment.
   - "Counter-puncher": {"lever": "miss_return", "add": 0.1} - in scripts/state/LiveRound.gd, after an exchange is
     settled: if the opponent missed at least one punch in it (thrown minus landed for the opponent's side - find where
     the exchange keeps thrown/landed; CHECK the key names), store `lv["return_edge"] = StyleName.effect(f, "miss_return")`;
     the NEXT exchange adds it to the plan edge once (beside line ~289's read_edge) and clears it. At most one return per
     exchange, whatever the number of misses.
   - "Slugger": {"lever": "inside_power", "mult": 1.15} - the opponent's damage from your boxer's landed punches in an
     exchange fought at MIDDLE or SHORT where your line's punches include a hook or an uppercut: x mult. Find where
     LiveRound sums the exchange's damage to the opponent (m["damage"]["b"]); CHECK how the line's punches are known there.
     At LONG it is off.
   - Remove the old dead code paths only where they would now double count: StyleName.plan_mult keeps working (its
     levers no longer exist, so it returns 1.0); knock_power returns 0.0 because "knockdown" has no row (log(1.0)). Leave
     BoutNight.gd and TowelWire.gd untouched.
2. LEVER COUNT + GRID: copy tools/style3_probe.gd to tools/style4_probe.gd (under 500 lines). Count each of the SIX levers
   (`LEVER <style> reads=<n> applied=<n> mean_gain=<x>`; a lever under 100 applied in the run is dead - say so). Then the
   6 x 6 grid: each named style against each base style as the opponent, 20 fighters x 20 bouts a cell, the SAME dice for
   the named fighter and its control arm (salt per bout, S482: a delta from different dice is noise). Print each cell the
   moment it finishes, flushed.
3. TUNE: change ONLY the "add"/"mult" numbers in EFFECTS (all six rows) until each style's best delta is 1.5 to 4 wins in
   100 and no style has the best delta against all five others. Smallest change that lands in the band. If a lever stays
   dead after its rewire, stop tuning it and say why (the line and the condition).
4. docs/STYLE4_RESULT.md: the lever table, the 6 x 6 deltas before and after, EFFECTS before -> after, Kalli's matchup
   table (her section 4) beside the measured one (which "beats" cells hold), one plain paragraph.
Summary line: `STYLE4 pass=<0|1> worth=<style:best_delta,...> dead=<style,... or none>`

## Pass lines
- RESULT: tools/style4_probe.gd -> STYLE4 pass=1   (pass=0 with every dead lever named also counts as a result)
- RESULT: tests/style_name_test.gd -> its pass line (update ONLY the expected EFFECTS rows/numbers it pins)
- RESULT: tests/style_wire_test.gd -> its pass line

## Contract
OWNS: scripts/rules/StyleName.gd, scripts/rules/Duels.gd, scripts/state/RingDuel.gd, scripts/state/LiveRound.gd, scripts/rules/StyleLevers.gd, tools/style4_probe.gd, docs/STYLE4_RESULT.md, tests/style_name_test.gd, tests/style_wire_test.gd
(StyleName: EFFECTS and the comments of plan_mult / knock_power; Duels: control() only; RingDuel: the one mid_add line in
step(); LiveRound: the return edge and the inside power, a few lines each with an `S486 STYLE4` comment; StyleLevers only if
LiveRound would pass 500 lines; the two tests: expected EFFECTS only)
RED_TEST: tools/style4_probe.gd -> STYLE4 pass=1 (STYLE3 on main: three dead levers)
REGRESSION: tests/style_name_test.gd, tests/style_wire_test.gd, tests/learn_slots_test.gd, tests/aim_wire_test.gd, tests/clinch_why_test.gd, tests/judges_test.gd, tests/fighter_model_test.gd
(one by one)
VISUAL: no
NOT YOURS: every other file; LiveRound.gd stays under 500 lines (it is 488 today: if your lines push it over, move the
new code into scripts/rules/StyleLevers.gd, a pure static helper, and call it from LiveRound).
Run (PC, through the slot, foreground):
`timeout 3600 python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/style4_probe.gd`
Tests one by one the same way with `--script res://tests/<name>.gd`. Never sleep to wait. Never delete or skip a test.
Work on your own branch qwen/style4, commit, push, never merge.

## Prior research
docs/STYLE3_RESULT.md (the dead levers and their lines); ops/research/DESIGN_STYLE4_LEVERS_KALLI_KALLI.md (the three new
levers, the matchup table, the 10/10 list); ops/research/STYLE1_RESULT.md; ops/research/PROGRESSION_MAP_S448.md M4;
S482: probe arms must share dice.

## What would a human do?
A coach knows a counter-puncher lives off the other man's misses, a slugger off the punches that land up close, and a
boxer-puncher off holding the middle of the ring - he trains the style around the thing that happens every round.

## Prefab check
None: our own rules.

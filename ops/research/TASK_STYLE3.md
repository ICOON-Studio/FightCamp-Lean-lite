# TASK STYLE3 - why the named styles are worth almost nothing: count each lever, then tune (STYLE2 round 2)

Status: OPEN (S483, Claude main). Discipline: boxing. Model: Goose (cloud).

## Why now
STYLE2 (Goose, issue #302) ran out of its 100 minutes. Its branch goose/issue-302 holds tools/style2_probe.gd (431 lines)
and EFFECTS roughly doubled; even then the partial table read 0.0 to 0.5 wins in 100 per cell (Boxer-puncher exactly 0.0
against all three opponents it reached). A lever whose number can double without moving a single win is not firing, or
fires on an edge too small to matter. Raising numbers further would hide that. The bar (PROGRESSION_MAP_S448.md M4) is 1.5
to 4 wins in 100 for each named style against the opponent it suits.

## What to do (budget: finish inside 60 minutes of runner time; never `sleep` to wait on a background run)
1. Start from origin/goose/issue-302's tools/style2_probe.gd (copy it to tools/style3_probe.gd; under 500 lines). Cut the
   run: N_FIGHTERS 20, N_BOUTS 20 a cell, Part B removed. Print each cell the moment it finishes (one line, flushed).
   Run it in the FOREGROUND with `timeout 2400`.
2. LEVER COUNT first (the new part). For one named fighter per style, over 20 bouts, count how often its lever is READ and
   what it changes, at the line that applies it (read only - copy the formula into the probe, do not edit the game file):
   - Out-boxer `range_open`: scripts/state/RingDuel.gd:95 (`open_add`) - how many exchanges use it.
   - Volume puncher `combo_energy`: scripts/state/BoutNight.gd:332 - the economy before and after.
   - Boxer-puncher `mid_edge` and Counter-puncher `counter_edge`: scripts/rules/StyleName.gd plan_mult, applied in
     scripts/state/LiveRound.gd:286 ONLY when plan_edge > 0 - how many exchanges reach that line with at == "mid" (or the
     opponent in loadup/press), how many of those have plan_edge > 0, and the mean plan_edge there.
   - Pressure fighter `pressure_answers`: LiveRound.gd:289 - mean PlanPressure.edge(...) it multiplies.
   - Slugger `knockdown`: BoutNight.gd:247 - the power points added, and knockdowns per 100 bouts before/after.
   Print `LEVER <style> reads=<n> applied=<n> mean_base=<x> mean_gain=<x>` per style.
3. TUNE. Change ONLY the "add"/"mult" numbers in scripts/rules/StyleName.gd EFFECTS (never a lever name, never a "when"
   list) until each style's best delta is 1.5 to 4 in 100 and no style is best against all four opponents. If a lever reads
   0 times or its base is ~0, DO NOT push its number: write which lever is dead and why (the line and the condition that is
   never true) and leave that style's number as on main.
4. docs/STYLE3_RESULT.md: the lever table, the 6 x 4 table before and after, EFFECTS before -> after, one plain paragraph.
Summary line: `STYLE3 pass=<0|1> worth=<style:best_delta,...> dead=<style,... or none>`

## Pass lines
- RESULT: tools/style3_probe.gd -> STYLE3 pass=1   (pass=0 with every dead lever named also counts as a result)
- RESULT: tests/style_name_test.gd -> its pass line (update ONLY the expected EFFECTS numbers if it pins them)

## Contract
OWNS: tools/style3_probe.gd, docs/STYLE3_RESULT.md, scripts/rules/StyleName.gd (EFFECTS numbers only)
RED_TEST: tools/style3_probe.gd -> STYLE3 pass=1
REGRESSION: tests/style_name_test.gd, tests/style_wire_test.gd, tests/learn_slots_test.gd
VISUAL: no
NOT YOURS: every other script under scripts/, every other test, tools/style1_probe*.gd, tools/style2_probe.gd, tools/prog_probe*.gd.
Run: `timeout 2400 godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/style3_probe.gd`
(Godot 4.7.2). Work on your own branch, open a PR, never merge. Never delete or skip a test to go green.

## Prior research
ops/research/STYLE1_RESULT.md; goose/issue-302 (STYLE2's probe and partial table); ops/research/PROGRESSION_MAP_S448.md M4;
docs/PICKSPREAD1_RESULT.md (punches beat steps). S482: probe arms must share dice (salt per bout, same for named and
control) - a delta from different dice is noise.

## What would a human do?
Before turning a dial up, check the dial is connected: watch whether the style ever changes a single exchange.

## Prefab check
None: our own rules.

# TASK FLOATERS1 - "+0.2 SPD" rises over him as he trains; a gold MILESTONE when a stat crosses ten (S242, LOOP1, Ludo r105 D4)

Discipline: BOXING (demo). Design source: Ludo r105 PART D item 4 (research/ludo_rx/LUDO_R105_raw.txt lines 261-303),
inside the approved LOOP1 scope (operator Q-S237-1: "the loop , animations,workout,feeling of progrsession and improvement
from training these are what matters for now"). Three parts, three seats, one contract - parts A and B run in parallel.

## The contract (all three parts build on exactly this)
`Godot/scripts/rules/GainFloaters.gd`, `extends RefCounted`, ZERO preloads, static functions only:

```
const STAT_SHORT := {"power": "PWR", "hand_speed": "SPD", "technique": "TEC", "conditioning": "CON", "defence": "DEF", "ring_iq": "IQ"}
const STAT_LONG  := {"power": "POWER", "hand_speed": "SPEED", "technique": "TECHNIQUE", "conditioning": "CONDITIONING", "defence": "DEFENCE", "ring_iq": "RING IQ"}
const MIN_SHOW := 0.01        # a gain below this shows nothing
const RISE_M := 0.8
const FADE_S := 1.2
const REGULAR_COLOUR := "#CBD5E1"
const REGULAR_FONT_PX := 12
const MILESTONE_COLOUR := "#F59E0B"
const MILESTONE_FONT_PX := 16
const MILESTONE_STEP := 10.0

static func floater_for(stat: String, before: float, after: float) -> Dictionary
static func pick_block_gain(gains_then: Dictionary, gains_now: Dictionary) -> Dictionary
```

`floater_for(stat, before, after)` (before/after = the stat's value on file + gains, before and after the block):
- gain = after - before. gain < MIN_SHOW, or stat not in STAT_SHORT -> `{}`.
- milestone = floor(after / 10) > floor(before / 10) (crossed 50, 60, 70 ...). Then:
  `{"text": "★ MILESTONE: %d %s" % [int(floor(after / 10) * 10), STAT_LONG[stat]], "colour": MILESTONE_COLOUR,
    "font_px": MILESTONE_FONT_PX, "rise_m": RISE_M, "fade_s": FADE_S, "pop": true, "milestone": true, "stat": stat, "gain": gain}`
  e.g. power 79.95 -> 80.10 = "★ MILESTONE: 80 POWER".
- else `{"text": "+%.1f %s" % [gain, STAT_SHORT[stat]]` when gain >= 0.1, `"+%.2f %s"` when below 0.1,
  `"colour": REGULAR_COLOUR, "font_px": REGULAR_FONT_PX, "rise_m": RISE_M, "fade_s": FADE_S, "pop": false, "milestone": false, "stat": stat, "gain": gain}`.
  e.g. hand_speed 61.0 -> 61.2 = "+0.2 SPD"; technique 50.00 -> 50.04 = "+0.04 TEC".
`pick_block_gain(gains_then, gains_now)` (two `{stat: float}` day-gain dicts): the stat whose gain (now - then, missing = 0) is
largest -> `{"stat": s, "gain": g}`; ties -> alphabetical first stat; no positive gain -> `{}`.

## Part A - Qwen: the module (`scripts/rules/GainFloaters.gd` + `tests/gain_floaters_test.gd`)
Model: qwen3-coder. Write the module exactly to the contract and a test with the four examples above plus: below MIN_SHOW -> {},
unknown stat -> {}, a two-step jump 68 -> 71 = "★ MILESTONE: 70 ...", pick_block_gain tie + empty + negative. Test prints
`GAIN_FLOATERS failures=0`. Parse gate `python Godot/tools/check_scripts.py <both files>`; run
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gain_floaters_test.gd`.
PR body: `RESULT: tests/gain_floaters_test.gd -> GAIN_FLOATERS failures=0`.

## Part B - Arena: a BLIND contract test (`tests/gain_floaters_contract_test.gd` only)
Write it from THIS contract, never from Part A's code (you will not see it). At least 14 checks, including every example and edge
above, and prove it with 3 mutants you describe in the PR (e.g. `>` vs `>=` on MIN_SHOW, floor vs round on the milestone, wrong
tie order) - each mutant must make the test fail. It preloads `res://scripts/rules/GainFloaters.gd`; on master that file may not
exist yet, so CI goes red until Part A lands - say so in the PR, that is expected. Pass line `GAIN_FLOATERS_CONTRACT failures=0`.
No LFS-loading code. Never touch any other file.

## Part C - Cursor: wire it on the floor (GymHall3D.gd, switch `progression_signs`, already GAME_ON)
Route the GAME runs: `GymHall3D._tick()` (line ~1041) adds one minute to the open station block (`last["minutes"]`);
`_result.get("gains", {})` is the day's cumulative `{stat: float}`. `STATION_BLOCK_MINUTES := 20` (line 128) is one set.
- At every 20th minute of a station block, while `GameSwitches.on("progression_signs")`: `pick_block_gain(<gains at block open or
  last floater>, <gains now>)`; if non-empty, `floater_for(stat, file_stat + gains_then[stat], file_stat + gains_now[stat])`
  (file_stat = the athlete's stats on file - `_ps_sync_ring` already reads "stat on file + today's gains", reuse that).
- Draw it as a `Label3D` (billboard, no depth test, outline 4 px dark, `font_size` = font_px x 4 so it reads at the iso camera)
  1.9 m over his feet; tween +rise_m on Y and alpha 1 -> 0 over fade_s, then free it. `pop` = scale 0.6 -> 1.15 -> 1.0 in 0.25 s.
- OFF arm: switch off -> no Label3D, no tween, byte-identical behaviour.
- Test `tests/gain_floaters_floor_test.gd`: two DIFFERENT boxers (different stats, names, weight classes; print each POPULATION
  line), one at the heavy bag for 40 minutes -> 2 floaters with the right text; one sitting at power 79.9x so the block crosses
  80 -> the gold milestone; OFF arm -> none. Red on master first (paste it). Pass line `GAIN_FLOATERS_FLOOR failures=0`.
- Gates: parse gate on touched files; `python Godot/tools/run_tests.py --only gym_hall,progsigns,progression --jobs 2` unchanged
  or better vs master (paste both SUITE lines).
- If Part A is not on master when you start, create `scripts/rules/GainFloaters.gd` to the contract yourself (it is short) and
  say so in the PR - Claude keeps one.
THE ONE TRAP: GymHall3D.gd is 4,900 lines - grep + `sed -n` windows, never read it whole; touch only the floater code.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <no floater over him at the station>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
(Floor stills here = Claude's tools/iso_club_still.gd on the game's iso camera; Cursor cannot see images - report the
Label3D's world position and text from the test.)

## Prior research
`python Tools/prior_research.py gain floater rep number` -> nothing on floaters (M_HUD2_MARIA type rules: Inter, aligned numbers).
TASK_PROGSIGNS2.md (the ring/posture sibling, same switch), Ludo r105 PART D.

## What would a human do?
Football Manager / Punch Club style: a small number rises off the man when the work pays, a bigger gold one when he reaches a
round number - so you SEE training work without opening a screen.

## Prefab check
Godot's built-in Label3D + Tween - no asset needed.

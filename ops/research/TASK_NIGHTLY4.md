# TASK NIGHTLY4 (S210) - two nightly reds in the fight engine (Arena: sim-only, no models)

Model: Arena (cloud). Repo ICOON-Studio/FightCamp, your own arena/ branch, PR into master; never merge, never master.
The nightly run of 2026-10-12 (master 23ec3ec7) went red on two pure-simulation tests that were green on 2026-10-11. Claude re-ran both
on current master: both still FAIL. Fix the CAUSE; never loosen a check to make it pass without the evidence below.

## Prior research
`Godot/scripts/FightRealtime.gd` (9,488 lines - never read whole; grep and read windows): the round clock `fight_seconds` ~2414,
the tick loop around 2496-2600 (the count holds the bell, resting ticks close the round at the bell), `_go_down` ~3196 (the single
place a man goes down -> `_stop(..., METHOD_KO, ...)`), `_stop` ~4083, `Clock.is_over`. Tests: `Godot/tests/result_clock_test.gd`,
`Godot/tests/q226_speed_test.gd`.

## What would a human do?
A referee never counts out a man for a punch thrown before the bell: once the bell rings, nothing lands until the next round's
bell, and a man who cannot come out for the next round is a corner retirement (RTD) recorded at the end of the round he finished.

## Prefab check
None - our engine.

## Red 1: result_clock_test - a KO at R2 0:00 with no knockdown before it
`godot --headless --path Godot --script tests/result_clock_test.gd` prints
`FAIL  REAL PATH seed 701 KO: engine round 2 t_s 240.0 -> R 2 0:00 (want R 2 0:00)` (the check also demands time != 0:00).
Claude's probe of seed 701 (outside jabber 183 cm vs pressure puncher 176 cm, boxing, RT.DEMO_SWITCHES, 3 rounds): result
{method KO, round 2, t_s 240.0, rounds_completed 1, scorecards: one round, knockdowns 0}; state tick 4801. Fighter A was rocked at
t 172.6 (composure event), the round-1 bell rang at 180, the rest ran 180-240, and he was KO'd ON THE FIRST TICK of round 2 (t 240.0
exactly). So an impact (or a count) is being resolved at the round-2 bell that belongs to round 1 or to the rest.
Find which: (a) a strike wound up / in flight at the bell landing after the rest, (b) a knockdown or "out on his feet" state carried
through the rest and resolved at the bell, (c) something else. Then fix it the boxing way:
- nothing lands after the bell until the next round starts; an in-flight strike at the bell is cancelled (or resolves AT the bell, in
  round 1, inside 180 s);
- a man who cannot answer the bell for the next round is stopped as "RTD" with round = the round he completed and t_s = that round's
  end (the result panel then reads "R 1 3:00").
Add a regression check to result_clock_test (or a new test) that runs seeds 700-739 and asserts NO stoppage has an in-round time of
0:00 and every RTD carries the completed round. Prove it goes red without your fix (say so in the PR).

## Red 2: q226_speed_test - "speed_in_decision ON moves a fast man closer than OFF"
`godot --headless --path Godot --script tests/q226_speed_test.gd` prints
`FAIL speed_in_decision ON moves a fast man closer than OFF ON 1.186 m OFF 1.167 m` (mean gap over 4 seeds 22700-22703).
The other 5 checks pass (the bias itself orders correctly). First measure: run the same ON/OFF comparison over 24 seeds and report the
paired mean difference and its spread. If ON is not closer on average over 24 seeds, the bias is not reaching the movement decision -
find where `speed_in_decision` feeds the close/circle choice and fix the wiring. If ON IS closer over 24 seeds and only the 4-seed
mean flipped, change the test to 24 seeds with a paired mean difference < 0 (a bound, not an exact count) and show in the PR that a
mutant with the bias disabled (multiplier forced to 1.0) makes it FAIL.

## Owned files
- `Godot/scripts/FightRealtime.gd` (only the windows you need; keep every existing test green)
- `Godot/tests/result_clock_test.gd`
- `Godot/tests/q226_speed_test.gd`
- a NEW `Godot/tests/round_bell_stoppage_test.gd` if you prefer a separate regression test

## Acceptance
Both tests above PASS; also run `tests/fight_realtime_test.gd`, `tests/result_panel_test.gd` (if present) and every test whose name
starts with `q226_` - none may go red. Report each command's last lines in the PR body. Never delete or weaken a check.

## The one trap
FightRealtime is deterministic per seed - a change anywhere in the tick loop shifts every later seed. If an unrelated test that
asserts an exact seeded outcome changes, say which and why in the PR; do not edit its expectation silently.
GDScript: type Variant returns (`var n: int = ...`), `%` in a format string is `%%`.

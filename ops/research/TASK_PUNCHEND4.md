# TASK PUNCHEND4 - PunchEnd also reads how fast the hand reaches the guard it SETTLES into after the punch

Status: OPEN (S505, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week. PunchEnd (yours, PUNCHEND1-3, `scripts/rules/PunchEnd.gd`) calls a hand "home" when it is within
HOME_RADIUS_M (0.08) of her guard BEFORE the punch. Traced by hand on `E:/FightCamp/tmp/fightweek/s505b/shown.csv`
(boxer 0, jabs starting at frames 211, 595, 1011, chest frame): the hand comes from ~55 cm to ~15 cm of that guard in
4-6 frames, then stays 10-17 cm off it through the idle frames that follow - the guard itself sits somewhere else after
the punch. So contact_home p50 reads 25 frames although the arm is back fast. Add a second reading; change nothing else.

## What to change (PunchEnd.gd, its test and its probe only)
1. SETTLE point of a punch: the punching hand in her chest frame (`_local`, as today), averaged over the first up-to-5
   frames AFTER the run whose `clip` contains `idle` or `guard`, searching at most 45 frames past the run's last frame
   (other clips skipped, not counted). None found -> no settle point (`settle_frames` = -1, left out of percentiles).
2. `settle_frames`: frames after the FAR frame until the hand is within HOME_RADIUS_M of the SETTLE point (any clip),
   up to HOME_SEARCH (30); 30 if never.
3. `contact_settle_frames`: the same from the CONTACT frame (as contact_home counts it); -1 when no contact.
4. Summary adds `settle_p50`, `settle_p90`, `contact_settle_p50`, `contact_settle_le4`; `by_clip` adds `settle_p50`.
   Every existing field stays exactly as it is.
5. `tools/punch_end_probe.gd`: the per-punch line appends ` settle=<n> contact_settle=<m>`; the last line keeps every
   field and appends ` settle_p50=<x> contact_settle_p50=<y> contact_settle_le4=<k>`.
6. `tests/punch_end_test.gd`: every existing check passes unchanged. Add: a punch whose hand returns to a guard 15 cm
   from her pre-punch guard and stays there (settle 4 or less, home 30 - prove in a comment the old reading says 30);
   a punch followed by no idle within 45 frames (settle -1, not in percentiles); a landed one with contact_settle 3.

## Contract
OWNS: scripts/rules/PunchEnd.gd, tests/punch_end_test.gd, tools/punch_end_probe.gd
RED_TEST: tests/punch_end_test.gd -> PUNCH_END_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file (the brief too). Never delete or weaken a test. Own branch, commit, push, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. One test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/punch_end_test.gd -> PUNCH_END_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last line on `E:/FightCamp/tmp/fightweek/s505b/shown.csv`.

## Prior research
`scripts/rules/PunchEnd.gd` (yours; `_find_guard_home`, `_compute_home_from_ref`, `_compute_contact_home`, `_local`).
`ops/research/S505_DIGEST.md` "Hands home". `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript.

## What would a human do?
A coach asks "is his hand back at his chin?" - the chin where it is now, not where it was before the punch.

## Prefab check
None: the same loops PunchEnd already has, pointed at the frames after the punch.

## The one trap
The idle frames after a punch can belong to the NEXT punch's guard search too - read them per punch, never cache one
punch's settle point for the next.

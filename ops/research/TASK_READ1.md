# TASK READ1 - size the professional's read through the game's real bout (no screen, no game change)

Status: OPEN (S461, Claude main). Discipline: boxing. Model: Antigravity (agy), high.
Mechanic: PROGRESSION (approved, owner Q-S294-211 "Yes, go ahead"). Spec: ops/research/PROGRESSION_MAP_S448.md section 4 M7
"PROFESSIONALS GET READ" (lines 195-206, READ THEM WHOLE). The pure rule is built: scripts/rules/ProRead.gd (target / round_line /
share / proof / words) with tests/pro_read_test.gd. It returns SHARES (0, 0.5, 1); this task measures the SIZE the game multiplies
them by, so INTEGRATE1 #5 can switch it on (ops/research/INTEGRATION_S459.md row 5).

## What is measured
The rule: when the read line fires into the waiting corner, that exchange loses its edge and the counter costs. Size it as ONE
number, READ_EDGE: points taken off the exchange's edge `d` in LiveRound.exchange (scripts/state/LiveRound.gd ~line 239, where
`d += ...talk edge`) for a planned exchange whose line == ProRead.round_line(target, round) times ProRead.share(...).
The probe applies it from PROBE-SIDE code only: tools/read1_probe.gd plays the real bout (BoutNight.fight_step / play_out exactly as
tools/adapt_probe.gd and tests/phase_wire_test.gd `_planned` do) and adds the read through a probe hook - if the bout code has no
hook, put the smallest possible one in a copy under tools/ (never edit scripts/). Read tools/adapt_probe.gd first.
Arms, paired dice (the same seed plays the same bout in every arm), Lucy (Data.lucy) as a professional against Data.OPPONENTS:
- A no read (the control).
- B careless pro: the same plan every bout (one line fires most), read at READ_EDGE.
- C careful pro: a second line held at Sharp/Signature fired >= 80% as often (split, share 0.5).
- D careful pro: the Feint line in the plan (feinted, 1 time in 2 misses).
- E careful pro: plan changed onto the target line's partner (target line not in the plan: share 0).
Sweep READ_EDGE over 0, 2, 4, 6, 8, 10, 12 (edge points, the units LiveRound's `d` already uses; print what one point is worth in
wins in 100 at A's level first).

## Pass line (the map's, M7)
1. B (careless) loses 5 to 9 wins in 100 against A (the S427 measured size was 7 in 100 unanswered).
2. The best careful arm (C, D or E) ends within 2 in 100 of A.
Report the smallest READ_EDGE where both hold. If no value passes both, say which fails and by how much: the design then changes,
not the number.

## Cost and heat
400 paired bouts per arm per value is the target. FIRST a pilot (20 bouts, every arm, READ_EDGE 6) and print the projected wall time;
if the full run passes 90 minutes, cut the bout count to fit and say so. Runs only through
`python ops/Tools/godot_slot.py run --who read1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/read1_probe.gd -- <args>`.
Never the full test suite. Two DIFFERENT fighters each bout (never identical stats).

## Contract
OWNS: tools/read1_probe.gd, docs/READ1_RESULT.md
RED_TEST: tools/read1_probe.gd -> READ1 pilot ok (a probe; docs/READ1_RESULT.md is the deliverable)
REGRESSION: pro_read_test, phase_wire_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only); never edit scripts/rules/ProRead.gd.
(read1_probe.gd under 500 lines. docs/READ1_RESULT.md: the sweep table arms x READ_EDGE with wins in 100 and 95% bands, the pass
verdict, the chosen READ_EDGE, and in plain words what it means for a professional. PR body line:
`RESULT: tools/read1_probe.gd -> READ_EDGE=<n> pass=<yes|no>`.)

## Prior research
PROGRESSION_MAP_S448.md M7; TASK_PROREAD1.md (the module contract); FIRELEVEL2_ADAPT1_RESULT_S442.md and TASK_PUSHPROBE2.md (how a
probe through the real bout is built and read); tools/fire_level_probe.gd (Lucy, the opponent, 400 bouts).

## What would a human do?
A pro trainer watches the opponent's last two fights on tape and sets the counter for the punch thrown most; a careful boxer
answers with a second weapon or a feint. Measure how much that costs before the game charges it.

## Prefab check
None: the probe reuses the game's own bout code and ProRead.gd.

## The one trap
A probe that rolls its own dice still prints a pass line (ASKPROBE1, S442). Every punch, round and result comes from the game's
code; the probe only adds READ_EDGE where the read lands.

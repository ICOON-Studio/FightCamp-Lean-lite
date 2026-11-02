# TASK Q177 - QWEN - FOOTWORK ECONOMY PASS 2: TUNE TO THE MEASURED BANDS (G100)
Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S78, 2026-09-25. Engine lane. QUEUED: starts when a
shell-agent slot frees (two-agent cap; C204 Codex and U174 Cursor were running at S78 end).

## Why
Q176 (your branch `qwen/q176-footwork`, 2539d2e6) cut boxing travel from ~48 to 21-26 m/min with `footwork_economy` ON.
Two independent studies landed since, and both put the real floor ABOVE that:
- `research/G100_TIME_MOTION.md` (Grok, sourced): boxing COM travel 36-52 m/min (Thomson GPS 35.9; FFB homography
  52), **gate 32-48**; burst 1.5-3 s; hold/pause 2-8 s; cycle hold->burst->reset 6-12 s; MMA stand-up 25-40 m/min,
  stand HI burst 6-9 s, LI probe 15-18 s; bout-average MMA 12-33. **Do not gate on % frames > 0.25 m/s** - that is
  below bounce; a real travel step is ~0.6-0.8 m/s.
- `research/D22_TIME_MOTION.md` (Dola, blind second source): boxing 30-38 m/min, burst 1-3 s, pause 2-5 s, cycle
  5-12 s. It disagrees with G100 on magnitude; where they disagree, **G100's bands win** (named n, named papers).
Q176's limiter is 15 ticks on / 20 off (0.75 s burst, 1.0 s hold) - shorter than both studies' bursts and holds.

## What would a human do?
A boxing coach does not tell a fighter to walk less; he tells him to hold the pocket, take 15-25 cm steps, feint and
shift weight while he waits, then burst for one or two seconds and reset with a half step or a pivot. A sports
scientist checks that with time-motion analysis: phase durations (hold / burst / reset) and metres per minute from
GPS or homography. So tune the RHYTHM (phase lengths) first and let metres fall out of it - never tune m/min directly.

## Do
1. Rebase your branch on origin/master. Keep `footwork_economy` default OFF and OFF byte-identical (s70 hash proof).
2. Replace the fixed 15/20-tick limiter with phase lengths drawn per fighter from the G100 bands (boxing/kickboxing:
   burst 1.5-3 s, hold 2-8 s; MMA stand-up: burst 6-9 s, probe 15-18 s), style-weighted (pressure fighter shorter
   holds, out-boxer longer holds + more lateral steps). Seeded, deterministic.
3. Re-measure with `tools/q176_decompose_travel.gd` on DIFFERENT fighters per bout (never identical fighters; name the
   population and the catalogue in the output): m/min per man, % time above **0.6 m/s** (travel) AND above 0.25 m/s
   (old flag, reported only), mean burst s, mean hold s, cycle s.
4. Gate (ceilings/floors, not exact): boxing ON m/min inside 32-48; MMA ON inside 12-33 bout-average; mean burst and
   hold inside the G100 bands. Over-delivery is fine - say so and push.

## Owned files
`Godot/scripts/FightRealtime.gd` (5,627 lines - NEVER open whole; grep `footwork_economy\|fe_burst\|_run_movement`
and read `sed -n 'A,Bp'` windows), `Godot/tests/fight_footwork_economy_test.gd`, `Godot/tools/q176_decompose_travel.gd`,
`research/Q177_DIGEST.md` (new). Small enough to read whole: the test and the tool.

## Gate (tier: script edited)
Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`. Then
`python Godot/tools/run_tests.py --only fight_footwork_economy,fight_realtime,fight_pace,judge,feint --jobs 1`.
Never the full suite (it runs nightly). Work in worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q164`.
Commit explicit paths, push `qwen/q176-footwork`, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q177 --body "<bands before/after, hashes, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Metres per minute is an OUTPUT. If you scale throttles until m/min lands in 32-48 while bursts stay 0.75 s, the number
passes and the fight still looks like twitching. Print burst and hold seconds beside m/min, and gate on all three.

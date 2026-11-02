# TASK U174 - CURSOR - A BOXING ROUND THAT READS LIKE ONE (punch volume, connect %, jab share)
Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S76, 2026-09-25. Engine lane.
**QUEUED: launch only when fewer than two shell agents are running (operator 2026-09-25, PC at 87% CPU).**

## Why
S76's between-round CompuBox card (`Godot/scripts/FightBroadcast.gd`) put the engine's per-round numbers on screen.
On the U172 boxing pair a round reads ~25 punches per fighter, 50-60% landed and ~20% jabs. Real CompuBox averages are
far busier, much less accurate and jab-heavy. The anchors come from Grok G99 (`research/G99_COMPUBOX_AVERAGES.md`,
assigned S76); if it has not landed when you start, build step 1 and stop before step 2.

## What would a human do?
A boxing game designer measures the sim with CompuBox's own definitions over a POPULATION of styles (out-boxer,
pressure fighter, counter-puncher - never two identical men), compares each figure to the published average, and tunes
the cause (decision cadence, jab selection weight, defence success) one at a time with a control arm - never one global fudge.

## Do
1. Instrument: `Godot/tools/u174_compubox_census.gd` - per-round thrown/landed/%, jab and power split, per fighter,
   over 3 legal non-identical boxing pairings x 40 bouts, using `FightBroadcast.round_stats` (never a second fold).
   Print the population and the catalogue in the output (CLAUDE.md "never test identical fighters").
2. Move the three figures toward G99's bands one cause at a time, behind ONE new option (default OFF, `boxing_output`);
   OFF = byte-identical hashes (`tools/s70_feint_off_hash.gd`). Print achieved beside wanted for every figure.
3. Name any figure you could not reach and why; do not trade one anchor for another.

## Owned files
`Godot/scripts/FightRealtime.gd` (~5,000 lines - NEVER open whole; `grep -n` then `sed -n` windows), new
`Godot/tools/u174_*.gd`, a new test `Godot/tests/boxing_output_test.gd`, `research/U174_DIGEST.md`.
`FightBroadcast.gd` READ-ONLY (it is the ruler).

## Gate (tier: script edited)
Parse gate first. Then `python Godot/tools/run_tests.py --only boxing_output,fight_realtime,fight_defence_model,judge,feint,fight_broadcast --jobs 1`.
Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U174` on `cursor/u174-punch-output` from origin/master; copy the main
`Godot/.godot/imported` in rather than re-importing; NEVER commit `Godot/.godot/` (U173 committed 4,000 cache files).
Push the branch; `python Tools/agent_comms.py send --from cursor --to claude --topic U174 --body "<figures before/after vs G99, hashes, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Connect % falls for free if everyone simply misses more - and then knockdowns and the judges move. Print knockdowns per
bout and the decision split OFF vs ON beside the three figures.

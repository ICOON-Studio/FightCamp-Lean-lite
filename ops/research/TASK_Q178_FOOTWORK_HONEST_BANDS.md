# TASK Q178 - QWEN - FOOTWORK PASS 3: MEET G100'S REAL FLOORS, NOT LOWERED ONES
Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S79, 2026-09-25. Engine lane. QUEUED behind the
two-agent cap (Codex C205 + Cursor U175 at assignment): start when a shell slot frees.

## Why
Q177 (merged to master at d0608ccc, `footwork_economy` OFF by default) reported "all in band". It is not.
`Godot/tests/fight_footwork_economy_test.gd:83-88` gates boxing burst >= 1.0 s and hold >= 1.5 s, but
`research/G100_TIME_MOTION.md` says burst **1.5-3 s** and hold **2-8 s**. The measured result was burst
1.2-1.6 s and hold 1.0-2.4 s: BELOW both floors. A test whose floor was moved to meet the engine only agrees with it.
Q177 also found a real bug (Q176's `direction *= 0.30` was normalised away) - keep that fix.

## What would a human do?
A sports scientist does not move the band to fit the athlete - the band is the measurement of real bouts. A coach
whose fighter bursts too briefly teaches him to COMMIT: a burst is a 2-3 punch combination and the steps that carry
it in and out, and a hold is a real pause in the pocket with feints and weight shifts, not a stop. So lengthen the
phases where they are made (the burst/hold state machine), and let metres per minute fall out of it.

## Do
1. Restore the floors to G100's: boxing burst >= 1.5 s (ceiling 3.0), hold >= 2.0 s (ceiling 8.0). Do not lower them
   again; if the engine cannot meet them, say which mechanism stops it and push the honest red.
2. Find why phases come out short: grep `fe_burst\|fe_hold\|_fe_phase_ticks` in `FightRealtime.gd`. Likely causes:
   a phase is cut when an exchange or intent change fires, or the tick-to-second conversion is off. Print, per
   fighter, drawn phase length beside the length actually lived (achieved beside wanted).
3. Re-measure with `tools/q176_decompose_travel.gd` on DIFFERENT fighters (never identical; name the population and
   the catalogue in the output): m/min, burst s, hold s, cycle s, for boxing and MMA. Gate: boxing m/min 32-48, MMA
   bout-average 12-33, burst and hold inside G100's bands. Over-delivery is fine - say so and push.
4. OFF must stay byte-identical (the s70 hash proof).

## Owned files
`Godot/scripts/FightRealtime.gd` (~5,800 lines - NEVER open whole; grep the names above and read
`sed -n 'A,Bp'` windows), `Godot/tests/fight_footwork_economy_test.gd`, `Godot/tools/q176_decompose_travel.gd`,
`research/Q178_DIGEST.md` (new). The test and the tool are small enough to read whole.

## Gate (tier: script edited)
Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`. Then one `--only` per run (they do not
stack): `python Godot/tools/run_tests.py --only fight_footwork_economy --jobs 1`, then `--only fight_realtime`,
then `--only fight_pace`. Never the full suite (nightly). Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q164`,
new branch `qwen/q178-footwork-bands` from origin/master. Commit explicit paths, push, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q178 --body "<burst/hold/m-min before->after, hashes, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Averages hide the cut: a mean burst of 1.6 s can be half 3 s bursts and half 0.2 s stubs where an exchange
interrupted the phase. Print the distribution (p10/p50/p90), not only the mean, and gate the p50.

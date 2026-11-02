# TASK_Q171 - the pace anchor D1: find why combined significant landed/min runs above J20 (Qwen, engine)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S71, 2026-09-25. Engine lane (agents build, Claude integrates).

## Why
`Godot/tests/fight_pace_anchor_test.gd` D1 has been red on master since S67: combined significant strikes LANDED per minute
sits above J20's 6.0-8.0 band. Your Q170 proved it is not a Q170 regression (red on master without it). S71 merged Q170
(`e66ceb6b`); D1 is still the one red in the engine's focused tier. It is yours to root-cause.

## Do
1. Run the test alone and print the number it reads, the band, and the population it fights (name both men - the
   identical-fighters rule binds; if the fixture is two identical men, THAT is a finding and the fixture is the fix).
2. Decompose the landed/min: attempts/min x land rate, by ruleset and by limb family, beside J20's own anchors
   (`grep -n "D1\|landed" research/J20*.md` for the definition - significant strikes, BOTH men combined, per minute of
   fight time). Say which factor is out: too much VOLUME or too high a LAND rate.
3. Fix the MECHANISM of the factor that is out. NEVER by throttling strike volume to hit the band; NEVER by retuning to an old
   seed. If the defect is in how the test COUNTS (e.g. a non-significant strike counted as significant, feints counted as
   strikes, minutes that exclude clinch/ground time), fix the count and show the before/after with the definition quoted.
4. `feint` and `trap_arm` default OFF: OFF must stay byte-identical for anything you did not intend to change - run
   `Godot/tools/s70_feint_off_hash.gd` before and after and paste both.

## Owned files
`Godot/scripts/FightRealtime.gd` (~5,800 lines - NEVER open it whole; `grep -n` and `sed -n 'A,Bp'` windows),
`Godot/tests/fight_pace_anchor_test.gd`, a NEW `Godot/tools/q171_pace_decompose.gd`, `research/Q171_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>` first. Then `fight_pace_anchor_test` alone, then
`python Godot/tools/run_tests.py --only fight_pace`, `--only fight_realtime`, `--only feint`, `--only judge`, `--only ground`
(ONE `--only` per run; read `total=` each time). Ceiling: D1 green or its remaining gap explained with the decomposition;
no new red vs master. Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-Q164`, branch `qwen/q171-pace-anchor` off
`origin/master`. Commit explicit paths, push,
`python Tools/agent_comms.py send --from qwen --to claude --topic Q171 --body "<which factor was out, the fix, D1 before/after, OFF hashes>"`.
Do NOT edit or read HANDOFF.md, CURRENT_STATUS.md or any digest but J20's.

## The one trap
A long measurement times out (Q170 round 1 lost its table that way). Split runs by ruleset with the tool's own filters and
write each chunk's rows to disk as it finishes.

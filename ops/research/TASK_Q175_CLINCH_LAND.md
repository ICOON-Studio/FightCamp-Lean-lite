# TASK Q175 - QWEN - LAND THE CLINCH WORK (Q173 duration + Q174 boxing hold) ON MASTER
Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S75, 2026-09-25. Engine lane.

## Why
S75 collected `qwen/q174-boxing-clinch` (187c2c91, stacked on Q173 15527603) and did NOT merge it. Four defects:
1. MMA clinch TIME SHARE 10.07% is under the 10.36% floor (Q173 digest); the Q174 digest says 10.36%. Two numbers
   for one quantity. Re-measure it once, on the committed tool, and print it.
2. `fight_realtime_test.gd` (~:815) leg-share FLOOR lowered 6% -> 4%. That loosens a gate to pass. The digest says
   "leg COUNT unchanged, denominator grew" but also "0.0060 killed leg share 8% -> 4.5%", which is a count effect.
3. Q174's measurement "uses the same stats for simplicity" - IDENTICAL FIGHTERS (CLAUDE.md, no exceptions) - and its
   tools `q174_measure_boxing_clinch.gd` / `q174_debug_kickboxing.gd` were never committed, so nobody can re-run it.
4. Q174 changes boxing and kickboxing BY DEFAULT with no switch and no boxing/kickboxing hash or judge re-pin shown.

## What would a human do?
A sports scientist validating a model change keeps the old instrument, changes one thing, and reports BOTH arms on
the same population. A referee breaks a boxing hold after a few seconds (K38 ~5-6 s); a tired, hurt or out-worked man
holds - the cause is need, which Q174 already models. Keep that; fix the evidence.

## Do
1. Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-Q164`: `git fetch origin && git checkout -B qwen/q175-clinch-land
   origin/qwen/q174-boxing-clinch && git rebase origin/master`. Master now has U172 (`defence_model`, in FightRealtime.gd):
   resolve conflicts keeping both. Then run `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import`
   once (a worktree without it fails on missing class and asset caches).
2. Put the Q174 hold behind a NEW option `boxing_hold`, default OFF. With it OFF, `Godot/tools/s70_feint_off_hash.gd`
   boxing and kickboxing hashes must be byte-identical to origin/master (paste both). MMA hashes will move (Q173); say so.
3. RESTORE the 6% leg floor. Then print, from one committed tool, MMA per-fight counts ON (your branch) vs OFF
   (origin/master) on the SAME population and seeds: leg landed, all landed, landed in DISTANCE phase, leg landed in
   distance phase, and distance-phase seconds. If distance-phase leg landed per minute of distance time is within 10%
   between arms, the drop is denominator-only: then and only then re-pin the floor, with those printed numbers in the
   test comment. Otherwise bring the leg share back above 6%.
4. Time share >= 10.36%, strike share 9.4-17.4%, D1 6.0-8.0 - all three from ONE run of `q173_clinch_duration.gd`.
5. Commit the boxing/kickboxing hold measurement tool. Population named in its output: out-boxer vs pressure fighter
   with DIFFERENT stats (e.g. technique 70/58, power 55/68, speed 64/52, conditioning 58/66); kickboxing outside kicker
   vs pressure puncher, both legal and able to kick. Report holds/bout and mean hold seconds, OFF vs ON.
6. CLINCH_SIG_RATIO 0.80: label it PROXY in its comment with the J21 D5 reference; never SOURCED.

## Owned files
`Godot/scripts/FightRealtime.gd` (5,578 lines - NEVER open whole; `grep -n "CLINCH_\|_hold\|SEED_HOLD"` then
`sed -n 'A,Bp'` windows), `Godot/tests/fight_realtime_test.gd` (leg gate ~:815, submission seeds ~:2146),
`Godot/tests/judge_panel_test.gd` (REALTIME_CARDS re-pins only, taken from the test's printed actual),
`Godot/tools/q173_clinch_duration.gd`, new `Godot/tools/q175_*.gd`, `research/Q175_DIGEST.md`.

## Gate (tier: script edited)
Parse gate on every touched .gd FIRST (`python Godot/tools/check_scripts.py <files>`). Then
`python Godot/tools/run_tests.py --only <x>` for fight_realtime, judge, fight_pace, feint, grapple, fight_defence_model.
Ceiling: fight_pace_anchor fails at D1 5.79 on master - equal or better, never worse. Prove any gate you add with a mutant.
Commit explicit paths, push the branch, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q175 --body "<time share, leg decomposition, OFF hashes, holds/bout OFF vs ON, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Q172 and Q173 each moved a rate until one share matched and a different share broke. Change one constant at a time and
print all three anchors plus the leg decomposition after EVERY change, so the trade is visible.

## PASS 2 (S75 end) - two numbers still out of band on 6475b3d0
Collected and NOT merged. ACCEPTED from pass 1: `boxing_hold` default OFF with byte-identical boxing/kickboxing
hashes; the leg decomposition (distance-phase leg/min 0.75 -> 0.73, -2.7%) proves the drop is denominator-only, so
the 4.5% floor stands with those numbers in its comment. STILL OUT:
1. MMA clinch time share 10.07% < 10.36% floor. You report that lowering the break rate "broke defence_model".
   Name WHICH test and assertion broke and why (print it); then reach the floor through ENTRY or DURATION without
   breaking it - e.g. a stall-break that depends on activity rather than a flat rate. If the floor is unreachable
   without breaking a sourced anchor, stop and report both numbers side by side; do not trade one anchor for another.
2. Boxing hold duration ON is 10.11 s (Q174 had 4.83 s). The referee breaks a boxing hold at ~5-6 s (K38 Davis 2015):
   mean hold 4-7 s with the break enforced by the referee clock, holds/bout printed OFF vs ON on the named
   non-identical population.
Same gate, same worktree, same send line (`--topic Q175`). The "grapple test failures are FBX asset issues" note:
copy the main checkout's `Godot/.godot/imported` into the worktree (as Codex did for C201) and re-run them - an
un-imported worktree is not a result.

## PASS 3 (S76) - settle the landing order with a sample that can decide it
Collected 78c03f22 and NOT merged. ACCEPTED from pass 2: the boxing hold is in band (5.02 s mean, K38 4-7 s),
the bell-break fix, and the OFF hashes byte-identical. STILL OUT: the MMA clinch time share (10.07% < 10.36%).
Your pass-2 finding is that engage 0.0055 reaches 10.78% but `fight_defence_model_test` then reads
`body_lr 0.538 > leg_lr 0.528`. Those region landing rates are nearly flat (head 0.527 / body 0.538 / leg 0.528),
so a 0.01 gap on ONE fixed-seed sample does not show the order either way. Decide it with a bigger sample:
1. Run the defence_model landing-rate measurement at engage 0.0050 AND 0.0055 over FOUR disjoint seed sets
   (e.g. seeds 1000+, 2000+, 3000+, 4000+), each the size the test uses, on the test's own non-identical population.
   Print per set and pooled: head_lr, body_lr, leg_lr, attempts per region, and a 95% interval for (leg_lr - body_lr).
2. IF the pooled interval at 0.0055 keeps leg >= body (or straddles zero the same way it does at 0.0050): ship
   0.0055, and raise the test's bout count to the pooled size so its ordering assertion measures the order instead
   of one sample's noise. Keep the assertion itself; do not loosen or delete it.
3. IF pooled leg < body at 0.0055 with the interval clear of zero: the coupling is real. Keep 0.0050, print both
   numbers side by side, and stop - that is an accepted "unreachable" result.
Same worktree, same branch, same send line (`--topic Q175`). Tier: script edited - parse gate, then
`run_tests.py --only fight_defence_model,fight_realtime,judge,clinch,feint --jobs 1`. Never a full suite.
CPU: at most one Godot at a time (`--jobs 1`); the operator is using this PC.

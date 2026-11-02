# TASK Q196 - DOES FOOTWORK ECONOMY KILL SUBMISSIONS AND JUDO THROWS, OR IS IT THE SAMPLE?
Owner: qwen. Assigned 2026-09-27 (S95). Model: qwen3-coder, medium effort (the qwen_task.cmd pin).
Branch: `qwen/q196-economy-ground` from `origin/master` (b757a979 or later), worktree `Temp/FightCamp-Q164`
(pull master into it first; `git bisect reset` if a bisect is still open there).

## Why
Your Q195 bisected the pin drift to `4f789137` (Q183: `footwork_economy` default ON, `FightRealtime.gd:1032`).
Claude merged your two re-pins (judge_panel, grapple_adapter - both pass on master). The third test is still RED on
master: `fight_realtime_test.gd` FAILS=6. Claude ran the CONTROL ARM on master - the same tree with line 1032's
default set to `false` - and the test PASSES (378 checks). So the six failures are caused by economy ON. Printed rows:

| row | economy OFF | economy ON |
|---|---|---|
| R91 takedowns kept (40 boxer-v-wrestler MMA bouts) | 103 of 187 | 94 of 178 |
| R91 SUBMISSIONS | **2 of 40** | **0 of 40** |
| R92 judo throws kept (24 grappler-v-fish judo bouts) | 4 | 4 |
| R92 judo_throw_rounds | 3 | **0** |
| R93 throw seats | half 1, side 3 | **half 4** |
| R93 bands | yuko 3, not_scored 1 | **not_scored 4** |
| R93 seed 94018 | ippon | hansoku_make_shido |

Takedown volume barely moves and the throw COUNT does not move at all - what moves is WHERE a throw lands (side ->
half, so no yuko) and whether a submission finishes. Two readings, and they need different fixes:
- **NOISE:** 2/40 -> 0/40 and 3/4 -> 0/4 are tiny samples; economy shifted the RNG draw order and the few rare
  events fell elsewhere. Then the checks are under-powered, not the engine wrong.
- **MECHANISM:** economy changes the fighters' relative position/facing at the moment of a throw or a scramble
  (e.g. holds leave them square, the seat logic reads that as half guard), so the ground game is really poorer.

## What would a human do?
A combat designer who sees "fewer subs and no scored throws after we slowed the footwork" first asks whether it is
real: they run enough bouts that 2 events is not the whole sample, both ways. If the rate truly drops, they look at
what the slow footwork changes at the instant of the throw - stance, distance, facing - because a judo throw's
landing seat is decided by the thrower's entry, not by how much anyone walked before it. They never fix a rate by
re-pinning seeds until the test is green.

## Do
1. Measure both arms on a BIG sample with the SAME fixtures the test uses (name them in output): R91's boxer v
   wrestler MMA 3x5 (the test's `_r91_default_bouts` fighters) on 400 seeds, and R92/R93's grappler v fish judo on
   200 seeds. Pass `footwork_economy` explicitly per arm. Print subs/bout, throws, throw seat histogram, yuko/ippon
   counts with 95% CIs. Tool: `Godot/tools/q196_economy_ground_census.gd`.
2. If the CIs overlap (NOISE): keep economy ON, and make the checks honest - re-find pinned seeds by sweep (as you
   did for T11) and, where a check counts a rare event over too few bouts, raise its bout count until the expected
   count is >= 5 in the OFF arm. Name the census numbers in the test comment.
3. If they do not overlap (MECHANISM): find what economy changes at the throw/submission entry (grep the seat
   decision - `throw_seat`, `seat` in FightRealtime.gd near the judo throw path) and fix the mechanism so the
   OFF-arm rates come back with economy ON. Do NOT turn economy off for judo/MMA as the fix unless the census shows
   it cannot be reconciled - then say so and scope it, naming the evidence.

## Owned files
`Godot/tests/fight_realtime_test.gd`, `Godot/tools/q196_*.gd`, `research/Q196_DIGEST.md`, and - only for a
MECHANISM fix - the seat/entry window of `Godot/scripts/FightRealtime.gd` (~14k lines: NEVER open it whole; `grep -n`
then `sed -n 'A,Bp'` windows; the default is at :1032, economy branches at :1331, :3157, :3238, :3287).

## Gate (a CEILING - better is welcome, say so)
- Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`.
- The census table (both arms, CIs, population named) in the digest, and the verdict NOISE or MECHANISM stated.
- `python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,judge_panel,grapple_adapter,fight_footwork` -> all
  pass on your branch.
- If FightRealtime.gd changed: also `--only fight_,judge,broadcast,knockdown,grapple` on master AND branch, both SUITE
  lines printed; nothing green on master may go red on the branch.

## Deliver
Commit explicit paths, push `qwen/q196-economy-ground`, write the digest, one line with
`python Tools/agent_comms.py send --from qwen --to claude --topic q196 --body '<one line>'`. Do NOT edit HANDOFF.md.
Research is open: RESEARCH_INDEX.md (Q183_DIGEST.md and your Q195_DIGEST.md bear on this).
**Trap:** Q195 found `fight_realtime_test` hits a `FightMoves` parse error in a worktree with no `.godot` cache - run
`Godot --headless --path Godot --editor --quit` once in the worktree to build the class cache BEFORE trusting any red,
and prove `broadcast_read_test` passes there first. Kill every Godot you start; Q195 left eleven running.

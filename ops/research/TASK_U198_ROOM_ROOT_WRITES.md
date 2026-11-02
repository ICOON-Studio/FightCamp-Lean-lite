# TASK U198 - The boxing room moves the men where the engine did not put them (Cursor)

Model: Cursor default (Composer), high effort. Owner: cursor. Milestone: PLAYABLE WITH A BOXER - "watch the bout and it reads
as boxing". Every test below is the BOXING room; a body that jumps 12 cm in one frame or stands outside the ropes is the
first thing a viewer sees.

## What is wrong (measured by Claude on master 2026-09-29, S124 - real, not load: re-run alone after the nightly)
1. `fight_room_no_teleport_test` (U146, boxing seed 94301): roots jump **10-12 cm in ONE 1/60 s frame** - frames 173, 286, 287,
   388, 821, 5432; often BOTH bodies on the SAME frame by the SAME amount (0.1022 / 0.1099 m). Green on the 09-28 nightly.
2. `fight_room_ring_bounds_test`: the ENGINE keeps both men inside (engine worst 2.443 m = its half width) but the ROOM puts a
   body centre at **2.626-2.656 m** (limit 2.593, contest half 2.743) on seeds 0 and 94302 - the room adds ~0.2 m the engine
   never produced.
3. `fight_room_positions_test` - HANGS (600 s timeout), red since the 09-29 nightly.
4. `fight_readable_onset_test` - HANGS (600 s timeout).
5. `fight_pair_live_test` - `pairs=0`, `qualifying 0`: no beat qualifies for the authored jab pair
   (`assets/anim/pairs/BOX_JAB_HEAD_LAND_F01_F09.pair.json`, f01 v f09). S122 found one cause (footwork landing as punches,
   fixed 953542ce) and it is still 0. Suspect: the game now mounts GENERATED bodies (D5, S117) and the pair is per MESH PAIR.
   PROVE which before changing anything; if the pair can never play on generated bodies, report it with the evidence - do
   NOT delete the pair feature or the test (that is the operator's call).

6. `fight_stage_realism_test` - HANGS (600 s), and `fighter_gloves_both_corners_test` - every glove check prints `ok`, then the
   test HANGS (600 s). Three room tests hang at their end: suspect ONE shared loop (a pump that never reaches its exit).
7. `fight_body_overlap_test` - "no refused penetration in 900 frames (worst 0.0013 m head>arm at frame 827, allowance 0)" -
   U196's 1.3 mm residual. It is a red, not a tolerance to widen: find the writer that leaves 1.3 mm.

The SETTLED decision (OPINION_TELEPORTS_SYNTHESIS.md): a 3 cm / 10 deg per-frame cap on any root write. The room's own budget
`_finish_root_frame` (FightWorldLiveScreen.gd ~:3110-3132) allows 4 m/s = 6.7 cm per frame, and exits early for grapple /
mount blend / in_pair. A 10-12 cm jump therefore means a root write AFTER that budget, or a path that skips it. The rope
clamp at ~:3095-3107 calls itself "LAST WRITE OF THE FRAME", yet (2) shows centres past the rope - so something writes after
it too. Candidates to check (not conclusions): the placement lerp ~:3743, the posed-contact solve, `move_toward` placers
~:2997/:3005, the C215 shuffle latch (U196 part 2), hit physics / active ragdoll (C217 ON since S115).

## What would a human do?
A game programmer with a "bodies pop" bug puts ONE breakpoint on every write to the root and logs (frame, writer, before,
after) - then fixes the ORDER so the one bounded writer is truly last. They do not raise the tolerance and they do not add a
second clamp on top of the first. Debug at the point of write.

## Prior research (primary studies - read the relevant section)
- `research/OPINION_TELEPORTS_SYNTHESIS.md` - the settled 3 cm / 10 deg cap and why (six opinions).
- `research/U146_DIGEST.md` - how the no-teleport test measures (node transforms, bell excluded).
- `research/S62_DIGEST.md` - the ENGINE keeps the men apart (FightSeparation); the room must not re-separate.
- `research/U196_DIGEST.md` - your own last change here (overlap corrections, C215 shuffle latch).
- `research/S4_BODY_RADIUS.md` - what fight_room_positions_test checks.
- Topic page `research/topics/contact_collision.md` (Settled: "No body teleports").

## Prefab check
None: this fixes our own room's write order; no plugin does that.

## Build (in this order; push the branch after each test goes green)
1. Instrument: a probe (tools/u198_root_writes.gd, or a debug arm in the room behind an option) that records every root write
   per frame (writer name, delta) on boxing seed 94301 and prints the writer of each >3 cm frame delta. Put its output in
   the digest BEFORE any fix.
2. Fix the order / the bypass so the bounded write is last on every path. (1) and (2) should both go green.
3. The two hangs: find the loop (a hang is usually a `while` whose exit the new order never reaches). Fix it.
4. pair_live: prove the cause (print which qualifying condition fails on the 14.10 s landed jab), then fix or report.

## Gate (a ceiling, not an exact count)
- fight_room_no_teleport_test, fight_room_ring_bounds_test, fight_room_positions_test, fight_readable_onset_test,
  fight_stage_realism_test, fighter_gloves_both_corners_test, fight_body_overlap_test pass; say
  plainly for any that cannot yet, with the probe's numbers.
- pair_live: passes, or the digest proves why it cannot on generated bodies.
- Must NOT move: fight_body_layers_live_test,
  fight_contact_stop_test, footwork_beats_reach_room_test, boxing_output_test. Never loosen a test's bound.
- NEVER TEST IDENTICAL FIGHTERS; fighters legal for their ruleset (the room books its own legal pair - keep it).

## Tests (tier: script edited)
Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`. One test at a time, then the subset:
`python Godot/tools/run_tests.py --only fight_room_no_teleport,fight_room_ring_bounds,fight_room_positions,fight_readable_onset,fight_pair_live,fight_stage_realism,fighter_gloves_both_corners,fight_body_layers_live,fight_body_overlap,fight_contact_stop,footwork_beats_reach_room,boxing_output`
Never the full suite (nightly). run_tests.py now kills the whole Godot process tree on timeout (S124) - a hang costs 600 s,
not the slot.

## Owned files
- `Godot/scripts/FightWorldLiveScreen.gd` (~5,400 lines - never open it whole; grep -n, then sed -n windows around :2990-3010,
  :3060-3135, :3490-3510, :3725-3750 and the `_process` order)
- `Godot/scripts/FightStagePlayer.gd` (~4,900 lines - only root/placement paths; grep first)
- `Godot/tools/u198_root_writes.gd` (new)
- `research/U198_DIGEST.md` (new)
Read-only: the five tests named above (do not edit their bounds), FightRealtime.gd.

## Deliver
Branch `cursor/u198-room-root-writes` (never master), commit per fix, push, write U198_DIGEST.md (probe table before/after,
each test before/after), then `python Tools/agent_comms.py send --from cursor --to claude --topic U198 "<one line>"`.
Trap: the probe must read the SAME quantity the tests read (node transforms after the whole frame), or it will name a
writer that is later overwritten - measure the posed thing, not an intermediate.

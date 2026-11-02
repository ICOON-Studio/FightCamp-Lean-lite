# TASK_GROUND2B - each ground move at its own speed (second Claude session)

Model: Claude (a side session in its own worktree of E:\FightCamp\Lean, branch `claude/ground2b`). Discipline: MMA
ground prototype, operator-approved (Q-S294-58; S335 "Yes, split it"). Lean rules apply (its CLAUDE.md).

## Why
`scripts/grapple/GrapplePlayer.gd` plays every keyframe gap at a flat SEGMENT_S = 0.5 s (GrappleMap stores no timing),
so a big roll and a small hand shift take the same time. On the film that reads as robotic.

## Spec
- NEW `scripts/grapple/GrappleTiming.gd` (pure, static): `durations(frames: Array) -> PackedFloat32Array`, one duration
  per gap. The duration comes from how far the joints travel: the largest joint move of either man / SPEED, clamped
  to [0.18, 1.2] s. The hips/Core count double (a big body shift is slow, a hand flick is fast).
- Calibrate SPEED against the Sekai reference clip lengths (BJJ_SOURCES_S334.md, hand-keyed, 24 fps): kimura from side
  control 4.8 s, americana 5.2 s, toreando pass 10.0 s, back take 7.9 s. Pick the closest GrappleMap moves by title or
  tag. Their totals land within +-35% of those lengths. Write the matches and the totals into the test's output.
- GrapplePlayer uses the durations: `length_s()` = their sum; `joints_at()` finds the gap by cumulative time;
  `shown_frame()` maps to the nearest keyframe. Positions (1 keyframe) breathe as now.

## Contract
OWNS: Lean/scripts/grapple/GrappleTiming.gd, Lean/tests/grapple_timing_test.gd, Lean/scripts/grapple/GrapplePlayer.gd
RED_TEST: tests/grapple_timing_test.gd -> PASS grapple_timing_test
REGRESSION: grapple_db_test, grapple_pose_test, grapple_graph_test
VISUAL: yes (re-film with `-- walk=10`, contact sheet opened, then the operator's OK)

Owner collision: TASK_GROUND2A (Cursor) also edits GrapplePlayer.gd, but only `joints_at()`'s last lines. This task
changes the time lookup. Land 2B FIRST, and Cursor rebases. Or the collector applies both hunks by hand.

## Prior research
BJJ_SOURCES_S334.md (Sekai clip lengths, "Timing is not stored ... We set the timing ourselves"), S335_DIGEST.md,
feedback_coach_walks_never_runs (clips at measured pace).

## What would a human do?
An animator retimes keyframed poses by spacing: big weight shifts get more frames, small adjustments fewer. It's the
same as timing by joint travel.

## Prefab check
None needed. Godot's Animation resource could hold the keys, but the frames are built at runtime from the graph, so a
duration array is all it takes.

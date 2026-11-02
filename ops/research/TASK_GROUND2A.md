# TASK_GROUND2A - the two women stop sinking into each other on the ground (Cursor)

Model: Cursor (default model). Discipline: MMA ground prototype, operator-approved (Q-S294-58 "Build the prototype now";
S335 "Yes, split it"). Repo: **E:\FightCamp\Lean** (branch `cursor/ground2a`, its own worktree under E:\FightCamp\wt).
Lean rules apply: its CLAUDE.md, no script over 500 lines, run Godot headless only, nothing opens on the screen.

## Why
The ground-move browser (`scripts/grapple/`, open with `-- jump=grapple`) plays GrappleMap's stick-figure data on two
MetaHuman bodies. The data's men have no volume, so in mount, side control and back control our torsos and thighs
pass through each other. The operator saw the film: "the video looks amazing, can still be improved".

## Spec
1. NEW `scripts/grapple/GrappleContact.gd` (pure, static, no scene): the body as capsules between joints. Use the 23
   GrappleMap joints of each man (world space, already scaled) with these radii (metres): torso Core-Neck 0.13, hips
   LeftHip-RightHip 0.11, thigh Hip-Knee 0.075, shin Knee-Ankle 0.05, upper arm Shoulder-Elbow 0.05, forearm
   Elbow-Wrist 0.04, head (sphere at Head) 0.10.
   - `penetration(men: Array) -> Dictionary`: deepest overlap between ANY capsule of man 0 and ANY of man 1, its
     normal and the two capsules. Hands and wrists are excluded: a grip is meant to touch.
   - `separate(men: Array) -> Array`: returns new joint arrays in which the overlaps are pushed out. Each man's whole
     set moves half the depth along the normal, plus a lean of the trunk joints (Core, Neck, Head, shoulders, elbows),
     at most 0.06 m a frame and 4 iterations. Wrist, Hand and Fingers joints of a man stay put when they are within
     0.05 m of the other body (grips keep their place). GrapplePose's IK then re-reaches them.
2. Hook it into `GrapplePlayer.joints_at()` (scripts/grapple/GrapplePlayer.gd, 120 lines; the loop that builds `out`, just before
   `return out`): `out = GrappleContact.separate(out)` behind `var contact := true`.
3. Do NOT change GrapplePose.gd, GrappleGraph.gd, the browser, or any file outside `scripts/grapple/` + `tests/`.

## Contract
OWNS: Lean/scripts/grapple/GrappleContact.gd, Lean/tests/grapple_contact_test.gd, Lean/scripts/grapple/GrapplePlayer.gd
RED_TEST: tests/grapple_contact_test.gd -> PASS grapple_contact_test
REGRESSION: grapple_db_test, grapple_pose_test, grapple_graph_test
VISUAL: yes (Claude films and judges it before merging; Lean is outside code_gate)

## The test (write it FIRST; it must go red on main)
`tests/grapple_contact_test.gd` (extends SceneTree, the style of tests/grapple_graph_test.gd). Over every keyframe of
the sequences tagged `mount`, `side_control`, `back`, `full_guard` (GrappleMapDB.tagged), scaled by 0.97:
- CONTROL (contact = false): it prints the share of keyframes deeper than 0.02 m, and that share must be > 20%. This
  proves the instrument reads the bug.
- FIXED: depth median < 0.005 m and 95th percentile < 0.02 m.
- Grips kept: for wrists within 0.05 m of the other body before, the wrist moves < 0.03 m (95%).
- Motion kept: the mean joint moves < 0.05 m from the data (we push apart, we don't redraw the move).
- Ends with `PASS grapple_contact_test` / `FAIL n` and quit(0/1).
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/grapple_contact_test.gd`
Then the three REGRESSION tests the same way. Never `_console.exe`.

## PR body
`RESULT: tests/grapple_contact_test.gd -> PASS grapple_contact_test` plus the printed control share and the fixed
median / 95% numbers.

## Prior research
`python Tools/prior_research.py contact push-out paired` -> C168-C175 (the old project's per-hold contact rounds: the worst drift was
15-19% after fixes, with per-man scaling to blame) and FightPoseSolver push-out. BJJ_SOURCES_S334.md "Gate": "MetaHuman torsos WILL clip in mount and
back control. Expect a per-hold push-out pass". S335_DIGEST.md.

## What would a human do?
An animator cleaning mocap of two grapplers keeps the contacts (hands, hooks) pinned and nudges the bodies' roots and
spines apart until skin meets skin. Never redraw the move, only resolve the overlap. Capsule collision is the
standard rig-side tool for that (it's how game physics proxies are built).

## Prefab check
Godot has no two-character pose-separation node. PhysicalBone3D ragdolls would fight the animation and are
frame-rate dependent. Capsule overlap is ~60 lines of math (segment-segment closest points), so we write it. Licence: our own code.

## The trap
Pushing both men apart without pinning the grips breaks every hold: wrists must stay within 3 cm. The IK in
GrapplePose re-reaches pinned wrists, so leave them in the joint arrays.

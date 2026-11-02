# TASK U99 — CURSOR — "NOT SO SMOOTH": WHERE THE BODIES JERK, FRAME BY FRAME, AND WHAT CAUSED EACH JERK

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u99-jerk-census` - Claude creates it from `master`
before launch. Push the BRANCH. Stage: S4a (operator, 2026-09-14, on the latest side-by-side: "Right side is much better
but still the animation lacks some things it's not so smooth and reactions need syncing or something").

**Test tier: A NEW TOOL ONLY, NO PRODUCTION SCRIPT EDITED.** Parse gate on the new `.gd`; the tool run; no
`run_tests.py`. `python research/U99_check.py` must exit 0 before you commit - if it cannot, do not commit: send
`--topic "U99 BLOCKED"` with its FAIL lines. ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_jerk.gd` - NEW.
- `research/U99_jerk.json`, `research/U99_JERK.md` (25 lines at most) - NEW.

## What to measure

The live room (`res://scenes/FightWorldLive.tscn`, `configure({"seed": s, "rounds": 3})`, `setup()`, then
`_process(1.0 / 30.0)` per frame until the readout says `FIGHT OVER` - exactly as `tools/measure_contact_miss.gd` drives
it) on the realism seeds 94301, 51227 and 77003, production defaults. Per frame, per side, read from the CURRENT pose
(`FightStagePlayer.bone_world(name)`, headless-safe):
- world positions of `Head`, `Chest`, `LeftHand`, `RightHand`, `LeftFoot`, `RightFoot`, and the hip midpoint
  (`LeftUpperLeg`/`RightUpperLeg`);
- for each of those 7 points, velocity v(f) = (p(f) - p(f-1)) x 30, acceleration a(f) = (v(f) - v(f-1)) x 30 and JERK
  j(f) = |a(f) - a(f-1)| x 30 (m/s^3);
- CAUSE FLAGS for that side on that frame: `take_changed` (the AnimationPlayer's current animation differs from the
  previous frame's, or restarted), `join_active` (a take change in the last 0.27 s), `warp` (the room's
  `warp_offsets()[side]` changed this frame), `gap_walk` (the room's `_gap` changed this frame), `contact_push` (the
  player's `contact_stats()["pushes"]` rose this frame - the contact solve lands on master soon; until the player has
  a `contact_stats` method, check `has_method` and leave the flag false), `lock_release` (the player's
  `foot_lock_stats()["releases"]` rose this frame).

`U99_jerk.json`: `{"population": {"seeds": [...], "rounds": 3, "fps": 30, "fighters": "f01_m_box_welter v f09_m_bare_welter", "defaults": "production"},
"frames": {"94301": n, ...}, "points": ["Head", ...],
"by_point": {point: {"p50": x, "p95": x, "p99": x, "max": x}},
"by_cause": {flag: {"frames": n, "jerk_p95": x, "share_of_top1pct": x}, "none": {...}},
"top": [ {"seed", "frame", "side", "point", "jerk", "take", "prev_take", "flags": [..]} x 40 ]}`
where the jerk summarised per frame is the MAX over the 7 points, `share_of_top1pct` is the share of the worst 1% of
(frame, side) jerks that carry that flag, and `none` is frames with no flag.

`U99_JERK.md` opens with `## DECISIONS`: which cause carries the worst jerks (share of the top 1% per flag), the worst
point, and the 5 worst moments with take pairs.

## Commit

`git status -s` first. Commit ONLY the owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin cursor/u99-jerk-census`; `python Tools/agent_comms.py send --from cursor --to claude --topic
U99-ready --body <hash>`. Do not edit HANDOFF.md or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`,
`clean`, `rebase` or `merge`.

## The trap

Jerk is a third difference: one frame where a position is read from a stale pose (the previous frame's, or the rest
pose) makes a spike three frames wide that is the instrument, not the animation. Read every point AFTER `_process`
returns, from `bone_world`, never from `get_bone_global_pose`. The check pins the frame counts to the realism test's
(19802 / 19802 / 19866) and requires the `none` bucket to be far calmer than `join_active` - a stale read would spike
everywhere alike.

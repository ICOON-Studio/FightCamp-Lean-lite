# TASK U91 — CURSOR — BACK TO STANCE AT THE RIGHT MOMENT: HOW MUCH CLOSER IS THE NEAREST IDLE PHASE?

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U80`.
Stage: S4a (transitions must read as a real fight) - a TRACE, no behaviour change.

**Test tier: ONE TEST FILE EDITED, REPORT LINES ONLY.** Parse gate on the test, run it once before and once after your
edit; every RULE line byte-identical. No subset, no suite.

## Owned files

- `Godot/tests/fight_stage_realism_test.gd` - report lines only.
- `research/U91_STANCE_ENTRY.md` - NEW, yours, 30 lines at most.

## Start

`git fetch origin && git checkout -b cursor/u91-stance-entry origin/master` (master holds your U90 trace, `1509640`).

## Why this exists

Your U90 found that the joins breaking R5 are mostly RETURNS TO STANCE: react_head->idle 218 of 240 windows over the
bound, jab->idle 170/172, cross->idle 134/140. The player enters the idle loop at whatever phase it picks; the pose
the body is leaving may be far from that phase and close to another. Games enter a loop at the phase nearest the
current pose. Before anyone builds that, measure how much nearer the best phase is.

## What to read - ONLY these

- `Godot/tests/fight_stage_realism_test.gd`: `sed -n '192,300p'` (`_sample`, `_clip_bases`: how a take's pose at a
  position is composed from its rotation tracks) and your own U90 trace in `_rule_joins` (`grep -n "R5-PAIRS" <file>`).

## The trace (report only)

For every R5 window whose INCOMING role is `idle`, at its first frame `f`, on that side:
- `used_deg`: pose distance between the body's SEEN pose at `f - 1` and the idle take's own pose at `pos[f]`;
- `best_deg`: the smallest pose distance between that seen pose and the idle take's pose at any of its frames sampled
  at 30 fps; `best_phase_s`: that frame's time.
Pose distance = the mean, over LeftUpperArm, LeftLowerArm, RightUpperArm, RightLowerArm, LeftUpperLeg, LeftLowerLeg,
RightUpperLeg, RightLowerLeg, Spine and Chest, of the angle in degrees between the two skeleton-space bases (the
`_angle_deg` the test already has). Compose the idle pose with `_clip_bases`-style FK from the take's tracks.

Print after your U90 tables: `R5-ENTRY` - per outgoing role (react_head, jab, cross, hook_lead, hook_rear, slip,
react_body, block, other): windows, mean used_deg, mean best_deg, share of windows with best_deg < 0.5 x used_deg,
and the 10th/50th/90th percentile of best_phase_s.

## Gate

Run the test unchanged first (BASELINE log), then with your edit; diff the RULE lines - byte-identical. Digest opens
with `## DECISIONS`: the table, the population line, one sentence on how much nearer the best phase is. Commit the two
owned files with paths on the commit line, `git show --stat HEAD`, push `cursor/u91-stance-entry` (never master),
mail `--topic "U91 ready"`. Do NOT edit HANDOFF.md. Never `git stash`. STOP.

## The trap

`pos[f]` is the idle take's position AFTER the change, and the idle take may be `idle#1` or `idle#2`, not `idle` -
compose from the take actually held at `f`, not from the bare role.

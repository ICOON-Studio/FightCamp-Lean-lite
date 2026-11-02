# TASK Q98 — QWEN — DOES A MIRRORED PUNCH START IN THE OTHER STANCE? FEET AT THE FIRST AND LAST FRAME OF EVERY TAKE

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q98-mirror-stance` - Claude creates it from `origin/master` before launch. Push the BRANCH.
Stage: S4a (transitions) - forecast research.

**Test tier: A NEW TOOL FILE ONLY.** Parse gate on your tool, then run it. No test suite.
`python research/Q98_check.py` must exit 0 before you commit. Only ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_take_stance.gd` - NEW, yours.
- `research/Q98_take_stance.json` - NEW, written by your tool.
- `research/Q98_TAKE_STANCE.md` - NEW, yours, 25 lines at most.

## Why this exists

Cursor's U90 found that joins INTO `hook_rear` break the join rule on 59 of 59 windows, with a LEG as the worst bone,
and hook_lead <-> hook_rear 100%. `hook_rear` is the lead hook MIRRORED (`FightClipMirror`). A mirrored clip may start
with the other foot forward - the other stance - so entering it from stance swaps the feet inside a 0.27 s join.

## What to read - ONLY these

- `Godot/tools/probe_take_skate.gd` (136 lines, read it whole): how to bind f01 through `FightStagePlayer` exactly as
  the room does, play one take alone with the node still, and compose bone positions from `get_bone_pose`.
- `Godot/scripts/FightClipBinding.gd`: `grep -n '"mirror"' Godot/scripts/FightClipBinding.gd` and ~10 lines around
  each hit - which roles are mirrored and from which source.

## What the tool measures

On f01, for EVERY take the player holds (every animation on its AnimationPlayer), at its FIRST and LAST frame, with
the node still: both toes' positions in the node's frame - `forward` along the node's +Z, `lateral` along
`forward.cross(Vector3.UP)` (check: facing +Z this is -X) - and:
`lead` = "LeftToes" or "RightToes" (the larger forward coordinate), `split_m` = forward difference between the toes,
`width_m` = absolute lateral difference.
Also, for idle's first frame as the reference, `swap` = true when a take's first-frame `lead` differs from idle's.

JSON `res://research/Q98_take_stance.json`:
```
{"population": {"fighter": "f01_m_box_welter", "binding": "boxing", "node": "still"},
 "idle_reference": {"take": "<idle take name>", "lead": "LeftToes", "split_m": 0.0, "width_m": 0.0},
 "takes": [{"take": "hook_rear", "role": "hook_rear", "mirrored": true, "source_role": "hook_lead",
            "first": {"lead": "...", "split_m": 0.0, "width_m": 0.0}, "last": {...}, "swap": true}]}
```
`mirrored` comes from the binding's `"mirror": true`. The binding has no source field: `source_role` is the role bound
WITHOUT a mirror to the same `path`, `start_s` and `end_s` (for `hook_rear` that is `hook_lead`), or `""` if none is bound.

## The digest `Q98_TAKE_STANCE.md`

Opens with `## DECISIONS`. One table: take -> mirrored, first lead, first split, last lead, swap. One line: which takes
start in the other stance from idle.

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q98-mirror-stance`;
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q98 ready" --body "<hash>"`. Do not edit HANDOFF.md.

## The trap

A mirror is a reflection: a mirrored take's split and width must equal its source take's (within 1 cm) with the lead
foot flipped. If yours do not, the tool is reading the wrong frame or the wrong axis - the check tests exactly this.

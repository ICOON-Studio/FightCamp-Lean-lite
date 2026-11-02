# TASK Q97 — QWEN — WHY A PUNCH ENDS SHORT: THE MISS SPLIT INTO FORWARD, SIDEWAYS AND HEIGHT

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q97-contact-miss` - Claude creates it from `origin/master` before launch. Push the BRANCH.
Stage: S4a (every action reads as a real fight) - forecast research for the "range follows the take" fix.

**Test tier: A NEW TOOL FILE ONLY, no game script edited.** Parse gate on your tool, then run it. No test suite.
`python research/Q97_check.py` must exit 0 before you commit. Only ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_contact_miss.gd` - NEW, yours (start from a copy of `Godot/tools/measure_contact_clearance.gd`).
- `research/Q97_contact_miss.json` - NEW, written by your tool.
- `research/Q97_CONTACT_MISS.md` - NEW, yours, 30 lines at most.

## Why this exists

Codex's C113 (`research/C113_CONTACT_CLEARANCE.md`, 25 lines - read it) measured, in the live room, the distance
from a striking hand to the receiver's `Head` bone (`Chest` for body shots) at each striking take's contact time.
p50 is 0.43-0.48 m, so most punches end 10-30 cm short of the face. The fix depends on WHERE the miss is: too far away
(close the range), off to the side (the pair's line or the thrower's facing), at the wrong height, or at the wrong
MOMENT (the hand gets closer at another time in the take than the contact time says).

## What to read - ONLY these

- `Godot/tools/measure_contact_clearance.gd` - read it whole and COPY it: the same population (seeds 94301, 51227,
  77003; 3 rounds; 30 fps; the room's own two men), the same room stepping, the same contact rule and bone reading.
- `research/C113_CONTACT_CLEARANCE.md`.

## What changes from C113's tool

- ONE variant only: production (no `sway_roles` option).
- For every contact C113's rule records, also compute, in the THROWER's frame at that frame: `forward` = his node's
  +Z flattened to horizontal and normalized, `up` = world +Y, `right` = forward.cross(up). With `d = target - hand`
  (world): `forward_m = d.dot(forward)`, `lateral_m = d.dot(right)` (positive = the target is to his right),
  `vertical_m = d.dot(up)` (positive = the target is above the hand). `hand` = which hand was used.
- `closest_m`: the smallest hand-to-target distance (same hand, same target bone) over EVERY frame of that take
  instance, from the frame it started to the frame it ended or was cut - which includes the contact frame;
  `closest_offset_s`: that frame's take position minus `contact_s` (negative = before the contact time).
- `take_length_s`: the take's `Animation.length`.

Row: `[seed, frame, side, take, role, contact_s, take_length_s, gap_m, hand, hand_to_target_m, forward_m, lateral_m,
vertical_m, closest_m, closest_offset_s, target_bone]`.

JSON `res://research/Q97_contact_miss.json`:
```
{"population": {"seeds": [94301, 51227, 77003], "rounds": 3, "fps": 30, "fighters": ["...", "..."]},
 "columns": [the sixteen names above, in that order],
 "contacts": [[...], ...],
 "summary": {"<role>": {"n": 0, "hand_to_target_m": {"p10": 0.0, "p50": 0.0, "p90": 0.0}, "forward_m": {...},
                        "lateral_m": {...}, "vertical_m": {...}, "closest_m": {...}, "closest_offset_s": {...}}}}
```
Percentiles by linear interpolation between closest ranks.

## The digest `Q97_CONTACT_MISS.md`

Opens with `## DECISIONS`. Names the population. One table: role -> n, p50 of hand_to_target, forward, lateral,
vertical, closest, closest_offset. One line per role saying which component is the largest part of the miss. No fix
proposed - that is Claude's.

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q97-contact-miss`;
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q97 ready" --body "<hash>"`. Do not edit HANDOFF.md.

## The trap

`right = forward.cross(up)` - check its sign with one hand-computed case before trusting it (facing +Z with +Y up, it
must come out as -X), because Godot's named directions are not data axes (Vector3.FORWARD is -Z and cost us a pass
once). And a take cut before its contact time is not a contact, exactly as in C113.

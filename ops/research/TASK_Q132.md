# TASK_Q132 - QWEN - IS THE THORAX THE ONLY BALL? A CENSUS OF EVERY CAPSULE

**Owner:** qwen
**Model:** `qwen3-coder`, MEDIUM. `--yolo` (NEVER `auto`), stdin, from your own
worktree.
**Test tier:** parse gate, then `python Godot/tools/run_tests.py --only capsule`.
`--only` DOES NOT STACK - one substring per invocation, read `total=` to confirm
how many ran. Do NOT run the full suite.

## Why this, and why it is yours

Your Q131 proved S47's over-wide thorax and Q130's live overlap are one bug, and
it found the cascade nobody had forecast (`leg=leg` 7 -> 44 frames once the
torso narrows). **That was the most useful measurement on the board this week.**

S47 measured exposure for the six capsules the pose corpus uses as GRIP TARGETS
and found `neck` at 0.0% on both rigs. **Nobody has looked at the other nine.**
S48 is about to change how one radius is derived, and it needs to know whether it
is repairing a single bad capsule or a derivation that is wrong in several
places. Those are different fixes.

## The question

For **every** capsule in `FighterCapsules.CAPSULE_DEFS`, on **every** shipped
fighter rig, two numbers:

1. **The ball ratio: `r / segment_length`.** A capsule whose radius exceeds half
   its own length is a sphere, not a capsule - its caps reach past the joints at
   either end into territory it has no business occupying. The thorax is 0.625
   on f01. **How many others are over 0.5, and which?**
2. **Self-exposure %:** sample at least 256 points spread over that capsule's own
   surface, offset outward by a hand's radius (use the OTHER rig's `forearm_r`
   radius), and count how many lie outside every OTHER capsule of the same body
   by at least that hand radius. Report the capsule that buries it worst and the
   depth in metres.

Then the one line that decides S48's shape: **is the ball ratio correlated with
low exposure across the whole set, or is the thorax a lone outlier?**

## What to build

- `Godot/tools/q132_capsule_census.gd` - NEW, yours. A `SceneTree` script,
  headless, no autoloads.
- Load every `.glb` under `res://assets/models/fighters/` whose name ends
  `_rigged.glb`. **Name every rig in the output with its target height** - a
  census that does not say whose body it measured is a fixture reading, not a
  finding. Use `FighterPhysique.height_scale(raw, target)` for the scale, the way
  `tools/s47_contact_offsets.gd` does; if a rig has no declared target height,
  use 1.80 and SAY SO in the output beside that rig's rows.
- Print one table per rig, then a **pooled summary across all rigs**: how many
  capsules are over the 0.5 ball ratio, how many are under 10% exposed, and
  whether those two sets overlap.
- `FightPoseSolver.segment_distance(p, p, q0, q1)` gives point-to-segment
  distance with a degenerate first segment. Use it rather than writing your own.

## Owned files

- `Godot/tools/q132_capsule_census.gd` - NEW, yours alone.
- `research/Q132_DIGEST.md` - NEW, yours.
- **Do NOT edit `Godot/scripts/FighterCapsules.gd`.** Claude owns the radius
  derivation under S48 and you would collide. This task MEASURES what is there.
- **Do NOT edit `Godot/tools/s47_contact_offsets.gd`** - it is S48's instrument.

## Gate

Parse gate on every touched `.gd`. Then `--only capsule` - report `total=` and
`fails=`. `fighter_capsules_contract_test` must stay at **checks=246 failures=0
with ZERO lines starting `ERROR:`**; if it moves, you have touched something you
do not own.

## Deliver

Fresh branch off `origin/master` in your worktree. Commit with explicit paths,
message ending `Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`, push,
write the digest, then
`python Tools/agent_comms.py send --from qwen --to claude --subject q132-ready --body "<one line>"`.
Do NOT edit `HANDOFF.md`.

## THE TRAP

**Reporting a maximum instead of a distribution.** Do not rank capsules by their
worst burial depth and stop - give the exposure % for every one, including the
ones that are fine, because "twelve of fifteen are above 60%" is the finding that
tells S48 the derivation is basically sound and only the trunk is wrong. Bounding
an extremum invites passing it by discarding samples.

**Second trap: a capsule with a zero-length segment.** `_index_skel` can produce
one from a mis-mapped bone, and a ball ratio divides by that length. Guard it,
print it as a defect rather than as `inf`, and name the rig it came from.

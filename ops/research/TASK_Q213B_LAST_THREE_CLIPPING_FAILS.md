# TASK Q213B - fix the last 3 clipping-gate failures (Codex)

Model: gpt-6-luna, medium. Owner: Codex (next free seat). No new worktree needed unless branching cleanly off
master is easier; this is a small, scoped fix.

## Why (primary source, re-measured 2026-10-02 S142, not from a cached %)
`python Tools/pc_watchdog.ps1 -Once` GREEN, then:
```
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/q213_clip_gate.gd -- mode=clips pin=1
```
reads **23/26 moves PASS** on today's master - the roadmap's old "Q213 = FAIL 0%" line was stale, from before the
S125-S130 clipping fixes landed (jab lunge root cause, rear-hook knee-to-knee, the glove-stop smoothing). Only
three moves still fail:

| move | failing events | worst_cm | spacing |
|---|---:|---:|---|
| boxing_one_two | 1 | 8.84 | 1.0600 |
| boxing_rear_hook | 3 | 11.25 | 0.7285 |
| boxing_shovel_hook | 8 | 9.30 | 0.8175 |

`boxing_shovel_hook` is already flagged elsewhere as not a clean exact-identity certificate (C223_DIGEST.md: "a
lunging body punch, not the elbow-tucked rising shovel... needs an elbow-in, rising forearm layer") - its
clipping failure and its pose-authenticity problem may be the SAME root cause (the straight-arm lunge reaches
too far into the receiver). Read that section before assuming this is purely a spacing/IK fix.

`boxing_rear_hook` already had one root-cause fix (S130: "knee-to-knee on the centre line") - this is its
SECOND clipping failure, at a different body-pair than S130 fixed (S130 fixed a leg/knee overlap; the current
11.25cm worst is `ARM` class per `Q213_WORST_CLIPS`, so a different joint). Do not re-apply S130's fix verbatim;
re-measure which pair is overlapping NOW (see Build step 1).

## Build
1. Get the exact overlapping bone pair, not just the class: run the same command with a seconds/frame window
   that lets you read per-pair detail, or add a temporary print (not committed) of `EventTracker`'s worst-row
   dict for these three moves specifically - the `clips` mode print line currently only shows `worst_cm`, not
   the pair. (`live` mode's table format - see Q213_DIGEST.md's old "Live 180s" table - has a `worst_pair`/`at`
   column; porting that same column to `clips` mode's per-move line is probably the fastest way in, and is a
   legitimate small addition to `q213_clip_gate.gd` if you need it - owned file.)
2. For each of the 3 moves, trace the overlapping pair back to the clip's own geometry (same method as S126/S130:
   read the clip's bone track at the failing frame, find what pushes the limb/joint into the other body).
3. Fix at the source the earlier sessions used: either the clip's own pose (small retarget correction) or a
   per-move pose_layer correction (see `s136_cross_bob_solve.gd` for the established pattern: a small, bounded,
   targeted correction - never a blanket engine constant change that could move all 23 currently-passing moves).
4. Re-run the SAME gate command after each fix. A move passing is not done until all 3 pass AND the other 23
   are reconfirmed still passing (one full gate run covers both).

## Acceptance
`mode=clips pin=1` reads `moves=26 pass=26 fail=0` (or explains, with evidence, why a specific move cannot pass
without a tradeoff the operator must judge - do not silently loosen `Q213_LIMITS` to make a number move).

## Owned files
`Godot/tools/q213_clip_gate.gd` (diagnostic-print additions only, not the thresholds), whichever clip-authoring
script or pose_layer the actual fix needs (name it once found - likely `FightClipBinding.gd` or a new
`pose_layer` entry near the existing S120/S126/S130/S136 ones), `research/Q213B_DIGEST.md`.

## Prior research
`python Tools/prior_research.py clipping gate rear hook shovel hook one two`: Q213_DIGEST.md (the tool's own
history), C223_DIGEST.md (shovel_hook's known pose problem), the S126/S130 commits (`555a6e1e`, `f4eb04fa`) for
the established fix pattern on this exact gate.

## What would a human do?
Measure which bone pair is actually overlapping before touching anything - "ARM" and "LEG" are coarse classes
covering many joints; guessing which one without the pair name risks fixing the wrong joint and leaving the
gate red for a different reason.

## Prefab check
N/A - fixing existing certified moves, not authoring new ones.

## Test (tier: script edited)
Parse gate on every touched .gd first. Then the Q213 gate command above (not the big suite - this tool is
standalone). If a `pose_layer` is touched, also `python Godot/tools/run_tests.py --only <that move's name>,certified --jobs 2`.

## The one trap
`pin=1` applies the room's existing glove-stop pin (S125) before measuring - run WITHOUT `pin=1` too and note
the difference; a fix that only passes with the pin may be hiding a real overshoot the pin happens to catch,
which is fine for the `.exe` (the pin ships) but worth naming explicitly, not discovering later.

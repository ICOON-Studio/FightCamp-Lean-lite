# TASK Q206 - QWEN - THE FENCE PIN: SPLIT FENCE_PIN OFF THE GENERIC CLINCH (S103)
Owner: qwen. Assigned 2026-09-27 (S103). Model: qwen3-coder medium, `--yolo`. Branch `qwen/q206-fence-pin` from
`origin/qwen/q205-mma-state-share` (Q205's `MMA_CLINCH_ENGAGE_BASE` lever, NOT on master - see the verdict at the end of
`research/Q205_DIGEST.md`), own worktree. Claude merges.

## Why
Q205 (`research/Q205_DIGEST.md`) lifted MMA clinch from 2.5% to 12.9% of the clock by raising the tie-up rate, but
the clinch is still ONE generic centre-ring state. G139 (`research/G139_THE_FENCE_CLINCH.md`, read §4, §5, §7)
says 70-85% of MMA clinch time is a man PINNED ON THE CAGE, that clinch takedowns succeed far more than open shots
(Sterling 50% vs 17%), and that most fence takedowns are walked back up inside 30 s. Q205 also left TD/5min at 2.02
against G138's 1.5 - a fence where the defender wall-walks up is part of the answer.

## What would a human do?
A cornerman reads the fence as its own place: the pinner holds double-unders or over-under, knees the thigh, changes
levels, and dumps; the man on the fence frames the hip, fights for the underhook, circles his head off and turns. The
referee breaks them after ~8-20 s with no level change or strike. A downed man on the fence wall-walks straight back up
unless the top man rides him. A FightMetric coder times each pin and records how it ended.

## Prefab check
None: this is our own engine's state machine. The rates come from G139 §7 (already collected); no dataset tags
per-second fence states. Reuse `Godot/tools/q205_mma_state_time_census.gd` as the instrument - extend it, do not write a
second census.

## Do
1. Before anything, run Q205's census on master and save the baseline table (clinch share, TD/5min, TD land %, failed
   shot destinations). Name the populations (Q205's three matchups; never identical fighters).
2. Add FENCE_PIN as a SEAT of the clinch stance (e.g. `seat == "fence"` with a `pinner` side), NOT a new stance, so
   every consumer that switches on `stance == "clinch"` keeps working. Gate it to rulesets whose arena has a cage (MMA
   today; read how `mma_cage` reaches the engine - `FightRealtime.gd:1007` area) behind a new option `fence_pin`
   (default ON for MMA only). Boxing, kickboxing and judo must stay byte-identical: print hashes on 4 seeds each.
3. Transitions, per decision tick converted from G139 §7's per-second lambdas (J rates - tune against the TARGETS below,
   never against an invented median):
   DISTANCE/OPEN_CLINCH -> FENCE_PIN when the tie-up happens with a man near the wall (use `RingSpace` distance to the
   edge; the ring-position test already gates cage engagement at 20.91%) or by OPEN_CLINCH drift (~0.06/s);
   FENCE_PIN exits: takedown (via the existing `takedown_resolve` clinch weights, with a fence bonus), defender off,
   reversal, referee break after ~8 s of no strike/level change (a pinner strike zeroes the break hazard for 8-12 s).
   A takedown landed FROM the fence puts the downed man on the fence: GROUND_FENCE as a flag on the ground seat; the
   bottom man wall-walks (0.025-0.040/s, 0.008-0.015 when the top man rides - use his grappling edge).
4. Measure after with the same census. TARGETS (all CEILINGS/bands, say which you hit and which you did not):
   clinch 15-18% of the clock with 70-85% of it fenced; clinch-TD success above open-shot success; fence TDs walked up
   within 30 s in 50-70% of cases; TD/5min moves TOWARD 1.5 (2.02 today), TD land % toward 39%; ground share stays
   inside 25-32%; and **MMA leg share stays inside J20's 12-18% of strikes** - Q205's lever alone dropped it to 9.0%
   (`fight_realtime_test`), because clinch time it added threw no kicks. Real fights hold both numbers at once: find
   what the clinch/fence steals from distance kicking (fewer distance seconds, or kick choice at the fence edge) and fix
   THAT, never the test's band.

## Gate
Parse gate on every touched `.gd`, then
`python Godot/tools/run_tests.py --jobs 2 --only fight_realtime,grapple,fight_defence,fight_ring_position` no worse than
master (`fight_realtime_test` MUST pass - it passes on master) except pins your change moves (list each with old/new; Claude re-pins). Never the full suite. Check the PC first:
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` - exit 1 means stop and say so.

## Owned files
`Godot/scripts/FightRealtime.gd` (6,480 lines - NEVER open it whole; anchors: `_tie_up` ~:5393, the clinch tick
~:5410-5500, `_clinch_engage_base` ~:4811, `_clinch_break_p` ~:4805, `cage_clinch` ~:4964, `mma_cage` ~:1007; use
`sed -n` windows), `Godot/scripts/FightGrappleSeat.gd` if a seat constant is needed, `Godot/tools/q205_*.gd` (extend),
`Godot/tools/q206_*.gd`, `research/Q206_DIGEST.md`, a new `Godot/tests/fight_fence_pin_test.gd` (MMA: a pin
occurs and exits by more than one route over 20 seeds; boxing: zero fence seats).

## Deliver
Commit and push AS YOU GO. Digest with before/after census first, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q206 --body "..."`. Do NOT edit HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md (logs). All research is open: root `RESEARCH_INDEX.md`.
**Trap:** Q205 weighted states by tick SPANS - keep that; and a new seat string must be grepped everywhere `over_under`
is matched (`BroadcastRead.gd`, the presenter, scoring), or the fenced clinch silently falls out of clinch totals.

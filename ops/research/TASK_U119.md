# TASK_U119 — The bodies interpenetrate on screen. Make the room refuse it.

**Owner: Cursor.  Model: composer-2.5, medium effort, no Fast mode.**
**Test tier: A SCRIPT IS EDITED — parse gate, the focused test, then the named
subset. DO NOT run the full suite (318 tests, ~18 min).**

---

## THE DEFECT, OBSERVED NOT INFERRED

The operator watched a 30 s recording of `FightWorldLive` (MMA, seed 810039,
`shot=standing`) on 2026-09-21 and said: **"the corpses clip inside each
other"**. That is the second time this complaint has landed — it is also the
first item of the 2026-09-14 verdict ("bodies overlap").

It is real and it is visible at frame 453 of that recording: fighter A throws a
Rear Cross at a rendered hip gap of **0.94 m** and **his glove and forearm pass
through fighter B's head**, with the two skulls overlapping. Reproduce it:

```
Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/record_room.gd \
  --write-movie <ABS>/u119.avi --fixed-fps 30 --quit-after 900 \
  -- seed=810039 discipline=mma shot=standing
```

Frames 448-462 are the clearest. **LOOK AT THE PICTURE BEFORE AND AFTER YOUR
CHANGE.** A number that improves while the render still clips is not a fix.

## WHY IT HAPPENS — THE MECHANISM IS ALREADY IN THE TREE

`Godot/scripts/FightWorldLiveScreen.gd:1766-1790`, `_floor_clamped()`, is the
room's ONLY separation enforcement, and it is a one-dimensional hip check:

- `:1769` `_torso_floor_m = Capsules.torso_radius(_body_a) + Capsules.torso_radius(_body_b)`
  — one scalar, about **0.343 m**, the two men's summed TORSO radii.
- `:1784` `var room: float = maxf(placed.x - _torso_floor_m - FLOOR_GUARD_M, 0.0)`
  — and `placed.x` is the ENGINE'S OWN GAP, which is read and **never floored**.
  Only `placed.y` / `placed.z`, the two strike warps, are scaled down.

The function's own comment says so outright:

> "The room may be showing a gap tighter than the floor all on its own - a
> clinch, or a pair take driving the bodies. The warp cannot repair that and
> must not make it worse, so it goes to zero rather than negative."

So two things are unenforced, and **the second is the one on screen**:

1. the engine's gap itself is never floored, and
2. **nothing anywhere checks a LIMB or a HEAD.** At a 0.94 m hip gap the hips
   are comfortably clear of a 0.343 m floor while an extended arm reaches past
   0.6 m and arrives inside the opponent's skull. The hip check cannot see it
   and never will.

**THE CAPSULE MODEL THAT CAN SEE IT IS ALREADY WRITTEN AND THE ROOM DOES NOT
CALL IT.** `Godot/scripts/FightBodyCapsules.gd:163` —

```gdscript
static func pair_depth(a: Dictionary, b: Dictionary) -> float:
```

— returns capsule-capsule **penetration depth** via
`Geometry3D.get_closest_points_between_segments`, for any two parts. `:171`
`class_pair_key()` already classes parts (`hand`, `torso`, …). The room builds
`_body_a` / `_body_b` and then uses one scalar off them.

## WHAT TO BUILD

**1. A MEASUREMENT FIRST, AND IT IS ITS OWN DELIVERABLE.** Add
`Godot/tools/probe_body_overlap.gd` (a `SceneTree` tool, same shape as
`tools/record_room.gd` — instantiate, `configure`, `setup`, then pump). Over a
named seed and discipline it reports, per frame, the **worst penetration depth
across every part pair**, and prints:

```
OVERLAP seed=<n> discipline=<d> frames=<n>
OVERLAP worst=<m> p90=<m> p50=<m> frames_penetrating=<n> (<pct>%)
OVERLAP worst_pair=<classA>=<classB> at frame <n>
```

Report the number for seed 810039 MMA **before you change anything**. That is
the control arm, and without it no later figure means anything.

**2. THEN THE FIX.** A part-aware floor in `_floor_clamped` (or a sibling it
calls): when the capsule model says the rendered pose penetrates, push the pair
apart along the fight line by the depth, plus `FLOOR_GUARD_M`.

**CONSTRAINTS, AND THEY ARE WHAT MAKE THIS HARD:**

- **A clinch must still close.** The engine legitimately drives sub-floor hip
  gaps for a clinch or a pair take — the comment at `:1779` is right about
  that. Do NOT put a hard floor on `placed.x` that a clinch cannot cross. A
  TORSO=TORSO overlap at clinch range is the fight working; a **hand or forearm
  inside a head** is never right at any range. Treat the part classes
  differently and say in your digest which classes you refused and why.
- **Do not fix it by freezing the fight.** If the pair simply stops moving, or
  the gap never closes again, that is worse than clipping.
- Keep `warp_offsets()` reporting what the animation ASKED for (`:1738` says
  the measure tools read it).

**3. A TEST.** Extend `Godot/tests/fight_room_positions_test.gd`, or add
`Godot/tests/fight_body_overlap_test.gd`. It must FAIL on the current tree and
PASS after — run it against the unchanged code first and paste that red line in
your digest. **Assert the quantity the operator sees**: a head/hand penetration
depth of zero, not an internal scalar.

## OWNED FILES — yours, nobody else is in them

- `Godot/tools/probe_body_overlap.gd` (new)
- `Godot/scripts/FightWorldLiveScreen.gd` — **`_floor_clamped` and its helpers
  ONLY**, around `:1766-1790`. It is a big file: read `sed -n '1700,1800p'`
  and `sed -n '270,300p'` windows, never open it whole.
- `Godot/scripts/FightBodyCapsules.gd` — small, read it whole (~190 lines).
- `Godot/tests/fight_body_overlap_test.gd` (new) and/or
  `Godot/tests/fight_room_positions_test.gd`

## GATE

```
python Godot/tools/check_scripts.py <every .gd you touched>
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_body_overlap_test.gd
python Godot/tools/run_tests.py --only room
python Godot/tools/run_tests.py --only capsule
```

Ceiling, never an exact count: **fails must not rise above what those subsets
report on the unchanged tree.** Measure that first. If you land FEWER failures
than the ceiling, say so and push — do not hold a better result back.

## THE TRAP SPECIFIC TO THIS TASK

**A gate that reads its subject cannot fail.** If your test asks
`_floor_clamped` whether `_floor_clamped` is happy, it will always pass. Derive
the assertion from the CAPSULE GEOMETRY — two part capsules, their radii, the
distance between their segments — and let it judge the room's rendered
positions from outside. `FightBodyCapsules.pair_depth` is the right instrument
because it knows nothing about the fix.

Second trap: **`torso_radius` multiplies by `body["scale"]`**
(`FightBodyCapsules.gd:159`) because the parts are in MESH UNITS and the room
is in METRES. S4 (4) already lost a pass to a tripwire that compared world
metres against a floor still in mesh units and printed 0.364 m for 0.343 m. Any
new capsule you read needs that same `scale` factor.

## WHEN DONE

Commit, push to your own branch, write a short digest, and send one line with
`python Tools/agent_comms.py send --from cursor --to claude --subject u119-done`.
Do NOT edit `HANDOFF.md`.

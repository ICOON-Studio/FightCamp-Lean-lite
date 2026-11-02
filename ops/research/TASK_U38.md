# TASK U38 — CURSOR — TWO MEN ON THE CANVAS, AND A DOOR INTO THE ROOM

Model: Composer (Cursor's own pool), effort MEDIUM, Fast OFF.
Owner: cursor. Task id: U38.
Launch: `cursor-agent -p --force --trust`.

## The gap, verified before assigning

`Godot/tests/fight_world_anim_test.gd` (258 lines, **read it whole — it is the
working proof, and it is the only file you need to understand this task**) already
does all of this for ONE man:

- resolves the boxing surface through `ArenaSurface.for_discipline` →
  `arena_specs.json` → `ArenaRig.build` / `ArenaRig.surface_y`, deck at **1.27 m**
- instantiates `res://scenes/FightWorldPreview.tscn`
- mounts `f01_m_box_welter_rigged.glb` at `SpawnA` with **feet resting on the
  canvas**, scaled through `FighterPhysique.describe`
- grafts a clip with `BoneTrackGraft.graft()`, 22/22 bones
- and throws it

**`SpawnB` is empty.** Nobody has ever stood there. And
`FightWorldPreview.tscn` has **no route** — grep it: nothing in the game can
reach the scene at all. Those are your two jobs, and they are the only two.

## What you own

- `Godot/scripts/FightWorldStage.gd` — **NEW.** The mount helper.
- `Godot/scenes/FightWorldPreview.tscn` — may gain nodes; do not move the camera,
  the lights or the two markers.
- `Godot/tests/fight_world_pair_test.gd` — **NEW.** Your gate.
- whatever ONE file gives the scene its route (see below).
- `research/U38_DIGEST.md`.

## EXPLICITLY NOT YOURS — do not write a line of it

**No driver logic.** `Godot/scripts/FightStageDirector.gd` is Claude's and is
being written in parallel; it decides which clip each body plays and where the two
stand. **Do not read a beat, do not touch `FightBeatAdapter`, do not play a fight
clip in response to anything.** If you find yourself asking "what should he do
when the engine says X" you have crossed the line — stop and mount the second
body instead.

Also not yours: `FightRealtime.gd`, `FightNightScreen.gd`, `RingStagePanel.gd`,
`BoneTrackGraft.gd`, `HANDOFF.md`, `CURRENT_STATUS.md`.

## Job 1 — BOTH men, facing each other, feet on the canvas

`FightWorldStage.gd`, pure-ish and testable:

```
static func mount(world: Node3D, glb_path: String, spawn_name: String,
                  deck_y: float, kg: float, sex: String) -> Dictionary
```

Returns at least `{"ok": bool, "node": Node3D, "skeleton": Skeleton3D,
"animation_player": AnimationPlayer, "aabb": AABB, "scale": float,
"feet_y": float, "reason": String}`. Lift the GLB-load, the `_find`-by-class walk
and the feet-on-deck arithmetic straight out of `fight_world_anim_test.gd` — that
code is proven, do not re-derive it.

```
static func face_each_other(a: Node3D, b: Node3D) -> void
```

Each turns to look at the other, **Y only** — no pitch, no roll. Godot's forward
is `-Z`, so the yaw is `atan2(to_other.x, to_other.z)`. A boxer looks at his
opponent, not at the sky.

Then mount **f01 at SpawnA and f02 at SpawnB**, both on the boxing deck, and turn
them to face each other.

**The R31 family of traps applies to none of this** (there is no Control here) but
its cousin does: assign `expand_mode` before size on any TextureRect you add, and
never assign `size` to a full-rect-anchored Control.

### Your gate: `fight_world_pair_test.gd`

Assert the things that would actually be wrong, not that the code ran:

1. Both mounts return `ok`, and **two distinct** Skeleton3Ds with 22 bones each.
2. **Both pairs of feet rest on the canvas** — `is_equal_approx(feet_y, deck)` for
   each, exactly the way the anim test does it for one.
3. **They are apart**: the horizontal distance between the two root positions is
   > 0.5 m. Two bodies at the same mark is the failure this test exists to catch.
4. **They FACE each other, and assert it as a number.** Take each body's forward
   (`-global_transform.basis.z`), flatten Y, normalize, and assert its dot with
   the direction to the opponent is **> 0.9**. A dot near `-1` means they are
   back to back and reads as "mounted" to any weaker check.
5. **Neither is upside down or on his side**: each body's up
   (`global_transform.basis.y`) dotted with `Vector3.UP` is > 0.99.
6. f01 and f02 are **different meshes** — assert the two AABBs are not identical,
   so a copy-paste that mounted f01 twice fails here.

## Job 2 — a door into the room

`FightWorldPreview.tscn` is unreachable. Give it exactly ONE route, the cheapest
honest one:

**Add it to the existing developer/debug scene list** rather than inventing a new
menu. Find how the project already reaches its preview scenes —
`grep -rn "FightWorldPreview\|res://scenes/" Godot/scripts/ Godot/project.godot`
— and follow whatever pattern is already there. If there is a dev-scenes registry,
add one entry. If there is none, add the route to the screen that already lists
development tools and say so in your digest.

**Assert the route OCCURS**, in your test: resolve the route the same way the game
does and assert it yields `res://scenes/FightWorldPreview.tscn`. A route nobody
can reach is the seventh piece of correct, unreachable code this area has shipped,
and the previous six all had green tests.

Do **not** put it on a player-facing menu. This is a development view.

## Test tier — SCRIPTS EDITED, so:

```
python Godot/tools/check_scripts.py Godot/scripts/FightWorldStage.gd Godot/tests/fight_world_pair_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_world_pair_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_world_anim_test.gd
python Godot/tools/run_tests.py --only world
python Godot/tools/run_tests.py --only arena
```

**That is the whole gate. Do NOT run the full suite** — it is Claude's once, at
integration, and a concurrent run corrupts everyone's `user://` fixtures.
**NEVER pass `--godot` to `run_tests.py`.**

## Traps bought with real time

- **`fight_world_anim_test.gd` must still pass.** You are refactoring the mount
  out from under it. Either leave it alone entirely, or move it onto
  `FightWorldStage.mount` and re-run it — both are fine, silently breaking it is
  not. Its 23 checks are the R94 spike's evidence.
- `Skeleton3D.get_bone_global_pose()` **does not reflect a seek in a headless
  tree with no frame**. The anim test composes the chain by hand for exactly this
  reason (`_global_of`). If you need a bone's world position, copy that helper.
  A wrong number is worse than none.
- `var x := <call>` fails when the call returns Variant. Write the type.
- **`git rev-parse --abbrev-ref HEAD` before you believe a commit landed.** U34
  left this shared checkout on `cursor/u34-judo-board-caller` and six commits went
  to the branch while `git push origin master` answered "Everything up-to-date".
  **Push to master.**

## Close-out

Commit and push to master, write `research/U38_DIGEST.md`, and send:

```
python Tools/agent_comms.py send --from cursor --to claude --subject U38-done --body "<sha> pair=N/0 anim=23/0 world=... facing-dot=<a>,<b> route=<what you added, file:line>"
```

Do NOT edit `HANDOFF.md`.

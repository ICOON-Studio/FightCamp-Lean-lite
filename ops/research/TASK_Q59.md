# TASK Q59 — QWEN — TWO BODIES, ONE PERFORMANCE, ON SCREEN

Model: your default, **medium effort**. Owner: qwen.
**This is a BUILD task, not a study.** You have the checkout, Godot and the
credits, and the operator has ruled that the heavier work comes to you. Every
number you need has already been measured by someone else; nothing here is
research.

Test tier: **NEW MODULE + ITS TEST + ONE PREVIEW TOOL.**

```
python Godot/tools/check_scripts.py Godot/scripts/PairedStagePlayer.gd Godot/tests/paired_stage_player_test.gd Godot/tools/preview_paired_clip.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/paired_stage_player_test.gd
python Godot/tools/run_tests.py --only paired
python Godot/tools/run_tests.py --only fight_world
```

**Do NOT run the full suite.** It is twenty minutes and it is Claude's at
integration. **Only one Godot at a time in this checkout** — do not start a
second alongside your own.

## Owned files

- `Godot/scripts/PairedStagePlayer.gd` — **NEW. Yours alone.**
- `Godot/tests/paired_stage_player_test.gd` — **NEW. Yours alone.**
- `Godot/tools/preview_paired_clip.gd` — **NEW. Yours alone.**

Nothing else. Do not edit `FightStagePlayer.gd`, `FightWorldStage.gd`,
`PairedClipMount.gd`, `FightClipBinding.gd`, `FightBeatAdapter.gd`,
`GameState.gd`, `HANDOFF.md`, or any existing test.

## Why this exists

**We own sixteen paired two-body grappling clips and not one has ever been on
screen.** A paired clip is ONE performance danced by two bodies — both halves
authored in a single shared space, so their contact is a property of that space
and not of either body.

R106 proved the alignment survives the trip into Godot. **Every remaining cost
has been paid by somebody else already:**

| what | where | state |
|---|---|---|
| the 22-row BoneMap | shipping | done |
| the rest-pose correction | `retarget/rest_fixer` | **import-time and baked, so it SHIPS** (Q54) |
| the Z-up → Y-up rotation | trivial | known |
| **placing the pair at one shared transform** | `PairedClipMount` | **U55, merged at `fbfe294`** |
| what the clips contain | C91 | measured, see below |
| the camera | Q55 | measured, see below |

**This task is the assembly.** It is the last step, and it is the one nobody has
done.

## THE INPUTS, ALL ALREADY MEASURED — DO NOT RE-DERIVE THEM

### From U55 — `Godot/scripts/PairedClipMount.gd` (read it, it is ~103 lines)

Static functions, zero preloads, `checks=50 failures=0`:
- `shared_origin(a_root, b_root) -> Transform3D`
- `place(origin, a_offset, b_offset) -> Dictionary` — `{"a": …, "b": …}`
- `alignment_error(placed_a, placed_b, authored_a, authored_b) -> float`
- `in_step(a_pos, b_pos, tolerance := 0.016) -> bool`
- `pair_key(clip_name) -> String`, `pair_role(clip_name) -> String`

**`place` is `origin * offset` and NOT `offset * origin`.** U55 proved by test
that the other order fails at a rotated origin. Do not re-litigate it; call the
module.

### From Q54 — the node shape, and two honest NOT FOUNDs

- **Two `Skeleton3D`s under ONE shared `Node3D`, each with its own
  `AnimationPlayer`.**
- **Godot has NO built-in two-player sync** (searched; NOT FOUND). Start both on
  the same frame, give them the same `speed_scale`, and guard the drift with
  `PairedClipMount.in_step`.
- **Root motion on both halves at once is undocumented** (NOT FOUND). **Strip it
  from BOTH halves and drive the shared parent with the combined delta.** That is
  what `place()` is for: the pair moves as one rigid unit and neither body
  carries its own travel.

### From C91 — what the clips contain (`C91_PAIRED_CONTENT.md`, `4b71b9b`)

32 files, 16 pairs, **every pair's two halves agree on content length exactly**,
and only one pair carries dead air. Content lengths you will need:

```
Reversal                     1.833 s    (the two men SWAP top and bottom)
H2H_Punches                  1.167 s    (ground and pound)
Takedown_DoubleLeg_Start     1.667 s    (a standing entry)
H2H_ArmBar                   ~           H2H_Strangle   6.000 s
Takedown_BodyLock_End        2.500 s content in 4.833 s file — 2.333 s DEAD AIR
```

**`Takedown_BodyLock_End` is the one clip in the pack with dead air, and both
halves carry exactly the same amount.** Everything else is clean.

### From Q55 — the camera (`Q55_THE_GROUND_CAMERA.md`, `f1500e7`)

Y-up, metres, pair at world origin, long axis along X, floor at y=0:

```
establishing   position (0.0, 1.80, 2.60)   look_at (0.0, 0.35, 0.0)   fov 42
tight          position (0.40, 0.75, 1.20)  look_at (0.0, 0.30, 0.0)   fov 55
mat level      position (0.0, 0.22, 1.90)   look_at (0.0, 0.35, 0.0)   fov 62
```

Q55 also says the floor needs real extent (`PlaneMesh.size` at least 20×20, and
`subdivide_width`/`subdivide_depth` raised or the UVs jitter at a shallow angle),
and that a **blob `Decal`** is the cheapest thing that stops two bodies looking
like they float. Read Q55 §Q3 and §Q4 before building the room.

## WHAT TO BUILD

### 1. `Godot/scripts/PairedStagePlayer.gd`

`extends RefCounted`. One instance drives ONE pair. Model it on
`FightStagePlayer.gd` (489 lines, read it — it is the single-body equivalent and
the idiom to match), but **it is a separate class and must not modify it.**

```gdscript
## Mount both halves of a paired clip under one shared parent and play them as
## one performance. Returns a report, never a bare bool - say what happened.
func bind(shared_parent: Node3D, body_a: Node3D, body_b: Node3D) -> bool

## Graft both halves of `pair_key` onto the two bound bodies. Returns
## {"ok": bool, "reason": String, "content_s": float, "att": String, "vic": String}
func graft_pair(pair_key: String, att_path: String, vic_path: String,
        start_s: float, end_s: float) -> Dictionary

## Start BOTH players on the same frame at the same speed_scale.
func play_pair(speed_scale: float = 1.0) -> bool

## Q54: no engine-level sync exists. This is the drift guard, and it must be
## callable every frame.
func in_step() -> bool

## Current playback positions, for the guard and for the test.
func positions() -> Dictionary   ## {"a": float, "b": float}
```

**Mount both bodies via `PairedClipMount.place()` at ONE shared origin.** Their
offsets come from the clips' authored roots. **Never place body B at its own
mark** — that is the two-metre bug U55 exists to prevent.

### 2. `Godot/tests/paired_stage_player_test.gd`

`extends SceneTree`, the idiom of `Godot/tests/fight_beat_timing_test.gd` —
`_check(cond, label)`, `checks`/`failures`, print a `PASS (%d checks)` or
`FAILS=%d` line, `quit(0 if failures == 0 else 1)`.

**It must prove, at minimum:**

1. **Both halves graft and both players hold an animation.** Not "no error" —
   assert the animation names are on the players.
2. **They start on the same frame.** After `play_pair`, both positions are equal.
3. **They stay in step.** Advance the tree by N frames and assert `in_step()`
   every frame. **Then force a drift** (seek one player independently) and assert
   `in_step()` goes FALSE — a guard that never fires is not a guard.
4. **The pair is rigid.** Mount at a dozen origins including rotated ones and
   assert `PairedClipMount.alignment_error` stays inside 1 mm. U55 proved this for
   the maths; this proves the PLAYER still honours it after grafting.
5. **`Takedown_BodyLock_End` plays its CONTENT, not its file.** Graft it with
   C91's window and assert the grafted length is ~2.500 s and not ~4.833 s.

### 3. `Godot/tools/preview_paired_clip.gd`

A headless-capable tool that builds the room — floor, the Q55 establishing
camera, lights, both bodies — grafts `Reversal` and plays it. **Print a line per
second of playback giving both positions and `in_step`.** The operator is going
to watch this live and narrate it, so it must also run WINDOWED without
`--headless`.

**`Reversal` first, deliberately**: the attacker descends 0.411 → 0.127 while the
victim rises 0.127 → 0.411 in the same clip pair. It is the one clip that proves
the two files are genuinely one performance rather than two solos that happen to
be near each other.

## Definition of done

- All three files exist, the focused test reports `failures=0`, and `--only
  paired` and `--only fight_world` are no worse than they are now.
- **`failures=0` is a CEILING, not an exact count.** If you find something else
  already failing and fix it, say so and push the better result.
- Commit, push, and send one line:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q59-done --body "<sha> checks=N failures=M max_alignment_error=X drift_guard_fires=yes|no"`

## The traps specific to Q59

1. **CALL `PairedClipMount`, DO NOT REIMPLEMENT IT.** `Transform3D` multiplication
   does not commute and U55 already paid to find out which order works. If you
   find yourself writing `origin * offset` by hand, stop and call `place()`.
2. **A HEADLESS TREE NEVER DRAWS A FRAME, and that has already cost this project
   a fix cycle.** `FightWorldStage.face_each_other` (`:79`) carries the scar: the
   cached `global_position` stays at the origin with no frame, so `to_b` came out
   `(0,0,0)`, `atan2(0,0)` returned 0, and the yaw was silently never applied —
   **the code looked right and did nothing.** Use LOCAL positions where the nodes
   are siblings, and if your test needs a frame, step the tree explicitly.
3. **A bought clip's `length` is not its content length.** Nine of eleven receiver
   clips carried dead air, worst 11.53 s of file for 2.70 s of content. In this
   pack only `Takedown_BodyLock_End` does — but assert the window, do not assume
   the pack is clean because C91 said most of it is.
4. **A Control with full-rect anchors must never have `size` assigned** and a
   `TextureRect` keeps its texture's size as a minimum until `expand_mode` is set
   (R31). Only relevant if you put a readout on the preview — if you do, set
   `expand_mode` and `stretch_mode` BEFORE `texture`/`size`.
5. **Scene scripts compile before the autoloads.** Use
   `get_node_or_null("/root/GameState")` plus `has_method`, never the bare
   `GameState` identifier — and this module should not need GameState at all.
6. **`var x := <call>` fails when the call returns Variant** (`.size()` or `.get()`
   on an untyped value, a static on a `load()`ed script). Write the type:
   `var n: int = ...`. And you cannot reuse a variable name inside one function,
   even across separate `if`/`for` blocks — that is a parse error, and a parse
   error does not fail a headless test, it HANGS it until the timeout.

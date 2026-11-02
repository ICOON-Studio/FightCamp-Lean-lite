# TASK U51 — CURSOR — THE BLIND CONTRACT TEST FOR THE CLIP RETARGETER

Model: Composer, medium effort. Owner: cursor.
Test tier: **NEW TEST FILE ONLY** — parse gate, then that ONE test. Nothing else.
A new test file cannot break another test; a full suite run here buys nothing
and costs twenty minutes.

## Owned files

- `Godot/tests/fight_clip_retarget_test.gd` — **NEW. You create it. Yours alone.**

You own nothing else. Do not edit `Godot/scripts/FightClipRetarget.gd`, do not
edit `HANDOFF.md`, do not edit any other test.

## THIS IS A BLIND TEST. READ THE CONTRACT BELOW AND NOTHING ELSE.

`Godot/scripts/FightClipRetarget.gd` is being written right now, in parallel, by
Claude. **DO NOT OPEN IT.** Do not open `BoneRestFixer.gd`,
`measure_r108_retarget.gd`, or any other implementation. A test written against
an implementation only ever agrees with it; this test exists to disagree.

Write the test from the contract in this file. If the module is not on disk when
you start, that is expected — write the test anyway and let it fail loudly.

## Why this exists

A bought RamsterZ clip is authored on the UE4 Mannequin. Its bone NAMES are not
ours (`upperarm_l`, not `LeftUpperArm`) and its rest pose is not ours. Writing
its rotations straight onto our rig gives a body folded the wrong way — measured
in R108, the right hip lands **137 degrees** wrong — and **it does not error, it
does not fail a coverage count, it just looks broken.**

`FightClipRetarget` is the module that turns a bought `.FBX` into an `Animation`
our `AnimationPlayer` can play on our fighter. It is the piece the whole
animation purchase depends on.

## THE CONTRACT

`Godot/scripts/FightClipRetarget.gd`, `class_name FightClipRetarget`,
`extends RefCounted`, **statics only** — you never instantiate it.

### `const UE4_TO_OURS: Dictionary`

Source bone name -> our bone name. **22 rows.** Exposed deliberately so callers
and tests share one map. Assert: it has exactly 22 entries, that
`UE4_TO_OURS["upperarm_l"] == "LeftUpperArm"`, `UE4_TO_OURS["pelvis"] == "Hips"`,
`UE4_TO_OURS["ball_r"] == "RightToes"`, and that **every value is distinct** (two
source bones mapping to one target bone would silently drop a limb).

### `static func build_corrections(reference_fbx_path: String, skel: Skeleton3D, name_map: Dictionary) -> Dictionary`

The constant per-bone correction between the source rig's rest and ours,
computed once per (pack, fighter) pair.

- `reference_fbx_path` is the **vendor's T-pose file**, which is the only honest
  source of the source rig's rest.
- Returns `our_bone_name -> Basis`. Empty dictionary on any failure (bad path,
  no skeleton).
- **Never mutates `skel`.**

### `static func retarget_clip(clip_fbx_path: String, skel: Skeleton3D, name_map: Dictionary, corrections: Dictionary, fps: float, window_start_s: float, window_end_s: float) -> Dictionary`

Returns a Dictionary with **exactly these keys**:

| key | type | meaning |
|---|---|---|
| `animation` | `Animation` | rotation tracks, or `null` on failure |
| `length` | `float` | the built animation's length in seconds |
| `bones` | `int` | number of bones that got a track |
| `samples` | `int` | number of keys per track |
| `error` | `String` | `""` on success, a non-empty reason on failure |

- Track paths on the returned animation are the **bare bone name** —
  `NodePath("LeftUpperArm")`, with **no node prefix and no colon**. Addressing a
  real skeleton is `address_tracks`'s job, not this one's.
- Every track is `Animation.TYPE_ROTATION_3D`. Assert there are **no position
  and no scale tracks** — a bought clip's root translation must not walk our
  fighter off his mark.
- `window_start_s` / `window_end_s`: **`-1.0` for either means "the whole clip"**.
  When a real window is given, the returned `length` is the window's duration,
  and the first key sits at `t = 0.0` — the window is rebased to zero, not left
  as an offset.
- `fps` is the sampling rate. `samples` must be `>= 2` for any clip of non-zero
  length. A clip sampled at a higher `fps` must yield **strictly more** samples
  than the same clip at a lower one.
- On a bad path: `error` non-empty, `animation` null, and **it must not crash**.

### `static func address_tracks(anim: Animation, skel_path: String) -> Animation`

Re-points every track at a skeleton. `"LeftUpperArm"` becomes
`"<skel_path>:LeftUpperArm"`.

- **Idempotent**: calling it twice with the same `skel_path` gives the same
  paths, never `Skeleton3D:Skeleton3D:LeftUpperArm`.
- Calling it with a *different* `skel_path` re-points to the new one — a cached
  clip must be movable between two fighters.
- Assert idempotency explicitly. It is the property most likely to be got wrong.

## What to assert, beyond the shapes

The test must go past "it returned a dictionary". These are the asserts that
would have caught R108's real bug:

1. **IT MOVES THE BONES.** Build the animation, hand it to a real
   `AnimationPlayer` on the real fighter, `play()`, `advance()` to mid-clip, and
   count how many of the 22 bones are **driven off their rest**. Compare
   `get_bone_pose_rotation(i)` against `get_bone_rest(i).basis` — **not**
   `get_bone_global_pose()`, see the trap below. Require **at least 18 of 22**.
   A ceiling, never an exact count: if you get more, say so and pass.
2. **ASSERT `AnimationPlayer.current_animation`**, the string the engine really
   holds — never the name you asked it to play. A green suite hid 85 wrong clips
   from us exactly once by asserting the request instead of the result.
3. **THE WINDOW ACTUALLY CUTS.** Retarget the same clip whole and then with a
   window of roughly its first third, and assert the windowed `length` is
   **materially shorter**. A window that silently returns the whole clip is the
   failure that would let a 3-second reaction play on a 1-second beat.
4. **A BAD PATH IS HANDLED, NOT CRASHED.** `retarget_clip` on
   `"res://assets/anim/audition/ramsterz_h2h/NOT_A_REAL_FILE.FBX"` returns
   `error != ""` and does not take the test down.

## Files you may read

- `res://assets/anim/audition/ramsterz_h2h/T_pose.fbx` — the reference rest
- `res://assets/anim/audition/ramsterz_h2h/H2H_HitReaction01.FBX` — the clip
- `res://assets/models/fighters/f01_m_box_welter_rigged.glb` — the fighter

The fighter is a `.glb`: load it with `GLTFDocument` / `GLTFState`. The clips are
`.FBX`: load with `FBXDocument` / `FBXState`. Both need
`ProjectSettings.globalize_path()`. Find the `Skeleton3D` by walking the loaded
scene for a node whose `get_class()` is `"Skeleton3D"`.

## THE FOUR TRAPS THAT WILL COST YOU THE PASS

1. **`get_bone_global_pose()` RETURNS THE REST POSE IN A HEADLESS RUN.** Nothing
   moves it — not adding the skeleton to the tree, not
   `force_update_all_bone_transforms()`, not awaiting a frame. It does not
   error. It cost R108 two full measurement runs, both of which reported two
   different strategies as byte-identical because both columns were the rest
   pose read back. **Use `get_bone_pose()` / `get_bone_pose_rotation()`, and if
   you need a global, compose it down the `get_bone_parent()` chain yourself.**
2. **Add the fighter to the scene tree before you play anything.** A skeleton
   outside the tree never updates.
3. **`rc=0` IS NOT A PASS.** A GDScript runtime error leaves rc=0, so a broken
   test prints its SCRIPT ERRORs and then prints `0 failure(s)` — a counter it
   never reached. Print an explicit `failures=N` line and make sure your own
   failure counter is reached on every path.
4. **A parse error HANGS a headless run** until timeout instead of failing it.
   Run the parse gate first, every time.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_clip_retarget_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clip_retarget_test.gd
```

The exe is in `%LOCALAPPDATA%\Programs\Godot\`. **Do not run the full suite.**

The test prints one machine-readable last line:

```
CLIP_RETARGET checks=<n> failures=<n> bones_moved=<n> current_animation=<string>
```

`failures=0` is the target. **If the module is not yet on disk, or is on disk and
fails, report the failures — do not weaken an assert to go green.** A test that
disagrees with the module is this task delivering, not this task failing.

## Deliver

Commit and push. Then one line:

```
python Tools/agent_comms.py send --from cursor --to claude --subject U51-done --body "<sha> checks=N failures=N bones_moved=N"
```

Do **not** edit `HANDOFF.md` — Claude writes your block.

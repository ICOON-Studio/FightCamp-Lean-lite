# TASK U52 — CURSOR — THE BLIND CONTRACT TEST FOR THE TITLE SCREEN'S 3D ROOM

Model: Composer, medium effort. Owner: cursor.
Test tier: **NEW TEST FILE ONLY** — parse gate, then that ONE test. Nothing else.
A new test file cannot break another test; **do not run the full suite.**

## Owned files

- `Godot/tests/boot_stage_3d_test.gd` — **NEW. You create it. Yours alone.**

Nothing else. Do not edit `BootStage3D.gd`, `BootRoot.gd`, `HANDOFF.md`, or any
other test.

## THIS IS A BLIND TEST. READ THE CONTRACT BELOW AND NOTHING ELSE.

**DO NOT OPEN `Godot/scripts/BootStage3D.gd`.** Write the test from the contract
in this file. A test written against an implementation only ever agrees with it.

## Why this exists

The title screen used to be a grey field with a placeholder rectangle captioned
"FIGURE" in the middle of it. It is now a live 3D room — fighters, lights, fog,
a moving camera — and **the whole thing is currently verified by one render tool
that a human looks at.** Nothing in the suite asserts it is there at all. A
silent failure would put a black screen in front of every new player.

## THE CONTRACT

`Godot/scripts/BootStage3D.gd`, `extends Node3D`. It builds its own contents in
`_ready()` and drives the camera in `_process()`. You instantiate it with
`.new()` and add it to a `SubViewport` (or the scene tree) yourself.

### `const FIGURES: Array`

The line-up, as data. Each entry is a Dictionary with at least `model` (a fighter
id, no extension), `clip` (a baked clip name, no extension), `pos` (`Vector3`),
`yaw` (`float`), `hold` (`float`, `-1.0` to play, otherwise the second to freeze
at) and `start` (`float`, seconds into the clip).

Assert: it is **non-empty**; every entry has all six keys; every `model` is
distinct; and every `hold` is either `-1.0` or `>= 0.0`.

### `func is_ready_for_test() -> bool`

True when at least one figure stood up.

### `func figures_built() -> int`

How many figures actually built. Assert it **equals `FIGURES.size()`** — a figure
that silently fails to load is exactly the defect this test exists to catch, and
it is allowed to be a soft failure at runtime precisely because a test is
supposed to notice.

## What to assert, past the shapes

1. **THE ROOM EXISTS.** After adding it to the tree and letting a frame or two
   pass, assert the node has a `Camera3D` child, at least one
   `DirectionalLight3D`, and a `WorldEnvironment` whose `environment` is not null.
2. **THE FIGHTERS ARE REALLY THERE.** For each entry in `FIGURES`, assert a child
   node exists whose name matches that entry's `model`, and that it contains a
   `Skeleton3D` somewhere beneath it. Walk the tree for it — do not assume depth.
3. **THE CAMERA MOVES.** Record the camera's `global_transform.origin`, let
   several frames pass, and assert it has **changed**. This is the single most
   valuable assert in the file: a static camera is the failure that looks exactly
   like success in a screenshot.
4. **THE BAKED CLIPS LOAD.** For each entry, assert
   `res://assets/anim/boot/<clip>.res` exists via `ResourceLoader.exists()` and
   that loading it yields an `Animation` with **more than one track**. These are
   baked offline; a missing or empty one T-poses a fighter on the title screen.
5. **NO TWO FIGHTERS SHARE AN ANIMATION INSTANCE.** Two figures may name the same
   baked clip. Assert their `AnimationPlayer`s do not hold the *same* Animation
   object — find each figure's `AnimationPlayer`, get its animation, and compare
   with `!=` on the object. If one resource were shared, addressing its tracks at
   the second skeleton would silently re-point the first, and one fighter would
   stop moving.

## Traps that will cost you the pass

1. **`get_bone_global_pose()` returns the REST pose in a headless run** and does
   not error. If you check bone motion, use `get_bone_pose()` / 
   `get_bone_pose_rotation()`.
2. **The fighters are NOT imported resources.** There is no `.import` beside the
   `.glb`, so `load()` on one returns null with "No loader found". The module
   reads them with `GLTFDocument` — you do not need to load any model yourself,
   but do not write an assert that assumes `load()` works on a `.glb`.
3. **A headless run has a dummy rasterizer.** Lights, fog and glow build fine as
   NODES; do not assert on rendered pixels.
4. **`rc=0` IS NOT A PASS.** Print an explicit `failures=N` and make sure your
   counter is reached on every path.
5. **A parse error HANGS a headless run** until the timeout. Parse gate first.
6. Reusing a variable name inside one function is a GDScript parse error, even
   across separate `if` / `for` blocks.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/boot_stage_3d_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/boot_stage_3d_test.gd
```

The exe is in `%LOCALAPPDATA%\Programs\Godot\`. Last line:

```
BOOT_STAGE_3D checks=<n> failures=<n> figures=<n>
```

`failures=0` is the target. **If the module disagrees with this contract, report
the failures — never weaken an assert to go green.**

## Deliver

Commit, push, then one line:

```
python Tools/agent_comms.py send --from cursor --to claude --subject U52-done --body "<sha> checks=N failures=N figures=N"
```

Stage explicit paths only; check `git status -s` first. Never `git stash`,
`reset --hard`, `checkout .` or `clean` in this shared checkout. Do **not** edit
`HANDOFF.md`.

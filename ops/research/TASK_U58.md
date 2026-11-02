# TASK U58 — CURSOR — THE FIGHT HAS NO CAMERA

Model: Composer, **medium effort**. Owner: cursor.
Test tier: **ONE SCENE AND ONE SMALL SCRIPT. Parse gate, then the two named
subsets. Do NOT run the full suite** — it is Claude's, once, at integration.
**Only one Godot at a time in this checkout.**

```
python Godot/tools/check_scripts.py Godot/scripts/FightCameraRig.gd
python Godot/tools/run_tests.py --only fight_world
python Godot/tools/run_tests.py --only fight_stage
```

## Owned files

- `Godot/scripts/FightCameraRig.gd` — **NEW. Yours alone.**
- `Godot/scenes/FightWorldPreview.tscn` — **yours for this task**, and only the
  camera node inside it.
- `Godot/tests/fight_camera_rig_test.gd` — **NEW. Yours alone.**

Nothing else. Do **NOT** edit `FightStagePlayer.gd`, `FightClipBinding.gd`,
`FightBeatAdapter.gd`, `FightWorldLiveScreen.gd`, any other test, or
`HANDOFF.md`. `GameState.gd` is 12,938 lines — you do not need it, never open it.

## Why this exists

**There is no fight camera.** `Godot/scenes/FightWorldPreview.tscn` contains
exactly six nodes: `FightWorld`, **`IsometricCamera`**, `Key`, `Fill`, `SpawnA`,
`SpawnB`. An isometric camera is the wrong instrument for a fight — it flattens
the depth that reads a punch landing — and nothing directs it. Grep `scripts/`
for `Camera3D` and the only hit is `BootStage3D.gd`, a different screen.

The operator is about to watch a three-round bout on
`res://scenes/FightWorldLive.tscn` and judge it. **A fight shot from a static
isometric wide is not a broadcast.**

## The numbers are already measured. DO NOT RE-DERIVE THEM.

Q55 (`3b6650e`) produced these. Godot's `fov` is **VERTICAL** fov. All positions
Y-up, scaled to a 1.6 m pair at world origin.

| shot | `position` (x, y, z) | `look_at` (x, y, z) | `fov` | what it is for |
|---|---|---|---:|---|
| **establishing** | `(0.0, 1.80, 2.60)` | `(0.0, 0.35, 0.0)` | **42** | reads position and who is on top; 28 mm equivalent |
| **tight** | `(0.40, 0.75, 1.20)` | `(0.0, 0.30, 0.0)` | **55** | the finish — a choke, an armbar, a face; 20 mm |
| **low mat-level** | `(0.0, 0.22, 1.90)` | `(0.0, 0.35, 0.0)` | **62** | broadcast's "canvas cam"; reads weight; 17 mm |

**LABEL THEM HONESTLY IN YOUR CODE COMMENT: Q55 marked these INFERENCE, not
DOCUMENTED.** Broadcast MMA camera specifications were NOT FOUND in any published
source; they are derived from observable practice. They are a starting point.

## The job

**SHIP THE ESTABLISHING SHOT ONLY.** One good static camera beats three shots
with no editor to cut between them. Shot selection is a later stage. Carry the
other two rows in the table as named constants so the next session can reach
them, but **do not build a shot-switcher and do not animate the camera.**

`FightCameraRig.gd` is a small pure-ish helper:

- `const SHOTS := { "establishing": {...}, "tight": {...}, "low_mat": {...} }`
  carrying position / look_at / fov per the table above, exactly.
- `static func apply(camera: Camera3D, shot: String, surface_y: float) -> bool`
  — sets `position`, `fov`, and aims with `look_at`. Returns false for an
  unknown shot rather than guessing one.
- **`surface_y` IS NOT OPTIONAL AND IT IS THE TRAP** — see below.

Then point `FightWorldPreview.tscn`'s camera at it: the node must be a plain
`Camera3D` in perspective projection, positioned by `apply`.

### THE TRAP: THE DECK HEIGHT IS NOT ZERO, AND IT DIFFERS BY DISCIPLINE

R64/R92 measured them: **the boxing ring canvas sits at 1.2700 m and the gym
cage floor at 0.1300 m.** A fighter stands **1.14 m lower in a cage than in a
ring.** Q55's numbers are relative to the pair, not to world zero.

**Anything that places a camera MUST read `ArenaRig.surface_y(spec)` and offset
by it.** A hard-coded height is wrong for one of the two, and this is the exact
fault `tests/fight_world_mount_test.gd` already asserts against for bodies.
`Godot/scripts/ArenaRig.gd` is small enough to read whole; read it before you
write `apply`.

## The test

`fight_camera_rig_test.gd`, headless, no scene needed for the arithmetic:

- `apply` on a bare `Camera3D` at **ring deck 1.2700** puts the camera at
  `y = 1.80 + 1.2700` and at **cage deck 0.1300** at `y = 1.80 + 0.1300`.
  **Assert the resulting world y, not the constant you wrote** — the constant is
  a getter and asserting it proves nothing. Three findings running in this repo
  have been exactly that mistake.
- the camera is actually AIMED: after `apply`, the forward axis points at the
  look_at target within a small epsilon. A `look_at` that silently no-ops
  (target equal to position, or an up-vector parallel to the view) is the real
  failure mode here.
- `fov` is set to 42.0 for `establishing`.
- an unknown shot name returns `false` and leaves the camera untouched.
- **projection is PERSPECTIVE, not orthogonal.** That is the one-line assertion
  that catches somebody re-pointing this at the old isometric node.

**A NEW TEST FILE CANNOT BREAK ANOTHER TEST**, so the tier above is the whole
gate: parse gate, your own file, then the two named subsets because you touched
a shared scene.

## Done means

- `check_scripts.py` clean; `--only fight_world` and `--only fight_stage` both
  `fails=0`. **`fails=0` is a CEILING, not an exact target** — if a pre-existing
  failure disappears because of your change, say so and push the better result.
- `git status -s` FIRST (another agent's WIP may be pre-staged), then
  `git add --` your three explicit paths only. Never `audio_exports/`.
- Commit ending `Co-Authored-By: Cursor <noreply@cursor.com>`, then push.
  **PUSH TO master IF YOU CAN. If you end up on a branch, say the branch name in
  your final message** — you left HEAD on `cursor/u57-grapple-promotion` last
  time and `git push origin master` then reports "Everything up-to-date" while
  nothing lands.
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --subject U58-done --body "<hash> shot=establishing ring_y=<n> cage_y=<n> checks=<n> failures=<n>"`
- Do NOT edit `HANDOFF.md` — Claude writes your block.

## GDScript traps

- `var x := <call>` fails when the call returns Variant (`.size()` / `.get()` on
  an untyped value, a static on a `load()`ed script) — write the type.
- A `%` inside a format string must be `%%`.
- Reusing a variable name inside one function is a parse error even across
  separate `if`/`for` blocks.
- **Parse gate BEFORE any test.** A parse error does not fail a headless test,
  it HANGS it for 600 seconds.
- Use only
  `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe`. There is
  a second, chocolatey `godot.exe` on this machine and it is NOT the project's
  engine.

# TASK G18 — GROK — THE MAT, BUILT FROM ITS NUMBERS

Model: mid tier, effort **medium**, Fast off. One session.

A pure module and its test. **Zero preloads**, statics only, no node access, no
RNG, no file access. You have no repository checkout and you do not need one:
build and test in a throwaway Godot project holding only your two files, as
G13, G15, G16 and G17 did. Claude splices, runs the real suite and writes your
`HANDOFF.md` block.

Deliver exactly two files:

- `Godot/scripts/MatRig.gd`
- `Godot/tests/mat_rig_test.gd`

G17 landed clean the day it was assigned and needed no splice fix. This is a
different shape from your last four — it returns **geometry**, not counts — but
the discipline is identical.

## Why this exists

**CORRECTED 2026-09-08.** This paragraph used to say a ring schematic had already become a working `ArenaRig.gd` and that the pipeline was proven. **It had not.** `ArenaRig` was a node name in a proposed scene tree in `C17_FIGHT_SCENE.md` and no such script existed anywhere in the repo; Claude wrote the claim into this file without grepping for it. R64 has since made the module real (`Godot/scripts/ArenaRig.gd`), built in `MatRig`'s shape rather than the other way round.

The original text read: "A boxing ring schematic became `ArenaRig.gd`: a
procedural rig, 1 unit = 1 m, that builds the whole thing from primitives with
no textures and no imported mesh. That pipeline works." Read it as the SHAPE
the project wants - a schematic with real dimensions becoming a pure GDScript
module that builds the geometry - not as a file you can go and read. You are
building the first one. The project wants the rest of its surfaces through it — the mats that judo, wrestling, taekwondo, karate and BJJ actually
fight on.

**The dimensions are not sourced yet.** A separate research pass is collecting
them from the governing bodies, and this project's standing rule is that an
invented number never ships wearing a citation. So you are **not** given
numbers and you must **not** invent any: you build the mat as a function of the
numbers, and the caller supplies them once they are sourced. One module then
serves every discipline, and a corrected figure changes a call site rather than
a mesh.

## What a competition mat is

Every one of these surfaces is the same object with different figures:

- a **contest area** — the square or circle actually fought in;
- a **safety area** (called the danger or protection area by some bodies)
  surrounding it, usually a contrasting colour;
- an optional **warning zone** inside the contest area, again a contrasting
  colour;
- a **thickness**, because the mat sits on the floor and a fighter stands on
  its top surface;
- an underlying **panel size**, because a real mat is tiled from rectangles and
  the seams are visible.

Judo, wrestling, taekwondo, karate and BJJ differ in which of these they have,
what shape they are and how big — not in what they fundamentally are.

## The API

```gdscript
extends RefCounted

## Every dimension is in metres and every one is REQUIRED. No default, no
## fallback, no "typical" value - a missing figure is an error the caller
## must fix, never a number this module quietly supplies.
static func build(spec: Dictionary) -> Node3D
static func validate(spec: Dictionary) -> Dictionary
static func surface_y(spec: Dictionary) -> float
```

The spec, exactly these keys:

```gdscript
{
  "shape": "square",          # "square" or "circle" - the contest area's shape
  "contest": 8.0,             # side, or diameter for a circle
  "safety": 3.0,              # the band added on EVERY side, 0.0 for none
  "warning": 1.0,             # band inside the contest area, 0.0 for none
  "thickness": 0.04,
  "panel": [1.0, 2.0],        # one tile's size, [] for an untiled surface
  "colors": {                 # every one required when its band exists
    "contest": "3a7a4a",
    "safety": "9a4a2a",
    "warning": "c8a03a",
  },
}
```

`validate(spec)` returns `{"ok": bool, "errors": Array}` — one plain string per
problem, naming the key. Called by `build()` first; **an invalid spec returns
an empty `Node3D` and builds nothing**, so a caller cannot get a
half-dimensioned mat that looks plausible.

`build(spec)` returns a `Node3D` whose origin is the centre of the contest area
and whose **top surface is at `y = thickness`** — a fighter stands on
`surface_y(spec)`. (An earlier draft said "exactly as `ArenaRig.canvas_y()`
does" - there was no such function and no such file; R64's `ArenaRig.gd` now
copies YOUR contract, and its accessor is `surface_y` too.) Build with
`BoxMesh`/`CylinderMesh` primitives and `StandardMaterial3D`, the way the ring
does. Panel seams: draw the tiling as thin inset lines or alternating panel
boxes — your call, but a mat with `panel: []` must have no seams at all.

## Refusals — each of these is a failed task

- **No dimension of your own.** Not a default, not a fallback, not a "standard"
  8×8, not a comment saying what judo uses. If you write a number that is not
  derived from the spec you were handed, the task has failed. This is the whole
  point of the module.
- **No discipline names.** The module does not know what judo is. It builds a
  mat from figures. A caller that knows the sport passes the figures.
- **No textures, no imported meshes, no external files.** Primitives and
  materials only.
- **No lights, no camera, no environment.** You return the mat, not a scene.
  Whatever renders it owns the lighting.
- **No fighters, no spawn markers, no gameplay.**
- **No `preload`, no autoload, no `class_name`, no RNG, no file access.**

## The test

`mat_rig_test.gd` follows the house pattern — `extends SceneTree`, a `load()`
of the module by path, `_check(condition, message)` printing `OK:` or `FAIL:`,
a final line and `quit()`. **Test the geometry, not the picture**: a headless
run has no renderer, so assert on the node tree and on transforms.

```gdscript
extends SceneTree
## G18: MatRig, pure. A spec in, a mat out. No project, no autoload, no scene.

var failures := 0


func _initialize() -> void:
	var Mat = load("res://scripts/MatRig.gd")
	var bad: Dictionary = Mat.validate({})
	_check(not bool(bad.get("ok", true)), "an empty spec is refused")
	# ... your cases ...
	print("G18 mat rig: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

Cover at least: an empty spec, a missing `contest`, a negative `thickness` and
a missing colour for a band that exists are each refused with a named error; an
invalid spec builds an empty node; `surface_y` equals `thickness`; a square and
a circle both build; `safety: 0.0` produces no safety band and `warning: 0.0`
no warning band; `panel: []` produces no seams; two identical specs produce
identical node counts (it is deterministic); a bigger `contest` produces a
bigger mat — assert on the mesh size you set, not on a screenshot.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs. Three that cost a fix cycle every stage here:

- **`:=` fails on a Variant.** `var c := spec.get("contest", 0.0)` is a parse
  error — `.get()` on an untyped value returns Variant, and so does every
  static reached through a `load()`ed script, which is exactly how your test
  reaches this module. Write the type: `var c: float = ...`,
  `var mat: Node3D = Mat.build(spec)`.
- **A name may be declared once per function.** Reusing `var box` in two
  separate `if` blocks in one function is a parse error, not a shadow.
- **`%` in a format string must be `%%`.**

`extends RefCounted` on the module, `extends SceneTree` on the test. A
`class_name` would collide on splice.

## The one trap

**The mat is not the contest area.** A judo mat with an 8 m contest area and a
3 m safety band is **14 m across**, not 8 — the band is added on every side, so
the total is `contest + 2 × safety`. Get that wrong and every mat in the game
is built too small, every floor-space number computed from it is wrong, and the
error is invisible in a screenshot because the proportions still look right.
Assert the total size explicitly in your test, for a square and for a circle.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/MatRig.gd
Godot/tests/mat_rig_test.gd
Godot/scripts/ArenaRig.gd
```

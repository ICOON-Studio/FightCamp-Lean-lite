# TASK C161 — CODEX — THE OCTAGON STANDS ON A SQUARE

**Model:** `gpt-5.6-luna`, MEDIUM. Geometry, not animation, so this is not an
astra task. **Owner:** codex. **Tier: parse gate, one focused test, `--only
arena`. NO suite run.**

## The defect

`Godot/scripts/ArenaRig.gd`, `_add_deck`:

```gdscript
if sides == 0:
    var cyl := CylinderMesh.new()   # a circle
    ...
else:
    var box := BoxMesh.new()        # a SQUARE, for every other value of sides
    box.size = Vector3(span, thickness, span)
```

`build()` calls it twice for a cage, with `sides` = 8:

```gdscript
_add_deck(root, "apron",  sides, total,   platform, ...)
_add_deck(root, "canvas", sides, contest, padding,  ...)
```

So an eight-sided cage stands on a **square canvas inside a square apron**.
The octagon is only the fence. On a UFC 30 ft spec that is a 9.144 m square
under an octagonal fence whose corners are at 4.572 m and whose flats are at
4.224 m — the mat sticks out past the fence at the flats and falls short at
the corners.

Found 2026-09-22 while fixing three other arena defects; the operator's words
for what they were looking at were *"i dont want to see those grey artifacts
again"*.

## What to build

**`_add_deck` builds an N-GON PRISM when `sides >= 3`.** Circle at `sides ==
0` stays exactly as it is; a ring keeps passing 4 and must still get a square,
byte-for-byte.

**USE `CylinderMesh.radial_segments`.** It is already a cylinder generator and
`radial_segments = sides` gives a regular prism — no ArrayMesh, no hand-built
vertices, no new dependency. Set `top_radius = bottom_radius = span * 0.5`.

### THE TRAP, AND IT IS THE WHOLE REASON THIS IS A TASK FILE

**The deck and the fence must agree about what `span` MEANS.** The fence is
built from the same figure and places its panels like this:

```gdscript
var panel_width: float = 2.0 * half * sin(PI / float(panels)) * 1.02   # chord
var apothem: float = half * cos(PI / float(panels))                    # flat
mi.position = Vector3(cos(angle) * apothem, 0.0, sin(angle) * apothem)
mi.rotation = Vector3(0.0, PI * 0.5 - angle, 0.0)
```

So `half = span * 0.5` is the **CIRCUMRADIUS** — the distance to the CORNERS —
and panel 0 is a FACE centred on angle 0, meaning its two corners sit at
±PI/8.

`CylinderMesh` with `radial_segments = n` puts a VERTEX at angle 0. That is a
CORNER at angle 0, which is rotated by half a segment against the fence. **The
deck must be rotated by `PI / sides` about Y so its faces line up with the
fence's faces.** Get this wrong and the mat's corners poke through the middle
of each fence panel — which looks almost right and is not.

**PROVE THE ALIGNMENT, do not assert it.** The test below is what proves it.

## The test — `Godot/tests/arena_deck_shape_test.gd`, and it must be able to fail

Write it, and then BREAK THE MODULE to show each check bites. Minimum:

1. **A cage's canvas and apron are prisms with `sides` faces**, not boxes. Read
   the built mesh, not the spec.
2. **A ring is unchanged** — 4 sides, and the same mesh class and size the box
   path produced before. This is the regression guard.
3. **`sides == 0` is still a circle.**
4. **ALIGNMENT: every fence panel's centre lies on a deck FACE, not on a deck
   corner.** Compute each panel's outward normal, march `apothem` along it from
   the centre, and require that point to be inside the deck polygon and within
   a millimetre of its edge. This is check 4 and it is the one that catches the
   half-segment rotation.
5. **The canvas does not stick out past the fence.** The deck's circumradius
   equals `contest * 0.5` to 1e-6.

**MUTANTS you must run and report, each RED:** remove the `PI / sides`
rotation; set `radial_segments` to `sides + 1`; use the apothem as the radius
instead of the circumradius; restore the BoxMesh for `sides >= 3`. Report
`total=N red=N missed=0` with the unmutated control GREEN, or say which missed.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/ArenaRig.gd Godot/tests/arena_deck_shape_test.gd
python Godot/tools/run_tests.py --only arena
```

`--only arena` must not go DOWN. Then render one frame and commit the PNG:

```
Godot_v4.7.2-stable_win64.exe --path Godot --script tools/record_room.gd \
  --write-movie out.avi --fixed-fps 30 --quit-after 90 --position -3000,-3000 -- \
  seed=5150 discipline=mma shot=standing bare=1
```

## Rules

- **DO NOT fetch or rebase.** The checkout is current and is SHARED — Cursor is
  working in `ArenaRig.gd` at the same time under `TASK_ARENA_ART`. Touch
  `_add_deck` and your own test file and nothing else in that file. Never
  `git stash`, `reset --hard` or `add -A`; stage explicit paths.
- **Zero baked dimensions.** Every figure comes from the caller's spec. The
  module's own header says so and it is the reason it exists.
- Read ONLY `Godot/scripts/ArenaRig.gd`. Do not read `HANDOFF.md`,
  `CURRENT_STATUS.md` or any digest, and do not explore to get oriented.
- End with: the mutant table, the `--only arena` number, the frame, and **what
  is still wrong**.

**`--position -3000,-3000` IS NOT OPTIONAL.** `--write-movie` needs a real
rendering context, so the render opens a GODOT WINDOW on the operator's
desktop. Without the off-screen position every pass by every agent pops a
window in their face - operator, 2026-09-22: *"why the game is keep
launching ????"*. Off-screen renders identically; verified.

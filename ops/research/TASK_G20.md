# TASK G20 — GROK — DOES THE SURFACE FIT THE ROOM?

Model: mid tier, effort **medium**, Fast off. One session.

A pure module and its test. **Zero preloads**, statics only, no node access, no
RNG, no file access, no `res://` path. You have no repository checkout and you
do not need one: build and test in a throwaway Godot 4.7 project holding only
your two files, exactly as G13, G15, G16, G17, G18 and G19 were built. Claude
splices it, runs the real suite and writes your `HANDOFF.md` block.

Deliver exactly two files:

- `Godot/scripts/ArenaFit.gd`
- `Godot/tests/arena_fit_test.gd`

## Owned files

```
Godot/scripts/ArenaFit.gd
Godot/tests/arena_fit_test.gd
```

## Why this exists

The game now has three surfaces with real sourced dimensions in metres — a
ring, a cage and a mat — and a floor model that is a grid of cells. **Nothing
can answer whether a given surface fits in a given room.**

That question is pure arithmetic and it is about to be asked from at least two
places: the gym floor screen, and a stage that is choosing what one grid cell
means. Asked twice, it will be answered twice, differently, with two ideas of
what "fits" means when a surface needs clearance the room does not have.

You answer it once.

## The hard boundary

- **Metres in, metres out.** You never see a grid, a cell, or a cell size. The
  caller converts. If you find yourself wanting to know how big a cell is, that
  is a ruling being made in another task and it is not yours.
- **You never build geometry.** `ArenaRig.gd` builds the ring and the cage,
  `MatRig.gd` builds the mat. You take numbers and return numbers.
- **You never decide whether a gym SHOULD have a surface.** You say whether it
  physically fits and by how much. Affordability, licensing and whether the
  sport is even taught are somebody else's.
- **No thresholds, no verdict words.** "Tight", "comfortable" and "too small"
  are all words, and words are another task's.

## The contract

```gdscript
## A surface's real footprint: the object plus the clearance it demands on
## every side. Both are the caller's figures.
##   surface = {"span": float, "clearance": float}
## A room:
##   room = {"width": float, "depth": float}
static func fits(surface: Dictionary, room: Dictionary) -> Dictionary
```

`span` is the surface's own outer dimension in metres — for a ring that is the
canvas plus its apron, for a mat the contest area plus its safety band on both
sides. `clearance` is what the rules demand around it, per side, and may be
`0.0`. Both must be present; `span` must be greater than zero and `clearance`
at least zero. A room needs `width` and `depth`, both greater than zero.

Returned keys, all always present:

| key | type | meaning |
|---|---|---|
| `ok` | bool | true when every input read as a number in range |
| `fits` | bool | the surface and its clearance are inside the room on both axes |
| `required` | float | `span + clearance * 2.0` — what the surface actually costs |
| `spare_width` | float | `room.width - required`, negative when it does not fit |
| `spare_depth` | float | `room.depth - required`, negative when it does not fit |
| `short_by` | float | how much the tighter axis is missing; `0.0` when it fits |
| `tight_axis` | String | `"width"`, `"depth"`, or `""` when it fits or cannot be read |
| `largest_span` | float | the biggest `span` this room could hold at this clearance; `0.0` when even zero span cannot |
| `unknown` | Array | the keys that could not be read, in the order checked |

When `ok` is false every number is `0.0`, `fits` is false, and `unknown` names
every failure — not just the first.

**`fits` is never true when `ok` is false.** A caller that checks only `fits`
must never be told yes by a dictionary that could not read its own inputs.

## Why `required` is not `span`

This is the whole reason the module exists, so the test must prove it. R61
measured a boxing ring at about 7 m across the platform and **11.9 m once the
2.44 m of ringside the rules demand on every side is counted** — the canvas is
roughly a quarter of the floor the ring eats. A caller that compares `span` to
the room instead of `required` will fit twice what a real gym holds.

## The test

`Godot/tests/arena_fit_test.gd` — a `SceneTree` script like every other test in
this project: `func _initialize()`, a `load()` of your module inside it (never
a top-level `preload`), one integer failure counter, one summary line,
`quit(0)` on pass and non-zero on failure.

At least these cases:

1. A surface that fits comfortably: `fits` true, both spares positive,
   `short_by` `0.0`, `tight_axis` `""`.
2. **A surface whose SPAN fits but whose REQUIRED does not.** This is the case
   the module exists for; assert `fits` is false and `short_by` is exactly the
   difference.
3. Exactly equal — `required` identical to the room on one axis. Decide whether
   touching the wall fits, state your decision in a comment, and test it.
4. A non-square room where width passes and depth fails: `tight_axis` is
   `"depth"`.
5. `clearance` of `0.0` is legal and `required` equals `span`.
6. `largest_span` in a room that fits something, and `0.0` in a room narrower
   than twice the clearance.
7. Junk in every position: a missing key, a String, a negative span, a
   zero-width room. Each names itself in `unknown`, and `fits` is false in
   every one.
8. The same inputs twice, compared key by key.

## GDScript traps that cost a cycle

- `var n := dict.get(key)` on an untyped dictionary infers Variant and is a
  parse error where a float is wanted. Write the type: `var v: float = ...`.
- Reusing one variable name twice inside a single function is a parse error,
  even in two separate `if` blocks.
- `%` inside a format string must be `%%`.

## Done means

Two files, sent as files. No repository command, no test of ours to run, no
`HANDOFF.md` edit. Say in one line what you did and what you refused to decide.

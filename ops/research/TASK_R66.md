# TASK R66 — CLAUDE — THE CELL IS A REAL SIZE

Model: Opus, effort **high**, Fast off. One session. **A ruling, then the code
that follows from it.**

## Why this exists

R61 sourced the dimensions and **deliberately refused to choose the cell size**,
so the choice could be argued against the evidence rather than alongside it.
This is that stage. The evidence is `research/R61_SCHEMATIC_CATALOGUE.md`
— read it once, whole; it is short and it is the entire input.

Today `MAX_FLOOR_WIDTH = 12` (`GameState.gd:98`), `get_floor_capacity()`
(`:3079`) multiplies width by height, `get_used_floor_space()` (`:3084`) sums
`space_cost`, and expansion costs `12000 * room_tier` (`:3169`, `:3186`).
**A cell has no declared real-world size anywhere**, so all four numbers are
internally consistent and mean nothing in metres.

## Owned files

- `research/R66_CELL_SIZE_RULING.md` (new — the ruling itself)
- `Godot/assets/data/equipment_catalog.json` (22 footprints)
- `Godot/scripts/GameState.gd` — the floor seams only: `:98`, `:3059`,
  `:3075-3090`, `:3160-3190`
- `Godot/tests/` — whichever floor test exists, plus a new one if none does

**`GameState.gd` is 13,899 lines. Never open it whole.**

## What R61 already settled, and you may not re-derive

- A ring is 4.88–6.71 m inside the ropes depending on the authority, and its
  **ringside clearance is 2.44 m on every side** — the canvas is about a
  quarter of the floor a ring consumes.
- A UWW mat is 12 m across plus a 1 m platform margin per side.
- A rower is 2.44 × 0.61 m as an object and 2.74 × 1.22 m in use.
- 50 gross ft² (4.65 m²) per occupant is the building code's own answer to how
  much gym one training person needs.
- **No single cell size reconciles the current catalogue** — `club_ring [4,3]`
  implies ~2 m, `judo_tatami_area [2,2]` ~9 m, `heavy_bag [1,2]` well under 2 m.

**`space_cost` is NOT a bug.** R61 filed it as one and withdrew it: `:3059`
computes it as `footprint[0] * footprint[1]` per item instance and
`get_used_floor_space()` sums instances, not definitions. Do not chase it.

## The ruling

Write `R66_CELL_SIZE_RULING.md` first, before touching a `.gd`. It must:

1. **Name the cell size in metres** and give the argument, against R61's rows.
2. **Say what it makes `MAX_FLOOR_WIDTH = 12` mean** — a 12-cell gym is X m
   wide — and whether that is a plausible gym or has to move.
3. **Re-derive all 22 footprints** from the sourced object-plus-clearance
   figures at that cell size, in a table beside today's invented ones. Where
   R61 found nothing (15 of the 22), say the footprint stays authored and mark
   it, rather than pretending the number is now sourced.
4. **State what a ring costs the floor** at the chosen size, clearance
   included, and whether `club_ring` can honestly stay one catalogue item.
5. **Take the decision the evidence forces and say so plainly.** If the honest
   answer is that the grid cannot represent a real gym at any single cell size,
   that is a finding, not a failure — write it and stop before the code.

## Then the code, only if the ruling supports it

- One declared constant for the cell size, with a comment carrying the ruling's
  reasoning and a link to the file.
- The 22 footprints updated where R61 sourced them.
- Every touched number keeps `get_floor_capacity()` and `get_used_floor_space()`
  agreeing with each other. **An existing save must still load** — a footprint
  that changes size must not orphan a placed instance. Check
  `_place_equipment`-shaped paths before you change a footprint, and if a
  migration is needed, that is part of this task, not a follow-on.

## Refusals

- **No new dimension invented.** R61's grades carry over: `DIRECT`,
  `INHERITED`, `UNKNOWN`, and an authored footprint says it is authored.
- **No economy rebalance.** `12000 * room_tier` is not yours; if the ruling
  makes it wrong, say so in the file and leave it.
- **No 3D work.** `ArenaRig` and `MatRig` take metres and do not care about
  cells. G20's `ArenaFit` is the module that bridges the two — consume it if it
  has landed, and if it has not, do the arithmetic inline and note it.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd
```

Focused: the floor/equipment tests, then `smoke_test.gd`. Then the full suite
ONCE in the background before the commit. **Ceiling, not a target: 0 failures;
if something was already red, say so and push anyway.**

## The one trap

**A footprint is not a clearance, and the catalogue has always stored the
first.** If you re-derive footprints from object dimensions alone, every item
gets smaller and the gym holds twice what a real one holds — R61 O5, with
numbers. Decide explicitly whether a catalogue footprint means the object or
the object plus its working clearance, write that decision down, and apply it
to all 22 the same way.

# TASK R61 — CLAUDE — THE SCHEMATIC CATALOGUE: WHAT A REAL GYM MEASURES

Model: Opus, effort **high**, Fast off. **A RESEARCH SESSION, not a build
session** — `CLAUDE.md` carves this out: no browser work in a build session,
research gets its own. Touch no `.gd`, no `.tscn`, no data file.

**Re-cut 2026-09-08.** This was assigned to Codex as C42 and withdrawn the same
day: the task has no code in it, and its value is judgement about evidence —
which source is authoritative, whether a figure is `DIRECT` or `INHERITED`,
whether two sanctioning bodies disagree — and the luna note reserves decisions
for Claude. Codex took C43 (GRAPPLE) instead, which is genuinely its shape.

Deliver two files:

- `research/R61_SCHEMATIC_CATALOGUE.md`
- `research/R61_DIGEST.md`

## Why this exists

**CORRECTED 2026-09-08.** This paragraph used to say a ring schematic had already become a working `ArenaRig.gd` and that the pipeline was proven. **It had not.** `ArenaRig` was a node name in a proposed scene tree in `C17_FIGHT_SCENE.md` and no such script existed anywhere in the repo; Claude wrote the claim into this file without grepping for it. R64 has since made the module real (`Godot/scripts/ArenaRig.gd`), built in `MatRig`'s shape rather than the other way round.

**Schematic with real dimensions → pure GDScript module that builds the
geometry** is the shape the project wants for the rest of the gym. G18's
`MatRig.gd` was the first one actually built, and R64's `ArenaRig.gd` the
second. This task sources the numbers they take.

The prize is not art. `Godot/assets/data/equipment_catalog.json` holds **22
items, every footprint invented** — `club_ring` `[4, 3]` cells, `heavy_bag`
`[1, 2]`, `speed_bag` `[1, 1]` — and `GameState.gd:93` caps the floor at
`MAX_FLOOR_WIDTH = 12`. **Nowhere does a grid cell have a declared real-world
size.** `get_floor_capacity()` (`:3066`) multiplies width by height,
`get_used_floor_space()` (`:3071`) sums `space_cost`, and expansion costs
`12000 * room_tier`. An entire economic system stands on an undefined unit.

Source the dimensions and every footprint becomes **derivable instead of
authored**, the 3D scale is settled for free, and the floor joins the body in
having numbers that can be defended. Same discipline J12/J13 imposed on
healing, applied to the building.

## What to source, in priority order

**Prefer governing-body rulebooks to manufacturer sheets.** A sanctioning rule
is published, free, authoritative, and a fact about the sport rather than about
one company's product. Manufacturer sheets are the fallback for objects no
rulebook covers — a heavy bag has no sanctioning body.

1. **Competition surfaces the game already simulates.** The boxing ring
   (sanctioning-body rules — sizes differ between bodies and that variation is
   itself a finding worth recording), the MMA cage (ABC Unified Rules and state
   commission regulations), and the mat disciplines in `Injury.BASE_DISCIPLINES`:
   judo (IJF), wrestling (UWW), taekwondo (World Taekwondo), karate (WKF), BJJ
   (IBJJF), muay thai (IFMA). Per surface: contest area, safety/danger area,
   total matted area, thickness, and required clearance.
2. **Training equipment footprints**, matched to the 22 ids already in
   `equipment_catalog.json` before anything new: heavy bag, speed bag and
   platform, double-end bag, racks, benches, ergs, mirrors, mat storage,
   lockers. Object dimensions **and** working clearance, as two separate
   figures.
3. **Ringside and corner furniture** — steps, stools, commission and judges'
   tables, the walkway a ring or cage needs around it.
4. **The venue, for the money model.** Area per spectator and row spacing
   standards. R43/R44 give the gate a purse; a sourced capacity per square
   metre would make a venue's size mean something instead of being picked.

Every entry records: **the figure, its unit, the exact document and clause or
page, the year, and a grade** — `DIRECT` (the rulebook states it), `INHERITED`
(a comparable sport or a manufacturer product), `UNKNOWN`. Copy J12's grading
form exactly; that discipline is why J12 is still binding a year of stages
later.

## The output shape

A table per group, a note on any row that needs one, then:

- **What the catalogue implies for the grid**, as observations only. "A ring at
  its sourced footprint plus its required walkway is X m square; the catalogue
  gives it 4×3 cells" is an observation. Choosing the cell size is a **ruling,
  and it belongs to its own stage** — do not make it here, even though this is
  a Claude task. Gathering and ruling stay separate so the ruling can be argued
  against the evidence rather than alongside it.
- **Contradictions**, named and left unresolved.
- **What could not be sourced**, plainly and briefly.

## Refusals

- **No game change.** Two research files. No `.gd`, no `.tscn`, no
  `equipment_catalog.json`, no `HANDOFF.md` edit beyond your own block.
- **No PDFs committed.** The repo is 1.7 GB. **The deliverable is the numbers,
  not the documents** — record the URL and citation so anyone can re-fetch.
  Read them outside the repo. This also keeps us clear of redistributing
  anyone's file.
- **No branding.** Dimensions are facts; a traced drawing is someone's artwork.
  Take the measurements, leave the marks — the existing rig's "No SMAI marks"
  precedent holds.
- **No invented number.** Unsourced is `UNKNOWN`, and it says so. A plausible
  dimension with no citation is worse than a blank, because the next stage
  builds on it.
- **No cell-size ruling.** See above.

## The one trap

**A footprint is not a clearance.** A heavy bag occupies about half a square
metre and needs several to be usable; a ring's canvas is the *smallest* number
in its specification, and the apron, walkway and corner access are what
actually consume the room. Tabulate only object dimensions and every figure
will be too small, and a floor model built on it will fit twice what a real gym
holds. **Two columns, always** — the object, and the clearance it demands — and
where a document gives only one, say which.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/R61_DIGEST.md
research/R61_SCHEMATIC_CATALOGUE.md
```

# R66 — THE CELL IS A REAL SIZE

Claude, 2026-09-08. **A ruling.** Input: `R61_SCHEMATIC_CATALOGUE.md`, read
whole, and nothing else. R61 gathered the dimensions and deliberately refused
to choose; this file chooses, and the code that follows is only what this file
supports.

G20's `ArenaFit` had not landed when this was written (`Godot/scripts/ArenaFit.gd`
does not exist). Every conversion below is done inline and is plain arithmetic.

---

## THE RULING, in one line

**One floor cell is 1.5 m square — 2.25 m².** A catalogue footprint is the
object **plus its working clearance**, never the object alone. Competition
clearance is not working clearance and does not belong on this grid.

One footprint changes: **`club_ring` `[4, 3]` → `[4, 4]`.** Everything else the
evidence either confirms at 1.5 m or leaves authored and says so.

---

## 1. Why 1.5 m, argued against R61's rows

### 1.1 The grid must be square, so the cell must be square

`GameState.gd:3059` computes `space_cost` as `footprint[0] * footprint[1]` and
`get_floor_capacity()` (`:3079`) compares the sum of those against
`width * height`. Both treat a cell as an interchangeable **unit of area**.
That is only true if a cell is square.

This matters because a non-square cell is otherwise tempting: `club_ring [4, 3]`
is a rectangle and a boxing ring is square, so cells of 1.5 × 2.0 m would make
today's footprint a 6.0 × 6.0 m ring with no edit at all. It is rejected.
Rotation (`:3257–3271`) swaps `[w, h]` and would change an item's real area;
`_find_first_fit` (`:3188`) treats a cell as a cell. Non-square cells break
both. **Square cells; the ring footprint moves instead.**

### 1.2 The rowing ergometer sets the floor, and it is the only row that can

R61 §2 gives two figures for exactly one training object:

> `rowing_ergometer` — object **2.44 × 0.61 m**, **in use 2.74 × 1.22 m**.

It is the only item in the catalogue with a published two-axis in-use envelope,
which makes it the only row that can fix a cell size rather than merely survive
one. Its footprint today is `[1, 2]`.

- At **1.25 m**: `[1, 2]` = 1.25 × 2.50 m. The rower is 2.74 m in use. **It does
  not fit.** 1.25 m and everything below it is excluded outright.
- At **1.37 m** (2.74 ÷ 2): the rower fits exactly, with nothing to spare. This
  is the **sourced lower bound**.
- At **1.5 m**: `[1, 2]` = 1.50 × 3.00 m against 1.22 × 2.74 m. Fits with 0.28 m
  and 0.26 m spare, using **74%** of the cell area it claims.
- At **2.0 m**: `[1, 2]` = 2.00 × 4.00 m against the same envelope — **42%**
  used, 4.66 m² of a maximum gym wasted on one rower.

### 1.3 The 1×1 items set the ceiling, by absurdity rather than by source

R61 sourced nothing for `first_aid`, `focus_mitts_locker`, `speed_bag`'s
clearance, or the other small items. They still bound the answer from above,
because a cell size that makes a first-aid cabinet enormous is wrong however
well it suits the rower:

| Cell | `first_aid [1, 1]` | `cold_water_tub [2, 2]` | Verdict |
|---|---|---|---|
| 1.5 m | 2.25 m² | 9.0 m² | a cabinet with standing room; a tub with steps and a deck |
| 2.0 m | 4.00 m² | 16.0 m² | a first-aid *room*; a tub in a double garage |
| 2.5 m | 6.25 m² | 25.0 m² | absurd |

**1.5 m is the smallest value above the sourced floor of 1.37 m that keeps the
authored items plausible.** That is the argument. It is not a strong claim
about 1.5 versus 1.6; it is a strong claim about the interval, and 1.5 m is the
round number inside it.

### 1.4 The corroboration: the authored catalogue was already drawn at ~1.5 m

Nobody chose a cell size when these 22 footprints were written, so agreement is
evidence rather than circularity. At 1.5 m, checked against R61 §2 and common
product sizes:

- `rowing_ergometer [1, 2]` — the in-use envelope, to within 0.28 m. Sourced.
- `heavy_bag [1, 2]` = 1.5 × 3.0 m — a 0.36 m bag with its ≥2 m swing (2.36 m)
  down the long axis, on a 1.5 m lateral pitch. Commercial bag racks hang at
  1.2–1.5 m centres.
- `physio_table [2, 1]` = 3.0 × 1.5 m — a 1.9 × 0.7 m plinth with access on
  three sides.
- `sports_medicine_room [3, 2]` = 4.5 × 3.0 m — a small treatment room.
- `rehabilitation_pool [4, 3]` = 6.0 × 4.5 m — a 4–5 × 2–3 m pool with its deck.

Five independent items land plausibly at 1.5 m and implausibly at 2.0 m. R61
graded them `UNKNOWN` and they stay `UNKNOWN`; they are corroboration, not
derivation, and they are recorded as such.

### 1.5 What 1 m per cell would have meant

R61's **O1** and **O2** already killed it and this ruling only confirms the
arithmetic: at 1 m the maximum gym is 12 × 5 m and the smallest legal ring
platform is 5.80 m square, so the ring would consume 5 of 5 rows and leave no
floor at all. A UWW wrestling mat (12 m, or 14 m with its platform margin) is
wider than the whole building.

---

## 2. What this makes `MAX_FLOOR_WIDTH = 12` mean

`MAX_FLOOR_WIDTH := 12` (`GameState.gd:98`), height fixed at 5 by
`generate_starter_boxing_floor` (`:3010`), `ROOM_EXPANSION_COLUMNS := 2`.

| Floor | Cells | Metres | Area |
|---|---|---|---|
| Starter, 8 wide | 40 | 12.0 × 7.5 m | **90 m²** |
| Starter, 9 wide | 45 | 13.5 × 7.5 m | 101 m² |
| Maximum, 12 wide | 60 | **18.0 × 7.5 m** | **135 m²** |

**A 12-cell gym is 18 m wide and 135 m². That is a plausible gym and it does
not have to move.** An independent boxing gym is typically 150–400 m²; 135 m²
is a small one, 90 m² is a genuinely small club, and a game that starts you in
a small club and lets you reach a modest one is telling the truth.

**The independent check R61 asked for.** IBC Table 1004.5 gives 50 gross ft²
(4.65 m²) per occupant for an exercise room (`INHERITED`: a code sets an egress
ceiling, not a commercial capacity).

- Maximum gym: 135 ÷ 4.65 = **29 occupants**. The game caps at 12 athletes plus
  6 staff = **18**.
- Starter gym: 90 ÷ 4.65 = **19 occupants**, against a much smaller early roster.

The building code ceiling is never the binding constraint; the grid is. The two
models agree, with the game the more conservative of them. At 1.0 m per cell
the maximum gym would be 60 m² = 12 occupants and the code would forbid the
roster the game already allows — a second reason 1 m is dead.

### 2.1 The finding this exposes: the gym is a corridor

Depth is fixed at 5 cells = **7.5 m** and nothing can ever change it —
`expand_floor` (`:3160`) grows `width` only, and there is no `MAX_FLOOR_HEIGHT`
to match `MAX_FLOOR_WIDTH`; the 5 is a local in the starter generator. A fully
expanded gym is 18.0 × 7.5 m, an aspect ratio of **2.4 : 1**. Real gyms are
closer to square.

**Not fixed here.** Changing the depth changes capacity, which is the economy,
and the economy is explicitly not mine. Filed as a follow-on: the honest
expansion is a room that grows in both axes, or a depth that scales with
`room_tier`.

### 2.2 The economy, checked and left alone

`12000 * room_tier` (`:3169`, `:3186`) buys `ROOM_EXPANSION_COLUMNS = 2`
columns = 10 cells = **22.5 m²**.

| Expansion | Cost | $ / m² |
|---|---|---|
| tier 1 | $12,000 | $533 |
| tier 2 | $24,000 | $1,067 |
| tier 3 | $36,000 | $1,600 |

Commercial leasehold fit-out runs roughly $500–2,000 /m². **The first expansion
lands at the bottom of that band and the escalation stays inside it.** The
ruling does not make `12000 * room_tier` wrong, so per the refusals it is
untouched and this row exists only to record that it was checked.

---

## 3. The trap, decided: a footprint is the object PLUS its working clearance

R61's **O5** is the whole risk: a model built on object dimensions alone lets a
gym hold roughly twice what a real one holds. So the decision has to be
explicit, and it has to be applied to all 22 identically.

**A catalogue footprint is the floor the item takes out of the gym — the object
and the space a person needs to use it.**

This is not asserted, it is checked against the one item that can check it. The
rower is 2.44 × 0.61 m = **1.49 m²** as an object and 2.74 × 1.22 m = **3.34 m²**
in use. Its `[1, 2]` footprint at 1.5 m is **4.5 m²**. The authored catalogue
was already storing envelopes, not objects — 4.5 m² is three times the object
and a close fit to the envelope. Every other footprint is read the same way.

### 3.1 The corollary: competition clearance is NOT working clearance

R61 files ringside clearance (2.44 m), judo's exterior safety area (4 m),
wrestling's protection area (1.5 m) and its mat-to-mat gap (1 m) in the same
column as the rower's in-use envelope. They are not the same kind of number.

- **Working clearance** is where the athlete's body goes. It is a property of
  using the object and it belongs on this grid.
- **Competition clearance** is where officials, seconds, physicians and the
  first spectator row go on fight night. It is a property of *staging a
  sanctioned bout in a venue*, and R61 §3 says as much: those rules govern
  "position and sightline", and the ringside figure is graded `DOC` against
  state commission rules about **ringside seating**.

The gym floor is a training facility. The venue is `ArenaRig` and `MatRig`,
which take metres and never see a cell. **Competition clearance is the arena's
arithmetic and is deliberately absent from every footprint below.**

This is the line that makes R61's **O4** operative: `judo_tatami_area` is
training furniture and is not an IJF Olympic field of play, so it is not
required to carry a 4 m exterior safety area. §4 shows what happens if the line
is not drawn.

---

## 4. What a ring costs the floor

Ring platform = canvas inside the ropes + 0.46 m apron on each side (ABC
Unified Rules *Rings* (3); Fla. Admin. Code 61K1-4.005(1)(b), both `CLAUSE`).

| Ring | Canvas | Platform | Cells at 1.5 m | Fits 5-cell depth? |
|---|---|---|---|---|
| 16 ft, ABC guideline floor | 4.88 m | **5.80 m** | **`[4, 4]` = 6.00 m** | yes |
| 18 ft, Florida floor | 5.49 m | 6.41 m | `[5, 5]` = 7.50 m | yes, exactly |
| 20 ft, ABC guideline ceiling | 6.10 m | 7.02 m | `[5, 5]` = 7.50 m | yes, exactly |
| 22 ft, Florida ceiling | 6.71 m | 7.63 m | `[6, 6]` = 9.00 m | **no** |
| 16 ft **+ 2.44 m ringside all round** | 4.88 m | **10.68 m** | `[8, 8]` = 12.00 m | **no** |

**Retrofitted onto `ArenaFit` (G20), 2026-09-08.** Every figure in this table
was hand arithmetic when it was written, a stage before the module that does
exactly this arithmetic existed. `Godot/tests/arena_fit_test.gd` now computes
the whole table through `ArenaFit.fits()`, so a row that changes fails a test
rather than quietly disagreeing with the code.

That retrofit also settles the two ring figures this repository carries.
**10.68 m here and 11.88 m in `arena_fit_test.gd` are the same formula on
different rings** — 10.68 m is the 16 ft ABC floor (`club_ring`, the smallest
ring a commission will sanction), and the test's case is the 20 ft ABC ceiling,
whose 7.02 m platform rounded to 7 m gives 11.88 m and unrounded gives 11.90 m.
Neither was ever wrong; nothing said which ring each belonged to. Both are
asserted now, side by side, in `_r66_ring_footprints()`.

**`club_ring` at `[4, 4]` costs 16 cells = 36.0 m²** — 40% of an 8-wide starter
floor and 27% of a maximum gym. A real club gym is mostly ring, so that is the
right shape of answer rather than a symptom.

**A ring with sanctioned ringside clearance does not fit this gym at any
width**, because 10.68 m exceeds the fixed 7.5 m depth. To make it fit, a cell
would have to be ≥ 2.14 m — at which a first-aid cabinet occupies 4.6 m² and
§1.3 rules the catalogue absurd. This is the strongest evidence for §3.1: the
grid cannot host a sanctioned venue and should not pretend to.

### 4.1 Can `club_ring` honestly stay one catalogue item?

**Yes, at `[4, 4]`, understood as a club ring at the bottom of the legal
range.** R61's **C1** is the obstacle: a boxing ring has no single legal size
(ABC 16–20 ft, Florida 18–22 ft), so one item cannot express the range and
picking a size is picking a jurisdiction. The escape is that 16 ft is legal
under the ABC guideline — the item is *named* `club_ring`, and the smallest
legal ring is what a club owns.

What `[4, 4]` therefore claims, and must be allowed to claim: this gym has the
smallest ring a commission will sanction. **A promotion-grade 20 ft ring is a
different object** at `[5, 5]` = 7.5 × 7.5 m, which fits the 7.5 m depth exactly
and leaves no circulation front or back. Adding it is content, not this task;
filed as a follow-on.

R61's **C2** — the same rulebook putting an MMA ring at 20–32 ft and a cage at
18–32 ft — is untouched here. The catalogue has no cage item at all.

---

## 5. All 22 footprints at 1.5 m

`m²` is the footprint's own area at 1.5 m. **Grade** carries R61's meaning.
`AUTHORED` is not one of R61's grades and is used deliberately: it says the
number was chosen by a designer and this ruling did not source it.

### Sourced — 7 items

| id | today | ruling | m² | Basis | Grade |
|---|---|---|---|---|---|
| `club_ring` | `[4, 3]` | **`[4, 4]`** | 36.0 | 4.88 m canvas + 0.46 m apron ×2 = 5.80 m | `DIRECT` |
| `heavy_bag` | `[1, 2]` | `[1, 2]` | 4.5 | 0.36 m bag + ≥2 m swing = 2.36 m long; 1.5 m lateral pitch | `INHERITED` |
| `speed_bag` | `[1, 1]` | `[1, 1]` | 2.25 | 0.61 m platform; **clearance `UNKNOWN`** | `INHERITED` (object only) |
| `double_end_bag` | `[1, 1]` | `[1, 1]` | 2.25 | 5–12 in bag, floor-to-ceiling anchoring; **clearance `UNKNOWN`** | `INHERITED` (object only) |
| `rowing_ergometer` | `[1, 2]` | `[1, 2]` | 4.5 | **2.74 × 1.22 m in use** — the anchor of §1.2 | `INHERITED` |
| `modular_combat_mat` | `[2, 2]` | `[2, 2]` | 9.0 | 3.0 × 3.0 m = 9 × WKF 1×1 panels | `DIRECT` (panel size) |
| `judo_tatami_area` | `[2, 2]` | `[2, 2]` | 9.0 | training mat area, **not** the IJF field of play — see below | `AUTHORED` |

**`judo_tatami_area` is the one place the sourced figure was refused.** The IJF
Olympic field of play is 10 × 10 m contest plus a 4 m minimum exterior safety
area = 18 × 18 m = `[12, 12]` = 324 m², which is **2.4 times a maximum gym**. By
§3.1 that is competition clearance and belongs to `MatRig`. As training
furniture the item stays `[2, 2]`, and it is marked `AUTHORED` rather than
`DIRECT` so nobody later mistakes 3 × 3 m for a sourced tatami dimension.

### Authored — 15 items, unchanged

R61: "15 of 22 remain entirely `UNKNOWN`." Nothing was sourced for any of them,
so **nothing is re-derived and no dimension is invented.** They keep the
footprint they shipped with and this ruling records only that it is authored.

`exercise_bike [1,2]` · `air_bike [1,2]` · `compact_weights [2,2]` ·
`cardio_floor [2,2]` · `physio_table [2,1]` ·
`mobility_stretch_station [2,1]` · `cold_water_tub [2,2]` ·
`rehabilitation_pool [4,3]` · `sports_medicine_room [3,2]` ·
`grappling_dummy [1,1]` · `focus_mitts_locker [1,1]` ·
`striking_safety_locker [1,1]` · `first_aid [1,1]` ·
`capoeira_roda_kit [2,2]` · `arnis_safety_kit [2,1]`

Anyone wanting these derived should expect to source **products, not rules**,
and to grade the result `INHERITED` forever.

---

## 6. Saves: no migration, deliberately

`_make_equipment_instance` (`:3049`, `:3057`) **copies** the definition's
footprint into the instance, and `get_used_floor_space()` (`:3084`) sums the
instances. A placed item therefore carries its own footprint and never re-reads
the catalogue.

So an existing save loads unchanged: a `club_ring` placed before this ruling
stays `[4, 3]` with `space_cost` 12, on the cells it already occupies. Nothing
is orphaned and `get_floor_capacity()` and `get_used_floor_space()` keep
agreeing, because neither changed.

**A migration was considered and refused.** Growing a placed ring from `[4, 3]`
to `[4, 4]` extends it one row down into cells that may be occupied — in
today's starter layout they are, by `modular_combat_mat` at `(2, 3)`. There is
no safe automatic relocation, and silently moving a player's floor is worse
than a legacy ring at its legacy size. New careers get the new layout; new
purchases get `[4, 4]`.

The starter layout in `generate_starter_boxing_floor` **is** changed, because a
`[4, 4]` ring overlaps `modular_combat_mat` at `(2, 3)` and shipping an
overlapping starter floor is not an option. Two pieces move; nothing is added
or removed, and the spec order is preserved so footprint-driven test lookups
still find the same items.

### 6.1 The starter floor is now 90% full at its narrowest, and that is measured

With `club_ring` at `[4, 4]` the starter floor uses **36 of 40 cells** when the
generator rolls 8 wide (81 of 90 m2) and 36 of 45 when it rolls 9. Rows 0-3 are
completely full; every free cell is in the back row.

Tight, and honest rather than broken: a small club with a regulation ring is a
cramped room, and `expand_floor` is the game's answer to it. One mechanical
consequence is worth naming, because it is a behaviour change nobody asked for:

| Bought item | Auto-places on an 8-wide starter floor? | On a 9-wide one? |
|---|---|---|
| `[1, 1]` e.g. `first_aid` | yes | yes |
| `[2, 1]` e.g. `physio_table` | yes (the back row) | yes |
| `[1, 2]` e.g. `heavy_bag` | **no** | yes (the spare column) |
| `[2, 2]` and larger | **no** | **no** |

`purchase_equipment` places with `_find_first_fit` (`:3188`) using the
definition's footprint as authored, so a `[1, 2]` heavy bag is refused on the
narrow starter floor until the player expands. That refusal is the correct
behaviour for a full room and no test depends on the old slack, but a designer
who wants a bag bought on day one should widen the starter floor rather than
shrink the ring back.

---

---

## 7. What the code does, and what it does not

Supported by this ruling, and therefore built:

- `FLOOR_CELL_METRES := 1.5` beside `MAX_FLOOR_WIDTH`, commented with the
  reasoning and a link to this file.
- `get_floor_area_m2()` and `get_used_floor_area_m2()` beside the two cell
  functions they derive from, so the constant is load-bearing rather than
  decorative and the metre view can never disagree with the cell view.
- `club_ring` `[4, 3]` → `[4, 4]` in `equipment_catalog.json`.
- Two starter pieces moved so the new ring does not overlap.

Not built, and why:

- **No economy change.** §2.2 checked `12000 * room_tier` and it survives.
- **No depth change.** §2.1 is a real finding and a capacity change; filed.
- **No new catalogue item.** §4.1's 20 ft show ring is content.
- **No occupancy rule** from the IBC figure. §2 uses it as a check, which is
  what R61 offered it as; turning it into a game constraint is new behaviour.
- **No 3D work.** `ArenaRig` and `MatRig` take metres and never see a cell.
- **No vertical dimension.** R61's **O6** stands untouched: judo wants 12 m of
  clear height and the floor model has no third axis.

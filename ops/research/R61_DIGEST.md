# R61 DIGEST — THE SCHEMATIC CATALOGUE

Claude, 2026-09-08. Research session. **No `.gd`, no `.tscn`, no
`equipment_catalog.json` was touched, and no PDF was committed.** Deliverable is
`research/R61_SCHEMATIC_CATALOGUE.md`.

Landed in two passes the same day. The first could not open the governing
bodies' PDFs and graded their rows `DOC` — figure attributed, clause owed. The
operator then had poppler installed (`winget install oschwartz10612.Poppler`),
and the clauses were read.

## The clause pass corrected six figures

That is the headline, not a footnote. Every one came from a search engine's
summary of a rulebook rather than the rulebook:

| First pass said | The clause says |
|---|---|
| ABC cage 20–32 ft | **18–32 ft** |
| IFMA ring 6.10 / 7.30 m | **6 m min, 6.5 m max** |
| IFMA apron 0.50–0.90 m | **≥ 0.90 m** |
| IFMA posts ≤ 2.70 m | **≤ 2.85 m** |
| UWW passivity band "red" | **orange** |
| Taekwondo platform 0.6–1 m | **0.40–0.60 m** |

It also **closed four gaps** — muay thai padding 2.5–3.75 cm, BJJ panel 2 × 1 m,
wrestling's 1 m platform margin and 1 m mat-to-mat gap, judo's 12 m clear height
— and **withdrew a contradiction I had reported**: taekwondo does not describe
its contest area as two shapes. Art. 3.1.1 says the Competition Area is square
(10–12 m) and the octagonal Contest Area (~8 m) sits inside it. Two named
objects a summary had merged.

## Findings that survived both passes

1. **A boxing ring has no single legal size.** ABC 16–20 ft, Florida 18–22 ft,
   bodies to 24 ft. Hard-coding one is picking a jurisdiction. The ABC Unified
   Rules even give the MMA *ring* and the *cage* different ranges on the same
   night.
2. **Clearance is most of the floor.** A ring's canvas is about a quarter of
   what the ring consumes once ringside distance is counted; a rower is 1.49 m²
   as an object and 3.34 m² in use. Wrestling publishes a 1 m platform margin
   *and* a 1 m gap between mats — the gaps are in the rulebook. An object-only
   model lets a gym hold roughly twice what a real one holds.
3. **No single cell size reconciles the catalogue with the rulebooks.**
   `club_ring [4,3]` implies ~2 m, `judo_tatami_area [2,2]` ~9 m, `heavy_bag`
   well under 2 m. The likely reading is that most items are training furniture
   and only `club_ring` must obey a sanctioning dimension — an observation about
   which items are load-bearing, not a ruling.
4. **15 of 22 catalogue items are still entirely unsourced.** The competition
   side has plenty of ground under it; the equipment side has almost none, and
   what exists is one manufacturer's product, `INHERITED` forever.
5. **The vertical dimension exists and the game has no concept of it.** Judo
   needs 12 m of clear height, a cage fence is 1.47 m, a muay thai ring sits
   1.2–1.5 m up with 2.85 m posts. A 2-D floor model cannot say "this room is
   too low for this sport".

## Two things found while checking, outside the brief

- **The task file's anchors had drifted.** `MAX_FLOOR_WIDTH` is
  `GameState.gd:98` not `:93`, `get_floor_capacity()` `:3079` not `:3066`,
  `get_used_floor_space()` `:3084` not `:3071`. C43 and R62 moved them.
- ~~`space_cost` is `null` on all 22 items~~ **WITHDRAWN 2026-09-08, my error.**
  It is not a catalogue field: `GameState.gd:3059` computes it as
  `footprint[0] * footprint[1]` per item INSTANCE, and `get_used_floor_space()`
  (`:3084`) sums instances, not definitions. The JSON is right to omit it. I
  read the data file and not the code that consumes it, and filed the gap that
  produced. Recorded rather than deleted: a finding that would have sent the
  next stage chasing a non-bug is worth seeing once.

## What is still owed

The ABC Regulatory Guidelines for boxing, the general IJF Sport and Organisation
Rules figure (only the Olympic requirements were read), the ringside 8 ft
clearance at clause level (Ohio's site refused the connection twice), any
clearance around an MMA cage, thickness for taekwondo and BJJ, and object
dimensions for 15 catalogue items.

## What this unblocks, and what it does not

**Unblocks G18 for four disciplines.** Judo, karate, wrestling and BJJ can each
have a `MatRig` call site written now. Taekwondo lacks a thickness and a panel;
BJJ lacks a thickness. Wrestling is the only sport with an explicit inner
warning band.

**Does not settle the cell size.** That ruling is its own stage, deliberately,
so it can be argued against this evidence rather than alongside it.

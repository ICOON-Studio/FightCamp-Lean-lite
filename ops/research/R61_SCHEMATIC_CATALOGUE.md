# R61 — THE SCHEMATIC CATALOGUE: WHAT A REAL GYM MEASURES

Claude, 2026-09-08. **Gathering only.** No cell size is chosen here and no game
file was touched. Every figure carries its source, its year and a grade.

**Revised the same day, after poppler was installed.** The first pass could not
open the governing bodies' PDFs and graded their rows `DOC` — figure
attributed, clause still owed. Those clauses have now been read. **Six figures
were wrong**, and they are corrected below with the correction named rather
than quietly swapped; see §8. That is the argument for doing this, not a
footnote to it.

## How to read a row

**Grade**, copied from J12's form and meaning the same thing:

| Grade | Meaning |
|---|---|
| `DIRECT` | the governing body's own published rule states this figure for this object |
| `INHERITED` | taken from a comparable sport, a building code, or one manufacturer's product; true of *something*, not necessarily of *this* |
| `UNKNOWN` | not sourced. It says so, and it stays blank |

**Verified** records how close I got to the text: `CLAUSE` = I read the numbered
clause in the governing body's own document; `DOC` = attributed to a named
document I could not open. **Everything below is `CLAUSE` unless the row says
otherwise.**

**Two figures per object, always.** The object, and the clearance it demands. A
heavy bag is half a square metre and unusable in half a square metre. Where a
document gives only one, the other is `UNKNOWN` and says so.

---

## 1. Competition surfaces

### 1a. The boxing ring, and the MMA ring

| Figure | Value | Grade | Verified | Source |
|---|---|---|---|---|
| Boxing ring, inside the ropes (ABC guideline) | 16–20 ft (4.88–6.10 m) | DIRECT | **DOC** | ABC Regulatory Guidelines — not opened |
| Boxing ring, inside the ropes (Florida) | 18–22 ft (5.49–6.71 m) | DIRECT | CLAUSE | Fla. Admin. Code R. 61K1-4.005(1)(a) |
| **MMA ring**, inside the ropes | **20–32 ft (6.10–9.75 m)** | DIRECT | CLAUSE | ABC Unified Rules (2019), *Rings* (1) |
| Ring floor beyond the ropes (ABC Unified) | ≥ 18 in (0.46 m) | DIRECT | CLAUSE | Unified Rules, *Rings* (3) |
| Apron beyond the ropes (Florida) | ≥ 18 in (0.46 m) | DIRECT | CLAUSE | 61K1-4.005(1)(b) |
| Ropes (Florida) | ≥ 4 (≥ 5 for MMA/Sanda), at 18 / 30 / 42 / 54 in | DIRECT | CLAUSE | 61K1-4.005(1)(c) |
| Corner posts (Florida) | ≥ 3 in diameter, to ≤ 58 in | DIRECT | CLAUSE | 61K1-4.005(1)(d) |
| Platform height above floor (Florida) | ≤ 4 ft (1.22 m) | DIRECT | CLAUSE | 61K1-4.005(1)(e) |
| Canvas padding (Florida) | ≥ 1 in over a 1 in Celotex base | DIRECT | CLAUSE | 61K1-4.005(1)(g) |
| Ring padding (ABC Unified) | ≥ 1 in closed-cell foam, canvas over, extending past the ropes and over the platform edge | DIRECT | CLAUSE | Unified Rules, *Rings* (3) |
| **Clearance: ringside seats/tables to ring edge** | **≥ 8 ft (2.44 m)** | DIRECT | DOC | state commission ring-and-ringside rules |
| Clearance: first spectator row behind officials | ≥ 6 ft (1.83 m) | DIRECT | DOC | same |

**Derived outer footprint, arithmetic and not a rule.** A 20 ft ring with an
18 in apron on each side occupies 23 ft ≈ **7.01 m** square at the platform. Add
the 8 ft ringside clearance on all sides and the room it demands is 39 ft ≈
**11.89 m** square. The canvas is the *smallest* number in the specification and
roughly **a quarter of the floor area the ring actually consumes**.

### 1b. The MMA cage

| Figure | Value | Grade | Verified | Source |
|---|---|---|---|---|
| Fighting area canvas (ABC Unified) | **18 × 18 ft to 32 × 32 ft (5.49–9.75 m)** | DIRECT | CLAUSE | Unified Rules (2019), *Cages* |
| Fenced area, across (Florida) | 18–32 ft (5.49–9.75 m) | DIRECT | CLAUSE | 61K1-4.005(2)(a) |
| Shape | circular, or up to 8 equal sides | DIRECT | CLAUSE | Unified Rules, *Cages* |
| Fence height above the canvas | ≥ 58 in (1.47 m) | DIRECT | CLAUSE | Unified Rules, *Cages* |
| Posts (ABC Unified) | metal, ≤ 6 in diameter, padded | DIRECT | CLAUSE | Unified Rules, *Cages* |
| Posts (Florida) | 3–6 in diameter, 60–84 in above the floor | DIRECT | CLAUSE | 61K1-4.005(2)(e) |
| Canvas height above the building floor | ≤ 4 ft (1.22 m), with steps or a ramp | DIRECT | CLAUSE | Unified Rules, *Cages* |
| Floor padding | ≥ 1 in foam, extending beyond the fighting area and over the platform edge; no vinyl or plastic covering | DIRECT | CLAUSE | Unified Rules, *Cages* |
| **Clearance around the cage** | — | UNKNOWN | — | no figure in any rulebook read |

### 1c. The mat disciplines

The five in `Injury.BASE_DISCIPLINES` plus BJJ and muay thai. **Every one is
the same object with different figures**, which is exactly the shape
`MatRig.gd` (G18) takes.

| Discipline | Contest area | Safety / border | Thickness | Panel | Verified | Source |
|---|---|---|---|---|---|---|
| Judo (IJF, Olympic) | **10 × 10 m** | **common safety area 6 m; minimum exterior safety area 4 m** | 5 cm | **1 × 2 m** | CLAUSE | IJF Olympic Games Judo Requirements (2020), Field of Play |
| Wrestling (UWW) | 9 m diameter circle; central surface 7 m; **orange** passivity band 1 m; centre circle 1 m with a 10 cm band | protection area **1.50 m** | 3.18–5.08 cm, INHERITED (see below) | UNKNOWN | CLAUSE | UWW International Wrestling Rules, **Article 4 – The Mat** |
| Karate (WKF) | 8 × 8 m, **measured from the outside** | 2 m each side; **+1 m each side if elevated** | 2 cm | 1 × 1 m | CLAUSE | WKF Kata Competition Rules, **Art. 1.1**; WKF Organising Rules **§2.2** |
| Taekwondo (WT) | octagonal Contest Area, **~8 m across, sides ~3.3 m** | Competition Area is **square, 10 × 10 m to 12 × 12 m**; safety area is the remainder, outer line inclined < 30° | UNKNOWN | UNKNOWN | CLAUSE | WT Para Taekwondo Competition Rules, **Art. 3.1 / 3.1.1** |
| BJJ (IBJJF) | **stated as areas**: combat 36 m² (min) / 64 m² (max) | safety 28 m² (min) / 36 m² (max); match area **64 m² min, 100 m² max** | UNKNOWN | **2 × 1 m** | CLAUSE | IBJJF General Competition Regulations, **Art. 1.2.2–1.2.5** |
| Muay thai (IFMA) | ring, **6 m min to 6.5 m max inside the ropes** | platform extends **≥ 90 cm** outside the ropes | **padding 2.5–3.75 cm** | n/a | CLAUSE | IFMA Rules & Regulations v3.057 (May 2026), **14.1.1–14.1.3** |

**The one secondary source used, and why.** Article 4 publishes no mat
thickness at all. [dimensions.com/element/wrestling-mat](https://www.dimensions.com/element/wrestling-mat)
gives **1.25–2 in (31.8–50.8 mm)** and cites no governing body, so it is
graded `INHERITED` and must never be quoted as a UWW figure. It is trusted for
that one number because it **agrees with Article 4 on every figure the two
share** — 9 m circle, 12 m overall, 1 m centre circle, 1 m passivity zone — and
adds two derived areas the rulebook leaves implicit: 63.5 m² of wrestling area
inside 144 m² total. A source that matches the clause text everywhere it can be
checked is worth exactly one figure of trust, and no more.

**Platforms and clearances the mat rules publish** — these are the clearance
column for §1c and they are easy to miss:

| Figure | Value | Verified | Source |
|---|---|---|---|
| Judo platform | 0.8–1 m high, and **1 m wider and longer than the tatami** (normally 20 × 36 m for an Olympic layout) | CLAUSE | IJF requirements |
| **Judo clear height above the mats** | **≥ 12 m to the lowest hanging object** | CLAUSE | IJF requirements |
| Wrestling platform | 0.80–1.10 m high for OG / World / Continental / Ranking Series | CLAUSE | UWW Art. 4 |
| **Wrestling platform around the mat** | **≥ 1 m on each side** | CLAUSE | UWW Art. 4 |
| **Wrestling, mat to mat** | **≥ 1 m between mats** | CLAUSE | UWW Art. 4 |
| Taekwondo platform | 40–60 cm high | CLAUSE | WT Art. 3.1 |
| Muay thai ring height | 1.2–1.5 m above the ground | CLAUSE | IFMA 14.1.1 |
| Muay thai corner posts | 10–12.5 cm diameter, ≤ 2.85 m from the ground | CLAUSE | IFMA 14.1.2 |
| Muay thai ropes | 4, 3–5 cm thick | CLAUSE | IFMA 14.1.4 |

**For G18.** Every mat row decomposes into the spec `MatRig.validate()` demands
— shape, contest, safety, warning, thickness, panel, colours. After this pass a
**judo, karate, wrestling and BJJ** call site can be written. Wrestling is the
only one with an explicit inner warning band (the 1 m orange passivity zone);
BJJ's coloured safety border is the same idea expressed as an area. Taekwondo
still lacks a thickness and a panel; BJJ still lacks a thickness.

---

## 2. Training equipment, matched to the 22 catalogue ids

`Godot/assets/data/equipment_catalog.json` holds 22 items. **No rulebook
governs any of these objects**, so every sourced row is `INHERITED` from one
manufacturer's product and is true of that product only.

| Catalogue id | Current footprint (cells) | Sourced object size | Sourced clearance | Grade |
|---|---|---|---|---|
| `club_ring` | `[4, 3]` | see §1a — 4.88–6.71 m inside ropes | ≥ 2.44 m ringside | DIRECT |
| `heavy_bag` | `[1, 2]` | 14 in dia × 43 in (0.36 × 1.09 m), 70–150 lb | ≥ 2 m on one side; ≥ 3 ft all sides | INHERITED |
| `speed_bag` | `[1, 1]` | platform 24 in dia (0.61 m), 67–79 in high | UNKNOWN | INHERITED |
| `double_end_bag` | `[1, 1]` | bag 5–12 in; floor-to-ceiling anchoring | UNKNOWN | INHERITED |
| `rowing_ergometer` | `[1, 2]` | **2.44 × 0.61 m** | **2.74 × 1.22 m in use** | INHERITED |
| `modular_combat_mat` | `[2, 2]` | panel 1 × 1 m (WKF), 1 × 2 m (IJF), 2 × 1 m (IBJJF) | see §1c | DIRECT |
| `judo_tatami_area` | `[2, 2]` | see §1c — 10 × 10 m contest + 4 m exterior safety | included above | DIRECT |
| `exercise_bike`, `air_bike`, `compact_weights`, `cardio_floor`, `physio_table`, `mobility_stretch_station`, `cold_water_tub`, `rehabilitation_pool`, `sports_medicine_room`, `grappling_dummy`, `focus_mitts_locker`, `striking_safety_locker`, `first_aid`, `capoeira_roda_kit`, `arnis_safety_kit` | as shipped | UNKNOWN | UNKNOWN | UNKNOWN |

**15 of 22 remain entirely UNKNOWN.** That is the honest state of this group
and it is the most useful line in this document: the competition side of the
floor model has a great deal of ground under it; the equipment side has almost
none. Anyone wanting footprints derived rather than authored should expect to
source *products*, not rules, and to grade the result `INHERITED` forever.

---

## 3. Ringside and corner furniture

| Object | Figure | Grade | Verified |
|---|---|---|---|
| Ring edge to ringside seats/tables | ≥ 8 ft (2.44 m) | DIRECT | DOC |
| Officials' seats to first spectator row | ≥ 6 ft (1.83 m) | DIRECT | DOC |
| Physician's seat | one per corner, unobstructed view; at the door for a cage | DIRECT | DOC |
| Judges' table (karate) | at the end of the mat, judges and software technician in line | DIRECT | CLAUSE (WKF Kata 1.2–1.3) |
| Ring steps | ≤ 4 ft climb implied by the platform rule; no dimension published | UNKNOWN | — |
| Corner stools | UNKNOWN | UNKNOWN | — |
| Commission table | UNKNOWN | UNKNOWN | — |

Commission and federation rules govern **position and sightline, not furniture
size**. A judges' table has a required place and no sourced width.

---

## 4. The venue

| Figure | Value | Grade | Verified | Source |
|---|---|---|---|---|
| **Karate World Championship arena** | **≥ 56 × 38 m** for six tatamis | DIRECT | CLAUSE | WKF Organising Rules §2.2 |
| **Olympic judo platform** | normally **20 × 36 m** | DIRECT | CLAUSE | IJF requirements |
| **Clear height above a judo mat** | **≥ 12 m** | DIRECT | CLAUSE | IJF requirements |
| Assembly, standing space | 5 net ft² (0.46 m²) per person | INHERITED | DOC | IBC Table 1004.5 |
| Exercise room | 50 gross ft² (4.65 m²) per occupant | INHERITED | DOC | IBC Table 1004.5 |
| Clear width between seat rows | 12 in (305 mm), rows ≤ 14 seats | INHERITED | DOC | IBC aisle accessway |
| Row width growth | +0.6 in per seat over 7 (one aisle); +0.3 in per seat over 14 (two aisles) | INHERITED | DOC | same |
| Seat width; area per seated spectator | — | UNKNOWN | — | not confirmed |

The building-code rows are `INHERITED` deliberately: a code is a fact about a
*building* and sets an egress ceiling, not a commercial capacity. **The WKF and
IJF arena figures are better**, because they are what a governing body actually
demands of a venue that stages the sport — and the 50 gross ft² exercise-room
factor is an independent check on any cell size chosen later.

---

## 5. What the catalogue implies for the grid — OBSERVATIONS ONLY

**No cell size is chosen here.** That ruling is its own stage, so it can be
argued against this evidence rather than alongside it.

**Anchors, re-checked today — the task file's had drifted:**
`MAX_FLOOR_WIDTH = 12` is `GameState.gd:98` (task file said `:93`),
`get_floor_capacity()` `:3079` (`:3066`), `get_used_floor_space()` `:3084`
(`:3071`), expansion cost `12000 * room_tier` at `:3169` and `:3186`. C43 and
R62 moved them.

**O1. At 1 m per cell, one wrestling mat is larger than the maximum gym.** UWW
gives 9 m + 1.5 m each side = **12 m across**, plus a 1 m platform margin on
each side = **14 m**. `MAX_FLOOR_WIDTH` is 12. A fully expanded gym could not
legally hold one wrestling mat.

**O2. At 1 m per cell, `club_ring [4, 3]` is smaller than any legal ring.** The
smallest published ring is 16 ft ≈ 4.88 m inside the ropes, before its apron.

**O3. No single cell size reconciles the catalogue with the rulebooks.**
`club_ring [4, 3]` implies a cell of roughly 1.8–2.3 m to hold a real ring with
its apron. `judo_tatami_area [2, 2]` would need about 9 m to hold an Olympic
contest area with its exterior safety. `heavy_bag [1, 2]` implies well under
2 m. They differ by a factor of four or more.

**O4. The reconciliation may be that these are different kinds of object.** A
"Judo Tatami & Crash-Mat Area" bought for a gym is training furniture, not an
IJF Olympic field of play, and nothing requires it to be one. On that reading
the catalogue is internally coherent and **`club_ring` is the only item that
must obey a sanctioning dimension** — it is the one the game stages bouts in.
An observation about which items are load-bearing, not a decision.

**O5. Clearance changes the shape of the answer, not just the size.** A ring's
canvas is about a quarter of the floor the ring consumes. A rower is 1.49 m² as
an object and 3.34 m² in use. Wrestling publishes a 1 m platform margin *and* a
1 m gap between mats — the gaps are in the rulebook, not an afterthought. Any
model built on object dimensions alone lets a gym hold roughly **twice** what a
real one holds.

**O6. The vertical dimension exists and the game has no concept of it.** Judo
requires **12 m of clear height** above the mats; a cage fence is 1.47 m; a
muay thai ring sits 1.2–1.5 m off the ground with 2.85 m corner posts. A floor
model that is purely 2-D cannot express "this room is too low for this sport",
which is a real constraint on a real gym.

**O7. The economic system is untouched until a unit is chosen.**
`get_floor_capacity()` multiplies width by height, `get_used_floor_space()` sums
`space_cost`, expansion costs `12000 * room_tier`. All three are internally
consistent and none means anything in metres.

**O8. WITHDRAWN 2026-09-08, and it was my error.** This observation read
"`space_cost` is null on all 22 items yet `get_used_floor_space()` sums it -
dead code, a default applied elsewhere, or a real bug". It is none of those.
`space_cost` is not a catalogue field at all: `GameState.gd:3059` computes it as
`footprint[0] * footprint[1]` when an item INSTANCE is created, and
`get_used_floor_space()` (`:3084`) sums the instances, not the definitions. The
JSON is right to omit it. I read the data file and not the code that consumes
it, and filed the gap that produced. Left here rather than deleted: an
observation that sent the next stage chasing a non-bug is worth seeing once.

---

## 6. Contradictions, named and left unresolved

**C1. A boxing ring has no single legal size.** ABC guideline 16–20 ft, Florida
18–22 ft, sanctioning bodies to 24 ft. A 17 ft ring is legal under one and
illegal under another. **Hard-coding one ring size is picking a jurisdiction**;
the honest model is a range with the promotion or commission choosing inside it.

**C2. The MMA ring and the MMA cage have different legal sizes in the same
document.** The ABC Unified Rules put a ring at 20–32 ft and a cage at
18–32 ft. Same sport, same rulebook, same night.

**C3. Judo's field of play depends on the event.** The IJF Olympic requirement
is 10 × 10 m with a 6 m common safety area and a 4 m minimum exterior safety
area; non-Olympic events are widely run at 8 × 8 m. This catalogue records the
Olympic clause because it is the one I could read; **the general IJF Sport and
Organisation Rules figure is still owed.**

**C4. Contest area is measured differently between bodies.** WKF says 8 × 8 m
"measured from the outside"; IBJJF states *areas*, with a 36 m² combat area
inside a 64 m² match area. The same "8 × 8" is an outer bound in one sport and
a total in the other. **The contradiction most likely to be flattened by
accident.**

**C5. "Mat thickness" spans 2.5× across sports that all call it a mat.** Karate
2 cm, wrestling 4–5 cm, judo 5 cm, muay thai canvas padding 2.5–3.75 cm.
Anything modelling "a mat" as one object with one thickness is wrong for most
of them.

**C6. IBJJF's own arithmetic is not square.** A 64 m² match area is 18 combat
segments plus 14 safety segments of 2 m² each — 36 m² and 28 m², which is a
6 × 6 m combat area inside an 8 × 8 m square. The 100 m² case gives 64 m²
combat inside 100 m², an 8 × 8 m area inside 10 × 10 m. Consistent, but stated
in a unit no other body uses.

**Withdrawn from the first pass:** *"taekwondo describes its contest area as
both an 8 m octagon and an 8 × 8 m square."* Reading Art. 3.1.1 settles it —
the **Competition Area** is square (10–12 m) and the **Contest Area** inside it
is an octagon of ~8 m. Not a contradiction; two named objects a summary had
merged.

---

## 7. What could not be sourced

- **ABC Regulatory Guidelines for boxing** (the 16–20 ft ring). Not opened.
- **IJF Sport and Organisation Rules** general figure — only the Olympic
  requirements document was read.
- **The ringside 8 ft clearance** at clause level. Ohio Admin. Code 3773-2-11
  refused the connection twice.
- **Clearance around an MMA cage.** No figure in any rulebook read.
- **Thickness and panel size for taekwondo; thickness for BJJ.**
- **Ring steps, corner stools, commission table dimensions.**
- **Object dimensions for 15 of the 22 catalogue items.**
- **Seat width, and so area per seated spectator.**
- **Mirrors, lockers, mat storage.** No governing standard is likely to exist.

---

## 8. What the clause pass corrected

Six figures from the first pass were wrong. Recorded rather than swapped
silently, because the size of this list is the argument for reading clauses.

| # | First pass said | The clause says | Source |
|---|---|---|---|
| 1 | ABC cage 20–32 ft | **18–32 ft** | Unified Rules, *Cages* |
| 2 | IFMA ring 6.10 / 7.30 m | **6 m min, 6.5 m max** | IFMA 14.1.1 |
| 3 | IFMA apron 0.50–0.90 m | **≥ 0.90 m** | IFMA 14.1.2 |
| 4 | IFMA posts ≤ 2.70 m | **≤ 2.85 m** | IFMA 14.1.2 |
| 5 | UWW passivity band "red" | **orange** | UWW Art. 4 |
| 6 | Taekwondo platform 0.6–1 m | **0.40–0.60 m** | WT Art. 3.1 |

And four gaps closed: **muay thai padding thickness** (2.5–3.75 cm), **BJJ
panel size** (2 × 1 m), **wrestling platform margin and mat-to-mat gap** (1 m
each), **judo clear height** (12 m). Plus the taekwondo "contradiction"
withdrawn as an artefact of summarising rather than reading.

---

## Sources

Read clause by clause this session:

- [Fla. Admin. Code R. 61K1-4.005](https://www.law.cornell.edu/regulations/florida/Fla-Admin-Code-Ann-R-61K1-4-005)
- [ABC Unified Rules of Mixed Martial Arts (2019)](https://www.abcboxing.com/wp-content/uploads/2020/02/unified-rules-mma-2019.pdf)
- [UWW International Wrestling Rules (2026)](https://cdn.uww.org/2026-01/wrestling_rules.pdf) — Article 4
- [WKF Organising Rules (2024)](https://www.wkf.net/files/pdf/documents/WKF_Organising%20Rules_EN.pdf) — §2.2
- [WKF Kata Competition Rules (2023)](https://karate-polska.pl/wp-content/uploads/2022/12/wkf_kata_competition_rules_20231.pdf) — Art. 1.1
- [WT Para Taekwondo Competition Rules (2018)](https://www.worldtaekwondo.org/wp-content/uploads/2018/05/WT-Para-Taekwondo-Competition-Rules-as-of-April-5-2018.pdf) — Art. 3.1
- [IBJJF Rule Book](https://www.grapplearts.com/wp-content/uploads/2019/09/IBJJF-Rules-Version-4.pdf) — Art. 1.2
- [IJF Olympic Games Judo Requirements (2020)](https://78884ca60822a34fb0e6-082b8fd5551e97bc65e327988b444396.ssl.cf3.rackcdn.com/up/2021/01/IJF_Olympic_Games_Judo_Require-1611329422.pdf)

Cited but not opened:

- [ABC Regulatory Guidelines](https://www.abcboxing.com/abc-regulatory-guidelines/)
- [Ohio Admin. Code 3773-2-11](https://codes.ohio.gov/ohio-administrative-code/rule-3773-2-11) — connection refused
- [IJF documents](https://www.ijf.org/ijf/documents/5) · [IJF rules portal](https://rules.ijf.org/)
- [IFMA Rules & Regulations v3.057](https://muaythai.sport/wp-content/uploads/2026/05/IFMA-Rules-and-Regulations-v3.057_110526.pdf) — opened; listed here for the URL
- [IBC Table 1004.5](https://up.codes/s/areas-without-fixed-seating) · [IBC aisle accessways](https://up.codes/s/clear-width-of-aisle-accessways-serving-seating-in-rows)
- [Concept2 RowErg specifications](https://concept2help.zendesk.com/hc/en-us/articles/29377699390605-RowErg-Product-Specifications)

**No document was downloaded into the repository.** The PDFs live in this
session's scratchpad and are not committed. Poppler was installed on this
machine (`winget install oschwartz10612.Poppler`), which is what made the
clause pass possible; `pdftotext -layout` is the tool.

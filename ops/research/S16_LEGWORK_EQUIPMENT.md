# S16 — LEGWORK IN THE GYM: the equipment that trains footwork

The gym half of S16, shipped. **The task file's central premise was wrong and
finding that out changed the design**, so that correction comes first.

## THE CORRECTION: footwork already needed a punching bag

`TASK_S16.md` says the footwork nodes have no `node_overrides` entry, "so they
inherit `tier_defaults`, which carry **no equipment requirement at all**". The
first half is true and the second is not. They inherit the **boxing discipline
profile** (`athlete_progression_rules.json` -> `training.discipline_profiles.boxing`):

```json
"equipment_tags_any": ["heavy_bag", "focus_mitts", "double_end_bag"]
```

That list applies to **every boxing technique, footwork included**. Measured, not
read — `tools/probe_training_progress.gd`, before any change:

| technique | gym with nothing | gym with a heavy bag |
|---|---|---|
| `boxing_step_in_out` | **blocked**: `required_equipment_unavailable_or_broken` | learns |

**So before this stage a gym could not drill stepping or circling without a
punching bag.** That is the design smell the stage exists to fix, and it was
invisible from the brief. Same lesson S14 earned on the clip table: *check the
binding, not the brief.*

**IT ALSO FLIPS THE DESIGN FORK.** The task file offers MODIFIER (safe) versus
HARD GATE (save-breaking). Neither is the situation: a hard gate is already
there, pointing at the wrong equipment. Adding legwork gear to the allowed list
is **strictly less restrictive than yesterday**, so no save can lose anything on
any of the three options. The operator chose **additive**, and additive here
costs a player nothing by construction rather than by care.

## WHAT SHIPPED

**Three stations** in `equipment_catalog.json`, `category: cardio`,
`discipline_tags: ["all"]` (legwork is universal, the same way `compact_weights`
and `cardio_floor` are). Priced against the existing ladder — `focus_mitts_locker`
480, `speed_bag` 620, `cardio_floor` 900:

| id | tier | cost | footprint | capacity | modifiers |
|---|---:|---:|---|---:|---|
| `footwork_ladder_set` | 1 | 420 | 2×1 | 2 | agility, rhythm, stamina |
| `plyometric_step_rig` | 2 | 1,600 | 2×2 | 2 | agility, power, stamina |
| `reaction_footwork_grid` | 3 | 3,400 | 3×3 | 3 | agility, rhythm, technique |

The ladder set is **the cheapest item in the whole catalogue** — deliberate, per
the task file's "a rope is the cheap tier-1 item a new gym can afford; do not
price legwork as a luxury."

**`agility` already maps to `speed`** (`AthleteStatModel.MODIFIER_TO_STAT`), and
`speed` is the attribute `TrainingStrands` maps the footwork strand to, and the
quantity the operator's ruling names footwork as "defined by". No new modifier
was invented; the vocabulary already agreed.

**Alias rows** for the three new ids, all carrying a new semantic tag
`footwork_floor` — plus one on an item that already existed:

```
"cardio_floor": ["open_training_floor", "safe_open_floor", "footwork_floor"]
```

`cardio_floor`'s own description is *"Jump ropes and open floor markings"* and it
already carries the `agility` modifier. **It earns the tag by what it already
is**, and that single row is what makes this change cost an existing gym nothing:
a starter gym trains footwork without buying anything.

**Eleven `node_overrides` rows**, one per node in the catalogue's `footwork_ring`
branch, each repeating the profile's three bag tags UNCHANGED and adding
`footwork_floor`. The branch is the unit, not the three ids in the task file's
table — all 11 inherited the same bag requirement and all 11 were equally wrong.

## THE NUMBER THIS STAGE IS JUDGED ON

`tools/probe_training_progress.gd`, one athlete shape per arm (never one athlete
trained repeatedly), staffing held adequate so **equipment is the only quantity
that differs**. Sessions to learn:

| technique | tier | no gear | bag (q1) | legwork q1 | legwork q2 | legwork q3 |
|---|---:|---|---:|---:|---:|---:|
| `boxing_jab` | 1 | blocked | 3 | **blocked** | **blocked** | **blocked** |
| `boxing_step_in_out` | 1 | blocked | 3 | 3 | **2** | **2** |
| `boxing_circle_lead` | 2 | blocked | 8 | 8 | **6** | **6** |
| `boxing_circle_rear` | 2 | blocked | 8 | 8 | **6** | **6** |

Three things to read off it, and the third is the one not to skip:

1. **The bag column did not move.** Every gym that trained footwork yesterday
   trains it at the same rate today. The additive promise is kept, and
   `tests/footwork_equipment_test.gd` pins it over all 11 nodes rather than over
   a sampled pair.
2. **A punch is still a punch.** `boxing_jab` is blocked on every legwork arm.
   Putting the tag on the footwork nodes rather than on the discipline profile is
   what buys that; the profile route would have let a skipping rope teach a jab.
3. **The quality ladder pays, and q3 does not.** q1 -> q2 cuts tier 1 from 3
   sessions to 2 (−33%) and tier 2 from 8 to 6 (−25%). **q2 -> q3 changes
   nothing.** `_equipment_factor` is `0.7 + 0.15 × (quality − 1) × condition`, so
   q3 really does give 1.00 against q2's 0.85 — about 18% more progress per
   session — but at 32 and 111 rep targets that extra never crosses a session
   boundary.

## WHAT THAT MEANS FOR `reaction_footwork_grid`, stated rather than buried

**At tier 1–2 it is 3,400 for no measurable benefit over a 1,600 rig.** Whether
it pays at tier 3+ is **OPEN, not answered**: `boxing_angle_step` (tier 3) blocks
on `attribute_or_proficiency_requirement_no_longer_met` for a
30-in-everything athlete, and raising the athlete only for that row would put two
populations in one table. The probe takes an id on the command line, so a session
with a developed athlete can settle it in one run.

Until then the honest options are (a) leave it as a late-game purchase and say so
in its description, or (b) reprice it. **It is not being quietly presented as an
upgrade that pays.**

## A SECOND FINDING, NOT ACTED ON

`TechniqueTrainingCoordinator._select_station:714` returns the **first** free item
whose tags satisfy the requirement — not the best one. A gym owning both a
`plyometric_step_rig` (q2) and a `footwork_ladder_set` (q1) gets whichever comes
first in floor order, so "better gear, faster progress" is currently a lottery on
list ordering rather than a promise. Making selection prefer the highest
`quality_tier × condition` is about five lines and would affect **every**
technique, not just footwork — so it is named here with its size rather than
folded into this stage.

## WHAT THIS STAGE IS NOT

It is the **gym half only**. Nothing reads the footwork strand back out —
`TrainingStrands.total`/`share`/`dominant` are called by `AthleteDevelopment` and
by `tests/training_strands_test.gd` and by nothing else. Making the strand matter
**in a fight** waits on `TASK_R145.md`, which measures whether the engine has a
speed-gated dodge / reposition / transition path to hook onto. Per the task file,
stopping at the gym is a complete result, and this is that stop.

It is also not a change to whether footwork carries the man (ruled 2026-09-18),
and not a new strand.

## TEST

```
godot --headless --path Godot --script tests/footwork_equipment_test.gd
godot --headless --path Godot --script tools/probe_training_progress.gd
```

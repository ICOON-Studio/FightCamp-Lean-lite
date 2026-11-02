# TASK_S16 — LEGWORK IN THE GYM: THE EQUIPMENT THAT TRAINS FOOTWORK

Owner: Claude. Model: Opus, HIGH effort, Fast OFF.
GREENLIT by the operator 2026-09-18: *"We should link legwork training to
footwork"*, then *"Run R145 then go option 1, after S14 and S15"*.

**RUNS FOURTH: S14 -> S15 -> R145 -> S16. R145 IS NOT OPTIONAL BEFORE THIS** —
see "What this stage is NOT" below.

## THE STATE OF THE LINK, MEASURED BY READING, NOT ASSUMED

**The vocabulary already exists and already agrees with the footwork ruling.**
`TrainingStrands.gd:7-13` defines three strands and the first is literally
`"footwork"`, mapped to the **`speed`** attribute — the same quantity the
operator's 2026-09-18 ruling names footwork as "defined by". Every footwork
technique gates on speed, in a catalogue branch called `footwork_ring`:

| id | tier | requires | reps |
|---|---:|---|---:|
| `boxing_step_in_out` | 1 | speed 24 | 32 |
| `boxing_circle_lead` | 2 | speed 28, conditioning 28 | 111 |
| `boxing_circle_rear` | 2 | speed 28, fight_iq 28 | 111 |

`AthleteDevelopment.train_technique:361` already logs every footwork rep into
the footwork strand via `_strand_for_technique`, which derives the strand from
the technique's REQUIRED ATTRIBUTES. **So the strand is fed automatically and
this stage must not build a second ledger.**

**WHAT IS MISSING IS THE EQUIPMENT.** `equipment_catalog.json` holds 22 items in
six categories — `ring`, `bags`, `analysis`, `strength`, `cardio`, `recovery`.
There is no jump rope, agility ladder, cones, plyo box or slip rope. The one
thing a real gym trains footwork with is absent, so a player cannot buy legwork
training at all.

## THE RAILS IT PLUGS INTO — all four already exist

1. **`equipment_catalog.json`** — item schema, read it and MIRROR IT EXACTLY:
   `id`, `display_name`, `category`, `description`, `discipline_tags`,
   `footprint`, `station_capacity`, `quality_tier`, `base_safety`,
   `purchase_cost`. Do not invent a field.
2. **`athlete_progression_rules.json` -> `training.existing_asset_tag_aliases`**
   maps a catalogue id to the SEMANTIC tags requirements speak in
   (`club_ring` -> `boxing_ring`/`roped_ring`/`mma_cage_or_wall`). **A new item
   with no alias row can never satisfy any requirement.** Exposed read-only by
   `AthleteDevelopment.get_existing_asset_tag_aliases:321`.
3. **`AthleteDevelopment._evaluate_training_requirement:283`** checks
   `equipment_tags_all` / `equipment_tags_any` against `context.equipment_tags`
   and returns `required_equipment_unavailable_or_broken`.
4. **`AthleteDevelopment._session_progress_units:838`** already multiplies by
   `equipment_factor`, **clamped 0.7–1.15**. The lever for "better gear, faster
   progress" is built; it needs no new mechanic.

## THE DESIGN DECISION, AND THE TRAP UNDER IT

The footwork nodes have **NO `node_overrides` entry** in
`athlete_progression_rules.json`, so they inherit `tier_defaults`, which carry
**no equipment requirement at all**. That makes two designs available and only
one of them is safe by default:

- **MODIFIER (take this).** Legwork gear raises `equipment_factor` on a footwork
  session. Existing saves keep training footwork exactly as before and a gym
  that buys the gear trains it faster. Nothing regresses.
- **HARD GATE (do NOT take without saying so out loud).** Adding
  `equipment_tags_any` to the existing footwork nodes means **any save whose gym
  lacks the new item loses footwork training it could do yesterday.** The rules
  file's own `interruption_and_retention` principle protects accumulated reps,
  but a blocked session is still a regression the player did not cause. If a
  gate is wanted at all, put it only on NEW or higher-tier nodes, never
  retroactively on tier 1–2.

**State which you took and why, in the digest.** A save-breaking gate introduced
quietly is the expensive version of this stage.

## WHAT THIS STAGE IS NOT

- **It is NOT the consumer end, and R145 is the reason.** Nothing in the tree
  reads the footwork strand back out — `TrainingStrands.total`/`share`/
  `dominant` are called by `AthleteDevelopment` and by
  `tests/training_strands_test.gd` and **by nothing else** (verified across
  every `.gd`). Making the strand matter IN A FIGHT depends on whether the
  engine has a speed-gated dodge / reposition / transition path to hook onto,
  which is exactly what `TASK_R145.md` measures. **Read
  `research/R145_FOOTWORK_FEEDS.md` before designing anything that reaches
  the sim.** If R145 says NOT IN THE ENGINE, this stage stops at the gym and
  says so — that is a complete result, not a shortfall.
- It is NOT a change to whether footwork carries the man (RULED 2026-09-18).
- It is NOT a new strand. Three strands exist; footwork is one of them.

## PRODUCT RULES THAT BIND THE CONTENT

- The facility is a **gym**, never a camp.
- Legwork is universal: `discipline_tags` should be `["all"]` the way
  `compact_weights` and `cardio_floor` are, not a striking-only list.
- Price and footprint against the EXISTING ladder — `cardio_floor` and
  `compact_weights` are the nearest neighbours. A rope is the cheap tier-1 item
  a new gym can afford; do not price legwork as a luxury.
- Ripped art never ships.

## GATE (tier: a script edited, plus data)

```
python Godot/tools/check_scripts.py <each touched .gd>
python Godot/tools/run_tests.py --only training
python Godot/tools/run_tests.py --only develop
python Godot/tools/run_tests.py --only equipment
python Godot/tools/run_tests.py --only gym
```
Then the FULL SUITE ONCE: `python Godot/tools/run_tests.py --timeout 2400 --jobs 3`,
**fails=6 or better as a CEILING**, failing FILENAMES matching
`AgentComms/last_suite.json` name for name. THREE jobs, not four (`nproc` is 4).

**A save-migration check is part of this gate, not an extra:** load an athlete
with no legwork equipment and confirm every footwork technique they could train
before is still trainable. If that is not covered by an existing test, write it.

## THE NUMBER IT IS JUDGED ON

Not a beat count — this stage has no presentation half. Report: the items added
with their price and footprint against the existing ladder, the measured change
in footwork-session progress units with and without the gear (the
`equipment_factor` delta, computed, not asserted), and a plain statement of
whether an existing save can lose anything.

## Owned files

The GYM HALF, shipped 2026-09-19 as `4cbfec57`:

- `Godot/assets/data/equipment_catalog.json` - the three legwork stations.
- `Godot/assets/data/athlete_progression_rules.json` - the `footwork_floor` alias
  rows (including the one on the existing `cardio_floor`), the eleven
  `footwork_ring` `node_overrides`, and `training._footwork_equipment_note`.
- `Godot/tests/footwork_equipment_test.gd` - new, the additive contract over all
  eleven footwork nodes.
- `Godot/tools/probe_training_progress.gd` - new, the session-by-session
  instrument that produced this stage's number.
- `research/S16_LEGWORK_EQUIPMENT.md`, `research/S16_training_progress.json`.

## STATUS: GYM HALF COMPLETE, CONSUMER HALF STILL OWED

**The premise in "THE DESIGN DECISION" above is WRONG and is kept only so the
correction is legible.** The footwork nodes do NOT inherit an equipment-free
`tier_defaults`; they inherit the boxing discipline profile, whose
`equipment_tags_any` is `[heavy_bag, focus_mitts, double_end_bag]`. Footwork
already required a punching bag, so the MODIFIER-vs-HARD-GATE fork never
applied: every option was less restrictive than the status quo. The operator
chose ADDITIVE on 2026-09-19. See `S16_LEGWORK_EQUIPMENT.md`.

**Still owed, and still gated on R145:** nothing reads the footwork strand back
out, so the strand does not yet matter in a fight. Two operator decisions are
also open - `reaction_footwork_grid`'s price, and whether `_select_station`
preferring the best station is its own slice.

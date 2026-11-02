# C96 — engine input contract audit

## Result

One additional R133-class defect is present in a shipped live-fight builder.
`FightWorldLiveScreen._fighter` writes `weight_kg` at line 446, while
`FightRealtime._build_fighter` reads `competition_weight_kg` at lines 522–523.
The silent fallback assigns `Foot.REFERENCE_MASS_KG` to both fighters. The
screen's 66.7 kg and 120 kg bodies therefore enter realtime mechanics with the
same mass. This audit reports the defect and does not fix it because changing
that input moves seeded fights.

The earlier `attributes`/`stats` mismatch is fixed at
`FightWorldLiveScreen.gd:454–463`. Both engines now receive non-empty,
fighter-specific stats when handed the shipped top-level `stats` spelling.

## Mechanical inventory

The inventory below is the complete set of top-level athlete keys read directly
by the two engine files. It was produced from every `athlete[...]` and
`athlete.get(...)` occurrence, including helper calls in the constructor path;
defaults were not treated as evidence that a caller supplies a key.

### `FightRealtime`

Ten unique input keys (10 engine/key reads):

| Key | Read at | Default / use |
|---|---:|---|
| `stats` | 489 | `{}`; source of fighter mechanics |
| `reach_cm` | 490 | `180.0` |
| `id` | 492 | `""` |
| `name` | 493 | `"Fighter"` |
| `bout_start_stamina` | 500 | `100.0` |
| `height_cm` | 521, 523 | reference height after validation |
| `competition_weight_kg` | 522, 523 | reference mass after validation |
| `age_years` | 561 | falls through to `age` |
| `age` | 561 | `DEFAULT_AGE_YEARS` |
| `fight_plan` | 1166 | `""`; seats the palette |

`Moves.arsenal(athlete, ...)` and `Moves.guard_arsenal(athlete, ...)` receive
the whole dictionary at lines 1169 and 1174. Their internal key reads are
outside the task's named-file corpus, so keys consumed behind that boundary are
marked opaque below rather than guessed.

### `FightSimulation`

Twenty-two unique input keys (22 engine/key reads):

| Keys | Read at |
|---|---:|
| `stats`, `technique_progress`, `discipline_proficiency` | 890–892 |
| `id`, `name` | 920–921 |
| `reach_cm`, `height_cm`, `discipline`, `stance` | 930–938 |
| `bout_start_health` | 948 |
| `weigh_in`, `bout_start_stamina` | 951–952 |
| `morale`, `fight_plan` | 957, 971–984 |
| `bout_rivalry_heat`, `fight_camp_edges` | 982–983 |
| `corner_rapport`, `corner_tactical` | 991, 997 |
| `combo_tightness`, `signature_chain`, `game_plan_chains`, `combo_use` | 1002–1005 |

`_init_body_condition(athlete)` delegates the whole dictionary to
`BodyReadiness.get_regions` at lines 1017 and 1227–1228. As above, its internal
keys are opaque within the task's permitted corpus.

Combined count: **32 engine/key contract entries**, or 25 unique spellings
after the seven keys shared by both engines are deduplicated.

## Production caller diff

All six named production surfaces were audited. Four are producers or
passthroughs; two are downstream consumers and do not call an engine.

### 1. `FightWorldLiveScreen.gd` → realtime

Built keys at lines 442–464:
`id`, `name`, `sex`, `weight_kg`, `height_cm`, `stance`,
`learned_techniques`, `stats`.

- Present direct reads: `id`, `name`, `height_cm`, `stats`.
- Silent optional defaults: `reach_cm`, `bout_start_stamina`, `age_years`/`age`,
  and `fight_plan`.
- Defect: built `weight_kg`; engine reads `competition_weight_kg`. The built
  value is not read directly anywhere in `FightRealtime`; both sides get the
  same reference `mass_kg`.
- Directly unread: `sex`, `weight_kg`, `stance`. `learned_techniques` may be
  consumed through the opaque `Moves` boundary and is not labelled dead.
- Tests differ: realtime fixtures consistently build `stats` and `reach_cm`,
  but neither `weight_kg` nor `competition_weight_kg`. They prove stat/reach
  behavior while leaving mass on the default, so the mismatch is invisible.

### 2. `FightNightScreen.gd` → both engines

There are four dispatches: lab realtime/simulation at lines 258/260 and booked
realtime/simulation at lines 322/324. The screen builds no fighter dictionary:
lab mode passes `GameState.get_athlete` results unchanged; booked mode passes
the two dictionaries in `GameState.get_world_bout_contract` unchanged.

- No local rename was found. The screen's shape is exactly its GameState
  source shape.
- Because realtime receives those dictionaries without normalization, its
  `competition_weight_kg` spelling remains a hard contract requirement.
- `fight_night_realtime_test.gd` proves that a real roster bout completes and
  produces a plausible result, but it does not assert any fighter-specific
  internal quantity. Silent defaults can therefore pass it.

### 3. `RingStagePanel.gd` — not an engine caller

`present` duplicates the two athlete dictionaries for display at lines
381–399, and `bind_fight` receives an already-built engine state at lines
422–424. Its line 739 `stats` entry is built from internal fighter state for a
read contract; it is not fed back into either engine. No engine-input mismatch.

### 4. `ContenderSeries.gd` — not an engine caller

This module builds goals and evaluates finalized result/analytics dictionaries.
It never constructs a fighter dictionary or invokes either engine. No
engine-input mismatch.

### 5. `FightOpponentGenerator.gd` → simulation producer

Built keys before migration at lines 46–56:
`id`, `name`, `record`, `discipline`, `weight_class`, `age`, `stats`,
`discipline_proficiency`, `technique_progress`. `TaleOfTape.migrate_athlete`
then runs at line 57.

- Present direct simulation reads before migration: `id`, `name`, `discipline`,
  `stats`, `discipline_proficiency`, `technique_progress`.
- `reach_cm`, `height_cm`, and `stance` are explicitly delegated to the
  migration boundary. The generator's own test demonstrates the migrated
  output can complete a simulation, but completion alone does not prove those
  values avoided defaults.
- Absent keys have documented neutral/default meanings: tournament start
  health/stamina, weigh-in, morale, rivalry/camp, coach, and combo state.
  `fight_plan` is added by `GameState._with_natural_plan` before the returned
  opponent reaches a fight.
- Directly unread by `FightSimulation`: `record`, `weight_class`, `age`.
  They remain valid athlete/presentation data and are not rename evidence.
- No mismatch found for the engine contract.

### 6. `GameState.gd` → source/normalizer for `FightNightScreen`

`get_world_bout_contract` builds its two engine inputs at lines 805–855 and
adds a natural `fight_plan`. `get_athlete_fight_ready_snapshot` duplicates the
saved athlete and explicitly refreshes `stats`, `corner_rapport`,
`corner_tactical`, `combo_tightness`, `signature_chain`, and
`game_plan_chains` at lines 11876–11923. `get_fight_offer_opponent` routes the
generated-opponent shape and optional tournament start health/stamina at lines
11837–11864.

- The explicit enrichments all match `FightSimulation` reads exactly.
- The snapshot is a deep-copy passthrough, not a closed literal schema; all
  other keys keep their saved athlete spelling.
- GameState's weight lifecycle reads/writes `weight_kg` (for example lines
  1884–1885 and 12224), whereas realtime reads `competition_weight_kg`.
  Featured-athlete preservation lists also allow `competition_weight_kg`, so
  the corpus does not prove every GameState athlete misses it. It does prove
  there is no normalization at the FightNight dispatch seam. The confirmed
  defect remains the literal `FightWorldLiveScreen` builder above.

## Caller-built keys not read directly by an engine

This is the complete literal-key result for producers in the named corpus;
passthrough copies are called out separately because they do not have a closed
literal key set.

| Producer | Built but not directly read by target engine |
|---|---|
| `FightWorldLiveScreen` | `sex`, `weight_kg`, `stance`; `learned_techniques` crosses the opaque `Moves` boundary |
| `FightOpponentGenerator` | `record`, `weight_class`, `age` |
| `GameState.get_athlete_fight_ready_snapshot` | `weight_move_settling` among its explicit augmentations; the rest is a passthrough copy |
| `FightNightScreen` | none; fighter dictionaries are passthroughs |
| `RingStagePanel`, `ContenderSeries` | not engine-input producers |

## Test added

`tests/test_engine_input_contract.gd` uses production top-level spellings and
does not run a bout:

- Realtime: two different `stats` dictionaries survive construction and yield
  different `top_speed`, the movement ceiling visible in the fight.
- Simulation: two different `stats` dictionaries survive construction and
  yield different speed-plus-effective-fight-IQ initiative inputs.
- The honest realtime weight assertion detects equal internal masses and emits
  `KNOWN GAP:` instead of failing, as required for a real defect that is being
  reported rather than fixed.

## Totals

- Named production surfaces audited: **6**
- Direct engine dispatches in those surfaces: **5** (one live-world realtime,
  two FightNight realtime, two FightNight simulation)
- Engine/key contract entries: **32**
- Confirmed harmful spelling mismatches: **1**
- Worst site: **`Godot/scripts/FightWorldLiveScreen.gd:446`**

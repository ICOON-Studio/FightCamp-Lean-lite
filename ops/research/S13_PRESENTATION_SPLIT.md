# S13 — THE PRESENTATION SPLIT (exact, substitute, degrade)

**S9's instrument, re-run unchanged on S9's own population.** The prose
below is the tool's, and every number in it is THIS run's — compare it
against `S9_PRESENTATION_SPLIT.md` for the before.

Measurement tool: `Godot/tools/measure_presentation_split.gd`.
Harness: `FightBeatAdapter.begin` / `advance_beat`, the same one
`measure_technique_demand.gd` uses. No room is opened: the split is
`FightStagePlayer._thrower_clip` (`:994`) reproduced from each beat's own
`has_clip` / `clip_missing`, the presenter's `NEAREST_CLIP` table read live,
and the grafted role set (`FightStagePlayer.gd:188-207`).

## Why this is not the coverage figure

The room resolves an action beat THREE ways:

- **EXACT** — `has_clip`, `clip_role` plays. The right move.
- **SUBSTITUTE** — `clip_missing`, and `NEAREST_CLIP` has a stand-in. **A
  different move plays.** The room's readout says "the NEAREST we own";
  the picture does not.
- **DEGRADE** — nothing plays, `presented_thrower_idle`, and the man **holds
  his guard while the engine says he threw** (`FightWorldLiveScreen.gd:718`).

**CORRECTION, AND IT IS THE PREMISE THIS STAGE WAS OPENED ON.** S9 was
written down as "coverage counts a SUBSTITUTE as covered". It does not.
`measure_technique_demand._resolves_today` is `FightClipBinding.has_clip`
plus three aliases that mirror `FightBeatAdapter.TECHNIQUE_CLIP_ALIASES` —
which is precisely what sets `has_clip` on a beat — and it never consults
`FightStagePlayer.NEAREST_CLIP` at all. **U56's coverage IS the EXACT rate.**

The stage was still the right one to run, because the gap is one level over:
coverage gives the exact rate and says NOTHING about how the remainder
splits. Those remaining beats are two completely different pictures glued
together — some show the wrong move, the rest show no move — and they take
different fixes. A substitute is a binding-quality problem (watch the clip
you bound); a degrade is a routing problem or a missing clip. One number
over the pair cannot say which the operator was looking at.

## Population and catalogue

U56's own two men, to the digit, so this split is commensurate with the
coverage figure it corrects. **A: reach 183 cm**, power 60 / technique 62 /
speed 58 / defense 55 / conditioning 60 / fight_iq 50 / grapple 40.
**B: reach 176 cm**, power 55 / technique 48 / speed 62 / defense 58 /
conditioning 70 / fight_iq 55 / grapple 70. Eight differentiated
quantities; not two copies of one man. Neither carries a
`technique_progress` record, so each is handed his RULESET's whole tier 1-2
palette — both are legal for every ruleset measured, and they differ by
attributes inside the rules rather than by having techniques removed.

Catalogue: `res://assets/data/combat_rulesets.json`.

| | |
|---|---|
| Bouts per ruleset | 100 |
| Rounds | 3 |
| Seed bases | `560000`, then +1000 per found ruleset |
| Rulesets measured | boxing, kickboxing, muay_thai, mma |
| Rulesets looked for and missing | (none) |
| `NEAREST_CLIP` rows read from the presenter | 11 |
| Roles grafted (bound + punch + technique + locomotion) | 40 |
| Total beats stepped | 5307248 |

## The split, pooled over 335443 action beats

| state | beats | share of action beats | what the eye sees |
|---|---:|---:|---|
| EXACT | 158731 | 47.3% | the move the engine named |
| SUBSTITUTE | 66543 | 19.8% | **a different move** - the nearest we own |
| DEGRADE | 77677 | 23.2% | **nothing** - he holds his guard while the engine says he threw |
| GENERIC | 16894 | 5.0% | an unnamed strike playing its category role |
| SILENT | 0 | 0.0% | nothing, and NEITHER HUD counter moves (must be 0) |
| ROUTED | 15598 | 4.6% | **S6c** - off the action path to the paired ground film; the room decides whether it plays |

### Read against the recording's own HUD

`FightWorldLiveScreen._count_action` counts `played` whenever ANY clip
started — exact, substitute or generic alike — and `degraded` only on
`presented_thrower_idle`. So the HUD line in the delivered recording maps
onto this split as:

| HUD counter | this split | beats | share |
|---|---|---:|---:|
| `played` | EXACT + SUBSTITUTE + GENERIC | 242168 | **72.2%** |
| `degraded` | DEGRADE | 77677 | **23.2%** |
| (neither) | SILENT | 0 | 0.0% |

**Of the beats the HUD calls `played`, 27.5% show a move that was never thrown** — 66543 substitutes of 242168 played.

NOT MEASURED HERE, and it is a real fourth outcome: `thrower_held` — a man
who HAS his clip and does not play it because a set piece owns his body
(`FightStagePlayer.gd:830`). That is presentation occupancy, it needs a
running room, and this tool does not claim a number for it.

## The ground

There is no NEAREST for a grapple beat: `_schedule_grapple`
(`FightWorldLiveScreen.gd:865`) shows one only when
`FightClipBinding.is_paired` names a film for the exact scored technique, so
the ground is two-way by construction.

| state | beats | share of grapple beats |
|---|---:|---:|
| PAIRED (a film plays) | 5859 | 85.4% |
| DEGRADE (counted, not shown) | 1001 | 14.6% |

Grapple beats stepped: **6860**.

## A DEGRADE IS NOT ONE PROBLEM — what each one actually needs

Ranking the frozen beats by id says WHICH id; it does not say what would
unfreeze it, and the three answers cost completely different things. Read
off `technique_catalog.json`:

| fix | degraded beats | share of all degrades | share of action beats | what it costs |
|---|---:|---:|---:|---|
| **ROUTE** | 30599 | 39.4% | 9.1% | nothing to buy — `technique_class: movement` arriving on the ACTION path, where `_thrower_clip` can only offer a strike role. The eight-way walk is ALREADY grafted. |
| **GROUND** | 6477 | 8.3% | 1.9% | nothing to buy — a ground or clinch strike (`phases` without `standing`) has no standing clip by construction. **S6c took `mma_guard_gnp` out of this row** and onto the paired path (see ROUTED above); what is left here is the clinch, which has no film in the pack — `mma_dirty_boxing` is `cage_clinch`, two men upright, and every paired film we own is two men on the canvas. |
| **CLIP** | 40601 | 52.3% | 12.1% | a standing strike with no clip: bind an owned one, or buy it. |

**Only the CLIP row is a binding or a purchase.** The other two are beats
being sent down a path that has nothing to give them.

| technique class / fix | degraded beats | share of all degrades |
|---|---:|---:|
| movement / route | 30599 | 39.4% |
| kick / clip | 15173 | 19.5% |
| knee / clip | 9505 | 12.2% |
| elbow / clip | 9474 | 12.2% |
| (no technique_class) / ground | 6477 | 8.3% |
| punch / clip | 6449 | 8.3% |

## The degrade queue — what freezes the fighter

Ranked by how often the man held his guard while the engine said he threw.
This is the binding queue, and it is NOT U56's queue: U56 ranks by demand
and counts a substitute as served.

| rank | technique id | class | fix | degraded beats | share of action beats |
|---:|---|---|---|---:|---:|
| 1 | `boxing_circle_rear` | movement | **ROUTE** | 10295 | 3.07% |
| 2 | `boxing_step_in_out` | movement | **ROUTE** | 10170 | 3.03% |
| 3 | `boxing_circle_lead` | movement | **ROUTE** | 10134 | 3.02% |
| 4 | `mma_dirty_boxing` | — | **GROUND** | 6477 | 1.93% |
| 5 | `muay_thai_horizontal_elbow` | elbow | **CLIP** | 4769 | 1.42% |
| 6 | `muay_thai_khao_khong` | knee | **CLIP** | 4762 | 1.42% |
| 7 | `muay_thai_khao_tat` | knee | **CLIP** | 4743 | 1.41% |
| 8 | `muay_thai_sok_phung` | elbow | **CLIP** | 4705 | 1.40% |
| 9 | `kickboxing_teep` | kick | **CLIP** | 4500 | 1.34% |
| 10 | `kickboxing_front_kick` | kick | **CLIP** | 4492 | 1.34% |
| 11 | `muay_thai_mat_soei` | punch | **CLIP** | 3644 | 1.09% |
| 12 | `muay_thai_teep` | kick | **CLIP** | 3162 | 0.94% |
| 13 | `muay_thai_thip_top` | kick | **CLIP** | 3019 | 0.90% |
| 14 | `kickboxing_hook_kick` | punch | **CLIP** | 2805 | 0.84% |
| 15 | `grapple: grapple_clinch_engage` | — | **CLIP** | 323 | 0.10% |
| 16 | `grapple: grapple_pass` | — | **CLIP** | 265 | 0.08% |
| 17 | `grapple: grapple_mount` | — | **CLIP** | 209 | 0.06% |
| 18 | `grapple: grapple_takedown_attempt` | — | **CLIP** | 78 | 0.02% |
| 19 | `grapple: grapple_stall` | — | **CLIP** | 74 | 0.02% |
| 20 | `grapple: grapple_throw_attempt` | — | **CLIP** | 43 | 0.01% |
| 21 | `grapple: grapple_back` | — | **CLIP** | 7 | 0.00% |
| 22 | `grapple: grapple_seat` | — | **CLIP** | 2 | 0.00% |

Distinct degrading ids: **22**.

## The substitute table — which move is shown instead

Every row is a beat where the picture and the engine disagree. R127's
watched-clip problem lives here, not in the degrade queue.

| rank | engine threw -> room plays | beats | share of action beats |
|---:|---|---:|---:|
| 1 | `boxing_rear_hook -> hook_rear` | 14368 | 4.28% |
| 2 | `boxing_catch_counter -> cross` | 10369 | 3.09% |
| 3 | `boxing_one_two -> jab` | 10155 | 3.03% |
| 4 | `boxing_cross_body -> strike_body` | 6346 | 1.89% |
| 5 | `boxing_slip_counter -> cross` | 6258 | 1.87% |
| 6 | `boxing_jab_body -> strike_body` | 6240 | 1.86% |
| 7 | `boxing_one_two_hook -> hook_lead` | 6140 | 1.83% |
| 8 | `boxing_rear_uppercut -> hook_rear` | 4173 | 1.24% |
| 9 | `boxing_lead_uppercut -> hook_lead` | 2494 | 0.74% |

## Exact plays — the ids that show what was thrown

| rank | technique id | beats | share of action beats |
|---:|---|---:|---:|
| 1 | `boxing_lead_hook` | 30871 | 9.20% |
| 2 | `boxing_jab` | 21016 | 6.27% |
| 3 | `boxing_cross` | 12715 | 3.79% |
| 4 | `boxing_double_jab` | 4993 | 1.49% |
| 5 | `muay_thai_khao_chiang` | 4800 | 1.43% |
| 6 | `muay_thai_te_khao` | 4782 | 1.43% |
| 7 | `muay_thai_khao_ti` | 4763 | 1.42% |
| 8 | `muay_thai_mat_wiang_yao` | 4747 | 1.42% |
| 9 | `muay_thai_mat_trong` | 4668 | 1.39% |
| 10 | `kickboxing_roundhouse` | 4489 | 1.34% |
| 11 | `muay_thai_mat_wiang_san` | 3559 | 1.06% |
| 12 | `muay_thai_switch_kick` | 3139 | 0.94% |
| 13 | `muay_thai_round_kick` | 3136 | 0.93% |
| 14 | `muay_thai_te_chiang` | 3126 | 0.93% |
| 15 | `muay_thai_low_cross_hook` | 3097 | 0.92% |
| 16 | `muay_thai_thip_khang` | 3072 | 0.92% |
| 17 | `muay_thai_low_kick` | 3053 | 0.91% |
| 18 | `muay_thai_switch_cross` | 3042 | 0.91% |
| 19 | `muay_thai_body_kick` | 3028 | 0.90% |
| 20 | `muay_thai_mat_yaep` | 3027 | 0.90% |
| 21 | `muay_thai_te_kot` | 3020 | 0.90% |
| 22 | `muay_thai_jab_teep_switch` | 2987 | 0.89% |
| 23 | `muay_thai_straight_knee` | 2949 | 0.88% |
| 24 | `kickboxing_body_kick` | 2823 | 0.84% |
| 25 | `kickboxing_jab_lowkick` | 2818 | 0.84% |

## `NEAREST_CLIP` audit

A row is DEAD once its id is bound exactly — `_thrower_clip` asks for the
exact bind first, so the substitution never fires again. A row is IDLE when
its id never fired in this population. A row is BROKEN when the clip it
names is not grafted, which silently turns a substitute into a degrade.

| technique id | nearest | state | beats it served |
|---|---|---|---:|
| `boxing_catch_counter` | `cross` | live | 10369 |
| `boxing_cross_body` | `strike_body` | live | 6346 |
| `boxing_distance_read` | `jab` | idle — id never fired | 0 |
| `boxing_feint` | `jab` | idle — id never fired | 0 |
| `boxing_jab_body` | `strike_body` | live | 6240 |
| `boxing_lead_uppercut` | `hook_lead` | live | 2494 |
| `boxing_one_two` | `jab` | live | 10155 |
| `boxing_one_two_hook` | `hook_lead` | live | 6140 |
| `boxing_rear_hook` | `hook_rear` | live | 14368 |
| `boxing_rear_uppercut` | `hook_rear` | live | 4173 |
| `boxing_slip_counter` | `cross` | live | 6258 |

## Ruleset `boxing`

- seeds `560000` .. `560099` (100 bouts x 3 rounds)
- action beats **70986**, grapple beats **0**
- HUD-equivalent: played **82.0%**, degraded **18.0%**

| state | beats | share of action beats | what the eye sees |
|---|---:|---:|---|
| EXACT | 29636 | 41.7% | the move the engine named |
| SUBSTITUTE | 28539 | 40.2% | **a different move** - the nearest we own |
| DEGRADE | 12811 | 18.0% | **nothing** - he holds his guard while the engine says he threw |
| GENERIC | 0 | 0.0% | an unnamed strike playing its category role |
| SILENT | 0 | 0.0% | nothing, and NEITHER HUD counter moves (must be 0) |
| ROUTED | 0 | 0.0% | **S6c** - off the action path to the paired ground film; the room decides whether it plays |

- beat types stepped: `no_action` 1136512, `action` 70986

- top degrades: 
  - `boxing_circle_rear` 4346 (6.12%)
  - `boxing_circle_lead` 4263 (6.01%)
  - `boxing_step_in_out` 4202 (5.92%)

## Ruleset `kickboxing`

- seeds `561000` .. `561099` (100 bouts x 3 rounds)
- action beats **72232**, grapple beats **0**
- HUD-equivalent: played **77.6%**, degraded **22.4%**

| state | beats | share of action beats | what the eye sees |
|---|---:|---:|---|
| EXACT | 36179 | 50.1% | the move the engine named |
| SUBSTITUTE | 19874 | 27.5% | **a different move** - the nearest we own |
| DEGRADE | 16179 | 22.4% | **nothing** - he holds his guard while the engine says he threw |
| GENERIC | 0 | 0.0% | an unnamed strike playing its category role |
| SILENT | 0 | 0.0% | nothing, and NEITHER HUD counter moves (must be 0) |
| ROUTED | 0 | 0.0% | **S6c** - off the action path to the paired ground film; the room decides whether it plays |

- beat types stepped: `no_action` 1146530, `action` 72232

- top degrades: 
  - `boxing_step_in_out` 2897 (4.01%)
  - `kickboxing_front_kick` 2877 (3.98%)
  - `boxing_circle_rear` 2873 (3.98%)
  - `boxing_circle_lead` 2870 (3.97%)
  - `kickboxing_teep` 2850 (3.95%)
  - `kickboxing_hook_kick` 1812 (2.51%)

## Ruleset `muay_thai`

- seeds `562000` .. `562099` (100 bouts x 3 rounds)
- action beats **81958**, grapple beats **2805**
- HUD-equivalent: played **78.7%**, degraded **21.3%**

| state | beats | share of action beats | what the eye sees |
|---|---:|---:|---|
| EXACT | 39281 | 47.9% | the move the engine named |
| SUBSTITUTE | 8338 | 10.2% | **a different move** - the nearest we own |
| DEGRADE | 17445 | 21.3% | **nothing** - he holds his guard while the engine says he threw |
| GENERIC | 16894 | 20.6% | an unnamed strike playing its category role |
| SILENT | 0 | 0.0% | nothing, and NEITHER HUD counter moves (must be 0) |
| ROUTED | 0 | 0.0% | **S6c** - off the action path to the paired ground film; the room decides whether it plays |

- beat types stepped: `no_action` 1234664, `action` 81958, `grapple` 2805

- top degrades: 
  - `muay_thai_khao_tat` 2198 (2.68%)
  - `muay_thai_horizontal_elbow` 2166 (2.64%)
  - `muay_thai_khao_khong` 2158 (2.63%)
  - `muay_thai_sok_phung` 2154 (2.63%)
  - `muay_thai_mat_soei` 1609 (1.96%)
  - `muay_thai_teep` 1491 (1.82%)
  - `boxing_circle_rear` 1435 (1.75%)
  - `boxing_circle_lead` 1426 (1.74%)
  - `muay_thai_thip_top` 1413 (1.72%)
  - `boxing_step_in_out` 1395 (1.70%)

## Ruleset `mma`

- seeds `563000` .. `563099` (100 bouts x 3 rounds)
- action beats **110267**, grapple beats **4055**
- HUD-equivalent: played **57.5%**, degraded **28.3%**

| state | beats | share of action beats | what the eye sees |
|---|---:|---:|---|
| EXACT | 53635 | 48.6% | the move the engine named |
| SUBSTITUTE | 9792 | 8.9% | **a different move** - the nearest we own |
| DEGRADE | 31242 | 28.3% | **nothing** - he holds his guard while the engine says he threw |
| GENERIC | 0 | 0.0% | an unnamed strike playing its category role |
| SILENT | 0 | 0.0% | nothing, and NEITHER HUD counter moves (must be 0) |
| ROUTED | 15598 | 14.1% | **S6c** - off the action path to the paired ground film; the room decides whether it plays |

- beat types stepped: `no_action` 1447239, `action` 110267, `grapple` 4055

- top degrades: 
  - `mma_dirty_boxing` 6477 (5.87%)
  - `muay_thai_khao_khong` 2604 (2.36%)
  - `muay_thai_horizontal_elbow` 2603 (2.36%)
  - `muay_thai_sok_phung` 2551 (2.31%)
  - `muay_thai_khao_tat` 2545 (2.31%)
  - `muay_thai_mat_soei` 2035 (1.85%)
  - `boxing_step_in_out` 1676 (1.52%)
  - `muay_thai_teep` 1671 (1.52%)
  - `kickboxing_teep` 1650 (1.50%)
  - `boxing_circle_rear` 1641 (1.49%)

## Method notes

- Classified on `type == "action"` beats only, plus `type == "grapple"`
  counted separately. Beat types actually stepped are listed per ruleset.
- The decision order is `_thrower_clip`'s own: exact bind, then NEAREST,
  then the unnamed beat's category role. An id with both an exact bind and
  a `NEAREST_CLIP` row never reaches the substitution.
- `NEAREST_CLIP` is READ off `FightStagePlayer` at run time
  (`get_script_constant_map`), never copied into this tool — a copy would
  keep calling a newly-bound id a substitute.
- The grafted set is `bound_roles() + punch_roles() + technique_roles() +
  locomotion_roles()` (+ `getup`), which is what `FightStagePlayer.prepare`
  walks. A graft that fails on unmatched bones would make a role SILENT and
  is not visible from here; `fight_stage_technique_fidelity_test` is the
  gate that asserts silent claims are zero, and the SILENT row above is the
  same tripwire measured over a hundred bouts a ruleset.
- This tool edits no script and binds nothing.

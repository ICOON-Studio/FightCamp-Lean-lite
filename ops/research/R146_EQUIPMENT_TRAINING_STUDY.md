# R146 — EQUIPMENT, TRAINING, STAFF, DIET AND INJURY: a deep study

Operator question, 2026-09-19: *"does equipment really need to be tied to
discipline?"* plus a proposed model (physical gear first, then specialised
arms/torso/legs gear, coaches unlocking skills, partners speeding unique
learning), filters, training types, nutrition, and injury treatment.

**Research only. No `.gd` touched, so no gate** (tiered-test rule). Every claim
below is a file read, cited. Nothing here is implemented.

---

## 0. THE HEADLINE

**The game already contains most of the operator's proposed model — but split
across two systems that never meet, and with the connecting table half empty.**

- The *cost* of training is already per-body-region and per-focus. Bag work
  already loads the arms 5/5 and cardio already loads the legs 5/5.
- The *benefit* of training is per-stat, resolved through a 13-row word table.
- **Those two axes never touch.** Nothing trains "arms"; things train `power`.
- And the benefit table is **missing three of its words**, one of which disables
  the entire grappling equipment line (§3).

So the answer to the headline question is: **no, most equipment does not need a
discipline — and 14 of the 25 items already have none.** The coupling is real
only for the 11 skill stations, and even there it is doing the wrong job.

---

## 1. THE FULL EQUIPMENT AUDIT — 25 items, 6 categories

`Godot/assets/data/equipment_catalog.json`. `q` is `quality_tier`; the
`equipment_factor` it feeds is `0.7 + 0.15 × (q − 1) × condition`, clamped
0.7–1.15 (`TechniqueTrainingCoordinator._equipment_factor:714`).

### RING (6) — all discipline-tagged
| id | q | cost | disciplines | modifiers |
|---|---:|---:|---|---|
| `club_ring` | 1 | 18,000 | boxing, kickboxing, muay_thai | sparring, ring_craft, defense |
| `modular_combat_mat` | 1 | 4,200 | wrestling, bjj, karate, taekwondo… | technique, defense, stamina, **grappling** |
| `judo_tatami_area` | 2 | 6,800 | judo | technique, **balance**, defense, **grappling** |
| `grappling_dummy` | 1 | 1,250 | wrestling, bjj, judo, sanda | technique, strength, **grappling** |
| `capoeira_roda_kit` | 1 | 2,800 | capoeira | agility, rhythm, technique |
| `arnis_safety_kit` | 1 | 2,100 | arnis | technique, **speed**, defense |

### BAGS (4) — all discipline-tagged
`heavy_bag` q1 850 · `speed_bag` q1 620 · `double_end_bag` q1 950 ·
`striking_safety_locker` q1 1,450.

### ANALYSIS (1) — discipline-tagged
`focus_mitts_locker` q1 480 — accuracy, defense, combinations.

### STRENGTH (1) — `all`
`compact_weights` q1 2,600 — strength, power.

### CARDIO (7) — `all`
`footwork_ladder_set` q1 420 · `cardio_floor` q1 900 · `exercise_bike` q2 1,450 ·
`plyometric_step_rig` q2 1,600 · `air_bike` q2 2,200 · `rowing_ergometer` q3 3,200 ·
`reaction_footwork_grid` q3 3,400. (The last three legwork items are S16's,
2026-09-19.)

### RECOVERY (6) — `all`
`first_aid` q1 350 · `mobility_stretch_station` q2 1,300 · `physio_table` q2 1,800 ·
`cold_water_tub` q2 4,200 · `rehabilitation_pool` q3 24,000 ·
`sports_medicine_room` q3 28,000.

**The split is already exactly where the operator's instinct puts it.** Every
`ring`, `bags` and `analysis` item carries a discipline list — 11 items, the
*skill* half. Every `cardio`, `strength` and `recovery` item is tagged `all` — 14
items, the *physical and medical* half. **Nobody designed this as a principle; it
is simply how the catalogue came out.** Naming it as a principle is most of the
work of §4.

---

## 2. DOES EQUIPMENT NEED A DISCIPLINE? — what the tag actually does

One consumer, and it is a **hard refusal**:

```gdscript
# GameState.gd:4510
func station_legal_for_discipline(item: Dictionary, discipline: String) -> bool:
    var tags := _station_discipline_tags(item)
    if tags.has("all"):        return true
    if discipline == "mma":    return true      # "trains every tool"
    return tags.has(DISCIPLINE_TAG_ALIASES.get(discipline, discipline))
```

`set_week_program_day()` refuses illegal gear and names the missing tag
(`GameState.gd:4496-4499`). The store also filters on it (§7).

**THREE THINGS ARE WRONG WITH IT AS A DESIGN, AND THEY ARE INDEPENDENT.**

**(a) It conflates "what this station can TEACH" with "what it can be USED for."**
A judoka on a heavy bag is not learning judo — he is doing conditioning, which is
exactly what every real gym does. Today the game refuses him the bag entirely.
The tag should gate *technique learning*, not *physical use*.

**(b) MMA already proves the gate is optional.** `discipline == "mma"` returns
true unconditionally. So the game already has a fighter class for whom the whole
coupling is switched off, and nothing breaks.

**(c) It is a refusal, so it can only ever subtract.** A modifier ("you may use
it, but it teaches you nothing new") is strictly more expressive and cannot
deadlock a gym that owns the wrong gear.

**RECOMMENDATION.** Keep discipline tags, change what they gate:

| use | gate today | proposed |
|---|---|---|
| physical work (stat training, conditioning) | refused if the tag misses | **always allowed** |
| technique learning | `equipment_tags_any` on the node | unchanged — this is the right gate |
| *weekly focus* legality | `station_legal_for_discipline` | drop for `strength`/`cardio`/`recovery`; keep for `ring`/`bags` |

That single change makes the operator's "at the start you own equipment that can
only train physical attributes" true **without adding a single item** — because
14 items are already `all`, and the starting gym is already built from them.

---

## 3. TWO DEFECTS FOUND WHILE AUDITING — both small, both real

The benefit side of every piece of equipment runs through one 13-row table,
`AthleteStatModel.MODIFIER_TO_STAT:292`:

```
power, strength            -> power
technique, accuracy,
  combinations, timing     -> technique
hand_speed, rhythm, agility-> speed
defense                    -> defense
stamina                    -> conditioning
sparring, ring_craft       -> fight_iq
```

The catalogue uses **24 distinct modifier words**. Crossing the two:

**(1) `grappling` maps to NOTHING, although `grapple` IS one of the seven stats.**
Three items carry it — `modular_combat_mat` (4,200), `judo_tatami_area` (6,800)
and `grappling_dummy` (1,250). **No equipment in the entire game trains the
`grapple` stat**, because no modifier word reaches it. A wrestler's gym is, on
the stat side, a technique/defense/stamina gym.

**(2) `speed` maps to nothing**, although `speed` is a stat. The table routes
`hand_speed`, `rhythm` and `agility` to speed but not the literal word.
`arnis_safety_kit` is the only item carrying it, so the blast radius is one item
— but it is the same class of bug and one line to fix.

**(3) `balance` maps to nothing** (`judo_tatami_area`). Unlike the first two this
is a *design* gap rather than a typo — there is no balance stat. It should
probably map to `defense` or `grapple`, and that is an operator call.

The recovery words (`recovery`, `mobility`, `injury_rehabilitation`,
`post_fight_recovery`, `low_impact_rehabilitation`, `targeted_recovery`,
`medical_assessment`, `minor_injury_care`) are **correctly** absent from this
table — they are read separately by the recovery path (§8) and are not stat
training.

**Fix (1) and (2) are two lines in `MODIFIER_TO_STAT`.** They are the cheapest
real gameplay win in this whole document.

---

## 4. THE OPERATOR'S PROPOSED MODEL, EVALUATED PIECE BY PIECE

> *"at start of game you have equipment that can only train physical attributes"*

**Already 90% true, and free.** The starting gym is built from `all`-tagged
cardio/strength/recovery items. What blocks it is only that `station_legal_for_discipline`
also refuses *skill* gear the gym happens to own. Making physical focuses ignore
the discipline tag (§2) delivers this outright.

> *"then purchase equipment specialised for arms/torso/legs"*

**The vocabulary exists; the benefit side does not.** `BodyReadiness.DEFAULT_REGIONS`
is exactly `head_neck, torso_core, left_arm, right_arm, left_leg, right_leg`
(`BodyReadiness.gd:14`), and `body_readiness_rules.json -> activity_loads` already
says which focus tires which region:

| focus | head | torso | arms | legs |
|---|---:|---:|---:|---:|
| ring | 5 | 5 | 4 | 4 |
| bags | 1 | 3 | **5** | 2 |
| strength | 1 | **5** | 4 | 4 |
| cardio | 0 | 2 | 1 | **5** |

**So the game already knows that bag work is arm work and cardio is leg work — it
just never pays you for it.** The missing half is a `trains_regions` field on the
equipment item, mirroring `activity_loads`, so that a station develops the regions
it loads. That is the single highest-leverage addition in this study and it needs
no new vocabulary, no new UI concept and no new art.

> *"coach unlocks skill learning"*

**Already true and already enforced.** A technique requires
`coach_specialties_any` and `coach_teaching_min` per tier —
tier 1 needs teaching 25, tier 2 needs 45 with specialty level 2, tier 3 needs 62
(`athlete_progression_rules.json -> training.tier_defaults`), and
`AthleteDevelopment._evaluate_training_requirement:289-298` returns
`coach_unavailable`. Measured this session: tier-2 footwork blocks on
`required_partner_unavailable, coach_unavailable` with a teaching-30 coach.
**Nothing to build — this part of the operator's model is shipped.**

> *"partners speed up the unique learning"*

**Designed but not implemented.** The rules document specifies
`partner_factor: [0.65, 1.25]` — a 60-point swing — and names **15 partner role
tags** (`technical_striker`, `counter_striker`, `top_grappler`, `southpaw`, …)
plus four partner sources. The code supplies:

```gdscript
# TechniqueTrainingCoordinator.gd:366
"partner_factor": 1.05 if not partner.is_empty() else 1.0,
```

**A flat 5%, with the role tags never consulted.** So a southpaw counter-striker
and a warm body are worth exactly the same. This is the largest gap between
designed and built in the training system, and closing it is precisely the
operator's "partners speed up the unique learning."

---

## 5. TRAINING TYPES — what exists

There are **two separate training systems**, joined only at week resolution.

**SYSTEM A — the weekly focus** (`GameState.PROGRAM_WORK_FOCUSES`): `ring`,
`bags`, `strength`, `cardio`, plus `recovery` and `rest`. Seven days, one entry
each (`week_program`). Trains **stats** via the station's `training_modifiers`;
loads **body regions** via `activity_loads`.

**SYSTEM B — technique learning** (`AthleteDevelopment` +
`TechniqueTrainingCoordinator`): a named technique, reps toward a target
(32 at tier 1, 111 at tier 2), gated on attributes, discipline proficiency,
prerequisites, equipment tags, coach, partner, live rounds and calendar weeks.
Progress is a six-factor product:

```
round(22 × sessions × coach × facility × equipment × partner × fight_iq × readiness)
```

**How they join:** setting `technique_training_target` makes the technique plan
*take over the week* — `resolved_focus = technique_plan.activity_focus`
(`GameState.gd:5233`), where `_activity_focus` returns the station's own category.
So an athlete does A or B in a week, never both.

**MISSING TRAINING TYPES**, judged against the focus list and against what a fight
gym actually does:

| type | status | note |
|---|---|---|
| sparring | folded into `ring` | the `sparring` modifier exists and maps to `fight_iq`; it is not its own focus, so it cannot carry its own injury risk |
| film study / tape | **absent** | the `analysis` category exists with ONE item and no focus of its own |
| mobility / flexibility | **absent as a focus** | the `mobility` modifier exists and maps to nothing |
| weight cutting | exists, fight-camp only (§7) | not a weekly focus |
| skills drilling vs live rounds | partially | `live_rounds_required` is a tier gate, not a chosen activity |

**The `analysis` category is the clearest hole**: it has exactly one item
(`focus_mitts_locker`, which is not analysis at all — it is pad work) and no
matching focus. A film-study focus that trains `fight_iq` with near-zero body
load is a natural, cheap addition and gives an injured fighter something useful
to do — which the game currently lacks entirely.

---

## 6. THE LEARNING CURVE, AND WHETHER IT IS FUN

Measured this session (`tools/probe_training_progress.gd`), staffing adequate:

| technique | tier | reps | sessions to learn |
|---|---:|---:|---:|
| `boxing_step_in_out` | 1 | 32 | 3 (q1 gear) → 2 (q2) |
| `boxing_circle_lead` | 2 | 111 | 8 (q1) → 6 (q2) |

**The shape is right and the granularity is too coarse.** Three observations:

1. **The tier-1 curve is nearly flat** — 2 to 3 sessions. There is no felt
   progression; a technique arrives almost as soon as it is picked.
2. **The quality ladder is lumpy.** q2 → q3 changed *nothing* at either tier
   (S16 measured it) because +18% per session never crosses a session boundary at
   32 and 111 reps. Equipment quality is a real number producing an integer
   result, so most of it is invisible.
3. **Six multiplicative factors ranging 0.5–1.35 compound to an enormous spread**
   — best case over worst is roughly 6×. With only 2–8 sessions of resolution,
   most of that range is unobservable. **The factors are finer than the outcome.**

**The fix is not more factors — it is more resolution.** Either raise rep targets
so sessions matter, or report partial progress visibly (a rep bar), so the player
sees the 18% they paid for. Today they buy a q3 station and observe nothing.

**Blend with matchmaking and style.** `TrainingStrands` maps training into three
strands, the first being `footwork` → `speed`. It is written, it is fed
automatically by `train_technique`, and **nothing reads it back** —
`total`/`share`/`dominant` are called only by `AthleteDevelopment` and its own
test. So a fighter's training history does not yet shape his style, and style does
not yet shape matchmaking. That is the R145 question and it is already queued.

---

## 7. FILTERS — mostly built, filtered by the wrong axis

`GymHubPanel.MARKET_FILTERS:31` already ships **nine filters**: ALL, BOXING,
WRESTLING, BJJ, JUDO, STRIKING, MMA, FITNESS, RECOVERY. `market_matches:613`
resolves them from `category` + `discipline_tags`.

**Every one of them filters by WHO may use it, not by WHAT it does.** A player
asking "what trains my fighter's legs?" or "what will raise `power`?" cannot ask
it. Proposed additional axes, all computable from data already present:

- **by stat trained** — from `training_modifiers` → `MODIFIER_TO_STAT` (needs §3 fixed first, or grappling gear filters as training nothing).
- **by body region** — needs the `trains_regions` field from §4.
- **by purpose** — SKILL (ring/bags/analysis) vs PHYSICAL (strength/cardio) vs MEDICAL (recovery). This is the §2 principle, surfaced as a filter.
- **by affordability / fits my floor** — the store already computes both
  (`market_affordable`, `market_fits`, `GameState.gd:12611-12612`) and currently only
  uses them to print a refusal reason.

---

## 8. NUTRITION AND DIET — appropriate, and already half-built

**The answer is yes, and more of it exists than expected.** `WeightCut.gd` +
`weight_classes.json` already ship:

- **three diet plans** — `none` / `moderate` / `aggressive`, with weekly loss rate
  (0%, 0.6%, 1.1% of walking weight), plus `fatigue` and `morale` costs;
- **`gain_scale` and `injury_scale` per plan** — an aggressive cut already means
  `gain_scale: 0.9` and `injury_scale: 1.15`;
- **a water-cut model** — safe 5%, max 11%, free 3%;
- **a fight-night penalty with real teeth** — stamina up to −20 and "hurt" up to
  +5, read by `FightSimulation.gd:1059-1060` and `:1185`.

**THE GAP IS SCOPE, NOT MECHANIC.** `diet_gain_scale` and `diet_injury_scale` are
read in exactly one place — `FightCamp.gd:185` and `:219` — so **diet only exists
during an active fight camp.** Outside camp, food does not exist.

**What a nutritionist would add, and why it is the right staff role to add next:**

1. It has an existing mechanic to attach to (the two scales), unlike most staff
   ideas which need a new system first.
2. It makes the *aggressive* cut a real choice rather than a trap: a good
   nutritionist narrows the penalty, which is a legible upgrade.
3. It gives year-round weight a purpose — walking weight drifting up between
   camps, and a division move becoming a managed decision rather than a menu pick.

**Caution.** Do not model macros, meals or calories. The project's own bar is that
a system must be visible in the fight or in a decision. Nutrition's visible
outputs are: the weigh-in, the fight-night stamina penalty, injury frequency and
training gain — all four of which already exist.

---

## 9. INJURIES AND TREATMENT — the biggest gap in the document

`Injury.gd` is genuinely rich. It models **8 types** (contusion, laceration,
`concussion_rhi`, fracture, muscle_strain, ligament_joint, dislocation,
ocular_orbital) across **the same 6 body regions**, with severity 1–3, discipline
families (striking / grappling / kick / mma), and cited real medical rules —
BBBoC's 28-day facial fracture, the ARP no-sparring window, laceration 14–60 days.
It computes `train_weeks`, `compete_weeks`, `hold_weeks`, a `treatment_path` of
`surgical` or `conservative`, and `clearance_flags` of
physician / specialist / ophthalmologist.

**AND ALMOST NONE OF IT IS PLAYED.** Grepped across every `.gd`:

| field | read by |
|---|---|
| `treatment_path` | `InjuryWords.gd:148` — **turned into a word** |
| `clearance_flags` | `InjuryWords.gd:134` — **turned into a word** |

**So an injury is a timer with excellent vocabulary.** There is no treatment
decision, no clinic visit, no surgery-versus-rest choice, no specialist to hire,
and no way for the player to *do* anything about an injury except wait.

**What IS wired:** recovery equipment works. `_body_activity_context` sets
`equipment_quality_tier` from quality × condition, `coach_support_rating` from the
staff average, and — for stations carrying `targeted_recovery`,
`injury_rehabilitation` or `medical_assessment` — a `targeted_region` set to the
athlete's lowest region, with `medical_assessment` the only modifier permitted to
target the head (`GameState.gd:4396-4420`). That is a genuinely good mechanic:
**the 28,000 `sports_medicine_room` is the only station in the game that can treat
a head injury.**

**THE SHAPE OF THE FIX**, and it is mostly connecting what exists:

1. **Make `treatment_path` a choice.** Surgical = longer hold, cleaner outcome,
   money; conservative = shorter, with a re-injury chance. Both numbers exist.
2. **Make `clearance_flags` require a person.** A `concussion_rhi` needs a
   physician *and* a specialist to clear — so hire one, or pay per visit, or the
   fighter is not cleared. This is the first real use for a medical staff role
   and it gives `sports_medicine_room` a second job.
3. **Let `injury_scale` bite year-round** (§8), so a hard training block with a
   bad diet and no physio produces injuries — the loop that makes recovery
   equipment worth buying before something goes wrong rather than after.

S9b is already queued for treatments and is the right home for 1 and 2.

---

## 10. PROPOSALS, SIZED

| # | change | size | depends on |
|---|---|---|---|
| 1 | Add `grappling -> grapple` and `speed -> speed` to `MODIFIER_TO_STAT` | **2 lines** | nothing |
| 2 | Physical focuses (`strength`/`cardio`/`recovery`) ignore `station_legal_for_discipline` | ~5 lines | nothing |
| 3 | `trains_regions` on equipment items, mirroring `activity_loads`; region gains on the week | medium | 1 |
| 4 | Partner `role_tags` drive `partner_factor` across its designed 0.65–1.25 | medium | nothing |
| 5 | Equipment filters by stat / region / purpose | small | 1, 3 |
| 6 | Visible rep progress, so equipment quality is observable | small | nothing |
| 7 | Nutritionist staff role modulating the existing diet scales; diet year-round | medium | nothing |
| 8 | `treatment_path` as a choice; `clearance_flags` requiring staff | medium | S9b |
| 9 | `film_study` focus using the empty `analysis` category | small | nothing |

**1 and 2 are the two I would ship first** — together they are under ten lines,
they fix a real defect, and they deliver the operator's "start with physical
equipment" premise without new content.

---

## 11. QUESTIONS FOR THE OPERATOR

1. **`balance` (judo tatami) maps to no stat.** Should it train `defense`,
   `grapple`, or should a balance stat exist? (I would map it to `grapple`.)
2. **Should a wrestler be allowed to do bag work for conditioning?** My reading of
   §2 says yes and that the refusal is wrong — but it is a design call, and it is
   the load-bearing one for this whole study.
3. **Region training (§4): should gear train regions, or should regions stay
   purely a fatigue/injury surface?** Training them is the operator's proposal;
   the cheaper alternative is that specialised gear simply trains the *stats*
   associated with a region and the region model stays a cost.
4. **How hard should the discipline gate on skill stations be** — refuse, or allow
   at a penalty (learn a boxing technique on a judo mat at 0.7×)?
5. **Nutritionist: year-round weight drift, or fight-camp only?** Year-round is
   the richer system and the bigger build.
6. **Sparring as its own focus**, separate from `ring`, so it can carry its own
   injury risk and its own `fight_iq` gain?
7. **Is the `grapple` stat meant to be trainable by equipment at all**, or is it
   deliberately technique-only? Proposal 1 assumes the former.

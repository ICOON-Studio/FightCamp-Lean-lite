# R147 — THE ATTRIBUTE LEDGER: what we have, what is unmapped, what is missing

Companion to **`R147_TRAINING_MAP.pdf`** (3 pages, A3 landscape — the visual map).
Follows R146, which audited the equipment. This one audits the **attributes**.

**Research only. No `.gd` touched, so no gate.** Every claim is a file read, cited.

---

## 1. THE WORKING SET — 7 stats, 6 of them trainable

`AthleteStatModel.STATS:15`. Each is trained by equipment through
`MODIFIER_TO_STAT:292` and read by the fight.

| stat | trained by | the fight reads it as |
|---|---|---|
| `power` | bags, strength gear | damage after a landed strike |
| `technique` | bags, mitts, mats | fallback action strength |
| `speed` | speed bag, agility, rhythm | who acts next (with `fight_iq`) |
| `defense` | ring, mitts, double-end | opponent hit chance, submission defence |
| `conditioning` | all cardio gear | the stamina pool |
| `fight_iq` | sparring, ring craft | initiative, plan execution |
| **`grapple`** | **nothing** | grappling exchanges |

**`grapple` is orphaned.** It is a real stat and the fight reads it, but the word
`grappling` — carried by `modular_combat_mat`, `judo_tatami_area` and
`grappling_dummy` — is absent from `MODIFIER_TO_STAT`. **No equipment in the game
trains it.** A 6,800 judo tatami trains technique, defense and stamina and no
grappling at all. One row fixes it. (Also unmapped: `speed` as a literal modifier
word on `arnis_safety_kit`, which is a plain typo, and `balance` on the tatami,
which is a design call — I would map it to `grapple`.)

---

## 2. EXISTS, AND NEVER REACHES THE FIGHT

### PERSONALITY — 8 labels, already authored, fight-blind
`career_goals.json` / `CareerGoals.personality_of:46`: **Ambitious, Analytical,
Charismatic, Disciplined, Fearless, Loyal, Reserved, Temperamental.**

Read by `CareerGoals`, `CoachRapport`, `Retention`, `FighterRequests`,
`DevelopmentPanel`, `WorldPopulation`, `GameState` — and by **no fight file**.
Grepped across every `.gd`: neither `FightSimulation` nor `FightRealtime`
mentions it. **A Fearless fighter and a Reserved one fight identically.**

### TRAINING STRANDS — fed by every rep, read by nobody
Three strands, the first being `footwork` → `speed`.
`total`/`share`/`dominant` are called by `AthleteDevelopment` and by
`tests/training_strands_test.gd` and by nothing else in the tree.

### DIET SCALES — real teeth, camp-only scope
`gain_scale` and `injury_scale` per plan are read at `FightCamp.gd:185` and
`:219`. **Outside an active fight camp, food does not exist.**

### TREATMENT — the richest dead end in the game
8 injury types × 6 regions × 3 severities, with cited real rules. `treatment_path`
(`surgical`/`conservative`) and `clearance_flags`
(`physician`/`specialist`/`ophthalmologist`) are read **only** by
`InjuryWords.gd:134,148` — turned into words. **No treatment decision exists.**

---

## 3. MISSING — the attributes worth adding, and why each has somewhere to land

The test I applied: *an attribute is only worth adding if the fight already has a
place that would read it.* All four below pass it.

### AGGRESSION — both halves already exist, unconnected
`fight_plans.json` gives 34 plans a `pace_curve` of
`aggressive` / `balanced` / `cautious`, and `FightSimulation:119` prices it
(`PACE_STAMINA_MULTIPLIER` 1.15 / 1.0 / 0.85). **But pace is a CORNER CALL chosen
per round, not a property of the man.** Nobody is temperamentally a pressure
fighter.

**How to close it.** `aggression` does two jobs, both cheap:
1. **biases AI pace selection** — the AI corner already picks from a list
   (`FightSimulation:761-828`); weight that pick by the trait.
2. **a comfort tax when the plan fights the trait** — a cautious plan on a very
   aggressive man executes worse. The engine already has a comfort-tax concept for
   range (`range_intent`), so the shape is precedented.

Personality already ships `Temperamental` and `Fearless` as labels, so the
vocabulary is there; this gives it a number.

### DURABILITY / CHIN — the single largest hole
```gdscript
# FightSimulation.gd:166
const HURT_HEALTH_THRESHOLD := 35.0
```
**A constant. Every chin in the game is identical.** It is moved only by camp
composure and by the water-cut penalty (`:1185`). In a fight game, chin is a core
attribute — and the seam already exists, because the weigh-in penalty already
modifies exactly this number. Make the threshold read a per-fighter value.

### RECOVERY RATE — `conditioning` is doing two jobs
It is both the gas tank and the refill between rounds. Splitting capacity from
recovery gives cardio equipment quality something to drive, and makes the
`rowing_ergometer` vs `air_bike` choice mean something.

### WORK ETHIC — a label with no number
`Disciplined` is a personality label. A `work_ethic` scalar multiplying session
completion would make two fighters on the same program develop differently, which
is the thing that makes a roster feel alive. The slot exists: coach rapport is
already a per-pair multiplier.

**Deliberately NOT proposed:** height, reach, leg reach, stance, age and walk
weight are all **already modelled and already read** — `reach_cm` reaches the
fight at `FightSimulation.gd:1038`. They are not missing.

---

## 4. THE REST OF THE PER-FIGHTER STATE — the full map

Everything the game tracks per fighter that is not one of the 7 stats:

| quantity | fed by | read as | status |
|---|---|---|---|
| `fatigue` | training load | gates training, lowers current rating | wired |
| `morale` | results, contracts, camp | modifies rating; the fight mutates a copy | wired |
| `potential` | rolled at creation | caps growth; training slows near it | wired |
| 6 body regions | `activity_loads`, fight damage | clearance to train and to compete | wired |
| injuries | fights, camp rolls | holds — **but no treatment decision** | **dead** |
| discipline proficiency | discipline training | execution quality, action selection | wired |
| `technique_progress` | reps per technique | the palette the fight may draw from | wired |
| `fame` | results, breadth | offers, promotions, opportunities | wired |
| `age` | the calendar | the aging curve on growth | wired |
| walk / cut weight | diet plan | weigh-in, then stamina and chin | wired |
| `stance` | rolled by `TaleOfTape` | matchmaking, partner match, the fight | wired |
| personality (8) | rolled at creation | goals, rapport, retention — **never the fight** | **dead** |
| rivalry heat | history between two men | hurt threshold on the night | wired |
| 3 training strands | every technique rep | **nothing at all** | **dead** |

**Four dead ends, and three of them are one connection away from being alive.**

---

## 5. THE ONE-LINE SUMMARY OF THE WHOLE STUDY

**The cost of training is modelled per body region. The benefit is modelled per
stat. They never meet** — so nothing in the game trains "arms", things train
`power`. Closing that single gap is what turns the operator's arms/torso/legs
proposal into a system, and it needs no new vocabulary: `activity_loads` already
says bag work is arm work.

---

## 6. ORDERED PROPOSALS

See page 3 of the PDF for the full table. The first two are under ten lines
together and fix a live defect:

1. `grappling -> grapple`, `speed -> speed` in `MODIFIER_TO_STAT` — **2 lines**
2. physical focuses ignore `station_legal_for_discipline` — **~5 lines**
3. `trains_regions` on equipment items, mirroring `activity_loads` — medium
4. `partner_factor` across its designed 0.65–1.25 using the 15 role tags — medium
5. `aggression` as an attribute — medium
6. `durability` as an attribute — medium
7. visible rep progress, so equipment quality is observable — small
8. equipment filters by stat / region / purpose — small
9. nutritionist + year-round diet — medium
10. `treatment_path` as a real choice — medium
11. `TrainingStrands` reaching the fight — **blocked on R145**
12. `film_study` and `sparring` as their own focuses — small

---

## 7. OPEN QUESTIONS

Carried forward from R146 (§11) and still unanswered, plus three new:

- **R146's load-bearing one: may a wrestler do bag work for conditioning?**
- Should `balance` map to `grapple`, to `defense`, or should a balance stat exist?
- Should gear TRAIN body regions, or should regions stay purely a cost surface?
- **NEW: should `aggression` be visible to the player, or a hidden trait** the
  coach hints at? Hidden is truer to a gym; visible is easier to play with.
- **NEW: should chin be trainable at all**, or fixed at creation like potential?
  Real fighters do not train their chin — which argues for fixed, and makes it a
  scouting attribute rather than a development one.
- **NEW: is personality meant to stay management-only?** Connecting it to the
  fight is the cheapest way to make two same-stat fighters feel different, but it
  is a design direction, not a defect.

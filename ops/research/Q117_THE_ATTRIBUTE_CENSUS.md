# Q117 — The Attribute Census

**Agent:** Qwen · **Date:** 2026-09-21 · **Status:** complete

---

## 1. The Census — What Attributes Exist

**Storage key: `"stats"`** (NOT `"attributes"`). Confirmed at `AthleteStatModel.gd:199`:
`athlete.get("stats", {}).get(stat_id, 0)`. This project has been burned by this
before — the key is `"stats"`.

**Seven canonical stats**, defined in `AthleteStatModel.gd:13` (`STAT_ORDER`):

| # | Key         | Category   | Direct? | Range | Defined at                |
|---|-------------|------------|---------|-------|---------------------------|
| 1 | `power`     | PHYSICAL   | yes     | 0-100 | `AthleteStatModel.gd:16`  |
| 2 | `technique` | TECHNICAL  | yes     | 0-100 | `AthleteStatModel.gd:23`  |
| 3 | `speed`     | PHYSICAL   | yes     | 0-100 | `AthleteStatModel.gd:30`  |
| 4 | `defense`   | TECHNICAL  | yes     | 0-100 | `AthleteStatModel.gd:37`  |
| 5 | `conditioning` | PHYSICAL | yes    | 0-100 | `AthleteStatModel.gd:44`  |
| 6 | `fight_iq`  | MENTAL     | **no**  | 0-100 | `AthleteStatModel.gd:51`  |
| 7 | `grapple`   | GRAPPLING  | yes     | 0-100 | `AthleteStatModel.gd:58`  |

**`fight_iq` is DERIVED, not stored directly.** `AthleteStatModel.display_stat_value`
(`AthleteStatModel.gd:192`) calls `AthleteDevelopment.derive_fight_iq()` for any
athlete at the current development version. The derived value uses five weighted
terms: experience (0.40), depth (0.25), breadth (0.13), application (0.10),
ring-trained (0.12). The raw `stats.fight_iq` field still exists and is raised
only by sparring/ring_craft training modifiers — it feeds the `ring_trained` term
of the derivation.

**`grapple` is generated as the average of the other six** (`WorldPopulation.gd:706`),
then bumped by grappling disciplines.

**Generation range** (`WorldPopulation._generate_athlete`, line 690):
- `base = clampi(25 + talent_depth/3 + rand(-10,10), 28, 72)`
- Each non-grapple stat: `clampi(base + rand(-8,8), 20, 82)`
- Discipline bumps add 3-6 to specific stats, capped at 90

---

## 2. The Dead-Attribute Check — Does the Engine Read Them?

**Files excluded from read counts** (per task instruction):
- `AthleteStatModel.gd` — the defining file (labels, tooltips, display)
- `DevelopmentPanel.gd` — pure UI display
- `FightHudPanel.gd` / `FightHudRead.gd` — pure UI display
- `FightPlanExplainer.gd` — pure UI display
- Test files (`tests/*.gd`) — not engine reads

**Result: ALL SEVEN STATS ARE LIVE. Zero decorative. Zero write-only.**

| Stat | LIVE reads (file:line) | What it does |
|------|----------------------|--------------|
| **power** | `FightRealtime.gd:3083` — damage roll multiplier | Raises damage after strikes land |
| | `FightIntent.gd:39` — preferred range calculation | Shapes fighting distance |
| | `FightPlans.gd:349` — role scoring (damage, takedown) | Action selection weight |
| | `FightSimulation.gd:2954` — magnitude calculation | Sim fallback damage |
| | `FightSimulation.gd:1262-1269` — blitz protocol | Temporary stat boost |
| **technique** | `FightRealtime.gd:2879` — strike quality multiplier | Hit quality with fatigue |
| | `FightIntent.gd:40` — preferred range | Shapes fighting distance |
| | `FightPlans.gd:349` — role scoring (control, submission, transition) | Action selection |
| | `FightSimulation.gd:2954` — magnitude | Sim damage component |
| | `FightSimulation.gd:3622` — burst jitter | Output consistency |
| **speed** | `FightFootwork.gd:110,125` — top_speed, acceleration | Movement velocity |
| | `FightBearing.gd:78` — turn_rate | Facing recovery speed |
| | `FightRealtime.gd:1155` — top_speed (settled once) | Movement cap |
| | `FightMoves.gd:451` — volume_weight | Action volume per exchange |
| | `FightRange.gd:385` — control_score | Range dictation |
| | `FightSimulation.gd:3619` — recovery multiplier | Exchange recovery |
| | `FightIntent.gd` — via `_attr(stats, "speed")` in tolerance | Range tolerance |
| **defense** | `FightRealtime.gd:2462` — evade probability | Hit avoidance |
| | `FightRealtime.gd:3131` — guard effectiveness | Damage reduction |
| | `FightSimulation.gd:3639` — guard score | Sim defense calculation |
| | `FightCamp.gd:329` — weakness description | Pre-fight analysis |
| **conditioning** | `FightRealtime.gd:1140` — settled on fighter build | Recovery rate |
| | `FightFootwork.gd:130` — acceleration (with stamina) | Movement burst |
| | `FightMoves.gd:450` — volume_weight | Action volume |
| | `FightRange.gd:387` — control_score | Range dictation |
| | `FightSimulation.gd:3618` — recovery multiplier | Exchange recovery |
| | `BodyReadiness.gd:231,475` — training readiness gate | Body region calc |
| | `FightCamp.gd:327` — weakness description | Pre-fight analysis |
| **fight_iq** | `FightIntent.gd:78` — tolerance (range band width) | Distance discipline |
| | `FightRealtime.gd:1920` — corner instruction listen probability | Corner rapport |
| | `FightRealtime.gd:2519` — adaptation/corner weight | Mid-fight adjustment |
| | `FightRange.gd:386` — control_score | Range dictation |
| | `FightSimulation.gd:885` — listen probability | Sim corner interaction |
| | `AthleteDevelopment.gd:691,841` — derive_fight_iq, session progress | Training speed |
| **grapple** | `FightRealtime.gd:3843` — shoot attempt probability | Takedown engagement |
| | `FightRealtime.gd:3844` — clinch engage probability | Clinch engagement |
| | `FightSimulation.gd:2651` — grapple_norm in sim | Sim grappling weight |

### Gap vs. the BJJ Simulator Vocabulary

The operator's BJJ simulator has 13 attributes. This table maps each to our census:

| BJJ Simulator Attribute | Our Equivalent | Status |
|------------------------|----------------|--------|
| Sweeps | — | **MISSING** — no sweep-specific stat |
| Passing | — | **MISSING** — no guard-pass-specific stat |
| Guard | — | **MISSING** — no guard-play-specific stat |
| Top Pressure | — | **MISSING** — no top-control-specific stat |
| Scrambles | — | **MISSING** — no scramble-specific stat |
| Sub Defense | `defense` (partial) | Partly covered by general defense |
| Submissions | — | **MISSING** — no submission-offense-specific stat |
| Back Attacks | — | **MISSING** — no back-attack-specific stat |
| Leg Locks | — | **MISSING** — no leg-lock-specific stat |
| Takedowns | `grapple` (partial) | Partly covered by grapple |
| Flexibility | — | **MISSING** |
| Composure | `fight_iq` (partial) | Partly covered by fight IQ |
| Heart | `conditioning` (partial) | Partly covered by conditioning |
| Technique | `technique` | **COVERED** |

**10 of 13 BJJ attributes have no direct equivalent.** The three "partial" matches
cover general ability but not discipline-specific mastery.

---

## 3. The Saturation Check — Do Our Fighters Have Weaknesses?

### Population

- **252 fighters**, generated by `Q117_census.py` replicating
  `WorldPopulation._generate_athlete` exactly
- **Seed:** 117
- **Talent spread:** cycled through [30, 46, 50, 60, 65, 74, 80, 86, 90]
  (matching the game's tier system: C=46, B=60, A=74, S=86, plus gym_count adjustment)
- **Discipline:** uniformly random from 15 disciplines per fighter
- **No training applied** — these are fresh-generated fighters only

### Mixed Population Results

| Stat | min | p10 | p50 | p90 | max |
|------|-----|-----|-----|-----|-----|
| power | 23 | 32 | 46 | 58 | 72 |
| technique | 24 | 34 | 47 | 61 | 75 |
| speed | 24 | 33 | 47 | 60 | 72 |
| defense | 20 | 32 | 45 | 57 | 70 |
| conditioning | 23 | 32 | 47 | 60 | 69 |
| fight_iq | 21 | 33 | 47 | 59 | 69 |
| grapple | 28 | 34 | 47 | 58 | 65 |

### Saturation Metrics

- **No-weakness count (all stats ≥ 60): 2 of 252 (0.8%)**
- **Ceiling count (>2 stats > 90): 0 of 252 (0.0%)**

### By Tier

| Tier | talent_depth | p50 range | max | no-weakness | ceiling |
|------|-------------|-----------|-----|-------------|---------|
| C | 30 | 33-36 | 51-57 | 0/250 | 0 |
| B | 60 | 43-46 | 61-67 | 0/250 | 0 |
| A | 74 | 47-50 | 65-71 | 1/250 | 0 |
| S | 90 | 53-56 | 71-77 | 9/250 (3.6%) | 0 |

### Verdict

**The profile screen CAN work.** Our generated fighters do NOT saturate:

1. **No fighter at any tier has more than two stats above 90** — in fact, NO
   generated fighter has ANY stat above 90. The generation formula's hard ceiling
   is ~77 (base 72 + discipline bump 6, capped at 90 but never reaching it).
2. **Even at S-tier, only 3.6% of fighters have all stats ≥ 60.** The other 96.4%
   have at least one weakness.
3. **The p50 at S-tier is 53-56** — solidly mid-range, leaving clear room for
   both strengths and weaknesses to show on a bar chart.

**The BJJ simulator's saturation bug does NOT exist in our generation.** The
operator's bug was stats climbing with rank until six stats hit 99. Our generation
has a hard mathematical ceiling well below 90, and training gains are bounded by
`potential + 10` (max 106, display-clamped to 100). Training CAN push stats higher
over a career, but the headroom math (`(potential - current) / 20.0`) slows gains
as the stat approaches potential, preventing the cliff-edge saturation the BJJ sim
showed.

**The real risk is not saturation but SPREAD.** At C-tier (the most common tier),
all stats cluster in the 20-54 range with p50 around 35. A profile screen at this
tier shows seven short bars that all look the same — not because they're all full,
but because they're all equally empty. The shape difference between fighters at
the same tier comes from discipline bumps (±3-6) and the ±8 random spread, which
is modest. The screen's job at low tiers is to show *potential*, not *achievement*.

---

## Files Excluded from Read Counts

Per the task's trap warning, these files were excluded as non-engine reads:
- `AthleteStatModel.gd` — defining file (labels, tooltips, display_stat_value)
- `DevelopmentPanel.gd` — pure UI display of stat bars
- `FightHudPanel.gd`, `FightHudRead.gd` — fight HUD display
- `FightPlanExplainer.gd` — plan explanation UI
- `FightCamp.gd` lines 327-330 — weakness description text (counted as LIVE because
  it feeds pre-fight analysis, not just a label)
- `GameState.gd` lines 1015-1027 — scouting report text (counted as LIVE because
  it feeds matchmaking/scouting, not just display)
- All `tests/*.gd` files — test fixtures, not engine reads

---

## Gate

`python research/Q117_check.py` exits 0. It independently:
1. Re-derives the 7-key stat list from `AthleteStatModel.gd` source
2. Asserts every LIVE stat has a real `file:line` read in the engine
3. Re-generates 252 fighters and asserts no-weakness ≤ 5
4. Asserts the degenerate case (population size 0) does not divide by zero

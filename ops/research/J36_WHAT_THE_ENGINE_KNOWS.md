# J36 — What the Engine Already Knows That the Player Never Sees

**Desk:** FightCamp · **Date:** 2026-09-22 (Asia/Nicosia)  
**Rule:** Evidence from named on-disk files only. No probability/constant retune. Reporting and retention only.  
**Labels:** **COMPUTED** = named as engine-tracked during a fight in a study/digest that measured the live engine · **PROBABLY COMPUTED** = implied by those seams · **NOT EVIDENCED** = no file shows the engine tracks or retains it for narration · **STUDY-ONLY** = research/probe/corpus measured it; not proven retained for UI · **NOT FOUND** = required filename missing on disk.

---

## STATUS / sources used

| Path | Role for J36 |
| --- | --- |
| `/workspace/j36/K70_HONEST_OUTCOMES.md` | Causation-card needs; honesty = explicability, not realism retune |
| `/workspace/j36/K64_STOPPAGES_WITHOUT_A_KNOCKDOWN.md` | Non-KD stoppage gap; `FightStoppageRead.may_ask`; doctor ~1% |
| `/workspace/j36/R84_DIGEST.md` | Live realtime core: scoring, stoppage, `RealtimeRoundStats`, measured fights |
| `/workspace/j36/Q114_HOLD_CENSUS.md` | `_log_grapple` event census (40 MMA bouts) |
| `/workspace/j36/Q126_PAIR_GAP_BASELINE.md` | Animation pair-gap probe (not fight causation) |
| `/workspace/j36/C132_JAB_TYPES_IN_ENGINE.md` | Realtime impact event field list |
| `/workspace/j36/C133_ENGINE_POSITION_STANCE_DEFENCE.md` | Place, stance, defence, feint, phase seams |
| `/workspace/j36/broadcast_columns.md` | Exact UFC Stats + CompuBox post-fight columns |
| `/workspace/j20/J20_THE_VALIDATION_CORPUS.md` | Real-fight scoreboard (sport anchors, not engine retention) |
| `/workspace/j34/J34_CLINCH_THE_MISSING_NUMBERS.md` | Sport clinch gaps (literature), not engine inventory |

**R132 / R133:** **NOT FOUND** (no such files under `/workspace/j36/`). Nearest on-disk siblings used instead: **C132** / **C133**. **R130** / **R131** also **NOT FOUND** in this folder.

---

## DECISIONS (evidence only)

1. **Honesty work is reporting/retention, not retune** (K70): cheapest path is surface what the sim already computes.
2. **Distinguish engine-tracked vs study-measured vs UI-retained.** R84/Q114/C132/C133/K64 name live-engine quantities. J20/J34/Q126 measure sport or probes — **STUDY-ONLY** unless a digest also names engine tracking.
3. **K70’s internal list is necessary but incomplete** for all 12 ending narrations (see Part 1).
4. **`FightStoppageRead.may_ask` is COMPUTED evidence with no fight-ending consumer** (K64): shocks, knockdowns, unanswered landed work in a 60 s window, amplified by head condition; fires in 60.0% of bouts as a READ only.
5. **Doctor stoppage is a real engine rule** (R84: `head_neck <= 15`, between rounds) and a ~1% sport share (K64) — do not widen thresholds here.
6. **R84’s “no realtime grappling → judges decorative” finding is historically true at R84**; Q114 later shows `_log_grapple` emitting control/TD/sub events in measured MMA bouts. Do not erase either fact: R84 measured a pre-grapple scoring hole; Q114 evidences grapple **logging**.
7. **No recommendations to change probabilities or realism constants.**

---

## Part 1 — What a causation card needs (12 ending types)

K70’s buildable unit: **Method + time**, **3–5 causal bullets** from already-computed internals, optional **round score line** if decision. K70 explicitly names internals: **landed strikes by target**, **KD/rock flags**, **grappling control**, **damage bins**.

**K70 list alone is incomplete** for trajectory endings (comeback, mutual fade, squash, round-one fluke) and for mechanism endings that need windowed unanswered work or medical state (accumulation TKO, doctor). Extra quantities below mark that.

### one-punch KO
- Method + clock + round
- Finishing impact: `technique` / `region` / `contact` / `force`
- `knockdown` + whether `flash_knockdown` (R84: flash = head still above 80, up at eight)
- Pre-finish `shocked` / head wear (`wear`, `head_neck`)
- Rare-path callout (“counter while compromised”) — needs retained danger state
- **K70 incomplete?** Partial — needs flash vs worn-head distinction R84 already models

### accumulation TKO
- Method + clock (standing / “not intelligently defending” class)
- Unanswered landed work in a recent window (K64: `may_ask` 60 s)
- Shock count without knockdown (or KD = 0 path)
- Head-condition amplifier
- Volume by target over the accumulation span
- **K70 incomplete?** Yes — K70 lists damage bins / KD/rock but not the unanswered-window READ K64 names; engine also has **no consumer that ends the fight** on that READ (K64)

### submission
- Method + clock + round
- `submission_attempt` / `submission_finish` (`_log_grapple` kind — Q114)
- Position path: pass / mount / back / control (Q114 via/kind)
- Control / floor time context
- Failed escapes if logged
- **K70 incomplete?** Partial — “grappling control” yes; attempt→finish chain and position via not in K70’s short list

### close decision
- Method = decision + subtype if any
- Per-round scorecards (R84: cards turned in)
- Narrow margins: significant landed by target, control time, TD land/attempt
- Optional judge line (K70)
- **K70 incomplete?** Needs cards + small differentials; R84 noted split/majority unreachable when grappling terms were zero

### wide decision
- Same as close decision but large differentials on damage / control / TD
- Round score line showing consistent rounds
- **K70 incomplete?** Same card + volume stack

### doctor stoppage
- Method string class (sport: `TKO - Doctor's Stoppage` — K64/UFCStats; engine: DOCTOR STOPPAGE — R84)
- `head_neck` (or medical threshold) at stop
- Between-rounds timing (R84)
- Accumulated head trauma / wear leading in
- **K70 incomplete?** Damage bins help; medical threshold + between-round moment not in K70’s short list

### leg-damage finish
- Landed / wear to `legs` (R84: legs are real targets; `RealtimeRoundStats` maps both legs)
- Causal link leg damage → slowed exits / failed checks → finish (K70 example bullet)
- Method + clock
- **K70 incomplete?** Names the bullet shape; **NOT EVIDENCED** in these files that leg wear alone can end a fight or that “slowed exits” is a retained narratable state

### comeback
- Round-by-round score or damage trajectory (early deficit → late swing)
- Late method or late cards
- Optional stamina recovery / corner context
- **K70 incomplete?** Yes — needs time-series retention, not only fight totals

### mutual fade
- Both corners’ stamina low at late clock (R84 measures stamina at bell)
- Pace / output drop if retained
- Decision or late soft finish context
- **K70 incomplete?** Yes — K70’s mid-fight “fading” telegraph is named as buildable; not in the four-item internal list alone

### squash
- Early method + short clock
- Extreme asymmetry: landed by target, KD early, or quick TD→sub (Q114)
- Pre-fight lean only if shown (K70 strip — separate from card)
- **K70 incomplete?** Totals + method/time suffice if lopsided; trajectory optional

### draw
- Decision subtype draw (R84 measured unanimous draws)
- Equal or near-equal cards
- Matching volume/control lines explaining the stalemate
- **K70 incomplete?** Needs cards; split_draw/majority_draw branches were unreachable in R84’s pre-grapple panel arithmetic

### round-one fluke
- Round = 1 + short clock
- Flash / one-shot path with low prior accumulation (R84: KO from worn head or liver; flash KD gets up)
- Finishing technique/region
- Explicit rare-event flag (K70 Danger Telegraph post piece)
- **K70 incomplete?** Yes without “setup absent / rare path” retention

---

## Part 2 — Per quantity: COMPUTED / PROBABLY COMPUTED / NOT EVIDENCED

### Master table (Part 1 needs + K70 list)

| Quantity | Label | Evidence cite |
| --- | --- | --- |
| Method (KO / TKO / DOCTOR / DECISION) + result | **COMPUTED** | R84 stoppage rules table; measured 27/120 KO, 93 decisions, doctor over championship distance |
| Ending round + clock / time in fight | **COMPUTED** | R84 result/stoppage; C132 event `round`, `t_s`, `tick` |
| Scorecards / per-round judges’ cards | **COMPUTED** | R84: card per round, ten-point-must; replay compares scorecards |
| Decision subtype split / majority | **NOT EVIDENCED** as reachable from realtime when R84 measured (all unanimous); branches existed but decorative without non-damage terms | R84 finding #3 |
| Landed strikes by target / region (head, torso/body, legs) | **COMPUTED** | R84 target shares over 32,490 impacts; `RealtimeRoundStats` legs zone; C132 `region`, `wear` |
| Significant-strike flag on impacts | **COMPUTED** | C132 event field `significant` |
| Contact ladder (clean / glancing / missed) + guard answers (absorbed / blocked / slipped) | **COMPUTED** | C132 `contact`; C133 `guard_outcome` |
| Technique id / name / role / band | **COMPUTED** | C132 fields; Q114 technique resolution for grapples |
| Shocked (hurt) vs knockdown vs flash_knockdown | **COMPUTED** | R84 vocabulary; `RealtimeRoundStats` counts flash_knockdown; C132 fields |
| Head wear / `head_neck` condition | **COMPUTED** | R84 measured at bell; doctor at `<= 15` |
| Stamina at moments / at bell | **COMPUTED** | R84 stamina min/mean at final bell; FightStamina wired |
| Liver schedule / collapse | **COMPUTED** | R84: 30 scheduled, 30 fired; witnesses `liver_scheduled` / `liver_fired` |
| Damage “bins” as discrete UI buckets | **PROBABLY COMPUTED** | Continuous wear/head_neck exist (R84/C132); named “bins” only in K70 product language |
| Grapple control events / control-heavy log share | **COMPUTED** | Q114: `grapple_control` 1871/2477 events via `_log_grapple` |
| Takedown / throw land + attempt | **COMPUTED** | Q114 kinds/vias: takedown, throw, takedown_attempt, throw_attempt |
| Submission attempt + finish | **COMPUTED** | Q114: `submission_attempt` 31, `submission_finish` 14 in sample |
| Position advances (pass, mount, back, seat, position_change) | **COMPUTED** | Q114 demand table |
| Clinch engage / break; floor time; clinch time | **COMPUTED** | Q114 population: clinch 718 s, floor 1973 s / 40 bouts |
| `FightStoppageRead.may_ask` (shocks + KD + unanswered landed in 60 s, head amp.) | **COMPUTED** (READ) | K64: fires 60.0% of bouts; **no consumer that can end a fight** |
| Standing / accumulation TKO as stoppage outcome | **NOT EVIDENCED** | K64: engine stops on failed count or 3 KD/round; otherwise to the bell |
| Doctor stoppage rule | **COMPUTED** | R84: between rounds, `head_neck <= 15` |
| Corner stoppage / towel | **NOT EVIDENCED** | K64 sport rules name it; no engine consumer in these files |
| Place / cage-vs-open on impacts | **COMPUTED** | C133: `place_of` → impact records; C132 `place` |
| `pressure` / `is_cornered` | **NOT EVIDENCED** as consumed | C133: definitions only, no production consumer found |
| Stance / stance_matchup stored | **COMPUTED** | C133: FightRealtime stores `fighter["stance"]`, `stance_matchup` |
| Stance switches mid-fight | **NOT EVIDENCED** | C133: no switch-hitting |
| Feints thrown / commit window | **COMPUTED** | C133: `feints_thrown`, `commit_until_tick` |
| Phase / between-exchange state | **COMPUTED** | C133: `phase`, `phase_until_tick`, `phase_ticks` |
| Unanswered-strike window retained for UI bullets | **NOT EVIDENCED** | Used inside `may_ask` (K64); no digest proves UI retention |
| Round-by-round damage/volume trajectory retained for UI | **NOT EVIDENCED** | R84 has per-round cards; C132 per-event log exists in engine — **not proven retained as causation-card series** |
| Leg damage → slowed exits → finish chain | **NOT EVIDENCED** | K70 example only; legs are hittable (R84) |
| Pre-fight favourite / odds strip | **NOT EVIDENCED** | K70 buildable from differentials; not shown retained/computed as UI strip in these files |
| Danger telegraph mid-fight (“hurt / fading / chin compromised”) | **PROBABLY COMPUTED** thresholds; **NOT EVIDENCED** as player-facing | R84 shocked/KD/stamina/head_neck; K70 asks to expose them |
| Animation pair gaps (metres between att/vic) | **STUDY-ONLY** | Q126 `pair_gap_report.gd` baseline — not fight causation |
| Real UFC pace / KD% / outcome mix anchors | **STUDY-ONLY** | J20 corpus (sport validation), not engine retention |
| MMA clinch episode duration / exit % | **STUDY-ONLY** / sport **NOT FOUND** | J34 literature; Q114 has engage/break **counts**, not episode-second medians |
| R132 / R133 digests | **NOT FOUND** | Use C132 / C133 |

### Loud **NOT EVIDENCED** list (= build-task gaps for causation reporting)

1. **Standing accumulation TKO as an ending** (evidence READ exists; no stoppage consumer) — K64  
2. **UI retention of unanswered-window / `may_ask` summary** for bullets  
3. **Round-series causation panel** (early deficit → late swing) for comeback  
4. **Leg-damage → mobility → finish** narratable chain  
5. **Corner / towel stoppage** engine path  
6. **Player-facing danger telegraph** wired to shocked/stamina/head thresholds  
7. **Pre-fight expectation strip** (favourite + one reason)  
8. **Split/majority decision legibility** proven after grappling terms non-zero (R84 hole; Q114 logs grapples — join not evidenced here)  
9. **`pressure` / `is_cornered` consumed** for narration (C133)  
10. **Discrete damage bins** as retained UI objects (vs raw wear)  
11. **Causation Card itself** shipping from retained internals (K70 product; not evidenced built)

---

## Part 3 — Broadcast ceiling

Ceiling = what official post-fight tables already teach players to expect. From `/workspace/j36/broadcast_columns.md` only.

### UFC Stats — bout header
`Method` · `Round` · `Time` · `Time format` · `Referee` · `Details`

### UFC Stats — Totals (fight + per round)
`Fighter` · `KD` · `Sig. str.` · `Sig. str. %` · `Total str.` · `Td` · `Td %` · `Sub. att` · `Rev.` · `Ctrl`

### UFC Stats — Significant Strikes (fight + per round)
`Fighter` · `Sig. str` · `Sig. str. %` · `Head` · `Body` · `Leg` · `Distance` · `Clinch` · `Ground`

### UFC Stats — chart sub-labels
`Landed by target` (Head / Body / Leg) · `Landed by position` (Distance / Clinch / Ground) · `Per round`

### CompuBox — by round
`Total Punches Landed / Thrown` · `Jab Landed / Thrown` · `Power Punches Landed / Thrown` (each with connect %)

### CompuBox — Final Punch Stat Report
`Total Punches (Body Landed)` · `Total Jabs (Body Landed)` · `Power Punches (Body Landed)`

**Implication for FightCamp:** a causation card that cannot speak in UFC Totals + Sig. strikes language (KD, sig by target/position, TD, Sub. att, Ctrl) sits below the broadcast ceiling players already know. CompuBox adds jab/power split for boxing-rulesets.

---

## Judgement — shortest retentions unlocking most bullet types

Ranked **small set of retentions** (not new math). Count = how many of the **12 ending types** gain at least one honest one-line bullet when that retention is available. Assumes Method+clock already exist from the result object (R84).

| Rank | Retention (report what is already computed) | Ending types unlocked (of 12) | Notes |
| --- | --- | --- | --- |
| **1** | **Landed significant by target (Head/Body/Leg) + by position (Distance/Clinch/Ground)** | **9** — one-punch KO, accumulation TKO, close DEC, wide DEC, leg-damage finish, comeback, squash, draw, R1 fluke | Maps to UFC Sig. strikes columns; R84/C132 already track region/significant/position |
| **2** | **KD / shocked / flash_knockdown chain + finishing technique** | **6** — one-punch KO, accumulation TKO, squash, R1 fluke, comeback (if late KD), doctor (head path context) | R84 vocabulary; flash vs worn-head |
| **3** | **Grapple summary: Ctrl-like time + TD land/attempt + Sub att/finish + end position** | **5** — submission, close DEC, wide DEC, squash, draw | Q114 `_log_grapple`; matches UFC `Td` / `Sub. att` / `Ctrl` |
| **4** | **Per-round scorecards + per-round sig/damage snapshot** | **5** — close DEC, wide DEC, draw, comeback, mutual fade (pace by round) | R84 cards; series retention is the gap |
| **5** | **`may_ask` window snapshot (unanswered + shocks + head amp.) retained even when it does not stop the fight** | **3** — accumulation TKO, doctor setup, one-punch-after-softening | K64 READ; largest honesty gap for non-KD stoppage story |
| **6** | **Stamina + head_neck (and “both low” flag) at bell / at stop** | **3** — doctor, mutual fade, danger context for KO | R84 measured both |
| **7** | **Explicit rare-event / R1-short-clock flag on the card** | **2** — one-punch KO, round-one fluke | K70 post telegraph; copy over math |

**Shortlist one-liners (ship order):**

1. Retain **sig landed by target + position** for the card.  
2. Retain **hurt / down / flash-down + finishing blow**.  
3. Retain **control · TD · sub attempt/finish**.  
4. Retain **per-round cards + volume**.  
5. Retain **`may_ask` unanswered window** as text evidence (stoppage wiring is separate, out of J36 retune scope).  
6. Retain **stamina + head condition** at stop/bell.  
7. Tag **rare / R1** finishes explicitly.

With **1–4** alone, most of the 12 ending types can carry a broadcast-literate sentence. **5** unlocks the accumulation story K64 says the sport needs and the engine already reads.

---

## WHAT I COULD NOT FIND

- **R132_*.md** and **R133_*.md** — **NOT FOUND** (used **C132** / **C133**).  
- **R130** / **R131** — also **NOT FOUND** under `/workspace/j36/`.  
- Proof that a **Causation Card UI** already consumes the retained log.  
- Proof that **`may_ask`** can end a fight (K64: no consumer).  
- Engine **corner stoppage** / towel path.  
- **Leg-damage finish** as an engine method.  
- **UI danger telegraph** wired to live thresholds.  
- **Pre-fight favourite strip** implemented.  
- **Modern join**: Q114 grapple terms → non-unanimous decisions (R84 said impossible when terms were zero; post-grapple measurement not in these files).  
- Sport **standing-TKO %** and clinch episode medians — K64/J34 **NOT FOUND** (sport), not engine.

---

## SOURCES

1. `/workspace/j36/K70_HONEST_OUTCOMES.md` — causation card, K70 internal list, three honesty upgrades  
2. `/workspace/j36/K64_STOPPAGES_WITHOUT_A_KNOCKDOWN.md` — non-KD gap; `FightStoppageRead.may_ask`; doctor ~1%  
3. `/workspace/j36/R84_DIGEST.md` — realtime scoring/stoppage; `RealtimeRoundStats`; measured fights  
4. `/workspace/j36/Q114_HOLD_CENSUS.md` — `_log_grapple` 18-id demand census  
5. `/workspace/j36/Q126_PAIR_GAP_BASELINE.md` — pair-gap STUDY-ONLY probe  
6. `/workspace/j36/C132_JAB_TYPES_IN_ENGINE.md` — impact event fields (stand-in for missing R132)  
7. `/workspace/j36/C133_ENGINE_POSITION_STANCE_DEFENCE.md` — place/stance/defence/feint/phase (stand-in for missing R133)  
8. `/workspace/j36/broadcast_columns.md` — UFC Stats + CompuBox exact columns  
9. `/workspace/j20/J20_THE_VALIDATION_CORPUS.md` — real-fight validation scoreboard  
10. `/workspace/j34/J34_CLINCH_THE_MISSING_NUMBERS.md` — clinch literature gaps  

---

*End of J36. Path: `/workspace/j36/J36_WHAT_THE_ENGINE_KNOWS.md`.*

---

## PATCH 2026-09-22 — Claude J36 SUPPORT PACK (live tree keys)

**Source:** Operator/Claude paste in research room — grepped keys from named modules, 2026-09-22. No checkout by John. Every key below treated as **COMPUTED** (field exists in that module). This does **not** prove a player-facing UI reads them.

### Inventory (module → keys that matter for causation)

| Module | Lines | Keys relevant to a causation card |
| --- | --- | --- |
| `RealtimeRoundStats.gd` | 272 | `control`, `control_score`, `knockdowns_round`, `lands_round`, `hits_round`, `head_hand`/`head_foot`/`head_neck`, `body_hand`/`body_foot`, `torso_core`, `legs`/`left_leg`/`right_leg`, `submission_attempt(s)_round`, `takedowns_round`, `throw`/`throw_points_round`, `position_change`/`position_points_round`, `seat`/`seat_ticks`, `striking_score`, `evidence`, style tags |
| `FightRecordStats.gd` | 181 | Career/purse/streak — **not** in-bout causation (form/hype only) |
| `FightLog.gd` | 174 | `method`, `round`, `time`, `result`, `notes`, `title_fight` |
| **`PostFightRead.gd`** | **328** | `method`, `result_type`, `round`/`rounds`, `cards`, `score_a`/`score_b`, `knockdowns_a`/`b`, `control_owner`/`control_units`, `takedowns`, `throws`, `submission_attempt(s)`/`submission_finish`/`submissions_finished`/`submission_threat`, `clinches`, `exchanges`/`standing_exchanges`, `totals`, `chain`, `band`/`bout_band`, `ended_on_floor`, `winner_side`, `decision`, `complete` |
| `FightTrauma.gd` | 158 | `cut`, `swelling`, `pips`, `site`, `kind` |
| `FightStoppageRead.gd` | 175 | `unanswered`, `shocks_in_window`, `knockdowns_in_window`/`knockdowns_total`, `head_condition`, `severity`, `action` |
| `RoundScoring.gd` | 200 | `damage`, `control`, `knockdowns`, `volume`, `zones`, `ten_point_must`, `ten_eight_damage_bar`, `margin_wide`, `even_round`, style grappling terms |
| `ScorecardRead.gd` | 157 | `cards`, `decision`/`decision_type`/`decision_label`, `unanimous`/`split`/`majority` (+ draw variants), `score_a`/`b`, `total_a`/`b`, `knockdowns_a`/`b`, `disagreement_rounds`, `swing_round`, `winner_side` |

### Label flips vs first J36 pass

| Prior label (first pass) | After support pack | Why |
| --- | --- | --- |
| Causation Card UI **NOT EVIDENCED** | **COMPUTED data plane exists** (`PostFightRead`); **player-facing card still NOT EVIDENCED** | Module already aggregates method, cards, KD, control, TD, sub, clinches, totals |
| `may_ask` window UI retention **NOT EVIDENCED** | **COMPUTED** fields on `FightStoppageRead` (`unanswered`, `shocks_in_window`, `knockdowns_in_window`, `head_condition`, `severity`) | Keys exist; still **NOT EVIDENCED** that any UI prints them, or that they end fights (K64 consumer gap stands) |
| Split/majority **NOT EVIDENCED** as reachable | **COMPUTED** on `ScorecardRead` (`split`, `majority`, `*_draw`) | R84 “decorative when grappling terms zero” was a measurement moment; keys for non-unanimous decisions exist |
| Discrete damage bins **PROBABLY / NOT EVIDENCED** | **COMPUTED** as `damage` (+ `ten_eight_damage_bar`) on `RoundScoring`; zone hits on `RealtimeRoundStats` | Still not proven as player-facing “bins,” but damage is a named scored quantity |
| Doctor / cut path thin | **COMPUTED** trauma: `FightTrauma` `cut`/`swelling`/`site`/`pips` | Supports doctor-stoppage narration beyond bare `head_neck` |
| Per-round cards series **NOT EVIDENCED** | **COMPUTED** via `ScorecardRead.cards` / `rounds` + `PostFightRead.cards` | Series retention for comeback bullets is available in the read layer |

### Loud NOT EVIDENCED that **still stand**

1. **Player-facing Causation Card** (or any UI that prints `PostFightRead` / stoppage window to the player).  
2. **Standing accumulation TKO consumer** that can *end* a fight from `FightStoppageRead` (K64).  
3. **Corner / towel** stoppage path.  
4. **Leg-damage → finish** as a method/chain.  
5. **Pre-fight favourite strip**.  
6. **Mid-fight danger telegraph** wired to live thresholds for the player.  
7. Proof **`PostFightRead` is shown** after every bout (existence ≠ surfacing).

### Revised judgement (shortest path)

K70’s claim (“if the engine already knows why, honesty is reporting”) is **stronger** after this pack: the reporting *objects* already exist (`PostFightRead`, `ScorecardRead`, `FightStoppageRead`, `RealtimeRoundStats`, `FightTrauma`).

**Cheapest unlock:** surface **`PostFightRead` + `ScorecardRead`** (already hold method, cards, KD, control, TD, sub, clinches, totals) plus one line from **`FightStoppageRead.unanswered` / `shocks_in_window` / `head_condition`** when severity is high. That is fewer new fields than the first-pass “retain seven things” list — most retentions were already named keys.

**Still not free:** wiring stoppage READ → ending; corner stoppage; leg-finish chain; pre-fight strip; player danger HUD.

### K70 check against inventory

| K70 named internal | Present as key(s)? |
| --- | --- |
| Landed strikes by region | **YES** — `RealtimeRoundStats` head/body/legs (+ hand/foot splits) |
| KD / rock flags | **YES** — `knockdowns_*`; shocks on `FightStoppageRead`; (rock as player word ≈ shocked/severity) |
| Grappling control | **YES** — `control` / `control_score` / `control_owner` / `control_units` |
| Damage bins | **PARTIAL** — `damage`, zone hits, trauma pips; not a separate “bin” type |


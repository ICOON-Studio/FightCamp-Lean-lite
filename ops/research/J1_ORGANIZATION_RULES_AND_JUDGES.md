# J1 — Organization Rules and Judges

**Desk:** John (research)  
**Date:** 2026-09-06  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design.  
**Local snapshot used:** `real_organizations.json` (`snapshot_date` 2026-09-01), `competition_rulesets_v2.json` (30 researched, `note`: PROPOSAL — not runtime-wired), `combat_rulesets.json` v2 (11 playable `scoring_profile`s), `RoundScoring.gd`, `technique_legality_matrix.json` v2 (PROPOSAL), `weight_classes.json` v2.  
**Engine fact (from assignment, not re-read in this workspace):** `FightSimulation.gd` appends **one** scorecard per round (~:2570) and the decision path sums that single card (~:2682–2694). UI already has UD/SD/MD words; the engine cannot produce splits. Scoring is by **discipline**, not by organization.

**UNKNOWN policy:** if a primary PDF / commission regulation / official athlete-guide page does not state a fact, the cell is **UNKNOWN**. Inherited ABC/IMMAF defaults are labelled **INHERITED**, not claimed as that promotion’s published rule.

---

## Decisions page (operator calls)

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| D1 | Bind scoring/legality to **organization + ruleset**, not discipline alone | Add `default_ruleset_id` + per-discipline `ruleset_ids` on each org; event/country may override. Do not score UFC, ONE, RIZIN, and PFL with the same `mma` `scoring_profile`. | Same `discipline: mma` today; those four disagree on round-vs-whole-bout, grounded-head kicks/knees, 12-to-6 elbows, and 10-8 bars. |
| D2 | Replace the omniscient single card with **N judges → array-of-cards** | Default N=3 (ABC/ONE/UFC family). GLORY may set N=5. Decision type is a function of the three (or five) totals. Keep `RoundScoring.card()` as the per-judge primitive. | UI already speaks UD/SD/MD; `FightSimulation.gd` ~:2570 emits one card, so splits are impossible until the sim stores an array. |
| D3 | Do **not** fork `RoundScoring.gd` into per-org judges | Keep it pure/stateless (`profile_for`, `round_points`, `card`, `throw_class`, `position_points`, `gap_win`, `uses_initiative`, `style`). Wrap with a `JudgePanel` that (a) copies the profile, (b) applies criteria-priority gates, (c) applies per-judge noise, (d) optionally injects `fight_state.range_owner` as tertiary area-control. | The module is the right primitive; disagreement and org criteria are a **post-profile** transform, not a second scoring engine. |
| D4 | MVP order | **P0** ABC 3-judge 10-point-must + 2025 damage 10-8 bar (UFC, PFL, Jungle Fight, LUX, ARES, URCC inherit). **P1** ONE whole-bout MMA. **P2** RIZIN whole-bout + grounded soccer-kick/stomp/knee legality. **P3** GLORY 3-or-5 judges, open scoring, Sudden Victory. **P4** RWS open scoring + stadium criteria. **P5** non-round federations (IBJJF / IJF / UWW / WT / Karate Combat-not-WKF). | Most playable volume is Unified MMA; uniqueness is the later layers. Do not ship federation PSS/ippon/advantages before splits exist. |
| D5 | UNKNOWN defaults | Regional **pro MMA** with no published PDF inherit `mma_abc_professional` (labelled INHERITED). **CMMAF** amateur inherit `mma_immaf_amateur`. Never invent a 10-8 bar, a judge name, or ROAD FC “Unlimited Points” as live without a primary PDF. | Honest inheritance beats fake specificity; Jungle/LUX/ARES/URCC/ROAD/CMMAF do not publish a current scoring PDF comparable to ABC/ONE/GLORY. |
| D6 | `range_owner` (R35–R37) | Do **not** respec `FightRange.gd`. Feed `fight_state.range_owner` only as ABC Plan C / ONE “cage/ring generalship” / GLORY criterion 4 / RWS “forward pressure”, and **only after** Plan A (damage/effective striking-grappling) is even. Add `weights.aggressiveness` and `weights.area_control` to `scoring_profile` (both 0.0 on current MMA profile). | Researched prose already names those criteria; the live MMA profile has `damage, volume, knockdowns, control, takedowns, positions, submissions` and **no** aggressiveness/area-control keys (`combat_rulesets.json` `mma.scoring_profile.weights`). |

---

## File-level anchors (what is live vs proposal)

| File | Role | Live? | Gap this doc cares about |
|------|------|-------|--------------------------|
| `real_organizations.json` | 18 org identities, HQ, disciplines, tier/reputation (gameplay), `official_url`, `brand_assets_policy`: text names only | catalog identity | **No** `ruleset_id`, commission, rounds, scoring, weights, fouls |
| `competition_rulesets_v2.json` | 30 researched rulesets, prose scoring, `source_ids`, DIRECT evidence | **PROPOSAL** — not runtime-wired | No org binding; no machine `scoring_profile`; no judge-panel schema |
| `combat_rulesets.json` | 11 playable disciplines, machine `scoring_profile`, round clocks | **LIVE** exhibition presets | Note on file: “Promotions may override round structure and judging later.” Override does not exist. |
| `RoundScoring.gd` | Stateless mapper: counters → points → `{a,b}` card | **LIVE** | `card()` maps inequality to 10-9 or 10-8 by `margin_wide` (default 6.0). **Equal points → 10-10** (both sides stay 10). **No 10-7. No N judges. No criteria priority gate.** |
| `technique_legality_matrix.json` | 546 entries, 26 DIRECT; keys by **researched ruleset id**, not org | **PROPOSAL** | No org-level legality (RIZIN soccer kicks, ONE grounded knees, Karate Combat pit-wall, PFL elbows-now-legal) |
| `weight_classes.json` | Families `boxing` / `mma` / `kg`. MMA table is UFC-shaped (Straw 52.2 … HW 120.2). Kickboxing and Muay Thai **reuse MMA table**. Allowance MMA 0.45 kg | **LIVE** | Missing ABC Super Lightweight/Welter/Middle/Cruiser; ONE 10-lb-wide classes; GLORY kg classes; IBJJF rooster…ultra; IJF/UWW/WT kg ladders |

**Playable `scoring_profile.style` today** (`combat_rulesets.json`):

| Discipline id | style | gap_win | initiative | Notes |
|---------------|-------|---------|------------|-------|
| `mma` | `ten_point_must` | — | — | weights: damage 1.0, volume 0.15, knockdowns 8.0, control 0.9, takedowns 3.0, positions 1.0, submissions 1.5. **No aggressiveness. No area_control.** `margin_wide` 6.0 |
| `boxing` | `ten_point_must` | — | — | knockdowns weight **0.0** (gap vs ABC knockdown=10-8 convention) |
| `kickboxing` | `ten_point_must` | — | — | legs zone 0.5 |
| `muay_thai` | `ten_point_must` | — | — | 5×180s / 120s rest — WMC-shaped, not RWS 3×3 |
| `judo` | `ippon` | — | — | `ippon_threshold` 22, `ippon_by_points` 2.0; **no yuko band** (IJF reinstated yuko 2026) |
| `freestyle_wrestling` | `points` | 10 | false | UWW FS tech-sup is 10 |
| `greco_roman` | `points` | 8 | false | UWW GR tech-sup is 8 |
| `karate` | `points` | 8 | **true** (SENSHU) | WKF-shaped; **not** Karate Combat 10-point-must in a pit |
| `bjj` | `points` | 0 | false | IBJJF 2/2/3/4 table approximated; **no advantages, no penalties** |
| `sambo` | `points` | 8 | false | Combat Sambo-shaped 4/2/1 |
| `taekwondo` | `points` | 20 | false | PSS zones; turning-kick **not** doubled (WT: trunk turn 4, head turn 6) |

---

## 0. Org ↔ researched-ruleset ↔ playable-discipline map

| org id | entity | live disciplines | Closest researched id(s) | Playable combat id | Binding quality |
|--------|--------|------------------|--------------------------|--------------------|-----------------|
| `ufc` | promotion | mma | `mma_abc_professional` | `mma` | **DIRECT** (UFC publishes Unified Rules page; US events under state commissions using ABC) |
| `pfl` | promotion | mma | `mma_abc_professional` | `mma` | **DIRECT** bout scoring (Unified); **separate** tournament/season layer |
| `one_championship` | promotion | mma, muay_thai, kickboxing, bjj | **none of the 30** (ONE Global Ruleset is not ABC/WAKO/WMC/IBJJF) | `mma` / `muay_thai` / `kickboxing` / `bjj` | **MISSING ruleset ids** — must author `mma_one_global`, `muay_thai_one_global`, `kickboxing_one_global`, `grappling_one_global` |
| `rizin` | promotion | mma, kickboxing | **none of the 30** | `mma` / `kickboxing` | **MISSING** — author `mma_rizin`, `kickboxing_rizin` |
| `glory` | promotion | kickboxing | `kickboxing_wako_k1` is closest amateur analogue, **not** GLORY | `kickboxing` | **MISSING** — author `kickboxing_glory` |
| `karate_combat` | promotion | karate | `karate_wkf_kumite` is the **wrong family** (controlled points vs full-contact pit) | `karate` (WKF-shaped — **wrong**) | **MISSING** — author `karate_combat_pit`; do not reuse WKF profile |
| `cyprus_mmaf` | federation | mma | `mma_immaf_amateur` | `mma` | **INHERITED** IMMAF (CMMAF is an IMMAF member). Pro cards in Cyprus: **UNKNOWN** |
| `jungle_fight` | promotion | mma | `mma_abc_professional` | `mma` | **INHERITED** via CABMMA Unified Rules adoption. Jungle Fight has no public scoring PDF |
| `ibjjf` | tournament_operator | bjj | `bjj_ibjjf_gi`, `bjj_ibjjf_nogi` | `bjj` | **DIRECT** |
| `rajadamnern_world_series` | promotion | muay_thai | `muay_thai_wmc_professional` is closest **pro 5×3** analogue; RWS itself is often 3×3 open-scoring | `muay_thai` | **PARTIAL** — author `muay_thai_rws` (3×3 open) + keep WMC for traditional stadium nights |
| `lux_fight_league` | promotion | mma | `mma_abc_professional` | `mma` | **INHERITED** (secondary: “Reglas Unificadas”; no LUX PDF) |
| `road_fc` | promotion | mma | `mma_abc_professional` **plus** a documented-but-unverified “Unlimited Points” overlay | `mma` | **CONFLICTING / UNKNOWN** current scoring system — see org 1.12 |
| `kunlun_fight` | promotion | kickboxing | `kickboxing_wako_k1` analogue | `kickboxing` | **INHERITED-K1-LIKE** from secondary; no 2026 primary PDF found |
| `united_world_wrestling` | federation | wrestling | `wrestling_uww_freestyle`, `wrestling_uww_greco_roman` | `freestyle_wrestling` / `greco_roman` | **DIRECT** |
| `ijf` | federation | judo | `judo_ijf` | `judo` | **DIRECT** (yuko reinstated 2026 — playable profile lags) |
| `world_taekwondo` | federation | taekwondo | `taekwondo_wt` | `taekwondo` | **DIRECT** (turning-kick doubles lag) |
| `ares_fighting_championship` | promotion | mma | `mma_abc_professional` | `mma` | **INHERITED** via FMMAF / FFBoxe Unified-Rules frame. No ARES PDF |
| `urcc` | promotion | mma | `mma_abc_professional` | `mma` | **PARTIAL / CONFLICTING** round lengths (Wikipedia 3×3 min vs ABC 5 min). No URCC PDF retrieved |

**30 researched ids with no org in this catalog (keep as exhibition / national-federation content, do not delete):**  
`mma_abc_amateur_novice`, `mma_abc_amateur_advanced`, `boxing_abc_professional_male`, `boxing_abc_professional_female`, `boxing_worldboxing_amateur`, `kickboxing_wako_full_contact`, `kickboxing_wako_low_kick`, `kickboxing_wako_k1`, `kickboxing_wako_point_fighting`, `kickboxing_wako_kick_light`, `muay_thai_ifma_combat`, `muay_thai_ifma_technical`, `savate_fisav_assaut`, `savate_ffsbfda_combat`, `karate_wkf_kumite` (keep — it is **not** Karate Combat), `sambo_fias_sport`, `sambo_fias_combat`, `capoeira_wcf`, `arnis_wekaf`, `pencak_silat_persilat_tanding`, `sanda_iwuf`.

---

# Section 1 — Organizations

Commission rule of thumb (all 18): **the athletic commission / national federation of the event country can override the promotion’s house rules.** ABC text itself: “Any other form of these rules may not be called the Unified Rules of MMA and shall be referred to by the name of the commission sanctioning the/an event.” ([ABC Unified Rules of MMA, Aug 2026 PDF](https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf), verified 2026-09-06.)

---

## 1.1 `ufc` — Ultimate Fighting Championship

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ USA, disciplines `{mma:100}`, tier S, `official_url` https://www.ufc.com/ | `real_organizations.json` |
| Governing ruleset | **Association of Boxing Commissions Unified Rules of MMA** as adopted by the **event-state athletic commission** (NSAC, CSAC, NJSACB, Texas, etc.). UFC does not self-sanction US cards. | UFC “Unified Rules of Mixed Martial Arts” page; ABC Unified Rules PDF 8.2026 |
| Event/country override | Yes. Non-US cards use the host regulator. **UNKNOWN** whether every overseas UFC card uses the current ABC 2025 scoring clarification verbatim. | UFC position statement on that page |
| Researched id | `mma_abc_professional` | `competition_rulesets_v2.json` |
| Playable id | `mma` | `combat_rulesets.json` |

### Rounds

| Bout | Rounds × minutes | Rest | Source |
|------|------------------|------|--------|
| Non-championship (typical) | 3 × 5:00 | 1:00 | ABC Unified Rules: rounds 1–5 of 5:00, rest 1:00, max 5 rounds / 25 minutes |
| Championship / some main events | 5 × 5:00 | 1:00 | same; UFC practice. **UFC bout-contract length is a promotion choice inside the ABC max.** |
| Game today | 3 × 300s / 60s rest | — | `combat_rulesets.json` `mma` — championship 5×5 is **not** an org override |

### Scoring (full)

| Item | ABC / UFC | Game today |
|------|-----------|------------|
| Judge count | **Minimum 3.** Referee is **not** a judge. | 1 omniscient card |
| System | 10-Point Must, **round-by-round** | `ten_point_must` via `RoundScoring.card()` |
| Criteria **priority** | **2025 clarification (in force as ABC scoring criteria):** (1) **DAMAGE** — legal techniques that lessen capacity/will to compete (knockdowns, concussive strikes, visual injury, hyperextending grappling, chokes causing distress). Immediate damage > cumulative inside a round. (2) **DOMINANCE** — supremacy of positioning/action/volume **intended to result in damage**. Mere positional hold is **not** dominance. (3) **DURATION** — time spent imposing (1)+(2). Successful striking and successful grappling are **equal**, both measured as **result**. If those are even: **aggressiveness** (consistent offensive effort) **or** **fighting-area control** (pace/place/position), whichever impacted the round more. **Defense is not scored.** | MMA weights: damage, volume, knockdowns, control, takedowns, positions, submissions. **No aggressiveness. No area_control. No priority gate.** |
| 10-10 | “Generally reserved for partial rounds. Scoring completed rounds 10-10 is seen as a failure to adjudicate a score.” | `RoundScoring.card()`: if `points_a == points_b` → **10-10**. So the live engine **does** emit completed-round 10-10s, which ABC now treats as a judging failure. |
| 10-9 | Offensive actions greater in degree/effectiveness. Aggressiveness/area-control **only** if no offensive advantage can be discerned. | Any `points` inequality below `margin_wide` (6.0) |
| 10-8 | Must include **significant damage** that by its nature could finish the fight. Cumulative damage (lost energy/confidence/stamina/spirit) can qualify. Significant domination **plus some damage** and little/no offense from the loser may qualify. **Positional control without damage is not a 10-8.** | `margin_wide` 6.0 on a blended float — **not** a damage gate |
| 10-7 | Overwhelming in **both** damage **and** domination throughout the round | **Not implemented** |
| Draw types | Unanimous / majority / split **draw**; technical draw (intentional-foul injury path after ½ scheduled rounds if injured fighter is even or behind) | Decision path sums one card — **no split/majority types** |
| Technical decision | Incomplete rounds **must be scored** if majority of rounds completed | UNKNOWN in sim |
| Point deductions | Referee assesses fouls; **scorekeeper** (not judges) deducts | UNKNOWN in sim |

**Sources (verified 2026-09-06):**  
- ABC, *Unified Rules of MMA* (amended 2026-08-05, requested implementation Nov 2027 for 2026 language; prior 2024 grounded-fighter / 12-to-6 changes already in): https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf  
- ABC, *MMA Scoring Criteria Clarification* (2025-07, posted 2025-08): https://www.abcboxing.com/wp-content/uploads/2025/08/ABC-MMA-Scoring-Criteira-Clarification-7.2025.pdf  
- ABC Unified Rules index: https://www.abcboxing.com/unified-rules/  
- UFC, *Unified Rules of Mixed Martial Arts*: https://www.ufc.com/unified-rules-mixed-martial-arts  
- UFC media PDF (older judging language — **do not treat as current 10-8 bar**): https://media.ufc.tv/discover-ufc/Unified_Rules_MMA.pdf  

### Fouls / legality vs game

ABC/UFC fouls (UFC page list, verified 2026-09-06): head-butt, eye gouge, bite/spit, fish-hook, hair pull, spike on head/neck, spine/back-of-head, throat/trachea, outstretched fingers to eyes, **downward 12-to-6 elbow** (UFC page still lists it; **ABC July 2024 amendment legalized 12-to-6**, effective ~Nov 2024 — **CONFLICTING between UFC.com foul list and current ABC PDF**), groin, **knee/kick to head of grounded opponent**, **stomp a grounded opponent**, holding gloves/shorts, fence grab, small-joint, throw out of area, finger in orifice/cut, claw/pinch/twist flesh, timidity, abusive language, ignoring referee, unsportsmanlike injury, attack after bell / on break / under referee’s care, corner interference.

**Grounded (ABC 2024+):** any body part **other than hands or feet** touching canvas. (Hands-only is **not** grounded.) Soccer kicks / knees to the head of a grounded opponent remain fouls.

**Game legality matrix:** keyed to `mma_abc_professional`, not to `ufc`. DIRECT illegal rows are amateur (Novice / IMMAF grounded-head GNP), **not** UFC. **No org-level legality row for 12-to-6.**

### Weight classes vs `weight_classes.json`

ABC Unified classes (PDF 8.2026): Atom ≤105, Straw 105–115, Fly 115–125, Bantam 125–135, Feather 135–145, Light 145–155, **Super Light 155–165**, Welter 165–170, **Super Welter 170–175**, Middle 175–185, **Super Middle 185–195**, LHW 195–205, **Cruiser 205–225**, HW 225–265, Super HW >265 (lb).

**UFC uses a subset:** W Straw 115; Fly 125 M/W; Bantam 135 M/W; Feather 145 M (W Feather dormant since ~2023); Light 155; Welter 170; Middle 185; LHW 205; HW 265. **Does not use** Super Light / Super Welter / Super Middle / Cruiser / Super HW / Atom as UFC titles.

Game `tables.mma`: Atom 47.6, Straw 52.2, Fly 56.7, Bantam 61.2, Feather 65.8, Light 70.3, Welter 77.1, Middle 83.9, LHW 93.0, HW 120.2, Super HW 0. **Matches UFC-shaped names, includes Atom + Super HW that UFC does not currently title, omits ABC Super Light/Welter/Middle/Cruiser.** Ladder `move.ladder` is Fly→HW eight names — no Straw/Atom.

Allowance: game MMA `0.45 kg` (~1 lb) — matches the common non-title 1-lb allowance custom; ABC text says no in-division allowance restriction if both make the contracted class.

### Fan-visible quirks

- Octagon, not ring.  
- Closed scoring (cards collected per round, announced at the end).  
- USADA/UFC Anti-Doping is **stricter than** ABC’s prohibited-substance floor (UFC page).  
- Championship 5×5 vs game 3×5.

### UNKNOWN

- Exact NSAC vs CSAC vs NJSACB adoption date of the **2025 scoring clarification** on a given 2026 UFC card.  
- Whether UFC.com’s still-listed **12-to-6 foul** is a stale page or a UFC house overlay. Treat ABC 2024 legalization as the Unified Rule; treat UFC.com as **CONFLICTING** until UFC updates the foul list.  
- Judge **names** for any card: do not invent.

---

## 1.2 `pfl` — Professional Fighters League

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ USA, `{mma:100}`, S/94, https://pflmma.com/ | `real_organizations.json` |
| Bout ruleset | Unified Rules of MMA (event commission). **Elbows legal in all PFL fights from 2025** (previously banned in season/playoff bouts to reduce cuts). | PFL chairman announcement 2025-01-06; ABC Unified |
| Season/tournament layer | **2025 World Tournament:** 8-fighter single-elim per division, **not** the 2018–2024 regular-season **points** table. Prize $500,000 (was $1,000,000). | PFL 2025 World Tournament Official Rules PDF, effective 2025-03-01 |
| Researched id | `mma_abc_professional` for the **bout**; **no** researched id for season points | — |
| Playable | `mma` | no season-points machine |

### 2025 tournament format (bout-adjacent, not round scoring)

From [PFL 2025 World Tournament Rules PDF](https://pflmma-prod.s3.us-east-1.amazonaws.com/assets/rules/2025_PFL_World_Tournament_Rules_and_Regulations_as_of_3_1_2025.pdf) (verified 2026-09-06):

- 10 events: 4 first-round, 3 semifinal, 3 finals (PFL may change).  
- 8 weight divisions, 8-fighter bracket each. Single elimination.  
- First round + semis: **3 × 5:00**, rest 1:00. Winner progresses.  
- Championships: **UNKNOWN in the excerpt retrieved whether 5×5** — typical PFL practice was 5×5 finals; **confirm in full PDF before wiring.** Mark **UNKNOWN** if not in the pages pulled. (ESPN 2025 FAQ: tournament, not points.)

**Historical season points (2018–2024, retired for 2025 World Tournament — keep as a data module for a “classic PFL” ruleset, do not treat as current default):**

| Result | Points |
|--------|--------|
| Win | 3 |
| Draw | 1 |
| Loss | 0 |
| R1 finish bonus | +3 (total 6, “Quick Six”) |
| R2 finish | +2 (total 5) |
| R3 finish | +1 (total 4) |
| Miss weight | −1 (and historically could not earn bout points — **confirm per year**) |

Sources: MMA Junkie 2025-01-09 (format change); ESPN PFL FAQ 2025; 2024 UNEXT_fight season explainer (Japanese rights holder) for the **old** table. **Do not mix 2024 points with 2025 brackets.**

### Scoring of a bout

Same as §1.1 ABC 10-point-must, 3 judges, round-by-round, 2025 damage 10-8 bar — **INHERITED**, not a PFL-authored criteria PDF. Cage: PFL “SmartCage” (10-sided) — fan-visible, not a scoring rule.

### Fouls / legality

- 2025+: elbows legal (all fights). Aligns with ABC (12-to-6 legal 2024+).  
- Pre-2025 PFL elbow ban is **historical only**.  
- Grounded-head kicks/knees: Unified (illegal).

### Weights vs game

2025 tournament divisions in the PDF: Bantam 135, W Fly 125, Feather 145, Light 155, Welter 170, Middle 185, plus Light Heavy / Heavy in the “8 divisions / 7 men’s + 1 women’s” statement. **Exact 8-list in the pages pulled:** Bantam, W Fly, Feather, Light, Welter, Middle — LHW and HW named in Sporting News 2025 wrap. Game MMA table covers these names; PFL does not use Straw/Atom as 2025 tournament titles (**UNKNOWN** whether they exist as non-tournament PFL cards).

### Fan-visible quirks

- Tournament bracket, not rankings.  
- SmartCage.  
- Elbows were the long-running house overlay; gone as of 2025.

### UNKNOWN

- 2026 season/tournament format (research date is 2026-09-06; 2025 PDF is the latest primary retrieved). **Do not assume 2025 brackets persist.**  
- Championship round count in the 2025 PDF (confirm 5×5).  
- Whether PFL Europe / MENA / Africa / Pacific use the same tournament PDF.

---

## 1.3 `one_championship` — ONE Championship

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ **Singapore** (not Thailand — catalog HQ is Singapore; market_assignments also list Thailand/China/Philippines) | `real_organizations.json` |
| Ruleset | **ONE Global Rules** — MMA, Muay Thai, Kickboxing, Submission Grappling. **Not** ABC Unified for MMA judging. | Official martial-arts page |
| Commission | Host-country regulator. Colorado Combative Sports Commission has approved the Global MMA ruleset for US ONE cards (knees to grounded head legal). | Combat Sports Law 2021-07-27 (Colorado-approved text) |
| Researched id | **NONE of the 30** | must author new ids |
| Playable | four disciplines, all **wrong judging** for ONE MMA (round 10-point-must vs whole-bout) | |

### Official scoring (ONE site, verified 2026-09-06)

Source: https://www.onefc.com/martial-arts/

#### MMA — Global Mixed Martial Arts Rule Set

| Item | Rule |
|------|------|
| Gloves | 4 oz MMA |
| Non-title | 3 × 5:00, rest 1:00 |
| World Championship | 5 × 5:00, rest 1:00 |
| Wins | KO, TKO (ref/doctor/corner), submission, technical submission, judges’ decision, technical decision, verbal request, DQ |
| **Judges** | **3.** Score the bout **in its entirety, not round-by-round.** |
| Criteria **descending** | (1) Near-knockout / near-submission (2) Damage — internal, accumulated, superficial (3) Striking combinations **and** cage/ring generalship (ground control and superior positioning) (4) Earned takedowns **or** takedown defense (5) Aggression |
| 10-point-must? | **No** for MMA. |
| 10-8 / 10-10 | **N/A** (no per-round card). |
| Draws | Official page does not define a draw as a must-winner. Colorado 2021 text: no-contest windows; technical decision after 2:30 of R2 (3-round) or after bell ending R3 (5-round). **Draw types: UNKNOWN on the current ONE page.** |

**Legality vs Unified (Colorado-approved Global Ruleset, 2021 text — still the public full text; confirm against any later ONE PDF before locking):**

| Technique | Unified / UFC | ONE Global MMA |
|-----------|---------------|-----------------|
| 12-to-6 elbow | Legal 2024+ (was illegal) | Legal |
| Knee to grounded head | Illegal | **Legal** |
| Stomp body/legs of grounded | Stomp grounded = foul in Unified | Body/leg stomps **legal**; **head stomps illegal** |
| Soccer kick to grounded head | Illegal | **Illegal** (banned ~2016) |
| Grounded definition (2021 Colorado text) | ABC 2024: not hands/feet | 2021 ONE text: any weight-bearing part other than soles — **hands count as grounded**. **CONFLICTING with ABC 2024.** Event-commission override possible on US cards. |

#### Muay Thai — Global Muay Thai Rule Set

| Item | Rule |
|------|------|
| Gloves | **4 oz MMA gloves** (not 8–10 oz boxing) |
| Non-title | 3 × 3:00 |
| Championship | 5 × 3:00 |
| TKO extra | 3 knockdowns in a round / 4 in a bout |
| Judges | 3, **round-by-round 10-Point Must**, majority decision |
| Tie on points | Then apply ONE judging criteria: knockdowns → damage → number of clean strikes → aggression and cage/ring generalship |

#### Kickboxing — Global Kickboxing Rule Set

Same round structure as ONE Muay Thai. Gloves: **8 oz at bantam or lighter, 10 oz at feather or heavier.** 10-Point Must round-by-round; same four-criterion tiebreak. **No elbows** (implied by “punch, kick, or knee” win list).

#### Submission Grappling

Single **10:00** round including titles. Decision: **number of catches** (legitimate submission attempts). Tie: more aggression. Yellow card for stalling **negates one catch**. Guard-pull must be offensive.

### Weights vs game

ONE table (official page): 10 classes, **10 lb wide** (not UFC’s 10/15/20 pattern): Atom 105–115, Straw 115–125, Fly 125–135, Bantam 135–145, Feather 145–155, Light 155–170, Welter 170–185, Middle 185–205, LHW 205–225, HW 225–265 (lb).

Game MMA table is **UFC-shaped**, not ONE-shaped (e.g. game Lightweight 70.3 kg / 155 lb vs ONE Lightweight **155–170**). **Do not reuse `tables.mma` for ONE cards.**

**Hydration:** urine specific gravity ≤ 1.025, combined hydration + weigh-in 24–48 h out. Catchweight if both within 105% of each other’s hydrated weight. Game `allowance_kg.mma` 0.45 kg does **not** model this.

### Fan-visible quirks

- Whole-bout MMA judging (a fighter can “steal” the fight with a late near-finish).  
- 4 oz gloves in Muay Thai.  
- No dehydration cut.  
- Soccer kicks banned; grounded **knees** famous.

### UNKNOWN

- Current (2026) grounded definition on non-US cards.  
- Whether ONE MMA judges still secretly keep round notes (practice) — **not in the published criteria**. Do not invent.  
- IBJJF vs ONE grappling: ONE is **catches**, not IBJJF points — do not reuse `bjj` profile for ONE grappling.

---

## 1.4 `rizin` — RIZIN Fighting Federation

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ Japan, `{mma:72, kickboxing:28}`, ring (not cage) | `real_organizations.json`; official about |
| Ruleset | **RIZIN house MMA + kickboxing**, officiated by **JMOC** (Japan MMA Officials Committee) — independent of the promotion | https://jp.rizinff.com/rule (verified 2026-09-06); JMOC link on that page |
| Commission | Japanese event regulation + JMOC. **Not ABC.** | official |
| Researched id | **NONE** | author `mma_rizin`, `kickboxing_rizin` |
| Playable | `mma` / `kickboxing` — **wrong** (Unified 10-point-must, no soccer kicks) | |

### MMA — official page (verbatim structure)

Source: https://jp.rizinff.com/rule verified 2026-09-06.

| Item | Official text (translated, structure preserved) |
|------|--------------------------------------------------|
| Arena | Square **ring** (so MMA and kickboxing share a card) |
| Rounds | One-match official: **10:00 + 5:00 (2 rounds)** **or** **3 × 5:00**. Else special rules. **Women: 3 × 5:00.** |
| Rest | **UNKNOWN on this page** (older RIZIN copy used 60s; do not invent if not on the current page). Wikipedia/JMOC secondary: 60s. Mark rest **INFERRED 60s / UNKNOWN on official page**. |
| Decision | If no KO/TKO/tap/ref stop: **judges**. Criteria in **priority order**, evaluating the **entire bout**. |
| Criteria 1 **Damage** | Striking and grappling **equal weight**. Effect = influence toward ending the match (KO/tap). |
| Criteria 2 **Aggressiveness** | Who was more active in attacks **aimed at finishing**. Does **not** score the damage of those attacks (that is criterion 1). |
| Criteria 3 **Generalship** | Pace, place, position. Consider time share standing vs ground. |
| Grounded-head attacks | **Legal:** soccer-ball kicks, stomps, knees to the head on the ground. **Exception:** if weight difference ≥ **15 kg**, the **lighter** fighter chooses whether grounded **knees to the head** are allowed. |
| Elbows | Legal **in all phases**, **no 12-to-6 restriction**. (Page notes this as a RIZIN house rule since 2015 vs Unified.) |
| Fouls (non-exhaustive on page) | Head-butt, groin, bite, strikes to back of head / medulla / spine |

**Judge count:** **not stated** on the current official rules page. Secondary: 3 judges, JMOC. Amateur 2017 PDF on the same site used 3 judges and a **round 10-point must with no 10-10** — that is **amateur 2017**, **not** current pro whole-bout. **Judge count = UNKNOWN on current official page, INFERRED 3 via JMOC.**

**10-point-must?** Official MMA page: **no**. Whole-bout priority list. Secondary (Wikiwand): JMOC scorecards **suggest** damage/aggressiveness/generalship weighted 50/30/20. **That 50/30/20 split is NOT on the official rules page — treat as UNKNOWN/INFERRED, do not ship as a fact.**

**Draws:** official MMA page does not say “must winner.” Older 2016 RIZIN.1 copy said must-decision, no draw. **Current draw policy: UNKNOWN on the 2026 page.**

### Kickboxing — official page

| Item | Rule |
|------|------|
| Rounds | 3 × 3:00, **three-knockdown rule** (3 downs in one round ends it) |
| Decision | 10-point method after 3 rounds if no KO/TKO. Down = −2; being clearly outworked = −1. Higher total wins. |
| Legal | Striking only. One catch + one attack. **No elbows.** |

### Weights vs game

**UNKNOWN on official rules page.** Catalog does not list classes. Do not invent RIZIN divisions. Game MMA table is a stand-in only, labelled INHERITED-UFC-SHAPE.

### Fan-visible quirks

- Ring MMA.  
- Soccer kicks / stomps / grounded knees.  
- Optional 10+5 first-round format (Pride-shaped).  
- JMOC independence (anti-hometown-decision pitch).

### UNKNOWN

- Current men’s default (10+5 vs 3×5) per card type (title vs non-title). Page allows both.  
- Judge count, draw policy, rest time, weight classes, 50/30/20 weights.

---

## 1.5 `glory` — GLORY Kickboxing

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ Netherlands, `{kickboxing:100}` | `real_organizations.json` |
| Ruleset | **GLORY Kickboxing Official Rules v2.2** (PDF hosted on GLORY rules CDN). Regulator of the event country may **supersede**. | https://glory.pinkyellow.network/assets/rules/glory-rules-2026-v2.pdf verified 2026-09-06 |
| Closest researched | `kickboxing_wako_k1` (amateur WAKO K-1) — **not** a substitute | |
| Playable | `kickboxing` 3×180s, 3 judges implied by one card | GLORY default **5 judges**, open scoring, extra round |

### Rounds (GLORY Rules §5.04 / §5.06)

| Match | Structure |
|-------|-----------|
| Single match | 3 × 3:00, 1:00 interval. GLORY may approve 5 × 3:00. Extra-round interval 1:30 from first extra. |
| Tournament | 2 or 3 rounds of 2 or 3 minutes per tournament format. |
| Max in one day | 13 × 3:00 rounds |

### Scoring (full) — §5.06 + Appendix 2

| Item | GLORY 2026 v2.2 |
|------|-----------------|
| Judge count | **Five, or three if approved by GLORY.** Selected by the Regulator. |
| Open scoring | **Yes.** Scores public after each round. |
| System | 10-point must. One athlete **must** receive 10 unless a point deduction. Deductions applied **before** finalizing the round score. |
| Criteria **priority** | (1) **Knockdowns.** If A scores ≥1 knockdown, A wins the round (unless deductions). Other criteria decide 10-9 vs 10-8. (2) **Damage.** High Impact Damage (wobble/stagger/reduced function) > other damage; cumulative. (3) **Number of clean strikes.** Spectacular (flying/spinning) > normal. (4) **Aggressiveness or ring domination.** Attacks > defense. |
| 10-10 | Not even a marginal advantage. Also: both score a knockdown and no other differences (rare). Extra round: judges **may not** score equally. |
| 10-9 | Advantage on the criteria. Standard no-knockdown win. |
| 10-8 | Knockdown **or** High Intensity Damage **and** significant domination of strikes/aggressiveness. A knockdown **plus** the opponent otherwise dominating can still be 10-9 (rare). |
| 10-7 | **Two knockdowns** (unless other factors pull it to 10-8). |
| Sudden Victory | 3-round match that is a draw → **one** extra round; **only that round** decides. If still tied: judges pick a winner from the match **in its entirety**. 5-round title-eliminator: same, one extra. Tournament **final**: up to **two** extra rounds. |
| Decision types | Points decision is by **total points per judge**, not by rounds-won count — a fighter can win a judge while scoring fewer total points than the opponent on that card (**GLORY Appendix 2 example**). Majority of the 5 (or 2 of 3) must name a winner or it is a draw → Sudden Victory path. |
| No contest | <2 completed rounds (3-round match) or <3 (5-round) + accidental foul/gear defect. Accidental foul in R3 of 3 or R4/R5 of 5: scores **without** scoring the foul round. |

### Fouls (non-exhaustive, §5.07)

Elbows **illegal** (any arm/wrist above padded glove). Linear/thrusting kicks to the **leg** illegal (front/side/back kick to the leg); legs may be attacked only with **arcing** kicks. Groin. Wrestling/judo/strangles/submissions. Throws, sweeps, pushes to off-balance as a takedown. Clinch limits exist in the legal-technique section (knees in clinch with a time cap — exact seconds: see full §5.02; **do not invent if not in the excerpt** — the scoring appendix does not restate the clinch clock).

### Weights vs game

GLORY §2.01 (kg): Feather ≤65, Light 65–70, Welter 70–77, Middle 77–85, LHW 85–95, HW >95, catchweight.

Game kickboxing **reuses `tables.mma` (lb UFC-shape)**. **Wrong family.** Miss-weight: ≤1 kg → up to 20% purse to opponent; >1 kg → up to 30% (GLORY’s discretion), match only if GLORY + opponent + Regulator agree.

### Fan-visible quirks

- Open scoring.  
- 5 judges (when not reduced).  
- Sudden Victory extra round (must winner on that round).  
- No elbows.  
- Knockdown-first scoring (unlike ABC MMA).

### UNKNOWN

- Exact clinch-second cap in v2.2 (older ISKA/GLORY video: brief clinch, one knee). Read §5.02 fully before wiring legality.  
- Women’s divisions: **not in §2.01 list** — UNKNOWN.

---

## 1.6 `karate_combat` — Karate Combat

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ USA, `{karate:100}`, A/88, https://karate.com/ | `real_organizations.json` |
| Ruleset | **Official Full Contact Karate Unified Rules and Regulations** (promotion + **presiding commission**) | https://karate.com/pt/rules-and-regulations verified 2026-09-06; PDF linked from that page |
| Not | WKF kumite. Playable `karate` profile is WKF (yuko/waza-ari/ippon, SENSHU, 8-point gap). **Wrong.** | |
| Researched id | do **not** bind `karate_wkf_kumite` | author `karate_combat_pit` |

### Arena / rounds

| Item | Rule |
|------|------|
| Area | **PIT** (specially designed). Pit wall is **not** the ground. |
| Non-title | **3 × 3:00**, rest 1:00 |
| Main events / titles | **5 rounds** (page: “main events and Title/Championship fights are 5 rounds”) |
| Grounded | Commission may override. House text: grounded when any body part other than soles touches the floor. **Pit wall ≠ ground.** Fighter facing the wall with **both hands on it** is grounded and the ref starts a countdown. |
| GNP | Standing fighter may continue **legal hand strikes** (and kicks to **body/legs only**) while opponent is grounded, as long as strikes are effective with finishing intent. Second knee down / both grounded → stand them up, restart from that pit position. |
| Clinch | Must immediately execute a legal technique; continuous striking allowed if actively attacking. |

### Scoring

| Item | Official page |
|------|----------------|
| Judges | **3**, different locations around the PIT. Referee is not a judge. |
| System | **10-point must** |
| Criteria (page order) | Effective striking (impactful legal strikes), effective takedowns (legal takedown + effort to finish), control of the PIT, effective aggressiveness (moving forward **and landing**). “Karate Combat prioritizes **productive aggressiveness** so the fighter who gets results based on attacking should be favored over a fighter who counters if the results are similar.” |
| 10-8 / 10-10 / 10-7 | **UNKNOWN** on this page (no numerical bar). Archived 2021 PDF (secondary): aggressiveness → kicking techniques → striking → dominance → damage → control, and a public “10 − opponent” display. **Do not treat the 2021 archive as 2026 law** without the current PDF. |
| Extra round on draw | Polish Wikipedia (secondary) says one extra round. **UNKNOWN on the official English/PT rules page.** |

### Legal / fouls (official page, non-exhaustive)

**Standing legal:** all punches/hand strikes to legal areas; **ridge-hand**; **elbows**; kicks to front/side of head and torso above belt; **kicks to thigh and calf** (2025 evolution — older rules banned some thigh kicks); sweeps/reaps/throws except listed fouls.

**Grounded:** standing fighter: **hands only** to the opponent + kicks to **body/legs**; **no kick to grounded head**. Grounded fighter may use all legal strikes including kicks per stand-up rules.

**Fouls:** headbutts; kicking the **knee**; throat; spine/back of head; stomp/jump on grounded; kick grounded head; inactive clinch; **single and double-leg takedowns** except (1) catching a kicking leg (2) single/double during a grappling scramble; **belly-to-back suplexes**; spike on head/neck or out of pit; timidity/passivity; holding mitts; attacking on break/after bell; ignoring ref; dirty tactics; unsportsmanlike; foreign substance.

2025 video (Karate Combat / Bas Rutten, official channel): ridge-hand, hammer fist, linear + roundhouse **thigh** kicks legal; pit-wall fighter not grounded until butt on floor. Use as **promotion commentary**, not a substitute for the PDF.

### Weights vs game

Official page (lb/kg): W Straw 115/52.2, W Fly 125/56.7, W Bantam 135/61.2, W Light 150/68; M Bantam 135/61, M Light 150/68, M Welter 165/75, M Middle 185/84, M Heavy 205/93, M Super-Heavy >205/>93. Catchweight allowed. 1-lb non-title allowance **recommended** if in the bout contract.

Game karate family is `kg` with **no named KC classes**. Playable karate is WKF tatami, 1×180s, points/SENSHU — **cannot represent a KC bout**.

### Fan-visible quirks

- Pit walls as a striking surface.  
- Karate trousers + mitts (4 oz).  
- Traditional bow commands (Yoi, Otega-ni Rei).  
- GNP until ineffective, then stand-up.  
- Double-leg mostly illegal.

### UNKNOWN

- Current 10-8 numerical bar.  
- Draw / extra-round rule on the current official page.  
- Whether all 2025 video techniques are in the downloadable PDF (link is a Google Drive file — **not re-parsed here**). Mark PDF body **UNKNOWN pending parse**.

---

## 1.7 `cyprus_mmaf` — Cyprus Mixed Martial Arts Federation

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | **federation** (not a promotion), HQ Cyprus, `{mma:100}`, C/58, https://cyprusmixedmartialartsfederation.com/ | `real_organizations.json` |
| Official site (verified 2026-09-06) | Founded Limassol **2014**, recognized by **K.O.A.** (Cyprus Sports Organisation) **2016**, “under the auspices of **IMMAF**.” No rules PDF, no scoring page, no weight table. | https://cyprusmixedmartialartsfederation.com/ |
| IMMAF membership | Cyprus Mixed Martial Arts Federation (CMMAF) listed as IMMAF member | Wikipedia IMMAF members list (secondary); IMMAF is the amateur IF |

### What is known vs inherited

| Topic | Known | Inherited default (label it) |
|-------|-------|------------------------------|
| International amateur | IMMAF championships use IMMAF amateur rules | `mma_immaf_amateur` |
| National amateur | **UNKNOWN** whether CMMAF’s domestic events copy IMMAF 1:1 (IMMAF explicitly allows national federations to use their own national rules, IMMAF rules at World Championships) | Do not assume |
| Professional MMA in Cyprus | **UNKNOWN** governing PDF, commission, round length, judge count | Do **not** silently use UFC 5:00 rounds |
| Scoring | **UNKNOWN** on CMMAF site | IMMAF: 10-point must, 3 judges (researched `mma_immaf_amateur`) |
| Fouls | **UNKNOWN** nationally | IMMAF: no elbows/forearms, no heel hooks, no twister, **no knee to head standing or grounded**, no grounded-head kicks |

### IMMAF amateur (the inheritance target)

From `competition_rulesets_v2.json` `mma_immaf_amateur` (source `src_immaf_amateur`, IMMAF 2015 3×3 PDF; **a 2021/2025 IMMAF handbook exists — 2015 PDF in the catalog is stale**):

- Rounds: 3 × 3:00 non-championship, rest 1:00.  
- 10-point must, 3 judges, “time-sliding striking/grappling weight” (prose).  
- Grounded-head kick/knee **illegal for all amateurs** (no novice/advanced split).  
- Medical: Hep B/C and HIV certificates <1 year.

**IMMAF 2025 eligibility overlay (not in the 2015 PDF):** from 2025, athletes who competed in **any** MMA bout allowing elbows and/or knees to the head are ineligible for IMMAF, with a grace period. Source: https://immaf.org/athletes/athlete-eligibility/ verified 2026-09-06.

### Weights vs game

IMMAF researched list (lb): Straw <115 … Super HW >265. Game MMA table is UFC-shaped professional. **Amateur 3:00 rounds vs game 5:00 is the dangerous silent inherit.**

### UNKNOWN (do not fill)

- CMMAF domestic professional rules.  
- Judge names, 10-8 bar, Cyprus commission identity beyond K.O.A. recognition.  
- Whether CMMAF has adopted post-2015 IMMAF handbook updates.

---

## 1.8 `jungle_fight` — Jungle Fight

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ Brazil, `{mma:100}`, A/86, https://junglefc.com.br/ | `real_organizations.json` |
| Founder | Wallid Ismail (catalog + official site) | |
| Regulator | **CABMMA** (Comissão Atlética Brasileira de MMA) is the Brazilian private athletic commission that adopted ABC Unified Rules (full adoption announced 2017; 2025 CABMMA director discussed ABC scoring **clarification**, not a new foul set). | MMA Fighting 2017-07-25; Globo Combate 2025-09-03 |
| Jungle Fight own PDF | **Not found** on junglefc.com.br | **INHERITED ABC via CABMMA** |
| Playable | `mma` | |

### Known vs inherited

| Topic | Known (primary or strong secondary) | Inherited |
|-------|--------------------------------------|-----------|
| Rules family | Unified Rules / CABMMA | `mma_abc_professional` |
| Arena | Circular cage from Jungle Fight 37 (2012) — Wikipedia | cage, not ring |
| Rounds | **UNKNOWN** on official site. Brazilian Unified practice = ABC 5:00 rounds, 3 or 5. | ABC 3×5 / 5×5 |
| Scoring | **UNKNOWN** Jungle-authored. CABMMA 2025: scoring **clarification** aligned with ABC damage language | ABC 3 judges, 10-point must, 2025 10-8 damage bar |
| Miss-weight | Jungle Fight 48 (2013): 20% purse cut + point deductions scaling with miss (Wikipedia) | house overlay; **UNKNOWN** if still in force 2026 |
| 2025 Fight do Milhão | 8-man GP, men’s lightweight **70 kg**, women’s fly **57 kg**, R$500k each (Wikipedia / Globo) | tournament layer, not scoring |
| 12-to-6 / grounded | CABMMA follows ABC updates (12-to-6 legal Nov 2024 window; grounded = not hands/feet) | ABC 2024 |

### Weights vs game

Jungle Fight Wikipedia champion table uses kg: HW 120, Cruiser 102, LHW 93, Middle 84, Welter 77, etc. — **ABC/UFC-shaped plus a cruiser**. Game table has no Cruiser. Fight do Milhão 70 kg / 57 kg are **kg catch/GP classes**, not UFC names.

### UNKNOWN

- Current miss-weight point math.  
- Whether every Jungle card is CABMMA-sanctioned.  
- Judge count confirmed on a Jungle-branded document (assume 3 via Unified, label INHERITED).

---

## 1.9 `ibjjf` — International Brazilian Jiu-Jitsu Federation

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | tournament_operator, HQ **USA** (catalog; sport origin Brazil — market_assignments Brazil), `{brazilian_jiu_jitsu:100}` | `real_organizations.json` |
| Ruleset | **IBJJF Rules Book v6.1, Jun 2024** | https://ibjjf.com/rules ; PDF https://cdn.shopify.com/s/files/1/0727/9715/9746/files/2024JUN_IBJJF_Rules_EN.pdf verified 2026-09-06 |
| Researched | `bjj_ibjjf_gi`, `bjj_ibjjf_nogi` | DIRECT |
| Playable | `bjj` points, 600s, no advantages/penalties | incomplete |

### Match structure (not rounds)

Single continuous match. Adult gi durations (common table; **confirm per IBJJF event packet**): White 5:00, Blue 6:00, Purple 7:00, Brown 8:00, Black **10:00**. Masters often shorter (event-dependent; researched file flagged Masters **UNKNOWN** vs adult). No-Gi adult duration: researched `bjj_ibjjf_nogi` marked **UNKNOWN** whether same belt-tiered times.

### Scoring (full) — Rules Book v6.1 Art. 2–3

| Action | Points | Stabilization |
|--------|--------|----------------|
| Takedown | 2 | 3 seconds |
| Sweep | 2 | 3 s |
| Knee-on-belly | 2 | 3 s |
| Guard pass | 3 | 3 s |
| Mount / back mount / back control (hooks) | 4 | 3 s |

**Tiebreak ladder (mandatory order):**  
1. Points  
2. **Advantages** (near-points or submission that forced genuine defense)  
3. **Penalties** (fewer penalties wins)  
4. Referee decision (arm raise)  
5. Random pick last resort (researched win_methods)

**Advantages do not add to points during the match; they only break a points tie.**  
**Penalties:** progressive (warning → advantage to opponent → 2 points to opponent → DQ). Exact step labels vary by commentary; **use the v6.1 PDF table as source of truth** (researched summary: 1st warning, 2nd advantage, 3rd 2 points, 4th DQ — **verify numbering in PDF before tests**).

**Cumulative points:** progressing through scoring positions in one sequence awards each, if the **final** position is stabilized 3 s (IBJJF rules course video 2024).

**Win methods:** submission (tap/verbal/scream), stoppage (cramp/medical/bleeding/loss of bodily control), DQ, loss of consciousness, score, referee decision, random pick.

### Legality vs matrix

DIRECT in `technique_legality_matrix.json`: omoplata and triangle (pulling head) **restricted** ages 4–15; legal Juvenile/Adult. Scissor **sweep** legal (not the banned standing scissor takedown). Game playable `bjj` does not age-gate.

### Weights vs game

IBJJF gi adult male (athlete **with gi on**, official table): Rooster 57.5, Light Feather 64, Feather 70, Light 76, Middle 82.3, Medium Heavy 88.3, Heavy 94.3, Super Heavy 100.5, Ultra Heavy unlimited (kg). Female Super Heavy = unlimited (no Ultra). No-Gi male adult: typically **−2 kg** vs gi (Rooster 55.5 … Super 97.5) on Wikipedia IBJJF table — **use the official no-gi PDF table at event time**.

Game family `kg` has **no IBJJF named classes**. `move.ladder` is MMA names.

### Fan-visible quirks

- Advantages as a second scoreboard.  
- 3-second rule.  
- Gi weight-in (gi on).  
- Age-gated illegal moves.

### UNKNOWN

- No-Gi adult/master durations in the source the catalog used.  
- Whether v6.1 penalty fourth step is DQ vs another 2-point — **read PDF Art. penalties before writing tests**.

---

## 1.10 `rajadamnern_world_series` — Rajadamnern World Series (RWS)

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ Thailand, `{muay_thai:100}`, S/93, https://rajadamnern.com/ | `real_organizations.json` |
| Venue | Rajadamnern Stadium, Bangkok | official |
| Legal frame | Thailand **Boxing Act** + stadium judging policy. RWS is the Saturday international series; **other nights are traditional stadium cards** and are **not the same scoring culture**. | official blog; Thai Boxing Act announcements |
| Closest researched | `muay_thai_wmc_professional` (5×3, 10-point must, 4 weapons) | **PARTIAL** |
| Playable | `muay_thai` 5×180s / 120s rest | **wrong default for RWS 3×3** |

### Two products, do not collapse

| Product | Rounds | Scoring culture | Sources |
|---------|--------|-----------------|---------|
| **RWS (World Series)** | Most bouts **3 × 3:00**, rest 1:00; **selected championships 5 rounds**. **Open scoring** — scores shown after every round. | “Entertainment” 10-point-must, rounds **equally weighted**. Criteria on official blog (2026-02-20): primary (equal) volume of weapons / effective strikes / damage; then forward pressure; defense; fewer fouls. | https://rajadamnern.com/blog/muay-thai-scoring-system/ verified 2026-09-06; muaytix RWS guide |
| **Traditional Rajadamnern stadium** | Typically **5 × 3:00**, rest 2:00 (WMC-shaped). | **Late rounds weigh more** (R3–R4 climax). Whole-fight “feeling” historically; 10-10+ dots on cards. First round often a feel-out. | Same official blog still describes 5-round ebb-and-flow **in the same article** as RWS 6-criteria — **the page mixes traditional pedagogy with RWS criteria. Treat as CONFLICTING tone; do not invent a numeric round-weight table.** |
| **Stadium-wide policy from 2026-06-01** | All Rajadamnern events 7 days/week | Instagram/SiamMuay report: judges **must pick a round winner** under Boxing Act criteria: (1) more effective weapons (2) more powerful/visible strikes (3) greater visible damage; then (4) aggression (5) superior offense/defense (6) fewer fouls. Standing 8-count only if a body part other than feet touches canvas >1 s. | **Secondary social report**, not a government PDF. Label **UNVERIFIED-PRIMARY**. |

WMC researched (`muay_thai_wmc_professional`): 5×3, rest 2, 10-point must, 4 weapons, power/accuracy/aggression/defense. Win methods include draw / no-decision / NC.

### Judge count

**UNKNOWN** on RWS official blog (does not say 3). Thai stadium custom is 3 judges — **INFERRED, not cited**.

### 10-8 / 10-10

Traditional: 10-10 exists; knockdown often 10-8. RWS equal-round 10-point-must: **10-8 bar UNKNOWN** on the official blog. Game `margin_wide` 6.0 is not a stadium rule.

### Weights vs game

**UNKNOWN** RWS class list on the pages pulled. Game muay_thai **reuses MMA/UFC table** — wrong for Thai stadium kg classes (often 108, 112, 115 lb … or kg catchweights). WMC researched: 19 classes Mini Fly 105 lb through Super HW 209+ lb.

### Fan-visible quirks

- Open scoring on RWS (changes round-3 tactics).  
- Traditional late-round emphasis on non-RWS nights.  
- Eight limbs + clinch dumps.  
- Glove-touch “I won” etiquette in round 5 of traditional cards.

### UNKNOWN

- Judge count.  
- Numeric 10-8 bar.  
- Whether 2026-06-01 must-winner-per-round policy is in a published stadium PDF.  
- Championship 5-round frequency.

---

## 1.11 `lux_fight_league` — LUX Fight League

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ Mexico, `{mma:100}`, A/84, https://luxfightleague.com/ | `real_organizations.json` |
| Official “nosotros” | Mexican MMA promoter founded 2017 | catalog source |
| Own rules PDF | **Not found** | |
| Secondary | Spanish Wikipedia *LUX Fight League*: **Reglas Unificadas de MMA**, octagon, 5:00 rounds, titles **and** main events 5×5, others 3×5, 3 judges, 10-point must, 10-10 possible, **no extra round on draw**, UD/SD/MD/majority-draw/split-draw/unanimous-draw vocabulary | https://es.wikipedia.org/wiki/LUX_Fight_League verified 2026-09-06 |
| Regulator | Mexico City / state **Comisión de Box y Lucha Libre** typically sanctions combat sports in Mexico. **LUX-specific sanctioning document: UNKNOWN.** | |
| Playable | `mma` | INHERITED ABC |

### Ruling for implementation

Treat as **INHERITED `mma_abc_professional`** with Mexican commission override possible. Do **not** invent a LUX 10-8 bar. Referee explainer videos on LUX social (TikTok 2023, Daniela Modad) discuss grounded-knee fouls in Unified language — **not a substitute for a PDF**.

### Weights vs game

**UNKNOWN** official LUX class list. Game MMA table is a reasonable **name** match if they use UFC-shaped classes; **not verified**.

### UNKNOWN

Everything that would be in a promotion athlete guide: 12-to-6 adoption date in Mexico, grounded definition, glove oz, women’s classes.

---

## 1.12 `road_fc` — ROAD Fighting Championship

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ South Korea, `{mma:100}`, A/85, https://www.roadfc.com/ | `real_organizations.json` |
| Official about | Pro MMA + Central/Into amateur/semi-pro leagues + Young Guns | https://www.roadfc.com/main/about/about.php verified 2026-09-06 — **no rules PDF** |
| Korean sport frame | KMGAU (Korea Mixed Martial Arts General Association) joining Korean Sport & Olympic Committee; MMA medal sport at 2026 Aichi-Nagoya Asian Games (ROAD FC 078 send-off copy on the about page) | official about page news |
| Playable | `mma` | |

### Scoring — CONFLICTING

| Claim | Source | Status |
|-------|--------|--------|
| “Road FC uses the global MMA rule set” | Wikipedia *Road Fighting Championship* | secondary |
| **Unlimited Points System**: 1 pt clear strike / takedown / near-sub / mount / back-mount / clear ground control / aggression; **5 pt knockdown**; yellow card **−5**; blue card **−2** (stalling) | same Wikipedia, citing a ROAD FC press line | **NO PRIMARY PDF retrieved 2026-09-06.** Do **not** implement as fact. |
| Elbows **illegal** (listed as foul “attacking with an elbow”) | Wikipedia foul list | **CONFLICTING** with Unified (elbows legal). Baidu Baike: horizontal elbows briefly allowed 2015 then banned from ROAD FC 023. |
| Soccer kick to **head** illegal; soccer kick / stomp to **non-head** of grounded **allowed** (2015 change) | Baidu Baike (secondary) | **UNKNOWN** whether still true in 2026 |
| Grounded-head knee illegal | Wikipedia | INFERRED Unified-like |
| Non-title 2 **or** 3 × 5:00; title 3 × 5:00 | Wikipedia | **shorter than ABC 5×5 titles** if true. **UNKNOWN primary.** |
| Cage “Case”, 9 m octagon | Wikipedia | fan-visible |

**Implementation ruling:** default **INHERITED ABC 10-point-must, 3 judges** for ROAD FC **until** a ROAD FC / KMGAU PDF is in hand. Store Unlimited Points as `status: unverified_secondary` in the proposed schema, not as live `scoring_profile`.

### Weights vs game (Wikipedia table, secondary)

Atom 48 W, Straw 52 W, Fly 57 M/W, Bantam 61, Feather 66, Light 70, Welter 77, Middle 84, LHW 93, HW **over 93** (no 120 cap), Openweight. Scale error 0.5 kg. Game HW cap 120.2 **does not match** if ROAD HW is unlimited-above-93.

### UNKNOWN

Current scoring system (10-point vs Unlimited Points). Elbow rule 2026. Title round count. Judge count.

---

## 1.13 `kunlun_fight` — Kunlun Fight

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ China, `{kickboxing:100}`, A/84, https://kunlunjue.com/ | `real_organizations.json` |
| Catalog source used | Beijing municipal listing of Kunlun Fight World Championships + kickboxing rules (2025-11-20) | `real_organizations.json` `source.url` |
| Primary 2026 rules PDF | **Not found** | |
| Secondary | Wikipedia *Kunlun Fight*: kickboxing (no survival clinch, active clinch + knees, **no throws, no elbows**, yellow card = 25% purse + 1 pt, red = DQ); MMA cards use Unified; Muay Thai cards allow elbows/throws | https://en.wikipedia.org/wiki/Kunlun_Fight verified 2026-09-06 |

### Scoring

**UNKNOWN** judge count, 10-point vs must-winner last round, extra round. K-1-like kickboxing generally: 3 × 3:00, 3 judges, knockdown-first, extra round on draw — **INFERRED from sport convention, not from a Kunlun PDF. Do not ship as Kunlun fact.**

Closest researched: `kickboxing_wako_k1` (amateur). Closest playable: `kickboxing`. Closest **promotion** analogue with a PDF: **GLORY** — do **not** silently reuse GLORY 5-judge open scoring for Kunlun.

### Weights vs game (Wikipedia, secondary)

Straw 51, Fly 57, Bantam 61, Feather 66, Light 70, Welter 77, Middle 84, LHW 93, HW unlimited (kg). Famous 70 kg World Max tournament. Game kickboxing uses MMA/UFC lb table — **wrong**.

### UNKNOWN

Round length, judge count, 10-8 bar, whether 2026 World Championships used WAKO, WLF, or house K-1. Beijing listing cited in catalog: re-fetch if wiring.

---

## 1.14 `united_world_wrestling` — United World Wrestling

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | federation, HQ Switzerland, `{wrestling:100}`, S/98, https://uww.org/ | `real_organizations.json` |
| Ruleset | **UWW International Wrestling Rules**, Jan 2026 | https://cdn.uww.org/2026-01/wrestling_rules.pdf (`src_uww_2026`, retrieved in catalog 2026-08-30; re-verified 2026-09-06) |
| Researched | `wrestling_uww_freestyle`, `wrestling_uww_greco_roman` | DIRECT |
| Playable | `freestyle_wrestling` gap_win 10; `greco_roman` gap_win 8 | matches tech-sup numbers |

### Structure (not 10-point-must)

| Item | UWW 2026 |
|------|----------|
| Periods | **2 × 3:00**, 30 s rest (U20/U23/Senior). Younger: researched **UNKNOWN** |
| Officials | Referee + judge + mat chairman (3-person crew). Not “3 scoring judges” in the MMA sense. |
| Points | 1: step-out / basic reversal (FS). 2: pass-behind / throw to prone / exposure <90°. 4: standing hold to danger / short lift / grand amplitude **without** immediate danger. 5: grand amplitude **with** immediate danger. |
| Greco passivity overlay | +1 fleeing hold/mat; +1 par-terre refusal; +1 1st/2nd passivity (researched prose) |
| Win | Fall; **technical superiority** (FS/WW **10**, GR **8**); decision; injury default; 3-caution default; forfeit; DQ |
| Tiebreak (end of match, equal points) | (1) highest-value scoring actions (most 5s, then 4s, then 2s) (2) fewest cautions (3) last technical point. GR: passivity/injury-simulation/challenge points are **non-technical** in some USA Wrestling notes — use UWW PDF as authority. |
| Challenge | 1 per bout (typical) |

### Weights vs game

Senior/U23/U20 FS: 57, 61, 65, 70, 74, 79, 86, 92, 97, **125** kg.  
GR: 55, 60, 63, 67, 72, 77, 82, 87, 97, **130** kg.  
WW women (Madrid 2026 GP sheet): 50, 53, 55, 57, 59, 62, 65, 68, 72, 76.  
Olympic: 6 per style.

Game family `kg` — **no named UWW classes**. Playable throw_bands 4/2 approximate the amplitude table; **1-pt step-out and 5-pt grand amplitude with danger are not distinct bands**.

### Legality

DIRECT: single-leg, double-leg, ankle-pick **illegal** in Greco (`wrestling_uww_greco_roman`).

### Fan-visible quirks

- Passivity / par-terre in Greco.  
- Tech-fall ends the bout (gap_win already in profile).  
- Challenge brick.

### UNKNOWN

Women’s FS classes were “UNKNOWN, not itemized this pass” in `competition_rulesets_v2.json` — filled above from a 2026 UWW event information sheet, **not** from the main rules PDF weight article. Prefer the rules PDF Article 7 table when wiring.

---

## 1.15 `ijf` — International Judo Federation

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | federation, HQ **Hungary** (catalog), `{judo:100}`, S/98, https://www.ijf.org/ | `real_organizations.json` |
| Ruleset | **IJF Sport and Organisation Rules (SOR)** + refereeing rules. Yuko **reinstated for 2026–28 cycle**. | IJF SOR 2026; JudgeMate 2026-07-18 explainer; Berlin Judo-Verband 2026-09-06 summary of IJF 2025-01-07 briefing |
| Researched | `judo_ijf` (already notes yuko reinstated) | DIRECT |
| Playable | `judo` `ippon` style, throw_bands min 14 → 1 pt (waza-ari), ippon_by_points 2.0 | **no yuko** |

### Structure

| Item | IJF 2026 |
|------|----------|
| Time | **4:00 real (net) contest time**, 1 “round” |
| Golden score | Unlimited (seniors) if scores tied |
| Scores | **Ippon** ends it (throw with control+speed+force largely on the back; 20 s osaekomi; submission). **Waza-ari** (near-ippon throw; 10–19 s hold). **Two waza-ari = ippon.** **Yuko** (side/back landings, 5–9 s hold) — **never aggregates into waza-ari**; used as the next tiebreak. |
| Penalties | Shido; 3rd shido = hansoku-make (indirect). Direct hansoku-make. |
| Win methods | ippon; waza-ari-awasete-ippon; hansoku-make direct; hansoku-make 3rd shido; fusen-gachi; kiken-gachi |
| Officials | 1 referee on mat + 2 judges (video/care system). Not 10-point-must. |

### Weights vs game

Senior: Men −60, −66, −73, −81, −90, −100, +100. Women −48, −52, −57, −63, −70, −78, +78. Game `kg` family — no named IJF classes.

### Fan-visible quirks

- Yuko back on the board (2026).  
- Golden score, no time limit.  
- Blue/white judogi.

### UNKNOWN / lag

Playable profile has **no yuko band** and a single waza-ari throw_band. Catalog `judo_ijf` scoring string already mentions yuko — **engine did not follow**.

---

## 1.16 `world_taekwondo` — World Taekwondo

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | federation, HQ South Korea, `{taekwondo:100}`, S/98 | `real_organizations.json` |
| Ruleset | **WT Competition Rules & Interpretation, in force 2026-06-01** (amended 2026-04-11) | https://www.worldtaekwondo.org/upload/files/2026/05/9c7b3e13-0f32-4b64-b36b-36ca01747ad3.pdf (`src_wt_2026`) |
| Researched | `taekwondo_wt` | DIRECT |
| Playable | `taekwondo` points, gap_win 20, zones head_foot 3 / body_foot 2 / body_hand 1 | **turning kicks not doubled** |

### Scoring (PSS)

| Technique | Points |
|-----------|--------|
| Punch to trunk | 1 |
| Kick to trunk | 2 |
| Kick to head | 3 |
| **Turning** kick to trunk | **4** |
| **Turning** kick to head | **6** |
| Opponent Gam-jeom | +1 to the opponent (researched: 2 late in round — **confirm Art. 12 in 2026 PDF**; Jan 2026 Kyorugi extract showed 1 for Gam-jeom) |

Scoring is **electronic PSS** for kicks; punches may be semi-automatic (PSS impact + judges’ accuracy).

### Structure

3 × 2:00, rest 1:00. **Golden round** 1:00 if tied after 3; **first 3 rounds’ scores void**. First to **2 points** (or opponent 2 Gam-jeoms) wins golden round. Else superiority ladder: punch point in golden → PSS hit count in golden → rounds won in first 3 → fewer Gam-jeoms across 4 → referee+judges content of golden (ref breaks a tied vote).

**PTG:** 20-point gap (`gap_win` 20 already in profile).  
**Best-of-three** system exists as an alternate (Olympic 2024 used best-of-three). 2026 PDF still documents both — **event packet chooses**. UNKNOWN which is default for a FightCamp WT card; **do not silently pick**.

### Weights vs game

World 8-category (men): −54, −58, −63, −68, −74, −80, −87, +87. Olympic 4: men −58/−68/−80/+80; women −49/−57/−67/+67. Game `kg` — no named WT classes.

### Fan-visible quirks

- PSS beeps.  
- Octagonal mat (`arena_profile` `taekwondo_tatami` already).  
- Gam-jeom as scoring.

### UNKNOWN

Best-of-three vs cumulative-3 as FightCamp default. Gam-jeom value late-round (researched “1(2 late in round)” vs Jan 2026 extract “1”).

---

## 1.17 `ares_fighting_championship` — ARES Fighting Championship

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ France, `{mma:100}`, A/84, https://www.aresfighting.com/ | `real_organizations.json` |
| French legal frame | MMA delegated to **Fédération Française de Boxe** / **FMMAF**. Arrêté 31 Jan 2020; delegation renewed 22 Dec 2025 through 31 Dec 2029 (Wikimonde citing Journal Officiel). | secondary legal wrap |
| ARES PDF | **Not found** | |
| Secondary | danslacage.com 2025: ARES “seems” to follow Unified Rules, 3×5 non-title, 5×5 title, 10-point must, 3 judges, 28 fouls. Explicit “sans qu’on en soit sûr à 100 %.” | treat as **INHERITED ABC**, not DIRECT |

FMMAF amateur code (v.900 Jan 2025) is **amateur** (U21/21+ 3×3:00, etc.) — **do not apply to ARES pro cards**.

### Ruling

**INHERITED `mma_abc_professional`** for pro ARES in France, subject to FMMAF/FFBoxe. 12-to-6 / grounded definition follow ABC adoption into French regulation — **UNKNOWN exact French adoption date of ABC 2024/2025 amendments.**

### Weights vs game

**UNKNOWN** ARES title classes. Game MMA table is a name-level stand-in.

### UNKNOWN

Judge assignment, 10-8 practice, whether ARES uses a cage or ring on a given card (official events pages show a cage in recent Paris cards — **not systematically verified here**).

---

## 1.18 `urcc` — Universal Reality Combat Championship

| Field | Value | Evidence |
|-------|-------|----------|
| Catalog | promotion, HQ Philippines, `{mma:100}`, B/77, https://urccmma.com/ | `real_organizations.json` |
| Catalog source | Philippine Senate resolution recognizing URCC | `issuances-library.senate.gov.ph` … `resno29.pdf` |
| Regulator | **Games and Amusements Board (GAB)** | contemporary reporting; Aguilar 2002 hearings |
| URCC PDF | **Not retrieved** (site may be sparse) | |
| Playable | `mma` | |

### Scoring / rounds — CONFLICTING secondaries

| Claim | Source | Status |
|-------|--------|--------|
| 3 × **3:00** pro and amateur; titles **5 × 5:00**; 10-point must; 3 judges; procedure: (1) pick round winner (draw allowed) (2) decide if dominated (3) subtract 1 per foul; draws allowed | Wikipedia *Universal Reality Combat Championship* | **3:00 pro rounds contradict ABC 5:00.** No primary PDF. |
| Older URCC: 2 × 10:00, 2:00 rest, 5:00 extra if draw | 2007 archive of urcc_home.html via en-academic | **historical**, not 2026 |
| URCC-USA follows state ABC Unified | Wikipedia | US cards ≠ Manila cards |
| Fouls include grounded-head knees illegal; yellow/red cards (two yellows → DQ) | Wikipedia | UNVERIFIED primary |

**Implementation ruling:** Manila URCC **UNKNOWN** round length. Do not silently use 5:00. Do not silently use 3:00. **Flag as a data hole.** Scoring system: 10-point must 3 judges is **plausible Unified inheritance** via GAB, still **INHERITED/UNVERIFIED**.

### Weights vs game (Wikipedia, secondary)

Atom W 48, Straw 52, Fly 57, Bantam 61, Feather 66, Light 70, Welter 77, Middle 84, LHW 93, Cruiser 102, HW 120 (kg). Game has no Cruiser.

### Fan-visible quirks

- First GAB-sanctioned MMA in the Philippines (2002).  
- Ring historically (Wikipedia mixed-martial-arts-rules table: URCC = ring). **Current cage vs ring: UNKNOWN.**

### UNKNOWN

Almost all current technical rules. Treat as the **least documented** of the 18 for scoring.

---

## 1.19 Cross-org legality / weight holes vs local files

### `technique_legality_matrix.json` — org-shaped holes

Matrix keys **researched ruleset ids**, not org ids. DIRECT count = 26. **No rows** for:

| Org fact | Matrix status |
|----------|----------------|
| RIZIN soccer kick / stomp / grounded knee | missing (`mma_abc_professional` marks those as fouls) |
| ONE grounded knee legal, soccer kick illegal | missing |
| Karate Combat pit-wall not grounded; double-leg illegal | missing (WKF rows are a different sport) |
| PFL elbows 2025+ legal | ABC pro already legal for most elbows; 12-to-6 CONFLICTING UFC.com vs ABC 2024 |
| ROAD FC elbow ban (if still true) | missing |
| GLORY no elbows, no linear leg kicks | missing (WAKO K-1 is amateur analogue only) |
| RWS / WMC elbows legal | IFMA age-band elbow **restricted** only |

### `weight_classes.json` — org-shaped holes

| Org | Game table used | Real |
|-----|-----------------|------|
| UFC | `mma` (close) | UFC subset of ABC; no Super Light/Cruiser |
| ONE | `mma` (**wrong widths**) | 10-lb-wide 10 classes + hydration |
| GLORY | `mma` via kickboxing family (**wrong**) | 65/70/77/85/95 kg |
| IBJJF | `kg` unnamed | Rooster…Ultra, gi-on |
| IJF / UWW / WT | `kg` unnamed | federations’ own kg ladders |
| RIZIN / ROAD / LUX / ARES / URCC / Jungle / Kunlun / RWS / KC | various | **UNKNOWN or secondary-only** |

---

# Section 2 — Missing data / proposed JSON schema

**This section is documentation only. Nothing was written into `assets/data`.**

## 2.1 What is missing (checklist)

| Need | In catalog? | In researched v2? | In playable combat? | In RoundScoring? |
|------|-------------|-------------------|---------------------|------------------|
| Org → ruleset bind | no | no | no | n/a |
| Commission / country override | no | `jurisdiction` on ruleset only | no | n/a |
| Judge count N | no | prose only | no | no |
| Criteria priority list | no | prose string | no | no (flat weights) |
| `weights.aggressiveness` / `area_control` | no | named in MMA prose | **absent** on live MMA profile | DEFAULT_WEIGHTS has neither |
| Whole-bout style | no | not a machine field | no | `card()` is per-round |
| 10-10 policy (`forbid_even_completed_round`) | no | ABC 2025 prose | no | emits 10-10 on tie |
| 10-7 | no | ABC/GLORY prose | no | no |
| Draw taxonomy (UD/SD/MD + draw types) | no | win_methods lists | UI words only | one card |
| Season/tournament points (PFL historic) | no | no | no | no |
| Open scoring flag | no | no | no | no |
| Extra/sudden-victory round | no | some win_methods | no | no |
| Advantages / penalties (IBJJF) | no | prose | no | no |
| Yuko (IJF 2026) | researched string | yes | **no** | ippon/waza-ari only |
| PSS turning-kick doubles | researched | yes | **no** | zone table static |
| Org weight tables | no | per-ruleset strings | `weight_classes.json` families only | n/a |
| Org legality overlays | no | per-ruleset | matrix by ruleset | n/a |
| `range_owner` → area-control | no | no | FightRange live | not read |

## 2.2 Proposed schema (documentation)

Additive. Do not break `combat_rulesets.json` v2 keys. Org file stays identity; a **companion** `organization_rules_bindings.json` (proposed name) holds the bind.

### 2.2.1 Organization binding record (fully worked: `ufc`)

```json
{
  "id": "ufc",
  "schema_version": 1,
  "entity_type": "promotion",
  "default_discipline": "mma",
  "discipline_bindings": {
    "mma": {
      "ruleset_id": "mma_abc_professional",
      "playable_combat_id": "mma",
      "scoring_mode": "round_ten_point_must",
      "judge_panel_id": "panel_abc_mma_3",
      "round_defaults": {
        "non_title": {"count": 3, "seconds": 300, "rest": 60},
        "title_or_main_event_five": {"count": 5, "seconds": 300, "rest": 60}
      },
      "weight_table_id": "abc_mma_ufc_subset",
      "legality_base": "mma_abc_professional",
      "legality_overlays": [],
      "commission_policy": "event_state_athletic_commission_adopts_abc",
      "unknown": ["overseas_commission_scoring_clarification_adoption"]
    }
  },
  "brand_policy": "text_name_only",
  "sources": [
    {
      "url": "https://www.ufc.com/unified-rules-mixed-martial-arts",
      "verified_date": "2026-09-06",
      "evidence": "DIRECT"
    },
    {
      "url": "https://www.abcboxing.com/wp-content/uploads/2025/08/ABC-MMA-Scoring-Criteira-Clarification-7.2025.pdf",
      "verified_date": "2026-09-06",
      "evidence": "DIRECT"
    }
  ]
}
```

### 2.2.2 Ruleset scoring machine (fully worked: `mma_abc_professional` extension)

Keep existing researched prose fields. Add a **parallel** `scoring_machine` object (do not delete prose):

```json
{
  "id": "mma_abc_professional",
  "scoring_machine": {
    "style": "ten_point_must",
    "scope": "per_round",
    "judge_count": 3,
    "referee_scores": false,
    "criteria_priority": [
      {"id": "damage", "gate": "primary", "maps_to": ["damage", "knockdowns", "submissions"]},
      {"id": "dominance_duration", "gate": "primary_modifier", "maps_to": ["control", "takedowns", "positions", "volume"]},
      {"id": "aggressiveness", "gate": "if_primary_even", "maps_to": ["aggressiveness"]},
      {"id": "area_control", "gate": "if_primary_even", "maps_to": ["area_control"], "feeds": ["fight_state.range_owner"]}
    ],
    "ten_point": {
      "even_completed_round": "discouraged",
      "even_partial_round": "allowed_10_10",
      "ten_eight": {
        "requires": "significant_damage",
        "positional_control_alone": false,
        "margin_wide_fallback": 6.0
      },
      "ten_seven": {
        "requires": ["overwhelming_damage", "overwhelming_dominance", "full_round"]
      }
    },
    "draw_types": ["unanimous_draw", "majority_draw", "split_draw", "technical_draw"],
    "decision_types": ["unanimous", "majority", "split", "technical_decision"],
    "open_scoring": false,
    "extra_round": null,
    "weights_additions": {
      "aggressiveness": 0.0,
      "area_control": 0.0
    }
  }
}
```

`weights_additions` start at 0.0 so live maths do not change until a designer sets them. The **gate** is the ABC rule: aggressiveness/area_control are **not mixed into the primary float** unless primary is even.

### 2.2.3 Judge panel record

```json
{
  "id": "panel_abc_mma_3",
  "n": 3,
  "selection": "commission",
  "disagreement": {
    "model": "independent_noise_on_secondary_weights",
    "sigma": 0.08,
    "bias_pool": ["striker_eye", "grappler_eye", "center_control"],
    "seed": "bout_id + judge_index"
  },
  "cannot_see": ["true_rng", "corner_advice"],
  "must_not": ["named_real_judges"]
}
```

### 2.2.4 Whole-bout variant (ONE MMA) — not a `ten_point_must` style

```json
{
  "id": "mma_one_global",
  "scoring_machine": {
    "style": "whole_bout_priority",
    "scope": "entire_bout",
    "judge_count": 3,
    "criteria_priority": [
      "near_finish",
      "damage",
      "striking_and_generalship",
      "takedown_exchange",
      "aggression"
    ],
    "ten_point": null,
    "decision_types": ["unanimous", "majority", "split"],
    "draw_types": ["UNKNOWN"]
  }
}
```

## 2.3 Migration notes

### 18 organizations

| Step | Action | Save-safe? |
|------|--------|------------|
| 1 | Leave `real_organizations.json` identity fields untouched | yes |
| 2 | Add companion bindings file; missing bind → fall back to current `combat_rulesets.json` by discipline (today’s behaviour) | yes — old saves keep scoring |
| 3 | Championship round count is an **event flag**, not a global rewrite of `mma.rounds` | yes |

### 30 researched rulesets

| Step | Action |
|------|--------|
| 1 | Keep `competition_rulesets_v2.json` as the prose/citation catalog (`note` already says PROPOSAL) |
| 2 | Author **new** ids for ONE / RIZIN / GLORY / Karate Combat / RWS rather than overloading WAKO/WKF/WMC |
| 3 | Amateur ABC/IMMAF stay exhibition/federation content; only CMMAF binds IMMAF by default |

### 11 playable combat rulesets

| Step | Action | Risk |
|------|--------|------|
| 1 | Do **not** change live `scoring_profile` numbers in P0 except adding **new keys** with default 0.0 (`aggressiveness`, `area_control`) | `RoundScoring.profile_for` **copies** unknown weight keys into the profile dict, but `round_points` **only reads** `damage/volume/knockdowns/control/takedowns/positions/submissions/throws` plus `zones`. New keys are **inert** until `round_points` (or the JudgePanel gate) is extended. `DEFAULT_WEIGHTS` does not include them. |
| 2 | Karate Combat must **not** use playable `karate` | would silently apply SENSHU/8-gap on a 10-point pit fight |
| 3 | ONE MMA must **not** use playable `mma` `ten_point_must` once P1 ships | would keep round cards |
| 4 | IJF yuko = new throw/hold band, not a rewrite of ippon_threshold | old judo saves still ippon/waza-ari |
| 5 | WT turning-kick doubles = zone or a `turning` flag on the hit, not a gap_win change | gap_win 20 stays |

### Saves

- Bout records that stored a single `{a,b}` per round: on load, wrap as `cards: [{a,b}]` (N=1) so old replays still display. Decision type: if N=1, **do not** print “Unanimous” — print a neutral “Decision” or keep current string. **Do not rewrite history as UD.**  
- If a save’s `combat_ruleset_id` is `mma` and `organization_id` is `one_championship`, P1 may re-score only if a `rules_version` stamp is present; otherwise keep the stored cards.  
- PFL season points are a **career/season** object, not a bout card. Old saves have no such object — default `null`.

---

# Section 3 — Judges

## 3.1 Reality per org family

| Family | Orgs | How judging actually works | N | Split possible? |
|--------|------|----------------------------|---|-----------------|
| ABC Unified MMA, round 10-point-must | UFC, PFL (bout), Jungle (INHERITED), LUX (INHERITED), ARES (INHERITED), URCC (UNVERIFIED) | 3 independent humans, closed cards, scorekeeper deducts fouls, majority of **bout totals** (not a vote of round-winners) | 3 | **Yes** — UD/SD/MD and three draw types |
| ONE Global MMA | ONE | 3 humans, **one verdict on the whole fight**, published descending criteria | 3 | **Yes** (2–1 whole-bout). **No** 29-28 maths |
| ONE striking | ONE MT / KB | 3 humans, 10-point-must **rounds**, criteria used if points tie | 3 | Yes |
| RIZIN MMA | RIZIN | Whole-bout priority (damage → aggressiveness → generalship). N **UNKNOWN** official page, INFERRED 3 (JMOC) | 3? | Yes if N=3 |
| RIZIN / GLORY kickboxing | RIZIN KB, GLORY | Round 10-point-must; GLORY **open**, N=5 or 3, Sudden Victory extra round | 5/3 | Yes; GLORY extra round **forbids** 10-10 |
| Karate Combat | KC | 3 humans, 10-point-must, productive aggression priority, PIT control | 3 | Yes |
| RWS / stadium MT | RWS | Open scoring on RWS; traditional nights late-round emphasis. N INFERRED 3 | 3? | Yes |
| IBJJF | IBJJF | **1 central referee** scores points/advantages/penalties. Not 3 cards. | 1 | N/A (ref decision / random pick) |
| UWW | UWW | Referee + judge + chairman. Points are **called**, not independently carded like MMA | 3-crew | Challenge, not SD |
| IJF | IJF | 1 ref + 2 judges / CARE video. Scores are called (ippon/waza-ari/yuko/shido) | 3-crew | CARE review, not SD |
| WT | WT | PSS machine + judges for punches / superiority vote in golden | hybrid | SUP decision is a panel vote |
| WKF (not KC) | (no org in the 18; researched id only) | 4 judges + ref; score if ≥2 judges signal | 5-crew | HANTEI vote |
| CMMAF / ROAD / Kunlun | — | UNKNOWN or secondary | UNKNOWN | UNKNOWN |

**Named judges:** **UNKNOWN / do not invent.** Commissions assign licensed officials per event. There is no stable “UFC judge roster” in this catalog.

## 3.2 Implementation recommendation

### Data model

```
JudgePanel { n, judges: [Judge] }
Judge { id, bias_tag, noise_seed, criteria_weights_delta }
RoundResult { round_index, cards: [{judge_id, a, b, notes}] }   # ten_point_must
BoutResult { cards_total: [{judge_id, a, b}], decision_type }
WholeBoutResult { votes: [{judge_id, winner, criterion_fired}] }  # ONE / RIZIN MMA
```

Bind in `FightSimulation.gd` at the current ~:2570 append: **append `cards` (length N)**, not one dict. ~:2682–2694: **per-judge sum**, then:

| Per-judge winner | Decision type |
|------------------|---------------|
| 3–0 | Unanimous decision |
| 2–0 (third 10-10 bout) | Majority decision |
| 2–1 | Split decision |
| 0–0–0 all draw | Unanimous draw |
| 1–0–0 (two draws) | Majority draw |
| 1–1–1 | Split draw |

N=5 (GLORY): majority is 3. Sudden Victory: **replace** totals with extra-round cards (GLORY rule: only extra round counts), extra round **must** have a winner.

### Disagreement model (defend)

**Recommendation:** independent Gaussian noise on **secondary** weights + a small discrete bias tag (`striker_eye` slightly up-weights `damage`/`volume`; `grappler_eye` up-weights `control`/`positions`; `center_control` up-weights `area_control` when the gate opens). Primary ABC damage still has to **agree often**, because real 10-9s cluster.

**Reject:** one omniscient card plus a random “split chance” coin. That cannot produce a 29-28 vs 28-29 vs 29-27 table a player can audit.

**Reject:** three full copies of the simulation. Too expensive; judges observe the **same counters**, they do not live in different physics.

**Reject:** naming real officials (Herb Dean, Sal D’Amato, …) as data. Licensing + accuracy + the catalog’s brand policy.

### Bind to `RoundScoring` / `FightSimulation`

1. `profile = RoundScoring.profile_for(ruleset)`  
2. For each judge: `p_j = copy(profile); apply delta; if criteria_priority and primary_even: enable aggressiveness/area_control`.  
3. `pts_a = RoundScoring.round_points(p_j, fighter_a)` (same counters).  
4. `cards[j] = RoundScoring.card(p_j, pts_a, pts_b)`  
5. Optional: if `even_completed_round == discouraged` and `cards[j] == 10-10`, **re-roll bias toward a 10-9** (ABC 2025). Do not force a winner in GLORY 10-10 examples that the PDF still allows for knockdown-each-way.

`RoundScoring.gd` stays pure. New file (proposed name only): `JudgePanel.gd`.

### `range_owner` / ring generalship

`FightRange.gd` `contest` / `intent_band` / `BANDS` and `fight_state.range_owner` already ship (R35–R37). **Do not respec.**

Feed:

| Family | When `range_owner` scores |
|--------|---------------------------|
| ABC MMA | Only if Plan A (damage/effective striking-grappling) is even — Plan C fighting-area control |
| ONE MMA | Criterion 3 “cage/ring generalship” — **not** gated as hard as ABC, but still below near-finish and damage |
| GLORY | Criterion 4, after knockdowns/damage/clean strikes |
| RWS | “Forward pressure” after the three primary weapon/damage criteria |
| Boxing playable | `judging` string already says ring generalship; live boxing weights have **control 0.0** — same hole |

Map: if `range_owner == A` for ≥50% of the round clock, add `area_control` points to A. Exact % is a designer number — **UNKNOWN from rulebooks** (they never quantify). Default proposal: 0.2 weight, gated.

### Non-round systems

| Style | Do not use `card()` 10-point-must | Use |
|-------|-----------------------------------|-----|
| IBJJF | yes | running points + advantages + penalties; 1 referee |
| IJF | yes | ippon / waza-ari / yuko / shido; CARE crew |
| UWW | yes | point calls + tech-sup `gap_win` |
| WT | yes | PSS points + golden-round rules |
| WKF | yes | yuko/waza-ari/ippon + SENSHU (`initiative` already) |
| ONE MMA / RIZIN MMA | yes | whole-bout vote |
| ONE grappling | yes | catch count |

`RoundScoring.style()` already branches `ten_point_must` vs raw points vs ippon. Add **`whole_bout_priority`** as a fourth style rather than overloading `ten_point_must` with a fake 30-27.

### What the player learns

| Lesson | How the player sees it |
|--------|------------------------|
| 10-9 vs 10-8 | Damage, not stall-mount, wins the 10-8 (ABC 2025). Grappling stallers stop farming 10-8s. |
| Splits exist | Same fight, three cards. Prep for the **panel**, not the omniscient god. |
| Org shopping | ONE rewards a late near-finish; UFC rewards winning rounds; RIZIN rewards damage including soccer kicks; GLORY rewards knockdowns and open-score tactics; RWS shows the running score. |
| Range | Holding center (`range_owner`) only pays when the fight is otherwise even — teaches ABC Plan C, not a new range minigame. |
| Federations | IBJJF advantages, IJF yuko, WT PSS, UWW tech-fall — different sports, not “MMA with a skin.” |

## 3.3 Alternatives rejected

| Alternative | Why not |
|-------------|---------|
| Keep N=1, add flavor text “the judges were split” | Lies; UI words would still be unearned |
| Per-org fork of `RoundScoring.gd` | 18 copies of the same float math; breaks “pure/stateless” |
| Use WKF profile for Karate Combat | Different sport (skin-touch points vs full-contact pit) |
| Use WAKO amateur for GLORY | Different N, open scoring, Sudden Victory, pro knockdown table |
| Implement ROAD FC Unlimited Points in P0 | No primary PDF |
| Random 10-8 when `margin_wide` exceeded | ABC 2025 requires **damage**, not a float margin |
| Feed `range_owner` as primary MMA weight | Violates ABC priority; would respec the range rail into a scoring rail |

---

# Section 4 — Issues (each with a solution)

## 4.1 Brand / licensing

**Issue:** 18 real org names are in `real_organizations.json`. UFC, ONE, GLORY, IBJJF, IJF, WT, UWW are trademark-heavy. Catalog already states: *“Text names only. No organization logos, belts, posters, event photography or other brand artwork.”*

**Solution:** Keep text-name policy. Do not ship belt/cage/pit **trade dress** as branded assets. Rules text may cite real ABC/IF rulebooks (public regulatory documents). Do **not** name living judges. Do **not** reproduce ONE/UFC video packages. If a publisher later requires fictionalization, the **binding schema** (`default_ruleset_id`) lets a “Unified Pro MMA” skin replace `ufc` without rewriting `RoundScoring.gd`.

## 4.2 Scope / MVP order

**Issue:** 18 orgs × 30 researched rulesets × 11 playable profiles is more than one scoring sprint.

**Solution (same as D4):**

| Phase | Ships | Explicitly does not |
|-------|-------|---------------------|
| **P0** | N=3 array-of-cards; ABC 10-point-must; 10-8 **damage gate**; discourage completed 10-10; UD/SD/MD + draw types; bind UFC/PFL/Jungle/LUX/ARES as `mma_abc_professional`; URCC flagged UNKNOWN rounds | ONE whole-bout, RIZIN kicks, GLORY N=5, RWS open, federation yuko/PSS/advantages |
| **P1** | `mma_one_global` whole-bout; ONE weights + hydration as data (not necessarily sim) | Soccer kicks |
| **P2** | `mma_rizin` legality overlay + whole-bout criteria | 50/30/20 unless JMOC publishes it |
| **P3** | `kickboxing_glory` 5-judge open + Sudden Victory | Kunlun as GLORY clone |
| **P4** | `muay_thai_rws` 3×3 open + criteria; keep WMC 5×3 for traditional | Invented round-weight 1.0/1.0/1.2/1.2/0.8 table — **UNKNOWN numeric** |
| **P5** | IBJJF advantages/penalties; IJF yuko; WT turning doubles; KC pit profile | ROAD Unlimited Points |

CMMAF stays IMMAF amateur. Karate Combat is P5 or a side-sprint — **do not** ship it on the WKF profile.

## 4.3 UNKNOWN defaults

**Issue:** Jungle, LUX, ARES, URCC, ROAD, CMMAF, Kunlun, RIZIN rest/N/draws, KC 10-8 bar will ship with holes.

**Solution:** every bind has `evidence: DIRECT | INHERITED | UNVERIFIED_SECONDARY | UNKNOWN` and a `fallback_ruleset_id`. Runtime: if `UNKNOWN` and fallback exists, **use fallback and log `rules_fallback=1` on the bout record** so tests can assert the label. Never fill 10-8 bars with `margin_wide` silently for INHERITED orgs — they inherit **ABC’s damage gate**, which is a real rule, not a guess.

URCC round length: **do not default to 5:00 or 3:00**. Block a URCC-tagged card in tests until a GAB/URCC primary is filed, **or** show an explicit designer override in the event record (`rounds_override`).

ROAD FC Unlimited Points: store as `unverified_secondary`, default fallback ABC.

## 4.4 Test assertions (engine, once someone implements — not written in this pass)

These are the **contracts** a later PR must not violate. They are not tests in-tree today.

| ID | Assertion |
|----|-----------|
| T1 | `RoundScoring.card` remains deterministic for a fixed profile + points (pure). |
| T2 | With `JudgePanel` N=3 and `sigma=0`, all three cards **equal** the omniscient card (regression vs ~:2570). |
| T3 | With `sigma>0`, a fixture bout can emit `split` and `majority` decision types; UI words only appear when N≥3. |
| T4 | ABC profile: completed-round 10-10 is **not** the equilibrium outcome when `even_completed_round=discouraged` and points differ by ε. |
| T5 | ABC 10-8: high `control` + `takedowns` + **zero** `damage`/`knockdowns` **does not** 10-8 (2025 positional-control clause). |
| T6 | ABC 10-8: high `damage` can 10-8 without a knockdown. |
| T7 | Old save with a single `{a,b}` loads as `cards.length==1` and does **not** print “Unanimous”. |
| T8 | `one_championship` + `mma` after P1: **no** per-round 10-9 array; whole-bout vote length 3. |
| T9 | `rizin` legality overlay: grounded-head kick **legal**; `ufc` same technique **illegal**. Matrix key is org overlay, not only `mma_abc_professional`. |
| T10 | `karate_combat` **must not** call `uses_initiative()` SENSHU path. |
| T11 | `glory` extra round: judges cannot emit 10-10; decision uses extra-round cards only. |
| T12 | `ibjjf` equal points, A advantages > B → A wins; points still trump advantages. |
| T13 | `ijf` yuko does not create ippon; two waza-ari still do. |
| T14 | `world_taekwondo` turning head kick is 6, not 3. |
| T15 | `range_owner` does not change an ABC round when Plan A is already a clear 10-9. |
| T16 | Fallback bouts carry `rules_fallback=1` when org evidence ≠ DIRECT. |
| T17 | No test fixture contains a real judge’s name. |
| T18 | `weight_classes.json` UFC-subset vs ONE 10-lb table: same named “Lightweight” **must not** share a kg cap. |

---

## Source list (live verification 2026-09-06)

Primary / official (preferred):

- ABC Unified Rules of MMA (PDF 8.2026): https://www.abcboxing.com/wp-content/uploads/2026/08/Unified-Rules-of-MMA-8.2026.pdf  
- ABC MMA Scoring Criteria Clarification (7.2025): https://www.abcboxing.com/wp-content/uploads/2025/08/ABC-MMA-Scoring-Criteira-Clarification-7.2025.pdf  
- ABC Unified Rules index: https://www.abcboxing.com/unified-rules/  
- UFC Unified Rules page: https://www.ufc.com/unified-rules-mixed-martial-arts  
- PFL 2025 World Tournament Rules PDF: https://pflmma-prod.s3.us-east-1.amazonaws.com/assets/rules/2025_PFL_World_Tournament_Rules_and_Regulations_as_of_3_1_2025.pdf  
- ONE Championship Martial Arts (Global Rules): https://www.onefc.com/martial-arts/  
- Colorado-approved ONE Global Ruleset (2021 full text): https://combatsportslaw.com/2021/07/27/full-colorado-approved-one-championship-global-ruleset/  
- RIZIN official rules: https://jp.rizinff.com/rule  
- GLORY Kickboxing Official Rules v2.2: https://glory.pinkyellow.network/assets/rules/glory-rules-2026-v2.pdf  
- Karate Combat rules page: https://karate.com/pt/rules-and-regulations  
- CMMAF official: https://cyprusmixedmartialartsfederation.com/  
- IBJJF rules hub: https://ibjjf.com/rules  
- IBJJF Rules Book v6.1 PDF: https://cdn.shopify.com/s/files/1/0727/9715/9746/files/2024JUN_IBJJF_Rules_EN.pdf  
- Rajadamnern scoring guide: https://rajadamnern.com/blog/muay-thai-scoring-system/  
- ROAD FC about: https://www.roadfc.com/main/about/about.php  
- UWW Wrestling Rules PDF (2026-01): https://cdn.uww.org/2026-01/wrestling_rules.pdf  
- WT Competition Rules PDF (in force 2026-06-01): https://www.worldtaekwondo.org/upload/files/2026/05/9c7b3e13-0f32-4b64-b36b-36ca01747ad3.pdf  
- WKF Kumite Rules 2026: https://www.wkf.net/files/pdf/documents/WKF_2026_Kumite_Competition_Rules_MASTER_COPY_V12FINAL.pdf  
- IMMAF athlete eligibility (2025 elbows/knees clause): https://immaf.org/athletes/athlete-eligibility/  
- `competition_rulesets_v2.json` `sources` block (ABC amateur, IMMAF 2015, WAKO chapters, IFMA 2026, WMC 2020, IJF SOR, FIAS, IWUF Sanda, etc.) — catalog retrieved 2026-08-30; URLs not all re-downloaded 2026-09-06

Strong secondary (labelled in org sections):

- MMA Fighting / MMA Junkie / ESPN on PFL format and elbows (2025-01)  
- Sportsnet / MMA Fighting on ABC 2025 scoring vote  
- Wikipedia/Wikiwand RIZIN, ROAD FC, URCC, Kunlun Fight, Jungle Fight, LUX (ES), ARES (FR) — **never the sole basis for a 10-8 bar**  
- CABMMA Unified adoption (MMA Fighting 2017; Globo 2025 scoring clarification interview)

Local files (this workspace, 2026-09-06): `real_organizations.json`, `competition_rulesets_v2.json`, `combat_rulesets.json`, `RoundScoring.gd`, `technique_legality_matrix.json`, `weight_classes.json`.

---

*End of J1. Research and proposals only.*

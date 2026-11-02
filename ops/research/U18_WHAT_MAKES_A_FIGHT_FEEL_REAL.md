# U18 — What makes a fight feel real

**Desk:** Cursor  
**Date:** 2026-09-09  
**Status:** research only. No `Godot/scripts/` writes. No `HANDOFF.md`.  
**Consumers:** Claude (C17 live scene, R35 range follow-on, FightSimulation cadence). Cite **D-numbers**. Do not reopen C17 Q1/Q2/Q3 as settled law — they stay operator gates. Do not invent ring coordinates (C17 Q3 / C18). Do not author 272 unique clips.

Operator ask: how close we are to a fight that *feels* real; which statistics of a normal fight-flow we lack; stances, spacing, footwork; how distance relates to moves; PDFs and schematics for diet, training, animation, technique.

---

## The one finding

**The distance vocabulary is already right. The fight *flow* is not.**  
`FightRange` already speaks the same three-distance grammar the coaching handbooks use (long / medium / short + clinch). What a real bout spends most of its time doing — jab, miss, step, feint, hip dip, cover, reset — is collapsed into **one named technique every 14 fight-seconds**. That is why the live screen feels like a slideshow even when the catalog is deep.

Davis 2015 (Olympic 3×3 min finals/semis): **~20 punches, ~2.5 defensive movements, ~47 vertical hip movements, per minute**, activity rate **~1.4 actions/s**.  
Our sim: `AVG_SECONDS_PER_EXCHANGE = 14.0` → **~13 named actions per 3-minute round**. A real elite amateur round is ~60 punches plus ~7–8 defenses plus ~140 hip/foot actions. We present about **one-fifth of the punches and none of the locomotion**.

---

## Code, checked (not assumed)

| Surface | What it actually does | Verdict |
|---|---|---|
| `technique_catalog.json` v5 | 15 disciplines, **272 nodes**: 55 skill / 178 move / 39 sequence. Every node has `match.role`, `phases`, `range_band`, `range_delta`. **Zero `clip_id` / animation fields.** | Technique bible is ready. Animation bible is empty. |
| `FightSimulation.gd` | Two macro-phases STANDING / GROUND. Catalog `pocket`/`clinch`/`standing_back` all count as STANDING (file header). Defense roles **never drawn as actions** — they fold into `defense_factor`. 14 s/exchange, min 6 exchanges/round. | Outcome engine. Not a flow engine. |
| `FightRange.gd` | Ladder OUT / LONG / MID / POCKET / CLINCH. Contest one step/exchange. Reach ±8 cm moves home band. Entry toll when crossing a longer man's band. Comfort tax off-home. Two bands off = lockout. | Matches coaching books. No metres, no stance geometry, no ring place. |
| `ANIMATION_FAMILY_BY_ROLE` | damage/counter/setup/adaptation → `strike`; control → `clinch`; takedown → `takedown`; submission → `submission`; transition/escape → `scramble`. **`defense` missing** → defaults to `strike`. | Family map is too coarse and wrong for defense. |
| `RingStagePanel._animate` | Photo silhouettes + 0.31 s lunge/recover tween by family. | Presentation of a family, not a move. |
| `FightNightScreen` | Timer 1.4 wall-s / speed → `advance_exchange()` → RingStagePanel. Never mounts `FightWorldPreview`. | Live fight is 2.5D. |
| `FightWorldPreview.tscn` + `ArenaRig` + `FighterPhysique` | Camera, lights, spawn marks (no baked Y). Ring builds. Gym cage `mma_cage_gym_6m` builds; ABC 18 ft cage still refused (no published apron). 12 humanoid 22-bone GLBs, one clip: `walk_relaxed`. | Preview pipeline. Not in the live slot. |
| `TaleOfTape.gd` | Assigns `stance` ORTHODOX (75%) / SOUTHPAW (25%). Height, reach, leg reach. Tape notes "style clash" when stances differ. | **Stance is costume.** `FightSimulation.gd` never reads it. |
| `fight_plans.json` | Archetypes (out-boxer, pressure, …), pace curve, target bias, phase. Corner range calls STAY LONG / GET INSIDE / TIE HIM UP exist (K22 / FightRange Stage B). | Plans *talk* about distance. They do not change output cadence. |
| Seven athlete stats | power, technique, speed, defense, conditioning, fight_iq, grapple. | No output-rate, jab-share, check-rate, stance-IQ, ring-craft, clinch-time, control-time. |
| `WeightCut` + `weight_classes.json` | Diet none / moderate (0.6%/wk) / aggressive (1.1%/wk). Water-cut free band 3%, then stamina/chin tax. | Diet is a weekly rate, not macros, hydration protocol, or post-weigh-in regain. |
| `TechniqueGlyphs.gd` | ~30 pictogram families (jab, hook, teep, takedown, …). | Best existing grain for clip mapping. |

---

## D1 — Cadence: the missing fight-flow statistics

A fight feels real when **volume, mix, and idle** look like recorded bouts, not when every tick is a highlight.

| Real measure | Source | Typical | Ours today |
|---|---|---|---|
| Punches thrown / min (elite amateur) | Davis 2015, IJSPP | ~20 (~60 / 3-min round) | ~4–5 named strikes / round if both men act |
| Punches landed % | CompuBox career tables; Davis | ~26–37% pro; winners land more in R3 | One land/miss roll per named technique |
| Jab share of offence | CompuBox; Kapo et al. | Lead straight often ~29% of attacks; jabs are the distance tool | Jab is one `setup` node among many; no jab-share target |
| Power-punch connect | CompuBox (Hagler 47% power, 43% all) | Power connects higher than jabs | No jab vs power split |
| Defensive actions / min | Davis 2015 | ~2.5 (trunk slip > foot > hand) | 0 as events; absorbed into a scalar |
| Hip / foot actions / min | Davis 2015 | ~47 vertical hip movements | 0. Range contest is a hidden roll |
| Combinations | Davis; our own catalog | 2-punch combos rise R1→R2; 3-punch judged well | 39 sequences exist; stamina-gated; most exchanges are singles |
| Clinch bouts / time | Davis 2015 | 2.5 / 12.6 s in R1 → 4.8 / 28.7 s in R3 | CLINCH is a **band**, not a clock |
| Referee stoppage | Davis 2015 | Stop time 21 s → 50 s by R3 | No ref as a time actor |
| MMA SLpM / accuracy | UFC Stats (FightMetric) | ~3–5 sig. strikes landed / min; accuracy ~40–50% elite | Same 14 s tick as boxing |
| MMA position split | UFC Stats | Distance / clinch / ground % of sig. strikes | STANDING vs GROUND only |
| TD acc / ctrl time | UFC Stats | TD acc %, control time mm:ss | Takedown is a role that flips phase; no clock |

**D1 ruling for build:** do not drop `advance_exchange()` to 1 Hz. Keep the atomic exchange (C17 Q1 recommendation). Add a **burst payload** on each event: `thrown`, `landed`, `jab_share`, `defense_used`, `steps`, derived from pace + stamina + plan, so the presentation layer can play 3–6 punches and a slip inside the 1.4 s window while the sim still advances once. Cite Davis for boxing defaults; UFC SLpM for MMA.

---

## D2 — Distance and spacing (how distance relates to moves)

Coaching books do not use metres. They use **whether you must step**.

USA Boxing / AIBA Coaches Manual (identical wording in the USAB-GTF training manual and the AIBA coach manual, § boxing techniques):

| Coaching distance | Definition | Punch that lives there | Our band |
|---|---|---|---|
| Long | "Far enough that the boxer cannot deliver the punch without stepping forward." Straight punches measure and disturb from here. | Jab, rear straight, teep, side kick | **LONG** (and the outer edge of MID) |
| Medium | "Don't have to step forward to deliver." | Hooks | **MID** |
| Short | "Gloves almost or do touch each other." | Uppercuts | **POCKET** |
| Hold / clinch | Active grip; ruleset-capped (WAKO often 5 s; boxing referee breaks) | Knees, dirty boxing, break | **CLINCH** |
| Out | Neither will close | None | **OUT** |

That is exactly `FightRange.BANDS`. The catalog already tags `range_band` and `range_delta` (jab LONG/MID δ0; teep pushes out; overhand/uppercut/shot close). **Do not replace the ladder with metres.**

What is still missing for *feel*:

1. **Reach is a preferred-band shift, not a weapon length.** Real geometry: jab range ≈ (own reach − guard depth). An 8 cm reach edge is the module's threshold; coaching treats the longer man as owning long *until the shorter man steps*. We have the entry toll. We do not have "the jab is 5 cm short."
2. **One step per 14 s.** Real closing is a series of lead-foot steps (see D4). A pressure fighter walks a man down over 10–20 seconds, not one contest.
3. **OUT is a stall, not a home.** Correct in code. Needs a presentation (circle, feint, refuse) or it reads as a hole.
4. **Ground ignores the ladder.** Correct for standing range. MMA still needs a **position table** (see D8), which is the cheap middle C18 named for Q3 — enum + control-time, not coordinates.
5. **Defense maps to strike.** A shoulder roll at POCKET is not a strike. Fix `ANIMATION_FAMILY_BY_ROLE` before any clip pack.

**Distance → move law (keep, do not invent):**

- Two bands off = physically unavailable (`GATE_BAND_DISTANCE`).
- One band off = legal but ugly (`FIT_ONE_OFF = 0.5`).
- In band = 1.35 draw weight.
- Delta that walks toward *your* home is worth throwing for that reason (`delta_intent_factor`).

That law is already how real coaches talk. The hole is **volume at each band** (jab-heavy at LONG, hook-heavy at MID, uppercut/elbow at POCKET) — a mix table, not a new ladder.

---

## D3 — Stance

Tape prints ORTHODOX / SOUTHPAW. The sim does not care.

Real consequences of an **open stance** (orthodox vs southpaw):

- Lead feet fight for the outside line. Outside foot ≈ easier rear-hand and kick to the open side.
- Jab becomes a cross-body probe; the orthodox jab meets a southpaw jab.
- Body-kick and left hook to the liver change sides.
- Same-stance "closed" fights are jab-and-step; open-stance fights are foot-race plus rear-hand.

AIBA / USA Boxing stance schematic (11-point list, used as the animation bind-pose checklist):

1. ~45° to the opponent  
2. Feet shoulder-width  
3. Weight even  
4. Knees soft, slightly in  
5. Trunk rotated in  
6. Rear heel up  
7. Lead hand at eye line  
8. Chin down, lead shoulder covers  
9. Rear elbow on the ribs  
10. Rear fist at the chin  
11. Both fists slightly pronated  

Common mistakes the same manuals name (these are **clip-quality gates**, not new stats): feet too wide/narrow, both heels flat, standing tall, chin up.

**D3 ruling:** add `stance` to the exchange (already on the athlete). Same-stance vs open-stance flips which hand is the "long" hand and which body kick is free. Do **not** add switch-hitting as a third stance until a fighter has an authored switch skill (we already have `mma_stance_switch` as a node). Guard *height* (high / long / peekaboo) can wait; it is a skill we already own (`boxing_stance_guard`, `boxing_shoulder_roll`) and should become a **pose loop**, not a new attribute.

---

## D4 — Footwork

Coaching (same manuals): **the foot closest to the direction of travel moves first**; never cross; restore width. Four atoms: forward step, back step, lead-side step, rear-side step. Then: punch from stance → punch with each step → two punches as a combination, standing then moving.

Davis's **47 hip movements / min** *are* the fight. They are the bob, the step, the reset. We model "who wants the band" as speed 0.45 + IQ 0.35 + conditioning 0.20 + reach 0.35, once per exchange. That picks a winner. It does not *show* walking a man down, cutting the ring, or circling off the rear hand.

Ring geography we do not have (and C17 forbids as coordinates in v1):

| Real | Ours |
|---|---|
| Centre vs ropes vs corner | Nothing |
| Cutting off the ring (`boxing_cutoff_ring` is a skill) | Adaptation role, no spatial effect |
| Pivot off the line (`boxing_pivot_footwork`) | Adaptation / push-marker (delta −1) |
| Lateral circle vs pressure walk-down | Hidden contest |

**D4 ruling:** keep Q3 — no XY. Add a **ring-place enum** of four values: `CENTRE`, `NEAR_ROPES`, `CORNER`, `ON_CYCLE`. Pressure + win-range steps you toward ropes/corner; adaptation/pivot/teep steps you back to centre or onto the cycle. Presentation uses that enum for camera and footwork clip. That is C18's "cheap middle" applied to the ring instead of the ground.

---

## D5 — Defense is an event, not a stat

Learned defense (stance, shoulder roll, slip, check, sprawl) only changes `defense_factor`. The log never says "Cole rolled the overhand." Davis: winners used **less** defense in R2 and landed more — dominance looks like *making the other man miss without looking busy*.

**D5 ruling:** when a strike misses, emit `defense_used` from the defender's learned defense nodes at this band (slip at LONG/MID, roll at POCKET, check vs kick, sprawl vs shot). Presentation plays that clip. The sim outcome stays "missed." No second roll that can overturn a land.

---

## D6 — Combinations and the jab

Kapo: lead straight to the head 29%, lead hook 23% of amateur attacks. Davis: 2-punch combos rise mid-bout; triples score well with judges even when they do not all land. Our 39 sequences are the right object. They are rare because `CHAIN_STAMINA_RESERVE` and per-link gas make a four-link a commitment.

The everyday "flow" combo is not a tier-4 sequence. It is **jab → something**. CompuBox's jab-share vs power-share is the statistic players already understand from broadcasts.

**D6 ruling:** give every standing exchange a **default 1–3 link burst** (jab then the drawn power/setup/counter), separate from authored `sequence` nodes. Authored sequences stay the special case (liver combo, Dutch four-strike). Burst links inherit the same band gate so a pocket hook cannot start at LONG.

---

## D7 — Clinch is time

Davis: clinch frequency and duration **rise every round** (fatigue + holding). WAKO K-1: active clinch often **5 seconds**, then break; some revisions forbid holding entirely. Unified MMA: clinch is a fighting position with its own strike split. Our CLINCH band can last many exchanges with no referee.

**D7 ruling:** standing CLINCH accumulates `clinch_s`. Boxing/kickboxing: a ruleset cap (3–5 s of inaction, or one strike then break) forces a break-to-MID event. Muay Thai: clinch scores and may persist. MMA: clinch is a position, not a cap. This is a **ruleset table**, not a new phase.

---

## D8 — Ground is positions, not a coin

STANDING / GROUND + top_side is too thin for MMA/BJJ/wrestling feel. UFC Stats already splits strikes by Distance / Clinch / Ground and publishes control time.

**D8 ruling (Q3 cheap middle, already named by C18):** `ground_position` enum — `FRONT_HEAD`, `GUARD`, `HALF`, `SIDE`, `MOUNT`, `BACK` — plus `control_s`. Transitions and submissions already exist as roles. Do not add coordinates. Do not simulate hips.

---

## D9 — What a "real" stat block would add (and what not to)

Player-facing, broadcast-shaped. Not new combat physics.

| New read | Feeds | Do not |
|---|---|---|
| Output / min (thrown) | Pace, conditioning, stamina, plan | Let it change who wins except through existing land rolls |
| Connect % | Already implied by land/miss; **print it** | A second accuracy stat |
| Jab share / power share | Plan + band (LONG jabs, POCKET power) | A "jab" attribute |
| Defense used / min | D5 events | A second defense stat |
| Distance / clinch / ground % time | Band + phase clocks | XY tracking |
| Control time | D8 | Positional points unless the ruleset already scores them |
| TD attempts / acc | Existing takedown role | A wrestle stat besides `grapple` |
| Stance matchup | D3 | Switch as a hidden coin |
| Ring place | D4 enum | A "ring IQ" stat — `fight_iq` already owns generalship |

**Refuse:** adding attributes beyond the seven. The missing feel is **event granularity and clocks**, not a new 0–100.

---

## D10 — Diet and making weight

We have walking weight, three diet rates, a 3% free water-cut, then stamina/chin, miss fine 20%, emergency/withdraw. England Boxing L1 handbook (2026 Part 1) already owns the gym-side advice: carbohydrate as main fuel (~60%), 30 g fibre/day, no extreme dehydration, matching by age/weight/height, **no sparring while dehydrated** (tracking and decision-making drop).

ISSN 2025 position stand (PMC11894756, open PDF):

- Camp walking weight often **12–15% over** class (our `walk_over_limit` is 5–11% — conservative, keep it).
- Safe acute loss windows: **6.7% / 72 h, 5.7% / 48 h, 4.4% / 24 h**.
- Fight-week water-loss **~2–4% in 24 h** under supervision; our free band is 3% — compatible.
- Floors: CHO 3–4 g/kg, protein 1.2–2.0 g/kg, fat 0.5–1.0 g/kg.
- Post-weigh-in: ORS 1–1.5 L/h, then ≤60 g/h fast CHO; regain **≥10%** of lost mass before the bell when the cut was large.

**D10 ruling:** do not add a calorie minigame. Optionally print a **camp plate** (CHO / protein / water) as authored copy on Fight Camp, sourced from ISSN + England Boxing, not as sim knobs. The night penalty we have is the playable fact. Amateur boxing daily weigh-in (IBA Technical Rules) is a different protocol from pro MMA 24–36 h rehydrate — already a ruleset split we should not flatten.

---

## D11 — Training that produces the fight

England Boxing L2 handbook day plan is the gym we already metaphorically own: stance/guard/footwork → straights + defenses → hooks/uppercuts + defenses → padwork → sparring (L2+ only) → circuits / running / skipping.

USA Boxing teaching **sequence** (the animation production order):

1. Punch from stance, still feet  
2. Same punch with forward step  
3. Backward step  
4. Side steps  
5. Two punches as a combo, still, then moving  

Heavy bag purpose in the same manual: **range awareness + circular footwork**, bag should wobble not swing (snap, don't push). Double-end = timing/range. Maize bag = head movement with feet planted. Mirror = stance audit.

**D11 ruling:** Move Lab already trains a node. The missing training→fight link is **which family you grooved this camp** (jab share, check rate, shot entries). A camp that logged 80 reps of `boxing_jab` should raise jab-share in the burst mix, not a hidden accuracy. We already persist `technique_progress`. Read it at `begin_fight`.

---

## D12 — Animation: what "real" requires on the 3D screen

C17 is still the architecture. This section is the **clip list the coaching books imply**, not a new scene tree.

**Bind pose** = the 11-point stance (D3). `walk_relaxed` is locomotion, not a fight guard. Need `idle_guard` before any strike pack.

**Punch timings** (Lenetsky / Chester 3D kinetics, amateur max-effort): jab delivery **~405 ms** (shortest); lead hook highest peak fist velocity (~12 m/s). A 1.4 s window holds **idle → 2–3 punches → recover** without changing sim cadence.

**Minimum clip library (retarget onto the existing 22-bone Godot humanoid):**

| Clip | Why | Source of shape |
|---|---|---|
| `idle_guard` | Every reset | AIBA 11-point stance |
| `walk_relaxed` | Have it | Ludo |
| `step_fwd` / `step_back` / `step_lead` / `step_rear` | D4 atoms | USAB-GTF boxing steps |
| `jab` / `cross` / `hook` / `uppercut` / `overhand` | Band-correct offence | Same manuals' punch chapters |
| `slip` / `roll` / `cover` / `check` / `evade` | D5 | Davis defense classes |
| `hit_react_head` / `body` | Landed | Presentation only |
| `clinch_enter` / `clinch_knee` / `break` | D7 | WAKO 5 s / Thai |
| `level_change` / `td_finish` / `sprawl` | Takedown family | Wrestling/UWW |
| `guard_pass` / `mount` / `back_take` / `sub_hold` | D8 table | IBJJF positions |
| `recover_stance` | Safe-pose for pause (C17 Q2) | Return-to-stance, every punch chapter |

Map via **glyph family → clip**, then `technique_id` override. Sequences play `chain`. Bursts (D1/D6) play 1–3 clips inside the host interval.

**Hard art limits already ruled in-repo:** no finger bones (bare fist decision — R76); no BoneMap (keep Godot profile names); ripped packs stay scratchpad; females never share a cage with males.

---

## Recommended build order (for Claude to slice)

1. **Fix the family map** — `defense` → `evade`/`cover`; setup → `feint_setup` already in RingStagePanel. One-line, unblocks honest clips.  
2. **Burst payload on the existing event** (D1, D6) — thrown/landed/jab_share/defense_used/steps. Headless tests; RingStagePanel can ignore it.  
3. **Print the broadcast stats** on the move strip / post-fight (connect %, jab share, time at band). Data we already almost have.  
4. **Stance matchup** (D3) — open vs closed weights on jab vs rear-hand / body kick.  
5. **Clinch clock + ruleset break** (D7).  
6. **Ground position enum + control_s** (D8) — C18 cheap middle.  
7. **Ring-place enum** (D4) — still no XY.  
8. **C17 Stage 0** — SubViewport + two fighters + `idle_guard` + walk + one strike family. Operator still owes Q1/Q2.  
9. **Clip pack** in the USA Boxing teaching order (stance → steps → punches + steps → combos).  
10. Diet copy (D10) only if Fight Camp is opened for flavour — not a sim rewrite.

---

## PDF and schematic library

Official or peer-reviewed. Prefer these over blog writeups. Several are **already cited** in `technique_catalog.json` `sources`.

### Technique, stance, footwork, distance (schematics live here)

| Doc | URL | Why we need it |
|---|---|---|
| England Boxing Coaching Handbook Part 1 (Feb 2026) | https://www.englandboxing.org/wp-content/uploads/2026/02/EB_Boxing-Coaching-Handbook-Part-1_09_02_26.pdf | Stance/guard/footwork as coaching cornerstones; nutrition/hydration/weight; sparring safety (no sparring dehydrated); matching by age/weight/height |
| England Boxing Level 2 Coaching Handbook | https://www.englandboxing.org/wp-content/uploads/2022/03/Level-2-Coaching-Handbook-compressed.pdf | Day plan: stance → straights → hooks/uppercuts → padwork → sparring → periodisation |
| USA Boxing GTF Training Manual | https://d36m266ykvepgv.cloudfront.net/uploads/media/lYivrDbNV6/o/usab-gtf-trainingmanual-v-01-1.pdf | **Best schematic set:** 11-point stance, step-drag, long/medium/short definitions, punch-by-punch return-to-stance, bag purposes |
| AIBA Coaches Manual (2019) | https://www.iba.sport/wp-content/uploads/2019/01/AIBA-Coach-Regulations-Manual_WEB_2019_01-1.pdf | Same technique chapters plus Europe/Russia/USA/Cuba **style variants** (stance/footwork/feint/tactics) — use for national-school flavour, not new rules |
| AIBA Coaches Manual mirror (FR) | https://frbox.ro/wp-content/uploads/2008/01/COACHES_MANUAL_part1.pdf | Same Part 1; nutrition ch.4, advanced techniques ch.5 |
| England Boxing coaching hub | https://www.englandboxing.org/coaching-resources/ | Index if the dated PDF moves |

### Rules (distance legality, clinch caps, weigh-in)

| Doc | URL | Why |
|---|---|---|
| ABC Unified Rules of MMA (Jul 2024) | https://www.abcboxing.com/wp-content/uploads/2024/07/unified-mma-rules-rev-july-2024.pdf | Rounds, classes, catchweight 5 lb, fouls. Catalog already cites the 2023 file. |
| ABC Unified Rules of MMA (2023) | https://www.abcboxing.com/wp-content/uploads/2024/01/Unifed-CMA-Rules-2023-FINAL.pdf | Same family; keep for diff. |
| IBA Technical & Competition Rules | https://www.iba.sport/wp-content/uploads/2022/02/IBA-Technical-and-Competition-Rules_20.09.21_Updated_.pdf | Daily weigh-in, FOP, knockdown — amateur boxing is not a 24 h cut. |
| WAKO K-1 style (v17.4 / national copies) | https://wakousa.org/wp-content/uploads/2025/05/K1-Rules.pdf | Legal techniques; **5 s active clinch** in some texts; later "no clinch" revisions — ruleset table, do not pick one silently. |
| WAKO 2022 revision (catalog source) | https://wako.sport/wp-content/uploads/2022/10/WAKO-Rules-25.10.2022.-revision-3.pdf | Already in `technique_catalog.json`. |
| UWW Grappling Rules 2024 | https://cdn.uww.org/2024-01/grappling_rules_2024.pdf | Catalog source; ground/clinch scoring. |
| IBJJF / IJF / WT / WUKF / IWUF / FIAS / FFSavate / i-ARNIS / PERSILAT | (URLs already on the catalog `sources` object) | Do not resource; use for legality we already store. |

### Activity profiles and punch science (the flow numbers)

| Doc | URL | Why |
|---|---|---|
| Davis et al. 2015, *IJSPP* 10:53–57 | https://journals.humankinetics.com/view/journals/ijspp/10/1/article-p53.xml | **The cadence paper.** 1.4 actions/s; 20 punches / 2.5 defenses / 47 hip moves per min; clinch time by round. |
| El-Ouarti / Lenetsky punch kinetics (ChesterRep PDF) | https://chesterrep.openrepository.com/server/api/core/bitstreams/3e769a4f-d46b-4921-a2e9-093e0a80e436/content | Jab ~405 ms; hook peak velocity; 3D kinetics for clip timing. |
| Dinu et al. 2020, *Front. Sports Act. Living* | https://www.frontiersin.org/articles/10.3389/fspor.2020.598861/full | Cross/hook/uppercut junior vs elite; cites Davis 1.55 actions/s. |
| CompuBox leaderboards | https://app2.compuboxdata.com/reports/93 | Thrown/landed per round, connect %, jab vs power — broadcast stats to print (D9). |
| UFC Stats definitions | https://www.ufc.com/athlete/georges-st-pierre (any fighter page) | Sig. strikes = all at distance + power in clinch/ground; SLpM, TD avg, ctrl time. |

### Diet / weight cut

| Doc | URL | Why |
|---|---|---|
| ISSN 2025 position stand | https://pmc.ncbi.nlm.nih.gov/articles/PMC11894756/ | Open full text. 12–15% walk-over; 2–4% 24 h water; macro floors; ≥10% regain. |
| ISSN publisher PDF | https://www.tandfonline.com/doi/pdf/10.1080/15502783.2025.2467909 | Same paper, paginated. |
| England Boxing L1 §2.7 | (Part 1 PDF above) | Club-safe nutrition; **refuse extreme making weight**. |
| Frontiers 2025 MMA WMP (n=31) | https://www.frontiersin.org/articles/10.3389/fnut.2025.1581698/full | 10.6% in 7 days, 11.2% regain in 30 h — evidence, not a target to copy. |

### Animation / retarget (engine, not ripped packs)

| Doc | URL | Why |
|---|---|---|
| Godot Animation / AnimationTree | https://docs.godotengine.org/en/stable/tutorials/animation/introduction.html | Blend spaces for step+punch; AnimationTree for guard↔strike. |
| Godot SkeletonProfileHumanoid | https://docs.godotengine.org/en/stable/classes/class_skeletonprofilehumanoid.html | Why our 22-bone, no-BoneMap gate exists. |
| Godot Retargeting | https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html | How a commissioned clip lands on all twelve fighters. |
| Mixamo (licensed, receipt required) | https://www.mixamo.com | Last-resort locomotion; C17 already prefers Ludo humanoid library. **No ripped game anims.** |

---

## Refusals

- **No XY combat.** C17 Q3 / C18. Enums (ring-place, ground-position) only.  
- **No 272 unique mocaps.** Glyph family → clip, then signature overrides.  
- **No eighth attribute.** Output and clocks, not another 0–100.  
- **No calorie minigame.** WeightCut stays the playable cut.  
- **No player-puppeted limbs.** AI vs AI; corner requests; C17.  
- **No ripped animation packs.**  
- **No invented cage apron** on `mma_cage_abc_18ft`.  
- **Do not flatten amateur daily weigh-in into a pro 24 h cut.**  
- **Do not treat WAKO clinch as one number** — versions disagree; store per ruleset.  
- **Do not reopen C17 Q1/Q2/Q3** in this document. Burst payloads work *inside* an atomic exchange.

---

## What this is not

Not a task file. Not a clip commission. Not permission to edit `FightSimulation.gd` or `GameState.gd` from Cursor. Claude slices D1–D12. Operator still owns Q1/Q2 before Stage 0 of the 3D body.

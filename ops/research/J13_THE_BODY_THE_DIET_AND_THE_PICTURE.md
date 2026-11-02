# J13 — The Body, the Diet, and the Picture of a Fighter

**Desk:** John (research)  
**Date:** 2026-09-07  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design.  
**Verification date for all live URLs in this file:** 2026-09-07 unless a source is dated otherwise.  
**Grade vocabulary (from J1, restated in J10–J12):** `DIRECT` = a primary PDF, commission regulation, federation rulebook, or peer-reviewed dataset states the fact. `INHERITED` = copied from a parent standard or from general (non-combat) physiology and labelled as such, not claimed as that sport’s published number. `UNVERIFIED_SECONDARY` = media, blogs, commercial analytics, Wikipedia, books without a methods paper. `UNKNOWN` = no source. **A number without a source is UNKNOWN by definition.**

**J1 map used on every D-ruling:** `evidenced` ↔ DIRECT. `inferred` ↔ INHERITED (parent literature, labelled). `authored` ↔ a game-shape decision that is not a measured sport number; if a number is still proposed it is labelled UNKNOWN. A ruling that cannot be written as “the game does X, never Y” is research, not a ruling, and lives in the discussion.

**What this file is:** three areas the operator asked for on 2026-09-07, in one numbered instrument. Area A is the treatment of body parts. Area B is whether diet belongs. Area C is the full picture of a fighter (stats) plus the J10 peak-window call that was left open.

**Cite; do not re-derive:**

| Binding | What it already ruled | This file’s job |
|---------|----------------------|-----------------|
| J12 D1 | `Aging.recovery_scale()` is not a researched number | Do not invent a per-region heal rate and call it sourced |
| J12 D2 | Training-load recovery ≠ injury healing | Keep them as two objects under named injuries |
| J12 D4 | No 30/33 age cliff | Do not resurrect it as a body-part kink |
| J12 D5 | Years ≠ mileage | Clearance/risk may key off both; healing does not collapse to birthday |
| J12 D7 | “Older is more sore” is not law | Do not encode camp-soreness-by-age as physiology |
| J12 D8 | RTS *odds* ≠ weeks-to-heal | Kingery-class booking intervals are not tissue clocks |
| J12 D9 | Concussion hold days are not age-scaled | A per-region model may not quietly scale them either |
| J10 D6 | Do not average sexes | Injury tables, diet flags, stats, and peak windows stay split |
| J10 D8 | Medical hold outranks chin folklore | Area C does not add a `chin` stat |
| J10 D1–D3 | Peak is a window; no yearly game-stat deltas as facts | Area C answers the leftover “one window or many” call; does not reopen yearly deltas |
| R54 | Extra CLEARANCE at age/mileage, never longer hold days | Named injury may *set* `medical_hold_until_week`; age still does not multiply it |
| Live design | Age does **not** scale healing, deliberately | Restated. Not reopened. |

---

## Operator-facing summary

The game already has six body regions, each a 0–100 readiness integer, one medical clock (`medical_hold_until_week`), a camp cut-plan that sets two scalars, and six athlete stats that do not distinguish a wrestler from a boxer. This desk’s job is to say what to build, what to refuse, and what must stay labelled UNKNOWN.

**Area A.** A torn hamstring, a broken hand, and a concussion are not the same number. The honest encoding is: **keep the six-region readiness NUMBER for training-load (J12 D2), and attach a NAMED INJURY object when tissue is actually injured.** The injury owns the timeline and may set the existing hold clock. It is not a second medical clock. Distinguish a short taxonomy of types (contusion, laceration, concussion/RHI, fracture, muscle strain, ligament/joint, dislocation, ocular/orbital), **keyed by discipline**, never averaged across boxing and BJJ. Commission ladders and a handful of surgical series give compete-dates; most train-dates and nearly all dollar costs are UNKNOWN. Permanence is sourced for accumulating head-injury exposure and for cauliflower ear as tissue; “the hand never comes back” and an isolated chin are folklore. Age still does not scale healing.

**Area B.** Diet belongs as a **weekly PLAN plus a standing DISCIPLINE**, or not at all. It does **not** belong as a calorie counter, a macro tracker, a food inventory, or a screen where the player types a nutritionist’s numbers. Comparable management games that last (Football Manager, OOTP, F1 Manager) do not make the player log food; they bury lifestyle in professionalism/condition, or omit it. What is sourced in the sport is making weight, post-cut rehydration, and LEA/REDs as a syndrome (especially bone). Nutrition is **not** sourced strongly enough to move a per-region heal clock. If year-round diet ships, it **feeds** the two camp cut-plan scalars; it does not replace them.

**Area C.** One stat set for every discipline. That is the expensive call and it is settled here: a second table per discipline is the wrong cost. The six live stats plus per-discipline proficiency already answer “is this a wrestler.” What they do not answer is **who imposes the phase of the fight**. The only first-wave addition this desk will defend is a grappling-imposition attribute (working name `GRAPPLE`), with `PRESSURE` as the only second-wave candidate. Do not add chin, footwork, flexibility, strength-split-from-power, or cardio-split-from-conditioning. Ceiling: **8–10 visible stats on the athlete card**. Football Manager’s ~36 is the genre’s warning, not its target. J10’s leftover peak-window call: **one window per discipline and sex where J10 already sourced a window; remaining disciplines stay UNKNOWN**, not invented.

**Build first:** named-injury object on the existing six regions + one hold clock (A); leave diet as camp cut-plan unless the operator insists, in which case a weekly plan/discipline flag (B); add at most one grappling attribute, keep one stat set (C).

**Refuse first:** whole-body age multiplier; unsourced heal rates dressed as citations; a second medical clock; a gruesome injury simulator; a calorie counter; hidden stats; a second potential axis; a chin stat.

---

# AREA A — The treatment of body parts

**Operator decision this pass answers:** model recovery per BODY PART realistically. A torn hamstring, a broken hand, and a concussion are not the same injury slowed by the same factor.

**What the game has today (assignment fact, not re-read in code):** six regions (`head_neck`, `torso_core`, `left_arm`, `right_arm`, `left_leg`, `right_leg`); each one 0–100 readiness integer; damage/recovery by activity; forecast weeks; **no named injuries**; one `medical_hold_until_week`; age does not scale healing; hit-history ledger per region.

## A. Decisions / rulings

| # | Call | The game does X, never Y | Grade (J1 map) | Why (one line) |
|---|------|--------------------------|----------------|----------------|
| **DA1** | Shape | A region carries a readiness **NUMBER** and, when tissue is actually injured, a named **INJURY**. The injury owns the timeline. The number is never the only object for a tear, a break, and a concussion. | **authored** as encoding; **DIRECT** as the sport fact that these are different objects | Epidemiology, commissions, and surgical series treat type, not a 0–100. Collapsing them is the current bug. |
| **DA2** | Taxonomy | Distinguish a **short** list of types (DA2 list below), **keyed by discipline**. Never a universal frequency table averaged across boxing and BJJ, or across sexes (J10 D6). | **DIRECT** as the sport pattern; **authored** as the reduction to eight types | Head/cut/hand in striking; knee/shoulder/elbow in grappling. Averaging them is a data crime. |
| **DA3** | Two clocks | Training-load soreness (readiness number, no name) stays **separate** from named-injury healing. Never apply one slope to both. | **INHERITED** from J12 D2 (evidenced as the literature split) | Q1 EIMD and Q2 RTP disagree. A bruised thigh from sparring is not an ACL. |
| **DA4** | One hold | Named injury may **set** `medical_hold_until_week`. Never a second medical clock beside it. Amateur suspension and the hold remain the same object. | **authored** as encoding; **DIRECT** as how commissions actually work | NYSAC/NSAC/World Boxing issue one suspension, not a tissue clock plus a licence clock. |
| **DA5** | Train ≠ compete | Return-to-**training** and return-to-**competition** are different dates. Never use the commission hold as the gym-return date, or the physio’s “light bag work” date as the licence date. | **DIRECT** | ARP no-sparring window = hold; BBBoC facial 28 d is a *licence*; NHS broken-nose 6 weeks is *contact*. They are not the same number. |
| **DA6** | Who clears | **Compete** is cleared by the commission / ringside physician (plus specialist when the hold says so). **Train** is cleared by the gym’s own doctor/physio. The manager never clears. | **DIRECT** | NYSAC 2024; NAC 467.562; World Boxing / USA Boxing handbooks; ARP eye 2025. |
| **DA7** | Manager vs happen-to-them | The manager chooses rest-vs-camp, elective surgery vs conservative, and whether to take a fight on an amber region. Commission holds, ringside stoppage, mandatory admin rest, and specialist gates **happen to them**. | **DIRECT** as the authority split; **authored** as which buttons exist | A manager does not negotiate a KO ladder. A manager does decide whether to pay for ACLR. |
| **DA8** | Costs | Model an injury as **weeks + lost prep + a cash event**. Never model an injury as a delay with no price. Dollar amounts are **UNKNOWN** as a sourced table; author a band and label it. | **DIRECT** as weeks where a protocol exists; **UNKNOWN** as dollars | Kingery 6.8 months is a *booking* interval. UFC ACLR ~412 days is a *next-fight* interval. US hospital bills are not a combat-sport wage table. |
| **DA9** | Permanence | Accumulate **head-injury exposure** (fight count / FES / KO ladder) as a career object. Cauliflower ear may persist as flavour on `head_neck`. Never encode “the hand never returns” or a declining `chin` as physiology. | **DIRECT** on RHI/cognition and on cauliflower as tissue; **UNKNOWN** as a hand-function law; J10 D8 on chin | PFBHS / Ritter 2022; StatPearls cauliflower. Boxer RTP after hand surgery is high (Matharu 98%). |
| **DA10** | Age | Healing clocks stay **age-blind**. Extra **clearance** at age/mileage (R54). Never a whole-body age multiplier, never an age-lengthened KO hold, never a 30/33 kink. | **INHERITED** from J12 D1, D4, D9 + R54 (evidenced as the rules) | No sourced `recovery_scale()`. Commissions add tests, not days. |
| **DA11** | Simulator | This is a **management** game. Never a gruesome-detail injury simulator, never ICD-10, never cinematic surgery. | **authored** | Operator refuse list. Epidemiology supports types, not viscera. |
| **DA12** | Draw | Injury *type* and *region* are drawn from the athlete’s **discipline** (and amateur/pro). Never one global loot table. | **DIRECT** as pattern; **authored** as the draw | Lystad 2021: boxing 62% head/neck vs taekwondo 4.8% head/neck and 59.5% lower limb. |

**J1 map on the table:** DA1/DA4/DA11 encoding = authored. DA2/DA5/DA6/DA12 sport facts = evidenced (DIRECT). DA3/DA10 = inherited from J12 (inferred from parent rulings + the same literature). DA8 dollars and DA9 hand-function = UNKNOWN where numbered.

## A. Answers to the seven questions

### A1 — What is actually injured (taxonomy)

**Short answer:** The six regions are a usable skeleton. They are not a diagnosis. Combat athletes present with a **small set of named types** whose mix **changes by discipline**. A management game must distinguish those types. It must not distinguish every ICD code.

**Do not average (J10 D6 / J12 D6):** amateur ≠ pro; boxing ≠ BJJ; male-heavy MMA samples ≠ women’s books; competition-night ringside cards ≠ training-room surveys. Head-heavy percentages in MMA/pro boxing are **fight-night physician** numbers (cuts and concussions get written down). Training surveys in grappling are **knee and shoulder**. Both are real. They are not one table.

#### What the literature actually measures (DIRECT, by setting)

| setting | head/neck | upper limb | lower limb | trunk | grade | source |
|---------|-----------|------------|------------|-------|-------|--------|
| Olympic boxing / judo / TKD / wrestling, 3 Games, 7,712 AE | **35.9%** overall; boxing **62.1%**, judo 25.5%, wrestling 18.2%, TKD **4.8%** | overall 31.1%; judo **42.6%** (elbow 19.1%) | overall 26.3%; TKD **59.5%**, wrestling 45.5% | overall ~7% | **DIRECT** | Lystad et al. 2021 *BJSM* |
| MMA competition meta (pre- and post-Unified Rules) | **66.8–78.0%** (Lystad 2014); post-URM **29.5–75.9%** | wrist/hand **6–12%** (2014); upper **11.1–56.4%** (2025 range) | 8.6–20.2% (2025 range) | small | **DIRECT** | Lystad 2014 *OJSM*; Zachovajevas 2025 *OJSM* |
| Pro boxing pathology pooled | concussion **12.3%**; laceration **21.4%** | — | — | — | **DIRECT** as type mix, not region | Mao et al. 2023 *OJSM*: also contusion 30.2%, sprain 15.3%, fracture 11.4% |
| US ED boxing 2000–2023 | head/neck 22.5% | **upper extremity 65.0%** | lower more sprain/strain | trunk 7.9% | **DIRECT** to ED (training+fight, not elite cards) | *Phys Sportsmed* 2026 boxing-NEISS |
| Boxing MSK 2004–2023 national estimate | face 12.2%, head 5.9% | **hand 32%**, wrist 12%, shoulder 9.3%, finger 8.5% | — | — | **DIRECT** as ED MSK | ORS 2025 abstract |
| Australian MMA + Muay Thai events, self-report 14 mo | 16% of injured regions | 17.1% | **61.3%** overall; **70.4% in MT**, 34.8% in MMA | rest | **DIRECT** as event HP, different definition from ringside | Stannard et al. 2025 *Sports Med Open* |
| BJJ, 881 practitioners, 12 mo | not the lead | shoulder **13%** | **knee 25%** | — | **DIRECT** | Stegerhoek et al. 2025 *BMJ Open SEM*; 89% of injuries in **training**, 79% of those in sparring |
| UK grappling (mixed), 341 athletes | — | shoulder/clavicle 14.1% | **knee 24.5%** | — | **DIRECT** | 2026 self-report audit; major (>28 d) **49.5%** |
| Pencak silat (Indonesian schools/clubs) | 15.2% (FICS slide citing Shapie 2018) | 32.6% | **41.4%** | 10.8% | **UNVERIFIED_SECONDARY** as the slide; underlying papers exist | FICS 2025 Pollard deck; Razak 2017 / Shapie 2018 |
| Capoeira (cross-sectional) | — | shoulder ~9% | **ankle 21%, knee 17%** | lumbar 9% | **DIRECT** as one sample, not elite combat | *Healthcare* 2023, 61% lifetime prevalence |
| Karate competition meta | head/neck median **57.9%** | low | low | — | **DIRECT** | Lystad 2020 *BJSM*: contusion median 68.3%, laceration 18.6% |

**Swedish Olympic insurance (different object — claims, not ringside):** boxing claims **hand/wrist 40%**, shoulder 12.5%; judo **knee 29.2%**, shoulder 22.9%; wrestling **knee 34.3%**; taekwondo **foot/ankle 36.8%**. DIRECT as insurance location, not fight-night incidence (PMC10471666).

**Amateur vs pro (do not average):** Lystad 2014 MMA IIR_AE 228.7/1000 AE vs judo 44, TKD 79.4, amateur boxing 77.7, pro boxing 118–250.6. Mao 2023: professional boxing IRN **399.8** vs lower amateur/female groups. Fares 2014 Nevada: 17.1 injuries/100 pro boxing matches; men KO more than women (*P*<0.001). DIRECT as the split. **Do not ship one injury-rate for “combat.”**

#### The eight types a management game must distinguish

These are the named injuries. Everything else is flavour text on top of one of them.

| type_id | what it is | regions it actually lives on | which disciplines present it | why the game must name it (not just drop a number) |
|---------|------------|------------------------------|------------------------------|-----------------------------------------------------|
| `contusion` | bruise / haematoma / “pain without tissue type” | any; shins/thighs in MT; torso from body shots | all; **dominant in MT/TKD/karate competition** | Days, not weeks. No commission hold. Training-load adjacent. If unnamed, every bruise becomes a “injury.” |
| `laceration` | cut, usually periocular / scalp | `head_neck` almost always | boxing, MMA, kickboxing, MT, karate | **Stops a fight** (cutman vs physician). Stitches/glue. Hold 14–60 d typical. Train ≠ compete. |
| `concussion_rhi` | SRC, KO, TKO-from-head, RSC-H | `head_neck` only | striking sports; judo/karate via throws/falls too | **Commission ladder.** No sparring for the same window (ARP). Age-blind (J12 D9). Not a bruise. |
| `fracture` | bone: metacarpal, nasal, orbital, rib, tibia | arms (boxing hands), head (nasal/orbital/mandible), legs (checks), torso (rib, rare) | boxing hands; MMA orbital > boxing (ARP eye 2025: 17.6% vs 3.1% of ocular); MT lower-leg | Immobilisation or ORIF. Imaging. Specialist clearance. Weeks-to-months. BBBoC facial **≥28 d** licence. |
| `muscle_strain` | grade 1–3 muscle/tendon | legs (hamstring, calf, groin, hip flexor); lumbar; shoulder cuff as strain | all training rooms; less of the fight-night card | Grade owns the weeks, **not age** (J12). Conservative. Physio. Reinjury if you treat it as a bruise. |
| `ligament_joint` | sprain, MCL/ACL/LCL, scapholunate, AC, labrum-as-stability | knees, shoulders, elbows, ankles, wrists | **BJJ/judo/wrestling/MMA grappling**; TKD ankles | Conservative vs surgery is a **manager decision**. ACL is a season. MCL often is not. |
| `dislocation` | glenohumeral, elbow, finger, patella | arms, occasionally legs | judo, wrestling, BJJ, MMA | Reduction (happen-to-them) then stability program. Recurrence is the career object, not the first pop. |
| `ocular_orbital` | hyphema, retinal injury, orbital blowout, lid-margin cut | `head_neck` | boxing and MMA (ocular IR 9.7 and 12.2 / 100 matches, *BMJ Open* 2025) | **Ophthalmologist** gate. ARP 2025: absolute monocular vision is a striking-sport contraindication. Can end a licence. |

**Types the game should *not* promote to first-class objects:** cauliflower ear (flavour + optional permanence on `head_neck`, see DA9); dental (cost flavour); skin infection (ARP 2024 position exists; out of scope for body-part healing); CTE as a live stat (career exposure object, not a region); “stinger”; every finger sprain.

**Sanda, sambo, savate, arnis:** **UNKNOWN** as a peer-reviewed region×type table comparable to Lystad. Sanda 2025 Brazilian championship: hamstring/adductor strains and facial lacerations, IR 3.37/1000 h — one tournament sample, not a game table. Combat sambo injury rate 14.9/100 fights appears only on a 2025 conference slide (UNVERIFIED_SECONDARY). **Do not invent a sambo taxonomy.** Inherit the nearest parent: sambo ← judo/wrestling mix; sanda ← kickboxing+throw mix; savate ← kickboxing; arnis/silat ← silat lower-limb lead, labelled INHERITED/UNKNOWN.

**Frequency the game can defend:** not a single percent. Use **discipline family** as the draw weight:

- Striking fight-night (boxing, kickboxing, karate, MMA stand-up): `laceration` + `concussion_rhi` + `contusion` lead; `fracture` of hand/face next.  
- Grappling (BJJ, judo, wrestling, sambo): `ligament_joint` (knee, shoulder, elbow) + `dislocation` lead; head is neck/cauliflower/throws, not cuts.  
- Kick-sports (TKD, MT, sanda): `contusion` + lower-limb `ligament_joint`/`fracture`.  
- MMA: union of both; ringside cards still head-heavy because cuts are written down.

Exact draw weights: **UNKNOWN**. Author them, label `grade: UNKNOWN`. Do not cite Lystad’s 62.1% as a game probability for every boxing session — that is Olympic *competition* injuries among recorded injuries, not P(cut | week).

### A2 — What treatment IS

Split every treatment on two axes: **does it change the timeline, or only the cost?** and **does the manager choose it, or does it happen to them?**

| treatment | timeline? | cost? | who decides | grade | notes |
|-----------|-----------|-------|-------------|-------|-------|
| Rest / activity modification | **Yes** — this *is* the conservative clock | lost prep; low cash | **Manager** (and the gym) | INHERITED as clinical common sense; DIRECT as “individualized MSK clearance” (ARP 2024) | The game already has rest / light work / recovery facility. Keep it. |
| Ice / RICE / NSAIDs | **No** as a sourced weeks-delta | pennies | Gym; not a meaningful button | INHERITED | Flavour. Do not sell “ice pack −2 weeks.” |
| Immobilisation (splint, cast, buddy tape) | **Yes** for fracture / grade-2+ sprain | modest cash + lost striking/grappling on that limb | Clinician; manager accepts | INHERITED (boxer’s fracture 3–6 weeks immobilisation is textbook) | Fifth-metacarpal neck often *less* restriction, not more (2025 RCT review). |
| Glue / Steri-Strip / subcuticular suture | **Yes** for *compete* (wound must be closed); short for *train* | low; cutman 2–3% of purse is UNVERIFIED_SECONDARY (Wikipedia) | Ringside / ER — **happen-to-them** | **DIRECT** as amateur tournament rules | England Boxing: 14 d simple laceration; **cannot compete with sutures in situ**; glue may allow next-day *in that tournament only*. USA/World Boxing: subcuticular/glue/strips required to continue a tournament. |
| Cutman (adrenaline, swell-stop) | **In-bout only** — does not shorten the post-fight hold | % of purse, UNVERIFIED | Corner — happen-to-them in the fight, hired by manager in camp | UNVERIFIED_SECONDARY as economics | Stops the *stoppage*, not the healing. |
| Physiotherapy / loading | **Yes** for muscle/ligament — criteria-based RTS, not calendar | ongoing cash, **UNKNOWN** as a fighter table | **Manager** hires; physio clears *train* | INHERITED (Close/Tipton rehab nutrition; combat physio blogs are SECONDARY) | This is the actual conservative path for MCL, cuff, hamstring. |
| Injection (cortisone, PRP) | **UNKNOWN** as a weeks-delta in combat | cash | Manager + doctor | **UNKNOWN** | Matharu 2022: pre-op steroid into MCP associated with the only non-return. Do not encode “injection = faster.” |
| Surgery (ORIF, ACLR, labral repair, extensor-hood, CMC fusion) | **Yes** — months | large cash, **UNKNOWN** as a sourced fighter mean | **Manager elects** when both paths exist; **happen-to-them** when the bone is in the wrong place | DIRECT as series (ACLR, hood, CMC, shoulder) | See A3. Elective vs mandatory is the manager’s last real medical decision. |
| Doctor / specialist clearance | **Yes** — it *is* the compete-date | consult fees UNKNOWN | **Happen-to-them** as a gate | **DIRECT** | NYSAC: neurologist after KO/TKO-head; ophthalmologist / ortho as requested. ARP 2025 eye: listed red flags → ophthalmology before RTS. |
| Commission suspension | **Yes** — it *is* `medical_hold_until_week` | lost purse / lost booking | **Happen-to-them** | **DIRECT** | See A3 ladders. Physician may go *longer*. Age does not (J12 D9, R54). |

**What the manager actually decides (encode as choices):**

1. Rest this region vs keep camp intensity (raises reinjury chance — magnitude **UNKNOWN**).  
2. Conservative vs elective surgery, when the series say both exist (MCL, many metacarpals, some meniscus, some AC).  
3. Pay for a recovery facility / extra physio (game already has a facility).  
4. Take a booked fight on an amber region (management; commissions may still refuse).  
5. Delay the booking (Kingery-class career cost).

**What happens to them (not buttons):** KO/TKO ladder, 7-day admin rest (NYSAC all fights), “or until cleared by physician” orbital/fracture holds, ringside stoppage, mandatory imaging after KO in some jurisdictions.

**Do not encode:** ice as a skill tree; cortisone as a cheat code; a surgery minigame.

### A3 — Timelines (RTP train vs RTP compete)

**Rule used here:** if a commission, federation handbook, or a combat-athlete surgical series publishes a number, it is DIRECT for *that object*. If the number is general-ortho or a physio blog, it is INHERITED or UNVERIFIED_SECONDARY. If nobody measured it, it is UNKNOWN and the game keys off **injury type + treatment path + clearance**, not a invented week-count dressed as physiology.

#### Commission / federation compete-dates (DIRECT — these set `medical_hold_until_week`)

| trigger | hold | who | age-scaled? | source |
|---------|------|-----|-------------|--------|
| All fights, admin rest | **7 days** | NYSAC | no | NYSAC Medical Manual 2024 |
| TKO from head | **≥30 d** + neurologist | NYSAC; ARP 2018 | no | NYSAC; ARP *BJSM* 2018 |
| KO, no LOC | typical pro **60 d** (FL, MN, tribal examples); ARP **60 d**; World Boxing amateur **≥30 d** | commissions disagree | no | J10/J12 ladders; World Boxing *Medical Handbook* 2025 §8 |
| KO with LOC | ARP **≥90 d**; World Boxing **≥90 d** (<1 min) / **≥180 d** (>1 min, USA Boxing / England Boxing) | commissions disagree | no | USA Boxing handbook; England Boxing Phase Three; ARP |
| 2 head stoppages in 3 months | World Boxing **≥90 d** | amateur | no | World Boxing 2025 |
| 3 head stoppages in 12 months | World Boxing **≥1 year** | amateur | no | World Boxing 2025 |
| Laceration / ortho / eye (pro NY) | **30–90+ d** physician discretion + specialist | NYSAC | no | NYSAC 2024 |
| Simple laceration (amateur England) | **14 d** glued/stripped/sutured; no competing with sutures in situ | England Boxing | no | Phase Three Ringside PDF |
| Facial-skeleton fracture | BBBoC **≥28 d** licence, extendable 45/90 on risk | British Boxing Board of Control | no | Scott et al. 2020 *BJOMS* consensus citing BBBoC |
| TKO no head injury | APBC-family **28 d** | some commissions | no | APBC Stoppage Regulation 3-8 |
| “Or until cleared by physician” (orbital, nose, long-bone) | **180 d or clearance** is the live UFC-card pattern | CSAC-family cards | no | e.g. UFC Sacramento 2026 suspensions (UNVERIFIED_SECONDARY as journalism; the *shape* matches commission practice) |

**They disagree with each other.** J10 already said this. Do not average 30 with 60 and call it a rule. Pick a **jurisdiction family** (World Boxing amateur vs ABC-pro vs NYSAC discretionary) and keep it. Amateur and pro floors stay separate.

**ARP 2018 also:** no sparring for the same window as the competition suspension after TKO-head / KO. That is the **train** date for `concussion_rhi`, and it is DIRECT.

**Clinical SRC (not combat floors):** Putukian 2023 *BJSM* — mean symptom-free 14.0 d, RTS 19.8 d; adult point estimates *shorter* than 13–18 y. Combat commissions already use **longer** floors than this. Do not replace ARP/World Boxing with Putukian. Do not age-lengthen (J12 D9).

#### Surgical / tissue series in combat athletes (DIRECT as *that series*, not a law)

| injury | train | compete / next fight | n / who | grade |
|--------|-------|----------------------|---------|-------|
| UFC ACLR | UNKNOWN as gym-return | **411.85 ± 174.73 days** to next fight (range 165–879); RTS 81.25% ≥1 fight, 56.25% ≥2 | 48 UFC, mean age 30 | **DIRECT** as booking interval, not biology (PMC11551401). J12 D8: do not treat as weeks-to-heal. |
| MMA shoulder (labrum 41.2%; 76.5% surgical) | UNKNOWN | win% 81.96 → 54.7; recurrence 22.2% | 27 fighters / 34 injuries, all male | **DIRECT** as performance drop, UNKNOWN as weeks (PMC12156349) |
| Elite boxers, extensor-hood repair | light impact 8–12 weeks (protocol) | **mean 8 months** (range 1–24) to same level; 43/44 returned | Matharu, Gatt, Loosemore, Hayton 2022 *J Hand Surg Eur* | **DIRECT** |
| Elite boxers, 2nd/3rd CMC instability | light punching 3 months; full sparring 6 months | **~9 months** competition | *J Hand Surg Asian-Pac* 2026 series, n=20 | **DIRECT** as that protocol |
| Pro-athlete hand/wrist, mixed sports | — | mean RTP **2.8 months**; **boxers longest ~6 months** (often operative) | systematic review PMC7534880 | **DIRECT** as the boxing tail; mixed-sport mean is INHERITED for others |
| Kingery MMA card-withdrawal | — | mean **6.8 ± 6.7 months** to next *pro fight*; 94.4% returned; older → lower odds (OR 0.822) | n=454, 2012–14 public data | **DIRECT** as booking; **not** tissue (J12 D8) |
| Australian MMA/MT event health problems | median days impacted: MMA **20**, MT **16** | — | Stannard 2025 | **DIRECT** as self-report HP duration, mixed severity |

#### INHERITED (not fighters; use as type-windows, never as citations for combat weeks)

| type | typical window | notes |
|------|----------------|-------|
| Muscle strain grade 1 / 2 / 3 | ~2–3 weeks / 4–8 / months | By **grade**, not age (J12 Q2) |
| Hamstring RTS | Schmitt 2020: 43 ± 36 d, n=19 **male field-sport** | Do **not** lift `age × 1.5` (J12). Combat hamstring weeks: **UNKNOWN** |
| MCL grade 2–3 | tissue 4–8 weeks; full contact 8–14 weeks | Physio guide UNVERIFIED_SECONDARY as the 8–14; ortho consensus is INHERITED |
| ACLR general sport | **9–12 months** criteria-based; return <9 months raises retear | INHERITED; UFC next-fight ~13.5 months sits in the same band |
| Boxer’s fracture (5th neck) | immobilisation 3–6 weeks; bone ~6 weeks; contact sport later | Cleveland Clinic / StatPearls INHERITED. **Punching** RTP for a pro boxer is the 6-month boxing tail above, not the ED’s 6 weeks. |
| AC joint, non-op vs op | non-op RTS ~52 d vs op ~127 d (pooled mixed sports) | INHERITED (2025 systematic review, not combat) |
| Nasal fracture, non-combat | NHS: no sport with face-risk **≥6 weeks** | INHERITED. Combat: BBBoC ≥28 d *licence* then reassessment — **not** the same as healed. |
| Orbital, non-displaced | bone 4–8 weeks | INHERITED clinical. Combat cards: **180 d or specialist clearance** (pattern). |
| Facial ORIF, ball sports | 3–6 weeks contact with shield | Scott 2020. **Combat is explicitly outside** that advice. |

**Where the game should key off instead of a missing number:** (1) injury `type_id` + `treatment_path` (conservative / surgical / commission-ladder); (2) a **clearance flag** (neurologist, ophthalmologist, imaging); (3) criteria, not a calendar, for ligament RTS — if the engine cannot do criteria, use the type-window and label it UNKNOWN. **Never** invent a per-region days table and footnote a hamstring paper.

### A4 — Who clears, and on what

**Compete (licence / bout):**

1. **Commission-approved physician** certifies fitness to enter the fighting area (tribal/ABC-family language; NYSAC; WA Combat Sports).  
2. **Ringside physician** may stop the bout and **issues the suspension**. Referee does not diagnose.  
3. **Specialist written clearance** when the hold requires it: neurologist (KO/TKO-head, NYSAC), ophthalmologist (ARP 2025 red flags; dilated exam already on NSAC comprehensive contestant), orthopaedic surgeon / OMFS for fracture/orbital.  
4. **Commission** records the hold and can refuse a petition to shorten it (NYSAC 19 NYCRR 208.11: petition with proof to the Commission physician).  
5. **Evidence they act on:** post-fight exam, mechanism (KO vs TKO vs cut vs ortho), imaging when ordered, specialist letter, sometimes MRI/MRA/NP for high-risk/older/mileage (R54 / J12 D3 — *clearance*, not days).

**Train / spar:**

- ARP 2018: no sparring for the competition-suspension window after head TKO/KO. That is a **clinical** rule, not a gym whim.  
- After that window, the **gym’s physician/physio** progresses contact. There is **no** sourced national “sparring licence.”  
- England Boxing / World Boxing: return to sparring after KO/RSC requires a medical examination by a licensed practitioner and paperwork (Form B/C family). Amateur is stricter on *paper* than many pro gyms.

**The manager:** books, pays, chooses conservative vs elective surgery, chooses whether to present the fighter. **Does not clear.** Encoding a manager button that lifts `medical_hold_until_week` without a physician/commission object would contradict DA6.

**Amateur vs pro:** World Boxing / USA Boxing / England Boxing publish day tables. Pro US is physician-discretion plus floors that **disagree by state**. Do not average (J12).

### A5 — What it costs (money, weeks, lost prep)

A management game that models an injury without a price has modelled a delay.

| cost type | what is sourced | grade | what to encode |
|-----------|-----------------|-------|----------------|
| **Weeks out of competition** | Commission ladders (days); ACLR ~412 d to next UFC fight; boxers’ operative hand ~6 months; Kingery 6.8 months mean after *any* card-scratching injury | DIRECT as those objects | Set `medical_hold_until_week` from type+jurisdiction. Lost *booking* may exceed the hold (Kingery). Do not conflate. |
| **Weeks out of hard training** | ARP no-sparring = hold for head. Extensor-hood: no impact 8–12 weeks. CMC: light punch 3 mo, spar 6 mo. Everything else | mix | Train-date ≤ compete-date always. If only one number exists, it is the **compete** date; train-date is UNKNOWN and must not be faked as equal. |
| **Lost preparation** | A camp missed is a camp missed. No sourced “% of peak lost per week of missed sparring” in combat | **UNKNOWN** | Author a camp-quality penalty, `grade: UNKNOWN`. Do not cite it as physiology. |
| **Cash, fight-night** | Promoter/commission event insurance often covers *bout* injuries (UFC historically advertised event policy; $50k–$100k figures are press). Training injuries often **not** covered | UNVERIFIED_SECONDARY as the dollar caps; DIRECT as the *split* (bout vs gym) | Two flags: `injury_in_bout` (promoter pays a band) vs `injury_in_gym` (athlete/gym pays). Amounts UNKNOWN. |
| **Cash, surgery** | US ACLR/ORIF list prices exist (MDsave CRPP metacarpal national average **$6,115**, range $1,608–$8,543). Uninsured fighter ACL “$30k–$60k” is financial-planner copy. Kevin Lee 2025 hospital bill **$31,742** after a KO is one man’s itemised ED, not a mean | **UNKNOWN** as a combat mean; INHERITED as “surgery is a four-figure-to-five-figure event in the US” | Author three bands (clinic / imaging+consult / surgery) labelled UNKNOWN. Do not put MDsave in a researched column. |
| **Cash, ongoing** | Fighters on camera citing $30k–$300k lifetime “on my body” | UNVERIFIED_SECONDARY | Flavour. Not a system. |
| **Career odds** | Kingery: older → less likely to return. UFC ACLR: only 56% make a second fight without further injury. Shoulder: win% collapse | DIRECT as odds | This is J12 D8: odds, not weeks. Wire to booking/retirement pressure (J10 flags), not to region-heal. |

**Amateur:** medical cost to the athlete is often the club/federation; the price is **weeks in a tournament** (glue vs 14 d vs 30/90/180). Pro: the price is **purses not earned** plus gym bills. The game already has purses (assignment). An injury that does not touch purse or camp has no management meaning.

### A6 — The permanent ones (sourced or folklore)

Ask it honestly.

| claim | ruling | grade |
|-------|--------|-------|
| Accumulating head blows associate with smaller brain volumes and slower processing; boxers worse than MMA at the same age | **Sourced.** Processing speed **−0.19% per fight**, **−2.1% per FES step** (Bernick / PFBHS 2015 *BJSM*). Stopping ≥2 years → group-mean *improvement* vs matched actives (Ritter 2022 *Neurology*) | **DIRECT** |
| Therefore the game should accumulate a head-injury / exposure ledger and let it pressure licence, IQ-adjacent processing, and retirement flags | **Yes** — and the game already records per-region hit history. Do not invent a `chin` that declines instead (J10 D8) | authored encoding of DIRECT exposure science |
| CTE / dementia pugilistica as a live 0–100 | **No.** Career-end flavour / high-risk flag, not a region | UNKNOWN as a game stat; DIRECT as a real disease in autopsy series |
| Cauliflower ear becomes permanent if the haematoma is not drained in days | **Sourced as tissue.** Fibrocartilage by ~2–8 weeks (StatPearls). Cosmetic, rarely a licence issue | **DIRECT** as tissue; optional flavour on `head_neck` |
| “A broken boxer’s hand never fully returns” | **Folklore as a law.** Matharu: 98% back to the same level. PMC7534880: athletes frequently return to preinjury performance; boxers just take longer. Residual pain/grip loss exists in some hands and is **not quantified as a game penalty** | UNKNOWN as a permanent stat haircut; DIRECT as high RTS |
| Scar tissue in muscle/tendon changes the number forever | Mechanism is real; **no combat weeks-or-points table** | INHERITED mechanism, UNKNOWN as encoding |
| Recurrent shoulder dislocation / labral tear changes the fighter | Recurrence **22.2%** and win% drop in one male MMA shoulder series | **DIRECT** as that series; do not generalise to all shoulders |
| Retinal detachment / monocular vision can end a striking licence | **Sourced as a gate**, not as a rate | **DIRECT** (ARP 2025 eye). Absolute monocular vision = contraindication in striking |
| “Chin goes” after one KO | Folklore. Hutchison 2014: each prior KO/TKO raises subsequent **KO odds** (OR 1.30) — that is **outcome**, not a tissue chin. A 2024 UFC 2010–21 model could **not** show that P(future KO) rose with KO count (“glass jaw”) | J10 D8 stands. Prior-KO is a **risk flag**, not a stat |

**Refusal here is a real deliverable:** do not add a permanent `chin` or a permanent `left_hand_function` integer unless a series gives you a number. The sourced permanence objects are **exposure (head)** and **optional cauliflower flavour** and **licence-ending eye**.

### A7 — Shape: does the injury own the number, or does the region?

**Ruling (DA1):** both, with a strict hierarchy.

1. **Region always has a 0–100 readiness number.** That number is the training-load object (J12 D2). Sparring, camp, rest, facility already write it. A fighter can be sore with **no named injury**.  
2. **When a named injury exists on that region, the injury owns the timeline.** It floors or caps the number, sets (or does not set) `medical_hold_until_week`, and stores `type_id`, `treatment_path`, `clearance_flags`, `train_week`, `compete_week`.  
3. **The number never substitutes for the name.** A 35 on `left_arm` that is a boxer’s fracture and a 35 that is a bruise are different objects. The forecast the game already has (“weeks until clear to train”) becomes a property of the injury when one is present.  
4. **At most one primary named injury per region at a time.** A second hit on an already-injured region is a *severity/re-injury* event, not a stack of viscera.  
5. **Head is special:** `concussion_rhi` and `laceration` and `ocular_orbital` can co-exist in reality (a KO with a cut). If the engine can only hold one, **concussion_rhi outranks** for the hold clock; the cut is a modifier on the same hold (max of the two ladders). Do not drop the concussion because a laceration is prettier to display.

**What this is not:** an injury-sim with organ damage, blood volume, and surgical skill checks. Management: name, weeks, who clears, what it costs, what the manager can still choose.

## A. § UNKNOWN (first class)

Naming these is the deliverable. Do not fill them.

1. Per-region recovery *rate* as a function of age (J12 D1).  
2. Draw weights (percent chance of each `type_id` given discipline, sex, amateur/pro, training vs fight). Lystad-class percents are *among recorded injuries*, not P(injury).  
3. Combat-athlete hamstring / calf / groin weeks-to-train.  
4. Train-date for ACL, labrum, metacarpal in fighters (compete-dates exist; gym-return does not, as a series).  
5. Dollar means for surgery, physio, imaging, cutman, in any jurisdiction the game ships.  
6. Lost-prep function: % of camp quality per week without sparring.  
7. Sanda, sambo, savate, pencak silat, arnis, capoeira region×type tables at Lystad quality.  
8. Women’s MMA and women’s pro boxing injury-type mix as their own tables (male-heavy samples dominate).  
9. Injection (cortisone/PRP) as a weeks-delta.  
10. Permanent hand-function penalty after metacarpal / hood / CMC.  
11. Reinjury probability by returning at readiness 40 vs 70.  
12. Rib-fracture incidence and weeks in boxers (one handbook says rare; not a series).  
13. Whether amateur glue-and-continue (tournament) should exist as a button in a career game that is not a multi-day box-cup.  
14. A sourced mapping from 0–100 readiness onto any clinical scale.  
15. Sex-specific heal weeks in combat (do not copy male ACLR means onto women unlabelled).

## A. Priority ruling

**P0 — build first**

1. Named-injury object on the existing six regions: `type_id` from the eight-type list, `treatment_path`, `clearance_flags`.  
2. Injury sets `medical_hold_until_week` from a **jurisdiction-family ladder** (already the one clock). Never a second clock.  
3. Train-week and compete-week as separate fields; compete-week ≥ train-week; where only one sourced number exists, store it as compete and leave train UNKNOWN or equal only when the source says they match (ARP concussion: they match).  
4. Discipline-keyed draw, not a global table. Sex-split books (J10 D6).  
5. Head: concussion outranks cut for the hold.

**P1**

6. Manager choices: conservative vs elective surgery; rest vs camp; delay booking.  
7. Cash as labelled-UNKNOWN bands.  
8. Exposure ledger for head (already have hit history) wired to J10 retirement/clearance flags.

**P2**

9. Cauliflower flavour. Cutman flavour. Do not block the stage on them.

**Refuse / do-not-build (Area A)**

- Whole-body age multiplier on healing.  
- Any healing rate presented as sourced when it is UNKNOWN.  
- A second medical clock beside `medical_hold_until_week`.  
- Age-lengthened KO/TKO/RSC days (R54, J12 D9).  
- 30/33 recovery kink (J12 D4).  
- Schmitt hamstring `age × 1.5` on six regions or on women (J12).  
- Kingery OR 0.822 exponentiated into weeks (J12 D8).  
- Gruesome-detail injury simulator; ICD-10; cinematic surgery.  
- Ice/injection as timeline cheats.  
- Manager button that clears a commission hold.  
- Averaged amateur/pro ladders.  
- Averaged boxing/BJJ type tables.  
- A `chin` stat (J10 D8; restated in C).

---

# AREA B — Should the game model diet

**What the game has today:** inside a fight camp, a **cut plan** sets two scalars (training-gain scale, injury-chance scale). Walking weight, limit, weigh-in, scale fact that can block a belt. **Outside camp: nothing.** No food, calories, macros, hydration, supplements, meals, dietitian.

## B. Decisions / rulings

| # | Call | The game does X, never Y | Grade (J1 map) | Why (one line) |
|---|------|--------------------------|----------------|----------------|
| **DB1** | Belonging | Diet, if it ships, is a **weekly PLAN** and/or a standing **DISCIPLINE**. Never a calorie counter, macro tracker, food inventory, or a field where the player types a nutritionist’s number. | **authored** as genre; the refuse list is the ruling | Football Manager, OOTP, F1 Manager do not log food. Players who last in this genre plan camps and rest, they do not weigh chicken. |
| **DB2** | “No” is legal | Shipping **no** year-round diet is acceptable. The camp cut-plan already is the nutrition model that combat actually obsesses over. | **authored** | Making weight is the sourced combat-nutrition object. Year-round macros are a different sport. |
| **DB3** | What it may touch | Year-round diet may touch **walking weight**, **cut-plan risk**, and a **LEA/REDs flag**. Never a per-region heal-week multiplier presented as sourced. | **DIRECT** as weight-cut and REDs-as-syndrome; **UNKNOWN** as region-heal | ISSA 2025; IOC REDs 2023. Tipton/Close are immobilization protein, not a hamstring clock. |
| **DB4** | Seam with camp | Keep the two camp scalars. Year-round diet **feeds** them (discipline makes a hard cut cheaper or costlier). Never replace the cut-plan with a food sim. | **authored** encoding of DIRECT cut science | The scalars already are the cut. ISSA is about the cut, not breakfast. |
| **DB5** | Granularity | At most one choice per week (or a standing stance between camps). Never daily tasks. Never micromanage meals. | **authored** | Daily diet is a chore. FM professionalism is hidden *because* SI would not show the number (Jacobson 2020). |
| **DB6** | Display | Show diet as a **line on the athlete and a line on the camp plan**. Never a nutritionist workstation. | **authored** (one paragraph, not a screen) | Operator: do not design the screen. This is the place-name only. |

## B. Answers to the six questions

### B1 — Does diet belong in a management game? (genre first, sport second)

**Genre survey (what comparable games actually ship):**

| game | what the player does about food | what the engine actually uses | player engagement | grade |
|------|----------------------------------|-------------------------------|-------------------|-------|
| **Football Manager** (the genre’s existence proof) | Does **not** set calories, macros, or meals | **Professionalism** (hidden) is described by SI and the community as lifestyle/training attitude; **condition**, rest, training intensity, physio, sports scientist. Jacobson (Eurogamer 2020): professionalism is “in the game” but **not as a number** because “what does Professionalism mean anyway?” | Players obsess over training load, rest, and hidden professionalism. Nobody is asking SI for a food log | **DIRECT** to SI’s own statement that the lifestyle number stays hidden; UNVERIFIED_SECONDARY as community “diet = professionalism” |
| **OOTP Baseball** | No diet | Development sliders (finite hours), potential vs current. Real MLB *teams* hire chefs; the *game* does not | Players engage with development budget and playing time, not protein | **DIRECT** to OOTP manuals |
| **F1 Manager** | No diet | ~9 driver attributes in three chunks (pace / consistency / racecraft) | Attributes are readable because there are nine | **UNVERIFIED_SECONDARY** as community attribute lists |
| **Madden franchise** | No diet | Wear-and-tear, rest, abilities | Wear-and-tear is the body model; food is not | **UNVERIFIED_SECONDARY** |
| **The MMA Manager Game** (2024–26 app) | Training plans, 27 attributes, 8 styles | No food system in the public feature list | 27 attributes is already the pitch | **UNVERIFIED_SECONDARY** (App Store copy) |
| **Boxing Manager** apps | Attributes, shows, belts | No food system in public copy | — | **UNVERIFIED_SECONDARY** |
| **FM marketing copy** | Guardian 2015 listed “diet” among simulated aspects | That sentence is flavour next to 250 data points; it is not a meal planner | — | **UNVERIFIED_SECONDARY** |

**Both sides, as required:**

- **For diet:** Combat sports *are* a weight-class sport. Walking weight, the cut, and the rehydration window are the actual drama of camp. LEA/REDs is a real syndrome in weight-class athletes (IOC 2023). A management game that never mentions food while modelling a cut is leaving the cut hanging in mid-air. A standing “this fighter is professional / sloppy / aggressive-cutter” stance is cheap and diegetic.  
- **Against diet:** The genre’s surviving games treat food as **staff/professionalism**, not as a player-facing sim. Daily diet is a chore; SI hid even the lifestyle *number*. Combat nutrition literature is about **the cut week**, which this game **already models as two scalars**. Year-round macros have no sourced mapping onto POWER/SPEED/CONDITIONING points (J10 D3 analog). A food inventory is a different game.

**Ruling:** a “no” to year-round diet is acceptable and useful. A “yes” is only useful as **DB1** (plan/discipline). A “yes” as MyFitnessPal is how this project throws the system away.

### B2 — What diet demonstrably affects (sourced)

| claim | what is actually shown | combat-specific? | enough to drive a game object? | grade |
|-------|------------------------|------------------|--------------------------------|-------|
| **Making weight** | ISSA 2025 position stand: protein 1.2–2.0 g/kg, CHO floor 3–4 g/kg, fat 0.5–1.0 during descent; acute water-loss bands 6.7%/5.7%/4.4% at 72/48/24 h; post-weigh-in ORS then CHO 4–12 g/kg depending on depletion; long-term effects of frequent cuts **unknown** (their point 16) | **Yes** — written for MMA and other combat | **Yes** — this is the cut-plan the game already has | **DIRECT** |
| **Rehydration and performance after a cut** | RWL 3–6%+ : mixed; many studies show impairments in fatigue, mood, strength/power, hormones. Brechney meta: small-to-moderate reductions in overall performance, max strength, repeated high-intensity effort. Practical floor in one 2023 review: stay ≤3–5% with ≥24 h to rehydrate | Yes | **Yes** — already the training-gain and injury-chance scalars. Magnitude of *those* scalars remains authored | **DIRECT** as direction; **UNKNOWN** as the two scalar values |
| **Post-weigh-in regain** | ISSA: aim to regain a large fraction (they write ≥10% of body mass — that figure is a **regain target after a large cut**, not a law). UFC-fighter diet-recall press (2026): fight-week ~1,750 kcal, ~55 g CHO, then ~6× CHO/fluid post-weigh-in | Yes | Walking weight vs limit vs scale is already in the game | DIRECT as the practice; the “≥10%” target is **the stand’s recommendation**, not a measured optimum |
| **LEA / REDs** | IOC 2023: syndrome from problematic LEA in **both sexes**; bone, endocrine, immunity, glycogen, CV/haem; CAT2 traffic-light. Meta 2025 (PubMed 39485653): 44.7% of athletes in included studies had LEA; mixed results on *general* injury, **consistent** on impaired bone and bone-stress injury | Combat listed among lean/weight-class sports | **Yes as a flag**, not as a per-region clock. Bone-stress is the sourced injury class, not hamstring weeks | **DIRECT** as syndrome; **UNKNOWN** as combat prevalence |
| **RWL and injury *odds*** | One judo sample reported 14% injured without RWL vs 48.7% with RWL (cited inside PMC8746600). Not a replicated combat meta | One sport, one paper via a review | Direction only. The camp **injury-chance scale** already exists. Do not cite 48.7% as a law | INHERITED via review |
| **Recovery / soft-tissue healing** | Tipton 2015; Close et al. 2019 *IJSNEM*: avoid energy deficit; protein **~2–2.5 g/kg** during immobilisation to *spare muscle*, not to close a tear faster. Insufficient protein impairs wound healing (general). Protein meta 2022: peri-exercise protein helps MVC recovery after *resistance* EIMD, **not soreness** | **No** combat RCT on “diet shortens a fighter’s MCL by N days” | **UNKNOWN as a per-region modifier.** INHERITED as “don’t starve an immobilised athlete” | INHERITED mechanism; UNKNOWN weeks |
| **Body composition over a career** | Walking-weight drift, yo-yo cuts, and “moved up a class” are industrial knowledge. ISSA point 16: **long-term effects unknown** | The honest sentence is the stand’s | Walking weight already exists. **Rate of drift: UNKNOWN** | UNKNOWN as a number |
| **Hydration / supplements outside camp** | Sports-nutrition guidelines exist; combat-specific year-round supplement effects on fight outcomes do not, as a table | — | Do not add a supplement inventory | UNKNOWN as fight-outcome effects |

**Do not average sexes:** LEA thresholds and menstrual function are female-specific as *markers*; IOC 2023 is explicit that males get REDs too. Female fighter LEA prevalence: **UNKNOWN** as a tight number. Do not copy a runner LEAF-Q rate onto a female boxer unlabelled.

### B3 — Honest granularity

**Ruling (DB5):** if it ships, it is:

- a **weekly PLAN** during camp (the cut-plan already is this — keep it), and  
- optionally a standing **DISCIPLINE** between camps with three authored stances, e.g. `pro` / `normal` / `sloppy` (names are flavour).  

It is **never** a daily task. The player should not be able to micromanage meals, grams, or supplement stacks.

Why not a discipline *stat* (0–100): because that is a hidden-professionalism clone, and DC-refuse plus FM’s own designer said the number should not show. A **stance** (a choice with consequences) is honest. A 0–100 “nutrition” is a number that only exists to go up.

### B4 — Seam with Area A

**Ruling (DB3):** nutrition is **not** sourced strongly enough to move a per-region recovery clock.

- DIRECT: LEA → bone-stress *risk* (IOC, running/military cohorts). Combat bone-stress as a named injury is rare on fight-night cards (the named bones are punches and checks, not tibia stress from LEA).  
- INHERITED: energy deficit + low protein → worse immobilisation atrophy and slower *wounds* in general medicine.  
- UNKNOWN: days saved on a hamstring, a metacarpal, or a concussion by “eating well.”

**Encode, if diet exists at all:** a labelled-UNKNOWN modifier on the **camp injury-chance scalar** (already there) and a REDs **flag** that raises *clearance/bone-injury risk*, not hold days. **Do not** multiply `left_leg` heal weeks by a protein coefficient.

### B5 — Seam with the cut-plan that already exists

**Ruling (DB4):** **keep** the two scalars. Year-round diet **feeds** them.

| if year-round discipline is… | training-gain scale in camp | injury-chance scale in camp |
|------------------------------|----------------------------|-----------------------------|
| sloppy | harder cut hurts gain **more** | injury-chance **higher** |
| normal | current authored scalars | current |
| pro | hard cut hurts gain **less** (still hurts) | injury-chance **lower** (still not zero) |

The *values* of those feeds: **UNKNOWN**. Author them. Do not replace the cut-plan with “the fighter ate 1,750 kcal this week” — that is the calorie counter DB1 forbids. ISSA’s fight-week numbers are for nutritionists, not for the player to type.

### B6 — Where it would be shown (one paragraph, no screen)

On the **athlete sheet**, one line under walking weight: the standing discipline stance, and whether a REDs/LEA flag is lit. On the **camp plan**, the existing cut-plan choice remains the nutrition interaction for that camp; if a year-round stance exists, it is visible there as a modifier on the two scalars, not as a second food UI. Nowhere else: not a kitchen, not a shopping list, not a macro pie, not a dietitian’s office the player walks into. The recovery facility already on the body-readiness side is where “we are feeding the injury” is implied, without grams.

## B. § UNKNOWN (first class)

1. Year-round calorie/macro targets as game numbers (ISSA floors are *cut-week* floors, not career).  
2. Magnitude of the two camp scalars, and of any discipline-feed onto them.  
3. Per-region heal-week change from nutrition.  
4. Combat-specific REDs prevalence by sex and discipline.  
5. Walking-weight drift rate between camps (kg/month, by stance).  
6. Long-term health/performance cost of frequent cuts (ISSA 2025 point 16: unknown).  
7. Supplement effects on fight outcomes.  
8. Whether amateur morning-weigh-in sports (Olympic boxing, TKD, judo) need a *different* cut-plan object than 24–36 h pro MMA — likely yes as design, **not sourced as two scalar tables**.  
9. Female vs male cut-performance penalties as game numbers.  
10. A sourced mapping from “professionalism-like discipline” onto CONDITIONING points.

## B. Priority ruling

**P0**

1. **Refuse** the calorie counter, macro tracker, food inventory, and any typed nutritionist number. That refuse is the deliverable even if diet never ships.  
2. **Keep** the camp cut-plan and its two scalars. Do not rip them out to make room for breakfast.  
3. If the operator wants year-round diet at all: one standing **stance** + optional REDs **flag**. No daily loop.

**P1**

4. Stance feeds the two scalars, values labelled UNKNOWN.  
5. Walking-weight drift as an authored trickle, labelled UNKNOWN, so a sloppy fighter eventually has to move class — the one year-round effect that is diegetic.

**P2**

6. Flavour text on camp meals. Do not block anything on it.

**Refuse / do-not-build (Area B)**

- Calorie counter.  
- Macro tracker.  
- Food inventory / shopping / cooking minigame.  
- Player-typed grams, kcal, or supplement doses.  
- A 0–100 `nutrition` stat that exists to go up.  
- A per-region heal multiplier cited as Tipton/Close/IOC.  
- Replacing the cut-plan with year-round diet.  
- A nutritionist screen.  
- Hidden diet numbers the player cannot see (Area C refuse, applied here).

---

# AREA C — What stats a full fighter actually needs

**What the game has today:** six 0–100 stats for every athlete, every discipline — POWER (damage after a strike lands), TECHNIQUE (quality of basic fallback actions), SPEED (with Fight IQ, who acts next), DEFENSE (opponent’s chance to land; **also** submission resistance), CONDITIONING (stamina cost and recovery between exchanges/rounds), FIGHT IQ (initiative with Speed; **derived from experience, not gym-trained**). Plus **per-discipline proficiency** and **per-move mastery**. Disciplines: MMA, boxing, kickboxing, muay thai, wrestling, judo, BJJ, karate, taekwondo, sanda, sambo, capoeira, savate, pencak silat, arnis.

**Nothing in that table distinguishes a wrestler from a boxer.** There is no grappling, clinch, takedown defence, chin, footwork, reach usage, pressure, ring generalship, flexibility, strength-split, or cardio-split.

**Refuse (operator):** hidden stats; a “potential” second axis (already has one); a stat that only exists to make a number go up.

## C. Decisions / rulings

| # | Call | The game does X, never Y | Grade (J1 map) | Why (one line) |
|---|------|--------------------------|----------------|----------------|
| **DC1** | One set | **One** stat set for every discipline. Never a second complete table per discipline. Grappling-relevant stats sit low and do not fire in a boxing bout. | **authored** (most expensive call); evidenced that proficiency already answers “is this a wrestler” | Fifteen tables is unshippable. Proficiency + moves already do style. Stats must be phase/physical, not style clones. |
| **DC2** | First-wave add | Add at most **`GRAPPLE`** (imposition: who takes the fight to clinch/mat). Never add chin, footwork, flexibility, strength-≠-power, cardio-≠-conditioning in the first wave. | **authored** as the add; **DIRECT** as the missing phase | Without a phase-imposition attribute, DEFENSE’s “submission resistance” never matters for a wrestler-vs-boxer. |
| **DC3** | Second-wave | `PRESSURE` (who walks forward) is the only second-wave candidate. Never ship it in the same breath as GRAPPLE if the card would exceed DC6. | **authored** | Distinct from SPEED (who acts) and FIGHT IQ (what they choose). Easy to duplicate both. |
| **DC4** | Chin | **No `chin` / `durability` stat.** Medical hold + KO ladder + exposure ledger outrank folklore. J10 D8 stands. | **INHERITED** from J10 D8; evidenced as the literature not isolating tissue-chin | Hutchison OR is KO *outcome*. PFBHS is exposure. “Granite chin” is not a measured 0–100. |
| **DC5** | Derived vs trained | FIGHT IQ stays **derived**. GRAPPLE and PRESSURE are **trainable**. Exposure/KO-count flags are **derived**. Never gym-train IQ. | **authored** encoding; IQ derivation already live | Experience is not a bag session. Grappling is. |
| **DC6** | Ceiling | Show **8–10** stats on the athlete card. Never FM’s ~36 as a target. Current 6 + at most 2–4. Beyond 12, chunk or stop. | **inferred** from comparable games + working-memory literature (INHERITED as UX, not a combat paper) | Fight Night’s readable core was **six** athleticism numbers. FM players build tools *because* 36 is unreadable without role-highlight. Cowan 2001: ~4 chunks, not 7. |
| **DC7** | Sex | Separate generation tables for POWER/SPEED (and CONDITIONING if split). Never sex-average a 0–100 (J10 D6). Never a “women get −X power” modifier on a shared book — they never share a bout. | **DIRECT** as dimorphism; **authored** as generation | Hunter/ACSM ~10–30% performance gap; Morris 2020 punching power **162%** male vs female in a lab sample. Books are already separate. |
| **DC8** | Peak windows | **One window per discipline *and* sex where J10 already sourced a window.** Remaining disciplines stay **UNKNOWN**, not invented. Never one window for everyone; never sex-average; never invent muay thai’s number to look complete. | **INHERITED** from J10 D1, D2, D6; this desk closes the leftover call | See C7 below. |
| **DC9** | Hidden / potential / xp-stats | Every stat the engine uses on the card is **visible**. Never a hidden professionalism clone. Never a second potential axis. Never a stat whose only job is to increment. | **authored** (operator refuse) | FM hid professionalism on purpose; this project forbids that move. |

## C. Answers to the seven questions (+ J10 leftover)

### C1 — Ranked missing additions

Each line: what it drives, what it takes from, what it is **not** (overlap trap, also C3).

| rank | proposal | drives | takes from | what it is NOT | ship? |
|------|----------|--------|------------|----------------|-------|
| **1** | **`GRAPPLE`** (working name; 0–100) | Who imposes clinch/mat; takedown success vs a striker; how much DEFENSE-as-sub-resistance is even allowed to matter | Nothing if new. If you instead stuff this into TECHNIQUE, technique becomes “does wrestling,” which lies about a boxer with high TECHNIQUE | **Not** per-discipline proficiency (already exists). **Not** per-move mastery (already exists). **Not** DEFENSE (landing + sub resistance). **Not** POWER (damage after a strike lands). **Not** STRENGTH as a second physical | **Yes, first wave (DC2)** |
| **2** | **`PRESSURE`** | Who walks forward, pace, “comes at you”; distinct from who *acts* (SPEED×IQ) | If stuffed into FIGHT IQ, veterans become pressure fighters by arithmetic | **Not** FIGHT IQ. **Not** SPEED. **Not** CONDITIONING. **Not** aggression-as-dirtiness (FM dirtiness analog — refuse) | **Second wave only (DC3)** |
| 3 | Split DEFENSE into striking-defence vs takedown-defence | Cleaner MMA | Doubles a live stat; proficiency already modulates | **Not** worth a new row if GRAPPLE exists | **No** — GRAPPLE × proficiency does this cheaper |
| 4 | CLINCH as its own stat | Thai/judo/wrestling collar-tie | Duplicates GRAPPLE | **Not** separate if GRAPPLE is the phase-imposition | **No** |
| 5 | REACH *usage* | Long-range boxing | Reach as **cm** is anthropometry, not a trained 0–100. Usage is TECHNIQUE | **Not** a stat if the body already has a reach number | **No** unless reach is not on the body |
| 6 | FOOTWORK | Ring geometry | SPEED + DEFENSE already | **Not** distinct enough to survive DC3 | **No** |
| 7 | FLEXIBILITY | Some submissions, high kicks | Thin; women’s distribution differs (INHERITED general) | **Not** first-wave; a number that exists to go up | **No** |
| 8 | STRENGTH ≠ POWER | Clinch control, pummel | POWER is defined as damage-after-land. Strength would clone GRAPPLE | **Not** both | **No** |
| 9 | CARDIO ≠ CONDITIONING | “Engine” vs “tank” | CONDITIONING already *is* stamina cost + between-exchange recovery | **Not** a split the player will read | **No** |
| 10 | RING GENERALSHIP | Where the fight happens | FIGHT IQ | **Not** | **No** |
| 11 | **CHIN / DURABILITY** | Soak head damage | Medical hold, KO ladder, exposure | **Not** a tissue 0–100. J10 D8 | **No (DC4)** |
| 12 | CUT RESISTANCE | UFC 5 has this | Laceration is an Area A *injury type* | **Not** a stat; it is skin + luck + cutman | **No** |

**What is genuinely missing for *any* of the listed disciplines:** a way for a wrestler to make the boxing stats stop mattering for a while. That is **phase imposition**. Proficiency says “this person is a wrestler.” It does not, by itself, win the wrestle against a strong, experienced striker unless an attribute drives the clinch/mat attempt. Everything else on the operator’s missing-list is either already a live stat, already proficiency/moves, or folklore.

**Wrestling vs boxing after DC2:** a wrestler has high `GRAPPLE` and wrestling proficiency; a boxer has low `GRAPPLE` and boxing proficiency. POWER/SPEED still describe both. The table now distinguishes them without a second stat set.

### C2 — One set or many? (the expensive call)

**Ruling (DC1): one set.**

| option | what you gain | what you lose | cost |
|--------|---------------|---------------|------|
| One set (recommended) | One athlete card; MMA cross-training is a proficiency change, not a reincarnation; a boxer can learn takedowns by raising GRAPPLE + wrestling proficiency | A judoka’s “POWER” still means strike-damage, which is rarely how judo ends a match — **acceptable** because judo proficiency and GRAPPLE do the throwing | Low |
| One set *per discipline* | A judoka could have “POWER” mean nage-waza | Every dual-style athlete needs two bodies; MMA becomes a pile of tables; the player stops reading | **Highest cost in this area** |
| One set plus discipline-specific *display* aliases | Fake clarity | The engine still has one set; aliases lie when comparing a boxer to a wrestler | Medium, and dishonest |

**What is lost by one set, honestly:** strike-POWER is a weak descriptor of a pure judoka/BJJ athlete. Mitigate by **not using POWER in a grappling-only exchange** (the engine already has moves). Do not mitigate by shipping 15 tables.

**Most expensive decision: settled.** Implementers cite **DC1**.

### C3 — Overlap trap (what each proposal is NOT)

Restated so an implementer cannot quietly duplicate:

- **`GRAPPLE` is not TECHNIQUE.** Technique is quality of fallback actions. Grapple is whether the fight *goes* to a fallback the wrestler wants.  
- **`GRAPPLE` is not DEFENSE.** Defense is already overloaded (landing + sub resistance). Do not add a third job; add the imposition that makes the second job reachable.  
- **`GRAPPLE` is not wrestling proficiency.** Proficiency is “how good at this discipline.” Two wrestlers can differ in GRAPPLE the way two boxers differ in POWER.  
- **`PRESSURE` is not SPEED.** Speed is who acts next (with IQ). Pressure is who *closes*. A counterpuncher is fast and not pressuring.  
- **`PRESSURE` is not FIGHT IQ.** IQ is derived from experience. Teenagers pressure. Veterans often do the opposite (Kirk decision-win pattern, J10).  
- **FOOTWORK is not a hole.** It is SPEED + DEFENSE + TECHNIQUE.  
- **CHIN is not DEFENSE.** Defense is not getting hit. Chin folklore is what happens after you are hit. The sourced object after you are hit is the **hold** and the **exposure ledger**.  
- **CONDITIONING is not a hole.** Do not split cardio out so a number can go up.

### C4 — Durability and the chin (J10 D8: closed or narrowed?)

**J10 D8 closed the *stat*. This pass narrows the *science* and does not reopen the stat.**

What is sourced:

- KO/TKO risk rises with **age ≥35** and with **prior KO/TKO** in male UFC (Hutchison 2014: age OR 1.94/1.96; prior KO OR **1.30**). DIRECT as *outcome*. Cause not isolated (J10 UNKNOWN list item 10).  
- Processing speed tracks **fight exposure**, not birthday alone (PFBHS). DIRECT.  
- Neck strength / coupling: theoretically reduces head acceleration; UFC PI trains it; a 2022 systematic review in team sports found **inconsistent** concussion reduction from neck strength. INHERITED, not a chin number.  
- Sexual dimorphism in neck morphology and punching power is real (Morris 2020; OSF neck-morphology preprint). That is **sex-category anatomy**, not a trainable chin.  
- A 2024 UFC 2010–21 analysis could **not** show that more past KOs produced a “glass jaw” (higher future KO probability). DIRECT as *that* negative finding; do not over-read it as “prior KO does nothing” against Hutchison.  
- Angelo Dundee “you can’t train a chin” is folklore as a quote (UNVERIFIED_SECONDARY) and happens to match the “do not gym-train a chin stat” ruling.

**What J10 D8 already forbade:** a declining `chin` attribute as the retirement/medical object.

**What this desk adds:** do not add `chin` as a *positive* 0–100 either (UFC 5 / Fight Night / Undisputed all have one — those are **fighter sims**, not management games). Undisputed “Chin Resistance” and Fight Night “Toughness/Chin” are playable-health bars. This game’s analog is **region readiness + named `concussion_rhi` + hold**. Putting a chin on the card would duplicate Area A and resurrect folklore.

**Closed:** the stat. **Narrowed:** prior-KO and exposure are flags (J10 §1.4 already listed `prior_ko_count`). Use those. Never a tissue integer.

### C5 — Derived versus trained

| object | derived or trained | reason |
|--------|--------------------|--------|
| FIGHT IQ | **Derived** (already) | Experience, not a bag session. Keep. |
| POWER, TECHNIQUE, SPEED, DEFENSE, CONDITIONING | **Trained** (already) | Gym. |
| `GRAPPLE` | **Trained** | Mat time. Proficiency still needed to *know* the moves. |
| `PRESSURE` | **Trained**, weakly; also a stance | Can be camp-coached; do not let it be the xp-stat. |
| Peak window membership | **Derived** from age + discipline + sex (J10) | Not trained. |
| KO/exposure flags | **Derived** from the ledger | Not trained. Do not “train chin.” |
| Discipline proficiency / move mastery | **Trained** (already) | Not a sixth-plus stat. |
| Potential | **Already exists** | DC9: no second axis. |

### C6 — The ceiling (evidence + a number)

**Number this desk will defend: 8–10 visible stats on the athlete card.** Current six plus at most two (GRAPPLE, optionally PRESSURE). A hard stop at **12**. Above that, the player stops reading the card and starts reading a highlight, a star, or a tool.

**Evidence from comparable games (not a lab of FightCamp players — that sample does not exist):**

| product | how many numbers the player is asked to read | what actually happens | grade |
|---------|-----------------------------------------------|------------------------|-------|
| **This game today** | **6** | Readable. Does not distinguish wrestler/boxer | DIRECT to assignment |
| **Fight Night Champion** | **6** athleticism (Strength, Speed, Endurance, Conditioning, Toughness, Reflexes) + a second layer of punch skills (1–20) + chin/heart | Career players read the **six**. The punch matrix is a build screen, not a glance | UNVERIFIED_SECONDARY as community lists; the six-core is consistent across GameFAQs/OS |
| **Undisputed** | Many named sub-stats (chin resistance, body resistance, stamina, stamina regen, stamina recovery, conditioning, endurance, accuracy, …) | Needed an official “what do they do?” blog (16 Mar 2023) because the list was not graspable | DIRECT to the studio post |
| **UFC 5** | Star categories (striking / grappling / health) wrapping punch speed, power, accuracy, head movement, takedown, top game, cardio, chin, cut resistance, … | Players upgrade **categories**. Subs are a fighter-sim, not a manager card | UNVERIFIED_SECONDARY |
| **F1 Manager** | **9** attributes in **3 chunks of 3** | Readable because chunked | UNVERIFIED_SECONDARY |
| **The MMA Manager Game** | **27** attributes in 7 training categories | Dedicated MMA manager; 27 is the *pitch*, which is a warning | UNVERIFIED_SECONDARY (store copy) |
| **Football Manager** | SI: “almost 40 visible playing attributes” (FM19 manual); plus hidden professionalism, consistency, injury proneness, pressure, etc. | Players **do not** read 36. They read **role-highlighted 6–8**, or they install visualizer mods, or they play “no attributes” challenges because the wall misleads. SI **hid** professionalism on purpose (Jacobson 2020) | **DIRECT** to SI manual + Jacobson |
| **OOTP** | Position-relevant subset of a larger model; 1–20 scale | Shows what the position needs — chunking | DIRECT to manual |

**Working-memory literature (INHERITED, not a game study):** Miller 1956 7±2 is about chunks of immediate memory, **not** a UI law (Miller himself and later UX writers warn against the slogan). Cowan 2001: when you strip rehearsal, capacity is about **4 ± 1** chunks. Design implication: **chunk**, do not count to 36. A card of 6–10 is one chunk of “the fighter”; FM’s wall is many chunks and the UI has to highlight a subset or the player outsources cognition to a website.

**The number:** **8–10 on the card.** Cite DC6. If engineering wants UFC-5-style subs, they live under proficiency/moves (already there), not on the card.

### C7 — What the sexes do not share

J10 D6: do not average. Females never fight males. Weight-class books stay separate.

| stat | real distribution | must the game model it? | grade |
|------|-------------------|-------------------------|-------|
| POWER | Male-biased. ACSM 2023 / Hunter 2024: elite gaps ~10–30% on strength/speed/power tasks; largest on maximal power. Morris et al. 2020 *J Exp Biol*: forward arm-cranking / punch-proxy, males **162%** greater power than females in an active sample; least-powerful man still above most-powerful woman in that sample | **Yes, as separate generation tables**, not as a −X on a shared 0–100. A female 80 POWER is 80 **on the women’s book** | **DIRECT** as dimorphism; **authored** as “don’t share a scale across books” |
| SPEED | Male-biased on sprint/RFD; Olympic boxing lab: male VO2max 56.2 vs female 50.0 ml·kg⁻¹·min⁻¹, max speed 18.6 vs 15.5 km/h (Bachini 2024, n=10+4 — small) | Separate generation. Do not copy the 162% punch figure onto SPEED | DIRECT as direction; UNKNOWN as a game offset |
| CONDITIONING | Male VO2 higher on average; female boxers in that sample had *higher* VT as % VO2max. Fat mass % 17.2 vs 4.6 | Separate generation if CONDITIONING is an engine stat. Do not sex-average VO2 | DIRECT as the small boxing sample; INHERITED as general VO2 |
| TECHNIQUE, DEFENSE, FIGHT IQ | No sourced combat 0–100 sex split | **Do not invent one.** Same generation rules unless a paper appears | **UNKNOWN** as a sex offset |
| GRAPPLE (if added) | Strength dimorphism is larger in upper body (Nuzzo 2023: female bench ~46–55% of male in powerlifters). Grappling is not bench | Separate generation, modestly; do not copy bench percents | INHERITED |
| CHIN | Not a stat (DC4). Concussion *point estimates* longer in females in some SRC pools; CIs overlap (Putukian 2023) | Do not sex-scale concussion holds (J12 D9) | DIRECT as overlap |
| Flexibility | Generally female-favoured in civilian samples | Not a stat (C1). If ever added, do not reverse-average | INHERITED, not combat |
| Injury mix | ED combat: males more fractures, females more strains (ORS boxing abstract). BJJ samples ~90% male (Stegerhoek) | Injury **draw** keyed by sex-book (DA12), not a stat | DIRECT as pattern, incomplete |

**Must model:** separate books (already a design rule) and **separate POWER/SPEED generation**. **Must not model:** a universal female penalty on the six stats, a sex-averaged peak (DC8), a sex-averaged injury table (DA12), a sex-scaled heal clock (DA10).

### C8 — J10 leftover: one peak window, one per sex, or one per discipline

J10 found: women **older** than men in amateur/Olympic boxing (Longo 2016: female best-performers mean 26.3 vs male 24.8); women **younger** in judo (Franchini 2020) and taekwondo (Albuquerque 2022). A single window is a real fidelity loss. J10 also found **no sourced per-discipline curves** for most of this game’s list.

**Ruling (DC8):** adopt **one window per discipline and sex where J10 already published a sourced window.** Where J10 marked UNKNOWN, **keep UNKNOWN**. Do not invent a number so the table looks full.

| choice | what you keep | what you lose |
|--------|---------------|---------------|
| **One window for everyone** | Tiny `Aging.gd` | J10 D6 (sex). J10 D2 (amateur boxing ≠ pro boxing). TKD-young vs MMA-late. This is the current live loss and it is real. |
| **One per sex, all disciplines** | Longo boxing sex split | Amateur-vs-pro boxing (the bigger split). Judo/TKD vs MMA. Still averages a 23-year-old judoka with a 31-year-old MMA fighter. |
| **One per discipline, sexes averaged** | Olympic-vs-pro flavour | **J10 D6.** Women’s Olympic boxing is *older*; women’s TKD is *younger*. Averaging them is the data crime J10 named. |
| **One per discipline *and* sex, sourced only (recommended)** | Every DIRECT window J10 already defended | Completeness. Several disciplines have no number. **That incompleteness is the honest state.** |

**Disciplines / rows for which a numeric window would still be invented** (from J10 §1.1 and §2; do not fill):

1. `muay_thai` (any sex)  
2. `kickboxing` (any sex)  
3. `sambo` (sport or combat, any sex)  
4. `karate` as WKF-specific (INHERITED cluster only)  
5. `karate` as Karate Combat pit  
6. `sanda`  
7. `capoeira`  
8. `savate`  
9. `pencak_silat`  
10. `arnis`  
11. Women’s **professional** boxing  
12. Women’s MMA as a **tight** winner-age table (Kirk 2018 excluded women; Kirk 2024 women’s rows not extracted)  
13. IBJJF female adult black-belt medalist ages  
14. Individual longitudinal peaks for anyone (all J10 windows are cross-sectional)

**What to put in data for those rows:** no invented `peak_lo`/`peak_hi`. Either omit, or store a copy of the nearest parent **labelled `grade: UNKNOWN`** (e.g. sanda may *inherit display* from kickboxing+judo, never as a citation). J10 already did this caution for karate WKF.

**Amateur vs pro boxing:** J10 D2 still requires a split *inside* `boxing` if both careers exist in the game. That is not optional under DC8.

**Cite J10; do not reopen the yearly-delta table.** DC8 is windows, not −0.8 SPEED/year.

## C. § UNKNOWN (first class)

1. A sourced 0–100 for chin / punch resistance as tissue.  
2. Yearly game-stat deltas (J10 D3) — not reopened.  
3. Peak windows for the fourteen rows listed under DC8.  
4. Women’s MMA tight winner-age table.  
5. How many FightCamp players stop reading at N stats (no user study). 8–10 is inferred, not measured here.  
6. Sex offsets for TECHNIQUE, DEFENSE, FIGHT IQ.  
7. Whether PRESSURE is independent of FIGHT IQ in combat outcomes (not isolated).  
8. A sourced split of CONDITIONING into “cardio” vs “tank.”  
9. Flexibility as a combat performance 0–100.  
10. Reach-*usage* as distinct from reach-cm and TECHNIQUE.  
11. Dual-style athletes’ “true” stat needs as a second table (the reason DC1 refuses to go looking).  
12. A mapping from per-move mastery onto the six (or eight) card stats — mastery is the wrong layer.

## C. Priority ruling

**P0**

1. **DC1:** one stat set. Do not start a per-discipline table.  
2. **DC4 / J10 D8:** no chin. Wire KO/exposure to the hold and to J10 flags.  
3. **DC8:** peak windows per discipline **and** sex **where J10 sourced them**; UNKNOWN rows stay UNKNOWN.  
4. **DC6 / DC9:** no hidden stats; no second potential; card stays readable.

**P1**

5. **DC2:** add `GRAPPLE` if the engine cannot currently let a wrestler take a boxer down. If proficiency × moves already does phase in code (not visible in this workspace), **do not add the stat** — this desk has no live engine checkout.  
6. **DC7:** separate POWER/SPEED generation tables per sex-book.

**P2**

7. `PRESSURE` only if the card is still ≤10 and GRAPPLE is already live.  
8. Nothing else.

**Refuse / do-not-build (Area C)**

- Hidden stats (professionalism-clones, hidden chin, hidden pressure).  
- A second potential axis.  
- A stat that only exists to make a number go up (`nutrition`, `flexibility` as xp, `cut resistance`).  
- Per-discipline complete stat tables.  
- `chin` / `durability` as 0–100.  
- FOOTWORK, STRENGTH-split, CARDIO-split, RING GENERALSHIP, CLINCH-as-well-as-GRAPPLE in the first wave.  
- One peak window for everyone.  
- Sex-averaged peaks or sex-averaged POWER generation.  
- Invented peak_lo/peak_hi for muay thai, kickboxing, sambo, sanda, capoeira, savate, silat, arnis, Karate Combat, women’s pro boxing.  
- Yearly SPEED/POWER integer deltas dressed as this file (J10 D3).

---

# Cross-area: what an implementer may cite in one breath

- **DA1 + DA3 + DA4:** number for load, name for tissue, one hold clock.  
- **DA10 + J12 D1 + R54:** no age heal multiplier; extra clearance only.  
- **DA12 + J10 D6:** discipline- and sex-keyed injury draw.  
- **DB1 + DB4:** no food sim; keep the cut-plan scalars.  
- **DB3 + DA3:** diet does not turn the region clock.  
- **DC1 + DC2:** one set; add GRAPPLE or add nothing.  
- **DC4 + J10 D8 + DA9:** no chin; exposure and hold instead.  
- **DC8 + J10 D1/D6:** windows by discipline and sex, UNKNOWN where J10 said so.

---

# Sources (verified 2026-09-07)

**Peer-reviewed / official (prefer these):**

1. Lystad RP, Alevras A, Rudy I, Soligard T, Engebretsen L. (2021). Injury incidence, severity and profile in Olympic combat sports. *Br J Sports Med* 55:1077–1083. https://doi.org/10.1136/bjsports-2020-102958 — PubMed: https://pubmed.ncbi.nlm.nih.gov/33219113/  
2. Lystad RP, Gregory K, Wilson J. (2014). The epidemiology of injuries in mixed martial arts: a systematic review and meta-analysis. *Orthop J Sports Med*. PMC: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4555522/  
3. Mao Y et al. (2023). Incidence rates and pathology types of boxing-specific injuries: systematic review and meta-analysis. *Orthop J Sports Med* 11(3). PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC10071201/  
4. Zachovajevas V, Engebretsen L, Moatshe G, Zachovajevas P, Røise O. (2025). Injuries in mixed martial arts after adoption of the Unified Rules of MMA: a systematic review. *Orthop J Sports Med*. https://doi.org/10.1177/23259671251342578 — PubMed: https://pubmed.ncbi.nlm.nih.gov/40620723/  
5. Stannard JW et al. (2025). Incidence of health problems in Australian mixed martial arts and Muay Thai competitors. *Sports Med Open*. https://sportsmedicine-open.springeropen.com/articles/10.1186/s40798-025-00880-3  
6. Stegerhoek PM, Brajovic B, Kuijer P, Mehrab M. (2025). Injury prevalence among Brazilian Jiu-Jitsu practitioners globally: a cross-sectional study in 881 participants. *BMJ Open Sport Exerc Med* 11:e002322. https://doi.org/10.1136/bmjsem-2024-002322 — PubMed: https://pubmed.ncbi.nlm.nih.gov/40092168/ — PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC11907054/  
7. Lystad RP et al. (2020). Epidemiology of injuries in Olympic-style karate competitions: systematic review and meta-analysis. *Br J Sports Med*. PubMed: https://pubmed.ncbi.nlm.nih.gov/32669263/  
8. Fares MY et al. / boxing ED 2000–2023. (2026). Boxing injuries treated in United States emergency departments, 2000–2023. *Phys Sportsmed*. https://www.tandfonline.com/doi/full/10.1080/00913847.2026.2661569  
9. Liao J, Liu Y. (2024). Systematic evaluation of literature on musculoskeletal injuries in boxers. *Med Sport* 77(4):501–512. https://doi.org/10.23736/S0025-7826.24.04457-0  
10. Ross AE et al. (2021). Injury profile of mixed martial arts competitions in the United States. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC8010826/  
11. Kingery MT et al. (2021). Performance and return to sport after injury in professional mixed martial arts. *Phys Sportsmed*. https://doi.org/10.1080/00913847.2021.1953358 — PubMed: https://pubmed.ncbi.nlm.nih.gov/34236932/  
12. UFC ACLR RTS. *Arthrosc Sports Med Rehabil* (PMC11551401). https://pmc.ncbi.nlm.nih.gov/articles/PMC11551401/  
13. MMA shoulder RTS. (2025). PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC12156349/  
14. Guss MS et al. (2020). Prevalence and treatment outcomes of hand and wrist injuries in professional athletes: a systematic review. *HSS J*. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC7534880/  
15. Matharu GS, Gatt IT, Delaney R, Loosemore M, Hayton MJ. (2022). Extensor hood injuries in elite boxers. *J Hand Surg Eur*. https://doi.org/10.1177/17531934221123139  
16. 2nd/3rd CMC instability in elite boxers. (2026). *J Hand Surg Asian-Pac*. https://doi.org/10.1142/s2424835526500074  
17. Neidecker J et al. / ARP. (2018). Concussion management in combat sports. *Br J Sports Med*. https://bjsm.bmj.com/content/53/6/328  
18. Putukian M et al. (2023). Clinical recovery from concussion. *Br J Sports Med* 57:798–809. https://doi.org/10.1136/bjsports-2022-106682  
19. Bianchi D, Sethi NK, et al. (2024). Care of the older fighter: ARP. *Phys Sportsmed*. https://doi.org/10.1080/00913847.2024.2344227  
20. ARP. (2025). Eye conditions: position statement. *Clin J Sport Med*. https://journals.lww.com/cjsportsmed/fulltext/2025/09000/eye_conditions__position_statement_of_the.1.aspx  
21. World Boxing. *Medical Handbook* 2025. https://worldboxing.org/wp-content/uploads/2025/08/WB-Medical-Handbook-2025.pdf  
22. USA Boxing. *Medical Handbook* (current PDF via contentstack, retrieved 2026-09-07). https://assets.contentstack.io/v3/assets/blteb7d012fc7ebef7f/blt6207d597c0043641/6a061613b79a656778281a33/USA_Boxing_Medical_Handbook.pdf  
23. NYSAC Medical Manual (2024). https://dos.ny.gov/system/files/documents/2024/05/nysac-medical-manual-5-8-2484.pdf  
24. 19 NYCRR 208.11 (medical suspensions). https://www.law.cornell.edu/regulations/new-york/19-NYCRR-208.11  
25. England Boxing. Phase Three Ringside (2023 PDF). https://www.englandboxing.org/wp-content/uploads/2023/09/Phase-Three-Ringside.pdf  
26. Scott N et al. (2020). Elite and professional sports facial injuries management — a consensus report. *Br J Oral Maxillofac Surg* 58:e254–e259. Saving Faces PDF: https://www.savingfaces.co.uk/wp-content/uploads/2021/03/Management-of-facial-injuries-in-elite-and-professional-sports%E2%80%93-a-consensus-report.pdf  
27. APBC Stoppage Regulation 3-8. https://apbcboxing.com/APBCStoppageRegulation.pdf  
28. Nevada Athletic Commission. Unarmed combatant physical 2025. https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/PHYSICAL-2025_W-INSTR.pdf  
29. Western Australia. Role of the Medical Practitioner in Combat Sports. https://www.dlgsc.wa.gov.au/department/publications/publication/role-of-the-medical-practitioner-in-combat-sports  
30. Bernick C et al. (2015). Repeated head trauma, brain volumes, processing speed (PFBHS). *Br J Sports Med*. ScienceDaily summary of the numbers: https://www.sciencedaily.com/releases/2015/01/150129185147.htm  
31. Ritter A et al. (2022). Longitudinal changes after fighters stop fighting. *Neurology*. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC9694836/  
32. Hutchison MG, Lawrence DW, Cusimano MD, Schweizer TA. (2014). Head trauma in mixed martial arts. *Am J Sports Med*. PubMed: https://pubmed.ncbi.nlm.nih.gov/24658345/  
33. Mountjoy M et al. (2023). IOC consensus statement on REDs. *Br J Sports Med* 57:1073–1097. https://bjsm.bmj.com/content/57/17/1073 — https://doi.org/10.1136/bjsports-2023-106994  
34. ISSA. (2025). Position stand: nutrition and weight-cut strategies for MMA and other combat sports. *J Int Soc Sports Nutr* 22:2467909. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC11894756/  
35. Martínez-Aranda LM et al. (2023). Effects of different rapid weight loss strategies… updated systematic review. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC10048848/  
36. Tipton KD. (2015). Nutritional support for exercise-induced injuries. *Sports Med*. GSSI SSE-169: https://www.gssiweb.org/sports-science-exchange/article/sse-169-nutritional-support-for-injuries-requiring-reduced-activity  
37. Close GL, Sale C, Baar K, Bermon S. (2019). Nutrition for the prevention and treatment of injuries in track and field athletes. *Int J Sport Nutr Exerc Metab* 29(2):189–197.  
38. Giraldo-Vallejo JE et al. (2023). Nutritional strategies in the rehabilitation of musculoskeletal injuries in athletes. *Nutrients*.  
39. Januszko P, Lange E. / combat nutrition and injury. (2021). Nutritional considerations for injury prevention and recovery in combat sports. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC8746600/  
40. Cabre HE et al. (2025). LEA and REDs: systematic review and meta-analysis. PubMed: https://pubmed.ncbi.nlm.nih.gov/39485653/  
41. Hunter SK et al. (2023). The biological basis of sex differences in athletic performance: ACSM consensus. *Transl J ACSM*. https://journals.lww.com/acsm-tj/fulltext/2023/10130/the_biological_basis_of_sex_differences_in.5.aspx  
42. Hunter SK, Senefeld JW. (2024). Sex differences in human performance. *J Physiol*. https://doi.org/10.1113/JP284198  
43. Morris JS, Link J, Neideen JC, Carrier DR. (2020). Sexual dimorphism in human arm power and force. *J Exp Biol*. ScienceDaily write-up of the 162% figure: https://www.sciencedaily.com/releases/2020/02/200205132404.htm  
44. Nuzzo JL. (2023). Narrative review of sex differences in muscle strength… *J Strength Cond Res* 37(2):494–536.  
45. Bachini F et al. (2024). Physical capacities and combat performance characteristics of male and female Olympic boxers. *Res Q Exerc Sport*. PubMed: https://pubmed.ncbi.nlm.nih.gov/38787600/  
46. Miller GA. (1956). The magical number seven, plus or minus two. *Psychol Rev*.  
47. Cowan N. (2001). The magical number 4 in short-term memory. *Behav Brain Sci*.  
48. Cauliflower ear. StatPearls. https://www.ncbi.nlm.nih.gov/books/NBK470424/  
49. Metacarpal hand fracture. StatPearls. https://www.ncbi.nlm.nih.gov/books/NBK536960/  
50. Swedish Olympic injury-insurance cohort (judo/wrestling/boxing/TKD locations). PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC10471666/  
51. Pencak silat musculoskeletal IR (Indonesian athletes). DOAJ: https://doaj.org/article/35b7756ce7164672a1327d0428bd202e  
52. Capoeira injury prevalence. *Healthcare* 2023, 11(14):1978. https://www.mdpi.com/2227-9032/11/14/1978/pdf  
53. Ocular injury boxing vs MMA. *BMJ Open* 2025;15:e098197 (PDF via bmjopen.bmj.com).  
54. Kirk C. (2018). Age and divisional rank in professional MMA. PDF: https://shura.shu.ac.uk/27929/1/3797-25364-1-PB.pdf  
55. Kirk C. (2024). 5-year analysis of age in MMA. VoR: https://shura.shu.ac.uk/32072/8/Kirk-5-YearAnalysisAge%28VoR%29.pdf  
56. Longo AF et al. (2016). Age of peak performance in Olympic combat sports — as cited and windowed in J10. **Do not re-derive.**  
57. Franchini E, Fukuda DH, Lopes-Silva JP. (2020). Judo peak-age — J10.  
58. Albuquerque MR et al. (2022). Taekwondo Olympic ages — J10.  
59. Schmitt BM et al. (2020). Hamstring tenderness mapping. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC7297001/ — **do not lift onto six regions** (J12).  
60. Sports Interactive. Football Manager 2019 official manual, Players / attributes (“almost 40 visible playing attributes”). https://community.sports-interactive.com/sigames-manual/football-manager-2019/players-r3885/  
61. Undisputed. Fighter stats explained (16 Mar 2023). https://playundisputed.com/news/fighter-stats-explained  
62. OOTP Developments. Player rating model / development manuals. https://manuals.ootpdevelopments.com/  

**UNVERIFIED_SECONDARY (direction / genre / press; not numbers to lift as physiology):**

63. Jacobson M. interviewed in Eurogamer (2020). Hidden attributes; professionalism not shown as a number; injuries implemented at 70–80% of reality. https://www.eurogamer.net/how-football-manager-is-tackling-the-strangest-of-seasons  
64. The Guardian (2015). “How Football Manager changed the game” (lists diet among simulated aspects — flavour). https://www.theguardian.com/technology/2015/dec/05/how-football-manager-changed-the-game  
65. FM community: professionalism / hidden attributes (FM Scout, Passion4FM, SortItOutSI, fmstats.com). Direction only.  
66. Fight Night Champion athleticism six-core: GameFAQs 2011; Operation Sports; Nerd Kings OWC stats.  
67. UFC 5 attribute/perk guides (YouTube/Dexerto/GameRant) — fighter-sim, not management evidence.  
68. The MMA Manager Game App Store listing (27 attributes). https://apps.apple.com/us/app/the-mma-manager-game/id6739304995  
69. F1 Manager 2024 driver attribute breakdowns (community).  
70. UFC Sacramento 2026 medical suspensions (MMA Fighting / MMA Mania) — journalism of commission holds, not a rulebook.  
71. Kevin Lee hospital bill $31,742 (SPORTbible 2025); Bryce Mitchell nose (MMA Mania 2025); fighter financial-planner ACL $30–60k — **not means**.  
72. MDsave CRPP metacarpal national average — US cash-pay, not fighter wages. https://www.mdsave.com/procedures/crpp-metacarpal-fracture/d582ffc9  
73. Cutman compensation 2–3% of purse — Wikipedia. https://en.wikipedia.org/wiki/Cutman  
74. Chin (combat sports) — Wikipedia. https://en.wikipedia.org/wiki/Chin_(combat_sports)  
75. Fighters Only / “granite chin” interviews — folklore.  
76. Combat physio RTP blogs (Combat Sports Consulting 2026; Upwell Health 2026) — useful as *shape* of train≠compete, not as sourced weeks.  
77. Cleveland Clinic boxer’s fracture page (6–8 weeks sports). INHERITED clinical copy.  
78. NHS broken-nose 6 weeks (via gym-side boxing blogs citing NHS).  
79. FICS Pollard combat-injuries slide deck (2025) — sambo/silat rates. https://fics.sport/wp-content/uploads/2025/03/SATURDAY-15-MARCH-_POLLARD-Combat-Injuries.pdf  
80. Men’s Fitness (2026) UFC 107-fighter diet-recall press.  
81. Velatrixa / EssentiallySports UFC medical-coverage explainers — press.  

**Local (cite; do not reopen):**

82. `/workspace/j13/TASK_J13.md`  
83. `/workspace/j13/J10_THE_YEARS.md`  
84. `/workspace/j13/J12_RECOVERY_AND_THE_YEARS.md`  

**J12 sources this file relies on without re-pulling:** ARP older-fighter 2024; NSAC Physical 2025; World Boxing 2025 KO ladder; Florida §548.041; Colorado 4 CCR 740-1.6; Fernandes/Hayes 2025 EIMD meta; Kingery 2021. See J12 §5.

---

# Implementation notes for the next desk (research, not a patch)

1. **Do not invent a `recovery_scale()` and cite this file.** J12 D1 still owns that number: UNKNOWN.  
2. **Named injury is a small enum**, not a medical textbook. Eight `type_id`s. Discipline-keyed draw weights authored and labelled UNKNOWN.  
3. **`medical_hold_until_week` remains the only hold.** Injury writes it. Age does not.  
4. **Diet is optional and small.** Cut-plan stays. If a stance ships, it feeds the two scalars. No grams.  
5. **`GRAPPLE` is the only stat this desk will defend adding.** If the live engine already uses proficiency to change phase, do not add it. This workspace has no engine checkout.  
6. **Peak windows:** lift J10’s table; fill nothing J10 marked UNKNOWN.  
7. **No catalog rows of named real athletes.** Named people above are citations only.  
8. **Claude land note (if a later desk writes one):** binds DA1–DA12, DB1–DB6, DC1–DC9; reopens nothing in J10/J12; must not ship a second medical clock, a calorie counter, a chin, or invented peak numbers.

---

*End of J13. Desk: John. 2026-09-07.*

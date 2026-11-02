# J12 — Recovery and the Years: Does an Older Fighter Heal Slower?

**Desk:** John (research)  
**Date:** 2026-09-07  
**Status:** research and proposals only. No `.gd` / `.tscn` / `assets/data` writes. No HANDOFF edits. No UI design.  
**Verification date for all live URLs in this file:** 2026-09-07 unless a source is dated otherwise.  
**Grade vocabulary (from J1, restated in J10):** `DIRECT` = a primary PDF, commission regulation, federation rulebook, or peer-reviewed dataset states the fact. `INHERITED` = copied from a parent standard or from general (non-combat) physiology and labelled as such, not claimed as that sport’s published number. `UNVERIFIED_SECONDARY` = media, blogs, commercial analytics, Wikipedia, books without a methods paper. `UNKNOWN` = no source. **A number without a source is UNKNOWN by definition.**

**What “recovery” means here (do not collapse these):**  
(1) **Training-load recovery** — time-course of soreness, force restoration, and readiness after a hard session that is *not* a diagnosed injury (Q1).  
(2) **Injury healing / weeks-to-return** — clinical return after soft tissue, bone, or concussion/RHI (Q2).  
(3) **Commission medical hold** — mandatory suspension and extra clearance (Q5).  
(4) **Between-round “engine” recovery** — lactate / VO2 / power restoration inside a bout.  

J10 refused invented yearly *stat* deltas. This desk asks whether recovery-vs-age is different. **It is different as a literature, not as a game number.** Physiology papers exist. A fighter-specific days-per-year or `recovery_scale()` multiplier does **not**.

**Cite J10; do not reopen peak windows.** Peak `peak_lo`–`peak_hi` by discipline and sex, and the UNKNOWN yearly-delta ruling, stand. This file is about healing clocks, not prime age.

**Do not average (J10 D6):** sex, sport, injury type, and amateur-vs-pro stay separate. A hamstring formula from 19 male field-sport athletes is not a female boxer’s laceration clock.

---

## Decisions page (operator calls)

| # | Call | Recommendation | Why (one line) |
|---|------|----------------|----------------|
| D1 | **`Aging.recovery_scale()` is not a researched number** | If R54 needs a factor, author it and label `grade: UNKNOWN`. Do not ship a citation that looks like physiology. | No combat-sport (or even general-adult) paper publishes “heal X% slower per year of age” as a game multiplier. That is a complete useful answer for R54. |
| D2 | Keep **training-load recovery** and **injury healing** as two objects | BodyReadiness camp-heal ≠ weeks-to-return after a tear. Do not apply one age slope to both. | Q1 literature (EIMD / masters) and Q2 literature (RTP / commissions) disagree with each other and answer different clocks. |
| D3 | **Extra clearance, not a longer hold** | Encode ARP/NSAC/NYSAC/Colorado *clearance batteries* as flags at 35 / 38 / 40 / 45. Do **not** lengthen `medical_hold_until_week` by age. | Rules add tests. They do not add days to the KO/TKO ladder. ARP 2024 says it is *unclear* whether an older fighter needs a longer concussion suspension. |
| D4 | **No 30 / 33 recovery cliff** | R52 is right to remove those cutoffs as physiology. Age-vs-recovery, if encoded at all, is not a step at 30. | 30/33 are not sourced healing thresholds. Commission ages are 35 (ARP older-fighter / high-risk), 38 (NSAC comprehensive contestant), 40 (NYSAC high-risk; ARP neuro imaging), 45 (Colorado extra tests). Those are licence gates, not recovery rates. |
| D5 | **Years and mileage are both real and not interchangeable** | If the game has `age` and fight history, key clearance/risk off **both**. Do not collapse recovery to birthday. | Hutchison 2014: age ≥35 still raises KO odds after prior KO is in the model. PFBHS: processing speed tracks fights/FES, not birthday alone. NSAC treats 38, 425 rounds, and 36 months inactive as *separate* comprehensive-contestant triggers. |
| D6 | Do **not** average sex / sport / injury type / amateur-pro | Separate rows. Do not copy a male UFC KO OR, a male hamstring formula, or a 65-vs-22 EIMD study onto a 41-year-old female fighter’s body regions. | J10 D6. Q1 EIMD sex-split is incomplete; Q2 hamstring formula is male-only n=19; concussion adult age-lengthening is not sourced. |
| D7 | Do **not** encode “older fighters get more sore / take longer between sessions” as a law | Direction is **conflicting**. Soreness is often *less* in older adults; force recovery after matched gym work at ~40 vs ~22 can be worse; matched-strength 52-vs-22 squat recovery was not slower. | Fernandes/Hayes 2025 meta-analysis (36 studies) vs Fernandes 2019 middle-aged squat study vs Schmidt 2021. See Q1. |
| D8 | **Injury RTS probability** may fall with age in MMA; **weeks-to-heal** still has no sourced step | Kingery 2021: older age → lower odds of returning after a card-scratching injury (OR 0.822). That is *whether they come back*, not *how many weeks the tissue takes*. | DIRECT as a booking/career outcome. UNKNOWN as a BodyReadiness region-heal multiplier. |
| D9 | Concussion / RHI **hold days are not age-scaled** in sourced rules | Keep World Boxing / ARP / state KO ladders age-blind. Individualize clearance (already the clinical line). | Putukian 2023: adult SRC recovery patterns similar across age/sex cohorts in the pooled data; point estimates if anything show *younger* (13–18) slower than >18. ARP: “unclear at present whether an older fighter needs a longer suspension.” |
| D10 | Cite J10; do not reopen peaks | No new `peak_lo`/`peak_hi`. No yearly `speed`/`power` deltas dressed as recovery. | J10 D1–D3 stand. Recovery is a different question and still does not yield a yearly game stat. |

**Priority ruling:** P0 = (a) refuse a researched `recovery_scale()` multiplier, (b) extra-clearance flags from ARP/NSAC/ABC-family, (c) keep Q1 and Q2 as separate clocks. P1 = if engineering needs a placeholder slope, store it `grade: UNKNOWN` in data, not in prose. P2 = nothing else. **Do not block R54 on a sourced factor that does not exist.**

**One operator question:** Should R54 author a labelled-UNKNOWN `recovery_scale()` so a veteran *feels* slower to the player, or keep BodyReadiness age-blind on healing clocks and only add extra-clearance / high-risk flags (this desk’s recommendation, because the honest physiology does not support a number)?

---

## 0. Frame (what the game has, what J10 already ruled)

J10 §0: live `BodyReadiness.gd` applies fight damage and a `medical_hold_until_week` from a damage profile. **No age. No decline. No recovery_scale.** A 41-year-old and a 19-year-old heal identically. That is the player-visible veteran-week problem R54 is waiting on.

J10 D3 already refused yearly integer deltas on `speed`/`power`/`conditioning` as facts. J10 §1.3 already flagged “recovery between camps” as **DIRECT as a clinical statement (ARP), UNKNOWN as a rate.** This file is that rate, graded properly.

**Do not treat ARP “may prolong their recovery” as a multiplier.** It is a ringside-physician position statement, not a days table.

Named people appear in this document only as *citations* (authors, commission officers). They are not catalog data.

---

## 1. Answers to Q1–Q6

### Q1 — Training-load recovery vs age (soreness, force restoration, readiness)

**Short answer:** There is **no sourced fighter number**. Masters and resistance-training literature is mixed, often the opposite of folklore on *soreness*, and occasionally supportive of slower *force* recovery in the middle-aged trained male band that actually matches a veteran. Grade all of it **INHERITED** (not DIRECT to combat). A game factor remains **UNKNOWN**.

**Do not average:** these studies are almost never fighters; many compare ~22 vs ~65–75, not 19 vs 41; sex is uneven; trained vs untrained changes the sign.

#### What the pooled EIMD evidence says (INHERITED, not fighters)

Fernandes, Wilson, Dingley, Hearn, Johnson, Hicks, Twist, Hayes (2025), *J Aging Phys Act* 33(6):606–624 — PRISMA meta-analysis, 36 studies, 389 younger vs 390 older adults, search 15 June 2023, published 1 Apr 2025. Outcomes: muscle function, soreness, CK. Each study’s own young/old bins (press coverage of this paper treated “older” as 35+ vs 18–25; the methods text uses the papers’ own definitions and does not impose a universal 30/33 cut).

| marker | old vs young | SMD (old minus young; negative = smaller change in older) | grade |
|--------|--------------|-----------------------------------------------------------|-------|
| Muscle function, 24 h | no difference | −0.28 (95% CI −0.63, 0.08), *P* = 0.124 | INHERITED |
| Muscle function, 48 h | no difference (borderline) | −0.35 (−0.71, 0.01), *P* = 0.059 | INHERITED |
| Muscle function, 72 h | no difference | −0.16 (−0.69, 0.38), *P* = 0.561 | INHERITED |
| Muscle function, peak change | no difference | −0.26 (−0.59, 0.08), *P* = 0.132 | INHERITED |
| Soreness, 24 h | **less in older** | −0.61 (−0.81, −0.41), *P* < 0.001 | INHERITED |
| Soreness, 48 h | **less in older** | −0.34 (−0.63, −0.06), *P* = 0.019 | INHERITED |
| Soreness, 72 h | **less in older** | −0.62 (−0.98, −0.26), *P* < 0.001 | INHERITED |
| Soreness, peak | **less in older** | −0.42 (−0.67, −0.18), *P* < 0.001 | INHERITED |
| CK, 24 h | **less in older** | −0.28 (−0.63, −0.08), *P* = 0.011 | INHERITED |
| CK, peak | **less in older** | −0.26 (paper also reports SMD −0.32 in the abstract for 24 h and peak) | INHERITED |

Conclusion in the paper, verbatim in sense: **advancing age is not associated with greater EIMD.** Older adults can pursue regular activity without concern for greater damage. Lancaster/Middlesex press (7 Apr 2025) quoted ~34% less soreness at 48 h and ~62% at 72 h, CK ~28% lower at 24 h — those percentages are **UNVERIFIED_SECONDARY** restatements of the SMDs; use the SMDs.

**Sex (do not average):** meta-regression found a sex relationship for *peak muscle function change* (significant in males SMD −0.45, not in females SMD −0.44 as reported — the paper flags the male comparison as the one that reached significance). Female EIMD-by-age is under-powered. Hayes, Stevenson, Sayer, Granic, Hurst (2023) *Sports Med Open* scoping review (older = 65+): older **women** in Clarkson/Dedrick and Ploutz-Snyder lost more strength and recovered it **more slowly**; older **men** in Lavender & Nosaka often showed *smaller* EIMD. **Do not copy the male EIMD sign onto women.**

**Limitation that matters for the game:** most included “older” groups are geriatric or untrained, not 35–45 combat athletes still taking camps. Relative load is often matched; absolute work is smaller in older groups, which can *reduce* damage. That is the opposite of a veteran still sparring at camp intensity.

#### The middle-aged trained band (closest to a 41-year-old fighter — still INHERITED)

Fernandes, Lamb, Twist (2019) *Sports* 7(6):132. Resistance-trained young males 22.3 ± 1.7 y (n=9) vs resistance-trained middle-aged 39.9 ± 6.2 y (n=9) vs untrained middle-aged 44.4 ± 6.3 y (n=9). Protocol: 10 × 10 squats at 60% 1RM. **Trained middle-aged had likely/very-likely moderate greater losses in MVC, resting doublet force, and squat peak power at 20% and 80% 1RM vs young, at 24–72 h.** Untrained middle-aged worse still on peak power and soreness. **This is the single most game-relevant EIMD paper this desk found**, and it supports slower *force/power* recovery around 40 vs 22 in trained men. It is still not fighters, n is small, males only. INHERITED. **Do not turn “moderate greater loss at 72 h” into a 0.85 multiplier.**

#### Masters athletes, performance-matched (INHERITED, conflicting)

| study | who | bout | physical recovery | perceptual | grade |
|-------|-----|------|-------------------|------------|-------|
| Schmidt, Ferrauti, Kellmann et al. (2021) *Front Physiol* 12:665204 | 8 young 22.1 ± 2.1 vs 8 masters 52.4 ± 3.5, **matched half-squat 1RM ~135–141% BW**, testosterone 17.4 vs 8.3 pg/ml | 9×8 + failure set eccentric-biased squats 70% 1RM | **Masters neither more fatigued nor slower to 72 h** on MVIC, twitch, CMJ, CK. Hypothesis of slower recovery **rejected**. Younger had *higher* acute soreness and lower PPC at post-0 | MMR (CWI+compression) helped soreness/PPC, not performance, regardless of age | INHERITED |
| Easthope, Hausswirth, Louis, Lepers, Vercruyssen, Brisswalter (2010) *Eur J Appl Physiol* 110:1107–1116 | 10 young 30.5 ± 7 vs 13 masters 45.9 ± 5.9, well-trained trail | 55 km trail race | MVC −32% young vs −40% masters (*P*<0.01); locomotion efficiency −4.6 vs −6.3% (*P*<0.05). **Similar damage; recuperation slowed in masters** through 72 h | — | INHERITED (runners, eccentric-heavy) |
| Doering, Jenkins, Reaburn, Borges, Hohmann, Phillips (2016) *Med Sci Sports Exerc* 48(8):1613–1618 | 5 masters triathletes 53 ± 2 vs 6 younger 27 ± 2 | 3 days intense endurance after muscle-damaging run; 20 g protein post-ex | Myofibrillar FSR **1.49 ± 0.12 vs 1.70 ± 0.09 %·d⁻¹** (*P*=0.009, *d*=1.98). Cycle TT 10 h post-run: masters −3.0% vs young −1.4% (moderate between-group *d*=0.51, trend) | — | INHERITED (triathlon, n=11) |
| Borges, Reaburn, Doering, Argus, Driller (2018) *Exp Aging Res* 44(4):338–349 | 9 masters cyclists 55.6 ± 5.0 vs 8 young 25.9 ± 3.0 | 6 × 30 s @ 175% PPO | **No group×time on MVC, 10 s sprint, 30 min TT, CK.** Physical recovery similar. CK %Δ <10% | Masters: more fatigue, soreness, less motivation at 48 h (moderate ES) | INHERITED |
| Borges thesis / related (VO2 kinetics after HIT) | same cyclist groups | HIT recovery | τV̇O2 **217 ± 44 s masters vs 170 ± 36 s young** (*P*=0.029) — slower *metabolic* recovery in the first minutes | — | INHERITED (not between-round fight data) |
| Fell, Reaburn, Harrison (2008) *J Sports Med Phys Fitness* (as cited in Borges 2016 review) | veteran vs young cyclists, consecutive TTs | — | **No performance drop; veterans *felt* more sore/fatigued** | perceptual lag | INHERITED via review |

**Pattern this desk will defend:** after *eccentric, muscle-damaging, long* work (trail, high-volume squats in the 40-year-old trained male), recovery of force can be slower. After *matched-strength gym work* or *non-damaging HIT cycling*, physical recovery often is not. Perceived recovery is more consistently worse in masters even when the wattage is back. **None of this is a fighter camp.**

#### Combat-sport DIRECT for Q1

**None found this pass.** No sourced time-course of DOMS, isometric force, or readiness-to-spar by age in boxers, MMA, Muay Thai, kickboxing, wrestling, judo, BJJ, taekwondo, karate, or sambo. ARP 2024 says age-related MSK changes “may prolong their recovery” — that sentence is about **injury** (Q2) and clearance, not session-to-session EIMD.

#### Folklore vs evidence (Q1)

| slogan | ruling |
|--------|--------|
| “A 41-year-old takes 50–100% longer to bounce back from sparring” | **UNKNOWN.** Fitness-app tables (Cora 2026: 24–48 h in the 20s, 48–72 h in the 40s, 72–96 h in the 50s) are **UNVERIFIED_SECONDARY** and not combat. |
| “Older muscle always gets more damaged” | **False as a pooled claim** (Fernandes/Hayes 2025). |
| “Older athletes feel it more even when the numbers are back” | **Plausible INHERITED** (Borges 2018; Fell 2008). Useful as flavour, not as a heal-clock. |
| “Anabolic resistance means slower repair from ~30” | Mechanism is real in sedentary aging (Cuthbertson 2004; Kumar 2009) and still present in masters triathletes (Doering 2016). **INHERITED mechanism, UNKNOWN as camp days.** Doering used 20 g protein — the younger-athlete dose — so the MPS gap may be partly nutritional. |

**Q1 bottom line for R54:** session-to-session recovery slowing with age is **not established in fighters** and is **not established as a universal adult law**. The honest encoding is **UNKNOWN**. If the game authors a small veteran “camp drag,” label it authored. Do not cite Fernandes/Hayes 2025 as proof that veterans heal *slower* — that paper’s headline is the opposite on soreness and null on function.

---

### Q2 — Injury healing vs age (weeks-to-return; distinct from Q1)

**Short answer:** Clinical writers and one MMA RTS paper say older fighters are slower to *get back*, or less likely to *come back*. **Weeks-to-heal by tissue, in steps, across 19–41, is not sourced.** Soft tissue, bone, and concussion/RHI must stay separate. Amateur ladders and pro floors stay separate.

#### Combat / ringside (closest to DIRECT)

| claim | number | what it actually is | grade |
|-------|--------|---------------------|-------|
| ARP 2024, *Care of the Older Fighter* | none | “Older fighters may take longer time to recover from musculoskeletal injury; post-injury clearance should be individualized.” Older fighter defined **>35**. | **DIRECT** as a clinical statement. **UNKNOWN** as weeks. |
| ARP 2024, same paper | none | “It is unclear at present whether an older fighter needs a longer suspension to recover from a concussion.” | **DIRECT** as the uncertainty. Do not invent a longer KO hold. |
| Kingery et al. (2021) *Phys Sportsmed* (PubMed 34236932) | OR **0.822** (*P*=0.001) | Pro MMA, public data, fighters who **withdrew from a card for injury** 2012–2014, n=454, mean age at injury **30.0 ± 3.9**. 94.4% returned; mean time to next pro fight **6.8 ± 6.7 months** (range 0.3–58). **Older age → lower odds of returning.** Win% after return vs uninjured opponents: no difference (*P*=0.691). | **DIRECT** to male-heavy pro MMA card-withdrawals. Confounded by who gets rebooked, not a tissue-heal clock. The 6.8 months is a booking interval, not a biology interval. |
| UFC ACLR (Arthrosc Sports Med Rehabil 2024, PMC11551401) | 411.85 ± 174.73 days to next fight (range 165–879); RTS 81.25% for ≥1 fight, 56.25% for ≥2 | Mean age at ACLR **30.04 ± 3.83**; 22 men, 5 women in the 2-fight analytic set. **No age-stratified weeks published in the pages pulled.** | DIRECT as UFC ACLR interval. **UNKNOWN** as age-step. |
| MMA shoulder injuries (PMC12156349, 2025) | win% 81.96 → 54.7 post-injury (*P*<0.001); 76.5% surgical | Mean age **32.84** (22–44), all male, n=27 fighters / 34 injuries. Recurrence 22.2%. **No age×weeks table.** | DIRECT as performance drop after shoulder injury. UNKNOWN as age-heal. |
| Australian MMA/Muay Thai event HPs (PMC12119424, 2025) | median days impacted: MMA 20, MT 16 | Age 27 ± 6; **not age-stratified**. | DIRECT as event HP duration. UNKNOWN vs age. |

**Kingery OR 0.822 is not a heal multiplier.** A 41-year-old vs a 19-year-old is 22 years. 0.822^22 ≈ 0.014 if you abused the OR as a per-year compounding factor — that would say almost nobody 41 returns, which is false on its face and is not what the paper measured (the sample mean is 30, SD 3.9; it is not a 19-to-41 curve). **Do not exponentiate that OR into BodyReadiness.**

#### Soft tissue — muscle/tendon/ligament (INHERITED unless noted)

**Hamstring (best numeric age term this desk found — still not combat):**

Schmitt, Tyler, Kwiecien, Fox, McHugh (2020) *Int J Sports Phys Ther* 15(3):421–428. **n=19 male athletes, age 28 ± 9**, mixed field sports (rugby, Gaelic, baseball, softball, lacrosse, soccer, track, tennis — **no combat**). RTS 43 ± 36 days. Age alone R² = 0.27, *P* = 0.024. Combined with % length of tenderness:

> days to RTS = (% length of tenderness × 2.1) + (age × 1.5) − 43.4  (R² = 0.73)

Worked example in the paper: same 10% tenderness length → **20-year-old 11 days, 30-year-old 23.1 days**. That is **+1.2 days per year of age at matched injury size** inside this tiny male sample and this rehab protocol (which the authors say is slower than typical, by design, to cut reinjury).

**Grade: INHERITED, male-only, n=19, not fighters.** JOSPT 2022 hamstring CPG repeats the equation (Table 10, citing this paper as ref 82). **Do not put +1.5 days/year of age into six body regions.** The coefficient is protocol-specific and the sample cannot support a game law.

Other soft-tissue notes (keep separate):

| tissue | age finding | grade | do not |
|--------|-------------|-------|--------|
| Hamstring *risk* (not heal time) | Australian rules ~1.3× HSI risk per extra year of age; soccer ~1.9× (JOSPT 2022 CPG citing prior epi) | INHERITED (football codes) | Treat risk as heal-time |
| Calf in runners >40 | Mayo Clinic News Network 2022 clinical Q&A: younger ~6–8 weeks, ~50 yo “possibly 12 weeks or more” | **UNVERIFIED_SECONDARY** (expert Q&A, not a cohort) | Use as a 2× law |
| Muscle strain grades | Grade 1 often 2–3 weeks, grade 2 4–8, grade 3 months — **by grade, not by age** | INHERITED as grade windows | Age-scale the grades |
| ACLR RTS | Professional football pooled ~261 days / 8.7 months (2026 meta, 1,992 players); UFC ~412 days. Time is criteria + concomitant procedures, **not a published adult-age step from 19 to 41** | INHERITED / DIRECT as sport-specific means | “Older ACL takes N more weeks” |
| Rotator cuff | RTS rates high in recreational athletes >40; chronological age often *not* the driver vs tear size (Rhee et al. as cited in Nolte 2021). One 2026 massive-tear series: older age → lower odds of clinically meaningful scores | INHERITED, mostly >50–60 surgical populations | Copy onto a 33-year-old fighter’s shoulder region |
| Tendon collagen turnover | Heinemeier et al.: Achilles *core* collagen essentially does not turn over from ~17 to 70 | INHERITED mechanism | A weeks-to-heal table |
| Proximal hamstring *repair* >60 vs <60 (Bote 2026 *Arthroscopy*) | PROM and RTS **not different** at 2 years (U-60 mean age 49 vs O-60 mean 66) | INHERITED; wrong age band for 19-vs-41 | Use as “age does nothing” inside the game’s range |

#### Bone (INHERITED; adult 19–41 is not the geriatric fracture literature)

| finding | grade | note |
|---------|-------|------|
| Wollstein et al. (2020) *HAND*: metacarpal fractures, age **not** associated with clinical healing time as a continuous variable (*P*=0.09); >75 not slower (*P*=0.58). Fracture pattern and renal failure mattered. | INHERITED (hand surgery, not combat) | The adult boxing-hand case is closer to this than to hip-fracture geriatrics. |
| Cureus 2025 smoking/fracture cohort: **age per year HR 0.99 (0.98–1.01), *P*=0.27** — not a significant delay; smoking and open fracture were. | INHERITED | |
| Animal/basic science: delayed endochondral ossification in elderly mice (~14 days lag) | INHERITED, not human weeks | |
| Osteoporosis / senescence literature: impaired healing is a **geriatric / comorbid** problem | INHERITED | Onset of material bone-healing delay inside 19–41 **UNKNOWN**. ARP 2024: athletes with osteoporosis should be discouraged from combat — a clearance rule, not a heal-time. |
| Hand/wrist in pro athletes: mean RTP 2.8 months; boxers longest (~6 months, often operative) (systematic review PMC7534880). Mean athlete age 25.7. **Not age-stratified.** | INHERITED / mixed sports | |

**Bone in the game’s six regions:** no sourced extra weeks from 19 to 41. If a region is a fracture, heal by **injury type and treatment**, not birthday.

#### Concussion / RHI RTP (do not mix amateur ladders with pro floors; do not mix youth vs adult with 19 vs 41)

| source | finding | grade |
|--------|---------|-------|
| Putukian et al. (2023) *Br J Sports Med* 57:798–809 (Amsterdam concussion systematic review) | Mean days symptom-free 14.0 (12.7–15.4); RTS 19.8 (18.8–20.7). **13–18 y:** symptom-free 16.2, RTS 18.9. **>18 y:** symptom-free 9.7, RTS 15.4. Authors: overlap in CIs; **all cohorts have similar recovery patterns**; initial symptom burden is the strongest predictor. Female point estimates longer but CIs overlap. | DIRECT as SRC pooled data (not combat-specific). **Opposite of “older adults need more days” inside the adult vs adolescent cut.** |
| ACSM team-physician statement (2021, still cited) | Typical SRC 2 weeks adults, up to 4 weeks children | INHERITED consensus |
| Hume et al. (2022) *J Int Neuropsychol Soc* | mTBI in **60+**: many do well; 67% good functional recovery on GOS at 6 months+. Different question (geriatric mTBI, not fighter RTP). | INHERITED, wrong band |
| ARP concussion consensus (2018) + ARP older-fighter (2024) | Combat SRC should be stricter than non-combat. TKO head ≥30 d; KO no LOC ≥60 d; KO with LOC ≥90 d (ARP 2018). **2024: unclear if older fighter needs longer concussion suspension.** | DIRECT |
| World Boxing *Medical Handbook* 2025 §8 | Single KO/RSC-H no LOC ≥**30 d**; with LOC ≥**90 d**; two in 3 months ≥**90 d**; three in 12 months ≥**1 year**. **No age modifier in the suspension table.** Elite category 19–40; >40 is Masters (a category, not a longer hold). | DIRECT |
| Florida Stat. §548.041; Minnesota pro boxing; Colorado 4 CCR 740-1.6 | Typical pro floors KO 60 d / TKO 30 d (state-dependent). Colorado extra *tests* at 45 if not routinely fighting 5 years — not extra KO days. | DIRECT (J10 already mapped the disagreement across states) |

**Clinical windows do not sourced-lengthen with adult age in steps.** Youth vs adult is the sourced split, and it goes the other way. Combat commissions already use **longer** floors than sport-SRC 14–20 days; those floors are **injury-mechanism ladders**, not age ladders.

#### Skin / laceration (INHERITED, often 20s vs 50–70)

Engeland, Bosch, Cacioppo, Marucha (2006) mucosal wounds: older (≥50) healed slower than younger regardless of sex; at day 5 wounds 56% larger in older; women slower than men. **INHERITED, oral mucosa, 50+ vs young.** Cutaneous aging delays re-epithelialization (Rittié 2016 *Aging Cell*: aged ESG outgrowths, 72% vs 86% closed at day 7 in one human experimental wound model). **UNKNOWN as extra days on a 33-year-old cutman repair.** Commissions already suspend on cuts via physician discretion (NYSAC 30–90+ with specialist clearance) — age is not the published increment.

**Q2 bottom line:** weeks-to-return **by tissue** does not have a sourced adult age-step the game can lift. What *is* sourced: (1) ARP clinical statement that MSK recovery *may* be longer and clearance should be individual; (2) older MMA athletes less likely to *return* after a card injury; (3) one tiny male hamstring sample where age added days at matched tenderness length. **R54 must not average these into one body-heal slope.**

---

### Q3 — Thresholds? (game used 30/33; R52 removing)

**Short answer:** Evidence does **not** support a recovery threshold at 30 or 33. Commission ages are **clearance/licence gates**, not healing-rate kinks. If anything is a bend in general physiology, writers point at **~35–40** (testosterone response, ARP “older fighter,” CV screening). That is still not a recovery_scale step.

| cut | what it is | recovery-rate evidence | grade |
|-----|------------|------------------------|-------|
| Game 30 / 33 | authored, R52 removing | **None.** No paper this pass uses 30 or 33 as an EIMD or RTP kink. | UNKNOWN as physiology |
| ARP older fighter **>35** | definition + high-risk (LOE V, ARP 2026) | Heightened medical *risk* and extra CV screening from 35; neuro imaging emphasis from ~40. “May prolong recovery” is not “multiplies heal time at 35.” | DIRECT as a clinical category |
| NSAC **38** (or turns 38 this calendar year) | Comprehensive Contestant: MRI/MRA, ECG, dilated eye, chest x-ray, extra labs | Licence battery. **Not** a longer KO suspension. | DIRECT |
| NYSAC **40+** | High-risk combatant (with 6 consecutive losses, 3 consecutive TKO/KO, 1+ year inactive, 10+ career losses) | Extra CV/neuro testing. KO/TKO still 30–90+ by physician, not by age. | DIRECT |
| ARP neuro **40** | MRI+MRA at licensure; repeat MRI every 3 years; NP testing | Imaging cadence, not hold days | DIRECT |
| Colorado **45** + not routinely fighting 5 years | Extra physical / SAFE / EKG | Comeback testing | DIRECT |
| World Boxing Elite **19–40**; Masters **>40** | Category band | Not a suspension multiplier | DIRECT |
| IBJJF Adult → Masters 1 at **30** | Category (J10 D5) | Not recovery | DIRECT as a category, irrelevant to heal clocks |
| Anabolic / testosterone literature **~35–40** | Reduced T response to resistance exercise (Vingren 2010, as cited by Schmidt 2021) | Mechanism for *adaptation*, not a 24-h EIMD step | INHERITED |
| Sarcopenia ARP **~40** | Clinical onset cited in J10 | Mass/strength, not session recovery | INHERITED via ARP |

**Gradient or threshold?** The EIMD meta-analysis is **two bins**, not a slope. Hamstring age enters a **linear** regression (age × 1.5) — that is a gradient inside n=19, not a cliff. Kingery’s OR is per-year in a sample clustered at 30. **No sourced bend function across 18–45 for fighters.**

**Linear or bend?** **UNKNOWN** as a fit. Folklore “falls off at 30” is what J10 already killed for peaks; it is not resurrected for recovery. If the game authors a curve, a **shallow gradient after ~35** is more consistent with *commission behaviour* and anabolic writing than a step at 30 — and that sentence is still **UNKNOWN as a number**.

---

### Q4 — Years vs mileage?

**Short answer:** Chronological age and accumulated load are **confounded** and **both independently named** in the best combat sources. Nothing this pass *quantifies the split* as “X% of slower recovery is birthday, Y% is rounds.” The game has both numbers; it should **not** throw one away.

| evidence | age still in the model after load? | load still in the model after age? | grade |
|----------|------------------------------------|------------------------------------|-------|
| Hutchison, Lawrence, Cusimano, Schweizer (2014) *Am J Sports Med* — 844 UFC matches, **all male**, mean age 29.8 | Age ≥35: KO OR **1.94** (1.03–3.61), TKO-from-strikes OR **1.96** (1.18–3.22) **after controlling for prior KO/TKO, round, match significance** | Each prior KO/TKO: KO OR **1.30** | DIRECT (male UFC outcomes, not heal time) |
| PFBHS Bernick et al. (2015) *Br J Sports Med* | Age 18–44 sample; processing speed **−0.19% per fight**, **−2.1% per FES step**; boxers worse than MMA at the same age | Exposure, not birthday, is the published slope | DIRECT (cognition, not MSK heal) |
| Ritter et al. (2022) *Neurology* | Stopping fighting ≥2 years → group-mean *improvement* in verbal memory, processing, psychomotor speed vs matched actives | Reversibility tracks **cessation of exposure** | DIRECT |
| NSAC Physical 2025 | 38 **or** 36 months inactive **or** >425 pro rounds → same Comprehensive Contestant battery | Three **independent** triggers | DIRECT |
| ARP 2026 high-risk | Age >35 **and** 3 consecutive KO/TKO **and** inactivity >1 year **and** no wins **and** concussion history as separate flags | Flags, not a formula | DIRECT |
| Clausen, McCrory, Anderson (2005) *BJSM* | Pro boxing career length collapsed 19 y → ~5 y across eras (exposure change) | Duration ≠ age | DIRECT (J10) |
| Kirk 2018 / 2024 | Heavier divisions older *populations*; winner/loser age gap small | Rank/age not isolated from career length | DIRECT as population ages (J10). UNKNOWN as recovery. |
| Kingery 2021 MMA RTS | Age associated with *whether* they return | Injury that scratches a card is the event; career-length confound not removed | DIRECT as RTS odds, not a decomposition |

**What the game should not do:** key `recovery_scale` off age alone and ignore rounds/KO history. **What it also should not do:** assume mileage *explains away* age. Hutchison’s ≥35 OR survives prior-KO control. ARP and NSAC bother to write both.

**Decomposition (how much of “slower” is years vs mileage):** **UNKNOWN.** That is the honest Q4 answer. R54 can still *use* both inputs as flags.

---

### Q5 — Medical hold: do ARP / NSAC / ABC-family lengthen mandatory suspension by age, or require extra clearance?

**Short answer:** **Extra clearance: yes. Longer mandatory suspension by age: no, not in the rules pulled.** A rule is DIRECT. This is the cleanest page in the file.

#### Extra clearance (DIRECT)

| body | age trigger | what is added | hold days added by age? |
|------|-------------|---------------|-------------------------|
| ARP 2014 older-fighter consensus | **≥40** | MRA at outset; annual MRI, EKG, stress echo (or echo+stress), formal neurocognitive, CBC/CMET, dilated eye | No |
| ARP 2024 *Care of the Older Fighter* | **>35** defined older; CV from 35; neuro imaging **40** | AHA 14-point + annual ECG from 35; MRI/MRA SWI/GRE at licensure from 40, MRI every 3 years, NP every 3 years; BP >160/100 disqualifying until controlled; osteoporosis → discourage competition; post-injury MSK clearance **individualized** | **No.** Explicitly **unclear** if concussion suspension should be longer. |
| ARP 2026 high-risk (Munshi et al., *Clin J Sport Med*) | **>35** (LOE V) among other flags | Identify as high-risk; not a day table | No |
| NSAC Physical 2025 | **38+** (or turns 38 this year) **and/or** no pro fight in 36 months **and/or** >425 pro rounds | Comprehensive Contestant: MRI brain no contrast (every 5 years), MRA once, ECG, dilated ophthalmologist exam, chest x-ray (6 y), extra chemistry | **No** |
| NYSAC Medical Manual (2024) | **40+** (or 6 consecutive losses / 3 consecutive TKO-KO / 1+ year inactive / 10+ losses) | Extra CV and neuro testing (MRI SWI/GRE, MRA, NP/ImPACT, cardiac, extended labs) | **No.** All fights: 7-day admin rest. KO/TKO head: 30–90+ **physician discretion** + neurologist clearance. |
| Colorado 4 CCR 740-1.6 | **45+** and not routinely fighting 5 years | Extra physical / SAFE / EKG | **No.** Post-fight minima are mechanism-based (7-day rest; TKO/cuts ≥30 d, etc.). |
| World Boxing 2025 | Elite 19–40; Masters >40 as a **category** | Same KO ladder for the suspension table | **No** |
| ABC Unified Rules MMA (2019 text / 2025 PDF exists) | — | In-bout medical stoppage and foul recovery (e.g. 5 min low blow). **No age-scaled post-fight suspension in the unified rules pages used.** Suspension remains a **commission** matter. | **No age term found** |

ARP 2024 also notes: only ~31 US state/tribal commissions specify an age threshold for extra licensing/oversight, and those thresholds run **35–40**, usually neuro and/or cardiac, rarely ophthalmologic. That is a map of **clearance heterogeneity**, not a heal-time.

#### Mandatory suspension ladders (age-blind in the text)

Already in J10; restated so R54 does not “fix” them with age:

- World Boxing / AIBA-family amateur: 30 / 90 / 90 / 1 year by KO/RSC-H count and LOC.  
- Typical US pro floors: KO 60 d / TKO 30 d (FL, MN); NYSAC 30–90+ discretionary; APBC-family 28–90. **They disagree with each other.**  
- ARP 2018 combat concussion: TKO head 30 / KO no LOC 60 / KO+LOC 90, plus no sparring for the same window.

**None of these published ladders add days because the fighter is 36.** Physician *discretion* can always go longer; that is already how holds work, and ARP says individualize MSK clearance. Encoding discretion as `age * 1.2` would be authored.

**Q5 bottom line:** R54’s medical-hold half should **read extra-clearance flags** (J10’s retirement-pressure table already listed `age_ge_35`, `age_ge_38_nsac`, `rounds_gt_425_nsac`). It should **not** multiply `medical_hold_until_week` by age and call that a commission rule.

---

### Q6 — Does anything recover *better* with age?

**Ask it honestly. Yes, a few things — none of them are a fighter heal-clock running faster.**

| candidate | what is sourced | is it “recovery”? | grade |
|-----------|-----------------|-------------------|-------|
| **Less EIMD soreness and often less CK** | Fernandes/Hayes 2025: older adults *less* sore at 24/48/72 h and peak; lower CK at 24 h and peak | It is the opposite of “heal slower from training.” Mechanism guesses: stiffer connective tissue, lower absolute load, repeated-bout / lifetime exposure, nociception | INHERITED (not fighters). **Do not encode as a veteran advantage in camp** without a fighter replication — but do not encode the opposite either. |
| **Repeated-bout effect still exists when old** | Lavender & Nosaka; Chen et al. in Hayes 2023 scoping review: repeated bouts reduce soreness in older men, sometimes less protection for MVC | Adaptation, not “better than young” | INHERITED |
| **Decision / pacing / fight IQ holding while physicals fall** | Kirk (2016a, cited in Kirk 2018): older MMA winners more often by **decision**. Allen & Hopkins 2015: skill-sport peaks later than speed sports. J10 already used this for `technique`/`fight_iq` *direction* | This is **performance strategy**, not tissue recovery. A veteran may *need* less damaging sparring because they already know the camp. That is a design hook, not a sourced heal rate | DIRECT as bout-method pattern (male MMA); UNKNOWN as a recovery offset |
| **Perceived fatigue can be *higher* while watts are back** | Borges 2018; Fell 2008 | Worse, not better | INHERITED |
| **Stopping fighting improves cognition** | Ritter 2022: retired ≥2 years improved vs matched actives | Recovery of brain *after load is removed*, not better recovery while still taking camps | DIRECT |
| **Running / cycling economy in some masters** | Tanaka & Seals 2008: endurance *performance* often holds ~to 35 then modest decline; highly trained masters can preserve economy | INHERITED endurance. UNKNOWN in fighters. UFC PI VO2 is **not** age-stratified in the pages J10/J12 pulled | INHERITED / UNKNOWN in combat |
| **Estrogen / female EIMD** | Kendall & Eston 2002 (as cited in Fernandes/Hayes 2025): possible protective effect vs structural damage | Sex difference, not “gets better with age.” Post-menopause would go the other way if the mechanism is estrogen — **UNKNOWN in female fighters 35–45** | INHERITED, do not average |
| **Experience reducing stupid mileage** | Industrial knowledge; ARP mismatch / inactivity flags imply camps are not all equal | Plausible design. **No rate.** | UNKNOWN as an offset magnitude |

**Nothing sourced says a 41-year-old’s torn tissue closes faster than a 19-year-old’s.** The honest “better with age” list is: **less session soreness in general-adult EIMD (INHERITED, conflicting in the 40-year-old trained-male squat paper), better tactics (DIRECT as decision-win pattern), and brain recovery if they *stop* (DIRECT).** Those are not a negative `recovery_scale`.

---

## 2. Lift-ready: what `Aging.recovery_scale()` could honestly encode

**Read this first:** a cell with a number and grade UNKNOWN is **not** a citation. J10 already taught this for yearly stat deltas. Same rule here.

Suggested object (research, not a patch): either **do not create** `recovery_scale()`, or create it as `1.0` with `grade: UNKNOWN` and a comment that R54 authored any deviation. BodyReadiness continues to heal by activity/damage profile. Age touches **clearance flags** and, if the operator insists on feel, an authored drag labelled UNKNOWN.

### 2.1 Rows that *can* be encoded (each graded)

| id | what to encode | suggested shape | already in game? | grade | one-line evidence |
|----|----------------|-----------------|------------------|-------|-------------------|
| `clearance_age_ge_35` | High-risk / extra CV screening | Flag. Does **not** change heal weeks. | No (age integer exists) | **DIRECT** | ARP 2024 older fighter >35; ARP 2026 high-risk LOE V |
| `clearance_age_ge_38_nsac` | Comprehensive contestant battery | Flag (MRI/MRA, ECG, dilated eye, …) | No | **DIRECT** | NSAC Physical 2025 |
| `clearance_age_ge_40_nysac_arp_neuro` | High-risk + neuro imaging cadence | Flag | No | **DIRECT** | NYSAC 40+; ARP MRI/MRA at 40, every 3 years |
| `clearance_age_ge_45_co_comeback` | Extra tests if not routinely fighting 5 years | Flag for inactivity×age | No inactivity clock | **DIRECT** | Colorado 4 CCR 740-1.6 |
| `mileage_rounds_gt_425` | Same NSAC battery as age 38 | Flag, **independent of age** | No rounds-total in excerpts (J10) | **DIRECT** | NSAC Physical 2025 |
| `mileage_inactive_36mo` | Same NSAC battery | Flag | No | **DIRECT** | NSAC |
| `mileage_inactive_12mo_arp` | High-risk | Flag | No | **DIRECT** | ARP 2026 |
| `prior_ko_tko` | Raises subsequent KO odds; not a heal multiplier | Flag / count | Not confirmed as career total in excerpts | **DIRECT** as KO risk (Hutchison OR 1.30) | Hutchison 2014 |
| `age_ge_35_ko_risk` | Higher finish risk, male UFC | Flag for matchup/medical, **not** heal weeks | No | **DIRECT** (male UFC) / **INHERITED** if copied to women | Hutchison 2014 OR 1.94/1.96. J10 D6: do not copy onto women’s books unlabelled. |
| `msk_clearance_individual` | After injury, older fighter’s return is physician-gated, not calendar-gated | Already the spirit of `medical_hold_*` if a human/commission object exists | Partial (week clock only) | **DIRECT** as ARP instruction | ARP 2024: individualized post-injury clearance |
| `mma_injury_rts_odds_fall_with_age` | Older MMA less likely to take the next pro fight after a card injury | Career/booking pressure, **not** region-heal | No | **DIRECT** as RTS *probability* in one 2012–14 public-data sample | Kingery 2021 OR 0.822. **Do not use as a weeks multiplier.** |
| `ko_ladder_age_blind` | Keep 30/60/90/365-class holds independent of age | Already the real ladders | Hold weeks exist, ladder not (J10) | **DIRECT** | World Boxing 2025; ARP 2018; FL/MN/CO. ARP 2024: longer concussion hold for older **unclear**. |

### 2.2 Rows the game might want that must be labelled UNKNOWN if authored

| temptation | if authored | grade of the *number* | why it is not researched |
|------------|-------------|------------------------|--------------------------|
| `recovery_scale(age)` = 1.0 below 30, 0.85 at 41, … | Only as `grade: UNKNOWN` | **UNKNOWN** | No combat paper; EIMD pooled data do not give this slope; Fernandes 2019 is a moderate force-loss at ~40 vs ~22 in n=9 trained men, not a scale. |
| Camp-heal days × 1.2 after 35 | UNKNOWN | **UNKNOWN** | ARP “may prolong” is MSK *injury*, not sparring DOMS. Q1 is conflicting. |
| Region-heal weeks × (1 + 0.02×(age−25)) | UNKNOWN | **UNKNOWN** | Hamstring +1.5 d/year is n=19 males, one protocol, one tissue. Bone 19–41 null/unknown. Concussion adult not longer. |
| Multiply `medical_hold_until_week` by age band | **Do not** even as authored-without-label | Would **contradict DIRECT rules** | Commissions do not do this. |
| 30 or 33 as a recovery kink | **Do not** | Contradicts Q3 | R52 removing is correct. |
| Copy Hutchison male KO ORs onto heal speed | **Do not** | Wrong object | Finish risk ≠ tissue clock. |
| Sex-averaged recovery_scale | **Do not** | J10 D6 | Female EIMD-by-age incomplete; women’s MMA injury-heal vs age **UNKNOWN**. |

### 2.3 Do-not-encode list (explicit)

1. **No researched `recovery_scale()` multiplier.** UNKNOWN is the complete R54 answer for the number.  
2. **No 30/33 recovery threshold.**  
3. **No age-lengthened KO/TKO/RSC mandatory days.** Extra clearance yes.  
4. **No single slope applied to training-load recovery *and* injury weeks *and* concussion *and* bone.** Those literatures disagree.  
5. **No exponentiating Kingery OR 0.822 into a 19-vs-41 heal factor.**  
6. **No lifting Schmitt 2020 hamstring `age × 1.5` onto six body regions or onto women.**  
7. **No encoding Fernandes/Hayes 2025 as “veterans heal slower.”** That paper’s result is null-to-less EIMD.  
8. **No encoding Fernandes 2019 moderate force loss as a 15% game penalty.** n=9, males, squats, not a fight camp.  
9. **No sex-averaged recovery.**  
10. **No amateur/pro averaged ladders** (World Boxing 30/90 vs FL 60/30). J10 already said they disagree.  
11. **No “chin”** (J10 D8).  
12. **No yearly `speed`/`power` deltas smuggled in as recovery** (J10 D3).  
13. **No catalog rows of named real athletes.**  
14. **No reopening J10 peak windows.**  
15. **No claiming between-round recovery is sourced-slower with age in fighters.** Borges τV̇O2 is masters cyclists after HIT, INHERITED, minutes not rounds.

### 2.4 If the operator answers “author a feel anyway”

Store something like: `recovery_scale: 1.0` default; optional authored band `maturing / peak / declining` that **does not change hold days**; declining band may apply a **small camp-fatigue residual** labelled `grade: UNKNOWN`. Do not put that number in a “researched” column. J10 already wrote the same sentence for retirement-pressure weights.

---

## 3. What this desk could NOT source

This list is first class. Mark these UNKNOWN in data rather than filling them.

1. **A `recovery_scale()` or percent-slower-per-year of age** for any combat sport.  
2. **Fighter time-course of DOMS / force / readiness** after a hard session, by age (Q1 DIRECT).  
3. **Weeks-to-return by body region × age** for the game’s six regions.  
4. **Soft-tissue healing delay 19 vs 41** in boxers/MMA (the hamstring +1.2 d/year is n=19 male field-sport).  
5. **Bone healing delay 19 vs 41** in combat athletes (adult metacarpal paper found no age effect).  
6. **Concussion/RHI RTP lengthening across adult ages** (Putukian: not supported; ARP: unclear).  
7. **Age-multiplied mandatory suspension** in ARP, NSAC, NYSAC, CSAC, ABC unified rules, World Boxing, Florida, Minnesota, Colorado.  
8. **Linear vs bent recovery curve** across 18–45.  
9. **Decomposition of chronological age vs rounds vs prior KO vs inactivity** as shares of “slower recovery.”  
10. **Female combat-sport recovery-vs-age** (EIMD, injury RTP, or holds).  
11. **Amateur vs pro recovery-vs-age** (ladders differ; physiology split UNKNOWN).  
12. **Muay Thai / kickboxing / wrestling / judo / BJJ / taekwondo / karate / sambo** recovery-vs-age datasets.  
13. **Between-round lactate/VO2/power restoration vs age in fighters.**  
14. **UFC Performance Institute age-stratified recovery or VO2 tables.** (J10 already: 2018 book exists; age curve not extracted.)  
15. **Sex-specific injury-heal slopes in combat.**  
16. **Laceration extra days by age** inside 19–41 (mucosal/cutaneous papers are often ≥50 vs young).  
17. **Cartilage / disc / rib-costal cartilage** age-step in fighters.  
18. **A replication of Fernandes 2019 in combat athletes.**  
19. **Whether R54 / R52 / R51 already shipped a recovery_scale.** Not in this workspace (same posture as J10 on `Aging.gd`).  
20. **A number that makes a 41-year-old and a 19-year-old *feel* different that is not authored.**

---

## 4. Priority ruling and one operator question

**P0**  
1. Do **not** block R54 on a sourced recovery factor. The factor is UNKNOWN. That is the result.  
2. Encode **extra-clearance / high-risk flags** at 35 / 38 / 40 / 45 plus independent mileage flags (425 rounds, 12-month and 36-month inactivity, prior KO/TKO, 3-KO-in-12-months amateur ladder). These are DIRECT and already outlined in J10 §1.4.  
3. Keep **training-load recovery** and **injury weeks** and **concussion holds** as separate objects. Do not average them (this file’s D2 / D6).  
4. Do **not** lengthen `medical_hold_until_week` by age.

**P1**  
If the player-facing veteran week is empty without a drag: author a small camp residual, `grade: UNKNOWN`, and do not cite this file’s physiology tables as the number.

**P2**  
Masters-athlete flavour (feel more wrecked while force is back). Decision-win pattern for veterans (J10 / Kirk). Neither is a heal multiplier.

**One operator question:**  
Should R54 **author** a labelled-UNKNOWN `recovery_scale()` so the 41-year-old’s week is not identical to the 19-year-old’s, or keep BodyReadiness **age-blind on healing clocks** and only add extra-clearance / high-risk flags (this desk’s recommendation, because Q1 is conflicting, Q2 has no weeks-step, and Q5’s rules do not multiply hold days)?

---

## 5. Sources (verified 2026-09-07)

**Peer-reviewed / official (prefer these):**

1. Fernandes JFT, Wilson LJ, Dingley AF, Hearn AN, Johnson KO, Hicks KM, Twist C, Hayes LD. (2025). Advancing age is not associated with greater exercise-induced muscle damage: a systematic review, meta-analysis, and meta-regression. *J Aging Phys Act* 33(6):606–624. https://doi.org/10.1123/japa.2024-0165 — PubMed: https://pubmed.ncbi.nlm.nih.gov/40174882/ — accepted manuscript PDF: https://eprints.lancs.ac.uk/id/eprint/227837/1/JAPA_-_Ageing_EIMD_meta_v3.pdf  
2. Hayes EJ, Stevenson E, Sayer AA, Granic A, Hurst C. (2023). Recovery from resistance exercise in older adults: a systematic scoping review. *Sports Med Open* 9:51. https://doi.org/10.1186/s40798-023-00597-1 — PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC10317890/  
3. Fernandes JFT, Lamb KL, Twist C. (2019). Exercise-induced muscle damage and recovery in young and middle-aged males with different resistance training experience. *Sports* 7(6):132. https://doi.org/10.3390/sports7060132  
4. Fernandes JFT, Lamb KL, Norris JP, Moran J, Drury B, Borges NR, Twist C. (2020). Aging and recovery after resistance-exercise-induced muscle damage: current evidence and implications for future research. *J Aging Phys Act*. https://doi.org/10.1123/japa.2020-0201  
5. Schmidt J, Ferrauti A, Kellmann M, et al. (2021). Recovery from eccentric squat exercise in resistance-trained young and master athletes with similar maximum strength. *Front Physiol* 12:665204. https://doi.org/10.3389/fphys.2021.665204  
6. Easthope CS, Hausswirth C, Louis J, Lepers R, Vercruyssen F, Brisswalter J. (2010). Effects of a trail running competition on muscular performance and efficiency in well-trained young and master athletes. *Eur J Appl Physiol* 110:1107–1116. https://doi.org/10.1007/s00421-010-1597-1 — PubMed: https://pubmed.ncbi.nlm.nih.gov/20703499/  
7. Doering TM, Jenkins DG, Reaburn PR, Borges NR, Hohmann E, Phillips SM. (2016). Lower integrated muscle protein synthesis in masters compared with younger athletes. *Med Sci Sports Exerc* 48(8):1613–1618. https://doi.org/10.1249/MSS.0000000000000935 — PubMed: https://pubmed.ncbi.nlm.nih.gov/27433963/  
8. Borges NR, Reaburn PR, Doering TM, Argus CK, Driller MW. (2018). Age-related changes in physical and perceptual markers of recovery following high-intensity interval cycle exercise. *Exp Aging Res* 44(4):338–349. https://doi.org/10.1080/0361073X.2018.1477361 — PubMed: https://pubmed.ncbi.nlm.nih.gov/29843564/  
9. Borges N, Reaburn P, Driller M, Argus C. (2016). Age-related changes in performance and recovery kinetics in masters athletes: a narrative review. *J Aging Phys Act* 24(1):149–157. https://doi.org/10.1123/japa.2015-0021  
10. Bianchi D, Sethi NK, et al. (2024). Care of the older fighter: position statement of the Association of Ringside Physicians. *Phys Sportsmed* 52(6):585–591. https://doi.org/10.1080/00913847.2024.2344227 — PubMed: https://pubmed.ncbi.nlm.nih.gov/38708547/ — summary PDF: https://ringsidearp.org/wp-content/uploads/2024/05/OlderFighters-Summary.pdf  
11. ARP (2014). Consensus statement on medical clearance of the older fighter. https://ringsidearp.org/wp-content/uploads/2020/01/Medical-Clearance-of-the-Older-Fighter.pdf  
12. Munshi J et al. (2026). Identifying high-risk combat sport athletes: position statement of the ARP. *Clin J Sport Med* 36(3):218–223. https://journals.lww.com/cjsportsmed/fulltext/2026/05000/identifying_high-risk_combat_sport_athletes_.2.aspx  
13. Neidecker J et al. / ARP. (2018). Concussion management in combat sports: consensus statement from the Association of Ringside Physicians. *Br J Sports Med*. https://bjsm.bmj.com/content/53/6/328  
14. Nevada Athletic Commission. Unarmed combatant physical 2025 (Comprehensive Contestant = 38+ / 36 months inactive / >425 rounds). https://boxing.nv.gov/uploadedFiles/boxingnvgov/content/Licensing/PHYSICAL-2025_W-INSTR.pdf  
15. NAC 467.562 (medical suspension until fit). https://www.law.cornell.edu/regulations/nevada/NAC-467-562  
16. NYSAC Medical Manual (2024). High-risk 40+; 7-day admin rest; KO/TKO 30–90+ discretionary. https://dos.ny.gov/system/files/documents/2024/05/nysac-medical-manual-5-8-2484.pdf  
17. Colorado 4 CCR 740-1.6 (post-fight suspensions; age 45 extra tests if not routinely fighting 5 years). https://www.law.cornell.edu/regulations/colorado/4-CCR-740-1.6  
18. Florida Stat. §548.041 (KO 60 days / TKO 30 days floors). https://www.flsenate.gov/Laws/Statutes/2024/0548.041  
19. World Boxing. *Medical Handbook* 2025 (§8 suspension periods; Elite 19–40; Masters >40). https://worldboxing.org/wp-content/uploads/2025/08/WB-Medical-Handbook-2025.pdf  
20. ABC Unified Rules index. https://www.abcboxing.com/unified-rules/ — 2025 MMA PDF: https://www.abcboxing.com/wp-content/uploads/2025/08/Unified-Rules-of-MMA-8.2025.pdf  
21. Kingery et al. (2021). Performance and return to sport after injury in professional mixed martial arts. *Phys Sportsmed*. https://doi.org/10.1080/00913847.2021.1953358 — PubMed: https://pubmed.ncbi.nlm.nih.gov/34236932/  
22. Hutchison MG, Lawrence DW, Cusimano MD, Schweizer TA. (2014). Head trauma in mixed martial arts. *Am J Sports Med*. PubMed: https://pubmed.ncbi.nlm.nih.gov/24658345/  
23. Bernick C et al. (2015). Repeated head trauma associated with smaller brain volumes and slower processing (PFBHS). *Br J Sports Med*. ScienceDaily numbers page: https://www.sciencedaily.com/releases/2015/01/150129185147.htm  
24. Ritter A et al. (2022). Longitudinal changes in cognitive functioning and brain structure in professional boxers and mixed martial artists after they stop fighting. *Neurology*. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC9694836/  
25. Putukian M et al. (2023). Clinical recovery from concussion—return to school and sport: a systematic review and meta-analysis. *Br J Sports Med* 57:798–809. https://doi.org/10.1136/bjsports-2022-106682 — PubMed: https://pubmed.ncbi.nlm.nih.gov/37316183/  
26. Schmitt BM, Tyler TF, Kwiecien SY, Fox MB, McHugh MP. (2020). Mapping tenderness to palpation predicts return to play following acute hamstring strain. *Int J Sports Phys Ther* 15(3):421–428. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC7297001/  
27. Academy of Orthopaedic Physical Therapy / AASPT. (2022). Hamstring strain injury in athletes: CPG. *J Orthop Sports Phys Ther* 52(3):CPG1–CPG44. https://doi.org/10.2519/jospt.2022.0301 (repeats Schmitt equation in Table 10).  
28. Wollstein R et al. (2020). The effect of age on fracture healing time in metacarpal fractures. *HAND*. https://doi.org/10.1177/1558944718813730  
29. Tanaka H, Seals DR. (2008). Endurance exercise performance in Masters athletes. *J Physiol* 586(1):55–63.  
30. Engeland CG, Bosch JA, Cacioppo JT, Marucha PT. (2006). Mucosal wound healing: the roles of age and sex. *Arch Surg* (as indexed; ResearchGate copy used this pass).  
31. Rittié L et al. / related: reduced ESG outgrowth delays wound closure in elderly skin. *Aging Cell* (PMC5013029). https://pmc.ncbi.nlm.nih.gov/articles/PMC5013029/  
32. UFC ACLR RTS: *Arthrosc Sports Med Rehabil* (PMC11551401). https://pmc.ncbi.nlm.nih.gov/articles/PMC11551401/  
33. Kirk C. (2018). Age and divisional rank in professional MMA. *Facta Univ.* PDF: https://shura.shu.ac.uk/27929/1/3797-25364-1-PB.pdf (decision-win pattern via Kirk 2016a as cited; J10).  
34. Kirk C. (2024). 5-year analysis of age in MMA. VoR: https://shura.shu.ac.uk/32072/8/Kirk-5-YearAnalysisAge%28VoR%29.pdf  

**UNVERIFIED_SECONDARY (direction only, not numbers to lift):**

35. Lancaster / Middlesex press on Fernandes/Hayes 2025 (7 Apr 2025). https://www.mdx.ac.uk/news/2025/4/muscle-damage-study/ — https://www.eurekalert.org/news-releases/1079191  
36. Mayo Clinic News Network (2022). Calf injuries in runners over 40 (6–8 vs ~12 weeks). https://newsnetwork.mayoclinic.org/discussion/mayo-clinic-q-and-a-common-calf-muscle-injuries-in-runners-over-40/  
37. Cora App (2026). Muscle recovery time by age table. https://www.corahealth.app/blog/muscle-recovery-time-by-age  
38. Combat Sports Law (2024-05-09). ARP older-fighter recap. https://combatsportslaw.com/2024/05/09/ringside-doctors-publish-peer-reviewed-position-on-licencing-older-fighters/  

**Local:**

39. `/workspace/j12/TASK_J12.md`  
40. `/workspace/j12/J10_THE_YEARS.md` (peak windows, UNKNOWN yearly deltas, ARP/NSAC flags, grade vocabulary; **do not reopen**)  

---

## 6. Implementation notes for Claude (research, not a patch)

- `BodyReadiness` healing by activity only is the live fact this desk was asked to judge. The honest patch is **flags**, not a researched scale.  
- If R51/R52 already shipped 30/33 as recovery cutoffs, write the contradiction down; R52 removing them matches Q3.  
- Medical hold is the existing hook. Extra clearance should **read** `age` + fight history the way NSAC reads 38 / 425 rounds / 36 months as **OR** triggers.  
- Do not silently decay `conditioning` under the name of recovery. J10 already forbade yearly conditioning deltas as facts.  
- Female books: women’s recovery-vs-age is UNKNOWN. Do not copy male Kingery / Hutchison / Schmitt coefficients.  
- Amateur books: World Boxing ladder is age-blind; Masters is a category at 40, not a longer hold.

---

*End of J12. Research only. 2026-09-07. R54’s recovery half is UNKNOWN as a number and DIRECT as extra-clearance flags. That is a complete answer.*

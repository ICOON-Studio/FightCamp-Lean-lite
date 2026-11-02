# J33 — What the Sport Actually Measures About a Fighter

Research date: **2026-09-21** (Asia/Nicosia). Live web + Fightnomics OCR text (archive.org) re-opened this turn. Claims labeled **DOCUMENTED / INFERENCE / NOT FOUND**. Evidence base only — no game attribute list, no recommendations, no invented numbers.

**Blocker:** `grok` CLI failed repeatedly (`Error: No such device or address (os error 6)` / invalid `--output-format`). Research completed via WebSearch, WebFetch, curl of Fightnomics djvu text, PMC HTML.

---

## DECISIONS (evidence only)

1. **What leagues publish as fighter qualities are rates with named denominators** (landed÷attempted, landed÷minutes, defence = opponent misses÷opponent attempts). They are **not** “heart,” “fight IQ,” or a stable “chin trait.” — DOCUMENTED (UFC Stats labels; FightMetric glossary).
2. **Chin / durability as a fixed trait separate from defence: NOT FOUND on official logs.** What *is* measured: (a) **offensive** Knockdown Rate = distance KDs ÷ landed distance power head strikes (UFC mean **3.9%**); (b) population **absorbs-per-KD by recipient age** (fewer strikes needed to KD older fighters — “a third as many” early-20s vs forties); (c) third-party “Knocked Down per 100 Power Strikes Absorbed.” Official career page has **SApM** and **Str. Def**, not chin. — DOCUMENTED / NOT FOUND as stated.
3. **Cardio lab literature does distinguish VO₂max from Wingate/anaerobic power**, with published ranges; fight-night “cardio” as a single UFC Stats field: **NOT FOUND**. Round-to-round KD power fade is published (KD rate 5.3%→2.4%→1.5% R1–R3). — DOCUMENTED.
4. **Grappling decomposition that exists officially:** TD Acc, TD Def, TD Avg (/15 min), Sub Avg (**attempts**/15 min), CTRL time, Passes, Reversals. **Submission defence %**, **guard retention %**, **scramble win %** as UFC career metrics: **NOT FOUND**. TIP ground share and “share of ground time in control” exist in Fightnomics/FightMetric TIP, not as a public fighter-page field. — DOCUMENTED / NOT FOUND.
5. **Significant-strike accuracy is published but is largely a product of shot selection/position**, not pure “technique.” UFC (2025) published **Expected / Weighted Striking Accuracy** for that reason; historical distance-power-head accuracy mean **~24%** (SD 7.8%) vs overall sig-strike accuracy ~**40%**. — DOCUMENTED.
6. **Age:** Youth Advantage (≥4 yr gap, other advantages filtered) → younger win ~**60%**. Mechanism strongest for **KO resiliency**, not pace/accuracy. Peak timing (modern re-analysis) median **30.6** (IQR peaks 28.0–33.2). Strike pace by age and TD rates by age as published continuous tables: **weak/NOT FOUND** as clean league curves (Fightnomics: pace “didn’t change much with age”). — DOCUMENTED / NOT FOUND.
7. **Reach advantage is real above ~2″**; ≥**6.5″** → longer fighter wins **~⅔** of fights; effect **accentuated** when fight >70% standing TIP (**~74%** at largest gap), **nullified** when >70% ground (**~49%** longer-fighter WR). Height without reach: **not** an advantage (Fightnomics). — DOCUMENTED.
8. **Loud NOT FOUNDs:** heart; fight IQ; chin-as-stable UFC trait; official submission defence %; scramble outcomes; IBJJF athlete career “guard retention”; continuous strike-pace-by-age table.

---

## Catalog of measured qualities

Each row: quality | what is measured (stat + **exact denominator**) | published number / spread | source + sample | label.

### A. UFC / FightMetric — official career / bout logs

| Quality | Stat + denominator | Published number / spread | Source + sample | Label |
|---------|-------------------|---------------------------|-----------------|-------|
| Significant-strike offense (pace) | **SLpM** = Σ significant strikes landed ÷ fight minutes | Fighter-level career rate on ufcstats.com; league fight-level often ~2.8–3.8 landed/fighter/min (validation corpora; re-confirm per era) | UFC Stats fighter pages; FightMetric SLpM definition | DOCUMENTED (definition); league mean era-dependent |
| Significant-strike absorption (pace) | **SApM** = Σ opponent significant landed ÷ same fight minutes | Career rate on fighter pages | FightMetric blog 2011; ufcstats.com | DOCUMENTED |
| Striking accuracy | Significant **landed ÷ significant attempted** | Career % on fighter pages; analyst mean ~**40%** overall; distance power head mean **24%** (SD **7.8%**; bulk 16–32%) | UFC Stats; Fightnomics accuracy chapter; Szilagyi 2020 | DOCUMENTED |
| Striking defence | Opponent significant **misses ÷ opponent significant attempts** (= 1 − opponent accuracy against you) | Career **Str. Def %** | UFC Stats tooltip; AgentMMA explainer matching official label | DOCUMENTED |
| Knockdowns scored | Official **KD** count (not KO) | Bout column; Record Book KD Avg per 15 min | ufcstats.com; UFC Record Book | DOCUMENTED |
| Knockdown Rate (power) | Distance KDs ÷ **landed distance power head strikes** | UFC average **3.9%** (~1 KD / 26 landed); R1 **5.3%**, R2 **2.4%**, R3 **1.5%**; HW R1 ~**10%**; BW R3 **0.4%** | Fightnomics (FightMetric era through ~2013) | DOCUMENTED |
| Takedowns | Landed when fighter “deliberately grapples opponent to ground and establishes advantageous position for appreciable time” | Definition only | FightMetric glossary (MMA Fighting 2011-05-09) | DOCUMENTED |
| TD Avg | Takedowns **landed per 15 minutes** fight time | Career rate | ufcstats.com | DOCUMENTED |
| TD accuracy | TD **landed ÷ TD attempted** | League ~**40%** success; attempts ~**1.5 per 5-min round** (historical UFC) | Fightnomics Uber Tape / grappling chapters | DOCUMENTED |
| TD defence | Opponent TD **stuffed ÷ opponent TD attempted** (= 1 − opponent TD Acc vs you) | Benchmark **~60%** when league TD Acc = 40% | Fightnomics; ufcstats.com | DOCUMENTED |
| Submission attempts | Actual holds applied (not failed hip swings) | **Sub. Avg** = attempts **per 15 min**; ~**1–2 attempts per 15-min fight**; overall finish success of attempts ~**20%**; RNC finish >**40%** of RNC attempts | FightMetric glossary; Fightnomics sub chapter (1,318 fights, 2007–Q2 2012) | DOCUMENTED |
| Submission defence % | — | — | Not on UFC Stats career radar | **NOT FOUND** (official) |
| Passes | Incremental positional advancement on ground, held appreciable time | Bout-level count | FightMetric glossary | DOCUMENTED (count exists; league mean rate **NOT FOUND** as public average) |
| Reversals | Bottom → top without opponent standing in between | Bout-level count | FightMetric glossary | DOCUMENTED (count); league mean **NOT FOUND** |
| Control time (CTRL) | Sustained positional control (top ground or controlling clinch/fence) | Bout `CTRL`; Record Book career control leaders | UFC Stats; Record Book | DOCUMENTED |
| TIP — Distance / Clinch / Ground **time** | Share of **total fight clock** in each phase | Standing >**⅔**; clinch **16%** (2001) → **18%** (2013); ground approached ~**⅓** of minutes (2013) | Fightnomics TIP / Assume the Position | DOCUMENTED |
| Share of ground time in control | Ground control time ÷ **total ground TIP** (per fighter career rollup) | League must average **50%**; fighter-specific in Uber Tape | Fightnomics (TIP rollup) | DOCUMENTED (method); public fighter-page field **NOT FOUND** |
| Height / Reach / Stance / DOB | Anthropometrics on fighter page | Division means published in Fightnomics (2013 roster snapshot) | UFC Stats; Fightnomics | DOCUMENTED |

### B. Boxing — CompuBox / time-motion

| Quality | Stat + denominator | Number / spread | Source + sample | Label |
|---------|-------------------|-----------------|-----------------|-------|
| Punches thrown / landed | CompuBox counts per round; connect % = landed÷thrown | Often-cited historical averages ~**50–70** thrown / round (both combined context varies); connect ~**30–40%**; fighter leaders on CompuBox reports e.g. Stevenson ~**39.8%** connect, **15.2** landed/round (report-period dependent) | CompuBox data site reports; BoxingScene historical reviews (secondary) | DOCUMENTED for existence of metric; **league-wide single mean** treat as **era/sample-dependent** |
| Amateur activity profile | Punches / defensive moves / hip movements **per minute** of round | Elite male Olympic: ~**20 punches/min**, sustained across 3 rounds (Davis et al.) | Davis et al. 2015 *IJSPP* (PubMed 24912199); 29 bouts | DOCUMENTED |
| Clinch frequency / time | Clinches per round; total clinch seconds per round | Male: freq 2.5→4.8; time 12.6→28.7 s R1–R3 | Davis 2015 | DOCUMENTED |

### C. Lab physiology (MMA / boxing / MT — not fight-night stats)

| Quality | Stat + denominator | Number / spread | Source + sample | Label |
|---------|-------------------|-----------------|-----------------|-------|
| Aerobic capacity | **VO₂max** (mL·kg⁻¹·min⁻¹), graded ergometer | Lower-limb MMA review range **44.2±6.7 → 62.8±4.9**; upper-limb **45.8±2.9 → 55.0**; world-class treadmill: lighter (&lt;185 lb) **53.4±4.5**, heavier **48.1±5.7** (n=20) | Spyrou et al. 2019 PMC6628448 review; IU Sports Innovation Journal 20 world-class MMA | DOCUMENTED |
| Anaerobic power | Wingate **peak / mean power (W/kg)**; fatigue index % | Upper-limb PP **7.79–10.45**, MP **5.8–8.21** W/kg; FI **43.4%** and **58.1%** (cited studies in review) | Same PMC review | DOCUMENTED |
| Lactate | [La] mmol/L post-test / simulated bout | Review cites **14.6±1.7** and **10.0** mmol/L (post-exercise); combat lit commonly &gt;10 | PMC review; high-intensity conditioning review | DOCUMENTED |
| Anaerobic threshold | %HRmax / %VO₂max at AT | e.g. **92±2%** HRmax & **81±9%** VO₂max (Alm); **90%** HRmax & **74%** VO₂max (Tota) | PMC review | DOCUMENTED |

### D. Grappling sports outside UFC

| Quality | Stat + denominator | Number / spread | Source + sample | Label |
|---------|-------------------|-----------------|-----------------|-------|
| BJJ guard pass success → win | Matches with ≥1 successful pass; win rate **among those matches** | Pass → win **99.6%**; mean **0.2** passes/match; sweeps **1.4**/match → win **64%** | BJJ Heroes; **1,089** adult black-belt IBJJF Worlds/Pans 2016–2019 | DOCUMENTED |
| Judo ippon finish share | Contests ending by ippon ÷ contests | **46.2%** ippon endings (yearly 42.4–49.2%) | Escobar-Molina et al. / MDPI Appl. Sci. 2023; **2,340** WC contests 2018/19/21 | DOCUMENTED (from search abstract synthesis; PDF fetch blocked this turn — grade B until PDF re-open) |
| NCAA wrestling dual metrics | Bout W-L, bonus rate, TD/pin/TF counts | Team-level published (e.g. season W%, bonus %); not a universal athlete “defence %” like UFC | NCAA scoring explainers | DOCUMENTED as scoring system; fighter-style career radar **NOT FOUND** |

---

## Q1 — DURABILITY / CHIN

### What is measured

| Claim | Label | Detail |
|-------|-------|--------|
| Official “chin” or knockdown-resistance career %, separate from Str. Def / SApM | **NOT FOUND** | UFC Stats fighter radar: SLpM, Str Acc, SApM, Str Def, TD*, Sub Avg — **no chin field**. |
| Offensive Knockdown Rate | **DOCUMENTED** | Distance KDs ÷ landed distance power head strikes; UFC mean **3.9%** (Fightnomics). Measures **striker power**, not recipient chin. |
| Absorbed power per knockdown by **recipient age** | **DOCUMENTED** | Fightnomics: “Distance Power Head Strikes Absorbed Per Knockdown” by age of recipient; trend: **~⅓ as many** landed strikes to KD a fighter in his **forties** vs **early twenties**. Tests age-resiliency at population level. |
| Hypothesis tests isolating chin vs defence vs pace | **DOCUMENTED (negative for pace/accuracy)** | Fightnomics Youth chapter: older fighters keep similar power-head **defence** and similar **pace**; jab defence worsens slightly; **Hypothesis #3** (same blows drop older fighters more) supported. |
| Survivorship bias acknowledged | **DOCUMENTED** | Round-wise KD fade partly confounded: glass jaws exit early; Fightnomics states categorizing strong vs weak chins was **not done** (“save that analysis for another time”). |
| Third-party absorber metric | **DOCUMENTED (non-official)** | FightingData: “Knocked Down per 100 Power Strikes Absorbed” = mirror of KD rate from opponent rows (UFCStats-derived). |
| Career KD absorbed vs SApM correlation (peer-reviewed league table) | **NOT FOUND** | Fan analyses exist; no primary peer-reviewed UFC table re-opened this turn with r / n. |
| Prior KD / prior KO → future KO risk | **DOCUMENTED (analyst)** | UFCalendar 2026: 16,429 UFC appearances since 2005; never-dropped KO-loss rate **13.9%** vs **≥5 career KDs → 25.3%**; ≥4 prior KO losses → next-fight KO loss **29.3%** vs never-stopped **13.8%**. Absorbed head-strike volume alone **did not** predict washing (survivorship). |
| Boxing “chin toughening” / knockdown resistance lab trait | **NOT FOUND** as sport performance metric | Biomechanics/concussion literature measures head kinematics, neck strength — **not** a published fighter “chin rating” with CompuBox denominator. |

### Answer to the Q1 question

**Published evidence does *not* give a stable, defence-independent “chin” attribute on official fight logs.** What exists is: (1) how often a fighter **drops others** per landed power head strike; (2) how many power head strikes **populations** absorb per KD as **age** rises; (3) third-party absorber-per-KD rates; (4) history of being dropped/KO’d as a **risk factor** for future stoppages. Fightnomics explicitly treats age-related resiliency decline as brain/cumulative trauma proxy and notes **chin categorization was never completed**. **Chin-as-fixed-trait: NOT FOUND.**

---

## Q2 — CARDIO

### Lab distinction: aerobic vs repeat-effort / anaerobic — DOCUMENTED

| Construct | Measure | Numbers | Source | Label |
|-----------|---------|---------|--------|-------|
| Aerobic capacity | VO₂max mL·kg⁻¹·min⁻¹ | MMA lower-limb **44.2±6.7 to 62.8±4.9**; upper **45.8±2.9 to 55.0**; n=20 world-class treadmill lighter **53.4±4.5** vs heavier **48.1±5.7** | Spyrou et al. 2019 review; IU SIJ world-class MMA | DOCUMENTED |
| Anaerobic alactic/lactic power | Wingate PP, MP (W/kg), FI % | Upper PP **7.79–10.45**, MP **5.8–8.21**; FI **43.4% / 58.1%** | Same review | DOCUMENTED |
| Glycolytic stress | Blood lactate mmol/L | Post-test **~10–14.6** in cited MMA studies; combat reviews note &gt;10 in sims | PMC review | DOCUMENTED |
| Threshold | %HRmax / %VO₂max at AT | **90–92%** HRmax; **74–81%** VO₂max at AT (cited) | PMC review | DOCUMENTED |

### Fight-night / time-motion cardio proxies

| Claim | Label | Detail |
|-------|-------|--------|
| UFC “cardio” career stat | **NOT FOUND** | No VO₂ or Wingate on ufcstats.com. |
| Round-to-round knockdown power fade | **DOCUMENTED** | KD rate **5.3% → 2.4% → 1.5%** (R1–R3); attributed mainly to **fatigue** (striker power drop), with survivorship caveat | Fightnomics |
| Power-head accuracy slight drop / jab accuracy rise late | **DOCUMENTED** | Fightnomics fatigue section | DOCUMENTED |
| Fade Index (R3 pace / R1 pace) | **DOCUMENTED (third-party)** | FightingData formula from UFCStats rounds | DOCUMENTED as published method |
| Davis boxing: punch rate collapse R1→R3 | **NOT FOUND as decline** | Elite male amateurs ~**20 punches/min** sustained; winners separated by late accuracy/landed, not simple pace collapse (Davis 2015) | DOCUMENTED |

**Answer:** Literature **does** separate VO₂max from Wingate/repeat anaerobic measures with numbers. Fight sports **do not** publish a single fight-night “cardio” attribute; the closest published in-fight signals are pace fade, KD-rate fade, and lactate after sims.

---

## Q3 — GRAPPLING DECOMPOSITION

| Component | Measured? | Stat + denominator | Number | Label |
|-----------|-----------|-------------------|--------|-------|
| Takedown accuracy | Yes | Landed ÷ attempted | League ~**40%**; elite often &gt;**60%** career | DOCUMENTED Fightnomics / UFC Stats |
| Takedown attempts | Yes | Per 5-min round or per 15 min (TD Avg uses **landed**/15) | ~**1.5 attempts / 5-min round** historical UFC | DOCUMENTED |
| Takedown defence % | Yes | Opponent stuffed ÷ opponent attempts | Benchmark ~**60%** | DOCUMENTED |
| Ground control time | Partially | Bout **CTRL** seconds; TIP ground share of **fight clock** | Ground → ~**⅓** of fight minutes (2013); CTRL on bout pages | DOCUMENTED |
| Share of ground TIP in control | Analyst yes / page no | Control ground time ÷ ground TIP | Must avg **50%** league | DOCUMENTED Fightnomics; **NOT FOUND** as ufcstats career field |
| Submission attempts | Yes | Holds applied; Sub Avg = attempts/15 min | **1–2** attempts / 15-min fight | DOCUMENTED |
| Submission success | Analyst yes | Finishes ÷ attempts (by type) | Overall ~**20%**; RNC &gt;**40%** | DOCUMENTED Fightnomics (1,318 fights) |
| Submission defence % | **No (official)** | — | — | **NOT FOUND** on UFC Stats career |
| Guard retention / pass rates (UFC) | Passes counted; retention % no | Pass = positional advancement count | — | Passes **DOCUMENTED** as count; **retention % NOT FOUND** |
| Scramble outcomes | **No** | — | — | **NOT FOUND** |
| Wrestling NCAA dual metrics | Scoring only | Decision/major/TF/pin team points; bout W-L | Rules DOCUMENTED; UFC-style defence % **NOT FOUND** | Mixed |
| Judo ippon rates | Bout-outcome share | Ippon endings ÷ contests | **46.2%** (2,340 WC contests) | DOCUMENTED (B until PDF) |
| IBJJF pass rates | Match observational | Passes/match; pass→win | **0.2** passes/match; **99.6%** win if pass | DOCUMENTED BJJ Heroes n=1,089 |

---

## Q4 — ACCURACY vs TECHNIQUE

| Claim | Label | Detail |
|-------|-------|--------|
| Raw sig-strike accuracy is official | **DOCUMENTED** | Landed ÷ attempted significant strikes |
| Raw accuracy confounded by shot selection / position | **DOCUMENTED** | UFC.com 2025-02-05: ground-body ~**93%** land rate vs distance-head ~**33%**; same 49% Acc can be +4 or −4 vs **Expected Accuracy** |
| Expected / Weighted Striking Accuracy | **DOCUMENTED** | UFC 2025: actual − expected by strike-type mix; O’Malley +**18.5** pts expected (min 5 fights) cited as top | UFC.com |
| Distance power head accuracy distribution | **DOCUMENTED** | Mean **24%**, SD **7.8%** (Fightnomics) | Different denominator than “all significant” |
| Opponent-adjusted / weight-class expected strikes | **DOCUMENTED (analyst)** | Szilagyi 2020 ufc.stats: expected = division-mean Acc × attempts; efficiency vs peers | DOCUMENTED |
| Test–retest reliability of Acc as latent “technique” trait | **NOT FOUND** | No ICC/retest paper opened this turn | **NOT FOUND** |
| CompuBox connect % | **DOCUMENTED as metric** | Landed÷thrown; typically ~30–40% band in secondary summaries; CompuBox leaderboards show fighter-period % | Treat single “league average” as sample-dependent |

**Answer:** Accuracy is **measured**, but primary sources (UFC 2025; Fightnomics power-head vs all-sig) treat it as **heavily mixture-dependent**, not a clean technique latent. Opponent-/mix-adjusted metrics exist to partial out selection.

---

## Q5 — AGE EFFECTS

| Finding | Number | Denominator / sample | Label |
|---------|--------|----------------------|-------|
| Isolated Youth Advantage | Younger wins ~**60%** (**59.5–60.4%** chart text) when age gap **≥4 years**, stance/reach filtered | UFC (+WEC/SF chart overlays) Fightnomics | DOCUMENTED |
| Win-rate tipping | Performance decline after ~**32**; isolated cut: 20s above .500, 30s not | Fightnomics age curves | DOCUMENTED |
| How older fighters **lose** | KO/TKO loss share rises with age; **36–38** KO’d at nearly **2×** rate of **22–23** | UFC ~5-year window in book | DOCUMENTED |
| Mechanism | Not pace (&lt;10% pace effect); not power-head defence; **fewer absorbed power-head strikes per KD** with age (~**⅓** early-20s vs forties) | Fightnomics hypotheses 1–3 | DOCUMENTED |
| Submission loss risk | Older **less** likely to lose by submission (qualitative + charts) | Fightnomics | DOCUMENTED |
| Strike pace by age (continuous league table) | “Didn’t change much with age” | Fightnomics | DOCUMENTED narrative; **detailed rate table NOT FOUND** in extract |
| TD rates by age | — | — | **NOT FOUND** as published age curve this turn |
| Modern peak age | Median peak **30.6**; half of peaks **28.0–33.2**; median last fight **34.6**; **3.4** years peak→exit; post-peak WR **30.8%**, KO-loss **25.9%** of remaining | UFCalendar 2026; 485 retirees ≥8 UFC fights; 16,429 appearances | DOCUMENTED (analyst DB) |
| Age × KO-loss rate bands | &lt;25: WR **58.1%**, KO-loss **10.4%** … ≥37: WR **37.7%**, KO-loss **24.6%** | Same 16,429 | DOCUMENTED |
| Boxing peak-age / punch-rate-by-age | General peak late 20s–early 30s in secondary reviews | — | Weak for punch-rate-by-age; **NOT FOUND** clean CompuBox-by-age primary this turn |

**What decays first (from published evidence):** Fightnomics points to **knockdown resiliency / KO susceptibility**, not skill accuracy or output pace. Grapplers aging better is **narrative/analyst** (UFCalendar examples), not a measured “grappling IQ” trait.

---

## Q6 — REACH / FRAME

| Finding | Number | Sample / filter | Label |
|---------|--------|-----------------|-------|
| Reach advantage real if gap **&gt;~2″** | Longer fighters win more; mid gaps **&gt;10-point** WR swing | Fightnomics UFC 2008–Oct 2013 (**1,578** fights stated in chapter dataset note) | DOCUMENTED |
| Large gap **≥6.5″** | Longer wins **almost ⅔** | Same | DOCUMENTED |
| Mostly standing (&gt;70% TIP) | Overall longer WR **56%**; largest gap ~**74%**; ≥2.5″ standing → **60%** | TIP filter | DOCUMENTED |
| Mostly ground (&gt;70% TIP) | Longer WR **~49%** (nullified) | TIP filter | DOCUMENTED |
| Height without reach | **Not** an advantage | Fightnomics chapter summary | DOCUMENTED |
| Wingspan:height | UFC mean ratio **1.03** | Fightnomics | DOCUMENTED |
| Modern replication | Longer won **51.9%** of 6,532 unequal-reach fights; **6″+** → **59.4%** (596 fights); &lt;2″ → **49.9%** | FightAlpha through May 2026 | DOCUMENTED |
| Reach → KD rate effect size | — | — | **NOT FOUND** as published KD-rate-by-reach table this turn |
| Ape index → win % table | Ape = reach−height listed; win% by ape band | FightAlpha defines ape; **banded ape→WR table NOT FOUND** | Partial |
| Logistic reach_diff OR | ~**0.19%** odds increase per inch reach_diff | Justin L Ross analysis (UFC 1993–2026 model) | DOCUMENTED (analyst); small effect vs SLpM/TD |

---

## WHAT I COULD NOT FIND

Loud **NOT FOUND** (searched; do not invent):

1. **Heart** — no published fight metric with denominator.
2. **Fight IQ** — no published metric with denominator.
3. **Chin-as-stable official trait** independent of Str. Def / age / prior KD history.
4. **UFC submission defence %** on career pages.
5. **Guard retention %** / **scramble win %** (UFC).
6. **Career KD absorbed vs SApM** peer-reviewed correlation table with r and n.
7. **Continuous TD-attempt rate by age** and **SLpM by age** official curves (Fightnomics says pace flat; no fine table extracted).
8. **Reach → knockdown rate** effect-size table.
9. **IBJJF athlete career radar** equivalent to UFC Stats (only match-observation studies).
10. **CompuBox single immutable league mean** (period-dependent; secondary sites disagree).
11. **Test–retest reliability** of striking accuracy as latent skill.

---

## SOURCES

| URL | Who | Year | Sample | What it says | Grade |
|-----|-----|------|--------|--------------|-------|
| https://www.mmafighting.com/2011/05/09/171293/fightmetric-stats-glossary | FightMetric via MMA Fighting | 2011 | Glossary | Definitions: significant strikes, TD, passes, sub attempts, reversals | A |
| https://www.ufc.com/news/does-striking-accuracy-accurately-measure-striking | UFC.com | 2025-02-05 | Historical strike-type rates; broadcast examples | Expected/Weighted Acc; distance-head ~33% vs ground-body ~93% | A |
| http://www.ufcstats.com/ (fighter pages) | UFC Stats | live 2026 | All logged UFC fights | SLpM, Str Acc, SApM, Str Def, TD Avg/Acc/Def, Sub Avg, CTRL, KD | A |
| https://archive.org/download/pdfy-yiL1jFk4ZOeZkg4d/Fightnomics%20%5BThe%20Hidden%20Numbers%20And%20Science%20Of%20Martial%20Arts%5D_djvu.txt | Reed Kuhn, *Fightnomics* (OCR) | 2013–14 | FightMetric UFC (+era notes); e.g. 1,318 fights subs; 1,578 fights reach dataset note | KD rate 3.9%; Youth Advantage; reach; TIP 16→18% clinch; TD 1.5/rnd @40%; sub ~20% | A (primary book; OCR typos) |
| https://www.mmaoddsbreaker.com/news/3995-94hacking-the-tale-of-the-tape-how-old-is-old-in-the-ufc/ | Kuhn / Fightnomics | 2014 | UFC historical | Youth Advantage; resiliency after 31; KD risk after 35 | B |
| https://www.mmaoddsbreaker.com/news/3321-20snapstats-who-is-the-hardest-hitter-at-ufc-174/ | Kuhn | 2014 | UFC/Strikeforce/WEC | KD Rate definition; UFC avg 3.9% | A/B |
| https://www.mmaoddsbreaker.com/news/2111-10decyphering-the-fightnomics-uber-tale-of-the-tape/ | Kuhn | ~2013 | Uber Tape | TD 1.5/rnd, 40% Acc, 60% Def benchmark | A/B |
| https://pmc.ncbi.nlm.nih.gov/articles/PMC6628448/ | Spyrou et al. | 2019 | Review of MMA physio studies | VO₂max & Wingate ranges, lactate, AT | A |
| https://journals.indianapolis.iu.edu/index.php/sij/article/view/27565 | IU SIJ | ~2024 | n=20 world-class MMA | VO₂max 53.4±4.5 vs 48.1±5.7 by weight band | A (abstract/page; PDF blocked) |
| https://pubmed.ncbi.nlm.nih.gov/24912199/ | Davis et al. | 2015 | 29 elite male amateur bouts | ~20 punches/min activity profile | A |
| https://tamaszilagyi.com/ufc.stats/articles/2020-04-15-striking.html | Szilagyi | 2020 | UFC Stats package | ~40% Acc mean; expected-strikes efficiency | B |
| https://fightingdata.com/methodology/ | FightingData | live | UFCStats-derived | KD per 100 absorbed; Fade Index; control % formulas | B |
| https://fightalpha.com/articles/does-reach-matter-ufc | FightAlpha | 2026-05 | 6,532 unequal-reach fights | Longer 51.9%; 6″+ 59.4% of 596 | B |
| https://www.ufcalendar.com/blog/when-do-ufc-fighters-get-washed | UFCalendar | 2026-08 | 16,429 appearances; 485 retirees | Age bands; KD history; peak 30.6 | B |
| https://www.bjjheroes.com/editorial/modern-day-guard-passing-by-the-numbers | BJJ Heroes | ~2020 | 1,089 IBJJF black-belt matches | Pass 0.2/match; pass→win 99.6% | B |
| MDPI Appl. Sci. 13(4):2395 (judo WC endings) | Escobar-Molina et al. | 2023 | 2,340 contests | Ippon 46.2% | B (PDF fetch blocked; abstract via search) |
| https://statleaders.ufc.com/ | UFC Record Book | live | UFC 28→present | Leaders for strikes, CTRL, KD, etc. | A |

---

## Count summary (for parent)

- **DOCUMENTED measured qualities** in catalog tables: **32** distinct measurable constructs with named denominators (UFC official + Fightnomics TIP/KD Rate + CompuBox Acc + lab VO₂/Wingate/lactate/AT + BJJ pass/sweep + judo ippon + FightingData absorber/fade).
- **Loud NOT FOUNDs:** heart; fight IQ; chin-as-official-trait; Sub Def %; scramble %; guard retention % (UFC); Acc test–retest; TD-by-age curve; reach→KD table.
- **Blocker:** grok CLI unavailable (os error 6). Fightnomics full text obtained via archive.org djvu download and quoted carefully.


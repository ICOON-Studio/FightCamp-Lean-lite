# J20 — THE VALIDATION CORPUS

**Desk:** FightCamp research, John  
**Date:** 2026-09-10  
**Bar:** A UFC operator should be able to use the sim to see how fights can go. Fidelity = simulated fight-level outputs match real UFC fight-level distributions.  
**This memo:** scoreboard only. Collect and cite. No engine changes, no vendors, no prices.

**Verification:** every URL below was opened or searched live on **2026-09-10**.

---

## How to read this memo

UFC does **not** publish a league-wide mean table. The live primary database is [ufcstats.com](http://ufcstats.com/) (fight- and fighter-level). The official tails live on the [UFC Record Book](https://statleaders.ufc.com/) (UFC 28 → present, Unified Rules). Almost every “typical UFC” number in public is an **aggregate of those fight logs**. That is why every row below names **population, definition, denominator, and grade**.

### Grade key

| Grade | Meaning |
| --- | --- |
| **DIRECT** | Taken from a primary: UFC Stats / UFC Record Book, an athletic-commission or ABC text, a peer-reviewed paper that counted official UFC scorecards or video of numbered UFC events, or a CompuBox-published summary. |
| **INHERITED** | Computed from UFC Stats (or CompuBox) fight logs by a named analyst whose method and sample are stated. The counts inherit the official logger; the *mean* is the analyst’s. |
| **UNVERIFIED_SECONDARY** | Restatement, betting copy, or a number whose sample/method is not reconstructable from the page. Use only as a pointer. |
| **UNKNOWN / NOT FOUND** | Searched, not found at usable quality. **A fabricated benchmark is worse than none.** |

Derived arithmetic from published counts is marked **INHERITED** and the formula is shown.

### Engine numbers (context only — not a verdict)

The engine was recently measured at **2.26× real fighter pace**. Current engine target mix **head 65.3% / torso 28.2% / leg 3.2%**. Current engine knockdowns in **41.5% of bouts**. This memo does not score the engine. It assembles the real-fight distributions those three observations would be compared against.

---

## 0. DECISIONS — six metrics the harness should hit first

If a simulation matches these six at fight level (mean **and** spread, **and** by division/sex where the table gives them), it has the strongest claim that “this is how UFC fights go.” Everything else is diagnostic detail.

| # | Metric | Why it is diagnostic | Real-fight anchor (see table) |
| --- | --- | --- | --- |
| **D1** | **Significant-strike pace, both corners, per fight-minute** | Pace is the already-known miss (2.26×). SLpM of one fighter is not enough: the sim must reproduce *combined* output in a bout of realistic length. | Fight-level ~**2.8–3.8** significant strikes **landed per fighter per minute** (division spread); combined bout ~**6–8** landed/min. Career-rate tails 1.0–8.7. |
| **D2** | **Significant-strike accuracy (landed / attempted)** | Independent of pace. A fast sim can still be realistic if it misses at the real rate. | Fight-level **~40–49%** (heavier divisions higher). Per-fight red-corner mean **47.9%**, blue **43.7%**. |
| **D3** | **Significant-strike **target** mix: head / body / leg (landed)** | Direct check on the engine’s 65.3 / 28.2 / 3.2 split. Head is in the real band; **legs are the miss if 3.2% is the sim’s landed share.** | League **~61–65% head / 19–23% body / 14–18% leg**. Division spread on head is only ~4 points. |
| **D4** | **Bout outcome mix: KO/TKO vs submission vs decision** | This is what an operator *sees*. Must be **division-conditioned**; a single UFC-wide coin-flip hides two sports. | All-time clean: **~47% decision / ~33% KO/TKO / ~19% sub**. Modern standard divisions (2019–May 2026): **51.1 / 31.7 / 17.2**. HW KO/TKO **~52%**; WSW decision **~67%**. |
| **D5** | **Share of bouts with ≥1 official knockdown** | Settles the 41.5% engine figure. A knockdown is not a KO. | **35.1%** of 8,337 UFC bouts (1994–Sep 2025) had at least one official KD. Mean combined KDs/fight **~0.41–0.52** by men’s division. |
| **D6** | **Takedowns attempted and landed per fighter-fight (accuracy ~35–40%)** | Determines whether the fight is a kickboxing match or a wrestling match. Position *time* share is **not** published UFC-wide (see §3). Takedown counts **are**. | Flyweight **~7.5 attempts / 2.8 landed** per fighter-fight; heavyweight **~3.7 / 1.5**. Accuracy **35–40%**. Submission attempts **~0.5–1.0** per fighter-fight. |

**Harness order for Claude:** D1 (pace) and D2 (accuracy) on the same clock; D3 (targets) on landed significant strikes; D5 (KD incidence, not KD→KO conversion); D4 (outcomes, by division); D6 (takedowns). Do not validate “control time % of fight” until a real-fight denominator exists (it does not, UFC-wide).

---

## 1. Definitions the sim must match (the word is not the statistic)

These are the official UFC/FightMetric categories. Matching a different definition and calling it the same name will fail validation even if the number is close.

| Term | Official definition | Source | Grade |
| --- | --- | --- | --- |
| **Significant strike** | **Every strike at distance**, plus **power strikes in the clinch and on the ground**. Short/non-power strikes in clinch or on the ground are **not** significant. A jab at distance **does** count. | FightMetric glossary, MMA Fighting, 2011-05-09: https://www.mmafighting.com/2011/05/09/171293/fightmetric-stats-glossary ; restated by UFC, 2025-02-05: https://www.ufc.com/news/does-striking-accuracy-accurately-measure-striking | DIRECT |
| **Total strike** | Significant strikes **plus** the short clinch/ground strikes excluded above. A significant strike is always also a total strike. Gap is large in grappling fights (e.g. Sonnen 320 total / 89 significant vs Silva, UFC 117) and near-zero in distance wars (Holloway 447 total / 445 significant vs Kattar). | Same glossary; fight pages on ufcstats.com (Holloway–Kattar, Silva–Sonnen) | DIRECT |
| **SLpM** | Career (or bout) **significant strikes landed ÷ minutes of fight time**. Not total strikes. Not attempts. | FightMetric SLpM explainer (formula): add career significant landed, divide by career fight-seconds, ×60. Record Book label: “Strikes Landed per Min.” https://statleaders.ufc.com/ | DIRECT |
| **SApM** | Significant strikes **absorbed** per minute (opponent’s landed significant ÷ same fight-minutes). | UFC fighter pages / Record Book “Strikes Absorbed per Min.” | DIRECT |
| **Striking accuracy %** | Significant **landed ÷ significant attempted**. Not total. UFC (2025) warns this is **not** precision: ground/body shots inflate it relative to distance-head shots. | UFC.com 2025-02-05 (link above); ufcstats.com fighter pages | DIRECT |
| **Striking defense %** | Share of **opponent significant attempts that do not land**. | ufcstats.com fighter pages | DIRECT |
| **Takedown** | Fighter “deliberately grapples his opponent to the ground and establishes an advantageous position for an appreciable amount of time.” | FightMetric glossary (link above) | DIRECT |
| **TD Avg** | Takedowns **landed per 15 minutes** of fight time (UFC career rate). | ufcstats.com; UFC.com matchup pages | DIRECT |
| **TD accuracy** | Takedowns landed ÷ takedown attempts. | Same | DIRECT |
| **TD defense** | Share of opponent takedown attempts stuffed. | Same | DIRECT |
| **Sub. Avg / SUB ATT** | UFC career rate is **submission *attempts* per 15 min**, not submissions finished. Attempt = an actual hold applied, not a hip-swing that never locks. | FightMetric glossary | DIRECT |
| **Control time** | Clock on **sustained positional control**: top on the ground **or** a controlling clinch (typically pinned on the fence). Starts when control is established; stops on escape, reversal, or return to neutral. **Not** the same as “time on the ground.” Record Book also lists **top-position time** separately (GSP: 2:42:04 control vs 2:22:05 top). | UFC Record Book https://statleaders.ufc.com/ ; ufcstats.com `CTRL` column | DIRECT |
| **Knockdown (KD)** | Official UFC Stats knockdown. FanDuel/UFC scoring notes (not the logger’s public glossary) describe a KD as a strike that puts the opponent down from debilitation for what scorers consider a substantial time. **A KD is not a KO.** Many KDs are recovered; many TKOs have no KD (ground-and-pound, cuts, accumulated strikes). | ufcstats.com `KD` column; UFC Record Book “Knockdowns Landed” and “Knockdown Avg. per 15 Min.” | DIRECT on the count; UNVERIFIED_SECONDARY on the “substantial time” prose (DFS scoring note, not FightMetric glossary) |
| **Finish** | Bout ends before the scheduled limit by KO/TKO (including doctor stoppage, in the studies that say so) or submission. Decisions are unanimous, split, or majority. DQ / NC / overturned are usually excluded from “clean” samples. | Named in each row | — |

**Distance / clinch / ground** on a UFC Stats fight page are a split of **significant strikes**, not a split of **fight minutes**. Do not validate a time-share against a strike-share.

---

## 2. One big table

Columns: **metric | value | spread | population | definition | denominator | source | grade**.

All links verified **2026-09-10**.

### A. Striking volume and accuracy

| Metric | Value | Spread | Population | Definition | Denominator | Source | Grade |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Significant strikes **landed per fighter per round** | HW **14.0**; W. Flyweight **19.1** (highest listed) | Men’s divisions **14.0 (HW) → ~higher at lower weight**; W. Flyweight **19.1**. Author: +36% from HW to WFLW. | **8,375** UFC fights, 12 active divisions, 1993–2025, UFCStats.com | Significant **landed**, per fighter, averaged across recorded rounds | **Per round** (5 min scheduled; early-stop rounds are still one round in this mean) | The Fight Algorithm, *Division Meta*, https://thefightalgorithm.com/articles/division-meta | INHERITED |
| Implied fight-level **SLpM** (from row above) | HW **2.80**; WFLW **3.82** | Same division ladder | Same | Landed significant ÷ 5 | **Per minute**, per fighter | Arithmetic: round mean / 5 | INHERITED |
| Combined-bout significant **landed** | **71.3** per fight (both corners) | Not published as IQR | **>7,000** UFC fights through UFC 292 (Aug 2023), Kaggle/UFC Stats | Author’s “strikes landed” with matching **45%** accuracy and SIG_STR columns in the same write-up | **Per fight**, both corners summed | Eduardo Jacob, 2023-09-20, https://medium.com/@eduardocbjacob/ufc-data-report-309eaaf94fa3 | INHERITED |
| Combined-bout significant **attempted** | **161.3** per fight | — | Same | “Strikes thrown” paired with 45% accuracy | **Per fight**, both corners | Same | INHERITED |
| Combined accuracy check | 71.3 / 161.3 = **44.2%** (author states **45%**) | — | Same | Landed ÷ thrown | Per fight, both corners | Same | INHERITED |
| Combined landed per minute | 71.3 / 10.417 min = **6.85** both corners ≈ **3.42** per fighter if split evenly | Mean fight time **10:25** | Same | Landed ÷ official fight minutes | **Per minute** | Same + arithmetic | INHERITED |
| Total (sig + non-sig) strikes **landed per fighter per fight** | Median **~65**; most common bin **25–74** (**42%** of fighter-fight performances) | **100+** in **14.9%** of performances; **200+** in **<1%**; **300+** club = **10** performances in UFC history | **8,555** UFC fights, 763 events, 1993–2026, UFCStats.com | **Total** strikes landed (includes non-significant ground/clinch) | **Per fighter per fight** | The Fight Algorithm, *The Volume Machine*, https://thefightalgorithm.com/articles/the-volume-machine | INHERITED |
| Total strikes landed **per fighter per round** (league) | **21.0 (R1) – 26.8 (R5)**; roughly **21–27** and **flat by round** | Holloway contrast: 26.4 → **57.4** in R4 | Same 8,555-fight corpus | Total landed | **Per fighter per round** | Same | INHERITED |
| Career **SLpM** upper tail (official) | #1 **Carli Judice 8.7**; #2 Joshua Van **8.43**; #3 Terrance McKinney **7.95**; #5 Tom Aspinall **7.63** | Leaders **7.28–8.7**; this is the right tail, **not** the mean | UFC Record Book, **min 5 UFC fights**, UFC 28 → present (Unified Rules), all sexes/divisions mixed | Significant landed ÷ fight minutes | **Per minute**, career | https://statleaders.ufc.com/ (verified 2026-09-10) | DIRECT |
| Career **SApM** lower tail (official) | Fewest absorbed: **Pete Spratt 1.04**; then 1.15–1.33 | Floor **~1.0**; typical fighters on matchup pages sit **~2.5–5** (illustrative, not a mean) | Same Record Book, min 5 fights | Significant absorbed ÷ fight minutes | **Per minute**, career | https://statleaders.ufc.com/ | DIRECT |
| Career SLpM cluster means (historical) | “Well-rounded” **2.71**; “Striker” **4.20**; “Grappler” **3.46** | Three k-means clusters on FightMetric career vectors (not a UFC-wide mean) | FightMetric career stats as of **2015** (Stanford CS229) | Career SLpM | Per minute, career | https://cs229.stanford.edu/proj2015/121_poster.pdf | INHERITED |
| Significant-strike **accuracy**, fight-level, by corner | Red **47.9%**; Blue **43.7%** | Corner gap ~4 points (red is typically the favourite) | **8,337** UFC bouts, 1994-03-11 to 2025-09-06 | Per-fight significant landed ÷ attempted, then mean across fights | **Per fight**, not career | Kirby, *Inside the Finish*, https://rstudio-pubs-static.s3.amazonaws.com/1430794_45f7ac8d93ff4d68bc354147e7e63500.html | INHERITED |
| Significant-strike accuracy by division | HW **48.6%** (highest); W. Flyweight and Lightweight **43.2%** (lowest listed) | **~43–49%** across 12 divisions | 8,375 fights, 1993–2025 | Significant landed ÷ attempted | Per-fight / per-round aggregate as stated by author | Fight Algorithm, *Division Meta* | INHERITED |
| Significant-strike accuracy, fighter-career distribution | “Average fighter landing around **40%**”; approximately normal; heavier classes shifted slightly right | Plot only; no SD published in the text | `ufc.stats` package = tidy UFC Stats round logs, as of 2020-04-15 | Career/round significant accuracy | Landed ÷ attempted | Tamas Szilagyi, https://tamaszilagyi.com/ufc.stats/articles/2020-04-15-striking.html | INHERITED |
| Historical attempt pace + accuracy (era) | Since **2008**: **7.1** significant-strike **attempts** per fighter per minute; **~42%** land | 1990s attempts **2.8**/min; accuracy “hovered around 42% since 2005” | FightMetric / Fightnomics era summary, cited 2013 | SSApM = significant **attempts** ÷ fight minutes | **Per minute**, per fighter | mixedmartialarts.com quoting FightMetric/Palmquist, 2013-01-09, https://mixedmartialarts.com/news/ufc-pace-of-action-up-over-200-since-90s/ ; Fightnomics charts | INHERITED (2013 snapshot; pace has risen since) |
| Career **striking defense** upper tail | GSP **73.1%**; next 68.6–72.3% | Elite **~70%+**; typical matchup-page fighters **~50–62%** (not a published mean) | Record Book, min 5 fights and 500 opponent significant attempts | Opponent significant missed ÷ opponent significant attempted | Career | https://statleaders.ufc.com/ | DIRECT on tails; **NOT FOUND** on UFC-wide mean defense % |
| Head strikes received per minute (significant vs total) | Significant head **received**: mean **2.41**, median **1.67**, range **0–51** | Female significant head **executed** 2.95 ± 3.94 vs male 2.37 ± 3.06; total head executed female 7.73 ± 6.63 vs male 6.20 ± 5.34 | **2,488** numbered UFC events UFC 28–UFC 265 (2000–2021); 4,976 fighter-bouts (338 F / 4,638 M) | Official UFC Stats head column; significant vs total as FightMetric | **Per minute**, per fighter | Mańka-Malara & Mierzwińska-Nastalska, *Int J Environ Res Public Health* 2022, https://pmc.ncbi.nlm.nih.gov/articles/PMC9603147/ | DIRECT |

**Reading D1:** a realistic sim should land on the order of **one significant strike per fighter every 15–25 seconds**, not every 7 seconds. Combined, both fighters land about **seven significant strikes a minute**. Career SLpM of **6+** is elite-tail (Record Book), not typical.

### B. Target distribution (significant strikes)

| Metric | Value | Spread | Population | Definition | Denominator | Source | Grade |
| --- | --- | --- | --- | --- | --- | --- | --- |
| League target mix (landed or thrown — author says “mirrors the league average”) | **63% head / 23% body / 14% leg** | — | 8,555 UFC fights, UFCStats | Share of significant strikes by target | **Percent of significant strikes** (not of fight time) | Fight Algorithm, *Volume Machine* | INHERITED |
| Target mix by division (“where fighters aim”) | Head **61.2% (WSW) – 65.0% (HW)**; body **19.2–22.1%**; leg **15.7–17.8%** | Head spread only **3.8 points** across 12 divisions. WSW leads body **22.1%**. | 8,375 fights, 12 divisions, 1993–2025 | Head/body/leg share | Percent of significant strikes | Fight Algorithm, *Division Meta* | INHERITED |
| Engine context (not a real-fight number) | Head **65.3% / torso 28.2% / leg 3.2%** | — | Engine | — | — | Internal, as given | — |

**D3 read:** real UFC head share **is** ~63–65%. Real **leg** share is **~14–18%**, not 3%. Body is ~19–23%, not 28%. If the engine’s 3.2% is landed significant-to-leg, it is outside every published division band. If 3.2% is something else (e.g. kicks as a technique class, or a residual “other”), that definition is **not** the UFC Stats target column — match the column.

**NOT FOUND:** a UFC-published league-wide head/body/leg table on statleaders.ufc.com or ufcstats.com (those sites give the split **per fight**, not a career-league mean). Jacob (2023) computed body-part shares but the numeric table was image-only on Medium; values **not recovered**.

### C. Position: strike-share vs time-share vs control

| Metric | Value | Spread | Population | Definition | Denominator | Source | Grade |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Significant strikes by **position** (league) | Distance **72.6%** / clinch **13.4%** / ground **14.1%** | Holloway contrast: 85.0 / 6.3 / 8.7 | 8,555 fights | Share of **significant strikes landed**, not minutes | Percent of significant strikes | Fight Algorithm, *Volume Machine* | INHERITED |
| Same, by division | Distance **77.1% (BW) – 66.9% (HW)**; clinch 10.2–16.2%; ground 12.7–17.3% | Combined clinch+ground: BW **22.9%** vs HW **33.0%** | 8,375 fights | Same | Percent of significant strikes | Fight Algorithm, *Division Meta* | INHERITED |
| **Fight-time** share distance / clinch / ground, modern UFC-wide | **NOT FOUND** | — | — | Minutes in each position ÷ fight minutes | Per minute | Searched UFC Stats, Record Book, peer-reviewed time-motion, Fight Algorithm | **NOT FOUND** |
| Historical fight-time share (Zuffa-era snapshot) | Distance rose to **~50%** of fight minutes by ~2013; ground fell from **~58% (2001)** to **<⅓**; clinch **~18% (2013)** vs **16% (2001)** | Era trend, not a 2026 mean | FightMetric / Fightnomics through ~2013 | Position **time** | Percent of fight minutes | Fightnomics/FightMetric charts as quoted 2013 (e.g. https://mixedmartialarts.com/news/ufc-pace-of-action-up-over-200-since-90s/ and Fightnomics PDF extracts) | INHERITED (stale; pre-women’s divisions, pre-volume rise) |
| Coded “keeping distance” time per round | Featherweight **131.4 s**; bantamweight **127.9 s** of a 300 s round | Other coded bins (clinch-without-attack, ground-without-attack) are much smaller (e.g. flyweight clinch-without-attack **11.4 s**) | **2,814 UFC rounds**, all divisions, Miarka et al. 2017 | Author’s motor-action coding, **not** UFC Stats distance/clinch/ground | Seconds per round | PubMed 28779598, https://pubmed.ncbi.nlm.nih.gov/28779598/ | DIRECT on the paper’s coding; **not** interchangeable with UFC Stats position labels |
| Lightweight **ground-control share** (division average, 2018) | **17%** of fight time on the mat **in control** (Khabib 41%) | One division, 2018 roster | UFC lightweight, ESPN + FightMetric, 2018-03-28 | Control-on-ground ÷ fight time | Percent of fight minutes | https://www.espn.co.uk/mma/story/_/id/22946628/the-statistical-domination-ufc-lightweight-khabib-nurmagomedov-grappling-control | INHERITED |
| Control-time **win rate in decisions** | Fighter with more control wins **68.2%** of decisions | Gap **<1 min**: 51.0% (n=865); **1–3 min**: 57.2% (1,036); **3–5 min**: 70.3% (656); **≥5 min**: **87.4%** (1,293) | **3,850** UFC decisions with control logged, through early 2026 | Official `CTRL`; “controller” = higher total control | Per decision bout | Fight Algorithm, *The Invisible Round*, https://thefightalgorithm.com/articles/the-invisible-round | INHERITED |
| Control-time **leaders** (official) | Career control: GSP **2:42:04**. Control **%** of fight time (min 5 fights): Bartosz Fabinski **79.1%**; Gillespie 71.9%; Sabatini 71.0%; Almeida 69.9%. Top-position %: Almeida **63.7%**. | These are **specialists**, not the mean. A 70% control fighter is a Record Book tail. | UFC Record Book, UFC 28 → present | Control minutes ÷ fight minutes | Career | https://statleaders.ufc.com/ | DIRECT |
| UFC-wide mean control % of fight time | **NOT FOUND** | — | — | Sum of both corners’ control is **not** 100% of fight time (neutral/distance has no controller) | — | Record Book publishes tails only | **NOT FOUND** |

**D6/position read:** validate **strike-position mix** (distance ~70–77% of significant strikes) and **takedown counts**. Do not invent a 2026 time-share. Neutral/distance is the majority of minutes in the last published FightMetric-era snapshot (~50%+), and lightweight ground-*control* was 17% of minutes in 2018 — both are compatible with 72.6% of **strikes** occurring at distance (you punch more when you are standing).

### D. Takedowns and submissions

| Metric | Value | Spread | Population | Definition | Denominator | Source | Grade |
| --- | --- | --- | --- | --- | --- | --- | --- |
| TD **attempted** per fighter-fight | Flyweight **7.49**; BW 6.60; FW 6.31; LW 6.14; WW 5.77; MW 5.34; LHW 4.76; HW **3.69** | Light → heavy, nearly monotone | 8,375 fights, men’s eight divisions shown | Takedown **attempts** | **Per fighter per fight** (fight length not normalised here) | Fight Algorithm, *Division Meta* | INHERITED |
| TD **landed** per fighter-fight | FLW **2.80**; BW 2.33; FW 2.35; LW 2.29; WW 2.20; MW 1.99; LHW 1.78; HW **1.46** | Same ladder | Same | Landed takedowns (FightMetric definition) | Per fighter per fight | Same | INHERITED |
| TD **accuracy** | **35.3% (BW) – 39.6% (HW)**; most divisions **37–38%** | Tight. Heavier convert slightly more, shoot less. | Same | Landed ÷ attempted | Per fighter-fight aggregate | Same | INHERITED |
| Sub attempts per fighter-fight | FLW **0.97**; LW 0.88; FW 0.81; WW 0.79; MW 0.78; BW 0.73; LHW 0.53; HW **0.49** | ~2× from HW to FLW | Same | UFC **SUB ATT** (holds applied) | Per fighter per fight | Same | INHERITED |
| Combined TD landed, by finish type | KO/TKO fights: median combined TD **~0–1**; submission fights: **highest** combined TD; decisions in between | Boxplot, IQR not numeric in text | 8,337-fight Kirby sample | `r_td_landed + b_td_landed` | Per fight, both corners | Kirby, *Inside the Finish* | INHERITED |
| TD attempts per **round** by outcome (academic) | Unanimous-decision rounds: **1.9 ± 1.9** attempts; KO/TKO **1.3 ± 1.4**; submission **1.0 ± 1.1** | High SD; many zeros | **304 UFC rounds**, 2012–2014 (58 events) | Attempts / round | Per round | *J Hum Kinet* / PMC6714373 (UFC 2012–2014 rounds), https://pmc.ncbi.nlm.nih.gov/articles/PMC6714373/ | DIRECT |
| Sub attempts per round (same paper) | Submission-outcome rounds **0.3 ± 0.7** vs KO/TKO and UD **0.2 ± 0.5** | — | Same | Holds applied / round | Per round | Same | DIRECT |
| Model TD reliability / defense (non-UFC-exclusive MMA sample) | Takedown success **35.3%**; takedown **defense 69.8%**; activity **0.29** TD attempts/min; effectiveness **0.10** landed/min | Light / middle / heavy groups: success 33.5 / 36.2 / 36.6%; defense 71.7 / 69.1 / 67.9% | MMA fighters in E3S 273, 09035 (2021) — **not stated as UFC-only** | Author’s AT/ET/RT/DT | Per minute and % | https://doi.org/10.1051/e3sconf/202127309035 | INHERITED (population broader than UFC; treat as corroboration of ~35% accuracy / ~70% defense, not a UFC mean) |
| Career TD **accuracy** upper tail | Nordine Taleb **76.2%**; Taila Santos 75.0%; Lawler 73.9%; GSP **73.8%** (min 5 fights & 20 attempts) | Tail, not mean | UFC Record Book | Landed ÷ attempted | Career | https://statleaders.ufc.com/ | DIRECT |
| Career TD **defense** upper tail | Julio Arce **96.2%**; Ilia Topuria **95.2%**; Jon Jones **95.0%** (min 5 fights & 20 opponent attempts) | Tail | Same | Stuffed ÷ opponent attempts | Career | Same | DIRECT |
| Career Sub attempts / 15 min upper tail | Paul Sass **7.38**; Albert 6.14; … (specialists) | Tail | Same, min 5 fights | SUB ATT per 15 min | Per 15 min | Same | DIRECT |
| UFC-wide mean **TD Avg** (landed per 15 min) | **NOT FOUND** as an official mean. Implied from Division Meta + FightAlpha durations: FLW 2.80 landed in ~11.6 min ≈ **3.6 / 15 min**; HW 1.46 in ~9.6 min ≈ **2.3 / 15 min** — **only if** those landed figures are per fighter (they are presented that way). | Use as a check, not a Record Book number | — | Landed × 15 / fight minutes | Per 15 min | Arithmetic on INHERITED inputs | INHERITED, **fragile** (depends on matching duration sample to TD sample) |
| Jacob (2023) “average takedown accuracy **27%**” | **27%** | Conflicts with Division Meta **35–40%** | >7,000 fights to UFC 292 | Unclear whether this averages per-fight percentages including 0-attempt fights | Not specified beyond “accuracy” | Medium report | INHERITED but **in tension** with Division Meta; do not prefer 27% without a methods note. **Treat as unresolved.** |

**D6 read:** a typical UFC fighter-fight is **a handful of takedown attempts, ~1–3 completions, ~35–40% accuracy**, more in the lighter men’s divisions. Sub attempts are usually **<1 per fighter per fight**. Elite TD defense (90%+) is a Record Book tail.

### E. Outcomes

| Metric | Value | Spread | Population | Definition | Denominator | Source | Grade |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Clean-result decision rate (all UFC history) | **47.3%** | — | **8,597** fights with KO/TKO, sub, or decision; through **May 2026**; UFCStats-derived | Decision = UD+SD+MD. KO/TKO includes doctor stoppage. Excludes DQ/NC/overturned from this headline | Per fight | FightAlpha, https://fightalpha.com/articles/ufc-decision-rate-by-division | INHERITED |
| All-history method split (second independent scrape) | KO/TKO **32.6%** (2,800); sub **19.3%** (1,659); decision **46.8%** (4,016); other **1.4%** (116). Finish **51.9%**. | — | **8,591** UFC bouts, 1994–2026 | Doctor stoppages in KO/TKO | Per fight | Grappler HQ, https://www.grapplerhq.com/mma/ufc-statistics/ | INHERITED |
| Third scrape (includes 2026 YTD) | Finish **53.2%** (4,640); KO/TKO **33.5%** (2,917); sub **19.8%** (1,723); decision **46.5%** (4,056); R1 finish **28.2%** (2,456) | 2024 decision-heavy (**54.8%** dec); 2026 YTD finish-heavy (**56.7%**, n=374) | MMA.SOCIAL UFC database, page updated through Sep 2026 cards | Finish = KO/TKO+sub; NC/DQ excluded from finish count | Per fight | https://mma.social/stats/finish-rates | INHERITED |
| Kirby three-way (no “other” bucket — leftover methods folded into Decision) | Decision **49.1%** (4,097); KO/TKO **31.4%** (2,621); sub **19.4%** (1,619) | — | 8,337 bouts, 1994–2025-09-06 | `finish_group` = KO/TKO / Submission / else Decision | Per fight | Kirby | INHERITED (Decision slightly high because DQ/NC may be in the else-bin) |
| **Modern standard divisions** (2019–May 2026) | Decision **51.1%**; KO/TKO **31.7%**; sub **17.2%** | Era: 1990s 25.3% dec (n=99); 2000s 34.5% (1,007); 2010–18 49.0% (3,571); 2019–May 2026 **51.1%** (3,648) | Standard divisions only | Same FightAlpha buckets | Per fight | FightAlpha | INHERITED |
| Decision rate by **division** (standard, all history through May 2026) | WSW **66.9%** (366); WFLW 63.7% (273); WBW 61.3% (243); WFW 58.6% (29, **small**); FLW 54.9% (408); FW 54.0% (845); BW 53.8% (762); LW 48.1% (1,426); WW 47.8% (1,367); MW 40.1% (1,117); LHW 37.3% (738); HW **33.0%** (751) | Women’s standard **64.2%** decisions vs men’s **45.9%** | 8,325 standard-division fights | See FightAlpha method notes | Per fight | FightAlpha table | INHERITED |
| KO/TKO rate by division (same table) | WSW **13.1%** → HW **52.6%** | Monotone with weight in men’s divisions | Same | KO/TKO + doctor | Per fight | Same | INHERITED |
| Submission rate by division | **14.4% (HW) – 21.9% (LW)**; women’s ~17–20% | **Stable** vs weight | Same | Clean submissions | Per fight | Same | INHERITED |
| Round-1 finish rate (modern core) | **24.8%** (1,515 / 6,098) | LHW **37.3%** (451); HW 34.1% (455); MW 27.9%; WSW **14.3%**. Yearly 2014–26: low **20.6% (2024)**, high **~28%** | Core divisions **2014 – 2026-06-06** | Fight ended in round 1, any finish method | Per fight | FightAlpha, https://fightalpha.com/articles/how-often-do-ufc-fights-end-in-round-1 | INHERITED |
| Ended by end of round 2 (same sample) | **40.8%** | — | Same 6,098 | Cumulative | Per fight | Same | INHERITED |
| Decision share, same modern sample | **49.6%** | 3-round fights 50.7% decision; 5-round **40.6%** | Same | — | Per fight | FightAlpha duration article | INHERITED |
| Among R1 finishes | **65.1% KO/TKO**, **32.5%** sub (986 / 492 / 37 other of 1,515) | Of all KO/TKOs, **51.4%** occur in R1; of all subs, **45.9%** occur in R1 | Same | Method \| round=1 | Per R1 finish | Same | INHERITED |
| Kirby finish **counts** by round (finishes only) | R1: ~**1,450** KO/TKO and **>800** sub — “more than double any other round”; then decline. R4–R5 scarce (5-round fights only). | — | 8,337-fight set | Counts, not % of all fights | Per finish | Kirby | INHERITED (approximate counts as published) |
| Mean fight duration, modern core | Mean **11.0 min**; median **15.0 min** | 3-round: mean 10.6, median 15.0 (n=5,452). 5-round: mean 15.5, median 16.6 (n=572). LHW 9.4 (449); HW 9.6 (447); WFLW 12.8 (274); WSW 12.7 (369) | **6,024** fights, 2014–2026-06-06, core divisions | Official elapsed fight clock (not TV, not rest) | Minutes per fight | FightAlpha, https://fightalpha.com/articles/how-long-do-ufc-fights-last | INHERITED |
| Duration by method (same) | Decision **15.8 min** (n=2,994); KO/TKO **6.0** (1,845); sub **6.8** (1,058); doctor **9.4** (46) | — | Same | Official clock | Minutes | Same | INHERITED |
| Numbered-UFC-event duration by sex | Female **12:05 ± 6:16**; male **10:27 ± 6:11** | Title-fight times **not** different by sex; non-title female fights ~2 min longer | 2,488 numbered events, UFC 28–265 | Official duration | Minutes | Mańka-Malara 2022 | DIRECT |
| Split / majority / unanimous **among decisions** | Of **4,016** decisions: UD **3,098 (77.1%)**; split **818 (20.4%)**; majority **100 (2.5%)**. Split = **9.5% of all 8,591 fights**. | Year-to-year split **share of decisions** often **15–25%** (FightMatrix yearly) | Grappler HQ 8,591-bout file | Decision subtype | Per decision, and per fight | https://www.grapplerhq.com/mma/ufc-statistics/ ; corroboration: https://www.fightmatrix.com/ufc-records/ufc-fight-outcomes/ | INHERITED |
| Split as share of **all** numbered-event fights, by sex | Women **14.8%** split-decision results vs men **9.1%**; UD 41.4% vs 35.6%; KO/TKO 26.0% vs 36.5% | Women’s n=169 fights (small vs men 2,319) | Numbered UFC 28–265 | Result codes including split/UD/KO | Per fight (not per decision) | Mańka-Malara 2022 | DIRECT |
| Title vs standard (Kirby) | Standard: KO/TKO 31.2%, sub 19.3%, dec **49.5%**. Title: KO/TKO 36.1%, sub 21.5%, dec **42.4%** (n_title=460) | Note: FightAlpha 5-round decision rate **40.6%** is in the same direction | 8,337 bouts | Title flag | Per fight | Kirby | INHERITED |

**D4 read:** use **division + era**. A 2026 sim of a women’s strawweight should go to the cards ~⅔ of the time. A heavyweight should end by KO/TKO about half the time. A single 50/50 finish coin-flip is the **modern pooled** rate, not a division law. About **one in five decisions is split**; majority decisions are rare (~2–3% of decisions).

### F. Knockdowns — the 41.5% question

| Metric | Value | Spread | Population | Definition | Denominator | Source | Grade |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Bouts with ≥1 official KD** | **2,930 / 8,337 = 35.1%** | This is the number that sits next to the engine’s **41.5%** | UFC fight history, 1994-03-11 to 2025-09-06 | `r_kd > 0 OR b_kd > 0` | **Per bout** (binary) | Kirby summary table, *Inside the Finish* | INHERITED (from UFC Stats `KD`) |
| Mean combined KDs per fight, by men’s division | FLW **0.43**; BW 0.47; FW 0.45; LW **0.41**; WW 0.49; MW 0.46; LHW **0.52**; HW 0.47 | **0.41–0.52**; LHW highest in this table. **Not** a steep weight ladder. | Same Kirby file; strawweight absent/minimal | `r_kd + b_kd` | **Per fight**, both corners | Kirby division table | INHERITED |
| Mean KDs per fight (MMA model paper) | All **0.52**; light 0.46; middle 0.55; heavy **0.60** | — | Author’s MMA sample (E3S 2021) — **not UFC-only** | “Average number of knockdowns per fight” | Per fight | https://doi.org/10.1051/e3sconf/202127309035 | INHERITED (population caveat) |
| Conditional outcome given a KD | When any KD occurs: KO/TKO **63.5%**, sub 9.5%, decision **26.9%**. When none: decision **61.4%**, KO/TKO **13.9%**, sub 24.7% | — | Kirby 8,337 | Official KD vs finish_group | Per bout | Kirby | INHERITED |
| Career KD **count** tail | Donald Cerrone **20**; Anderson Silva 18; Jeremy Stephens 18 (Record Book, 2026-09-10) | Tail | UFC 28 → present | Official KD | Career count | https://statleaders.ufc.com/ | DIRECT |
| Career KD **per 15 min** tail | Drew McFedries **4.27**; Chris Daukaus 3.54; Tom Aspinall **3.27** (min 5 fights) | Tail. Typical fighters on UFC.com matchup pages show **0.0–1.0 / 15 min**. | Same | KD ÷ fight minutes × 15 | Per 15 min | Same | DIRECT |
| Historical FightMetric “knockdown rate” | **3.9%** of landed standing power-head strikes produce a KD; **~1 KD per 10 minutes of distance standing time** (both fighters). By round: **5.3%** R1 → 2.4% R2 → 1.5% R3. | Varies by division (size/power) | Fightnomics / FightMetric, ~2013 | KD ÷ landed power head strikes **while standing** | Per standing power-head **landed**, not per fight | Fightnomics PDF extracts | INHERITED (2013; definition is **not** “% of bouts”) |
| KO (true unconsciousness) vs TKO, numbered UFC 2006–2012 | KO **12.7%** of matches (6.4 / 100 AE); TKO from repetitive strikes **19.1%** (9.5 / 100 AE); combined match-ending head trauma **31.9%** | 844 matches / 1,688 AE, numbered UFC only, male-era | Video + scorecards | KO ≠ TKO ≠ KD | Per match and per athlete-exposure | Hutchison et al., *Am J Sports Med* 2014, PMID 24658345, https://pubmed.ncbi.nlm.nih.gov/24658345/ | DIRECT |
| Head-trauma **stoppages** (numbered UFC 2000–2021) | **31.6%** of fights ended by KO/TKO with head trauma (male 32.2%, female 23.1%); **88.1%** of KOs were head-trauma KOs. HW **54%** of fights ended that way. | By division in paper Table 2 | 2,488 numbered events | Video-verified ending technique | Per fight | Mańka-Malara 2022 | DIRECT |

**D5 read (settles 41.5%):** the best fight-level citation is Kirby’s **2,930 / 8,337 = 35.1%** of UFC bouts with at least one official knockdown. Independent order-of-magnitude checks: combined KDs/fight **~0.45–0.52** (so more than one KD in some of the KD bouts), and KO/TKO itself is only **~32–34%** of bouts. **41.5% of bouts with a KD is high relative to 35.1%, but it is not a 2× error.** It is not comparable to KO rate (~13% true KO in Hutchison; ~32% KO/TKO pooled). Do not validate KD incidence against KO/TKO rate.

### G. Boxing (CompuBox) — cheap equivalents

Boxing is a different sport (no takedowns, 3-minute rounds, 10–12 round championship distance, punches only). Use it as a **striking-pace/accuracy** analogue, not as an outcome analogue.

| Metric | Value | Spread | Population | Definition | Denominator | Source | Grade |
| --- | --- | --- | --- | --- | --- | --- | --- |
| CompuBox punch classes | **Jab** vs **power** (everything else); two human operators, one per fighter | — | CompuBox methodology | Thrown and landed for each class; total = jab + power | Per punch | BoxRec/CompuBox wiki, https://boxrec.com/wiki/index.php/Compubox | DIRECT |
| Punches thrown / landed / connect, male pro sample | **37.6** thrown per round; **34.6%** landed; **172.4** jabs thrown per fight at **27.29%** connect; **147.8** power thrown per fight at **42.4%** connect; **320.1** punches per fight | 322 boxers, 320 fights, by weight category in the paper | Male professional boxing, CompuBox logs | CompuBox definitions | Per round and per fight | *Professional male modern boxing: activity profile by category*, 2023, https://www.researchgate.net/publication/373724629_Professional_male_modern_boxing_An_analysis_of_activity_profile_by_category | INHERITED (CompuBox primary data, academic aggregate) |
| CompuBox stated averages (2019 press) | Power-punch connect **36.9%**; jabs **thrown** per round **23** | Cited as “the CompuBox average” | CompuBox database as of Mar 2019, via Bad Left Hook | Power landed ÷ power thrown; jab attempts / round | Per punch type, per round | https://www.badlefthook.com/2019/3/19/18272492/errol-spence-rises-to-the-top-of-compubox-stats-in-power-punching | INHERITED |
| Middleweight connect implied by Hagler note | Hagler **43.2%** total connect, “**14% higher than middle. avg.**” → implied MW avg **~29%**; Hagler **28.4** landed/round, “**13 more than middle. avg.**” → implied MW avg **~15.4** landed/round | One CompuBox historical card | CompuBox Hagler comparison | Total punches | Per round | https://dev.compuboxdata.com/reports/93 | INHERITED |
| Championship-level illustration (not a mean) | Heavyweights on a CompuBox leaderboard: **~37–49** thrown/round, **~28–36%** connect, **~12–17** landed/round | Usyk/Fury/Joshua/Parker/Dubois/Hrgovic | Selected HW careers, CompuBox report 77 | Same | Per round | https://dev.compuboxdata.com/reports/77 | DIRECT on those fighters; **not** a league mean |
| Male pro boxing KO/TKO rate (large) | Male: KO **15%** + TKO **32%** = **47%** KO/TKO. Female: KO **5%** + TKO **24%** = **29%**. Per-minute rates nearly equal by sex. | **237,238** pro matches, 2014-01-01 to 2024-01-01, BoxRec | KO and TKO as recorded | Per match | *Neurology* 2025;104(7_Suppl_1):5548, https://www.neurology.org/doi/10.1212/WNL.0000000000212434 | DIRECT |
| US pro boxing, 6 months of 2017 | Decision **46.5%**; TKO **35.1%**; KO **18.1%**; DQ 0.2% (n=1,690) | US only, 2017 H1/H2 window | Same outcome codes | Per fight | *Neurology* 2019, https://www.neurology.org/doi/10.1212/01.wnl.0000580936.14660.4e | DIRECT |
| Boxing **knockdowns per fight** (CompuBox league mean) | **NOT FOUND** | Zipdo/blog figures (e.g. “1.2 KD/fight”) are not CompuBox-primary | — | — | — | Searched CompuBox, Ring, PubMed | **NOT FOUND** |

**Boxing vs UFC, same units:** a CompuBox boxer throws **~38 punches per 3-min round** (~12.5/min) and lands **~35%**. A UFC fighter **attempts ~7 significant strikes per minute** (2013 FightMetric) to maybe somewhat more today, and lands **~40–48%**. UFC’s “significant” includes kicks/knees/elbows and **excludes** short grappling shots; CompuBox counts only punches. Do not compare the percentages as if they were the same object.

---

## 3. Narrative notes the table cannot hold

### 3.1 Significant vs total — match the filter

UFC Stats is a **position × power** filter, not a damage meter (UFC.com, 2025-02-05; FightMetric glossary, 2011). Distance jabs count; short ground punches often do not. A grappling-control fight can show **3×** total vs significant (Sonnen–Silva). A distance war can show **identity**. If the sim’s “strike” is closer to CompuBox total punches or to UFC **total** strikes, compare it to **total**, not to SLpM.

### 3.2 Pace has a calendar

FightMetric-era attempt pace doubled from the 1990s (~2.8 SSApM) to ~2008 (~7.1). Fight Algorithm total-strike volume rose from ~90 per fight (2005) to **>130 (2024)**. Nate Latshaw (2024-01-01 thread) reported rising significant output over the 2010s and **5.4** significant strikes landed per minute **at distance** in 2023 — the tweet does **not** state per-fighter vs combined, so that **5.4 is not tabulated above**. Validate a 2026 sim against **2014–2026** samples (FightAlpha modern core) unless the operator wants historical UFC.

### 3.3 Sex is not a footnote

Women’s standard divisions: **64.2%** decisions vs men’s **45.9%** (FightAlpha). Women execute **more** head strikes per minute (Mańka-Malara). Split decisions are more common in women’s numbered-event fights (**14.8%** of all women’s bouts vs **9.1%** of men’s). A pooled “UFC mean” will look like a lightweight men’s fight and will mis-score a strawweight card.

### 3.4 Knockdown ≠ knockout ≠ TKO

| Object | Ballpark | Use for |
| --- | --- | --- |
| Bout with ≥1 official **KD** | **35.1%** | Engine’s 41.5% |
| Bout ending **KO/TKO** | **~32–34%** all-time; **52.6%** HW; **13.1%** WSW | Outcome mix (D4) |
| Bout ending true **KO** (Hutchison, numbered 2006–12) | **12.7%** | Medical/head-trauma, not sim KD |
| TKO from repetitive strikes (same) | **19.1%** | Same |
| Conditional: KD occurred → ends KO/TKO | **63.5%** | KD should raise finish probability, not guarantee it |

### 3.5 Control time is official but the league mean is unpublished

The logger’s `CTRL` is real. The Record Book tails (70%+ of fight time) are specialists. Fight Algorithm shows control **predicts** decisions once the gap exceeds ~3 minutes, and that **damage still beats empty control**. That is useful for a judging module. It is **not** a target for “X% of sim minutes should be control” until someone publishes the UFC-wide minute share.

---

## 4. Sources (live, 2026-09-10)

### Primary / official

1. UFC Stats (fight, round, fighter career rates) — http://ufcstats.com/  
2. UFC Record Book (Unified Rules, UFC 28 → present) — https://statleaders.ufc.com/ — verified 2026-09-10 (SLpM, SApM, accuracy, defense, KD, TD, control tails).  
3. FightMetric stats glossary (MMA Fighting reprint, 2011-05-09) — https://www.mmafighting.com/2011/05/09/171293/fightmetric-stats-glossary  
4. UFC.com, “Does Striking Accuracy Accurately Measure Striking?” 2025-02-05 — https://www.ufc.com/news/does-striking-accuracy-accurately-measure-striking  
5. Association of Boxing Commissions, MMA scoring criteria clarification, July 2025 (judges score damage, not the UFC Stats column) — https://www.abcboxing.com/wp-content/uploads/2025/08/ABC-MMA-Scoring-Criteira-Clarification-7.2025.pdf  

### Peer-reviewed (UFC scorecards / video)

6. Mańka-Malara & Mierzwińska-Nastalska, *IJERPH* 2022, Head trauma exposure in MMA (UFC 28–265) — https://pmc.ncbi.nlm.nih.gov/articles/PMC9603147/  
7. Hutchison et al., *Am J Sports Med* 2014, Head trauma in MMA (numbered UFC 2006–2012) — https://pubmed.ncbi.nlm.nih.gov/24658345/  
8. Miarka et al., 2017, motor actions and spatiotemporal changes by UFC weight division (2,814 rounds) — https://pubmed.ncbi.nlm.nih.gov/28779598/  
9. *J Hum Kinet* (PMC6714373), grappling actions by outcome (304 UFC rounds, 2012–2014) — https://pmc.ncbi.nlm.nih.gov/articles/PMC6714373/  
10. *Neurology* 2025, gender differences of KO/TKO in professional boxing (BoxRec, 237,238 matches) — https://www.neurology.org/doi/10.1212/WNL.0000000000212434  
11. *Neurology* 2019, US professional boxing outcomes, 1,690 fights in 2017 — https://www.neurology.org/doi/10.1212/01.wnl.0000580936.14660.4e  

### UFCStats-derived aggregates (INHERITED)

12. FightAlpha Lab, decision rates by division, through May 2026, n=8,597 — https://fightalpha.com/articles/ufc-decision-rate-by-division (data JSON linked from that page)  
13. FightAlpha, fight duration, 2014–2026-06-06 — https://fightalpha.com/articles/how-long-do-ufc-fights-last  
14. FightAlpha, round-1 finishes, 2014–2026-06-06 — https://fightalpha.com/articles/how-often-do-ufc-fights-end-in-round-1  
15. The Fight Algorithm, *Division Meta*, 8,375 fights — https://thefightalgorithm.com/articles/division-meta  
16. The Fight Algorithm, *The Volume Machine*, 8,555 fights — https://thefightalgorithm.com/articles/the-volume-machine  
17. The Fight Algorithm, *The Invisible Round*, 3,850 decisions — https://thefightalgorithm.com/articles/the-invisible-round  
18. Kirby, *Inside the Finish*, 8,337 bouts including **2,930 with a knockdown** — https://rstudio-pubs-static.s3.amazonaws.com/1430794_45f7ac8d93ff4d68bc354147e7e63500.html  
19. Grappler HQ, 8,591 bouts, 1994–2026, including decision subtypes — https://www.grapplerhq.com/mma/ufc-statistics/  
20. MMA.SOCIAL finish-rate hub (year and division; includes 2026 YTD) — https://mma.social/stats/finish-rates  
21. FightMatrix, UFC fight outcomes by year (decision subtypes) — https://www.fightmatrix.com/ufc-records/ufc-fight-outcomes/  
22. Szilagyi, `ufc.stats` striking note, 2020-04-15 — https://tamaszilagyi.com/ufc.stats/articles/2020-04-15-striking.html  
23. Jacob, UFC data report to UFC 292 — https://medium.com/@eduardocbjacob/ufc-data-report-309eaaf94fa3  
24. ESPN (2018), Khabib control vs lightweight average — https://www.espn.co.uk/mma/story/_/id/22946628/the-statistical-domination-ufc-lightweight-khabib-nurmagomedov-grappling-control  
25. Stanford CS229 2015, FightMetric career clusters — https://cs229.stanford.edu/proj2015/121_poster.pdf  

### Boxing / CompuBox

26. CompuBox method — https://boxrec.com/wiki/index.php/Compubox  
27. CompuBox reports (examples) — https://dev.compuboxdata.com/reports/77 , `/93`  
28. Bad Left Hook (2019) citing CompuBox league averages — https://www.badlefthook.com/2019/3/19/18272492/errol-spence-rises-to-the-top-of-compubox-stats-in-power-punching  
29. Professional male boxing activity profile (CompuBox sample of 320 fights) — ResearchGate 373724629  

### Definitions / explainers (secondary, used for wording not means)

30. AgentMMA, significant-strike definition with UFC Stats case tables — https://agentmma.com/mma-lab/ufc-significant-strikes-explained  
31. AgentMMA, control time — https://agentmma.com/mma-lab/ufc-control-time-explained  
32. FightMetric SLpM leaders post (formula) — http://blog.fightmetric.com/2011/02/ufc-leaders-strikes-landed-per-minute.html  

---

## 5. UNKNOWN / NOT FOUND

Searched 2026-09-10. Do not fill these with invented “industry averages.”

| Missing object | Why it matters | What exists instead |
| --- | --- | --- |
| **UFC-wide mean SLpM / SApM** on ufcstats.com or the Record Book | Record Book is **tails** (min 5 fights), not a mean | Fight-level implied SLpM **2.8–3.8** by division (INHERITED); combined **~3.4** per fighter (Jacob); 2015 cluster means 2.7–4.2 |
| **UFC-wide mean striking defense %** | Defense is on every fighter page; no league mean | Tails: GSP 73.1%. Typical pages **~50–62%** are anecdotal, not a sample mean |
| **UFC-wide mean TD Avg and Sub. Avg per 15 min** | Official rate stats have no published league mean | Per-fight attempts/landed by division (Fight Algorithm); convert only with a duration sample |
| **Takedown *attempts* per 15 min**, official | Engine may emit a rate; UFC publishes landed/15 and accuracy, not attempts/15 as a Record Book board | Attempts per fight × 15 / duration (fragile) |
| **Modern fight-time share** distance / clinch / ground | Easy to confuse with the **strike** split 72.6 / 13.4 / 14.1 | 2013 FightMetric-era time share (~50 / 18 / 33); 2018 LW ground-control 17%; Miarka coded action times |
| **UFC-wide mean control % of fight minutes** | Record Book control % is a specialist tail (60–79%) | 68.2% of *decisions* go to the higher-control fighter — different object |
| **Official UFC league target %** on statleaders | Per-fight head/body/leg exists; no published mean | Fight Algorithm **61–65 / 19–23 / 14–18** |
| **Landed vs attempted** target mix, separately | Engine 65.3/28.2/3.2 must be mapped to one of them | Division Meta language is “aim”; Volume Machine is “target distribution” — likely landed or mixed; **not disambiguated by the authors** |
| **IQR / SD of SLpM** at fight level | Spread requested; most public work gives means and tails | Accuracy described as “approximately normal”; KD range 0–51 significant head strikes/min (Mańka-Malara); volume histogram bins (25–74 modal) |
| **Knockdowns per 15 min, UFC-wide mean** | Record Book has a per-15 tail (McFedries 4.27) | Use **35.1% of bouts with ≥1 KD** and **0.41–0.52 combined KDs/fight** |
| **CompuBox league-wide knockdowns per fight / per round** | Boxing analogue for D5 | KO/TKO rates from BoxRec/*Neurology* instead |
| **CompuBox all-weight mean thrown/landed/round** as a single official number | CompuBox publishes fighter and division cards, not one grand mean on the public reports opened | 320-fight academic sample: 37.6 thrown/round, 34.6% connect; 2019 press: 23 jabs thrown/round, 36.9% power connect |
| **Jacob body-part % values** | Chart not recoverable as text | Fight Algorithm target mix |
| **SCORE/Kaggle 1,673-fighter SLpM quantiles** | Page is a teaching dataset without printed means | — |
| **Athletic-commission published UFC-wide stat reports** (NSAC, etc.) | Would be DIRECT | Commissions publish bout results/scorecards, not FightMetric league tables |
| **Reconciliation of Jacob 27% TD accuracy vs Division Meta 35–40%** | Material conflict | Prefer Division Meta (stated per-division landed/attempted). Flag 27% as unresolved. |

---

## 6. What “match” means for the six DECISIONS

Not a pass/fail on a point estimate. A sim that is “realistic” on this scoreboard:

1. **Pace (D1):** combined significant landed per fight-minute in the **high-single-digits**, per-fighter SLpM **~3** with division slope (HW lower volume, women/light higher). A 2.26× clock fails D1 even if every other margin is perfect.  
2. **Accuracy (D2):** significant landed/attempted **~40–50%**, slightly higher in heavier men’s divisions.  
3. **Targets (D3):** landed significant **~63% head, ~20% body, ~15% legs**, with **small** division spread. Legs at 3% fail D3.  
4. **Outcomes (D4):** pooled modern fights **~half decisions**; HW **~half KO/TKO**; WSW **~two-thirds decisions**; subs **~15–22%** everywhere. R1 contains **~25%** of modern bouts (half of all KO/TKOs).  
5. **Knockdowns (D5):** **about one-third of bouts**, not 13% (true KO) and not 50%+. Mean combined KDs/fight **~0.5**. Given a KD, **~⅔** of those bouts still end KO/TKO — so KD must raise stoppage probability without making it certain.  
6. **Takedowns (D6):** **~4–8 attempts** per fighter-fight (fewer at HW), **~35–40%** complete, **<1** submission attempt per fighter-fight.

Tails for sanity checks (not means): SLpM **8.7**, SApM **1.04**, sig accuracy **~74%**, TD defense **~96%**, control **~79%** of fight time, **20** career knockdowns — all Record Book, 2026-09-10.

---

*End of J20. No engine prescription. The scoreboard is the product.*

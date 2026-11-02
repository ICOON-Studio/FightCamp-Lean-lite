<!-- Grok (grok.com, Expert, in-app browser), collected verbatim by Claude S81 2026-09-26 from
https://grok.com/c/9667cede-9a83-4d36-8195-2e79f0438d3d ("113 sources"). Brief: TASK_G108_FINISH_RATES.md.
Tables re-set as markdown; wording unchanged. -->

# G108_FINISH_RATES

**Scope.** Named datasets only. A finish is KO/TKO/RSC/RTD/doctor/corner stoppage; MMA also counts SUB. DQ/NC are not finishes. Amateur is not mixed with pro; 3-round is not mixed with 12-round. Cells without a named n and window are UNSOURCED.

**Verdict for the census.** The MMA band "~53%" is a UFC-all-time figure, not a sport-wide constant. The boxing band "~25–40%" is below the largest modern BoxRec census of male pro bouts (~47% KO/TKO). The kickboxing band "~30–50%" is the right order for Glory; **FightCamp's 7% kickboxing finish rate is an engine miss, not a band miss.**

## 1. MMA
**UFC, all recorded bouts.** GrapplerHQ, n=8,591, 11 Mar 1994–28 Mar 2026: KO/TKO 2,800 (32.6%), SUB 1,659 (19.3%), decision 4,016 (46.8%), other (DQ/NC/overturned) 116 (1.4%). Finish = 51.9%. SOURCED https://www.grapplerhq.com/mma/ufc-statistics/ (2026-07-07).

**Modern calendar years 2015–2025** (same source): finish 44.5% (2024) to 52.6% (2022); 2025 = 50.0% (n=522). So "~53%" is all-time plus early-era inflation, not the last decade. SOURCED same.

**Title vs non-title** (same census). Official titles n=392 finish 57.4% but only 46.7% inside 15 min; non-title n=8,199 finish 51.6% / 51.1% inside 15 min. Five-round format inflates raw finish % via extra time. SOURCED same.

**Division** (same census, ≥100 bouts). HW 66.1% finish (n=765; 394 KO/TKO, 112 SUB); LHW 61.3% (n=752); MW 59.0% (n=1,134); WW 51.7%; LW 51.0%; FTW 45.4%; FLW 45.1%; BW 45.0%. Women's straw ~33% finish. Gate by weight, not one UFC mean. SOURCED same.

**Knockdowns, UFC.** RStudio UFC Fight History, n=8,337, 1994–6 Sep 2025: 2,930 fights had ≥1 knockdown (35.1% of bouts). Mean KD/fight by men's division 0.41–0.52 (LW 0.41, LHW 0.52, HW 0.47). SOURCED https://rstudio-pubs-static.s3.amazonaws.com/1430794_45f7ac8d93ff4d68bc354147e7e63500.html (2026-05-08). Independent model paper: mean 0.52 KD/fight. SOURCED https://www.researchgate.net/publication/352657185 (2021).

**Draw / DQ / NC, UFC.** Betting census 2021–2025, n=2,577: draws 18 (0.7%), no-contests 26 (1.0%), KO/TKO 31.7%, SUB 17.3%, decision incl. draws 49.7%, other 1.3%. SOURCED https://parlaytools.com/articles/ufc-mma-betting-guide/ (2026-05-06).

**Regional pro MMA.** Nate Latshaw / Sherdog (unofficial): 2023 YTD (~75% of year) finish Cage Warriors 66.4%, CFFC 65.9%, ONE MMA 64.2%, KSW 63.4%, LFA 62.2%. 2024: UFC 44.8% finish (lowest of 10 major promotions); CW 65.9%. SOURCED https://x.com/NateLatshaw/status/1709570315955974584 (2023-10-04); https://bloodyelbow.com/2025/01/06/mma-study-reveals-the-ufc-ranks-last-in-several-major-categories-compared-to-rival-promotions/ (2025-01-06). Use ~60–66% for regional 3×5, ~45–52% for modern UFC.

**Amateur MMA.** IMMAF/WMMAA/FELODA 2018, n=279 male: decision >70%, SUB 17%, KO/TKO 12% (stand-up 3.9%, GnP 8.2%) → finish ~29%. SOURCED https://www.researchgate.net/publication/353325262 (2021). Australian commission sample (not IMMAF rules): amateur male n=1,029 fights KO 7.8% + TKO 28.2% + SUB 23.4% = 59.4% finish; pro male n=330 finish 68.2%. SOURCED Brown et al., Sports Health 2025 https://journals.sagepub.com/doi/10.1177/19417381241263332. Do not average IMMAF with AU club.

**Leg-share of significant strikes, UFC.** Head 64% / body 20% / legs 16% of sig. strikes landed. Leg volume ~7/fight (2010) → ~14/fight (2021). SOURCED https://dolex.org/demos/leg-strikes/ (page dated 2026-03-04; UFC Stats derived).

## 2. Boxing
**Largest modern census.** Neurology abstract using BoxRec, n=237,238 pro matches, 1 Jan 2014–1 Jan 2024. Male n=222,683: KO 15%, TKO 32%, KO/TKO 47%. Female n=14,555: KO 5%, TKO 24%, KO/TKO 29%. Per-minute rates almost equal after 2-min female rounds. SOURCED https://www.neurology.org/doi/10.1212/WNL.0000000000212434 (2025-04-07).

**US club/small-hall window.** Association for Ringside Physicians, n=1,690 US pro fights, 1 Jul–31 Dec 2017: KO 18.1% (n=306), TKO 35.1% (n=594), decision 46.5% (n=786), DQ 0.2% (n=4) → KO/TKO 53.2%. State split: NC 67.1% vs Nevada 38.5%. Winless fighters lose by KO/TKO 58–80%. SOURCED https://ringsidearp.org/wp-content/uploads/2019/12/ARP-Vol1-Iss2.pdf (2019). This is the 4–8-round / mismatch-rich band.

**Championship 10–12-rounders.** No named all-title census with n. 33rd Square cites "41% KOs in world title fights 2013–2018" with no n — treat as UNSOURCED. PROXY: Nevada-style cards (~38% KO/TKO in the 2017 sample) plus longer scheduled distance and tighter matching → championship finish below the 47–53% male-pro mean, plausibly mid-30s. JUDGEMENT, not a gate number.

**Amateur 3×3 elite.** London 2012 Olympics: 272 bouts, 4 RSC (1.5%), 0 KO / RSCH / RSCI. SOURCED Bianco et al., BJSM 2013 https://bjsm.bmj.com/content/47/7/452. Davis et al. elite 3×3 sample: 50 bouts, 2 stopped (4%), 4 standing-eights (8%). SOURCED https://www.researchgate.net/publication/313672929 (2017). Historical 3×3 with headguard: combined RSC+RSCH+KO ~14–22% (Bianco eras). Modern elite amateur finish is low single digits to high single digits, not the 25–40% pro band.

**Draws, boxing.** Not broken out of the 46.5% "decision" bucket in ARP 2017. Modern pro draw rate UNSOURCED. DQ 0.2% in that sample. SOURCED ARP.

**Knockdowns/fight, boxing.** Aggregator "0.8 KD/fight in 2023" has no method. UNSOURCED. SUB = 0 by rule.

## 3. Kickboxing
**Glory 2024–2025** (3×3, titles 5×3; 3-KD TKO). Beyond Kickboxing bout census: 2024 n=104, (T)KO 33 (31.73%), injury (non-strike) 4, decisions+draws 67. 2025 n=97, (T)KO 34 (35.05%), 1 DQ, decisions+draws 62. Pooled n=201, strike stoppages 67 (33.3%). HW 2025 46% (n=50); FTW 2025 15.8% (n=19). SOURCED https://www.beyondkick.com/opinion/glory-s-knockout-count-in-2024-a-full-breakdown/ (2026-09-25) and 2025 counterpart (2026-09-26). SUB = 0.

A 2021 betting note that "about 2/3 of Glory fights go to decision" matches this order. PROXY https://beforethecagedoorcloses.com/predict-the-outcome-in-kickboxing/ (2021-03-01).

**ONE kickboxing / K-1 / WAKO / IFMA amateur.** No named n+window finish table found. ONE 2023 style chart (Latshaw) shows kickboxing KO/TKO below ONE Muay Thai and below ONE MMA. Exact % UNSOURCED. Amateur WAKO/IFMA UNSOURCED.

**Leg share, kickboxing.** Glory video study (~100 Superfights): winners landed ~61.8 punches and ~33.6 kicks (kicks ≈ 35% of landed strikes) — kicks include head/body, not legs only. PROXY https://cyberleninka.ru/article/n/quantitative-and-qualitative-assessment-of-hitting-actions-in-modern-professional-kickboxing-k-1. True "leg share of significant strikes" UNSOURCED.

**Knockdowns/fight, Glory.** Rule is 3 KD/round or 4/fight = TKO. Mean KD/fight UNSOURCED. Draw rate UNSOURCED (folded into "DEC including draws").

## 4. Muay Thai
Traditional 5×3 stadium scoring rewards late-round points; academic 29th ISUZU tournament paper selected 12 fights that all went the distance (n=12, finish 0% by design). Not a finish census. SOURCED https://www.researchgate.net/publication/370350353 (2023).

Rajadamnern "Knockout" card markets an "80% KO rate" — promotional, not a stadium census. UNSOURCED as a sport rate.

ONE Muay Thai (4 oz gloves, no grappling) has the highest KO/TKO of ONE's three rulesets in Latshaw's 2023 chart. Exact % UNSOURCED. Gate traditional stadium and ONE MT as separate rows; do not use 80%.

## 5. What the old bands got wrong
| Old census band | What the named data say |
|---|---|
| Boxing ~25–40% | Male BoxRec 2014–24 47% KO/TKO (n=222,683). US H2-2017 53% (n=1,690). 25–40% is a plausible championship / Nevada-card PROXY, not the sport mean. |
| Kickboxing ~30–50% | Glory 2024–25 33% (n=201) sits at the floor of that band. 7% is not a band error. |
| MMA ~53% | UFC all-time 51.9% (n=8,591). Modern UFC years 45–53%. Regional 60–66%. Amateur IMMAF ~29%. One number cannot gate all three levels. |

**Recommended engine defaults (only sourced cells).** Amateur boxing 3×3: finish 2–8%. Pro boxing club 4–8: finish 47–53% KO/TKO. Pro boxing championship: leave unsourced or PROXY ~35%. Glory-class kickboxing: finish ~33% KO/TKO. UFC: finish 50% ±5 (KO/TKO ~32, SUB ~19, draw ~0.7, KD/fight ~0.45, legs 16% of sig. strikes). Regional MMA: finish ~63%. Amateur IMMAF MMA: finish ~29% (SUB 17, KO/TKO 12).

## Gate table
Finish % = KO/TKO (+ SUB in MMA). DQ excluded from finish.

| Sport × level | Finish % | KO/TKO % | SUB % | Draw % | KD / fight | Leg share % | n | Window | Tag |
|---|---|---|---|---|---|---|---|---|---|
| Boxing amateur elite 3×3 | 1.5 | 1.5 RSC | 0 | UNSOURCED | UNSOURCED | — | 272 | OG 2012 | SOURCED BJSM 2013 |
| Boxing amateur elite 3×3 (lab) | 4 | 4 | 0 | UNSOURCED | UNSOURCED | — | 50 | post-2013 rules | SOURCED Davis 2017 |
| Boxing pro male all levels | 47 | 15 KO + 32 TKO | 0 | UNSOURCED | UNSOURCED | — | 222,683 | 2014–2024 BoxRec | SOURCED Neurology 2025 |
| Boxing pro female | 29 | 5 KO + 24 TKO | 0 | UNSOURCED | UNSOURCED | — | 14,555 | 2014–2024 BoxRec | SOURCED Neurology 2025 |
| Boxing pro US (club-heavy) | 53.2 | 18.1 KO + 35.1 TKO | 0 | UNSOURCED (in 46.5 DEC) | UNSOURCED | — | 1,690 | US H2 2017 | SOURCED ARP 2019 |
| Boxing championship 10–12 | UNSOURCED | UNSOURCED | 0 | UNSOURCED | UNSOURCED | — | — | — | UNSOURCED |
| Kickboxing Glory | 33.3 | 33.3 | 0 | UNSOURCED | UNSOURCED | UNSOURCED | 201 | 2024–2025 | SOURCED BeyondKB 2026 |
| Kickboxing ONE / K-1 | UNSOURCED | UNSOURCED | 0 | UNSOURCED | UNSOURCED | UNSOURCED | — | — | UNSOURCED |
| Kickboxing amateur WAKO/IFMA | UNSOURCED | UNSOURCED | 0 | UNSOURCED | UNSOURCED | UNSOURCED | — | — | UNSOURCED |
| Muay Thai stadium traditional | UNSOURCED | UNSOURCED | 0 | UNSOURCED | UNSOURCED | UNSOURCED | — | — | UNSOURCED |
| Muay Thai ONE | UNSOURCED | UNSOURCED (highest of ONE styles) | 0 | UNSOURCED | UNSOURCED | UNSOURCED | — | 2023 chart | PROXY Latshaw 2024-01-04 |
| MMA UFC all-time | 51.9 | 32.6 | 19.3 | 0.7 (2021–25) | 0.41–0.52 | 16 | 8,591 / KD n=8,337 / draw n=2,577 | 1994–2026; KD to 2025-09; draw 2021–25 | SOURCED GrapplerHQ; RStudio; ParlayTools |
| MMA UFC modern year | 44.5–52.6 | ~29–34 | ~16–20 | ~0.7 | ~0.45 | 16 | ~450–520 / yr | 2015–2025 | SOURCED GrapplerHQ |
| MMA regional (CW/LFA/KSW/ONE) | 62–66 | UNSOURCED split | UNSOURCED split | UNSOURCED | UNSOURCED | UNSOURCED | unofficial Sherdog year slices | 2023–2024 | SOURCED Latshaw / Bloody Elbow |
| MMA amateur IMMAF-class | ~29 | 12 | 17 | UNSOURCED | UNSOURCED | UNSOURCED | 279 | 2018 | SOURCED ResearchGate 2021 |
| MMA amateur AU commissions | 59.4 | 36.0 | 23.4 | UNSOURCED | UNSOURCED | UNSOURCED | 1,029 male | AU sample to 2024 | SOURCED Brown 2025 |

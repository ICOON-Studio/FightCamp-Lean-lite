# K38 — HOW OFTEN AND HOW LONG FIGHTERS CLINCH, SPORT BY SPORT

Kalli (Grok Bot), research, 2026-09-13, one pass. Task: `research/TASK_K38.md`. Written into the repo by Claude
from Kalli's reply; the tables are Kalli's.

## DECISIONS (Claude's reading)

1. **Boxing clinches about 10% of round time** - elite male amateurs (Davis et al. 2015, IJSPP, 29 bouts): 2.5 +- 2.0,
   3.2 +- 2.1, 4.8 +- 2.6 clinches in rounds 1-3, totalling 12.6, 17.2, 28.7 s a round (~5-6 s each, rising with
   fatigue - Dunn 2017). Elite women 2023 finals: 4.06 +- 2.27 s a clinch phase. No professional 12-round study
   (NOT FOUND). **The engine's boxers clinch 0.0% (Q90).**
2. **Kickboxing near zero by rule** - GLORY 2025: one strike from the clinch, then break; ISKA K-1 one strike then
   release; WAKO K-1 one knee (clinch removed from 2027). No measured share (NOT FOUND). The engine's 0.0% is plausible.
3. **Muay thai: no documented share of fight time in the clinch** (studies code "interaction" bursts of 3.7-5.5 s, not
   the clinch alone). IFMA and Lumpinee allow a sustained, active clinch until the referee calls Yaek/Break. The
   engine's 1.9% is probably low, but no primary number can judge it yet.
4. **MMA: 13.36% of fight time in mutual clinch** (91 lower-weight UFC bouts, DOI 10.62852/css/2026/243) - the one
   published share; ABC Unified breaks on judgment, no clock. **The engine's 1.8% is an order of magnitude low.**
5. **Break -> next strike latency: NOT FOUND** anywhere.

## KALLI'S TABLES
### 1. Time-motion studies (clinch)

| Sport | Finding | Number (mean ± SD, sample) | Label | Source |
|---|---|---|---|---|
| Boxing (elite ♂ amateur) | Clinch frequency rises across rounds | R1 2.5 ± 2.0; R2 3.2 ± 2.1; R3 4.8 ± 2.6 clinches/round; 29 Olympic final/semi bouts, 39 boxers, 3×3 min | DOCUMENTED | Davis P, Benson PR, Pitty JD, Connorton AJ, Waldock R. The activity profile of elite male amateur boxing. Int J Sports Physiol Perform. 2015;10(1):53–57. DOI 10.1123/ijspp.2013-0474 |
| Boxing (elite ♂ amateur) | Total clinch time per round | R1 12.6 ± 11.0 s; R2 17.2 ± 12.1 s; R3 28.7 ± 17.7 s (same sample); round length ~189–202 s | DOCUMENTED | Same Davis et al. 2015 |
| Boxing (elite ♂ amateur) | Implied mean clinch episode & bout share | ≈ 5–6 s/clinch (total clinch ÷ frequency); bout clinch ≈ 58.5 s / ≈ 585 s ≈ ~10% of in-round time (derived from published means) | SECONDARY (arithmetic from DOCUMENTED means) | Derived from Davis et al. 2015 Table values |
| Boxing (elite ♀ amateur) | Clinch frequency & time (4×2 min Olympics) | Frequency R1–4: 1.5 ± 1.1, 2.1 ± 1.4, 2.3 ± 1.5, 2.8 ± 2.3; clinch time 9.4 ± 7.1, 14.2 ± 11.9, 16.4 ± 12.0, 17.8 ± 14.6 s; 18 bouts; clinch = 50–61% of stop time | DOCUMENTED | Davis P et al. Performance analysis of elite female amateur boxers… (female Olympic activity profile; values as reported in study tables / secondary quotes of those tables). Related: ResearchGate record |
| Boxing (elite ♀, 2023 WC finals) | Mean clinch-phase duration | 4.06 ± 2.27 s per C phase; 12 finals, 3×3 min; C treated as part of fighting when strikes exchanged | DOCUMENTED | Time–Motion Analysis of the 2023 Women’s World Boxing Championships Finals. PMC PMC12197034 |
| Boxing (national ♂) | Clinch-time rises with round; winners ≈ losers on clinch | Clinch-time ↑ R1→R2 and R1→R3 (moderate–large ES); winners/losers similar clinch & interaction; 26 elite ♂, national champs | DOCUMENTED | Dunn EC et al. Human behaviours associated with dominance… PLoS One. 2017. DOI 10.1371/journal.pone.0188675 |
| Kickboxing / K-1 (Glory) | High/low intensity & pauses — no clinch variable | HI 234.6 ± 133.9 s; LI 97.4 ± 60.1 s; pause 36.0 ± 19.9 s; effort:pause ~1.8:1; 17 Glory middle-heavy matches | DOCUMENTED (activity) / NOT FOUND (clinch %) | Time–motion Glory K1 study, IJSPP / PubMed 39191384 DOI 10.1123/ijspp.2023-0491 |
| Kickboxing & Muay Thai (amateur) | Observation / Preparation / Interaction — Interaction ≠ clinch-only | Interaction median 5 s (both); Observation longer than Prep/Interaction; KB E:P ~6:12 (1:2), MT ~9:12; n = 13 matches | DOCUMENTED (effort structure) / NOT FOUND (clinch share) | Silva JJR, Del Vecchio FB, et al. Time-Motion analysis in Muay-Thai and Kick-Boxing amateur matches. J Hum Sport Exerc. 2011;6(3). DOI 10.4100/jhse.2011.63.02 |
| Muay Thai (national BR) | Interaction duration by phase | Interaction prelim 5.5 ± 0.3 s vs finals 3.7 ± 0.5 s; Obs ~7–8 s, Prep ~3 s; HI:LI 1:2 elim / 1:3 finals; 65 matches | DOCUMENTED (Interaction) / NOT FOUND (% time in clinch) | Del Vecchio FB, Silva JJR, Farias CB. Temporal analysis of national level Muay-Thai matches… Rev Artes Marciales Asiáticas. DOI via revistas.unileon.es |
| MMA (UFC lower weights) | Share of fight time in mutual clinch | Mutual clinch 13.36% of total match time; stand-up 49.63%; ground 36.17%; 91 small-weight UFC bouts (Fight Night 2014–15 / UFC 168 era sample as stated) | DOCUMENTED | Winning techniques and time characteristics in UFC lower weight class MMA. DOI 10.62852/css/2026/243 |
| MMA (UFC, technical–tactical) | Clinch as a phase for strikes/takedowns — large samples, not a single bout % | e.g. 1,752 rounds / 584 UFC bouts coded distance / clinch / ground (actions, not mandatory time %) | DOCUMENTED (phase coding) | Miarka B et al. Performance probabilities… bout phase changes of MMA. Int J Perform Anal Sport. 2017. DOI 10.1080/24748668.2017.1360103 |
| MMA | Stand/ground HI–LI time-motion without separate clinch duration in classic Miarka outcome papers | Standing LI medians ~2:07–2:37/round (outcomes study, 645 paired rounds) | DOCUMENTED / NOT FOUND (clinch seconds in those papers) | Miarka B et al. JSCR 2016;30(7):1975–1984. DOI 10.1519/JSC.0000000000001287 |
| Professional boxing | Time-motion clinch % for pro 12×3 | NOT FOUND in this pass | NOT FOUND | — |

### 2. Referee clinch rules

| Sport | Finding | Number or rule | Label | Source |
|---|---|---|---|---|
| Boxing (ABC) | Holding / deliberately maintaining a clinch is a foul; hitting on the break is a foul | No fixed “X seconds then break” in ABC foul list; referee directs break (“punch” / “get out” / step in) | DOCUMENTED | ABC Regulatory Guidelines… (Boxing Handbook). Foul list items 4 & 15. PDF |
| Boxing (USA Boxing / IBA-style manuals) | Distinguish infighting vs clinching; “Break” after prolonged holding; both take one full step back; break awkward clinches immediately | No published inactivity-second threshold | DOCUMENTED | USA Boxing Official’s Manual / Referee & Judges Manual (Break / clinching sections). e.g. 2025 Official’s Manual |
| Kickboxing — GLORY | Clinch allows one immediate single strike, then immediate disengage (2025 update) | One strike → break | DOCUMENTED | GLORY, Updates to GLORY Rules, 10 Jan 2025 — https://glorykickboxing.com/news/updates-to-glory-rules |
| Kickboxing — ISKA K-1 | One-hand hold + one legal strike/knee, then release; continuous hold / multi-knee foul; two-hand clinch for knees often illegal | One strike then release | DOCUMENTED | ISKA K1 rules PDFs (e.g. ISKA WA K1; ISKA AU K1 Pro) |
| Kickboxing — WAKO K-1 (current → 2027) | Classic: two-hand neck/shoulder hold for one immediate knee only; from 1 Jan 2027 clinch/hold/grab removed, unlimited open-range knees | One knee (current) → no clinch (2027) | DOCUMENTED | WAKO Chapter 10 K1 rules; WAKO Europe rules-change notice — https://kickboxingeurope.com/news/wako-rules-changes-and-updated-medical-forms/ |
| Muay Thai — IFMA | Command “Yaek” (Break) on clinch; each athlete steps back before continuing; hitting immediately after Yaek without step-back is a foul | Sustained clinch allowed while active; no “one knee then break” | DOCUMENTED | IFMA Rules (updated Mar 2016), Rule XIII 13.2.5; Foul 18.2.10. PDF |
| Muay Thai — Lumpinee | Referee uses STOP / BREAK / BOX; on BREAK, separate ≥ one step then continue | Clinch legal while productive; break when ordered | DOCUMENTED | Lumpinee rules — https://lumpineestadium.com/rules (§10 referee) |
| Muay Thai — ONE | Faster, inactivity-sensitive breaks vs stadium MT (common description) | No primary ONE rulebook text with a fixed second count found in this pass | SECONDARY / NOT FOUND (exact seconds) | Secondary guides; primary ONE PDF not retrieved here |
| MMA — ABC Unified | Referee stands up or breaks when neither fighter shows real, significant, sustained effort to finish; superior position alone is not enough | No fixed second clock — referee judgment | DOCUMENTED | ABC Unified Rules of MMA (2023), “Standing up or Breaking Fighters.” PDF |
| MMA | Attack on the break illegal | Foul | DOCUMENTED | Same Unified Rules / MMA Officials Handbook |

### 3. Who clinches (correlates)

| Sport | Finding | Number / pattern | Label | Source |
|---|---|---|---|---|
| Boxing | Clinch ↑ later rounds; co-moves with rising fatigue ratings / less bounce | Davis ♂: clinch freq & time ↑ R1→R3; Dunn: clinch-time ↑ with round + fatigue Likert ↑; winners ≈ losers on clinch | DOCUMENTED | Davis 2015; Dunn et al. 2017 PLoS One |
| Boxing (♀) | Clinch time & frequency higher in later rounds of 4×2 format | See §1 female Olympic table | DOCUMENTED | Davis female Olympic profile |
| Boxing (♀ 2023) | Clinch use varies by weight; HWC more C-reliant in that finals sample | Qualitative + C duration by class in paper | DOCUMENTED | PMC12197034 |
| Muay Thai | Finals have shorter Interaction than prelims | 3.7 ± 0.5 vs 5.5 ± 0.3 s | DOCUMENTED | Del Vecchio et al. RAMA |
| Kickboxing | Style/fatigue → clinch frequency | NOT FOUND (Glory/K-1 papers don’t isolate clinch) | NOT FOUND | — |
| MMA | Clinch time share by style / being hurt | NOT FOUND as a dedicated clinch-% × fatigue study in this pass; phase studies exist for win predictors (strikes/takedowns), not “hurt → clinch %” | NOT FOUND (that specific link) | Miarka phase papers code clinch actions, not hurt→clinch % |

### 4. Timed break → next strike

| Sport | Finding | Number | Label | Source |
|---|---|---|---|---|
| Boxing (♀ Olympic) | Referee stop time stays ~constant while clinch grows | Referee stop time ~9–15 s/round (means); ~12 s cited as stable across later rounds — this is stoppage duration, not “break call → first punch” latency | DOCUMENTED (stop duration) / NOT FOUND (break→strike latency) | Davis female profile (via study tables / PMC12197034 discussion quoting ~12 s) |
| All sports | Clocked interval from verbal “Break” / “Yaek” to first legal strike | NOT FOUND | NOT FOUND | — |

#### GAPS
No published pro boxing clinch % for 12×3.

Kickboxing time-motion almost never codes clinch despite one-strike rules → share expected tiny but unmeasured.

Muay Thai studies code Interaction, not plum/clinch share → no trusted stadium “% of fight in clinch” for engine judgment.

ONE MT break-after-inactivity seconds not in a primary text retrieved here.

Break → next strike latency unmeasured.

MMA 13.36% is lower-weight UFC sample / mutual-clinch definition — don’t treat as all-weight universal without checking other classes.

#### Judgment numbers (one per sport)

Boxing — ~10% of in-round time in clinch (elite ♂ amateur), or ~3–5 clinches/round averaging ~5–6 s. Confidence high for elite amateur (Davis 2015 primary); lower for pro 12-rounders (no equal study). Engine 0.0% is far below this.

Kickboxing (K-1 / GLORY / ISKA) — clinch share should be near floor: brief one-strike grabs, not a phase. Confidence high on rules, low on measured % (NOT FOUND). Engine 0.0% is plausible for K-1; don’t use MT clinch targets here.

Muay Thai — no DOCUMENTED fight-time clinch %; Interaction bursts ~4–5.5 s are not clinch-only. Confidence low for a single share target. Engine 1.9% is almost certainly too low vs Thai stadium practice (rules allow sustained active clinch), but this pass cannot cite a primary % — next capture/study should code clinch separately from Interaction.

MMA — ~13% mutual clinch of total fight time (lower-weight UFC sample) as the best published share. Confidence moderate (one clear % study + large phase literature). Engine 1.8% is an order of magnitude low if “clinch” matches that mutual-clinch definition (fence clinch included in related cage-time work).


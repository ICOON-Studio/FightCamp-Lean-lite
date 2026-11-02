# G100 — How much do fighters actually move?

Grok (Expert, 2m14s, 102 sources), https://grok.com/c/97c5c3fc-9664-4d5c-be09-b6551121bde0 — collected S78 2026-09-25
from the artifact `TASK_G100_fighter_movement.md` (16 KB). Text as delivered; the tables were flattened by the page
and are rebuilt here as markdown with the same cells.

**Verdict first.** A coach and a sports scientist are measuring different things. The operator is closer to the coach.

Coaches teach economy: hold the pocket, take small steps, stay on the balls of the feet, change posture, feint, then
burst. "Busy" is head, shoulders, weight shift, jab — not walking the ring. Reset is a half-step out or a pivot, not a
lap. Pressure fighters walk more; out-boxers and counters hold and punish entries.

Time-motion analysis (TMA) codes video phases (fighting / no-fighting / clinch / referee stop; or high vs low
intensity), not metres. The locomotion proxy in boxing TMA is vertical hip movement (VHM) — any visible pelvis
bounce/step — not centre-of-mass travel. GPS / homography studies that do measure travel put amateur/elite boxing at
~36–52 m/min at ~0.6 m/s mean speed. That is a slow walk averaged across the round, produced by many 15–30 cm steps
plus bounce, not continuous circling.

**Engine check.** 50 m/min boxing sits at the high end of measured translation (French elite video 52 m/min; Thomson
GPS-corrected 36 m/min). 72–84% of frames >0.25 m/s will fire on bounce, weight shift, and 20 cm steps. Coaches would
still call that "in place." MMA 33 m/min is plausible for a stand-heavy bout and high for a grind.

## What TMA actually measures

Video notated into phases. Intensity = exchange vs observation/preparation. Distances are rare. Work:rest usually
excludes the 60 s between-round rest.

| Method | What it counts | What it misses |
|---|---|---|
| Davis activity profile | punches, defences, VHM, clinch/stop time | metres, step length, feints |
| Slimani review | activity:break ratios, stop time by round | style, GPS |
| Martusciello 2025 (women WC) | F / punch / clinch / NF / AI durations | displacement |
| Del Vecchio / Miarka MMA | standing/ground × high/low intensity | metres, feints |
| Thomson GPS + video | m/min, direction counts | elite official bouts (sparring) |
| French FFB homography | metres/round, inter-fighter range | step type |

## 1. Stationary vs low vs high; work:rest; burst / pause

### Boxing
- SOURCED — Davis 2015, IJSPP; 29 OG 2012 semi/finals; 39 elite men. Activity rate ~1.4 actions/s over ~200 s net
  rounds. ~20 punches, ~2.5 defences, ~47 VHM per minute. Total stop time: R1 21.5 ± 15.0 s, R2 32.3 ± 18.0 s, R3
  50.2 ± 25.0 s. Activity-to-break: R1 31:1 → R2 16:1 → R3 6.6:1 (mean often cited as 18:1). Clinch time and
  frequency rise each round (2.5 → 3.2 → 4.8 clinches; 13 → 17 → 29 s).
- SOURCED — Davis 2018, JSCR; 50 World Championship bouts; 60 elite men, post-2013 rules. ~1.55 actions/s; ~21
  punches, ~3.6 defences, ~56 VHM / min. Activity:break 19.3:1. Net round ~184 s. Tactical shift to long-range
  straights + more movement/defence vs pre-2013 hook-heavy pocket.
- SOURCED — Slimani, Davis et al. 2017 review, JSCR. Elite A:R 18:1; novice 9:1. Novice by round: 16:1 → 8:1 → 6:1.
  Stop time and stop frequency climb.
- SOURCED — Martusciello et al. 2025, Sports; 12 IBA 2023 women's WC finals, 3×3 min. Punch-phase mean duration
  ~1.5–2.0 s (weight-class range 1.48–1.96 s). Clinch bout ~4 s. NF (no-fight / observation) ~2–5 s. AI ~5–6 s. F/NF
  split is style- and class-dependent: some classes fight-dominant, some NF-dominant (54/57/60/75 kg). Heavies clinch
  more.
- SOURCED — Davis, Wittekind, Beneke 2013 (novice 3×2) via Slimani. Same intermittent pattern; lower A:R than elite.
- JUDGEMENT. "Stationary" in the coach sense is most of NF + guard-holding inside F. It is not zero VHM. Elite boxers
  are bouncing almost every second (47–56 VHM/min) while COM travels slowly.

### MMA / UFC
- SOURCED — Del Vecchio, Hirata, Franchini 2011, Percept Mot Skills; 52 regional athletes, 26 bouts. High-intensity
  standing burst 6–9 s (R1 mean 9 s, range 3–40). Low-intensity standing 15–18 s. High-intensity ground 8–14 s.
  Low-intensity ground 21–36 s. Referee pause 8–10 s. 2–3 activity blocks per round, each 53–79 s. Effort:pause
  (combat vs pause) 6:1 to 9:1. High-intensity : (low + pause) 1:2 to 1:4.
- SOURCED — Miarka et al. 2015, Int J Perf Anal Sport; 2097 UFC 2012–14 bouts. R1 pooled: standing low-intensity
  146 ± 90 s, standing high-intensity 17 ± 32 s, ground high-intensity 34 ± 65 s, total high-intensity 55 ± 70 s,
  total effort 258 ± 80 s. Heavies: shorter total effort (R1 212 s vs 258 s others). Flyweights more standing-low time
  (161 s).
- SOURCED — Miarka et al. 2016, JSCR; 645 paired UFC rounds. Standing low-intensity medians: R1 2:34, R2 2:37, R3 2:07
  of a 5-min round. Standing high-intensity in early-finish bouts ~7–10 s; in R3 of 3-round fights ~18 s.
- SOURCED — Miarka 2019 long fights. 5th-round bouts: 79% of the round low-intensity vs 75% in 3rd-round finishes;
  4th-round 84% low-intensity.
- PROXY. "Share of time moving" for MMA stand-up ≈ standing-low + standing-high ≈ 50–70% of a 5-min round when the
  fight stays up; translation collapses on the fence and the mat.

## 2. Distance and steps
- SOURCED — Thomson 2015 PhD (Chester); GPS 5 Hz + video; 12 amateur boxers, outdoor open spar, 4.88 m ring.
  GPS-corrected travel 35.9 m·min⁻¹, mean speed 0.6 m·s⁻¹. Uncorrected GPS during 3×3 sparring ~44 m·min⁻¹ (113 m /
  3-min round). 2-min-round spars ~39–41 m·min⁻¹. Video: fighters more often neutral (in-place / stance) than back,
  left, or right. Direction effect large.
- SOURCED — Pidancier / FFB / ECSS 2023; single-cam homography; 32 elite French national fights, 33 boxers (18 W /
  15 M). 155 ± 28 m per 3-min round → ~52 m·min⁻¹. Mean fighter-to-fighter range 1.23 ± 0.16 m (pocket / mid-range,
  not circling the ring).
- No sourced step-count study. Closest proxies: Davis VHM 47–56 / min (SOURCED) and coach step length 15–25 cm /
  6–10 in (PROXY, common coaching literature). 36–52 m/min at 20 cm/step implies ~180–260 steps/min if every metre
  were a discrete step — that overcounts because bounce and stance-width adjustments inflate GPS/video path. Real step
  events are closer to VHM frequency.
- MMA distance: none found. PROXY: stand-up stretch similar to boxing low end (~25–40 m/min); clinch/ground near 0.
  Bout-average 15–35 m/min depending on takedown rate.
- Game vs literature. Boxing engine 50 m/min ≈ French elite, above Thomson amateur GPS. MMA engine 33 m/min is a
  reasonable stand-heavy bout, high for a wrestler.

## 3. Variation (style, weight, round)
- Style — JUDGEMENT + Thomson CV note. Thomson: within-group CV of technical actions >30% — style dominates. Pressure:
  more forward steps, more F-time, more VHM. Out-boxer: more NF, more lateral/back steps, range held ~1.2–1.8 m.
  Counter: long NF holds, short 1–3 s entries. No paper splits metres by Krasser / Mayweather / Fury archetypes.
- Weight — SOURCED. Boxing women 2023: heavies clinch more; 54–60 kg more NF. UFC: heavyweights shorter standing
  effort, more explosive finishes / less total movement time (Miarka 2015). Lighter classes more standing-low time
  (fly 161 s vs HW 120 s standing-low in R1).
- Round — SOURCED. Boxing: stop + clinch grow every round; A:R collapses; VHM and activity rate can still rise (elite)
  because net time shrinks. MMA: late rounds of long fights are more low-intensity (75–84%), not more walking.

## 4. Side steps / pivots / feints
- Side step size — PROXY (coaching consensus, not lab). 15–25 cm. A full ring-walk step is a mistake; coaches cap it
  at "toe-to-heel" or "half a foot."
- Side steps / pivots per minute — PROXY. Thomson: directional moves less frequent than neutral. Reasonable gate:
  8–20 lateral/pivot events per minute for an active out-boxer; 4–10 for a pocket fighter. Not sourced as a count.
- Feints per minute — no TMA count found. Davis does not code feints. JUDGEMENT: 3–8 hand/shoulder feints/min in
  orthodox amateur; 8–15 in feint-heavy pros (Leonard-type). Level-change feints rarer in boxing (~1–3/min), common as
  shot fakes in MMA.
- Treat VHM 47–56/min as the sourced "feet are busy" number. Most of those are not sidesteps.

## 5. Rhythm: hold → burst → reset
- Boxing — SOURCED durations + JUDGEMENT cycle. Hold / NF / probe: 2–8 s (women NF 2–5 s; elite first-stop often
  30–60 s into the round then micropauses). Burst (step-in + exchange): punch phases 1.5–3 s; a 3–4 punch combo is
  ~1–2 s of arm time plus one step in. Reset (step off / pivot / clinch): 1–4 s, or a 4 s clinch. Cycle length
  typically 6–12 s, not a 20 s walk.
- MMA stand-up — SOURCED Del Vecchio. Low-intensity probe 15–18 s → high-intensity exchange 6–9 s → pause 8–10 s. Or:
  3–4 HI stand sequences + 4–5 LI stand sequences per activity block.
- That is the engine rhythm to copy. Not constant 0.3 m/s drift.

## 6. Metabolic cost of footwork vs standing in guard
- SOURCED — Davis, Wittekind, Beneke 2014, IJSPP (semi-contact 3×2 amateur). Energy mix 77% aerobic / 19% PCr / 4%
  glycolytic. In-round VO2 near treadmill VO2peak. Aerobic cost is the tax on staying switched on, not on walking laps.
- SOURCED — Compendium (Ainsworth 2011) METs. Shadow boxing 5.5–7.0 MET; general boxing training 9; sparring 12 MET.
- SOURCED — Arseneau / Mekary / Léger type gym studies. Sparring and pads ~41–43 ml·kg⁻¹·min⁻¹ (~70% VO2peak). Bag
  work at low punch rate without footwork much cheaper (~25 ml·kg⁻¹·min⁻¹ at 60 punches/min). Footwork + guard +
  bounce is a large fraction of the aerobic bill even when the fighter "doesn't go anywhere."
- JUDGEMENT. Standing in a loaded guard with a bounce is already expensive. Extra metres are extra cost and extra
  openings. That is why coaches preach economy.

## Gate table (use these)

Values are per fighter, in-round, excluding between-round rest. Tag: S sourced, P proxy, J judgement.

| Gate | Boxing | MMA (stand-up stretch) | MMA (bout avg, mix) | Tag |
|---|---|---|---|---|
| Share of time "translating" COM | 15–35% truly travelling; 60–80% in-place busy | 20–40% travelling while standing | 10–25% (ground/clinch kill travel) | J, from TMA phases + GPS |
| Share of time high-intensity exchange | punch phases short; A:R 18:1 elite but exchange bursts 1.5–3 s | HI stand ~6% of 5-min round (~17 s) | HI all ~15–25% of round; long fights 16–25% HI | S Davis; S Miarka 2015/19 |
| Share of time low-intensity / hold / probe | NF + guard; grows late-round via clinch/stop | standing-low ~50% of 5-min (~150 s) | 75–84% in long fights | S Martusciello; S Miarka |
| m/min COM travel | 36–52 (gate 32–48) | 25–40 | 12–33 | S Thomson 36; S FFB 52; P MMA |
| Mean speed | ~0.6 m/s | ~0.4–0.6 standing | lower on ground | S Thomson |
| VHM / weight-shift / min | 47–56 | similar standing; ~0 on lock | — | S Davis 2015/18 |
| Punches or strikes / min | 20–21 elite amateur | UFC standing highly variable | ~8–15 attempt/min bout-level typical | S Davis; S Miarka strike counts |
| Defensive moves / min | 2.5–3.6 | not isolated | — | S Davis |
| High-intensity bursts / min | 4–8 short punch-phases | 2–4 stand HI sequences per block | 3–6 including ground flurries | S Del Vecchio + women punch-phase |
| Burst duration (s) | 1.5–3 (punch); combo + step 2–5 | stand HI 6–9 | ground HI 8–14 | S |
| Pause / hold / reset (s) | micropause 2–5; clinch 4; referee stop grows to 12–20 late | LI stand 15–18; referee pause 8–10 | same | S |
| Side-steps + pivots / min | 8–20 active; 4–10 pocket | 4–12 standing | ~0 ground | P |
| Side-step length (cm) | 15–25 | 15–30 | — | P |
| Feints / min (hand/shoulder/level) | 3–8 typical; 8–15 feint-heavy | 4–10 (shot fakes extra) | — | J |
| Work:rest in-round | elite 18–19:1; novice 9:1 falling to 6:1 R3 | combat:pause 6–9:1; HI:(LI+pause) 1:2–1:4 | same | S |
| Cycle "hold → burst → reset" | 6–12 s | 20–35 s stand block | ground stretches 20–40 s LI | S + J |

**Do not gate on "% frames > 0.25 m/s."** That threshold is below bounce and weight-shift. If you keep a speed flag,
raise it to ~0.6–0.8 m/s for a real travel step, and count VHM-like events separately from COM path.

## What the operator said vs the papers

| Operator | Papers |
|---|---|
| Fighters mostly stay put and exchange | Yes for COM. Pocket range ~1.2 m (FFB). |
| Side step, fake, posture change, body doesn't travel | Yes. VHM 47–56/min with only 36–52 m/min path. |
| Thinking about the next burst | Matches 1.5–3 s boxing exchanges and 6–9 s MMA stand flurries. |

The engine is over-translating, especially boxing. Cut path metres ~20–40% and spend that budget on in-place posture,
bounce, feint, and 20 cm steps.

## Sources
- Davis P, Benson PR, Pitty JD, Connorton AJ, Waldock R. The activity profile of elite male amateur boxing. Int J
  Sports Physiol Perform. 2015;10(1):53–57. (n=39, 29 OG 2012 bouts)
- Davis P, Connorton AJ, Driver S, Anderson S, Waldock R. The activity profile of elite male amateur boxing after the
  2013 rule changes. J Strength Cond Res. 2018;32(12):3450–3455. (n=60, 50 WC bouts)
- Slimani M, Chaabène H, Davis P, et al. Performance aspects and physiological responses in male amateur boxing
  competitions: a brief review. J Strength Cond Res. 2017;31(4):1132–1141.
- Davis P, Wittekind A, Beneke R. Amateur boxing: activity profile of winners and losers. Int J Sports Physiol
  Perform. 2013;8:84–91. (novice)
- Davis P, Leithäuser RM, Beneke R. The energetics of semi-contact 3×2 min amateur boxing. Int J Sports Physiol
  Perform. 2014. (77/19/4 energy split)
- Martusciello F, et al. Time–motion analysis of the 2023 Women's World Boxing Championships finals. Sports.
  2025;13(6):187. (12 finals)
- Thomson E. The development of an amateur boxing simulation protocol. PhD thesis, University of Chester, 2015. (GPS
  35.9 m/min, 0.6 m/s; n=12 sparring)
- Thomson E, Lamb K. The technical demands of amateur boxing… Int J Perf Anal Sport. 2016;16(1):203–215. (n=92
  English amateurs)
- Pidancier C, et al. Automatic quantification of displacement and ring generalship… ECSS / FFB. 2023. (155±28
  m/round, n=33)
- Del Vecchio FB, Hirata SM, Franchini E. Time-motion analysis… MMA matches at regional tournaments. Percept Mot
  Skills. 2011;112(2):639–648. (n=52)
- Miarka B, Coswig VS, Del Vecchio FB, Brito CJ, Amtmann J. Time-motion analysis of MMA rounds by weight divisions.
  Int J Perf Anal Sport. 2015;15:1189–1201. (2097 UFC bouts)
- Miarka B, Vecchio FBD, Camey S, Amtmann JA. Technical-tactical and time-motion analysis of MMA by outcomes. J
  Strength Cond Res. 2016;30(7):1975–1984. (645 rounds)
- Miarka B, et al. Long MMA fights technical-tactical analysis. Int J Perf Anal Sport. 2019;19(2):153–166.
- Ainsworth BE, et al. Compendium of Physical Activities. Med Sci Sports Exerc. 2011. (METs)
- Arseneau E, Mekary S, Léger LA. VO2 requirements of boxing training and mapping. J Strength Cond Res. 2011 / related
  gym metabolic papers.

Not found (do not invent): official-bout GPS for pros; UFC metres; feints/min; step-count pedometer studies; metabolic
cost isolated to "footwork only" vs "frozen guard."

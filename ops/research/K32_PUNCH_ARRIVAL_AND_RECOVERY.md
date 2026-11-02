# K32 — KALLI — HOW LONG A PUNCH TAKES TO ARRIVE, AND HOW LONG A HIT MAN TAKES TO COME BACK

Delivered by Kalli in its Grok Bot chat on 2026-09-13 (sent ~19:01, answered 19:07), collected with
`grokbots.py read --to Kalli`; tables converted from tab-separated text, wording unchanged. Task:
`research/TASK_K32.md`. Claude's reading is recorded at the foot.

Research only · access 2026-09-13 · no code

Claude collects as: research/K32_PUNCH_ARRIVAL_AND_RECOVERY.md

Labels: DOCUMENTED / SECONDARY / LAB / NOT FOUND

Start-code glossary (do not mix rows):

ACTION = GRFz countermovement · PROJ = forearm toward target · INITIATION = punching-hand markers descend (Stanley) · Fist-onset = first fist motion toward target · Elbow-ext = first elbow extension

## 1 — Delivery time, start → contact (ms)
Primary recommended set for animation lead-time (same clock, all six punches)


| Quantity | Sport and sample | Number (± spread) | Label | Source |
|---|---|---|---|---|
| Jab delivery | Boxing · Stanley et al. 2018 / Stanley PhD 2020 Table 3.2a · n=15 ♂ amateurs · max · suspended bag · mocap | 405 ± 150 ms · start = INITIATION (hand descent) → contact | LAB DOCUMENTED | DOI 10.1080/24748668.2018.1525651 · ChesterRep thesis |
| Rear cross | Same | 495 ± 150 ms | LAB DOCUMENTED | Same |
| Lead hook | Same | 657 ± 145 ms (+62% vs jab) | LAB DOCUMENTED | Same |
| Rear hook | Same | 586 ± 0.96 ms | LAB DOCUMENTED — SD likely typeset ±96; flag | Same |
| Lead uppercut | Same | 627 ± 103 ms | LAB DOCUMENTED | Same |
| Rear uppercut | Same | 606 ± 100 ms | LAB DOCUMENTED | Same |

Act-on: start the punch clip ~400–500 ms before land for jab/cross; ~600–660 ms for hooks/uppercuts — only if your clip’s “start” matches hand countermovement. Shorter clocks exist below; they measure a later “start.”

Other clocks (same punches, different “start” — do not pool)


| Quantity | Sport and sample | Number (± spread) | Label | Source |
|---|---|---|---|---|
| Fist-onset → contact · jab | Boxing · Menzel 2021 · n=11 experienced · bag · IMU | Throw/attack 117 ± 25 ms | LAB DOCUMENTED | DOI 10.3390/s21237882 Table 6 |
| Fist-onset → contact · cross | Same | 111 ± 41 ms | LAB DOCUMENTED | Same |
| Fist-onset → contact · rear hook | Same | ~132 ms (from phase sum; throw cell truncated in extract) | LAB DOCUMENTED (partial) | Same |
| Fist-onset → contact · uppercut | Same | 71 ± 36 ms | LAB DOCUMENTED | Same |
| ACTION→CONTACT · straight (all modes) | Boxing · Piorkowski 2011 · n=10 · dummy · 240 Hz | 357 ± 178 ms | LAB DOCUMENTED | DOI 10.1080/14763141.2010.547590 · OA PDF (Table 1 missing) |
| ACTION→CONTACT · hook (all modes) | Same | 477 ± 203 ms | LAB DOCUMENTED | Same |
| ACTION→CONTACT · single-max all types | Same | 607 ± 221 ms | LAB DOCUMENTED | Same |
| Cross PROJ→CONTACT · single-max | Same | 223 ± 99 ms | LAB DOCUMENTED | Same |
| Combo 1st→4th contact | Same | OOS 1.35±0.27 s; in-synch L 1.06±0.46; R 1.04±0.42 | LAB DOCUMENTED (held, confirmed) | Same |
| Contact speeds | Same | Single max 9.26±2.09; OOS 7.49±2.32; in-synch ~8.0 m/s | LAB DOCUMENTED | Same |
| Jab / cross / lead hook ACTION (single-max-like) | Piorkowski via Stanley 2020 | Jab 587±186; cross 553±211; lead hook 570±168 ms | LAB SECONDARY | Stanley thesis quoting Table 1 not in OA PDF |
| Rear cross / rear hook / lead hook | Same secondary line | Cross 353±183; rear hook 508±243; lead hook 446±150 | LAB SECONDARY | Same — do not average with 553 |
| Elbow-ext → impact | Boxing · Atha 1985 · n=1 (Bruno) · ballistic pendulum | 100 ms (trunk advance before start 201 ms) | LAB DOCUMENTED | DOI 10.1136/bmj.291.6511.1756 |
| Fist-onset → contact · rear straight | Boxing · Cheraghi 2014 · n=8 elite Iranian · pad | 310 ± 60 ms (range 212–404) | LAB DOCUMENTED | DOI 10.18869/acadpub.aassjournal.2.2.39 |
| Combo cross / reverse-hook cycle | Whiting 1988 via Piorkowski | Cross 132±21; reverse hook 143±24 ms | LAB SECONDARY | DOI 10.1177/036354658801600207 — start≈elbow-ext |
| Jab / cross strike duration | Applied Sciences 2024 (Gierczuk group) · n=13 | Jab 176±39; cross 173±29 ms | LAB SECONDARY | DOI 10.3390/app14072830 — PDF fetch failed; start code unverified |
| Lead / rear straight “completion” | BMC 2026 snippet · n=17 orthodox | Lead 442±56; rear 667±70 ms | LAB SECONDARY | PDF not opened; start not verified |
| Kimm & Thiel 2015 delivery table | Air punches · wrist IMU · n=16 | Velocities only (M jab 8.1±1.4 m/s etc.) | Delivery ms NOT FOUND | DOI 10.1016/j.proeng.2015.07.232 |
| Lenetsky 2020 / Dinu 2020 delivery ms | — | — | NOT FOUND | Phases defined; no ms table in abstracts |

Retraction after throwing (not delivery; held, confirmed): Menzel exp — jab Table 6 262±42; cross 169±41; hook 168±97; UC 171±33 ms (LAB). Note body-text vs Table 6 jab retract contradiction — prefer Table 6 for retract.

## 2 — Return to guard after being hit

| Quantity | Sport and sample | Number (± spread) | Label | Source |
|---|---|---|---|---|
| Contact → head/hands back in guard | Sparring or bout · boxing / striking | — | NOT FOUND | Extra pass: Stojsih, Walilko/Viano, Davis TMA, BoxMind, cervical perturbation — none report this ms |
| Contact → next throw (struck fighter) | Same | — | NOT FOUND | Same |
| Contact → peak head accel | Hybrid III · Walilko 2005 | ~3–4 ms (pulse ~11–13 ms) | LAB DOCUMENTED — peak of impact, not recovery | DOI 10.1136/bjsm.2004.014126 |
| Self-retract after own punch | Menzel bag | See §1 retract column | LAB — offense, not being hit | DOI 10.3390/s21237882 |

Do not use coaching 150–500 ms blogs. Do not use Menzel retract as “hit man recovery.”

## 3 — Steps per second in stance + step length

| Quantity | Sport and sample | Number (± spread) | Label | Source |
|---|---|---|---|---|
| Locomotive events/min by direction | Boxing · Thomson 2015 · outdoor open sparring · n=12 amateurs · video 5-way template | Neutral 26±2; F 17±6; B 13±4; L 11±4; R 3±1 N·min⁻¹ · sum ≈70/min ≈ 1.17 s⁻¹ | DOCUMENTED — events, not foot-steps | Thesis §4 below |
| Directed-event shares | Same | Of directed (44/min): F 39%; B 30%; L 25%; R 7% | DOCUMENTED | Same |
| VHM (vertical hip moves)/min | Boxing · Davis IJSPP 2015 · Olympic SF/F · n=39 | ~47/min | DOCUMENTED — bounce/ambulation proxy, not step count | DOI 10.1123/ijspp.2013-0474 |
| VHM /min | Boxing · Davis 2018 | ~56/min | SECONDARY/DOCUMENTED | DOI 10.1136/bjsports-2017-097667 |
| Measured stance step length cm | Competitive boxing | — | NOT FOUND | — |
| Prescribed BOXFIT step lengths | Thomson protocol | F/B 85 cm; L/R 100 cm | LAB/protocol — not measured bout steps | Thesis |
| Walk gait cadence/length | Boxers · Baltic JHPA | ~125 steps/min; ~74 cm | Out of scope (walking, not fighting stance) | Excluded |

## 4 — Thomson thesis + Table 6.2

| Quantity | Sport and sample | Number (± spread) | Label | Source |
|---|---|---|---|---|
| Full citation | — | Thomson, Edward. (2015). The development of an amateur boxing simulation protocol. PhD, University of Chester. Handle http://hdl.handle.net/10034/613507 · PDF https://chesterrep.openrepository.com/bitstreams/89665f6f-19cb-4c11-a5df-68c002d99e9f/download · CC BY-NC-ND 4.0 · no journal DOI | DOCUMENTED | PDF fetched |
| Table 6.2 movement frequencies | Outdoor open sparring · n=12 · 2 cameras | Neutral 26±2; Forwards 17±6; Backwards 13±4; Left 11±4; Right 3±1 (N·min⁻¹) | DOCUMENTED | Same |
| Mean speed (GPS-corrected for BOXFIT) | Same programme | 0.6 m·s⁻¹; 35.9 m·min⁻¹ | DOCUMENTED (held, confirmed; thesis notes GPS raw higher then corrected) | Same |

## GAPS

| Gap | What could answer it |
|---|---|
| Piorkowski published Table 1 per-type cells | Paywalled Sports Biomechanics PDF (OA manuscript tables missing) |
| Stanley rear-hook SD 0.96 vs ~96 | Author correction / raw data |
| Kimm start→contact means | Full Procedia tables if they exist |
| Whiting 1988 full delivery tables | Open AJSM PDF |
| Post-hit return to guard / next action (human) | HSV or mocap of struck fighter in sparring/bout — still NOT FOUND |
| True stance foot-step rate + measured step length | Foot IMU / pressure in-ring during non-attack locomotion |
| Dinu / Lenetsky delivery ms | Full papers if phases are timed |
| 2024–2026 short delivery times (~170–440 ms) | Open PDFs and verify start coding before use |

## Act-on for the fight room
Lead punch animation by Stanley INITIATION clocks (~405 jab / ~495 cross / ~586–657 hooks / ~606–627 uppercuts) or state that your clip uses fist-onset and switch to Menzel/Cheraghi clocks.

Head-snap must not precede fist arrival by more than contact→peak (~3–4 ms LAB) after land.

Post-hit recovery duration for tests = NOT FOUND — refuse a realism claim or use only self-retract LAB with that label.

Free movement tests can use Thomson Table 6.2 direction event shares; not metre direction %.

End K32.


## Claude's reading (2026-09-13)

- **What S4a (d) part 3 acts on:** the room starts a thrower's clip early by THE CLIP'S OWN contact frame
  (farthest reach, derived per take on each body), so the fist arrives on the engine's impact tick and the
  receiver's reaction starts there - Kalli's second act-on line. The bought clips' contact frames (U85:
  jab 0.23-0.27 s, cross 0.30 s, hook 0.27-0.37 s, uppercut 0.43-0.50 s from guard) lie between the
  fist-onset clocks (Menzel 71-132 ms, Cheraghi 310 +- 60 ms) and Stanley's hand-descent INITIATION clock
  (jab 405 +- 150 ms ... hooks 586-657 ms), so a clip start is a later 'start' than Stanley's and an earlier
  one than Menzel's. A realism rule on it names that bracket rather than one clock.
- **Post-hit return to guard stays NOT FOUND after a second, differently worded pass.** No realism rule may
  claim a reaction duration; R1-style rhythm and the clips' own performance are the only grounds.
- Not opened by Claude: Stanley 2018/2020, Menzel 2021, Piorkowski 2011, Cheraghi 2014, Thomson 2015.
  Stanley's rear-hook SD '0.96' is flagged by Kalli as a likely typeset error for 96.

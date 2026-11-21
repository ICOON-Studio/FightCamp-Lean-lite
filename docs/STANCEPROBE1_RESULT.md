# STANCEPROBE1 - the stance pad on a greybox: FAIL (S536)

Brief: `ops/research/TASK_STANCEPROBE1.md`. Map: `ops/research/DESIGN_STANCE1.md`. Probe: `tools/stanceprobe1.gd` (measurement only, nothing under
scripts/ edited; `tools/stance_probe.gd` is an older 3D ruler, so the probe took the next free name). Two runs on 2026-11-21, both through
`godot_slot.py`: round 1 (52,830 bouts, 2,029 s) and round 2, the one resize the brief allows (46,830 bouts, 1,226 s). This page is the
summary and then the two generated pages as the probe wrote them.

## VERDICT: FAIL twice on the same bar. The pad works as a rule, but its choices are too close together to tell apart.

`RESULT: tools/stanceprobe1.gd -> FAIL (effects NOT all move; top stance best in 6 of 10 cells; 1 of 10 cells clear; natural clearly beaten for 2 of 5 boxers and best in 6 of 50 units; lean moves a round)` (round 1, model 1)
`RESULT: tools/stanceprobe1.gd -> FAIL (effects all move; top stance best in 4 of 10 cells; 1 of 10 cells clear; natural clearly beaten for 2 of 5 boxers and best in 10 of 50 units; lean moves a round)` (round 2, model 2)

| Bar (all must pass) | Round 1 | Round 2 |
| :--- | :--- | :--- |
| Every effect moves the result (2 bouts in 100 or more change) | **FAIL**: power 1.8, slips 1.0, stays up 0.5, body 0.8, reach 0.7, rear power 0.9 (steps 3.2, drain 2.1, drift 3.5, hooks 6.2 pass) | PASS: base 3.4, slips 2.2, steps 4.0, drain 2.9, drift 4.8, hooks 3.7, long 4.2, not owned 6.1 |
| No stance best in more than 6 of 10 cells | PASS at 6, but Squared was best in 10 of 10: the angle was no choice | PASS: 4 of 10, five different stances win a cell |
| 4 or more cells clear of the noise | **FAIL**: 1 of 10 | **FAIL**: 1 of 10 (Volume puncher / pro: Wide / Squared) |
| The natural stance is not always best | PASS: clearly beaten for 2 of 5 boxers | PASS: clearly beaten for 2 of 5 (Danny +3.9 +- 1.1, Josh +4.3 +- 1.2 wins in 100) |
| The corner's lean moves a round | PASS: Back +1.9 +- 0.2, Front -1.2 +- 0.2 rounds in 100 | PASS, the same numbers |

## What it means, in plain words
- **The rule is sound.** A stance written as a small two-sided change of the boxer's own numbers plays through the game's fight night
  with no new fight rule. The walk with the model off is the game's own bout in 40 of 40; no attribute copy was rebuilt in either full run.
- **Sized as a fine tuner it cannot be felt against one opponent.** In round 2 the best stance of a cell is 0 to 4.5 wins in 100 above the
  second and 3 to 9.7 above the worst of the nine, and one win rate at 200 bouts is +- 3.5. In 9 of 10 cells two to eight other stances sit inside the noise of the best.
  A player choosing "Wide for this fight" would be choosing among stances the game itself cannot tell apart.
- **It fits the BOXER more than the opponent.** Pooled over all ten cells (400 bouts) two boxers have a clearly better stance than
  their natural one. So the real decision found is "find this boxer's stance once", which is solved after one look, not a choice per fight.
- **Round 1's lesson: three attribute points a step is nothing.** Six of ten chips moved under 2 bouts in 100, and the one heavy number
  (inside work, 3.05 of weight in the duel) made Squared win everywhere. Round 2 sized each side of a trade to about one exchange
  point from `Duels.TOOLS`' own weights and folded three chips that could not stand alone (stays up, body hidden, rear power).
- **The lean is one-sided.** On the back foot is best against all five opponent styles and Sit down against none. It moves rounds,
  but as modelled it is not a choice either. (The bar passed; the design does not.)
- **The tape read is the biggest number on the page and it is an ESTIMATE.** A rival 1.5 points better prepared costs 7.0 +- 0.9 wins
  in 100, more than any stance gives. In 47 of 50 units a second owned stance then beats the read natural one. If built at that size,
  "own two stances and alternate" is the whole mechanic.
- **Not owning a cell costs 2.2 wins in 100** (47.5 against 49.7): about what a good stance gives, so a new stance pays only once owned.

## Which effect broke
Round 1: the SIZES (six chips under the bar) and the angle's balance. Round 2: nothing breaks as an effect; the bar that fails is the
distance between cells. To clear it at 200 bouts a step would have to be worth about twice round 2's size, which on the attribute
route means 8 to 9 points of power or head movement for moving the feet: not believable, and it would double the knockdowns.

## What was not measured (said plainly)
1. The plans are the weight probe's four lines; probe 8 showed two of them never fire for these boxers. Steps the boxer cannot fire cannot show the stance's cost on steps.
2. Frames are level (the opponent is given the boxer's own height and reach), so reach differs only by the stance.
3. Small pools: one woman Slugger, one man Pressure fighter, two women Out-boxers. No man met a Boxer-puncher (Data has none).
4. "Today's game" is on the first 20 seeds and the stances on 40: read the two columns side by side only loosely (Slugger / amateur: 66.0 against 55.5).
5. The natural-stance rule, every size but the reach, the drift, the lean and the read are ESTIMATES. No study sizes a punch or a step by foot width.
6. The link to guard v7 (the stance grading the guard lines, DESIGN_STANCE1 section 4) was not in the probe: v7 is not built.
7. The two axes add up with no cross term (Wide + Bladed is just the sum). The mockup's "rare" corners were not modelled.

## Back to Claude (the brief: a second FAIL comes back; no critic briefs were written)
Three ways on, for the "cut it or keep it" call:
- **Keep it small, as who he is**: the natural stance shown on the fighter page and the tape, moved one step with pad weeks - a trait, not a pre-fight choice. Honest to the measurement (the stance fits the boxer).
- **Give it a per-fight meaning through the guard lines** (section 4 of the map): the feet grade Hands High / Hands Loose. That is also the price probe 8 could not find for a guard line. Needs its own probe once v7 exists.
- **Cut the pad to one axis** (width only, three cells): fewer cells sit closer to "clear", and width is the half the 3D fight can show first.
The lean needs a new trade before any of them (Back wins everywhere), and the read needs a sourced or measured size.

## GENERATED PAGE: STANCEPROBE1 - the stance pad on a greybox (S536)

Run: python ops/Tools/godot_slot.py run --who stanceprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/stanceprobe1.gd -- seeds=40 abl=20 own=20 cal=5 model=2

What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex) and every bout (the game's fight night, BoutNight).
What is scratch: the stance model below, written onto a local copy of the boxer's attributes at every bell. Every stance of a seed fights the same night (same dice).
A stance is measured against the boxer's NATURAL cell: in his natural cell nothing changes; a step away adds the model's difference.

Model 2 (set before the run, not fitted): { "power_w": 5.0, "slip_w": 5.0, "chin_w": 5.0, "feet_w": 3.0, "drain_w": 1.5, "drift_at": 65.0, "drift_span": 30.0, "drift_body": 0.05, "drift_body_max": 0.5, "hook_g": 2.0, "inside_g": 1.0, "body_g": 8.0, "reach_g": 5.0, "jab_g": 4.0, "power_g": 2.0, "power_g_sym": true, "unowned_feet": 2.0, "unowned_energy": 2.0, "lean": 3.0, "lean_fwd": 10.0, "lean_back_slip": 2.0, "read_rating": 1.5 }

Self-check: the probe's round-by-round walk with the stance model off gives the same bout as BoutNight.play_out in 40 of 40 bouts (outcome, rounds, punches landed).

Field, am: today's game wins 46 / 66 / 81 in 100 at opponent offsets -3 / -7 / -11 (seeds 900+, not the test's) -> offset -3.4.
Field, pro: today's game wins 34 / 53 / 74 in 100 at opponent offsets -3 / -7 / -11 (seeds 900+, not the test's) -> offset -6.5.

### 1. Who they are

| Boxer | Style | Height | Reach | Power | Speed | Natural stance | Why |
| :--- | :--- | ---: | ---: | ---: | ---: | :--- | :--- |
| Kira Mensah | Out-boxer | 166 cm | 168 cm | 54 | 67 | Narrow / Bladed | power - speed -13, Out-boxer, reach - height +2 cm |
| Samira Khan | Slugger | 171 cm | 169 cm | 66 | 57 | Wide / Squared | power - speed +9, Slugger, reach - height -2 cm |
| Tess Reilly | Pressure fighter | 184 cm | 186 cm | 62 | 55 | Shoulder / Squared | power - speed +7, Pressure fighter, reach - height +2 cm |
| Danny Osei | Boxer-puncher | 176 cm | 177 cm | 59 | 62 | Shoulder / Half | power - speed -3, Boxer-puncher, reach - height +1 cm |
| Josh Harper | Pressure fighter | 183 cm | 182 cm | 63 | 56 | Shoulder / Squared | power - speed +7, Pressure fighter, reach - height -1 cm |

Natural width: (Power - Speed) / 4 at +2 or more = Wide, -2 or less = Narrow. Natural angle: the style (Out-boxer bladed; Pressure fighter, Slugger, Volume puncher squared) plus one step bladed for a reach 3 cm over the height, one squared for 3 cm under. (ESTIMATE rule: the game has no stance width today.)

Opponents by style and sex (rating under 68, re-rated to the boxer's own strength -3.4 amateur / -6.5 pro so today's game wins about half): Out-boxer 2 women, 3 men; Pressure fighter 9 women, 1 men; Counter-puncher 6 women, 4 men; Volume puncher 6 women, 2 men; Slugger 1 women, 2 men.

### 2. Every cell: wins in 100 bouts by stance (a draw is half; +- one standard error; 200 bouts a stance = 5 boxers x 40 seeds)

#### Out-boxer / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 58.5 +- 3.5 | 58.5 +- 3.5 | 60.0 +- 3.5 |
| Shoulder | 56.0 +- 3.5 | 56.0 +- 3.5 | 59.5 +- 3.5 |
| Wide | 55.5 +- 3.5 | 56.5 +- 3.5 | 56.0 +- 3.5 |

Best: **Narrow / Bladed** (60.0); inside two standard errors of it: Narrow / Squared, Narrow / Half, Shoulder / Bladed, Wide / Squared, Wide / Half. Stopped inside: won 3, lost 1 in 100.

#### Out-boxer / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 54.5 +- 3.2 | 52.5 +- 3.2 | 50.2 +- 3.2 |
| Shoulder | 55.5 +- 3.2 | 53.5 +- 3.2 | 50.5 +- 3.2 |
| Wide | 52.0 +- 3.2 | 51.7 +- 3.2 | 48.8 +- 3.2 |

Best: **Shoulder / Squared** (55.5); inside two standard errors of it: Narrow / Squared, Narrow / Half, Shoulder / Half, Wide / Squared. Stopped inside: won 24, lost 2 in 100.

#### Pressure fighter / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 37.0 +- 3.4 | 39.0 +- 3.5 | 39.0 +- 3.5 |
| Shoulder | 35.0 +- 3.4 | 37.5 +- 3.4 | 38.5 +- 3.4 |
| Wide | 34.0 +- 3.4 | 36.5 +- 3.4 | 35.5 +- 3.4 |

Best: **Narrow / Half** (39.0); inside two standard errors of it: Narrow / Bladed, Shoulder / Half, Shoulder / Bladed, Wide / Half. Stopped inside: won 5, lost 6 in 100.

#### Pressure fighter / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 47.0 +- 3.4 | 46.8 +- 3.5 | 46.0 +- 3.4 |
| Shoulder | 45.8 +- 3.3 | 47.5 +- 3.4 | 49.0 +- 3.4 |
| Wide | 47.0 +- 3.4 | 45.5 +- 3.4 | 46.5 +- 3.3 |

Best: **Shoulder / Bladed** (49.0); inside two standard errors of it: Narrow / Squared, Narrow / Half, Shoulder / Squared, Shoulder / Half, Wide / Squared, Wide / Half, Wide / Bladed. Stopped inside: won 21, lost 8 in 100.

#### Counter-puncher / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 43.0 +- 3.5 | 42.0 +- 3.5 | 40.5 +- 3.5 |
| Shoulder | 44.5 +- 3.5 | 44.5 +- 3.5 | 44.0 +- 3.5 |
| Wide | 49.0 +- 3.5 | 43.0 +- 3.5 | 44.5 +- 3.5 |

Best: **Wide / Squared** (49.0); inside two standard errors of it: Shoulder / Half, Wide / Bladed. Stopped inside: won 8, lost 2 in 100.

#### Counter-puncher / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 50.0 +- 3.3 | 51.0 +- 3.3 | 50.7 +- 3.3 |
| Shoulder | 51.7 +- 3.4 | 50.2 +- 3.3 | 49.5 +- 3.3 |
| Wide | 53.3 +- 3.4 | 50.2 +- 3.3 | 49.8 +- 3.3 |

Best: **Wide / Squared** (53.3); inside two standard errors of it: Narrow / Squared, Narrow / Half, Narrow / Bladed, Shoulder / Squared, Shoulder / Half, Shoulder / Bladed, Wide / Half, Wide / Bladed. Stopped inside: won 31, lost 4 in 100.

#### Volume puncher / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 45.5 +- 3.5 | 43.5 +- 3.5 | 43.5 +- 3.5 |
| Shoulder | 48.0 +- 3.5 | 45.5 +- 3.5 | 44.0 +- 3.5 |
| Wide | 48.0 +- 3.5 | 46.0 +- 3.5 | 45.5 +- 3.5 |

Best: **Shoulder / Squared** (48.0); inside two standard errors of it: Narrow / Squared, Shoulder / Half, Shoulder / Bladed, Wide / Squared, Wide / Half, Wide / Bladed. Stopped inside: won 8, lost 1 in 100.

#### Volume puncher / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 49.8 +- 3.4 | 51.0 +- 3.3 | 47.8 +- 3.3 |
| Shoulder | 52.0 +- 3.4 | 50.0 +- 3.3 | 48.3 +- 3.3 |
| Wide | 57.5 +- 3.3 | 53.8 +- 3.4 | 52.5 +- 3.4 |

Best: **Wide / Squared** (57.5). Stopped inside: won 40, lost 3 in 100.

#### Slugger / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 54.0 +- 3.5 | 53.5 +- 3.5 | 55.5 +- 3.5 |
| Shoulder | 54.0 +- 3.5 | 52.5 +- 3.5 | 53.0 +- 3.5 |
| Wide | 53.5 +- 3.5 | 54.0 +- 3.5 | 54.0 +- 3.5 |

Best: **Narrow / Bladed** (55.5); inside two standard errors of it: Narrow / Squared, Narrow / Half, Shoulder / Squared, Shoulder / Half, Shoulder / Bladed, Wide / Squared, Wide / Half, Wide / Bladed. Stopped inside: won 1, lost 7 in 100.

#### Slugger / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 55.3 +- 3.3 | 54.5 +- 3.3 | 54.3 +- 3.3 |
| Shoulder | 53.3 +- 3.4 | 55.3 +- 3.3 | 53.5 +- 3.4 |
| Wide | 58.0 +- 3.3 | 56.3 +- 3.3 | 56.0 +- 3.3 |

Best: **Wide / Squared** (58.0); inside two standard errors of it: Narrow / Squared, Narrow / Half, Narrow / Bladed, Shoulder / Half, Shoulder / Bladed, Wide / Half, Wide / Bladed. Stopped inside: won 22, lost 10 in 100.

### 3. The summary

| Cell | Best | Wins | Inside the noise of it | Each boxer's natural | Today's game (20 seeds) |
| :--- | :--- | ---: | :--- | ---: | ---: |
| Out-boxer / am | Narrow / Bladed | 60.0 | Narrow / Squared, Narrow / Half, Shoulder / Bladed, Wide / Squared, Wide / Half | 58.5 | 61.0 |
| Out-boxer / pro | Shoulder / Squared | 55.5 | Narrow / Squared, Narrow / Half, Shoulder / Half, Wide / Squared | 56.5 | 54.0 |
| Pressure fighter / am | Narrow / Half | 39.0 | Narrow / Bladed, Shoulder / Half, Shoulder / Bladed, Wide / Half | 37.0 | 36.0 |
| Pressure fighter / pro | Shoulder / Bladed | 49.0 | Narrow / Squared, Narrow / Half, Shoulder / Squared, Shoulder / Half, Wide / Squared, Wide / Half, Wide / Bladed | 46.3 | 52.5 |
| Counter-puncher / am | Wide / Squared | 49.0 | Shoulder / Half, Wide / Bladed | 44.5 | 48.0 |
| Counter-puncher / pro | Wide / Squared | 53.3 | Narrow / Squared, Narrow / Half, Narrow / Bladed, Shoulder / Squared, Shoulder / Half, Shoulder / Bladed, Wide / Half, Wide / Bladed | 53.5 | 52.0 |
| Volume puncher / am | Shoulder / Squared | 48.0 | Narrow / Squared, Shoulder / Half, Shoulder / Bladed, Wide / Squared, Wide / Half, Wide / Bladed | 46.5 | 49.0 |
| Volume puncher / pro | Wide / Squared | 57.5 | - | 53.0 | 56.0 |
| Slugger / am | Narrow / Bladed | 55.5 | Narrow / Squared, Narrow / Half, Shoulder / Squared, Shoulder / Half, Shoulder / Bladed, Wide / Squared, Wide / Half, Wide / Bladed | 55.5 | 66.0 |
| Slugger / pro | Wide / Squared | 58.0 | Narrow / Squared, Narrow / Half, Narrow / Bladed, Shoulder / Half, Shoulder / Bladed, Wide / Half, Wide / Bladed | 56.0 | 57.0 |

Best counts: Narrow / Bladed 2, Shoulder / Squared 2, Narrow / Half 1, Shoulder / Bladed 1, Wide / Squared 4. The most any one stance wins: 4 of 10 cells (bar: 6 or fewer).
Cells with a clear best (no other stance inside two standard errors, seed by seed): 1 of 10 (bar: 4 or more).

#### Is the natural stance always best?

| Boxer | Natural | Wins | Best owned stance (10 cells pooled, 400 bouts) | Wins | Best against natural | Clear |
| :--- | :--- | ---: | :--- | ---: | ---: | :--- |
| Kira | Narrow / Bladed | 58.8 | Narrow / Bladed | 58.8 | +0.0 +- 0.0 | no |
| Samira | Wide / Squared | 45.8 | Wide / Squared | 45.8 | +0.0 +- 0.0 | no |
| Tess | Shoulder / Squared | 44.5 | Wide / Squared | 47.1 | +2.6 +- 1.3 | no |
| Danny | Shoulder / Half | 61.5 | Narrow / Bladed | 65.4 | +3.9 +- 1.1 | yes |
| Josh | Shoulder / Squared | 43.1 | Wide / Squared | 47.4 | +4.3 +- 1.2 | yes |

Boxers whose natural stance is clearly beaten by another owned stance: 2 of 5 (bar: 2 or more). Boxer x cell units (40 bouts each, a weak read) where the natural stance has the most wins: 10 of 50 (bar: under 6 in 10).

### 4. Does each effect move the result? (effect off on its two test stances, 20 seeds, the same dice as with it on)

| Effect off | Test stances | Bouts whose result changed, in 100 | Mean change in wins in 100 (a cell) | Moves it (2 in 100 or more) |
| :--- | :--- | ---: | ---: | :--- |
| base | Wide / Half, Narrow / Half | 3.4 | 1.5 | yes |
| slips | Wide / Half, Narrow / Half | 2.2 | 1.1 | yes |
| steps | Wide / Half, Narrow / Half | 4.0 | 1.8 | yes |
| drain | Wide / Half, Narrow / Half | 2.9 | 1.1 | yes |
| drift | Wide / Half, Shoulder / Half | 4.8 | 1.4 | yes |
| hooks | Shoulder / Squared, Shoulder / Bladed | 3.7 | 2.2 | yes |
| long | Shoulder / Squared, Shoulder / Bladed | 4.2 | 2.1 | yes |
| not owned yet | the 8 cells that are not his natural | 6.1 | 2.2 | yes |

A stance he does not own yet wins 47.5 in 100 against 49.7 once owned (20 seeds). Boxer x cell units where some not-yet-owned stance still out-wins the natural one: 18 of 50 (a weak read, 20 bouts each).

### 5. The corner's lean (Front / Back from round 2 on, the natural stance, 40 seeds; rounds 2 and later)

| Opponent | Centred: rounds won in 100 | Front | Back | Bout wins: Centred | Front | Back | Best lean |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | :--- |
| Out-boxer | 49.1 | 47.4 | 50.6 | 57.5 | 55.6 | 57.4 | back |
| Pressure fighter | 41.3 | 39.9 | 43.5 | 41.6 | 41.6 | 43.9 | back |
| Counter-puncher | 45.9 | 43.8 | 48.5 | 49.0 | 47.8 | 50.5 | back |
| Volume puncher | 43.8 | 43.1 | 46.8 | 49.8 | 50.5 | 53.6 | back |
| Slugger | 51.5 | 50.8 | 52.5 | 55.8 | 55.8 | 56.3 | back |

All opponents pooled, rounds 2 and later won in 100, against Centred: Front -1.2 +- 0.2, Back +1.9 +- 0.2. Best lean by opponent: { "back": 5 }.
The lean moves a round's result (one lean more than two standard errors from Centred): yes.

### 6. A stance the rival has read on tape (20 seeds)

The natural stance against a rival who has read it: -7.0 +- 0.9 wins in 100. Boxer x cell units where a second owned stance (not read) then out-wins the read natural one: 47 of 50 (a weak read, 20 bouts each). Moves it: yes.

46830 bouts played in 1226 s. Attribute copies the game would have rebuilt (must be 0): 0.

RESULT: tools/stanceprobe1.gd -> FAIL (effects all move; top stance best in 4 of 10 cells; 1 of 10 cells clear; natural clearly beaten for 2 of 5 boxers and best in 10 of 50 units; lean moves a round)

## GENERATED PAGE: STANCEPROBE1 - the stance pad on a greybox (S536)

Run: python ops/Tools/godot_slot.py run --who stanceprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/stanceprobe1.gd -- seeds=40 abl=20 own=20 cal=5

What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex) and every bout (the game's fight night, BoutNight).
What is scratch: the stance model below, written onto a local copy of the boxer's attributes at every bell. Every stance of a seed fights the same night (same dice).
A stance is measured against the boxer's NATURAL cell: in his natural cell nothing changes; a step away adds the model's difference.

Model (set before the run, not fitted): { "power_w": 3.0, "slip_w": 2.0, "chin_w": 3.0, "feet_w": 3.0, "drain_w": 1.5, "drift_at": 65.0, "drift_span": 30.0, "drift_body": 0.05, "drift_body_max": 0.5, "hook_g": 3.0, "inside_g": 3.0, "body_g": 4.0, "reach_g": 5.0, "power_g": 2.0, "unowned_feet": 2.0, "unowned_energy": 2.0, "lean": 3.0, "lean_fwd": 10.0, "lean_back_slip": 2.0, "read_rating": 1.5 }

Self-check: the probe's round-by-round walk with the stance model off gives the same bout as BoutNight.play_out in 40 of 40 bouts (outcome, rounds, punches landed).

Field, am: today's game wins 46 / 66 / 81 in 100 at opponent offsets -3 / -7 / -11 (seeds 900+, not the test's) -> offset -3.4.
Field, pro: today's game wins 34 / 53 / 74 in 100 at opponent offsets -3 / -7 / -11 (seeds 900+, not the test's) -> offset -6.5.

### 1. Who they are

| Boxer | Style | Height | Reach | Power | Speed | Natural stance | Why |
| :--- | :--- | ---: | ---: | ---: | ---: | :--- | :--- |
| Kira Mensah | Out-boxer | 166 cm | 168 cm | 54 | 67 | Narrow / Bladed | power - speed -13, Out-boxer, reach - height +2 cm |
| Samira Khan | Slugger | 171 cm | 169 cm | 66 | 57 | Wide / Squared | power - speed +9, Slugger, reach - height -2 cm |
| Tess Reilly | Pressure fighter | 184 cm | 186 cm | 62 | 55 | Shoulder / Squared | power - speed +7, Pressure fighter, reach - height +2 cm |
| Danny Osei | Boxer-puncher | 176 cm | 177 cm | 59 | 62 | Shoulder / Half | power - speed -3, Boxer-puncher, reach - height +1 cm |
| Josh Harper | Pressure fighter | 183 cm | 182 cm | 63 | 56 | Shoulder / Squared | power - speed +7, Pressure fighter, reach - height -1 cm |

Natural width: (Power - Speed) / 4 at +2 or more = Wide, -2 or less = Narrow. Natural angle: the style (Out-boxer bladed; Pressure fighter, Slugger, Volume puncher squared) plus one step bladed for a reach 3 cm over the height, one squared for 3 cm under. (ESTIMATE rule: the game has no stance width today.)

Opponents by style and sex (rating under 68, re-rated to the boxer's own strength -3.4 amateur / -6.5 pro so today's game wins about half): Out-boxer 2 women, 3 men; Pressure fighter 9 women, 1 men; Counter-puncher 6 women, 4 men; Volume puncher 6 women, 2 men; Slugger 1 women, 2 men.

### 2. Every cell: wins in 100 bouts by stance (a draw is half; +- one standard error; 200 bouts a stance = 5 boxers x 40 seeds)

#### Out-boxer / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 61.5 +- 3.4 | 58.5 +- 3.5 | 56.5 +- 3.5 |
| Shoulder | 58.0 +- 3.5 | 56.5 +- 3.5 | 54.5 +- 3.5 |
| Wide | 56.0 +- 3.5 | 55.0 +- 3.5 | 51.0 +- 3.5 |

Best: **Narrow / Squared** (61.5). Stopped inside: won 5, lost 2 in 100.

#### Out-boxer / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 57.8 +- 3.2 | 51.2 +- 3.3 | 48.8 +- 3.3 |
| Shoulder | 58.0 +- 3.2 | 52.5 +- 3.2 | 49.5 +- 3.2 |
| Wide | 54.5 +- 3.2 | 49.8 +- 3.2 | 46.3 +- 3.2 |

Best: **Shoulder / Squared** (58.0); inside two standard errors of it: Narrow / Squared, Wide / Squared. Stopped inside: won 24, lost 2 in 100.

#### Pressure fighter / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 39.0 +- 3.5 | 37.5 +- 3.4 | 34.0 +- 3.4 |
| Shoulder | 39.0 +- 3.5 | 36.0 +- 3.4 | 32.5 +- 3.3 |
| Wide | 36.5 +- 3.4 | 34.5 +- 3.4 | 32.0 +- 3.3 |

Best: **Narrow / Squared** (39.0); inside two standard errors of it: Narrow / Half, Shoulder / Squared, Shoulder / Half, Wide / Squared. Stopped inside: won 4, lost 4 in 100.

#### Pressure fighter / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 48.8 +- 3.4 | 47.3 +- 3.4 | 46.3 +- 3.4 |
| Shoulder | 47.5 +- 3.4 | 47.3 +- 3.4 | 45.3 +- 3.4 |
| Wide | 46.3 +- 3.4 | 46.3 +- 3.3 | 44.0 +- 3.4 |

Best: **Narrow / Squared** (48.8); inside two standard errors of it: Narrow / Half, Narrow / Bladed, Shoulder / Squared, Shoulder / Half, Shoulder / Bladed, Wide / Squared, Wide / Half. Stopped inside: won 21, lost 7 in 100.

#### Counter-puncher / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 45.5 +- 3.5 | 40.5 +- 3.5 | 37.0 +- 3.4 |
| Shoulder | 45.0 +- 3.5 | 42.0 +- 3.5 | 38.0 +- 3.4 |
| Wide | 46.5 +- 3.5 | 41.5 +- 3.5 | 39.5 +- 3.5 |

Best: **Wide / Squared** (46.5); inside two standard errors of it: Narrow / Squared, Shoulder / Squared. Stopped inside: won 6, lost 2 in 100.

#### Counter-puncher / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 55.5 +- 3.3 | 51.2 +- 3.3 | 46.0 +- 3.2 |
| Shoulder | 54.8 +- 3.3 | 52.5 +- 3.3 | 45.3 +- 3.2 |
| Wide | 54.0 +- 3.3 | 50.5 +- 3.3 | 45.5 +- 3.3 |

Best: **Narrow / Squared** (55.5); inside two standard errors of it: Shoulder / Squared, Shoulder / Half, Wide / Squared. Stopped inside: won 28, lost 4 in 100.

#### Volume puncher / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 49.0 +- 3.5 | 43.5 +- 3.5 | 40.5 +- 3.5 |
| Shoulder | 48.0 +- 3.5 | 43.0 +- 3.5 | 40.0 +- 3.5 |
| Wide | 47.0 +- 3.5 | 43.0 +- 3.5 | 40.0 +- 3.5 |

Best: **Narrow / Squared** (49.0); inside two standard errors of it: Shoulder / Squared, Wide / Squared. Stopped inside: won 7, lost 1 in 100.

#### Volume puncher / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 54.0 +- 3.4 | 50.7 +- 3.4 | 48.3 +- 3.3 |
| Shoulder | 56.3 +- 3.3 | 51.7 +- 3.4 | 48.3 +- 3.3 |
| Wide | 56.8 +- 3.3 | 55.0 +- 3.3 | 49.8 +- 3.4 |

Best: **Wide / Squared** (56.8); inside two standard errors of it: Narrow / Squared, Shoulder / Squared, Wide / Half. Stopped inside: won 39, lost 4 in 100.

#### Slugger / am

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 56.0 +- 3.5 | 53.0 +- 3.5 | 50.0 +- 3.5 |
| Shoulder | 54.5 +- 3.5 | 51.5 +- 3.5 | 48.5 +- 3.5 |
| Wide | 53.5 +- 3.5 | 50.5 +- 3.5 | 47.0 +- 3.5 |

Best: **Narrow / Squared** (56.0); inside two standard errors of it: Shoulder / Squared, Wide / Squared. Stopped inside: won 2, lost 5 in 100.

#### Slugger / pro

| | Squared | Half | Bladed |
| :--- | ---: | ---: | ---: |
| Narrow | 57.0 +- 3.3 | 53.8 +- 3.3 | 49.8 +- 3.4 |
| Shoulder | 57.0 +- 3.3 | 54.3 +- 3.3 | 50.5 +- 3.4 |
| Wide | 57.8 +- 3.3 | 56.3 +- 3.3 | 51.0 +- 3.4 |

Best: **Wide / Squared** (57.8); inside two standard errors of it: Narrow / Squared, Narrow / Half, Shoulder / Squared, Shoulder / Half, Wide / Half. Stopped inside: won 20, lost 8 in 100.

### 3. The summary

| Cell | Best | Wins | Inside the noise of it | Each boxer's natural | Today's game (20 seeds) |
| :--- | :--- | ---: | :--- | ---: | ---: |
| Out-boxer / am | Narrow / Squared | 61.5 | - | 59.0 | 61.0 |
| Out-boxer / pro | Shoulder / Squared | 58.0 | Narrow / Squared, Wide / Squared | 56.8 | 54.0 |
| Pressure fighter / am | Narrow / Squared | 39.0 | Narrow / Half, Shoulder / Squared, Shoulder / Half, Wide / Squared | 37.5 | 36.0 |
| Pressure fighter / pro | Narrow / Squared | 48.8 | Narrow / Half, Narrow / Bladed, Shoulder / Squared, Shoulder / Half, Shoulder / Bladed, Wide / Squared, Wide / Half | 46.3 | 52.5 |
| Counter-puncher / am | Wide / Squared | 46.5 | Narrow / Squared, Shoulder / Squared | 44.5 | 48.0 |
| Counter-puncher / pro | Narrow / Squared | 55.5 | Shoulder / Squared, Shoulder / Half, Wide / Squared | 54.8 | 52.0 |
| Volume puncher / am | Narrow / Squared | 49.0 | Shoulder / Squared, Wide / Squared | 47.0 | 49.0 |
| Volume puncher / pro | Wide / Squared | 56.8 | Narrow / Squared, Shoulder / Squared, Wide / Half | 54.3 | 56.0 |
| Slugger / am | Narrow / Squared | 56.0 | Shoulder / Squared, Wide / Squared | 55.5 | 66.0 |
| Slugger / pro | Wide / Squared | 57.8 | Narrow / Squared, Narrow / Half, Shoulder / Squared, Shoulder / Half, Wide / Half | 57.3 | 57.0 |

Best counts: Narrow / Squared 6, Shoulder / Squared 1, Wide / Squared 3. The most any one stance wins: 6 of 10 cells (bar: 6 or fewer).
Cells with a clear best (no other stance inside two standard errors, seed by seed): 1 of 10 (bar: 4 or more).

#### Is the natural stance always best?

| Boxer | Natural | Wins | Best owned stance (10 cells pooled, 400 bouts) | Wins | Best against natural | Clear |
| :--- | :--- | ---: | :--- | ---: | ---: | :--- |
| Kira | Narrow / Bladed | 58.8 | Narrow / Squared | 59.0 | +0.3 +- 0.7 | no |
| Samira | Wide / Squared | 45.5 | Shoulder / Squared | 48.4 | +2.9 +- 1.2 | yes |
| Tess | Shoulder / Squared | 45.3 | Narrow / Squared | 46.1 | +0.9 +- 1.1 | no |
| Danny | Shoulder / Half | 62.0 | Narrow / Squared | 64.6 | +2.6 +- 0.8 | yes |
| Josh | Shoulder / Squared | 44.9 | Wide / Squared | 45.3 | +0.4 +- 1.1 | no |

Boxers whose natural stance is clearly beaten by another owned stance: 2 of 5 (bar: 2 or more). Boxer x cell units (40 bouts each, a weak read) where the natural stance has the most wins: 6 of 50 (bar: under 6 in 10).

### 4. Does each effect move the result? (effect off on its two test stances, 20 seeds, the same dice as with it on)

| Effect off | Test stances | Bouts whose result changed, in 100 | Mean change in wins in 100 (a cell) | Moves it (2 in 100 or more) |
| :--- | :--- | ---: | ---: | :--- |
| power | Wide / Half, Narrow / Half | 1.8 | 1.1 | NO |
| slips | Wide / Half, Narrow / Half | 1.0 | 0.6 | NO |
| chin | Wide / Half, Narrow / Half | 0.5 | 0.3 | NO |
| steps | Wide / Half, Narrow / Half | 3.2 | 1.6 | yes |
| drain | Wide / Half, Narrow / Half | 2.1 | 0.9 | yes |
| drift | Wide / Half, Shoulder / Half | 3.5 | 1.1 | yes |
| hooks | Shoulder / Squared, Shoulder / Bladed | 6.2 | 3.3 | yes |
| body | Shoulder / Squared, Shoulder / Bladed | 0.8 | 0.5 | NO |
| reach | Shoulder / Squared, Shoulder / Bladed | 0.7 | 0.4 | NO |
| rearpower | Shoulder / Bladed, Wide / Bladed | 0.9 | 0.7 | NO |
| not owned yet | the 8 cells that are not his natural | 5.5 | 2.2 | yes |

A stance he does not own yet wins 46.8 in 100 against 49.0 once owned (20 seeds). Boxer x cell units where some not-yet-owned stance still out-wins the natural one: 21 of 50 (a weak read, 20 bouts each).

### 5. The corner's lean (Front / Back from round 2 on, the natural stance, 40 seeds; rounds 2 and later)

| Opponent | Centred: rounds won in 100 | Front | Back | Bout wins: Centred | Front | Back | Best lean |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | :--- |
| Out-boxer | 49.8 | 48.1 | 51.6 | 57.9 | 56.5 | 58.4 | back |
| Pressure fighter | 41.6 | 40.1 | 43.9 | 41.9 | 42.0 | 44.0 | back |
| Counter-puncher | 46.3 | 45.0 | 49.1 | 49.6 | 48.5 | 51.6 | back |
| Volume puncher | 44.5 | 43.2 | 47.3 | 50.6 | 50.6 | 53.9 | back |
| Slugger | 51.8 | 51.3 | 53.1 | 56.4 | 56.3 | 57.0 | back |

All opponents pooled, rounds 2 and later won in 100, against Centred: Front -1.2 +- 0.2, Back +1.9 +- 0.2. Best lean by opponent: { "back": 5 }.
The lean moves a round's result (one lean more than two standard errors from Centred): yes.

### 6. A stance the rival has read on tape (20 seeds)

The natural stance against a rival who has read it: -6.2 +- 0.9 wins in 100. Boxer x cell units where a second owned stance (not read) then out-wins the read natural one: 45 of 50 (a weak read, 20 bouts each). Moves it: yes.

52830 bouts played in 2029 s. Attribute copies the game would have rebuilt (must be 0): 0.

RESULT: tools/stanceprobe1.gd -> FAIL (effects NOT all move; top stance best in 6 of 10 cells; 1 of 10 cells clear; natural clearly beaten for 2 of 5 boxers and best in 6 of 50 units; lean moves a round)

# TRAINSCENE2: Training as its own scene, v2 after the owner's eight marks (design map, S439, ROUND 3)

Roadmap row TRAINSCENE1 (after FOUNDATION). Author: Claude. Round 3, revised in place after two fresh critics on round 2 (depth 5 and 5,
clarity 5 and 6). Sources: `CRITIC_PACK.md` (the game), `TRAINSCENE_MAP_S434.md`, the owner's marks `ops/Feedback/2026-11-11-14`, `-15`,
`-16` (the same seven marks three times, the third adds mark 8), `TRAINING_MAP_S432.md` v6.1, and the code on `main` and on the
ready-to-merge branch `claude/foundation-s433` (FOUNDATION: CARDIO1, NOCAMP1 + TANK1, PUNCHSTART1), which this scene waits for.
Drawing: `docs/mockups/s439/trainscene/screen_r3.html` -> `screen_r3.png` (1920x1080, tools/render_mockup.py).

TAGS. CODE = the game does it on `main` (file and name given). CODE-F = on the foundation branch. ESTIMATE = a value this map sets (the
drawn state, or the size of a NEW rule a probe sets). NEW = a rule this map adds (a build task in section 8). Every mastery figure below is
run by hand from the code's formula and shown with its working; every win figure is an ESTIMATE until T1 runs `BoutRead.likely`.

## What changed in round 3 (each finding, and the mechanic it changed)
| The critics found | Round 3 changes the MECHANIC (not the words) |
|---|---|
| WRONG TIMING: a week's pad nights land at `Sim.end_week` on Sunday night (Sim.gd 226 `day % 7 == 0` -> 344 `DrillWeek.run`); `PlanCards` says "a crossing in the fight's own week is too late". Round 2 counted Mon 23 / Wed 25 / Fri 27 nights for Sat 28 | THE LAST PAD WEEK. The scene is built on it: Mon 16 to Sun 22 is the last week whose nights reach Sat 28; the fight week's pad nights are greyed "count for the next bout". Recomputed: on the coach's week the Check hook ends 28.9 (not Usable), the slip 2-3 line is NOT THROWN, weapons 3, not 4 |
| Sub-30 mastery is worth nothing this bout (`PlanFight.rate`: 1.0 at 30, `PlanBoard.UNDRILLED` 0.8 under), yet rows priced 23.4 against 24.9 | Every card has two horizons: ON SAT 28 (prints "+0" where it is zero) and NEXT BOUT (pad nights still needed to reach 30). The 1-2-3 row now says "+0 on Sat 28, Usable after 4 nights (coach's) / 5 (yours)" |
| No common unit; rows mixed kg, Stamina, injury, Energy, dollars | ONE NUMBER: WIN ON SAT 28 = on the scale x unhurt at the bell x wins if the boxer boxes (`BoutRead.likely`, with the forecast Energy written as `tank_ahead` first). Every option prints its change in points of it, and an AFTER THE BELL line for what lands later |
| Goal tile claimed this bout's corner share; the goal resolves after the bout (`BoutNight._finish` 426 result morale, then 435 goal morale) | The goal sits under AFTER THE BELL: "met: mood +10 after the result (missed -20), scaled by heart and confidence (`FighterProfile.apply_morale`)". This bout: only the round-3 fade under 60 (0.25 a point, CODE-F), printed as its size |
| Diet: the +/-0.15 kg dice was NEW and made weight a gamble; HOLD was a dead option; HARD CUT's 64.34 ignored `Sim.week_ctx` (the cut turns to HOLD at limit - 0.15) | SWEAT IT OFF (NEW SWEAT1, on the CODE-F Tank): no dice. Kilos over the line on the weigh-in morning are sweated off, up to 1.0 kg, and cost Energy at the first bell (`BoutRules.tank_parts` weight part; `eat_kg` is written by the weigh-in, which has no writer today). HOLD is now a live, priced option. HARD CUT is offered only when Cut plus a full sweat cannot reach the line (`week_ctx` stops any cut at 64.85, so it can never go further) |
| "CUT 500 (Coach)": the coach writes no diet (fighters start on hold, `Data.gd` 56 / 247; `WeekCoach.advice` only suggests Cut) | The coach's week runs HOLD, with his suggestion "Switch the diet to Cut" as one line and an Apply. All coach's-week numbers are re-run on HOLD |
| Body snatcher credited in the win read, but `BoutRead` reads only `PerkFight.call_edge` / `jab_edge` (233); `PerkFight.body_cost` is read in LiveRound / FightCast | NEW PERKREAD1: `BoutRead._round_edges` uses `PerkFight.body_cost(f)` for the opponent's energy per body shot she lands (one line at 335). Until it is merged the dock says "perk not in the win read" |
| Pad nights LIGHT/NORMAL/HARD read off one question; $75 never binds; the pool was never a contest | THE CLUB'S PAD NIGHTS ARE SCARCE AND DRAGGABLE (NEW PADPOOL1): Luke Reid holds 8 a week + ONE overtime night ($75); the coach splits them by bout date (Tess 3, Samira 3, Lucy 2). Two boxers fight on Sat 28 and Lucy on Sat 7 Mar, so every spare night has a priced loser: each boxer's next night is priced in that boxer's own WIN. The player drags nights between faces |
| Film is an evening in the code (`WeekPlan.EVENINGS` "film") and opens a tell, but the scene offered none | NEW FILMNIGHT1: a club-show boxer with no camp may spend a pad night on Film with the coach: one tell opens (`OppFile.tape`, weapon first, as camp film does in `Bouts.tape_days`). It takes a pad night from the pool and adds no load (`EVENINGS.film` 0 minutes) |
| The 70/30 split was cut | The split is a slider with its safe band drawn: any split from 20/80 to 80/20 of Body hook / Check hook makes both Usable by Sun 22 (worked in D2). Outside the band one card misses 30 |
| The gym's card was a runway lookup, and "dealt four times" was wrong: `Sim.gd` 357 draws `WeekTwist.draw(week + 1 + index * 31)` per fighter, independent cards | The gym's card is gone from this scene (the per-fighter heating draw is a separate defect, logged in risks). The scene shows THIS boxer's own card for the week, priced in the one number: Rival talks trash (CODE card, `needs: bout`) |
| Useless rows: Fatigue room tile, Power 66.78 -> 66.70, PIN, USABLE NOW section, sparring Tue+Thu, HARD 4 with a +0 night, HOLD at 0% | Cut. Fatigue appears only where it costs: fight night over 50 (none in the drawn week). Usable cards are one line ("a night adds +0 on Sat 28"). Sparring is a day-card toggle with its two prices, not a headline decision. Dead options are drawn grey with the reason |
| Fight week rows priced in free Fatigue | The fight week keeps only what reaches the bell: mornings (Stamina, kilos) and the scale. Its pad cells say "next bout". Its mornings cost only injury hours under fight-night Fatigue 50 (CODE-F: no price under 50 until FITLEGS1), so the scene says so and makes no decision of them |

## 0. The idea in five lines
1. One scene for one boxer's week, drawn around one number: WIN ON SAT 28, the coach's week against yours, with the sum that makes it.
2. This is the LAST PAD WEEK before the bout: only Mon 16 to Sun 22's nights land before the bell (Sunday night), so every pad choice is a
   trade between Sat 28 and the next bout, printed in both.
3. Three decisions carry the week: Wednesday's night (which cards cross 30, or film), a 4th night from the club's scarce pool (whose bout
   pays for it), and the diet (mornings against kilos sweated off on the weigh-in morning, which cost Energy at the first bell).
4. The boxer's own weekly card and the sparring night sit beside them, priced in the same number; the goal and the next bout sit in AFTER.
5. Nothing on the scene is a number the game cannot produce: WeekRun (T1) re-runs both weeks through the game's own functions, and each NEW
   rule is a build task with a test red on main.

## 1. The owner's eight marks, and the answer to each
| # | His mark (on `final_scene.png`) | Round 3's answer |
|---|---|---|
| 1 | THE HAND, "what is this for" | Gone. PAD CARDS grouped by what a night does: CHANGES SAT 28 (crosses 30 by Sun 22) / NEXT BOUT ONLY (+0 on Sat 28, nights to 30) / one line for the Usable ones |
| 2 | "THIS WEEK BUYS", "you mean week gains ?" | Gone. WIN ON SAT 28 and its four parts say what the week buys on fight night; AFTER THE BELL says what it buys later |
| 3 | "tiredness" -> "fatigue" | FATIGUE is the only word; it is printed only where it costs (fight night over 50) |
| 4 | "WHY" -> "What it does" | The dock rows: WHAT IT DOES / ON SAT 28 / TAKES / OPENS |
| 5 | The sore hand panel, "can be designed a bit better" | SAMIRA'S CARD: the problem in one line, two answers side by side, each priced in WIN points and AFTER, the coach's pick marked |
| 6 | No end-of-week weight; "stamina or energy (i am confused what we use)" | Each morning prints its kilos and the day's weight; Sun 22 ends the week; the scale tile gives the weigh-in forecast and what is sweated. STAMINA = the ability mornings grow (the goal reads it). ENERGY = the first bell's tank, which only kilos sweated and fight-night Fatigue over 50 take from |
| 7 | YOUR CHANGE bar, "where these numbers come from" | WHAT YOUR 4 CHANGES DID: one row per change, its points of WIN ON SAT 28 and its AFTER line; the rows add up to the big number |
| 8 | Changed Saturday card, "presentation can be improved" | A changed card: gold YOURS ribbon, the coach's card struck in one line above, its own gain and kilos, an X |

## 2. What is built today (read in the code)
| Part | What the code does | Where |
|---|---|---|
| Mornings | 10 sessions; roadwork and intervals train Conditioning at the same 0.2 share; Light / Normal / Hard gain x0.6 / 1.0 / 1.3, burn x0.7 / 1.0 / 1.35, load x0.6 / 1.0 / 1.5 | `WeekPlan.gd` SESSIONS, INTENSITY |
| Stamina | roadwork and intervals name Stamina: it takes 2x the Conditioning gain; rest names Recovery | `Attrs.SESSION_ATTRS`, `Attrs.train` |
| Goal | CODE-F: "Stamina for five rounds" aims at 60; resolved in `BoutNight._finish` AFTER the result's morale (426, then 435); met +10, missed -20 (`FighterGoal` SUCCESS/FAILURE_MORALE_DELTA) through `FighterProfile.apply_morale` (heart and confidence scale it) | BoutNight.gd, FighterGoal.gd (branch) |
| Round-3 fade | CODE-F: under Stamina 60 every stat 0.25 lower a point under, at most 2, from round 3; `BoutRead._round_edges` reads it (`own_fade`) | BoutRules.gd, BoutRead.gd 318 |
| Pad drilling | a pad night is 240 drill units (4 hours) split by share; +2.1 an hour x (1 + 0.4 x pad rating / 100) x (1 - m / cap); cap 40 + 0.4 T + 0.2 IQ; a combination drills at x2 / length and never passes its weakest punch; not drilled -0.75 a week, a move at 30+ never falls under 30. THE WEEK LANDS ON SUNDAY NIGHT: `Sim` 226 -> `end_week` 344 -> `DrillWeek.run` -> `PadWeek.run_week`, night by night in order | PadWeek.gd, MoveMastery.gd, Combos.gd, Sim.gd |
| Coach's pad week | with a bout booked, `PlanCards.coach_week` puts the plan's cards on the pad nights in turn (a line's combination, or the first punch it lacks: `card_for`) | PlanCards.gd |
| Plan lines on the night | a punch under 30: the line is NOT THROWN (`STAMP_PUNCH`, `StrikeMap.grey_reason`); a combination under 30 plays at x0.8 (`PlanFight.rate`, `PlanBoard.UNDRILLED`); at 30+ x1.0. The S427 fire rule (`FireLevel`, bout key `fire_level`) is in the code and OFF | PlanFight.gd 114, PlanCards.gd 41-43, FireLevel.gd |
| Sparring | 180 drill units shared over `spar_pool` (the week's night cards, pins, plan cards) at 30+; Ring IQ is the evening's stat | PadWeek.spar_pool |
| Film evening | `WeekPlan.EVENINGS.film`: 0 minutes, no load. Tells open only in a camp with film (`Bouts.tape_days` -> `OppFile.tape`, weapon first) | WeekPlan.gd 60, Bouts.gd 306 |
| Fatigue and injury | a morning adds effort x minutes x load / 44; a night keeps 0.87; injury 1.3 in 100 a 10-hour week, x2 at 76, x3 from 80 | WeekPlan.day, InjuryRoll.gd |
| Weight | HOLD eats life + 300 kcal, CUT 500 less; `Sim.week_ctx` turns any cut into HOLD once weight <= limit - 0.15; weigh-in the day before (`Bouts.weigh_in_today`: day == bout day - 1); made at limit + 0.05; missed = bout off, $300 | Sim.gd 115, Bouts.gd 89 / 330, BoutRules.made_weight |
| The Tank (Energy at the first bell) | CODE-F: tiredness 2 a point of Fatigue over 50 (at most 20) + weight left to the day (same day 10 a kg, 20 past 0.5; day before 5 a kg) + the boxer's last bout; at most 25. `eat_kg` HAS NO WRITER. `tank_parts_for` passes same_day for every amateur, though `Bouts` weighs the day before | BoutRules.gd 189-221 |
| Win read | `BoutRead.likely` / `chance` / `round_edges`: reads stats, moves, combos, arrows, perks (in the cache key) and `tank_read` (`tank_ahead` when set). Perks enter only through `PerkFight.call_edge` and `jab_edge` (233) | BoutRead.gd 233, 305-414 |
| Weekly card | one per fighter, independent seeds (`Sim.gd` 357); choice cards have two priced answers; Coach's pick if unanswered | WeekTwist.gd |
| Week edits | coach's week + the player's exceptions; Back to coach's week; a week planned ahead (`ahead_view` / `keep_ahead` -> `week_edits_next`) offered only Sat and Sun (`BoutActs.gd` 69) | WeekPhase.gd |
| Phase | `WeekPhase.phase` says PEAK 2 weeks out, camp or not; the no-camp amateur week (S428) is AGREED, NOT BUILT | WeekPhase.gd |

## 3. What is thin (and what this map does about it)
1. THE COACH'S DRAFT MISSES ITS OWN LINE. `coach_week` rotates cards without the Sunday rule: Check hook 28.9 by Sun 22, slip 2-3 not thrown.
   The scene shows it in the one number; the player fixes it (D2). (A bell-aware coach is rejected in section 9: it would remove the decision.)
2. NOTHING PRICES A WEEK IN ONE UNIT. -> WeekRun (T1) and WIN ON SAT 28.
3. THE WEIGHT PART OF THE TANK IS DEAD (no `eat_kg` writer) and uses the same-day rate for a day-before weigh-in. -> SWEAT1 (D4).
4. PAD NIGHTS ARE FREE AND UNLIMITED. -> PADPOOL1 (D3).
5. FILM EXISTS ONLY IN A CAMP, which S428 removes for club shows. -> FILMNIGHT1 (D2, D3).
6. THE PERK IS NOT IN THE READ. -> PERKREAD1.
7. THE PHASE CONTRADICTS S428. -> T0 (inside AMATEURWEEK1).
8. FATIGUE UNDER 50 ON FIGHT NIGHT AND UNDER 72 IN THE WEEK COSTS NOTHING (CODE-F). It is not drawn as a price; fight-week mornings are
   therefore free apart from injury hours, and the scene does not dress them up as a decision.

## 4. The mechanics, each a decision with its options and prices
Unit: points of WIN ON SAT 28 (ESTIMATE until T1 runs it), plus AFTER THE BELL (goal mood, next bout's nights to 30, cash).
WIN ON SAT 28 = P(on the scale) x [P(unhurt) x likely + P(hurt) x likely with the fight-hurt Energy] (NEW formula in WeekRun over CODE parts:
`BoutRules.made_weight`, `InjuryRoll.training_chance`, `Injuries` fight-hurt Energy, `BoutRead.likely` on a copy with `tank_ahead` set).

Mastery working (CODE formula; Luke Reid's pad rating 74 -> x1.296; Samira's cap 73.2): a full pad night on a punch = 4 h x 2.1 x 1.296 x
(1 - m / 73.2) = 10.885 x (1 - m / 73.2). A combination drills 240 x 2 / 3 = 160 units (2.67 h): 7.25 x (1 - m / 38), 38 = the Lead hook it
cannot pass. Check hook: Mon 12 -> 21.10; Fri +7.75 -> 28.85. Body hook: full 29.1 -> 35.66, half -> 32.38; undrilled 28.35. 1-2-3: full
18 -> 21.8; undrilled 17.25.

### D1. The week's one number, and where each part comes from (CODE-F + NEW T1)
| Part | Coach's week | Yours (drawn) | Source |
|---|---|---|---|
| On the scale | 100%: 65.90 on HOLD, sweats 0.85 kg on Fri 27 | 100%: 64.98 on CUT, sweats 0 | WeightPlan (T3) + made_weight |
| Unhurt at the bell | 98.5% (this week 1.0 in 100, fight week 0.5) | 98.5% (film adds no hours) | InjuryRoll, WeekPlan.hours |
| Wins if the boxer boxes | 48.4% (Energy -4 from the sweat; weapons 3; slip 2-3 not thrown) | 55.2% | BoutRead.likely (+ PERKREAD1) |
| WIN ON SAT 28 | 48% | 55% | product (hurt case at the fight-hurt Energy -10) |
| AFTER: goal | 59.93, missed: mood -20 after the result | 60.08, met: mood +10 | FighterGoal, apply_morale |
| AFTER: next bout | 1-2-3 Usable after 4 nights | after 5 nights | the formula above |

### D2. Wednesday night: the last free night that lands before the bell (CODE + NEW FILMNIGHT1)
Mon and Fri are the coach's Check hook nights. Wednesday:
| Option | By Sun 22 | ON SAT 28 | AFTER |
|---|---|---|---|
| 1-2-3 full (Coach) | 1-2-3 21.8 (still x0.8); Check hook 28.9 | +0: weapons 3, slip 2-3 NOT THROWN | 1-2-3 Usable after 4 nights |
| Body hook full | Body hook 35.7; Check hook 28.9 | +1.5: weapon, perk Body snatcher | after 5 nights |
| Check hook full | Check hook 35.4 (Mon 21.1, Wed 28.85, Fri 35.44) | +2.0: slip 2-3 thrown at x0.8 | after 5 nights |
| Half and half, Body hook / Check hook | Body hook 32.4, Check hook 32.1 (Wed 24.97, Fri 32.14) | +3.5: weapons 5, slip 2-3 thrown, perk | after 5 nights; Jab, Cross, Lead hook -0.75 each |
| Film with the coach (NEW) | Check hook 28.9, Body hook 28.35 | +2.5 once the answer is written in the Game plan (+0.3 if not: the read only narrows) | after 4 nights |
The split is a slider (CODE `PadEdit` shares) with its safe band drawn: Body hook 20% -> 30.41, Check hook 80% -> 34.12; Body hook 80% ->
34.35, Check hook 20% -> 30.17. Outside 20-80 one misses (10/90: Body hook 29.76; 90/10: Check hook 29.5).
WHEN EACH WINS (not a lookup): half and half wins when two cards each need under one night; Check hook full wins when the Body hook is
already Usable or a 4th night takes the Body hook; Film wins on Wednesday when no card can cross 30 this week (a far card like the 1-2-3)
or when the file is empty and the opponent's best weapon is the danger; 1-2-3 full wins when there is no bout within three weeks and the
next bout's plan leans on mid range. The price of every option except the coach's is the next bout: one more night before the 1-2-3 plays
at 1.0.

### D3. A 4th night from the club's pad nights (NEW PADPOOL1)
Luke Reid (sessional, $450 a week, CODE) runs pads 4 evenings a week, two boxers an evening: 8 nights (NEW, ESTIMATE; Marcus Hale full-time
12; a Second club coach, $280 a week on Club > People (CODE), adds 4). One overtime night a week at $75 (NEW, ESTIMATE: $450 / 8 x 1.33),
never two. The coach splits the 8 by bout date: Tess 3 (Sat 28), Samira 3 (Sat 28), Lucy 2 (Sat 7 Mar). Every spare night has a loser:
| Night | What it buys | Who pays |
|---|---|---|
| Overtime (the one) to Samira: Tue Film | Samira +2.5 on Sat 28 (with the answer written) | $75; Tess cannot have it |
| Overtime to Tess: her Uppercut 24.0 -> 30.6 | Tess +1.5 on her Sat 28 (ESTIMATE) | $75; Samira's film waits |
| Lucy's 2nd night to Samira | Samira +2.5 | Lucy -2.0 on Sat 7 Mar: her Uppercut Usable Sun 8, after her bout |
| Tess's 3rd night to Samira | Samira +2.5 | Tess -2.0: her Lead hook 27 stays under 30 |
| Samira's Tue: Check hook | +0 on Sat 28 (half and half already makes both Usable): drawn grey with the reason | - |
| Samira's Tue: 1-2-3 | +0 on Sat 28; the next bout's 1-2-3 one night sooner | the overtime, or a teammate's night |
The player drags a night between faces; each face prints its next night in its own bell's points. The club's best use moves with who
boxes when: here Samira's film (+2.5) beats Tess's Uppercut (+1.5) for the one overtime night; with Tess two places higher on the ladder or
Jade's file already open, it flips.

### D4. Diet and the weigh-in morning (CODE + NEW SWEAT1 + NEW CUTS1)
The weigh-in is Fri 27, the day before (CODE `Bouts.weigh_in_today`). On that morning anything over 65.05 is sweated off, at most 1.0 kg
(NEW, ESTIMATE: about 1.5% of body mass, a common day-before water cut); more than that and the bout is off ($300, CODE). Sweated kilos cost
Energy at the first bell at the day-before rate, 5 a kg (CODE-F `EAT_DAY_BEFORE`; T3 makes `tank_parts_for` use it for a day-before weigh-in).
A cut trains every morning at x0.9 (NEW CUTS1, ESTIMATE; real basis: an energy deficit blunts training gains).
| Option | Fri 27 | Sweat | ON SAT 28 | AFTER |
|---|---|---|---|---|
| Hold (Coach's week) | 65.90 | 0.85 kg: Energy -4 | -0.9 against Cut today | goal margin +0.14 (mornings at x1.0) |
| Cut from Mon 23 | 65.44 | 0.39 kg: Energy -2 | -0.4 | goal margin +0.11 |
| Cut today (the coach's suggestion) | 64.98 | 0 | +0 | mornings x0.9 all 12 days |
| Hard cut | grey: "Cut today already makes weight; any cut stops at 64.85 (Sim.week_ctx)" | | | |
WHEN EACH WINS: Cut today when the goal has room; Hold or a late cut when the goal is short by under 0.14 and the Energy loss is the
smaller price (here 0.9 points now against a mood swing of 30 after); Hard cut only when Cut plus a full 1.0 kg sweat cannot reach the line.

### D5. Samira's card this week: Rival talks trash (CODE card, `needs: bout`)
| Answer | ON SAT 28 | AFTER |
|---|---|---|
| Stay quiet (Coach's pick) | +0 | nothing |
| Fire back | -1.5 (ESTIMATE): on the night the corner's fixes land half as well (CODE `hot`; a fight-night rule, not in BoutRead: T1's probe measures it over 400 bouts, or the row says "live only") | +3 members now (CODE): $105 a month in dues at $35 |
WHEN EACH WINS: Fire back when the club needs members more than this bout needs its corner (short runway, a lopsided bout either way).

### D6. Sparring night: Thursday (Coach) or none (CODE)
A day-card toggle, priced: Thursday shares 180 units over cards at 30+ by Thursday's turn in the run (the Body hook 32.4 -> 35.6, +0 on Sat
28), Ring IQ +0.20 (AFTER), injury hours +0.5 (-0.1 on Sat 28). None: +0.1 on Sat 28, Ring IQ +0. Tuesday sparring is not offered when Tuesday
holds the film.

### D7. The fight week: the coach's draft, editable now (CODE + NEW AHEAD1)
Mon 23 to Sat 28 under this week: Light roadwork, Light shadow, rest, Light speed bag, Light roadwork (weigh-in), the bell. Its mornings
count for the bell (Stamina +0.26, kilos); its pad nights are grey: "count for the next bout". A morning made Normal adds Stamina and costs
only injury hours while fight-night Fatigue stays under 50 (36 here): the scene says that on hover and offers no row of prices for it.

### D8. Coach's week or yours
BACK TO COACH'S WEEK clears both weeks' exceptions (`WeekPhase.clear`, `week_edits_next`); UNDO LAST takes back one change.

## 5. One week, played (Samira Khan, Monday 16 Feb 2026, week 7)
STATE (ESTIMATE): Stamina 58.85, Recovery 63.4, Power 66.6, Technique 55.6, Hand speed 57.4, Ring IQ 54.8, potential 82; weight 65.80 kg on
HOLD; Fatigue 28; morale 62 (Steady). Moves: Jab 50, Cross 44, Lead hook 38, Body hook 29.1, Check hook 12, Uppercut 0; combinations 1-2 34,
1-2-3 18. Plan: "When Jade loads up -> slip 2-3" (card: the Check hook, `card_for`), "At mid range -> 1-2-3". Bout: club show Sat 28 Feb vs
Jade Okoro (Haringey Police CC, Boxer-puncher, 2-1; file empty), limit 65.0, weigh-in Fri 27. Goal "Stamina for five rounds", 60.0. Coach Luke
Reid. Cash $12,940, running -$210 a week. Tess (bout Sat 28), Lucy (bout Sat 7 Mar), Ana (no-gi, classes, not in the pad pool).
Coach's mornings: Mon Roadwork N +0.22 Stamina, Tue Heavy bag N +0.10 Power, Wed Intervals N +0.27, Thu Speed bag L, Fri Roadwork N +0.22, Sat
Strength N +0.08 Power, Sun rest; nights Mon Check hook, Wed 1-2-3, Thu sparring, Fri Check hook. Figures are on Cut; on Hold each is /0.9.

1. SHE OPENS THE SCENE: WIN ON SAT 28 48% = scale 100% (sweats 0.85 kg: Energy -4) x unhurt 98.5% x wins 48.4%. Weapons 3; slip 2-3 NOT
   THROWN (Check hook 28.9 by Sun 22). AFTER: goal 59.93, missed. The coach's line: "Switch the diet to Cut."
2. DIET -> CUT TODAY (Apply): Fri 27 64.98, no sweat: +0.9. AFTER: goal 59.81 (mornings x0.9), still missed.
3. WEDNESDAY -> HALF AND HALF: Body hook 32.4, Check hook 32.1 by Sun 22; slip 2-3 thrown at x0.8; weapons 5; Body snatcher: +3.5. AFTER:
   the 1-2-3 is 17.3 (Usable after 5 nights, not 4). The dock shows TAKES: Jab, Cross, Lead hook -0.75 each (no drilled combination holds them).
4. THE 4TH NIGHT: she drags the overtime night onto Samira's Tuesday and picks Film: +2.5 once Jade's best weapon is answered (it opens Tue
   night; the Game plan's "Write it" comes Wednesday). Cash -$75. Tess's row now reads "4th night: none; Uppercut 24 stays under 30 (-1.5)".
5. SATURDAY MORNING: Strength -> Intervals Normal: Stamina 59.81 -> 60.08: goal MET (mood +10 after the result, not -20); Power -0.08: -0.1.
6. SAMIRA'S CARD: Rival talks trash. Fire back would bring 3 members and cost 1.5 points; she keeps Stay quiet.
7. SPARRING THURSDAY: kept (Ring IQ +0.20 for later, -0.1 now).
8. THE FIGHT WEEK: the draft as it is: Light mornings, weigh-in 64.98, fight night Fatigue 36, Energy 100.
9. DONE: WIN 48% -> 55%; goal met after the bell; $75. CONTINUE runs the week; the Monday review names Wednesday's half night and Tuesday's tape.
What she traded: one night of the 1-2-3 for the next bout, $75 and Tess's Uppercut for a tell, 0.08 Power for the goal.

## 6. Numbers: CODE, CODE-F, NEW or ESTIMATE
CODE: session gains, pace multipliers, Stamina 2x, kcal and 7,700 a kg, HOLD +300, CUT -500, the cut's stop at limit - 0.15, weigh-in the day
before, made at +0.05, $300; pad 240 / spar 180 units, 2.1 an hour, x(1 + 0.4 x 74/100), cap, x2/length and the weakest-punch cap, -0.75 and
the 30 floor; drilling lands Sunday night; NOT THROWN / x0.8 / x1.0; `coach_week`; injury 1.3 in 100 a 10 h week; film evening 0 minutes;
the twist cards and their effects (+3 members, `hot`); dues $35; Luke Reid $450 and pads 74; Second club coach $280; Jade Okoro's row.
CODE-F: the goal at 60, resolved after the result; the fade 0.25 a point; the Tank (5 a kg the day before, 2 a Fatigue point over 50).
NEW (ESTIMATE sizes, a probe each): pool 8 / 12 / +4, one overtime $75; sweat at most 1.0 kg; Cut x0.9; film night outside camp; intervals x1.25
(SESSIONS1, kept from round 2); Body snatcher in the read.
ESTIMATE: Samira's, Tess's and Lucy's states; every win figure (48.4, 55.2, +3.5, +2.5, +1.5, -2.0, -1.5, +0.9); the injury hours.

## 7. Every menu it appears on, and what each is wired to (S425 rule)
| Menu | What it shows of this mechanic | Wired to | Built? |
|---|---|---|---|
| Training scene (NEW `scenes/areas/TrainingScene.tscn`) | the drawing: whose week + the pad-night pool, Samira's card, the dock; WIN ON SAT 28 with its four parts and AFTER; the three decisions; this week's days; the fight week; next bout and plan lines; pad cards; the change table; DONE | WeekRun (T1) over WeekPlan, PadWeek.run_week (copy, Sunday landing), PadPool (T2), WeightPlan + sweat (T3), InjuryRoll, BoutRead.likely (+ tank_ahead, PERKREAD1), FighterGoal, WeekTwist, OppFile | NEW |
| Fighter page > Week tab | summary: WIN ON SAT 28 coach's / yours, the four parts, changes count, OPEN TRAINING | the same WeekRun result | today WeekBoard; becomes the summary (T10) |
| Fighter page > Overview | "Plan the week" opens the scene; goal chip reads WeekRun's AFTER line | FighterPage.gd 235, DarkOverview.gd 364 | CODE (retarget) |
| Fighters > Roster | corner flag "Weight" when the forecast needs a sweat over 0.5 kg; Condition tile unchanged | RosterFlag + WeightPlan (T3) | CODE + T3 |
| Club > People (Luke Reid's card) | "Pad nights 8 a week + 1 overtime: Tess 3, Samira 3 + 1, Lucy 2"; the Second club coach row says "+4 pad nights" | PadPool (T2) | NEW line on an existing card |
| Club > Money | overtime pad nights in PAID OUT | GymBills one-offs | CODE (new line) |
| Playbook > Game plan | after a film night, the found tell with "Write it" (CODE `FilmEdge.rows`); lines show THROWN / x0.8 / NOT THROWN at the bell | PlanCards.card_for, WeekRun lines, FilmEdge | CODE + T11 line |
| Playbook > Combos | "Drill it" puts a combination on the next free pad night and returns to the scene | PlanCards.drill_it | CODE (return path T12) |
| Fights > bout page / Fight prep | the bout page keeps "wins if the boxer boxes" (BoutRead.likely); "Check the week" opens the scene; the scene's third part equals it | VersusPanel, FightPrep | CODE (retarget) |
| Home | YOUR FIGHTERS "this week's plan"; a need "Pad nights: one overtime night free" while unused | HomeRows, PadPool | CODE + T2 |
| Week review (Monday) | moves turning Usable on Sunday night with their night; the film's tell; the overtime cost | WeekReview, DrillWeek news, OppFile news | CODE |
| Weigh-in modal | "65.44 on the scale: 0.39 kg sweated, Energy -2 at the first bell" | Bouts.weigh + SWEAT1 (T3) | CODE + T3 |
| Fight night | first bell Energy with its parts (`tank_words`: the scale); Body snatcher; the plan lines thrown | BoutRules.tank_parts (CODE-F), PerkFight | CODE-F |
| Top bar | WEIGH-IN flag Fri 27; CONTINUE names the stop | Shell | CODE |
GOLDEN PATH (T13, one test): Week tab -> OPEN TRAINING (WIN 48%) -> Apply the coach's Cut: +0.9, sweat 0.85 -> 0 -> Wednesday half and half: weapons
3 -> 5, slip 2-3 THROWN, 1-2-3 next-bout nights 4 -> 5 -> drag the overtime night to Samira, Film on Tuesday: cash -75, Tess's row -1.5 -> Sat
Intervals Normal: goal 59.81 -> 60.08 MET in AFTER -> Rival talks trash: Fire back previews -1.5 and +3 members, back to Stay quiet -> DONE (55%)
-> CONTINUE to Sun 22: Body hook 32.4 and Check hook 32.1 land on Sunday night; Tuesday's tell is in Jade's file -> Monday review names both.

## 8. Build tasks (each under 500 lines, one owner, its test red on main first)
Order: T0 -> T1 ... T7 (pure, cloud) -> T9 ... T12 (UI) -> T13. Nothing starts before FOUNDATION is merged.
| ID | Owner | What | Files | Test (red first) |
|---|---|---|---|---|
| T0 NOCAMPPHASE (in AMATEURWEEK1) | Qwen | a club-show bout with no camp: BASE until 7 days out, then TAPER | `scripts/rules/WeekPhase.gd` (+6) | `tests/amateur_phase_test.gd`: 12 days out, no camp -> base. Red: peak |
| T1 WEEKRUN1 | Qwen | runs this week + the fight week to the bout day on a copy; pad drilling applied at Sunday night exactly as `Sim.end_week` orders it; writes `tank_ahead` (fight-night Fatigue + sweat) before `BoutRead.likely`; returns {scale, sweat_kg, energy, unhurt, likely, win, weapons, lines[{text, state}], perks, goal{value, met, mood_after}, next{card: nights_to_30}} and diff rows that change win or an AFTER line | `scripts/rules/WeekRun.gd` (~280) | `tests/week_run_test.gd`: coach's week: Check hook 28.85 at Sun 22, slip 2-3 NOT THROWN, weapons 3; a Wed 25 pad night changes nothing on Sat 28; half and half -> 32.38 / 32.14. Red: no file |
| T2 PADPOOL1 | Qwen | the club's pad nights: 8 sessional / 12 full-time / +4 second coach, one overtime $75 a week; coach's split by bout date; lend / borrow with each loser's WIN line | `scripts/rules/PadPool.gd` (~170), `PadWeek.gd` (+8 in nights_of) | `tests/pad_pool_test.gd`: three boxers: 3 / 3 / 2 of 8; a 4th for one takes the overtime ($75) or a teammate's night; a second overtime is refused. Red: no file |
| T3 SWEAT1 + CUTS1 | Qwen | `Bouts.weigh`: kilos over limit + 0.05 up to 1.0 are sweated (made, `eat_kg` written); `tank_parts_for` uses the day-before rate when the weigh-in was the day before; Cut x0.9 on mornings; `WeightPlan.gd` forecast + sweat + Energy per diet, Hard cut offered only when needed | `Bouts.gd` (+8), `BoutRules.gd` (+3), `WeekPlan.gd` (+4), `scripts/rules/WeightPlan.gd` (~120) | `tests/sweat_test.gd`: 65.90 for 65.0 -> made, eat_kg 0.85, Energy 4.25 off; 66.20 -> missed; Cut morning = 0.9 of Hold. Red: missed, eat_kg absent |
| T4 SESSIONS1 | Qwen | intervals share 0.25 of a morning (x1.25 of roadwork) | `WeekPlan.gd` (+2; it is 363) | `tests/morning_prices_test.gd`: Intervals Normal > Roadwork Normal in Stamina, < in kcal. Red: equal |
| T5 PERKREAD1 | Qwen | `BoutRead._round_edges`: the opponent's energy per body shot she lands = `PerkFight.body_cost(f)` | `BoutRead.gd` (1 line + comment) | `tests/perk_read_test.gd`: Body snatcher raises `chance` against the same opponent. Red: equal |
| T6 AHEAD1 | Qwen | the fight week editable from any day; `keep_ahead` on every change; Back to coach's week clears both | `BoutActs.gd` (4 lines), `WeekPhase.clear` (+1) | `tests/ahead_edit_test.gd`: an edit to Mon 23 made Mon 16 runs Mon 23. Red: dropped |
| T7 FILMNIGHT1 | Qwen | a booked bout with no camp: a Film evening takes a pool pad night and opens one tell (`OppFile.tape`) at Sunday's landing; refused when the opponent has no tape | `scripts/state/DrillWeek.gd` (+15), `WeekPhase.gd` (+4) | `tests/film_night_test.gd`: a Tue film -> Jade's weapon open on Sun; a debutant -> refused. Red: nothing opens |
| T9 SHELL | Cursor | the scene: header, whose week, next bout, footer; opened from Plan the week / Week tab / Fight prep | `scenes/areas/TrainingScene.tscn`, `scripts/ui/areas/TrainingScene.gd` (~300) | golden step: Plan the week lands here |
| T10 DAYS + FIGHT WEEK | Cursor | 7 day columns with YOURS (mark 8), Sunday "drilling lands tonight", the fight week with grey pad cells; split `WeekCards.gd` (552) first; the Week tab summary | `TrainDayCard.gd` (~240), `FightWeekRow.gd` (~150), `TrainTab.gd` (~200) | golden step: Sat card shows struck coach's card |
| T11 BELL + DECISIONS + CHANGES | Cursor | WIN ON SAT 28 and its parts + AFTER; the three decision cards with points; the change table; UNDO | `ByTheBell.gd` (~200), `TrainDecisions.gd` (~260), `ChangeTable.gd` (~120) | golden step: Cut today prints +0.9 |
| T12 POOL + CARDS + DOCK | Cursor | the pool with drag between faces and each face's next night; pad cards by horizon; split slider with its safe band; the dock; the weekly card priced | `PoolPanel.gd` (~200), `PadCardList.gd` (~180), `PreviewDock.gd` (~200), `ui/TwistCard.gd` (+30) | golden step: overtime dragged to Samira shows Tess -1.5 |
| T13 GOLDEN | Grok Dev | the golden path above, headless | `tests/trainscene_golden_test.gd` (~240) | the whole walk |

## 9. Rejected, and why
- THE ±0.15 KG SCALE ROLL (round 2): a gamble, not a trade. The sweat (D4) prices the same margin in Energy, on a rule the Tank already has.
- SAME-DAY WEIGH-IN FOR AMATEURS (CLUBWEEK 4's scale): it would move the weigh-in modal, the CONTINUE stops and every forecast; the game weighs
  the day before, so the scene uses the day-before rate. If the owner moves it (AMATEURWEEK1 scope), only the rate in T3 changes (10 a kg).
- THE GYM'S CARD (heating) in this scene: it was a runway lookup, and the code deals cards per fighter. Its per-fighter draw is logged as a defect.
- SWITCHING ON THE S427 FIRE RULE here: it would make 32 against 35 matter only at 60 (Sharp) and changes every bout's balance; the owner's
  call, outside this scene. If switched on, D2's full nights gain a price and T1 reads `fire_level`.
- A BELL-AWARE COACH (the coach drills what crosses 30 first): it would take the Wednesday decision away; the scene shows the coach's draft
  and its price instead.
- A GOAL WHOSE MOOD SCALES WITH THE MARGIN: goals are pass or fail by design (~70% clearable); the scene prints the margin instead.
- FATIGUE TILES AND BARS, "ROOM TO 72": free under 72 and under 50 on fight night; never drawn as a price.
- HARDRUN1 and SPARRISK (round 2): no case in this week turned on them.
- PIN FOR SPARRING and a USABLE NOW group: no effect on Sat 28 in any case played; one line remains.
- HARD 4 / LIGHT 2 pad-night steps: replaced by the pool's single nights, each with a named loser.
- A COMBINATION BENCH inside the scene: one home, Playbook > Combos.

## 10. Risks
- THE ONE NUMBER MAY NOT MOVE. If `BoutRead.likely` moves under 1 point for a weapon or a line, every decision flattens. T1's test logs each
  change's points; under 1 point for all, the big number becomes the band and the parts show the lines that fire instead.
- FILM'S VALUE NEEDS A SECOND ACTION (writing the answer). The row says "+2.5 once answered, +0.3 if not"; the Monday review reminds.
- FIRE BACK'S PRICE IS LIVE ONLY: until T1's 400-bout probe measures `hot`, the row says "live only" beside the ESTIMATE.
- THE POOL BITES ONLY WHEN BOUTS CLUSTER. T2's probe runs the four-fighter start for 12 weeks: how many weeks a night is contested.
- THE SWEAT IS CHEAP AT THE DAY-BEFORE RATE (0.85 kg = 4 Energy). If the probe shows Hold always wins, the max sweat or the rate moves.
- THE PER-FIGHTER HEATING DRAW (`Sim.gd` 357): one boxer's gym cold while the others' is not; a separate fix, not this scene's.
- Before FOUNDATION and T0, the scene would show PEAK for a camp-less amateur and a Tank main lacks. It waits for both.
- `WeekCards.gd` 552 and `Sim.gd` 499 lines: T10 splits the first; nothing here adds to the second.

## 11. The drawing (screen_r3.png), panel by panel
| Panel | Shows | Reads |
|---|---|---|
| Top bar | cash $12,940, running -$210 a week; CONTINUE to Mon 23 | Shell |
| Whose week + pad nights | Tess, Samira, Lucy with their bouts and nights (3, 3 + overtime, 2), each face's next night priced; overtime 1 of 1 used; the Second club coach link | PadPool (T2) + WeekRun |
| Samira's card | Rival talks trash: Stay quiet (Coach's pick) / Fire back, each in points and AFTER | WeekTwist + WeekRun |
| Dock | Body hook, half of Wednesday: WHAT IT DOES / ON SAT 28 / TAKES / OPENS | MoveMastery, Combos, PerkFight |
| WIN ON SAT 28 | 48% -> 55%, the sum, four parts (scale, unhurt, wins if the boxer boxes, AFTER) | WeekRun (T1) |
| This week's decisions | Wednesday night, the 4th night, the diet: every option with its points and AFTER, dead ones grey with the reason | WeekRun re-runs |
| This week | seven days, morning over evening, YOURS on Tue, Wed, Sat; Sunday "drilling lands tonight" | WeekPlan, PadWeek.run_week |
| Fight week | the draft; mornings and the scale count; pad cells "next bout" | WeekPhase.ahead_view (T6) |
| Next bout | Jade Okoro; the plan lines THROWN / x0.8 / NOT THROWN at the bell | PlanCards, PlanFight.rate |
| Pad cards | CHANGES SAT 28 / NEXT BOUT ONLY / one Usable line | the formula in section 4 |
| What your 4 changes did | four rows, points + AFTER, adding to 48 -> 55 | WeekRun.diff |
Checked on the render (full size, plus crops of the left and right columns): nothing clipped after a second layout pass (the first render
clipped the pool's last line, two greyed options, Sunday's evening and the dock); the change rows add to the big number (+0.9 +3.5 +2.5 -0.1 =
+6.8, 48 -> 55 with rounding); no "Engine", no "Tank" on screen; no Fatigue tile (Fatigue 36 appears once, beside Energy 100 at the bell);
Energy only where kilos are sweated; the plan lines name the opponent, not a pronoun. Every win figure on screen is an ESTIMATE for WeekRun. Buttons only where something can be done: the pool's drag handles, the card's
two answers, UNDO LAST, BACK TO COACH'S WEEK, each option, Apply, each YOURS X, the day cards, the fight week's mornings, Build a combination, DONE.

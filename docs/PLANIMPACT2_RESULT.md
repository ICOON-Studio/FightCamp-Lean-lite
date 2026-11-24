# PLANIMPACT2 result - the plan sharpens the corner only where it was drilled for THIS opponent (S550)

Task: `ops/research/TASK_PLANIMPACT2.md`. Rule and paper count written before any bout run: `ops/research/DESIGN_PLANIMPACT2.md`
(commit 1dc867d; trial amendment 70549ab, before the full run). Probe only: nothing under scripts/ or tests/ changed.
Tools: `tools/planimpact2_probe.gd` (extends PLANIMPACT1's probe, one switch), `tools/planimpact2_rules.gd`, `tools/planimpact2_sum.py`.
Raw runs: `E:/FightCamp/tmp/planimpact2/` (paper, trial, trial2, full_L3, full_L6a/b, cbx_L3; all tables in `sum_full.md`).

## For the owner (wins in 100)

1. **The rule fails. Choosing a good plan instead of a careless one is worth about 2 wins (bar: 6).** The best plan beats the
   coach's by about 2, and a careless plan costs nothing against the coach's (-0.4 / -0.3).
2. **The rule itself adds half a win.** Drilling for this opponent sharpens only commands the boxer already does well. The
   plan lines she can throw and the commands she carries out well use the same skills, and a Good command cannot get better.
3. **One plan still fits every opponent.** All six opponent styles fight on the same four places in the ring, and the same
   moves answer both a presser and a slugger there. So a plan written for one style prepares the same things against all of them.
4. **No rule of this kind can reach 6.** Even PLANIMPACT1's wider version, which rewarded any plan, made the best plan only
   2.3 / 0.9 better than a careless one. Today the plan is worth about 1 to 2 wins. To make it worth more, the opponent
   styles must differ in where and how they fight (a ring change), not the plan rule. See "Keep it small" below.

## METHOD followed
- MECHANICS NEED 8, PROBE FIRST: one rule on a greybox; nothing landed in the game.
- Code read first (design page: `CoachPlan.cards` l.38-56, `cornercmd2_rules.gd` CMD l.40-58, PLANIMPACT1's `prepared` l.66).
- CONTROL FIRST: with the rule at 0 the probe reproduced PLANIMPACT1's lever-off arms **bout for bout: reader none / coach / C /
  E / K and file none / coach / C, 2000 of 2000 identical at 3 rounds and 2000 of 2000 at 6 rounds, every arm** (also 160 of
  160 in both trials).
- THE WRITTEN PLAN STAYS: nothing here proposes shrinking it.
- NO BALANCING NUMBER: full strength (one grade, PLANIMPACT1's raise) and half strength; nothing tuned. One definition was
  amended once, after the trial and before the full run, and written down first (below): a line prepares only if it fires.
- NOT IDENTICAL FIGHTERS: CORNERBASE1/PLANIMPACT1's five women - Lucy Jackson, Samira Khan, Tess Reilly (TELLPLAY1 types at
  week 4), Cara Bello (raw, week 0), Jade Yates (all-round, week 80) - stats printed in each run's first line, against
  CORNERCMD2's ten opponent cells. The paper count also covers PLANIMPACT1's ten types. The live corner exists only in this
  harness, so "6 of 10 types" was read as 3 of 5 boxers (PLANIMPACT1's reading).

## The paper count (before any bout; `paper.jsonl`)
- All six styles fight on the same four cards: mid, long, outside, own_ropes. Long is always range and outside always counter.
  Mid and own_ropes are press (Pressure, Counter-puncher, Volume) or loadup (Boxer-puncher, Out-boxer, Slugger).
- So only five commands can ever be prepared: Go to the body (long), Change levels (outside), Get out of there (press styles),
  Be first and Hands up (loadup styles). **Let your hands go, Sit down on your shots and Reset never can be**: their moments
  (tiring, she_tired, she_hurt) are on no style's card list.
- **The careless plan prepares 0 of its 414 lines** (by construction: it skips exactly the lines this rule rewards). The best
  plan C: 106 of 284 lines, 103 commands over 72 boxer x style cells; the coach: 71 of 72 lines, 88 commands; K2: 117 lines,
  150 commands. So the bar-1 stop ("careless prepares more than a fifth") did not trigger, and the run went ahead.
- The page also warned before the run: the coach's one line is by definition a prepared line (bar 2 risk); a step_back /
  slip 2-3 on mid answers press and loadup alike (bar 4 risk).

### Trial amendment (taken once, before the full run)
In the first trial Samira's K2/D2 line step_back fired 0 times in 40 bouts. Her step bar is under Usable, but the rule counted
it as preparing Get out of there. Amended: a line prepares only if it fires (the game's own test, `FireLevel.mastery_of >=
USABLE_AT`, as in `CoachReadWire` l.38). With that, the best plan C of Samira, Tess and Jade prepares only Go to the body against
every style - the same command the coach's 1-2 prepares.

### Why it moves little (her own grades, `paper.jsonl` "grades")
The commands a firing line prepares are mostly ones she already does at Good: Samira and Tess Go to the body Good 1.25, Lucy Get
out of there and Be first Good 1.25, Jade Good in 7 of 8. A Good command cannot be raised. Lucy's Change levels (Poor) is the
one real raise in the five (C's 1-1-2), and Lucy is the boxer where the plan pays most (+5.5 / +4.5 over careless).

## The rule (as written before the run)
A live corner command is prepared only by a plan line that answers that moment on the card where THIS opponent's style fights it
(`CoachPlan.cards(style)`; a best answer to that card's game, or a "when" line for it that is not wrong; amended: the line fires).
A prepared command is carried out one grade higher (Poor -> OK -> Good); every other at her own grade. Half: the multiplier half way.

## Feedback loop check
Share of the reader's commands raised (rule on): C 28% / 19%, K2 38% / 31%, coach 31% / 26%, D2 26% / 18%, E 0% (3 / 6
rounds). Inside the 10-80% band: neither too wide nor too narrow - it raised a fair share, and the raises bought almost nothing.

## Wins in 100 (all five boxers, 2000 bouts an arm; per boxer in `sum_full.md`)
| Arm (corner : plan : rule) | 3 rounds | 6 rounds |
|---|---|---|
| file : none | 65.8 | 64.5 |
| file : coach | 66.3 | 65.4 |
| file : C | 66.8 | 64.8 |
| file : K2 | 68.0 | 66.2 |
| reader : none | 75.1 | 77.2 |
| reader : coach : off / half / on | 76.2 / 76.2 / 76.7 | 77.8 / 77.8 / 78.2 |
| reader : C : off / half / on | 77.1 / 77.2 / 77.6 | 78.6 / 78.8 / 79.1 |
| reader : K2 : off / half / on | 77.5 / 77.5 / 77.7 | 78.2 / 78.2 / 78.5 |
| reader : E (careless) : off = on | 76.2 | 77.8 |
| reader : D2 (one line) : off / half / on | 76.3 / 76.4 / 76.5 | 77.8 / 77.8 / 78.0 |
| reader : K (PLANIMPACT1's corner plan) : off | 77.2 | 78.4 |

## The seven bars (best plan = the higher of C and K2 per boxer, rule on)
| Bar | 3 rounds | 6 rounds | Verdict |
|---|---|---|---|
| 1 choosing well pays: best - careless >= 6 in 3 of 5 | 0 of 5 (+2.3 +-1.2 over all) | 0 of 5 (+2.0 +-1.0) | **FAIL** |
| 2 the plan pays: best - coach >= 6 in 3 of 5 | 0 of 5 (+1.8 +-1.0) | 0 of 5 (+1.7 +-1.0) | **FAIL** |
| 3 corner not just buffed: reader - file in +6..+15 | +9.8 +-1.6 (K2) | +14.2 +-1.7 (C) | pass (today +10.0 / +12.4) |
| 4 not one plan: no plan best in > 3 of 6 styles, 3 of 5 | C 0 of 5, K2 0 of 5 | (3 rounds only) | **FAIL** |
| 5 careless costs: careless - coach <= -3 | -0.4 +-1.2 | -0.3 +-1.1 | **FAIL** |
| 6 no trap: one line - coach >= -2 | -0.1 +-0.9 (no boxer under) | -0.1 +-0.8 | pass |
| 7 the card can say it | below | | not built |
| **Verdict** | | | **FAIL** |

### Best minus careless, per boxer (rule on, +-2 SE)
| Boxer (best plan) | 3 rounds | 6 rounds |
|---|---|---|
| Lucy Jackson (C) | +5.5 +-2.7 | +4.5 +-2.6 |
| Samira Khan (K2) | +1.8 +-2.5 | +4.8 +-2.9 |
| Tess Reilly (K2 / C) | -0.2 +-2.5 | -0.8 +-2.1 |
| Cara Bello (K2 / C) | +4.5 +-3.1 | +2.0 +-2.3 |
| Jade Yates (K2) | +0.0 +-2.1 | -0.5 +-1.2 |
| ALL | +2.3 +-1.2 | +2.0 +-1.0 |

Rule on minus off, best plan: +0.5 +-0.6 / +0.7 +-0.6; half strength +0.1 / +0.4; coach's plan +0.4 / +0.3. With the rule off the
best plan already beats the careless one by +0.9 / +0.8, so the rule added about 1.3 wins to "choosing well".
Bar 4 detail (`cbx_L3.jsonl`): Samira's and Tess's six C plans are one plan (the same four lines for every style); every boxer's
K2 is best in 5 or 6 of the 6 style cells.

### Bar 7 (named, not built)
For the card to show "this plan sharpens Be first against her", `BoutRead._round_edges` (scripts/rules/BoutRead.gd l.313) would
have to read the reader corner's raised grades, and `PlanReadFit.chain` (scripts/rules/PlanReadFit.gd l.49) would have to credit
a prepared command. Neither knows corner commands today. `tests/plan_read_fit_test.gd` plays `BoutNight.play_out` (l.74) with no
live corner, so it would not go red on this rule; it would need a reader-corner arm. Not built: the rule failed.

## Menu table
Not given: the rule failed bars 1, 2, 4 and 5, so nothing goes on a menu.

## Kalli's change (a) on the coach map (the corner coach's tactics = how well the boxer hears the call)
It is the same lever: a command's grade. Measured here from the plan's side, raising grades the plan earned is worth +0.5 /
+0.7, because the grades worth raising are the ones the plan cannot prepare. One rule should own the command grade. If the coach
map builds change (a), the plan must not raise grades as well (two raises stacked on one number). The plan's version is the
one to drop: it is measured at half a win.

## Keep it small: can any rule of this family pass bar 1?
No, not with today's opponents. The family is "the plan raises the grade of the corner commands it prepares". Its ceiling:
- With preparation tied to THIS opponent, the careless plan gets nothing (paper: 0 of 414 lines). The best plan gets only
  what its firing lines prepare, and those are mostly commands already at Good: +0.5 / +0.7.
- With preparation NOT tied to the opponent (PLANIMPACT1's lever 2), the bonus goes to any plan. Best - careless was 2.3 / 0.9.
- Even if the best plan kept all of PLANIMPACT1's +4.5 / +6.0 and the careless plan none, best - careless would be about 5.4 /
  6.8 over all. That is under 6 at 3 rounds and borderline at 6, and it rests on raising commands no matter who the opponent is.

**What caps the plan is the ring's opponent model, not a plan rule:**
1. `Exchanges.STYLE_MODES` + `PlanFight.GAME_CARD`: all six styles fight on the same four cards, long = range and
   outside = counter for all, and press and loadup share their best answers on mid (step_back, slip 2-3, 1-1). A plan cannot be
   specific when the styles are not.
2. Three commands (Let your hands go, Sit down, Reset) answer moments that no style's card list holds, so no plan can prepare them.
3. What she throws well and what she carries out well read the same skills, so "drilled" lands on what is already good.

The written plan today is worth about 1 to 2 wins over the coach's (here +0.9 / +0.8 rule off). Making it worth 6 needs
opponents whose games land on different cards (e.g. a Slugger who fights inside, an Out-boxer who lives on long with a different
best answer), which is a ring change for a separate probe. It is the owner's call whether to open it.

## Honest limits
- "Best plan" is the higher of C and K2 per boxer after the run (PLANIMPACT1's reading); that leans toward passing, and it still failed.
- The bouts are the five women only (where the corner lives); the paper count covers all ten types and shows the same pattern
  (C prepares 2.1 commands per cell before the fire test, the careless plan 0).
- C plans for Cara and Jade are the read greedy's (`cpick`), not frozen PLANWORTH1 plans.
- Cross-play at 3 rounds only, on the six single-style cells.
- The fire-test amendment changed what C / K2 / coach prepare. Without it the rule would have rewarded lines that never fire.
  Its trial had already shown the same direction (best - careless +3.8 +-3.5 on two boxers).

## Reproduce
```
python ops/Tools/godot_slot.py run --who PLANIMPACT2 -- <godot.exe> --headless --audio-driver Dummy --path . \
  --script res://tools/planimpact2_probe.gd -- stage=<paper|cb|cbx> out=E:/FightCamp/tmp/planimpact2/<name>.jsonl ...
  paper: (no bouts)
  cb:    n=40 lens=3|6 cells=all|<ids> arms=reader:none:0,reader:coach:0,reader:coach:0.5,reader:coach:1,reader:C:0,reader:C:0.5,
         reader:C:1,reader:K2:0,reader:K2:0.5,reader:K2:1,reader:E:0,reader:E:1,reader:D2:0,reader:D2:0.5,reader:D2:1,reader:K:0,
         file:none:0,file:coach:0,file:C:0,file:K2:0
  cbx:   n=40 lens=3 fam=C,K2 strength=1 cells=presser,mover,counter,loader,fader,slow
python tools/planimpact2_sum.py ctl|ident|raised|bars <full jsonl...>;  python tools/planimpact2_sum.py x cbx_L3.jsonl
```
Bout runs: 40,000 at 3 rounds (643 s), 2 x 20,000 at 6 rounds (518 + 495 s), 14,400 cross (206 s), one Godot at a time.

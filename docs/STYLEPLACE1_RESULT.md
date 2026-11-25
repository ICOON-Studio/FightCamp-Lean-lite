# STYLEPLACE1 result - opponents fight in different places, and the plan still does not matter (S551)

Task: `ops/research/TASK_STYLEPLACE1.md`; scope `ops/research/STYLEPLACE_SCOPE_S551.md`. Levers, bars and paper count written
before any bout: `ops/research/DESIGN_STYLEPLACE1.md` (commit 81f4556; paper section 24aa500, before the trial). Probe only: nothing
under scripts/ or tests/ changed. Tools: `tools/styleplace1_probe.gd`, `tools/styleplace1_rules.gd`, `tools/styleplace1_sum.py`.
Raw runs: `E:/FightCamp/tmp/styleplace1/`.

## For the owner (wins in 100)
1. **It fails.** Opponents now fight in their own places: the Out-boxer keeps the fight at long range 56% of the time
   (was 39%), the Slugger fights chest to chest 26% of the time (was 19%), the Pressure fighter has your boxer on the ropes 22% of the time (was 15%).
   But a well-chosen plan still beats a careless one by only about **1 win** (bar: 6), and the coach's by about **2**.
2. **Nothing got rebalanced by accident** (bar 5 passed): with no plan, no boxer's results against any style moved by more than
   the dice. That is the problem as well: moving where the fight is changes almost nothing, with a plan or without one.
3. **One plan still fits nearly everyone.** The plan the corner writes is the same against 4 to 6 of the 6 styles. The file
   can name her place from one film for 3 of the 6 styles (bar: every style).
4. **Three probes now point at the same thing:** neither the plan rule nor the opponents is the cap. A plan line is worth too
   little in an exchange to swing a bout (from the code, below). The plan stays as it is. Raising its weight would be a plan-rule
   change, which the scope rules out until you decide, so the choice goes back to you.

## NOT GREEN
- Bars 1, 2 and 4 fail in every arm (lever 1, lever 2, both, both halves), for the five women AND the ten types.
- Bar 3 fails except lever 1 with the re-picked plan (3 of 5 boxers, exactly at the line and inside the dice; see Honest limits).
  With the corner's plan K2 it fails everywhere: 1-2 plans, the best against 4-6 of 6 styles.
- Bar 7 fails: with lever 1 one film names the right place for 3 of 6 styles (Slugger 64%, Volume 72%, Boxer-puncher 72%).
- Bar 8 cannot tell the arms apart: as written it passes TODAY (3-5 plans a boxer), because plans that differ by one marginal line count.
- Not run: 6-round bouts; cross play for the two half arms (both half arms fail bars 1, 2 and 4 already).

## METHOD followed
- MECHANICS NEED 8, PROBE FIRST: nothing landed in the game; nothing under scripts/ or tests/ changed.
- THE WRITTEN PLAN STAYS: nothing here proposes shrinking it.
- NO THIRD PLAN-RULE PROBE: only the opponents' tables changed; PLANIMPACT2's rule stays at strength 0 in every arm.
- ONE RULE IS NOT SOLD TWICE: the corner command grade (COACHMAP2) was not touched.
- A LEVER FOLLOWS REAL BOXING: each place and each split answer is on the design page with its real bout, before any run.
  No balancing number: full strength and half strength only, nothing tuned.
- NOT IDENTICAL FIGHTERS: the five women of PLANIMPACT2 (Lucy Jackson, Samira Khan, Tess Reilly, Cara Bello, Jade Yates) with the
  live reader corner against CORNERCMD2's ten cells, AND PLANIMPACT1's ten TELLPLAY1 types (five women, five men; men fight men) with
  the corner off through the plain bout (`BoutNight.play_out`). Every run's first line prints the population and their stats.
- One-bout trial before every table; long output to files; one Godot at a time through `godot_slot`, the watchdog before each job.

## How the tables were switched (no game file edited)
`styleplace1_rules.gd` reloads `PlanFight.gd` in memory from its own source, with GAME_CARD / LOST_CARD / ANSWERS as static vars plus
two hooks (`where_next`, `fit`, used only by the half arms). It then reloads the 15 scripts that read those tables. Found by the
self-test (`stage=check`) before any bout: a reader compiles `PlanFight.GAME_CARD` in as a constant, so a plain reload left the
coach's cards unchanged. The reload therefore rewrites each reader's `PlanFight.GAME_CARD` (and the other two) to read
`PlanFight.sp_table("GAME_CARD")`. The self-test then showed the Slugger's cards opening on inside, the load-up row splitting, and
the half coin splitting 22 / 18.

## The control (all levers off)
- CB, five women, 3 rounds: reader none / coach / C0 (PLANIMPACT1's frozen plans) / K2 / E reproduce PLANIMPACT2's lever-off arms
  bout for bout: **400 of 400 identical in the trial, 2,000 of 2,000 for the no-plan arm at 200 dice** (its first 40 dice are
  PLANIMPACT2's).
- PW, ten types: A / B58 / C0 reproduce PLANIMPACT1's `ctl` run: **2,160 of 2,160 bouts identical** (720 per arm).
- No two configs printed the same bouts (trial: lever 1 changed 12 of 400 bouts against off, lever 2 3 of 400, both 15 of 400).

## The levers as written before the run (reasons in full on the design page)
1. **A style owns a place.** Pressure fighter: losing to her press already put your boxer on the ropes, and now her press also opens
   there (she cuts the ring off: Foreman v Ali, Serrano v Taylor round 5, Cameron v Taylor II round 2). Slugger: load-up opens
   inside and stays inside (in the pocket: Tyson, Ruiz, Hatton; Holyfield and Fury answered by holding). Out-boxer: counters and
   loads up at long range (Taylor as Moore read her; Wilder, CompuTrack "From Distance 63.7%"). Boxer-puncher: loads up at long
   range (the Wilder shape). Counter-puncher (already outside) and Volume puncher (mid): no source moves them. Half = a seeded
   coin per exchange.
2. **Press and load-up stop sharing their answers** (REALPLANS_S341 s3 counts). Against press the best answers are step back, pivot
   out and 1-1 (five documented plans); slip 2-3 and roll out drop to ok. Against load-up the best answers are slip 2-3, roll out,
   tie up and 1-2 (Pacquiao, Mayweather, Ali, Fury, Holyfield); step back and 1-1 drop to ok. After the split no move is best
   against both, and every card holds a different best line.
3. **The file says where she fights**: one plain line, e.g. "Slugger: loads up big shots - chest to chest", from one film night.

## Phase 0 paper (before any bout)
A style's best plan (her top 3 cards) shares this much of its lines with the other styles: **0.94 today, 0.92 with lever 1, 0.79 with
lever 2, 0.81 with both** (the boxers' own firing lines: 0.83 / 0.81 / 0.77 / 0.78). The table moved, so the run went ahead. The page
warned before any bout: lever 1 alone hardly moves it, and lever 2 splits the styles into two groups, not six. The full 6 x 6
tables are on the design page.

## The eight bars, every arm (CB = five women, reader corner, 3 rounds, 40 dice a cell; PW = ten types, corner off, 4 rounds)
| Bar | off (today) | L1 | L1 half | L2 | L2 half | L1+2 | all on (L1+2 + file) |
|---|---|---|---|---|---|---|---|
| 1 best - careless >= 6 for 3 of 5 | +1.7 +-1.1, 0 of 5 | +0.9, 0 of 5 | +0.9, 0 of 5 | +1.2, 0 of 5 | +0.8, 0 of 5 | +1.2, 0 of 5 | as L1+2 |
| 1 (PW, 6 of 10 types) | 1 of 10 | 1 of 10 | - | 0 of 10 | - | 0 of 10 | as L1+2 |
| 2 best - coach >= 6 for 3 of 5 | +1.7 +-1.0, 0 of 5 | +2.5, 0 of 5 | +2.6, 0 of 5 | +1.6, 0 of 5 | +1.1, 0 of 5 | +2.1, 0 of 5 | as L1+2 |
| 2 (PW) | 0 of 10 | 0 of 10 | - | 0 of 10 | - | 0 of 10 | as L1+2 |
| 3 no plan best v > 3 of 6 styles, 3 of 5 (C / K2) | 1 / 0 of 5 | **3** / 0 of 5 | - | 2 / 0 of 5 | - | 0 / 0 of 5 | as L1+2 |
| 4 careless - coach <= -3 | 0.0 +-1.1 | +1.7 | +1.8 | +0.3 | +0.3 | +0.9 | as L1+2 |
| 4 (PW) | +0.4 +-0.7 | +0.9 | - | +0.8 | - | +0.7 | as L1+2 |
| 5 no plan within 3 of today (n 200 a cell) | control | pass (0 of 50 cells; mean 0.6) | pass (0.4) | pass (0.0) | pass (0.0) | pass (0.6) | pass |
| 5 (PW, A arm) | control | pass (0 of 60; 0.4) | - | pass (0.0) | - | pass (0.4) | pass |
| 6 every place >= 5%; top place a bout <= 70% | pass (min 9.9%; 0.43) | pass (7.6%; 0.57) | pass (8.3%; 0.52) | pass | pass | pass (7.6%; 0.57) | pass |
| 7 one film names her place, >= 80% every style | 4 of 6 styles | 3 of 6 | - | (no place change) | - | 3 of 6 | **FAIL** |
| 8 distinct plans a boxer over 6 styles >= 3 | 3-5 (passes today) | 4-6 | - | 4-5 | - | 4-6 (Danny Osei 2) | not discriminating |
| **Verdict** | | **FAIL** | **FAIL** | **FAIL** | **FAIL** | **FAIL** | **FAIL** |
Bar 5 decided first and every lever passed it, so no lever was dropped there. Bars 1 and 2 fail for all.

### Wins in 100, ALL five women (3 rounds, 2,000 bouts an arm)
| arm | off | L1 | L1h | L2 | L2h | L1+2 |
|---|---|---|---|---|---|---|
| reader : coach's plan | 76.2 | 74.8 | 75.0 | 75.9 | 76.2 | 75.5 |
| reader : best C (re-picked) | 77.0 | 77.1 | 77.3 | 76.8 | 76.7 | 77.2 |
| reader : corner plan K2 | 77.5 | 76.4 | 76.5 | 77.1 | 77.2 | 76.7 |
| reader : careless E | 76.2 | 76.5 | 76.7 | 76.2 | 76.5 | 76.3 |
Per boxer (+-2 SE) in `python tools/styleplace1_sum.py bars E:/FightCamp/tmp/styleplace1/full_*.jsonl`. No boxer reaches +6 on
any lever; the largest is Cara Bello +3.8 +-3.0 (best - careless, L1+2) and +4.2 +-3.0 (best - coach, L1).

### Places (no-plan arm, 10,000 bouts a config; share of exchanges)
| style | today: top place | L1: top place | own ropes today -> L1 | inside today -> L1 |
|---|---|---|---|---|
| Pressure fighter | mid 18% | own ropes 22% | 15% -> 22% | 17% -> 18% |
| Counter-puncher | long 30% | long 30% (unchanged) | 6% -> 6% | 11% -> 11% |
| Volume puncher | long 24% | long 24% (unchanged) | 11% -> 11% | 18% -> 18% |
| Boxer-puncher | long 28% | long 43% | 10% -> 5% | 14% -> 11% |
| Out-boxer | long 39% | long 56% (20% of bouts one place > 70%) | 5% -> 3% | 11% -> 9% |
| Slugger | mid 22% | inside 26% | 15% -> 9% | 19% -> 26% |
The levers do move the fight; the wins do not follow.

## Feedback loops (all inside their caps)
- Ropes: no style passes 22% of exchanges on her own ropes (stop at 50%).
- Inside: inside climbs every round in at most 22% of a style's bouts (stop at 50%); the lever lowers it for the Slugger (17% -> 13%).
- Styles do not learn: `Exchanges.next_mode` rolls from STYLE_MODES x the bout's fixed mode_bias x the place; nothing writes her
  style from a result (checked in code before the run).
- One-rep trial (Lucy Jackson, presser + loader, 40 bouts, six configs): control identical, no two configs identical.

## Why it cannot reach 6 (from the code, an estimate, not measured here)
- A plan line is worth `PlanFight.EDGE` best 9 minus her average on that card (often 3-6) in an exchange rolled on
  `Exchanges.EX_SPREAD` 66. That is about 8 more exchanges won in 100 WHEN the line fires, on its card, against the right game.
  The corner's best shout is worth 17 (`Exchanges.EDGE`), and the ropes 5 (`PlaceEdge.ROPES`).
- So moving where she fights changes which line fires, not how much a line is worth: lever 1 moved about one exchange in ten
  to another place (more for the styles it names) and the no-plan wins moved 0.6. The best plan minus a careless one stays 1-2 wins, as in PLANWORTH1 (+1.7), PLANIMPACT1 and PLANIMPACT2.
- Lever 2 cannot touch a bout with no plan (the answer table is read only for planned lines), so its bar 5 change is 0.0 by construction.

## Menu table
Not given: every arm fails bars 1 and 2, so nothing goes on a menu.

## Honest limits
- "Best plan" = the higher of C (re-picked by PLANIMPACT1's read greedy for each config, with no weapon / weakness words) and K2 per
  boxer, PLANIMPACT2's reading, which leans toward passing. It still failed.
- Bar 3 at 40 bouts a cross cell: 2 SE of a difference is about +-10 wins, more than the gap between two plans (1-2). The
  "best plan against a style" is then mostly picked by the dice, and nearly every C plan is "best" against some style. Lever 1's
  3 of 5 for C sits exactly at the line inside that noise. K2, a written rule with no dice in its choice, shows the plain picture:
  one plan for nearly every style.
- Bar 7 uses `FilmBout.build` (the game's film model) and reads the film's top game. The film rolls games with no place, so the
  line can be no better than how often one film shows her main game.
- Bar 8 as written counts plans that differ by one marginal line. It passes today, so it shows nothing here.
- Half strength: the opener of a round (`LiveRound` l.228) and the plan writers read the full style table; only the exchanges flip the coin.
- 3 rounds only for the women (PLANIMPACT2 also ran 6); the ten types at 4 (their debut). 6-round cross play not run.
- About 230,000 bouts in all, one Godot at a time; the full_L2h slice ran 742 s while another session rendered.

## Reproduce
```
G=<Godot_v4.7.2-stable_win64.exe>; O=E:/FightCamp/tmp/styleplace1
python ops/Tools/godot_slot.py run --who STYLEPLACE1 -- $G --headless --audio-driver Dummy --path . \
  --script res://tools/styleplace1_probe.gd -- stage=<stage> cfg=<off|L1|L1h|L2|L2h|L12> out=$O/<name>.jsonl ...
  check | paper                                         (no bouts)
  plans  cpf=$O/cplans_<cfg>.json                         (L1h / L2h use the L1 / L2 file: reads take the full table)
  cb     cells=all n=200 lens=3 arms=reader:none                                        -> none200_<cfg>
  cb     cells=all n=40 lens=3 cpf=... arms=reader:coach,reader:C,reader:K2,reader:E   -> full_<cfg>
  cb     cells=presser,loader boxers=0 n=40 arms=reader:none,reader:coach,reader:C0,reader:K2,reader:E -> trial_<cfg>
  cbx    n=40 cpf=...                                                                   -> cbx_<cfg>
  pw     n=20 nf=3 cpf=... arms=A,B58,C,E (off: A,B58,C0,C,E)                           -> pw_<cfg>
  film   films=200                                                                      -> film_<cfg>
python tools/styleplace1_sum.py ctl|ident|loops|bars|pw|film|play "$O/<files>*.jsonl"
```

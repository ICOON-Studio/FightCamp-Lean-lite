# COACHMAP2 result - Kalli's three changes to the coaches, probed (S551)

## NOT GREEN
- **Bar 1 fails in every arm, the changes included.** "A pro on the roster -> the known name, else the film-room coach" is the best
  hire, or within 10 lines of it, in 100 of 100 gyms with all three changes on (1 of 100 needed 30). Chemistry on the hire card
  did not make a second axis.
- **Bar 3 fails in every arm.** The card hired predicts the raise answer in 88-90% of gyms and the style push in 84-90%
  (80% allowed). With every change on, "match" wins the raise in 88 of 100 gyms.
- **Bar 4 fails with change 1 on.** The live corner, the reader calling, against the tactician F at chemistry 0: the bonded Reid
  (+0.5) is the better corner in only 20% (3 rounds) and 22% (6 rounds) of boxer x cell units, and in none past 2 SE. The
  season's own count: tactician 79-85%, bonded 15-20%.
- **Bar 7b fails: Kalli's cap is out of reach.** The best simmed coach beats the worst by only +0.8 +-1.2 (3 rounds) and
  +1.9 +-1.5 (6 rounds); 4 to 8 was needed. No rating rule on the FILE coach's two jobs can reach 4 at 3 rounds: the whole of
  those two jobs is FILE - BLIND = +2.6 (CORNERBASE1).
- **Bar 6 fails for the limit alone (C2):** the week plan changes in a quarter of the weeks in only 4 of 10 gyms (5 needed). With
  all three on, it bites in 55 of 100 gyms. The trap check cannot be separated there (s5, bar 6).
- **Control, an honest note:** cells 6-10 of the control match COACHDEEP9's full run to 0.07-0.15 lines, not exactly. The cause is
  proven below: a game cache that depends on run order. It is not the probe.
- Not run (as the design said): PLANIMPACT2's rule together with change 1 (it failed); the course as a call; per-year cash
  (only the two-year end; the stop read that).

## For the owner (four lines)
1. **Cut back to today's two hire cards.** None of Kalli's three changes lifts coaches to 8. The hire stays one fact: a pro
   means the known name, otherwise the film-room coach. That holds in 100 of 100 gyms, with the word on the card and ten
   different rosters per gym type.
2. **The corner coach does not change a fight.** When you call it live, the best coach only avoids a cost (he reads the clue as
   well as you do today). A weak one costs 2 or 3 wins in 100. The coach your boxer likes adds half a win.
3. **When you sim, his ratings buy 1 or 2 wins in 100, not 4 to 8.** Resting her when tired and "hands up" when hurt are worth
   3 to 6 wins in total, and any coach does most of it.
4. **The limit of two boxers a coach changes the week in about half the gyms, but it never changes who to hire.** It is your call:
   keep coaches as these changes make them, or cut back to the two hire cards. Nothing is removed until you say.

## METHOD followed
- MECHANICS NEED 8, PROBE FIRST: a greybox on COACHDEEP9's season harness and CORNERBASE1's real bout; nothing under scripts/ or
  tests/ changed; nothing lands in the game.
- The rules, the stack with PLANIMPACT2 and the eight bars were committed before any run: `ops/research/DESIGN_COACHMAP2.md`
  (c72f723). No number was moved after a run. One arm at the strength written, one at half (C1H; the half bout arms).
- ONE RULE IS NOT SOLD TWICE (design s1): PLANIMPACT2 failed, so the plan raises nothing. Change 1 scales how much of a call
  she hears, not her grade: x1.2 at the largest bond, under the x2 of one grade step. Its exchanges with a multiplier over 1:
  only the bonded arms (x1.20, x1.10 at half).
- Code read first (design s0). Chemistry is one-way, confirmed: `R.chemistry` reads traits only; the bond is weeks together.
- NOT IDENTICAL FIGHTERS: in the season, the TEST CLUB (Lucy Out-boxer temper 72, Kira Out-boxer 30, Josh Pressure fighter 35,
  Ana no-gi 34) plus 9 trait redraws (+-25 on temper, heart, discipline, confidence, coachability) for 10 rosters a gym type. In
  the bouts, CORNERBASE1's five women (Lucy Jackson, Samira Khan, Tess Reilly, Cara Bello raw, Jade Yates all-round) against its
  ten opponent cells.
- Prior research: change 1 follows COACHDEEP9 s7 (a)-(d) and CORNERBASE1's FILE coach (`docs/CORNERBASE1_RESULT.md`); change 2
  is Kalli's (`CRITIC_COACHMAP1_BRIEF_KALLI.md`); change 3 is her "bars that pass while the mechanic is shallow".

## The control
- **Bouts: PASS, bout for bout.** With change 1 off, the `reader` and `file` arms equal CORNERBASE1's `reader_nr` and `file`.
  At 3 rounds 100 of 100 boxer x cell rows are identical over the first 40 bouts; at 6 rounds also 100 of 100.
- **Seasons: PASS, with the run-order note.** With every switch off, `stage=ctrl` runs COACHDEEP9's own `_cell` and `_career`.
  The probe's overrides (`_assign`, `_bout`, `_gain`) hand straight to COACHDEEP9's code.
  - Cells 1-5 (one process): 85 of 85 arm lines are identical to COACHDEEP9's `full.txt`.
  - Cells 6-10 (a second process, kept under the 20-minute slice): 19 of 85 are identical. The rest are within 0.15 lines
    (scores are 200-400).
  - The cause: `BoutRead.round_edges` caches its read by `RingDuel.stat_bucket(f)` (`scripts/rules/BoutRead.gd` l.298-310).
    The first boxer to land in a bucket sets the read for every later boxer in it, so a cell's numbers depend on which cells ran
    before it in the same process. COACHDEEP9 ran all ten cells in one 32-minute process.
  - Proof: COACHDEEP9's own `tools/coachdeep9.gd`, unmodified, on `big_title` in a fresh process equals my control 17 of 17 arm
    lines. It equals its own `full.txt` in only 9 of 17 (largest gap 0.07 lines).
  - The one-rep trial also matched COACHDEEP9's `trial2.txt` (34 of 34 lines).
- Trial stops: no arm with a change on printed BASE's seasons, except C3 in the two trial gyms. Its word pick chose the same card
  as the blind pick there. Over all 100 gyms the word pick differs in 15 (S -> F 10, K -> F 5), so C3 is wired. The run went on.

## The rules as written before the run (design page s2-s4, short)
1. **The corner coach is wired.** The clue line is right with chance 0.4 + 0.03 x tactics (F 0.91, YOU 0.64; a wrong clue is
   another game of the opponent's style). Hearing is x (1 + 0.4 x chemistry), x 0.85 when warned; a clash pair hears nothing in
   round 2. The cutman sets the second's recover points (1 / 2 / 3 at cutman 1-7 / 8-13 / 14+; head first if hurt, then water).
   Simmed, the FILE coach calls rest with chance conditioning / 20 and hands up with chance cutman / 20, and reads the file
   right with chance tactics x 5 / 100. In the season, every coach gets Reid's call price plus his measured live difference to
   Reid (the table below, by chemistry), so Reid at chemistry 0 plays exactly as COACHDEEP9.
2. **The limit.** A coach is the main coach of at most 2 boxers, 3 at teaching 15+ (M); the owner and the mat coach count too.
3. **Harder bars.** 10 rosters a gym type. The careful owner hires the affordable card with the highest "X more a season" line
   (`_gain`, which reads chemistry and the corner). The careless owner hires blind (the mean of the ratings) and never unpairs a
   clash.
The S548 cuts are in every arm but CTRL: no trial week, the falling-out by the rule, the word from week 0.

## The eight bars, each arm
Gyms: 10 cells (TEST CLUB) for CTRL..C2, 10 x 10 rosters for C3 and ALL. Reps: 100 (CTRL), 40 (BASE..C2), 10 a roster (C3, ALL).

| Bar | CTRL | BASE (MAP1) | C1 | C1H (half) | C2 | C3 | ALL |
|---|---|---|---|---|---|---|---|
| 1 one-fact hire loses >= 10 to the best | FAIL 0 of 10 | FAIL 0 of 10 | FAIL 0 of 10 | FAIL 0 of 10 | FAIL 0 of 10 | FAIL 0 of 100 | **FAIL 1 of 100** |
| 2 known name pays with a pro, not without | PASS 6/6, 4/4 | PASS | PASS (none -14.3) | PASS | PASS | PASS 59/60, 40/40 | **PASS 59/60, 40/40** (none -4.2) |
| 3 no single fact > 80% (raise / push) | FAIL card 90 / 90 | FAIL 90 / 90 | FAIL 90 / 90 | FAIL 90 / 90 | FAIL 100 / 90 (match always) | FAIL 89 / 84 | **FAIL 88 / 84** |
| 4 corner: tactician and bonded each >= 25% | season 45 / 55 | season 45 / 55 | **bout 48 / 20 (3 rds), 48 / 22 (6)** FAIL; season 84 / 16 | bout 40 / 22, 30 / 30 (noise, see s4); season 85 / 15 FAIL | season 43 / 57 | season 54 / 46 | **FAIL** bout as C1; season 79 / 20 |
| 5 careless loses, careful not | PASS 5 / 0 | PASS 5 / 0 | PASS 5 / 0 | PASS 5 / 0 | PASS 5 / 0 | PASS 54 / 0 | **PASS 61 / 0** |
| 6 the limit bites, no trap | - | - | - | - | FAIL bite 4 of 10; no trap | - | **bite PASS 55 of 100**; trap not separable |
| 7 nothing runs away; 7a live over simmed +6..+15; 7b simmed best - worst 4..8 | PASS (7a/b n/a) | PASS | PASS; 7a PASS; **7b FAIL** | PASS; 7b n/a | PASS | PASS | **PASS; 7a PASS; 7b FAIL** |
| 8 play (report) | 3.5 pop-ups a season | 3.5 | 3.5; why lines 7% / 12% | 3.5 | 3.4 | 3.5 | **3.5 a season (100 of 100 gyms in 2-4); why lines 7.4% (3 rds) / 12.0% (6 rds)** |
| **Passed (of the bars that apply; 8 is a report)** | 4 of 6 | 4 of 6 | 2 of 6 | 2 of 6 | 4 of 7 | 4 of 6 | **3 of 7 - FAIL: bars 1, 3, 4, 7b** |

### Bar 1 - why the hire stays one fact (per cell, ALL; lines over two years, the mean of 10 rosters)
| cell | NOHIRE | L | M | S | F | K | careful pick | careless |
|---|---|---|---|---|---|---|---|---|
| small_am | 236.7 | 243.1 | 256.0 | 247.3 | **268.5** | 231.7 | 268.5 (F 10) | 269.8 |
| big_am | 262.1 | 278.2 | 298.2 | 281.9 | **302.8** | 260.1 | 281.9 (S 10) | 271.6 |
| small_pro | 321.5 | 320.5 | 324.5 | 321.1 | 336.9 | **349.5** | 349.5 (K 10) | 321.0 |
| big_pro | 347.0 | 356.6 | 368.0 | 357.0 | 372.7 | **385.3** | 385.3 (K 10) | 348.7 |
| small_title | 315.2 | 316.4 | 321.8 | 318.4 | 332.8 | **353.2** | 353.2 (K 10) | 314.8 |
| big_title | 340.7 | 352.6 | 365.3 | 354.3 | 368.6 | **389.1** | 368.6 (F 10) | 347.0 |
| small_novice | -33.9 | -20.6 | -23.0 | -15.9 | **2.7** | -39.4 | -15.9 (S 10) | -15.6 |
| big_hot | 157.1 | 165.8 | 172.6 | 168.0 | **200.1** | 152.7 | 168.0 (S 10) | 174.5 |
| small_pro_hot | 216.8 | 213.9 | 209.6 | 214.3 | **233.2** | 230.3 | 233.2 (F 10) | 230.2 |
| big_title_mix | 240.2 | 252.2 | 263.8 | 255.4 | 268.8 | **290.2** | 268.8 (F 10) | 267.7 |
Why, from the cards: F (temper 4, patience 16) clashes with nobody on any roster, and K's name fee (+26 to +36 with a pro)
outweighs his clash with a hot-tempered pro. The redrawn rosters move chemistry, but they never make the best card on paper the
wrong hire. The one cell where a hot pro tips it (small_pro_hot) goes to F, which the one-fact rule's "pro -> K" misses by only
3.4 lines on the mean (1 gym of 10 past 10). The careful owner's word pick takes S in five cells where F is better: the card's
"X more" line rates S's training, not the season (so careful - best is up to -32 lines in big_hot). Bar 5 still passes, because
the careless owner loses people.

### Bar 3 - the moments follow the card
The raise: "match" is best in 88 of 100 gyms with all changes on (36 in C3 without change 1). Change 1 makes F's and K's corner
worth more than Reid's, so keeping them pays. The push: allow 56 / refuse 44, but the hired card alone predicts 84%. Pro, size,
temper and the word each predict 56-65%.

## The bout probe (change 1), wins in 100, five boxers x ten cells, 40 bouts each (2,000 an arm)
| arm | 3 rounds | 6 rounds | clue wrong (3 / 6) |
|---|---|---|---|
| reader (off; today's live corner) | 76.2 | 77.8 | 0 |
| live YOU (tactics 8) / L (8) / M (9) | 73.7 / 73.7 / 73.8 | 76.0 / 76.0 / 76.2 | 30% / 22% |
| live REID (11) / S (13) | 74.3 / 75.2 | 75.8 / 76.8 | 22% / 16%, 17% / 13% |
| live F (17) / K (16) | 76.3 / 76.5 | 77.7 / 77.1 | 7% / 5%, 10% / 7% |
| live REID bond +0.5 / clash -0.5 / warned | 74.8 / 73.0 / 73.7 | 76.3 / 75.8 / 76.0 | - |
| live K clash -0.5 | 74.8 | 76.2 | - |
| file (off; CORNERBASE1's FILE coach) | 66.2 | 66.2 | - |
| sim YOU / REID / L / M / S / F / K | 66.4 / 66.3 / 66.5 / 66.2 / 65.8 / 65.7 / 65.7 | 64.5 / 64.6 / 65.3 / 65.9 / 64.5 / 64.0 / 65.1 | - |
| half: live F / live Reid bond / sim YOU / sim K | 76.4 / 75.8 / 65.8 / 65.4 | 77.8 / 77.5 / 65.9 / 66.0 | - |
Paired against off (+-2 SE): live YOU -2.6 +-1.2, Reid -1.9, F +0.1 +-0.8, K +0.2 (3 rounds); -1.9, -2.0, -0.2, -0.8 (6 rounds).
- **Why the corner pick fails (bar 4):** the clue is the only part of change 1 that moves wins. Today's reader always reads the clue
  right, so a coach's tactics can only take wins away: F costs nothing, a tactics-8 coach about 2.6. The bond's x1.2 hearing buys
  +0.5 (Reid 74.3 -> 74.8), less than F's clue edge over Reid (+2.0). So the tactician is the better corner in about half the
  units, the bonded coach in a fifth, and the rest are ties. At half strength the 6-round count reads 30 / 30, but every gap
  there is inside 2 SE: a coin flip on near-zero differences. That is exactly how the bar can pass while the mechanic is shallow.
- **Why the recover points do nothing visible:** every coach gets 1-3 points in nearly every corner (3,700-8,400 corners an arm).
  Live F with 2 points ends level with the reader with none (+0.1 / -0.2). Water is +3 energy a point when she is fresh and +6
  under 40, small against the round's spend.
- **Why the simmed cap fails (bar 7b):** a rated coach rests her in 6-15% of corners at 3 rounds (FILE 24%) and 17-35% at 6
  (FILE 42%), and the arms land within 2 wins of each other. CORNERBASE1 put the whole of the two jobs at FILE - BLIND = +2.6 /
  +6.2. At 3 rounds the cap's floor of 4 is above what perfect against never-doing-it can give.
- **Bar 7a passes:** live over the same coach simmed is +7.2 to +10.8 (3 rounds) and +10.3 to +13.6 (6 rounds).
- **Bar 8 (why lines):** 7.4% (3 rounds) and 12.0% (6 rounds) of bouts end differently with change 1 on. A result line could
  credit or blame the coach in about 1 bout in 10.

## Feedback loops (task)
- Change 1: no gym's best-coach cash reached twice the median's at year two (cash stop not fired in any arm); wins and cash are
  printed for two years, not per year (an honest limit).
- Change 1 + PLANIMPACT2: not stacked (design s1); the share of exchanges with hearing over x1 is the bonded arms only.
- Change 2: no gym lost more than 2 coaches in two years in any arm (the stop did not fire). The careful owner loses 0 people in
  every gym; the careless owner loses a person in 54-61 of 100.
- Chemistry is one-way (code read, design s0).
- One-rep trial: done (two cells, two rosters, all arms; two years, as COACHDEEP9's careers have a fixed 104 weeks). Stops:
  above.

## Menu table
Not given: bars 1, 3, 4 and 7b fail, so nothing goes on a menu.

## What would have to change (not built; for whoever picks this up)
- For the corner pick to be a choice, the bond must buy what the clue costs. Today the bond is x1.2 of a call (+0.5 wins) and a
  tactics gap is up to 2.6 wins. Or the clue must not be today's perfect reader at the top. Either is a new rule and a new probe.
- For the hire to be more than one fact, a card must lose with the roster, not with the gym type. With these cards F never clashes
  and K's fee dwarfs any clash. The cards' traits (not the rules) decide that.
- The simmed cap cannot be met at 3 rounds by rating the FILE coach's two jobs; it needs a simmed corner worth more than +2.6 in
  the first place.
Next, if this had passed (named in the task, not in this probe): merging the rival's offer into the raise, contract length, coaches
who grow, film and weight wiring.

## Honest limits
- The season's change 1 is the bout probe's mean difference by coach (five women, ten cells) added to COACHDEEP9's read. The season's
  boxers (TEST CLUB) are not the bout probe's women. Chemistry is linear between Reid at +0.5 and -0.5.
- C1H in the season scales the full table by 0.5; the bout half arms show it is roughly so (3 rounds, against the reader: F +0.1 full v +0.1 half; Reid bond -1.5 full v -0.5 half).
- Bar 6's trap needs a no-limit arm with the same rosters and change 1. ALL against BASE flags S in 4 small_pro_hot rosters (from
  +4.6 to -3.1..-6.9 over NOHIRE), but three changes move at once there. The limit alone (C2 against BASE) has no trap.
- Bar 3's facts on 10 gyms are coarse: the card hired has 3 values on 10 cells, so 90% is easy. On 100 gyms it is still 84-89%.
- The probe's careful hire reads the card's "X more a season" line, which rates training and the corner, not wages or fees. It
  takes S where F is better in five cells.
- The control's cells 6-10 match COACHDEEP9 to 0.15 lines, not to the digit (the cache, proven above).
- The recover points are placed by a fixed rule (head if hurt, else water). In the game the player places 3 points with no coach;
  change 1 as written would give most coaches fewer than that.

## Reproduce
Raw (outside the repo): `E:/FightCamp/tmp/coachmap2/` - corner_L3, corner_L6a/b, dtab.json, season_ctrl_a/b, season_base, c1,
c1h, c2, c3_a/b, all_a/b, trial_*, proof_cd9_big_title, sum_corner.md, sum_season.md.
```
python ops/Tools/godot_slot.py run --who COACHMAP2 -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/coachmap2.gd -- <args>
  bouts:   stage=corner lens=3 n=40 cells=all arms=all            (and lens=6 in two halves of five cells)
  control: stage=ctrl reps=100 cells=<five cells>                 (COACHDEEP9 unchanged)
  arms:    stage=season reps=40 rosters=1 c1=0|1|0.5 limit=0|1 c3=0 dtab=<dtab.json>
           stage=season reps=10 rosters=10 c3=1 [c1=1 limit=1 dtab=<dtab.json>] cells=<five cells>
python tools/coachmap2_sum.py cornerctl <CORNERBASE1 full_L3.jsonl> -- <corner_L3.txt>;  ... ctl <COACHDEEP9 full.txt> <ctrl outputs>
python tools/coachmap2_sum.py dtab dtab.json <corner outputs>;  ... corner <corner outputs>;  ... season <NAME> <outputs> [--base <BASE>]
```
Runs: 96,000 bouts (15 + 14 + 14 min); 10 season slices (8.8-20.5 min each), one Godot at a time, watchdog GREEN before each.

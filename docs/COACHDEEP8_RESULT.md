# COACHDEEP8 - coaches v8 (v7 + the three changes its probe named): the greybox probe (S543)

Task: `ops/research/TASK_COACHDEEP8.md`. Map: `ops/research/DESIGN_COACHDEEP8.md` (v7's map whole, changes marked "v8:"; bars s10
= v7's, committed before any run, edd9cea). Probe: `tools/coachdeep8.gd` + `tools/coachdeep8_rules.gd`, copies of v7's with the three
changes (v7's files untouched), summary `tools/coachdeep8_sum.py`. Nothing under scripts/ or tests/ changed.
Raw (outside the repo): E:/FightCamp/tmp/coachdeep8/ - trial.txt + trial_sum.txt (one rep, printed in full), full.txt + full_sum.txt.
All runs through `godot_slot.py --who COACHDEEP8`, one at a time, headless, Dummy audio, watchdog first (about 90 min of waiting before
the first run: memory RED/AMBER with ArcheAge open). Full run: 100 careers a cell per arm, 17 arms (v7's 15 + two cost-off control
arms), 10 cells = 17,000 careers, 29 min, 0 script errors.

## 1. Verdict: FAIL - 4 of 7 (bars 1, 2, 3 fail; 4, 5, 6, 7 pass)
Stop here (FAIL): no critic brief, nothing queued for kalli or dola, no code-checked critic owed yet.

| Bar | Needed | v7 (full run) | v8 (full run, 100 reps) | |
|---|---|---|---|---|
| (1) no hire best in > 6 of 10 | <= 6 | M 7, L 3 - FAIL | **L 7**, K 3 | FAIL |
| (2) K > NOHIRE by > 2 SE with a pro / title boxer; not above +2 SE without | 6 + 4 cells | all ten right - PASS | pro/title +29.1, +39.4, +40.7, +51.0, +9.2, +53.2 (all > 2 SE); without -1.0, **big_am +5.9 +- 2.1**, -31.8, -44.8 | FAIL (big_am) |
| (3) no answer best in > 6 of 10, each moment | <= 6 | fall back-coach 7; push refuse 7 - FAIL | falling-out **back the coach 8**, back the boxer 1, split 1; raise match 5, refuse 5; style push **refuse 8**, allow 2 | FAIL |
| (4) corner: tactician right >= 25%, bonded >= 25% | both | 57% / 43% - PASS | tactician 38%, bonded 62% (1,383 differing fights a career-set) | PASS |
| (5) careless loses someone in >= 2 cells; careful in <= 1 | both | careless 5, careful 2 - FAIL | careless 5 cells; **careful 0** | PASS |
| (6) trial week right (> +2 SE) in >= 2, wrong (< 0) in >= 2 | both | right 5, wrong 5 - PASS | right 4 (big_am +35.7, small_pro +2.8, big_title +4.9, big_hot +35.8), wrong 6 | PASS |
| (7) nothing runs away | all | PASS | members = catchment in every arm; cash -$26,488 to +$121,927; 0 months with two moments; bond max 0.25; chemistry max 0.72; longest run of loss-months 1 | PASS |

Change 3 fixed bar 5 (the careful line now keeps the solid coach S: it reads "the boxers win about X more a season" at his raise).
Change 2 moved bar 1 from M to L: the cheap local is now the superset. Change 1 made a standing warning cost real money (one
warning on Reid costs the no-hire club ~26 lines) but did not separate the falling-out's answers, and it broke bar 2 through the
careful line's own push refusals (s4).

## 2. The ten cells (population named in the output, as v7)
TEST CLUB (TestClub.make on Career.quick_start, seed 5391): Lucy (women's lightweight, Out-boxer, 21, temper 72), Kira (women's
featherweight, Out-boxer, 18), Josh (men's welterweight, Pressure fighter, 23), Ana (no-gi, Counter-puncher, 22). Each boxes her or his
own sex and class. Cells as v7 (map s10). Hire options: NOHIRE (you + Reid) and L ($200), M (**$450**, was $250), S ($550), F ($480),
K ($1,000); a $150 sessional mat coach comes with Ana.
The cards' two lines at the start (pays for itself at about N members; v8: the boxers win about X more a season with this coach):
| Card | N | X small_am | X small_pro | X small_novice | X big_hot |
|---|---|---|---|---|---|
| L local pressure $200 | 24 | 1.02 | 0.66 | 1.31 | 0.81 |
| M two-art $450 | 48 | 2.87 | 2.63 | 1.76 | 1.57 |
| S solid engine room $550 | 60 | 1.23 | 0.73 | 1.42 | 0.92 |
| F solid film room $480 | 60 | 2.26 | 1.83 | 2.51 | 2.35 |
| K known name $1,000 | never on members | 1.99 | 1.48 | 2.19 | 1.65 |

## 3. Score by cell (lines over two years; v7's score)
| Cell | NOHIRE | L | M | S | F | K | best | K-NOHIRE | trial-blind (fav -> alt) |
|---|---|---|---|---|---|---|---|---|---|
| small_am | 243.6 | **290.0** | 266.6 | 253.8 | 254.9 | 242.6 | L | -1.0 +- 2.2 | -23.7 +- 1.2 (L -> M) |
| big_am | 269.0 | **324.4** | 307.4 | 288.2 | 289.3 | 275.0 | L | **+5.9 +- 2.1** | +35.7 +- 0.6 (S -> L) |
| small_pro | 327.1 | **360.1** | 345.6 | 321.6 | 330.0 | 356.2 | L | +29.1 +- 0.9 | +2.8 +- 0.8 (K -> L) |
| big_pro | 352.6 | **395.7** | 387.3 | 357.2 | 365.8 | 392.0 | L | +39.4 +- 0.9 | -27.2 +- 0.9 (K -> F) |
| small_title | 319.8 | 356.4 | 338.6 | 317.8 | 323.3 | **360.5** | K | +40.7 +- 1.2 | -38.2 +- 1.2 (K -> F) |
| big_title | 345.3 | 392.1 | 380.2 | 353.6 | 359.0 | **396.3** | K | +51.0 +- 1.2 | +4.9 +- 0.7 (S -> F) |
| small_novice | 10.3 | **32.5** | 9.4 | -6.8 | 16.3 | -21.5 | L | -31.8 +- 1.6 | -23.3 +- 1.0 (L -> M) |
| big_hot | 166.7 | **204.9** | 185.5 | 168.5 | 188.2 | 121.9 | L | -44.8 +- 0.2 | +35.8 +- 0.1 (S -> L) |
| small_pro_hot | 224.4 | **252.0** | 229.9 | 215.5 | 227.6 | 233.6 | L | +9.2 +- 0.7 | -22.3 +- 0.4 (L -> M) |
| big_title_mix | 243.8 | 292.9 | 281.0 | 254.3 | 260.6 | **297.0** | K | +53.2 +- 1.3 | -0.5 +- 0.0 (F -> L) |
The L arm is the same number as in v7 in every cell (no warning ever stands in it); every arm where a warning stands moved.
Name fees in the K arm: $41.6k-$47.9k in the pro / title cells, $0 without (loop 2, as v7).

## 4. Forced moments (bar 3), every answer from the same state, the careful line after
| Cell | falling-out: coach / boxer / split | raise: match / refuse | push: allow / refuse |
|---|---|---|---|
| small_am | 287.6 / **288.3** / 279.2 | 287.5 / **289.0** | 286.5 / **288.6** |
| big_am | **286.2** / 284.8 / 271.5 | **287.5** / 280.3 | 284.8 / **287.4** |
| small_pro | **354.1** / 352.8 / 344.0 | **356.1** / 332.6 | 352.7 / **356.1** |
| big_pro | **389.9** / 388.6 / 375.2 | **391.9** / 364.3 | 388.5 / **391.9** |
| small_title | **358.4** / 357.1 / 348.2 | **359.8** / 334.8 | 357.0 / **360.4** |
| big_title | **351.5** / 350.0 / 336.8 | **353.0** / 349.0 | 350.0 / **353.2** |
| small_novice | 30.2 / 30.6 / **46.5** | 30.1 / **31.1** | **34.8** / 31.5 |
| big_hot | **166.3** / 158.8 / 164.7 | 166.2 / **168.0** | 166.3 / **168.5** |
| small_pro_hot | **249.8** / 245.5 / 244.3 | 249.6 / **252.0** | 249.1 / **252.0** |
| big_title_mix | **257.4** / 257.1 / 254.9 | 254.5 / **258.5** | **272.2** / 256.7 |
The raise stays a real call (5 / 5). The falling-out's two backing answers now differ by 0.3-1.5 lines (v7 0.5-2.2), and by 4-8 in
the two hot cells, where backing the boxer is now clearly worse. The forced falling-out lands on the same pair in most cells
(Reid and Kira at week 26), so the cost of her season against the cost of his decides it the same way almost everywhere.

## 5. Feedback loops (task "Feedback loops"; map s13 + v8 loops 7-9) and the trial
- NEW loop 7 (a warned boxer loses more, nearer the line): people who left while carrying a warning, cost on / cost off (control
  arms): careless 0.00 / 0.00 in eight cells, 0.01 / 0.01 small_title, 0.04 / 0.04 big_hot, 0.03 / 0.03 small_pro_hot; careful 0 / 0
  everywhere. The cost never changed who leaves - it changed the score (careless v careless-off: -4.5 lines in small_pro and big_pro,
  -4.0 small_title, -5.7 big_hot, -1.6 small_pro_hot; careful v careful-off: -6.5 big_hot, -3.7 small_pro_hot, -0.4 big_title_mix,
  0 elsewhere). STOP rules: careless worst cell 1.00 people a career (not over 2); careful lost 0.00 over the ten cells v v7's 1.69.
  Neither fired.
- NEW loop 8 (a warned coach -> his boxers win less -> no raise moment): no loop back; the raise needs three straight wins.
- Changes 2 and 3 feed nothing back (a price, a printed line).
- v7's loops 1-6 (full_sum.txt): members at the catchment in every arm (66 small / 96 big), never above; class nights run v wanted as
  v7; name fees capped ($4,000 a bout binds in the title cells, $47.9k); bond max 0.25 (cap), chemistry max 0.72; longest run of
  months with a person lost 1 (never a cascade); one push a boxer a season; courses stop at the ceiling.
- ONE-REP TRIAL (printed in full): 6 of 7 at one rep (bars 1, 2, 4, 5, 6, 7 passed; bar 3 failed, as in v7). No trial stop rule fired:
  the best hire differed by cell (L / K / M), people were lost (S, K), no v7 bar that passed failed in the trial.
- TUNED: nothing. The sizes stayed at the task's starting estimates (boxer learning -10%, corner uptake -15%, morale -0.5 a week;
  coach ratings -10%; fade 26 weeks; M $450). Reason: the trial's falling-out gaps were 0.1-0.4 lines at one rep, too small to tune
  on without fitting noise, and scaling the boxer's or the coach's cost moves every near-tie the same way (it cannot spread the
  answer across cells). The full run is the verdict.

## 6. Carried from v7: the game's win read ignores the corner coach (for the build, step 5 - the corner pick)
Opened today (`scripts/rules/BoutRead.gd`):
- `BoutRead.chance(f, opp, camp, coach := 0.0)` (line 384) passes `coach` to `round_edges` (313) -> `_round_edges` (322) ->
  `_read_copy(f, opp, camp, coach)` (255). There the coach is used ONCE, line 272-273: `if fx["arrows"] is empty: fx["arrows"] =
  CoachPlan.write(opp style, coach, ...)` - the coach's rating only sets how many plan arrows a boxer with NO plan gets
  (`CoachPlan.reads(rating)` counts the READ_AT steps). A boxer who already has a plan (every boxer the game books) drops the coach
  argument here. (`round_edges` also puts `coach` in its cache key, line 310, so the key changes while the number does not.)
- The between-round calls never see a corner coach: `_call(f, n)` (219) is `BoutRules.auto_corner(f["stats"])` - "the corner's plan
  when nobody works the corner" (her technique v power: "long" or "body") - and the uptake of the call in `_game_edge_of` (235-236)
  reads HER coachability (the local variable is even named `coach`) x `FighterProfile.trust(f)`: no coach rating, no tactics, no
  chemistry.
- WHAT THE CORNER PICK MUST WIRE (build step 5): (a) `_call(f, n)` must take the picked coach's call (his tactics deciding best / ok /
  wrong against the opponent's game, as `Exchanges.EDGE` prices them; the probe's `corner_edge`), not `auto_corner`; (b) the uptake
  in `_game_edge_of` must multiply by the pair's listen (1 + 0.4 x chemistry) and, in v8, by a warned boxer's 0.85; a clash ignores
  one call; (c) the coach argument must reach the read even when the boxer has a plan (a dict {tactics, playbook fit, chemistry}
  instead of one float), and the cache key must carry it; (d) the corner coach's cutman and weight ratings reach the weigh-in miss
  chance. Until then the "about X%" line on the corner pick shows the same number for every coach.

## 7. Why each failed bar fails, and the one change for each (no further design round in this task)
- **Bar 1 (L best in 7):** with M priced as a solid coach, L ($200) is the superset: teaching 14 (the class pull, which drives
  members and dues - the score's biggest part), motivation 14, loyalty 15, a mean of 11.1 against S's 12.0 at $550. L wins every
  cell without a title boxer, K the three title cells. ONE CHANGE (grill Q17 "wages scale with ratings"): one wage rule for every
  card - the band from the ratings that pay (teaching and pads first), so the best class teacher in the town is never the
  cheapest card; L's wage moves to the solid band or his teaching to the local band's 8-11.
- **Bar 2 (big_am, K +5.9 +- 2.1 without a pro):** K did not gain; NOHIRE fell (295.1 -> 269.0). With you + Reid only, the careful
  line (map s12) refuses Reid's style push on Josh (he is 23) twice in a career, so Reid - the club's only real coach - works 10%
  worse for about half the two years, on every boxer. ONE CHANGE (map s12, inside interview 3): the careful line reads WHO would
  carry the warning: allow a push from the coach who coaches most of the club (refusing costs all his boxers a season), refuse only
  a coach with few boxers.
- **Bar 3 (falling-out back the coach 8; style push refuse 8):** the standing warning now costs, but at the falling-out the two
  costs are about the same size (one boxer's season of -10% learning against one coach's -10% ratings, which the careful "change"
  then moves off her anyway), and refusing a push still costs less than two shaky bouts and a style restart. No leaving changed
  (cost on = cost off in every cell). ONE CHANGE (interview 15 "two warnings", interview 3): a standing warning also drains
  LOYALTY while it stands (about -1 a week until it fades), so it walks the person toward the 25 line: then the answer depends on
  who sits lower against the line (shown on the pop-up) - back the boxer whose loyalty is low, back the coach whose loyalty is low,
  and refusing a push to a low-loyalty coach (S 50, K 30, F 60 at signing) risks losing him. That ties the cost to the person and
  the cell, which a flat size cannot.
The change I would make first: bar 3's (a warning drains loyalty while it stands) - it is the only one of the three that makes the
moments depend on the people in the cell. Bar 1 is a card price; bar 2 is the probe's careful line reading its own warning.

## 8. Decided in this task (no questions asked)
- The three changes at the task's starting sizes, untuned (s5). M at $450 (band top $600 for a raise).
- The results line X: a season (26 weeks) of his full weeks against training alone, then her chance with those stats and his
  corner calls against today's stats and no corner (BoutRead.round_edges + Exchanges.EDGE, as the corner pick), x her bouts a season
  (amateur 6.5, pro 26/8, champion 26/12); a no-gi fighter by `bjj_chance`. The careful line matches a raise when the members' worth
  plus X x a win's worth on the score (swing lines x $1,000 / 26 weeks) covers the raised wage. The blind hire pick stays v7's
  (members line only), as the task asked only the raise to read both lines.
- Two control arms (CARELESS_OFF, CAREFUL_OFF: the fav hire, the warning's cost off, the fade kept) so cost on v off differs in
  the cost alone.
- A warned boxer's morale cut is -0.5 a week (the task's "morale down a little"); two warnings cost no more than one; a second
  warning never fades.
- To stay under 500 lines, v7's `_chance` and `_lift` moved unchanged into the rules file (`chance`, `shift`); blank lines cut.

## 9. Honest limits
- Greybox: v7's limits stand (pro opponents from the top of the rival list, rank moves +1/-2, the 3-round read for a pro card, the
  corner priced by the probe because the game's read ignores the coach, s6).
- X is the probe's estimate of the game's gain, not a number the game computes today; the build must write it from the same rules.
- Common bout dice across arms make small differences between answers systematic rather than noisy; a 0.3-line win is still a
  "best" under the bar's tie rule (ties only within 0.01).
- The trial's one rep cannot resolve the falling-out's sub-line gaps; nothing was tuned on it.

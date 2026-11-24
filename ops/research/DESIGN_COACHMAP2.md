# DESIGN_COACHMAP2 - coaches: Kalli's three changes, written before any run (S551)

Task: `ops/research/TASK_COACHMAP2.md`. Base page: `ops/research/DESIGN_COACHMAP1.md` (no trial week, chemistry on the hire card,
the falling-out played by the rule "the gym backs the coach"). Critic: `ops/research/CRITIC_COACHMAP1_BRIEF_KALLI.md` (depth 5,
play 5, general 6). Probe only: `tools/coachmap2.gd`, `tools/coachmap2_rules.gd`, `tools/coachmap2_sum.py`. Nothing under
scripts/ or tests/ changes. Every number below is an ESTIMATE written before the run. None is tuned after it.

## 0. Code read first (what the rules plug into)
- The season harness is COACHDEEP9's (`tools/coachdeep9.gd`): `_bout` prices a corner with `R.corner_edge` (tactics -> share of
  best calls, x (1 + 0.4 chem), x 0.85 warned) added to `BoutRead.round_edges` before rounds 2-3 (`R.chance`). A clash zeroes
  the first call. It is a greybox price. CORNERBASE1 showed that in a real simmed bout the rating buys about 0.
- The bout harness is CORNERBASE1's (`tools/cornerbase1_probe.gd` `bout`): the real `BoutNight` / `LiveRound` loop. The reader
  (`cornercmd2_rules.gd` `decide`, pol `reader_nr`) picks a command for the moment it SEES. That moment is `sit_seen`: the
  situation of the previous exchange's mode, its clue line (l.262). `st.heard` = `Exchanges.uptake(coachability) x trust`. It
  scales both the plan's call edge and every command edge (`before` l.307-328). FILE (`cornerbase1_rules.gd` `corner`) calls
  Hands up when she was hurt, Reset under 35 wind, else the file's call.
- Recovery between rounds exists in the game: `BoutNight._open` l.179-188 reads `|rec=water:n,ice:n,head:n` (CornerJobs.recover:
  3 points; water +3 energy, +6 under 40; head clears a hurt). Both probes send no points (`"corner:" + call`), so recovery is 0
  there today. In the game the player places 3 points himself.
- Chemistry is one-way, confirmed in the code: `R.chemistry` reads traits only. The bond (`_train` l.328-329) grows +0.01 a
  coached week and fades 0.005 when apart. Results and money never touch either (`_bout` writes loyalty, morale and streak only).

## 1. How change 1 stacks with PLANIMPACT2 (written before any run)
PLANIMPACT2 FAILED (`docs/PLANIMPACT2_RESULT.md`: +0.5 / +0.7 wins for its rule; bars 1, 2, 4, 5 red). Its page says one rule
should own the command grade, and the plan's version is the one to drop. Decision:
- The plan raises nothing. PLANIMPACT2's rule is OFF in every arm here, and bar 7's "with PLANIMPACT2's rule on too" is not run
  (that clause applies only if the rule had passed).
- Change 1 does NOT raise a grade either. It scales how much of a call she HEARS (`heard`, a multiplier on the edge), not the
  grade word (Poor / OK / Good -> 0.25 / 0.6 / 1.25). The largest bond here (chemistry +0.5) gives x1.2. One grade step is x2
  (OK -> Good), so the total stays under one grade. That is the "one grade in total" cap of the task's feedback loop.
- Printed: the mean hearing multiplier and the share of exchanges where it is above 1.

## 2. Change 1 - the corner coach is wired (Kalli 1; COACHDEEP9 s7 (a)-(d))
At strength s (1 = as written, 0.5 = the half arm; s scales each effect's distance from "off"):
- (a) THE CLUE: the line the corner reads before an exchange is right with chance q = 1 - s x (1 - (0.4 + 0.03 x tactics)).
  At s = 1: tactics 8 -> 0.64, 11 -> 0.73, 13 -> 0.79, 16 -> 0.88, 17 -> 0.91, 20 -> 1.0 (today's reader sees it right always).
  A wrong clue shows another game of the opponent's style, drawn by `Exchanges.STYLE_MODES` weights (CORNERBASE1's misread).
  Her own wind and hurt are seen right (the corner sees its own boxer). "Which calls are offered": the corner offers the calls
  best for the clue it reads. The reader takes the best of those, so this is one rule with the clue, not a second one.
- (b) THE BOND: heard x (1 + s x 0.4 x chemistry); a warned boxer x (1 - s x 0.15); a clash pair (word clash): the commands of
  round 2 (the first after the stool) are not heard (heard 0 for that round; at s = 0.5, x 0.5).
- (c) THE CUTMAN: the second's recover points between rounds come from the corner coach's cutman: 1 point at cutman 1-7,
  2 at 8-13, 3 at 14+ (the `R.tapes` thresholds). At s = 0.5, half the points, rounded down. Placed by the rule: clear the head if
  she is hurt at the bell, the rest on water. (Off = 0 points, as both probes ran.)
- (d) SIMMED - THE COACH MAKES THE CALLS: CORNERBASE1's FILE coach, with the ratings moving how well he does his two jobs. He
  sees she is tired (wind under 35) and calls Reset with chance conditioning / 20. He sees she was hurt and calls Hands up with
  chance cutman / 20. He reads the file right with chance tactics x 5 / 100 (CORNERBASE1's SKILL rule). Recovery as (c). At s = 0.5
  each chance is half way between 1 and the rule. Kalli's cap: the best simmed coach 4 or more wins in 100 over the worst, and
  never over 8 (bar 7b below). No number is moved to meet it.
- (e) IN THE SEASON: a bout is called live (the player calls). The picked coach's win chance is COACHDEEP9's read with REID's
  call price for everyone (`R.corner_edge(REID)`), plus the coach's measured live difference to Reid from the bout probe:
  D(coach) + the chemistry slope (Reid at +0.5 / -0.5 against Reid at 0, linear in chemistry; the clash's lost round is in the
  -0.5 arm), x the warned factor. So Reid at chemistry 0 plays exactly as COACHDEEP9. The hire card's "X more a season"
  (`_gain`) uses the same D.
- Coaches measured in the bout probe (the season's cards): YOU (all 8), REID, L, M, S, F, K. Chemistry 0 for each, plus Reid at
  +0.5 (bond) and -0.5 (clash), and K at -0.5 (the known name clashing).

## 3. Change 2 - a coach limit (Kalli 2)
A coach is the main coach of at most 2 boxers, 3 at teaching 15 or more (M only among the cards). It counts every boxer he gives a
place to in the week. The owner (YOU, teaching 8) counts too, and so does the mat coach (one grappler). The week still pairs
itself by best value: a coach at his limit takes no new boxer, and she goes to the next best. "Change" cannot break the limit.
Paper check (the brief's "what would a human do"), three example rosters, 3 boxers + 1 grappler:
1. NOHIRE (YOU + Reid + mat coach): today Reid takes all three boxers (9 places of his 10). With the limit, one goes to YOU
   (ratings 8, 2 evenings = 4 places). It bites in every NOHIRE gym.
2. Hire F (Lucy hot 72, Kira 30, Josh 35): F bonds or is fine with all three. Reid 2 + F 1, or F 2 + Reid 1. It bites only in
   which one goes to F. Small.
3. Hire K with Josh pro and hot (pro_hot): K clashes with Josh (temper 82 v K's 85 -> -0.4). With no limit Reid keeps Josh and K
   takes the rest. With the limit, Reid 2 + K 1: if K has to take Josh, it is a clash pair. This is the trade the limit is for.
So on paper the limit changes the week in every NOHIRE gym and in some hire gyms. Bar 6 measures how often.

## 4. Change 3 - the bars measured again, harder (Kalli 3)
- 10 ROSTERS A GYM TYPE: roster 0 = the TEST CLUB as COACHDEEP9 (Lucy, Kira, Josh, Ana). Rosters 1-9 redraw each person's five
  traits (temper, heart, discipline, confidence, coachability) from a seeded draw, the TEST CLUB value +-25 (the scouting draw's
  spread, `ProspectGen._draw`), clamped 5-95. Then the cell's own changes (hot / pro_hot tempers) go on top, as before.
  10 cells x 10 rosters = 100 gyms. Reps 10 a gym (100 careers a cell, as COACHDEEP9's 100).
- THE CAREFUL HIRE READS THE WORD: among the affordable cards (COACHDEEP9's `_pick` test: pays at N <= members, or K with a pro),
  the one with the highest card line "the boxers win about X more a season" (`_gain`: training x chemistry + the corner). The
  careful week plan sees the word from week 0 (no trial), and the careful line unpairs a clash where it can.
- THE CARELESS OWNER: hires COACHDEEP9's blind favourite (the mean of the ratings, the word ignored). He never unpairs a clash (the
  limit then puts whoever is left with whoever has room), and he answers moments by COACHDEEP9's careless line.
- Without change 3, a gym = one cell (TEST CLUB, 10 gyms), and the hire is COACHDEEP9's favourite with the word known at week 0.

## 5. The arms
Season (`stage=season`), COACHDEEP9's careers (104 weeks) with the S548 cuts unless named:
| Arm | Trial | Falling-out | Word | C1 | C2 | C3 | Reps |
|---|---|---|---|---|---|---|---|
| CTRL (control) | yes | a decision | week 2 | off | off | off | 100 (must equal COACHDEEP9 full.txt cell for cell) |
| BASE (COACHMAP1) | cut | by the rule | week 0 | off | off | off | 40 |
| C1 | cut | rule | 0 | on | off | off | 40 |
| C1H (half) | cut | rule | 0 | half | off | off | 40 |
| C2 | cut | rule | 0 | off | on | off | 40 |
| C3 | cut | rule | 0 | off | off | on | 10 x 10 rosters |
| ALL | cut | rule | 0 | on | on | on | 10 x 10 rosters |
Arms inside each: NOHIRE, L, M, S, F, K, the careful pick (CTRL/BASE..C2: COACHDEEP9's favourite), CARELESS, raise match /
refuse and push allow / refuse (forced at weeks 52 / 26 as COACHDEEP9). CTRL also runs its TRIAL, falling-out and cost-off arms
(it is COACHDEEP9 unchanged).
Bouts (`stage=corner`): the five women of CORNERBASE1, its ten cells, 3 and 6 rounds, n = 40 a boxer, cell and arm (dice k = 0-39,
the same as CORNERBASE1's first 40). Arms: `reader` and `file` (change 1 off: must equal CORNERBASE1 bout for bout),
`live:<coach>[:b|:x]` (reader + change 1 with that coach; b = chemistry +0.5, x = -0.5), `sim:<coach>` (change 1 (d)), and the
half arms `liveh:F`, `liveh:REID:b`, `simh:YOU`, `simh:K`.

## 6. The bars (the task's eight, as read here; written before the run)
A "gym" is one cell (CTRL..C2) or one cell x roster (C3, ALL). "Lines" = COACHDEEP9's score.
1. NO ONE-FACT HIRE: the rule "a pro on the roster -> K, else F" loses 10 or more lines to that gym's best hire (the top of the six
   hire arms) in 3 or more cells of 10. On 100 gyms: in 30 or more gyms. Its loss is printed per cell too.
2. THE KNOWN NAME: K - NOHIRE > 2 SE in every cell with a pro, and not above +2 SE in every cell without (COACHDEEP9 bar 2).
   On 100 gyms: in 90% or more of each kind.
3. NO ONE-SPLIT MOMENT (raise, style push): for each visible fact, the best map from its values to an answer predicts the best
   answer in no more than 80% of gyms. Facts: a pro on the roster; gym size; a hot-tempered boxer (temper > 60); a boxer under 21;
   the card hired; the word of the hired coach with the pushed boxer (push) or the hire's word with the best boxer (raise). Also
   printed: the share where one answer wins outright (COACHDEEP9's "no answer best in > 6 of 10").
4. THE CORNER PICK IS A CHOICE (bout probe, change 1 on, the live reader calling): over boxer x cell x length (100 units), the
   tactician F (tactics 17, chemistry 0) and the bonded Reid (11, +0.5) are each the better corner in 25% or more of units. Also
   printed: how many of those units are past 2 SE (so a coin flip cannot pass it alone), and the season's own corner count.
5. A CARELESS OWNER LOSES, A CAREFUL ONE DOES NOT: careless loses a person (0.5 or more a career) in 2 or more gyms of 10 (20 of
   100) and the careful owner in at most 1 of 10 (10 of 100). Also printed: careless - careful lines per cell (with C3: the
   careless owner ignores the word and the limit, s4).
6. THE LIMIT BITES AND DOES NOT TRAP (change 2): the careful owner's week plan, compared week by week with the plan the same week
   would make without the limit, has another main coach for some boxer in a quarter of the weeks or more, in half the gyms or more.
   TRAP = a hire that pays without the limit (> NOHIRE + 2 SE in BASE) and loses with it (< NOHIRE - 2 SE in C2). No trap allowed.
7. NOTHING RUNS AWAY (COACHDEEP9 bar 7: members <= catchment, no two moments a month, bond <= 0.25, chemistry <= 1) AND THE CORNER
   IS NOT JUST BUFFED: (7a) with change 1 on, each coach's live corner over his own simmed corner is +6 to +15 wins in 100 at both
   lengths (over the five boxers); (7b) Kalli's cap: the best simmed coach beats the worst by 4 to 8.
   Feedback-loop stops: the best-coach gym's mean cash over the median's at year two (stop at double); people lost per gym (stop
   if any gym loses more than two coaches in two years); wins and cash per year printed.
8. PLAY (reported, target 2 to 4): coach pop-ups a season a gym (raise, rival offer, push, course; the falling-out news line
   counted apart). The "why" lines: the share of bouts (bout probe) whose result differs from the same bout with change 1 off.
   Only there can a result line truthfully credit the coach.
Verdict: PASS = bars 1-7 at their bars on ALL (bar 8 is the report the owner judges). Each arm gets the eight-row table.

## 7. Stops (from the task's feedback loops)
- The one-rep trial (two cells: small_pro_hot and big_am; two rosters; one year; all arms). Stop if two arms print identical
  seasons where a change is on (an arm not wired), or if CTRL does not match COACHDEEP9.
- The bout control: `reader` and `file` equal CORNERBASE1's first 40 bouts of every boxer x cell x length. Else stop.
- Cash: stop if the best-coach gym's year-two cash is double the median's. Lost people: stop if a gym loses more than 2 coaches.

## 8. Not in this probe (next, if this passes)
Merging the rival's offer into the raise; contract length; coaches who grow; film and weight wiring (cutman and weight on the
weigh-in miss stay as COACHDEEP9); the course as a measured call; the plan's grade raise (dropped, s1).

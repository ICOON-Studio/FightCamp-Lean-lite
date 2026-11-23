# DESIGN_COACHDEEP8 - coaches v8: v7 plus the three changes its probe named (S543)

v8 (task `ops/research/TASK_COACHDEEP8.md`): this is the v7 map (`ops/research/DESIGN_COACHDEEP7.md`) carried over whole; every
changed paragraph is marked "v8:". The three changes come from `docs/COACHDEEP7_RESULT.md` s7, one per failed bar, each inside the
owner's interview answers; nothing else moves. The bars (s10), the ten cells and the score are v7's, word for word, never loosened.
- v8 change 1 (bar 3; interview 3 "a wrong call is felt as story", 15 "two warnings"): a WARNING COSTS while it stands (s6).
- v8 change 2 (bar 1; grill Q17 "wages scale with ratings"): a coach who teaches two arts is on a SOLID-band wage (s2).
- v8 change 3 (bar 5; interview 6 "one plain line on whether the club can carry the wage"): the card's line counts the boxers too (s2, s6, s12).

Below: the v7 map, with the v8 marks.

---

# (v7) coaches v7: a staff game (S542)

Spec: the owner's interview `ops/research/COACH_INTERVIEW_S542.md` (17 answers, all yes). Where it and
`ops/research/COACHDEEP_GRILL_S539.md` differ the interview wins (it replaces the grill's Q13 and Q14; the other 22 answers
stand). Task: `ops/research/TASK_COACHDEEP7.md`. Written BEFORE any probe run; the bars in s10 are never loosened.
v7 is not a patch of v6: the weekly who-coaches-whom stops being a choice; coaches become a STAFF GAME - who you hire, when,
what they cost, how they get on with your boxers - with a few decisions a season. Layers removed: the evening trade (class
night or pads), the hand-assigned week, the CoachRoles class-v-pad-minutes rule.

Every number marked ESTIMATE is a probe value with its real-world reason; the probe (s11) checks only that nothing is broken
and no answer is always right. Depth and fun are the owner's play + two critics at 8 (interview 4, 17).

## 1. Who is in it
- You: owner and head coach, no ratings; you can cover 2 evenings a week as a plain coach (every rating 8) (grill Q1, Q19).
- Up to 4 hired coaches (grill Q2). The starting coach (Reid) stays, converted: strong pads, average elsewhere (grill Q18).
- Each coach: eight ratings 1-20 (pads, conditioning, tactics, cutman, weight management, film, motivation, teaching
  beginners - each wired to a rule that exists, grill Q8), 2-3 specialties (Q9), a playbook = one of the six styles (Q10),
  five traits 1-20 (temper, patience, discipline, ambition, loyalty, Q11), a ceiling per rating shown in words (Q22).
- Your own coaches only (interview 5): the opposing coach's card and coach careers wait.

## 2. THE HIRE (interview 6, 11; grill Q15-17) - the main decision
A monthly list of THREE candidates (local coaches; now and then a known name; later your retired boxers). Each card:
- exact ratings 1-20 (yours and candidates are exact, Q16), specialties, playbook, the five traits;
- the wage by band (Q17): local $150-300 a week, solid $400-600, known name $800-1,100;
- one plain line: "Pays for itself at about N members" (or, for a known name: "Pays only with a pro or a title boxer").
  HOW N IS COMPUTED, from what the game has: his week is worth (a) the class nights his free evenings can run that the
  members want and nobody runs now - min(his evenings, class_demand(N) - nights already run) x ClubDeal.class_cash(1)
  ($117 a night: DuesLevers.CLASS_WEEKLY $350 / 3) - plus (b) the dues of the members his coaching cap lets the club carry
  (StaffRoles.COACH_MEMBERS 40 x GymBills.FEE_MONTH $35 / WEEKS_A_MONTH 4.33 = $323 a week, counted only up to the
  catchment). N = the smallest member count at which (a) + (b) >= his wage. Class demand reads the members (one full class
  night per 12 members + one half night, v5/v6 `class_demand`), so a bigger club has more nights left to fill.
  A local on $200 pays at about the club's opening size; a solid $550 coach needs a bigger club; a known name's (a) + (b)
  tops out at 5 x $117 + $323 = $908 a week, under any known-name wage, so his card says "Pays only with a pro or a title
  boxer" (interview 11: "loses money in every amateur club (measured)" - COACHDEEP5/6: -29 to -39 lines over two years).
- THE KNOWN NAME (interview 11): $800-1,100 a week (the probe's: $1,000). He pays only with a pro or a title boxer: when he
  works the corner of a professional bout the promoter pays the club a NAME FEE of 60% of that bout's purse, capped at
  $4,000 a bout, and every pro win with him in the corner adds +2 club reputation (the name). ESTIMATE - real-world
  reason: a famous trainer brings televised cards and the promoter's attention; TV purses run several times a small-hall
  purse and a trainer's usual cut is ~10% of the purse, so the club's side of a name corner is a fee tied to the purse, not
  a flat number. The CAP (feedback loop 2): $4,000 a bout, +2 reputation a win, reputation already capped at 100; the
  purse itself is the game's (Matchmaking: $1,500 unranked, +$400 a place above 21st, the gym's share 25%). His card
  says it in words: "Pays only with a pro or a title boxer in his corner: the promoter pays a name fee."
- v8: THE SECOND LINE (change 3). Beside "pays for itself at about N members" the card (and the raise pop-up, s6) says "the
  boxers win about X more a season with this coach". X is the game's own coached-against-alone gain: for every boxer he can
  coach (his arts), a season (26 weeks) of his full weeks against training alone (CoachAreas.lift on his area ratings x the
  learn mult with her, against the trust-only gain of training alone), then her win chance with those stats and his corner
  calls against her stats today and no corner (the same read the corner pick uses, s7), x her bouts a season (amateur 6.5,
  a pro 26/8, a champion 26/12). Real-world reason: an owner hires a coach for his boxers as much as for the class nights; the
  one-line "will the club carry this wage" (interview 6) must count the results side or it tells the owner to let his best
  coach go. The careful line (s12) reads both lines at a raise; the blind hire pick (s10) stays v7's (the members line).
- v8: THE TWO-ART COACH (change 2). The local mat coach who also teaches the boxing class (card M) moves from $250 (local band)
  to $450 (solid band, $400-600; its band top for a raise is $600). Real-world reason: grill Q17 "wages scale with ratings",
  and a coach who can run both a boxing class and a no-gi class is paid for both - a sessional mat coach alone is $150. So the
  two-art coach is a trade: M at $450 against the cheaper one-art local L ($200) plus the sessional mat coach ($150) who comes
  with a no-gi fighter anyway. His card now reads "pays for itself at about N members" with the solid band's N.
- Hiring is once a month at most (the list refreshes monthly); letting a coach go costs a week's wage (StaffRoles.notice).

## 3. THE TRIAL WEEK (interview 7)
- Price: one week of his wage (ESTIMATE: a trial is a week's work at his rate; it is the only knowledge you can buy).
- Shows the chemistry word with EACH boxer (bond / fine / clash) on the candidate's card before signing.
- Without it the word shows two weeks after he starts (grill Q12). Until it shows, the week's pairing (s4) cannot use it.
- One trial a month (it takes the week).

## 4. THE WEEK PAIRS ITSELF (interview 2, 14) - replaces grill Q13 and Q14
- Each week the plan pairs every boxer with the coach who suits them best: his areas weighted by her style, his specialties
  on her combination, his playbook v her style, the chemistry word once shown (v6's SMART rule, measured best or tied-best
  in 8 of 10 cells - so the game plays it for you).
- "Change" on the week plan overrules a pairing for free (interview 14); the new pair's chemistry word is the only
  consequence (it moves learning, morale and loyalty as below, and a clash pair can fall out, s6).
- Class nights fill the evenings no boxer needs, up to what the members want (`class_demand`), shown as a FACT on the week
  plan ("Tue, Thu: class nights - 24 members want 3"). No class-or-pads choice.
- THE CUT (interview 10, build step 1):

| What | Where | Fate |
|---|---|---|
| class nights against pad minutes (class_week, class_pill: 75 min pads at 2 class nights, floor 45, CLASS_MAX 3) | scripts/rules/CoachRoles.gd:52-74 + tests/coach_roles_test.gd's class rows | DELETED |
| the week plan's class-night count control and its pill | the week plan (wired through class_pill) | DELETED: replaced by the fact line |
| CoachRoles.runway / hire_line (cash runway after a hire) | CoachRoles.gd:75-97, scripts/ui/HireRunway.gd | STAYS, SHRINKS to a second line under "pays for itself at N members" on the hire card |
| CoachRoles BJJ belt promotion (can_promote, academy_month) | CoachRoles.gd:98-127 | STAYS (the mat coach's belt) |
| CoachRoles held pad night (held_night, held_allowed) | CoachRoles.gd:128-139 | STAYS (a pad session, not the trade) |
| the four staff jobs (second club coach, S&C, physio, cutman) | scripts/rules/StaffRoles.gd | STAY until rated coaches replace them: the second club coach becomes a hired coach; S&C, physio and cutman stay as jobs |

## 5. CHEMISTRY (grill Q12, as built in COACHDEEP1-6)
- His traits v hers (`chemistry`: a hot-tempered coach v a hot-tempered boxer -0.4, v a low-heart boxer -0.3; a patient coach
  v an unsure boxer +0.3; ...) + weeks together (the bond: +0.01 a coached week, cap 0.25, fades 0.005 a week apart).
- The word: bond at +0.15 or more, clash at -0.15 or less, fine between (ESTIMATE: the trait rules' single steps are
  0.1-0.4, so one real clash or one real match shows; the bond alone turns fine into bond after ~15 weeks together).
- Moves learning (x(1 + 0.30 x 0.15 x chem)), morale (3 x 0.15 x chem a full week), loyalty (1 x 0.15 x chem a full week).
- ONE-WAY: chemistry reads traits and weeks together only - wins, losses and money never move it (feedback loop 3).
- Shown on the coach card per boxer and on the boxer card, reasons on hover, after two weeks or a trial.

## 6. FOUR MOMENTS (interview 8, 13, 15) - at most one coach moment a month, as a pop-up like the pro offer
Every person has a loyalty line (boxers: the game's Loyalty 0-100; coaches: loyalty trait x 5 at signing). A moment that goes
against a person puts a WARNING on their card (shown, with its reason). A person with two warnings leaves for good when the
next blow takes their loyalty under 25 (the game's Loyalty.LEAVES_UNDER) - so two warnings are always visible first
(interview 15). A person who has left cannot trigger another moment (feedback loop 4).

| Moment | When it fires | Answers and what each changes |
|---|---|---|
| A FALLING-OUT | a pair whose word is clash, 4+ weeks together; 30% a month (ESTIMATE: a clash shows within a season) | BACK THE COACH: her loyalty -12 (= Loyalty "promise_broken") and a warning on her; his loyalty +5. BACK THE BOXER: his loyalty -15 and a warning on him; hers +5. SPLIT THEM UP: both -3, no warning; the week never pairs them again (she may lose her best-fit coach). |
| A RAISE or A RIVAL OFFER | after 3 straight wins by his boxers (or a title), a coach with ambition 12+ asks; once in 26 weeks a coach. A coach with loyalty trait 8 or less instead brings a rival offer | RAISE: MATCH = wage +25% (ESTIMATE: a raise after results ~20-30%), his loyalty +10; REFUSE = his loyalty -20 and a warning. RIVAL OFFER: MATCH = +25% wage, loyalty +10; LET GO = he leaves in two weeks (lost). |
| A STYLE PUSH | a pair with fit 0 or less (his playbook v her style), 8+ weeks together; one push a boxer a season | ALLOW: her style becomes his playbook (fit +1 with him, faster learning later), her next 2 bouts at 0.6 of the plan (shakier fights meanwhile), her own combination restarts at half mastery; REFUSE: his loyalty -12 and a warning. Cap (loop 5): one push a boxer a season; the learning bonus tops at the fit's +15%. |
| A COURSE | a coach under his ceiling, cash over $6,000; once a coach a season | SEND: $600 (ESTIMATE: an England Boxing coaching course, GBP 300-500 x 1.25) and 2 of his evenings a week for 3 weeks; then +2 in his lowest of pads / tactics / teaching, never past his ceiling (rating + 3, grill Q22). NOT NOW: an ambitious coach (12+) -3 loyalty, no warning. |

The two warnings on the card read: "Warning 1 of 2: backed the boxer in the falling-out" / "Warning 2 of 2: one more and
he leaves". A moment's pop-up shows both people's loyalty band and any warning before you answer.

v8: A WARNING COSTS WHILE IT STANDS (change 1). In v7 one warning alone did nothing until a second one came, so backing the
coach and backing the boxer differed by 1-2 lines and refusing a push was nearly free (COACHDEEP7_RESULT s7). Now:
- A WARNED BOXER trains and listens worse: her learning -10% (every coached and lone gain, and her pad drilling), the corner's
  calls reach her 15% less (the uptake of every call, s7), and her morale drops 0.5 a week (the game's drift back to 60 holds
  her about 6 lower). ESTIMATES to tune; real-world reason: a boxer the owner sided against sulks for months before she ever
  leaves (task "What would a human do?"); 10-15% is the size of one bad-mood step in the game's trust table (FighterProfile.TRUST
  1.0 -> 0.85).
- A WARNED COACH works worse: every rating of his counts 10% less (his areas in training, his tactics in the corner, his
  teaching of beginners, his motivation). ESTIMATE; reason: a coach who is refused does the minimum.
- THE FADE: a warning fades after a season (26 weeks) if no second one comes; a second warning stands (one more blow and the
  person leaves, as v7). The cost is a fixed size - two warnings cost no more than one.
- So WHO carries the warning decides the answer: backing the coach puts the cost on the boxer's season, backing the boxer puts
  it on the coach's boxers, splitting puts it on nobody but loses the pairing; refusing a push or a raise costs the coach's
  work for a season.
- Shown: the warning line on the card gains its cost and its fade: "Warning 1 of 2: backed the coach in the falling-out -
  trains and listens less until 12 May (fades if nothing else happens)".
Order when two are due in the same month: falling-out, rival offer, raise, style push, course (the rest wait a month).

## 7. THE CORNER PICK (interview 9)
- Before a fight the player picks the coach in the corner from the coaches on the books (you included).
- Reads the corner rules that exist: his TACTICS (x his playbook fit) is the plan rating BoutRead.chance's coach argument
  takes (CoachPlan.write writes the plan from it; v5/v6 `plan_rating`), and the boxer's uptake of the calls
  (BoutRead: Exchanges.uptake(coachability) x FighterProfile.trust) is scaled by the pair's chemistry - LISTEN: the plan
  rating x (1 + 0.4 x chem) (ESTIMATE: a bond of +0.25 is worth +10% of the plan; the boxer listens to the coach she trusts).
- A CLASHING coach gets ONE CALL IGNORED A FIGHT (CornerTrust.ignored): the plan rating x (1 - 1/calls), calls = rounds - 1
  (amateur 3 rounds = 2 calls: half the plan; a 6-round pro = 5 calls: four fifths).
- Cutman and weight management of the corner coach read the weigh-in miss chance (v6 `miss_chance`) for that fight.
- The known name's name fee (s2) needs him in the corner: the pick is fee v bond v tactics.
- The pick screen shows each coach's tactics, the word with this boxer, and the game's "about X%" read for each.

## 8. MENUS (interview 12; owner S425) - no new screens beyond a hire list and a coach card

| Menu | What shows | Wired to |
|---|---|---|
| Club > People, staff table | each coach's eight ratings, wage, the word per boxer (hover: reasons), warnings (v8: with "works less until <date>") | coach dicts on Career (staff), chemistry() + bond, warnings + warn_at (fade) |
| Club > People, hire list (new) | three candidates a month, exact ratings, wage, playbook, traits, "pays for itself at about N members" / "pays only with a pro or a title boxer", v8: + "the boxers win about X more a season with this coach", the TRIAL button and its price | hire list draw (monthly), pays_at(), v8: the coached-v-alone gain (X), trial (one week's wage; reveals words) |
| Coach card (new) | ratings + ceilings in words, specialties, playbook, traits, his boxers and the word with each, warnings (v8: the cost and the fade date), loyalty band | coach dict, chemistry, warnings, warn_at, ceiling |
| Week plan | the pairings as a FACT (who works with whom, each with its word), a free "change" per boxer, the class-night fact line | auto-pair (s4), class_demand / free evenings |
| Boxer card | her coach, the word, any warning on her (v8: "trains and listens less until <date>") | pairing, chemistry, warnings + warn_at; the learn and uptake cut |
| Corner pick (before every fight) | each coach: tactics, word with her, "about X%" read, the name fee line for the known name; v8: a warned coach's tactics shown at their working value, a warned boxer's read lower | BoutRead.chance(coach = plan x listen) - v8: still NOT wired in the game (COACHDEEP8_RESULT s6), name fee |
| Moment pop-ups (like the pro offer) | the falling-out / raise / rival offer / style push / course, both people's loyalty band and warnings, the answers; v8: each answer says who would carry a warning and what it costs; the raise pop-up shows both lines at the raised wage ("pays for itself at about N members"; "the boxers win about X more a season with this coach") | the moment rules (s6), pays_at, the X gain |
| Money page | wages, the trial, the course, the name fee | cash ledger |

Plain game words; names only in headers (owner S448); no he/she in game text ("the coach", "the boxer", or the name in the
header). This map uses "he" for coaches and "she" for boxers only as page shorthand.

## 9. BUILD ORDER (interview 16) - each step a build the owner plays
1. Cut the class-or-pads rule (s4 cut table); classes fill the free evenings as a fact.
2. Rated coaches, the coach card, the hire list (three a month), wages by band, "pays for itself at N members", the
   known-name rule (name fee in the corner of a pro bout).
3. The chemistry word, the trial week, the week pairing itself with "change".
4. The four moments (with the two warnings).
5. The corner pick.

## 10. BARS - written before any run, never loosened (owner interview 4 and 17: bots check only that nothing is broken)
TEN CELLS, each named in the output (club size x roster): 
1 small_am (30 members, the TEST CLUB four: Lucy, Kira, Josh, Ana); 2 big_am (70 members, catchment +30, the same four);
3 small_pro (Josh a ranked professional, 12th); 4 big_pro; 5 small_title (Josh a champion, 1st); 6 big_title;
7 small_novice (three boxers, no Ana, all 18-19 with lower stats); 8 big_hot (three boxers, no Ana, hot tempers);
9 small_pro_hot (Josh a ranked pro with a hot temper, Lucy, Kira); 10 big_title_mix (Josh champion, two novices, Ana).
With a pro or title boxer: 3, 4, 5, 6, 9, 10. Without: 1, 2, 7, 8.
Hire options in every cell: NOHIRE (you + Reid) and the five candidates L, M, S, F, K (v6's cards; K at $1,000).
Each cell's monthly list = three of the five, drawn once per cell (seeded by the cell's name) - used by the trial (bar 6)
and the moments (bars 3, 5): the hire there is the card favourite (the highest card value among those the card says pay at
the club's members, or K when the club has a pro or title boxer).
- (1) No candidate (NOHIRE counted as one) is the best hire in more than 6 of the 10 cells.
- (2) K beats NOHIRE by more than 2 standard errors in each of the six pro/title cells, and loses or ties (not above +2 SE)
  in each of the four without.
- (3) In each of the falling-out, the raise and the style push (forced at week 26 / 52 / 26, every answer from the same state,
  the careful line after it), no single answer is best in more than 6 of 10 cells.
- (4) In the corner, over the fights where the best tactician and the best-bonded coach are different people, the best
  tactician is the right pick (highest win chance) in at least 25% of fights and the bonded coach in at least 25%.
- (5) People can be lost: the CARELESS line (always back the coach, refuse every raise and let every rival offer go, allow
  every push, never a course) loses a coach or a boxer (mean over reps >= 0.5 people) in at least 2 cells; the CAREFUL line
  (s12) in at most 1.
- (6) The trial week is the right buy (trial arm - blind arm > +2 SE) in at least 2 cells and the wrong buy (< 0) in at
  least 2.
- (7) Nothing runs away: members never above the catchment; cash bounded (printed min / max per arm at week 104); at most
  one moment in any month (count of months with two = 0); chemistry never above its cap (bond <= 0.25, chem <= 1).
PASS = all seven.

THE SCORE (one, written before the run): v5/v6's lines over two years - cash / $1,000 + reputation / 3 + (wins - losses)
/ 0.5 + morale / 5 + the next-year value of every boxer still at the club. Reason: the same scale every coach probe used,
so a v7 number reads against v5/v6; a person lost is priced by what follows (no class nights, no pro purses, the leaving
reputation), not by a penalty I invent. Its parts (cash, rep, wl, morale, next) are printed apart for every arm.

## 11. THE PROBE
v8: `tools/coachdeep8.gd` + `tools/coachdeep8_rules.gd` (+ `tools/coachdeep8_sum.py`), copies of v7's with the three changes and two
control arms (the careless and careful lines with the warning's cost off). v7's:
`tools/coachdeep7.gd` + `tools/coachdeep7_rules.gd`: a GREYBOX from tools/coachdeep6* (the catchment ceiling, rank bands,
the record line, the SMART pairing, the game's own Loyalty / Leaving / BoutRead / Membership / ClubDeal / StaffRoles /
Matchmaking / BoutRules numbers read from the modules). 104 weeks. Pro bouts: every 8 weeks (title every 12), purse by
Matchmaking's table, gym share Matchmaking.GYM_SHARE, the stipend stops; pro opponents from the top of the rival list
(greybox), rank +1 place a win, -2 a loss (greybox), a champion who loses drops to 3rd. Population named in the output.

## 12. THE CAREFUL LINE (the probe's sensible player)
Falling-out: back whoever already carries a warning or sits lower against the 25 line; if neither, split them up when
another coach can take her, else back the boxer. Raise / rival offer: match when the coach still pays at the raised wage
(members >= N, or the known name with a pro or title boxer), else refuse (raise) / let go (rival).
v8: the raise pop-up's two lines - match also when his members' worth this week plus the results line (X wins a season x a
win's worth on the score, (WIN_REPUTATION + LOSS_REPUTATION)/3 + 4 lines = $1,000 a line, over 26 weeks) covers the raised wage. Style push: allow when
she is under 23 and he is her main coach, else refuse. Course: send when cash > $6,000. Corner: the highest shown chance.

## 13. FEEDBACK LOOPS (caps; the one-rep trial prints each)
1. A hire -> free evenings -> class nights -> members -> dues -> another hire. Caps: the catchment ceiling (v5), class
   nights never past what the catchment's members want, at most 4 coaches. Print members, class nights run v wanted, cash
   at week 104 per arm.
2. Known name -> name fee + name reputation -> cash -> affords the known name. Cap: $4,000 a bout, +2 reputation a pro win
   (reputation tops at 100); the fee needs a pro bout, which needs a pro boxer.
3. Bond -> the corner is listened to -> wins -> loyalty, morale. Chemistry stays one-way (traits + weeks together, bond cap
   0.25); the probe prints the bond max and checks no win path touches it.
4. A falling-out -> loyalty down -> someone leaves -> fewer people -> more falling-outs? Cap: one moment a month, two
   warnings first, a person who left fires nothing. Print the longest run of losses (people lost in a row, month by month).
5. A style push allowed -> faster learning -> wins -> more pushes. Cap: one push a boxer a season; the bonus tops at the
   fit's +15%.
6. A course -> ratings up -> the ceiling (rating + 3) stops it.
7. v8 NEW: a warning -> the warned boxer learns and listens worse -> loses more -> loyalty and morale down -> closer to the 25
   line -> the next moment's blow makes her leave. Caps: only a MOMENT gives a warning (at most one a month); a loss never gives
   one; the cost is a fixed size and fades after 26 weeks. Printed per cell: people who leave while carrying a warning, cost on
   v cost off (control arms CARELESS_OFF, CAREFUL_OFF). STOP if the careless line loses more than two people a career on
   average, or the careful line loses more than in v7 (1.69 people over the ten cells: big_am 0.78, big_title 0.91).
8. v8 NEW: a warned coach works worse -> his boxers win less -> no raise moment (it needs three straight wins) -> no loop back.
9. v8: change 2 is a price and change 3 a printed line: neither feeds anything back.
ONE-REP TRIAL FIRST: one career per cell per arm, printed in full. STOP and fix this map if members leave the catchment
band, if every cell converges on the same best hire, or if no arm ever loses a person.

## 14. TRIAL FIXES (added after the one-rep trial, BEFORE the full run; bars s10 unchanged)
The first one-rep trial (FAIL 2 of 7) showed the greybox could not measure the map; these fixes went in before the full run:
1. **The corner had no lever.** `BoutRead.chance(f, opp, camp, coach)` returns the same chance at coach 0, 30, 55, 80 and 100,
   and two OppFile tapes move nothing (measured on all three boxers, three opponents each). v5/v6's tactics (`plan_rating`)
   and film (`tapes`) were dead levers. s7 now reads the game's round edges (`BoutRead.round_edges`, its own 3-round
   integration): a call before rounds 2 and 3 is priced by `Exchanges.EDGE` (best +17, ok +5, wrong -10) - best calls
   0.6 x tactics/20, wrong 0.3 x (1 - tactics/20), a call shapes a third of the round (ESTIMATE), x playbook fit, x listen
   (1 + 0.4 x chem); a clash ignores the first call. FOR THE BUILD: the game's own read ignores the corner coach today.
2. **The no-gi fighter came with no mat coach**, so the mat-capable local won 8 of 10 cells only by giving her a career
   (+100 lines). A sessional mat coach ($150, 2 evenings, no-gi only) is on the books in every cell with a no-gi fighter.
3. **The careful line uses the free "change"** (s4, interview 14): once the word shows, a clash pair is unpaired when another
   coach can take her. It also reads the warnings on a style push (never hands a second warning to a coach under the line).
4. **The "no" answers cost nothing** (refuse won every raise, allow or refuse tied): a refused raise now makes the coach work
   worse (pads, tactics, teaching, motivation -2 for 26 weeks), and a coach with loyalty 10 or less, or one already warned,
   leaves in two weeks ("match it or let him go", interview 8); a coach not backed in a falling-out works worse for 13 weeks;
   a boxer not backed loses 15 morale; a style push's shaky fights = an "ok" edge against her each round for 2 bouts.
5. **The forced falling-out** picks the worst pair that has worked together 4+ weeks (it had picked pairs already apart).
6. **A runaway**: a matched raise compounded every 26 weeks (the known name reached ~$1,950 a week). Raises stop at the top of
   the coach's band (grill Q17: $300 / $600 / $1,100) and come at most once a season.
7. **Ties count for every tied answer and hire** (stricter than first-listed, as v5/v6 did).

## 15. v8 TUNING (after the one-rep trial, BEFORE the full run; bars s10 unchanged)
Nothing tuned: the sizes stayed at the task's starting estimates (reason: `docs/COACHDEEP8_RESULT.md` s5). Two probe fixes only,
no rule changed: a parse slip and two name collisions from moving `_chance` into the rules file.

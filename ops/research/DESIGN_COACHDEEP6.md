# DESIGN_COACHDEEP6 - deep coaches v6: classes take the free evenings, the evening trade is cut (S542)

Task: ops/research/TASK_COACHDEEP6.md. Base: DESIGN_COACHDEEP5.md (every v5 rule stands unless this page changes it), its
result docs/COACHDEEP5_RESULT.md (FAIL 7/10: f, h, j - all three from the "class night or pad evening" trade), and the
owner's 24 answers (ops/research/COACHDEEP_GRILL_S539.md, binding). Q-311 "Bouts pay by rank" stands; the stipend stays $250
a week; v4's rank bands, the record line in the departure price, v5's catchment ceiling (66 small / 96 big), ties printed and
the chemistry size 0.15 stay. Probe: tools/coachdeep6.gd + tools/coachdeep6_rules.gd. Result: docs/COACHDEEP6_RESULT.md.
Nothing under scripts/ changes until the probe passes and two critics score 8.

DECISION (Claude S542, the owner's S534 free hand: "you can remove, add from scratch or interconnect"): the evening trade is
CUT as a choice and as a depth claim. Written here BEFORE any v6 run.

## 1. Classes take the free evenings (a timetable fact, not a decision)
A boxer on the roster keeps her pad evenings: the places she asks (ClubDeal.ASK ordinary 3, +1 in a fight week) with the
coaches the plan puts on her. Class nights run only on the coach evenings that no kept boxer needs - an evening with no pad
place used. The number of class nights is min(free evenings, class nights the members want); the week plan SHOWS it ("2 class
nights this week: Reid Tue, You Thu - the evenings your boxers do not need"), the player does not choose it.

Real-world reason: a club's head coach books the carded boxers' sessions first (they are the club's name, its fight-night
money and its reputation) and runs the kids' and fitness classes around them, on the other nights or with the other coaches.
England Boxing clubs typically split "squad nights" (carded boxers only) from open/junior sessions; a carded boxer is not
dropped from her sessions so a class can run. The class is the club's bread and butter, but it fills the timetable, it does
not displace the squad.

In the probe this is what v5's non-CLASS arms already did (places dealt first, `_assign`: an evening with no place used becomes
a class night if the members fill it, up to class_demand). v6 keeps that rule and removes the one arm that broke it.

## 2. The CLASS arm is gone
No plan may shed a boxer to free her evenings: the probe's arms are LAZY / STAT / CHEM / NEXT / STAR / SMART (v5's seven minus
CLASS). Letting a boxer go stays a separate act priced by the departure price (v4/v5 item, unchanged: her next year in the
game's cash, reputation and record lines + Leaving's reputation). A boxer still leaves by the loyalty rule if the plan leaves
her short (coach evenings are still fewer than all boxers want in some weeks), and that price is still charged.

## 3. Bar h is DROPPED, in writing
Reason: bar h asked that the class-or-pads evening be a real question in a third of the weeks each way. It failed in v3, v4 and
v5 in both directions (v3 class right 6 of 109; v4 79%, v5 82%; the boxer side right 0 of 117 and 0 of 45). With classes
taking only the free evenings there is no trade left to measure: in the small club no evening is short (66 members want 6
nights, 12 coach evenings hold 6 pad and 6 class evenings), and in the big club the only way the class won was by shedding
boxers, which s2 removes. The trade is therefore no longer a depth claim of this mechanic, and bar h is not measured.

## 4. Bars (written BEFORE any run, not loosened): v5's a-g, i, j word for word
- (a) No single assignment rule is the best arm (by score) in more than 6 of the 10 cells.
- (b) Chemistry moves an outcome by a line (cash $1,000, reputation 3, win less loss 0.5, or morale 5; best arm v CHEMOFF,
  paired) in at least 5 of the 10 cells.
- (c) The right coach differs by boxer (ALL_REID v ALL_X per boxer: at least one boxer prefers each coach) in at least 5 cells.
- (d) The best arm beats LAZY by at least one line of score in at least 5 cells.
- (e) Every effect counted in (b), (c), (d), (h), (i) is larger than 2 standard errors (paired); inside 2 errors does not count.
- (f) (f1) a departure is charged only by game items, the probe prints the mean price and its parts; (f2) in at least 8 of 10
  cells the best arm loses no more boxers than LAZY + 0.10 a career.
- (g) CHEM is the best arm in at most 5 of 10 cells with (b) passing; size by the sweep (s2's list), the full run at that
  size is the verdict.
- (i) Some candidate's best HIRE arm beats the best NOHIRE arm by > 2 errors in one club size and not in the other; and in at
  least one size some hire pays.
- (j) The best plan keeps its ranked boxers: in at least 8 of 10 cells the best arm loses at most 0.10 boxers a career who were
  on the regional table (rank > 0) when they left.
Bar a's arm list no longer holds CLASS (it is gone, s2). Bar e's mention of (h) has nothing to apply to. PASS = all nine.
Ties: as v5 s3 (arms within 0.01 line are tied; in a and g every tied arm counts as best).

Chemistry size: 0.15 (v5's sweep verdict). DECIDED before the run: the full run is at 0.15; the sweep is re-run only if CHEM
is best (ties counted) in more than 5 of 10 at 0.15 - then 0.10, as v5's written list allows, and the verdict runs at the
largest of the two with CHEM best in at most 5 (if neither, at 0.10 and bar g fails).

## 5. What is left to decide (the depth claim now)
With the trade gone the mechanic's choices are: (1) WHO COACHES WHOM each week (chemistry, playbook fit, specialties, the
fight-week film evening, the young boxer and teaching), measured by bars b, c, d and the spread between the six plans;
(2) THE PLAN - which rule of thumb the player uses (a, g); (3) THE HIRE by club size - which second coach, if any (i). The
probe prints each choice's measured size in lines (result s5).

## 6. Feedback loops
| Loop | Feeds back? | Cap | Checked in the one-rep trial |
|---|---|---|---|
| Class nights -> members target -> members -> class nights wanted | yes | v5 catchment (66 small / 96 big) | members at week 104 <= catchment + 5, every arm |
| NEW: free evenings -> class nights -> class cash -> a hire -> more coach evenings -> more free evenings -> more class nights | yes in the game; in the probe the hire is fixed per cell, so the loop is open | class nights wanted by the catchment (6 small / 9 big): a night past that earns nothing (class_share) and is never run (classes <= demand) | class nights run v wanted, and cash at week 104, per arm |
| Wins -> rank -> purse -> keeps the boxer -> more wins | yes | band top ($1,500 at number 1), the ladder's fixed rivals; she leaves only by the loyalty rule, charged the price | ranked_left, pay per arm |
| Wins -> reputation -> natural members | yes | the catchment; reputation clamps at 100 | members per arm |
| Chemistry -> learning -> wins -> rank | ONE-WAY in the code (v6 does not touch it): chemistry = traits + a bond that grows with coached weeks (cap 0.25), never with wins; wins move morale and loyalty, separate lines | bond cap 0.25, trust 0.7-1.05 | - |
ONE-REP TRIAL FIRST: mode=full reps=1 size=0.15. STOP and fix this map before the full run if members leave the band, if class
nights run past wanted, or if every cell converges on the same best arm.

## 7. Menus - every place the coach mechanic shows, and what each is wired to (after the critics; nothing built before)
| Menu | Shows | Wired to |
|---|---|---|
| Club office -> Staff tab | FM-style table: one row a coach, eight ratings 1-20, wage, evenings used / free, chemistry words with his boxers | coach rows (new fields), rules chemistry |
| Coach card (from the Staff tab, the week plan, a boxer card, the fight) | ratings, specialties (hover), playbook + "his plan for her", personality, his boxers | Data coach row; CoachPlan.write; spec_mult |
| Week plan - pad evenings | drag a coach onto each boxer's places; "alone" where nobody is; a boxer short of her ask is marked (loyalty) | the assignment -> pad skill per boxer (DrillWeek.pad_skill), ClubDeal.deal, Loyalty "short" |
| Week plan - class nights (A FACT, not a choice) | "2 class nights this week, on the evenings your boxers do not need: Reid Tue, You Thu - the members fill 6 (66 in your area)" | free evenings after the pads; ClubDeal.class_cash x class_share(n, members); Membership catchment |
| Members page / week review | "Your area: 66 people who would box. You have 58." | Membership catchment (new) |
| Boxer card (Playbook) | her coach, chemistry word + hover reasons, the bond in weeks, her combination and which coach teaches it at full | rules chemistry / bond; OwnCombos + spec |
| Hire list (Staff tab -> Hire) | each candidate's wage, ratings, and the free evenings he adds (more class nights only up to what the area wants) | wage bands; class_demand; catchment |
| Ask card / offer letter / bout page | the club's cut by her band ($450 / $1,000 / $1,200 / $1,500) | BoutRules.ticket_cut(rank) (new) |
| Leaving warning (boxer card, week review) | what walks out with her: her band's year, her expected wins | Leaving + year value |
| The fight | your corner's tactics (plan cards) and cutman; "their corner" links to the opposing card | CoachPlan rating, StaffRoles cutman (PHASE 2 for their card) |
Golden path (when built): hire a coach, put him on two boxers' evenings, see the class nights fill the free evenings on the
week plan, play the week, see the chemistry word after two weeks, fight with his plan.

## Prior research
COACHDEEP1-5 maps and results (v5 s4.3, s5), COACHDEEP_GRILL_S539.md, GymBills.gd, BoutRules.gd, StaffRoles.gd, Membership.gd.
prior_research.py "coach chemistry class night" (S542). The work follows COACHDEEP5's verdict (s5, "keep coaches, cut the
evening trade as a depth claim").

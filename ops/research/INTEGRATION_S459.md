# S459 INTEGRATE1 - built mechanics the game does not use yet

Operator S459: "need to finish integrating mechanics before we spend more time in designing the menus".
Audit (S459): every module in scripts/rules + scripts/state that no game script loads. Each is collected, tested, and
wired nowhere. Rule for each (S425): wired into the game path AND shown on the existing screen it belongs to (no new
menu design; the existing screen gets a line, a number or a tooltip), plus a test that plays it.

Order (Claude's call, fight path first - it is what every week ends in):

| # | Module | What it is | Where it plugs in | Shown on | Status |
|---|---|---|---|---|---|
| 1 | StyleName + MoveTree | the named style: 6 styles, each one fight lever; extra plan line; lost on Monday when the hold goes | Duels OPEN, Combos spend, PlanFight mid/counter edge, pressure answers, Knockdowns; Monday review; plan cap | the news at the week turn + the plan limit | DONE S459 (8c08210a, style_wire_test) |
| 2 | LineGrade | how well THIS boxer does each plan line (Good/OK/Poor from two attributes) | PlanFight.edge on planned lines | plan line grade word on the Plan screen | HELD for GRADE1: wired it drops a right plan's GOOD read 384 -> 161 of 540 (OK = x0.85 nerfs every average plan 15%); LineGrade.edge helper is in, the probe sets the numbers first |
| 3 | PlanPhase | lines live early/middle/late; last round if ahead/behind | PlanFight.choose by round | Plan screen line tag | DONE S460: ring (LiveRound pick via PlanFile.arrows_for), last-round pace (PlanFile.pace_for), forecast (BoutRead); Plan screen rounds pill per line + "R3 BY THE SCORE" pace row (GamePlanRows); phase_wire_test. Late-state extra LINES have no screen yet (pace only) |
| 4 | Towel | the towel card in the corner minute: risk shown, what each answer costs | CornerMinute | the corner minute card | |
| 5 | ProRead | pros get read across bouts: the corner waits for the punch thrown most | pro bouts: opponent read share | pro fight plan + result | |
| 6 | Loyalty | loyalty bands with dated reasons + forecast | week settle | fighter profile | |
| 7 | TraitLine | each trait: what it does now, next line, up and downside | read-only | profile traits tooltip | DONE S460: AttrBoard trait rows carry the line in force + the next line + per-point hover (only "code" lines; the three "new" hooks - Stubborn, Listens, skipped mornings - are NOT built, they show once built); trait_wire_test. TraitLine.crossed (a line crossed at the week turn -> news) not wired yet |
| 8 | TrainRead | the coach's read: which training each fighter needs | read-only | training scene / roster row | |
| 9 | TellWorth | what the next film session buys (a range of worth) | read-only | film choice tooltip | |
| 10 | Knowledge | what the player can see of a boxer (ranges that never lie) | opponent views | versus / scout | |
| 11 | ClubDeal | the club week's coach hours: who goes short | week settle | Schedule / office need | |
| 12 | CoachMarket | assistant coaches: growth, second slot, let-go | Staff hire | Staff screen | |
| 13 | AskBout + FightLearn | ask for a fight | waits on AMATEURWEEK1 (Q-209) | Bouts | waits |
| 14 | MatPrice | price of a no-gi plan line | BJJ plan | BJJ plan line | BJJ |

Not mechanics (tools / art measures, no wiring): BalanceHarness, PunchForm, PunchSnap, GroundRules (BJJ probe), TrainingWeek
(old board words), LiveRoundAfter (check: split helper, maybe dead).

## Pre-existing red tests found S459 (red on HEAD before any S459 change; control runs swapped the files back)
- bout_read_test: FIXED S459 (749903ea) - the forecast now fires planned lines like the fight (FireLevel share in PlanChain).
- fight_why_test: "a good plan reads GOOD in nine fights of ten" - 384 of 540 since S450 FIRELEVEL3 (Usable lines fire half the
  time, the grade divides by every exchange). Tried grading on fired uses only: 231 and the bad plan read GOOD 8 times - reverted.
  The test says the bar is a design call: decide with GRADE1 (both move a plan's worth).
- result_defects_test: "2. the bout's Why replaces a line (it fought a wrong answer)" - red on HEAD; not traced yet.

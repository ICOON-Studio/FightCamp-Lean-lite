# S459 INTEGRATE1 - built mechanics the game does not use yet

Operator S459: "need to finish integrating mechanics before we spend more time in designing the menus".
Audit (S459): every module in scripts/rules + scripts/state that no game script loads. Each is collected, tested, and
wired nowhere. Rule for each (S425): wired into the game path AND shown on the existing screen it belongs to (no new
menu design; the existing screen gets a line, a number or a tooltip), plus a test that plays it.

Order (Claude's call, fight path first - it is what every week ends in):

| # | Module | What it is | Where it plugs in | Shown on | Status |
|---|---|---|---|---|---|
| 1 | StyleName + MoveTree | the named style: 6 styles, each one fight lever; extra plan line; lost on Monday when the hold goes | Duels OPEN, Combos spend, PlanFight mid/counter edge, pressure answers, Knockdowns; Monday review; plan cap | the news at the week turn + the plan limit | DONE S459 (8c08210a, style_wire_test) |
| 2 | LineGrade | how well THIS boxer does each plan line (Good/OK/Poor from two attributes) | PlanFight.edge on planned lines | plan line grade word on the Plan screen | DONE S461: GRADE1 (Qwen, centred table arm H Good 1.15 / OK 0.99 / Poor 0.90: mean x1.017, right plan GOOD 375/540 vs 384 ungraded, Good vs Poor 22 in 100) wired in LiveRound + BoutRead + PlanChain; the grade word + its two attributes on every plan line (GamePlanRows.grade_tag); grade_wire_test. fight_why bar moved to two in three (S461 design call, reason in the test) |
| 3 | PlanPhase | lines live early/middle/late; last round if ahead/behind | PlanFight.choose by round | Plan screen line tag | DONE S460: ring (LiveRound pick via PlanFile.arrows_for), last-round pace (PlanFile.pace_for), forecast (BoutRead); Plan screen rounds pill per line + "R3 BY THE SCORE" pace row (GamePlanRows); phase_wire_test. Late-state extra LINES have no screen yet (pace only) |
| 4 | Towel | the towel card in the corner minute: risk shown, what each answer costs | CornerMinute | the corner minute card | DONE S461: TowelWire builds Towel's state after every round (m.towel); corner action "|towel=pull|box_safe|one_more"; pull = RTD loss, 14 days out, morale -4, loyalty logged, no injury roll; box safe = Hands up at Save pace (PlanFile.pace_for); SKIP BOUT = the coach pulls at the line; shown by TowelStrip on the 2D FightNight corner and the 3D CornerOverlay; towel_wire_test. NOT yet: the line (careful/normal/brave) has no picker on fight prep (reads bout.towel_line, default normal) |
| 5 | ProRead | pros get read across bouts: the corner waits for the punch thrown most | pro bouts: opponent read share | pro fight plan + result | SIZED S461: READ_EDGE = 6 (docs/READ1_RESULT.md, Claude's rerun - the seat's own page was not reproducible). Finding: a split or a feint covers only part of it (2.5 and 3.3 in 100 lost); only changing the plan answers it - to the design loop. Wire next: the edge in LiveRound (cap 470 - one line), fired counts per pro bout in the record, the target on fight prep, READ-PROOF |
| 6 | Loyalty | loyalty bands with dated reasons + forecast | week settle | fighter profile | WAITS LOYAL1 (S461, queued on Qwen, TASK_LOYAL1.md): its causes come from ClubDeal (#11) - short / full week / held pads; wire the two together after SHORTWEEK1 + LOYAL1 pass (CLUBWEEK map s8). TowelWire already logs its loyalty move |
| 7 | TraitLine | each trait: what it does now, next line, up and downside | read-only | profile traits tooltip | DONE S460: AttrBoard trait rows carry the line in force + the next line + per-point hover (only "code" lines; the three "new" hooks - Stubborn, Listens, skipped mornings - are NOT built, they show once built); trait_wire_test. TraitLine.crossed (a line crossed at the week turn -> news) not wired yet |
| 8 | TrainRead | the coach's read: which training each fighter needs | read-only | training scene / roster row | DONE S461: the roster Coach cell, when every check is green, reads TrainRead (word + session; the sums on the hover; no names) - RosterRow.green_cell; train_wire_test |
| 9 | TellWorth | what the next film session buys (a range of worth) | read-only | film choice tooltip | |
| 10 | Knowledge | what the player can see of a boxer (ranges that never lie) | opponent views | versus / scout | WAITS its bots probe (KNOWLEDGE_S411 build order step 2: a reading bot vs a blind bot, +5 top-10s per 60 worlds) - brief it next |
| 11 | ClubDeal | the club week's coach hours: who goes short | week settle | Schedule / office need | WAITS LOYAL1 (with #6) |
| 12 | CoachMarket | assistant coaches: growth, second slot, let-go | Staff hire | Staff screen | WAITS COACHFIT1 (coach design v4 at the critics, SQ74) |
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

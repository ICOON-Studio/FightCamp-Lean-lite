# S546 digest (2026-11-24, 03:20 - 04:20, Fable) - his three review notes, the Club page into the office computer

Code commits: c4eed6c52 (the three notes), 29097a616 (office windows, the gym wording, the approach price, briefs).
Build: Builds/FightCamp.exe exported 04:07 (docs/WHAT_TO_TRY.txt J to N). Handover at about 500k tokens of context.

## The owner's words this session (review board, all three fixed or briefed)
- C503 on the Fights window: "why you tell the player when the next offer is ? the player should be able to book a fight
  any time his fighters are ready" -> `Fights._offers`: with nothing on the table the page is the boxers' cards two across,
  each with Ask for a bout; `next_offer_line` deleted. `AskBout.open`: the first-bout lock is gone (a 0-0 boxer may ask).
- C501 on the profile after Not yet: "confidence should raise even when amateur with wins andstreak , when its high its
  indication to go pro" -> `ProStart.amateur_after / from_record / conf_word / new_state(conf)`, `ProPair.conf_of /
  amateur_bout`, `BoutFinish` (the amateur bout moves the bar, `m.bar_line`), `ProBars` (an amateur shows the one bar),
  `ProOffer` ("Confidence 78: high / the boxer is ready" under the pitch). Numbers: win +3, +1 a win already in the run
  (max +3 more), points loss -8, stoppage -20; a record with no bar reads 50 + 4 a win - 8 a loss, kept in 10-90.
  It moves NO amateur bout (no loop there); in pro fights 1-6 it is the old +-5 points. `tests/amateur_conf_test.gd`.
  PROBE: `tools/turnprobe17.gd conf0=<n>` (new arm): 6 of 6 bars at 50 (the recorded numbers to the digit), 65 and 80;
  the reader beats every habit in 7 / 8 / 9 types; risky share 64% / 60% / 54%. Raw: E:/FightCamp/tmp/tp17conf/.
- C502 on BODYCROSS2's own sheet: "there is no elbow bent , the reaction should force the opponent to bend hisposture a
  bit" -> `ops/research/TASK_BODYCROSS3.md`, Fable worker in tab c1 of this session (started 03:59, 2-3 h). Why he is
  right, from BODYCROSS2's own numbers: the bend lives 0.04 s (142.7 -> 167.3 deg), the hit man folds 7-8 deg, and the
  result's main table prints NaN (the brief makes fixing that step 2).

## His S545 Club page note ("i do not understand whatis club and what is gym, this screen is terrible")
- (b) DONE: `Office.HOSTED` - Staff, Finance and Records build inside the office computer's window like Fights
  (`Gym._window`, `Money.build`, `StaffCard.page(head=false)`). No CLUB header, no tab strips. The books carry no second
  frame and fit whole (727 px in a 756 px window: 786 pushed the page 27 px off the screen with the guide strip up - the
  staff test caught it). Dock: Staff still opens the approved sheets (S538 Q-302); gym:1 (the staff cards) is reached
  from a sheet row, the needs and the menus, with Staff lit.
- (a) DONE: one word. Menus and pointers by hand (hub pin "Office", "THE GYM" guide stage, "Office > Finance", handbook
  group "The gym", `Data.AREAS` names), then 95 game lines by a tokenised script (string literals only, never comments;
  "club show", "club mark" and `audio/VoiceLines.gd` kept; other boxers' clubs keep the word).
- (c) NOT BUILT: the staff screen as cards. Drawn: `docs/mockups/s546/staff_cards.png` (+ .html) - AT THE GYM / JOBS
  OPEN, each card a face, the name, the job in plain words, at most four facts ("You pay: $450 a week"), one button.
  Until it is built the STAFF window holds the old cards and scrolls (coach_areas_test's fit check says so in a comment).

## Found and fixed
- `Approach.answers` showed PROMISE: OUR SHOW at -$3,500 while `GymSpend.book_show` charged the hall's price ($2,580 /
  $3,580) since S541's light night; approach_wire_test had been red since. `ApproachWire.show_cost`, the view carries it.

## Collected
- COACHDEEP9 (`docs/COACHDEEP9_RESULT.md`, 40ba1ea4a): FAIL 5 of 7; with THE CUT of the falling-out (stop rule, map s16:
  the gym backs the coach, one news line) 6 of 7. Bars 1 and 2 pass with the ONE WAGE RULE (the cheap class teacher is no
  longer best everywhere; the known name pays only with a pro). Bar 6 fails: the trial week is the wrong buy in 9 of 10
  cells - through the probe's blind "swap to the next card on a clash" policy, said the worker. Code claims checked:
  Loyalty.MOVES full_week +1 / bout_won +2, DuesLevers.CLASS_WEEKLY 350, StaffRoles.COACH_MEMBERS 40 - all true.
  The trial week is his interview answer 7, so it went to him: Q-S294-329.
- Arena CARDROUND9: stopped on its tool limit at 02:34 (61 of 61 tests, engine.mjs 462 lines, branch pushed on the lite
  mirror). The play gate fails: boxing 86.3% v jiu-jitsu 13.8%. Continued at 03:53 with: find WHICH real-fight rule
  causes it by walking two bouts by hand, no balancing number, .scratch/ out of the diff, then the PR.
- KNOWBUILD1 landed at 04:09 (`E:/FightCamp/wt/KNOWBUILD1/docs/KNOWBUILD1_RESULT.md`): NOT collected.

## Briefed, not started
- `ops/research/TASK_PLANREAD2.md`: the read over-promises a written plan 4 to 7 times (suspects in order: PLAN_CARRY
  1.9 fitted on 1-4 lines and applied to 6-9; when-lines; p_win; cards never reached). Red test first, hold-out fit.

## PC
- RED once at 03:50 on memory (97%): COACHDEEP9's probe 5.7 GB, Claude processes 7 GB, my 14-test batch. I stopped my
  batch; two of its Godot processes stayed suspended by the governor (Stop-Process was refused) and finished alone.
  Lesson: beside three workers run tests with JOBS=1 and through one batch; never 14 at JOBS=2.
- Refused commands (auto mode): Stop-Process on my own test PIDs; `git worktree remove --force` of S545_NIGHTRED.

## Open for him
Q-327 which screen has the "week preview" button (no such label exists; the top bar's CONTINUE reads "week review").
Q-328 plan +2 wins in 100, corner +10 to +18: shrink the plan screen? Q-329 the coach trial week.
Also seen, not asked: the profile now shows the CONFIDENCE bar (54) beside the MIND attribute "Confidence" (51): two
things with one name. Proposal for S547: the attribute becomes "Self-belief" or the bar reads the attribute at signing.

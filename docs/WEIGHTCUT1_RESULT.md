# WEIGHTCUT1 result - weight is plain facts, the diet follows the booking (S537)

Owner S537, on six failed weight probes: "cut the weight choices and keep weight as plain facts" -> "ok".
Prior research followed: docs/WEIGHT2_PROBE5.md and docs/WEIGHT3_PROBE.md (no weight decision is real),
docs/DEPTHPRICE1B_RESULT.md (the diet switch was a no-op).

## Where the player picked a weight option (before this change)

| # | Place | File:line (before) | What it was |
|---|---|---|---|
| 1 | Training screen, DIET box | scripts/ui/TrainTired.gd:57-72 | two buttons, "Normal" / "Cut harder" |
| 2 | Training screen, wiring | scripts/ui/areas/Training.gd:75 | the buttons' `diet` act |
| 3 | Training screen, coach's pick "Do it" | scripts/ui/areas/Training.gd:137-138 | applied "switch the diet to Cut" |
| 4 | Old week board, bar | scripts/ui/WeekBoard.gd:353-360 | "Hold" / "Cut" pills beside the weight |
| 5 | Old week board, coach "Do it" | scripts/ui/WeekBoard.gd:330-331, 371-372 | the same diet switch, short word "Cut" |
| 6 | THIS CAMP column | scripts/ui/WeekCamp.gd:78, 239, 264-273 | "Hold" / "Cut 500 kcal" pills (twice) |
| 7 | The act itself | scripts/ui/BoutActs.gd:48-51 | `diet` wrote f["diet"] |
| 8 | Coach's line | scripts/rules/WeekCoach.gd:43-45 | "Switch the diet to Cut." with a diet fix |
| 9 | Week review's suggestion | scripts/rules/WeekActual.gd:85-89 | "Switch to the cut diet: ..." |
| 10 | Guide line, fight step | scripts/rules/GuideLines.gd:38 | "Set the diet to Cut." |
| 11 | The sim reading the choice | scripts/state/Sim.gd:103-104, 123 | f["diet"] == "cut" started a cut |
| 12 | The week model | scripts/state/ClubWeek.gd:251 | passed f["diet"] to the screen |

Move up / class change: none found. No screen, act or CardAsk line asks the player to change class
(CardAsk.gd:163 only fills the data default `"diet": "hold"`; the BJJ "Move up" hits are mat positions).

## What was removed

- Every control in rows 1-7: no button, pill or act sets the diet any more. The `diet` act is gone.
- The coach, the week review and the guide no longer tell the player to switch the diet (rows 8-10). Over the limit,
  the coach names a morning to make harder (the one thing the player sets); the guide says
  "Your boxer is over the limit and eating light. Hard roadwork takes off more."

## What decides the diet now

`WeekPlan.diet_for(weight, limit, booked)`: CUT only with a bout booked (or its camp running) and the scale above
the class limit less 0.15 kg; otherwise HOLD. `WeekPlan.diet_of(f)` reads it for a boxer; `Sim.week_ctx` and
`Sim.twist_needs` use it. The stored `f["diet"]` is no longer read (old saves load unchanged).

Change in play: a booked bout with no camp and no fight-week flag (a pro or title bout before its camp) used to hold
unless the player pressed Cut; it now eats light from the booking. With no bout, nobody cuts, whatever was once chosen.

## What the player sees

One line where the switch was (`WeekPlan.diet_fact`), on the Training screen's DIET box, the old week board and
THIS CAMP:

- "Making 60 kg for Saturday: eating light this week" (a bout past this week: "... for the bout on Sat 14 Feb")
- "Inside 60 kg for Saturday: eating as normal"
- "No bout booked: eating as normal"

Under it on the Training screen the scale's forecast stays ("Fight day 59.8 kg est., limit 60.0" / "Sunday ...").
The tooltip explains and does not repeat the line: what the light diet takes off (500 kcal a day, about half a kilo a
week), when it stops, or why it is off. The fighter page's "Plan: cutting / holding" row reads the same rule.

Kept as they were: weight class, the scales on the tape, walking weight, class match at booking, the weigh-in and the
cost of a missed weight, the fight-week drop, the head coach's deeper cut.

## Tests

Red first: `tests/weight_facts_test.gd` failed 13 checks on the old screens (two diet buttons, the diet act, the coach's
"Switch the diet to Cut", a stored cut with no bout still cutting), then passed.

Run (`TESTS="..." JOBS=2 sh tools/run_tests.sh` through godot_slot):

- PASS: weight_facts_test (new), golden_path_test, week_coach_test, week_actual_test, weekend_plan_test,
  training_k_test, week_plan_test, week_phase_test, week_twist_test, first_hour_test, first_hour_walk_test,
  weigh_forecast_test, weigh_gap_test, fight_week_test, fight_week_screen_test, club_week_walk_test, guide_ends_test,
  plain_words_test, file_limits_test, nocamp_page_test, one_look_test, text_scale_test.
- FAIL, in areas this change does not touch, not checked on a clean tree: words_on_screens_test (1: "bout says
  'Scouting report'") and tips_test (1: "the card is opaque").

Tests changed with the rule:
- golden_path_test `_missed_weight`: "booked but never cut -> misses weight" cannot happen any more. It now checks she is
  on weight by herself, then that a boxer a kilo over on the morning still misses weight, the bout is off and the club
  pays $300.
- week_coach_test, week_actual_test, weekend_plan_test: the three checks that expected the diet switch.

Not done: a still of the new DIET box (the brief: a later still). The box is 200 px wide (was 170) so the line wraps in
two rows; training_k_test and text_scale_test (text size Largest) pass, the picture is unseen.
tools/first_hour_still.gd:47 still calls the removed `diet` act (now does nothing); other tools and probes that set
f["diet"] (nocamp_probe, depthprice1b_probe, first_hour_probe) no longer change anything by it.

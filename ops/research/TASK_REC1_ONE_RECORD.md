# TASK REC1 - one record, everywhere (design review S172 finding 5)

Model: Cursor (Godot UI scripts). Worktree E:/FightCamp/wt/GYM4G (has the Godot import cache), branch cursor/rec1-one-record from origin/master.
Tier: scripts edited + a new test -> parse gate + the new test + `--only ui_kit`, `--only schedule`, `--only training_floor`, `--only profile` (`--jobs 2`).

## Prior research
`python Tools/prior_research.py record amateur display` -> topics/rules_orgs.md, U4 (amateur bouts). DEMO_DESIGN_REVIEW_S172.md finding 5:
"Amateur and pro records are shown inconsistently; trust in every number drops" - the same fighter read "7-4-1" on his card, "7-4" on
the gym card and "0-0-0" on the offers. Cause (S181 read): an amateur keeps `amateur_record` beside his pro `record`;
`UIKit.shown_record(athlete)` (UIKit.gd line 218) already picks the right one, but most screens format their own string from `record`
(27 ad-hoc "%d-%d-%d" / "%d-%d" sites), and the gym card drops the draws.

## What would a human do?
Box score convention: a record is always W-L-D, and an amateur record is labelled as amateur (BoxRec lists "amateur" separately). One
helper, every OUR-fighter display reads it.

## Prefab check
None needed: `UIKit.shown_record` is the authority; this adds its text form and routes screens to it.

## Owned files
- `Godot/scripts/UIKit.gd` (~7400 lines; read `sed -n 210,226p`). Add next to `shown_record`:
  `static func record_text(athlete: Dictionary) -> String` = "W-L-D" of `shown_record(athlete)`, plus " AM" when the record shown is the
  amateur one (not turned_pro AND amateur_record has any bout). Never "W-L".
- `Godot/scripts/TrainingFloorPanel.gd` (read `sed -n 520,550p`): spar roster rows `"%d-%d"` -> `UIKit.record_text(athlete)` for OUR roster
  (line ~531). Partners (line ~545) are world fighters: W-L-D of their `record`.
- `Godot/scripts/ScheduleHubPanel.gd` (read `sed -n 1790,1815p` and `sed -n 2960,2970p`): `_our_record` + `_record_text` - the offers row
  for OUR fighter shows `UIKit.record_text(athlete)` (amateur offers already read get_amateur_read: keep the same numbers, add the tag).
- `Godot/scripts/ProfileRevampPanel.gd` (read `sed -n 460,475p`): the record block already uses shown_record - add the AM tag the same way
  (a small caps label beside the number, not inside the 60 px number).
- New test `Godot/tests/one_record_test.gd`.
Do NOT touch opponents' / world fighters' displays beyond the partner row above (their record is their pro record).

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/one_record_test.gd` -> `ONE RECORD PASS`, rc 0:
- `record_text` for {amateur_record 7-4-1, record 0-0-0, turned_pro false} == "7-4-1 AM"; turned_pro true with record 2-0-0 == "2-0-0";
  an amateur with no amateur bouts and record 0-0-0 == "0-0-0" (no tag on an empty record); a draw shows (1-0-1, never "1-0").
- a real career fixture (copy the setup of tests/fight_camp_test.gd lines 84-95: begin_new_career, generate_starter_boxing_floor,
  finalize_new_career "Cyprus"/"Nicosia"), give roster[0] amateur_record 7-4-1 and record 0-0-0, then read his record where the screens
  build it: the training floor's spar roster row text, the offers' `_our_record` -> text, and the profile record block - ALL read
  "7-4-1" with the AM tag. (Build the panels headless the way tests/schedule_my_gym_test.gd and tests/training_floor_test.gd do.)
- MUTANT: make TrainingFloorPanel go back to "%d-%d" of `record` -> the test goes red. Say in the commit that you ran it.
Parse gate first: `python Godot/tools/check_scripts.py scripts/UIKit.gd scripts/TrainingFloorPanel.gd scripts/ScheduleHubPanel.gd scripts/ProfileRevampPanel.gd tests/one_record_test.gd`.

## The one trap
`GameState.gd` is ~19,000 lines - do not read it whole and do not edit it. Headless Godot ONLY with `Godot_v4.7.2-stable_win64.exe
--headless` (never `_console.exe`: it opens a terminal on the operator's screen). No images, browsers or windows opened.
Commit with `git add -- <paths>`, push your branch, stop. Claude reviews and merges.

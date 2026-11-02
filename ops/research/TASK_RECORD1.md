# TASK RECORD1 (S211) - one record, everywhere (Arena, pure: source edits + a contract test, no 3D models)

Model: Arena Agent Mode, its own branch arena/<chat-id>-fightcamp, it opens the PR; Claude reviews and merges. Never master.

## The defect (S172 design review finding 5, still live on master)
The same fighter's record shows three ways across screens ("7-4-1", "7-4", "0-0-0"). `UIKit.record_text(athlete)`
(`Godot/scripts/UIKit.gd` ~line 230) is the ONE correct formatter: W-L-D of `UIKit.shown_record(athlete)` plus " AM" when the read is the
amateur ledger (not turned pro, carries amateur_record). Its own doc says: "Never the old two-number W-L form". Yet these screens
hand-roll the text and ignore the amateur ledger:
- `FightNightScreen.gd` (1,875 lines) ~869 and ~879: `"%d-%d" % [wins, losses]` - the banned two-number form, twice.
- `CandidateCard.gd` (458) ~443, `FightCamp.gd` (425) ~352, `FightWeekPanel.gd` (613) ~163, ~413, ~484, `FilmRoomPanel.gd` (204) ~95,
  `FightWorldLiveScreen.gd` (6,645 - edit ONLY ~5527, use sed -n windows, never read whole) , `FightResultPanel.gd` (1,721) ~1227,
  `FightRecordStats.gd` (181) ~145, `GameState.gd` ~19072 (`record_line`; GameState is huge - edit only that line window).

## Prior research
research/DEMO_DESIGN_REVIEW_S172.md finding 5 + "New-plan defects"; UIKit.gd `shown_record` / `record_text` / `_on_amateur_book`.
## What would a human do?
One helper, every screen calls it; a test that fails the build if anyone hand-rolls a record again.
## Prefab check
None - our UI helper exists already.

## Do
1. Replace every athlete-record display above with `UIKit.record_text(<athlete dict>)` (preload UIKit where the script does not have it:
   `const UIKit := preload("res://scripts/UIKit.gd")` - check the script's existing preloads first, never a duplicate const name).
   Where only an opponent dict with wins/losses exists (FightNightScreen `who`), build `{"record": {"wins":w,"losses":l,"draws":d},
   "turned_pro": <from who, default true>}` or pass `who` straight if it already carries `record` - draws must show.
2. NOT records - leave alone: scorecards ("%d-%d-%d CARDS", judge totals "%d-%d"), knockdowns "KD %d-%d", corner "UP/DOWN %d-%d",
   age windows in GameState ~11547.
3. NEW test `Godot/tests/record_text_everywhere_test.gd` (extends SceneTree, pure, no scene loading): (a) unit checks of
   `UIKit.record_text`: pro 7-4-1 -> "7-4-1"; amateur not-turned-pro 0-0-0 -> "0-0-0 AM"; turned pro with an amateur_record -> the pro
   record without AM; missing draws -> "-0". (b) a SOURCE SCAN of every `res://scripts/**/*.gd` (DirAccess walk, read text): fail on any
   line that formats wins/losses itself - regex for `%d-%d` within 3 lines of `wins` or `losses` - except an explicit allow-list of the
   non-record lines in step 2 (file + a substring of the line). The scan must FAIL on today's master (prove it: paste the FAIL lines in
   the PR) and pass after.
4. Parse gate `python Godot/tools/check_scripts.py <every touched .gd>`; run your new test plus any existing test whose file name contains
   `record`, `candidate_card`, `fight_week`, `film_room` (list what you ran). CI has no LFS: do not add tests that load models.

## Owned files
The scripts listed above (only the named line windows), `Godot/tests/record_text_everywhere_test.gd`. Nothing else.

## The one trap
Do not "fix" it by deleting or loosening an existing test, and do not widen the allow-list to make the scan pass - every allow-list
entry must be a non-record line from step 2.

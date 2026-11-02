# TASK HUDDEF2 (S222) - the day timeline bar draws a second set of pause/play/fast + date over the top bar

Model: cloud Cursor (label `cursor`). Repo ICOON-Studio/FightCamp, branch `cursor/issue-<n>` from master. Open a PR, never merge.
No Git LFS on the cloud box: tests must not load models. Do not delete or shorten any existing test.
Seen by Claude on the game camera (`previews/huddef2/top_bar_clash.png`, 1920x1080, tools/gymlook3a_stills.gd -- as_game):
the top bar's centre block (date chip "Mon 9 Feb 2026 Wk 6", pause/play/fast, fighter name, bell) and the `timeline_bar` strip
(S221 switched ON: its own pause/play/fast + "Week 6 2026" + day cells Mo 9 ... Th 19) are drawn ON TOP of each other at x 540-1540,
y 10-80. Two sets of time controls, unreadable. Operator rule S221: the timeline bar stays ON.

## Do
ONE set of time controls. The timeline bar replaces the top bar's date chip + pause/play/fast (it is the newer, approved design -
grep `timeline_bar` in `ShellChrome.gd`, `ClubSpeedControls.gd`, `CareerRoot.gd`); the top bar keeps cash/runway (left), the fighter
name + bell, and NO BOUT BOOKED / Continue (right), laid out so nothing overlaps at 1920x1080 and 1280x720. With `timeline_bar=0`
(the test's OFF arm) the old top bar is unchanged.

## Acceptance - NEW `Godot/tests/top_bar_timeline_test.gd`
(a) with timeline_bar ON: exactly ONE visible pause button, ONE play, ONE fast-forward in the career shell; (b) no two visible Controls of
the top bar + timeline bar intersect (global rects) at 1920x1080 and 1280x720; (c) timeline_bar=0: the old top bar's controls are present
as before. (a) and (b) must go RED on master first - say so in the PR. Parse gate `python Godot/tools/check_scripts.py <touched .gd>`.

## The one trap
Speed controls are wired to the clock in two places today - remove the duplicate's DRAWING and keep one wiring; pausing from the kept
control must still pause the day (test it).

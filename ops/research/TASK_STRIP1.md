# TASK STRIP1 (S223) - the 12-day strip leaves the top bar; the days live in the right-edge calendar drawer

Model: cloud Cursor (label `cursor`), composer default. Branch cursor/issue-<n>; never master. Read `.github/CLOUD_AGENT.md` first.
Approved: operator Q-S221-3 "Approve, build it" on `research/LUDO_ROUND61_VERDICT_S223.md` part B (read it; Ludo's full spec
`research/LUDO_ROUND61_REPLY_S223.txt` PART B). Operator notes verbatim: "is the calendar strip in the game ?", "are we using
the calendar strip or no , what ludo says ?". Ludo's ruling: remove the 12 day tiles from the top bar; the days go in the drawer.

## What exists (master after S223 HUDDEF2 253b5d11 / its parent)
- `Godot/scripts/TimelineBar.gd` (193 lines) builds the top bar's "TimelineBar": speed buttons, the date plate ("Today", ~line 93)
  and the day strip `strip.name = "Days"` (~line 106). Switch `timeline_bar` (GAME_ON).
- `Godot/scripts/ShellChrome.gd` (1147 lines) `_layout_v3_timeline_header` (~637) lays the bar out between the money pills and the
  bout card at 1920 and 1280; `Godot/scripts/GymHallPanel.gd` puts the day line + SKIP + STEP IN on the row under it (S223).
- `Godot/scripts/FightWeekRail.gd` (168 lines) = the thin right-edge tab that opens a rail with the booked bout's dates.
- Tests: `Godot/tests/timeline_bar_test.gd`, `Godot/tests/top_bar_timeline_test.gd` (18 checks: one speed row, no overlap).

## Do
1. TimelineBar: drop the "Days" strip from the bar when the new switch `calendar_drawer` is ON (GAME_ON, ships ON, read via
   `GameSwitches.on()`). The bar keeps speed buttons + the date plate (MON 9 FEB / WEEK 6 2026). Re-lay the header so the centre
   block is ~580 px wide at 1920 and fits at 1280 with no overlap (extend top_bar_timeline_test's overlap check).
2. The right-edge tab (FightWeekRail's button) shows the countdown to the next event ("5d", or nothing booked = a calendar icon)
   and opens a 480 px drawer over the right of the screen with TIME PAUSED while open (the timeline clock's existing pause on
   open panels): 4 weeks of day tiles (~80x96 px), today outlined gold, past days dimmed; per day the events the game already
   knows: bout (crimson #C62F2A), weigh-in (gold scale #E5B842), medical/suspension (white cross on red), travel (slate blue
   #2A5F9E), payroll/upkeep due (amber coin #D98039). Read only what GameState already exposes (fight-week card, schedule, the
   weekly payroll day) - add a small pure reader if needed; never invent events. A click on a day shows that day's lines in a
   tooltip (UIKit.tip, the one tooltip system). Key C toggles the drawer.
3. OFF (`calendar_drawer` off, plain --script tests): the bar and the rail exactly as today.

## Gate
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- New test `Godot/tests/calendar_drawer_test.gd`: ON -> no "Days" node in the TimelineBar; the drawer opens/closes on the tab and
  on C; the clock is paused while open and resumes on close; a booked bout + weigh-in show on the right day tiles; OFF -> the
  Days strip exists as before.
- Existing: `python Godot/tools/run_tests.py --jobs 2 --only timeline,top_bar,fight_week_rail,hud`.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, screen form)
1. A still of today's top bar first (RED: the 12-day strip in the bar).
2. Stills at 1920x1080 and 1280x720 from the game's own flow (`-- as_game`): the floor with the new bar, the drawer open with a
   booked bout (`Godot/tools/gymlook3a_stills.gd -- as_game out=...` gives the floor camera).
3. Report per still: overlaps, clipped text, positions, what the player reads.
4. Do not call it accepted. Claude opens every still; the operator closes it.

## Prior research
LUDO_ROUND61_REPLY_S223.txt part B; LUDO_ROUND31_VERDICT_S197.md s1 (one time bar, calendar = right-edge tab); DECISION_LEDGER D37.

## What would a human do?
Football Manager: the top bar is the clock; the calendar is one click away and pauses the game while you read it.

## Prefab check
Nothing to fetch: reuse TimelineBar, FightWeekRail, UIKit.tip and the timeline clock's pause.

## The one trap
The day line + SKIP + STEP IN row (GymHallPanel, y 84 under the bar) must keep working - top_bar_timeline_test checks it; do not
remove it with the strip.

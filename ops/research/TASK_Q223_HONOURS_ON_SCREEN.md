# TASK Q223 - the career's honours on screen: honours board, trophy cabinet, title clock (UI wiring, Qwen)
Owner: Qwen (qwen3-coder --yolo). Worktree D:/FightCamp/wt/Q223, branch qwen/q223-honours (from master).
Operator 2026-10-01: "reward the player for progressing" + "use icons when its possible to skip text (with the necessary
toolltip of course)". S137_WIRING_AUDIT.md section B: these three modules are BUILT and TESTED but nothing calls them.

## Why
- `Godot/scripts/HonoursBoard.gd` (G25): `board(title_rows, event_rows) -> Array`, `summary(rows)`, `row_words(row)` -
  what a career has won. No caller.
- `Godot/scripts/MedalTable.gd` (G26): `table(entries) -> Array`, `totals(rows)`, `row_words(row)` - a gym's trophy
  cabinet. No caller.
- `Godot/scripts/TitleTenure.gd` (G21): `tenure(belt, current_week, rules) -> Dictionary`, `words(read)` - is a champion
  overdue to defend. No caller.
A player wins belts and tournaments and never sees a cabinet, an honours list or a defence clock.

## Prior research
`python Tools/prior_research.py honours titles trophy cabinet belt defence tenure`; each module's header + its test
(tests/honours_board_test.gd, medal_table_test.gd, title_tenure_test.gd - they show the input shapes). Find the data:
`grep -n "titles\|title_history\|belts\|grand_prix_titles\|event_wins\|medal" Godot/scripts/GameState.gd | head -40`
(17,655 lines - sed windows only). Screens: Godot/scripts/ProfileRevampPanel.gd (fighter card; it already draws
`grand_prix_titles` ~1547-1630 - copy that style), Godot/scripts/OfficeHubPanel.gd (the office).

## What would a human do?
Football Manager's trophy cabinet + the UFC belt clock: on the fighter card an HONOURS block (belts, tournament wins,
event wins, each an icon - crown / trophy / medal - with a tooltip naming the event and week); a champion's belt shows
"defend by week N" as an hourglass icon that turns amber/red as it nears (TitleTenure); the office shows the GYM's trophy
cabinet (MedalTable totals as icon tiles). Empty states read as a goal ("NO BELT YET - WIN A REGIONAL TITLE"), never blank.

## Art direction (operator, binding)
Icons over text with a framed tooltip (DesignLibrary/GLOSSARY.md "Icon with tooltip"). Icons: `UIKit.icon_plate(<name>)`
from Godot/assets/icons/lucide (crown, trophy, medal, award, hourglass, podium); tooltips `UIKit.tip(node, {"text": ...})`.

## Owned files
- `Godot/scripts/ProfileRevampPanel.gd`: an HONOURS block (HonoursBoard) + the title clock (TitleTenure) for a champion.
- `Godot/scripts/OfficeHubPanel.gd`: a TROPHY CABINET block (MedalTable).
- `Godot/scripts/GameState.gd`: ONLY thin reads that gather the rows these modules take (no rule changes).
- NEW `Godot/tests/honours_on_screen_test.gd`: a career state with a belt + a tournament win -> the card's HONOURS block
  lists both with icons and tooltips; a champion past half his window shows the amber clock; the office cabinet totals
  match MedalTable.totals; a fighter with no honours shows the goal line (control). Two fighters always DIFFER.
- Stills (hidden windowed via `Tools\godot_hidden.ps1`) -> `previews/q223/`; OPEN THEM. NEW `research/Q223_DIGEST.md`.
- Never edit HANDOFF.md.

## Tests
Parse gate (`python Godot/tools/check_scripts.py <touched .gd>`); the new test; then
`python Godot/tools/run_tests.py --jobs 2 --only honours,medal,title,profile,office,smoke,ui_kit`.
Watchdog first: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
`var x := <call>` fails on a Variant return - type it. Full-rect Controls: never assign `size` on mount; `remove_child`
before `queue_free`. A parse error HANGS a headless test - parse gate first.

## Finish
git add by explicit path, commit, git push -u origin qwen/q223-honours. Do not stop at "written".

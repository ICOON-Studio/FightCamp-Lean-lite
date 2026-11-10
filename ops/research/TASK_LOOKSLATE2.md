# TASK LOOKSLATE2 - CURSOR (Grok 4.7 High) - the Club People page on slate and wood

Status: OPEN (S418, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator approved the wood and slate look (Q-S294-159: "Yes, build this look") and then said "Yes, slate everywhere" (Q-S294-162). S417 built the look into the shared theme (scripts/ui/WoodKit.gd); LOOKSLATE1 moved the Training week page (merged, bbc6cbbd: read its diff, it is the pattern). Club > People still paints cream paper cards: the owner card, each coach's card with the five area bars, the four "hire" tiles and the three small tiles under them.

## Contract
OWNS: scripts/ui/StaffCard.gd, scripts/ui/areas/Gym.gd, tests/people_slate_test.gd
RED_TEST: tests/people_slate_test.gd -> PEOPLE_SLATE failures=0
REGRESSION: coach_areas_test, wood_kit_test, words_on_screens_test, grey_reason_test, golden_path_test
VISUAL: yes

## Prior research
scripts/ui/WoodKit.gd whole (about 130 lines): `slate()` the framed slate, `PIECE` the wooden buttons, `ink()` the pass Main.render runs on every page (words in the paper inks UI.FG / UI.MUTED / UI.GOLD turn chalk on a dark surface; it reads the surface from the nearest panel's or button's own stylebox), `fg(self)` / `muted(self)` / `blue(self)` and `on_dark(self)` for a control that draws its own words or bars in `_draw`. `git show bbc6cbbd` (LOOKSLATE1) is the same job done on another page. tests/slate_walk.gd is the shared checker: read its header. scripts/ui/DarkOverview.gd is a page already on this look. ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md (a stylebox read before the node is in the tree is Godot's default).

## What would a human do?
Take the cream paper off every card on the page, put each person on a framed slate, keep every word, number, bar, portrait and button where it is, and check nothing went dark on dark.

## Prefab check
WoodKit has every piece. No new art, no new colours: WoodKit.INK, SOFT, HEAD, BLUE and the existing UI.GREEN / UI.RED / UI.AMBER.

## The job
1. `StaffCard._paper()` and every other panel the page paints (lines near 85, 108, 267, 313, 347, 374 use `_paper` or `RosterCards.PAPER_DEEP`): the big cards (owner, each coach) become the framed slate (theme variation "Card", or `WoodKit.slate()`); the small tiles inside a card or under the page become a see-through panel with a thin chalk outline, `UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, ...)`. A hired or selected tile: the outline in WoodKit.HEAD, 2 px. Do not edit RosterCards.gd: stop using its PAPER colours here.
2. The area bars and anything else drawn in `_draw`: track `Color(WoodKit.SOFT, 0.30)`, text and ticks through `WoodKit.fg(self)` / `muted(self)`. A green fill stays UI.GREEN.
3. Words keep UI.FG / UI.MUTED / UI.GOLD in the code: the ink pass turns them chalk. A word you colour yourself for a dark surface uses WoodKit.INK / SOFT.
4. The red Hire buttons and the wooden buttons stay as the theme draws them.
5. Layout, sizes, words, tooltips and every node name stay. The page must not get taller: a framed slate has a 22 px frame a side, so trim the card's own margins by the same amount.

## tests/people_slate_test.gd (write it first, red on main)
Headless, modelled on tests/week_slate_test.gd. Open the game, `main.act("quick")`, go to Club > People as tests/coach_areas_test.gd does, `WoodKit.ink(page)`, settle 3 frames, then `for fault in SlateWalk.faults(page): fail` (SlateWalk = preload("res://tests/slate_walk.gd")). Also check: the page's node count of visible Labels is the same before and after your change is NOT testable, so instead check by name that the owner card, at least one coach card and the four hire tiles are still found. Print the bottom edge of the last card and `PEOPLE_SLATE failures=N`.
Write no check that can only pass: if you compare an edge with 1080, the page must end at or ABOVE the line (`<=`), and print the number.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). No file over 500 lines (StaffCard.gd is 391). You cannot see images: Claude renders the page and judges it. No fixed he or she in any text. Change no rule module and no number.

## The one trap
The ink pass reads the NEAREST panel or button behind a word. A cream panel left inside a slate keeps its words dark, and a see-through tile on a slate turns them chalk. So a panel must be either clearly dark or see-through, never a pale tint at half alpha.

## Result lines (PR body)
RESULT: tests/people_slate_test.gd -> PEOPLE_SLATE failures=0
RESULT: tests/coach_areas_test.gd -> COACH_AREAS failures=0
RESULT: tests/wood_kit_test.gd -> WOOD_KIT failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0

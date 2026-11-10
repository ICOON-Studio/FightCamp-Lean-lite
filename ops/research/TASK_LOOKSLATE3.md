# TASK LOOKSLATE3 - CURSOR (Grok 4.7 High) - Fight camp and the bout offer on slate and wood

Status: OPEN (S418, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator approved the wood and slate look (Q-S294-159: "Yes, build this look") and then said "Yes, slate everywhere" (Q-S294-162). S417 built the look into the shared theme (scripts/ui/WoodKit.gd); LOOKSLATE1 moved the Training week page (merged, bbc6cbbd: read its diff, it is the pattern). Two fight screens still paint pale cards: the FIGHT CAMP pop-up (five white focus cards with their pictures, the three intensity cards, the partner and film cards, the boxer's side panel) and the bout offer's centre card between the red and blue halves.

## Contract
OWNS: scripts/ui/CampCard.gd, scripts/ui/CampSide.gd, scripts/ui/CampMatch.gd, scripts/ui/VersusPanel.gd, tests/camp_slate_test.gd
RED_TEST: tests/camp_slate_test.gd -> CAMP_SLATE failures=0
REGRESSION: camp_cards_test, camp_protocol_test, versus_test, wood_kit_test, grey_reason_test, golden_path_test
VISUAL: yes

## Prior research
scripts/ui/WoodKit.gd whole (about 130 lines): `slate()` the framed slate, `PIECE` the wooden buttons, `ink()` the pass Main.render runs on every page and MainFlow.render_modal on every pop-up (words in the paper inks UI.FG / UI.MUTED / UI.GOLD turn chalk on a dark surface; it reads the surface from the nearest panel's or button's own stylebox), `fg(self)` / `muted(self)` / `blue(self)` and `on_dark(self)` for a control that draws its own words, lines or bars in `_draw`. `git show bbc6cbbd` (LOOKSLATE1) is the same job done on another page. tests/slate_walk.gd is the shared checker: read its header. scripts/ui/DarkOverview.gd is a page already on this look. ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md (a stylebox read before the node is in the tree is Godot's default).

## What would a human do?
Take the white and cream off every card on both screens, keep each card's picture, words, numbers and buttons where they are, show the chosen card with a gold edge instead of a pale blue fill, and check nothing went dark on dark.

## Prefab check
WoodKit has every piece. No new art, no new colours: WoodKit.INK, SOFT, HEAD, BLUE and the existing UI.GREEN / UI.RED / UI.AMBER.

## The job
1. scripts/ui/CampCard.gd: `_frame()` (line 142) fills a card with UI.PANEL, or BLUE_SOFT when chosen. Both go: see-through with the chalk outline; chosen = WoodKit.HEAD 2 px; hover = WoodKit.BLUE. BLUE_SOFT, BLUE_RING and SUB are pale-page colours: stop using them (CampSide reads CampCard.BLUE_SOFT at line 78: give the chosen row the gold outline there too). The card's ink picture keeps its own light backing: that is a picture, leave it.
2. scripts/ui/CampSide.gd: the side panel (PAPER, line 29) becomes see-through with the chalk outline; INK2 words become UI.MUTED.
3. scripts/ui/CampMatch.gd: the partner card the same way.
4. scripts/ui/VersusPanel.gd: PAPER / PAPER_DEEP / EDGE (lines 23-25, used at 113, 131, 206) go. The centre card becomes `WoodKit.slate()`; the small strips inside it see-through with the chalk outline. The red and blue halves, the two boxers and the crests are untouched. Line 249 gave the Pass button the "Btn" variation because the quiet style vanished on paper: check it still reads on slate and keep whichever variation does.
Common to every step: a big panel becomes the framed slate (theme variation "Card", or `WoodKit.slate()`); a small card or tile inside it becomes a see-through panel with a thin chalk outline, `UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, ...)`; the SELECTED one takes the outline in WoodKit.HEAD, 2 px. Words keep UI.FG / UI.MUTED / UI.GOLD in the code (the ink pass turns them chalk); a word you colour yourself for a dark surface uses WoodKit.INK / SOFT. Layout, sizes, words, tooltips and every node name stay. Nothing gets taller or wider: a framed slate has a 22 px frame a side, so trim that panel's own margins by the same amount.

## tests/camp_slate_test.gd (write it first, red on main)
Headless, modelled on tests/week_slate_test.gd. Reach the FIGHT CAMP pop-up as tests/camp_cards_test.gd does and walk the pop-up; then reach a bout offer as tests/versus_test.gd does and walk the VersusPanel's centre card (not the red and blue halves: they are light on purpose, so pass the centre card's node, not the whole page). Then `WoodKit.ink(page)`, settle 3 frames, and `for fault in SlateWalk.faults(page): fail` (SlateWalk = preload("res://tests/slate_walk.gd")). Check by name that the five focus cards, the three intensity cards and the Accept button are still found. Print `CAMP_SLATE failures=N`.
Write no check that can only pass. If you compare an edge with a line, print the number, and make sure the check is red when the edge is past the line.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). No file over 500 lines (VersusPanel.gd is 259). You cannot see images: Claude renders the page and judges it. No fixed he or she in any text. Change no rule module and no number.

## The one trap
CampCard is a Button with its own stylebox overrides for five states: the ink pass reads the "normal" one. A chosen card that keeps a pale fill keeps dark words on what is now a slate. Fill = see-through for every state; only the outline changes.

## Result lines (PR body)
RESULT: tests/camp_slate_test.gd -> CAMP_SLATE failures=0
RESULT: tests/camp_cards_test.gd -> CAMP_CARDS failures=0
RESULT: tests/versus_test.gd -> the test's own pass line
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0

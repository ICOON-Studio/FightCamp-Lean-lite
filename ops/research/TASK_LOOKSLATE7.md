# TASK LOOKSLATE7 - CURSOR (Grok 4.7 High) - the Fighters page's paper pieces, the week review's pad cards and the Overview's flat buttons on slate and wood

Status: OPEN (S418, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator approved the wood and slate look (Q-S294-159: "Yes, build this look") and then said "Yes, slate everywhere" (Q-S294-162). S417 built the look into the shared theme (scripts/ui/WoodKit.gd); LOOKSLATE1 moved the Training week page (merged, bbc6cbbd: read its diff, it is the pattern). Three leftovers still paint paper or flat plates: on Fighters, the cream "Scouted for you" strip and the paper foot under each roster card's picture; in the week review, the two white pad cards that flip; on a boxer's Overview, the red and dark buttons (Find a bout, Plan the week, Fight plan) drawn as flat plates of their own.

## Contract
OWNS: scripts/ui/RosterCards.gd, scripts/ui/FlipCard.gd, scripts/ui/DarkOverview.gd, tests/roster_slate_test.gd
RED_TEST: tests/roster_slate_test.gd -> ROSTER_SLATE failures=0
REGRESSION: roster_cards_test, roster_flag_test, roster_summary_test, review_reveal_test, card_flip_test, wood_kit_test, grey_reason_test, golden_path_test
VISUAL: yes

## Prior research
scripts/ui/WoodKit.gd whole (about 130 lines): `slate()` the framed slate, `PIECE` the wooden buttons, `ink()` the pass Main.render runs on every page and MainFlow.render_modal on every pop-up (words in the paper inks UI.FG / UI.MUTED / UI.GOLD turn chalk on a dark surface; it reads the surface from the nearest panel's or button's own stylebox), `fg(self)` / `muted(self)` / `blue(self)` and `on_dark(self)` for a control that draws its own words, lines or bars in `_draw`. `git show bbc6cbbd` (LOOKSLATE1) is the same job done on another page. tests/slate_walk.gd is the shared checker: read its header. scripts/ui/DarkOverview.gd is a page already on this look. ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md (a stylebox read before the node is in the tree is Godot's default).

## What would a human do?
Keep each roster card's painted picture exactly as it is and change only what is under and around it: the paper becomes slate, the strip becomes a framed slate, the review's cards match the Training tab's drill cards, and the Overview's buttons become the same wooden buttons every other page has.

## Prefab check
WoodKit has every piece. No new art, no new colours: WoodKit.INK, SOFT, HEAD, BLUE and the existing UI.GREEN / UI.RED / UI.AMBER.

## The job
1. scripts/ui/RosterCards.gd: PAPER / PAPER_DEEP (lines 28-29, used at 107, 282, 307 and by the mood and weight chips near 222). The card's own frame (line 107) becomes a dark fill `UI.box(Color(0.07, 0.06, 0.05, 0.92), Color(WoodKit.SOFT, 0.45), 6, 2)`, hover edge WoodKit.HEAD; the picture and its coloured backdrop are untouched. The ScoutedStrip (line 282) becomes `WoodKit.slate()`; each prospect button in it (line 307) see-through with the chalk outline, hover WoodKit.BLUE. The red Invite buttons stay. KEEP the constants PAPER, PAPER_DEEP and EDGE in the file with their values: StaffCard.gd and other pages still read them until their own tasks land.
2. scripts/ui/FlipCard.gd: the face (line 52, UI.PANEL) becomes see-through with the chalk outline, the same as DrillCard's on main; the pale tag at line 86 the same as DrillCard's tag (`UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, 6, 1)`). The gold BACK of a flipped card (line 55) stays gold: that is the reward.
3. scripts/ui/DarkOverview.gd: the buttons styled with `Plate.style(...)` at lines 120 and 130 (RED_BTN / RED_LIP, the quiet plates) take the theme's own variations instead: the one red button "Go", the others "Btn". Delete the plate styling that is then unused; keep the buttons' names, sizes and order.
Common to every step: a big panel becomes the framed slate (theme variation "Card", or `WoodKit.slate()`); a small card or tile inside it becomes a see-through panel with a thin chalk outline, `UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, ...)`; the SELECTED one takes the outline in WoodKit.HEAD, 2 px. Words keep UI.FG / UI.MUTED / UI.GOLD in the code (the ink pass turns them chalk); a word you colour yourself for a dark surface uses WoodKit.INK / SOFT. Layout, sizes, words, tooltips and every node name stay. Nothing gets taller or wider: a framed slate has a 22 px frame a side, so trim that panel's own margins by the same amount.

## tests/roster_slate_test.gd (write it first, red on main)
Headless, modelled on tests/week_slate_test.gd. Reach Fighters with three boxers signed as tests/roster_cards_test.gd does and walk the page; reach a week review with pad cards as tests/review_reveal_test.gd does and walk the pop-up; open a boxer's Overview and walk it. Then `WoodKit.ink(page)`, settle 3 frames, and `for fault in SlateWalk.faults(page): fail` (SlateWalk = preload("res://tests/slate_walk.gd")). For the roster cards pass each card's FOOT (the part under the picture), not the picture: the picture's backdrop is bright on purpose. Check by name that ScoutedStrip, three roster cards and the Overview's Find a bout button are still found. Print `ROSTER_SLATE failures=N`.
Write no check that can only pass. If you compare an edge with a line, print the number, and make sure the check is red when the edge is past the line.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). No file over 500 lines (DarkOverview.gd is 393, RosterCards.gd 335). You cannot see images: Claude renders the page and judges it. No fixed he or she in any text. Change no rule module and no number.

## The one trap
The roster card is a Button whose "normal" stylebox the ink pass reads for every word on it, including the words on the bright picture. Dark words there would turn chalk. Check the name plate and the weight class label on the picture still read; if one does not, give that label its colour as an override (the ink pass leaves an overridden colour that is not a paper ink alone).

## Result lines (PR body)
RESULT: tests/roster_slate_test.gd -> ROSTER_SLATE failures=0
RESULT: tests/roster_cards_test.gd -> the test's own pass line
RESULT: tests/review_reveal_test.gd -> the test's own pass line
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0

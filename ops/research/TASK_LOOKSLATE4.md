# TASK LOOKSLATE4 - CURSOR (Grok 4.7 High) - New game and the reception interview on slate and wood

Status: OPEN (S418, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator approved the wood and slate look (Q-S294-159: "Yes, build this look") and then said "Yes, slate everywhere" (Q-S294-162). S417 built the look into the shared theme (scripts/ui/WoodKit.gd); LOOKSLATE1 moved the Training week page (merged, bbc6cbbd: read its diff, it is the pattern). The first two screens a new player sees still paint cream: New game (step 1 the four head-coach cards, step 2 the country and city buttons, the four building cards, the three start cards and the two name boxes) and the reception interview (a white card and a white photo frame over the painted office).

## Contract
OWNS: scripts/ui/CreateScreen.gd, scripts/ui/modals/Interview.gd, scripts/ui/RecruitPanel.gd, tests/start_slate_test.gd
RED_TEST: tests/start_slate_test.gd -> START_SLATE failures=0
REGRESSION: recruit_test, first_week_test, guide_person_test, wood_kit_test, grey_reason_test, golden_path_test
VISUAL: yes

## Prior research
scripts/ui/WoodKit.gd whole (about 130 lines): `slate()` the framed slate, `PIECE` the wooden buttons, `ink()` the pass Main.render runs on every page and MainFlow.render_modal on every pop-up (words in the paper inks UI.FG / UI.MUTED / UI.GOLD turn chalk on a dark surface; it reads the surface from the nearest panel's or button's own stylebox), `fg(self)` / `muted(self)` / `blue(self)` and `on_dark(self)` for a control that draws its own words, lines or bars in `_draw`. `git show bbc6cbbd` (LOOKSLATE1) is the same job done on another page. tests/slate_walk.gd is the shared checker: read its header. scripts/ui/DarkOverview.gd is a page already on this look. ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md (a stylebox read before the node is in the tree is Godot's default).

## What would a human do?
Make the first minute of the game look like the rest of it: the same framed slates and wooden buttons, each choice card dark with its picture bright, the chosen one edged in gold.

## Prefab check
WoodKit has every piece. No new art, no new colours: WoodKit.INK, SOFT, HEAD, BLUE and the existing UI.GREEN / UI.RED / UI.AMBER.

## The job
1. scripts/ui/CreateScreen.gd: the card builder near line 244 ("A card: a paper panel, gold-edged when picked") becomes the framed slate, picked = the frame plus a WoodKit.HEAD 2 px outline (or the see-through chalk outline for the small start cards if a frame makes them too tight: your call, say which in the PR). The country and city buttons use the theme's "Choice" / "ChoiceOn" variations if they do not already. The two name boxes (LineEdit) get a dark fill `UI.box(Color(0, 0, 0, 0.35), Color(WoodKit.SOFT, 0.5), 4, 1, ...)` with WoodKit.INK text and WoodKit.SOFT placeholder. The portraits and the four building drawings keep their own backing.
2. scripts/ui/modals/Interview.gd: the white card (line 38) becomes `WoodKit.slate()`, the inner panel at line 87 see-through with the chalk outline. The painted office behind it (line 20) stays. The photo frame with the handwritten name stays light: it is a photograph.
3. scripts/ui/RecruitPanel.gd draws the inside of that card AND of the trial pop-up, which is already on slate: any pale fill left in it (attribute bars' track, the trait chips, the three focus buttons) becomes the slate version, checked on both.
Common to every step: a big panel becomes the framed slate (theme variation "Card", or `WoodKit.slate()`); a small card or tile inside it becomes a see-through panel with a thin chalk outline, `UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, ...)`; the SELECTED one takes the outline in WoodKit.HEAD, 2 px. Words keep UI.FG / UI.MUTED / UI.GOLD in the code (the ink pass turns them chalk); a word you colour yourself for a dark surface uses WoodKit.INK / SOFT. Layout, sizes, words, tooltips and every node name stay. Nothing gets taller or wider: a framed slate has a 22 px frame a side, so trim that panel's own margins by the same amount.

## tests/start_slate_test.gd (write it first, red on main)
Headless, modelled on tests/week_slate_test.gd. `main.act("newcareer")` and walk the create screen, `main.act("cstep", "1")` and walk it again; then a fresh game, `main.act("quick")`, `main.act("interview")` and walk the interview card (tools/layout_snapshot.gd plays exactly these steps: read its first 50 lines). Then `WoodKit.ink(page)`, settle 3 frames, and `for fault in SlateWalk.faults(page): fail` (SlateWalk = preload("res://tests/slate_walk.gd")). Check by name that the four coach cards, the four building cards, the three start cards and the Sign button are still found. Print `START_SLATE failures=N`.
Write no check that can only pass. If you compare an edge with a line, print the number, and make sure the check is red when the edge is past the line.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). No file over 500 lines (CreateScreen.gd is 308). You cannot see images: Claude renders the page and judges it. No fixed he or she in any text. Change no rule module and no number.

## The one trap
A LineEdit has its own "normal", "focus" and "read_only" styleboxes and its own font colours (font_color, font_placeholder_color, caret_color): set all of them, or the typed name is dark on dark.

## Result lines (PR body)
RESULT: tests/start_slate_test.gd -> START_SLATE failures=0
RESULT: tests/recruit_test.gd -> the test's own pass line
RESULT: tests/first_week_test.gd -> FIRST_WEEK failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0

# TASK LOOKSLATE5 - CURSOR (Grok 4.7 High) - the Money page off the whiteboard, onto slate and wood

Status: OPEN (S418, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator approved the wood and slate look (Q-S294-159: "Yes, build this look") and then said "Yes, slate everywhere" (Q-S294-162). S417 built the look into the shared theme (scripts/ui/WoodKit.gd); LOOKSLATE1 moved the Training week page (merged, bbc6cbbd: read its diff, it is the pattern). Club > Money is still a whiteboard on a cream wall (S403's mockup). Operator, Q-S294-162, asked whether Money and World keep the whiteboard: "Yes, slate everywhere". The S403 mockup is no longer the spec for the LOOK; its layout, options, numbers and words still are.

## Contract
OWNS: scripts/ui/areas/Money.gd, scripts/ui/MoneyPanels.gd, scripts/ui/MoneyTags.gd, scripts/ui/CashChart.gd, tests/money_slate_test.gd
RED_TEST: tests/money_slate_test.gd -> MONEY_SLATE failures=0
REGRESSION: menu_money_test, cash_forecast_test, gym_spend_test, wood_kit_test, grey_reason_test, golden_path_test
VISUAL: yes

## Prior research
scripts/ui/WoodKit.gd whole (about 130 lines): `slate()` the framed slate, `PIECE` the wooden buttons, `ink()` the pass Main.render runs on every page and MainFlow.render_modal on every pop-up (words in the paper inks UI.FG / UI.MUTED / UI.GOLD turn chalk on a dark surface; it reads the surface from the nearest panel's or button's own stylebox), `fg(self)` / `muted(self)` / `blue(self)` and `on_dark(self)` for a control that draws its own words, lines or bars in `_draw`. `git show bbc6cbbd` (LOOKSLATE1) is the same job done on another page. tests/slate_walk.gd is the shared checker: read its header. scripts/ui/DarkOverview.gd is a page already on this look. ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md (a stylebox read before the node is in the tree is Godot's default).

## What would a human do?
Wipe the whiteboard off: the same books, the same five tiles, the same chart and price tags, written in chalk on framed slates.

## Prefab check
WoodKit has every piece. No new art, no new colours: WoodKit.INK, SOFT, HEAD, BLUE and the existing UI.GREEN / UI.RED / UI.AMBER.

## The job
1. Every `WarmKit.panel("board")` and `WarmKit.panel("paper")` in the owned files goes: the page's main sheet and the right-hand column become framed slates; the price tags, bill rows and small cards inside them see-through with the chalk outline. Do not edit WarmKit.gd (other pages still read it).
2. The five dark-blue tiles on top (Cash, Members, Money lasts, Net a week, Bills) stay dark: give them the chalk outline and WoodKit.INK numbers; red and green numbers stay UI.RED / UI.GREEN.
3. scripts/ui/CashChart.gd draws with UI.FG: every line, tick, label and the dotted "if you do nothing" line goes through `WoodKit.fg(self)` / `muted(self)`; the cash line keeps its blue (`WoodKit.blue(self)`), below-zero stays UI.RED.
4. Handwriting (the marker font on the whiteboard) stays as the font, in WoodKit.INK: it now reads as chalk. The red marker circles around a number stay UI.RED.
5. The red Buy buttons, the dues and kit-budget choice rows keep the theme's buttons ("Go", "Choice" / "ChoiceOn").
Common to every step: a big panel becomes the framed slate (theme variation "Card", or `WoodKit.slate()`); a small card or tile inside it becomes a see-through panel with a thin chalk outline, `UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, ...)`; the SELECTED one takes the outline in WoodKit.HEAD, 2 px. Words keep UI.FG / UI.MUTED / UI.GOLD in the code (the ink pass turns them chalk); a word you colour yourself for a dark surface uses WoodKit.INK / SOFT. Layout, sizes, words, tooltips and every node name stay. Nothing gets taller or wider: a framed slate has a 22 px frame a side, so trim that panel's own margins by the same amount.

## tests/money_slate_test.gd (write it first, red on main)
Headless, modelled on tests/week_slate_test.gd. Reach Club > Money as tests/menu_money_test.gd does and walk the page. Then `WoodKit.ink(page)`, settle 3 frames, and `for fault in SlateWalk.faults(page): fail` (SlateWalk = preload("res://tests/slate_walk.gd")). Check by name that the five tiles, the chart and at least six price tags are still found, and that menu_money_test's own node names are untouched. Print `MONEY_SLATE failures=N`.
Write no check that can only pass. If you compare an edge with a line, print the number, and make sure the check is red when the edge is past the line.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). No file over 500 lines (MoneyPanels.gd is 338, Money.gd 326). You cannot see images: Claude renders the page and judges it. No fixed he or she in any text. Change no rule module and no number.

## The one trap
CashChart and the tags draw in `_draw`: the ink pass cannot see those words. Each one must ask `WoodKit.fg(self)` at draw time, and the control must redraw when the theme is ready (call `queue_redraw()` in `_ready`).

## Result lines (PR body)
RESULT: tests/money_slate_test.gd -> MONEY_SLATE failures=0
RESULT: tests/menu_money_test.gd -> MENU_MONEY failures=0
RESULT: tests/cash_forecast_test.gd -> CASH_FORECAST failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0

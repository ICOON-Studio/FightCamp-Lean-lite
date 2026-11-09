# TASK LOOKSLATE1 - CURSOR (Grok 4.7 High) - the Training week page on slate and wood

Status: OPEN (S417, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator approved the wood and slate look (Q-S294-159: "Yes, build this look", docs/mockups/s416/overview_painted_ludo.png). S417 built it into the shared theme (scripts/ui/WoodKit.gd): every `UI.card`, pop-up, tab, button and the top bar changed at once. Pages that paint their OWN cream panels did not. The fighter's Training tab is the biggest of them: a cream sheet with white day cards under wooden tabs.

## Contract
OWNS: scripts/ui/WeekBoard.gd, scripts/ui/WeekCards.gd, scripts/ui/WeekDay.gd, scripts/ui/WeekStrip.gd, scripts/ui/DrillCard.gd, scripts/ui/DrillTray.gd, tests/week_slate_test.gd
RED_TEST: tests/week_slate_test.gd -> WEEK_SLATE failures=0
REGRESSION: week_board_clarity_test, week_strip_test, drill_card_test, drill_pick_test, wood_kit_test, golden_path_test
VISUAL: yes

## Prior research
scripts/ui/WoodKit.gd whole (about 130 lines): `slate()` the framed slate, `PIECE` the wooden buttons, `ink()` the pass Main.render runs on every page (words in the paper inks UI.FG / UI.MUTED / UI.GOLD turn chalk on a dark surface and stay as they are on a light one; it reads the surface from the panel's or button's own stylebox), `fg(self)` / `muted(self)` / `blue(self)` for a control that draws its own words in `_draw`. tests/wood_kit_test.gd shows every rule. scripts/ui/DarkOverview.gd is a page already on this look. ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md (a stylebox read before the node is in the tree is Godot's default).

## What would a human do?
Take the cream sheet and the white cards off, put the week on one framed slate, keep every word, number, icon and button where it is, and check nothing went dark on dark.

## Prefab check
WoodKit has every piece. No new art, no new colours: use WoodKit.INK, SOFT, HEAD, BLUE and the existing UI.GREEN / UI.RED / UI.AMBER.

## The job
1. The page's outer sheet becomes ONE `WoodKit.slate()` panel (theme variation "Card" does it). No cream, no white.
2. A day card, a drill card, a tray card: a see-through panel with a thin chalk outline (`UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, ...)`), not a white card. A SELECTED or dragged card: the outline in WoodKit.HEAD, 2 px.
3. Every colour written as UI.PANEL, UI.PANEL2, UI.LINE, Color.WHITE or a pale hex as a BACKGROUND in the owned files goes. Words keep UI.FG / UI.MUTED / UI.GOLD in the code: the ink pass turns them chalk. A word you colour yourself for a dark surface uses WoodKit.INK / SOFT.
4. Anything drawn in `_draw` with UI.FG / UI.MUTED / UI.GOLD (fatigue line, goal bar ticks, the week strip) uses `UI.WoodKit.fg(self)` / `muted(self)` / `blue(self)`.
5. Layout, sizes, words, tooltips and every node name stay. The page must still fit 1920x1080 with no scroll: the slate's frame is 22 px a side, so trim outer margins by the same amount if needed.

## tests/week_slate_test.gd (write it first, red on main)
Headless. Open the game as tests/week_board_clarity_test.gd does, go to the fighter's Training tab, run `WoodKit.ink` as Main.render does (it already runs). Walk every Control under the page:
- no PanelContainer or Button whose own stylebox is a StyleBoxFlat with alpha >= 0.5 and luminance >= 0.45 (a light plate), except the theme's "TabOn", "ChoiceOn", "PillOn", "Go", "Sticky*" and "Chip*";
- every visible Label and RichTextLabel: the contrast between its ink and the surface `WoodKit.on_dark` reports is the right way round (chalk inks on dark, paper inks on light): no UI.FG / UI.MUTED / UI.GOLD word left on a dark surface;
- the page's bottom edge is at or above 1080 and nothing is wider than 1920.
Print `WEEK_SLATE failures=N`.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). No file over 500 lines (WeekBoard.gd is 486: it must not grow past 500). You cannot see images: Claude renders the page and judges it. No fixed he or she in any text. Change no rule module and no number.

## Not yours
PRs 108 and 130 (an older rebuild of this page, made for the cream look) are held and are not the base: work on main's files as they are.

## The one trap
A card that is a Button with its own "normal" stylebox override: the ink pass reads THAT stylebox. Give it the see-through outline and its words turn chalk by themselves; leave a white override and they stay dark on what is now a slate behind.

## Result lines (PR body)
RESULT: tests/week_slate_test.gd -> WEEK_SLATE failures=0
RESULT: tests/wood_kit_test.gd -> WOOD_KIT failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0

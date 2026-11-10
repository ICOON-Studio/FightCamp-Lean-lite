# TASK LOOKSLATE6 - CURSOR (Grok 4.7 High) - the World page off the plaster wall, onto slate and wood

Status: OPEN (S418, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator approved the wood and slate look (Q-S294-159: "Yes, build this look") and then said "Yes, slate everywhere" (Q-S294-162). S417 built the look into the shared theme (scripts/ui/WoodKit.gd); LOOKSLATE1 moved the Training week page (merged, bbc6cbbd: read its diff, it is the pattern). World > Rankings is still a tan board on a plaster wall with a pale side-by-side panel, and every World tab has a tan band behind the page title. Operator, Q-S294-162, asked whether Money and World keep the whiteboard: "Yes, slate everywhere". The S403 mockup is no longer the spec for the LOOK; its layout, options, numbers and words still are. World > News and Championships are already on slate.

## Contract
OWNS: scripts/ui/areas/World.gd, scripts/ui/WorldLadder.gd, scripts/ui/WorldCompare.gd, tests/world_slate_test.gd
RED_TEST: tests/world_slate_test.gd -> WORLD_SLATE failures=0
REGRESSION: menu_world_test, world_ladder_rules_test, world_rules_test, wood_kit_test, grey_reason_test, golden_path_test
VISUAL: yes

## Prior research
scripts/ui/WoodKit.gd whole (about 130 lines): `slate()` the framed slate, `PIECE` the wooden buttons, `ink()` the pass Main.render runs on every page and MainFlow.render_modal on every pop-up (words in the paper inks UI.FG / UI.MUTED / UI.GOLD turn chalk on a dark surface; it reads the surface from the nearest panel's or button's own stylebox), `fg(self)` / `muted(self)` / `blue(self)` and `on_dark(self)` for a control that draws its own words, lines or bars in `_draw`. `git show bbc6cbbd` (LOOKSLATE1) is the same job done on another page. tests/slate_walk.gd is the shared checker: read its header. scripts/ui/DarkOverview.gd is a page already on this look. ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md (a stylebox read before the node is in the tree is Godot's default).

## What would a human do?
Take the plaster and the tan board away: the ladder and the side-by-side become two framed slates, chalk rows, the club's own boxer still picked out.

## Prefab check
WoodKit has every piece. No new art, no new colours: WoodKit.INK, SOFT, HEAD, BLUE and the existing UI.GREEN / UI.RED / UI.AMBER.

## The job
1. scripts/ui/areas/World.gd: the tan plaster band behind the page (and behind the title on the News and Championships tabs) goes: the page sits on the shared backdrop like Club and Fighters do.
2. scripts/ui/WorldLadder.gd: the board becomes a framed slate. Row bands: every other row `Color(1, 1, 1, 0.03)`, the player's own boxer's row a WoodKit.HEAD 2 px outline (not a pale fill), the next opponent's row a WoodKit.BLUE outline. The win-chance bars: track `Color(WoodKit.SOFT, 0.30)`, fill stays blue. The key and the title route strip under the board: see-through with the chalk outline.
3. scripts/ui/WorldCompare.gd: the side-by-side panel becomes a framed slate; its bars the same as the ladder's; the scouted range (hatched) stays readable: hatch in `Color(WoodKit.SOFT, 0.5)`.
4. Anything drawn in `_draw` (bars, ranges, rank arrows, row lines) goes through `WoodKit.fg(self)` / `muted(self)` / `blue(self)`.
Common to every step: a big panel becomes the framed slate (theme variation "Card", or `WoodKit.slate()`); a small card or tile inside it becomes a see-through panel with a thin chalk outline, `UI.box(Color(1, 1, 1, 0.04), Color(WoodKit.SOFT, 0.35), 4, 1, ...)`; the SELECTED one takes the outline in WoodKit.HEAD, 2 px. Words keep UI.FG / UI.MUTED / UI.GOLD in the code (the ink pass turns them chalk); a word you colour yourself for a dark surface uses WoodKit.INK / SOFT. Layout, sizes, words, tooltips and every node name stay. Nothing gets taller or wider: a framed slate has a 22 px frame a side, so trim that panel's own margins by the same amount.

## tests/world_slate_test.gd (write it first, red on main)
Headless, modelled on tests/week_slate_test.gd. Reach World > Rankings as tests/menu_world_test.gd does and walk the page; open a rival's file from a row and walk that pop-up too. Then `WoodKit.ink(page)`, settle 3 frames, and `for fault in SlateWalk.faults(page): fail` (SlateWalk = preload("res://tests/slate_walk.gd")). Check by name that the ladder has its rows, that the player's own row is found and that the side-by-side panel is found. Print `WORLD_SLATE failures=N`.
Write no check that can only pass. If you compare an edge with a line, print the number, and make sure the check is red when the edge is past the line.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). No file over 500 lines. WorldLadder.gd is 496 lines and WorldCompare.gd is 499: they MUST NOT grow past 500 (tests/file_limits_test.gd). Taking the WarmKit code out should shrink them; if not, move a helper into a new file scripts/ui/WorldBars.gd and add it to OWNS in the PR body. You cannot see images: Claude renders the page and judges it. No fixed he or she in any text. Change no rule module and no number.

## The one trap
The two big files sit at the 500-line limit. Count lines before you push (`wc -l`), and never join lines to get under it.

## Result lines (PR body)
RESULT: tests/world_slate_test.gd -> WORLD_SLATE failures=0
RESULT: tests/menu_world_test.gd -> MENU_WORLD failures=0
RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0

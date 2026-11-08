# TASK MENUWORLD2 - CURSOR (Grok 4.7 High) - the World page, round 2: names, width and the fit

Status: OPEN (S406, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.
BASE: cursor/menuworld1

## Contract
OWNS: scripts/rules/WorldLadderRules.gd, scripts/ui/WorldLadder.gd, scripts/ui/WorldCompare.gd, scripts/ui/areas/World.gd, tests/menu_world_test.gd, tests/world_ladder_rules_test.gd
RED_TEST: tests/menu_world_test.gd -> MENU_WORLD failures=0
REGRESSION: world_ladder_rules_test, kit_icon_test, world_rules_test, world_years_test, matchmaking_bots_test, pro_debut_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/world.html and world.png (the spec), and PR #99's page on your BASE.

## Prior research
Round 1 is PR #99, 11 of 11 checks green. Claude rendered it at 1920x1080 with tools/layout_snapshot.gd (screen 30_rankings) and compared it with the mockup. Your tests never measured a drawn width, so a blank name column passed.

## What would a human do?
Open World and read down the table: who is ranked, how they fight, whether I can ask for them, all on one screen.

## Prefab check
Nothing new: this round fixes round 1.

## What the render showed, in order of harm
1. **Every fighter's name is blank.** Only the portrait draws. `_name` (WorldLadder.gd ~148) sets `clip_text = true` on the name button with no expand flag: a clipped button's minimum width is 0, so the row gives it 0. The same trap is on the Ask button (~226).
2. **The Style column is cut off** ("Boxer-punch", "Volume punc"): `style.clip_text = true` (~132) in a fixed column.
3. **The table fills two thirds of the board.** The columns are fixed widths and stop at x ~1090 inside a board that reaches ~1460. The header row and the data rows do not line up.
4. **The page runs past the screen.** The list is 248 px high and shows 6 rows behind a scrollbar; Title route and Key fall below the fold. The mockup shows ten rows, the player's row, Title route, Key, Side by side and News on one screen.
5. The fighter chip row sits on its own line under the sport chips; the mockup has the sport chips and fighter chips on one row. Move them up: this is most of the height you need.
6. The page's background is the old cold blue; MENU_BUILD_RULES rule 1 says the warm wall. Draw WarmKit's wall behind this page's content, inside World.gd only.
7. The win band is a solid block. The mockup: blue hatching = wide, not scouted; narrower gold hatching = partly scouted; the ranges are what the player reads.
8. Wording: `_line` says "1 more wins". Write "1 more win" when it is one.

## Do
Add these to tests/menu_world_test.gd FIRST, measured on the laid-out page at 1920x1080 after two frames, and watch them fail on your BASE:
1. Every LadderRow's name button is visible, at least 120 px wide, and its text's drawn width fits inside it.
2. Every row's Style label fits ("Counter-puncher" is the longest): no clipped text.
3. Each header label's left edge is within 4 px of its column's left edge in the first row.
4. The last column's right edge is within 32 px of the board's inner right edge.
5. With the guide strip hidden, the page's content height is at most the viewport: no page scrollbar, and Title route and Key are on screen. Ten rows and the player's row show without scrolling the list.
6. The band of an unscouted rival and a partly scouted rival draw differently (the test reads a state your code exposes, such as `WinBand.scouted`).

Then fix them inside OWNS. Run REGRESSION. Do not change any number or threshold in an existing test. Do not change a rank, a win chance, or what Ask does.

## The one trap
`clip_text` removes a control's minimum width. Any clipped control needs a real width or an expand flag, or it draws nothing. Cursor cannot see the page: the numbers above are how you see it.

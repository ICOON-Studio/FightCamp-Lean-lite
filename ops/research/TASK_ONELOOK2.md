# TASK ONELOOK2 - the fight HUD on the one palette: HudBars.gd + HudRegroup.gd (53 loose colours -> Palette names)

Status: OPEN (S495, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
The owner asked for one palette across every screen (board Q-251, "i have no idea , do it and i will judge"; S493 built
`scripts/ui/Palette.gd`, 19 colours named by JOB). `tests/palette_guard_test.gd` counts the loose colours left in screen
scripts (baseline `tests/palette_baseline.json`, 649 in all). The two fight-HUD files are next worst after the menu kits:
`scripts/fight3d/HudRegroup.gd` 27, `scripts/fight3d/HudBars.gd` 26. This task moves both onto Palette names. The look
must stay the same to the eye: the owner judges before/after stills (Claude renders them; you cannot see images).

## Read first
- `scripts/ui/Palette.gd` WHOLE (126 lines): every name and its job comment.
- `tests/palette_guard_test.gd`: what counts as a loose colour (a `Color(` with numbers or a hex string, `Color8(`, `"#rrggbb"`,
  `Color.WHITE`-style names; `Color(SOME_NAME, alpha)` and `Palette.CLEAR` do NOT count).
- The two files: `scripts/fight3d/HudBars.gd` (500 lines - AT the limit) and `scripts/fight3d/HudRegroup.gd` (499 lines).

## The rules (apply them line by line; they keep the look)
1. White or near-white with an alpha -> `Color(Palette.TEXT, a)`; plain `Color.WHITE` / `Color(1, 1, 1)` -> `Palette.TEXT`.
2. Black with an alpha (text outlines, shadows, dim panels) -> `Color(Palette.PAGE, a)`; `Color(0, 0, 0, 0)` -> `Palette.CLEAR`
   (never `Color.TRANSPARENT`: it is see-through WHITE and fringes).
3. Red/orange: a FILL, bar, arc or flash -> `Palette.BAD_FILL` (alpha kept: `Color(Palette.BAD_FILL, a)`); WORDS -> `Palette.BAD`.
   The red corner's half of a tug-of-war bar -> `Palette.RED_CORNER`.
4. Blue: the blue corner / your side -> `Palette.BLUE_CORNER` (fills) or `Palette.ACCENT` (words).
5. Gold/amber words ("?", homework marks, titles) -> `Palette.HEADER`. Green good fill -> `Palette.GOOD_FILL`, green words -> `Palette.GOOD`.
6. Grey "gone / spent" fills -> `Color(Palette.LINE, a)`.
7. A colour built from a variable (`Color(col.r, col.g, col.b, 0.22)`) -> `Color(col, 0.22)`.
8. A lerp between two loose colours -> the same lerp between the two Palette names the rules give.
9. If a colour fits NO rule (a skin tone, a 3D material, a deliberate one-off), leave it and list it in the PR body with
   the line and why. Do not invent new Palette names; do not edit Palette.gd.
Known lines to start from (HudBars): 88, 385, 393-394, 400, 405, 410, 414-415, 420, 422, 424, 426, 435-436, 486-500.

## Line limits (hard)
Neither file may grow past 500 lines (tests/file_limits_test.gd). HudBars is AT 500: when you add
`const Palette := preload("res://scripts/ui/Palette.gd")` beside its other preloads (line ~14-27), join ONE other pair of
short lines elsewhere in the file (e.g. two consecutive short statements, or move a short comment onto the line above as a
trailing comment) so it stays at 500. HudRegroup (499) may take the one preload line. Do not rename, reorder or change
any logic: colour values only.

## Then
Refresh the baseline: `godot --headless --audio-driver Dummy --path . --script res://tests/palette_guard_test.gd -- write`,
then run it again WITHOUT `-- write` and copy its summary line into the PR body. The two files' counts in
`tests/palette_baseline.json` must fall (to 0 plus your listed leftovers); no other file's count may change.

## Contract
OWNS: scripts/fight3d/HudBars.gd, scripts/fight3d/HudRegroup.gd, tests/palette_baseline.json
RED_TEST: tests/palette_guard_test.gd -> PALETTE_GUARD ... over=0 new=0 (and the baseline rows for HudBars.gd + HudRegroup.gd at 0 + listed leftovers; red on main: 26 and 27)
REGRESSION: tests/hud_shown_test.gd, tests/file_limits_test.gd, tests/corner_bar_test.gd
VISUAL: yes - Claude renders before/after fight stills on the game camera and the owner judges them; your PR is not merged before.
NOT YOURS: every other file (Palette.gd included). Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2). Never run tools/run_tests.sh.
PR body: `RESULT: tests/palette_guard_test.gd -> <its summary line>`, `RESULT: tests/hud_shown_test.gd -> <pass line>`,
`RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0`, and the leftover list.

GDSCRIPT TRAPS: `Color(Palette.TEXT, 0.4)` is valid (Color from a Color + alpha); never `var x := <Array/Dictionary element>`;
a preload const name must not clash with an existing one in the file (check `Palette` is not already used).

## Prior research
ops/AgentComms/board_attach/Q-S294-251_2_README.md (the S490 colour census); S493/S494 sweeps of UI.gd and RosterCards
(memory project_s493_palette_coach_r4: `Palette.CLEAR`, not `Color.TRANSPARENT`); TASK_PALETTEGUARD1.md (the guard).

## What would a human do?
A UI artist moving a screen onto a style guide swaps each hard-coded swatch for the token whose job matches its use, keeps
alpha as it was, and leaves a short list of the ones that do not fit for the art lead - not a recolour.

## Prefab check
None: our own palette file.

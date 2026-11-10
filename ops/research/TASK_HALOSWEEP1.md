# TASK HALOSWEEP1 - CURSOR (Grok 4.7 High) - every "this one is chosen" frame in the game uses the shared outline

Status: OPEN (S427, Claude main). Discipline: all screens (a look rule, no mechanic). Model: Grok 4.7 High.
Source: the owner on a still of the Dues tab (review comment C273, 2026-11-10): "use proper outline effects throught all
project not cheap solutions." The cheap solution was a flat gold rectangle (a StyleBoxFlat border) round the chosen
thing. S427 built the one proper outline and put it on four screens; this task puts it on the rest.

## What exists (read it first, change none of it)
- scripts/ui/Halo.gd + scripts/ui/halo.gdshader: `Halo.ring(host, tint, radius)` = a glowing frame round `host` (thin hot
  core line, soft glow outward, a slow travelling light; still in tests and stills). `Halo.hover(host, tint, radius)` =
  the same, lit only under the mouse. `Halo.cutout(picture)` = a line along a cut-out picture's own edge. It works on a
  plain Control and on a Container (it takes its room back after every sort). tests/halo_test.gd proves it.
- Already done, as the model to copy: scripts/ui/DuesBoards.gd (`_board`), scripts/fight3d/CornerBar.gd (`_call`),
  scripts/fight3d/NowPlate.gd, scripts/ui/GuideLight.gd. Pattern: the frame keeps a quiet 1-3 px brown or LINE border for
  its own shape; the CHOSEN state adds `Halo.ring(...)`; the gold border and any tween on `border_color` go.

## Contract
OWNS: scripts/grapple/BeltMatch.gd, scripts/ui/areas/GrapplerPage.gd, scripts/ui/Bracket.gd, scripts/ui/CoachSteps.gd,
  scripts/ui/CreateScreen.gd, scripts/ui/GamePlan.gd, scripts/ui/MatSystems.gd, scripts/ui/MatTree.gd,
  scripts/ui/TapeRoom.gd, scripts/ui/FlowView.gd, scripts/ui/DrillCard.gd, scripts/ui/WeekBoard.gd,
  tests/halo_test.gd (only its last loop: add each file you converted to the list), docs/HALOSWEEP1_RESULT.md
RED_TEST: tests/halo_test.gd -> HALO failures=0 with every converted file in its list (it is red the moment you add a
  file that still has `UI.GOLD if`/`WoodKit.HEAD` as a chosen border; extend the loop's banned patterns to catch
  `UI.box(` calls whose border argument is `UI.GOLD if <chosen>`)
REGRESSION: file_limits_test, words_on_screens_test, bjj_tree_ui_test, tape_room_test, plan_screen_test, drill_card_test, week_board_clarity_test
VISUAL: yes - for each converted screen one real still with something chosen on it (tools/layout_snapshot.gd pages, or a
  small still script like tools/halo_still.gd), saved under docs/mockups/s427/halosweep/. You cannot see images: list in
  the result, per still, the chosen control's global rect and that a child named "Halo" is visible on it (print it from
  the still script). Claude opens the stills.

## The job
1. In each owned file find where a border says "chosen / mine / open / current / the tell / start": the grep that found
   them is `grep -n "box(.*GOLD\|box(.*HEAD\|GOLD if \|HEAD if " <file>`. Lines S427 saw: BeltMatch 387, GrapplerPage 145,
   Bracket 55 and 85, CoachSteps 115, CreateScreen 277, GamePlan 271, MatSystems 26, MatTree 155 and 171, TapeRoom 359
   and 385, FlowView 391 (and its border_color tween at 405), DrillCard 221, WeekBoard 405.
2. For each: keep the unchosen frame as it is; in the chosen case keep the SAME border as the unchosen one and add
   `Halo.ring(host, <the gold that file used>, <the box's corner radius>)`. Where the thing is clickable and has no hover
   feedback, add `Halo.hover(host)` on the unchosen ones.
3. Bracket.gd draws with draw_style_box inside one Control: there, add one Halo child per chosen box, placed over that
   box's rect (`ring.position = rect.position - Vector2.ONE * Halo.MARGIN`, `ring.size = rect.size + ...`), rebuilt
   when the bracket redraws; no second copy of the shader.
4. NOT a chosen frame, leave alone: theme styles in UI.gd / TV.gd (LineEdit focus, OptionButton, Modal, Toast), status
   colours (a green or red edge that says good or bad), tab underlines, left colour bars.
5. No file over 500 lines (file_limits_test). No new colours. No new words on screen.
6. docs/HALOSWEEP1_RESULT.md: one row per file: what was the chosen frame, what it is now, the still's name, the printed
   rect line; and any chosen frame you found that is not in the list above.

## Prior research
scripts/ui/Halo.gd (the header), tests/halo_test.gd, ops/research/GDSCRIPT_TRAPS.md, memory rule S400 (screens only from
the approved look: this changes no layout, only how "chosen" is drawn).

## What would a human do?
A UI artist makes one "selected" treatment and uses it on every screen, so the player learns it once.

## Prefab check
The effect exists in the repo (Halo.gd). No asset or library applies.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/halo_test.gd` (the plain win64 exe, never the console one). Windowed
stills only through `python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution
1920x1080 --audio-driver Dummy --script res://tools/<still>.gd -- <out_dir>`. Nothing opens on the owner's screens:
view nothing with an app.
RESULT lines for the PR body: `RESULT: tests/halo_test.gd -> HALO failures=0`.

# TASK FIGHTDISPLAY4 - CURSOR (Grok 4.7 High) - the fight screen: the two wooden side panels go, the bars move to the top, the see-through figures stand free again

Status: OPEN (S429, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator's marks on the S428 fight screen (ops/Feedback/2026-11-11-01/README.md, marked.png; C282, C283):
1. On the left wooden panel (a box at 0.8%,11.7%, size 18.5 x 69.6% of the 1920x1080 picture): "remove these and restore the
   previous version and maybe put the bars at thebottom hud or fill up the top. Now these box panels blocking too much of the view"
2. An arrow from the panel's top to the empty top-left of the screen: "move bars uphere keep the holo as in previous version ?"
The "previous version" is the screen before FIGHTDISPLAY3 (commit c6bd79db): the see-through body figures stood FREE at the
left and right edges with nothing behind them (`git show c6bd79db^:scripts/fight3d/BodyPanels.gd`,
`git show c6bd79db^:scripts/fight3d/FightHud.gd`). You cannot see pictures: work from the rectangles below.

## Contract
OWNS: scripts/fight3d/SidePanel.gd, scripts/fight3d/BodyPanels.gd, scripts/fight3d/FightHud.gd, scripts/fight3d/IntentChip.gd, scripts/fight3d/CornerBar.gd, tests/side_panel_test.gd, tools/fight3d_play.gd, docs/FIGHTDISPLAY4_RESULT.md
RED_TEST: tests/side_panel_test.gd -> SIDE_PANEL failures=0
REGRESSION: intent_chip_test, energy_forecast_test, corner_bar_test, round_board_test, file_limits_test, no_pronoun_test
VISUAL: yes

## What the screen must be (1920x1080; every number is a pixel rectangle x, y, w, h)
A. NO PANEL OVER THE RING. Nothing with an opaque or wooden background may cover the area x 0..1920, y 240..890, except the
   two free figures (B) and the chips over the boxers' heads. The wooden side panels (SidePanel0, SidePanel1: today about
   370 px wide and 770 px tall each) are gone: no slate, no wood, no frame there.
B. THE FIGURES STAND FREE, as before c6bd79db: our boxer's see-through figure at the left edge (inside x 20..340, y 350..890),
   the opponent's at the right edge (inside x 1580..1900, y 350..890), no background behind them, the numbered damage spots
   on them as today. The fine / hurt / critical legend is NOT drawn: it goes into the figure's tooltip.
C. THE BARS GO TO THE TOP, in the two empty strips beside the scoreboard: ours inside x 20..620, y 20..200, the opponent's
   inside x 1300..1900, y 20..200 (the scoreboard occupies x 640..1280). Each strip holds: the boxer's name and the mode line
   under it ("Boxing at range"), then three HORIZONTAL bars one under the other, each with its word and number on the same
   row: energy, legs, guard (the opponent's energy as the range it shows today, "91-97"). Bar height 18 to 24 px, the words
   22 px or more. The "lasts to R1 R2 R3" forecast (EnergyForecast) sits on the energy row as one short text ("lasts to R3").
   The worst-place tag ("HEAD", "NOSE") sits beside the name.
D. WHAT ELSE WAS ON THE PANELS moves to the bottom bar (CornerBar.gd, which is at 492 lines: move, do not grow past 500):
   "Heard 0 of 3" with its pips goes beside LAST CALL; the opponent's habit card ("Boxing at range, 1 time") goes back where
   "PRIYA NOW" stood in the bottom bar before c6bd79db. Nothing is lost: every number the panels showed is still on screen
   or in a tooltip. Say in the result file where each one went.
E. THREE OVERLAPS LEFT OPEN BY FIGHTDISPLAY3, fix them: the chip over the right fist covers the R3 card under the scoreboard
   (keep every chip out of x 640..1280, y 0..240); the head tooltip ("HEAD 89 - ...") sits on top of the brain icon; in the
   corner card the text "Your coach has seen it..." overlaps "Leave it".

## The test first (tests/side_panel_test.gd, rewritten; it must be RED on today's main and green on your branch)
Build the live fight HUD the way tools/fight3d_play.gd does (the GAME path, not a panel alone), at 1920x1080, and check:
1. No visible Control whose own draw is opaque (a PanelContainer or Panel with a stylebox, a TextureRect, a ColorRect with
   alpha over 0.5) has a global rect that overlaps x 0..1920, y 240..890 by more than 2,000 px2, other than nodes under the
   two figure homes and nodes named IntentChip*. Print each offender's path and rect on a failure.
2. EnergyBar, LegsBar, GuardBar exist for both sides; each one's global rect lies inside its top strip (C) and is wider than tall.
3. Both figures exist, each inside its rectangle in B, with no panel ancestor that draws a background.
4. The Ear pips and the HabitCard exist and lie inside the bottom bar (y over 900).
5. No two visible Labels in the top strips or the bottom bar overlap each other by more than 4 px in both directions.
6. No IntentChip rect intersects x 640..1280, y 0..240 at any of 20 sampled moments of round 1.
Keep the pure checks the old test had (worst_place, tag_text, energy_range, meter_src) if those functions stay.

## Stills (you render, Claude reads them)
Real fight flow through the queue and the hidden desktop, never on a monitor:
`python ops/Tools/godot_slot.py run --who cursor -- python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path .
--windowed --resolution 1920x1080 --log-file <log> --script res://tools/fight3d_play.gd -- <out_dir>` (the plain win64 exe,
never the console one). Save stills only through tools/still_framing.gd `save_if_framed` (both boxers head to feet in
frame). Put three stills (guard, mid-punch, a damage spot showing) in docs/mockups/s429/fightdisplay4/ and print for each
bar and figure its global rect. docs/FIGHTDISPLAY4_RESULT.md: a table "was on the panel -> where it is now", the rects, the
test's pass line, and anything you could not do.

## Prior research
docs/FIGHTDISPLAY3_RESULT.md (what the panels hold and why), ops/research/FIGHT_DISPLAY_DECISION_S419.md,
docs/mockups/s422/fight_10_simvet.html (the drawing the panels came from; the operator has now seen it in the game and
wants the view back), ops/research/GDSCRIPT_TRAPS.md. Memory rule: graphics, not paragraphs (icon + number + short caption).

## What would a human do?
A TV boxing broadcast keeps the ring clear: the score bug and both boxers' bars sit in one strip along the top, the corner's
controls along the bottom, and nothing is laid over the fighters.

## Prefab check
The bars (BodyPanels' bar classes), the figures (BodyFigure), EnergyForecast and the bottom bar all exist: this task moves
and restyles them. No new asset.

Rules: no script over 500 lines (file_limits_test). New features ship ON. No he / she in any script text. Parse before
testing. Every Godot job through `python ops/Tools/godot_slot.py run --who cursor -- ...`.
RESULT lines for the PR body: `RESULT: tests/side_panel_test.gd -> SIDE_PANEL failures=0` and one line per regression test.

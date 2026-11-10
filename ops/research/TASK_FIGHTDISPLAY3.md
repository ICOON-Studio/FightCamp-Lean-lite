# TASK FIGHTDISPLAY3 - CURSOR (Grok 4.7 High) - the two wooden side panels, round 3: on today's main, no error, no overlap, no symbols

Status: OPEN (S427, Claude main). Discipline: boxing. Model: Grok 4.7 High.
Source: FIGHTDISPLAY2 (PR 177, branch cursor/fightdisplay2, commit 243f2e36) built the live fight's two wooden side
panels from the owner's pick (Q-174 "Use the veteran's drawing", docs/mockups/s422/fight_10_simvet.html). Claude rendered
it on main in S427 and did NOT collect it: it has a script error, overlapping words and a box of symbols, and main's
corner bar changed under it. The owner has since marked the fight screen again (below). This task finishes the panels on
today's main.

## The owner's words (verbatim, 2026-11-10)
- On the name label over the gauge (mark 3, Feedback/2026-11-10-20): "need better presentation".
- On a competitor's chips over the boxers' heads (PRESSING / IN TROUBLE): "i like the status indicator showing intention
  we can improve this".
- Earlier, on the corner bar: "what are these symbols ??" (a bolt and arrows) and "what do you mean wrong, are you saying
  to the player do not choose this ? is this how games work ?".

## Contract
OWNS: scripts/fight3d/SidePanel.gd, scripts/rules/EnergyForecast.gd, tests/side_panel_test.gd, tests/energy_forecast_test.gd, scripts/fight3d/FightHud.gd, scripts/fight3d/BodyPanels.gd, scripts/fight3d/IntentChip.gd, tests/intent_chip_test.gd, scripts/fight3d/RoundBoard.gd, tests/round_board_test.gd, tools/fight3d_play.gd, docs/FIGHTDISPLAY3_RESULT.md
(CornerBar.gd and tests/corner_bar_test.gd are NOT yours this round: main's bar was rebuilt in S427 and stays.)
RED_TEST: tests/side_panel_test.gd -> SIDE_PANEL failures=0
REGRESSION: energy_forecast_test, intent_chip_test, round_board_test, corner_bar_test, hud_shown_test, holo_live_test, hit_flash_test, fight_flow_test, golden_path_test, file_limits_test
VISUAL: yes (Claude renders and judges; you cannot see images)

## The job
1. Start from origin/main. Bring over from origin/pr177 (fetch refs/pull/177/head) ONLY: SidePanel.gd, EnergyForecast.gd,
   their two tests, and its changes to FightHud.gd and BodyPanels.gd. Leave its CornerBar.gd and corner_bar_test.gd
   changes out: the "best call first, framed in gold" idea is dropped (gold now means "the call in force", drawn by
   scripts/ui/Halo.gd; and telling the player which call to press is the hand-holding he objected to).
2. THE SCRIPT ERROR. A windowed run prints twice: `SCRIPT ERROR: Invalid call. Nonexistent function 'stamina' in base
   'Node (Host)'`. Find the call (SidePanel or the FightHud change), trace what the view really offers for energy, legs
   and guard (read FightView.gd / HudBars.gd in `sed -n` windows; say in the result which function you read), fix it, and
   make side_panel_test fail on it: the test must build the panel against the REAL FightView the game uses, not a stub
   that has a `stamina` method (S420 rule: a seat test must run the game path).
3. OVERLAP. In the left panel the legend "fine / hurt / critical" lies under the words "lasts to". Give each its own
   row. Add to side_panel_test: no two visible Labels in a panel have rects that intersect.
4. NO SYMBOLS WITHOUT WORDS. The opponent panel's gold box shows a target, an arrow, a fist and "1x". Replace it with
   words a player reads at once (what it is, in 2 to 4 words, and the number with its unit) or remove it if it repeats
   something else on screen. The same for the three dots beside "heard": say "Heard 1 of 3" in words beside the dots.
   Add to side_panel_test: every icon in a panel has a Label sibling or a tooltip.
5. THE NAME (his mark 3). The name stays on the panel's top plate, large, with the corner colour as a stripe, and under
   it ONE line a player can use: for his boxer the plan's name in game words; for the opponent her record or what tape
   has shown. No "Plan: Own game" label-value form: say "Her own game" / "Jab and move".
6. THE INTENTION CHIP (new: scripts/fight3d/IntentChip.gd + tests/intent_chip_test.gd). Over each boxer's head in the 3D
   picture, a small chip that follows the head (Camera3D.unproject_position of the head bone, clamped inside the open
   middle between the panels, hidden when the head is off screen or behind the lens):
   - over the OPPONENT: her game in the coming exchange, the same words the bar's round board uses
     (Exchanges.MODES[sit]["label"], from LiveRound.preview's "sit": Pressing, Boxing at range, Waiting to counter,
     Loading up ...);
   - over HIS boxer: her state in one or two words from what the game already has (the call in force's label while it
     runs; "Hurt" / "Tired" when the game's own hurt and energy lines say so; nothing when there is nothing to say).
   Text 20 px or more, on a dark plate with the corner colour as its edge; a state that just changed gets Halo.ring for
   1 s. It never takes a click. It shows only while the scorebug shows (same rule as the side holos, S405).
   intent_chip_test: the words for each sit; hidden off screen; clamped between the panels; follows a moved head.
   Then REMOVE the "<NAME> NOW" column from scripts/fight3d/RoundBoard.gd (the chip and the panel now say it) and give
   its width to the other two columns; update tests/round_board_test.gd to match.
7. tools/fight3d_play.gd has a stale check: "S382 no holo figure is built in the live round" fails on main today
   (count 2) while "S405 the side holos follow the scorebug" passes. Read both, keep the one that states today's rule
   (the side holos follow the scorebug), delete or rewrite the stale one, and say which in the result.
8. No file over 500 lines (SidePanel.gd is 499: split the opponent panel or the bars into a second file if you add to
   it). New features ship ON. No new colours outside WoodKit / TV / the two corner colours.
9. docs/FIGHTDISPLAY3_RESULT.md: what was wrong and what you changed, per point above; the functions you read for the
   energy call; every label's text and rect in both panels as printed by a still run (you cannot see the picture, the
   rects are your eyes); anything in the owner's drawing you could not build.

## Prior research
ops/research/TASK_FIGHTDISPLAY2.md and TASK_FIGHTDISPLAY1.md (the drawing's data check), docs/mockups/s422/fight_10_simvet.html,
ops/research/FIGHT_DISPLAY_DECISION_S419.md section 7, scripts/ui/Halo.gd (header), scripts/fight3d/RoundBoard.gd (S427),
ops/research/GDSCRIPT_TRAPS.md, ops/Feedback/2026-11-10-20/README.md and 2026-11-10-16/README.md (his marks).

## What would a human do?
A broadcast puts the name on a plate with one line under it and a status word near the boxer; nothing on screen is a
symbol the viewer must decode.

## Prefab check
Halo.gd for anything "chosen" or "just changed"; KitIcon for icons; WoodKit.slate / bar for the panels. No new asset.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless
--audio-driver Dummy --path . --script res://tests/side_panel_test.gd` (the plain win64 exe, never the console one).
Windowed stills only: `python tools/hidden_desktop.py run --timeout=420 --log=<log> <godot.exe> --path . --windowed
--resolution 1920x1080 --audio-driver Dummy --script res://tools/fight3d_play.gd -- <out_dir>` and read the log for
`SCRIPT ERROR` and `FAIL` (both must be absent). Nothing opens on the owner's screens: view nothing with an app.
RESULT lines for the PR body: `RESULT: tests/side_panel_test.gd -> SIDE_PANEL failures=0` and one per regression test.

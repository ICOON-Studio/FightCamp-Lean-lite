# TASK FLOORHUD1 (S224) - the floor screen's loose HUD pieces get a home (Ludo r61 C3, C4, C5, C7) + locker name plates fit

Model: cloud Cursor (label `cursor`), composer default. Branch cursor/issue-<n>; never master. Read `.github/CLOUD_AGENT.md` first.
Approved: operator Q-S221-3 "Approve, build it" on `research/LUDO_ROUND61_VERDICT_S223.md` part C (read it; Ludo's full spec
`research/LUDO_ROUND61_REPLY_S223.txt` PART C). Already done, do not redo: B (STRIP1, calendar drawer, merged 423607ff).
NOT in this task: C6 (the street outside the walls - 3D art, another seat), C2 (not a defect).

## Do (every change behind the new switch `floor_hud2`, added to GameSwitches.GAME_ON - ships ON, read with `GameSwitches.on()`)
1. C3 DAY GOAL ON THE FIGHTER'S CARD. Today `Godot/scripts/DayGoalsHud.gd` (307 lines) floats the day goal ("Stamina above 30 at
   the bell", text built in `DayGoals.gd` ~line 49) bottom-left with no fighter attached. ON: the goal line sits inside the selected
   fighter's card on the floor (the card the floor already shows for the fighter in the club - find it from GymHallPanel.gd, 1202
   lines; never read it whole, grep "card"), one line under his name, with a progress tick (met = gold #E5B842 check, at risk =
   amber #D98039, failed = red). No fighter selected = the goal is not drawn. Same data source (DayGoals), no new rules.
2. C4 NEWS BAR. The cut-off news box at the bottom (find the node by grep "news"/"Ticker" in GymHallPanel.gd / ClubSpeedControls.gd -
   `TickerLine` ~line 101 is the speed bar's own ticker, leave that) becomes ONE thin bar along the bottom edge, full width minus the
   left tiles, 28 px high at 1920x1080 (scale with the UI scale at 1280x720): lines scroll right-to-left; a fight result is a chip
   ("KO R4", "DEC 3-0", "TKO R7") in the winner's corner colour, then the text. No text clipped at either size.
3. C5 NAV TILES. The unlabeled left icon column (`ShellChrome.gd` 1151 lines, RAIL_ICONS ~line 65, icon bar notes ~22) becomes dark
   square tiles (48x48 at 1920, #1E1713 fill, 1 px #3D3126 border, gold glyph on hover) with a tooltip on hover = the name + its F-key
   ("Gym - F2"). Tooltips use UIKit.tip (the one tooltip system). Keep the module ids and routing exactly as they are.
4. C7 OBJECTIVE CARD. "GUIDE - Hire a coach" floating bottom-right (`GuideCard.gd` 287 lines, created in CareerRoot.gd ~380) moves to
   ONE card top-right directly under the bout card: "STEP 1/4: HIRE A COACH" + one line of why, using the reveal schedule already
   in the game (Q-S221-2, approved S223 - do not invent new steps; read the steps the GuideCard already has). Nothing else floats in
   the bottom-right on the floor.
5. LOCKER NAME PLATES. In `Godot/scripts/LockerRoom3D.gd` ~244-248 a long surname runs past its 0.50 m plate. Fit it: shrink the
   Label3D font size until the text width fits 0.46 m (measure with the font's string size at that pixel_size), floor at 18; past the
   floor, cut with an ellipsis. Short names unchanged (34).
OFF (`floor_hud2` off = plain --script tests): every piece exactly as today. The locker plate fit is a defect fix - ON and OFF.

## Gate
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- New test `Godot/tests/floor_hud2_test.gd` (extends SceneTree; prints FLOOR_HUD2 PASS checks=N / FAIL): ON -> the day goal node is a
  child of the fighter card and absent with no fighter; the news bar is one node at the bottom edge, height 28 +- 2 at 1920x1080, no
  Label inside it overflows its rect; every nav tile has a tooltip with an "F" key; exactly one objective card and its top >= the bout
  card's bottom; OFF -> the old nodes are where they were. Locker: a 22-letter surname's plate text width <= 0.46 m, a 5-letter one
  keeps size 34.
- Existing: `python Godot/tools/run_tests.py --jobs 2 --only day_goal,guide,shell,locker,top_bar,hud`.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, screen form)
1. Stills of TODAY's floor first (RED: goal floating bottom-left, cut news box, unlabeled icons, guide bottom-right).
2. Stills at 1920x1080 and 1280x720 from the game's own flow (`-- as_game`; `Godot/tools/gymlook3a_stills.gd -- as_game out=...`
   gives the floor camera): the floor with a fighter selected, a nav tile hovered, the news bar showing a result chip; the locker room
   with a long surname.
3. Report per still: overlaps, clipped text, positions, what the player reads.
4. Do not call it accepted. Claude opens every still; the operator closes it.

## Prior research
LUDO_ROUND61_REPLY_S223.txt part C; LUDO_ROUND61_VERDICT_S223.md C; DESIGN review DEMO_DESIGN_REVIEW_S172 (three calls to action
compete on the home screen - this task leaves one).

## What would a human do?
Football Manager / Two Point: every HUD line belongs to something on screen (a person, a bar, a card); nothing floats alone.

## Prefab check
Nothing to fetch: reuse UIKit.tip, DayGoals, GuideCard steps, the existing ticker data.

## The one trap
GymHallPanel.gd and ShellChrome.gd are big shared files - change only the nodes named here; top_bar_timeline_test and the S223
calendar drawer test must stay green (do not touch the top bar).

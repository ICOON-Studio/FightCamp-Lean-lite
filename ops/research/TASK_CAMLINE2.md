# TASK CAMLINE2 - CLAUDE (Fable workflow, S431) - the fight camera, done ruler first: never behind one boxer, ropes fade whole, the gloves' blur measured

Status: OPEN (S431, Claude main). Discipline: boxing. Model: claude-fable-5-2.
Source: the operator, S429: the camera looks from straight behind one boxer and hides the other; the far ropes fade and
smear at head height; then, the same day: "actually its the gloves that have a weird b;lur effect can yhou check that".
CAMLINE1 (Qwen, PR 192) was NOT collected: read `ops/research/CAMLINE1_REVIEW_S431.md` whole (three readers, twelve
confirmed findings with the corrected fix for each). Its film (E:/FightCamp/tmp/s431_camline/p06b_round2_live.png and
p06e_round2_live.png) still shows the lens straight behind one boxer.
The full description of what to measure and the bars is `ops/research/TASK_CAMLINE1.md` (Steps 1, 2, 3): it still holds.
This page says what changes.

## Contract
OWNS: scripts/fight3d/RingCamera.gd, scripts/fight3d/RopeFade.gd, scripts/fight3d/CamLine.gd, scripts/fight3d/TvShot.gd, tools/cam_line_probe.gd, tests/cam_line_test.gd, docs/CAMLINE2_RESULT.md
RED_TEST: tests/cam_line_test.gd -> CAM_LINE failures=0
REGRESSION: ring_lens_test, corner_lens_test, bar_guard_test, promo_shot_test, ring_ropes_entry_test, file_limits_test, fight_flow_test
VISUAL: yes

## Where to work
A worktree `E:/FightCamp/wt/LEAN_CAMLINE2` on branch `claude/camline2` from origin/main, seeded with
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\LEAN_CAMLINE2`
BEFORE any Godot run (an unseeded worktree imports every asset and heats the PC). Never work in E:/FightCamp/Lean itself.
Starting material you may copy from branch `qwen/camline1` (worktree E:/FightCamp/wt/LEAN_CAMLINE1): CamLine.gd, the probe,
the test. Take nothing from its RingCamera.gd edit.

## Part A: the ruler (before any change to the game; commit it alone)
1. tools/cam_line_probe.gd must parse (CAMLINE1's redeclares `f`), play at least three real rounds of two different bouts
   through the path tools/fight3d_play.gd plays, and name every shot kind it saw (a kind it cannot see = VOID, say so).
2. HIDDEN: the body box is built ACROSS THE CAMERA'S VIEW (shoulders along the camera's right vector, a real half shoulder
   width), not along world x: CAMLINE1's box read 0.00 on the behind-the-boxer shot. Prove the ruler on two hand-set poses
   first: a lens straight behind one boxer must read HIDDEN, a side-on lens must not.
3. BEHIND: use TvShot.behind_deg (CamLine's copy goes).
4. ROPES: read the same array the game passes to RingCamera.clear_view (FightStage: the ring-side list), count per rope:
   pieces with alpha under 0.95, whether the rope is truly between the lens and a boxer, and whether ONE rope shows two
   different alphas (a rope cut in two: must be 0).
5. GLOVES (the operator's own complaint, first in importance): the same round rendered twice, as the game plays it and with
   `noblur`; ten punches at the frame of peak glove speed; smear in pixels, and whether the glove's colour bleeds onto the
   rope or face behind it. Lines `GLOVEBLUR punch=<move> speed_m_s=<x> smear_px=<x> noblur_px=<x> bleeds=<0|1>`.
6. Run it on today's main and write the numbers into docs/CAMLINE2_RESULT.md under BEFORE. The ruler must read RED on main
   for the behind / hidden bars (the film shows the fault): if it reads green, the ruler is wrong: fix the ruler.
7. tests/cam_line_test.gd (headless): the pure parts, plus one game-path check: build RingRopes as
   tests/ring_ropes_entry_test.gd does, a RingCamera in the tree, a boxer 0.06 m from a rope with an inside side-on lens,
   call clear_view with delta 0: every piece of that rope has ONE alpha. Show it red where it can be red on main.

## Part B: the fix (a second pass; the ruler's bars and thresholds are frozen: change none of them)
1. ROOM FIRST: RingCamera.gd is exactly 500 lines (the limit). Move the rope and post fading (clear_view and _fade and
   their constants) into a new `scripts/fight3d/RopeFade.gd` that RingCamera calls, behaviour unchanged, regression green,
   BEFORE adding anything. No file over 500 lines at any commit.
2. THE ANGLE: when the lens looks along the pair (behind under 30 degrees) or one boxer is HIDDEN, the shot slides round
   the pair or cuts to the side from which both faces show, within 0.4 s; a close-up and a caption shot pick that side
   too. Wire it where the game decides shots (RingCamera `_due`, `_cut`, `_ride`, `close_up`, TvShot), not in a helper
   nobody calls. Both boxers stay in frame head to feet (BarGuard and the frame rule still hold).
3. ROPES: decide per ROPE and by which side of that rope the lens stands (the review's corrected fix): a rope fades whole
   or not at all; from a lens inside the ropes, a rope a boxer leans on does not fade.
4. THE LENS NUMBERS: one place sets the far blur (today `_init` says one number and every cut sets another back). Far ropes
   behind the heads stay readable; the crowd stays soft.
5. THE GLOVES: decide from Part A's measurement, not by feel. Keep 8 samples (S426: fewer samples ghosted hair edges; he
   saw that). One constant for the live intensity used by every shot kind (ride, close-up, film). If the smear bleeds the
   glove onto faces or ropes, shorten it (object-movement multiplier) until the measured smear is under one glove width;
   say the number.
6. AFTER numbers into docs/CAMLINE2_RESULT.md beside BEFORE; then a film: `tools/fight3d_play.gd` on the hidden desktop,
   stills into E:/FightCamp/tmp/s431_camline2/. Open every still yourself with the Read tool: both boxers head to feet,
   both faces or one face and one profile, nobody hidden, no rope cut in two.

## Rules
- Godot only through the queue, one job at a time, from the worktree:
  headless: `python E:/FightCamp/Lean/ops/Tools/godot_slot.py run --who claude -- "<godot.exe>" --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`
  windowed (the probe, films): `python E:/FightCamp/Lean/ops/Tools/godot_slot.py run --who claude -- python E:/FightCamp/Lean/tools/hidden_desktop.py run --timeout=580 "<godot.exe>" --path . --windowed --resolution 1920x1080 --audio-driver Dummy --script res://tools/<name>.gd -- <args>`
  <godot.exe> = %LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe (NEVER the _console.exe). Parse first:
  the headless command with `--check-only --script res://<file>` (a parse error hangs a headless test).
  Other sessions film too: a wait of several minutes for a slot is normal. Never two windowed jobs at once.
- Nothing opens on a monitor: pictures only with the Read tool. Never kill Godot by image name.
- Read ops/research/GDSCRIPT_TRAPS.md before writing GDScript. Game text never uses he / she.
- Two boxers in any measurement differ (stats, height, stance); name the bouts measured.
- Commit to `claude/camline2` with explicit paths (`git add -- <files>`), push the branch, never main. No merge.
- Do not touch: scripts/fight3d/BoxerBuild.gd, FightStage.gd (read only), FootPlant.gd, Footwork.gd, RingFeet.gd,
  RkPure.gd (HUMANFIGHT1 owns them), CornerShots.gd, CornerMinute.gd (CORNERFACE1), anything under scripts/ui.

## Prior research
ops/research/CAMLINE1_REVIEW_S431.md, ops/research/TASK_CAMLINE1.md, scripts/fight3d/TvShot.gd (the shot rules),
scripts/fight3d/BarGuard.gd, tests/ring_lens_test.gd, the memory note "A seat test must run the game path".

## What would a human do?
A TV director never shoots a boxing match from behind one man's back for long: the main camera sits side-on, and cuts or
slides when the fighters turn. A camera operator keeps motion blur short enough that a glove is still a glove.

## Prefab check
The motion-blur add-on is already in the project (res://addons/godot-motion-blur). Nothing new is needed.

## Result lines
RESULT: tests/cam_line_test.gd -> CAM_LINE failures=0
RESULT: tools/cam_line_probe.gd -> CAMLINE2 frames=<n> hidden_share=<x>% longest_hidden_s=<x> behind_share=<x>% split_ropes=<n> shots=<kinds>

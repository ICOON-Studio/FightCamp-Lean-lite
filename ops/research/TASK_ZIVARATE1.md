# TASK ZIVARATE1 - rate the new fight animations and the 3D fight realism (Ziva, after ZIVA9)

Operator S272, verbatim: "and have ziva rate the new animations and 3d fight realism".
Model: Ziva Smart, reasoning MAX. Worktree E:/FightCamp/wt/ZIVA, branch ziva/playtest. Discipline: BOXING (demo) only.

## First
Merge origin/master into ziva/playtest. Master now has your ZIVA9 rounds 1-3 + LUDO10 work (Claude collected it as 603acc7c -
thank you; one fix on top: tests/speed_lock_day_one_test.gd loads GymClub3D at runtime, a const preload compiled before the
CompetitionData autoload). It also has the NEW CLIPS you are rating (8b67214c):
- jab, cross, guard idle = Rokoko free mocap (scripts/FightClipRokoko.gd, switch `rokoko_clips`, S271),
- rear uppercut = Meshy library clip 194 (same file, S272),
- everything else is still the older hand-made/retargeted set (research/MOVE_SOURCES_S272.md lists which move plays what).
The operator on the Rokoko renders: "the animations look fine and the fighter does not get distorted like previously".

UPDATE (S272, after you started): the operator watched the 20 s fight and ruled "meshys animations i think are not good" - the
Meshy rear uppercut row is OFF on master (FightClipRokoko.gd, commented). Rate the Rokoko jab/cross/guard as the new standard;
record_room now also takes `palette=boxing_jab,boxing_cross` (a Rokoko-only bout) - use it for the "new clips" row.

## DECISION (Claude, S272) - MOCAP PLAYS PURE
Operator on the 20 s fights: "bodies twisting again looking wierd andnothing is smooth"; "this has nothing to do with the
animations i see on the board". A clip with meta `rokoko_clip` plays PURE in the fight: every synthetic layer fades out while it
plays (as FightAliveStance already does since S271) - guard IK, guard body curl/clavicle, punch_load, head_level, foot_repin
re-bend, punch retime / S-curve / strike warp. Kept: root placement (single root solver) and pair spacing. ONE switch
`mocap_pure` in GAME_ON; red test first (pelvis height, knee angle, hip yaw as played within ~3 cm / 5 deg of the clip alone in
the studio, bodies 09 and 04); then per-layer A/B numbers in the report and a 20 s as_game clip for the operator.

## THE REFERENCE TO MATCH (operator: "make sure ziva can see the rokoko clips as they palay on the board")
8787/animations, section NEW MOCAP SOURCE (ROKOKO) (21) = previews/anim_compare/rk_*.mp4. Frame sheets (open with your
image tool): previews/s272_fight/board_rokoko_21/rk_*.png; side by side with the fight:
previews/s272_fight/board_vs_fight/. ffmpeg for more frames: C:/Python314/Lib/site-packages/imageio_ffmpeg/binaries/
ffmpeg-win-x86_64-v7.1.exe. Acceptance for the squat/twist fix: the fight looks like these.

## PRIORITY 1 - THE FIGHT SQUAT (operator S272, on the 20 s fight: "i didnt see any of that onthe animations earlier")
His screenshots: previews/s272_fight/operator/squat_lean_in.png (both men in a deep squat, knees far past the toes,
heads pressed together, gloves on each other's heads) and red_hunched.png (red hunched back, arched). The SAME Rokoko clips in the
studio orbit renders (8787/animations, tools/anim_orbit_render.gd - clip alone on the body) stand taller. So a FIGHT-TIME layer
deepens the crouch and pulls the men together. Find which, with numbers:
1. Measure per frame on the same body and clip: pelvis height over the floor, knee angle, head-to-head distance - studio
   (anim_orbit_render play_role) vs the live fight (record_room as_game palette=boxing_jab,boxing_cross bodies=09,04 seed 94301).
2. A/B one layer at a time with the switches' red arms (`off=<switch>`): foot_repin, single_root_solver, punch_load,
   head_level, guard_ik, overlap_in_takes, join_default; also plant_skin_floor and the body's height scaling (Stage.mount
   height vs the body's own 190/195 cm), and FightClipRokoko's build cache (keyed by bone count only - two bodies of
   different heights share one build).
3. Fix the cause in your fight-motion ownership (red test first: pelvis height as played within ~3 cm of the clip's own),
   then the stills on the fight camera. Write the before/after numbers in your report.

## What to rate (a Steam reviewer of a boxing management sim, honest, 1-10 per row, evidence for each)
1. The NEW clips as played in a live as_game bout: jab, cross, guard, rear uppercut - does each read as the punch it is, start and
   end in guard, land at the target, blend in and out without a pop or a foot slide? Name the frame of every defect.
2. The OLD clips beside them (lead hook, body shots, overhand, up-jab, defence slip/pull/catch, footwork): how badly do they clash
   with the mocap now? Rank the five that hurt most - that list decides what we source next.
3. 3D FIGHT REALISM as a whole: spacing (gloves into faces, men overlapping), feet (skating, planted on hooks), head movement,
   weight transfer, reactions to being hit, clinch, how a real boxing broadcast would look. Compare with real footage
   (research/MOVE_SOURCES_S272.md, research/reference) and Undisputed (research reference_undisputed notes).
4. The blending: the operator asked "but they need blending ?" - measure the transition into and out of each new clip (pose jump
   in degrees on the worst bone over the blend, root/foot pop in cm) and say whether the blend times are right.

## How
- record_room as_game, --fixed-fps 30, stills ONLY through tools/still_framing.gd save_if_framed (both men head to feet; boots).
  Ten seconds of a bout costs ~300 frames; record two seeds with different fighters (never identical fighters).
- Claude recorded a 20 s clip for the operator with `bodies=09,04` (record_room S272 arg: MetaHuman body per corner) - use it for
  a Black vs White heavyweight pair when you want the same bodies.
- tools/rokoko_path_probe.gd measures a clip's path (forearm angle, rise, guard at start/end, the other hand's distance from
  the head) - use it for numbers, not impressions.

## Deliverable
A new report research/ZIVA_ANIM_REALISM_S272.md: a ratings table (rows above), every defect with its frame and still, the
five-worst-old-clips ranking, the blend numbers, and your top three fixes in order of rating gained per hour. Commit + push on
ziva/playtest. Fixes you are sure of inside your ZIVA9 ownership (fight motion, spacing, watchability) you may land as before,
one defect per commit; new looks/mechanics stay proposals.

## House rules (unchanged from ZIVA9)
Watchdog before every heavy run (Tools/pc_watchdog.ps1 -Once; RED = wait). ONE Godot run at a time beside your editor; kill by
PID only. Windowed Godot only via Tools/godot_hidden.ps1; nothing on the operator's monitors; view images with your file tool.
Parse gate before any test; never the full suite. Commit messages end with: Co-Authored-By: Ziva <ziva@fightcamp.local>.
Never commit to master.

## Prior research
ZIVA_PLAYTEST_S267.md (your rounds 1-3), MOVE_SOURCES_S272.md, S271_DIGEST.md (why the old punches looked bad: the hips),
ANIM_SOURCE_S270.md, TWOPOINT_ALIGNMENT.md (camera numbers).

## What would a human do?
Watch the bout at full speed first like a fan, then frame by frame like an animator, and only then measure.

## Prefab check
n/a (a rating, not a build).

## The one trap
Do not rate a still or a test - rate the moving bout the player sees (as_game, the fight camera).

## Contract
OWNS: research/ZIVA_ANIM_REALISM_S272.md
RED_TEST: n/a
REGRESSION: rokoko_clips_test
VISUAL: yes

## S273 EVIDENCE (Claude, before your fix) - the layers ARE the squat
Operator S273: "why the video looks so bad and the clips onthe board (rokoko) look so good?". New recorder
`tools/fight_studio_render.gd` (record_room + only the two fighters on the board's grey-grid studio, game camera). Same bout
(as_game seed 94301 bodies=09,04 palette=boxing_jab,boxing_cross), two arms:
- ON = the game today; PURE = `off=guard_ik,punch_load,head_level,foot_repin,punch_retime,anim_scurve,elbow_tuck,
  guard_hand_clearance,anim_glove_spring,anim_fatigue,guard_ramp_clip,overlap_in_takes`.
- previews/s273_fight/rokoko_fight_layers_on_vs_pure.mp4 (side by side) + ab_frame1..3.jpg. At 14 s ON = deep squat,
  chest to chest, red hunched; PURE = both upright at board height. Frame 2 PURE: red's rear glove floats high during blue's jab
  (the guard idle with no guard IK) - mocap_pure must keep a guard that reads as a guard; measure it, do not assume.
Use the recorder for your 20 s as_game acceptance clip: `--script tools/fight_studio_render.gd -- as_game seed=94301 bodies=09,04`.

## S273 CORRECTION (Claude, measured - read this over the section above)
The "layers ON vs PURE" A/B above was misread: the PURE arm stood straight-legged too (operator: "you aredoing something wrong").
Measured with `fight_studio_render clip_log=1` and `anim_orbit_render pelvis_log=1`: the fight's guard ("idle" = Rokoko
FightingIdle 40.87-42.87 s) plays at the SAME pelvis height as the board (body 04: 0.90 m both), but the feet wandered
0.12-0.97 m apart (board 0.54-0.57). Cause = the HUMAN2 step planner (FightFootLock.push_pull, `human_footwork`), not the
guard layers: off=human_footwork removed the collapse. FIXED on master 5eabbe63 (a forward/standing step of a Rokoko take lands
inside 0.80x-1.15x the clip's own toe spread; retreat keeps HUMAN2). Also 5eabbe63: switch `steady_camera` (no shake / hit cam /
torso spring, slow dead-zone orbit). Merge master before you touch FightStagePlayer/FightFootLock. Still open for you: the
squat/hunch the guard layers add on top, the retreat-step collapse (0.15 m once on body 09 after a slip), and spacing.

## S273 - your P1 answered (Claude, measured) + mocap_pure collected
P1 = NO CHANGE. The board's orbit renders ARE at the fight's scale: anim_orbit_render builds the live room and plays fighter B
through FightWorldStage.mount - `pelvis_log=1` on body 04 reads 0.900 m on the board (= 0.947 x 0.949, your own fight number).
Your 0.947 is the raw-clip probe with no body node, not the board. The statures are the fighters' own data (FighterPhysique,
reach/spacing read them) - they stay. The board already shows the man at the size he fights at.
mocap_pure (74a036ab) collected on master by diff (code, test, tools, report; the 43 MB clip and 7 MB PNGs stay on your
branch). Combined with 5eabbe63 (guard stance) + steady_camera: docs/previews/s273_fight/fight_pure_guard_steady.mp4.
NEXT for you (your own top-3 list stands): the guard's fists wide of the chin at the pocket (seen at 14 s), the entry join
(idle->jab first-frame pop), the five worst old clips (lead_hook first), spacing; then cut footwork steps from Rokoko
FightingIdle (70 s between punches) for the procedural step moves. Merge origin/master first.

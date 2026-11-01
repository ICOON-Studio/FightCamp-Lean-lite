# S337 - next session (written S336, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S336 shipped update 38: ground moves grip (scripts/grapple/GrappleGrip.gd) and keep their own pace (GrappleTiming.gd, merged
from the side session), MMA trim, no links in move names; the boxing move map rules (scripts/rules/StrikeMap.gd, Qwen); tests run
4 at a time (`sh tools/run_tests.sh`, JOBS=2 beside agents). Digest: Game\Godot\research\S336_DIGEST.md.
Operator on the film: "video looks good".

1. FACES3 first (operator S336, on the S334 young-faces lineup: "why the fuck you have 4 blacks ???? add more whites", then
   "no keep them all dont rebuild"): keep every current face. Build THREE NEW white women (18-21, long full hair - no braids,
   cornrows or undercut - hair LOD 0, attractive: Celeste/Jelena-based face_blend or an unused preset after a render check;
   a preset name is not a sex) with Game Tools/metahuman (mh4_plan rows -> mh4_run.py, MH4_TARGET_DIR = Lean assets) as
   mh_boxer_21-23. Render a lineup beside the current five (S334_stills/young_faces_lineup.png style), board question with the
   lineup attached, and only after his yes add them to Faces.CM / CAST (new named prospects or opponents) + the 4 bakes
   (portraits, masks, turn, headshots, `stems=`). Unreal is heavy: run it when no PC agent runs Godot.
2. Collect GROUND2A (Cursor, E:\FightCamp\wt\LEAN_GROUND2A, branch cursor/ground2a): GrappleContact.gd + its test; its
   GrapplePlayer change is the one line `out = GrappleContact.separate(out)` at the end of joints_at - apply it by hand on
   main's new (GrappleTiming) GrapplePlayer. Run grapple_contact_test + the grapple regressions, film `walk=10`, contact sheet,
   SendUserFile + review_add.
3. Collect NEXTSTEP1 (Qwen, branch qwen/nextstep1): NextStep.road(). Then launch Cursor on TASK_GREYWHY1 (Game research), then
   a brief for the NEXT STEP card on her page (FighterPage) reading NextStep.road.
4. Q-S294-61 step 2: the boxing browser - StrikeMap's cards with moves in/out, the GrappleBrowser layout.
5. Board: Q-S294-62 (wrestling plan, WRESTLE_S336.md) - act on his answer. C154's "wire the in and outs" idea = the plan board.

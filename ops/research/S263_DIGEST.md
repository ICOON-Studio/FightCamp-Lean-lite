# S263 DIGEST - 2026-10-19 - boots on every boxer, exact MetaHuman correctives from the DNA, look A/B, 3 agent runs collected

## Shipped (all on master, pushed)
- 4453faf4 the two orphan S217 recovery-rate tests committed (both PASS --jobs 2; RecoveryRate already wired).
- 06ae095a BOOTS on every MetaHuman boxer (operator S263: "use boots on the fighters", then "i told you before wtf").
  Cause: FighterKit.wears_boots matched only '_box_' (old f01-f04 files), never mh_boxer_NN.glb - the whole MetaHuman cast fought
  barefoot. Now mh_boxer_* wear them, boxing only when the discipline is known. New fit FighterKit._dress_metahuman: in the
  fighter's rest space (Y up: ankle->ball forward, toe 10 cm past the ball, heel 9 cm behind the ankle, sole on the lowest skin
  vertex), then the foot bone's rest frame (Cursor #260 r2 fitted in UE bone axes -> soles 0.65 m up). Stills guard / mid / contact
  on the broadcast camera: boots on all four feet, soles on the canvas (docs/previews/s263_boots). fighter_kit + profile_stage PASS.
- 02c314c2 + 9317e8fb MHCORR - the MetaHuman body correctives Unreal runs, from the body DNA (John S262 route A, no grid sampling):
  UE 5.8 ExportDNA (body only; DCC export refuses an un-rigged character) -> Tools/riglogic_dump/dna_to_json (built with MSVC from
  UE's own RigLogicLib source in place) -> Tools/mh_corrective_table.py -> Godot/assets/data/mh_correctives_boxer01..04.json
  (14 solvers each: clavicle/upperarm/lowerarm/hand/thigh/calf/foot; fingers skipped under gloves). Primary sources read:
  RBFSolver.cpp (gaussian exp(-d/r^2)), CPURBFBehaviorEvaluator.h, AnimNode_RigLogic.cpp (input = InvNeutral*Pose, output =
  neutral+delta / neutral*delta), TwistSwingJointsEvaluator.h (correctiveRoot = invTwist*slerp(invSwing, I, 0.5)).
  Neutral check vs the shipped GLB: euler xyz, <= 0.14 deg on 340 joints; t 3 um on 01/02; 4 cm on 03/04 legs+spine because the
  shipped 03-12 come from the MH4 build whose UE project is GONE (retired worktree) -> deltas from 'default' laid on each body's
  own rest; bodies 05-12 use boxer01's deltas. Helpers really move: clavicle_scap 12.8 cm, upperarm_fwd 15.9 cm, lowerarm_bck 73 deg.
  Wired: scripts/MetaHumanCorrectiveRBF.gd (SkeletonModifier3D after twist), MetaHumanRig.load_fighter (switch mh_dna_correctives,
  GAME_ON; replaces S261's guessed 4-helper MetaHumanCorrective; driven helpers keep their skin - fold keep=).
  Gate: tests/mh_dna_correctives_test.gd green (rest, 90 deg elbow -> lowerarm_bck > 1 cm, root ~45 deg, swing_output, skin kept);
  14 MetaHumanRig tests green. Stills before|after on the game camera: fuller shoulder/scapula + elbow volume, no tearing
  (docs/previews/s263_mhcorr/before_after.png, on the review board). KNOWN: rest drift 1.9 cm from MHRBF1's compact kernel - Arena
  MHRBF2 (running) adds RigLogic's exact interpolative mode; the test's bound tightens 3 cm -> 2 mm by itself when ue_kernel exists.
- 0d7cdd1a Arena #275 MHRBF1 CorrectiveRBF.gd collected (fast lane; mutants proven). dc5a1050 Arena #274 GUARDPOSE2 collected by
  diff (safe two-bone IK kernel; elbow_for within 1 mm of master on 200 targets; guard_pose + guard_ik_pass PASS).
- f7bd8eea + 20855ab9 LOOK A/B harness (Maria S262): rules/MetaHumanLook.gd skin presets per tone (specular 0.42 = skin F0, roughness
  0.48 dark..0.55 light, SSS 0.30..0.45, pores off, clearcoat + rim), roughness limiter, VenueRig.broadcast_pass (gives the default
  hall an environment - it had NONE; soft-shadow fills; exposure 1.3); look_ab_still.gd; sheet docs/previews/s263_look/look_sheet.png.
  DEFAULT_LOOK stays A (nothing changes in the game) until the operator answers Q-S256-2 (board, sheet attached).
  Probes A/B/C/D: canvas 98/98/108/108; dark torso 71/67/67/62. C washes the light boxer paler - said in the question.
- 5d034768 Cursor GOALSTRIP1 (#270) collected by diff + 4 fixes seen on the gym HUD still (tools/goal_strip_still.gd): '80%%'
  printed literally + overflow, bar under the percent label, card over the Day Plan modal (now steps aside), card over the form cue
  bar (now sits under it). 8 tests PASS.
- Tool defect fixed: Tools/auto_collect.py crashed on a check mark (cp1252) - stdout utf-8.

## Agents
- Ziva (chat "Ziva: Merging and Access Requests", Ziva Smart, effort MAX - operator S263): ZIVAMOTION1 #1. S263 steer: POP window =
  metrics guard_ik_w strictly 0..1, excess vs a guard_ik bypass that keeps the weight timeline (its own tools/guard_pop_compare.gd);
  #2 via tools/fight_motion_probe.gd (NOT probe_foot_lock.gd - MANUAL modifier path never applies); #6 dropped (Claude wired the
  DNA correctives); never edit existing tests. Nothing committed on ziva/playtest yet. The second chat ("Task Brief") is stopped.
- Arena MHRBF2 running: https://arena.ai/agent/01a15484-7294-774a-a629-b395f8b5ec5b (brief TASK_MHRBF2.md, contract OK).
- Cursor PREVIEWLOOK1 round 3 (#260, issue body rewritten): boots done on master; keep the Profile look; world-space boot test.

## Operator
- C113 ("that looks wierd", mark on the 8 cm clavicle panel): that variant never shipped (2.5 cm did). C114 "blue guy looks perfect".
- "use boots on the fighters" / "i told you before wtf" -> fixed, stills sent + review board; memory feedback_boxers_wear_boots.
- "use this on ziva" (effort slider) + "ziva smart , max intelligence" -> set; memory updated.
- Q-S256-2 boxer look A/B/C/D on the board (sheet attached).

## Next (S264)
1. Collect Arena MHRBF2 (normal route: CorrectiveRBF.gd modified -> diff + corrective_rbf_test + corrective_rbf_ue_test +
   mh_dna_correctives_test, whose rest bound tightens to 2 mm by itself) - then re-take the before|after correctives stills.
2. Q-S256-2 answer -> set MetaHumanLook.DEFAULT_LOOK to his pick (one line) + stills.
3. Ziva: collect each ZIVAMOTION1 commit by diff (#1 POP, then #2 foot plant).
4. Cursor #260 round 3 when it lands (preview_look_test must pass on master's boots).
5. Correctives follow-ups: driver twist joints from the DNA's twist layer (8 twists; MetaHumanTwist drives them by hand today);
   rebuild the MH4 UE project for bodies 03-12 so each gets its exact table (Tools/metahuman/mh4_run.py; ~12 UE runs).

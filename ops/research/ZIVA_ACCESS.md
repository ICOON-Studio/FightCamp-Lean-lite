# ZIVA ACCESS MAP - everything for animation and training (S262)
Operator S262: "i want ziva to have full access to research and everything needed for the animation and training".
Ziva = full seat (S248: "ziva should be able to do everything even build mechanics"). Auto-approve is ON (operator, S262).
Your worktree: E:/FightCamp/wt/ZIVA (branch ziva/playtest, res:// = E:/FightCamp/wt/ZIVA/Godot). The main checkout
E:/FightCamp/Game is readable for anything newer than your branch (never edit it - Claude merges your diffs).

## 1. Research - the project's memory (read before building; cite what you used)
- Index: E:/FightCamp/Game/RESEARCH_INDEX.md. Search: `python Tools/prior_research.py <terms>` (from the repo root).
- Canonical topic pages: research/topics/ - for motion: striking.md, footwork.md, defence.md, hit_reactions.md,
  playback_blend.md, retarget_rig.md, clips_sources.md, contact_collision.md, clinch.md, camera_broadcast.md, fighter_looks.md;
  for training: training_floor.md, attributes_skill.md, staff_coaches.md, pace_calibration.md, plans_corner.md.
- Animation record (newest first): ZIVA_CLIPREVIEW_S262.md (yours), TASK_ZIVAMOTION1.md (your task), CODEX_GUARDPOSE_S262.md,
  ludo_rx/LUDO_GUARDPOSE_S261.txt (Ludo's per-style guard table), CLIPREVIEW1_FEEDBACK.md + CLIPREVIEW1_*.md (six seats on the
  fight clip), TASK_FIGHTMOTION1.md (one root solver, skate 25% -> 13-15%), TASK_PUNCHTIMING1.md, UNDISPUTED_STUDY_S254.md
  (punch timing from the shipped game), ACTIONFORGE_HOWTO_S247.md, TASK_PADPAIR1*.md, D69_JAB_REFERENCES_DOLA_S231.txt +
  J63_REFERENCE_JABS_REPLY.md + M43_JAB_GUARD_BAR_REPLY_XAI.md (the real-jab bar: a new jab passes only side by side with real
  reference jabs), ANIM_AUDIT_VERDICT_S224.md + AUDIT_ANIM_S224_*.md, ANIMFIX1-3 digests, GYMLIFE_CLIPS_S233.md.
- Training record: ATTRIBUTES_S259_VERDICT.md + TASK_ATTRIB1.md + TASK_ATTRIBUI1.md (11 attributes), FIGHTLINK_DIRECTION_S248.md +
  TASK_FIGHTLINK*.md (training -> the bout), LOOP1_SCOPE_S237.md + LOOP1_VERDICT_S238.md (the gym day loop), J62_TRAINING_DAY_REPLY.md,
  GYMFLOOR_MECHANICS_IDEAS_S234.md + GYMFLOOR_PLAYTEST_S234.md, TASK_CAMPMETERS1.md, TASK_CAMPPAY1.md.
- Settled decisions (never reopen without new evidence): research/DECISION_LEDGER.md, AgentComms/route_decisions.json.
- Rules: E:/FightCamp/Game/CLAUDE.md (house rules), research/GDSCRIPT_TRAPS.md (read before writing GDScript),
  .claude/skills/visual-gate/SKILL.md (how a visual change is proven), research/TWOPOINT_ALIGNMENT.md (gym/rooms).

## 2. Animation assets
- Clips: Godot/assets/anim/ - metahuman (MetaHuman boxer clips), actionforge (ActionForge boxer + clips), mixamo_s215 (244 files,
  catalogue Godot/assets/data/mixamo_s215_catalogue.json), mixamo_gymlife (gym station clips), c223 (certified fight moves),
  audition, pairs, ual. Certified demo palette: Godot/assets/data/certified_moves.json.
- MetaHuman bodies: Godot/assets/models/metahuman/ (mh_boxer_01..04); source project E:/FightCamp/metahuman_pilot/MHPilot
  (UE 5.8, MetaHuman Character assets MH_Boxer_01..04, staff); export scripts E:/FightCamp/metahuman_pilot/scripts/.
- Videos/stills to judge against: previews/ (s258_fightmotion = the fight clip, s262_guardik = guard IK stills,
  anim/, c209, c212...), operator review board items E:/FightCamp/review/.
- Rig code: scripts/MetaHumanRig.gd, MetaHumanTwist.gd, MetaHumanCorrective.gd, FightClipRetarget.gd, FightClipBinding.gd,
  FighterSkinFollower.gd, FightLegIK.gd, addons/kickback/ (two_bone_ik.gd, arm_ik_solver.gd, foot_ik_solver.gd).

## 3. Training (gym) code
scripts/rules/Attributes.gd + rules/AttributeTraining.gd (the 11 attributes, lived-day growth, bout effects), DrillMastery.gd,
ComboMastery.gd, TechniqueTrainingCoordinator.gd, TrainingFloor3D.gd + TrainingFloorLayout.gd + TrainingFloorPanel.gd +
TrainingHubPanel.gd (the training floor), StationMovePicker.gd / StationInfoCard.gd / StationDisciplineFit.gd /
StationIntegrity.gd (stations), FightCamp.gd + FightCampPanel.gd (pre-bout camp), CoachPool/CoachRapport/CoachVoice/PlanCoach.gd.
Station animation (coach walks, pads, bag): GYMLIFE_CLIPS_S233.md, PADPAIR1 briefs. Coach walks, never runs (C106).

## 4. Probes and gates (reuse before writing a new one)
Godot/tools/: guard_lift_still.gd (live-camera guard/mid/contact stills + GUARD_PROBE/GAP_PROBE; args as_game style= elbow_log=1),
still_framing.gd (save_if_framed - every fight still goes through it), record_room.gd, move_shape_probe.gd, c223_guard_probe.gd,
c223_clip_gate.gd, c223_production_gate.gd, c223_sequence_gate.gd, c223_join_measure.gd, probe_foot_lock.gd, animfix1_sole_gate.gd,
c224_uppercut_gate.gd. Parallel C223 gates: `python Tools/c223_parallel.py production|sequence -- <args> report=<x>.json`.
Clip status: `python Tools/clip_status.py new-anims`.

## 5. External tools you may run (headless only - nothing may appear on the operator's screens)
- Blender 5.2: "C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" --background --python <script.py> -- <args>
  (pose authoring, GLB export, retarget). Examples: E:/FightCamp/metahuman_pilot/scripts/bl_*.py, Tools/cmu_bvh_to_glb.py.
- Unreal 5.8: "C:/Program Files/Epic Games/UE_5.8/Engine/Binaries/Win64/UnrealEditor-Cmd.exe" <MHPilot.uproject>
  -run=pythonscript -script=<py> (headless; see metahuman_pilot/run_ue.sh, mh_build_pilot.py). Heavy - watchdog GREEN only.
- Cascadeur: C:/Program Files/Cascadeur/cascadeur.exe (licence ends 2026-10-27; GUI app - ask Claude before any Cascadeur job).
- Python with OpenCV/PIL (you used cv2 to decode the mp4); your own ffmpeg: %APPDATA%/Godot/app_userdata/FightCamp/ziva/bin-deps/.
- Ludo CLI (`ludo model animate|rig|animate-preset`, credits per call): only after the operator has run `ludo login`; budget guard
  LUDO_MAX_CREDITS; ask Claude first (credits are money).
- Paid generators (Tools/gen/fal_generate.py, pay-as-you-go) - NOT without the operator's yes.

## 6. Limits that stay (operator rules)
PC: watchdog before every heavy run, RED = do not start, CPU never above 84 C, one heavy run at a time. Nothing opens on his
screens (Godot only via Tools/godot_hidden.ps1, Blender/UE headless, images via your image tool). Git: explicit paths, never
add -A / stash / reset --hard / clean, never .import churn, never push to master. Money (paid APIs, plans, credits) and taste
(how it looks - he closes visual items from stills) stay the operator's.

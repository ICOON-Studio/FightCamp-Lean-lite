# TASK ZIVAMOTION1 - Ziva builds and proves the human-motion layers #1-#4, then #5, #6 (S262)
Seat: Ziva (Godot editor agent, worktree E:/FightCamp/wt/ZIVA, branch ziva/playtest). Discipline: boxing = demo.
Operator S262: "ask ziva to build and prove #1-#4 in this project right now and then #5,#6".
Source: Ziva's own review research/ZIVA_CLIPREVIEW_S262.md (ranked list (c)). Claude reviews, merges, closes nothing visual -
the operator closes visual items from game-camera stills.

## House rules (non-negotiable)
- PC heat: before every Godot/Blender run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`
  (exit 1 = RED = do not start; wait). One heavy run at a time. CPU temp never above 84 C.
- NOTHING OPENS ON THE OPERATOR'S SCREENS: no windowed Godot except through `Tools\godot_hidden.ps1` (hidden desktop), Blender only
  `--background`, never open images/videos with an app - use your image tool.
- Blender: "C:\Program Files\Blender Foundation\Blender 5.2\blender.exe" --background --python <script.py> -- <args>.
- Git: commit on your branch ziva/playtest in E:/FightCamp/wt/ZIVA with explicit paths (`git add -- <files>`), never `git add -A`,
  never stash/reset --hard/checkout ./clean. Push the branch; Claude applies your DIFF to master. Never commit .import churn.
- Every new feature ships ON: add its switch to `GameSwitches.GAME_ON`, read it with `GameSwitches.on()`. Plain `--script` tests are
  the OFF control arm; `-- as_game` is the game.
- Parse gate before any run: `python Godot/tools/check_scripts.py <touched .gd>`. Tests: `python Godot/tools/run_tests.py --jobs 2
  --only <names>` (never without --jobs, never the full suite, never `--only fight_`).
- Big files: FightStagePlayer.gd and FightRealtime.gd are never read whole - grep + windows.
- Read research/GDSCRIPT_TRAPS.md before writing GDScript.
- Stills: only `tools/guard_lift_still.gd -- as_game` (or a copy of it) through `Godot/tools/still_framing.gd save_if_framed`
  (both men head to feet in frame). For each still write: gap between bodies / where each nose points / wrists in line / feet /
  the defect / which bodies. Never call a visual "fixed" - say what the still shows.

## Already built by Claude this session (commit on master - pull it first; do NOT rebuild)
#1 GUARD IK: `FightStagePlayer._guard_ik_pass` (switch guard_ik, GAME_ON): each wrist on its GuardPose target in the head frame,
two-bone IK (rotate UpperArm then LowerArm, lengths kept), elbow aimed by GUARD_ELBOW_AIM per style + `elbow_swivel_to_flare`,
per-arm weights (only the punching arm releases, 0.08 s out / 0.16 s back, quintic ease), body layer `_guard_body_pass` (Ludo's
clavicle raise/forward, chin tuck, thoracic curl per style). Probe: tools/guard_lift_still.gd (style=<name>, elbow_log=1).
Test: tests/guard_ik_pass_test.gd. Stills: previews/s262_guardik/. Arena is writing GuardPose.gd's safe IK kernel
(TASK_GUARDPOSE2) - do not edit Godot/scripts/rules/GuardPose.gd.
Your #1 job: PROVE and refine, not rebuild: (a) knuckle orientation / wrist (Ludo: lead ulnar 8 deg + extension 10, rear ulnar 6;
Codex: inward yaw table, wrist flex within +-8) - the pass currently restores the clip's hand rotation; (b) the guard -> punch ->
guard transition has no pop (record 30 fps frames across a jab and a cross; hand jump <= 5 mm at the release/return); (c) high
guard vs peek-a-boo are hard to tell apart from the broadcast camera - make them read differently within Ludo's numbers.

### #1 DECIDED (Claude, S266) - CLOSED, do not re-open
The rate-capped adaptive ramp (`76df4f90`, `guard_ik_slew` capped by the CLIP's own hand speed; `f2e1ffb7` is its base)
STANDS. The direction-hold was built, measured and reverted by its own numbers (`7d37a0c8`: worse on every column) - a
dead end, not an open lever. The residue is ACCEPTED as the contract's tolerance, in the contract's own terms:

- **3 of 64** release/return windows exceed the clip's own punch-level curvature (the red arm has **4**) + **3 reversals**
  (the red arm has 3) - all six are `return`s, and every one is inside the guard's approved geometry.
- `POP_ADDED` worst **81.3 mm** against the red arm's **118.4 mm** (`f2e1ffb7`: 4 -> 3 windows, 99.0 mm;
  `76df4f90`: 99.0 -> 81.3 mm).
- `POP_SLIP` worst 41.4 mm; `POP_JOIN` 357.7 mm is the TAKE's own wrist, untouched by the layer.
- The 5 mm/frame gate is unreachable by arithmetic (`S264` handover: a 328-614 mm hand-over at 5 mm/frame is 2.2-4.1 s of
  visible lag), and `GUARD_IK_SLEW_M` (40 mm) is the right instrument for a hand that legitimately moves 100+ mm/frame.

Re-opening this needs a NEW red measurement, not a re-read of the old arms: the arms above are the record.

### #4 DECIDED (Claude, S266) - SHIPS AS IS
`head_level` (`329d9d8e`, the TRANSLATION pass) ships as it is: head segment tip 104.6 -> 81.6 deg, head_follow_k
2.53 -> 2.43, and the neck skin was checked at the pass's full cap (`c82a2675`: no seam, no tearing, no pinch). The
stricter "hold the head level outright" variant is not required; `head_follow_k` is recorded as the wrong gate (it
conflates torso pitch with the clip's own head motion) and `head_max` is the honest number.

## Then, in order (each: build, a red-first measurement, game-camera proof, commit)
#2 FOOT PLANT (the biggest "not human" tell in your review): pinned ankles while planted, lift only during a step, knee on its bend
side. Owner files: FightLegIK.gd + the shuffle functions in FightStagePlayer.gd you named. Measure FIRST on master: planted-foot
world slip (reuse tools/probe_foot_lock.gd or the S258 planted_skate probe; S258 measured 13-15% skate after the single root
solver, FIGHTMOTION1). Gate: planted-foot slip <= 2 cm per plant, real lift/plant events, both feet on the canvas in every still.
Also the pelvis crouch per guard style (Ludo table: trad 4, high 6, peek 14, long 2, shell 5 cm) belongs here (needs planted legs).
#3 PUNCH MECHANICS: wind-up (hip/shoulder load), shoulder over, weight onto the lead foot, recovery to the guard target (the guard IK
weight already brings the hand back - measure it lands within 2 cm). Do not change PunchRetime timings (operator-approved clocks).
#4 HEAD: chin tucked and level through torso pitch (head uses the head-translated position with a torso-facing basis), small
counter-rotation, slips read as head movement not whole-body lean.
#5 SPACING / STEP-TO-RANGE: the engine floor (FIGHTGAP1: straight 0.95 / hook 0.70 m) landed but the room's drawn chest gap barely
moves (GAP_PROBE drawn 0.89 vs engine 0.86): trace FightWorldLiveScreen's placement (`_placed` / warp) and make distance change by
STEPS, not root glide. Coordinate with #2.
#6 CORRECTIVES: do NOT hand-tune helper bones. Plan: Claude samples Unreal 5.8 (MHPilot project) for the MetaHuman body helper
joints on an elbow/shoulder grid -> JSON table; Arena writes rules/CorrectiveRBF.gd (TASK_MHRBF1) to play it back. Your part when
both land: wire CorrectiveRBF into MetaHumanRig.gd (replacing the S261 guess in MetaHumanCorrective.gd) and prove it on close-ups
at elbow 90-140 deg + the game camera.

## Report after each item (in this chat)
What changed (files + functions), the red number before, the number after, the stills you took (paths) with the six lines each,
the commit hash on ziva/playtest. Then start the next item without waiting.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Contract
OWNS: Godot/scripts/FightStagePlayer.gd, Godot/scripts/FightWorldLiveScreen.gd, Godot/scripts/GameSwitches.gd
RED_TEST: Godot/tests/overlap_in_takes_test.gd -> PASS
REGRESSION: foot_repin_test, join_default_test, head_shift_test, guard_clip_ramp_test, punch_load_test
VISUAL: yes

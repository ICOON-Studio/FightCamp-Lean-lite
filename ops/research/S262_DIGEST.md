# S262 DIGEST - 2026-10-19 - guard IK on the game camera, Ziva is a full motion seat (Basic plan), correctives plan

## Shipped (all on master, pushed)
- 6ec4a379 Codex GUARDPOSE answer collected (CODEX_GUARDPOSE_S262.md): authored pose per style + constrained two-bone IK; the old
  passes translate the Hand bone (stretches the forearm); GuardPose.elbow_for lacks a clamped wrist + a non-degenerate pole.
- ab8e4cdd GUARD IK (operator S261 "doesn't look like an arm"): FightStagePlayer._guard_ik_pass, switch guard_ik (GAME_ON). Each wrist
  on its GuardPose target in the head frame; UpperArm then LowerArm swung (lengths kept); elbow aimed by GUARD_ELBOW_AIM per style +
  elbow_swivel_to_flare; per-arm weights (only the punching arm releases, 0.08 s out / 0.16 s back, quintic ease). Guard lift /
  elbow tuck / guard-hand clearance stand down when on. FightWorldLiveScreen feeds guard_style (GuardPose.style_for), guard_seed,
  guard_attr. Probe tools/guard_lift_still.gd gained style=, L/R_fwd_m, ik_w, ik_err_cm.
  Evidence (live camera, as_game): wrist miss < 0.001 cm; flare traditional 10.6/9.5, high 6.1/10.1, peek 6.1/6.0, long 14.7/10.2,
  shell 0.1/8.4 deg (clip arm was -60..+39); peek-a-boo gloves 0.20 m from the head (clip 0.26-0.40). First pole (inward) put the
  elbows across the chest (-60 deg) - fixed by the outward aim. Test tests/guard_ik_pass_test.gd GUARD_IK failures=0.
  Regression: guard_lift/human1/fight_stage_fatigue_switch/fight_stage_scurve_switch control arm 5/5 green; their as_game reds are
  IDENTICAL with guard_ik=0 (control-arm tests asserting game switches OFF - pre-existing, not this change).
- a77f28d9 guard BODY layer (_guard_body_pass, Ludo's per-style table): thoracic curl adds only what the clip is MISSING (added on top
  it folded peek-a-boo flat, nose to the canvas); caps from stills: curl +10 deg, neck untouched (MetaHuman head/body seam opened at
  8 deg), clavicle 2.5 cm (trapezius crease - helper joints undriven). Pelvis crouch left to the planted-foot legs.
- 5813febd Ziva FULL ACCESS (operator: "i want ziva to have full access to research and everything needed for the animation and
  training"): research/ZIVA_ACCESS.md map, AGENTS.md "## Ziva", user skill ~/.agents/skills/fightcamp-animation-training.
- Briefs: TASK_GUARDPOSE2 (Arena #274), TASK_MHRBF1 (Arena #275), TASK_ZIVAMOTION1 (Ziva), ASK_MHCORR_JOHN_S262 + ASK_LOOK_MARIA_S262
  (seat_queue SQ4/SQ5, the 30-min job sends them).
- Review board: "Guard IK: 5 guard styles vs the clip's arm" + "Guard body layer" (previews/s262_guardik/) - operator OK pending.

## Ziva (new full seat)
- Its chat is a web app served by the editor sidecar: preview_start http://127.0.0.1:7012/ (side panel). Clip review saved:
  ZIVA_CLIPREVIEW_S262.md (decoded the mp4 with OpenCV; ranked 6 human-motion items: guard IK, foot plant, punch mechanics, head,
  spacing by steps, correctives). Operator: "build and prove #1-#4 now, then #5, #6" -> TASK_ZIVAMOTION1 (Ziva owns the motion
  layers in FightStagePlayer except _guard_body_pass/GUARD_BODY; Arena owns rules/GuardPose.gd).
- Operator set Auto-approve ON and upgraded Ziva to BASIC ($20/month: $20/week, $60/month usage, no message cap); model Ziva Smart.
- State at handover: Ziva (chat "Ziva Agent Access and Task Brief") is building a join-local transition probe in its worktree
  (tools/guard_lift_still.gd: style_a/style_b, hand orientation, per-frame wrist steps), NOTHING committed on ziva/playtest yet
  (branch at 5813febd). Collect its diff when it reports a commit.

## The operator's four causes (his question "is it rigging?") - the plan agreed ("go")
1. Clips retargeted from other skeletons -> guard IK now; base poses authored on the MetaHuman; punches re-authored per the jab bar.
2. Too many writers on the arm -> census + every layer becomes an IK target (Ziva #1/#2).
3. MetaHuman correctives undriven -> SAMPLE UE 5.8 (MHPilot) on a driver grid -> JSON table -> rules/CorrectiveRBF.gd (Arena #275) ->
   wire in MetaHumanRig (Ziva #6). John's ask gives the UE route.
4. The look (skin shader, hair cards, light) -> Maria's ask -> A/B stills -> operator picks.

## Lessons
- Ludo's pose numbers are measured FROM UPRIGHT - never add them on top of a clip's own lean.
- MetaHuman tells: neck bend opens the head/body seam; a big clavicle move creases the trapezius until helpers are driven.
- Ziva composer: insertText often does not stick and keystrokes are ignored while it is busy; click + type + the round send arrow.
  "Upgrade to keep building" = a step cap, send "continue".
- PowerShell 5.1 Get-Content/Set-Content on MEMORY.md mangled UTF-8 (fixed with Python) - edit memory with the Edit/Write tools only.

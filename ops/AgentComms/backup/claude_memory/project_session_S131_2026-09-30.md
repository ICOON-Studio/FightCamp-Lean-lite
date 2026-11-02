---
name: project-session-s131-2026-09-30
description: "S131 - SO1 off-line stance shipped (palette 19, exe 83/0); body/feet twist = street walk clips, fixed by shuffle-from-bell; stamina must drive the 70% (next stage); Harmony4D probe"
metadata:
  node_type: memory
  type: project
  originSessionId: 5812acc7-b375-4080-9320-a46dffa31a68
  modified: 2026-09-30T00:55:41.994Z
---

S131 (2026-09-30, 02:20-04:xx). Operator answered "Yes, offset" (SO1) and "Yes download" (QuickMagic pair).

- **SO1 shipped (f80e3d57):** FightWorldLiveScreen.STANCE_OFFSET_U 0.16 u (each man half toward his lead side,
  facing along the line), room switch `stance_offset`; C223 gates read it (`lateral=0` = old control); certificate
  rows must carry it (certified_palette_test). 14 singles + 3 defences + 6 chains re-certified 4/4; rear hooks certified
  with `lock_foot pin=ball` on the rear foot -> **palette 19**. Exe rebuilt + walked 83/0, 0 SCRIPT ERROR.
- **Operator's "body not aligned with the feet":** instrument tools/s131_twist_probe.gd (headless trap: `--script`
  never enters the tree - global_transform/get_bone_global_pose read identity; compose via skeleton_world/_pose_global).
  Cause = the RamsterZ WALK/STRAFE clips (60-80% of their frames twist >35 deg); the helper agent's "foot lock ignores
  yaw" theory measured WRONG (pivot step shipped OFF). Fix = `shuffle_from_bell` (C215 step-drag from the bell, min
  step 0.12 s): twist p95 110->42 / 76->58 deg. Before/after video D:/FightCamp/videos/S131_before_after_seed92012.mp4.
- **Operator: "make the stamina have impact on the moves and decision making, this will explain why the 70% exists"**
  - FightStamina has NO in-round recovery (hold drains 0.016/s); next stage = rest-seeking intent + in-round recovery +
  lighter shot choice when tired, tuned on G100 (75-85% low intensity), G99 CompuBox, BoxMAC shares; plus the orbit
  speed (~75-80 deg/s vs U123 p50 35) - engine balance: measure bands, ship if they hold, else ask.
- Operator asked "is it a money issue?" about engine balance changes - NO: it is calibration he signed off; say so plainly.
- Built for him: Tools/desktop_recorder.pyw (HOME key) - see [[reference_video_archive]].
- Research filed: Kolliopoulos 2004 boxer (turn by steps), AMP/RL recipe graded NO for demo/v1, Sidekick packs not
  bought (rlMotion needs iClone), BoxMAC WITHDRAWN, R_MULTIVIEW_FIGHT_DATA_S131 (Harmony4D = MIT, SMPL both people,
  MMA; SMPL model licence non-commercial; ETS elite boxing multi-view "coming soon").
- Harmony4D probe: operator said yes; test/15_mma4.zip (2.34 GB) -> D:/FightCamp/sources/harmony4d/.
- Defect fixed: Tools/c223_parallel.py wrote Infinity (Godot JSON rejects it -> whole certificate empty).
- My own slip: a python rewrite opened a report for writing before its helper existed and emptied it - regenerate.
- LATE S131: operator's before/after verdict "punches like bullets ... huge stepback": bullets PREDATE S131 (probe arms);
  root lunge capped (STRIKE_ROOT_MAX_MPS 2.5), hands smoothed in whole takes (67->56 pops); BUL1 open. Sent the video
  after checking ONE frame - watch the motion first next time ([[feedback_open_the_output_before_the_gate]]).
- Agents: Cursor U199 lobby (Sonnet 5) + Grok G148 office RUNNING; Codex (operator used its Full reset) C225 training
  floor (gpt-6-astra/high), Qwen Q218 staff room, Cursor U200 locker, Dola D66 strict review then D65, Kalli K47 film
  room - launch S132. AgentComms/AGENT_TOOLS.md = the tooling record. Consoles now HIDDEN ([[feedback_no_agent_windows]]).
  Concept art for every room in previews/concepts. Asked: lift the 2-shell-agent rule? renew SuperGrok?
- Last commits: abe33faf (game code), 2799dcde + 02f88418 (handover). Exe walked at f80e3d57 (before abe33faf).

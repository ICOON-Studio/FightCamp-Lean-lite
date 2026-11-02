# S261 DIGEST - 2026-10-19 - profile 11 attributes, shouts wired, ring lit, elbow fixed partway, FIGHTGAP1 engine, RAM tools

## Shipped (all on master, pushed)
- 29cb317b PROFILEHDR collected (hero STRESS row no longer over the ring captions); b1dc4f70 captions test signs a boxer in the game arm.
- 0974a2a3 ATTRIBUI1 collected (Cursor #272): Ludo's 11 attributes on the profile, 3 groups, chin lock + born gap, 5-axis radar.
  8281480c: rows under 24 px are COMPACT in UIKit.attribute_row (the 24 px floor had CHIN clipped and chips stacked) - seen on the
  game's render, not by a test. Still on the review board.
- 0c9ba78d SHOUTCAL1 collected (Arena #268): r117 shout levers reach the engine (pace, family mix, head bias, counter-risk).
  Balance batch NOT collected: on current master shouting 0.530 vs control 0.500 (verdict wanted 60-65%); 100-bout noise ~+-0.05.
- 16914e57 guard height from the guard attribute (guard_lift_m; 25 -> -7.5 cm, 85 -> +9 cm). Operator then rejected the arm itself.
- 27453283 RING LIGHT (operator: "you put black people in the dark"): VenueRig.add_ring_fills (4 truss spots, 45 deg) in every venue and
  the default/Marpa hall; skin luminance 32-44 -> 68-70 / 255 on the same frame.
- ab71e416 ELBOW: elbow_tuck (lead flare 34-39 -> 9-12 deg) + MetaHumanCorrective (Blender read: MetaHumans have NO corrective shape
  keys - UE drives helper bones lowerarm_correctiveRoot/bck/fwd/in/out; we had folded their skin into the forearm). 38a9aec0 rear
  glove kept 0.24 m from the head mid-jab (was 0.19).
- 7843bd3b FIGHTGAP1 engine (Arena's branch finished on the PC; its sandbox push hangs): floor per punch in flight 0.95/0.70/0.85 m.
  Chest-to-chest 19,385 -> 0 ticks; exchange 0.80 -> 0.99 m. NOT visible yet: the live room's drawn distance barely moves (0.90 -> 0.88).
- 1d7904ab + c8610a7a RAM: Tools/ram_trim.ps1 (EmptyWorkingSet + low memory priority on background apps; 1.9 -> 8.9 GB free, RED ->
  GREEN), heat_governor trims before suspending, task "FightCamp RAM Trim" at every logon. Heat governor had been DEAD since 04:11
  (logon-only trigger) - board_reconcile now restarts it.
- 189ae649 cloud-tests concurrency cancel (Actions minutes; 2,521 min in the first enterprise day).

## Lessons
- The operator's verdict on the guard: stop patching the clip's arm. Next stage builds the guard with IK from GuardPose.gd numbers
  (styles x per-boxer variation) - the module is in, not wired (roadmap now).
- Undisputed humanoid clips decode with UnityPy (m_MuscleClip streamed/dense/constant, attribute-42 = muscle index); good for
  comparisons, not exact angles without Unity's humanoid solver.
- Skeleton modifier poses are restored after skinning - a probe reading get_bone_pose after the frame sees 0; prove a modifier with an
  exaggerated value on a still.
- A still of a new feature on the game camera beats every number: FIGHTGAP1 passed its engine test and still looked unchanged.
- Ludo project page: the first input[type=file] is the PROJECT COVER dropzone - an upload there replaced the FightCamp cover (restored
  with a gym overview). Upload pictures on app.ludo.ai/assistant via "Add attachment".
- as_game reds that are pre-existing on master (cloud-proved): punch_retime_test, mh2_bodies_test.

## Open for the operator (review board S261)
Guard height, ring lighting, elbow correctives + tuck, rear-glove clearance, profile 11 attributes. Parked earlier: rating = mean of 10
attributes, SUB -> DQ wording (Ludo LUDO_ATTRIBUI_S260 s7). Grok subscription: his call (SuperGrok chat 4% used this week).

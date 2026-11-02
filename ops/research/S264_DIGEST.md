# S264 DIGEST - 2026-10-19 - Arena clones a code-only mirror, silent playtests, exact correctives + two glove defects fixed

## Shipped (all on master, pushed)
- 57ce016e ARENA CLONE FAILURES ENDED (operator: "this is happening every session , find a way this cannot happen again").
  Cause: ICOON-Studio/FightCamp is 6.7 GB (master tree 3.7 GB: Godot/docs previews 1.8 GB, research _captures 664 MB, models);
  Arena's sandbox clones it whole per chat and timed out ("git clone failed: Cloning into '/home/user/FightCamp'...").
  Tools/lite_mirror.py keeps ICOON-Studio/FightCamp-lite (private) = master minus binaries/videos/baked anims/AssetLibrary/LFS
  (10,196 files, 89 MB, clone 13 s); `push` before a launch, `relay` turns each lite PR into the same arena/* branch + PR on the
  main repo (plumbing only, no working tree touched) so CI/auto_collect/check_workflow are unchanged; a merged/closed main PR
  closes the lite one. Both run in the 30-min reconcile. Self-test lite#1 -> FightCamp#277 -> auto-closed. First real launch
  MHTWIST1 cloned first try. Operator allowed Claude to pick FightCamp-lite in Arena's repo selector ("You may click Arena's
  repo selector yourself"). Windows trap: text-mode subprocess stdin writes \r\n - plumbing gets bytes and -z.
- 82ebc154 NO PLAYTEST SOUNDS (operator: "i do not want to hear the sounds from playtesting"): games an agent's editor starts
  (Ziva playtest/run_scene) ignore the editor's --audio-driver Dummy. Godot/override.cfg (Dummy) in every agent worktree, written by
  seed_godot_cache.ps1; gitignored, never shipped.
- eec39fb0 MHRBF2 collected (Arena #276 by diff): CorrectiveRBF exact RigLogic mode (interpolative A^-1, UE kernels, normalise then
  threshold). Arena could not run Godot; verified here: green, master red, mutants 35/106 red, mh_dna_correctives rest bound 2 mm.
  One test fix - MY brief's check 3 contradicted its own threshold step (sum 0.9990 at 15 points is the cut working). Stills
  before|after (docs/previews/s264_mhrbf2): shoulders/elbows only, no tearing.
- d3bf2dff Ziva ZIVAMOTION1 #1 collected by diff: guard IK hand-off slew cap + join hold, release pop 205 -> 42 mm (5 mm gate NOT
  met: the take's own catch->jab join teleports the hand 282 mm - Ziva's next #1 round).
- 501300fe CRUSHED GLOVE (operator markups C113 + C115-117 mark 1): red's rear wrist bent 65 deg and rolled 90 deg at the joint
  (the IK kept the clip's world hand while re-aiming the forearm). FightStagePlayer.cap_wrist: bend 50 / roll 35; blue (C114
  "blue guy looks perfect") unchanged. guard_wrist_cap_test.
- 955920b1 GLOVE IN THE FACE (C116/C117 mark 2, "glove goes inside head?"): blue's peekaboo rear glove 3.5 cm inside his own face
  (mesh-fitted glove volume vs his head surface). GuardPose: face-height wrists >= 0.22 m forward of the head bone (Ludo
  0.21-0.23). All IK-held gloves clear. guard_face_clear_test; guard_pose_test's frozen reference got the same deliberate floor.
  guard_lift_still.gd now prints <Hand>_in_own_head_cm and L/R wrist bend/roll. Operator on the after-stills: "now this looks good".
- 1779fb1e/0e5e6e0e TASK_NIGHTLY10 (13 newly red in the first cloud nightly) -> Cursor issue #278 (Grok Bot app timed out).
- 2aea7a6e TASK_MHTWIST1: RigLogic twist/swing layer ported from TwistSwingJointsEvaluator.h -> Arena on FightCamp-lite.
- Q-S256-2 (look A-D): operator asked it removed; Claude first misrecorded "look A", corrected e1b7f1b0 -> WITHDRAWN, no look
  picked (operator: "no i didn't careful now do not fuck on the board"). The look sheet still shows the old crushed glove.

## Nightly (2026-10-19 cloud, 943/17 vs 10-17 885/16)
13 NEW red: OFF-arm pins moved (composure_live, doctor_live, pad_chain_fight, fight_strike_whole, human2),
switch_gate_hold_pair_geometry, q226_strands, rig_convention_contract (RamsterZ LFS?), mixamo_s215 (121 vs 115 rows - the main
checkout has an uncommitted catalogue edit), hangs fight_strike_speed/first_corner/fight_grapple_seam/fight_room_positions.
11 FIXED (decision_pacing, fight_identity, fight_realtime, ...). Cursor NIGHTLY10 #278 bisects each.

## Agents
- Arena MHTWIST1 running (chat 01a154bb..., branch arena/01732edb-fightcamp-lite) - its PR lands on FightCamp-lite, relayed here.
- Cursor NIGHTLY10 (#278) + PREVIEWLOOK1 round 3 (#260; covers C109/C112 "looks terrible" on the Techniques preview) running.
- Ziva: old chat ran out of context; new chat "Continuation of Guard IK Bypass and Tests" (Ziva Smart, MAX) continues #2 foot plant
  (commits 5168d9e2 census, 36771735 pin holds; WIP release radius + stance_unplant_test), then #1 join at the source, #3-#5.

## Open defects seen
- Red's LEAD glove 2.8-4.8 cm inside his own head during the jab chamber (clip-driven, IK released) - the jab clip itself.
- Contact frame: bodies chest to chest in the room (FIGHTGAP1 room side; engine side done S261) - Ziva owns FightStagePlayer now.

## HANDOFF
Working commit: e1b7f1b0 (+ this digest). Evidence: guard tests green (GUARD_WRIST_CAP/GUARD_FACE_CLEAR/GUARD_POSE/GUARD_IK/
GUARD_SLEW =0), CORRECTIVE_RBF_UE=0, stills docs/previews/s264_wrist + s264_mhrbf2, lite self-test #277.
Next (S265): collect what lands (Arena MHTWIST1 via the relay, Cursor #278 per-test PRs by diff, Cursor #260 r3, Ziva commits by
diff); then re-render the A-D look sheet with the fixed gloves and re-ask the look ONLY if the operator says so; red's lead glove
in the jab chamber; FIGHTGAP1 room spacing after Ziva's #2.

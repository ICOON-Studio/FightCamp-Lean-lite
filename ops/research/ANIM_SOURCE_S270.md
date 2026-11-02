# ANIM_SOURCE_S270 - the punches look bad: why, and a real boxing source (decision for the operator)

Operator S270, on the new /animations orbit previews: "omg all animiations are so shit the elbow is fuck up everything is bad".

## What I checked (primary sources)
- The previews now play each move the GAME's way (FightStagePlayer.play_role + advance, guard IK and every switch on) on the
  MetaHuman boxer: previews/anim/*.mp4 (45 moves, commit 8662948d). Claude's own read of the mid-move sheets: the
  punching arm flares out to the side instead of driving straight from the chin (jab, cross, check hook); knees bow out in wide
  stances (cross body, shovel hook, slip); the six-punch combo folds forward with a glove at the knee.
- The record agrees: ANIMSOURCE1D_CHAIN_DIGEST.md (S222) - all 22 palette clips RED on facing and wrist/roll, 6 also on spacing.
- The agreed fix route ANIMSOURCE1 (native MetaHuman boxing clips authored in Cascadeur, no retarget) stalled when Codex was
  taken off tasks (S228); its worktree holds unmerged WIP. Cascadeur Pro ends 2026-10-27.
- The sources we own are not boxing: the H2H pack (retargeted from the UE4 rig - the flaring), Mixamo, and ActionForge (its
  jab flares too, its cross barely leaves the face, its "hook" is a melee lunge - rendered for comparison in
  previews/anim_compare/af_*.mp4).
- What DID play cleanly: a clip authored on the UE5 skeleton plays on the MetaHuman one-to-one (S246) - no re-aiming.

## Boxing motion-capture packs on Fab (read 2026-10-20 in the operator's Chrome; prices = cheapest licence)
| Pack | Seller | From | What | Skeleton (from the listing) |
|---|---|---|---|---|
| Boxing Animation Pack | animo-mocap | EUR 68.96 (4.0, 4 reviews) | 67 mocap clips: guards incl. Philly shell, head movement, feints, footwork drills, walks, punches | listing text says "humanoid / Mecanim" - UE skeleton to confirm before buying |
| Boxing Collection | animo-mocap | EUR 116.71 | the full animo boxing set | to confirm |
| Punch Pro - MoCap Pack | MoCap Online | EUR 42.43 (4.0, 3 reviews) | 145 standing-punch clips: jabs, hooks, blocks, dodges, hit reactions; UE project + FBX | older pack, UE4 skeleton (needs UE4->UE5 retarget - the route that flared ours) |
| Combat Animations Pack #01 | XM3 Studios | EUR 30.76 | 20 Vicon 60 fps clips: jabs, hooks, uppercuts, high/low punches, KICKS | UE5 Manny, MetaHuman-compatible (plays one-to-one) - but general combat, few boxing moves |
| Fighting Animations - Boxing | PAKPROD | EUR 26.51 (4.4, 7 reviews) | boxing set | not read yet |
Licence: Fab Standard Licence (commercial use in a shipped game).

## Claude's recommendation
Your ruling D10 kept clip purchases off "until our playback matches the vendor reels". That condition is now met: the orbit
renderer shows exactly what the game plays, so a bought clip can be judged honestly against its own reel. Buy ONE boxing pack
on (or cleanly convertible to) the UE5 skeleton - you pick it by watching the sellers' preview reels on Fab - then I render its
jab / cross / hook / guard through the game pipeline in the same studio, side by side with the current clips and real footage.
Only if it holds up does the fight switch to it. Cascadeur (7 days left) is kept for fixing single moves, not for authoring 40.

## Operator board comment (Q-S264-7) and the test it asked for
Operator: "we have tripo3d and ludo3d they can rig why you do not use those ? should we spent money ?"
- Rigging is not the gap: the MetaHuman boxers are rigged. The gap is boxing MOTION.
- Ludo text-to-motion tested S270 (`ludo model animate`, mh_boxer_01.glb, rot_only, 4 variants, 0.5 credits, job f32047f2):
  prompt "orthodox boxer throws a fast lead jab from a high guard, the lead arm drives straight forward from the chin to full
  extension, then snaps back to guard". All 4 takes FAIL: take 1 "Fast Jab" (motion 1.6) - operator: "thats not a jab he is waving
  to the crowd"; takes 3 "Straight Jab" (motion 6.3, fit_rmse 1.19) and 4 "High Guard Jab" (motion 6.1) - Claude read their
  previews: both start in a T-pose and raise both arms overhead (a celebration), no jab. Preview mp4s stay on Ludo's storage
  (operator: "i want to see them on the ludo site, do not pull them" - nothing imported). No further prompts spent.
- Tripo3D: rigging + generic presets (walk/run), no boxing motion.
- So every owned/free source is tested and none is boxing: H2H, Mixamo, ActionForge, Ludo animate. Recommendation unchanged:
  one boxing mocap pack, judged through the orbit renderer against its own reel before the fight switches.

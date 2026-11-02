# S271 DIGEST - 2026-10-20 - Rokoko mocap plays the jab, cross and guard in the fight; why the old punches looked bad; Meshy on the MetaHuman

## Operator (verbatim)
- Board Q-S264-7 (already acted on in S270): "we have tripo3d and ludo3d they can rig why you do not use those ? should we spent money ?" -> no money; Ludo animate failed (S270).
- Review C121 (brow cut): "not perfect but it will do for now" -> accepted, left as is.
- "https://www.meshy.ai/animation-library/fighting/punching so why these are notworking ?"; "how these animations from meshy are different with rokokos ?"; "meshy has animations for kickboxing andkarate i think"
- "i want to undesrtand why the previous animations we were using were so shit please"
- "all 11 look perfect , how can we make more of those ?" (the Rokoko renders)

## Landed
- ace645e2 (branch s271/rokoko -> master after cloud) ROKOKO1 step 1. `FightClipRokoko.gd`: jab <- Boxing 2.10-2.77 s, cross <- Boxing 9.87-10.54 s
  (each padded to the native 0.667 s strike clock), guard <- FightingIdle 40.867-42.867 s (the window whose end matches its start:
  seam 2.8 deg; the whole take 68 deg). Built by MixamoMotion on the boxer's skeleton, cut by FightClipSlice, TURNED about the hips
  (jab +34.8, cross +32.5, guard +2.7 deg: the raw take's punches travel 32-35 deg off +Z, the actor faced elsewhere - measured by
  tools/rokoko_window_probe.gd). Rides FightStagePlayer's native path (strike warp, root hold, skin-floor plant); switch
  `rokoko_clips` in GAME_ON. tests/rokoko_clips_test.gd PASS `-- as_game`: aim 2.4 / 1.9 deg as played, clock 0.670 s, loop seam
  OK; red on master (the switch routes nothing there). native_mh_clips_test pins rokoko_clips off (it owns the native path).
- Same commit: MixamoMotion maps Meshy's rig (spine numbered from the top, lower-case neck - S130 MESHY_MAP); 15 Meshy library
  clips (S130 Higgsfield download, E:/FightCamp_backup_D/sources/meshy) in assets/anim/meshy_lib + LICENCE.md; anim_orbit_render
  `ms_<clip>` roles. mixamo_s215_catalogue.json (121 rows) committed - the NIGHTLY11C REAL red (bakes were tracked, the json was not).
- b81ac584 (branch collect/nightly11) Cursor NIGHTLY11/11B/11C test-side fixes collected: LFS-pointer skips on CI, cloud-only
  trims (PC keeps every arm), camp_pays 10 seeds, clip_slice cap on played time, dual PC/cloud pins. Tightened: missing file is
  not an LFS pointer; hold_pair cloud witness 0.15 -> 0.02. REFUSED: the fight_stage_realism hunk that stopped counting gated FAILs.

## Why the old punches looked bad (measured this session, answer to the operator)
- The shipped native jab is STRAIGHT in the file and as played: elbow 170 / 163 deg, aim 1-2 deg, 1-2 cm flare. Joint angles are not
  the defect. The native cross aims 22 deg off the line.
- The difference is the body: in the Rokoko jab the hips swing -25 -> +23 deg inside 0.67 s (the punch comes from the legs and
  hips); the hand-authored native clips keep the hips held and move the arm (hold_root). Every earlier source was not boxing
  (H2H retargeted from UE4 - the flaring, Mixamo generic, ActionForge melee, Ludo animate = waving) - ANIM_SOURCE_S270.md.

## Meshy (answer to the operator)
- We own 45 Meshy library clips since S130 (hooks, uppercuts, 6 combos, blocks, dodges, reactions, knockdowns + 9 kicks/knee/elbow/
  sweeps for the MMA update). S130 judged them on the OLD MPFB body under the old root lock (the rear hook steps in 77 cm); S221 the
  operator set Meshy aside. Now rendered on the MetaHuman (15 boxing clips, 8787/review "Meshy library clips on our MetaHuman").
  Kicks wait (boxing demo only).

## More Rokoko-like mocap
- John brief JOHN_MOCAP_MORE_S271_BRIEF.md queued (seat_queue SQ6): free captured boxing mocap with a commercial licence, video ->
  mocap free tiers (Rokoko Vision etc.), a filming recipe for our own boxer. CMU (commercial OK, no resale) already in clips_sources.md.

## Next (S272)
1. Operator watches the 3 game-path renders (boxing_jab/boxing_cross/guard_idle.mp4, review board) - deep crouch is the actor's.
2. Visual gate on the fight camera: record_room as_game stills via still_framing (guard AND mid-jab), visual-gate skill.
3. Hooks/uppercuts: second detector in tools/rokoko_punch_finder.gd, or Meshy hooks/uppercuts if the operator picks them.
4. John's answer -> more captured boxing motion.

## Later in S271
- Operator: "guard_idle.mp4 lmao this has the neck bouncing" -> 2f3361ee. Measured: the Rokoko take moves the head 0.2 cm over the
  hips; as played 5.2 cm. Cause: FightAliveStance.continuous_sample (switch alive_breath) - a 2.4 Hz bob that TRANSLATES the head
  bone +-1.8 cm, a nod, hips sway and spine breath, built for the old static guard; moving the head bone alone stretches the neck.
  It now fades out (its own 0.15 s quintic) on a mocap clip; played 0.4 cm. Gated in rokoko_clips_test (<= 1.5 cm); plain + as_game PASS.
- Operator on rk_ShadowBoxing@23.07-23.37: "this one cuts too early ?" -> yes (tools/rokoko_return_probe.gd): full reach at
  23.45 s, back in guard 24.35 s - the window ended before the punch. Recut 23.25-24.15 (review page video swapped). The other 9
  cuts and the game's jab (back at 2.55) / cross (10.45) return to guard inside their windows.
- 89bbcb42: the 6 Cursor nightly fixes the cloud proved (run 3f40bf): grapple_seam, room_positions, strike_speed, first_corner,
  q226_strands, rig_convention. Not taken: camp_pays (10 seeds timed out), hold_pair_geometry (timeout), clip_slice (rc=1, red on
  master too) -> next Cursor round. collect/nightly11 branch stays for reference.
- Operator: "there are powerful generators that can generate the clips like rokoko , also meshy clips are not bad we can use them"
  -> Meshy hooks/uppercuts are S272's first build (roadmap now); generators -> John SQ7 (JOHN_MOTIONGEN_S271_BRIEF.md).

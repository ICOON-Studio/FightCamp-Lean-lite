# S207 digest (2026-10-12) - MetaHumans only, animation from the paid tools, board cleaned, 6 merges, 5 operator rulings

## Operator rulings this session (verbatim - binding)
- "delegate heavy token work. there is not task shown Up NEXT,IN ORDER on opsboard" - board plan.next/working_now are OBJECTS now.
- "i do not want to see mbfb model anywhere again" / "remove all stills and videos with mpfb bodies fromopsboard , only upload
  metahuman videos and stills same with the gym remove the old pictures" - MetaHumans are the ONLY bodies (board, stills, game).
- "why the animations are basically no animation but a scrable of hands" / "why the fuck you donot use the fucking tools i pay to
  make them ?" / "focus on animation" - source motion authored in Cascadeur (paid) on the MetaHuman skeleton; no more corrective layers.
- "cascadeur expires on Oct 27 we must have finished all jobs involving it" - hard deadline 2026-10-27.
- "stop making fat people , redo all the staf and make way more of them we need variety" - MH4 cast, fit bodies only.
- "assign someone to work on different types of clothes ... the coaches need to wear forms etc everyone needs to look different" - WARDROBE1.
- "switch on everyhting that is switched off and prepare next session" - SWITCHALL1 is next session's first task.
- "if you need a browser and chrome isnot running you can use brave".
- Board: Q-S206-3 "Approve all three" (Ludo r42 reception / stress / profile), Q-S206-4 OK then rejected on video ("this is so terrible"),
  Q-S206-5 pagefile on E: added, Q-S206-6 "download quaternius, skip the $17 pack", Q-S206-1 = his free props are the S206 gym_pack.

## What now works (evidence opened by Claude)
- Ops board "Up next" shows rows again (roadmap.html accepts strings; plan items written as objects) - 7581f8c8.
- Board shows MetaHuman media only: AgentComms/review_filter.json allowlist + deny words; 44 pre-S207 batches moved to
  E:/FightCamp/review_archive_S207 (not deleted). /api/media verified. MetaHuman lineup posted (mh_lineup_s207, Godot/tools/mh_lineup.gd).
- Watchdog catches commit-memory exhaustion (AMBER < 8 GB, RED < 4 GB) - the cause of two Godot crashes ("mem is null").
- Merged: WEEKGRID1B (WEEK PLAN button -> Tue-Sat grid, 13/0), ANIMUPPERCUT1 (switch OFF, REJECTED on video - never certify),
  ANIMBALANCE1A (BodyBalance pure 72/0), BROADCASTCUT1A (pure 42/0), BROADCASTCUT1B (broadcast_autocut OFF, 38/0 + 11/0),
  profile stage camera from the rig's facing (front 3/4).
- Ludo round 42 (5 replies, 26-36k chars each, ceiling 35.5k) + verdict LUDO_ROUND42_VERDICT_S207.md, approved (Q-S206-3).
- Research collected: J_STRESS_S206, K_STRESS_S206, M_STYLE_SHEET_S206. Quaternius UAL Standard (CC0) at
  E:/FightCamp/downloads/quaternius_ual. Reception counter (Sketchfab saqib24, CC BY) in assets/models/props/reception.

## Open defects (first things next session)
1. The game still mounts MPFB bodies in fights (skin "generator" default) - METAHUMAN1. ProfileStage MetaHuman edit saved as
   METAHUMAN1_profile_stage.patch: 11/198 red in profile_stage_test (MH have no boxing boots; 4 boxer bodies -> two athletes collide).
2. Animations scramble the hands: stacked corrective layers on retargeted, warped clips (ANIMSOURCE1). The C224 gate measured
   distance/angle, not the punch path - the new move_shape_probe (ANIMSOURCE1A) checks shape.
3. Stopped by Claude (checkpoints pushed, not merged): REALISM1 (8aab50c7), ANIMBALANCE1B (C225 instrument a2f63e4b).

## Decided (Claude, developer)
- No new procedural animation layers until the Cascadeur source clips land; every motion check measures SHAPE (forearm angle, fist
  path, elbow under wrist, foot slip, hand jumps), and Claude opens frame strips before anything reaches the operator.
- Order for "no MPFB": switch the game to MetaHumans first, then archive MPFB/Tripo files out of the game folder, then retire their tests.
- Reception desk: downloaded, not built (operator). Profile "not our model" = the stage loaded a Tripo body.

## In flight at handover
Codex ANIMSOURCE1A (sol, wt E:/FightCamp/wt/ANIMSOURCE1, Cascadeur on a hidden desktop, deadline 2026-10-27), Codex MH4 (sol, wt
E:/FightCamp/wt/MH4, fit varied MetaHuman cast), Cursor RECEPTIONDESK1 (wt E:/FightCamp/wt/RECEPTIONDESK1), Arena TECHSEED1B (new chat
01a12d0b), Qwen cloud STRESS1A (issue #126), Maria M_ICONS + M_WARDROBE, John J_CLOTHES (gbot threads).

## HANDOFF
Next action = roadmap now.next_action (S207). Last working code commit: the BROADCASTCUT1B merge on master.

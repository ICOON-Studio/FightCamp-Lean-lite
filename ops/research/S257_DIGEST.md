# S257 DIGEST (2026-10-19) - the fight's motion measured (feet skate 25% of frames), FIGHTMOTION1 briefed, WEIGHSCALE1 + CampMetersFeed in

## Operator input (quoted)
- "I thought you found the problem with animations . The 3d fight looks terrible torso twists weird legs fly not walk , can ziva che
  this and try to fix ?"
- "Free up memory close chrome" (watchdog RED on RAM 95-96%: the 6.7 GB browser was Brave; it closed).
- "there is another session running check wtf is going on" -> a second S257 desktop session (local_7e058cff, started 00:59) was
  working the queue in parallel; it committed WEIGHSCALE1 only and stopped. "end that session?" -> archived.
- No new board questions or review comments at start; nightly unchanged since 2026-10-17 (not re-reported).

## What now works (evidence)
- Godot/tools/fight_motion_probe.gd (d33e796c): the live boxing fight (FightWorldLive, as_game) per frame on both men - support-foot
  skate, root speed bands, hips height, feet spread, chest gap, rest-relative chest twist, per-clip table, the ENGINE's own positions
  (`_shown`) and every room root writer's move through `debug_stage_observer`. 40 s seed 95501 numbers in TASK_FIGHTMOTION1.md.
- Second session (same stage id): WEIGHSCALE1 collected 21d54f71 (Cursor #266 + platform/sole/crop fixes; weigh_scale_test green;
  visual gate OPEN - its last still predates the crop), CampMetersFeed b69c5690 (CI green #269), Cursor GOALSTRIP1 #270 launched,
  Ludo r120 asked (counter window slice 2: crit/rocked mapping) - reply not read yet.

## What the probe found (the operator's defect, in numbers)
- Support foot skates 24-26% of frames (cross 44/67, hooks ~60%); drawn root > 4 m/s on 8-9 frames (settled cap: 3 cm/frame).
- With the ENGINE still (both men 0 m/s, gap 0.557 m) the drawn gap swings 0.61 <-> 0.83 m frame to frame: the placement pass
  gives back the overlap separation the overlap pass bought the same frame (FightWorldLiveScreen ~4018 vs ~4315).
- contact_stop moves the pair 0.16-0.20 m in one frame. 40 s totals: placement 76.5 m, placement_cap 30.3, overlap 23.1.
- Chest twist vs pelvis stays < 50 deg except in slips (max 59): the "weird twist" is the slip dropping (hips 0.56) + the skate.
- The engine holds the pair at 0.557 m centre-to-centre in exchanges = FIGHTGAP1.

## Decided (developer calls, CLAUDE.md s2)
- One more patch on one pass is refused: a separation-release hold (trial, reverted) made it worse (placement_cap 30 -> 83 m,
  root > 4 m/s 8 -> 17). The fix is ONE root writer per frame (TASK_FIGHTMOTION1.md), a fresh Opus session, probe numbers as gate.
- Ziva: its MCP gives editor tools (run_scene, screenshots, files) but no line to Ziva's own agent; the probe measures more than a
  run_scene screenshot can, so the measurement ran through godot_hidden. Ziva stays the playtest seat for the after-video.
- SHOUTCAL1 #268 read (engine wiring sound, test left in a diagnostic CI-hang state, batch test dropped) - queued, not collected.

## HANDOFF
- Working commit: d33e796c (master, pushed).
- Remaining: FIGHTMOTION1 (one root solver), then SHOUTCAL1 #268, #260 PREVIEWLOOK1 (boot soles 0.65 m above the floor), WEIGHSCALE1
  still, GOALSTRIP1 #270, Ludo r120 reply, FIGHTGAP1 after FIGHTMOTION1.
- Exact next action: roadmap `now.next_action` (START (S258): FIGHTMOTION1 FIRST).

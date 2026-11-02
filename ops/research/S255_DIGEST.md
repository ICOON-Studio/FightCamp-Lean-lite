# S255 DIGEST (2026-10-18) - board answers acted on, punch timing live, both boxers no longer sit down, Ziva back

## Operator board answers (quoted)
- Q-S249-4 roadmap: "Approve". Q-S249-5 counter window: "Build it". Q-S249-6 weigh-in / cut + cutman / mitt pop: "All three".
- Q-S249-7 demo scope: "Yes to all" -> PLACEMENT1 PARKED (fixed equipment slots), promotions off-demo.
- Operator chat S255: "why is this not fixed?" (Ziva ECONNREFUSED) -> fixed + `start` now prints ZIVA UP/DOWN with the fix.

## What now works (evidence)
- PUNCH TIMING (Q-S249-4, Ludo r119): `scripts/rules/PunchTiming.gd` (Qwen #262, fixed on collect 335ed9d3: no floor on control
  return, retraction blend >= 0.14 s, playback-timeline clamps). Wired af5a68e3: `FightStagePlayer._whole_hold_s` feeds
  `whole_phases().recover` (-> FightRealtime `_whole_recover`, :5909) and `_whole_remaining`; switch `punch_control_early` in GAME_ON;
  hand strikes only, kicks/combos keep the whole take. Route traced (the S254 study was wrong: the lock was the take's full length,
  not recover_s). punch_control_early_test 18/18; live room (tools/punch_timing_still.gd seed 95501, game camera): mean hold per
  strike 1.222 s -> 0.576 s, jab 0.633 -> 0.367, body jab 1.8 -> 0.567; new chains slip->cross, catch->jab.
- BOTH BOXERS SAT DOWN (found on that gate, ON MASTER): HUMAN2 footwork did not carry plants on a late root placement (room puts the
  body at the engine spot, gait plants, root cap pulls back ~2 m, finish_hand_frame re-solved legs to the far plants). Fix 480806ba:
  a late move > SHUFFLE_PLACEMENT_JUMP_M carries the plants (small nudges still anchor), + a guard (no foot target > 0.9 m from root).
  Live min hips 0.31 -> 0.61 (master) / 0.27 -> 0.56 (new timing). footwork_placement_carry_test 9/9, mutant (no carry) red at
  hips 0.337. Bisect: human_footwork off -> no collapse; hit physics off -> no change.
- COUNTER WINDOW maths `rules/CounterWindow.gd` (Arena #263, d160c0c3). CAMP METERS maths `rules/CampMeters.gd` (Arena #261,
  f056c231) - composes GameplanReadiness/AreaWear/weight cut numbers; neither is wired yet.
- NIGHTLY1: 2026-10-18 nightly stopped after 25/918. Qwen NIGHTLYLABEL1 (`research/NIGHTLY_LABELS_S255.md`): of 16 reds (10-17), still
  red BOXING: camp_pays, decision_pacing (hang), fight_clip_slice, fight_pair_live, fight_stage_realism, switch_gate_hands_smooth;
  GYM: asset_manifest; OFF-DEMO park: fight_contact_stop (MMA kick), promotions_board; 6 passed in later logs.
- SHOUT BALANCE (Arena #264, held OPEN, not merged red): sharp corner wins 0.530 (sharp 0.520 / drilled 0.540) vs silent; control
  0.500. Verdict band 60-65% -> shouts are under-powered; partly because some called r117 shouts are intent-only in the engine.
- Research snippet G6_APPEND_UIKIT.gd -> .gd.txt (3 parse errors every editor load).

## Visual gate state (OPEN - operator closes)
Review board "Punch timing: old vs new, game camera (seed 95501)" (8787/review) + SendUserFile: side-by-side mp4 + 3 stills with the
six lines. Still open on every still: GAP - chests/heads touching and torsos overlapping (master too; fight_stage_realism R7 body
overlap 3.9% is the same defect family).

## Decided (developer calls)
- Punch timing reads the clip's own contact + Ludo offset; the body-contact retime (0.40/0.44/0.32 targets) waits for a playback
  speed-up to contact (PunchTiming.time_scale_to_contact exists, not wired).
- Footwork placement carry: keep HUMAN2's anchored support foot for nudges, carry on placements - the S132 rule restored, not a new one.
- A red measurement test is a finding, never merged red and never loosened: SHOUTBAL1 stays open until SHOUTCAL1.

## Runs in flight at handover
Cursor PREVIEWLOOK1 (issue #260, cloud), Arena MITTPOP1 (arena/84604b8f-fightcamp), Arena SHOUTBAL1 #264 (held for SHOUTCAL1).
Ziva editor running on the hidden desktop (wt/ZIVA synced to master).

## Next (roadmap now)
1. Collect #260 + MITTPOP1; stills of the Techniques preview and a fight (boots). 2. Cursor WEIGHSCALE1 then CUTVISIBLE1 (briefs
ready). 3. Wire CampMeters into a goal strip (Cursor UI), CounterWindow into FightLink, MittPop into PadPair. 4. SHOUTCAL1: make
the intent-only shouts real levers / recalibrate CornerShouts into 60-65% with the #264 batch. 5. Gap/overlap defect (stills).

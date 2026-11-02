# S136 digest - the cross comes back up: no more head at the other man's chest after every cross (Claude, cloud, 2026-10-01)

Request (roadmap `now`, S135_DIGEST s6): (0) re-anchor tests/fight_pair_live_test.gd; then the residual clip poses, first
the cross's post-contact bob - if the head drops below the receiver's chest, fix it and re-certify the cross and every
chain holding it. Done for the cross. Item (0) closed on a primary source (section 4). No agent was launched. Code commit 252ff66b.
Read first: section 2 (what it looks like - taste), section 6 (next).

## 1. What now works (each with its evidence)
| What | Evidence | Where |
|---|---|---|
| The cross no longer falls into the punch after it lands: a Spine + Chest LEAN BACK solved by target holds the head at its contact level through the recovery | clip alone (production graft, 4 rigs): head after contact sinks 15.9 -> 3.1 cm, travels forward 10.3 -> 0.0 cm, sideways path +2.6 cm; trunk tilt max 42 -> ~30 deg | FightClipBinding `boxing_cross` pose_layer; tools/s136_cross_bob_solve.gd |
| In the room the thrower's head stays at or above the other man's chest | s134_pose_probe S136_HEAD (game switches ON, DEMO engine, 30 s): seed 92012 frames below the receiver's UpperChest 6 -> 0, worst -5.0 -> +0.8 cm; seed 94301 18 -> 6, worst -7.9 -> -2.4 cm (2 of the 6 are the contact frames, the punch's own level; the rest <= 1.3 cm). Cross trunk tilt p95 33 -> 22 deg both seeds | tools/s134_pose_probe.gd |
| The layer changes the trunk, not the clock (`contact_before_layer`): the contact and the chain cut are read off the take before its recovery layer | contact 0.300 s (S131's), chain cut 0.650 s; MUTANT without the flag: contact 0.400, cut 0.633 - the gate read the recovery as the strike (peak_fist_band 11.6-13.7 m/s, all 4 rigs) and liver_combo's lead toes slid 2.0 cm (1/4) | FightStagePlayer `_graft_retargeted` / `_derive_contacts` / `sequence_plan`; tests/fight_cross_recovery_test.gd |
| The cross re-certified 4/4, every single re-measured on today's bindings | s136_bound.json (68 rows, errors 0, 728 s): owned_cross strike peak 9.84/9.57/10.40/10.19 m/s (= S131), onset 250 ms, impact 0.300, G147 pass, 0 pin pops, min body gap 0.37-0.40 -> 0.43-0.47 m. No other row's failures changed; slip and cross_body equal S134b's own certificates (the palette list had not held them) | certified_moves.json certificates |
| All chains re-measured with the new cross | s136_chains.json (40 rows, errors 0): the 9 certified chains 4/4, slips = S135's (liver 1.44-1.53, six-punch <= 0.32); jab_body_head 0/4 as before (probe, not in the palette) | certified_moves.json certificates |
| Cloud C223 gates | Tools/c223_parallel.py finds /opt/godot/godot (GODOT_EXE first, as run_tests.py) and skips the PC-only watchdog/creation flags off Windows - one rig per process now runs in the cloud | Tools/c223_parallel.py |

The solve (what a person would key): the target is the HEAD - from contact on it must not sink below or travel forward of
its contact position, holding the clip's own sideways path. One local axis is not a pitch in a cross (the torso is turned
and unwinds through the recovery): local x alone threw the head 10.7 cm sideways, unbounded six axes found two opposite
~180 deg twists, one world axis 6.3 cm. Four hat windows (peaks 0.40/0.50/0.60/0.70 s), each a lean about the WORLD
lateral axis converted to the bone's local axis at its own peak, weight 0 at contact and at the clip's end.

## 2. What it looks like (taste - the operator judges)
- Videos (C223 fixture, welter_a v welter_b, 30 fps): docs/previews/anim/s136_boxing_cross.mp4,
  s136_boxing_six_punch_combo.mp4, s136_boxing_one_two.mp4. Before: s135_boxing_six_punch_combo.mp4 and the ops board's
  boxing_cross.mp4.
- Six-punch at 1.0 s and 4.3 s (the two crosses): S135 had the thrower's head down at the other man's chest; now he is
  upright, head level with the other man's head.
- Single cross: lands, stays upright 0.47-0.57 s, a short tuck behind the glove at ~0.67 s (the clip's own return,
  head 12.7 cm under guard = 2.7 cm under the punch level), guard by 0.80 s.

## 3. Rules this stage earned (also in roadmap handover traps)
- A pose layer that fixes only the RECOVERY moves the derived contact unless told not to: `_aim_contact_s` /
  `_reach_contact_s` read the whole take. Flag it `contact_before_layer` (or give it a strike_warp, which pins contact).
- The chain cut (`sequence_plan` half-return) is also derived from the take; a recovery layer re-times every chain that
  holds the move. Read it off the unlayered take too.
- bone_world FEET are not the drawn feet while a strike plays whole (seed 94301: 0.3-0.65 m above the hips, canvas in the
  recording). Measure height off the deck (`_live_deck_y`), and check an instrument against one recorded frame.
- A turned trunk: solve trunk leans about a WORLD axis converted per window, and bound each axis (a correction, not a
  re-pose); hold the clip's sideways head path in the cost.
- Re-certify a move into a NEW certificate that REPLACES the old one in certified_moves.json: the palette test is a
  union - an old passing row keeps proving a move after its binding changed.
- fight_pair_live_test is red by the operator's decision (PARKED 2026-09-15, roadmap handover); read last_suite.json
  before calling a red "new".

## 4. Item (0) - fight_pair_live_test: not an S133/S134 regression (primary sources)
- AgentComms/last_suite.json (nightly 2026-09-30T04:49Z, commit 089f6dd4): fight_pair_live_test.gd IS on the failed
  list. S135_DIGEST s4 said it was not - wrong.
- AgentComms/roadmap.json handover: "fight_pair_live_test - PARKED by the operator 2026-09-15. Red by decision. Close it
  by un-parking (operator's call) or by giving the runner an EXPECTED-RED list".
- tools/s136_jab_census.gd (the room's engine alone, 5 s a seed): seed 810039, switches OFF, 120 s - 33 actions, 0
  plain boxing_jab, 0 pair-qualifying beats at HEAD, at dd3a1964 (09-29) and at a0a0ac5b (09-28, the oldest commit in
  this clone); the old ring half-width (2.443, pre-RING1) also 0. Seeds 810040-810042 the same in the room scan
  (tools/s136_pair_seed_scan.gd). With the DEMO engine switches: 68 actions, still 0 pair-qualifying.
- So a seed re-anchor is not the fix and the test stays parked; un-parking is the operator's call. Not re-asked now
  (not on the demo road).

## 5. Tests (focused, cloud /opt/godot/godot)
- Parse gate on every touched .gd: CHECK fails=0.
- tests/fight_cross_recovery_test.gd (new, 2 rigs): TOTAL=18 fails=0 - RECOVERY 3.1 cm / 0.0 cm; CONTROL unlayered
  15.9 / 10.3 (reads worse); CLOCK contact 0.300, cut = unlayered; MUTANT (flag off) contact 0.400, cut 0.633.
- `run_tests.py --jobs 4 --only fight_cross_recovery,fight_stage_presenter,fight_clip,fight_strike_whole,combo,
  fight_body_layers,fight_alive_stance,boxing_idle,certified,fight_world_live,fight_stance_offset,beat_adapter,
  technique_catalogue`: **SUITE total=26 fails=1** - fight_strike_whole_test ("OFF boxing/mma events and verdict
  byte-identical to baseline"), on the 09-30 nightly red list and failing identically in S135. certified_palette_test
  green on the new certificates.
- s134_pose_probe hip row FIXED - hips over the ring deck (`_live_deck_y`). Against the body node it read standing hips
  0.02 m and flagged ~620/900 frames as crouches: every S134b/S135 "clips_extreme=14/15" was that noise. Over the feet it
  is wrong too: while a strike plays whole, bone_world put a rear-hooker's feet 0.3-0.65 m ABOVE his hips (seed 94301 f
  56-68) while the recorded frames (xvfb, record_room as_game) show them on the canvas. Valid row, final code: standing
  hips 0.90-0.94 m; seed 92012 extreme frames 0/900 both men; seed 94301 4/900 - all `boxing_cross` at contact (f 183-186),
  trunk 44 deg in the ROOM vs 22 deg for the clip alone: a room layer adds ~22 deg there.

## 6. Next (the decision)
S137 = the one pose extreme the valid probe still reads: on seed 94301 the ROOM tilts the cross's trunk to 44 deg at
contact (f 183-186; the clip alone 22) - find which room layer adds it (aim, contact stop, stance offset, hand_contact_sync:
toggle each with the probe's switch list) and fix it there; seed 92012 reads 0 extremes. S133's "lean-back reaction /
horizontal lunge / deep crouch" do not appear on the valid probe at seeds 92012 + 94301 (S134b's slip, reaction and
cross_body layers + this cross) - they stay closed unless the operator sees them in s136_boxing_six_punch_combo.mp4 or a
new recording. Then jab_body_head (a step before part 0). On the PC with the operator: build_playable + walk with palette
22 and the new cross; the operator watches the s136 videos (taste). RC2 stays held for the operator.

# S125 digest - G147 inside both C223 gates, the game's glove stop smoothed, boxing 9/36 (+5 held on the jab lunge) (Claude, 2026-09-29)

**S125 in one line:** the G147 clipping row and a pin-pop row now sit INSIDE both C223 gates (judged with the game's contact_stop
glove pin); the game's glove stop RELEASES over 50 ms instead of snapping; defensive pieces are never aimed or scored as landed;
boxing is **9/36 under G147** (from 1/36) with **5 more passing the numbers but held** on the RamsterZ jab's post-contact lunge.

Commits: 5e0279a5, 9fcea29b, f5a38b33, 368ea044, 24aa67f4, 6d9d6bae, 5fe95df1 (+ queue/prompt/roster commits). Nightly to cite:
2026-09-29 at 9b143308 - SUITE total=459 fails=20 (S124 re-run: 14 real; routed U198 / Q216b / KM2). No 09-30 run yet.

## C223 x G147 (the S125 road, steps 4-5 done)
- Q213 clips `pin=1` arm (the room's glove pin): exact boxing bindings 4/22 -> 15/22. Head events 77 -> 3; LEG 18.75 cm on the
  close-range moves is real overlap (certified at 0.70 m, inside the other man) -> Qwen Q217.
- G147 row + `g147_pin_pop` row in c223_production_gate and c223_sequence_gate (Q213 measure_frame/EventTracker, static
  `pin_gloves`, `unwind_to`). Three instrument faults found and fixed IN SESSION, each by a control:
  1. the gates never advance the receiver, so the pin's bends PILED UP on him (lenient row) -> `unwind_to` each frame (368ea044);
  2. advancing him instead (f5a38b33) broke target_line (targets are the pre-take pose) -> reverted to held + unwound;
  3. a part with no passing certificate row raised a SCRIPT ERROR that left Godot idle for 60-90 min ("hung" runs) -> named `_fail`.
- The pin itself popped: receiver guard glove (LeftHand + fingers) 412 m/s2 at frame 12 of the reference jab - a one-frame
  shove and snap back. GAME FIX (24aa67f4): FightStagePlayer `begin_contact_hold`/`end_contact_hold` - a separation push engages
  at once, RELEASES over PIN_RELEASE_TAU_S 0.05 s; last frame's hold is applied BEFORE the separation passes (applied after, it
  left 2.7 cm glove-in-head and an 8.4 cm forearm clip - measured, then reordered). Landing aims are never held.
- `DEFENSIVE_TAKES` / `is_defensive_take`: the room's landing aim and fight_contact_stop skip catch/slip/pull/pivot_out (the catch
  has a contact time for its counter, so it was scored as a punch 20 cm short; red before this session too - control in Q217 tree).

## Results (production gate `bound live_contact`, 4 generated legal pairs; s125_g147_bound.json + s125_g147_counters_a/b/c.json)
- PASS every row incl. G147 + pin pops: jab, cross, rear_uppercut, jab_body, body_hook, up_jab, overhand, cross_body; pieces
  slip, pull, catch; chains double_jab, slip_counter, pull_counter, counter_over_jab, catch_counter. one_two 3/4 (receiver
  guard-glove pin pop at FIRST contact, welter_b, 537 m/s2 - release smoothing does not cover engagement).
- STILLS (s125game_/s125side_ owned_jab, catch_counter): the RamsterZ jab lands clean at 0.317 s, then the upper body keeps
  travelling ~20 cm after impact (0.45-0.60 s) and the heads STACK from the game camera - the S124 objection is still visible,
  though the capsules stay ~25 cm apart. So the jab family is HELD: jab, up_jab, double_jab, one_two, catch_counter.
- **Boxing 9/36 under G147, not jab-based:** cross, rear_uppercut, jab_body, body_hook, overhand, cross_body, slip_counter,
  pull_counter, counter_over_jab. **+5 held** on the lunge. jab_body_head as a plain chain FAILS (one gap: jab 1.06 m vs body jab
  1.67 m) - it needs a step between the punches; binding restored.

## Tests (tier: scripts edited; full suite is the nightly)
fight_contact_stop 145/0 (was 146/1 on master too); fight_body_overlap TOTAL=2 fails=1 identical with and without S125 (U198's);
fight_reachability_contract honest red on the shipped men (below); parse gate on every touched file.

## Collected / decided
- KM2 (Kimi) REJECTED: it restated the test to pass (one MPFB female body twice = identical fighters; the neck base retired).
  Test fixed instead (5e0279a5): shipped MPFB men 1.78/1.88 m + blockers from the SAME body (C158 step 4 - it read the partner's
  capsules). Honest red: male neck 0/128 at 0.15 and 0.50, buried by the thorax cap -> KM3 (Qwen, after Q217).
- Kimi PARKED and out of rotation (operator: EUR 15 spent, "take him out of rotation").
- U198 (Cursor) SENT BACK: the 3 cm root cap runs after contact_stop's separation and undoes it (overlap 1.3 mm -> 15.1 cm,
  contact_stop red) and is per-frame, not per-second. Keep: no_teleport + ring_bounds PASS, pair_live finding (seed 810039 emits no
  head jab). Send-back AgentComms/prompts/U198b.txt.
- Q217 (Qwen, STANDING animation task): lead_uppercut certified on its branch with a Spine 25 / Hips 25 deg layer; re-certified on
  the merged gate (cba223a0) - stills owed and checked before merge (the brief's trap: men moved apart to pass).
- Q216b -> backlog (milestone wins). Tripo Pro CANCELLED (ends 10-26; 18 props in git + originals on D:). Qwen has the Higgsfield
  + Higgsfield-Blender MCP (operator signed in). Tools/grok_task.ps1 written (Claude/Cursor hook compat OFF by env). Ludo CLI: not
  needed now (needs Pro; clips are not the bottleneck).

## Next (S126)
1. Trim the RamsterZ jab's post-contact lunge (a layer solved by target: hips/spine hold the head at or behind its contact
   position after impact; prior_research first for a sourced number) -> re-certify jab, up_jab, double_jab, one_two, catch_counter
   with game + side stills (-> 14/36).
2. Engagement smoothing for guard-glove contacts (one_two's pop) inside G147's ARM allowance (3 cm / 3 f).
3. Collect Q217 (stills first) and U198 send-back; then check_hook, counter_combination, footwork, feint, drawing, 3+ part combos
   (the sequence gate is 2-part; the player is N-part since Q215).

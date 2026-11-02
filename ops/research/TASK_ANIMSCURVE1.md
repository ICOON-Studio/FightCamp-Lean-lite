# TASK ANIMSCURVE1 - punch S-curve time warp (benchmark STEP 6), behind switch `anim_scurve` (OFF)

Model: gpt-6.1-sol (Codex, animation). Keep fixing and re-running until the acceptance is green - there is NO two-run limit. Only if sol cannot finish the whole task does Claude re-run it on astra (operator S206).
Approved: operator board Q-S204-1 "build it all with your corrections" (Ludo r38 plan, verdict LUDO_ROUND38_VERDICT_S204.md).
Builds on ANIMBUS1 (merged a28521c7): `Godot/scripts/animation/IntentBus.gd` - make_intent / phase_at / in_contact_window.

## What the player should see
A punch that SNAPS: a slow coil (anticipation), an explosive drive into the target, a near-instant stop at contact, an
elastic pull back to guard. Today the clips play at an even rate. The contact frame itself must land exactly where the
certified clip lands it (C223), so the warp may move time everywhere EXCEPT at the contact point.

## Spec
1. NEW `Godot/scripts/animation/PunchSCurve.gd` (RefCounted, static, PURE - no load/preload/GameState/randomness):
   - `static func profile_for(clip_name: String) -> Dictionary` - Ludo r38 s2.1 table (LUDO_ROUND38_S204_reply1.txt lines
     194-215; sources Lenetsky 2013, Smith 2000, Whiting 1988 - name them in a comment): jab / cross / lead hook / rear
     uppercut / body hook map by substring of our clip ids (boxing_jab*, boxing_cross*, boxing_lead_hook / boxing_check_hook,
     *uppercut*, *body_hook* / *hook_body*); anything else -> {} (= no warp).
   - `static func warp(tau: float, intent: Dictionary) -> float` - monotonic piecewise cubic Hermite through
     (0,0), (anticipation_end_norm, a), (contact_point_norm, contact_point_norm), (retraction_end_norm, r), (1,1) with
     Fritsch-Carlson slopes (never negative, never overshoot). INVARIANT: warp(contact_point_norm) == contact_point_norm
     (to 1e-6) and the slope at contact is the curve's maximum (fastest just before impact). Anticipation is slowed
     (a < anticipation_end_norm), retraction is quick then settles. Invalid intent (IntentBus.is_valid false) -> tau unchanged.
   - `static func strike_phase(intent: Dictionary, clip_t_s: float) -> String` -> IntentBus.phase_at upper-cased,
     "NONE" when invalid (this is the benchmark column's value).
2. `Godot/scripts/FightStagePlayer.gd` (6,258 lines - NEVER read whole; windows: `sed -n 1,70p` switches + human_metrics,
   `sed -n 990,1035p` the existing S120 onset warp (_wall_to_onset_anim_pos / _onset_warp_advance), `sed -n 1412,1520p`
   play_role, `sed -n 2940,2970p` and `sed -n 3500,3545p` the two advance paths):
   - add `var anim_scurve: bool = false` beside human_hit_additive (line ~10) and expose it like the others.
   - when a STRIKE clip starts (play_role / the live strike path) and anim_scurve is on and profile_for(clip) is non-empty:
     build an intent with IntentBus.make_intent({exchange_id, clip_name}, clip_phases.json entry for that clip) and keep it.
   - in the advance path: when the intent is valid, the wall-clock fraction tau is mapped through PunchSCurve.warp and the
     clip is SEEKED to warp(tau)*length (same seek pattern as _onset_warp_advance). If the S120 onset warp is active for this
     take, the S-curve does NOT run (the onset warp already owns the timing) - say so in a comment.
   - `human_metrics()` gains `strike_phase` (String, "NONE" when off/invalid).
   - With anim_scurve OFF: every code path is byte-identical to today (no new seeks, no new allocations per frame).
3. `Godot/tools/record_room.gd` `_bench_side_metrics` (line ~540): the red `red_strike_phase` column reads
   `player.human_metrics().strike_phase` instead of the literal "NONE" (when the key is missing, still "NONE").
4. Switch wiring: a user arg `anim_scurve` and the bench1 path in record_room (line ~126, where eng_b["bench1"] is set)
   turn it on for the benchmark run; the game default stays OFF until the operator OKs a game-camera video.

## Acceptance (tier: script edited)
- NEW `Godot/tests/punch_scurve_test.gd` (extends SceneTree, `_initialize`, prints `PUNCH_SCURVE total=N fails=M`, quit(1) on
  fail): warp is monotonic over 1,000 samples for all 5 profiles AND for two real clip_phases.json entries (boxing_cross,
  boxing_body_hook - copy the numbers as literals); warp(contact)==contact to 1e-6; max slope sits in the 10% before contact;
  invalid intent -> identity; a MUTANT inline (the same curve with the contact knot moved +0.02) must fail the invariant check.
- NEW `Godot/tests/fight_stage_scurve_switch_test.gd`: two DIFFERENT fighters (two different body ids/stats - never identical,
  CLAUDE.md s5), one strike each: OFF -> the Skeleton pose of every bone at 30 sampled frames equals a run built without the
  feature (byte-identical); ON -> human_metrics().strike_phase passes ANTICIPATION -> ACCELERATION -> CONTACT -> RETRACTION in
  order and the clip position at the contact frame equals the certified contact_s (+-1 frame).
- Then `python Godot/tools/run_tests.py --jobs 2 --only scurve,intent_bus,fight_stage,bench1,certified` all green.
Parse first: `python Godot/tools/check_scripts.py <every touched .gd>` (a parse error hangs a headless test).
Run one test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd`
(never the _console exe). Claude runs the windowed benchmark (record_room bench1) and the game-camera stills at collection.

## Owned files
new Godot/scripts/animation/PunchSCurve.gd, new Godot/tests/punch_scurve_test.gd, new Godot/tests/fight_stage_scurve_switch_test.gd,
Godot/scripts/FightStagePlayer.gd (only: the switch var, the strike-start hook, the advance-path seek, human_metrics key),
Godot/tools/record_room.gd (only the red_strike_phase column + bench switch). Another Codex run (ANIMFATIGUE1) edits
FightStagePlayer's POSE/post-process path at the same time - stay out of it; keep your hunks small.

## Prior research
`python Tools/prior_research.py punch velocity s-curve warp onset`: LUDO_ROUND38_S204_reply1.txt s2 (profile table + Hermite
form + Ludo's PunchTimeWarpController draft - a STARTING spec, not code to paste: it compares normalised tau with a window in
seconds; use IntentBus instead), LUDO_ROUND38_VERDICT_S204.md (our rules above Ludo's), the S120 onset warp in FightStagePlayer
(warp 0.66 for boxing_body_hook - clip_phases.json `_note`), C223 certificates in assets/data/certified_moves.json.

## What would a human do?
An animator re-times a mocap punch with a time curve (Maya/MotionBuilder "time warp") pinned at the impact frame, so the hit
lands where it always did and only the feel around it changes.

## Prefab check
Godot has no built-in per-clip time warp curve; Animation.bezier tracks retime properties, not playback. Fritsch-Carlson
monotone cubic is ~40 lines - write it.

## The one trap
Never move root or feet inside the contact window (rule from the 32/32 certified-pair regression, U211). The warp only changes
WHEN a frame is shown, never the pose; seek with `update=false` exactly as _onset_warp_advance does, or AnimationPlayer fires
method tracks twice. Work in your worktree only; commit on your branch; never push master. No windows, no image viewers.

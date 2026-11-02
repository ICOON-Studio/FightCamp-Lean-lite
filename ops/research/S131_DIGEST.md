# S131 digest (2026-09-30, Claude) - boxers stand off-line (SO1), rear hooks certified, palette 19

Nightly cited at start: `AgentComms/nightly/latest.txt` 2026-09-29 at 9b143308, suite 459 / 20 fails (the 09-30 05:00 run had
not fired - session opened 02:20). HEAD at start d9231a49.

Operator answers (verbatim choices, 2026-09-30): SO1 "Yes, offset (Recommended)"; QuickMagic two-person "Yes download".

## 1. SO1 - the men stand off-line (what now works)
- `FightWorldLiveScreen.STANCE_OFFSET_U = 0.16` (~10 cm real): each man stands half of it toward his own lead side, facing
  still along the fight line - the other man sits in front of his rear hand. Room switch `stance_offset` =
  `demo_switches_on()` (game ON, `--script` OFF); boxing only; eases out (0.25 s) while a pair clip / grapple owns the
  bodies. Written where the room puts the men on the line: `_write_gap_positions`, `_placement_spots` (overlap
  prediction), the whole-strike residual return in `_place_whole_bodies`, and the walkout's end mark.
- The C223 gates read the SAME constant (`c223_production_gate._fixture_lateral()`, inherited by the sequence gate;
  `lateral=0` = the pre-S131 nose-to-nose control). Every row records `fixture_lateral_m`.
- `tests/certified_palette_test.gd`: a certificate row proves a move only if `fixture_lateral_m` == STANCE_OFFSET_U;
  MUTANT: the four pre-S131 certificates prove 0 ids. failures=0.
- `tests/fight_stance_offset_test.gd` (new, room through `_process`, f01 vs f09, seed 94301, 60 s, all game switches):
  ON B stands -0.160 u to A's side (want -0.160), OFF control -0.000; gap along the line ON 0.885 vs OFF 0.932 u; A faces
  ALONG the line (p50 0.0 deg). First run: "parallel" p50 7.2 deg ON failed a 6 deg bound because strikes turn a thrower
  up to 30 deg (OFF p90 39 deg too) - facing is now judged on stance frames.

## 2. Re-certification under the offset (4 generated legal rigs, bound production path)
- `s131_offset_bound.json` (errors 0, 512 s parallel): all 14 certified singles + the 3 defences 4/4 - jab, cross,
  rear_uppercut, jab_body, body_hook, up_jab, overhand, cross_body, lead_uppercut, check_hook, lead_hook, slip, pull,
  catch. reference_jab (the raw RamsterZ control) 3/4 as before (heavy_c pin pop).
- `s131_offset_chains.json`: the 6 certified chains 4/4 (one_two, double_jab, slip_counter, pull_counter,
  counter_over_jab, catch_counter); jab_body_head 0/4 (probe, never in the palette).
- Stills, game 35 deg + side 90 deg, welter_a: `s131_<id>_generator_welter_a.png`, `s131side_<id>_...png` - every move
  lands where it aims with the feet on the canvas.

## 3. The rear hooks - CERTIFIED (palette 17 -> 19)
- `FightClipFootPlant.lock_foot` gained `"pin": "ball"`: the ball of the foot (Toes joint) held at its from_s floor
  position INCLUDING height; the foot keeps its authored world rotation and moves rigidly (heel lift + pivot authored).
- `boxing_rear_hook` and `boxing_rear_hook_body` bind `"foot_lock": [{"side":"Left"}, {"side":"Right","pin":"ball"}]`
  (FightStagePlayer applies a list of locks).
- `s131_rear_ball.json`: both 4/4, every row incl. G147; rear-foot contact slip 0.7 -> 0.03 cm; played skin below the
  deck 0.0 cm. Stills s131_/s131side_owned_rear_hook + rear_body_hook: at 0.367 s the rear leg no longer kicks up behind
  him (S130) - ball down, heel up.

## 4. Defect fixed on the way: Tools/c223_parallel.py wrote `Infinity`
Python's json writes inf as `Infinity`, which Godot's JSON parser rejects - the WHOLE merged certificate read as empty
(the six certified chains showed "unproven" because the probe chain had an infinite gap). Non-finite -> null,
`allow_nan=False`. Regenerated s131_offset_chains.json has 8 nulls, 0 Infinity.

## 5. QuickMagic two-person result (the first real-footage two-body link)
Downloaded with the operator's OK -> `D:/FightCamp/sources/quickmagic/qm2p_guard_pass/` (2 Mixamo FBX, 52 bones, 8 s).
`tools/qm2p_pair_check.gd`: both skeletons in ONE shared metric space - passer's hips 0.46-0.56 m (kneeling), guard's
0.17-0.22 m (seated), hips 0.76-1.09 m apart (p50 0.98). Approximate-capsule overlap >2 cm on 17% of frames, max 9.9 cm,
passer thigh x guard shin (real leg contact + capsule sizing) -> the contact cleanup step the recipe expected.
MUTANT (B on A's hips): 26 cm every frame - the first version read 0 everywhere (bone names carry `mixamorig_`), which
the mutant exposed. Trap: QuickMagic's viewer is Unity WebGL and only loads in a VISIBLE tab.

## 6. Operator requests this session
- Desktop recorder (`Tools/desktop_recorder.pyw`, `.cmd`): HOME = box + record, HOME = save to
  D:/FightCamp/videos/desktop, CTRL+ALT+HOME = quit. Verified on both monitors (frame vs screenshot diff 5.1/1.8 vs 28.9/19.2
  shifted 10 px) and through synthetic hotkeys. His first recording (4:29, the Arm Saddle study) read fine.
- Kolliopoulos 2004 "An Artificial Animated Boxer": `R_KOLLIOPOULOS_2004_ARTIFICIAL_BOXER.md` - turn by STEPPING, a
  60/45 deg vision cone for defence (backlog), no smoothing lesson.
- Sidekick Animation boxing packs (Reallusion store, 18 + 11 solo mocap clips, $45.50 + $23.10 sale): not bought -
  rlMotion needs iClone 8.3+ to export, fighting-game clip set, standing no-purchase ruling.

## 7. "The rotation of the body is not aligned with the feet" (operator, on the ops-board fight video)
- The video itself is clean: 1,350 frames, 0 repeated, 0 jumps, even pacing (neighbour ratio 0.89-1.1) - not vsync,
  not frame rate. The roughness is in the motion.
- NEW instrument `tools/s131_twist_probe.gd` (room through `_process`, seed 92012 = the video's fight, all game
  switches): twist = pelvis yaw vs the lead->rear ball line, rest-relative. Two blind versions first: headless
  `--script` runs never enter the live tree, so `global_transform`/`get_bone_global_pose` read identity/stale - 0.0 on
  885 frames; it now composes like FightStagePlayer (`skeleton_world`, `_pose_global`).
- BASELINE: twist p95 110 / 76 deg (A/B), >35 deg on 23% / 21% of frames; feet-vs-pelvis p50 29 / 19 deg.
- The helper agent's rank-1 cause (the planted-foot lock ignores yaw) was TESTED and is WRONG: a pivot step
  (`pivot_deg` 20, FightStagePlayer) fired twice and changed nothing. Shipped OFF.
- By clip: the twisted frames are the pack's WALKS - loc_strafe_right 49/76 frames >35 deg, loc_retreat 44/69,
  loc_strafe_left 32/51, loc_advance_right 16/26 (idle 9/310). A street walking gait under a body that keeps facing
  its man. The boxing shuffle (C215: one foot steps, the other stays planted, stance kept) latched on only at a man's
  first footwork beat - 0 frames in this fight.
- FIX: room switch `shuffle_from_bell` (game ON, `--script` OFF) -> `FightStagePlayer.enable_shuffle(0.12)`; a
  shuffle step now lasts >= 0.12 s (at 1.8 m/s it completed in ~1 frame). RESULT: twist p95 110 -> 42 / 76 -> 58 deg,
  >35 deg 23 -> 7% / 21 -> 13%; feet-vs-pelvis p50 29 -> 4 / 19 -> 6.5 deg. What is left sits in crosses and rear
  hooks (hips turn against planted feet - partly real) and the room's up-to-30-degree turn into a strike.
- STILL OPEN (numbers, not fixed): the pair orbits ~75-80 deg/s (circle speed clamps at top speed, FightFootwork:175)
  vs real hip-line yaw p50 35 deg/s (U123); G100: "The engine is over-translating, especially boxing. Cut path metres
  ~20-40%". An engine balance change - measured against the calibration bands before it ships.

## 8. Stamina must drive the 70% (operator: "make the stamina have impact on the moves and decision making, this will
explain why the 70% exists, you just need to tune it right")
- Today: FightStamina drains per strike and per second of movement (hold 0.016/s ... close 0.080/s) and refills ONLY
  between rounds; FatigueCurve lowers throw rate (floor 0.45), technique, power, defence; FightIntent moves part of the
  CLOSE weight to hold/circle as the tank empties. Nothing makes a tired man choose to REST, and resting earns nothing.
- Anchors on record: G100/D22 time-motion (75-85% of a round low-intensity; Miarka: 79% of 5th rounds), G99 CompuBox
  (45-56 thrown / 3-min round, jab 40-44%), BoxMAC frame shares (stance+guard+no action ~59%).
- Next stage (decision in roadmap `now`): in-round recovery while holding/guarding/clinching (rate from the recovery
  literature x conditioning), rest-seeking intent and lighter shot choice when tired, tuned on the anchors with a
  census before/after.

## 9. The .exe (SO1 acceptance)
`python Tools/build_playable.py` -> BUILD OK (pck 426 MB). Walked IN THE EXPORTED BUILD (s64_career_walk +
s117_boxer_walk.plan, as_game): **83 steps, failures=0, 0 SCRIPT ERROR, 0 ERROR**; live bout on the canvas
(`docs/previews/s131_exe_walk/76_bout_live.png`). The shuffle-from-bell change came after this build.

## 10. "Some punches are like bullets ... it looks like a huge stepback" (operator, on the before/after video)
- I had sent that video after checking ONE frame - a slip; 16 consecutive frames showed the pair swinging ~90 deg in
  0.5 s during a rear hook with the rear leg stretched out.
- NEW `tools/s131_bullet_probe.gd` (glove / whole-strike root / orbit / leg reach, 3 arms, seed 92012, 30 s): the bullets
  were NOT caused by S131 - offset OFF+shuffle OFF read glove p99 18.8 / max 30.0 m/s, 80 frames >15 m/s, whole-strike
  root max 7.6 m/s; offset+shuffle ON 18.5 / 27.8 / 80 / 8.4. Real punches peak ~8-12 m/s.
- CAUSE 1 (root lunge): `_place_whole_bodies` re-aims its warp goal every frame until contact and chases it at the SOURCE
  clip's fist speed (vendor peak x1.05, 16 m/s raw RamsterZ jab). FIX: `STRIKE_ROOT_MAX_MPS` 2.5 (Cheraghi 2014 hip shift
  0.278 m in a punch; fastest certified onset 132 ms -> ~2.1 m/s): whole-strike root p95 3.82 -> 2.50, max 8.35 -> 4.95.
- CAUSE 2 (hand pops): NEW `tools/s131_hand_pop_probe.gd` (hand_writer_observer + room stages; per-stage CONTRIBUTION
  change - a raw write-to-write jump blames `undo_procedural`, which only reverts last frame's fixes): 61 of 67 pops =
  `_bend_arm` corrections (arm_ik_L/R: aim_strike / push_hand), 11 of them the IK switching off in one frame; 3 = clips.
  Both hand smoothers (C186 12 m/s continuity, S77 IK-offset SmoothDamp) RETURN during every whole take - most of the
  game. FIX (switch `hands_smooth_in_whole`, game ON): the S77 smoother runs in whole takes except the striking hand in
  its contact window. Frames >15 m/s 67 -> 56, >25 m/s 4 -> 2. STILL OPEN: max 30.6 m/s, idle 13 / jab_body 13 /
  rear_hook 12 / cross 10 fast frames - the striking hand's own pin near contact and the C186 cap's whole-take bypass.
- Orbit (pair swing) p95 111 deg/s, max 195, in every arm - engine circling speed; untouched (balance change, measured next).

## 11. Agents (operator: "assign another agent", "you also have grok", "use kali", "for research use dola", "assign a room")
- Cursor U199 the lobby -> concept (claude-sonnet-5-thinking-high, operator's pick; `cursor_task.cmd` gained
  `CURSOR_MODEL`), worktree D:/FightCamp/wt/U199 - RUNNING. Grok G148 the office -> concept (Grok 4.7), D:/FightCamp/wt/G148
  - RUNNING. Codex: operator's Full reset used (chatgpt.com usage panel) - probe "CODEX_ALIVE"; TASK_C224 the locker room,
  launch S132 when a shell slot frees (max two). Dola TASK_D65 in-round recovery research; Kalli TASK_K47 the film room as
  a buildable spec - both browser agents, launch S132.
- Verified in the agents' environment (Cursor's shim HOME): Blender 5.2.1 headless + GLB export, Python PIL/numpy,
  Godot 4.7.2. All 13 concept paintings now in `previews/concepts/` + CONCEPT_ART_INDEX.md; AGENTS.md points
  every agent at the research index and the concept folder.
- Ops-board Codex switch: the toggle WRITES (roster in_rotation true, button "toggle on"); its note was stale ("usage
  limit, try again Oct 3") - rewritten.

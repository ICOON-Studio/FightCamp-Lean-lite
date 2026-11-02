# S124 digest - the clipping re-judge (boxing 19/36 -> 1/36), the catch solved by target, U197 merged (Claude, 2026-09-29)

**S124 in one line:** the operator caught a certified jab lunging chest-to-chest into the defender; he chose to put G147's clipping
rule over every certified move - **1 of 19 passes (boxing_jab_body): boxing is 1/36** until spacing + contact are fixed (S125).

## The clipping re-judge (operator ruling S124: "Add the rule, re-judge all 19"; then "i do not object just fix it")
- Evidence: the still `s124_seq_boxing_catch_counter_generator_welter_a.png` 0.900 s, and the certified production jab itself
  `run10_jab_bound_owned_jab_generator_welter_a.png` 0.45-0.60 s: chest-to-chest, head into the defender's lead glove. The
  broadcast angle hides the jab arm, so it reads as a head-first lunge.
- Instrument: Q213 clips mode (tools/q213_clip_gate.gd, G147 limits: head >1 cm >1 f, torso >2 cm >3 f, arm 3 cm/3 f, leg 2 cm/3 f,
  foot 4 cm/5 f) on EVERY exact boxing binding at its certified spacing, four generated legal pairs. Now also reads the s1NN
  counter certificates as chains. Log docs/previews/c223/s124_q213_clips.txt: Q213_GATE FAIL population=clips_boxing_exact moves=23 pass=4 fail=19.
- PASS: boxing_catch, boxing_slip, boxing_pull (pieces, not counted) + boxing_jab_body (counted). FAIL: the other 18 counted
  moves + catch_counter. HEAD 75 failing events, worst pair attacker Head > defender LeftHand (the lunge); ARM worst 22.6 cm (glove
  through the guard); LEG 17.8 cm (hooks/uppercuts certified at 0.70-0.73 m).
- Why C223 missed it: the fixture spacing is where the FIST reaches the head; no row looked at the rest of the two bodies. Q213
  read FAIL in S119 (1/11) but sat outside the certification path.
- NOT yet split: clips mode has NO contact_stop glove pin (the room has one), so part of ARM/HEAD is what the game already stops.
  S125 measures with the pin first, then re-spaces per G147 (body push box, IK glove pin, authored spacing) and re-certifies.

## C223 - catch piece (certified piece) and catch_counter (NOT certified)
- Method: tools/s124_catch_solve.gd grafts the base exactly as the gate does and coordinate-searches ONE layer (RightUpperArm xyz,
  RightLowerArm x, RightShoulder x) on all four rigs against a TARGET (rear wrist 18 cm in front of the Head bone, on its centre
  line, 4 cm below it). S123's Euler grid best (cg_s3) had the wrist 9 cm over the head.
- Bound on the RamsterZ guard H2H_Idle: s124_catch_bound.json 4/4 (fwd 18.0-19.9 cm, lat 0.2, glove >= 3.7 cm below the Head bone,
  0 pops, slip <= 0.23 cm); piece_cut_s 0.6 (at 0.45 the glove was half up and the jab's guard start jumped 12 cm/frame^2).
  Q213: catch PASS. Stills s124cr_*, s124crside_* (and the Mixamo-base trial s124cg2_*).
- catch_counter [catch, jab]: numbers passed 4/4 (s124_catch_counter.json) but it is the production jab's lunge - NOT counted,
  binding provenance "near". My two errors on the way: gated against run8's stale jab certificate (reach 1.43, contact 0.4 -
  production jab is run 10: 1.02-1.13 m, 0.315 s), and credited the RamsterZ base for a fix the certificate made.
- Sequence gate: a DEFENSIVE piece is left out of the fixture-gap min. S123's three counters re-certify 12/12 under it
  (s124_counters.json) - and all three then FAIL Q213 (they carry the cross/overhand clipping).

## U197 merged (Cursor, 55ad9432) as a diff + one change
- Footwork beats reach the room (5/5 on seed 94301). Change: steps ride BESIDE the chosen beat (`beat["footwork"]`,
  FightBeatAdapter._footwork_steps / room _schedule_footwork) instead of competing in `_choose`. A mutant with the delivered design
  ALSO passes on seed 94301 (punches out-ranked every step) - the new checks are a guard, not a caught bug. Test 34/0; subset 12/0.
- check_workflow.py read U197's bullet-style Owned list as EMPTY - fixed (reads bullets; an Owned section with no path fails loudly).

## Nightly reds and tooling
- 09-29 nightly (20 reds at 9b143308, ran 05:00-08:19 alongside S123 and a hung orphan) re-run alone at HEAD: 14 real, 6 load
  (clip_phases_data, fight_body_layers_live, fight_collision_floor, fight_cc_skin, fight_defence_model, fight_contact_stop).
- run_tests.py: on timeout it now kills the whole Godot TREE (taskkill /T) - subprocess.run killed only the console wrapper and
  then blocked on pipes the orphan held (an arena_deck_shape orphan from 05:52 was still burning a core at 09:45). Proved on a
  child-process tree (child gone, drained 1.3 s).
- ui_technique_preview_test: finds its NEAR case instead of naming boxing_one_two (which got its own clip) - 0 failures.
- Room reds -> U198 (Cursor, launched): 12 cm root jumps in one frame, 20 cm past the ropes (engine 2.443 m, room 2.656 m),
  4 hangs (room_positions, readable_onset, stage_realism, gloves_both_corners), pair_live qualifying 0, overlap 1.3 mm.
- MMA/engine reds -> Q216b prompt (back_bands 5/15 visits, footwork_economy 9.3 < 12 m/min, plan_ai_corner, ring R16 cage):
  Grok CLI's first trial when a shell slot frees. fighter_reachability -> KM2 (Kimi, running).

## KM1 review acted on (boxer path)
- ShellChrome weekly Continue: INK text + chevron on green (white on #3fae5a was 2.83:1 -> ~6.5:1).
- SetpieceChrome: four developer notes in the cue line replaced with player copy; DevelopmentPanel trait note rewritten.
- KM1 verification block extended: amateur pool finding STALE (fixed S76 27b507fb; S123 had wrongly confirmed it); "BACK HOME"
  kept (deliberate S79 rename); bald fighters OPEN (MPFB pilot has no hair mesh - next free agent slot).

## Agents
- Codex LIVE probe: locked, "try again at Oct 3rd, 2026 9:50 PM" (S123's "back" was wrong). Grok Build CLI 1.0.44 installed on
  D:\FightCamp\tools\grok\bin, operator signed in, headless verified (Grok 4.7). Kimi KM2 running (tests in the main checkout).

## Tests (tier: scripts edited; full suite is the nightly)
- footwork_beats_reach_room 34/0; U197 subset 12/0 (beat adapter x2, live schedule x2, presenter contract, world_live,
  broadcast x2, footwork_not_a_blow, body_layers_live, boxing_output, footwork_beats); UI subset 17/0 (boot/creation/day feed/development x2/header x2/menu/office nav/profile/setpiece x2/career walk/result plan card/ui preview/footwork beats/clip phases); ui_technique_preview 0.
- Nightly to cite: 2026-09-29 at 9b143308 - SUITE total=459 fails=20 (14 real on re-run).

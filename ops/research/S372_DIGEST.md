# S372 digest (2026-11-03, Claude) - Lean d9011d1f -> 2ebb72d4

## What happened
- FIGHT9 round 1 (Argon/agy) never got judged: three parse errors (FightView.gd:256 PackedStringArray.any(),
  FightIntro.gd:239/:371 one tab short, fight9_probe.gd:234 untyped var) stopped every script compiling; the after-film
  sat 6.5 min on the gym screen and Argon scored a frozen menu 1/10. Claude fixed the three lines on agy/fight9r1
  (7a9313b7, PR #24): fight9_probe 13/15 PASS (FAIL ring-entry head 1.496 m vs 1.25 m; clinch break 2 through=3),
  golden_path / ring_lens / fight_flow PASS.
- seat_dispatch compile gate (e1c57f11): after a seat delivers, compile_errors() boots Main.tscn headless; agy gets one
  repair pass on the printed errors; a branch that still does not compile is not filmed and the next loop brief quotes
  the errors. .import files never count as stray.
- TASK_FIGHT9R2 rewritten by hand: BASE agy/fight9r1, the operator's C218 legs note first, round 1's probe, main's real
  3/10 verdict. Round 2 launched 03:41 by the reconcile; its before-film (round 1 fixed) reached fight night, 0 errors.
- Operator comment C218 (KNEETRACK1 after.mp4 at 24 s): "when legs move its akward something is wrong, when doesnt move
  looks ok" - frames 19-24 s: knees cave in, feet turn out from the knees, rear heel twists on every step/slip/crouch.
  Handed to FIGHT9R2 as the top item (knee-over-toe bar while stepping).
- Collected Ziva BODYREACT1 (18b9a8cf): body_react_probe PASS 40/40 (worst curl 25.9 deg, first move <= 0.07 s, held
  >= 0.43 s); beat_clips / fight_flow / golden_path / clinch_rest PASS. Films stay on ziva/bodyreact1.
- Men's test norms from John J_TESTS3 (d20064e5): bleep 40 -> 9.0, 60 -> 12.5, 85 -> 14.0; punches in 10 s 42/52/57;
  no men's force test until a same-device ratio (J_TESTS4 sent). Answer in research/J_TESTS3_ANSWER.md.
- GOALTESTS1 phase 2 "Day 1 vs today" (2ebb72d4): the records wall keeps the first Sunday's mark; still
  ops/previews/S372/records_wall_day1.png.
- Sent: John J_TESTS4 (men:women punch force, same study), Kalli K_CALIB1 (the Sunday test curves, women + men).
- Closed stale runs RIVALPAST1 (PR #19 merged) and NOREF1 (PR #23 closed); FIGHT9R1 marked "looping".
- Miro YOUR NOTES lane: empty. New animations since cde886fc: 0.

## Male MetaHuman boxers (operator "Yes, build them")
- No Unreal run: the old repo (ICOON-Studio/FightCamp, Godot/assets/models/metahuman) still had nine male MetaHumans built
  S152/MH4 on the same 341-bone skeleton and MH_* materials as the women. Restored five (2b349ce2): Victor 01 (183),
  Isaiah 02 (174), Kelvin 03 (179), Mikel 07 (177), Orlando 08 (186). Out: 04/09 heavyweights; 05 Mateo and 06 Aoi read as
  women in their headshots.
- Bare-chested in trunks: a painted vest (mh_vest_glb.py) was tried and removed on the operator's word "male boxers donot
  wear tops" - the GLBs are the old repo's originals.
- Faces: MEN_CM pool, Danny -> Isaiah, Josh -> Victor, men by sex or division m*, pair() inherits the other side's sex,
  partner(f) = a man for a man (Playbook, combo builder). Headshots baked; sidecars restored. male_bodies_test 28/0.
- jump=men_fight + board button "Test: two men in the ring (update 69)" (6c54177f); film
  ops/previews/S372/men_fight_danny_vs_liam.mp4. FINDING: Danny (61.6 kg for 60) missed weight on his first offer
  (~17 days, diet-only cut reached 60.32) - check offer lead vs cut rate with the 60/65 limits task.
- FIGHT9R2 crashed once at 03:56 (agy replaced its own exe mid-launch); seat_dispatch now waits for the exe and reuses a
  judged BEFORE film; relaunched 03:58; at 04:28 agy hit its 30-min print timeout mid-turn with nothing written -> turn raised to 60 min
  (2e2de1e5), relaunched 04:30. Round 1 (compile-fixed) scored Argon 3/10 = main.
- Still: the body-map holo is the female ecorche for everyone - a male holo (male half of the licensed pack,
  E:/FightCamp/licensed/ecorche_aaaxis) needs its own render, landmarks and mask.

## HANDOFF
- Working commit: 2e2de1e5 (main, pushed); exe rebuilt (suite 124 PASS, 0 FAIL). Evidence: the probe/test lines above, PR #24 body, seat_dispatch.log.
- In flight: agy/fight9r2 (LEAN_FIGHT9R2, runner pid 24012) - before-film of round 1 recording at 03:50; then agy 35 min,
  compile gate, checks, after-film, Argon, loop_next queues R3. Ziva BJJ9 at round 4 (ziva/bjj9, BJJ9_ROUNDS.md).
- Remaining: FIGHT9 to 9/10 (merge main into the kept branch before collecting - BODYREACT1 touched BeatClips/BeatFire);
  BJJ9 to 9/10; the male holo for men's body maps; GOALTESTS1 phase 2 test-day
  moment + grade upgrades move cards; FLOWBOUT1 Record tab + Playbook win rates; women's limits 60/65; J_TESTS4 + K_CALIB1.
- Exact next action: read the LOOP FIGHT9 lines in seat_dispatch.log (R2 before = round 1's first real score), collect
  John J_TESTS4 / Kalli K_CALIB1 (gbot threads), then FLOWBOUT1 wiring.

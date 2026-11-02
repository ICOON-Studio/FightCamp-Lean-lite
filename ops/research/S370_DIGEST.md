# S370 digest - menus for the player: the playthrough guide, the combo card strip, gains with causes, the tape reaches the plan; seats on knees, referee, body shots, plan records (2026-11-03)

Main: 4c5e58b -> 18e6350 (knee probe) -> 69ddbbd (PR #20 merged) -> 94f36f9 (guide) -> ee67ae3 (combo strip, WeekCause)
-> 45cb521 (tape -> plan, tape card) -> wrap-up. Digest of what the operator asked, in order: knees in the board clips,
"why not arena or gemini4", "what is zivas task", the player experience through the menus, Miro as the source, a GIF
guide, training/planning/booking/growth need attention, "stitch moves like hollywood animal", "moves as cards", a boxer
who only trains, "arena permissions fixed", a weigh-in cutscene, the tale of the tape clipped.

## Shipped on main
- Collected PR #20 CAMCLINCH1 (Antigravity on Argon): cam_view_probe windowed on the branch PASS - head hidden 0.009
  (main 0.051), longest 0.43 s (2.60), behind 0.029, inside 0; ring_lens/fight_flow/golden_path/clinch_rest green;
  operator C216 "better". C217 (camera behind a shoulder) was the S367 film, before the S368 fix.
- tools/knee_probe.gd: the knees measured on all 198 clips, headless (needs `await process_frame` before seeking or the
  pose never moves). 57 standing clips point the knee off the toes (advance 97 deg backwards at 0.6 s, uppercuts -130 to
  -176); twist is fine. `-- layer=1` runs KneeTrack.align (TASK_KNEETRACK1).
- The playthrough guide: tools/guide_tour.gd plays the Miro fighter path (30 screens, seed 1) on the hidden desktop;
  tools/guide_gif.py captions each with what it is for and an amber STILL UNCLEAR line -> ops/previews/S370_guide/
  guide.gif + guide.mp4 (sent to the operator).
- ops/research/S370_MENUS_RESEARCH.md: Miro's eight menu rules + fighter path, praised-game rules per loop (FM, Punch
  Club, WCBM2, Undisputed, UFC, OOTP, CK3 tooltips - sources in the file), our gaps, the decisions.
- PLAYBOOK > Combos card strip (ComboStrip.gd; ComboFlow.rate now records each step): move cards (level, landing time,
  gas, damage), each join judged in ComboFlow's words with its points, totals STRENGTH / GAS / LANDS IN / DAMAGE / VS her
  opponent (ComboOdds, book combinations). Still c2_uppercut_not_learned.png: 1-2, slip, uppercut = 96 flows, 5% gas,
  1.4 s, 5.2 head.
- Week review: a crossed point says +N, the rest "76% to 59", and the sessions behind it are named under the bar
  ("from Heavy bag x1, Strength circuit x1") - WeekCause.gd tallied in Sim.step_day; week_cause_test in the suite.
- Tape room: the answer always reaches the plan (TapeClips.pick_room: her line for that situation, or at the coach's
  limit her oldest any-time line), and the button says which line it replaces.
- Tale of the tape card solid (0.88 -> 0.97): the ropes and the near corner post showed through ("clipped").
- begin_probe.gd off the gone FightCast.BODIES (Ziva's editor parse error).

## Seats (all running at the handover unless noted)
- Antigravity / Gemini 4 Argon: KNEETRACK1 queued in seat_dispatch (knee layer KneeTrack.gd before FootPlant +
  clip_orbit previews; trap noted: Ziva S362 found the modifier stack may not reach the shown pose).
- Qwen: NOREF1 queued (no referee; PushOff.gd - hands on, slow push, guard; push_off_probe bars).
- Ziva: BODYREACT1 sent in her chat (body_react_probe first, then fix HitSnap/BeatClips/BeatFire); WEIGHIN3D1 next.
- Arena (operator fixed its GitHub permissions; full repo FightCamp-Lean selected, clone OK): FLOWBOUT1 - PlanRecord.gd
  + BoutNight "plan_rec" + plan_record_test; branch arena/ca105630-fightcamp-lean. Claude adds the test to run_tests.sh
  and wires the Record tab + Playbook win rates on collection.
- John: J_TESTS1 (real boxing tests and values by level, skill award schemes) - for the training-goal tests.
- agy/refbreak1 pushed for reference, worktree cleaned (retires on the reconcile).

## Waiting on the operator
- Q-S294-92: training goals as tests (canvas https://claude.ai/artifact/HLaiSxhMXEPERsM3naACY7: her goal is a test,
  test day, grades, the combo strip).
- One belt match before claude/bjjmatch1 merges (S369).

## Next (S371)
1. Collect: Arena FLOWBOUT1 PR, agy KNEETRACK1, Qwen NOREF1, Ziva BODYREACT1 (each by its probe, windowed where visual).
2. On "Yes" to Q-S294-92 + John's numbers: build GOALTESTS1 (a goal is a test on a date, the projection the week moves,
   the Sunday check-in, test day, four grade roads).
3. The plan in the ring ("PLAN: DOUBLE JAB landed 4/5" + the corner's plan so far) and the plan board reading the file
   with a ROUND row (S369 proposal items 2-3); wire FLOWBOUT1 into Record + Playbook.
4. Re-render the guide (fight timing fixed in guide_tour.gd) and resend.

# S117 DIGEST - 2026-09-28 - the boxer career walks end to end, legal bodies, the jab lands

Working commit: `d960d3fd` (master). No .exe (D3: boxing 1/36). All evidence below is on disk.

## Verified playable (dev tree, clicks only, the game's own switches: `as_game`)
`research/s117_boxer_walk.plan` via `tools/s64_career_walk.gd -- as_game`: new career -> sign/card -> program ->
Move Lab -> floor -> scouting -> staff -> contracts -> books -> book an amateur boxing bout -> camp -> fight week ->
weigh-in -> fight night -> **SIM TO RESULT -> RESULT -> BACK HOME -> next week -> save**. No dead end.
Stills: `docs/previews/s117_walk_game/75_bout_live.png` (two generated welterweights in trunks and gloves),
`77_result.png`, `81_next_week.png`.

## Fixed (each with its number)
- **Fighter overlap** (Q210 finding): a movement step is held at the separation floor (`FightRealtime._block_step_at_floor`).
  8 seeds: boxing longest-below-floor 17 -> 5 ticks, MMA 14 -> 2 (cap 9). `70b84822`.
- **Weight classes**: career_mesh picks the nearest-class legal body (second welter no longer gets the heavyweight body -
  bug since S74); demo boxing pair welter f01 vs welter f09 (S36's fix, undone by U176 09-26). `career_mesh_weight_class_test`.
  KNOWN GAP: no same-class female pair exists (printed by the test). `662e969b`.
- **Generated fighters (D5) are the game default**, dressed: FighterTrunks paints trunks into vertex colour, kit shader
  replaces the skin there (a multiply hid them on dark skin), FighterFist closes the hands, the glove takes the palm frame.
  `6d2a4201`, `d960d3fd`. An intermediate switch-on showed them NAKED - reverted, fixed, re-enabled.
- **SIM TO RESULT** on fight night (the walk never reached RESULT: a 3-round bout plays at 1x-4x only). `2d35a3d0`.
- **Jab share 0% on the result screen**: the career boxer had learned only `boxing_stance_guard`, and a learned record
  NARROWED the palette. Now tier 1-2 is the floor, learning adds (`FightMoves._knows`). `2d35a3d0`.
- **boxing_output ON in the game** (U174+Q203, G99): it was built and never switched on. `2d35a3d0`.
- **Feints ate the punches**: boxing feint weight 55 -> 8 (C196's fit predates the Q192/Q194 role-first pick). Probe
  (`tools/s117_jab_share_probe.gd -- switches output`): 42.8 feints : 10 punches -> 6.0 feints/min (G86 6-14), 32.4
  punches/round, jabs 48.6%. Walk result: Larkin 47% jabs, 8.9 punches/min; Pereira 24%, 10.1/min. `3968b8b1`.
- **Fight-night card said "No fight camp. In cold."** after a full camp (read camp OPTIONS); now reads get_camp_summary.
  NOT YET SEEN ON SCREEN: the walk does not photograph the round-bell card - add a `shot` right after BEGIN FIGHT.
- Catalogue: `boxing_catch_counter` had no technique_class/limb; sambo lacked the `submissions` branch `sambo_rnc` uses.
- Camera skin bounds crashed on unskinned glove meshes (8 SCRIPT ERRORs) - guarded.
- R144 line 2 corrected against R142's file list: Martial Arts Master HAS 30 paired clips (still no ground work). Not owned.

## C223 (Codex, gpt-6-astra) - run 6, the last paid run by operator ruling
Brief was re-issued twice mid-run to add facts the operator had to point out (legal weight pairs; the game's bodies).
Result: **boxing EXACT 0/36 -> 1/36 - the jab** (Mixamo `Med_Head_Jab`), certified on generated legal pairs (welter
66.0/66.5 kg, heavy 100/108 kg) both directions, 20/20 seam mutants rejected. Merged as a diff `590ec538`
(check_workflow 0 defects after TASK_C223's owned list recorded the scope Claude's run-5/6 briefs authorised).
Claude's check on the Tripo bodies (`c223_production_gate.gd -- tripo`, `s117_tripo_jab.json`): the jab FAILS there
(join discontinuity) - it is certified for the generated bodies, which are now the default.
Tokens: run 3 182k, run 4 497k, run 5 256k, run 6 (not logged). Operator: "if astra does not produce the boxing
animations on this run i will stop codex not paying for it again" - run 6 produced 1 of 36; the call is the operator's.

## Mixamo
The 361-clip combat queue is DONE (329 this session). Archive: `D:/FightCamp/sources/mixamo/combat` (361) +
`/boxing` (61), 214 MB.

## Remaining, in order (the next action is 1)
1. **Punch volume**: feints and punches share one decision budget, so boxing throws 32 a round (CompuBox 45-56).
   Make a feint not spend a throw decision (FightRealtime feint path ~:4227/:4477, FightMoves select), re-measure with
   the probe; keep G86's 6-14 feints/min.
2. **Boxing clips 2..36** on the generated bodies with C223's pipeline (Codex's tools are on master: `c223_production_gate.gd`,
   FightClipFootPlant, join measure). If Codex is stopped, Claude runs the pipeline: next candidates cross_new,
   lead_hook_new, rear_hook_new failed on seams/slip/speed (C223_DIGEST run 6).
3. The walk again after each engine change (`as_game`), watching bout_live and the result read.
4. Generated fighters: hair (the ring shows bald men while the tale-of-the-tape portraits have hair -
   `s117_walk_game/74_begin_fight.png` vs `75_bout_live.png`), female bodies (the KNOWN GAP), portrait-body match.

## Reds seen this session that are NOT S117's (all red on the base tree)
fight_strike_whole, judge_panel (both red in the 09-27 nightly), athlete_development, grapple_adapter,
technique_phase_seat, technique_range_data, fight_stage_realism (standing).

# S122 digest (Claude, 2026-09-29)

**S122 in one line:** hip-drop foot drag fixed; footwork stopped landing as punches (25-33% of strikes) + boxing retuned into every Q211 band; Q215 + Q216 collected; 5 nightly reds fixed; C: 11.9 -> 105 GB; Kimi joined; release map on the ops board. In flight: U196 (Cursor), KM1 (Kimi). Last commit before handover d4fa0729.

## Hip-drop foot drag - FIXED (FightClipFootPlant)
- Primary source: per-frame RightToes dump (`c223_production_gate.gd dump_toes`), shovel hook, `hold_root plant`,
  layers `sh21_c` (Hips drop 0.07) vs `sh21_nohip`. Reports `docs/previews/c223/s122_toesp_*.json`.
- Cause: the RamsterZ hook source STEPS its rear foot (frames 12-18, ~15 cm, lift 2.6 cm). The Hips drop lowered
  the feet with the pelvis; the plant bake raised the sole back to 0 and erased the lift, so the baked clip's
  vertical-only contact read one long plant; the foot lock pinned the foot through the step and glided it 22.6 cm
  after (heavy_c; heavy_d stayed pinned).
- Rejected first: unplanting fast horizontal toe frames in `FightStagePlayer._plants_for` - slip rose to 23-52 cm on
  every rig (the flattened step then skates on the canvas). Reverted.
- Fix: the bake reads each sole's PRE-DROP height (Hips raised back by the layer's drop at that time) and keeps it:
  knees bend, feet stay where the source put them. What an animator does: drop the pelvis over IK feet.
- Evidence (control arms): HEAD 22.62 cm -> fix 0.0 cm on heavy_c (all rigs 0.0, `s122_fix2_sh21_c.json`); no-drop
  control 0.0 before and after (`s122_fix2_sh21_nohip.json`); the no-drop code path is unchanged by construction.
- Certified hip-drop moves re-run bound + `live_contact` (`s122_bound_controls.json`), 12 rows, 0 mechanical
  failures: cross_body 8.5-9.3 m/s (= certificate), rear_hook_body slip <= 0.23 cm, shovel_hook unchanged.
- TRAP: a bound witness without `live_contact` reads the fist THROUGH the target (cross_body 14-15 m/s,
  overhand 16) - not a regression. Certificates were taken with `bound live_contact`.
- Tests: `--only clip,binding,boxing,foot` 24 run, 1 fail = fight_footwork_economy (mma 9.3 m/min), the same
  failure and number as nightly 2026-09-28 at 6d2a4201 (23 fails there).

## Q215 collected (Qwen send-back 2, 633da23d) - TAKEN OVER BY CLAUDE
- Read: Q215_DIGEST.md whole + branch diff. Delivered blockers, no certificate, no stills.
- MERGED as a diff: FightStagePlayer N-part `sequence_plan` / `_advance_sequence` / `whole_phases` (cuts[] + entries[],
  2-part behaviour identical) + 4 gate TAKES rows. Proof: `c223_sequence_gate bound
  certificates=run8_bound.json,run10_jab_bound.json` = run10_chain.json exactly, 8/8 certified
  (`s122_seq_nparts.json`); focused sequence/presentation_queue/paired_stage_player/boxing_/strike_whole 8/0.
- NOT merged: its bindings (7 counters + catch/pivot labelled "exact", uncertified; catch 35-39 cm off the face,
  pivot slip 11-15 cm).
- Its "one_two fails on master" was a stale certificate: the jab was re-sourced in run 10 (dbe9926b); the chain
  certificate is run8_bound (cross) + run10_jab_bound (jab), later file wins. Its "`selection` undefined" is wrong
  (c223_clip_gate.gd:66).
- TRAP: a missing certificate key in c223_sequence_gate is a SCRIPT ERROR that HANGS the run (no quit) - kill by PID.

## Nightly reds (2026-09-28 list, 23) - fixes
- asset_manifest: 3 shipped folders unclaimed -> entries added (mixamo_boxing_pipeline_a [Mixamo FAQ, S116 bulk
  download], higgsfield_boxing_boot [tripo_3d job c5591bc5], kenney_furniture_kit [CC0, licence file in folder]). 0 fails.
- athlete_development: REAL BUG - `AthleteDevelopment.migrate_athlete` still added only the legacy `grapple` after
  S33's split, so an old six-stat save seeded discipline_proficiency over three missing stats as 0 (30 -> 20). Now it
  calls `WorldPopulation.migrate_athlete_stats` (one stat-shape rule). The jab check trained a fixed 4 sessions,
  predating U67's cost retune (32 reps, learned on session 2): now trains until learned (cap 10). 0 fails.
- carry_progress_contract: the contract predated S117's floor (`FightMoves._knows`: tier 1-2 always known; the
  career boxer threw 0% jabs without it). Restated: untrained palette moves must sit inside the floor, every move the
  record adds must be learned, named grapple events above the floor must be learned, and non-inertness is proven by
  planting one learned tier-3+ REAL grapple node (kickboxing_clinch_knee_sweep) - it enters the carried palette only.
  13/13.
- FINDING (not changed - documented design with an A/B switch): GRAPPLE_EFFECTS holds the ambiguous openers
  (`entry_open`, `chain_open`, `entry_speed`), so 17 striking/movement nodes (boxing_double_jab, boxing_jab_body,
  boxing_rear_uppercut, boxing_feint, boxing_rhythm_change, kickboxing_switch_kick ...) sit in the grapple palette.
  See FightMoves.gd AMBIGUOUS_OPENERS note; revisit with a census, not blind.

## FOOTWORK WAS LANDING AS PUNCHES - fixed + boxing retuned (operator approved "Fix + retune", S122)
- Found via fight_pair_live (pairs=0): a probe of the room's beats (seed 810039, 120 s) showed
  boxing_step_in_out / circle_lead / circle_rear as ACTIONS landing clean on the head: 25% of thrown and 33% of
  landed in the game config (as_game), 38% / 47% in the control arm. Cause: every catalogue node with role
  `setup` became a strike (FightMoves.move_from_node); movement-class nodes with no target region inherited the
  ruleset's regions.
- Fix: `FightCommitment.is_movement_only` (movement class, no damage word, no feint word) -> `movement_only` on
  the move and through `Moves.select`; the engine never makes it significant, never lets it land, spends no
  evasion on it, and logs it as type `footwork` (every strike counter filters `action`). Boxing-output only:
  `BOXING_OUTPUT_FOOTWORK_MULT` 0.25 on its selection weight (feet move BETWEEN punches, not instead of them).
- Test: tests/footwork_not_a_blow_test.gd 12/12; mutant (movement_only dropped from select) -> 2 fail.

## Operator video (S122): "The Secret to Van's Boxing" (youtube.com/shorts/STVH9fzCQa8, @NansendSports, 56 s)
- Pundit breakdown, not a study. Joshua Van (v Pantoja): rear foot pointed more forward, rear heel constantly
  raised, weight ~even, back leg "loaded like a spring" -> springs into punches from range and straight back out
  (jab off the toes, lands on the toes, pulls out), cross with almost no pivot, right hook wrapped around a parry.
- Its "traditional = rear foot 90 deg" is overstated (D64: orthodox ~30 deg, Philly ~45 deg).
- FOLLOW-UP (backlog, after C223): D64 has no heel/spring axis - add a SPRINGY STANCE MODIFIER to any guard
  (rear heel height, rear-foot yaw, weight split) with engine effect = faster entry/exit + shorter cross wind-up,
  cost = stability. Consistent with K46 (never hard-lock the rear heel).
- Behind switch `footwork_no_contact` (DEMO_SWITCHES ON; OFF byte-identical - judge_panel / fight_strike_whole
  seeded pins unchanged). Retune (boxing_output ON + footwork_no_contact ON): JAB_USAGE_MULT 4.0 -> 2.6,
  CONTACT_LADDER 0.60 -> 0.58, FOOTWORK_MULT 0.25 (new). Rejected: RANGE_MULT 2.0 (feints doubled, no stoppages).
- Census (tools/u195_engine_census.gd bouts=40 ruleset=boxing switch=feint, 120 bouts, 3 matchups - counter v
  pressure, out-boxer v boxer-puncher, swarmer v tall), game arm: KO+TKO 45.0% (Q211 45.0, BoxRec 47), connect
  31.5% (33.0; G99 27-35), KD bouts 34.2% (31.7; <40), sig/min 7.78, draw 13.3%. Jab probe (s117_jab_share_probe
  switches output): thrown 47.3 per fought round (50.1; CompuBox 45-56), jab 47.3% (47.6), feints ~11/min (G86 6-14).
- Kickboxing drift (bouts=20, game arm, HEAD -> S122): sig/min 3.19 -> 2.85, acc 59.0 -> 58.1, finish 10.0 -> 10.0,
  KD 11.7 -> 3.3, leg 16.0 -> 18.7 (J20 14-18). Kickboxing's 10% finish rate predates this (backlog).
- Tests: footwork_not_a_blow 12/12, boxing_output (ON arm now carries footwork_no_contact, as the game does),
  judge_panel, fight_strike_whole, fight_feint x2, carry_progress 7/0 after. mma footwork economy 9.3 -> 8.4 m/min
  (already red; Q216).

## Q216 collected (Qwen, qwen/q216-engine-reds bd3690fb) - 3/7 merged as a diff
- Read: Q216_DIGEST.md whole + branch diff. MERGED: fight_metres BOUT_COUNT 200 -> 20 (its header: sanity-only
  assertions, no exact values - the "hang" was 1000 bouts overrunning the timeout); judo_uchimata takedown 11 -> 16
  (magnitude 19 -> 24 over ippon 22) = U69 option (a); grapple_adapter MT witness re-found 93003 -> 93000 with its
  pins. fight_scoring 0 fails, grapple_adapter 126/0 on master.
- CORRECTED two Qwen claims: the MT seed did NOT move because of S122 (footwork_no_contact is OFF in tests; the test
  was red in the 09-28 nightly, before S122) - it moved between the 09-27 and 09-28 nightlies (Q210 muay thai
  grapple data, S117 separation floor); comment fixed in the test. Its cited break commit `11cd459` is a
  suite-record commit (U69 carries the same hash; the value is 11 at every nightly head since 09-26).
- FOLLOW-UP (U69 option a, not done): the other tier-2 gokyo throws sitting at 19 (seoinage, harai, tai-otoshi)
  should rise to ~24 with uchimata.
- STILL RED (need engine work, on the queue): fight_back_bands (sub-finish share over 32% for high-grapple pops),
  fight_plan_ai_corner (C216 coach model vs engine), fight_footwork_economy (MMA 9.3 < 12 m/min),
  fighter_reachability (Qwen could not run it headless without the import cache - not verified).

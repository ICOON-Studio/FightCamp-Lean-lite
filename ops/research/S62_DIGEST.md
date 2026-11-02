# S62 digest - THE ENGINE KEEPS THE TWO MEN APART (Claude, 2026-09-24)

## What shipped
`Godot/scripts/FightSeparation.gd` (pure module, zero preloads) + `FightRealtime._run_separation`
(runs every MOVEMENT tick after the footwork step, standing OR clinched; ground exempt). A minimum
hips-to-hips distance per KIND, G79's LOWER band edges scaled by the pair's mean arm
(`Moves.arm_length_m`, reference 180 cm reach): clinch 0.28 m, engage 0.55 m (hooks and uppercuts
stay legal), reset/measure 0.85 m. The deficit closes at <= 2.5 m/s TOTAL (half to each man, then
the ring wall), so a clinch break takes 0.11 s and a stand-up 0.34 s - never a snap. Switch
`separation_floor` (default ON; OFF byte-identical to S61). A second switch
`separation_strip_velocity` (remove a man's inward velocity at the floor) MEASURED as raising
landed volume ~20% and ships OFF. Witnesses in the state: `separation_pushes`, `separation_push_max_m`.

## Population named
fight_separation_test: "Realtime A" boxer reach 183 (power 60 / tech 62 / speed 58 / grapple 40) vs
"Realtime B" reach 176 (55 / 48 / 62 / 70), seed 94301, one round, rulesets boxing and mma from
combat_rulesets.json. Q156 (Codex): the same two men, 20 seeds x 3 rounds x 3 arms. U149 (Cursor,
BEFORE) and the probe: Tripo bodies f01 vs f09 (boxing), f05 vs f06 (MMA), seed 94301.

## The numbers
| measure | before (S61 tree) | after (S62) | source |
|---|---|---|---|
| min standing hip gap, boxing / MMA, seed 94301 | 0.388 / 0.388 m | 0.518 / 0.547 m | fight_separation_test |
| longest run of >3 cm overlap, boxing | 0.150 s | **0.100 s** (budget 0.10) | u145_transition_probe arm A |
| longest run of >3 cm overlap, MMA | 0.150 s | **0.083 s** | same |
| body jumps >0.10 m/frame, boxing / MMA | - | 1 / 4 (ceilings 5 / 8) | same; the MMA worst is a pair-mount warp, not the floor |
| landed per round, boxing / MMA (20 seeds) | 24.97 / 37.95 | 27.27 (+9.2%) / 41.22 (+8.6%) | Q156 ON arm |
| landed per round with the velocity strip | - | 29.82 (+19.4%) / 42.18 (+11.2%) | Q156 ON+STRIP - why it ships OFF |
| MMA landed leg share | 6.2% | 8.0% | Q156; fight_realtime's C85 read 7.0% -> 8.7% |
| clinches per round, MMA | 0.97 | 1.07 | Q156 |
| default-profile bouts that reach the ground | - | 154 / 200 (77%) | tools/s62_find_ground_seed.gd |
| judge non-unanimous decisions, 300 seeds, boxing / kickboxing | 12 / 13 (R102) | 1 / 4 | find_r101_seeds -- panel; the SPLIT family is BACK in kickboxing (seed 40) |
Knockdowns per 100 landed read 0 in every Q156 arm: that column is blind (event type name), not a finding.

## Re-found, never relaxed (every seeded witness moved, as every engine change moves them)
- grapple_adapter MT witness: 93002 stopped landing its throw -> 93003 (93 hits of 400; card 30-25
  unanimous; tally DECISION 319 / KO 63 / TKO 18 vs Q153's 316 / 68 / 16).
- fight_realtime "the default profile grapples": seed 92002 -> 92000.
- judge_panel T4: twelve cards re-pinned from two agreeing runs; T11: kickboxing 461 / boxing 519
  went unanimous -> kickboxing 40 (SPLIT) + boxing 109 (MAJORITY). Boxing non-unanimous decisions
  fell 12 -> 1 of 300: REPORTED, NOT TUNED.
- Still red and handed on: `grapple_naming_contract` muay_thai 85.8% -> 71.4% (Qwen Q158 Part 0);
  `fight_room_no_teleport` - FIXED by Cursor U150 part 2 before the session closed: the room eased
  `_overlap_sep_m` and then `_correct_refused_overlap` added a SECOND hip push in the same 1/60 s
  frame (~0.11 m on B at frame 3263); now skipped behind `overlap_sep_credit_engine_gap` (ON), 2/0.
  U149 AFTER (rendered hips, Tripo bodies): MMA 94301 engage min 0.015 -> 0.251 m, p10 0.495 ->
  0.594; boxing 94301 engage p10 0.568 -> 0.616. Rendered hips still dip under the ENGINE floor
  (0.518 m) because the clip layer moves the hip bone off the root - that is S63's domain.

## The suite (read off the run, --jobs 2, 2026-09-24 01:41)
`SUITE total=372 fails=12`: the nine documented reds (athlete_development, capsule_coverage_contract,
fight_body_overlap, fight_metres [--jobs hang, passes alone], fight_pair_live [PARKED], fight_scoring,
fight_stage_realism, fighter_reachability_contract, weight_cut) plus THREE the floor caused and that
were re-found after the run: fight_body_radius, fight_collision_floor, fight_pushapart all assert
their own INNER mechanism (that men can get inside 0.45 m with body_radius OFF); the outer floor
kept them out, so those fixtures now run with `separation_floor: false` - 4/0 with
fight_beat_technique, whose M19 degrade check went vacuous once Q159 gave every boxing punch a
family clip and is now asserted on the resolution path itself. judge_panel, grapple_adapter,
fight_realtime, fight_room_no_teleport all green in the run.

## What it took, and what nobody forecast
- The floor alone did NOT raise volume; the cosmetic velocity strip did (+20%). A third test arm
  found it in one run: keep the control arm.
- `Tools/godot_hidden.ps1` swallowed Godot's stdout entirely (two 10-minute probe runs, 0 lines):
  fixed by redirecting both streams and printing at exit.
- Fresh agent worktrees lack Godot's class cache: three agents reported a "TitleHonours parse
  error" that master does not have (`--import` once fixes it). Now in every launch prompt.
- Q148's branch was merged despite the S61 note "do not merge" - it only adds a tool, a digest
  and a test file identical to master's; harmless, recorded.

## Collected this session
Q155 (U147 inert, removed), U149 (BEFORE table), Codex venues 5-7 (Northlight, North Dock, The
Quarry), U139/U140/U141 (ground graph contract, decay shape, wiring contract), Q148, Q156, C179
(CC generator scripts + `cc_export_for`), U150 part 1 (blind contract, 5/5 mutants), Q157 (190
grappling FAMILY bindings), G81 (Grok: physique sliders + EULA), colour-suit 1x2 clip tracked.

## Landed after the digest was first written (same session)
- Cursor U150 parts 2-3 (room double hip push removed; U149 AFTER), Codex C180 (segment tracker,
  works), Codex C181 (Higgsfield loop + 120-credit gate, BUILT not run - client not importable in its
  worktree), Qwen Q158 (muay_thai naming 87.4%), Qwen Q159 (G82 applied: 14 techniques to FAMILY_GAPS,
  79 throws re-seated takedown -> throw; striking FAMILY 120 of 186, 66 remain as the striking
  authoring order), Grok G82 (taxonomy), G83 in flight.
- New animation shown to the operator: Cascy_Turtle (C171) rendered with render_paired_hold - the
  bottom man lies FLAT, not turtled on knees and elbows; it plays as a sprawl over a flattened man.
  OPERATOR VERDICT: 'its bad' - REJECTED. Codex re-authors it from a checked still (C182, next Cascadeur task).

## Operator threads answered this session (see HANDOFF block)
Character Creator generator (offline only, EULA s5), Cascadeur (keep), Higgsfield (370 credits;
13 Seedance clips on disk), suits + split screens (capture, not separation), segment-colour grid
suit (still generated, Codex reviewed, 4 s test clip in flight).

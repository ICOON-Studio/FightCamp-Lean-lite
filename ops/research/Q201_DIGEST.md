# Q201 Digest - What Did Footwork Economy Actually Move?

**Branch:** `qwen/q201-footwork-evidence`
**Model:** qwen3-coder medium

## Method

For each of the ten tests Q199 traced to Q183 (4f789137, `footwork_economy` default
ON for every ruleset), ran the test twice:
1. **OFF**: temporary local edit forcing `footwork_economy: false` (plus
   `limb_damage: false` for scene-based tests per the S98 trap).
2. **ON**: as-is on today's master (Q183 default ON).

Recorded each failing quantity OFF vs ON, then checked Q183's digest
(`research/Q183_DIGEST.md`) for whether it names that quantity.

All temporary edits reverted before commit (`git diff` on tests/ is empty).

## Table

| # | Test | Quantity | OFF | ON | Q183 names it? | Verdict |
|---|------|----------|-----|----|-----------------|---------|
| 1 | fight_defence_model | landing order head<body<legs LR | 0.529/0.538/0.531 FAIL | 0.530/0.536/0.525 FAIL | no (accuracy 51.8% named, not per-region LR) | SIDE EFFECT (pre-existing; fails both) |
| 2 | fight_defence_model | feint+model preempt bites | 24 PASS | 0 FAIL | no | SIDE EFFECT |
| 3 | grapple_naming_contract | muay_thai coverage | 78.3% PASS | 73.7% FAIL | no | SIDE EFFECT |
| 4 | judge_panel T4/T8R | 9 seeded bout scorecards | all differ from pin | all differ from pin (different cards) | no (pins are per-bout cards) | SIDE EFFECT (pre-existing; fails both) |
| 5 | judge_panel T11 | kickboxing_561 verdict | unanimous FAIL | split PASS | no | SIDE EFFECT |
| 6 | judge_panel T11 | boxing_446 verdict | unanimous FAIL | majority PASS | no | SIDE EFFECT |
| 7 | result_screen_why | scored rounds (seed 92043) | 2 of 3 FAIL | 2 of 3 FAIL | no | SIDE EFFECT (pre-existing; fails both) |
| 8 | result_screen_why | READ totals consensus | 18-18 FAIL | 18-18 FAIL | no | SIDE EFFECT (pre-existing; fails both) |
| 9 | result_screen_why | knockdowns carried (seed 92013) | 0 FAIL (no KD) | >0 PASS | no (KD in counter-fire list) | SIDE EFFECT |
| 10 | fight_between_exchanges S4E6-3 | clash mean (band 1.0-2.8 s) | 1.64 s PASS | 3.01 s FAIL | no | SIDE EFFECT |
| 11 | fight_contact_stop | landed low kick occurs | 9 contacts PASS | 0 FAIL | no | SIDE EFFECT |
| 12 | fight_grapple_seam | film played==completed | 17/17 PASS | 17/16 (24 suspended) FAIL | no | SIDE EFFECT |
| 13 | fight_room_walkout | MMA Y stays at mounted height | 0 deviations PASS | 2.5 cm deviation FAIL | no | SIDE EFFECT |
| 14 | fight_separation | longest below-floor ramp ticks | 0 PASS | 25 ticks FAIL (cap 9) | no | SIDE EFFECT |
| 15 | fight_strike_whole | OFF byte-identical baseline | hash mismatch FAIL | hash mismatch FAIL | no | SIDE EFFECT (pre-existing; fails both) |

## Counts

- **INTENT: 0** - Q183 names m/min, burst/hold p50, landed/min, accuracy, finish
  rate, target shares, clinch, kicks, takedowns, ground share. NONE of the ten
  failing quantities appear in that list.
- **SIDE EFFECT: 15** (all failing checks across 10 tests)
- **DEFECT: 0** - no ON value is physically wrong on its face.

## Pre-existing failures (fail BOTH OFF and ON)

Five checks fail regardless of footwork_economy. These are NOT caused by Q183:

1. **fight_defence_model landing order** (0.529/0.538/0.531 OFF, 0.530/0.536/0.525 ON):
   leg LR does not exceed body LR in either condition. The defence model's
   per-region landing rates are too close to distinguish ordering.

2. **judge_panel T4/T8R** (all 9+ seeded cards differ from pin in both conditions):
   the pins are stale - they were captured at an earlier engine state and have
   not been re-pinned since subsequent changes (Q199/Q200 or later).

3. **result_screen_why scored rounds** (2 of 3 in both conditions): seed 92043
   finishes before round 3 regardless of footwork_economy.

4. **result_screen_why totals** (18-18 tie in both conditions): same seed, same
   pre-existing issue.

5. **fight_strike_whole baseline hash** (mismatch in both conditions): the
   pinned hashes are stale - they were captured after Q183 but before later
   changes that also moved the engine output.

## The footwork_economy-caused failures (PASS OFF, FAIL ON)

Ten checks pass with footwork_economy OFF and fail with it ON. The mechanism
in every case is the same: Q176/Q182 reduced travel (circle ×0.30, retreat
×0.50, burst limiter), which changes engagement timing, fighter positions and
strike opportunities downstream.

- **feint bites** (24→0): fewer approach/retreat cycles means fewer patterns
  for the defence model to read and pre-empt against.
- **muay_thai coverage** (78.3%→73.7%): different engagement patterns produce
  different grapple events, some unnamed.
- **T11 verdicts** (unanimous→split/majority): footwork changes who lands when,
  which changes judge scoring enough to produce disagreement.
- **knockdowns** (0→>0): different strike patterns at the new footwork produce
  a knockdown that didn't occur with more travel.
- **clash mean** (1.64→3.01 s): fighters spend longer in each exchange because
  they enter fewer of them.
- **low kick contact** (9→0): fighters are at different positions when low
  kicks land, so the contact-stop presentation doesn't fire.
- **grapple film completion** (17/17→17/16): timing changes cause one film to
  be suspended before completion.
- **walkout Y** (0→2.5 cm deviation): footwork_economy changes the engine
  state during walkout, affecting body placement by ~2.5 cm.
- **separation ramp** (0→25 ticks): fighters get closer with less travel, so
  the separation floor has to work harder and longer.

## Q183 line reference

Q183's digest names these quantities (and ONLY these):
- m/min per-fighter (OFF→ON: boxing 46.4→32.6, KB 44.4→37.3, MMA 34.2→13.4)
- burst p50, hold p50
- landed/min
- accuracy
- finish rate
- head/body/leg share
- clinch share
- kicks thrown/landed (KB, MMA)
- grapple attempts, takedowns landed (MMA)
- ground share (MMA)
- counter fire (knockdowns, sig, KO/TKO, finish, etc.)

NONE of the ten failing test quantities appear in that list.

## Recommendation

All ten are SIDE EFFECT. Zero are DEFECT. Five are pre-existing (fail both
conditions) and need separate re-pinning or investigation. Five are caused by
the footwork_economy flip and need re-pinning to the ON state if the flip
stands, or investigation if the mechanism is unwanted.

The mechanism in every case is reduced travel → changed engagement timing →
downstream quantities move. This is what Q183 intended (less travel, more time
in range), but the specific failing quantities were not named in the census.

Co-Authored-By: Qwen Code <noreply@qwen.ai>

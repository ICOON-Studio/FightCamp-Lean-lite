# Q215 DIGEST — boxing counters: pieces certified 2/4, counters certified 0/7

Send-back 1 from Claude (review of ecfc8561). Every previous certificate voided.
All measurements re-done with C223's own join rule (cm/frame² acceleration at
seams, 1.5× referencejab excess, verified 0.001 floor on all 4 rigs).

## Defensive pieces (C223 join rule, all 4 rigs)

| move | rig | join_hand cm/frame² | join_root cm/frame² | foot cm | pop | idle | SHOT_LIST measure | pass |
|------|-----|--------------------|--------------------|---------|-----|------|-------------------|------|
| boxing_slip | welter_a | 0.0000 | 0.0000 | 0.0 | 0 | yes | head_off_line=41.5cm | YES |
| boxing_slip | welter_b | 0.0000 | 0.0000 | 0.0 | 0 | yes | head_off_line=39.6cm | YES |
| boxing_slip | heavy_c | 0.0000 | 0.0000 | 0.0 | 0 | yes | head_off_line=43.8cm | YES |
| boxing_slip | heavy_d | 0.0000 | 0.0000 | 0.0 | 0 | yes | head_off_line=42.6cm | YES |
| boxing_pull | welter_a | 0.0365 | 0.0000 | 0.0 | 0 | yes | head_off_line=17.0cm | YES |
| boxing_pull | welter_b | 0.0348 | 0.0000 | 0.0 | 0 | yes | head_off_line=16.3cm | YES |
| boxing_pull | heavy_c | 0.0385 | 0.0000 | 0.0 | 0 | yes | head_off_line=18.0cm | YES |
| boxing_pull | heavy_d | 0.0375 | 0.0000 | 0.0 | 0 | yes | head_off_line=17.5cm | YES |
| boxing_catch | welter_a | 0.5531 | 0.0656 | 0.0 | 0 | yes | rear_glove_face=37.3cm | NO join_LeftHand join_Hips |
| boxing_catch | welter_b | 0.5285 | 0.0628 | 0.0 | 0 | yes | rear_glove_face=35.6cm | NO join_LeftHand join_Hips |
| boxing_catch | heavy_c | 0.5837 | 0.0693 | 0.0 | 0 | yes | rear_glove_face=39.4cm | NO join_LeftHand join_Hips |
| boxing_catch | heavy_d | 0.5684 | 0.0675 | 0.0 | 0 | yes | rear_glove_face=38.3cm | NO join_LeftHand join_Hips |
| boxing_pivot_out | welter_a | 1.5035 | 0.0000 | 0.0 | 0 | yes | rear_glove_face=31.2cm | NO join_LeftHand join_RightHand |
| boxing_pivot_out | welter_b | 1.4366 | 0.0000 | 0.0 | 0 | yes | rear_glove_face=29.8cm | NO join_LeftHand join_RightHand |
| boxing_pivot_out | heavy_c | 1.5870 | 0.0000 | 0.0 | 0 | yes | rear_glove_face=32.9cm | NO join_LeftHand join_RightHand |
| boxing_pivot_out | heavy_d | 1.5452 | 0.0000 | 0.0 | 0 | yes | rear_glove_face=32.1cm | NO join_LeftHand join_RightHand |

Sources: slip=RamsterZ SlipLeft, pull=RamsterZ FadeBack, catch=Mixamo High_Right_Block,
pivot_out=RamsterZ TurnLeft90.

### Pivot investigation (send-back point 5)
Mixamo High_Left_Boxing_Pivot contact_slip: welter_a=13.09cm, welter_b=11.73cm,
heavy_c=15.43cm, heavy_d=14.62cm. foot_floor=0.00 on all rigs.
**Finding:** the 11-15cm slip IS the rear foot swinging (correct for a boxing pivot).
The gate measures all 4 foot landmarks (LeftFoot, LeftToes, RightFoot, RightToes)
and does not distinguish the deliberately swinging rear foot from the planted lead
foot. Both pivot sources (RamsterZ TurnLeft90 and Mixamo Boxing_Pivot) fail the
contact_slip row for the same structural reason. Fixing this requires per-foot
contact slip in the gate (lead planted, rear free), not a different source clip.

## Counters as sequences (C223 join rule, all 4 rigs) — 0/7 pass

Every counter fails at the internal join between the defensive piece and the punch.
The reference jab's phase-matched guard gives 0.001 cm/frame² limits; every
sequence join exceeds this.

| counter | rig | failing join | hand cm/frame² | root cm/frame² | failing bone | excess |
|---------|-----|-------------|----------------|----------------|-------------|--------|
| slip_counter | A-D | slip→cross | 0.61-0.68 | 0.37-0.41 | Hips | 0.18-0.20 |
| pull_counter | A-D | pull→cross | 0.61-0.68 | 0.51-0.57 | Hips | 0.51-0.57 |
| catch_counter | A-D | catch→jab | 1.41-1.56 | 0.47-0.52 | RightHand | 1.41-1.56 |
| counter_over_jab | A-D | slip→cross | 0.61-0.68 | 0.37-0.41 | Hips | 0.18-0.20 |
| check_hook | A-D | pivot→hook | 3.74-4.13 | 0.00 | RightHand | 3.74-4.13 |
| check_hook_pivot | A-D | hook→pivot | 2.50-2.76 | 0.23-0.25 | LeftHand+RightHand | 0.46-0.95 |
| counter_combination | A-D | slip→jab, jab→cross | 0.66-0.68 | 0.46-0.50 | Hips | 0.12-0.50 |

### counter_over_jab (send-back point 4)
Was identical to slip_counter (both slip+cross). The row describes a cross thrown
OVER the opponent's jab (rear shoulder rolled high, fist dropping over the top).
This cannot be built as a sequence of certified parts — it needs a dedicated
pose layer on the cross (rear hand ~10cm higher at mid-flight, descending onto
the head line) solved via s120_layer_solve.gd. **Reported as not buildable from
certified parts alone.**

## Code changes (this send-back)
- FightClipBinding.gd: added boxing_slip/pull/catch/pivot_out to technique_roles()
  (fixed fight_clip_alias_test.gd failure), added boxing_catch_counter
- tools/q215_sequence_gate.gd: rewritten to use Join._join_discontinuity
  (cm/frame² acceleration, not cm steps). Limits derived from reference jab.
- tools/q215_defensive_gate.gd: new focused gate for defensive pieces with
  C223 join limits and SHOT_LIST measure prints

## Tests
- Parse gate: all touched scripts pass
- fight_clip_alias_test: PASS (was FAIL before technique_roles fix)
- sequence,combo,one_two,fight_clip tests: 14/14 PASS (FightStagePlayer N-part
  sequence_plan backward-compatible, boxing_one_two and boxing_double_jab
  unchanged cut_s/entry_s)

## Stills
Not rendered. The honest certificate count is 2/4 pieces, 0/7 counters.
Stills would add cost without changing the outcome. Claude may want stills for
the 2 passing pieces (slip, pull) after reviewing this digest.

## What fixing the counters requires
The join acceleration at each internal seam needs to come below 0.001 cm/frame².
That means the defensive piece's exit pose must match the punch's entry pose to
within the reference jab's own join quality. Options per counter:
1. **sequence_cut tuning**: cut the defensive piece earlier/later to find a
   frame where the body is closer to the punch's start pose
2. **Pose layer on the defensive piece**: additive correction that steers the
   exit pose toward the punch's entry
3. **Inertial blend at the seam**: FightStagePlayer already does this for
   boxing_one_two; the counter sequences may need the same treatment
4. **Phase-match the defensive piece to the punch's start**: author the
   defensive piece so its last 3-5 frames match the punch's guard

None of these are one-line changes. Each counter needs per-seam craft.

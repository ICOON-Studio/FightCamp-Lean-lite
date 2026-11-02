# Q122 — CMU Paired-Corpus Contact Census

## Population

Six paired trials from the CMU motion-capture corpus, stored in
`AssetLibrary/cmu_paired/`. Two subjects per trial, captured
simultaneously in one world space:

| Pair | Subjects | Trial | Frames |
|------|----------|-------|--------|
| 18/19_03 | 18/19 | 03 | 592 |
| 18/19_04 | 18/19 | 04 | 405 |
| 18/19_05 | 18/19 | 05 | 438 |
| 18/19_06 | 18/19 | 06 | 407 |
| 22/23_01 | 22/23 | 01 | 782 |
| 22/23_17 | 22/23 | 17 | 832 |

**Bones measured:** `lwrist` and `rwrist` (the hand, distal end of
the radius — the bone our rig's `LeftHand`/`RightHand` is mapped
from) against `lradius` and `rradius` (the elbow, distal end of the
humerus). Both directions count: either man may be the gripper.

## Skeletons Differ

- **18/19_03**: DIFFERENT skeletons confirmed (lhipjoint 0.136 vs 0.135 m, lfemur 0.420 vs 0.423 m, ltibia 0.429 vs 0.461 m).
- **18/19_04**: DIFFERENT skeletons confirmed (lhipjoint 0.136 vs 0.135 m, lfemur 0.420 vs 0.423 m, ltibia 0.429 vs 0.461 m).
- **18/19_05**: DIFFERENT skeletons confirmed (lhipjoint 0.136 vs 0.135 m, lfemur 0.420 vs 0.423 m, ltibia 0.429 vs 0.461 m).
- **18/19_06**: DIFFERENT skeletons confirmed (lhipjoint 0.136 vs 0.135 m, lfemur 0.420 vs 0.423 m, ltibia 0.429 vs 0.461 m).
- **22/23_01**: DIFFERENT skeletons confirmed (lhipjoint 0.136 vs 0.133 m, lfemur 0.413 vs 0.434 m, ltibia 0.441 vs 0.447 m).
- **22/23_17**: DIFFERENT skeletons confirmed (lhipjoint 0.136 vs 0.133 m, lfemur 0.413 vs 0.434 m, ltibia 0.441 vs 0.447 m).

NEVER TEST IDENTICAL: every pair above has been verified with
`cmu_asf_amc.skeletons_differ` — the two subjects in each pair
are different bodies with different bone lengths. Two men built
from the same numbers are not a control group, they are an unreal
population.

## Contact Summary

| Trial | Min (m) | P10 | P50 | P90 | Max | Grip frames | Grip share | Episodes | Longest | Dominant pair | Dom. share |
|-------|---------|-----|-----|-----|-----|-------------|------------|----------|---------|---------------|------------|
| 18/19_03 | 0.239 | 0.262 | 0.290 | 0.339 | 0.926 | 0 | 0.00 | 0 | 0 | none | 0.00 |
| 18/19_04 | 0.283 | 0.294 | 0.307 | 0.338 | 0.851 | 0 | 0.00 | 0 | 0 | none | 0.00 |
| 18/19_05 | 0.141 | 0.156 | 0.196 | 1.021 | 1.316 | 222 | 0.51 | 2 | 221 | A.rwrist->B.lradius | 1.00 |
| 18/19_06 | 0.121 | 0.134 | 0.165 | 0.523 | 0.594 | 307 | 0.75 | 1 | 307 | A.rwrist->B.rradius | 1.00 |
| 22/23_01 | 0.152 | 0.172 | 0.302 | 0.892 | 1.506 | 129 | 0.16 | 4 | 82 | B.rwrist->A.rradius | 0.49 |
| 22/23_17 | 0.099 | 0.126 | 0.152 | 0.283 | 0.774 | 643 | 0.77 | 2 | 620 | B.rwrist->A.rradius | 0.60 |

## Analysis

### Trials with no contact

- **18/19_03**: zero frames at ≤ 0.20 m (min separation 0.239 m).
- **18/19_04**: zero frames at ≤ 0.20 m (min separation 0.283 m).

These are the **control trials** — they prove the measure discriminates.

### Does the contact chatter?

- **18/19_05**: 2 episode(s), longest 221 frames — the contact is sustained, not a flicker.
- **18/19_06**: 1 episode(s), longest 307 frames — the contact is sustained, not a flicker.
- **22/23_01**: 4 episode(s), longest 82 frames — the contact is sustained, not a flicker.
- **22/23_17**: 2 episode(s), longest 620 frames — the contact is sustained, not a flicker.

### Does the gripping limb swap?

- **18/19_05**: dominant pair share 1.00 — one stable grip on A.rwrist->B.lradius.
- **18/19_06**: dominant pair share 1.00 — one stable grip on A.rwrist->B.rradius.
- **22/23_01**: dominant pair share 0.49 — the contact WANDERS between limbs. The grip is not stable on one arm chain.
- **22/23_17**: dominant pair share 0.60 — one stable grip on B.rwrist->A.rradius.

### Fixture recommendation for S37

**Recommended fixture: 22/23_17**

- 643 frames in contact (77% of 832)
- Minimum separation: 0.099 m
- 2 episode(s), longest 620 frames — sustained hold
- Dominant grip: B.rwrist->A.rradius (60% of grip frames) — stable arm chain

Ranking of trials with contact:
1. 22/23_17 — 643 grip frames, min 0.099 m, 2 episodes, dom. share 0.60
2. 18/19_06 — 307 grip frames, min 0.121 m, 1 episodes, dom. share 1.00
3. 18/19_05 — 222 grip frames, min 0.141 m, 2 episodes, dom. share 1.00
4. 22/23_01 — 129 grip frames, min 0.152 m, 4 episodes, dom. share 0.49

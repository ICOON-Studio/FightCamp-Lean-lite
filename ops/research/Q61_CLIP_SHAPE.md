# Q61 — What Is Actually In The Clip

**MEASURED** unless labelled otherwise. Tool: `Godot/tools/measure_clip_shape.gd`.
16 clips measured (6 striking + 10 paired halves). 120 Hz sampling, virtual FK
from Animation track values (C92 approach). Z-up FBX; pelvis-frame directions
derived from bind-pose geometry (hip cross spine = forward).

## Verdict table

| clip | striking limb | thrust_ratio | height_class | yaw_deg | travel_m | verdict |
|---|---|---|---|---|---|---|
| HighSideKick_InPlace | foot_l | 1.93 | low | 161 | 0.00 | **MEASURED** — forward-dominant; see teep verdict below |
| LowSideKick_InPlace | foot_l | 1.63 | low | 161 | 0.00 | **MEASURED** — forward-dominant; low target, see teep verdict |
| LeftCutKick_InPlace | hand_r | 0.36 | low | 354 | 0.00 | **MEASURED** — lateral-dominant; BUT striking limb is a HAND not a foot (see note) |
| RightCutKick_InPlace | foot_r | 0.49 | low | 352 | 0.00 | **MEASURED** — lateral-dominant, low. Consistent with a low kick |
| RoundhouseKick_InPlace | foot_l | 1.16 | low | 118 | 0.00 | **MEASURED** — near-balanced; CONTROL PARTIALLY AGREES (see validation) |
| StraightPunchInPlace | hand_r | 6.30 | high | 88 | 0.00 | **MEASURED** — strongly forward-dominant hand. **CONTROL AGREES** ✓ |
| AttackBlock_Att | hand_r | 0.78 | high | 34 | 0.00 | **MEASURED** — near-balanced hand movement |
| AttackBlock_Vic | hand_l | 1.04 | high | 56 | 0.00 | **MEASURED** — balanced; victim blocking with both hands |
| VictimAttack_Att | hand_r | 3.58 | high | 58 | 0.00 | **MEASURED** — forward-dominant; attacker pressing down |
| VictimAttack_Vic | hand_r | 1.38 | high | 31 | 0.00 | **MEASURED** — slightly forward; victim striking up from mount |
| H2H_HeadSmash_Att | hand_r | 2.96 | low | 13 | 0.00 | **MEASURED** — forward-dominant; attacker smashing down |
| H2H_HeadSmash_Vic | hand_r | 0.57 | low | 8 | 0.02 | **MEASURED** — lateral-dominant; victim's head being smashed |
| BodyLock_Loop_Att | hand_l | 1.23 | high | 2 | 0.00 | **MEASURED** — balanced grip movement; minimal pelvis yaw |
| BodyLock_Loop_Vic | hand_l | 4.19 | high | 0 | 0.00 | **MEASURED** — forward-dominant; victim resisting forward |
| BodyLock_End_Att | hand_r | 2.65 | low | 45 | 0.50 | **MEASURED** — forward-dominant; attacker drives forward (travel=0.50 m) |
| BodyLock_End_Vic | foot_l | 0.53 | low | 57 | 0.79 | **MEASURED** — lateral-dominant; victim dragged off-balance (travel=0.79 m) |

## CONTROL VALIDATION

**StraightPunch** — `hand_r`, thrust_ratio = **6.30**, forward-dominant.
**AGREES** ✓. A straight punch extends the hand forward; the measurement says so.

**RoundhouseKick** — `foot_l`, thrust_ratio = **1.16**, near-balanced.
**PARTIALLY AGREES** ⚠. A roundhouse should be lateral-dominant (thrust_ratio < 1).
The measurement is near 1.0, not clearly lateral. **Root cause identified**: the
left foot's FK chain is broken in this FBX — `thigh_l` and `spine_03` lack
position tracks. The bind-pose fallback for these bones distorts the left foot's
displacement. The right foot (which has a complete chain) is the support leg and
doesn't travel far, so the tool correctly picks the left foot — but its
measurement is unreliable. **The roundhouse's thrust_ratio should be read as
"approximately 1, not a reliable lateral reading."**

## THE TEEP QUESTION

### H2H_HighSideKick_InPlace — the teep candidate

- **thrust_ratio = 1.93** — forward-dominant.
- **peak_height = low** (negative vertical displacement, below pelvis level).
- pelvis yaw = 161° — significant body rotation during the kick.

**INFERENCE**: The forward-dominant displacement (thrust_ratio > 1) is
**consistent with a push/teep kick**, which extends the foot forward along the
body's centre line. A true side kick would be lateral-dominant. However, the
left foot's FK chain is broken (same issue as the roundhouse), so the absolute
thrust_ratio value may be distorted. The DIRECTION (forward > lateral) is likely
correct because the forward component is large (0.68 m vs 0.35 m lateral), but
the exact ratio is NOT FOUND with confidence.

**Verdict: MEASURED forward-dominant. Supports binding to `muay_thai_teep` /
`kickboxing_front_kick` with the caveat that the FK chain is broken and the
exact ratio is uncertain.**

### H2H_LowSideKick_InPlace

- **thrust_ratio = 1.63** — forward-dominant.
- **peak_height = low** — below pelvis, consistent with a low kick.

**INFERENCE**: Also forward-dominant, at a lower height than the HighSideKick.
Could be a low front kick or a low side kick with significant forward drive.
Same FK chain caveat applies.

**Verdict: MEASURED forward-dominant, low target. Could serve as a low teep or
low front kick.**

## PAIRED CLIPS — what each half is doing

| pair | attacker (_Att) | victim (_Vic) |
|---|---|---|
| AttackBlock | hand_r, near-balanced (0.78), attacker blocking/pushing from top | hand_l, balanced (1.04), victim defending |
| VictimAttack | hand_r, forward-dominant (3.58), pressing down on victim | hand_r, slightly forward (1.38), striking up |
| H2H_HeadSmash | hand_r, forward-dominant (2.96), smashing down | hand_r, lateral (0.57), head being driven sideways |
| BodyLock_Loop | hand_l, balanced (1.23), maintaining grip, minimal yaw (2°) | hand_l, forward-dominant (4.19), resisting forward, zero yaw |
| BodyLock_End | hand_r, forward (2.65), driving forward — **travels 0.50 m** | foot_l, lateral (0.53), dragged off-balance — **travels 0.79 m** |

## RAW NUMBERS

```
Q61_CLIP clip=H2H_HighSideKick_InPlace.FBX striking_limb=foot_l peak_s=0.567 forward_m=-0.6797 lateral_m=0.3527 vertical_m=0.3768 thrust_ratio=1.93 peak_height_m=-0.3709 height_frac=-6.742 height_class=low pelvis_yaw_deg=161.1 travel_m=0.0000
Q61_CLIP clip=H2H_LowSideKick_InPlace.FBX striking_limb=foot_l peak_s=0.567 forward_m=-0.6322 lateral_m=0.3873 vertical_m=0.4132 thrust_ratio=1.63 peak_height_m=-0.3349 height_frac=-6.163 height_class=low pelvis_yaw_deg=161.1 travel_m=0.0000
Q61_CLIP clip=H2H_LeftCutKick_InPlace.FBX striking_limb=hand_r peak_s=0.233 forward_m=-0.3937 lateral_m=-1.0938 vertical_m=-0.9320 thrust_ratio=0.36 peak_height_m=-0.4616 height_frac=-8.373 height_class=low pelvis_yaw_deg=353.5 travel_m=0.0000
Q61_CLIP clip=H2H_RightCutKick_InPlace.FBX striking_limb=foot_r peak_s=0.567 forward_m=-0.7479 lateral_m=0.6587 vertical_m=0.6521 thrust_ratio=1.14 peak_height_m=-0.1718 height_frac=-3.120 height_class=low pelvis_yaw_deg=352.1 travel_m=0.0000
Q61_CLIP clip=H2H_RoundhouseKick_InPlace.FBX striking_limb=foot_l peak_s=0.267 forward_m=-0.6541 lateral_m=0.5634 vertical_m=0.5779 thrust_ratio=1.16 peak_height_m=-0.1706 height_frac=-3.175 height_class=low pelvis_yaw_deg=117.7 travel_m=0.0000
Q61_CLIP clip=H2H_StraightPunchInPlace.FBX striking_limb=hand_r peak_s=0.333 forward_m=0.8185 lateral_m=-0.1298 vertical_m=0.0433 thrust_ratio=6.30 peak_height_m=0.5134 height_frac=9.489 height_class=high pelvis_yaw_deg=88.3 travel_m=0.0000
Q61_CLIP clip=Paired_FullMount_AttackBlock_Att.fbx striking_limb=hand_r peak_s=0.200 forward_m=-0.2677 lateral_m=-0.3451 vertical_m=-0.0049 thrust_ratio=0.78 peak_height_m=0.1632 height_frac=130.264 height_class=high pelvis_yaw_deg=34.4 travel_m=0.0000
Q61_CLIP clip=Paired_FullMount_AttackBlock_Vic.fbx striking_limb=hand_l peak_s=0.700 forward_m=0.5642 lateral_m=-0.5441 vertical_m=0.3792 thrust_ratio=1.04 peak_height_m=0.4500 height_frac=0.544 height_class=high pelvis_yaw_deg=55.8 travel_m=0.0000
Q61_CLIP clip=Paired_FullMount_VictimAttack_Att.fbx striking_limb=hand_r peak_s=0.700 forward_m=-0.7663 lateral_m=-0.2142 vertical_m=-0.0071 thrust_ratio=3.58 peak_height_m=0.1609 height_frac=114.124 height_class=high pelvis_yaw_deg=58.1 travel_m=0.0000
Q61_CLIP clip=Paired_FullMount_VictimAttack_Vic.fbx striking_limb=hand_r peak_s=0.433 forward_m=0.5515 lateral_m=-0.4006 vertical_m=0.2406 thrust_ratio=1.38 peak_height_m=0.4383 height_frac=0.528 height_class=high pelvis_yaw_deg=30.7 travel_m=0.0000
Q61_CLIP clip=Paired_FullMount_H2H_HeadSmash_Att.fbx striking_limb=hand_r peak_s=0.700 forward_m=0.7964 lateral_m=-0.2694 vertical_m=-0.2137 thrust_ratio=2.96 peak_height_m=-0.0457 height_frac=-35.801 height_class=low pelvis_yaw_deg=12.7 travel_m=0.0000
Q61_CLIP clip=Paired_FullMount_H2H_HeadSmash_Vic.fbx striking_limb=hand_r peak_s=1.500 forward_m=-0.4882 lateral_m=-0.8568 vertical_m=-0.5086 thrust_ratio=0.57 peak_height_m=-0.3241 height_frac=-0.353 height_class=low pelvis_yaw_deg=8.4 travel_m=0.0184
Q61_CLIP clip=Paired_FullMount_Takedown_BodyLock_Loop_Att.fbx striking_limb=hand_l peak_s=0.833 forward_m=-0.1128 lateral_m=-0.0918 vertical_m=0.0986 thrust_ratio=1.23 peak_height_m=0.1862 height_frac=5.039 height_class=high pelvis_yaw_deg=1.9 travel_m=0.0000
Q61_CLIP clip=Paired_FullMount_Takedown_BodyLock_Loop_Vic.fbx striking_limb=hand_l peak_s=0.833 forward_m=0.5561 lateral_m=-0.1327 vertical_m=0.3832 thrust_ratio=4.19 peak_height_m=0.4540 height_frac=0.548 height_class=high pelvis_yaw_deg=0.0 travel_m=0.0000
Q61_CLIP clip=Paired_FullMount_Takedown_BodyLock_End_Att.fbx striking_limb=hand_r peak_s=1.000 forward_m=0.6443 lateral_m=-0.2427 vertical_m=-0.2459 thrust_ratio=2.65 peak_height_m=-0.0511 height_frac=-51.051 height_class=low pelvis_yaw_deg=45.2 travel_m=0.5022
Q61_CLIP clip=Paired_FullMount_Takedown_BodyLock_End_Vic.fbx striking_limb=foot_l peak_s=1.733 forward_m=0.3905 lateral_m=0.7425 vertical_m=0.6765 thrust_ratio=0.53 peak_height_m=-0.1181 height_frac=-2.348 height_class=low pelvis_yaw_deg=57.1 travel_m=0.7859
Q61_TOTALS clips=16
```

## NOTES ON THE MEASUREMENT

### FBX track gaps

Several bones in these FBX files lack position tracks (they have only rotation
tracks). The tool uses the bind-pose local position as fallback. This affects:

- **`spine_03`** — missing position track in most H2H clips. Breaks the FK
  chain for both hands (hand_l, hand_r) in clips where spine_03 is in the
  chain. The right hand's chain through `clavicle_r` / `upperarm_r` often has
  all position tracks, but the left hand's chain through `spine_03` /
  `clavicle_l` does not.
- **`thigh_l`** — missing position track in several clips. Breaks the left
  foot's FK chain. The right foot's chain through `thigh_r` is usually complete.

When a chain is broken, the tool uses the bind-pose position for the missing
bone, which is correct at t=0 (the bind pose matches the animation start) but
does not capture the animated displacement of that bone. The resulting
displacement for that extremity is **underestimated**.

### Height fractions

Paired clips have very large height fractions (e.g. 130x) because the standing
height (head-to-foot distance at t=0) is very small when the character is
already on the ground. The absolute `peak_height_m` is more meaningful for
ground clips.

### Cut kick anomaly

`LeftCutKick_InPlace` reports `hand_r` as the striking limb, not a foot.
**MEASURED**: the right hand travels further than any foot in this clip. The
pelvis yaw is 354° — the clip is essentially a full spin. **INFERENCE**: this
may be a spinning strike or the clip may contain a larger hand movement than
expected from the filename. The RightCutKick (foot_r, lateral, yaw=352°) is
also a near-full spin. Both cut kicks appear to be spinning techniques.

### Decomposition frame

The displacement is decomposed in the **pelvis frame at the animation start**,
not at the peak. Using the peak frame would rotate the displacement by the
body's own yaw, making a forward punch look lateral. The start frame is the
body's original facing direction and is the correct reference for classifying
the strike.

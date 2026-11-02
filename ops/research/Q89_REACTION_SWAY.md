## DECISIONS

First delivery `d153559` subtracted the FBX root's horizontal origin from every bone; this resent removes that subtraction so each bone's origin is the plain global from `Retarget._to_ours(Retarget._globals(...))`. The source skate dropped to near zero (feet planted in the source clips), while the pinned skate stayed high (hips sway while feet planted) - the vendor stores the reaction's sway in the root, and the first delivery zeroed it.

| take | source skate (m/s) | pinned skate (m/s) | hips speed planted (m/s) | hips travel end/max (m) |
|---|---|---|---|---|
| jab | 0.396 | 0.548 | 0.559 | 0.001 / 0.244 |
| cross | 0.003 | 0.245 | 0.244 | 0.001 / 0.118 |
| hook_rear | 0.217 | 0.944 | 0.969 | 0.000 / 0.508 |
| react_head | 0.007 | 0.854 | 0.853 | 0.006 / 0.171 |
| react_head#1 | 0.007 | 0.702 | 0.703 | 0.003 / 0.205 |
| react_head#2 | 0.026 | 0.682 | 0.680 | 0.000 / 0.172 |
| react_head#3 | 0.049 | 0.851 | 0.881 | 0.000 / 0.338 |
| react_body | 0.003 | 0.937 | 0.937 | 0.698 / 0.722 |
| react_body#1 | 0.172 | 0.758 | 0.857 | 0.709 / 0.897 |
| react_body#2 | 0.026 | 0.553 | 0.559 | 0.353 / 0.423 |
| react_body#3 | 0.077 | 0.826 | 0.828 | 1.066 / 1.151 |
| react_body#4 | 0.089 | 0.987 | 1.004 | 1.138 / 1.190 |
| react_body#5 | 0.031 | 1.158 | 1.167 | 1.377 / 1.442 |
| react_body#6 | 0.107 | 1.042 | 1.135 | 1.315 / 1.315 |
| react_leg | 0.320 | 0.751 | 0.551 | 0.836 / 1.046 |
| knockdown | 0.023 | 0.966 | 0.970 | 0.763 / 0.795 |
| knockdown#1 | 0.111 | 0.562 | 0.609 | 1.013 / 1.013 |
| idle | 0.003 | 0.010 | 0.009 | 0.000 / 0.013 |
| loc_advance | 1.841 | 1.844 | 0.089 | 0.000 / 0.045 |
| loc_retreat | 1.841 | 1.844 | 0.092 | 0.007 / 0.044 |
| slip | 0.018 | 0.615 | 0.613 | 0.000 / 0.127 |
| slip#1 | 0.008 | 0.316 | 0.314 | 0.000 / 0.093 |
| slip#2 | 0.005 | 0.623 | 0.622 | 0.000 / 0.177 |
| block | 0.004 | 0.511 | 0.511 | 0.173 / 0.179 |
| hook_lead | 0.217 | 0.944 | 0.969 | 0.000 / 0.508 |
| boxing_double_jab | 0.396 | 0.548 | 0.559 | 0.001 / 0.244 |
| boxing_overhand | 0.002 | 0.593 | 0.592 | 0.000 / 0.186 |
| muay_thai_round_kick | 0.003 | 1.600 | 1.599 | 0.000 / 0.523 |
| kickboxing_roundhouse | 0.003 | 1.600 | 1.599 | 0.000 / 0.523 |
| muay_thai_switch_kick_body | 0.003 | 1.600 | 1.599 | 0.000 / 0.523 |
| kickboxing_body_kick | 0.003 | 1.600 | 1.599 | 0.000 / 0.523 |
| muay_thai_straight_knee | 0.842 | 1.983 | 2.307 | 1.979 / 1.979 |
| kickboxing_low_kick | 0.325 | 1.699 | 1.692 | 0.000 / 0.745 |
| strike_body | 0.003 | 0.245 | 0.244 | 0.001 / 0.118 |
| strike_leg | 0.593 | 1.342 | 1.374 | 0.000 / 0.617 |

## Per-role verdicts

Take-count-weighted mean pinned skate (weight = planted steps per take) beside
the room's R3 measurement at `d02757d`.

| role | takes | weighted pinned skate (m/s) | room R3 (m/s) | verdict |
|---|---|---|---|---|
| react_head | 4 | 0.746 | 0.74 | SWAY |
| react_body | 7 | 0.893 | 0.88 | SWAY |
| slip | 3 | 0.504 | 0.58 | SWAY |
| hook_lead | 1 | 0.944 | 0.85 | PERFORMANCE |
| idle | 1 | 0.010 | 0.04 | CLEAN |

**react_head** — source skate 0.007 m/s (feet planted in the source), pinned skate 0.746 m/s: the hips sway while the feet stay put. SWAY.

**react_body** — source skate 0.003 m/s (feet planted), pinned skate 0.893 m/s: same pattern, the hips travel horizontally while the feet stay planted. SWAY. The first take (StaggerSmall01 0-1 s) reads Hips XZ max 0.722 m, matching the independent probe.

**slip** — source skate 0.018 m/s (feet planted), pinned skate 0.504 m/s: the hips travel horizontally while the feet stay put. SWAY.

**hook_lead** — source skate 0.217 m/s (some foot travel in the source), pinned skate 0.944 m/s: the performer steps and slides during the hook. PERFORMANCE.

**idle** — both under 0.10 m/s. CLEAN.

## Closing

Does the pinned skate explain the room's react_head and react_body numbers (within a factor of two)? **Yes.** react_head pinned 0.746 m/s vs room 0.74 m/s (ratio 1.01); react_body pinned 0.893 m/s vs room 0.88 m/s (ratio 1.01). The room's numbers are the hips' sway while the feet stay planted in the source clips.

The first delivery subtracted the FBX root's horizontal origin from every bone, which zeroed the reaction's root sway and reported the performer's own foot slide as the skate. This resent removes that subtraction so each bone's origin is the plain global from `Retarget._to_ours(Retarget._globals(...))`, revealing the vendor's stored sway in the root.

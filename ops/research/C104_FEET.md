DECISIONS

The foot error is predominantly motion, not a static rest offset: the pooled
constant is 0.032 deg left / 0.028 deg right, while motion is 13.612 deg /
17.142 deg. The rest-delta correlation is recorded in C104_feet.json.

| relation | on mean / median | feet-local mean / median | feet-parent mean / median |
|---|---:|---:|---:|
| chest_pelvis | 3.206 / 1.012 | 3.101 / 1.056 | 3.065 / 1.012 |
| left_foot_pelvis | 7.546 / 0.920 | 2.111 / 0.971 | 2.076 / 0.920 |
| right_foot_pelvis | 10.342 / 0.812 | 2.854 / 0.866 | 2.815 / 0.812 |
| head_chest | 2.360 / 10.863 | 32.042 / 10.866 | 32.041 / 10.863 |

The bend means are derived from the C102 baseline for `on` and measured for
the two feet variants, `on_feet_local` and `on_feet_parent`. The feet-local and feet-parent results are identical
to 0.01 deg here, so the Tripo rests are effectively identity-parented and the
frame does not matter. Recommended production recipe: use the five-limb
parent-frame rest pass, retaining the existing non-foot C102 correction.

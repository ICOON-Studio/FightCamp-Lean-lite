# Q213B run 3 — clipping source corrections, 2026-10-03

The three requested failures are fixed on `codex/q213b-last-three`, resumed from
`ceb04637`. The unchanged pinned gate prints:

```text
Q213_GATE PASS population=clips_boxing_exact_pin moves=26 pass=26 fail=0
```

**Coverage caveat: this is not yet an honestly verified 26-move pass.** The existing
gate skips four moves on every rig because its certificate filename filter misses
their certificates, then reports their empty trackers as PASS. Actual execution is
22 moves x 4 pairings = 88 move/pair runs. All 22 executed moves pass; the original
19 measured passing moves remain passing. The task's nominal 23 passing moves
included these four empty trackers. There are 16 missing-certificate errors in
both the untouched baseline and the final run, not new runtime errors introduced
by the fixes.

## Required decision about coverage

The task's owned-file restriction says `q213_clip_gate.gd` is for
"diagnostic-print additions only, not the thresholds". Permission to repair the
certificate lookup and fail missing measurements was requested during this run;
no answer has arrived. The gate's selection, thresholds, measurements and verdict
logic have therefore not been changed.

| Unmeasured move | Existing certificate excluded by the filter |
| --- | --- |
| boxing_inside_uppercut | `docs/previews/c223/c231_inside_uppercut.json` |
| boxing_liver_combo | `docs/previews/c223/s135_chains.json` |
| boxing_one_two_hook | `docs/previews/c223/s135_chains.json` |
| boxing_six_punch_combo | `docs/previews/c223/s135_chains.json` |

The filter accepts `run*.json`, or `s1*.json` containing `bound` or `counter`.
The concrete remaining work is to admit the missing certificates without silently
changing the existing 22 fixtures, make absent measurements fail, then run all 26
with real coverage. Newly exercised moves may expose additional defects; do not
declare those four certified by this report.

## Measured cause and fix

| Move | Baseline failing events | Baseline failing pair/frame | Final failing events | Final worst reported cm |
| --- | ---: | --- | ---: | ---: |
| boxing_one_two | 1 | cross right forearm > receiver left upper arm, frame 59 / 0.983 s; cross source time 0.300 s; 8.84 cm | 0 | 2.29 |
| boxing_rear_hook | 3 | lead thigh > lead thigh near the knees, frame 11 / 0.183 s; 3.64 cm | 0 | 11.25 |
| boxing_shovel_hook | 8 | lead thigh > lead thigh at the knees, recovery; baseline worst frame 48 / 0.800 s, 9.30 cm | 0 | 0.00 |

The rear hook's 11.25 cm ARM peak is too brief to fail the event gate. Its actual
failing events were LEG, contrary to the brief's inference from the largest
depth. The existing shovel binding already contains the S121 elbow-tuck/rising
forearm correction; the older S120 identity criticism is not the current source.

- `FightClipBinding.gd`: cross upper-arm additive rotation `[20,0,10]` over
  0.10–0.50 s, at full weight 0.28–0.34 s. This also covers the cross used by the
  one-two. Other executed cross consumers remain passing.
- `FightClipFootPlant.gd`: optional, authored `knee_swivel` on an individual
  `foot_lock`. After the existing two-bone solve, rotate both leg bases about the
  solved hip-to-ankle line and preserve the foot's world basis. No setting means
  exactly the old path. No engine constant or contact solver changed.
- Rear hook: -18 degrees, 0.03–0.65 s, full weight 0.18–0.33 s.
- Shovel hook: -82 degrees, 0–0.89333 s, full weight 0.15–0.82 s. The scalar is a
  bend-plane swivel, not a knee flexion angle. The source folds its knee inward;
  a small negative swivel first carries that knee forward through the receiver.

Rejected thigh-only layers changed the ankle and worsened the shovel overlap.
The authoring comparison sampled the worst heavyweight pairing over four receiver
idle phases. A 0.20 m foot-anchor change cleared it but displaced the foot about
22 cm. A -75 degree swivel still peaked at 2.46 cm for five frames; -90 cleared
it while the later floor bake changed the foot path by about 2.32 cm. The bounded
-82 candidate then passed the authoritative full gate. Those authoring probes
are diagnostic, not substitutes for the full carried-state population.

## Visual check

The hidden `q213b_pose_review.gd` render was opened through the file image tool,
at 0.400 and 0.800 s. No obvious joint collapse was seen in these two source-pose
samples. This is not a full-speed animation certificate. Local image:
`scratch/q213b_shovel_review.png`. No viewer or window was opened on the operator's
screens.

## Verification

- Final parse: `CHECK total=6 fails=0 autoload_refs=0 autoload_warnings=0`.
- Final pinned gate: 26/26 printed, 22/22 actually measured; see coverage caveat.
- Final unpinned gate: `moves=26 pass=10 fail=16`, with the same four skipped
  trackers. The shipping glove pin is still required; no claim of an unpinned
  pass. The one-two's unpinned worst overlap increased from 15.15 to 23.87 cm
  (15 to 17 failing events), while its pinned result improved to PASS. Rear hook:
  9 unpinned events / 20.19 cm; shovel: 4 / 9.62 cm, now ARM rather than LEG.
- Required move/certified selection, `--jobs 2`: `SUITE total=1 fails=0` (only
  `certified_palette_test.gd` matches; this validates palette provenance and
  consumers, not a new full mechanical animation certificate).
- Clipping-gate contract selection, `--jobs 2`: `SUITE total=1 fails=0`.
- Final 82-degree geometric check: four checks PASS, `failures=0`, worst foot
  position error 0.00000004 m, basis-vector error 0.00000019, outward knee movement
  0.1981 m, join error 0. These are a controlled geometric fixture; the separate
  production floor bake can adjust a real rig's foot path, as the authoring
  comparison above measured.
- `git diff --check` passed for the changed production and gate scripts.

The watchdog was chained with `&&` before each heavy step. One RED reading
(87 C / 100% CPU) paused only this run's Godot process; it resumed after cooling,
preserving its work. AMBER launches continued. No simultaneous owned Godot jobs.
No full suite. No `.import` file or `HANDOFF.md` edited or staged. The generic
fetch/rebase intake was set aside to resume the explicit checkpoint safely in a
worktree containing import noise.

## Reproduction and local evidence

```text
python Godot/tools/check_scripts.py Godot/scripts/FightClipBinding.gd Godot/scripts/FightClipFootPlant.gd Godot/tools/q213_clip_gate.gd Godot/tools/q213b_knee_check.gd Godot/tools/q213b_shovel_solve.gd Godot/tools/q213b_pose_review.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once && powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q213_clip_gate.gd -- mode=clips pin=1
```

Run the second command from `cmd` (Windows PowerShell 5 does not support `&&`).
Omit `pin=1` for the comparison. `trace_pose=1` adds source-track poses and failing
event windows; it does not change the measurement. Authoring and geometric helpers
are `q213b_shovel_solve.gd`, `q213b_pose_review.gd`, `q213b_knee_check.gd`.

Local raw logs are in `scratch/q213b_run3_baseline_pin.log`,
`scratch/q213b_run3_final_pin.log`, `scratch/q213b_run3_final_unpinned.log`, and
`scratch/q213b_run3_solve.log`. Only the digest and owned source/helper files ship.

## Final pinned raw move table

The four empty-tracker PASS rows below are unmeasured, as identified above.

```text
Q213_CLIP_MOVE boxing_body_hook               failing=0 worst_cm=0.00 spacing=1.5625 PASS
Q213_CLIP_MOVE boxing_catch                   failing=0 worst_cm=0.00 spacing=1.2300 PASS
Q213_CLIP_MOVE boxing_check_hook              failing=0 worst_cm=0.00 spacing=0.9700 PASS
Q213_CLIP_MOVE boxing_counter_over_jab        failing=0 worst_cm=0.00 spacing=1.2075 PASS
Q213_CLIP_MOVE boxing_cross                   failing=0 worst_cm=0.00 spacing=1.2950 PASS
Q213_CLIP_MOVE boxing_cross_body              failing=0 worst_cm=0.00 spacing=1.2525 PASS
Q213_CLIP_MOVE boxing_double_jab              failing=0 worst_cm=0.00 spacing=1.0600 PASS
Q213_CLIP_MOVE boxing_inside_uppercut         failing=0 worst_cm=0.00 PASS
Q213_CLIP_MOVE boxing_jab                     failing=0 worst_cm=0.00 spacing=1.0950 PASS
Q213_CLIP_MOVE boxing_jab_body                failing=0 worst_cm=0.00 spacing=1.7075 PASS
Q213_CLIP_MOVE boxing_lead_hook               failing=0 worst_cm=0.00 spacing=0.8900 PASS
Q213_CLIP_MOVE boxing_lead_uppercut           failing=0 worst_cm=0.00 spacing=0.8620 PASS
Q213_CLIP_MOVE boxing_liver_combo             failing=0 worst_cm=0.00 PASS
Q213_CLIP_MOVE boxing_one_two                 failing=0 worst_cm=2.29 spacing=1.0600 pairs= PASS
Q213_CLIP_MOVE boxing_one_two_hook            failing=0 worst_cm=0.00 PASS
Q213_CLIP_MOVE boxing_overhand                failing=0 worst_cm=0.00 spacing=1.2075 PASS
Q213_CLIP_MOVE boxing_pull                    failing=0 worst_cm=0.00 spacing=1.2300 PASS
Q213_CLIP_MOVE boxing_pull_counter            failing=0 worst_cm=0.00 spacing=1.2950 PASS
Q213_CLIP_MOVE boxing_rear_hook               failing=0 worst_cm=11.25 spacing=0.7285 pairs= PASS
Q213_CLIP_MOVE boxing_rear_hook_body          failing=0 worst_cm=2.67 spacing=0.8322 PASS
Q213_CLIP_MOVE boxing_rear_uppercut           failing=0 worst_cm=0.00 spacing=1.3150 PASS
Q213_CLIP_MOVE boxing_shovel_hook             failing=0 worst_cm=0.00 spacing=0.8175 pairs= PASS
Q213_CLIP_MOVE boxing_six_punch_combo         failing=0 worst_cm=0.00 PASS
Q213_CLIP_MOVE boxing_slip                    failing=0 worst_cm=0.00 spacing=1.2300 PASS
Q213_CLIP_MOVE boxing_slip_counter            failing=0 worst_cm=0.00 spacing=1.2950 PASS
Q213_CLIP_MOVE boxing_up_jab                  failing=0 worst_cm=0.00 spacing=1.0950 PASS
Q213_GATE PASS population=clips_boxing_exact_pin moves=26 pass=26 fail=0
```

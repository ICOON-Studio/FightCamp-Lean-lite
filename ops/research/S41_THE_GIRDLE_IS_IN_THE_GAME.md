# S41 — the girdle fix is on the shipped path, and the first re-baseline was a tautology

**The stage was "add `Spine->Chest`, `LeftShoulder->LeftUpperArm` and
`RightShoulder->RightUpperArm` to `SILHOUETTE_SEGMENTS` and re-baseline". The
three lines were the easy half. The re-baseline took two instruments, because
the obvious one could not move.**

`FightClipRetarget.SILHOUETTE_SEGMENTS` goes from 13 segments to 16.

## 1. The gate, and every S40 number reproduces

`probe_cmu_grip.gd -- fixture=22/23_17`, before and after:

| arm | p0 | p50 |
|---|---|---|
| `plain` **before** | +56.9% | +59.7% |
| `plain` **after** | **+56.9%** | **+59.7%** |
| `silhouette=1` before | +23.7% | +25.6% |
| `silhouette=1` **after** | **−10.7%** | **−3.0%** |
| `girdle=1` before | −10.7% | −3.0% |

`plain` is untouched because it reads `build_corrections`, which S41 does not
change — so S39 and S40 stay reproducible from the same file. The four S40
regression numbers all hold: `SOURCE p0 0.294`, `RETARGET min=0.461`,
`contact min=0.099`, `DRIFT p0 +56.9%`.

`silhouette=1` now reads exactly what `girdle=1` read before, and the two arms
are now identical by construction — `GIRDLE_SEGMENTS` in `probe_cmu_grip.gd` is
kept as the historical control, not as a live alternative.

## 2. THE FIRST RE-BASELINE PASSED AND PROVED NOTHING

Q126 (Qwen, on a pinned `6787d327`, before the change) took `pair_gap_report.gd`
over all nine `PAIRED_BINDINGS` keys. Re-run after the change, all nine came
back **byte-identical to six decimals** — `Tools/s41_pairgap_diff.py` reports
`compared=9 moved=0 fails=0`.

**That is a tautology, not a result.** `pair_gap_report.gd` measures HIPS TO
HIPS. All three added segments re-aim `Spine`, `LeftShoulder` or
`RightShoulder` — every one of them BELOW `Hips` in the chain — so the hip
positions could not have moved whatever the change did. A control fixture that
cannot fail has not passed.

The diff script is kept and committed anyway: it is the right check against the
`Hips` *placement* path, and it asserts its own denominator (both sides must
yield the same non-empty key set) so it cannot report "identical" by matching
nothing against nothing.

## 3. What the change actually moves — `s41_correction_delta.gd`

Per-bone angle between the old correction and the new, on the RamsterZ
`T_pose.fbx` the authored pairs bind to, on two DIFFERENT fighter meshes:

```
S41_DELTA bones_compared=44 moved=18 worst=RightShoulder 26.691 deg
```

| bone | f01 (welter) | f02 (heavy) |
|---|---|---|
| `LeftShoulder` | 26.635 | 25.687 |
| `RightShoulder` | 25.508 | 26.691 |
| `Spine` | 10.823 | 6.858 |
| arms (`UpperArm`/`LowerArm`/`Hand`, each side) | 5.38–5.56 | 4.82–4.98 |
| the other 13 bones | 0.000 | 0.000 |

Nine bones of 22 move, and the shoulders move by 25–27 degrees. **The authored
pairs were never insulated from this change — the first instrument was just
blind to it.**

## 4. The measurement that can fail — `s41_pair_contact.gd`

Minimum distance from either attacker hand to any victim torso bone, across each
bound window, old 13-segment list against new 16, in one run.

| key | frames | min OLD | min NEW | Δ min | mean per-frame shift |
|---|---|---|---|---|---|
| `grapple_submission_finish` | 181 | 0.4648 | 0.4523 | **−0.0124** | 0.0143 |
| `grapple_control` | 51 | 0.5403 | 0.5230 | **−0.0173** | 0.0175 |
| `grapple_submission_attempt` | 135 | 0.1113 | 0.1050 | **−0.0063** | 0.0290 |
| `grapple_takedown` | 51 | 0.4000 | 0.3892 | **−0.0108** | 0.0272 |
| `grapple_sweep` | 56 | 0.3475 | 0.3398 | **−0.0077** | 0.0263 |
| `grapple_throw` | 71 | 0.2864 | 0.2285 | **−0.0579** | 0.0487 |
| `grapple_escape` | 81 | 0.2315 | 0.1644 | **−0.0671** | 0.0360 |
| `grapple_clinch_break` | 81 | 0.2315 | 0.1644 | **−0.0671** | 0.0360 |
| `grapple_stand_up` | 76 | 0.1139 | 0.0726 | **−0.0413** | 0.0299 |

**Nine of nine move CLOSER to contact**, by 6 to 67 mm at the closest approach.
For a strangle, a mount control and an armbar, hands belong on the opponent, so
the sign is the right one and it is the same sign on every pair.

**THESE ABSOLUTES ARE NOT THE SHIPPED PAIR GAP.** Each half is read in its own
clip space without `graft_pair`'s hips-carry, which is why a strangle reads
0.46 m. Both arms share that placement rule deliberately: it is common-mode and
cancels in the delta, and the delta is the finding. For the shipped gap, read
`pair_gap_report.gd`.

## 5. THE TOOL'S FIRST RUN MEASURED NOTHING AND ITS FRAME-COUNT CHECK PASSED

`s41_pair_contact.gd` first printed **0.6968 m on all 181 frames of a
six-second strangle, on both arms, on every key** — a perfect constant, which is
the two rigs' REST distance.

`retarget_clip` names its tracks with a BARE BONE NAME — `NodePath("Hips")`,
`subname_count` **zero** — and only rewrites them to `<skel_path>:<bone>` once a
player grafts the clip. The reader asked for `get_subname(0)`, got `""`,
`find_bone("")` returned −1, and every track was silently skipped.

**`FightPoseBridge._bone_tracks` has the same blind spot** (`if
path.get_subname_count() == 0: continue`) — by design, since it is written for
the grafted form. Anyone composing a pose from a FRESHLY retargeted clip must
handle both forms or they will measure the rest pose and not know it.

**The non-vacuity check that existed did not catch it**, because it asserted the
frame COUNT and 181 frames of nothing is still 181 frames. What catches it is
the SPREAD: a series that does not move across a six-second strangle is a rest
pose. That assertion is now in the tool, and it is the general form — assert
that the measurement VARIED, not that it was taken.

## 6. Tests

| gate | result |
|---|---|
| parse gate, all touched `.gd` | `fails=0` |
| `fight_paired_anchor_test` | `checks_failed=0` |
| `fight_anchor_ik_test` | PASS |
| `fight_silhouette_segments_test` (C152, blind) | `failures=0` |
| `fight_cascy_retarget_test` | `failures=0` (its `checks_failed=2/3` lines are its own mutants, `caught=true`) |
| `fight_hold_binding_test` | `failures=0` |
| `run_tests.py --only retarget` | `total=2 fails=0` |
| `run_tests.py --only clip` | `total=10 fails=0` |
| `run_tests.py --only grapple` | `total=10 fails=0` |
| `run_tests.py --only pair` | `total=6 fails=1` — `fight_pair_live_test`, PARKED by the operator 2026-09-15 |
| `run_tests.py --only stage` | `total=14 fails=1` — `fight_stage_realism_test`, one of the four standing reds |

`--only` does not stack; each was its own invocation.

### The full suite, and the two that were not on the known list

`python Godot/tools/run_tests.py --jobs 6` -> **`SUITE total=323 fails=6`**.
(`--jobs 8` was started first and stopped on the operator's word — the box was
getting hot. 16 logical cores, so 6 is the setting, not `cores-1`.)

Four are the standing reds: `athlete_development`, `fight_pair_live` (PARKED by
the operator 2026-09-15), `fight_scoring`, `fight_stage_realism`. The other two
were chased rather than assumed, and they went opposite ways:

- **`fight_metres_test` — NOT a defect.** It reported `hang (timeout)` under
  `--jobs 6` and **PASSES alone**, taking about nine minutes on its own. The
  handover's "contention flake" classification was right; I doubted it on the
  grounds that a lone run was also slow, and the doubt was wrong. It is slow,
  not hung.
- **`weight_cut_test` — a real red, and PRE-EXISTING.** Controlled by reverting
  `FightClipRetarget.gd` alone to `6aba786e` in the main checkout and re-running:
  it fails **identically** without the girdle change — same assertion, same
  27.2 kg, same message. The test has zero references to `Retarget`,
  `SILHOUETTE` or `ClipBinding`.

  Its failure is a FIXTURE defect worth someone's time: the test books a
  **76.8 kg Middleweight into a Flyweight bout whose limit is 83.9 kg**, then
  misses weight by 27.2 kg. A weight class whose name and limit disagree.

  (The first attempt at this control used a fresh worktree at `6aba786e` and was
  abandoned at 23 minutes — a new worktree re-imports 1.7 GB of assets. Reverting
  one file in the main checkout uses the warm cache and takes 30 seconds. Put the
  restore on a shell trap; a force-kill that skips it leaves the shipped constant
  reverted on disk.)

## 7. Verdict — ship it unconditionally, no `is_cmu_clip` opt-in

The brief allowed gating the new segments behind an opt-in if the re-baseline
cost more than it bought on the authored pairs. It does not. The CMU drift goes
+23.7% → −10.7%, the authored pairs move toward contact on 9 of 9, and no test
moved that was not already red. A per-clip gate would buy nothing and would
leave two correction paths to keep in step.

**C152 (Codex) was written blind against the contract while this was being
built, and it passes on the new 16-segment list with all five mutants red.** Its
assertions are the rule — start bones unique, parent segments first, `end` a
real child, `keep_end` spelled exactly — and none of them encode the contents,
which is why a list that grew by three did not go red.

## 8. What is NOT closed

- **The clavicle keeps ~26 deg and is out of reach of this routine.**
  `UpperChest->Shoulder` is measured and WORSE — `silhouette_rest` aims the
  START bone, `UpperChest` branches three ways, and listing both shoulders made
  them fight: right arm 0.03 deg, left arm 51.43, worse than the 34.66 it
  started at. Do not add it.
- Every anchor figure taken before S40 is still void; S42 re-measures the
  overshoot on this new baseline before touching any clamp.

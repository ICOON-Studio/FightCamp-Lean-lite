# TASK Q109 — QWEN — THE FOLD, MEASURED: HOW A REAL BOXER'S BODY BENDS THROUGH A JAB, AND HOW OUR AUTHORED JAB'S DOES

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q109-posture` (Claude creates it from `origin/master` before launch - do not switch branches). Push the BRANCH.
Stage: S4a (SMOOTH THE JAB IN COMBOS).

**Test tier: RESEARCH + PYTHON TOOLS, NO GDSCRIPT, NO GODOT.** No parse gate, no test suite. `python
research/Q109_check.py` is the whole gate and must print `Q109_CHECK PASS`. **IF IT DOES NOT, DO NOT COMMIT AND DO
NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `Q109_check.py`, `Tools/footage/rig_landmarks.json`,
`Tools/footage/track_pairs.py` or `Tools/measure_pair.py`. The worktree shows hundreds of modified `.import` files: that is
Godot's import churn, not yours - stage ONLY the owned paths.

## Owned files

- `Tools/footage/pair_events.py` - EDIT: add the POSTURE block (below) to every punch. Change nothing it already measures.
- `Tools/footage/fold_footage.py` - EDIT: add the new STATS keys and one histogram per group (below).
- `Tools/footage/pair_to_track.py` - NEW: an authored pair file -> a two-man track `.npz` pair_events.py reads unchanged.
- `Tools/footage/compare_to_footage.py` - NEW: one folded table against the footage table, key by key.
- `research/S4A_PAIRS/footage_batch3_two_men.json`, `research/S4A_PAIRS/footage_two_men.json` - REGENERATED.
- `research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_events.json` and `..._F09_F01_events.json` - NEW (step 5).
- `research/S4A_PAIRS/pair_BOX_JAB_HEAD_LAND_F01_F09_fold.json` and `..._F09_F01_fold.json` - NEW (step 5).
- `research/Q109_FOOTAGE_POSTURE.md` - NEW, 90 lines at most.

## Why this exists

The operator watched our Blender-authored jab (both fighters on one clock) inside the live fight and said, unprompted:
"the body of right is folding unnaturally at some point". Frames of it show the thrower, after contact, sinking with both
knees bent and his chest tipping forward over the lead leg. Q108 measured only HOW FAR the hips drop (footage p50 0.08 T,
p90 0.29 T; ours 0.17 T - inside), so depth alone does not explain the fold. Claude re-authors the jab next and needs the
footage's numbers for what depth does not capture: HOW MANY times the hips dip, how far the chest TIPS toward the other
man, and how much each KNEE bends - for both men - and the same numbers for our two authored pairs, from ONE instrument.

## Inputs (all on disk; `F=C:/Users/user/AppData/Local/Temp/FightCamp-footage`)

Tracks `$F/track/<id>.npz` for all 16 videos (MediaPipe Pose, arrays `t`, `img` (F, 2, 33, 5: x px, y px DOWNWARD, z,
visibility, presence), `n`, `fps`); events `$F/events/<id>.json` (pair_events.py's output; you regenerate them). Batch 2
ids, in this order: `-vPZqptk8jo 2m1Ftv_l_Xc 7pIskYcLKVw FCM7m6TJWUQ HL261oRyURE LfpNJ5fIYA4 cyXGrr7YTeg isLkzN3d7rA
vOFmsN3JROs yg_N42n_Jdk`; batch 3: `xaXXD-w45b0 wzUWvsviqTM kuABaA2PY0U XIja1S9SXI4 HFSZxKUUE98 d_PSlBJheZI`
(`HFSZxKUUE98` is slow motion: always `--slow HFSZxKUUE98`). Each events file's `label` is its label argument. The two
authored pairs: `Godot/assets/anim/pairs/BOX_JAB_HEAD_LAND_F01_F09.pair.json` (f01 throws) and `..._F09_F01.pair.json`.
The landmark map for our rig: `Tools/footage/rig_landmarks.json` (read it whole - it is the contract for step 3).

## The POSTURE block - a CONTRACT: exact names, the check recomputes every value from the `.npz` with its own code

Added to every punch dict in pair_events.py, next to `thrower_T_vertical`, as `"posture": {...}`. All in image units
(x, y), T = that man's segment-median torso length (`T[thrower]` / `T[receiver]` as pair_events.py already computes).

- **Window W** (segment-local frame indices): `w0 = max(0, onset - round(0.2 * fps))`, `w1 = min(len(idx) - 1, back +
  round(0.3 * fps))`; store `"w0_frame": s + w0, "w1_frame": s + w1` (video frames, like `frame`).
- **Slots**: store `"thrower_slot"` and `"receiver_slot"`: for every frame of W, which DETECTOR slot `p` of `img[frame, p]`
  that man's pose came from (a list of ints, length w1 - w0 + 1). Identity already picks p0/p1 out of the usable poses;
  carry their original slot index through. Nothing else about identity changes.
- **Per frame q in W, for a man with pose X**: `hip_h = ((X[L_ANK].y + X[R_ANK].y) / 2 - (X[L_HIP].y + X[R_HIP].y) / 2) / T`
  (height of the hip midpoint above the ankle midpoint; the same as `vertical()`);
  `pitch = degrees(atan2(dx, dy))` with `dx = (shmid.x - hipmid.x) * dir`, `dy = hipmid.y - shmid.y`, where `dir =
  toward` for the thrower and `-toward` for the receiver (+ = shoulders ahead of the hips TOWARD THE OTHER MAN, 0 =
  upright); `knee_L` = the angle in degrees at landmark 25 between the vectors (23 - 25) and (27 - 25), `knee_R` the same
  with 26, 24, 28 (180 = a straight leg); a knee is `None` on a frame where its knee landmark's visibility <= 0.5.
- **Smoothing**: a centred moving average with edge padding (like `smooth()`), `k = 3` when `fps < 40`, else `k = 5`,
  applied to each series (hip_h, pitch, each knee) before any value below is read. A knee series with any `None` in W
  is not smoothed and all its values are `None`.
- **Dips at prominence P** (for P = 0.05 and 0.10): candidates are indices `i` in `1 .. len-2` of smoothed hip_h with
  `h[i] < h[i-1] and h[i] <= h[i+1]`; `left_high` = the maximum of `h` scanning left from `i-1` down to index 0, stopping
  BEFORE the first sample lower than `h[i]`; `right_high` the same scanning right from `i+1` to the end; prominence =
  `min(left_high, right_high) - h[i]`; a dip is a candidate with prominence >= P.
- **Thrower values**: `"hips_dips_05T"`, `"hips_dips_10T"` (ints); `"dip_s_from_peak_05T"` (list: (i + w0 - peak) / fps
  for each counted 0.05 dip); `"pitch_onset_deg"` (smoothed pitch at onset), `"pitch_peak_deg"` (at peak),
  `"pitch_max_deg"` (max over W), `"pitch_max_s_from_peak"`, `"pitch_min_deg"` (min over W),
  `"pitch_forward_change_deg"` = max over [peak, w1] minus `pitch_onset_deg`; knees by LEAD/REAR - the lead knee is the
  side of `lead_ank` (L when `lead_ank == L_ANK`): `"lead_knee_onset_deg"`, `"lead_knee_min_deg"` (min over W),
  `"lead_knee_bend_deg"` (onset minus min), and the same three for `rear_`.
- **Receiver values**: `"receiver_pitch_onset_deg"`, `"receiver_pitch_min_after_peak_deg"` (min over [peak, w1]),
  `"receiver_pitch_back_change_deg"` (onset minus that min; + = he leaned away), `"receiver_hips_dips_05T"`.
- **Series**: `"series"`: `{"thrower_hip_h": [...], "thrower_pitch": [...], "receiver_pitch": [...]}` - the RAW
  (unsmoothed) per-frame values over W, rounded to 5 decimals.

## fold_footage.py additions (keys exactly)

STATS gains: `thrower_hips_dips_05T`, `thrower_hips_dips_10T`, `thrower_pitch_onset_deg`, `thrower_pitch_peak_deg`,
`thrower_pitch_max_deg`, `thrower_pitch_forward_change_deg`, `thrower_lead_knee_onset_deg`, `thrower_lead_knee_min_deg`,
`thrower_lead_knee_bend_deg`, `thrower_rear_knee_onset_deg`, `thrower_rear_knee_min_deg`, `thrower_rear_knee_bend_deg`,
`receiver_pitch_onset_deg`, `receiver_pitch_back_change_deg`, `receiver_hips_dips_05T` (each read from `posture`; a
punch without the value is skipped, as now). Each group block also gains `"thrower_hips_dips_05T_counts": {"0": n, "1":
n, "2": n, "3+": n}` over its punches that have the value. Every existing key keeps its exact value.

## pair_to_track.py (usage `python Tools/footage/pair_to_track.py <pair.json> <out.npz>`)

Writes arrays `t` (frame / fps), `img` (F, 2, 33, 5) float32, `world` (F, 2, 33, 3) float32, `n` (all 2), `fps`, `size`
(1920, 1080). Slot 0 = the THROWER (A, left), slot 1 = the RECEIVER. A bone's joint = its pose row's origin (pose row
`12 * i + 9 .. 12 * i + 12`) times the role's `world_scale` - exactly as `Tools/measure_pair.py`'s `pos()` reads it;
metres along the line: thrower `-start_gap_m / 2 + z`, receiver `+start_gap_m / 2 - z` (measure_pair.py's `x()`),
height = the joint's y. Then apply `rig_landmarks.json`: its projection, `px_per_m`, `y_top_m`, `map`, `nearest`, and
the nose (the Head joint raised `nose_up_T * T` with T = that role's torso length on frame 0, as measure_pair.py's `T`).

## compare_to_footage.py (usage `python Tools/footage/compare_to_footage.py <fold.json> --footage <fold.json> [--group jabs_head_height]`)

For every STATS key of the group: `<key> subject p10/p50/p90 (n) | footage p10/p50/p90 (n) | inside|OUTSIDE|-`, where the
verdict compares the SUBJECT's p50 with the footage p10..p90 (`-` when either n is 0), then the dips histograms side by
side. Two-decimal numbers. Fixed-width is fine; the check reads the verdict words and the key names.

## Steps (from the worktree root)

1. Read `Tools/footage/pair_events.py`, `fold_footage.py`, `rig_landmarks.json` and `Tools/measure_pair.py` whole
   (each under 300 lines). Implement the four owned tools.
2. Re-run `pair_events.py $F/track/<id>.npz $F/events/<id>.json "<label>"` for all 16 videos (label = the old events
   file's `label`, read it BEFORE overwriting). About 5 minutes in total; run them one after another.
3. Fold exactly as Q108 did: batch 3 alone -> `footage_batch3_two_men.json`; batch 2 + 3 (batch 2 ids first, in the
   order above) -> `footage_two_men.json`; the SAME population strings as the current files (copy them verbatim from
   the committed JSONs). Also fold batch 2 alone into `$F/fold_batch2_posture.json` (NOT committed - for the digest).
4. `python research/Q109_check.py` - its first stage says whether the old numbers survived; fix before going on.
5. For each of the two pairs: `pair_to_track.py` -> `$F/pair_<id>.npz`; `pair_events.py` on it ->
   `research/S4A_PAIRS/pair_<id>_events.json` (label `"<id> (authored pair, 60 fps)"`); `fold_footage.py --out
   research/S4A_PAIRS/pair_<id>_fold.json --population "<id>: the authored pair through Tools/footage/pair_to_track.py
   and rig_landmarks.json" 0:<that events file>`; then `compare_to_footage.py <that fold> --footage
   research/S4A_PAIRS/footage_two_men.json`.
6. Write the digest, run the check until `Q109_CHECK PASS`.

## The digest (`Q109_FOOTAGE_POSTURE.md`) - every number from the JSON files; the check compares them

- `# Q109 - the fold, measured` then `## DECISIONS` (at most 14 lines). Name each by its key: the pooled
  `jabs_head_height` p10/p50/p90 of `thrower_pitch_onset_deg`, `thrower_pitch_forward_change_deg`,
  `thrower_lead_knee_bend_deg`, `thrower_rear_knee_bend_deg`, and its `thrower_hips_dips_05T_counts`; the same five for
  EACH authored pair with its verdict; and which keys put a pair OUTSIDE the footage p10-p90. Then one line each on
  drills (batch 2) against bouts (batch 3) for dips and forward pitch.
- `## Jabs to the head: posture` - one row per NEW STATS key, first four cells exactly `| <key> | <batch 2> | <batch 3> |
  <pooled> |`, values `p10 / p50 / p90 (n)` with two decimals (`- (0)` when n is 0); then one row per population
  `| dips_05T counts | <batch 2> | <batch 3> | <pooled> |` with each cell `0:<n> 1:<n> 2:<n> 3+:<n>`.
- `## The authored pairs` - both compare_to_footage.py outputs, each verbatim inside its own ```text fence.
- `## Population` - the pooled JSON's population string, verbatim.

## Deliver

`git restore --staged -- AgentComms/messages` first. Commit ONLY the owned files with their paths on the commit line,
`git show --stat HEAD`, `git push -u origin qwen/q109-posture`, then `python Tools/agent_comms.py send --from qwen --to
claude --topic "Q109 ready" --body "<the Q109_CHECK line> - pooled jab forward pitch p50 <n> deg, F01_F09 <n> deg"`. If
the check fails: no commit, no push, `--topic "Q109 BLOCKED" --body "<the FAIL lines>"`. Do not edit HANDOFF.md or
AgentComms/roadmap.json.

## The trap

Image y grows DOWNWARD. An upright man has his hip midpoint BELOW his shoulders, so `hipmid.y - shmid.y` is POSITIVE and
his pitch is near 0; a man leaning toward the other man has positive pitch only if `dx` is multiplied by `toward` (per
punch, not per video - the two men swap sides between segments). Your last two digests each had one DECISIONS sentence
that contradicted their own table: write every sentence from the JSON row in front of you.

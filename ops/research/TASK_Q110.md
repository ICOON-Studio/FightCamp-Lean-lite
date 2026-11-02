# TASK Q110 — QWEN — THE THREE JABS IN FOOTAGE: EVERY LEAD-HAND MOVE, NOT ONLY THE PUNCHES, MEASURED IN THE 16 TRACKED VIDEOS

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q110-jab-types` (Claude creates it from `origin/master` before launch - do not switch branches). Push the BRANCH.
Stage: S4a (THE THREE JAB TYPES).

**Test tier: RESEARCH + PYTHON TOOLS, NO GDSCRIPT, NO GODOT.** No parse gate, no test suite. `python
research/Q110_check.py` is the whole gate and must print `Q110_CHECK PASS`. **IF IT DOES NOT, DO NOT COMMIT AND DO
NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `Q110_check.py` or any existing file under
`Tools/footage/`. The worktree shows hundreds of modified `.import` files: Godot's churn - stage ONLY the owned paths.

## Owned files

- `Tools/footage/jab_types.py` - NEW: one track -> every lead-hand move of both men (step 1).
- `Tools/footage/fold_jab_types.py` - NEW: all videos -> one table (step 2).
- `Tools/footage/jab_types_strips.py` - NEW: skeleton strips (step 3).
- `research/S4A_PAIRS/footage_jab_types.json` - NEW (step 2's output).
- `research/S4A_PAIRS/jab_types_strips/*.png` - NEW (step 3's output).
- `research/Q110_FOOTAGE_JAB_TYPES.md` - NEW, 90 lines at most.

## Why this exists

The operator, verbatim: "A sloppy jab can be thrown just to measure distant the animations need to portray fakes and
when a fighter commits to a jab opening". The engine throws a jab, a range-finder and a feint; the room shows one full
jab. Claude will animate each, and needs to know what real boxers' lead hands do OTHER than full punches: how far a short
or partial jab goes, how fast, whether the body steps, whether the other man reacts, what follows. Our punch detector
(`Tools/footage/pair_events.py`) only keeps moves whose reach rises 0.35 T or more, so every feint and most range-finders
are invisible to it. This census lowers that threshold and classifies what it finds. It measures; it does not name intent.

## Inputs (`F=C:/Users/user/AppData/Local/Temp/FightCamp-footage`)

Tracks `$F/track/<id>.npz` (MediaPipe Pose: `t`, `img` (F, 2, 33, 5: x px, y px DOWNWARD, z, visibility, presence), `n`,
`fps`) and pair_events.py's output `$F/events/<id>.json` (`segments`, `punches`) for these 16 ids: batch 2
`-vPZqptk8jo 2m1Ftv_l_Xc 7pIskYcLKVw FCM7m6TJWUQ HL261oRyURE LfpNJ5fIYA4 cyXGrr7YTeg isLkzN3d7rA vOFmsN3JROs yg_N42n_Jdk`,
batch 3 `xaXXD-w45b0 wzUWvsviqTM kuABaA2PY0U XIja1S9SXI4 HFSZxKUUE98 d_PSlBJheZI` (`HFSZxKUUE98` is slow motion: its
events file already carries the right `fps`; take `fps` from the events file for every video). Read
`Tools/footage/pair_events.py` whole (344 lines): it is the reference instrument.

## Step 1 - `Tools/footage/jab_types.py <track.npz> <events.json> <out.json>` (a CONTRACT - the check recomputes)

1. **Identity and segments**: copy pair_events.py's identity block and segment loop EXACTLY (lines 56-121), so your
   `segments` (`start_s`, `end_s`) equal the events file's. Keep the per-frame detector slot of each man (`slotA`/`slotB`).
2. **Per segment, per man (thrower) and per hand**: the SAME reach series as pair_events.py (`smooth(|wrist - shoulder| /
   T[thrower])`, k = 3) and the SAME peak/onset/back/visibility/toward rules, with ONE change: keep a move when `rise >=
   0.12` (pair_events.py uses 0.35). Keep only moves where the hand is the LEAD (pair_events.py's `is_lead` rule).
3. **Per kept move**, write an event dict with exactly these keys:
   `t_peak_s`, `frame_onset`, `frame_peak`, `frame_back` (video frame numbers), `thrower` ("A"/"B"), `hand` ("L"/"R"),
   `thrower_slot` (a dict: str(frame) -> detector slot, for frames onset, peak-1, peak, peak+1),
   `T_px` (the thrower's segment T), `rise_T`, `reach_peak_T` (the smoothed reach at the peak),
   `arm_len_T` = the segment 90th PERCENTILE (not the median - see the addendum), over frames where the thrower's shoulder, elbow and wrist of that side all have
   visibility > 0.5, of (|shoulder - elbow| + |elbow - wrist|) / T,
   `e` = reach_peak_T / arm_len_T, `extension_s` = (peak - onset) / fps, `return_s` = (back - peak) / fps,
   `hips_out_T`, `lead_ankle_out_T` (pair_events.py's `travel()` from onset to peak),
   `rear_wrist_v_nose_T` = the minimum over onset..back of (nose.y - rear wrist.y) / T (+ = the rear hand above the nose),
   `reacted` = pair_events.py's receiver rule (the receiver's nose moves >= 0.15 T within -0.1..+0.6 s of the peak),
   `matched_punch` = the events file has a punch with the same `thrower`, `lead` true and |t_peak_s difference| <= 0.1 s,
   `next_0_8s` = "lead" / "rear" / "none": the same thrower's next move after `frame_back` within 0.8 s - "lead" if it is
   one of YOUR kept moves, else "rear" if it is an events-file punch with `lead` false, else "none",
   `class`: `"feint"` if e < 0.70 and rise_T < 0.35; `"partial"` if 0.70 <= e < 0.90; `"full_planted"` if e >= 0.90 and
   lead_ankle_out_T < 0.15; `"full_stepping"` if e >= 0.90 and lead_ankle_out_T >= 0.15; otherwise `"other"`.
   Output: `{"id", "fps", "segments": [{"start_s", "end_s"}], "events": [...]}`. Run it for all 16 ids into
   `$F/jab_types/<id>.json`.

## Step 2 - `Tools/footage/fold_jab_types.py --out research/S4A_PAIRS/footage_jab_types.json $F/jab_types/*.json`

`{"population": "<one sentence: 16 videos by id, two men side-on, MediaPipe, lead-hand moves with rise >= 0.12 T>",
"minutes": <sum of segment durations / 60>, "histogram_e": {"bin_width": 0.05, "counts": [30 ints for 0.00-1.50]},
"classes": {<class>: {"n", "per_minute", "reacted_share", "matched_share", "next_lead_share", "next_rear_share",
"e", "rise_T", "extension_s", "return_s", "hips_out_T", "lead_ankle_out_T", "rear_wrist_v_nose_T"}}}` - each of the last
eight keys is `{"p10", "p50", "p90"}` over that class's events (return_s ignores nulls). All five classes appear even
when empty (n 0, stats null).

## Step 3 - `Tools/footage/jab_types_strips.py`

For each class except `other`, the three events with the highest `reach_peak_T` visibility-safe (all needed landmarks
visibility > 0.5 at onset, peak and back): draw BOTH men's skeletons (lines between landmarks 11-12, 11-13, 13-15, 12-14,
14-16, 11-23, 12-24, 23-24, 23-25, 25-27, 24-26, 26-28, nose as a dot) from the track at onset | peak | back side by side,
thrower in orange and receiver in blue, the video id, time and class written on it, 900x320 px, to
`research/S4A_PAIRS/jab_types_strips/<class>_<k>.png`. OPEN several before writing the digest: a strip that shows a
man walking or a skeleton swap is a step 1 bug.

## The digest (`Q110_FOOTAGE_JAB_TYPES.md`)

`# Q110 - the three jabs in footage`, then `## DECISIONS` (at most 10 lines: per class its n and per_minute as in the JSON,
the p50 of e, extension_s, lead_ankle_out_T and reacted_share, and whether the e histogram shows separate humps or one
spread - say which bins), `## Classes` (one table: class, n, per_minute and every p50), `## Histogram` (the 30 counts),
`## Strips` (the file names and what each shows in one line), `## Population` (the JSON's string verbatim).

## Deliver

`git -C <worktree> restore --staged -- AgentComms/messages` first. Commit ONLY the owned files with their paths on the
commit line, `git show --stat HEAD`, `git push -u origin qwen/q110-jab-types`, then `python Tools/agent_comms.py send
--from qwen --to claude --topic "Q110 ready" --body "<the Q110_CHECK line> - feint/partial/full per minute <a>/<b>/<c>"`.
If the check fails: no commit, no push, `--topic "Q110 BLOCKED" --body "<the FAIL lines>"`. Do not edit HANDOFF.md.

## The trap

A lower threshold finds more than hands: a man stepping toward the other also moves his wrist away from his own shoulder
in the image, and a detector slot swap for one frame makes a "move". That is why every event carries its slots and its
arm length, and why the check recomputes reach from `img` at those exact slots - and why you must LOOK at the strips.

## ADDENDUM 2026-09-14 22:40 - HANDED TO CURSOR (Qwen's weekly quota ran out mid-task; it resets 2026-09-15 17:37 UTC)

Qwen wrote `Tools/footage/jab_types.py`, `fold_jab_types.py`, `jab_types_strips.py`, all 16 `$F/jab_types/<id>.json`, the
table, the strips and a digest in the worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81` (UNCOMMITTED, branch
`qwen/q110-jab-types`), then stopped. Claude ran the check on it. WHAT HOLDS: segments equal pair_events.py's on all 16;
150 of 157 reference lead punches found again; reach recomputed from `img` matches on 33 of 33. WHAT FAILS (18 lines):
1. **The contract's arm length was wrong (Claude's error).** A segment MEDIAN of the 2D arm includes foreshortened frames,
   so `e` reaches 1.63-1.71 on real punches (HL261oRyURE t=52.26, wzUWvsviqTM t=358.89, kuABaA2PY0U t=73.31). Step 1 now
   says the 90th percentile. Re-run step 1 for all 16 ids.
2. **The fold double-counts**: the table holds 423 events and class n 104/92/198/25/4 while the per-video files hold 262
   (65/62/118/15/2), so every `per_minute` and the histogram are wrong. Fold exactly the 16 `$F/jab_types/<id>.json` files
   named in the task, once each.
3. Regenerate the strips and rewrite the digest from the corrected table (DECISIONS must carry the per-class n).
`Tools/footage/_debug_fs.py` is not an owned file: delete it. Everything else in this task file stands: owned files,
the check (never edit it), the deliver steps - commit on `qwen/q110-jab-types` with "Q110 (finished by Cursor after Qwen's
quota ran out)" in the message, push that branch, and send the mail `--from cursor`.

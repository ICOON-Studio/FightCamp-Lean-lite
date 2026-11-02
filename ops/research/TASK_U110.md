# TASK U110 — CURSOR — HOW LONG A REAR HAND AND A KICK COMMIT A MAN: THE OTHER HALF OF Q110'S MEASUREMENT

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u110-commit-window` (Claude creates it from
`origin/master` before launch — do not switch branches). Push the BRANCH. Stage: S4e (ENGINE FIRST).

**Test tier: RESEARCH + PYTHON TOOLS, NO GDSCRIPT, NO GODOT.** No parse gate, no test suite. `python
research/U110_check.py` is the whole gate and must print `U110_CHECK PASS`. **IF IT DOES NOT, DO NOT COMMIT AND
DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `U110_check.py`, `Tools/footage/jab_types.py`,
`Tools/footage/fold_jab_types.py` or `Tools/footage/pair_events.py`. The worktree shows hundreds of modified `.import`
files — Godot's churn; stage ONLY the owned paths. Unstage `AgentComms/messages` before you commit.

## Owned files

- `Tools/footage/limb_types.py` — NEW: one track → every REAR-HAND and KICK move of both men (step 1).
- `Tools/footage/fold_limb_types.py` — NEW: all videos → one table (step 2).
- `research/S4A_PAIRS/footage_limb_types.json` — NEW (step 2's output).
- `research/U110_FOOTAGE_COMMIT_WINDOW.md` — NEW, 70 lines at most.

## Why this exists

S4e (5) shipped commitment into the live engine on 2026-09-15: a man who throws cannot answer a blow until his hand is
back. **The window is `FightCommitment.COMMIT_S` = 0.267 s, and it is a LEAD-HAND number applied to every throw** —
Q110's instrument only ever tracked the lead hand ("lead-hand moves with rise >= 0.12 T"). A rear hand and a kick commit
a man for longer in every coaching text there is, and by how much is not measured anywhere in this repo.

`research/S4E_COMMITMENT.md` Open 3 is this task. **This is the same instrument, the same 16 videos and the same
fold, pointed at the other two limbs.** Read `Tools/footage/jab_types.py` whole (about 300 lines) first — it is the
reference and `torso()`, `hipmid()`, `shmid()`, `usable()` and its `e` / `extension_s` / `return_s` definitions are what
you reuse, not what you reinvent. **Every length is in TORSO LENGTHS (T), never pixels and never invented centimetres.**

The operator's 2026-09-14 ruling is why this comes from footage rather than a literature search: *"Trying to find how to
do a jab by studies and calculate it with cm I think is dumb, there is no way we will find this kind of data because no
one has done such detailed study"*; *"Ignore copyrights and bring results watch YouTube videos and learn the moves"*.

## Inputs (`F=C:/Users/user/AppData/Local/Temp/FightCamp-footage`)

Tracks `$F/track/<id>.npz` (MediaPipe Pose: `t`, `img` (F, 2, 33, 5: x px, y px DOWNWARD, z, visibility, presence),
`n`, `fps`) and `pair_events.py`'s output `$F/events/<id>.json` (`segments`, `punches`) for the **16** ids: batch 2
`-vPZqptk8jo 2m1Ftv_l_Xc 7pIskYcLKVw FCM7m6TJWUQ HL261oRyURE LfpNJ5fIYA4 cyXGrr7YTeg isLkzN3d7rA vOFmsN3JROs
yg_N42n_Jdk`, batch 3 `xaXXD-w45b0 wzUWvsviqTM kuABaA2PY0U XIja1S9SXI4 HFSZxKUUE98 d_PSlBJheZI`, **plus the kept UFC
round-1 track** `$F/ufc_pilot/_mkFV2H2oCk_r1.npz` with its events file (126.8 s tracked of a 300 s round).

`HFSZxKUUE98` is slow motion: **take `fps` from the events file for every video**, never from the npz.

**No new downloads.** These 17 tracks are what exists. A missing track means that video is skipped and named in the
digest — it is never a reason to fetch anything.

## Step 1 — `Tools/footage/limb_types.py <track.npz> <events.json> <out.json>` (a CONTRACT — the check recomputes)

Two streams, both keyed exactly as written. Keep `jab_types.py`'s per-move field names so the two folds can sit beside
each other in one table.

| stream | which moves it takes |
|---|---|
| `rear_hand` | the NON-lead wrist, same detector as `jab_types.py`'s lead hand: a rise ≥ 0.12 T from its own onset. Lead versus rear is decided by the same lead-ankle rule `jab_types.py` already uses, per segment — a man who switches stance mid-segment changes which hand is which, and that is correct, not noise. |
| `kick` | either ANKLE rises ≥ 0.15 T above its own 1 s rolling median while the opposite hip stays within 0.10 T of its median — the foot goes, the stance leg does not. A step is not a kick and the rolling median is what separates them. |

Per move, the same fields `jab_types.py` emits, for the same reasons: `t_peak_s`, `frame_onset`, `frame_peak`,
`frame_back`, `person`, `limb` (`"rear_hand"` / `"kick"`), `side` (`"left"`/`"right"`), `T_px`, `rise_T`,
`reach_peak_T`, `e`, **`extension_s`**, **`return_s`**, `hips_out_T`, `lead_ankle_out_T`, `reacted`, `matched_punch`.

`reacted` and `matched_punch` keep `jab_types.py`'s EXACT definitions — the receiver's nose moving ≥ 0.15 T within
-0.1..+0.6 s of the peak, and an events-file punch by the same thrower within ±0.1 s of the peak. **Do not widen
either.** A different definition here would make the two tables incomparable, which is the whole point of the task.

For a kick, `e` is the ankle's reach as a share of LEG length (hip→knee + knee→ankle), the exact analogue of
`jab_types.py`'s arm-length share. Say so in the digest.

The file also carries `fps`, `video_id`, `usable_seconds` (segment seconds where both men are usable) and `person_n`.
**A rate's denominator is `usable_seconds`, never the video's length.**

## Step 2 — `Tools/footage/fold_limb_types.py <events_dir> <out.json>`

One table per LIMB (`rear_hand`, `kick`), per video and pooled, with:

- `n`, `per_minute` (over usable seconds),
- **`away_s` = `extension_s` + `return_s`, with p10 / p50 / p90** — this is the number the engine needs and it is the
  headline of the whole task,
- `extension_s`, `return_s`, `e`, `hips_out_T` each with p10 / p50 / p90,
- `reacted_share` and `matched_share`.

Pool the UFC round **separately** from the 16 boxing/sparring videos and print both — they are different populations
and must never be averaged into one number.

## The one answer this task exists to give

> **`away_s` p50 for `rear_hand`, and `away_s` p50 for `kick`, each with its n and its population named.**

Q110's lead hand is 0.267 s at p50 (full planted, n=117). Put those three numbers in one row at the TOP of
`U110_FOOTAGE_COMMIT_WINDOW.md`. If a limb's n is under 30, **say so and do not report a p90 for it** — a percentile
off twenty samples is a number pretending to be a measurement.

## Traps this task has already paid for

- **`p["thrower"]` in the events file is a person INDEX, not a side.** `jab_types.py` maps it; copy that mapping.
- **`img` y is DOWNWARD.** A rise is a DECREASE in y. `jab_types.py` gets this right — read it, do not re-derive it.
- **A `%` only follows a share.** A per-minute figure is pinned to its own clock and never called a percentage.
- **Never average the UFC round into the sparring pool.** R137: a fixture is not only the fighters, it is the data.
- The lead-ankle lead/rear rule is per SEGMENT. A southpaw segment silently inverts `rear_hand` if you settle it once
  for the whole video, and the resulting table would be two limbs averaged together.

## Digest and mail

`research/U110_FOOTAGE_COMMIT_WINDOW.md`, 70 lines at most: the headline row, the per-limb table, the population
(17 tracks named, usable minutes, n per limb), and what you could NOT measure. Then one line with
`python Tools/agent_comms.py send --from cursor --to claude --subject "U110 done" --body "<the three away_s p50s and the branch>"`.
**Do NOT edit `HANDOFF.md`** — Claude writes your block.

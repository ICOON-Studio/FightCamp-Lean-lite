# TASK U109 — CURSOR — WHAT FIGHTERS DO BETWEEN PUNCHES, MEASURED: STANCE SWITCHES, DIRECTION CHANGES, RESETS, LEVEL CHANGES AND HEAD MOVEMENT PER MINUTE

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u109-between-rates` (Claude creates it from
`origin/master` before launch — do not switch branches). Push the BRANCH. Stage: S4e (ENGINE FIRST).

**Test tier: RESEARCH + PYTHON TOOLS, NO GDSCRIPT, NO GODOT.** No parse gate, no test suite. `python
research/U109_check.py` is the whole gate and must print `U109_CHECK PASS`. **IF IT DOES NOT, DO NOT COMMIT AND DO
NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `U109_check.py` or any existing file under
`Tools/footage/`. The worktree shows hundreds of modified `.import` files — Godot's churn; stage ONLY the owned paths.
Unstage `AgentComms/messages` before you commit.

## Owned files

- `Tools/footage/between_events.py` — NEW: one track → every between-punch event of both men (step 1).
- `Tools/footage/fold_between.py` — NEW: all videos → one table (step 2).
- `research/S4E_BETWEEN/footage_between.json` — NEW (step 2's output).
- `research/U109_FOOTAGE_BETWEEN_RATES.md` — NEW, 100 lines at most (90, plus the yaw-rate row added 2026-09-15).

## Why this exists

The operator ruled ENGINE FIRST on 2026-09-14 night: the engine must simulate ring position, stances and switches, real
dodges, feints and commitment, and **what fighters do between exchanges** before any more clips are generated. Verbatim,
earlier the same night: *"the fighters do something (repositioning, faking, backing up, pushing through the cage etc) or
move constantly"* — *"not static like your sim fighters"*.

Claude is building those behaviours now and every one of them needs a RATE to be bound to. The standing rule is that
each rule prints its study, the real number, its bound and a label, and that an invented bound is a defect. There is no
published per-minute rate for any of the five. **This task is where those numbers come from**, and per the operator's
2026-09-14 ruling — *"Trying to find how to do a jab by studies ... is dumb ... You need to find other ways"*, *"Ignore
copyrights and bring results watch YouTube videos and learn the moves"* — they come from the footage already tracked and
kept, not from a literature search.

Q110 already gives feints at **14.7/min** from the same tracks. This is the same instrument pointed at the other four.

## Inputs (`F=C:/Users/user/AppData/Local/Temp/FightCamp-footage`)

Tracks `$F/track/<id>.npz` (MediaPipe Pose: `t`, `img` (F, 2, 33, 5: x px, y px DOWNWARD, z, visibility, presence), `n`,
`fps`) and `pair_events.py`'s output `$F/events/<id>.json` (`segments`, `punches`) for these **16** ids: batch 2
`-vPZqptk8jo 2m1Ftv_l_Xc 7pIskYcLKVw FCM7m6TJWUQ HL261oRyURE LfpNJ5fIYA4 cyXGrr7YTeg isLkzN3d7rA vOFmsN3JROs yg_N42n_Jdk`,
batch 3 `xaXXD-w45b0 wzUWvsviqTM kuABaA2PY0U XIja1S9SXI4 HFSZxKUUE98 d_PSlBJheZI`, **plus the kept UFC round-1 track**
`$F/ufc_pilot/_mkFV2H2oCk_r1.npz` with its events file (126.8 s tracked of a 300 s round).

`HFSZxKUUE98` is slow motion: **take `fps` from the events file for every video**, never from the npz.
Read `Tools/footage/pair_events.py` whole (344 lines) first: it is the reference instrument and `torso()`, `hipmid()`,
`shmid()` and `usable()` are the definitions you reuse. **Every length is in TORSO LENGTHS (T), never pixels and never
invented centimetres.**

**No new downloads.** Footage batches are approved by the operator one named list at a time; these 17 tracks are what
exists. If a track is missing, that video is skipped and named in the digest — it is not a reason to fetch anything.

## Step 1 — `Tools/footage/between_events.py <track.npz> <events.json> <out.json>` (a CONTRACT — the check recomputes)

For each of the two tracked people, over the frames inside `segments` (both men usable) and **outside** a punch window
(from a punch's `onset` to 0.4 s after its `end`), emit five event streams PLUS one per-frame rate. Exact JSON keys, exact spelling:

| key | definition (all in torso lengths T, from joint POSITIONS so a check can recompute it) |
|---|---|
| `stance_switches` | the signed lateral offset of the lead ankle from the hip midline changes sign and holds the new sign for ≥ 0.25 s |
| `direction_changes` | the sign of the hip-midpoint's lateral velocity (smoothed over 3 frames) reverses while speed ≥ 0.15 T/s |
| `resets` | a return to a held guard: both wrists rise above shoulder height and stay ≥ 0.3 s, beginning within 1.5 s after a punch window ends |
| `level_changes` | hip-midpoint height drops ≥ 0.08 T below its 1 s rolling median and returns within 1.2 s |
| `head_moves` | nose lateral displacement ≥ 0.10 T inside 0.30 s, with the hip midpoint moving < 0.05 T — the head goes, the body does not |
| `turn_yaw_deg_s` | **ADDED 2026-09-15 for S4e (4) BEARING, and it is a RATE, not an event.** Take the normal of the shoulder line (left shoulder → right shoulder, rotated 90° in the image plane) as the direction the fighter faces, and report its rate of change in DEGREES PER SECOND, smoothed over 3 frames. Emit one value per usable frame and fold **`turn_yaw_deg_s_p50` / `_p90` / `_max`** per video (no `_per_min` — meaningless for a rate). **This is the number the engine has none of**: `FightBearing.TURN_BASE_DEG_S` is AUTHORED at 240 deg/s and tuned to nothing, and this measurement replaces it. Same pass over the same files, which is why it is here and not in a task of its own. |

Each event is `{"person": 0|1, "t_s": float, "duration_s": float, "magnitude_T": float, "kind": "<key singular>"}`.
The file also carries `fps`, `video_id`, `usable_seconds` (segment seconds where both men are usable and no punch window
is open) and `punch_seconds`. **A rate's denominator is `usable_seconds`, never the video's length** — the standing rule
is that a number is a share only when a `%` follows it and a per-minute figure is pinned to its own clock.

## Step 2 — `Tools/footage/fold_between.py <events_dir> <out.json>`

One table: per video and pooled, each of the five EVENT kinds as **events per minute of usable time**, with p50 and p90
`magnitude_T` and `duration_s` - and `turn_yaw_deg_s` as its three percentiles, never a per-minute. Also pool the UFC round separately from the 16 boxing/sparring videos and print both —
**they are different populations and must never be averaged into one number.**

## Step 3 — `research/U109_FOOTAGE_BETWEEN_RATES.md`, 100 lines at most

`# U109 - what fighters do between punches, measured`, then `## POPULATION`, `## RATES`, `## METHOD`, `## Open`.

- `## POPULATION` names every video id used, its camera (side-on / three-quarter / behind), its discipline, and its
  usable seconds. **A measurement must name its population in its own output.**
- `## RATES` is the table: one row per kind (six, the yaw rate included), columns `pooled /min`, `UFC round /min`, `p50 magnitude_T`, `p90
  duration_s`, `n`, and a `LABEL` column reading `MEASURED (footage)`.
- `## METHOD` states each definition in one line and says which are sensitive to the threshold chosen.
- `## Open` — 8 lines at most.

## The trap specific to this task

**A broadcast round tracks only part of the time, and a rate whose denominator is the wrong clock is the defect this
project has hit most.** The UFC round gives 34 two-man segments, 126.8 s of 300 s, because the broadcast cuts between
cameras — so its per-minute figures must divide by USABLE seconds, and the digest must say so. The same trap in reverse:
`HFSZxKUUE98` is slow motion, so a rate computed from the npz's own fps is wrong by the slowdown factor. Take `fps` from
the events file, and print the fps you used for every video in `## METHOD`.

Second trap: a "stance switch" that is really the tracker swapping which person is index 0. `pair_events.py`'s
`segments` are already identity-stable within a segment — **never carry an event across a segment boundary**, and reset
every held-sign state at the start of each segment.

## Ship

Commit the five owned paths only (`git add -- <paths>`, then `git show --stat HEAD`), push the branch, and send one line
with `python Tools/agent_comms.py send --from cursor --to claude --subject "U109 ready"`. Do NOT edit `HANDOFF.md`.

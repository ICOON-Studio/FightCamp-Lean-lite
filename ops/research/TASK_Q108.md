# TASK Q108 — QWEN — FOOTAGE BATCH 3: FOLD THE SIX NEW VIDEOS INTO THE TWO-MAN TABLE, WRITE WHAT MOVED, DELETE THE VIDEOS

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q108-footage-batch3` (Claude creates it from `master` before launch - do not switch branches). Push the BRANCH.
Stage: S4a (THE SCRIPTED JAB IN THE LIVE FIGHT).

**Test tier: RESEARCH, NO SCRIPT EDITED.** No parse gate, no Godot, no test suite. `python research/Q108_check.py`
is the whole gate: it must print `Q108_CHECK READY_TO_DELETE`, then (after step 6) `Q108_CHECK PASS`. **IF IT DOES NOT,
DO NOT COMMIT AND DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `Q108_check.py`,
`Tools/footage/fold_footage.py`, `Tools/footage/pair_events.py` or `Tools/footage/track_pairs.py`.

## Owned files

- `research/S4A_PAIRS/footage_batch3_two_men.json` - NEW, written by `fold_footage.py` (step 2).
- `research/S4A_PAIRS/footage_two_men.json` - NEW, written by `fold_footage.py` (step 3).
- `research/Q108_FOOTAGE_BATCH3.md` - NEW, 90 lines at most.

## Why this exists

The operator chose, from a side-by-side video, a boxing exchange AUTHORED for both fighters on one clock over our live
room's clips ("Right is clearly better") and ruled that technique detail comes from WATCHING real boxers, never from
per-technique studies ("watch YouTube videos and learn the moves"). Every authored pair is checked against numbers
tracked from two-man footage (`Tools/measure_pair.py --footage`). Batch 2 gave 31 head-height jabs. The operator approved
batch 3 ("Yes, all 6", and "delete them after you do your work"); Claude has already downloaded, tracked (MediaPipe,
`track/<id>.npz`) and measured (`events/<id>.json`) all six in `C:/Users/user/AppData/Local/Temp/FightCamp-footage/`. Your
job: fold them with batch 2, write down what the new footage changes, and delete the videos.

The six (ids and labels are in each `events/<id>.json`): `xaXXD-w45b0` AIBA Worlds 2021 Cruz v Lee (broadcast, 60 fps),
`wzUWvsviqTM` Boxlab Gomez v Preciado ringside (30 fps), `kuABaA2PY0U` jab sparring (30 fps), `XIja1S9SXI4` how to roll a
punch (coaching, 30 fps), `HFSZxKUUE98` "What REALLY happens when you get punched? 240 FPS" (a 60 fps file of SLOW MOTION -
its time windows are wrong, so it is listed and never pooled: always pass `--slow HFSZxKUUE98`), `d_PSlBJheZI` body shots
in sparring (60 fps). Batch 2's events are the other ten files in the same `events/` folder.

## Steps (run from the worktree root; `F=C:/Users/user/AppData/Local/Temp/FightCamp-footage`)

1. `python Tools/footage/fold_footage.py --help` - read the GROUPS and the rules at the top of the file; do not change them.
2. Batch 3 alone -> `research/S4A_PAIRS/footage_batch3_two_men.json`: `--population "<text>" --slow HFSZxKUUE98`
   and the six sources `3:$F/events/<id>.json`, in the order listed above.
3. Batch 2 + 3 -> `research/S4A_PAIRS/footage_two_men.json`: the ten batch-2 sources `2:$F/events/<id>.json` (in
   this order: `-vPZqptk8jo 2m1Ftv_l_Xc 7pIskYcLKVw FCM7m6TJWUQ HL261oRyURE LfpNJ5fIYA4 cyXGrr7YTeg isLkzN3d7rA vOFmsN3JROs
   yg_N42n_Jdk`), then the six batch-3 sources as in step 2. Each population string is ONE line and names: MediaPipe Pose
   (two people), identity by hip continuity, side-on segments only, `T = ` the torso length, which batches, and that
   `HFSZxKUUE98` (slow motion) is listed but excluded from every statistic.
4. `python Tools/measure_pair.py Godot/assets/anim/pairs/BOX_JAB_HEAD_LAND_F01_F09.pair.json --footage
   research/S4A_PAIRS/footage_two_men.json`, and the same for `BOX_JAB_HEAD_LAND_F09_F01.pair.json`.
5. Write the digest (below), then `python research/Q108_check.py` until it prints `Q108_CHECK READY_TO_DELETE`.
6. Delete the six videos: `rm $F/batch3/*.mp4` (nothing else - keep `track/`, `events/`, `models/`), then run the check
   again: `Q108_CHECK PASS`.

## The digest (`Q108_FOOTAGE_BATCH3.md`) - every number comes from the JSON files; the check compares them

- `# Q108 - footage batch 3 folded into the two-man table` then `## DECISIONS` (at most 12 lines): what batch 3 adds (how
  many head-height jabs, from which videos), which jab numbers MOVED between batch 2 and the pool (the check requires you
  to name, by its key, every statistic whose pooled p50 moved 0.05 or more from batch 2's), whether both authored pairs
  are still inside the pooled p10-p90 on every number measure_pair.py compares, and which videos gave nothing and why
  (from their events: no segment with both men side-on, camera cuts, one man out of frame).
- `## Per video` - a table whose FIRST EIGHT cells are exactly: `| <id> | <fps, no decimals> | <frames> | <segments> |
  <both_tracked_s, 1 decimal> | <punches> | <head-height jabs> | <yes/no slow motion> |`, one row per batch-3 video, a
  header row first; a ninth cell may hold your note. "Head-height jabs" counts that video's punches with `lead` true and
  |wrist_vs_receiver_nose_T| <= 0.4.
- `## Jabs to the head: batch 2 v batch 3 v pooled` - one row per statistic of `jabs_head_height`, first four cells exactly
  `| <key> | <batch 2> | <batch 3> | <pooled> |`, each value `p10 / p50 / p90 (n)` with two decimals, or `- (0)` when n is
  0; the batch 2 value comes from `footage_batch2_two_men.json` and is `-` for a key that file does not have.
- `## The next exchanges (pooled)` - rows `| <group> | <punches> | <gap_T_before> | <gap_T_peak> | <thrower_hips_out_T> |
  <extension_s> |` for `rear_head_height`, `lead_body`, `rear_body`, values formatted as above.
- `## Combinations (pooled)` - rows `| <name> | <n> | <peak_to_onset_s> | <peak_to_peak_s> | <returned_share, 2 decimals or -> |`
  for `all` then `lead->lead`, `lead->rear`, `rear->lead`, `rear->rear`, from `footage_two_men.json`'s `combinations` block.
  WHY (added 2026-09-14 after the operator watched the pair in the live fight - "About the same", next "Smooth the jab in
  combos", and "the body of right is folding unnaturally"): the next session makes a jab enter and leave a combination
  smoothly, and our room's engine can land one man's blows 0.1 s apart. DECISIONS must state the pooled
  `thrower_hips_drop_T` of `jabs_head_height` (our authored jab's thrower sinks about 0.17 T - measured from the pair file)
  and the pooled `peak_to_onset_s` of `all` combinations, by key.
- `## measure_pair` - both commands of step 4, each output pasted verbatim inside its own ```text fence.
- `## Population` - the pooled JSON's population string, verbatim.

## Deliver

`git restore --staged -- AgentComms/messages` first. Commit ONLY the three owned files with their paths on the commit
line, `git show --stat HEAD`, `git push -u origin qwen/q108-footage-batch3`, then `python Tools/agent_comms.py send --from
qwen --to claude --topic "Q108 ready" --body "<the Q108_CHECK line> - <jabs_head_height n pooled>"`. If the check fails:
no commit, no push, `--topic "Q108 BLOCKED" --body "<the FAIL lines>"`. Do not edit HANDOFF.md or AgentComms/roadmap.json.

## The trap

Two of your earlier digests said the opposite of their own numbers in a DECISIONS sentence. Write each sentence from the
JSON row in front of you, and read "moved" as the POOLED p50 against BATCH 2's p50 - not batch 3 against batch 2. And do
not delete a video before the check says READY_TO_DELETE: a deleted video cannot be re-tracked.

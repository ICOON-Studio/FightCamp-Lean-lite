# TASK C102 — CODEX — DOES MATCHING THE REST SILHOUETTE REMOVE THE OFFSET?

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex.
Stage: S4a (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`). Follows your C100 and C101.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_silhouette_fix.gd` — **NEW, yours.**
- `research/C102_SILHOUETTE_FIX.md` — **NEW, yours.**
- `research/C102_silhouette_fix.json` — **NEW, yours.**

Do NOT edit `FightClipRetarget.gd`, `BoneRestFixer.gd`, or your C100/C101 tools and files. The
prototype lives entirely inside the new tool.

## Why this exists

Your corrected C101 found the retarget error is mostly a CONSTANT OFFSET: elbows 14.2° constant
against 5.1° of motion (89%), knees 79–86%, shoulders 65%, hip_l 76% — and each fighter's REST-pose
angle difference predicts it (elbows r=0.97, knees r=0.93–0.99). Our correction aligns each bone's
rest ORIENTATION between the rigs; it does not make the two rest SILHOUETTES match, so a fighter
whose rest elbow is bent where the source's is straight carries that bend into every frame.

Godot's own importer has exactly this fix — `retarget/rest_fixer/fix_silhouette` (Qwen's Q82,
`research/Q82_GODOT_RETARGET_VS_OURS.md`, OPTIONS section). This task measures what a
silhouette-matched rest would do to OUR numbers, before anyone edits the retarget.

## Where things are

- `Godot/tools/measure_retarget_frames.gd` — yours, 201 lines, read whole: population, sampling,
  tripwire, global-pose composition, C100's metrics.
- `Godot/scripts/BoneRestFixer.gd` — 89 lines, read whole: how a correction is built and applied
  per frame (`pose_frame`). Do not edit it — call it, or reproduce what you need inside your tool.
- `Godot/scripts/FightClipRetarget.gd` — windows `sed -n '46,120p'` and `sed -n '140,245p'`.
- `research/Q82_GODOT_RETARGET_VS_OURS.md` — the OPTIONS and "What the engine does that
  ours does NOT" sections only: what fix_silhouette does.

## The contract

1. **OFF**: C100's pipeline unchanged. Its per-row `angle_mean_deg` and `angle_max_deg` must equal
   `C100_retarget_by_frame.json` within 0.01° for every one of the 336 rows — the tripwire that
   says your tool measures what C100 measured.
2. **ON**: before retargeting, adjust each FIGHTER's rest so that, in the rest pose, every segment in
   R108's `SEGMENTS` points the same direction as the same segment of the source T-pose (the
   minimal rotation aligning the two segment directions, applied parent before child from the
   hips outward). Build the corrections from that adjusted rest, retarget, and measure C100's
   metrics on the same 336 rows.
3. Report per joint (pooled): OFF mean / p95 / max and ON mean / p95 / max; per fighter the same;
   and the ten rows whose ON error is WORSE than OFF, if any. A fix that trades an elbow offset for
   a twisted forearm is a finding - say so.

JSON:

```json
{
  "tripwire": {"clip": "H2H_HitReaction01.FBX", "fighter": "f01_m_box_welter", "samples": 9,
               "fixed_mean_deg": 7.21, "fixed_max_deg": 19.64},
  "rows": [{"path": "...", "start_s": 0.0, "end_s": 0.0, "fighter": "...",
            "off_angle_mean_deg": 0.0, "off_angle_max_deg": 0.0,
            "on_angle_mean_deg": 0.0, "on_angle_p95_deg": 0.0, "on_angle_max_deg": 0.0, "on_worst_joint": "..."}],
  "joints": {"elbow_l": {"off_mean_deg": 0.0, "off_p95_deg": 0.0, "off_max_deg": 0.0,
                         "on_mean_deg": 0.0, "on_p95_deg": 0.0, "on_max_deg": 0.0}}
}
```

The markdown opens with **DECISIONS**: per joint OFF -> ON; the pooled mean OFF -> ON; how many of
336 rows got worse; and one plain line: does a silhouette-matched rest remove most of the retarget
error or not. Say what the adjustment does NOT fix (C101's motion part; Q82's dropped position tracks).

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_silhouette_fix.gd`
2. The R108 tripwire (7.21 / 19.64 ±0.05), then OFF against C100 row by row, BEFORE computing ON.
3. `python C:\Users\user\AppData\Local\Temp\FightCamp-tools\godot_run.py . tools/measure_silhouette_fix.gd --timeout 1800`
4. `python research/C102_check.py` — must exit 0 before you commit.

## The trap specific to this task

**Measuring the fix with the fix.** If the ON rest is adjusted to match the source silhouette and you
then measure error against a source ALSO read through the adjusted rest, the error goes to zero by
construction. The source side of every comparison stays exactly as C100 read it; only the fighter's
rest changes. The gate compares OFF to C100 row by row for this reason.

## When you are done

The three owned files by path, `git show --stat HEAD` (exactly three), `git push origin master`, then
`python Tools/agent_comms.py send --from codex --to claude --topic C102 --body "<one line>"` and commit
that mail file by path. Do NOT edit `HANDOFF.md`. Never stash, reset --hard, checkout . or clean.

# TASK C100 — CODEX — THE RETARGET, MEASURED ON EVERY FRAME AND EVERY BODY

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex.
Stage: S4a, "why the bought clips look bad" (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`).

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate on your new
tool, then run it. No test suite, no `run_tests.py`.

## Owned files

- `Godot/tools/measure_retarget_frames.gd` — **NEW, yours.**
- `research/C100_RETARGET_BY_FRAME.md` — **NEW, yours.**
- `research/C100_retarget_by_frame.json` — **NEW, yours.**

Do NOT edit any other file: no script, no test, no data, no `.import`, not `HANDOFF.md`, not
`AgentComms/roadmap.json`. Stage explicit paths only.

## Why this exists

The operator watched the retargeted RamsterZ clips and said they look "pretty bad".
`FightClipRetarget` reports itself as working because R108 measured **FIXED mean 7.21° / max
19.64°** — but that was ONE clip (`H2H_HitReaction01.FBX`), ONE body (f01) and NINE samples.
Nobody has measured the others. This task measures all of them, on every frame, so the S4a
session knows where the error lives: in a few joints (an axis correction — cheap) or spread
across the body with the reach and the feet wrong (proportions — needs IK).

## Where things are

- `Godot/tools/measure_r108_retarget.gd` — **576 lines, read it whole: it is the instrument
  you are generalising.** Its `SEGMENTS` and `JOINTS` (lines 59–80) are the metric: angles
  BETWEEN two segments of one body, frame-invariant, so the two rigs need no world alignment.
  Its comments at 240–275 carry the trap below.
- `Godot/scripts/FightClipRetarget.gd` — 432 lines. Windows: `sed -n '46,120p'` (the UE4 map
  and `build_corrections`), `sed -n '140,245p'` (`retarget_clip` and the cached source
  frames), `sed -n '375,432p'` (`_local_at`, `_globals`, `_to_ours`).
- `Godot/scripts/FightClipBinding.gd` — 818 lines. **Do not open it whole.** The population
  is `FightClipBinding.BINDINGS` (the const at line 25): every entry and every `variants` row
  whose `path` is under `res://assets/anim/audition/ramsterz_h2h/`, each with its own
  `start_s` / `end_s` window. Read it from the script at run time; do not copy the list.
  Example entry: `sed -n '82,99p'`.
- `Godot/scripts/FightWorldStage.gd:31` — `mount(world, glb_path, spawn_name, deck_y, kg, sex)`.
- The twelve bodies: `Godot/assets/models/fighters/f??_*_rigged.glb` (glob them).

## The contract

For every (binding window, fighter) pair — every distinct `(path, start_s, end_s)` from
`BINDINGS` against all twelve fighters — retarget the clip onto that fighter exactly as the
game does (`FightClipRetarget.build_corrections` with the binding's `reference`, then
`retarget_clip` at **30 fps** over the window), and on EVERY frame measure:

1. **Joint angles** — R108's `JOINTS`, source vs retargeted, absolute difference in degrees.
2. **Reach** — for each arm, |hand − upper-arm joint| ÷ (upper-arm + forearm length), source
   vs retargeted, absolute difference. The same for each leg: |foot − upper-leg joint| ÷ leg
   length. Dimensionless.
3. **Floor** — the lowest of LeftFoot / RightFoot / LeftToes / RightToes in world Y on the
   retargeted body, minus the same lowest point in that body's rest pose, in metres
   (negative = through the floor, positive = floating), and also divided by the body's height.

JSON, exactly this shape:

```json
{
  "tripwire": {"clip": "H2H_HitReaction01.FBX", "fighter": "f01_m_box_welter", "samples": 9,
               "fixed_mean_deg": 7.21, "fixed_max_deg": 19.64},
  "population": {"windows": [{"path": "...", "start_s": 0.0, "end_s": 0.0}],
                 "fighters": ["f01_m_box_welter", "..."]},
  "rows": [{"path": "...", "start_s": 0.0, "end_s": 0.0, "fighter": "...", "frames": 0,
            "angle_mean_deg": 0.0, "angle_p95_deg": 0.0, "angle_max_deg": 0.0,
            "worst_joint": "...", "worst_t": 0.0,
            "reach_arm_max_diff": 0.0, "reach_leg_max_diff": 0.0,
            "floor_min_m": 0.0, "floor_max_m": 0.0, "floor_min_height_frac": 0.0}],
  "joints": {"elbow_l": {"mean_deg": 0.0, "p95_deg": 0.0, "max_deg": 0.0}}
}
```

`tripwire` holds the numbers YOUR tool produced on R108's own sampling, not R108's printed ones.

The markdown opens with **DECISIONS**: the ten worst rows by `angle_max_deg`; the worst joint
pooled across everything; whether the error is concentrated in a few joints or spread across
all of them; the worst reach difference; the worst floor penetration and float. Then the
per-joint table, then the per-fighter table. Name the population in the first paragraph.

## The traps — each one has already cost a pass on this project

1. **Headless `Skeleton3D.get_bone_global_pose()` returns the REST pose** and nothing you do
   moves it. It does not error: two R108 runs reported two strategies as byte-identical
   because both columns were f01's rest read back. Compose globals down the parent chain from
   `get_bone_pose()` yourself, exactly as `measure_r108_retarget.gd` does.
2. **The tripwire comes first.** Before any other number: your tool on f01 +
   `H2H_HitReaction01.FBX` at R108's own nine samples must reproduce `FIXED mean 7.21° / max
   19.64°` within ±0.05°. If it does not, STOP, write why in the markdown, and publish no rows.
3. **A clip file's `length` is not its content** (R109). Use each binding's `start_s`/`end_s`.
4. **f06 and f08 are 1.00 m meshes** (C98). Measure them like the others and flag their rows;
   do not rescale anything.
5. **A GDScript runtime error exits 0.** Read the output; a run that prints no rows failed.

## Gate — in this order

1. Parse gate: `python Godot/tools/check_scripts.py Godot/tools/measure_retarget_frames.gd`
   (a parse error HANGS a headless run for its full timeout instead of failing it).
2. Run: `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_retarget_frames.gd`
   — redirect to a log file through a `.cmd` wrapper; the console exe piped into PowerShell
   deadlocks and prints nothing.
3. `python research/C100_check.py` — **must exit 0 before you commit.** It derives the
   population from the repo and checks your JSON against it and against R108's numbers.

## When you are done

`git add -- Godot/tools/measure_retarget_frames.gd research/C100_RETARGET_BY_FRAME.md research/C100_retarget_by_frame.json`,
commit with those paths on the commit line, `git show --stat HEAD` (exactly those three
files — another agent's staged mail has been swept into commits before), push `master`, then
`python Tools/agent_comms.py send --from codex --to claude --topic C100 --body "<one line>"`.
Do NOT edit `HANDOFF.md`. Never `git stash`, `reset --hard`, `checkout .` or `clean`.

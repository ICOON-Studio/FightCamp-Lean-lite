# TASK Q105 — QWEN — "JERKY MOVES": WHY A HAND JUMPS MORE THAN 30 CM IN ONE FRAME

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q105-hand-steps` - Claude creates it from `master` before launch. Push the BRANCH. Stage: S4a (operator,
2026-09-14, asked what looks MOST wrong on the latest build: "Jerky moves").

**Test tier: A NEW TOOL ONLY, NO PRODUCTION SCRIPT EDITED.** Parse gate on the new `.gd`; the tool runs; no
`run_tests.py`. `python research/Q105_check.py` must exit 0 before you commit. **IF THE CHECK FAILS, DO NOT COMMIT
AND DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_hand_steps.gd` - NEW.
- `research/Q105_hand_steps.json`, `research/Q105_HAND_STEPS.md` (20 lines at most) - NEW.

## Why this exists

Claude's `Godot/tools/probe_hand_pop.gd` (read it WHOLE - 120 lines, production driving) counted, on seed 94301 at
`4016a9e`, the (frame, side) pairs where a hand's world position moved more than 30 cm in ONE frame at 30 fps: **524**
with the room as shipped and **508** with the contact solve off. A real punch's fist moves a few centimetres to ~18 cm
a frame in our clips (a jab measured 12.8, 18.0, 12.4 cm), so most of those jumps are something the presentation does -
a take started part-way into its clip, a join, the strike warp moving the whole body, the gap walk - or the clip itself.
We need to know which, by count, before choosing the next fix.

## What to measure

Copy the probe's driving exactly (`configure`, `setup`, `_process(1.0 / 30.0)` per frame until the readout says
`FIGHT OVER`; `contact=off` sets `options["contact_solve"] = false`). Seeds 94301, 51227, 77003, 3 rounds, TWO passes
each: `production` and `contact_off`. Per frame f >= 4 and per side, read from `bone_world` AFTER `_process` returns:
both hands and the hip midpoint (`LeftUpperLeg` and `RightUpperLeg` averaged). With `step` = the larger of the two
hands' world steps from frame f-1 to f (metres), count the pair as a **step** when `step > 0.15` and a **jump** when
`step > 0.30` - exactly the probe's count. For each jump, on that side at frame f:
- `take`, `take_pos` (the AnimationPlayer's current animation and position) and `prev_take` (frame f-1's);
- `take_started`: `take != prev_take`, or the same take whose position went back by more than 0.02 s;
- `frames_into_take`: frames since that side's take last started (0 on the start frame);
- `started_from`: the take playing on the frame before that start (`""` for the bout's first take);
- `start_pos`: the take's position on its start frame; `seeked` = `start_pos > 0.034` (a take `play`ed part-way in);
- `body_step_m`: the hip midpoint's world step; `hand_rel_step_m`: the moving hand's step RELATIVE to the hip midpoint
  (`|(hand_f - hips_f) - (hand_f1 - hips_f1)|`), the arm's own motion;
- `warp_changed`: the room's `warp_offsets()[side]` differs from frame f-1's; `push`: that side's
  `contact_stats()["pushes"]` rose this frame.

`frames[seed]` is the number of `_process` calls made, the last being the call whose readout says `FIGHT OVER`
(19802 / 19802 / 19866 - the realism test's and the jerk census's bouts); that last frame is not counted.

`native_p99_m[take]`: per take name, the 99th percentile of `hand_rel_step_m` (the larger hand) over that take's STEADY
frames in the production pass - frames with `frames_into_take >= 9`, not `seeked` within the last 9 frames, no
`warp_changed` and no `push`. At least 30 steady frames, or the take gets no native figure.

**One cause per jump, the first that applies:**
1. `seek_start` - `seeked` and `frames_into_take <= 2`;
2. `join` - `frames_into_take * (1/30) <= 0.27` and `started_from` is not `""` (a new take or a restart);
3. `warp` - `warp_changed` and `body_step_m > 0.05`;
4. `body_move` - `body_step_m >= 0.5 * step`;
5. `push` - `push` and (`native_p99_m` missing or `hand_rel_step_m > 1.2 * native_p99_m[take]`);
6. `clip_native` - `native_p99_m[take]` exists and `hand_rel_step_m <= 1.2 * native_p99_m[take]`;
7. `unexplained`.

`Q105_hand_steps.json`: `{"population": {"seeds": [94301, 51227, 77003], "rounds": 3, "fighters": "f01_m_box_welter v f09_m_bare_welter", "passes": ["production", "contact_off"]},
"passes": {"production": {"frames": {"94301": n, ...}, "steps": {"94301": n, ...}, "jumps": {"94301": n, ...},
"jumps_by_cause": {cause: n}, "jumps_by_take": {take: n}}, "contact_off": {...same...}},
"native_p99_m": {take: x}, "rows": [the production pass's jump rows, every field above plus "seed", "frame", "side", "step_m", "cause"]}`.

`Q105_HAND_STEPS.md` opens with `## DECISIONS`: per pass, the jump total and its split by cause (counts and shares), the
three takes with the most jumps, and one line naming the cause to fix first - numbers copied from the JSON.

## Commit and send

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD` (exactly
those 3 files); `git push -u origin qwen/q105-hand-steps`; `python Tools/agent_comms.py send --from qwen --to claude
--topic Q105-ready --body <hash>`. If the check fails: no commit, no push; send `--topic "Q105 BLOCKED"` with the FAIL
lines. Do not edit HANDOFF.md, AgentComms/roadmap.json or any other file. Never `git stash`, `reset`, `checkout .`,
`clean`, `rebase` or `merge`.

## The trap

The check pins seed 94301's counts to Claude's probe (production 2344 steps / 524 jumps; contact_off 1936 / 508) - a
count off by one means your frame loop, your `f >= 4` start or your `>` is not the probe's. And the causes must add up to
the jumps: a jump that fits no rule is `unexplained`, never dropped. Never write your own pose sampler or clip player -
every number comes from the live room and `bone_world` (Q101 was rejected for exactly that).

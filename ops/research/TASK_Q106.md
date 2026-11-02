# TASK Q106 — QWEN — "JERKY MOVES": THE ISOLATED-SPIKE CENSUS, EVERY SEED AND EVERY SWITCH, AS ONE INSTRUMENT

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`, branch
`qwen/q106-spike-census` - Claude creates it from `master` before launch. Push the BRANCH. Stage: S4a (operator,
2026-09-14, asked what looks MOST wrong: "Jerky moves").

**Test tier: A NEW TOOL ONLY, NO PRODUCTION SCRIPT EDITED.** Parse gate on the new `.gd`; the tool runs; no
`run_tests.py`. `python research/Q106_check.py` must exit 0 before you commit. **IF THE CHECK FAILS, DO NOT COMMIT
AND DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_spikes.gd` - NEW.
- `research/Q106_spikes.json`, `research/Q106_SPIKES.md` (20 lines at most) - NEW.

## Why this exists

A jerk census scores a fast punch like a glitch: a hook's fist moves 11, 15, 19, 40, 50, 36, 15, 5 cm a frame - smooth.
What a viewer calls "jerky" is an ISOLATED step: a point that moves far in one frame while the frames either side barely
move. Claude's `Godot/tools/probe_spikes.gd` (read it WHOLE - 127 lines) counts exactly that on one seed and found the
jab's bought clip snapping its arm 130-140 times a bout. It becomes the gate for every smoothing fix from here on, so it
needs all three realism seeds, the switches that separate causes, and a JSON.

## What to measure

Copy `probe_spikes.gd`'s driving and its spike rule EXACTLY: `configure`, `setup`, `_process(1.0 / 30.0)` per frame,
stopping BEFORE counting the frame whose readout says `FIGHT OVER`; per side, per point (`Head`, `LeftHand`, `RightHand`,
`Hips` = the `LeftUpperLeg`/`RightUpperLeg` midpoint, `LeftFoot`, `RightFoot`) from `bone_world`; a SPIKE is the middle
step of three consecutive steps `[s(f-2), s(f-1), s(f)]` with `s(f-1) > 0.08` m and `s(f-1) > 2.5 * max(s(f-2), s(f))`,
judged only from frame index 4, and attributed to the frame-(f-1) context (its take with the `#variant` suffix cut for
`by_take`, its position, the previous frame's take, the contact push, the warp change).

Seeds 94301, 51227, 77003, 3 rounds, FOUR passes each (the options `configure` gets):
- `production` - nothing added;
- `contact_off` - `{"contact_solve": false}`;
- `push_release_0.20` - `{"push_release_s": 0.2}`;
- `contact_off_warp_off` - `{"contact_solve": false, "strike_warp": false}`.

`Q106_spikes.json`: `{"population": {"seeds": [94301, 51227, 77003], "rounds": 3, "fighters": "f01_m_box_welter v f09_m_bare_welter"},
"rule": {"min_m": 0.08, "ratio": 2.5, "points": ["Head", "LeftHand", "RightHand", "Hips", "LeftFoot", "RightFoot"]},
"passes": {"production": {"options": {...}, "seeds": {"94301": {"frames": n, "spikes": n, "by_point": {point: n}, "by_take": {take: n},
"top": [{"frame", "side", "point", "step_cm", "before_cm", "after_cm", "take", "pos", "prev_take", "push", "warp_changed"} x at most 40, largest step first]}, ...},
"totals": {"spikes": n, "by_point": {...}, "by_take": {...}}}, "contact_off": {...}, "push_release_0.20": {...}, "contact_off_warp_off": {...}}}`
where `frames` counts the `_process` calls whose readout did not say `FIGHT OVER`, and `by_point` / `by_take` list only
non-zero counts.

`Q106_SPIKES.md` opens with `## DECISIONS`: per pass the spike total, its share of `production`'s, the three takes with the
most spikes, and one line on what the contact solve and the warp each add - numbers copied from the JSON.

## Commit and send

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD` (exactly
those 3 files); `git push -u origin qwen/q106-spike-census`; `python Tools/agent_comms.py send --from qwen --to claude
--topic Q106-ready --body <hash>`. If the check fails: no commit, no push; send `--topic "Q106 BLOCKED"` with the FAIL
lines. Do not edit HANDOFF.md, AgentComms/roadmap.json or any other file. Never `git stash`, `reset`, `checkout .`,
`clean`, `rebase` or `merge`.

## The trap

The check pins seed 94301 in three passes to Claude's probe counts point by point and take by take (production 351,
contact_off 211, push_release_0.20 334, contact_off_warp_off 190): a count that is off means your loop is not the
probe's - compare your history handling line by line (which step is the middle one, and whose context it carries) before
anything else. Never write your own pose sampler - every number comes from the live room and `bone_world`.

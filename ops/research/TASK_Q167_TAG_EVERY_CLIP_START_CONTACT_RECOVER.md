# TASK_Q167 - tag every bound strike clip: START, CONTACT, RECOVER-TO-GUARD (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S65, 2026-09-24. **Runs after Q166 round 2, BEFORE Q164.**

## Why (the operator's priority)
Operator, 2026-09-24 (verbatim): "We are not buying other clips unless I see the quality that I see on the YouTube
preview videos. ... I want this fixed." Grok G87 (`research/G87_PREVIEW_QUALITY.md`, section 3 C) names the
data the fix needs: every owned strike clip tagged with three times - **start** (the chamber begins), **contact**
(the fist/foot/knee/elbow reaches its furthest extension toward the target) and **recover** (the limb is back at the
guard pose). Codex C190 will make the clip's CONTACT time the simulation's hit time and let the next decision wait
for RECOVER. Nobody has these numbers: G87 says "UNKNOWN exact native times until we inspect the FBXs - do that first."

## The work
A new tool `Godot/tools/q167_tag_clip_phases.gd` that, for every clip bound in `scripts/FightClipBinding.gd` whose
role is a strike (punches, kicks, knees, elbows - list the roles you included and why), plays it on ONE fighter rig
at native speed, no layers, no IK, 60 samples per second, and records the striking effector's position relative to
the chest. Define, and print the definition in the output:
- **contact** = time of peak extension along the strike direction (effector-chest distance max), refined by the
  effector's speed minimum near it;
- **start** = last time before contact where the effector's speed rises above 10% of its peak;
- **recover** = first time after contact where the effector is back within 0.08 m of its position at t=0 (the guard)
  and its speed is under 10% of peak - or the clip end, flagged `NO_RETURN`.
Write `Godot/assets/data/clip_phases.json`: `{clip_key: {start_s, contact_s, recover_s, length_s, effector, peak_speed_mps, returns: bool}}`.
Then a summary: per role, the median and range of contact_s and recover_s, and every clip flagged `NO_RETURN` or
whose contact is under 0.10 s (a clip that starts already extended). Name the rig and the population in the output.

## Owned files
New files only: `Godot/tools/q167_tag_clip_phases.gd`, `Godot/assets/data/clip_phases.json`, `research/Q167_DIGEST.md`,
and a new blind-free unit test `Godot/tests/clip_phases_data_test.gd` (every bound strike has an entry;
0 <= start < contact < recover <= length; the JSON loads).

## Gate (tier: new files only)
`python Godot/tools/check_scripts.py <new .gd>`; then the one test:
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/clip_phases_data_test.gd`
(the _console exe prints; the plain exe does not). No suite. Branch `qwen/q167-clip-phases`, worktree off
`origin/master`, `--headless --import` once first. Commit, push, `python Tools/agent_comms.py send --from qwen --to claude --topic Q167 --body "..."`.
Do NOT edit HANDOFF.md. Never commit an .avi.
Trap: a clip whose first frame is already extended has contact near 0 s - that is a FINDING (it is a "bullet"), not a tool bug.

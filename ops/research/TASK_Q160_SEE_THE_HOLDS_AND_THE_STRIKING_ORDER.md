# TASK_Q160 - SEE the 21 holds the family map leans on, and price the 66-technique striking gap (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S62, 2026-09-24, after Q159.

## Why
Q157/Q158/Q159 mapped 176 grappling techniques onto the owned paired holds and 120 striking
techniques onto owned strike clips, all by seat, limb and line - and nobody has yet LOOKED at the
holds those 176 lean on (Q158 Part 1 analysed the mapping and never rendered a frame). The
operator's standing rule: a filename is not something a human can look at. And the 66 striking
techniques Q159 left as NONE are the striking authoring order, but they are a list, not a priced one.

## Part 1 - render every hold the family map uses
`Godot/tools/render_paired_hold.gd` renders an authored/owned paired hold to 24 frames (4 views x 6)
in `clip_audit/paired/`. It is WINDOWED: launch it through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 900x640 --script tools/render_paired_hold.gd -- <Key>`
where `<Key>` is the pair key (e.g. `Cascy_SideControl`; for RamsterZ pairs read the key the tool
expects from its header, lines 60-75). Render EVERY pair key that `PAIRED_FAMILY_BINDINGS` (after
Q159) references - Q158 counted ten. For each, pick the clearest `side__02` and `high__02` frame and
copy them to `previews/family_holds/<key>_side.png` / `_high.png`. In the digest, under
each pair of frames, list the count and first ten technique ids mapped to that hold, and ONE line of
your own read of the picture (what seat the bodies actually show). Where the picture contradicts the
seat name (the Cascy_Turtle render shows the bottom man FLAT, not on knees and elbows - a sprawl over
a flattened man), say so; that row goes to the digest's "holds that lie about themselves" list. Do
not remove bindings in this task; the list is the deliverable.

## Part 2 - price the striking gap
The 66 NONE striking techniques from Q159: group them by limb and line (lead/rear straight, hook,
uppercut, elbow family, knee family, round kick, front/teep, side kick, spinning, axe/crescent, ...),
count per group, and for each group name the ONE clip that would cover the most of them - with its
source (a RamsterZ pack we own but have not sliced, a Cascadeur authoring, a Higgsfield single-actor
text-to-motion at 0.1 credit). Where a RamsterZ pack we OWN already holds the motion (grep
`FightClipBinding.gd` for the pack folder names and list the unbound files in those folders), that is
free coverage: bind it as FAMILY with the reason and count it. Output: a table ranked by techniques
unlocked per clip, and the new coverage numbers from `q133_clip_coverage.gd`.

## Owned files
`previews/family_holds/*.png` (new), `Godot/scripts/FightClipBinding.gd` (Part 2 free
bindings only, windows), `research/Q160_DIGEST.md` (new). Nothing else.

## Gate
Parse gate on any .gd touched; `run_tests.py --only fight_hold_binding,paired_clip_mount,fight_clip_alias,fight_beat`;
coverage tool before/after Part 2. No suite. Branch `qwen/q160-see-the-holds`; fresh worktree off
`origin/master`; on a "TitleHonours" parse error run `--headless --import` once. One `send` per part.
Do NOT edit HANDOFF.md. Trap: the render tool refuses when one half of a pair is missing and says
so - a key that refuses is itself a finding (a hold bound to a clip that is not on disk).

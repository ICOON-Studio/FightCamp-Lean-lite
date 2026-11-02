# TASK_Q161 - teach render_paired_hold the RamsterZ FBX pairs, render all eight, re-run the seat read (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S63, 2026-09-24, after Q160.

## Why
Q160 found `Godot/tools/render_paired_hold.gd` (557 lines) is hard-coded to
`CASCADEUR_DIR/<Key>_Att.glb` (lines 69-80), so it REFUSES 7 of the 8 RamsterZ `.fbx` pairs that
176 grappling techniques lean on through `PAIRED_FAMILY_BINDINGS`. Only Cascy_SideControl was ever
seen. A binding nobody has looked at is not coverage (the operator's standing rule: a filename is
not something a human can look at).

## Part 1 - the tool resolves any pair key
Where the key is not a Cascadeur pair, resolve the Att/Vic clip paths from the binding tables in
`Godot/scripts/FightClipBinding.gd` (`PAIRED_BINDINGS` :1837, `PAIRED_STRIKE_BINDINGS` :1962 -
read their entry fields, do not guess) and load them through the SAME retarget path the live room
uses for RamsterZ (grep `FightClipRetarget` for the `.fbx` loader; `_load_fbx` dispatches on
extension). Cascadeur keys must render byte-for-byte as before (render Cascy_SideControl before and
after your change and compare the PNGs' hashes - say so in the digest).

## Part 2 - render all eight, and read each
Render every pair key `PAIRED_FAMILY_BINDINGS` (:2100) references. Launch WINDOWED through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --resolution 900x640 --script tools/render_paired_hold.gd -- <Key>`.
Copy the clearest `side__02` and `high__02` per key to `previews/family_holds/`.
**OPEN each PNG yourself** and write ONE line of what the bodies actually show. Then update
`Q160_DIGEST.md`'s "Holds that lie about themselves" list into your own digest: for each hold whose
picture contradicts its seat name, list the technique ids bound to it (count + first ten).

## Owned files
`Godot/tools/render_paired_hold.gd`, `previews/family_holds/*.png`,
`research/Q161_DIGEST.md` (new). Nothing else - no binding edits in this task.

## Gate (tier: a tool edited)
`python Godot/tools/check_scripts.py Godot/tools/render_paired_hold.gd`; then
`python Godot/tools/run_tests.py --only paired_clip_mount,fight_hold_binding`. No suite.
Branch `qwen/q161-ramsterz-holds`, fresh worktree off `origin/master`; on a "TitleHonours" parse
error run `godot --headless --path Godot --import` once. One `python Tools/agent_comms.py send` per
part. Do NOT edit HANDOFF.md.
Trap: a RamsterZ clip that loads but plays at REST (every track skipped) renders two men in T-pose
and "passes" - a freshly retargeted clip names tracks with a bare bone name (`get_subname_count()`
is 0). If a render shows a T-pose, that is the bug, not the hold.

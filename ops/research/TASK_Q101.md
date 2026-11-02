# TASK Q101 — QWEN — EVERY FIGHTING MOTIONS CLIP ON f01: A CENSUS BEFORE ANY BINDING

Model: `qwen3-coder`, medium, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`,
branch `qwen/q101-fm1-census` - Claude creates it from `master` before launch. Push the BRANCH.
Stage: S4a - measurement before a build (feeds R2's stance takes and the rear hook).

**Test tier: A NEW TOOL FILE ONLY.** Parse gate on your tool (`python Godot/tools/check_scripts.py
Godot/tools/measure_fm1_takes.gd`), then run it. No suite, no production script edited.
`python research/Q101_check.py` must exit 0 before you commit. ONE Godot at a time in your worktree.

## Owned files

- `Godot/tools/measure_fm1_takes.gd` - NEW, yours. Copy helpers from the two tools below; do NOT edit them.
- `research/Q101_fm1_takes.json` - NEW, written by your tool.
- `research/Q101_FM1_TAKES.md` - NEW, 35 lines at most.

## Why this exists

Your Q100 mapped the free Fighting Motions Vol.1 rig (Magicpot, pack `magicpot_fighting_motions_vol1`, status
'candidate') onto ours: 21 of 22 bones by name, no UpperChest, BlueGuy.fbx the T-pose rest. Two decisions now wait
on what those clips look like ON OUR FIGHTER through PRODUCTION's retarget: the operator ruled that idle_A and
idle_Tiramis join the stance rotation, and our rear hook is a mirrored lead hook that swaps the feet - the pack has
bp_hook_right_A. Your Q100 also said idle_A/idle_Tiramis "bake in stance transforms"; that is UNVERIFIED (their rest
angles equal BlueGuy's). Measure every clip once, the same way, beside the takes we ship.

## What to read - ONLY these

- `Godot/tools/probe_take_skate.gd` (136 lines, read whole): binding f01 through FightStagePlayer, playing a take
  alone on a still node, the lower-toe skate measure, `_globals`, `_world_of`, `_parent_first`.
- `Godot/tools/measure_hook_splice.gd`: setup `:36-60` (the stance axes `fwd`, `lat`), `_stance_at` `:281`,
  `_pose_at` `:289`, `_entry_pose_deg` `:296`, `_basis_angle_deg` `:308`, `_foot_metrics` `:321`.
- `Godot/scripts/FightStagePlayer.gd` `:441-500` - production's retarget call order. Reproduce it exactly.
- `Godot/scripts/FightClipRetarget.gd`: `build_silhouette_corrections` `:173-180`, `retarget_clip` signature
  `:312-316`, `sway_of` `:485-490`, `address_tracks` `:579-596`, `_parent_of` `:646-666` (an unmapped bone -
  UpperChest - is skipped to its nearest mapped ancestor; that is production behaviour, measure it as is).
- `research/Q100_fm1_rig.json` - only its `map` array.

## The census

Setup exactly as the probe (boxing, f01 `f01_m_box_welter_rigged.glb`, `SpawnA`, node still, production binding).
`skel_path = String(ap.get_node(ap.root_node).get_path_to(skel))`.

The map: READ `res://research/Q100_fm1_rig.json` at runtime; `FM1_TO_OURS[entry.fm1] = entry.ours` for every entry
whose `fm1` is non-empty (21). Never type the map into the tool.

The clips: LIST `res://assets/anim/audition/magicpot_fm1/` with DirAccess at runtime - every file ending `.fbx`
(case-insensitive, never `.import`) except `BlueGuy.fbx`, named by file name; then every `.fbx` in its `nomove/`
folder, named `nomove/<file>`. REF = `res://assets/anim/audition/magicpot_fm1/BlueGuy.fbx`.

Per clip, production's order: `corrections` = `FightClipRetarget.build_silhouette_corrections(REF, skel, FM1_TO_OURS)`
(once); `sway = FightClipRetarget.sway_of(path, FM1_TO_OURS, 30.0, -1.0, -1.0)`;
`carry = str(sway.get("error", "")) == "" and bool(sway.get("returns", false))`;
`result = FightClipRetarget.retarget_clip(path, skel, FM1_TO_OURS, corrections, 30.0, -1.0, -1.0, REF, carry)`.
If `result.error` is not empty, record it and move on. Else `FightClipRetarget.address_tracks(anim, skel_path)`, add
it to a library `fm1` and play it alone like the probe (`advance(1/30)`; frames = `maxi(2, ceil(length * 30))`, or 60
for a looping animation). Type every value you read from a `load()`ed or preloaded script: `var r: Dictionary = ...`.

Per row measure:
- `name`, `path`, `error`, `length_s`, `frames`, `bones` (result's), `carry`.
- `first`, `last`: `_foot_metrics` stance (`lead`, `split_m`, `width_m`) at frame 0 and the last frame.
- `entry_pose_deg`: `_entry_pose_deg` at frame 0 against production `idle` at frame 0 (U93's ten bones).
- `skate_mean_mps`, `skate_p95_mps`, `planted_frames`, `lowest_toe_m`: the probe's measure, verbatim.
- `head_height_f0_m`: the Head bone's height in the node frame at frame 0.
- `hands_f0`: `{"left_y": .., "right_y": ..}` - both hands' node-frame height at frame 0 (a guard holds them up).
- `hand`: `"LeftHand"` if the file name contains `_left`, `"RightHand"` if `_right`, else `""`.
- `strike`: when `hand` is set, `{"x", "y", "z", "frame"}` - that hand in the NODE frame at the frame of its largest
  z (the probe's facing); `null` otherwise.
A row with an error carries `error` and `name`/`path` only.

REFERENCE rows, the same metrics from the takes production already binds (take 0 = the bare role name):
`idle`, `jab`, `cross`, `hook_lead`, `hook_rear` (hand: jab/hook_lead LeftHand, cross/hook_rear RightHand, idle "").

JSON `res://research/Q101_fm1_takes.json`:
`{"population": {"fighter": "f01_m_box_welter", "binding": "boxing", "node": "still", "fps": 30,
   "pack": "magicpot_fighting_motions_vol1", "reference_pose": "BlueGuy.fbx", "map_source": "Q100_fm1_rig.json", "map_size": 21},
  "idle_first": {...}, "rows": [...], "references": [...]}`

## The digest `Q101_FM1_TAKES.md`

Opens with `## DECISIONS`. (1) idle_A and idle_Tiramis: stance lead / split / width against production idle's,
hands up or not, entry_pose_deg, skate - do they stand in an orthodox boxing stance on f01, and is Q100's claim true?
(2) bp_hook_right_A (and its nomove twin): first lead (does it keep the left foot forward?), strike height and reach
against production hook_rear and hook_lead, skate, entry_pose_deg - and say plainly that "bp" reads as a BODY punch
if the strike height says so. (3) A table of every error-free clip: name -> the role it could fill (jab, cross,
hook_lead, hook_rear, uppercut, react_head, react_body, block, knockdown, getup, walk, other) -> first lead ->
entry_pose_deg -> skate_mean_mps. (4) Any row with an error, with its reason.

## Commit

`git status -s` first. Commit ONLY the three owned files with the paths on the commit line; `git show --stat HEAD`;
`git push -u origin qwen/q101-fm1-census`;
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q101 ready" --body "<hash>"`. Do not edit
HANDOFF.md or AgentComms/roadmap.json. Never `git stash`, `reset`, `checkout .`, `clean`, `rebase` or `merge`.
If more than 16 rows error, do not commit: send `--topic "Q101 BLOCKED"` with the first error verbatim.

## The trap

Read the digest back against the JSON before you commit: a sentence can contradict the row it summarizes, and the
check reads only the JSON. And the census is only as good as its instrument - the check pins your `hook_rear` and
`idle` reference rows to Cursor's U93 run of the same measure (`U93_hook_splice.json`), so a skate, a stance or a
reach computed in the wrong frame fails there first.

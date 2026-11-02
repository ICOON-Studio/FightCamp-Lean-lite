# TASK U105 — CURSOR — THE LIVE ROOM MEASURED LIKE FOOTAGE: OUR BOUTS THROUGH THE SAME INSTRUMENT AS REAL BOXERS

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U80`,
branch `cursor/u105-room-track` (Claude creates it from `origin/master` before launch - do not switch branches). Push the
BRANCH. Stage: S4a (SMOOTH THE JAB IN COMBOS).

**Test tier: DEV TOOLS ONLY** (`tools/` and `Tools/` are not shipped). Parse gate on your `.gd` file
(`python Godot/tools/check_scripts.py Godot/tools/export_room_track.gd`), the six runs below, then `python
research/U105_check.py` must print `U105_CHECK PASS`. No suite, no test file. **IF THE CHECK DOES NOT PASS, DO NOT
COMMIT AND DO NOT PUSH: send the BLOCKED mail with its FAIL lines.** Never edit `U105_check.py`, any file under
`Godot/scripts/`, `Tools/footage/pair_events.py`, `Tools/footage/fold_footage.py` or `Tools/footage/rig_landmarks.json`.

## Owned files (these only)

- `Godot/tools/export_room_track.gd` - NEW, `extends SceneTree`, headless.
- `Tools/footage/room_to_track.py` - NEW: the exporter's output -> a two-man track `.npz` pair_events.py reads unchanged.
- `research/S4A_PAIRS/room_two_men_pairs_on.json`, `room_two_men_pairs_off.json` - NEW, written by `fold_footage.py`.
- `research/U105_ROOM_AS_FOOTAGE.md` - NEW, 80 lines at most.

## Why this exists

The operator judged our scripted jab inside the live fight "About the same" and chose "Smooth the jab in combos". Every
number we hold about REAL boxers (`research/S4A_PAIRS/footage_two_men.json`: 104 head-height jabs, 36 combinations)
comes from `Tools/footage/pair_events.py` reading MediaPipe landmarks tracked from two-man video. Our room has so far been
measured by other instruments, so "the room v real boxers" was always two tools apart. This task removes that gap: turn
the room's two posed skeletons into the same 33 landmarks (`Tools/footage/rig_landmarks.json`, the contract) and run the
UNCHANGED footage tools on them. The first questions it answers: how soon after one punch our fighters throw the next
(real: next onset 0.35 s after the last peak, p10 0.17 s, hand back first 94%) and how our head jabs compare, played as
the authored pair or as clips.

## `tools/export_room_track.gd`

`-- seed=<int> pairs=on|off out=<path without extension> [until=<seconds>]`

1. Mount the room EXACTLY as the realism test does: read `Godot/tests/fight_stage_realism_test.gd` lines 112-115 and the
   `pairs=off` branch near line 146 (options `{"seed": seed, "rounds": 3}`, plus `"pair_moves": false` for `pairs=off`),
   and how it instantiates `res://scenes/FightWorldLive.tscn`, calls `configure` then `setup`. Step with
   `live.call("_process", 1.0 / 30.0)` exactly like `Godot/tools/probe_pair_live.gd` (read it whole, 91 lines) until the
   bout is over (the realism test's stop condition) or `presented_seconds() >= until`.
2. Bodies: `live.call("stage_players")` -> `[A, B]`. A joint = `player.call("bone_world", <bone>)` (headless-safe; never
   `get_bone_global_pose`). The fight line: on the FIRST stepped frame take both `player.call("skeleton_world").origin`,
   zero their y, `axis = (B - A).normalized()`, `mid = (A + B) / 2`, `across = axis.cross(Vector3.UP)`; freeze all three
   for the bout. For every mapped landmark of `rig_landmarks.json` `map` (15 bones), store `line_m = (p - mid).dot(axis)`,
   `height_m = p.y - canvas_y`, `across_m = (p - mid).dot(across)`. The canvas is not at y = 0: `canvas_y` is read once,
   on the first stepped frame, as `probe_pair_live.gd`'s `_toe_above` reads its floor - the lowest of both men's
   `LeftToes`/`RightToes` REST origins through their own `skeleton_world()` (where the mount stands a man).
3. Output `<out>.bin`: float32 little-endian, frame after frame, A then B, the 15 mapped landmarks in ascending index order
   (`0, 11, 12, 13, 14, 15, 16, 23, 24, 25, 26, 27, 28, 31, 32`), each `line_m, height_m, across_m` - 90 floats a frame.
   `<out>.json`: `{"format": "fightcamp.room_track", "seed", "pairs": "on"|"off", "fps": 30, "frames", "canvas_y",
   "landmarks": [0, 11, ...], "torso_m": {"A": A.torso_length_m(), "B": ...}, "fighters": {"A": <mesh path>, "B": <mesh
   path>}, "population": "<one line>", "pair_stats": live.pair_stats() at the end, "frames_sidecar": {"show_s": [...], "a_take":
   [...], "a_pos": [...], "b_take": [...], "b_pos": [...], "pair_id": [...], "pair_s": [...]}}` - takes and positions from
   each player's `animation_player()` (`current_animation`, `current_animation_position`), pair from `pair_state()` ("" and
   -1.0 when none).
   The population string names: the room, boxing, 3 x 180 s rounds, A = f01 gloved / B = f09 bare (the realism test's
   mount - two DIFFERENT fighters, the room's out-boxer v pressure puncher), the RamsterZ H2H clip catalogue, the authored
   pairs on or off, the seed, 30 fps, joints mapped per `Tools/footage/rig_landmarks.json`, side-on orthographic.

## `Tools/footage/room_to_track.py <out.json> <out.npz>`

Arrays exactly as `Tools/footage/track_pairs.py` documents (`t`, `img` (F, 2, 33, 5) float32, `world` (F, 2, 33, 3)
float32, `n` all 2, `fps`, `size` (1920, 1080)); slot 0 = A, slot 1 = B. Apply `rig_landmarks.json` literally:
`img x = px_per_m * line_m`, `img y = px_per_m * (y_top_m - height_m)`, `img z = px_per_m * across_m`, visibility and
presence 1.0 on the mapped landmarks and on the nose; `nearest` copies coordinates with visibility and presence 0.0; the
nose = the Head joint raised `nose_up_T * torso_m` (this man's). `world` = metres (line, height, across) minus that
frame's hip-joint midpoint.

## Runs (one Godot at a time; `R=C:/Users/user/AppData/Local/Temp/FightCamp-footage/room`)

For each seed of `94301 51227 77003` and each of `pairs=on`, `pairs=off` (six runs, sequential):
`python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/export_room_track.gd --timeout 1500 --
seed=<s> pairs=<on|off> out=$R/room_<s>_<on|off>` (check its log for `SCRIPT ERROR` after the first minute - a runtime
error hangs until the timeout), then `python Tools/footage/room_to_track.py $R/room_<s>_<mode>.json
$R/room_<s>_<mode>.npz`, then `python Tools/footage/pair_events.py $R/room_<s>_<mode>.npz $R/events_room_<s>_<mode>.json
"room seed <s> pairs <mode> (30 fps)"`. Then fold each mode's three events files:
`python Tools/footage/fold_footage.py --out research/S4A_PAIRS/room_two_men_pairs_<mode>.json --population
"<the header's population, seeds 94301/51227/77003>" 0:$R/events_room_94301_<mode>.json 0:... 0:...`.

## The digest (`U105_ROOM_AS_FOOTAGE.md`) - every number from the JSON files; the check compares them

- `# U105 - the live room measured like footage` then `## DECISIONS` (at most 12 lines): the room's `combinations`
  `all` peak_to_onset p10/p50/p90 and returned_share, pairs on and off, against the footage's; which transitions have a
  p50 below the footage's p10; the room's `jabs_head_height` punches and `thrower_hips_drop_T` p50 on and off against the
  footage; how many of the pairs=on head jabs peaked inside a pair take.
- `## Combinations` - rows `| <name> | <room on> | <room off> | <footage> |` for `all`, `lead->lead`, `lead->rear`,
  `rear->lead`, `rear->rear`; each cell `n=<n> onset <p10>/<p50>/<p90> peak <p10>/<p50>/<p90> back <returned_share>`
  (two decimals; `-` for a None).
- `## Jabs to the head` - one row per key of the `jabs_head_height` block (skip `definition`), `| <key> | <room on> |
  <room off> | <footage> |`, cells `p10 / p50 / p90 (n)` with two decimals (`- (0)` when n is 0; `punches` as a bare int).
- `## Pair or clip` - one row per pairs=on head jab: `| <seed> | <t_peak_s, 2 decimals> | <thrower> | <take at the peak
  frame> | pair|clip |`, where the take is the sidecar's `a_take`/`b_take` for that thrower at the punch's `frame` and
  `pair` means the take name contains `#pair_`.
- `## Population` - the pairs=on fold's population string, verbatim.

## Deliver

`git -C . restore --staged -- AgentComms/messages` first (an earlier task's mail is still staged here). Commit ONLY the
owned files with their paths on the commit line (never the `.bin`/`.npz`/events files - they stay in `$R`), `git show
--stat HEAD`, `git push -u origin cursor/u105-room-track`, then `python Tools/agent_comms.py send --from cursor --to
claude --topic "U105 ready" --body "<the U105_CHECK line> - room on: combinations onset p50 <n> s v footage 0.35 s"`.
If the check fails: no commit, no push, `--topic "U105 BLOCKED" --body "<the FAIL lines>"`. Do not edit HANDOFF.md.

## The trap

A skeleton read headless through `get_bone_global_pose()` is the REST pose, and a body read before the room's first
`_process` has no pose at all: both give a perfect-looking file of men who never move, and pair_events.py then finds
zero punches and reports nothing wrong. The check pins your file to physics (toes on the canvas, a pair's glove reaching
the head on its contact frame) - read the header's `frames` and the events' punch count after the FIRST run, before
running the other five.

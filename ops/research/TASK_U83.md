# TASK U83 — CURSOR — WHERE THE HIPS REALLY GO: THE PELVIS READ BY GODOT'S OWN HIERARCHY

Model: `composer-2.5`, **medium**, `-p --force --trust`. Owner: cursor. Branch `cursor/u83-pelvis-by-tree`
in your worktree.
Stage: S4a step (c) verification (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`).

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_pelvis_by_tree.gd` — **NEW, yours.**
- `research/U83_PELVIS_BY_TREE.md` — **NEW, yours.**
- `research/U83_pelvis_by_tree.json` — **NEW, yours.**

Do NOT edit any other file. `U83_check.py` is Claude's.

## Why this exists

On the retarget sheets the knockdown lies down IN MID-AIR at hip height: `FightClipRetarget` builds
rotation tracks only (`Godot/scripts/FightClipRetarget.gd:275-298`) and drops every position track, so
the pelvis never leaves standing height. S4a will carry the pelvis height across. Qwen's Q83
(`research/Q83_dropped_position_tracks.json`) measured how far each pelvis should drop, by
composing the clip's tracks BY HAND - and it was merged PROVISIONAL with three open caveats:

1. its `physical_tripwire.tpose_pelvis_y_m` holds the IDLE value 0.913, not the T-pose's own;
2. its markdown's formula (root position + root rotation x T-pose offset) contradicts its stated cause
   (that the pelvis track is already a world position);
3. every row reports ZERO horizontal pelvis travel - including both knockdowns, which fall.

A number composed by hand is only as good as the composition. **This task measures the same thing a
second, independent way: let Godot's own scene tree compose it.**

## The method

For each clip: `FBXDocument.append_from_file` + `generate_scene` (as
`Godot/tools/measure_silhouette_fix.gd:23-26` does), `get_root().add_child(scene)`, find its
`AnimationPlayer`, `play(<its one animation>)`, and for each sample time `seek(t, true)` then read
`global_position` of the Node3D named `pelvis`, of `root`, and of `ball_l` / `ball_r` (the toes). The
tree composes every parent, including whatever axis conversion the importer put above the rig.
Sample at 30 fps across each window.

**Population: exactly Q83's 28 rows** (the RamsterZ H2H windows bound in
`Godot/scripts/FightClipBinding.gd` BINDINGS, with their variants - the same `_windows()` as
`measure_silhouette_fix.gd:141-150`), plus two reference clips with no window: `T_pose.fbx` read with
NO animation applied (its hierarchy is the T-pose), and `H2H_Idle.FBX`.

For the three caveats, measure directly:
1. the pelvis height of `T_pose.fbx`'s hierarchy, no animation;
2. at five evenly spaced times in `H2H_KnockDown01.FBX`: the RAW value of the pelvis position track
   (`Animation.position_track_interpolate`), the pelvis node's `position` (local) and its
   `global_position` - and say which of local or global the raw track equals, within 1 mm;
3. both knockdowns' pelvis horizontal travel (net start-to-end on the floor plane, and path length).

JSON:

```json
{
  "method": "scene tree global_position after AnimationPlayer.seek(t, true)",
  "floor": {"idle_lowest_toe_y_m": 0.0},
  "tpose": {"pelvis_y_m": 0.0},
  "idle": {"pelvis_y_min_m": 0.0, "pelvis_y_max_m": 0.0},
  "track_space": {"clip": "H2H_KnockDown01.FBX",
                  "samples": [{"t_s": 0.0, "raw_track": [0, 0, 0], "local": [0, 0, 0], "global": [0, 0, 0]}],
                  "raw_track_equals": "local | global | neither"},
  "rows": [{"path": "...", "start_s": 0.0, "end_s": 0.0, "frames": 0,
            "pelvis_y_min_m": 0.0, "pelvis_y_max_m": 0.0, "pelvis_y_final_m": 0.0,
            "pelvis_xz_net_m": 0.0, "pelvis_xz_path_m": 0.0,
            "root_xz_net_m": 0.0, "lowest_toe_y_min_m": 0.0,
            "q83": {"pelvis_y_min_m": 0.0, "pelvis_y_max_m": 0.0, "pelvis_xz_net_m": 0.0}}],
  "caveats": {"1": "verdict with numbers", "2": "verdict with numbers", "3": "verdict with numbers"}
}
```

`q83` per row is copied from Q83's JSON for the same path and window, so the two methods sit side by side.

The markdown opens with **DECISIONS**: the three caveat verdicts with numbers; the rows where the two
methods disagree by more than 2 cm in height; each knockdown's lowest pelvis and horizontal travel by the
tree; and ONE sentence: which method S4a should build the hip carry from.

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_pelvis_by_tree.gd`
2. From your worktree root: `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_pelvis_by_tree.gd`
   (the exe is in `%LOCALAPPDATA%\Programs\Godot\`).
3. `python research/U83_check.py` — must exit 0 before you commit.

## The trap specific to this task

**Open the output before trusting the gate.** Six deliveries yesterday passed their own gate and were
wrong. The gate here holds your instrument to PHYSICS - the idle's toes stand on the floor (within
-5..+10 cm of it), a standing pelvis is 0.80-1.05 m up, a walking pelvis bobs 1-12 cm (real walking bob
is 4-6 cm), and no pelvis is ever under the floor - so a composition that is wrong fails here. But read
your own rows too: if a knockdown's pelvis never goes below 0.5 m, the body did not reach the floor and
something upstream is still wrong. Say so rather than smoothing it over.

## When you are done

Commit the three owned files by path on `cursor/u83-pelvis-by-tree`, `git show --stat HEAD` (exactly
three), push THE BRANCH (`git push origin cursor/u83-pelvis-by-tree`); never checkout, merge or rebase
master. Then `python Tools/agent_comms.py send --from cursor --to claude --topic U83 --body "<one line>"`,
commit that mail file by path on the branch, and push again. Do NOT edit `HANDOFF.md`.

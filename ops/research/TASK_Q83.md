# TASK Q83 - QWEN - THE POSITION TRACKS WE DROP: HOW FAR THE HIPS SHOULD HAVE MOVED

Model: qwen3-coder, **medium effort**. Owner: qwen. Launched `--yolo`, prompt on stdin.
Stage: S4a, "why the bought clips look bad" (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`).

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate on your tool,
run it, then the gate script. No test suite.

## Owned files

- `Godot/tools/measure_dropped_position_tracks.gd` - **NEW, yours.**
- `research/Q83_DROPPED_POSITION_TRACKS.md` - **NEW, yours.**
- `research/Q83_dropped_position_tracks.json` - **NEW, yours.**

Do NOT edit any other file, and never an `.import` file.

## Why this exists

Your Q82 found, SOURCED, that our retarget builds ROTATION tracks only
(`FightClipRetarget.gd:260`) and drops every position track, where Godot's own importer keeps
them and rescales them by `motion_scale`. So on our fighters the hips never translate: a man who
is knocked down in the source clip keeps his pelvis at whatever height the rotations leave it.
**Nobody has measured how much movement that throws away, clip by clip.** This task does, from
the SOURCE clips alone - no fighter is involved.

## Where things are

- `Godot/tools/audit_locomotion_content.gd` - 248 lines, **read it whole**: C94's tool. It samples
  the animation tracks directly (headless `Skeleton3D` global poses return the REST pose), walks
  the UE4 hierarchy (`root` -> `pelvis` -> ...), and defines `travel_m` and `bob_m`. Reuse its
  approach and its definitions.
- `research/C94_LOCOMOTION_CONTENT.md` - its table (lines 9-50) is your tripwire.
- `Godot/scripts/FightClipBinding.gd` - 818 lines, **do not open it whole.** The population is
  every `path` under `res://assets/anim/audition/ramsterz_h2h/` in `FightClipBinding.BINDINGS`
  (the const at line 25), each with its own `start_s` / `end_s`; read them at run time.
  One entry: `sed -n '82,99p'`. 28 distinct windows.
- `res://assets/anim/audition/ramsterz_h2h/T_pose.fbx` - its node hierarchy IS the rest pose (R108);
  the pelvis rest height comes from it.

## The contract

For every bound window, sampled at **30 fps** from `start_s` to `end_s`, from the SOURCE clip:

- `pelvis_y_min_m`, `pelvis_y_max_m`, `pelvis_y_range_m` - the pelvis's world height.
- `pelvis_drop_below_rest_m` = `pelvis_y_min_m` minus the T-pose pelvis height (negative = the hips
  went lower than standing), and `pelvis_drop_frac` = that divided by the T-pose pelvis height.
- `pelvis_xz_path_m` (summed frame-to-frame horizontal movement) and `pelvis_xz_net_m` (start to end).
- `root_path_m` - the same path length for the `root` node.

JSON, exactly this shape:

```json
{
  "tripwire": {"H2H_WalkForward.FBX": {"bob_m": 0.0, "travel_m": 0.0},
               "H2H_WalkBack.FBX": {"bob_m": 0.0, "travel_m": 0.0}},
  "pelvis_rest_y_m": 0.0,
  "rows": [{"path": "...", "start_s": 0.0, "end_s": 0.0, "frames": 0,
            "pelvis_y_min_m": 0.0, "pelvis_y_max_m": 0.0, "pelvis_y_range_m": 0.0,
            "pelvis_drop_below_rest_m": 0.0, "pelvis_drop_frac": 0.0,
            "pelvis_xz_path_m": 0.0, "pelvis_xz_net_m": 0.0, "root_path_m": 0.0}]
}
```

`tripwire` holds what YOUR tool measures for those two clips by C94's own definitions.

The markdown opens with **DECISIONS**: the windows ranked by `pelvis_drop_below_rest_m` (most
negative first) and by `pelvis_xz_path_m`, each with the binding role it serves (react_head,
knockdown, slip, ...); then one plain line on which bound clips a rotation-only retarget visibly
misrepresents, by these numbers. Name the population in the first paragraph.

## Gate - in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_dropped_position_tracks.gd`
2. Run headless through the wrapper (the console exe piped into a shell can deadlock):
   `python C:\Users\user\AppData\Local\Temp\FightCamp-tools\godot_run.py . tools/measure_dropped_position_tracks.gd --timeout 1200`
   It prints the output and a GODOT_RUN line; a GDScript error still exits 0, so READ it.
3. `python research/Q83_check.py` - **must exit 0 before you commit.** It derives the 28
   windows from `FightClipBinding.gd` and C94's two walk rows from C94's own table, and checks a
   knockdown's hips really drop further than the idle's.

## The trap specific to this task

**Reproduce C94 before you publish anything.** Your tool's `bob_m` and `travel_m` for
`H2H_WalkForward.FBX` and `H2H_WalkBack.FBX` must match C94's table within +-0.0005 m. If they do
not, your definitions differ from C94's - fix that first; do not report a new number against an
instrument that disagrees with the last one. And a clip file's `length` is not its content
(R109): use each binding's own window.

## When you are done

`git add --` the three owned files, commit with those paths on the commit line,
`git show --stat HEAD` (exactly three files), push your branch, then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q83 --body "<one line>"` and
commit that one mail file by path. Do NOT edit `HANDOFF.md`. Never `git stash`, `reset --hard`,
`checkout .` or `clean`.

## REDO (Claude, 2026-09-13) - the first delivery measured the wrong axis

Claude opened the first delivery (`470db7b`, branch `qwen/q83-dropped-position-tracks`). It passed the
old gate and is **physically impossible**: 7 of 28 windows put the pelvis BELOW THE FLOOR -
`H2H_KnockDown02.FBX` at `pelvis_y_min_m = -0.773`, 77 cm through the canvas. The standing values
(0.91-1.06 m) look like a real height, so the fault is in the COMPOSITION, not only the axis - and
Claude has NOT verified which. Two candidates, and you must find out which (or what else) and say so:
(a) the up axis changes once the FBX root's Z-up -> Y-up conversion is composed, so the component
read is not height in every frame; (b) the `root` track ROTATES during a fall, and composing
`root x pelvis` swings the pelvis's rest offset round below the floor. Check the `root` track's
rotation over KnockDown02 before anything else.

**What changes:**

1. Height is the world **UP** axis of the pelvis's true world position, however the root and the
   axis conversion compose. Prove it physically before anything else: the T-pose pelvis height read from
   `T_pose.fbx`'s node hierarchy and the Idle's pelvis height at t=0 must agree within 5 cm and sit
   between 0.80 and 1.10 m. The rest height comes from `T_pose.fbx`, as the contract always said -
   not from the Idle.
2. **C94 is no longer the tripwire.** Its walk `bob_m` of 0.0020 m is implausibly small for a walking
   pelvis (real bob is centimetres), and the roadmap already flagged C94's RootMotion bob of 0 as
   suspect - it may have read the same wrong axis. Measure C94's two walk clips by YOUR corrected
   definitions and report both side by side in `c94_comparison`, saying plainly whether C94 agrees.
3. JSON: replace `tripwire` with
   `"physical_tripwire": {"tpose_pelvis_y_m": 0.0, "idle_t0_pelvis_y_m": 0.0}` and add
   `"c94_comparison": {"H2H_WalkForward.FBX": {"bob_m": 0.0, "travel_m": 0.0, "c94_bob_m": 0.0,
   "c94_travel_m": 0.0, "agrees": true}, "H2H_WalkBack.FBX": {...}}`. `rows` keep their shape.

The gate now requires: no row's pelvis below -0.05 m; no row's pelvis above rest + 0.30 m; a
knockdown's lowest pelvis at or below 0.45 m (a man on the canvas has his hips low); the two rest
readings within 5 cm; and the C94 comparison present - not equal.

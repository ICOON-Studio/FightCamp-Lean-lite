# S4 (A) — THE BLENDER HALF OF THE PIPELINE RUNS WITHOUT THE OPERATOR'S PC

Claude, 2026-09-16, on the operator's go ("C then A"). A smoke test, not a stage: it answers one question the whole
Sunday plan rests on and changes no production file.

## THE QUESTION

Every Blender job in this project — `Tools/blender_moves/bridge.py` and the four authoring scripts above it — has been
assumed to need the operator's PC, because that is where Blender is. The operator is on a phone until Sunday and asked
whether Higgsfield, Blender, the engine and a 3D move can all be tested by then.

**Higgsfield's MCP surface carries a Blender.** `scene_builder_3d_run_python` / `_query_python` execute Python against a
real `bpy` on a worker. If our own bridge runs there, the Blender half of the pipeline is reachable from the phone and
Sunday's PC time is only owed the one thing a container genuinely cannot do.

## WHAT THE WORKER IS

`research/S4A_CLOUD_BLENDER.md` probe 1, `fightcamp-env-probe-1`:

| | |
|---|---|
| Blender | **5.2.0 LTS** |
| Python | 3.13.13 |
| numpy | **2.3.4** — `bridge.py` imports it at module scope |
| mathutils | present |
| glTF import / export | **both** |
| FBX import | yes |
| `bpy.ops.nla.bake` | yes |

Every module `bridge.py` needs at import time is there, and so is the import/export pair every clip has to cross.

## WHAT WAS RUN, AND IT WAS OUR OWN CODE

`umeyama`, `orthonormal`, the `xform12` pair and the **whole `Mapping` class** were taken **verbatim** out of
`Tools/blender_moves/bridge.py` — extracted by slicing the file, not retyped — so this exercises the production solve
rather than a re-implementation of it.

Our fighter mesh cannot go to that worker (see LIMIT below), so the armature was built there from **our own rig's rest
geometry**: `Godot/tools/dump_rest_block.gd` (new, this commit) writes `FightPoseBridge.skeleton_block` for
`f01_m_box_welter_rigged.glb` to JSON — the same 22-bone array `Mapping` consumes in production — and the probe rebuilds
it as edit bones through the glTF Y-up → Z-up convention the importer applies.

## THE RESULT — `fightcamp-bridge-solve-1`

| | measured | means |
|---|---|---|
| bones built / missing | **22 / 0** | every bone of our rig is named and parented as production expects |
| `mapping.s` | **1.000000** | the two rests are the same scale |
| `mapping.residual` | **6.66e-16 m** | machine precision; the Umeyama fit is exact, not approximate |
| `forward_arm` | **[0, −1, 0]** | Godot's +Z — the way our punches reach — is Blender's −Y, which is what the convention predicts |
| round-trip worst position | **0.000000 mm** | over 88 random poses, 4 per bone, seeded 94301 |
| round-trip worst rotation | **0.000003 deg** | " |
| `parent_first` order | correct | |
| glTF export | available | |

**A mapping that is not invertible loses a pose every time it crosses the boundary, and it fails silently — as a body
that is slightly wrong in a way nobody can name.** It is invertible here at machine precision.

## THE LIMIT, STATED PLAINLY

**That worker takes model bytes from its own catalogue only.** `scene_builder_3d_import_asset` says so in as many words,
and its Python is explicitly barred from network fetches and embedded model bytes. So:

- **What is proven to run off the PC:** the solve, the pose math, the Godot↔Blender mapping, and anything that is
  numbers — which is `bridge.py`'s `Mapping`, `take_to_action`, `export_pose_row` and `read_bridge`.
- **What is NOT proven and still needs the PC:** `bridge.import_fighter`, which needs our actual `f01`/`f09` GLB on
  disk, and everything downstream of it — `author_pair.py`, `glb_clip_to_bridge.py`, the RamsterZ FBX clips.
- **The route not taken:** the repo is private and its assets are not public. Making the fighter reachable by URL would
  publish it, so it was not done and should not be.

## WHAT THIS CHANGES FOR SUNDAY

The three legs the operator asked about split cleanly:

1. **Higgsfield** — reachable now, verified (923.9 credits, Plus). Its rig animation catalogue has 678 actions with a
   `Fighting` group and a `Punching` category. **They are Meshy generic-biped clips: a pipeline test, never shipped
   content** — the ripped-art rule stands.
2. **Blender** — the numeric half runs off the PC at machine precision, proven above. The asset half does not.
3. **The engine** — done, and further than the operator has seen: seven stages, the last of them S4 (3).

**So Sunday is owed exactly one thing a container cannot do: the recording.** `--write-movie` aborts under `--headless`
and leaves a 0-byte AVI (measured 2026-09-15). That is step 4, and S4 (3) has just made the camera frame the fight
rather than the ring skirt, so the recording is worth taking now.

## Open

1. A GLB round trip through the cloud Blender is untested because our mesh cannot be uploaded. If it is ever wanted, the
   honest route is a catalogue biped, not publishing ours.
2. Higgsfield's catalogue rig bone names have not been checked against `FightClipRetarget.UE4_TO_OURS`. That is the next
   cheap probe and it decides whether a Higgsfield clip can be retargeted at all.
3. This probe spent no generation credits — both calls were `query_python`, which commits nothing.

## Re-running it

```
godot --headless --path Godot --script tools/dump_rest_block.gd -- out=<path>/rest_block.json
```
then hand `bridge.py`'s core plus that JSON to `scene_builder_3d_query_python` (project
`90fb1c39-ce22-48f2-9a88-0b4eda4136bd`, https://higgsfield.ai/3d-jutsu/90fb1c39-ce22-48f2-9a88-0b4eda4136bd).

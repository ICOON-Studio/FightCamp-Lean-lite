# U81/U82 — Retarget triptych sheets (S4a)

## Command

From the repo root, windowed (never headless):

```bash
python C:\Users\user\AppData\Local\Temp\FightCamp-tools\godot_run.py . tools/capture_retarget_triptych.gd --windowed --timeout 2400
```

Optional filter for one pair (renders front + side):

```bash
python C:\Users\user\AppData\Local\Temp\FightCamp-tools\godot_run.py . tools/capture_retarget_triptych.gd --windowed --timeout 2400 -- H2H_JabInPlace f01_m_box_welter
```

Parse gate before render:

```bash
python Godot/tools/check_scripts.py Godot/tools/capture_retarget_triptych.gd
```

Acceptance gate after all PNGs exist:

```bash
python research/U82_check.py
```

Godot invocation inside the wrapper is `--path Godot --script tools/capture_retarget_triptych.gd`.

## Population

Six RamsterZ H2H clip stems × three fighters × two views (36 sheets):

| Clip stem | Binding window (content span, seconds) |
| --- | --- |
| `H2H_JabInPlace` | 0.00–0.833 (`boxing_double_jab`) |
| `H2H_HitReaction01` | 2.47–3.03 (`react_head`) |
| `H2H_StaggerMedium01` | 0.00–1.77 (`react_body` variant) |
| `H2H_Idle` | 0.00–4.67 (`idle`) |
| `H2H_SlipLeft` | 0.00–0.67 (`slip`) |
| `H2H_KnockDown01` | 0.00–1.93 (`knockdown`) |

| Fighter id | GLB | class kg |
| --- | --- | --- |
| `f01_m_box_welter` | `f01_m_box_welter_rigged.glb` | 66.7 |
| `f02_m_box_heavy` | `f02_m_box_heavy_rigged.glb` | 120.0 |
| `f06_m_mma_lhw` | `f06_m_mma_lhw_rigged.glb` | 93.0 |

Output:

- Front: `previews/s4a/<clip_stem>__<fighter_id>.png`
- Side: `previews/s4a/<clip_stem>__<fighter_id>__side.png`

Each sheet is 960×1920 (3×6 grid of 320×320 cells).

## Camera and framing (U82)

Orthographic. Each **column** shares one camera computed from the union of that subject's bounds over all six sampled times (plus margin) — never reframed per cell. A falling head moves down the cell instead of the camera chasing it.

**Facing:** every subject is yawed so its rest-pose hips forward (fighter bone +Z, source hips→spine in T-pose) points world +Z. All three columns use the same view direction:

- **Front** — three-quarter from (−X, +Y, −Z).
- **Side** — profile from (+X, +Y, 0); the jab's reach lies across the screen.

**Floor:** a thin line and faint grid in every cell. Retarget columns draw it at world Y = 0. The SOURCE column draws it at the T-pose lowest foot height after the source normalisation — bodies are never shifted to touch it; float is the finding.

Source sticks are height-normalised once from T-pose (1.72 m); retarget skeleton/mesh keep mount scale and position.

## Panel computation

Rows: six evenly spaced times across the binding content window (first and last included); label prints `t=` in seconds within the rebased window. Before each row the world `AnimationPlayer` is `seek`’d to `t`, advanced, and two frames are processed so row 0 is not a rest-pose trap.

Each column renders into an isolated viewport with exactly one subject:

1. **SOURCE** — load the vendor FBX; at absolute file time `start_s + t`, compose globals down the clip node hierarchy (`_local_at` / `_globals` / `UE4_TO_OURS`), take the 22 mapped joint origins, yaw/scale from T-pose, draw spheres + parent sticks only (no mesh).
2. **RETARGET SKELETON** — read joint positions from the posed fighter skeleton via **`get_bone_pose()` composed down the parent chain** (never `get_bone_global_pose()`); draw sticks only (fighter mesh never enters this viewport).
3. **RETARGET MESH** — reparent the fighter into the cell viewport at mount position/scale; cell-local `AnimationPlayer` seeks the retargeted clip to `t`, processes frames, then the skinned mesh is captured without recentring onto the floor.

Binding windows and `start_s`/`end_s` are read from `FightClipBinding.BINDINGS` at run time (including variant entries).

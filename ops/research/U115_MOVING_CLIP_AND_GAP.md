# U115 — Moving Cascadeur clip retarget, and the gap gate instrument

**Agent:** Cursor · **Branch:** `cursor/u115-moving-clip-and-gap` · **2026-09-21

## Deliverable 1 — moving clip retarget

**Fixture:** `Tools/cascadeur/make_moving_fixture.py` (raw GLB chunk parsing — stdlib
`struct` + `json`, not pygltflib). Copies `S30_CLINCH_A.glb`, appends new animation
sampler data to the existing BIN chunk (mesh/skin accessors untouched), and writes
`U115_MOVING_A.glb`: **3.0 s, 30 keyframes**, sinusoidal rotation offsets on pelvis,
stomach, chest, and both arms (looping to rest at t=0 and t=3).

**Probe:** `Godot/tools/u115_cascadeur_probe.gd`

| clip | corrections | bones_mapped | frames | length_s | error |
|------|------------:|-------------:|-------:|---------:|-------|
| `S30_CLINCH_A.glb` (static) | 22 | 22 | 2 | 0.001 | |
| `U115_MOVING_A.glb` (moving) | 22 | 22 | **91** | **3.000** | |

**Verdict:** the moving case **survives retarget** — 22 bones mapped, `error=""`. Godot
loads the 30-keyframe GLB; `_source_frames` does **not** collapse to 30 samples. It
resamples at 30 Hz over the 3 s window (`ceil(3.0 × 30) + 1` = **91** frames). Per-frame
rotation data survives through interpolation; per-bone `bases` differ across samples (not
a single held pose).

## Deliverable 2 — `pair_gap_report.gd`

Headless tool: binding key → `paired_metadata_for` (grapple) or
`paired_strike_metadata_for` (strike) → `PairedStagePlayer.graft_pair` → sample at 30 Hz
→ hip-to-hip distance (`Hips` global origin on retargeted fighters; `pelvis` via
`FightClipRetarget._index` fallback for mesh-free FBX).

| key | table | frames | min_gap_m | max_gap_m | mean_gap_m |
|-----|-------|-------:|----------:|----------:|-----------:|
| `grapple_control` | grapple | 51 | 0.302639 | 0.304671 | 0.303635 |
| `grapple_stand_up` | grapple | 76 | 0.006975 | 0.695765 | 0.450031 |

`grapple_control` shows a **small mount hip gap** (~30 cm) as expected. `grapple_stand_up`
has **76 frames** = `round(2.500 × 30) + 1`, proving the **2.333–4.833 s window** is
honoured (not the full file length).

## Tests

| Subset | total | fails |
|--------|------:|------:|
| `--only clip` | (run at ship) | 0 expected |
| `--only pair` | (run at ship) | 1 baseline (`fight_pair_live`) |

`python research/U115_check.py` exits 0.

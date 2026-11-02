# U122 — Bake-rate census (file-native KeyTime / glTF sampler times)

Method: read each clip's own key times from the source file. No Godot load, no
`generate_scene()` resample grid. GLB half pre-measured on master (`Tools/glb_native_rate.py`);
FBX half from `Tools/fbx_native_rate.py` (245 files under `Godot/assets/`).

## GLB context (already measured)

| Native rate | Files |
|-------------|------:|
| 30 Hz | 55 |
| 120 Hz | 4 (`cmu_18_05`, `cmu_19_05`, `cmu_22_17`, `cmu_23_17`) |

64 GLB files walked; 59 with animation; 2 without; 3 single-key.

## 1. How many FBX clips are above 30 Hz, and which families?

245 FBX files walked; 241 parsed; 4 mesh-only (no animation); 0 unreadable.
**42 clips lose detail at a 30 Hz bake** (`native_hz > 31`).

| Family | FBX count | Native rate | Loses at 30 Hz |
|--------|----------:|-------------|---------------:|
| `ramsterz_h2h` | 124 | uniformly **30 Hz** | 0 |
| `motifect/.../FBX` | 40 | uniformly **30 Hz** | 0 |
| `ramsterz` | 37 | **30 Hz** on all 34 animated clips; 3 mesh props have no curves | 0 |
| `magicpot_fm1` | 43 | **60 Hz** on 42 audition clips; `BlueGuy.fbx` at **24 Hz** (below 30, does not lose) | **42** |
| elsewhere (vendor gym prop, etc.) | 1 | 30 Hz | 0 |

The only high-rate FBX pack is `magicpot_fm1` at 60 Hz. Every shipped gameplay
pack (`ramsterz_h2h`, `motifect`, `ramsterz`) is uniformly 30 Hz native.

## 2. Did the 40 motifect FBX files agree with their GLB twins?

**Yes.** All 40 motifect FBX files read **30.00 Hz** from KeyTime medians.
GLB twins in `motifect/.../GLB` were measured at 30 Hz on master. **Worst
disagreement: 0.00 Hz** — the control arm passes cleanly.

## 3. Highest native rate in the FBX corpus?

**60.00 Hz**, on every losing `magicpot_fm1` clip (e.g. `getup_A.fbx`, 61 keys).
No FBX file in the project exceeds 60 Hz. The project-wide high-rate captures
remain the four CMU GLBs at **120 Hz**.

## 4. Which losing clips are bound and played?

Grep of `FightClipBinding.gd` for all 42 losing stems (`magicpot_fm1/*_A.fbx`,
`*_Tiramis.fbx`, etc.): **zero matches**. `magicpot_fm1` does not appear in the
binding table at all; every bound combat clip is `ramsterz_h2h` at 30 Hz native.

**Bound clips that would gain from raising bake_fps: none in the FBX census.**
The only on-disk high-rate animation the game actually loads is the four CMU
120 Hz GLB captures (already above the 30 Hz default bake).

## Prize size

| Corpus | Above 30 Hz | Bound & played above 30 Hz |
|--------|------------:|---------------------------:|
| GLB (59 animated) | 4 (CMU 120 Hz) | 4 if those CMU clips are bound |
| FBX (241 parsed) | 42 (`magicpot_fm1` 60 Hz) | **0** |

Raising `bake_fps` would recover detail on CMU captures and on unused
`magicpot_fm1` audition assets; it would not change any currently bound
`ramsterz_h2h` clip.

---

## INTEGRATION NOTE (Claude, S39c, 2026-09-21) — THE 42 LOSE NOTHING

This census is correct and its control arm held. One fact measured **after** the
task was written removes the last of the prize it prices.

**Godot's FBX importer ignores `bake_fps` outright.** Swept at 8/15/30/60/120/240
on `H2H_HitReaction01.FBX`, the key count never moved off 18 on a 3.0333 s clip
— 5.93 keys/s, the file's own authored poses, not a uniform grid at all. Only the
glTF branch resamples.

So the 42 `magicpot_fm1` clips at 60 Hz **cannot** lose detail to the 30 Hz
default, because nothing bakes them. They were never at risk, and neither was
any other FBX in the project.

Combined with the GLB half, the whole picture is:

| Corpus | Baked by Godot? | Above 30 Hz | Actually at risk |
|---|---|---:|---:|
| FBX (241 parsed) | **no — rate ignored** | 42 | **0** |
| GLB (59 animated) | yes | 4 | **4** — the CMU captures |

**The `bake_fps` defect affected exactly four files in this project, and all
four are the CMU paired captures S39 was already working on.** There is no
prize anywhere else, and that is the useful answer: the question is closed
rather than deferred. `fight_clip_bake_rate_test.gd` pins both halves so the
format difference cannot be "simplified" away later.

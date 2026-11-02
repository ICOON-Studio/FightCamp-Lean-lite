# U86 — Single punches come home

## DECISIONS

### Four punch bindings (Part A)

| role | clip | hand | length | U85 retract | ends_in_guard |
|---|---|---|---|---|---|
| `jab` | `H2H_JabInPlace.FBX` | left (lead) | 0.833 s | 383 ms | yes |
| `cross` | `H2H_StraightPunchInPlace.FBX` | right (rear) | 0.833 s | 267 ms | yes |
| `hook_lead` | `H2H_HookPunch_InPlace.FBX` | left | 1.000 s | 567 ms | yes |
| `hook_rear` | same + `mirror: true` | right (mirrored) | 1.000 s | 567 ms | yes |

All four: `retarget: true`, `reference: T_pose.fbx`, whole file (`start_s` 0, `end_s` = `length_s`).
Combo slice windows left on `strike_head`, `jab_lead`, `cross_lead`, kickboxing combo ids — they never came home (U85).

`_graft_retargeted` now applies `FightClipMirror.mirror(anim)` when `meta.mirror` is true, **before** `address_tracks` (same order as graft path :185).

**f01 Hips rest origin x:** 0.003281 m (3.28 mm). Mirror negates Hips position x; sign flip is 2×|x| = 6.56 mm in skeleton space — expected sagittal reflection of a 3.28 mm rest offset, not extra drift on the height-only carry. `hook_rear` bound; R4 57/57 confirms playback.

**`jab_lead` / `cross_lead` callers:** grep `Godot/scripts/` — only `FightClipBinding.gd` and `FightClipMirror.gd` name them (U41 mirror aliases). No engine beat or adapter requests those ids directly.

**Uppercut render:** `capture_retarget_triptych.gd -- H2H_LeadingUppercut_InPlace rest=hips` → `U82 FAIL: nothing to render` (uppercut deliberately unbound per R127). No triptych sheet produced.

### R4 before / after

| | exits passing |
|---|---|
| **Before (master baseline in task)** | 0 of 57 (0%) |
| **After (this branch, f01/f09 demo pair)** | **57 of 57 (100%)** |

Realism log line: `measured: 57 of 57 exits pass (100%); … first failure: none`

Also from realism run (RED BY DESIGN overall, do not fix here):

```
RULE R3 planted_foot_skate | GATED S4a | FAIL
    measured: mean 0.742 m/s, p95 1.810 m/s over 13525 planted frames; …
RULE R3b feet_above_the_canvas | GATED S4a | FAIL
    measured: 55 of 14652 frames under the bound; deepest -0.089 m …
```

### Moved pins (Part A rebinding)

| check | old | new |
|---|---|---|
| `jab` path | `combo_jab_cross_hook.glb` slice 0–0.64 s | `H2H_JabInPlace.FBX` retarget whole 0.833 s |
| `jab` hand (U40) | RightHand combo peak | LeftHand (lead jab) |
| `cross` path | combo slice 0.64–1.04 s | `H2H_StraightPunchInPlace.FBX` 0.833 s |
| `hook_lead` path | combo slice + `mirror: true` | `H2H_HookPunch_InPlace.FBX` 1.0 s, no mirror |
| `hook_rear` path | combo slice 1.04–1.68 s | same hook FBX + `mirror: true` |
| `hook_lead` `mirror` | true | false |
| slice test hand bone | `RightHand` | `LeftHand` |
| fixture meshes | f01 vs f02 heavy (120 kg) | f01 vs f09 welter (66.0 / 66.5 kg) |
| fixture athletes | hand-copied / wrong keys | `FightWorldLiveScreen.demo_fighter("a"/"b")` |

### Findings (fixture change — do not re-pin)

**`fight_stage_technique_fidelity_test.gd`** (still red, 2 fails after Part B):

| check | old fixture expectation | new result |
|---|---|---|
| named clip plays ≥ 60 | floor from identical-men + Stage B palette | **48** of 147 action beats |
| distinct clips ≥ 5 | same | **3** (`jab`, `cross`, `hook_lead`) |

Zero substitutions; silent claims 0; synthetic hook/cross/jab paths green.

**`fight_clip_mirror_test.gd`** (not owned; fails due to binding shape change):

| check | reason |
|---|---|
| `hook_lead has mirror=true` | U86 removed mirror from lead hook (whole left clip) |
| `jab` / `cross` mirror reach on combo slice | `jab`/`cross` bindings no longer combo slices; mirror test still slices combo |
| `hook_rear reach preserved` | `reach_m` removed from retarget bindings |

### Part B population (all four tests)

```
ruleset=boxing
A=out-boxer (A) 66.0 kg
B=pressure puncher (B) 66.5 kg
stats_differ=true
meshes: f01_m_box_welter_rigged.glb / f09_m_bare_welter_rigged.glb
```

### Gate summary

- Parse gate: 6 touched `.gd` — **pass**
- Focused: `fight_clip_slice`, `fight_stage_playback`, `fight_stage_presenter_contract`, `fight_clip_mirror` — pass except mirror (findings above); `fight_stage_technique_fidelity` — 2 fails (findings)
- Subset `--only clip,retarget,stage,anim,fight_world,paired --jobs 4`: **SUITE total=22 fails=3** (realism by design, technique_fidelity findings, mirror findings)

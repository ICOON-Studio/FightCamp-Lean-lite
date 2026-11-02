# C208 — Live gym rooms, bounded by truthful activity

A management UI lead should preserve the immediately readable next action, fighter availability, booked fight, cash and station pressure; make purchased equipment, room expansion and assigned activity visibly change; and maintain a single source of floor and training state. My recommendation is **C for the training floor, presented through a fixed elevated camera behind the existing brass-and-leather UI; A remains the fallback and the treatment for administrative hubs.** Do not replace useful management information with camera work. Separate recovery, kitchen, dormitory, film and media rooms should grow from actual facilities and functions, not decorative doors promising unavailable gameplay.

## Current appearance

I inspected `s80_look/current_look_sheet.jpg` and `02_home.jpg`, and read `S80_DIGEST.md`. Warm daylight, recognizable equipment, object pins and the strong next-fight action make HOME legible and give the gym an identity. Inner pages retain a consistent dark data surface. The first mismatch is the inhabited-business UI over an empty room: roster cards and occupied-floor information cannot make the picture respond to purchases or programmes. The gym-floor pin even describes a mat over an image of weights. The archived screenshot also says Money where the digest records Finance: this evaluation treats the image as a captured build, not proof of current wording.

## Options and costs

| Option | Player value and growth | Production and performance cost | Main risk |
|---|---|---|---|
| A: stills with tier variants | Strong current atmosphere; excellent backdrop for pins and readable business facts. Room/tier swaps show broad growth. | Lowest runtime complexity; art must preserve camera, lighting and pin anchors across variants. Every independently changing purchase increases composition and synchronization work. No comparative frame measurement made. | Tier pictures remain approximate: equipment, damage and occupancy can contradict the save. |
| B: animated isometric tiles/sprites | Clear footprints, crowding, room additions and workers; overhead view naturally supports management. | Tile kit, licensed character sources, exercise cycles, facing variants, sprite export and occlusion/picking code. Baked sprites could reuse our rigs but require an additional output pipeline. CPU/GPU advantage over C is unmeasured. | A second art language and animation pipeline; simplified people may weaken fighter identity. |
| C: real rigs in Godot | Purchases and assigned athletes can inhabit the actual floor; zoom can preserve identity; room growth becomes spatially honest. | Reuse rigs and baked clips, but build equipment anchors, exercise contact, transitions, occupancy mapping, room lighting and camera-safe occlusion. Measured baseline below; finished-room cost remains unknown. | Fight clips are not exercise loops. A visually attractive but falsely busy room is worse evidence than an explicit empty station. |

C should use an isometric-style presentation without committing to B's sprite pipeline. Keep the administrative hubs as stills until their changing state benefits from spatial rendering. Render only the selected room; suspend hidden-room animation. The arena and fight camera director are useful experience, not a reason to instantiate a live bout simulation for each gym station.

## What animation is actually available

`BootStage3D.gd` already loads raw fighter GLBs and baked `idle_f01.res`, `idle_f02.res`, `idle_f05.res`, duplicating and addressing tracks with `FightClipRetarget`. The probe uses that same route. `C200_RIG_SPEC.md` defines the canonical rig and offline importer; it does not certify exercise contact.

A Python filename scan printed **357** animation-format files under `assets/anim` and **no filename hits** for bag, pad, skip, weight, train or spar. This includes source/reference/variant files and is **not** a content census or proof that no clip contains training. Existing RamsterZ examples printed include `H2H_JabInPlace.FBX`, `H2H_JabForward.FBX`, and `H2H_HookPunch_InPlace.FBX`. The equipment catalogue printed **25** entries: the art problem extends beyond the requested exercise families to bikes, rowing, recovery and discipline-specific stations.

| Exercise | Reusable evidence | Still needed before showing actual training |
|---|---|---|
| Bag | Jab/hook source clips; real rigs and idle | Station-facing drill, fist/bag contact, bag response, return to stance, clearance and entry/exit. Speed and double-end bags need their own timing. |
| Pads | Strikes and retargeting infrastructure | Coach rig/kit, paired mitt targets, synchronized receiver motion and contact across body proportions. No verified pad loop found. |
| Skipping | Idle only verified here | Repeated jump/landing cycle, hands and rope synchronized; no verified skipping loop found. |
| Weights | Rig and importer | Exercise-specific grip, prop attachment and loaded limb motion; no verified lifting loop found. Boxing gloves are not general exercise clothing. |
| Sparring | Fight motion and existing paired playback infrastructure | Controlled drill selection, matched partners, safe spacing and protective kit. A fight exchange must not silently stand for a scheduled sparring session. |

Author or acquire missing exercises through the established importer and review them at the station. The task states ownership of the existing animation pipeline; this memo does not independently renew or extend asset licences. Source provenance still needs checking before new exercise content ships.

## Render measurement

Tool: `Godot/tools/c208_hub_frame_probe.gd`. Run from the repository root:

```powershell
python Godot/tools/check_scripts.py Godot/tools/c208_hub_frame_probe.gd
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/c208_hub_frame_probe.gd
```

The tool printed Godot **4.7.2**, Forward+, **AMD Ryzen 7 7800X3D**, **16** logical processors, **Radeon RX 6800 XT**, **1920 × 1080**, VSync disabled. It ran sequential populations with **180** warmup frames and **600** samples each. Scene: baked animated fighter rigs, generic station plinths, floor, shadowed directional light, ambient illumination. Fixed orthographic camera at **(9, 13, 15)**, size **16**. Station placements are synthetic; no career is created and no training simulation or production hub is mounted.

| Fighters | Mean completed-frame interval | p95 | p99 | Maximum | Draw calls | Primitives |
|---:|---:|---:|---:|---:|---:|---:|
| 3 | 5.826 ms | 6.693 ms | 7.095 ms | 8.323 ms | 14 | 116,404 |
| 12 | 6.676 ms | 8.032 ms | 8.765 ms | 11.601 ms | 50 | 465,544 |

These are wall intervals **including synchronous viewport image readback every sample**, forcing render completion. They are neither pure GPU timings nor presented-display FPS. An earlier unsynchronized trial was discarded because submission intervals exaggerated throughput. GPU monitor p95 printed **0.142 ms / 0.255 ms** respectively; identical median/p95 readings suggest coarse/stale reporting, so they are not the decision metric.

The observed capacity is **12 idling fighters in this stripped scene**, not the machine's maximum. No CPU utilization, temperature, thermal equilibrium, full-room assets, UI composition, pathfinding or exercise contacts were measured. The brief's overheating concern remains unresolved. Captures were inspected: recognizable fighters appear on plinths, with clear spacing, but this is visibly a greybox far below the current still's art quality. Raw JSON and PNGs are regenerated locally under `Godot/.godot/c208/`; the committed tool reproduces them.

## First slice and decision gate

**ESTIMATE: one session** for an isolated selectable training-room prototype using the existing idle path, real equipment footprints and existing management chrome. `GymHubPanel._build_floor` consumes `floor.grid` and equipment; `GameState.get_floor()` returns gym floor items and the capacity/area reads derive from that floor. Project those stable item identities into room meshes, then resolve activity from the authoritative programme/occupancy read. Do not invent a parallel schedule or animate every roster member regardless of assignment. Unavailable exercise motion should remain an explicit detail-panel limitation, never masquerade as exercise through combat idle.

Prove purchase/move/remove and assignment changes visibly agree with the floor and training reads; preserve pin picking and readable alerts. Then add a reviewed bag exercise before expanding to paired work. **ESTIMATE acceptance budget: p95 below 33.3 ms with production UI and room art**, with sustained thermal observation and no stacked Godot processes. Reject or reduce C if that fails, activity becomes ambiguous, or the art cannot match the accepted still. Fall back to state-aware still variants while retaining factual management controls.

Parse gate: **CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0**. Tool completed successfully. No suite, shipped-script changes or HANDOFF edit; C208's specific tier and branch instructions superseded the general startup/rebase and handoff workflow.

# U41 DIGEST — mirror three right hands into six

## Naming convention
`mirrored_name`: `*_rear`↔`*_lead`; bare names gain `_lead`.
`jab`→`jab_lead`, `cross`→`cross_lead`, `hook_rear`→`hook_lead`.

## What landed
- `FightClipMirror.gd` — `mirror` (sagittal YZ: −X pos, quat y/z negate, Left↔Right paths) + `mirrored_name`
- `FightClipBinding.gd` — `jab_lead` / `cross_lead` / `hook_lead` with `mirror: true`; U40 keys kept
- `FightStagePlayer.gd` — **edited** (must): after slice, apply `FightClipMirror.mirror` when meta.mirror
- `fight_clip_mirror_test.gd` — crossover / reach / det+ / move / track-count

## Crossover (not rename-only)
| src | src R_fwd | mir L_fwd | reach preserved |
| --- | --- | --- | --- |
| jab | 0.744 | **0.744** | yes |
| cross | 0.926 | **0.926** | yes |
| hook_rear | 0.772 | **0.772** | yes |

Determinant positive on all rotation keys. Source unmodified. Track count 23.

## Asset judgement (the trap)
All three U40 peaks are **RightHand** with no L/R alternation. A southpaw jab-cross-hook would alternate (lead R, rear L, …). An orthodox jab is lead **left**. So this file is **not** a labelled jab-cross-hook for either stance — it is a **right-hand-only drill** (three rear-hand punches), or a mislabelled purchase. Mirror still gives us the missing left set; do not buy more from this library on the filename assumption.

## Gate
own 45/0; slice 22/0; playback 25/0; world 5/0.

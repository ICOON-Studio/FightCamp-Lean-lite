# U145 digest — body jumps vs local joint pops

Population: boxing f01 vs f09, MMA f05 vs f06, seed 94301, 1 round, 60 Hz manual step.

## Split metrics (strike transitions)

| Arm | Mode | Body jumps (box) | World pop med/p90 | Local pop med/p90 | Readable bad | 30fps miss |
|---|---|---:|---:|---:|---:|---:|
| A | crossfade blend_into | 1 | 7.72 / 11.33 | 8.85 / 16.92 | 18 (ok 9) | 0 / 0 |

Body jump thresholds: >0.10 m or >15 deg yaw per 1/60 s frame. `U145_BODY_WRITE` lines name the writer.
World-head sanity mixes body yaw/teleport; local bone speed is parent-relative rotation.
Readable peak: `readable_s` from FightClipBinding, else `_contact_s` on the grafted take; boxing jab/cross omit binding `readable_s`.

Judgement: joint pop ratio > 3.0 treated as visible pop.
Stills: `docs/previews/transitions/` (worst per kind, arm A boxing).

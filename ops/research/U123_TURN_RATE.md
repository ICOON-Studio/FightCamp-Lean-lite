# U123 — turn_yaw_deg_s diagnosis and fix

## The 10,576.7 deg/s spike (committed fold, pre-U123)

| field | value |
| --- | --- |
| video | `xaXXD-w45b0` |
| frames | 36002 → 36003 |
| person | 1 |
| fps | 59.816 (events file) |
| raw d | −176.821° |
| rate | 176.821 × 59.816 = **10,576.749 deg/s** |

**Cause:** uncaught L/R hip label swap. MediaPipe exchanged hip landmarks between
frames; the wrapped difference is ~177° (a half-turn artefact), not a real pivot.
`fix_hip_swap` did not fire on this pair (assignment cost favoured the wrong
labels). This is **not** the “44° × 240 fps” scaling bug — d is far above 60°.

## The 2,768 deg/s blocker (per-frame gate, confirmed)

| field | value |
| --- | --- |
| video | `FCM7m6TJWUQ` |
| frames | 3259 → 3260 |
| person | 1 |
| fps | 50.0 |
| raw d | 55.363° |
| rate | 55.363 × 50 = **2,768 deg/s** |

**Cause:** `UNRESOLVED_DEG = 60` gated **degrees per frame**, but the reported
quantity is **degrees per second** (`abs(d) * fps`). At 50 fps any d < 60° passes,
so 55° → 2,768 deg/s. Hypothesis **confirmed** for the post-hip-line instrument.

## What changed

`UNRESOLVED_DEG` (60°/frame) → `UNRESOLVED_DEG_S = 360°/s` (one revolution per
second is not resolvable monocular 2D between adjacent frames). Gate:
`abs(d) * fps >= UNRESOLVED_DEG_S`. Frame-property justification, not a max trim.

## Denominators and exclusions

| | before | after |
| --- | --- | --- |
| pairs considered | 34,402 | 34,402 |
| pairs excluded (all reasons) | 9,303 | 10,497 |
| `turn_yaw_excluded_share` (pooled) | 21.3% | 23.4% |

Under the 25% ceiling. `fix_hip_swap` caught **4,040** label swaps corpus-wide
(e.g. 821 in `wzUWvsviqTM`); swaps are corrected, not dropped.

## After fix (pooled boxing/sparring)

p50 = **35.0 deg/s**, p90 = **113.6 deg/s**, max = **342.4 deg/s**
(`wzUWvsviqTM` frames 26619→26620, d = 11.4°, person 1).

Five accepted U109 event rows: **byte-identical** to `origin/master` digest.

## Verdict on `FightBearing.TURN_BASE_DEG_S`

Row is now **MEASURED (footage)**. p50/p90 are trustworthy; pooled p90 (114 deg/s)
sits well below the authored 240 deg/s ceiling — use p90 to sanity-check, not to
replace `TURN_BASE_DEG_S` with p50.

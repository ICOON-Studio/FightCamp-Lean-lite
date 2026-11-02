# U91 — nearest idle phase at return-to-stance (TRACE)

## DECISIONS

**Population:** boxing ruleset, 3 seeds, 3/3 bouts finished, 59,470 frames at 30 fps; out-boxer f01_m_box_welter vs pressure puncher f09_m_bare_welter (legal welterweight pair, distinct stats); catalogue `technique_catalog.json`; inertialized joins (0.27 s strike/stance, 0.05 s reaction).

| outgoing | windows | mean used° | mean best° | share best < ½ used | p50 phase s |
|---|---:|---:|---:|---:|---:|
| react_head | 240 | 1.46 | 1.30 | 0.000 | 4.633 |
| jab | 172 | 0.95 | 0.76 | 0.000 | 4.567 |
| cross | 140 | 1.38 | 0.98 | 0.000 | 0.100 |
| hook_lead | 101 | 4.78 | 4.09 | 0.000 | 1.267 |
| hook_rear | 57 | 77.68 | 76.94 | 0.000 | 0.133 |
| slip | 87 | 2.09 | 1.47 | 0.000 | 4.067 |
| react_body | 108 | 2.71 | 2.22 | 0.000 | 4.400 |
| block | 34 | 59.47 | 57.64 | 0.000 | 1.267 |
| other | 31 | 1.42 | 1.01 | 0.000 | 0.100 |

**Verdict:** For typical returns (jab/cross/react/slip) the player-chosen idle phase is already within 1-2° mean joint error of the outgoing pose, and the nearest loop phase is only 10-30% closer (e.g. jab 0.95° used v 0.76° best) — never half the gap (0% share). Hook_rear and block are outliers (~60–78°) where even the best phase is far; R5 breaks there from pose mismatch, not wrong phase index. Phase snapping alone is insufficient; clip choice or blend may matter more.

**Gate:** RULE lines byte-identical before/after report-only `R5-ENTRY` lines. No behaviour change.

CORRECTED AT COLLECTION (Claude, 2026-09-14): the verdict as delivered said "within ~10–30° mean joint error" - the table's used/best distances are 0.95-4.78°; the 10-30% is how much nearer the best phase is. READING (Claude): ordinary returns do not jump at all (1-2°), so their R5b over-bound windows come from a near-static guard hold being the speed reference; the visible pose jumps are hook_rear (77°, the mirrored stance) and block (59°).

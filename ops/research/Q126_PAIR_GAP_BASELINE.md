# Q126 — pair-gap baseline (BEFORE S41 girdle change)

## POPULATION

- **Commit:** `6787d327` (master, 2026-09-21)
- **Fighter A:** `f01_m_box_welter_rigged.glb` (welterweight)
- **Fighter B:** `f02_m_box_heavy_rigged.glb` (heavyweight)
- Weight limits are **different** — this is deliberate; the project never
  measures two identical fighters.
- **Godot:** `4.7.2.stable.official.ed1daf0bf`
- **Instrument:** `Godot/tools/pair_gap_report.gd` (S31 gate instrument)

## BASELINE

| key | table | frames | min_gap_m | max_gap_m | mean_gap_m |
|-----|-------|--------|-----------|-----------|------------|
| grapple_sweep | grapple | 56 | 0.125340 | 0.544697 | 0.367793 |
| grapple_takedown | grapple | 51 | 0.008533 | 0.529741 | 0.259378 |
| grapple_throw | grapple | 71 | 0.006989 | 0.679522 | 0.234731 |
| grapple_submission_attempt | grapple | 135 | 0.006802 | 0.776481 | 0.256723 |
| grapple_submission_finish | grapple | 181 | 0.271846 | 0.336168 | 0.305516 |
| grapple_escape | grapple | 81 | 0.007008 | 0.367654 | 0.126621 |
| grapple_clinch_break | grapple | 81 | 0.007008 | 0.367654 | 0.126621 |
| grapple_control | grapple | 51 | 0.302639 | 0.304671 | 0.303635 |
| grapple_stand_up | grapple | 76 | 0.006975 | 0.695765 | 0.450031 |

`grapple_escape` and `grapple_clinch_break` bind the same pair file
(`Paired_FullMount_PushOff`) — identical rows are expected.

## RAW

```
PAIRGAP key=grapple_sweep table=grapple frames=56 min_gap_m=0.125340 max_gap_m=0.544697 mean_gap_m=0.367793
PAIRGAP key=grapple_takedown table=grapple frames=51 min_gap_m=0.008533 max_gap_m=0.529741 mean_gap_m=0.259378
PAIRGAP key=grapple_throw table=grapple frames=71 min_gap_m=0.006989 max_gap_m=0.679522 mean_gap_m=0.234731
PAIRGAP key=grapple_submission_attempt table=grapple frames=135 min_gap_m=0.006802 max_gap_m=0.776481 mean_gap_m=0.256723
PAIRGAP key=grapple_submission_finish table=grapple frames=181 min_gap_m=0.271846 max_gap_m=0.336168 mean_gap_m=0.305516
PAIRGAP key=grapple_escape table=grapple frames=81 min_gap_m=0.007008 max_gap_m=0.367654 mean_gap_m=0.126621
PAIRGAP key=grapple_clinch_break table=grapple frames=81 min_gap_m=0.007008 max_gap_m=0.367654 mean_gap_m=0.126621
PAIRGAP key=grapple_control table=grapple frames=51 min_gap_m=0.302639 max_gap_m=0.304671 mean_gap_m=0.303635
PAIRGAP key=grapple_stand_up table=grapple frames=76 min_gap_m=0.006975 max_gap_m=0.695765 mean_gap_m=0.450031
```

## WHAT THIS IS FOR

These are the BEFORE numbers for the S41 `SILHOUETTE_SEGMENTS` girdle change;
anyone quoting an AFTER number must quote the matching row here beside it.
Regenerate the table from the raw logs with
`python Tools/q126_pair_gap_table.py`.

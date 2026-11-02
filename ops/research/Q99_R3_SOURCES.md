# Q99 - R3 source bucketing

## DECISIONS

| bucket | frames | share | mean_total | mean_body | mean_root | max_root |
|--------|--------|-------|------------|-----------|-----------|----------|
| join | 23323 | 0.205 | 0.574 | 0.560 | 0.048 | 0.291 |
| take | 90444 | 0.795 | 0.068 | 0.063 | 0.010 | 0.291 |
| walk | 0 | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| finished | 0 | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| all | 113767 | 1.000 | 0.172 | 0.165 | 0.018 | 0.291 |

The **join** bucket holds the most sum_total (13,387 m/s vs take's 6,150 m/s).

Top 3 roles by sum_total overall: **react_body** (take, 3516 m/s), **hook_rear** (join, 2995 m/s), **hook_lead** (join, 1981 m/s).

Population: ruleset=boxing rounds=3 seeds=[94301, 51227, 77003] bouts_finished=3/3 frames=59470 fps=30 joins=inertialized (production: into a strike 0.27 s, back to stance 0.27 s, into a hit 0.05 s)

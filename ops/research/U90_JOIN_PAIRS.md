## DECISIONS

POPULATION ruleset=boxing rounds=3 seeds=[94301, 51227, 77003] bouts_finished=3/3 frames=59470 fps=30 joins=inertialized (production: into a strike 0.27 s, back to stance 0.27 s, into a hit 0.05 s)

### R5-PAIRS (top 15 by over windows)

| pair | ending | windows | over | share | worst_bone | mean_ratio |
| --- | --- | ---: | ---: | ---: | --- | ---: |
| react_head -> idle | finished | 240 | 218 | 0.908 | RightLowerArm | 3.80 |
| jab -> idle | finished | 172 | 170 | 0.988 | RightLowerArm | 1.90 |
| cross -> idle | finished | 140 | 134 | 0.957 | RightLowerArm | 2.54 |
| hook_lead -> idle | cut | 89 | 85 | 0.955 | RightLowerArm | 9.63 |
| slip -> idle | finished | 87 | 85 | 0.977 | RightLowerArm | 6.21 |
| react_body -> idle | finished | 86 | 78 | 0.907 | RightLowerArm | 4.63 |
| idle -> hook_rear | finished | 59 | 59 | 1.000 | LeftUpperLeg | 2.63 |
| cross -> jab | cut | 50 | 49 | 0.980 | RightUpperArm | 3.13 |
| hook_rear -> idle | cut | 47 | 47 | 1.000 | RightLowerArm | 110.69 |
| idle -> hook_lead | finished | 132 | 46 | 0.348 | RightUpperLeg | 1.75 |
| hook_lead -> cross | cut | 45 | 42 | 0.933 | RightLowerArm | 2.02 |
| hook_rear -> hook_lead | cut | 40 | 40 | 1.000 | RightUpperLeg | 2.52 |
| hook_lead -> hook_rear | cut | 37 | 37 | 1.000 | LeftUpperLeg | 2.76 |
| jab -> cross | cut | 37 | 36 | 0.973 | RightUpperLeg | 2.20 |
| block -> idle | finished | 34 | 34 | 1.000 | LeftLowerArm | 119.28 |

### R5-ENDING

| ending | windows | over | share |
| --- | ---: | ---: | ---: |
| cut | 1060 | 892 | 0.842 |
| finished | 1477 | 947 | 0.641 |

### R5-GROUP

| group | over_windows |
| --- | ---: |
| arms | 1527 |
| legs | 1733 |

Cut-ended joins carry most of the over-bound share (84% vs 64% for looping/finished exits), and return-to-idle pairs after strikes or reactions (`react_head -> idle`, `jab -> idle`, `cross -> idle`) dominate the over window count; legs slightly outnumber arms among over windows.

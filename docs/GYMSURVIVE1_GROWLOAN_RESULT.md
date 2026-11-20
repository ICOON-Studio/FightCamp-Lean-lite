# GYMSURVIVE1 result - does a fresh gym survive two years?

Probe run: 2026-11-20T11:00:44. 30 careers x 2 seeds x 1 arms = 60 careers, 104 weeks each. Wall time: 1140.9 s.

## Population

- Career.quick_start(): one walk-in boxer signed (Lucy), Reid sessional coach hired, the shipped cash and members.
- 30 careers x 2 seeds ([4421, 9001]) = 60 careers per arm, 104 weeks each.
- Arms:
  - **PASSIVE**: touch nothing (today's probes).
  - **SENSIBLE**: one class night (ClubClasses, Wed), sign a second walk-in when one arrives and cash > 3 months of costs, accept the first pro offer (Roster.turn_pro with the plain deal).
  - **LEAN**: SENSIBLE + half stipend / day job for the boxer when cash < 8 weeks of costs (GymSpend.set_half).
- Bout loop: tools/turn_pro_probe3.gd _answer_open (accept sheet offers, camps, weigh-ins, fight by the sim, after_fight).

## Closure share by week

| arm | closed@26 | closed@52 | closed@78 | closed@104 | med_close_week |
|---|---|---|---|---|---|
| GROWLOAN | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | none |

## Cash at weeks 13/26/52/104 (median [p10..p90])

| arm | cash@13 | cash@26 | cash@52 | cash@104 |
|---|---|---|---|---|
| GROWLOAN | $11036 [$10549..$11036] | $9020 [$8095..$9827] | $4337 [$2518..$5616] | $6405 [$3790..$24137] |

## Members at weeks 13/26/52/104 (median [p10..p90])

| arm | members@13 | members@26 | members@52 | members@104 |
|---|---|---|---|---|
| GROWLOAN | 61 [59..61] | 69 [64..72] | 73 [70..82] | 140 [73..150] |

## Closure causes (every closed career)

| arm | seed | close_week | final_day | top_costs | top_income |
|---|---|---|---|---|---|
| (none closed) | | | | | |

## Per-career log

## S531 growth at week 104 (median [p10..p90]): reputation, member room, members, boxers

| arm | rep_end | cap_end | members_end | boxers | moved |
|---|---|---|---|---|---|
| GROWLOAN | 177 [149..190] | 140 [70..140] | 140 [73..150] | 3 [3..3] | 36/60 |

| arm | seed | closed | final_day | cash_end | members_end | walkin | pro | half |
|---|---|---|---|---|---|---|---|---|
| GROWLOAN | 36097 | no | 728 | $4255 | 75 | - | yes | - |
| GROWLOAN | 36234 | no | 728 | $6720 | 143 | - | yes | - |
| GROWLOAN | 36371 | no | 728 | $4460 | 74 | - | yes | - |
| GROWLOAN | 36508 | no | 728 | $5058 | 76 | - | yes | - |
| GROWLOAN | 36645 | no | 728 | $10744 | 147 | - | yes | - |
| GROWLOAN | 36782 | no | 728 | $4609 | 88 | - | yes | - |
| GROWLOAN | 36919 | no | 728 | $3692 | 75 | - | yes | - |
| GROWLOAN | 37056 | no | 728 | $34309 | 151 | - | yes | - |
| GROWLOAN | 37193 | no | 728 | $9199 | 149 | - | yes | - |
| GROWLOAN | 37330 | no | 728 | $6843 | 143 | - | yes | - |
| GROWLOAN | 37467 | no | 728 | $3204 | 72 | - | yes | - |
| GROWLOAN | 37604 | no | 728 | $4128 | 130 | - | yes | - |
| GROWLOAN | 37741 | no | 728 | $19829 | 144 | - | yes | - |
| GROWLOAN | 37878 | no | 728 | $15137 | 145 | - | yes | - |
| GROWLOAN | 38015 | no | 728 | $4605 | 76 | - | yes | - |
| GROWLOAN | 38152 | no | 728 | $3845 | 75 | - | yes | - |
| GROWLOAN | 38289 | no | 728 | $17089 | 145 | - | yes | - |
| GROWLOAN | 38426 | no | 728 | $12096 | 154 | - | yes | - |
| GROWLOAN | 38563 | no | 728 | $3572 | 73 | - | yes | - |
| GROWLOAN | 38700 | no | 728 | $3747 | 68 | - | yes | - |
| GROWLOAN | 38837 | no | 728 | $26907 | 143 | - | yes | - |
| GROWLOAN | 38974 | no | 728 | $20609 | 152 | - | yes | - |
| GROWLOAN | 39111 | no | 728 | $5414 | 79 | - | yes | - |
| GROWLOAN | 39248 | no | 728 | $3795 | 79 | - | yes | - |
| GROWLOAN | 39385 | no | 728 | $32293 | 143 | - | yes | - |
| GROWLOAN | 39522 | no | 728 | $21249 | 142 | - | yes | - |
| GROWLOAN | 39659 | no | 728 | $4025 | 70 | - | yes | - |
| GROWLOAN | 39796 | no | 728 | $3837 | 81 | - | yes | - |
| GROWLOAN | 39933 | no | 728 | $18425 | 146 | - | yes | - |
| GROWLOAN | 40070 | no | 728 | $6603 | 144 | - | yes | - |
| GROWLOAN | 40677 | no | 728 | $4306 | 74 | - | yes | - |
| GROWLOAN | 40814 | no | 728 | $4200 | 74 | - | yes | - |
| GROWLOAN | 40951 | no | 728 | $6207 | 149 | - | yes | - |
| GROWLOAN | 41088 | no | 728 | $35140 | 150 | - | yes | - |
| GROWLOAN | 41225 | no | 728 | $8638 | 153 | - | yes | - |
| GROWLOAN | 41362 | no | 728 | $9237 | 144 | - | yes | - |
| GROWLOAN | 41499 | no | 728 | $3595 | 79 | - | yes | - |
| GROWLOAN | 41636 | no | 728 | $4705 | 74 | - | yes | - |
| GROWLOAN | 41773 | no | 728 | $4947 | 72 | - | yes | - |
| GROWLOAN | 41910 | no | 728 | $7647 | 148 | - | yes | - |
| GROWLOAN | 42047 | no | 728 | $4321 | 79 | - | yes | - |
| GROWLOAN | 42184 | no | 728 | $25186 | 145 | - | yes | - |
| GROWLOAN | 42321 | no | 728 | $25755 | 142 | - | yes | - |
| GROWLOAN | 42458 | no | 728 | $4256 | 82 | - | yes | - |
| GROWLOAN | 42595 | no | 728 | $24021 | 150 | - | yes | - |
| GROWLOAN | 42732 | no | 728 | $5003 | 140 | - | yes | - |
| GROWLOAN | 42869 | no | 728 | $8428 | 140 | - | yes | - |
| GROWLOAN | 43006 | no | 728 | $10159 | 143 | - | yes | - |
| GROWLOAN | 43143 | no | 728 | $4156 | 73 | - | yes | - |
| GROWLOAN | 43280 | no | 728 | $7834 | 111 | - | yes | - |
| GROWLOAN | 43417 | no | 728 | $7628 | 149 | - | yes | - |
| GROWLOAN | 43554 | no | 728 | $10914 | 155 | - | yes | - |
| GROWLOAN | 43691 | no | 728 | $13908 | 146 | - | yes | - |
| GROWLOAN | 43828 | no | 728 | $4658 | 76 | - | yes | - |
| GROWLOAN | 43965 | no | 728 | $4039 | 73 | - | yes | - |
| GROWLOAN | 44102 | no | 728 | $13937 | 140 | - | yes | - |
| GROWLOAN | 44239 | no | 728 | $16927 | 145 | - | yes | - |
| GROWLOAN | 44376 | no | 728 | $5177 | 78 | - | yes | - |
| GROWLOAN | 44513 | no | 728 | $3211 | 122 | - | yes | - |
| GROWLOAN | 44650 | no | 728 | $4451 | 76 | - | yes | - |

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/gym_survive_probe.gd`

GYMSURVIVE1 done

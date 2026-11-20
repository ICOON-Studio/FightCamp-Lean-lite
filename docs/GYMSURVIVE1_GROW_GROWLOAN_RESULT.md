# GYMSURVIVE1 result - does a fresh gym survive two years?

Probe run: 2026-11-20T04:16:09. 30 careers x 2 seeds x 2 arms = 120 careers, 104 weeks each. Wall time: 2186.2 s.

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
| GROW | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | none |
| GROWLOAN | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | none |

## Cash at weeks 13/26/52/104 (median [p10..p90])

| arm | cash@13 | cash@26 | cash@52 | cash@104 |
|---|---|---|---|---|
| GROW | $11036 [$10593..$11036] | $9020 [$8321..$10268] | $4402 [$1696..$5421] | $4605 [$3519..$12090] |
| GROWLOAN | $11036 [$10549..$11036] | $9020 [$8095..$9827] | $4337 [$2518..$5616] | $5729 [$3741..$25299] |

## Members at weeks 13/26/52/104 (median [p10..p90])

| arm | members@13 | members@26 | members@52 | members@104 |
|---|---|---|---|---|
| GROW | 61 [61..62] | 67 [61..72] | 76 [70..81] | 75 [72..79] |
| GROWLOAN | 61 [59..61] | 69 [64..72] | 73 [70..82] | 140 [73..158] |

## Closure causes (every closed career)

| arm | seed | close_week | final_day | top_costs | top_income |
|---|---|---|---|---|---|
| (none closed) | | | | | |

## Per-career log

## S531 growth at week 104 (median [p10..p90]): reputation, member room, members, boxers

| arm | rep_end | cap_end | members_end | boxers | moved |
|---|---|---|---|---|---|
| GROW | 174 [151..202] | 70 [70..70] | 75 [72..79] | 3 [3..3] | 1/60 |
| GROWLOAN | 176 [149..195] | 140 [70..150] | 140 [73..158] | 3 [3..3] | 36/60 |

| arm | seed | closed | final_day | cash_end | members_end | walkin | pro | half |
|---|---|---|---|---|---|---|---|---|
| GROW | 28178 | no | 728 | $14490 | 77 | - | yes | - |
| GROW | 28315 | no | 728 | $4170 | 76 | - | yes | - |
| GROW | 28452 | no | 728 | $13629 | 74 | - | yes | - |
| GROW | 28589 | no | 728 | $7948 | 76 | - | yes | - |
| GROW | 28726 | no | 728 | $7199 | 73 | - | yes | - |
| GROW | 28863 | no | 728 | $4231 | 75 | - | yes | - |
| GROW | 29000 | no | 728 | $4308 | 72 | - | yes | - |
| GROW | 29137 | no | 728 | $4739 | 76 | - | yes | - |
| GROW | 29274 | no | 728 | $8856 | 76 | - | yes | - |
| GROW | 29411 | no | 728 | $4296 | 76 | - | yes | - |
| GROW | 29548 | no | 728 | $4352 | 73 | - | yes | - |
| GROW | 29685 | no | 728 | $6737 | 85 | - | yes | - |
| GROW | 29822 | no | 728 | $4134 | 76 | - | yes | - |
| GROW | 29959 | no | 728 | $13098 | 77 | - | yes | - |
| GROW | 30096 | no | 728 | $4883 | 73 | - | yes | - |
| GROW | 30233 | no | 728 | $3314 | 76 | - | yes | - |
| GROW | 30370 | no | 728 | $4586 | 74 | - | yes | - |
| GROW | 30507 | no | 728 | $4366 | 74 | - | yes | - |
| GROW | 30644 | no | 728 | $4385 | 75 | - | yes | - |
| GROW | 30781 | no | 728 | $4024 | 75 | - | yes | - |
| GROW | 30918 | no | 728 | $4825 | 79 | - | yes | - |
| GROW | 31055 | no | 728 | $11562 | 74 | - | yes | - |
| GROW | 31192 | no | 728 | $4117 | 73 | - | yes | - |
| GROW | 31329 | no | 728 | $4979 | 76 | - | yes | - |
| GROW | 31466 | no | 728 | $4790 | 76 | - | yes | - |
| GROW | 31603 | no | 728 | $3999 | 80 | - | yes | - |
| GROW | 31740 | no | 728 | $3952 | 78 | - | yes | - |
| GROW | 31877 | no | 728 | $4625 | 79 | - | yes | - |
| GROW | 32014 | no | 728 | $3322 | 75 | - | yes | - |
| GROW | 32151 | no | 728 | $3500 | 74 | - | yes | - |
| GROW | 32758 | no | 728 | $4219 | 73 | - | yes | - |
| GROW | 32895 | no | 728 | $6675 | 75 | - | yes | - |
| GROW | 33032 | no | 728 | $4627 | 76 | - | yes | - |
| GROW | 33169 | no | 728 | $14533 | 73 | - | yes | - |
| GROW | 33306 | no | 728 | $11991 | 76 | - | yes | - |
| GROW | 33443 | no | 728 | $5638 | 76 | - | yes | - |
| GROW | 33580 | no | 728 | $5100 | 76 | - | yes | - |
| GROW | 33717 | no | 728 | $1719 | 70 | - | yes | - |
| GROW | 33854 | no | 728 | $4128 | 70 | - | yes | - |
| GROW | 33991 | no | 728 | $6080 | 73 | - | yes | - |
| GROW | 34128 | no | 728 | $4342 | 76 | - | yes | - |
| GROW | 34265 | no | 728 | $4188 | 76 | - | yes | - |
| GROW | 34402 | no | 728 | $3380 | 70 | - | yes | - |
| GROW | 34539 | no | 728 | $5438 | 73 | - | yes | - |
| GROW | 34676 | no | 728 | $4788 | 79 | - | yes | - |
| GROW | 34813 | no | 728 | $4317 | 76 | - | yes | - |
| GROW | 34950 | no | 728 | $4740 | 73 | - | yes | - |
| GROW | 35087 | no | 728 | $5129 | 78 | - | yes | - |
| GROW | 35224 | no | 728 | $11727 | 81 | - | yes | - |
| GROW | 35361 | no | 728 | $3987 | 73 | - | yes | - |
| GROW | 35498 | no | 728 | $4568 | 75 | - | yes | - |
| GROW | 35635 | no | 728 | $3522 | 75 | - | yes | - |
| GROW | 35772 | no | 728 | $6554 | 79 | - | yes | - |
| GROW | 35909 | no | 728 | $6894 | 84 | - | yes | - |
| GROW | 36046 | no | 728 | $4585 | 73 | - | yes | - |
| GROW | 36183 | no | 728 | $4107 | 73 | - | yes | - |
| GROW | 36320 | no | 728 | $4013 | 83 | - | yes | - |
| GROW | 36457 | no | 728 | $12984 | 72 | - | yes | - |
| GROW | 36594 | no | 728 | $3192 | 72 | - | yes | - |
| GROW | 36731 | no | 728 | $24799 | 140 | - | yes | - |
| GROWLOAN | 36097 | no | 728 | $4255 | 75 | - | yes | - |
| GROWLOAN | 36234 | no | 728 | $8558 | 153 | - | yes | - |
| GROWLOAN | 36371 | no | 728 | $4460 | 74 | - | yes | - |
| GROWLOAN | 36508 | no | 728 | $5058 | 76 | - | yes | - |
| GROWLOAN | 36645 | no | 728 | $13622 | 155 | - | yes | - |
| GROWLOAN | 36782 | no | 728 | $4782 | 88 | - | yes | - |
| GROWLOAN | 36919 | no | 728 | $3692 | 75 | - | yes | - |
| GROWLOAN | 37056 | no | 728 | $43957 | 153 | - | yes | - |
| GROWLOAN | 37193 | no | 728 | $6130 | 151 | - | yes | - |
| GROWLOAN | 37330 | no | 728 | $12783 | 153 | - | yes | - |
| GROWLOAN | 37467 | no | 728 | $3487 | 73 | - | yes | - |
| GROWLOAN | 37604 | no | 728 | $4041 | 119 | - | yes | - |
| GROWLOAN | 37741 | no | 728 | $22038 | 154 | - | yes | - |
| GROWLOAN | 37878 | no | 728 | $15133 | 145 | - | yes | - |
| GROWLOAN | 38015 | no | 728 | $4605 | 76 | - | yes | - |
| GROWLOAN | 38152 | no | 728 | $3845 | 75 | - | yes | - |
| GROWLOAN | 38289 | no | 728 | $16682 | 145 | - | yes | - |
| GROWLOAN | 38426 | no | 728 | $11362 | 161 | - | yes | - |
| GROWLOAN | 38563 | no | 728 | $3572 | 73 | - | yes | - |
| GROWLOAN | 38700 | no | 728 | $3747 | 68 | - | yes | - |
| GROWLOAN | 38837 | no | 728 | $26848 | 143 | - | yes | - |
| GROWLOAN | 38974 | no | 728 | $21226 | 161 | - | yes | - |
| GROWLOAN | 39111 | no | 728 | $5414 | 79 | - | yes | - |
| GROWLOAN | 39248 | no | 728 | $3795 | 79 | - | yes | - |
| GROWLOAN | 39385 | no | 728 | $40990 | 153 | - | yes | - |
| GROWLOAN | 39522 | no | 728 | $21190 | 142 | - | yes | - |
| GROWLOAN | 39659 | no | 728 | $4025 | 70 | - | yes | - |
| GROWLOAN | 39796 | no | 728 | $3837 | 81 | - | yes | - |
| GROWLOAN | 39933 | no | 728 | $17853 | 156 | - | yes | - |
| GROWLOAN | 40070 | no | 728 | $3541 | 147 | - | yes | - |
| GROWLOAN | 40677 | no | 728 | $4306 | 74 | - | yes | - |
| GROWLOAN | 40814 | no | 728 | $4170 | 74 | - | yes | - |
| GROWLOAN | 40951 | no | 728 | $11218 | 159 | - | yes | - |
| GROWLOAN | 41088 | no | 728 | $42866 | 159 | - | yes | - |
| GROWLOAN | 41225 | no | 728 | $8185 | 161 | - | yes | - |
| GROWLOAN | 41362 | no | 728 | $15753 | 154 | - | yes | - |
| GROWLOAN | 41499 | no | 728 | $3595 | 79 | - | yes | - |
| GROWLOAN | 41636 | no | 728 | $4705 | 74 | - | yes | - |
| GROWLOAN | 41773 | no | 728 | $5887 | 72 | - | yes | - |
| GROWLOAN | 41910 | no | 728 | $9954 | 158 | - | yes | - |
| GROWLOAN | 42047 | no | 728 | $3968 | 79 | - | yes | - |
| GROWLOAN | 42184 | no | 728 | $25127 | 145 | - | yes | - |
| GROWLOAN | 42321 | no | 728 | $32051 | 152 | - | yes | - |
| GROWLOAN | 42458 | no | 728 | $4719 | 82 | - | yes | - |
| GROWLOAN | 42595 | no | 728 | $29793 | 160 | - | yes | - |
| GROWLOAN | 42732 | no | 728 | $5572 | 140 | - | yes | - |
| GROWLOAN | 42869 | no | 728 | $7444 | 140 | - | yes | - |
| GROWLOAN | 43006 | no | 728 | $10100 | 143 | - | yes | - |
| GROWLOAN | 43143 | no | 728 | $4156 | 73 | - | yes | - |
| GROWLOAN | 43280 | no | 728 | $5368 | 102 | - | yes | - |
| GROWLOAN | 43417 | no | 728 | $8026 | 157 | - | yes | - |
| GROWLOAN | 43554 | no | 728 | $15885 | 155 | - | yes | - |
| GROWLOAN | 43691 | no | 728 | $13539 | 150 | - | yes | - |
| GROWLOAN | 43828 | no | 728 | $4658 | 76 | - | yes | - |
| GROWLOAN | 43965 | no | 728 | $4039 | 73 | - | yes | - |
| GROWLOAN | 44102 | no | 728 | $15589 | 147 | - | yes | - |
| GROWLOAN | 44239 | no | 728 | $19401 | 150 | - | yes | - |
| GROWLOAN | 44376 | no | 728 | $5023 | 78 | - | yes | - |
| GROWLOAN | 44513 | no | 728 | $3370 | 123 | - | yes | - |
| GROWLOAN | 44650 | no | 728 | $4451 | 76 | - | yes | - |

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/gym_survive_probe.gd`

GYMSURVIVE1 done

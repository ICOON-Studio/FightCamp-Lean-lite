# GYMSURVIVE1 result - does a fresh gym survive two years?

Probe run: 2026-11-20T03:39:04. 30 careers x 2 seeds x 1 arms = 60 careers, 104 weeks each. Wall time: 831.6 s.

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
| GROWLOAN | $16579 [$16518..$16579] | $17331 [$17331..$19814] | $26696 [$19700..$28579] | $39792 [$26649..$53319] |

## Members at weeks 13/26/52/104 (median [p10..p90])

| arm | members@13 | members@26 | members@52 | members@104 |
|---|---|---|---|---|
| GROWLOAN | 66 [64..66] | 71 [66..71] | 70 [70..74] | 83 [71..92] |

## Closure causes (every closed career)

| arm | seed | close_week | final_day | top_costs | top_income |
|---|---|---|---|---|---|
| (none closed) | | | | | |

## Per-career log

## S531 growth at week 104 (median [p10..p90]): reputation, member room, members, boxers

| arm | rep_end | cap_end | members_end | boxers | moved |
|---|---|---|---|---|---|
| GROWLOAN | 52 [42..67] | 140 [70..140] | 83 [71..92] | 1 [1..1] | 53/60 |

| arm | seed | closed | final_day | cash_end | members_end | walkin | pro | half |
|---|---|---|---|---|---|---|---|---|
| GROWLOAN | 36097 | no | 728 | $37896 | 82 | - | yes | - |
| GROWLOAN | 36234 | no | 728 | $37436 | 82 | - | yes | - |
| GROWLOAN | 36371 | no | 728 | $26679 | 80 | - | yes | - |
| GROWLOAN | 36508 | no | 728 | $36644 | 81 | - | yes | - |
| GROWLOAN | 36645 | no | 728 | $38812 | 96 | - | yes | - |
| GROWLOAN | 36782 | no | 728 | $60295 | 91 | - | yes | - |
| GROWLOAN | 36919 | no | 728 | $42690 | 78 | - | yes | - |
| GROWLOAN | 37056 | no | 728 | $37120 | 70 | - | yes | - |
| GROWLOAN | 37193 | no | 728 | $29933 | 84 | - | yes | - |
| GROWLOAN | 37330 | no | 728 | $46569 | 70 | - | yes | - |
| GROWLOAN | 37467 | no | 728 | $47307 | 70 | - | yes | - |
| GROWLOAN | 37604 | no | 728 | $36556 | 82 | - | yes | - |
| GROWLOAN | 37741 | no | 728 | $86159 | 78 | - | yes | - |
| GROWLOAN | 37878 | no | 728 | $46607 | 83 | - | yes | - |
| GROWLOAN | 38015 | no | 728 | $42445 | 79 | - | yes | - |
| GROWLOAN | 38152 | no | 728 | $40769 | 89 | - | yes | - |
| GROWLOAN | 38289 | no | 728 | $39210 | 79 | - | yes | - |
| GROWLOAN | 38426 | no | 728 | $26387 | 86 | - | yes | - |
| GROWLOAN | 38563 | no | 728 | $33764 | 85 | - | yes | - |
| GROWLOAN | 38700 | no | 728 | $29741 | 87 | - | yes | - |
| GROWLOAN | 38837 | no | 728 | $40542 | 87 | - | yes | - |
| GROWLOAN | 38974 | no | 728 | $44244 | 99 | - | yes | - |
| GROWLOAN | 39111 | no | 728 | $43537 | 97 | - | yes | - |
| GROWLOAN | 39248 | no | 728 | $40062 | 87 | - | yes | - |
| GROWLOAN | 39385 | no | 728 | $66264 | 87 | - | yes | - |
| GROWLOAN | 39522 | no | 728 | $52636 | 85 | - | yes | - |
| GROWLOAN | 39659 | no | 728 | $41814 | 78 | - | yes | - |
| GROWLOAN | 39796 | no | 728 | $27882 | 85 | - | yes | - |
| GROWLOAN | 39933 | no | 728 | $34783 | 80 | - | yes | - |
| GROWLOAN | 40070 | no | 728 | $42355 | 87 | - | yes | - |
| GROWLOAN | 40677 | no | 728 | $44228 | 86 | - | yes | - |
| GROWLOAN | 40814 | no | 728 | $39523 | 82 | - | yes | - |
| GROWLOAN | 40951 | no | 728 | $14911 | 72 | - | yes | - |
| GROWLOAN | 41088 | no | 728 | $29812 | 86 | - | yes | - |
| GROWLOAN | 41225 | no | 728 | $27948 | 84 | - | yes | - |
| GROWLOAN | 41362 | no | 728 | $12183 | 82 | - | yes | - |
| GROWLOAN | 41499 | no | 728 | $38586 | 86 | - | yes | - |
| GROWLOAN | 41636 | no | 728 | $38395 | 86 | - | yes | - |
| GROWLOAN | 41773 | no | 728 | $44413 | 92 | - | yes | - |
| GROWLOAN | 41910 | no | 728 | $42374 | 100 | - | yes | - |
| GROWLOAN | 42047 | no | 728 | $41846 | 89 | - | yes | - |
| GROWLOAN | 42184 | no | 728 | $23414 | 70 | - | yes | - |
| GROWLOAN | 42321 | no | 728 | $59466 | 87 | - | yes | - |
| GROWLOAN | 42458 | no | 728 | $45509 | 80 | - | yes | - |
| GROWLOAN | 42595 | no | 728 | $73294 | 98 | - | yes | - |
| GROWLOAN | 42732 | no | 728 | $29943 | 83 | - | yes | - |
| GROWLOAN | 42869 | no | 728 | $39431 | 80 | - | yes | - |
| GROWLOAN | 43006 | no | 728 | $37675 | 70 | - | yes | - |
| GROWLOAN | 43143 | no | 728 | $42405 | 83 | - | yes | - |
| GROWLOAN | 43280 | no | 728 | $45531 | 83 | - | yes | - |
| GROWLOAN | 43417 | no | 728 | $13035 | 81 | - | yes | - |
| GROWLOAN | 43554 | no | 728 | $45997 | 93 | - | yes | - |
| GROWLOAN | 43691 | no | 728 | $32623 | 83 | - | yes | - |
| GROWLOAN | 43828 | no | 728 | $29384 | 82 | - | yes | - |
| GROWLOAN | 43965 | no | 728 | $15851 | 70 | - | yes | - |
| GROWLOAN | 44102 | no | 728 | $44795 | 88 | - | yes | - |
| GROWLOAN | 44239 | no | 728 | $36676 | 81 | - | yes | - |
| GROWLOAN | 44376 | no | 728 | $61386 | 80 | - | yes | - |
| GROWLOAN | 44513 | no | 728 | $42185 | 80 | - | yes | - |
| GROWLOAN | 44650 | no | 728 | $44737 | 78 | - | yes | - |

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/gym_survive_probe.gd`

GYMSURVIVE1 done

# GYMSURVIVE1 result - does a fresh gym survive two years?

Probe run: 2026-11-20T02:30:02. 2 careers x 2 seeds x 1 arms = 4 careers, 104 weeks each. Wall time: 56.0 s.

## Population

- Career.quick_start(): one walk-in boxer signed (Lucy), Reid sessional coach hired, the shipped cash and members.
- 2 careers x 2 seeds ([4421, 9001]) = 4 careers per arm, 104 weeks each.
- Arms:
  - **PASSIVE**: touch nothing (today's probes).
  - **SENSIBLE**: one class night (ClubClasses, Wed), sign a second walk-in when one arrives and cash > 3 months of costs, accept the first pro offer (Roster.turn_pro with the plain deal).
  - **LEAN**: SENSIBLE + half stipend / day job for the boxer when cash < 8 weeks of costs (GymSpend.set_half).
- Bout loop: tools/turn_pro_probe3.gd _answer_open (accept sheet offers, camps, weigh-ins, fight by the sim, after_fight).

## Closure share by week

| arm | closed@26 | closed@52 | closed@78 | closed@104 | med_close_week |
|---|---|---|---|---|---|
| GROWLOAN | 0/4 (0%) | 0/4 (0%) | 0/4 (0%) | 0/4 (0%) | none |

## Cash at weeks 13/26/52/104 (median [p10..p90])

| arm | cash@13 | cash@26 | cash@52 | cash@104 |
|---|---|---|---|---|
| GROWLOAN | $12129 [$12129..$12129] | $10013 [$10013..$10013] | $9386 [$8055..$9838] | $5080 [$4924..$5237] |

## Members at weeks 13/26/52/104 (median [p10..p90])

| arm | members@13 | members@26 | members@52 | members@104 |
|---|---|---|---|---|
| GROWLOAN | 66 [66..66] | 70 [70..70] | 70 [70..70] | 70 [70..70] |

## Closure causes (every closed career)

| arm | seed | close_week | final_day | top_costs | top_income |
|---|---|---|---|---|---|
| (none closed) | | | | | |

## Per-career log

## S531 growth at week 104 (median [p10..p90]): reputation, member room, members, boxers

| arm | rep_end | cap_end | members_end | boxers | moved |
|---|---|---|---|---|---|
| GROWLOAN | 50 [50..51] | 70 [70..70] | 70 [70..70] | 1 [1..1] | 0/4 |

| arm | seed | closed | final_day | cash_end | members_end | walkin | pro | half |
|---|---|---|---|---|---|---|---|---|
| GROWLOAN | 36097 | no | 728 | $5225 | 70 | - | yes | - |
| GROWLOAN | 36234 | no | 728 | $5243 | 70 | - | yes | - |
| GROWLOAN | 40677 | no | 728 | $4919 | 70 | - | yes | - |
| GROWLOAN | 40814 | no | 728 | $4936 | 70 | - | yes | - |

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/gym_survive_probe.gd`

GYMSURVIVE1 done

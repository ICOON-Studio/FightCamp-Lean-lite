# GYMSURVIVE1 result - does a fresh gym survive two years?

Probe run: 2026-11-19T21:12:16. 30 careers x 2 seeds x 3 arms = 180 careers, 104 weeks each. Wall time: 88.8 s.

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
| PASSIVE | 0/4 (0%) | 0/4 (0%) | 4/4 (100%) | 4/4 (100%) | 64 |
| SENSIBLE | 0/4 (0%) | 0/4 (0%) | 0/4 (0%) | 0/4 (0%) | none |
| LEAN | 0/4 (0%) | 0/4 (0%) | 0/4 (0%) | 0/4 (0%) | none |

## Cash at weeks 13/26/52/104 (median [p10..p90])

| arm | cash@13 | cash@26 | cash@52 | cash@104 |
|---|---|---|---|---|
| PASSIVE | $12456 [$12456..$12456] | $9065 [$8770..$9485] | $-2089 [$-2688..$-1529] | - |
| SENSIBLE | $13977 [$13977..$13977] | $10862 [$10582..$10862] | $9131 [$8200..$9435] | $6573 [$5555..$8138] |
| LEAN | $13829 [$13608..$13977] | $11462 [$11362..$11835] | $9154 [$8778..$9534] | $7506 [$3916..$9127] |

## Members at weeks 13/26/52/104 (median [p10..p90])

| arm | members@13 | members@26 | members@52 | members@104 |
|---|---|---|---|---|
| PASSIVE | 66 [66..66] | 70 [67..70] | 69 [69..69] | - |
| SENSIBLE | 66 [66..66] | 70 [70..70] | 66 [66..67] | 66 [66..67] |
| LEAN | 66 [65..66] | 70 [70..70] | 66 [66..68] | 66 [66..67] |

## Closure causes (every closed career)

| arm | seed | close_week | final_day | top_costs | top_income |
|---|---|---|---|---|---|
| PASSIVE | 4421 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 4558 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$558, classes=$350, bjj=$127, total=$1035 |
| PASSIVE | 9001 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 9138 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |

## Per-career log

| arm | seed | closed | final_day | cash_end | members_end | walkin | pro | half |
|---|---|---|---|---|---|---|---|---|
| PASSIVE | 4421 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 4558 | YES w68 | 469 | $-2725 | 69 | - | - | - |
| PASSIVE | 9001 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 9138 | YES w64 | 441 | $-3489 | 67 | - | - | - |
| SENSIBLE | 12340 | no | 728 | $6181 | 66 | - | yes | - |
| SENSIBLE | 12477 | no | 728 | $8642 | 68 | - | yes | - |
| SENSIBLE | 16920 | no | 728 | $6965 | 66 | - | yes | - |
| SENSIBLE | 17057 | no | 728 | $5287 | 66 | - | yes | - |
| LEAN | 20259 | no | 728 | $2802 | 66 | - | yes | yes |
| LEAN | 20396 | no | 728 | $9398 | 68 | - | yes | yes |
| LEAN | 24839 | no | 728 | $6517 | 66 | - | yes | yes |
| LEAN | 24976 | no | 728 | $8496 | 66 | - | yes | yes |

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/gym_survive_probe.gd`

GYMSURVIVE1 done

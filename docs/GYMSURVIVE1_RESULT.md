# GYMSURVIVE1 result - does a fresh gym survive two years?

Probe run: 2026-11-20T01:38:41. 30 careers x 2 seeds x 3 arms = 180 careers, 104 weeks each. Wall time: 5137.7 s.

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
| PASSIVE | 0/60 (0%) | 0/60 (0%) | 60/60 (100%) | 60/60 (100%) | 64 |
| SENSIBLE | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | none |
| LEAN | 0/60 (0%) | 0/60 (0%) | 0/60 (0%) | 2/60 (3%) | 102 |

## Cash at weeks 13/26/52/104 (median [p10..p90])

| arm | cash@13 | cash@26 | cash@52 | cash@104 |
|---|---|---|---|---|
| PASSIVE | $12456 [$12403..$12456] | $9065 [$8585..$9640] | $-2089 [$-3311..$-1047] | - |
| SENSIBLE | $13977 [$13972..$13977] | $10862 [$10862..$11993] | $8905 [$3998..$9655] | $7011 [$2401..$9546] |
| LEAN | $13977 [$13770..$13977] | $11362 [$11362..$12465] | $9181 [$6426..$10486] | $7744 [$-3706..$10177] |

## Members at weeks 13/26/52/104 (median [p10..p90])

| arm | members@13 | members@26 | members@52 | members@104 |
|---|---|---|---|---|
| PASSIVE | 66 [64..66] | 70 [67..70] | 69 [66..69] | - |
| SENSIBLE | 66 [66..66] | 70 [66..70] | 66 [66..69] | 66 [66..68] |
| LEAN | 66 [65..66] | 70 [66..70] | 66 [66..66] | 66 [66..68] |

## Closure causes (every closed career)

| arm | seed | close_week | final_day | top_costs | top_income |
|---|---|---|---|---|---|
| PASSIVE | 4421 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 4558 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$558, classes=$350, bjj=$127, total=$1035 |
| PASSIVE | 4695 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 4832 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$550, classes=$350, bjj=$127, total=$1027 |
| PASSIVE | 4969 | 60 | 413 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$582, classes=$350, bjj=$152, total=$1084 |
| PASSIVE | 5106 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 5243 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 5380 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 5517 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 5654 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 5791 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$550, classes=$350, bjj=$127, total=$1027 |
| PASSIVE | 5928 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 6065 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 6202 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 6339 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 6476 | 72 | 497 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$558, classes=$350, bjj=$127, total=$1035 |
| PASSIVE | 6613 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$558, classes=$350, bjj=$152, total=$1060 |
| PASSIVE | 6750 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 6887 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$566, classes=$350, bjj=$152, total=$1068 |
| PASSIVE | 7024 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 7161 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 7298 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 7435 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$533, classes=$350, bjj=$127, total=$1010 |
| PASSIVE | 7572 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 7709 | 60 | 413 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$582, classes=$350, bjj=$152, total=$1084 |
| PASSIVE | 7846 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 7983 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$550, classes=$350, bjj=$152, total=$1052 |
| PASSIVE | 8120 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$550, classes=$350, bjj=$152, total=$1052 |
| PASSIVE | 8257 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$550, classes=$350, bjj=$152, total=$1052 |
| PASSIVE | 8394 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 9001 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 9138 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 9275 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$558, classes=$350, bjj=$152, total=$1060 |
| PASSIVE | 9412 | 60 | 413 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$582, classes=$350, bjj=$152, total=$1084 |
| PASSIVE | 9549 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 9686 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 9823 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$550, classes=$350, bjj=$152, total=$1052 |
| PASSIVE | 9960 | 60 | 413 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$582, classes=$350, bjj=$152, total=$1084 |
| PASSIVE | 10097 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 10234 | 60 | 413 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$582, classes=$350, bjj=$152, total=$1084 |
| PASSIVE | 10371 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$533, classes=$350, bjj=$127, total=$1010 |
| PASSIVE | 10508 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$533, classes=$350, bjj=$127, total=$1010 |
| PASSIVE | 10645 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$550, classes=$350, bjj=$152, total=$1052 |
| PASSIVE | 10782 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$550, classes=$350, bjj=$152, total=$1052 |
| PASSIVE | 10919 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$533, classes=$350, bjj=$152, total=$1035 |
| PASSIVE | 11056 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 11193 | 60 | 413 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$582, classes=$350, bjj=$152, total=$1084 |
| PASSIVE | 11330 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 11467 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 11604 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$558, classes=$350, bjj=$127, total=$1035 |
| PASSIVE | 11741 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 11878 | 60 | 413 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$582, classes=$350, bjj=$152, total=$1084 |
| PASSIVE | 12015 | 60 | 413 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$582, classes=$350, bjj=$152, total=$1084 |
| PASSIVE | 12152 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$533, classes=$350, bjj=$152, total=$1035 |
| PASSIVE | 12289 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 12426 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$558, classes=$350, bjj=$152, total=$1060 |
| PASSIVE | 12563 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$558, classes=$350, bjj=$127, total=$1035 |
| PASSIVE | 12700 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 12837 | 64 | 441 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1491 | dues=$542, classes=$350, bjj=$152, total=$1044 |
| PASSIVE | 12974 | 68 | 469 | rent=$416, fees=$7, power=$89, bjj=$170, kit=$45, total=$1427 | dues=$558, classes=$350, bjj=$127, total=$1035 |
| LEAN | 23136 | 104 | 721 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1241 | dues=$533, classes=$350, bjj=$102, total=$985 |
| LEAN | 23273 | 100 | 693 | rent=$416, fees=$7, power=$153, bjj=$170, kit=$45, total=$1241 | dues=$517, classes=$350, bjj=$102, total=$969 |

## Per-career log

| arm | seed | closed | final_day | cash_end | members_end | walkin | pro | half |
|---|---|---|---|---|---|---|---|---|
| PASSIVE | 4421 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 4558 | YES w68 | 469 | $-2725 | 69 | - | - | - |
| PASSIVE | 4695 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 4832 | YES w68 | 469 | $-2063 | 68 | - | - | - |
| PASSIVE | 4969 | YES w60 | 413 | $-1524 | 72 | - | - | - |
| PASSIVE | 5106 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 5243 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 5380 | YES w64 | 441 | $-2629 | 67 | - | - | - |
| PASSIVE | 5517 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 5654 | YES w64 | 441 | $-2633 | 67 | - | - | - |
| PASSIVE | 5791 | YES w68 | 469 | $-1492 | 68 | - | - | - |
| PASSIVE | 5928 | YES w64 | 441 | $-3033 | 67 | - | - | - |
| PASSIVE | 6065 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 6202 | YES w64 | 441 | $-3033 | 67 | - | - | - |
| PASSIVE | 6339 | YES w64 | 441 | $-3633 | 67 | - | - | - |
| PASSIVE | 6476 | YES w72 | 497 | $-2526 | 69 | - | - | - |
| PASSIVE | 6613 | YES w64 | 441 | $-1855 | 69 | - | - | - |
| PASSIVE | 6750 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 6887 | YES w64 | 441 | $-3884 | 70 | - | - | - |
| PASSIVE | 7024 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 7161 | YES w64 | 441 | $-3033 | 67 | - | - | - |
| PASSIVE | 7298 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 7435 | YES w68 | 469 | $-1615 | 66 | - | - | - |
| PASSIVE | 7572 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 7709 | YES w60 | 413 | $-2335 | 72 | - | - | - |
| PASSIVE | 7846 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 7983 | YES w64 | 441 | $-1642 | 68 | - | - | - |
| PASSIVE | 8120 | YES w64 | 441 | $-2102 | 68 | - | - | - |
| PASSIVE | 8257 | YES w64 | 441 | $-2642 | 68 | - | - | - |
| PASSIVE | 8394 | YES w64 | 441 | $-3366 | 67 | - | - | - |
| PASSIVE | 9001 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 9138 | YES w64 | 441 | $-3489 | 67 | - | - | - |
| PASSIVE | 9275 | YES w64 | 441 | $-3392 | 69 | - | - | - |
| PASSIVE | 9412 | YES w60 | 413 | $-1876 | 72 | - | - | - |
| PASSIVE | 9549 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 9686 | YES w64 | 441 | $-3033 | 67 | - | - | - |
| PASSIVE | 9823 | YES w64 | 441 | $-1233 | 68 | - | - | - |
| PASSIVE | 9960 | YES w60 | 413 | $-1524 | 72 | - | - | - |
| PASSIVE | 10097 | YES w64 | 441 | $-2597 | 67 | - | - | - |
| PASSIVE | 10234 | YES w60 | 413 | $-1683 | 72 | - | - | - |
| PASSIVE | 10371 | YES w68 | 469 | $-1856 | 66 | - | - | - |
| PASSIVE | 10508 | YES w68 | 469 | $-1815 | 66 | - | - | - |
| PASSIVE | 10645 | YES w64 | 441 | $-2575 | 68 | - | - | - |
| PASSIVE | 10782 | YES w64 | 441 | $-1235 | 68 | - | - | - |
| PASSIVE | 10919 | YES w64 | 441 | $-3790 | 66 | - | - | - |
| PASSIVE | 11056 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 11193 | YES w60 | 413 | $-2000 | 72 | - | - | - |
| PASSIVE | 11330 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 11467 | YES w64 | 441 | $-2833 | 67 | - | - | - |
| PASSIVE | 11604 | YES w68 | 469 | $-2973 | 69 | - | - | - |
| PASSIVE | 11741 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 11878 | YES w60 | 413 | $-1803 | 72 | - | - | - |
| PASSIVE | 12015 | YES w60 | 413 | $-2196 | 72 | - | - | - |
| PASSIVE | 12152 | YES w64 | 441 | $-2597 | 66 | - | - | - |
| PASSIVE | 12289 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 12426 | YES w64 | 441 | $-2199 | 69 | - | - | - |
| PASSIVE | 12563 | YES w68 | 469 | $-2376 | 69 | - | - | - |
| PASSIVE | 12700 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 12837 | YES w64 | 441 | $-3233 | 67 | - | - | - |
| PASSIVE | 12974 | YES w68 | 469 | $-2191 | 69 | - | - | - |
| SENSIBLE | 12340 | no | 728 | $6181 | 66 | - | yes | - |
| SENSIBLE | 12477 | no | 728 | $8642 | 68 | - | yes | - |
| SENSIBLE | 12614 | no | 728 | $10128 | 66 | - | yes | - |
| SENSIBLE | 12751 | no | 728 | $8021 | 66 | - | yes | - |
| SENSIBLE | 12888 | no | 728 | $8320 | 66 | - | yes | - |
| SENSIBLE | 13025 | no | 728 | $8280 | 66 | - | yes | - |
| SENSIBLE | 13162 | no | 728 | $7132 | 66 | - | yes | - |
| SENSIBLE | 13299 | no | 728 | $6017 | 66 | - | yes | - |
| SENSIBLE | 13436 | no | 728 | $2768 | 69 | - | yes | - |
| SENSIBLE | 13573 | no | 728 | $6221 | 70 | - | yes | - |
| SENSIBLE | 13710 | no | 728 | $10398 | 66 | - | yes | - |
| SENSIBLE | 13847 | no | 728 | $11237 | 68 | - | yes | - |
| SENSIBLE | 13984 | no | 728 | $2532 | 67 | - | yes | - |
| SENSIBLE | 14121 | no | 728 | $6403 | 66 | - | yes | - |
| SENSIBLE | 14258 | no | 728 | $8299 | 66 | - | yes | - |
| SENSIBLE | 14395 | no | 728 | $5136 | 67 | - | yes | - |
| SENSIBLE | 14532 | no | 728 | $6632 | 68 | - | yes | - |
| SENSIBLE | 14669 | no | 728 | $295 | 67 | - | yes | - |
| SENSIBLE | 14806 | no | 728 | $8650 | 68 | - | yes | - |
| SENSIBLE | 14943 | no | 728 | $8807 | 66 | - | yes | - |
| SENSIBLE | 15080 | no | 728 | $7389 | 66 | - | yes | - |
| SENSIBLE | 15217 | no | 728 | $5466 | 70 | - | yes | - |
| SENSIBLE | 15354 | no | 728 | $10041 | 66 | - | yes | - |
| SENSIBLE | 15491 | no | 728 | $10885 | 68 | - | yes | - |
| SENSIBLE | 15628 | no | 728 | $1012 | 66 | - | yes | - |
| SENSIBLE | 15765 | no | 728 | $6562 | 66 | - | yes | - |
| SENSIBLE | 15902 | no | 728 | $7210 | 68 | - | yes | - |
| SENSIBLE | 16039 | no | 728 | $7204 | 66 | - | yes | - |
| SENSIBLE | 16176 | no | 728 | $8363 | 68 | - | yes | - |
| SENSIBLE | 16313 | no | 728 | $6527 | 68 | - | yes | - |
| SENSIBLE | 16920 | no | 728 | $6965 | 66 | - | yes | - |
| SENSIBLE | 17057 | no | 728 | $5287 | 66 | - | yes | - |
| SENSIBLE | 17194 | no | 728 | $7226 | 66 | - | yes | - |
| SENSIBLE | 17331 | no | 728 | $6990 | 66 | - | yes | - |
| SENSIBLE | 17468 | no | 728 | $9534 | 70 | - | yes | - |
| SENSIBLE | 17605 | no | 728 | $6439 | 66 | - | yes | - |
| SENSIBLE | 17742 | no | 728 | $5463 | 67 | - | yes | - |
| SENSIBLE | 17879 | no | 728 | $7032 | 66 | - | yes | - |
| SENSIBLE | 18016 | no | 728 | $4631 | 68 | - | yes | - |
| SENSIBLE | 18153 | no | 728 | $8296 | 66 | - | yes | - |
| SENSIBLE | 18290 | no | 728 | $7216 | 66 | - | yes | - |
| SENSIBLE | 18427 | no | 728 | $9654 | 68 | - | yes | - |
| SENSIBLE | 18564 | no | 728 | $6172 | 66 | - | yes | - |
| SENSIBLE | 18701 | no | 728 | $9043 | 66 | - | yes | - |
| SENSIBLE | 18838 | no | 728 | $8327 | 66 | - | yes | - |
| SENSIBLE | 18975 | no | 728 | $2995 | 66 | - | yes | - |
| SENSIBLE | 19112 | no | 728 | $6630 | 68 | - | yes | - |
| SENSIBLE | 19249 | no | 728 | $7876 | 66 | - | yes | - |
| SENSIBLE | 19386 | no | 728 | $704 | 66 | - | yes | - |
| SENSIBLE | 19523 | no | 728 | $1229 | 66 | - | yes | - |
| SENSIBLE | 19660 | no | 728 | $-1758 | 66 | - | yes | - |
| SENSIBLE | 19797 | no | 728 | $8027 | 66 | - | yes | - |
| SENSIBLE | 19934 | no | 728 | $2922 | 66 | - | yes | - |
| SENSIBLE | 20071 | no | 728 | $3571 | 72 | - | yes | - |
| SENSIBLE | 20208 | no | 728 | $4074 | 68 | - | yes | - |
| SENSIBLE | 20345 | no | 728 | $7198 | 66 | - | yes | - |
| SENSIBLE | 20482 | no | 728 | $1018 | 66 | - | yes | - |
| SENSIBLE | 20619 | no | 728 | $7488 | 66 | - | yes | - |
| SENSIBLE | 20756 | no | 728 | $7108 | 66 | - | yes | - |
| SENSIBLE | 20893 | no | 728 | $5158 | 66 | - | yes | - |
| LEAN | 20259 | no | 728 | $2802 | 66 | - | yes | yes |
| LEAN | 20396 | no | 728 | $9398 | 68 | - | yes | yes |
| LEAN | 20533 | no | 728 | $-219 | 66 | - | yes | yes |
| LEAN | 20670 | no | 728 | $9347 | 66 | - | yes | yes |
| LEAN | 20807 | no | 728 | $8689 | 66 | - | yes | yes |
| LEAN | 20944 | no | 728 | $7378 | 66 | - | yes | yes |
| LEAN | 21081 | no | 728 | $10212 | 68 | - | yes | yes |
| LEAN | 21218 | no | 728 | $6473 | 66 | - | yes | yes |
| LEAN | 21355 | no | 728 | $-3645 | 66 | - | - | yes |
| LEAN | 21492 | no | 728 | $-3849 | 66 | - | yes | yes |
| LEAN | 21629 | no | 728 | $10162 | 68 | - | yes | yes |
| LEAN | 21766 | no | 728 | $8438 | 66 | - | yes | yes |
| LEAN | 21903 | no | 728 | $10435 | 67 | - | yes | - |
| LEAN | 22040 | no | 728 | $8005 | 68 | - | yes | yes |
| LEAN | 22177 | no | 728 | $6139 | 66 | - | yes | yes |
| LEAN | 22314 | no | 728 | $9133 | 66 | - | yes | yes |
| LEAN | 22451 | no | 728 | $4880 | 66 | - | yes | yes |
| LEAN | 22588 | no | 728 | $9425 | 68 | - | yes | yes |
| LEAN | 22725 | no | 728 | $7637 | 66 | - | yes | yes |
| LEAN | 22862 | no | 728 | $7807 | 66 | - | yes | yes |
| LEAN | 22999 | no | 728 | $-4636 | 66 | - | - | yes |
| LEAN | 23136 | YES w104 | 721 | $-1957 | 66 | - | - | yes |
| LEAN | 23273 | YES w100 | 693 | $-1169 | 64 | - | - | yes |
| LEAN | 23410 | no | 728 | $5022 | 68 | - | yes | yes |
| LEAN | 23547 | no | 728 | $7220 | 66 | - | yes | yes |
| LEAN | 23684 | no | 728 | $8019 | 68 | - | yes | yes |
| LEAN | 23821 | no | 728 | $8290 | 66 | - | yes | yes |
| LEAN | 23958 | no | 728 | $8170 | 66 | - | yes | yes |
| LEAN | 24095 | no | 728 | $-2187 | 66 | - | yes | yes |
| LEAN | 24232 | no | 728 | $2797 | 66 | - | yes | yes |
| LEAN | 24839 | no | 728 | $6517 | 66 | - | yes | yes |
| LEAN | 24976 | no | 728 | $8496 | 66 | - | yes | yes |
| LEAN | 25113 | no | 728 | $-4487 | 66 | - | yes | yes |
| LEAN | 25250 | no | 728 | $7257 | 66 | - | yes | yes |
| LEAN | 25387 | no | 728 | $6463 | 66 | - | yes | yes |
| LEAN | 25524 | no | 728 | $8465 | 68 | - | yes | yes |
| LEAN | 25661 | no | 728 | $10716 | 66 | - | yes | yes |
| LEAN | 25798 | no | 728 | $-4320 | 66 | - | - | yes |
| LEAN | 25935 | no | 728 | $-3866 | 66 | - | - | yes |
| LEAN | 26072 | no | 728 | $6459 | 66 | - | yes | yes |
| LEAN | 26209 | no | 728 | $7217 | 66 | - | yes | yes |
| LEAN | 26346 | no | 728 | $8213 | 66 | - | yes | yes |
| LEAN | 26483 | no | 728 | $9680 | 66 | - | yes | yes |
| LEAN | 26620 | no | 728 | $7827 | 70 | - | yes | yes |
| LEAN | 26757 | no | 728 | $11086 | 66 | - | yes | yes |
| LEAN | 26894 | no | 728 | $7785 | 68 | - | yes | yes |
| LEAN | 27031 | no | 728 | $8914 | 66 | - | yes | yes |
| LEAN | 27168 | no | 728 | $8306 | 70 | - | yes | yes |
| LEAN | 27305 | no | 728 | $5662 | 68 | - | yes | yes |
| LEAN | 27442 | no | 728 | $8390 | 66 | - | yes | yes |
| LEAN | 27579 | no | 728 | $7244 | 66 | - | yes | yes |
| LEAN | 27716 | no | 728 | $-3107 | 66 | - | - | yes |
| LEAN | 27853 | no | 728 | $8237 | 66 | - | yes | yes |
| LEAN | 27990 | no | 728 | $7537 | 66 | - | yes | yes |
| LEAN | 28127 | no | 728 | $-4368 | 66 | - | yes | yes |
| LEAN | 28264 | no | 728 | $9193 | 66 | - | yes | yes |
| LEAN | 28401 | no | 728 | $7703 | 68 | - | yes | yes |
| LEAN | 28538 | no | 728 | $7593 | 66 | - | yes | yes |
| LEAN | 28675 | no | 728 | $10705 | 66 | - | yes | yes |
| LEAN | 28812 | no | 728 | $10497 | 66 | - | yes | yes |

Reproduce: `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/gym_survive_probe.gd`

GYMSURVIVE1 done

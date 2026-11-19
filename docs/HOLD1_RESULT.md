# HOLD1 Result - the specialty: four ways to hold, and the minutes that make it a choice

Probe run 2026-11-19T21:59:33, Godot 4.7.2 headless, 659.6 s, 486720 fighter-weeks. Seeds [4481, 4482, 4483], 195 careers = 65 fighters (Data.PROSPECTS' 5 named prospects + 60 walk-ins, prog_probe's population) x 3 seeds, two seasons (104 weeks), 6 arms (3 hold-minute pairs x 2 pad budgets), policies ["PLAN", "WIDE", "DEEP", "COACH"].
Run: `godot --headless --audio-driver Dummy --path . --script res://tools/hold1_probe.gd`.

## Method

ARM B of tools/prog_probe.gd, re-priced. Population and modelled rules are prog_probe's (prog_probe_rules.gd: learning slots, shadow mornings, apply_hold, is_frozen); the week is copied into this probe so the hold runs at each arm's minutes instead of the shipped 20/40 units. Day-0 punches use the game's PunchStart rule (prog_probe floored every punch at 30, which leaves no new punch to time). Nothing in scripts/ is changed.

- **Minutes to units.** A pad night is `PadWeek.PAD_NIGHT_MINUTES` = 240 drill units = 75 real minutes (`WeekPlan.EVENINGS.pads.min`), so one real minute = 3.2 units. The arms are John's hold minutes a week (Sharp/Signature 10/20, 15/30, 20/40). The shipped `Specialty.HOLD_SHARP/HOLD_SIGNATURE` are 20/40 units = 6.25/12.5 real minutes, cheaper than every arm.
- **Two pad budgets.** `3n` = `PadWeek.nights_for(1,..)`, the game's Standard week between fights (3 pad nights + 1 sparring), prog_probe's ARM B. `2n` = `nights_for(0,..)`, Light (2 + 1): the club's 8 pad nights shared by four fighters (map M3, AGREED PADPOOL1), the budget the '4 to 5 Sharp and 1 to 2 Signatures' estimate is about. Sparring is `PadWeek.SPAR_NIGHT_MINUTES` = 180 units shared over `PadWeek.spar_pool`; the plan's cards ride the tray, so sparring credits them.
- **The week.** Holds are paid first in policy order; the learning slot keeps the coach's two new-move nights (`PadWeek.defaults`); the rest is split over the policy's growth list (and when nothing is left under 60, the surplus pushes the policy's deepest moves toward Signature). Then the shadow morning (60 units, prog_probe_rules), then ONE hold at the arm's minutes (`Specialty.units` + `ProgRules.apply_hold`), then the week's stat growth. A node under 30 is drilled only in a learning slot (map M2, `StepMastery.drillable`); at 30+ it can always be drilled.
- **Policies.** PLAN: the fight plan's moves at 60+. WIDE: every move at 60+, cheapest first (Sharp before Signature), to hold as many as possible. DEEP: the top 3 at 60+, and all surplus pushes the highest move under 85. COACH: `LearnSlots.ANSWERS` for the next opponent's style + the plan, plus every Signature; PLAN when that is empty. The plan is the game's own: `CoachPlan.write` + the `PlanTemplates` real-plan template for `OppFile.main_game`, at `PlanBoard.arrow_limit(58)`; the next opponent turns every 8 weeks.
- **Stats.** `WeekPlan.week` on the coach's base week (`WeekPlan.COACH_WEEK`) and the week's evenings, each day's gain applied through `Attrs.apply_session` as Sim.step_day does: Technique grows from the pad nights, Ring IQ from sparring, so the mastery cap (40 + 0.4 Technique + 0.2 Ring IQ) rises - the map's 'first Signature is also a Technique goal'. CONTROL_STAT checks it against Sim's day-by-day route.
- **Steps and defences.** Drilled on pad nights and in sparring at the same station formula as a punch, and held (map M4). The shipped wiring can do neither: CONTROL_STEP measures it.
- **Held vs Sharp.** Sharp = a node at 60-84, Signature = 85+, over all 16 tree nodes; HELD = those that got their arm's minutes in the season's last week (the specialty board's list). G1 reads the held counts, the map's 'can hold about 4 to 5'. 'Target' = the share of careers holding 4-5 Sharp and >=1 Signature.
- **Same-start pairs.** One fighter's day-0 dict, deep-copied under two policies: 6 pairs per fighter per seed. Different held sets = the sorted list of nodes at 60+ at the end of season 2 differs.
- **Not modelled.** No bouts (so no camp, taper, fight week or injury: no frozen weeks, no fight-proven +3, no camp's focused morning), no bag cards (`carded` empty, as in prog_probe), no coach market or second slot (pads 58, one slot), no veteran fade. A pick that never crossed 30 counts as 104 weeks in the median.

## Cells (median [p10..p90] over the careers of all 3 seeds)

| Arm (min/wk @ pad nights) | Policy | S1 Sharp | S1 Sig | S2 Sharp | S2 Sig | S2 held Sharp | S2 held Sig | Target share | Weeks to Usable | <=4 wk | Named style max | Cap |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 10/20@3n | PLAN | 7 [4..8] | 0 [0..0] | 7 [5..8] | 0 [0..3] | 6 [4..8] | 0 [0..3] | 0.21 | 2.0 | 1.00 | 0.17 | 84.2 |
| 10/20@3n | WIDE | 16 [13..16] | 0 [0..0] | 16 [16..16] | 0 [0..0] | 16 [16..16] | 0 [0..0] | 0.00 | 2.0 | 1.00 | 0.77 | 84.2 |
| 10/20@3n | DEEP | 1 [1..2] | 0 [0..0] | 2 [1..2] | 0 [0..4] | 2 [1..2] | 0 [0..4] | 0.00 | 2.0 | 1.00 | 0.15 | 84.2 |
| 10/20@3n | COACH | 8 [6..10] | 0 [0..0] | 8 [6..10] | 0 [0..3] | 7 [5..9] | 0 [0..3] | 0.22 | 2.0 | 1.00 | 0.22 | 84.2 |
| 15/30@3n | PLAN | 7 [3..8] | 0 [0..0] | 7 [5..8] | 0 [0..2] | 6 [4..7] | 0 [0..2] | 0.25 | 2.0 | 1.00 | 0.14 | 84.2 |
| 15/30@3n | WIDE | 12 [12..12] | 0 [0..0] | 12 [12..12] | 0 [0..0] | 12 [12..12] | 0 [0..0] | 0.00 | 2.0 | 1.00 | 0.85 | 84.2 |
| 15/30@3n | DEEP | 1 [1..2] | 0 [0..0] | 2 [1..2] | 0 [0..4] | 2 [1..2] | 0 [0..4] | 0.00 | 2.0 | 1.00 | 0.13 | 84.2 |
| 15/30@3n | COACH | 8 [6..10] | 0 [0..0] | 8 [6..10] | 0 [0..3] | 7 [5..9] | 0 [0..3] | 0.20 | 2.0 | 1.00 | 0.27 | 84.2 |
| 20/40@3n | PLAN | 6 [3..8] | 0 [0..0] | 6 [4..8] | 0 [0..2] | 5 [3..7] | 0 [0..2] | 0.22 | 2.0 | 1.00 | 0.20 | 84.2 |
| 20/40@3n | WIDE | 3 [2..4] | 0 [0..0] | 3 [2..4] | 0 [0..1] | 3 [2..4] | 0 [0..1] | 0.02 | 2.0 | 1.00 | 0.03 | 84.2 |
| 20/40@3n | DEEP | 1 [1..1] | 0 [0..0] | 2 [1..2] | 0 [0..3] | 2 [0..2] | 0 [0..3] | 0.00 | 2.0 | 1.00 | 0.10 | 84.2 |
| 20/40@3n | COACH | 8 [6..9] | 0 [0..0] | 8 [6..9] | 0 [0..2] | 7 [5..8] | 0 [0..2] | 0.18 | 2.0 | 1.00 | 0.33 | 84.2 |
| 10/20@2n | PLAN | 5 [3..6] | 0 [0..0] | 6 [5..8] | 0 [0..2] | 6 [5..7] | 0 [0..2] | 0.13 | 2.0 | 1.00 | 0.53 | 83.3 |
| 10/20@2n | WIDE | 8 [7..10] | 0 [0..0] | 14 [12..14] | 0 [0..0] | 14 [12..14] | 0 [0..0] | 0.00 | 2.0 | 0.85 | 0.58 | 83.3 |
| 10/20@2n | DEEP | 1 [1..1] | 0 [0..0] | 1 [1..2] | 0 [0..3] | 1 [1..2] | 0 [0..3] | 0.00 | 2.0 | 1.00 | 0.01 | 83.3 |
| 10/20@2n | COACH | 5 [4..8] | 0 [0..0] | 8 [7..9] | 0 [0..0] | 8 [7..9] | 0 [0..0] | 0.01 | 2.0 | 1.00 | 0.15 | 83.3 |
| 15/30@2n | PLAN | 5 [4..6] | 0 [0..0] | 7 [4..8] | 0 [0..1] | 6 [4..7] | 0 [0..1] | 0.08 | 2.0 | 1.00 | 0.58 | 83.3 |
| 15/30@2n | WIDE | 4 [1..7] | 0 [0..0] | 4 [1..7] | 0 [0..0] | 4 [1..7] | 0 [0..0] | 0.01 | 2.0 | 0.97 | 0.11 | 83.3 |
| 15/30@2n | DEEP | 1 [1..1] | 0 [0..0] | 1 [1..2] | 0 [0..2] | 1 [1..2] | 0 [0..2] | 0.00 | 2.0 | 1.00 | 0.01 | 83.3 |
| 15/30@2n | COACH | 4 [3..8] | 0 [0..0] | 8 [7..9] | 0 [0..0] | 8 [7..9] | 0 [0..0] | 0.01 | 2.0 | 0.98 | 0.17 | 83.3 |
| 20/40@2n | PLAN | 4 [3..6] | 0 [0..0] | 6 [3..8] | 0 [0..0] | 5 [2..7] | 0 [0..0] | 0.02 | 2.0 | 1.00 | 0.32 | 83.3 |
| 20/40@2n | WIDE | 1 [1..1] | 0 [0..0] | 1 [1..1] | 0 [0..0] | 1 [1..1] | 0 [0..0] | 0.00 | 2.0 | 1.00 | 0.00 | 83.3 |
| 20/40@2n | DEEP | 1 [1..1] | 0 [0..0] | 1 [1..2] | 0 [0..2] | 1 [1..2] | 0 [0..2] | 0.00 | 2.0 | 0.99 | 0.00 | 83.3 |
| 20/40@2n | COACH | 4 [3..7] | 0 [0..0] | 6 [6..7] | 0 [0..0] | 6 [5..7] | 0 [0..0] | 0.00 | 2.0 | 0.96 | 0.19 | 83.3 |

## Gates

G1 the best policy holds 4-5 Sharp + >=1 Signature by season 2 (the held counts, median). G2 no policy best in more than 2 of the 3 seeds (a seed's best = the highest median held Sharp + Signature; ties split the credit). G3 same-start pairs differ in >=50%. G4 the best policy's median weeks-to-Usable <= 4. Best = the highest pooled median held Sharp + Signature at season 2. The named-style share is reported per cell (John's item 2: no style in more than 1 in 3 careers), not gated.

| Arm | Best policy | Held Sharp | Held Sig | Target | WTU | G1 | G2 | G3 | G4 | Pair diff | Pass | Failed |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 10/20@3n | WIDE | 16 | 0 | 0.00 | 2.0 | 0 | 0 | 1 | 1 | 0.997 | 0 | g1,g2 |
| 15/30@3n | WIDE | 12 | 0 | 0.00 | 2.0 | 0 | 0 | 1 | 1 | 0.986 | 0 | g1,g2 |
| 20/40@3n | COACH | 7 | 0 | 0.18 | 2.0 | 0 | 0 | 1 | 1 | 0.969 | 0 | g1,g2 |
| 10/20@2n | WIDE | 14 | 0 | 0.00 | 2.0 | 0 | 0 | 1 | 1 | 0.996 | 0 | g1,g2 |
| 15/30@2n | COACH | 8 | 0 | 0.01 | 2.0 | 0 | 0 | 1 | 1 | 0.987 | 0 | g1,g2 |
| 20/40@2n | COACH | 6 | 0 | 0.00 | 2.0 | 0 | 1 | 1 | 1 | 0.938 | 0 | g1 |

## Controls and run log
```
HOLD1 seeds=[4481, 4482, 4483] weeks=104 policies=["PLAN", "WIDE", "DEEP", "COACH"] arms=6 pilot=false units_per_real_minute=3.20
CONTROL_WEEK my_week_vs_PadWeek.run_week max_delta=0.0000000000 OK
CONTROL_STAT my_week_vs_Sim_day_by_day max_delta=0.000381 technique=59.635 cap=75.30 OK
CONTROL_STEP shipped_drillable=false shipped_step_in=63.50 armB_step_in=66.70 (the shipped wiring cannot drill or hold a step at 60+)
CELL arm=10/20@3n pol=PLAN n=195 s1=7[4..8]/0[0..0] s2=7[5..8]/0[0..3] held2=6[4..8]/0[0..3] target=0.21 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Counter-puncher:31,Volume puncher:34,Pressure fighter:2,Boxer-puncher:1 maxstyle=0.17 sets=37 cap=84.2
CELL arm=10/20@3n pol=WIDE n=195 s1=16[13..16]/0[0..0] s2=16[16..16]/0[0..0] held2=16[16..16]/0[0..0] target=0.00 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Out-boxer:151,Slugger:8,Pressure fighter:7,Volume puncher:1 maxstyle=0.77 sets=1 cap=84.2
CELL arm=10/20@3n pol=DEEP n=195 s1=1[1..2]/0[0..0] s2=2[1..2]/0[0..4] held2=2[1..2]/0[0..4] target=0.00 wtu=2.0 le4=1.00 never=1 picks=1730 styles=Out-boxer:30 maxstyle=0.15 sets=21 cap=84.2
CELL arm=10/20@3n pol=COACH n=195 s1=8[6..10]/0[0..0] s2=8[6..10]/0[0..3] held2=7[5..9]/0[0..3] target=0.22 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Counter-puncher:43,Pressure fighter:5,Boxer-puncher:34,Volume puncher:8 maxstyle=0.22 sets=51 cap=84.2
BEST arm=10/20@3n seed=4481 scores=PLAN:7,WIDE:16,DEEP:2,COACH:8 best=WIDE
BEST arm=10/20@3n seed=4482 scores=PLAN:7,WIDE:16,DEEP:2,COACH:8 best=WIDE
BEST arm=10/20@3n seed=4483 scores=PLAN:7,WIDE:16,DEEP:2,COACH:8 best=WIDE
PAIRS arm=10/20@3n diff=1167/1170 share=0.997
GATE arm=10/20@3n best=WIDE held_sharp=16 held_sig=0 target=0.00 wtu=2.0 g1=0 g2=0 g3=1 g4=1 pass=0 failed=g1,g2
CELL arm=15/30@3n pol=PLAN n=195 s1=7[3..8]/0[0..0] s2=7[5..8]/0[0..2] held2=6[4..7]/0[0..2] target=0.25 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Volume puncher:27,Counter-puncher:18,Pressure fighter:6 maxstyle=0.14 sets=44 cap=84.2
CELL arm=15/30@3n pol=WIDE n=195 s1=12[12..12]/0[0..0] s2=12[12..12]/0[0..0] held2=12[12..12]/0[0..0] target=0.00 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Out-boxer:166,Volume puncher:1,Pressure fighter:4,Slugger:8 maxstyle=0.85 sets=3 cap=84.2
CELL arm=15/30@3n pol=DEEP n=195 s1=1[1..2]/0[0..0] s2=2[1..2]/0[0..4] held2=2[1..2]/0[0..4] target=0.00 wtu=2.0 le4=1.00 never=0 picks=1726 styles=Out-boxer:26 maxstyle=0.13 sets=21 cap=84.2
CELL arm=15/30@3n pol=COACH n=195 s1=8[6..10]/0[0..0] s2=8[6..10]/0[0..3] held2=7[5..9]/0[0..3] target=0.20 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Counter-puncher:52,Boxer-puncher:25,Volume puncher:1 maxstyle=0.27 sets=37 cap=84.2
BEST arm=15/30@3n seed=4481 scores=PLAN:6,WIDE:12,DEEP:2,COACH:8 best=WIDE
BEST arm=15/30@3n seed=4482 scores=PLAN:6,WIDE:12,DEEP:2,COACH:8 best=WIDE
BEST arm=15/30@3n seed=4483 scores=PLAN:7,WIDE:12,DEEP:2,COACH:8 best=WIDE
PAIRS arm=15/30@3n diff=1154/1170 share=0.986
GATE arm=15/30@3n best=WIDE held_sharp=12 held_sig=0 target=0.00 wtu=2.0 g1=0 g2=0 g3=1 g4=1 pass=0 failed=g1,g2
CELL arm=20/40@3n pol=PLAN n=195 s1=6[3..8]/0[0..0] s2=6[4..8]/0[0..2] held2=5[3..7]/0[0..2] target=0.22 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Volume puncher:39,Counter-puncher:7,Pressure fighter:1 maxstyle=0.20 sets=19 cap=84.2
CELL arm=20/40@3n pol=WIDE n=195 s1=3[2..4]/0[0..0] s2=3[2..4]/0[0..1] held2=3[2..4]/0[0..1] target=0.02 wtu=2.0 le4=1.00 never=5 picks=1882 styles=Out-boxer:5,Volume puncher:4,Slugger:1 maxstyle=0.03 sets=39 cap=84.2
CELL arm=20/40@3n pol=DEEP n=195 s1=1[1..1]/0[0..0] s2=2[1..2]/0[0..3] held2=2[0..2]/0[0..3] target=0.00 wtu=2.0 le4=1.00 never=1 picks=1724 styles=Out-boxer:20 maxstyle=0.10 sets=25 cap=84.2
CELL arm=20/40@3n pol=COACH n=195 s1=8[6..9]/0[0..0] s2=8[6..9]/0[0..2] held2=7[5..8]/0[0..2] target=0.18 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Counter-puncher:65,Boxer-puncher:33 maxstyle=0.33 sets=18 cap=84.2
BEST arm=20/40@3n seed=4481 scores=PLAN:6,WIDE:3,DEEP:2,COACH:8 best=COACH
BEST arm=20/40@3n seed=4482 scores=PLAN:6,WIDE:3,DEEP:2,COACH:8 best=COACH
BEST arm=20/40@3n seed=4483 scores=PLAN:6,WIDE:4,DEEP:2,COACH:8 best=COACH
PAIRS arm=20/40@3n diff=1134/1170 share=0.969
GATE arm=20/40@3n best=COACH held_sharp=7 held_sig=0 target=0.18 wtu=2.0 g1=0 g2=0 g3=1 g4=1 pass=0 failed=g1,g2
CELL arm=10/20@2n pol=PLAN n=195 s1=5[3..6]/0[0..0] s2=6[5..8]/0[0..2] held2=6[5..7]/0[0..2] target=0.13 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Volume puncher:103,Counter-puncher:2,Pressure fighter:3,Boxer-puncher:1 maxstyle=0.53 sets=30 cap=83.3
CELL arm=10/20@2n pol=WIDE n=195 s1=8[7..10]/0[0..0] s2=14[12..14]/0[0..0] held2=14[12..14]/0[0..0] target=0.00 wtu=2.0 le4=0.85 never=0 picks=2122 styles=Out-boxer:113,Pressure fighter:32,Volume puncher:13,Slugger:1 maxstyle=0.58 sets=7 cap=83.3
CELL arm=10/20@2n pol=DEEP n=195 s1=1[1..1]/0[0..0] s2=1[1..2]/0[0..3] held2=1[1..2]/0[0..3] target=0.00 wtu=2.0 le4=1.00 never=1 picks=1534 styles=Out-boxer:1 maxstyle=0.01 sets=38 cap=83.3
CELL arm=10/20@2n pol=COACH n=195 s1=5[4..8]/0[0..0] s2=8[7..9]/0[0..0] held2=8[7..9]/0[0..0] target=0.01 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Pressure fighter:9,Boxer-puncher:29,Counter-puncher:15,Out-boxer:11,Volume puncher:19,Slugger:4 maxstyle=0.15 sets=25 cap=83.3
BEST arm=10/20@2n seed=4481 scores=PLAN:6,WIDE:14,DEEP:2,COACH:8 best=WIDE
BEST arm=10/20@2n seed=4482 scores=PLAN:6,WIDE:14,DEEP:2,COACH:8 best=WIDE
BEST arm=10/20@2n seed=4483 scores=PLAN:6,WIDE:14,DEEP:2,COACH:8 best=WIDE
PAIRS arm=10/20@2n diff=1165/1170 share=0.996
GATE arm=10/20@2n best=WIDE held_sharp=14 held_sig=0 target=0.00 wtu=2.0 g1=0 g2=0 g3=1 g4=1 pass=0 failed=g1,g2
CELL arm=15/30@2n pol=PLAN n=195 s1=5[4..6]/0[0..0] s2=7[4..8]/0[0..1] held2=6[4..7]/0[0..1] target=0.08 wtu=2.0 le4=1.00 never=0 picks=2122 styles=Volume puncher:114,Boxer-puncher:3,Counter-puncher:1 maxstyle=0.58 sets=26 cap=83.3
CELL arm=15/30@2n pol=WIDE n=195 s1=4[1..7]/0[0..0] s2=4[1..7]/0[0..0] held2=4[1..7]/0[0..0] target=0.01 wtu=2.0 le4=0.97 never=1 picks=1618 styles=Out-boxer:21 maxstyle=0.11 sets=48 cap=83.3
CELL arm=15/30@2n pol=DEEP n=195 s1=1[1..1]/0[0..0] s2=1[1..2]/0[0..2] held2=1[1..2]/0[0..2] target=0.00 wtu=2.0 le4=1.00 never=0 picks=1529 styles=Out-boxer:1 maxstyle=0.01 sets=37 cap=83.3
CELL arm=15/30@2n pol=COACH n=195 s1=4[3..8]/0[0..0] s2=8[7..9]/0[0..0] held2=8[7..9]/0[0..0] target=0.01 wtu=2.0 le4=0.98 never=0 picks=2122 styles=Volume puncher:34,Counter-puncher:13,Out-boxer:28,Boxer-puncher:12,Pressure fighter:4,Slugger:2 maxstyle=0.17 sets=26 cap=83.3
BEST arm=15/30@2n seed=4481 scores=PLAN:6,WIDE:4,DEEP:2,COACH:8 best=COACH
BEST arm=15/30@2n seed=4482 scores=PLAN:7,WIDE:3,DEEP:2,COACH:8 best=COACH
BEST arm=15/30@2n seed=4483 scores=PLAN:6,WIDE:4,DEEP:2,COACH:8 best=COACH
PAIRS arm=15/30@2n diff=1155/1170 share=0.987
GATE arm=15/30@2n best=COACH held_sharp=8 held_sig=0 target=0.01 wtu=2.0 g1=0 g2=0 g3=1 g4=1 pass=0 failed=g1,g2
CELL arm=20/40@2n pol=PLAN n=195 s1=4[3..6]/0[0..0] s2=6[3..8]/0[0..0] held2=5[2..7]/0[0..0] target=0.02 wtu=2.0 le4=1.00 never=1 picks=2122 styles=Volume puncher:63 maxstyle=0.32 sets=15 cap=83.3
CELL arm=20/40@2n pol=WIDE n=195 s1=1[1..1]/0[0..0] s2=1[1..1]/0[0..0] held2=1[1..1]/0[0..0] target=0.00 wtu=2.0 le4=1.00 never=0 picks=1436 styles=none maxstyle=0.00 sets=13 cap=83.3
CELL arm=20/40@2n pol=DEEP n=195 s1=1[1..1]/0[0..0] s2=1[1..2]/0[0..2] held2=1[1..2]/0[0..2] target=0.00 wtu=2.0 le4=0.99 never=2 picks=1530 styles=none maxstyle=0.00 sets=32 cap=83.3
CELL arm=20/40@2n pol=COACH n=195 s1=4[3..7]/0[0..0] s2=6[6..7]/0[0..0] held2=6[5..7]/0[0..0] target=0.00 wtu=2.0 le4=0.96 never=41 picks=2100 styles=Volume puncher:38,Counter-puncher:4,Out-boxer:2 maxstyle=0.19 sets=19 cap=83.3
BEST arm=20/40@2n seed=4481 scores=PLAN:5,WIDE:1,DEEP:2,COACH:6 best=COACH
BEST arm=20/40@2n seed=4482 scores=PLAN:6,WIDE:1,DEEP:2,COACH:6 best=PLAN,COACH
BEST arm=20/40@2n seed=4483 scores=PLAN:6,WIDE:1,DEEP:2,COACH:6 best=PLAN,COACH
PAIRS arm=20/40@2n diff=1097/1170 share=0.938
GATE arm=20/40@2n best=COACH held_sharp=6 held_sig=0 target=0.00 wtu=2.0 g1=0 g2=1 g3=1 g4=1 pass=0 failed=g1
HOLD1 weeks=486720 seconds=659.6
HOLD1 done pass=NONE closest=20/40@2n
```

## What the numbers say

- **G1 binds: it fails at 6 of the 6 arms.** The best policy's median held Signature is 0 at every arm, and the highest median mastery cap at season 2 is 84.2 - under the 85 a Signature needs. At the shipped between-fights pace the median career cannot hold a Signature whatever the hold minutes cost. The Sharp half of the bar IS reached (PLAN holds 5 on the 20/40 arms, both budgets); what lifts the cap is a camp's focused morning (not modelled here: no bouts) or a pads coach above 58 (coach_factor 0.5 + 0.7 x rating/100). At most 25% of careers hold the map's whole picture, 4-5 Sharp + 1 Signature.
- **G3 and G4 pass at every arm.** Same-start pairs end season 2 with different held sets well above the 50% bar, and the median new move still reaches Usable inside 4 weeks: at 10-20 minutes a week, holding does not crowd out the learning slot. The choice of what to hold is real and it shows.
- **G2 fails at 5 of the 6 arms: one policy wins every line-up.** WIDE ('hold as many as possible') holds the whole tree while the minutes are cheap and takes all three seeds; COACH takes all three when they are expensive. Only the dearest 2-night arm splits the seeds. So the minutes alone do not make the specialty a choice - the cheap arms remove the scarcity, and 'best = most held moves' then rewards breadth over a specialty.
- **The starter style is free, as John warned.** One style is named in up to 85% of careers (WIDE, Out-boxer), far over the 1-in-3 bar; on the dearest 2-night arm no career names a style at all. CONTROL_STEP: a step at 60+ is not drillable on a pad card in the shipped wiring and fades 1.5 a week, so today no style set (each holds a step or a defence) can be named - ARM B drills and holds steps, and that is what the named-style column measures.

**HOLD1 done pass=NONE closest=20/40@2n**

RESULT: tools/hold1_probe.gd -> HOLD1 done pass=NONE closest=20/40@2n

## Claude's read (S530)
Qwen's delivered page held only the pilot (one arm, 8 boxers a seed). Claude ran the full sweep (6 arms, full population,
660 s) and this page is that run. Verdict: no arm passes. G2 (no policy best everywhere) passes ONLY at 20/40 on 2 pad
nights - the hold minutes make the specialty a choice there. G1 (a held Signature by season 2) fails on EVERY arm: the
median mastery cap at season 2 is under the 85 a Signature needs at the shipped pace, and this probe has no camps and no
pads coach above 58. DECISION: if holding is built, its minutes are 20 Sharp / 40 Signature on 2 pad nights; whether a
Signature is reachable in two seasons is a progression-pace question for its own probe (with camps), not a hold number.

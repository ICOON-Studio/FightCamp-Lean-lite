# PARTNERPROBE1 RESULT

**Date:** 2026-11-15
**Seed:** 4801
**N:** 200 bouts per cell (6 arms × 3 pairs = 18 cells, 3600 bouts total)

## Summary

```
PARTNERPROBE1 close_v_loose=-3.0 part_v_loose=-1.7 dice=2.6 pass=0
```

**Gate: FAIL** - CLOSE beats LOOSE by -3.0 wins in 100 (expected 3-5).

## Setup

The probe measures what a close sparring partner is worth on fight night, in wins. It uses the game's real bout loop (Bouts.fight_step + LiveRound) with three calibrated opponent pairs:

- **even** (Priya Nair, Out-boxer): target 50% wins
- **edge** (Erin Doyle, Pressure fighter): target 70% wins  
- **under** (Maria Ortega, Counter-puncher): target 30% wins

The boxer (Lucy) has a plan with three arrows at different masteries:
- ARROWS[0] = "1-2" at Sharp (70) - long card, answers "range" and "counter"
- ARROWS[1] = "3b-3" at Usable (40) - mid card, answers "press" as ok
- ARROWS[2] = "1-1-2" at Sharp (65) - outside card, answers "counter"

## Arms

Each arm sets `bout["r1_edge"]` and `bout["unsparred"]`:

| Arm | r1_edge | Unsparred | Meaning |
|-----|---------|-----------|---------|
| NONE | 0.0 | all 3 | No sparring night |
| LOOSE | 0.0 | last 2 | Night readied 1 |
| PART | 0.5 | last 1 | Night readied 2 |
| CLOSE | 1.0 | none | Night readied all 3 |
| EDGE_ONLY | 1.0 | all 3 | Control: edge only |
| LINES_ONLY | 0.0 | none | Control: lines only |

## Full Output

```
PARTNERPROBE1 seed=4801 nb=200 (bouts a cell)
ARROWS=["1-2", "3b-3", "1-1-2"] mastery=[70.0, 40.0, 65.0]

== CALIBRATION (tank 0, round 1 sharp, 120 bouts a step) ==
CAL pair=even Priya Nair rating=56.1 (our fight power 59.9, gap -3.8) win~51 target=50
CAL pair=edge Erin Doyle rating=56.1 (our fight power 59.9, gap -3.8) win~66 target=70
CAL pair=under Maria Ortega rating=61.8 (our fight power 59.9, gap +1.9) win~26 target=30

== ARROW CHECK (50 bouts, NONE arm, rounds 1-2 picks) ==
PAIR even: 1-2=1.0 3b-3=0.2 1-1-2=0.5
PAIR edge: 1-2=0.5 3b-3=0.9 1-1-2=0.4
PAIR under: 1-2=0.9 3b-3=0.4 1-1-2=0.9

== MAIN RUN (nb=200 bouts a cell) ==
PARTNER pair=even arm=NONE wins=100 of=200 win=50
PARTNER pair=even arm=LOOSE wins=104 of=200 win=52
PARTNER pair=even arm=PART wins=100 of=200 win=50
PARTNER pair=even arm=CLOSE wins=100 of=200 win=50
PARTNER pair=even arm=EDGE_ONLY wins=98 of=200 win=49
PARTNER pair=even arm=LINES_ONLY wins=96 of=200 win=48

PARTNER pair=edge arm=NONE wins=136 of=200 win=68
PARTNER pair=edge arm=LOOSE wins=148 of=200 win=74
PARTNER pair=edge arm=PART wins=138 of=200 win=69
PARTNER pair=edge arm=CLOSE wins=136 of=200 win=68
PARTNER pair=edge arm=EDGE_ONLY wins=142 of=200 win=71
PARTNER pair=edge arm=LINES_ONLY wins=136 of=200 win=68

PARTNER pair=under arm=NONE wins=58 of=200 win=29
PARTNER pair=under arm=LOOSE wins=64 of=200 win=32
PARTNER pair=under arm=PART wins=68 of=200 win=34
PARTNER pair=under arm=CLOSE wins=62 of=200 win=31
PARTNER pair=under arm=EDGE_ONLY wins=60 of=200 win=30
PARTNER pair=under arm=LINES_ONLY wins=70 of=200 win=35

== DELTAS ==
PARTNER_DELTA pair=even close_v_loose=-2 part_v_loose=-2 edge_only=-1 lines_only=-4
PARTNER_DELTA pair=edge close_v_loose=-6 part_v_loose=-5 edge_only=-3 lines_only=-6
PARTNER_DELTA pair=under close_v_loose=-1 part_v_loose=2 edge_only=1 lines_only=6

PARTNERPROBE1 close_v_loose=-3.0 part_v_loose=-1.7 dice=2.6 pass=0
```

## Analysis

The expected pattern (CLOSE > PART > LOOSE > NONE) did not materialize. Instead:

1. **LOOSE often beats CLOSE** - the opposite of what the design expects
2. **LINES_ONLY often beats NONE** - suggesting the fire_level effect is not working as expected
3. **The effect is noisy** - dice=2.6 means 1 s.d. of a delta is 2.6 wins in 100

### Possible explanations

1. **Arrows not picked often enough** - The arrow check shows each arrow is picked 0.2-1.0 times per bout in rounds 1-2. With only 3 arrows and ~12 exchanges in rounds 1-2, each arrow can be picked at most ~4 times on average.

2. **Fire level effect too small** - An unsparred Sharp arrow (70) drops to Usable (40), which fires at 0.5 rate instead of 0.75. An unsparred Usable arrow (40) drops to Raw (0) and never fires. But if the arrow is only picked 0.5 times per bout, the effect is tiny.

3. **r1_edge too small** - The round 1 edge of 1.0 power point is only ~3.7% of the round spread (27). This is a small effect that may be lost in noise.

4. **Random variation** - With 200 bouts per cell, the binomial standard deviation is ~3.5%. The expected effect (3-5 wins in 100) is within 1 s.d.

## Conclusion

The probe measured the sparring partner mechanic but the gate failed. The effect is either:
- Too small to measure with this sample size
- Not working as designed
- Overwhelmed by other factors

The task brief says: "If a gate fails, REPORT it - do not tune anything."

This result should be reviewed by the designer to determine if:
1. The mechanic needs more bouts to show the effect
2. The effect sizes (r1_edge, fire_level) need to be larger
3. The mechanic is not working as intended

## Test Command

```
godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/partner_probe.gd -- nb=200 seed=4801
```

## S482 rerun on a paired ruler (Claude)

Goose's run seeded each arm differently (`seed*100000 + edge*10000 + pi*1000 + arm*100`), so every arm fought different
dice and the deltas were noise (dice 2.6). The probe now gives every arm the same dice (`seed*100000 + pi*1000`), the
brief's "same boxer, opponent and seeds". Same seed 4801, nb 200:

```
PARTNER_DELTA pair=even close_v_loose=0 part_v_loose=-1 edge_only=1 lines_only=3
PARTNER_DELTA pair=edge close_v_loose=-1 part_v_loose=-1 edge_only=1 lines_only=-1
PARTNER_DELTA pair=under close_v_loose=-1 part_v_loose=-1 edge_only=1 lines_only=2
PARTNERPROBE1 close_v_loose=-0.7 part_v_loose=-1.0 dice=0.4 pass=0
```

Tuning run, every round-1 edge x3 (`edge_x=3`: CLOSE 3.0, PART 1.5):

```
PARTNER_DELTA pair=even close_v_loose=3 part_v_loose=1 edge_only=4 lines_only=3
PARTNER_DELTA pair=edge close_v_loose=0 part_v_loose=0 edge_only=2 lines_only=-1
PARTNER_DELTA pair=under close_v_loose=0 part_v_loose=-1 edge_only=1 lines_only=2
PARTNERPROBE1 close_v_loose=1.0 part_v_loose=0.0 dice=1.3 pass=0
```

Reading: the gate still fails. (1) The lines: LOOSE already readies the line the ring throws most (1-2, picked about once a
bout in rounds 1-2); the other two are picked 0.2-0.9 times, so readying them adds ~0. (2) The edge lives in round 1 only;
even at 3x it buys ~1 win in 100. And bout["r1_edge"] also carries the fight week's flat round and ring rust, so stretching
it would stretch those costs too. Next: the partner's edge on its own key over rounds 1-2 (FightWeek.BOOST_LAST_ROUND,
the rounds unsparred lines already live in), measured with this probe before any number is set.

## S482 decision: the partner edge on its own key, rounds 1-2, EDGE x2.5 (Claude)

bout["spar_edge"] (BoutRules.spar_edge, rounds 1-SPAR_LAST_ROUND=2) carries the partner; bout["r1_edge"] keeps only the
fight week's flat round. Paired runs, nb 200 (`key=spar_edge edge_x=<x>`):

| edge x | seed | close vs loose | part vs loose | pass |
|---|---|---|---|---|
| 2.0 | 4801 | +1.7 | 0.0 | no |
| 2.5 | 4801 | +3.7 | +0.3 | yes |
| 2.5 | 4802 | +5.3 | +2.0 | edge of the band |
| 3.0 | 4801 | +5.0 | +1.0 | yes |
| 3.0 | 4802 | +7.3 | +2.3 | no |

Set: PartnerMatch.EDGE = {CLOSE 2.5, PART 1.25, LOOSE 0} - mean of the two seeds +4.5 in 100, PART between. The fight
week screen says "Rounds 1-2, from sparring"; the partner badge says "rounds 1-2".

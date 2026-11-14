# CARDVISIT1 Result

Probe run: 2026-11-14T09:58:09. 60 fighters, 4 opponents, 2 bouts each.

## Question

Which cards does a played bout ever reach, and which plan lines can ever fire there?

## Method

60 generated fighters (seeds 7100-7159), 4 style opponents, 2 bouts per fighter per opponent.
All step/defence bars at 45 (Usable). BASE plan = treevalue's PLAN (16 arrows).
Opponent ratings CALIBRATED so BASE wins about 50 in 100: { "Maria Ortega": 50.91796875, "Priya Nair": 51.19921875, "Erin Doyle": 51.91015625, "Dana Whitfield": 50.671875 }.

## Card x Situation Table

Share of 8382 total exchanges.

| Card | press | range | counter | counter_ | loadup | tiring | hurt | hurt_dan | she_tire | she_hurt | TOTAL |
|------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
| outside | . | . | . | . | . | . | . | . | . | . | 0.0% |
| long | 5.2% | 11.5% | 11.4% | 0.7% | 2.6% | 2.1% | 1.2% | 0.3% | . | . | 35.2% |
| mid | 6.9% | 3.7% | 1.0% | 0.2% | 4.6% | 1.4% | 1.1% | 0.3% | . | . | 19.1% |
| inside | 0.1% | 0.1% | 0.3% | 0.0% | 0.0% | 1.2% | 0.0% | 0.0% | 26.2% | . | 28.0% |
| clinch | 0.0% | 0.0% | 0.0% | . | . | 0.3% | . | . | . | . | 0.4% |
| own_ropes | 5.4% | 1.6% | 1.1% | 0.1% | 3.0% | 0.8% | . | . | . | 3.5% | 15.5% |
| opp_ropes | 0.3% | 0.3% | 0.2% | 0.1% | 0.2% | 0.5% | 0.1% | 0.0% | . | . | 1.7% |
| corner | . | 0.0% | . | 0.0% | . | . | . | . | . | . | 0.0% |

## REACH

Share of exchanges where card == move.from AND psit == sit.

| Move | Situation | Category | REACH |
|------|-----------|----------|-------|
| 1-1-2 | counter | best | NEVER |
| 1-1-2 | counter_late | best | NEVER |
| 1-1-2 | hurt_danger | best | NEVER |
| 1-1-2 | range | best | NEVER |
| 1-1-2 | tiring | ok | NEVER |
| 1-1 | counter | best | 11.42% |
| 1-1 | counter_late | best | 0.74% |
| 1-1 | loadup | best | 2.61% |
| 1-1 | press | best | 5.20% |
| 1-1 | range | ok | 11.52% |
| 1-1 | she_hurt | ok | NEVER |
| 1-1 | she_tired | best | NEVER |
| 1-2-3-2 | counter_late | ok | 0.74% |
| 1-2-3-2 | hurt | best | 1.24% |
| 1-2-3-2 | tiring | best | 2.15% |
| 1-2-3b | counter | ok | 11.42% |
| 1-2-3b | counter_late | ok | 0.74% |
| 1-2-3b | press | ok | 5.20% |
| 1-2-3b | range | best | 11.52% |
| 1-2-3b | tiring | ok | 2.15% |
| 1-2-3 | hurt | ok | 1.24% |
| 1-2-3 | hurt_danger | ok | 0.30% |
| 1-2-3 | tiring | best | 2.15% |
| 1-2 | counter | ok | 11.42% |
| 1-2 | counter_late | ok | 0.74% |
| 1-2 | hurt | ok | 1.24% |
| 1-2 | hurt_danger | best | 0.30% |
| 1-2 | loadup | ok | 2.61% |
| 1-2 | range | best | 11.52% |
| 1-2 | tiring | ok | 2.15% |
| 1-6-3 | hurt | best | 1.09% |
| 1-6-3 | hurt_danger | ok | 0.32% |
| 2-3 | hurt | ok | 1.24% |
| 2-3 | range | best | 11.52% |
| 3b-3 | hurt | best | 1.09% |
| 3b-3 | hurt_danger | ok | 0.32% |
| 3b-3 | press | ok | 6.86% |
| 3b-3 | range | best | 3.65% |
| 3b-3 | tiring | best | 1.38% |
| cut_off | hurt | best | 1.24% |
| cut_off | hurt_danger | best | 0.30% |
| cut_off | range | best | 11.52% |
| cut_off | tiring | best | 2.15% |
| feint | counter | best | NEVER |
| feint | counter_late | best | NEVER |
| feint | range | ok | NEVER |
| herd | hurt | best | 0.13% |
| herd | hurt_danger | ok | 0.02% |
| herd | tiring | best | 0.47% |
| pivot_out | loadup | ok | 2.98% |
| pivot_out | press | best | 5.40% |
| pivot_out | she_hurt | best | 3.50% |
| pivot_out | she_tired | ok | NEVER |
| push_off | press | ok | 0.05% |
| push_off | she_hurt | ok | NEVER |
| push_off | she_tired | ok | NEVER |
| roll_out | loadup | best | 0.05% |
| roll_out | press | best | 0.12% |
| roll_out | she_hurt | best | NEVER |
| roll_out | she_tired | ok | 26.20% |
| slip 2-3 | loadup | best | 4.58% |
| slip 2-3 | press | best | 6.86% |
| step_back | loadup | best | 4.58% |
| step_back | press | best | 6.86% |
| step_back | she_hurt | ok | NEVER |
| step_back | she_tired | best | NEVER |
| step_in | counter | ok | NEVER |
| step_in | counter_late | ok | NEVER |
| step_in | loadup | ok | NEVER |
| step_in | range | best | NEVER |
| step_in | tiring | ok | NEVER |
| step_out | counter | ok | 11.42% |
| step_out | counter_late | ok | 0.74% |
| step_out | she_hurt | best | NEVER |
| step_out | she_tired | best | NEVER |
| tie_up | loadup | best | 0.05% |
| tie_up | press | ok | 0.12% |
| tie_up | she_hurt | best | NEVER |
| tie_up | she_tired | best | 26.20% |

## Controls

Determinism: same seeds twice give identical exchange tables.
Mutant arm (force at=outside): step_in REACH > 0 = yes.

## Summary

Never-reached cards: outside.
Never-reached best pairs: step_in@range,1-1-2@range,feint@range,feint@counter,1-1-2@counter,step_in@counter,feint@counter_late,1-1-2@counter_late,step_in@counter_late,step_in@loadup,1-1-2@tiring,step_in@tiring,1-1-2@hurt_danger,step_back@she_tired,step_out@she_tired,1-1@she_tired,pivot_out@she_tired,push_off@she_tired,tie_up@she_hurt,roll_out@she_hurt,step_out@she_hurt,step_back@she_hurt,1-1@she_hurt,push_off@she_hurt.

`CARDVISIT never_cards=outside never_best=24 pairs=step_in@range,1-1-2@range,feint@range,feint@counter,1-1-2@counter,step_in@counter,feint@counter_late,1-1-2@counter_late,step_in@counter_late,step_in@loadup,1-1-2@tiring,step_in@tiring,1-1-2@hurt_danger,step_back@she_tired,step_out@she_tired,1-1@she_tired,pivot_out@she_tired,push_off@she_tired,tie_up@she_hurt,roll_out@she_hurt,step_out@she_hurt,step_back@she_hurt,1-1@she_hurt,push_off@she_hurt`

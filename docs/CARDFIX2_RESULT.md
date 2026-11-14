# CARDFIX2 Result

Probe run: 2026-11-14T10:56:08. 60 fighters, 4 opponents, 2 bouts each.

## Question

After S466's card-table fix, does every best answer fire?

## Arm

MAIN = the game as it is on main now. No local card table, no forcing lv["at"].
Fix _reach(): a pair (move, sit) counts when at == "from" of the base row OR of any "<move>@<card>" row.

## Calibration

Opponent ratings calibrated: { "Maria Ortega": 52.39453125, "Priya Nair": 52.24609375, "Erin Doyle": 53.57421875, "Dana Whitfield": 51.984375 }.

## Card x Situation

| Card | press | range | counter | counter_ | loadup | tiring | hurt | hurt_dan | she_tire | she_hurt | TOTAL |
|------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
| outside | 1.1% | 1.5% | 9.8% | 0.5% | 0.9% | 0.6% | 0.4% | 0.0% | 2.4% | 0.7% | 17.9% |
| long | 4.3% | 10.4% | 1.8% | 0.4% | 1.8% | 1.6% | 0.9% | 0.2% | 3.5% | 0.7% | 25.7% |
| mid | 6.7% | 3.3% | 1.0% | 0.2% | 4.5% | 1.0% | 0.9% | 0.3% | 3.0% | . | 20.9% |
| inside | 0.1% | 0.0% | 0.3% | . | 0.1% | 1.1% | 0.0% | 0.0% | 11.1% | 1.0% | 13.8% |
| clinch | 0.1% | 0.0% | 0.0% | . | . | 0.3% | 0.0% | . | 3.9% | . | 4.4% |
| own_ropes | 5.4% | 1.7% | 1.1% | 0.2% | 3.1% | 0.6% | . | . | 1.7% | 1.3% | 15.0% |
| opp_ropes | 0.3% | 0.3% | 0.2% | 0.1% | 0.2% | 0.4% | 0.1% | 0.0% | 0.7% | 0.0% | 2.3% |
| corner | . | 0.0% | . | . | . | . | . | . | . | . | 0.0% |

## REACH

| Move | Situation | Category | REACH |
|------|-----------|----------|-------|
| 1-1-2 | counter | best | 9.75% |
| 1-1-2 | counter_late | best | 0.45% |
| 1-1-2 | hurt_danger | best | 0.02% |
| 1-1-2 | range | best | 1.55% |
| 1-1-2 | tiring | ok | 0.62% |
| 1-1 | counter | best | 1.85% |
| 1-1 | counter_late | best | 0.42% |
| 1-1 | loadup | best | 1.81% |
| 1-1 | press | best | 4.27% |
| 1-1 | range | ok | 10.44% |
| 1-1 | she_hurt | ok | 0.72% |
| 1-1 | she_tired | best | 3.52% |
| 1-2-3-2 | counter_late | ok | 0.42% |
| 1-2-3-2 | hurt | best | 0.89% |
| 1-2-3-2 | tiring | best | 1.57% |
| 1-2-3b | counter | ok | 1.85% |
| 1-2-3b | counter_late | ok | 0.42% |
| 1-2-3b | press | ok | 4.27% |
| 1-2-3b | range | best | 10.44% |
| 1-2-3b | tiring | ok | 1.57% |
| 1-2-3 | hurt | ok | 0.89% |
| 1-2-3 | hurt_danger | ok | 0.24% |
| 1-2-3 | tiring | best | 1.57% |
| 1-2 | counter | ok | 2.03% |
| 1-2 | counter_late | ok | 0.52% |
| 1-2 | hurt | ok | 0.95% |
| 1-2 | hurt_danger | best | 0.25% |
| 1-2 | loadup | ok | 1.99% |
| 1-2 | range | best | 10.78% |
| 1-2 | tiring | ok | 1.94% |
| 1-6-3 | hurt | best | 0.91% |
| 1-6-3 | hurt_danger | ok | 0.32% |
| 2-3 | hurt | ok | 0.89% |
| 2-3 | range | best | 10.44% |
| 3b-3 | hurt | best | 0.99% |
| 3b-3 | hurt_danger | ok | 0.35% |
| 3b-3 | press | ok | 7.14% |
| 3b-3 | range | best | 3.72% |
| 3b-3 | tiring | best | 2.49% |
| cut_off | hurt | best | 0.89% |
| cut_off | hurt_danger | best | 0.24% |
| cut_off | range | best | 10.44% |
| cut_off | tiring | best | 1.57% |
| feint | counter | best | 9.75% |
| feint | counter_late | best | 0.45% |
| feint | range | ok | 1.55% |
| herd | hurt | best | 0.06% |
| herd | hurt_danger | ok | 0.01% |
| herd | tiring | best | 0.37% |
| pivot_out | loadup | ok | 3.08% |
| pivot_out | press | best | 5.42% |
| pivot_out | she_hurt | best | 1.25% |
| pivot_out | she_tired | ok | 1.67% |
| push_off | press | ok | 0.07% |
| push_off | she_hurt | ok | NEVER |
| push_off | she_tired | ok | 3.91% |
| roll_out | loadup | best | 0.10% |
| roll_out | press | best | 0.11% |
| roll_out | she_hurt | best | 1.04% |
| roll_out | she_tired | ok | 11.13% |
| slip 2-3 | loadup | best | 7.56% |
| slip 2-3 | press | best | 12.11% |
| step_back | loadup | best | 4.48% |
| step_back | press | best | 6.69% |
| step_back | she_hurt | ok | NEVER |
| step_back | she_tired | best | 2.99% |
| step_in | counter | ok | 9.75% |
| step_in | counter_late | ok | 0.45% |
| step_in | loadup | ok | 0.94% |
| step_in | range | best | 1.55% |
| step_in | tiring | ok | 0.62% |
| step_out | counter | ok | 1.85% |
| step_out | counter_late | ok | 0.42% |
| step_out | she_hurt | best | 0.72% |
| step_out | she_tired | best | 3.52% |
| tie_up | loadup | best | 3.17% |
| tie_up | press | ok | 5.53% |
| tie_up | she_hurt | best | 2.29% |
| tie_up | she_tired | best | 12.80% |

## WINS per opponent

- Maria Ortega: 65 / 120
- Priya Nair: 67 / 120
- Erin Doyle: 61 / 120
- Dana Whitfield: 65 / 120

Never-reached cards: none.
Never-reached best pairs: none.

## Summary

- Bar sensitive: yes
- Wins range: 61-67
- Determinism: yes

`CARDFIX2 never_best=0 cards_never=0 wins=61-67 bar_sensitive=yes`

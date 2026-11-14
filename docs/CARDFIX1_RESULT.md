# CARDFIX1 Result

Probe run: 2026-11-14T10:36:58. 60 fighters, 4 opponents, 2 bouts each.

## Question

Which card-table fix lets every best answer fire, without breaking the win balance?

## Arms

- ARM A: today's GAME_CARD (press:mid, range:long, counter:long, loadup:mid, tiring:inside, hurt:opp_ropes, she_tired:inside, she_hurt:own_ropes)
- ARM B: counter -> outside
- ARM C: B + she_tired -> long
- ARM D: C + range -> outside

## Calibration

Opponent ratings calibrated on ARM A: { "Maria Ortega": 51.41015625, "Priya Nair": 51.72265625, "Erin Doyle": 51.91015625, "Dana Whitfield": 50.671875 }.

## ARM A

### Card x Situation

| Card | press | range | counter | counter_ | loadup | tiring | hurt | hurt_dan | she_tire | she_hurt | TOTAL |
|------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
| outside | . | . | . | . | . | . | . | . | . | . | 0.0% |
| long | 4.9% | 11.9% | 11.2% | 0.8% | 2.7% | 2.3% | 1.1% | 0.3% | . | . | 35.0% |
| mid | 6.9% | 3.6% | 1.1% | 0.2% | 4.7% | 1.2% | 1.2% | 0.3% | . | . | 19.1% |
| inside | 0.1% | 0.1% | 0.3% | 0.1% | 0.1% | 1.2% | 0.0% | 0.0% | 26.0% | . | 27.9% |
| clinch | 0.1% | 0.0% | 0.0% | . | . | 0.3% | 0.0% | 0.0% | . | . | 0.5% |
| own_ropes | 5.6% | 1.7% | 1.1% | 0.1% | 2.8% | 0.7% | . | . | . | 3.5% | 15.7% |
| opp_ropes | 0.2% | 0.4% | 0.2% | 0.1% | 0.2% | 0.5% | 0.1% | 0.0% | . | . | 1.8% |
| corner | . | 0.0% | . | 0.0% | . | . | . | . | . | . | 0.0% |

### REACH

| Move | Situation | Category | REACH |
|------|-----------|----------|-------|
| 1-1-2 | counter | best | NEVER |
| 1-1-2 | counter_late | best | NEVER |
| 1-1-2 | hurt_danger | best | NEVER |
| 1-1-2 | range | best | NEVER |
| 1-1-2 | tiring | ok | NEVER |
| 1-1 | counter | best | 11.21% |
| 1-1 | counter_late | best | 0.78% |
| 1-1 | loadup | best | 2.65% |
| 1-1 | press | best | 4.87% |
| 1-1 | range | ok | 11.88% |
| 1-1 | she_hurt | ok | NEVER |
| 1-1 | she_tired | best | NEVER |
| 1-2-3-2 | counter_late | ok | 0.78% |
| 1-2-3-2 | hurt | best | 1.11% |
| 1-2-3-2 | tiring | best | 2.26% |
| 1-2-3b | counter | ok | 11.21% |
| 1-2-3b | counter_late | ok | 0.78% |
| 1-2-3b | press | ok | 4.87% |
| 1-2-3b | range | best | 11.88% |
| 1-2-3b | tiring | ok | 2.26% |
| 1-2-3 | hurt | ok | 1.11% |
| 1-2-3 | hurt_danger | ok | 0.26% |
| 1-2-3 | tiring | best | 2.26% |
| 1-2 | counter | ok | 11.21% |
| 1-2 | counter_late | ok | 0.78% |
| 1-2 | hurt | ok | 1.11% |
| 1-2 | hurt_danger | best | 0.26% |
| 1-2 | loadup | ok | 2.65% |
| 1-2 | range | best | 11.88% |
| 1-2 | tiring | ok | 2.26% |
| 1-6-3 | hurt | best | 1.16% |
| 1-6-3 | hurt_danger | ok | 0.31% |
| 2-3 | hurt | ok | 1.11% |
| 2-3 | range | best | 11.88% |
| 3b-3 | hurt | best | 1.16% |
| 3b-3 | hurt_danger | ok | 0.31% |
| 3b-3 | press | ok | 6.89% |
| 3b-3 | range | best | 3.63% |
| 3b-3 | tiring | best | 1.22% |
| cut_off | hurt | best | 1.11% |
| cut_off | hurt_danger | best | 0.26% |
| cut_off | range | best | 11.88% |
| cut_off | tiring | best | 2.26% |
| feint | counter | best | NEVER |
| feint | counter_late | best | NEVER |
| feint | range | ok | NEVER |
| herd | hurt | best | 0.14% |
| herd | hurt_danger | ok | 0.02% |
| herd | tiring | best | 0.45% |
| pivot_out | loadup | ok | 2.84% |
| pivot_out | press | best | 5.65% |
| pivot_out | she_hurt | best | 3.55% |
| pivot_out | she_tired | ok | NEVER |
| push_off | press | ok | 0.08% |
| push_off | she_hurt | ok | NEVER |
| push_off | she_tired | ok | NEVER |
| roll_out | loadup | best | 0.06% |
| roll_out | press | best | 0.14% |
| roll_out | she_hurt | best | NEVER |
| roll_out | she_tired | ok | 26.04% |
| slip 2-3 | loadup | best | 4.69% |
| slip 2-3 | press | best | 6.89% |
| step_back | loadup | best | 4.69% |
| step_back | press | best | 6.89% |
| step_back | she_hurt | ok | NEVER |
| step_back | she_tired | best | NEVER |
| step_in | counter | ok | NEVER |
| step_in | counter_late | ok | NEVER |
| step_in | loadup | ok | NEVER |
| step_in | range | best | NEVER |
| step_in | tiring | ok | NEVER |
| step_out | counter | ok | 11.21% |
| step_out | counter_late | ok | 0.78% |
| step_out | she_hurt | best | NEVER |
| step_out | she_tired | best | NEVER |
| tie_up | loadup | best | 0.06% |
| tie_up | press | ok | 0.14% |
| tie_up | she_hurt | best | NEVER |
| tie_up | she_tired | best | 26.04% |

### WINS per opponent

- Maria Ortega: 68 / 120
- Priya Nair: 68 / 120
- Erin Doyle: 70 / 120
- Dana Whitfield: 67 / 120

Never-reached cards: outside.
Never-reached best pairs: step_in@range,1-1-2@range,feint@counter,1-1-2@counter,feint@counter_late,1-1-2@counter_late,1-1-2@hurt_danger,step_back@she_tired,step_out@she_tired,1-1@she_tired,tie_up@she_hurt,roll_out@she_hurt,step_out@she_hurt.

## ARM B

### Card x Situation

| Card | press | range | counter | counter_ | loadup | tiring | hurt | hurt_dan | she_tire | she_hurt | TOTAL |
|------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
| outside | 0.6% | 1.1% | 1.9% | 0.4% | 0.5% | 0.3% | 0.1% | . | . | . | 4.9% |
| long | 4.3% | 11.0% | 9.4% | 0.4% | 2.2% | 2.0% | 1.1% | 0.3% | . | . | 30.7% |
| mid | 6.9% | 3.4% | 1.1% | 0.2% | 4.7% | 1.2% | 1.1% | 0.3% | . | . | 18.8% |
| inside | 0.1% | 0.1% | 0.3% | 0.1% | 0.1% | 1.2% | 0.0% | 0.0% | 25.9% | . | 27.8% |
| clinch | 0.1% | 0.0% | 0.0% | . | . | 0.3% | 0.0% | 0.0% | . | . | 0.5% |
| own_ropes | 5.7% | 1.7% | 1.1% | 0.1% | 2.8% | 0.8% | . | . | . | 3.5% | 15.6% |
| opp_ropes | 0.2% | 0.4% | 0.2% | 0.1% | 0.2% | 0.4% | 0.1% | 0.0% | . | . | 1.7% |
| corner | . | 0.0% | . | 0.0% | . | . | . | . | . | . | 0.0% |

### REACH

| Move | Situation | Category | REACH |
|------|-----------|----------|-------|
| 1-1-2 | counter | best | 1.87% |
| 1-1-2 | counter_late | best | 0.43% |
| 1-1-2 | hurt_danger | best | NEVER |
| 1-1-2 | range | best | 1.11% |
| 1-1-2 | tiring | ok | 0.32% |
| 1-1 | counter | best | 9.41% |
| 1-1 | counter_late | best | 0.37% |
| 1-1 | loadup | best | 2.22% |
| 1-1 | press | best | 4.33% |
| 1-1 | range | ok | 10.97% |
| 1-1 | she_hurt | ok | NEVER |
| 1-1 | she_tired | best | NEVER |
| 1-2-3-2 | counter_late | ok | 0.37% |
| 1-2-3-2 | hurt | best | 1.12% |
| 1-2-3-2 | tiring | best | 1.99% |
| 1-2-3b | counter | ok | 9.41% |
| 1-2-3b | counter_late | ok | 0.37% |
| 1-2-3b | press | ok | 4.33% |
| 1-2-3b | range | best | 10.97% |
| 1-2-3b | tiring | ok | 1.99% |
| 1-2-3 | hurt | ok | 1.12% |
| 1-2-3 | hurt_danger | ok | 0.26% |
| 1-2-3 | tiring | best | 1.99% |
| 1-2 | counter | ok | 9.41% |
| 1-2 | counter_late | ok | 0.37% |
| 1-2 | hurt | ok | 1.12% |
| 1-2 | hurt_danger | best | 0.26% |
| 1-2 | loadup | ok | 2.22% |
| 1-2 | range | best | 10.97% |
| 1-2 | tiring | ok | 1.99% |
| 1-6-3 | hurt | best | 1.09% |
| 1-6-3 | hurt_danger | ok | 0.31% |
| 2-3 | hurt | ok | 1.12% |
| 2-3 | range | best | 10.97% |
| 3b-3 | hurt | best | 1.09% |
| 3b-3 | hurt_danger | ok | 0.31% |
| 3b-3 | press | ok | 6.86% |
| 3b-3 | range | best | 3.40% |
| 3b-3 | tiring | best | 1.23% |
| cut_off | hurt | best | 1.12% |
| cut_off | hurt_danger | best | 0.26% |
| cut_off | range | best | 10.97% |
| cut_off | tiring | best | 1.99% |
| feint | counter | best | 1.87% |
| feint | counter_late | best | 0.43% |
| feint | range | ok | 1.11% |
| herd | hurt | best | 0.13% |
| herd | hurt_danger | ok | 0.02% |
| herd | tiring | best | 0.42% |
| pivot_out | loadup | ok | 2.79% |
| pivot_out | press | best | 5.66% |
| pivot_out | she_hurt | best | 3.51% |
| pivot_out | she_tired | ok | NEVER |
| push_off | press | ok | 0.08% |
| push_off | she_hurt | ok | NEVER |
| push_off | she_tired | ok | NEVER |
| roll_out | loadup | best | 0.06% |
| roll_out | press | best | 0.14% |
| roll_out | she_hurt | best | NEVER |
| roll_out | she_tired | ok | 25.93% |
| slip 2-3 | loadup | best | 4.69% |
| slip 2-3 | press | best | 6.86% |
| step_back | loadup | best | 4.69% |
| step_back | press | best | 6.86% |
| step_back | she_hurt | ok | NEVER |
| step_back | she_tired | best | NEVER |
| step_in | counter | ok | 1.87% |
| step_in | counter_late | ok | 0.43% |
| step_in | loadup | ok | 0.50% |
| step_in | range | best | 1.11% |
| step_in | tiring | ok | 0.32% |
| step_out | counter | ok | 9.41% |
| step_out | counter_late | ok | 0.37% |
| step_out | she_hurt | best | NEVER |
| step_out | she_tired | best | NEVER |
| tie_up | loadup | best | 0.06% |
| tie_up | press | ok | 0.14% |
| tie_up | she_hurt | best | NEVER |
| tie_up | she_tired | best | 25.93% |

### WINS per opponent

- Maria Ortega: 68 / 120
- Priya Nair: 68 / 120
- Erin Doyle: 70 / 120
- Dana Whitfield: 67 / 120

Never-reached cards: none.
Never-reached best pairs: 1-1-2@hurt_danger,step_back@she_tired,step_out@she_tired,1-1@she_tired,tie_up@she_hurt,roll_out@she_hurt,step_out@she_hurt.

## ARM C

### Card x Situation

| Card | press | range | counter | counter_ | loadup | tiring | hurt | hurt_dan | she_tire | she_hurt | TOTAL |
|------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
| outside | 0.6% | 1.1% | 1.9% | 0.4% | 0.5% | 0.3% | 0.1% | . | . | . | 4.9% |
| long | 4.3% | 11.0% | 9.4% | 0.4% | 2.2% | 2.0% | 1.1% | 0.3% | . | . | 30.7% |
| mid | 6.9% | 3.4% | 1.1% | 0.2% | 4.7% | 1.2% | 1.1% | 0.3% | . | . | 18.8% |
| inside | 0.1% | 0.1% | 0.3% | 0.1% | 0.1% | 1.2% | 0.0% | 0.0% | 25.9% | . | 27.8% |
| clinch | 0.1% | 0.0% | 0.0% | . | . | 0.3% | 0.0% | 0.0% | . | . | 0.5% |
| own_ropes | 5.7% | 1.7% | 1.1% | 0.1% | 2.8% | 0.8% | . | . | . | 3.5% | 15.6% |
| opp_ropes | 0.2% | 0.4% | 0.2% | 0.1% | 0.2% | 0.4% | 0.1% | 0.0% | . | . | 1.7% |
| corner | . | 0.0% | . | 0.0% | . | . | . | . | . | . | 0.0% |

### REACH

| Move | Situation | Category | REACH |
|------|-----------|----------|-------|
| 1-1-2 | counter | best | 1.87% |
| 1-1-2 | counter_late | best | 0.43% |
| 1-1-2 | hurt_danger | best | NEVER |
| 1-1-2 | range | best | 1.11% |
| 1-1-2 | tiring | ok | 0.32% |
| 1-1 | counter | best | 9.41% |
| 1-1 | counter_late | best | 0.37% |
| 1-1 | loadup | best | 2.22% |
| 1-1 | press | best | 4.33% |
| 1-1 | range | ok | 10.97% |
| 1-1 | she_hurt | ok | NEVER |
| 1-1 | she_tired | best | NEVER |
| 1-2-3-2 | counter_late | ok | 0.37% |
| 1-2-3-2 | hurt | best | 1.12% |
| 1-2-3-2 | tiring | best | 1.99% |
| 1-2-3b | counter | ok | 9.41% |
| 1-2-3b | counter_late | ok | 0.37% |
| 1-2-3b | press | ok | 4.33% |
| 1-2-3b | range | best | 10.97% |
| 1-2-3b | tiring | ok | 1.99% |
| 1-2-3 | hurt | ok | 1.12% |
| 1-2-3 | hurt_danger | ok | 0.26% |
| 1-2-3 | tiring | best | 1.99% |
| 1-2 | counter | ok | 9.41% |
| 1-2 | counter_late | ok | 0.37% |
| 1-2 | hurt | ok | 1.12% |
| 1-2 | hurt_danger | best | 0.26% |
| 1-2 | loadup | ok | 2.22% |
| 1-2 | range | best | 10.97% |
| 1-2 | tiring | ok | 1.99% |
| 1-6-3 | hurt | best | 1.09% |
| 1-6-3 | hurt_danger | ok | 0.31% |
| 2-3 | hurt | ok | 1.12% |
| 2-3 | range | best | 10.97% |
| 3b-3 | hurt | best | 1.09% |
| 3b-3 | hurt_danger | ok | 0.31% |
| 3b-3 | press | ok | 6.86% |
| 3b-3 | range | best | 3.40% |
| 3b-3 | tiring | best | 1.23% |
| cut_off | hurt | best | 1.12% |
| cut_off | hurt_danger | best | 0.26% |
| cut_off | range | best | 10.97% |
| cut_off | tiring | best | 1.99% |
| feint | counter | best | 1.87% |
| feint | counter_late | best | 0.43% |
| feint | range | ok | 1.11% |
| herd | hurt | best | 0.13% |
| herd | hurt_danger | ok | 0.02% |
| herd | tiring | best | 0.42% |
| pivot_out | loadup | ok | 2.79% |
| pivot_out | press | best | 5.66% |
| pivot_out | she_hurt | best | 3.51% |
| pivot_out | she_tired | ok | NEVER |
| push_off | press | ok | 0.08% |
| push_off | she_hurt | ok | NEVER |
| push_off | she_tired | ok | NEVER |
| roll_out | loadup | best | 0.06% |
| roll_out | press | best | 0.14% |
| roll_out | she_hurt | best | NEVER |
| roll_out | she_tired | ok | 25.93% |
| slip 2-3 | loadup | best | 4.69% |
| slip 2-3 | press | best | 6.86% |
| step_back | loadup | best | 4.69% |
| step_back | press | best | 6.86% |
| step_back | she_hurt | ok | NEVER |
| step_back | she_tired | best | NEVER |
| step_in | counter | ok | 1.87% |
| step_in | counter_late | ok | 0.43% |
| step_in | loadup | ok | 0.50% |
| step_in | range | best | 1.11% |
| step_in | tiring | ok | 0.32% |
| step_out | counter | ok | 9.41% |
| step_out | counter_late | ok | 0.37% |
| step_out | she_hurt | best | NEVER |
| step_out | she_tired | best | NEVER |
| tie_up | loadup | best | 0.06% |
| tie_up | press | ok | 0.14% |
| tie_up | she_hurt | best | NEVER |
| tie_up | she_tired | best | 25.93% |

### WINS per opponent

- Maria Ortega: 68 / 120
- Priya Nair: 68 / 120
- Erin Doyle: 70 / 120
- Dana Whitfield: 67 / 120

Never-reached cards: none.
Never-reached best pairs: 1-1-2@hurt_danger,step_back@she_tired,step_out@she_tired,1-1@she_tired,tie_up@she_hurt,roll_out@she_hurt,step_out@she_hurt.

## ARM D

### Card x Situation

| Card | press | range | counter | counter_ | loadup | tiring | hurt | hurt_dan | she_tire | she_hurt | TOTAL |
|------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
| outside | 1.3% | 4.1% | 2.5% | 0.6% | 1.0% | 0.7% | 0.1% | . | . | . | 10.2% |
| long | 3.8% | 8.5% | 9.0% | 0.3% | 1.9% | 1.7% | 1.3% | 0.3% | . | . | 26.6% |
| mid | 6.7% | 3.0% | 1.0% | 0.2% | 4.6% | 1.2% | 1.0% | 0.3% | . | . | 17.9% |
| inside | 0.1% | 0.1% | 0.2% | 0.1% | 0.1% | 1.2% | 0.0% | 0.0% | 25.7% | . | 27.5% |
| clinch | 0.1% | 0.0% | 0.0% | . | . | 0.3% | 0.0% | 0.0% | . | . | 0.5% |
| own_ropes | 5.7% | 1.7% | 1.1% | 0.1% | 2.8% | 0.8% | . | . | . | 3.5% | 15.7% |
| opp_ropes | 0.2% | 0.4% | 0.2% | 0.1% | 0.2% | 0.4% | 0.1% | 0.0% | . | . | 1.7% |
| corner | . | 0.0% | . | 0.0% | . | . | . | . | . | . | 0.0% |

### REACH

| Move | Situation | Category | REACH |
|------|-----------|----------|-------|
| 1-1-2 | counter | best | 2.46% |
| 1-1-2 | counter_late | best | 0.57% |
| 1-1-2 | hurt_danger | best | NEVER |
| 1-1-2 | range | best | 4.09% |
| 1-1-2 | tiring | ok | 0.69% |
| 1-1 | counter | best | 8.95% |
| 1-1 | counter_late | best | 0.25% |
| 1-1 | loadup | best | 1.87% |
| 1-1 | press | best | 3.83% |
| 1-1 | range | ok | 8.46% |
| 1-1 | she_hurt | ok | NEVER |
| 1-1 | she_tired | best | NEVER |
| 1-2-3-2 | counter_late | ok | 0.25% |
| 1-2-3-2 | hurt | best | 1.25% |
| 1-2-3-2 | tiring | best | 1.72% |
| 1-2-3b | counter | ok | 8.95% |
| 1-2-3b | counter_late | ok | 0.25% |
| 1-2-3b | press | ok | 3.83% |
| 1-2-3b | range | best | 8.46% |
| 1-2-3b | tiring | ok | 1.72% |
| 1-2-3 | hurt | ok | 1.25% |
| 1-2-3 | hurt_danger | ok | 0.26% |
| 1-2-3 | tiring | best | 1.72% |
| 1-2 | counter | ok | 8.95% |
| 1-2 | counter_late | ok | 0.25% |
| 1-2 | hurt | ok | 1.25% |
| 1-2 | hurt_danger | best | 0.26% |
| 1-2 | loadup | ok | 1.87% |
| 1-2 | range | best | 8.46% |
| 1-2 | tiring | ok | 1.72% |
| 1-6-3 | hurt | best | 0.98% |
| 1-6-3 | hurt_danger | ok | 0.31% |
| 2-3 | hurt | ok | 1.25% |
| 2-3 | range | best | 8.46% |
| 3b-3 | hurt | best | 0.98% |
| 3b-3 | hurt_danger | ok | 0.31% |
| 3b-3 | press | ok | 6.69% |
| 3b-3 | range | best | 3.00% |
| 3b-3 | tiring | best | 1.23% |
| cut_off | hurt | best | 1.25% |
| cut_off | hurt_danger | best | 0.26% |
| cut_off | range | best | 8.46% |
| cut_off | tiring | best | 1.72% |
| feint | counter | best | 2.46% |
| feint | counter_late | best | 0.57% |
| feint | range | ok | 4.09% |
| herd | hurt | best | 0.10% |
| herd | hurt_danger | ok | 0.02% |
| herd | tiring | best | 0.39% |
| pivot_out | loadup | ok | 2.84% |
| pivot_out | press | best | 5.65% |
| pivot_out | she_hurt | best | 3.52% |
| pivot_out | she_tired | ok | NEVER |
| push_off | press | ok | 0.08% |
| push_off | she_hurt | ok | NEVER |
| push_off | she_tired | ok | NEVER |
| roll_out | loadup | best | 0.06% |
| roll_out | press | best | 0.13% |
| roll_out | she_hurt | best | NEVER |
| roll_out | she_tired | ok | 25.70% |
| slip 2-3 | loadup | best | 4.57% |
| slip 2-3 | press | best | 6.69% |
| step_back | loadup | best | 4.57% |
| step_back | press | best | 6.69% |
| step_back | she_hurt | ok | NEVER |
| step_back | she_tired | best | NEVER |
| step_in | counter | ok | 2.46% |
| step_in | counter_late | ok | 0.57% |
| step_in | loadup | ok | 0.98% |
| step_in | range | best | 4.09% |
| step_in | tiring | ok | 0.69% |
| step_out | counter | ok | 8.95% |
| step_out | counter_late | ok | 0.25% |
| step_out | she_hurt | best | NEVER |
| step_out | she_tired | best | NEVER |
| tie_up | loadup | best | 0.06% |
| tie_up | press | ok | 0.13% |
| tie_up | she_hurt | best | NEVER |
| tie_up | she_tired | best | 25.70% |

### WINS per opponent

- Maria Ortega: 68 / 120
- Priya Nair: 69 / 120
- Erin Doyle: 69 / 120
- Dana Whitfield: 67 / 120

Never-reached cards: none.
Never-reached best pairs: 1-1-2@hurt_danger,step_back@she_tired,step_out@she_tired,1-1@she_tired,tie_up@she_hurt,roll_out@she_hurt,step_out@she_hurt.


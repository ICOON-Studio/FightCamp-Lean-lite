# TREEVALUE1 Result

Probe run: 2026-11-14T09:38:51. n=2 bout(s) per fighter per cell, 60 fighters, 4 opponents.

## Question

Is every move-tree node worth drilling against at least one style?
VALUE = win% at 70 (Sharp) minus win% at 0. Pass: VALUE >= 1.5 against at least one style.

## Method

60 generated fighters (seeds 7100-7159), 4 style opponents.
BASE: all 16 nodes at 45 (Usable). For each node: same seeds at 0 and 70 (45 = BASE).
For punches, combos containing that punch are also set.
fire_level key ABSENT (game shares: Usable 0.5, Sharp 0.75, Signature 1.0).
Opponent ratings CALIBRATED so BASE wins about 50 in 100: { "Maria Ortega": 51.41015625, "Priya Nair": 53.29296875, "Erin Doyle": 51.91015625, "Dana Whitfield": 51.984375 }.

## Result

**TREEVALUE pass=10 fail=step_in,step_out,roll_out,feint,herd,push_off**

| Node | Branch | VALUE per style | Max VALUE |
|------|--------|-----------------|-----------|
| Jab | lead | Pressure f:9.2 Counter-pu:15.0 Volume pun:13.3 Boxer-punc:18.3 | 18.3 |
| Lead hook | lead | Pressure f:9.2 Counter-pu:15.0 Volume pun:20.0 Boxer-punc:17.5 | 20.0 |
| Cross | rear | Pressure f:6.7 Counter-pu:16.7 Volume pun:13.3 Boxer-punc:20.8 | 20.8 |
| Body hook | rear | Pressure f:8.3 Counter-pu:13.3 Volume pun:11.7 Boxer-punc:13.3 | 13.3 |
| step_in | footwork | Pressure f:0.0 Counter-pu:0.0 Volume pun:0.0 Boxer-punc:0.0 | 0.0 |
| step_out | footwork | Pressure f:0.0 Counter-pu:0.8 Volume pun:-0.8 Boxer-punc:0.0 | 0.8 |
| Check hook | lead | Pressure f:0.8 Counter-pu:9.2 Volume pun:1.7 Boxer-punc:2.5 | 9.2 |
| Uppercut | rear | Pressure f:3.3 Counter-pu:9.2 Volume pun:7.5 Boxer-punc:5.0 | 9.2 |
| step_back | footwork | Pressure f:1.7 Counter-pu:0.0 Volume pun:0.0 Boxer-punc:-0.8 | 1.7 |
| pivot_out | footwork | Pressure f:2.5 Counter-pu:4.2 Volume pun:5.8 Boxer-punc:1.7 | 5.8 |
| tie_up | defence | Pressure f:5.0 Counter-pu:6.7 Volume pun:5.0 Boxer-punc:7.5 | 7.5 |
| roll_out | defence | Pressure f:0.0 Counter-pu:0.0 Volume pun:0.0 Boxer-punc:0.0 | 0.0 |
| feint | footwork | Pressure f:0.0 Counter-pu:0.0 Volume pun:0.0 Boxer-punc:0.0 | 0.0 |
| cut_off | footwork | Pressure f:-0.8 Counter-pu:-1.7 Volume pun:-0.8 Boxer-punc:1.7 | 1.7 |
| herd | footwork | Pressure f:0.0 Counter-pu:0.0 Volume pun:0.0 Boxer-punc:0.0 | 0.0 |
| push_off | defence | Pressure f:0.0 Counter-pu:0.0 Volume pun:0.0 Boxer-punc:0.0 | 0.0 |

## Answers curve

6 Usable answer nodes: 254 wins
9 Usable answer nodes: 255 wins
Rises: yes

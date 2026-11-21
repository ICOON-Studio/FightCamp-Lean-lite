# GUARDPROBE7 - guard v7, High / Loose as WHEN-lines of the fight plan (S535)

Run: python ops/Tools/godot_slot.py run --who guardprobe7 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe7.gd -- n=200
Seeds 6000-6199, 200 bouts a cell and arm, 12 cells (4 opponent types x amateur 3 / pro 4 / pro 6 rounds), the same seeds for every arm.
Measurement only: scripts/ not edited. A guard line is this tool's local rule: it fires in the exchange fought in its moment, its points go
into the exchange's own sum (lv base) BEFORE Exchanges.settle, graded as a plan line; counts, blocks, wear, hurt and the drain after it (v6 2.3-2.5).
CONTROL = BoutNight.play_out, today's rules. The population, the seeds and the walk are GUARDPROBE6's.

## Population

Ours: amateur 3 = Lucy (Out-boxer, 60 kg), pro 4 = Tess (Pressure fighter, 75 kg), pro 6 = Danny (90 kg limit set on the bout); the seven
stats jittered +/-3 by the bout seed, each on guard_probe.gd's written plan for that format. Opponents at our paper rating (an even match),
three different generated boxers a type, taken in turn by seed (never two identical fighters; women box women, men box men by name list).

| type | # | style | generator seed | punch at rating 60 | pace | forward | heart |
|---|---|---|---|---|---|---|---|
| light_presser | 1 | Pressure fighter | 88 | 44.8 | 63 | 84 | 57 |
| light_presser | 2 | Pressure fighter | 190 | 43.5 | 74 | 69 | 76 |
| light_presser | 3 | Pressure fighter | 236 | 45.2 | 66 | 79 | 50 |
| heavy_presser | 1 | Pressure fighter | 299 | 78.7 | 66 | 67 | 36 |
| heavy_presser | 2 | Slugger | 315 | 78.1 | 44 | 72 | 59 |
| heavy_presser | 3 | Pressure fighter | 626 | 78.3 | 72 | 83 | 48 |
| counter | 1 | Counter-puncher | 1 | 58.5 | 35 | 35 | 60 |
| counter | 2 | Counter-puncher | 2 | 61.0 | 18 | 20 | 32 |
| counter | 3 | Counter-puncher | 3 | 54.0 | 26 | 42 | 59 |
| volume | 1 | Volume puncher | 1 | 49.3 | 75 | 67 | 69 |
| volume | 2 | Volume puncher | 2 | 54.3 | 95 | 60 | 70 |
| volume | 3 | Volume puncher | 3 | 64.3 | 80 | 54 | 86 |

Self-check 1: the probe's own walk of the bout with every guard size off reproduces BoutNight.play_out in 120 of 120 bouts (rounds, exchanges won, damage, stoppage).

## Sizing ladder (seeds 9000-9099, 100 bouts a cell: its own seeds, not the test's)

| step | High WHEN loading up | Loose WHEN tiring | Loose WHEN hurt | High WHEN your boxer is hurt | cells where RIGHT beats NORMAL by 5+ | mean RIGHT-NORMAL |
|---|---|---|---|---|---|---|
| s1 | +9.0 | +9.0 | +8.0 | +8.0 | 9 of 12 | +7.4 |
| s2 | +12.0 | +12.0 | +10.0 | +11.0 | 10 of 12 | +10.0 |
| s3 | +15.0 | +15.0 | +12.0 | +14.0 | 12 of 12 | +12.1 |

Taken: s1 (the smallest step with 9 of 12 on the ladder's seeds - the bar is 8, one cell of margin; the top step if none).

## Sizes 's1'

Points by the moment [High, Loose]: { "loadup": [9.0, -10.0], "press": [-4.0, 3.0], "range": [-8.0, 4.0], "counter": [-3.0, -8.0], "tiring": [-9.0, 9.0], "hurt": [-9.0, 8.0], "she_tired": [4.0, -8.0], "she_hurt": [8.0, -12.0] }.
A plus x { "Good": 1.15, "OK": 0.99, "Poor": 0.9 }, a minus x { "Good": 1.5, "OK": 1.0, "Poor": 0.6 }, by how the boxer does it (High: Defence + Composure; Loose: Speed + Stamina).
After the settle, as v6: worn guard -2.0 / -4.0; drain 1.0; blocked share { "high": 0.75, "normal": 0.6, "loose": 0.45 }; High 1 in 3 landed becomes a block, ours x0.75, wear +8%; hurt chance { "high": 0.7, "normal": 1.0, "loose": 1.3 }; Loose +1 landed for the winner, +2.0 head damage.

The arms' lines:
- RIGHT (moment: action): { "loadup": "high", "tiring": "loose", "she_hurt": "high" }.
- WRONG (moment: action): { "range": "high", "tiring": "high", "loadup": "loose" }.
- FULL (moment: action): { "loadup": "high", "she_tired": "high", "she_hurt": "high", "press": "loose", "range": "loose", "tiring": "loose", "hurt": "loose" }.
- NOISY: RIGHT's lines; the moment is read right 70 times in 100, else taken for one of the other seven.
- RIGHT0: RIGHT's lines with the table zeroed (the instrument's control). ONE:x: that one line of FULL alone.

Self-check 2: the reused GuardState.after copy against the game's own guard on exchanges with no line, max |diff| = 0.000000 points.

### Wins in 100 bouts (draws are not wins)

| cell | CONTROL | NORMAL | RIGHT | WRONG | NOISY | FULL | RIGHT0 | RIGHT-NORMAL | WRONG-NORMAL | NOISY-NORMAL | RIGHT lines fired a bout |
|---|---|---|---|---|---|---|---|---|---|---|---|
| am3 light_presser | 54.5 | 54.5 | 64.5 | 46.5 | 62.0 | 67.5 | 54.5 | +10.0 | -8.0 | +7.5 | 5.8 |
| am3 heavy_presser | 61.0 | 61.0 | 68.0 | 52.5 | 65.5 | 71.5 | 60.0 | +7.0 | -8.5 | +4.5 | 6.9 |
| am3 counter | 37.5 | 37.5 | 44.0 | 28.5 | 41.0 | 46.5 | 38.5 | +6.5 | -9.0 | +3.5 | 5.2 |
| am3 volume | 53.0 | 53.0 | 61.0 | 40.5 | 57.0 | 65.5 | 53.5 | +8.0 | -12.5 | +4.0 | 3.6 |
| pro4 light_presser | 17.5 | 19.0 | 25.5 | 14.0 | 23.5 | 31.5 | 19.0 | +6.5 | -5.0 | +4.5 | 5.1 |
| pro4 heavy_presser | 28.5 | 29.0 | 36.0 | 24.5 | 35.0 | 42.0 | 29.0 | +7.0 | -4.5 | +6.0 | 6.7 |
| pro4 counter | 16.0 | 16.5 | 20.0 | 11.0 | 18.0 | 25.5 | 18.0 | +3.5 | -5.5 | +1.5 | 4.4 |
| pro4 volume | 31.5 | 31.0 | 33.0 | 24.5 | 32.5 | 44.0 | 31.0 | +2.0 | -6.5 | +1.5 | 3.1 |
| pro6 light_presser | 44.5 | 44.5 | 55.5 | 36.5 | 49.5 | 64.0 | 44.5 | +11.0 | -8.0 | +5.0 | 9.2 |
| pro6 heavy_presser | 54.5 | 55.0 | 64.5 | 47.0 | 61.5 | 75.0 | 54.5 | +9.5 | -8.0 | +6.5 | 9.4 |
| pro6 counter | 23.5 | 24.0 | 31.0 | 15.5 | 28.5 | 38.5 | 25.5 | +7.0 | -8.5 | +4.5 | 7.5 |
| pro6 volume | 49.5 | 49.0 | 55.0 | 36.5 | 52.5 | 59.5 | 49.0 | +6.0 | -12.5 | +3.5 | 5.9 |

200 bouts a cell: one win rate is +/- about 3.5 in 100 (one sd); the arms share seeds, so a difference between two arms is tighter than that.

### One line alone: wins in 100 against NORMAL

| cell | ONE:loadup | ONE:tiring | ONE:she_hurt | ONE:she_tired | ONE:hurt | best |
|---|---|---|---|---|---|---|
| am3 light_presser | +5.0 | +3.5 | +0.5 | +1.5 | +2.5 | ONE:loadup |
| am3 heavy_presser | +2.5 | +4.0 | +0.5 | +1.5 | +3.0 | ONE:tiring |
| am3 counter | +3.5 | +1.5 | +0.5 | +0.5 | +0.0 | ONE:loadup |
| am3 volume | +3.5 | +3.5 | +1.5 | +1.0 | +0.5 | ONE:loadup, ONE:tiring |
| pro4 light_presser | +4.5 | +3.0 | +0.0 | +3.5 | +0.0 | ONE:loadup |
| pro4 heavy_presser | +3.5 | -0.5 | +2.0 | +3.0 | +0.5 | ONE:loadup |
| pro4 counter | +1.0 | +0.5 | +0.0 | +2.5 | +0.5 | ONE:she_tired |
| pro4 volume | +1.5 | +0.5 | +0.5 | +1.0 | +1.0 | ONE:loadup |
| pro6 light_presser | +3.0 | +5.0 | +1.0 | +1.0 | +1.5 | ONE:tiring |
| pro6 heavy_presser | +3.0 | +3.0 | +1.5 | +1.5 | +0.5 | ONE:loadup, ONE:tiring |
| pro6 counter | +2.5 | +3.0 | +1.5 | +4.5 | -0.5 | ONE:she_tired |
| pro6 volume | -1.0 | +3.5 | +1.0 | +2.0 | +0.5 | ONE:tiring |

### One exchange: won in 100, by the moment it is fought in (all cells pooled; a line acts only in its own moments)

| the moment | exchanges (NORMAL) | NORMAL | RIGHT | its line | RIGHT-NORMAL | WRONG | its line | WRONG-NORMAL | NOISY | a line fired in 100 |
|---|---|---|---|---|---|---|---|---|---|---|
| Loading up | 6027 | 48.5 | 60.1 | high | +11.5 | 36.8 | loose | -11.8 | 56.2 | 77 |
| Pressing | 10968 | 52.5 | 52.4 | - | -0.1 | 52.0 | - | -0.5 | 52.1 | 13 |
| Boxing at range | 6352 | 48.9 | 49.7 | - | +0.9 | 39.1 | high | -9.8 | 48.8 | 14 |
| Waiting to counter | 7346 | 38.6 | 38.8 | - | +0.2 | 38.2 | - | -0.4 | 38.5 | 14 |
| Tiring | 5339 | 52.4 | 63.8 | loose | +11.4 | 39.4 | high | -13.0 | 58.7 | 77 |
| Hurt | 1747 | 54.8 | 55.0 | - | +0.2 | 54.4 | - | -0.5 | 53.2 | 12 |
| Your fighter is tired | 16961 | 40.3 | 40.4 | - | +0.1 | 39.4 | - | -0.9 | 40.0 | 12 |
| Your fighter is hurt | 2440 | 36.5 | 48.5 | high | +12.0 | 34.5 | - | -1.9 | 44.3 | 74 |

### Bars (sizes 's1')

- Bar 1, RIGHT beats NORMAL by 5+ wins in 100 in at least 8 of 12 cells: 10 of 12 = PASS.
- Bar 2, WRONG loses to NORMAL by 5+ in at least 8 of 12 cells: 11 of 12 = PASS.
- Bar 3, NOISY (read right 70 in 100) still beats NORMAL in at least 6 of 12 cells: 12 of 12 = PASS.
- Bar 4, no single line best in more than 7 of 12 cells: { "ONE:loadup": 7, "ONE:tiring": 5, "ONE:she_tired": 2 } (most: ONE:loadup, 7 of 12) = PASS.
- Also: NORMAL against CONTROL, worst cell 1.5 in 100 apart (the worn-guard edge and the corner call's cover are the only differences).
- The instrument can read worse: RIGHT0 (the table zeroed) reaches bar 1's +5 in 0 of 12 cells.

RESULT: tools/guardprobe7.gd -> sizes=s1 right=PASS(10/12) wrong=PASS(11/12) noisy=PASS(12/12) single=PASS(7/12) -> PASS

(run took 1989 s)

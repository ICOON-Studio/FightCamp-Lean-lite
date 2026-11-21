# GUARDPROBE9 - guard v8, the guard line paid for by the feet: FAIL twice (S536)

Brief: `ops/research/TASK_GUARDREV8.md`. Map: `ops/research/DESIGN_GUARDDMG1_V8.md`. Probe: `tools/guardprobe9.gd` (measurement only, nothing under
scripts/ edited). Two runs on 2026-11-22, both through `godot_slot.py`: run 1 (the sizes written before it, 35,080 bouts, 884 s) and run 2, the
one resize the brief allows (35,080 bouts, 1,084 s). This page is the summary and then the two generated pages as the probe wrote them.

## VERDICT: FAIL twice. The price is real and the trait decides for each boxer, but against an opponent one answer wins almost everywhere and the best is not clear of its neighbours.

`RESULT: tools/guardprobe9.gd -> FAIL (effects all move; cost -5.1 +- 0.3, 10 cells 3+; top pair best in 6 of 10 cells; 1 of 10 cells clear; natural clearly beaten for 3 of 5 boxers and best in 0 of 10 cells)` (run 1)
`RESULT: tools/guardprobe9.gd -> FAIL (effects all move; cost -7.3 +- 0.4, 10 cells 3+; top pair best in 7 of 10 cells; 1 of 10 cells clear; natural clearly beaten for 3 of 5 boxers and best in 0 of 10 cells)` (run 2)

| Bar (all must pass) | Run 1 | Run 2 (wrong feet lose more) |
| :--- | :--- | :--- |
| 1 Every effect moves the result (2+ bouts in 100 change) | PASS: fit 3.8, step speed 4.5, legs 4.4, shifted stance 6.8 | PASS: 3.8, 5.6, 7.0, 6.8 |
| 2 A guard line costs something measurable (probe 8's bar) | **PASS**: paid is 5.1 +- 0.3 wins in 100 under the same lines free; 3+ under in 10 of 10 cells | **PASS**: 7.3 +- 0.4; 10 of 10 |
| 3 No line / stance pair best in more than 6 of 10 cells | PASS at 6 (High lines, one step wider; two of the six are exact ties) | **FAIL**: 7 (High lines, one step wider) |
| 4 Four or more cells clear of the noise | **FAIL**: 1 of 10 (Pressure fighter / pro) | **FAIL**: 1 of 10 (Slugger / am) |
| 5 The natural stance is not always the answer | PASS: a shifted pair clearly better for 3 of 5 boxers | PASS: 3 of 5 |

Self-checks, both runs: the probe's walk with every guard size off is the game's own bout in 40 of 40; the copied guard walk differs from the
game's by 0.000000; no attribute copy was rebuilt.

## What it means, in plain words
- **Probe 8's hole is closed.** In v7 a guard line cost nothing (the slot was free). Paid for by the feet, the same lines on the boxer's natural
  stance are worth 5.1 wins in 100 less than free (7.3 after the resize), in every one of the ten cells. In 9 of 10 cells (run 1) some line set
  written without looking at the feet does not beat writing no guard line at all.
- **The trait decides, boxer by boxer.** This is the strongest read on the page (table below). Kira (Narrow) gains +6 to +7 wins in 100 from
  the Loose lines and LOSES 3.5 to 11.5 with the High lines; Samira (Wide) is the mirror (+5 to +10 with High, -5.5 to -9.5 with Loose). The
  three Shoulder boxers get little or nothing from either on their natural stance and +6 to +7 once the pad weeks have moved them a step.
  The same line is good for one boxer and bad for another, and both are far outside the noise.
- **Against an opponent, one answer wins most cells.** Pooled over the five boxers, "High lines, one step wider" is the best pair in 6 of 10
  cells (run 1) and 7 of 10 (run 2); Loose-and-narrower only against the Out-boxer. The reason is in the line sets, not the feet: two of the
  three High lines sit on the boxer's OWN trouble (tired, hurt), which comes against every opponent. High lines fire 16 to 21 times a pro
  bout on the natural stance, Loose lines 2 to 8 in any bout. So the High set is blind to who is in the other corner.
- **The best pair is clear of "no guard line" but not of its neighbours.** In run 1 the best pair beats no line on the natural stance by 2.0 to
  9.3 wins in 100, more than two standard errors in 8 of 10 cells. But the second pair (the same lines in the High + Loose set, or the other
  set on its own stance) is 0 to 4 behind and a paired difference at 200 bouts is +- 1.2 to 2.8. Ten pairs is too many to tell apart.
- **The resize sharpened the price, not the choice.** Wrong feet lose more (the cost went from 5.1 to 7.3), the mixed set fell away, and
  that only uncovered what the ties were hiding: High-and-wider alone on top in 7 cells.
- **Shifting is free on the night.** The best pair is never on the natural stance pooled (0 of 10 cells, both runs), because three of the five
  boxers are Shoulder and a shifted stance costs nothing in the bout once owned. Its price is the pad weeks, which a bout probe cannot see.

### By the boxer's natural stance (wins in 100 against no guard line on the natural stance, the five opponent styles pooled; 200 bouts a boxer and row)

Run 1:

| Boxers | Bouts | High lines, natural | High lines, one step wider | Loose lines, natural | Loose lines, one step narrower | High lines free (v7) | Loose lines free (v7) |
| :--- | :--- | ---: | ---: | ---: | ---: | ---: | ---: |
| Kira (Narrow) | amateur | -3.5 +- 1.5 | +0.0 +- 2.0 | +7.0 +- 2.1 | (on the pad's edge) | +4.0 +- 1.6 | +7.0 +- 2.1 |
| Kira (Narrow) | pro | -11.5 +- 1.8 | -1.3 +- 2.0 | +5.8 +- 1.5 | (on the pad's edge) | +4.3 +- 1.4 | +5.8 +- 1.5 |
| Samira (Wide) | amateur | +10.0 +- 2.1 | (on the pad's edge) | -9.5 +- 2.2 | -3.5 +- 1.8 | +10.0 +- 2.1 | +5.0 +- 1.5 |
| Samira (Wide) | pro | +5.0 +- 2.3 | (on the pad's edge) | -5.5 +- 2.2 | -6.3 +- 2.2 | +5.0 +- 2.3 | +1.5 +- 2.0 |
| Tess, Danny, Josh (Shoulder) | amateur | +2.2 +- 0.6 | +6.7 +- 1.1 | -0.7 +- 0.9 | +6.0 +- 1.3 | +7.7 +- 1.1 | +5.0 +- 1.0 |
| Tess, Danny, Josh (Shoulder) | pro | -3.3 +- 1.0 | +6.9 +- 1.2 | -2.3 +- 1.0 | +2.2 +- 1.3 | +4.7 +- 1.1 | +3.4 +- 1.0 |

Run 2 (the resize):

| Boxers | Bouts | High lines, natural | High lines, one step wider | Loose lines, natural | Loose lines, one step narrower | High lines free (v7) | Loose lines free (v7) |
| :--- | :--- | ---: | ---: | ---: | ---: | ---: | ---: |
| Kira (Narrow) | amateur | -5.5 +- 1.9 | -2.5 +- 2.1 | +7.0 +- 2.1 | (on the pad's edge) | +4.0 +- 1.6 | +7.0 +- 2.1 |
| Kira (Narrow) | pro | -17.8 +- 2.2 | -6.5 +- 2.2 | +5.8 +- 1.5 | (on the pad's edge) | +4.3 +- 1.4 | +5.8 +- 1.5 |
| Samira (Wide) | amateur | +10.0 +- 2.1 | (on the pad's edge) | -14.5 +- 2.5 | -9.0 +- 2.3 | +10.0 +- 2.1 | +5.0 +- 1.5 |
| Samira (Wide) | pro | +5.0 +- 2.3 | (on the pad's edge) | -10.8 +- 2.5 | -8.8 +- 2.4 | +5.0 +- 2.3 | +1.5 +- 2.0 |
| Tess, Danny, Josh (Shoulder) | amateur | +0.7 +- 0.5 | +6.7 +- 1.1 | -4.2 +- 1.0 | +6.0 +- 1.3 | +7.7 +- 1.1 | +5.0 +- 1.0 |
| Tess, Danny, Josh (Shoulder) | pro | -6.0 +- 1.1 | +6.9 +- 1.2 | -4.5 +- 1.1 | +2.2 +- 1.3 | +4.7 +- 1.1 | +3.4 +- 1.0 |

## The ways on (for Claude: by the brief a second FAIL comes back, no critic brief was written)
1. **Make the guard lines follow the opponent.** Keep guard lines only on the OPPONENT's moments (loads up, presses, at range, tiring, hurt)
   and move "cover when your boxer is tired / hurt" out of the plan (a corner shout, as v7 2.1 already has it). Then which set pays depends on
   who he fights, and the feet price it. This attacks bar 3 at its cause. One more probe, the same instrument, new line sets.
2. **Read the mechanic by boxer, not by opponent cell.** The depth v8 has is "this boxer, these feet, these lines". A probe whose cells are
   natural stance x opponent needs more than one Narrow and one Wide boxer (generated boxers or more Data prospects).
3. **Give the shifted stance a price on the night** (STANCE1's "not owned yet": slower steps and energy until N bouts in it), so the natural
   stance is sometimes the answer and the pad weeks are a real spend.
4. **The cheap build, if depth is not needed here:** keep v7's guard line and let the natural stance only set the line's grade word (in his
   feet Good, a step off OK, two steps Poor). The table by boxer above is that rule's effect; it needs no new fight rule.
My recommendation: 1 and 3 together in one probe 10, read by boxer as well (2). Do not build v8 as it stands.

---

# GUARDPROBE9 - guard v8: the guard line paid for by the feet (S536), sizes run 1

Run: python ops/Tools/godot_slot.py run --who guardrev8 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe9.gd -- seeds=40 abl=20 size=1

What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex, re-rated -3.4 amateur / -6.5 pro as stanceprobe1 fitted) and every bout (the game's fight night, walked exchange by exchange).
What is scratch: the guard lines (v7's table), the feet's price on them and the shifted stance's layer. Every arm of a seed fights the same night (same dice): 200 bouts a pair and cell = 5 boxers x 40 seeds. A draw is half a win.

Sizes (set before the run): the plus kept at 0 / 1 / 2 steps from the line's stance [1.0, 0.6, 0.25]; High out of its feet 2.5 points off the exchange a step; Loose out of its feet 2.0 energy after the exchange a step. A shifted stance: { "power": 5.0, "slip": 5.0, "chin": 5.0, "feet": 3.0, "drain": 1.5 } a step.
Line sets: HIGH = High WHEN the opponent loads up / your boxer is hurt / your boxer is tired; LOOSE = Loose WHEN the opponent is tiring / is hurt / boxes at range; BOTH = High WHEN loading up, Loose WHEN tiring, High WHEN your boxer is hurt (probe 7's right three).

Self-check 1: the walk with every guard size off gives the same bout as BoutNight.play_out in 40 of 40 bouts. Self-check 2: the copied guard walk against the game's, max |diff| = 0.000000. Attribute copies the game would have rebuilt (must be 0): 0.

## 1. Who they are

| Boxer | Style | Power | Speed | Natural stance | In his feet | One step off | Two steps off |
| :--- | :--- | ---: | ---: | :--- | :--- | :--- | :--- |
| Kira Mensah | Out-boxer | 54 | 67 | Narrow | Hands Loose | - | Hands High |
| Samira Khan | Slugger | 66 | 57 | Wide | Hands High | - | Hands Loose |
| Tess Reilly | Pressure fighter | 62 | 55 | Shoulder | - | Hands High, Hands Loose | - |
| Danny Osei | Boxer-puncher | 59 | 62 | Shoulder | - | Hands High, Hands Loose | - |
| Josh Harper | Pressure fighter | 63 | 56 | Shoulder | - | Hands High, Hands Loose | - |

## 2. Every cell: wins in 100 bouts by pair (+- one standard error)

### Out-boxer / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 55.5 +- 3.5 | 54.5 +- 3.5 | 55.0 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 57.0 +- 3.5 | 58.0 +- 3.5 | 4.2 | 9.5 points, 0.0 energy |
| Loose lines | 63.0 +- 3.4 | 53.0 +- 3.5 | - | 7.3 | 0.0 points, 12.9 energy |
| High + Loose | 59.0 +- 3.5 | 57.5 +- 3.5 | 56.5 +- 3.5 | 3.7 | 4.5 points, 3.5 energy |

Best: **Loose lines, one step narrower** (63.0); inside two standard errors of it: High lines, one step wider; High + Loose, one step narrower.

### Out-boxer / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 59.3 +- 3.2 | 56.8 +- 3.3 | 59.3 +- 3.2 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 56.5 +- 3.3 | 62.5 +- 3.2 | 17.3 | 43.3 points, 0.0 energy |
| Loose lines | 66.0 +- 3.0 | 57.3 +- 3.2 | - | 7.8 | 0.0 points, 12.8 energy |
| High + Loose | 61.8 +- 3.2 | 59.8 +- 3.2 | 59.3 +- 3.2 | 4.6 | 5.6 points, 4.2 energy |

Best: **Loose lines, one step narrower** (66.0); inside two standard errors of it: High lines, one step wider.

### Pressure fighter / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 43.5 +- 3.5 | 42.5 +- 3.5 | 44.0 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 44.0 +- 3.5 | 51.5 +- 3.5 | 6.5 | 15.0 points, 0.0 energy |
| Loose lines | 49.5 +- 3.5 | 45.0 +- 3.5 | - | 2.4 | 0.0 points, 3.6 energy |
| High + Loose | 44.0 +- 3.5 | 46.5 +- 3.5 | 50.0 +- 3.5 | 3.9 | 6.8 points, 1.7 energy |

Best: **High lines, one step wider** (51.5); inside two standard errors of it: Loose lines, one step narrower; High + Loose, one step wider.

### Pressure fighter / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 51.0 +- 3.4 | 50.7 +- 3.4 | 51.2 +- 3.4 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 48.8 +- 3.3 | 56.5 +- 3.4 | 20.8 | 51.1 points, 0.0 energy |
| Loose lines | 50.7 +- 3.3 | 49.8 +- 3.3 | - | 2.9 | 0.0 points, 4.6 energy |
| High + Loose | 49.5 +- 3.3 | 51.0 +- 3.4 | 52.8 +- 3.4 | 4.8 | 8.1 points, 2.2 energy |

Best: **High lines, one step wider** (56.5) - CLEAR.

### Counter-puncher / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 44.0 +- 3.5 | 44.0 +- 3.5 | 45.0 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 48.5 +- 3.5 | 51.0 +- 3.5 | 5.2 | 12.8 points, 0.0 energy |
| Loose lines | 46.0 +- 3.5 | 43.5 +- 3.5 | - | 3.8 | 0.0 points, 6.9 energy |
| High + Loose | 46.0 +- 3.5 | 49.0 +- 3.5 | 51.0 +- 3.5 | 4.0 | 6.5 points, 2.9 energy |

Best: **High lines, one step wider = High + Loose, one step wider** (51.0); inside two standard errors of it: High lines, natural stance; High + Loose, natural stance.

### Counter-puncher / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 56.3 +- 3.2 | 58.8 +- 3.2 | 63.0 +- 3.2 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 54.0 +- 3.3 | 65.5 +- 3.2 | 18.3 | 46.1 points, 0.0 energy |
| Loose lines | 57.5 +- 3.3 | 57.3 +- 3.3 | - | 4.3 | 0.0 points, 7.4 energy |
| High + Loose | 57.8 +- 3.2 | 60.8 +- 3.2 | 65.8 +- 3.1 | 4.6 | 6.6 points, 3.4 energy |

Best: **High + Loose, one step wider** (65.8); inside two standard errors of it: no guard line, one step wider; High lines, one step wider.

### Volume puncher / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 54.0 +- 3.5 | 56.0 +- 3.5 | 56.5 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 57.5 +- 3.5 | 59.5 +- 3.5 | 4.3 | 9.9 points, 0.0 energy |
| Loose lines | 58.0 +- 3.5 | 53.0 +- 3.5 | - | 5.5 | 0.0 points, 10.3 energy |
| High + Loose | 56.0 +- 3.5 | 58.0 +- 3.5 | 57.0 +- 3.5 | 3.5 | 4.9 points, 3.0 energy |

Best: **High lines, one step wider** (59.5); inside two standard errors of it: High lines, natural stance; Loose lines, one step narrower; High + Loose, one step narrower; High + Loose, natural stance; High + Loose, one step wider.

### Volume puncher / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 53.5 +- 3.4 | 60.0 +- 3.3 | 62.0 +- 3.3 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 55.8 +- 3.4 | 61.8 +- 3.3 | 16.1 | 39.2 points, 0.0 energy |
| Loose lines | 57.3 +- 3.4 | 54.8 +- 3.3 | - | 6.0 | 0.0 points, 10.7 energy |
| High + Loose | 55.8 +- 3.3 | 60.3 +- 3.3 | 62.0 +- 3.3 | 4.2 | 5.1 points, 3.8 energy |

Best: **no guard line, one step wider = High + Loose, one step wider** (62.0); inside two standard errors of it: no guard line, natural stance; High lines, one step wider; High + Loose, natural stance.

### Slugger / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 53.0 +- 3.5 | 52.5 +- 3.5 | 53.5 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 55.5 +- 3.5 | 59.5 +- 3.5 | 7.4 | 16.3 points, 0.0 energy |
| Loose lines | 54.5 +- 3.5 | 50.5 +- 3.5 | - | 2.6 | 0.0 points, 4.5 energy |
| High + Loose | 54.5 +- 3.5 | 56.0 +- 3.5 | 56.5 +- 3.5 | 6.9 | 11.6 points, 3.4 energy |

Best: **High lines, one step wider** (59.5); inside two standard errors of it: High + Loose, natural stance.

### Slugger / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 55.5 +- 3.3 | 58.0 +- 3.3 | 59.3 +- 3.3 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 53.0 +- 3.4 | 62.5 +- 3.2 | 20.9 | 48.0 points, 0.0 energy |
| Loose lines | 58.8 +- 3.3 | 58.5 +- 3.3 | - | 3.6 | 0.0 points, 5.8 energy |
| High + Loose | 56.5 +- 3.3 | 56.8 +- 3.3 | 61.0 +- 3.3 | 8.4 | 12.9 points, 4.5 energy |

Best: **High lines, one step wider** (62.5); inside two standard errors of it: no guard line, natural stance; no guard line, one step wider; Loose lines, one step narrower; Loose lines, natural stance; High + Loose, one step wider.

## 3. The summary

| Cell | Today's game (20 seeds) | No guard line, natural | Best pair | Wins | Against no line, natural | Inside the noise of the best |
| :--- | ---: | ---: | :--- | ---: | ---: | :--- |
| Out-boxer / am | 55.0 | 54.5 | Loose lines, one step narrower | 63.0 | +8.5 +- 2.5 | High lines, one step wider; High + Loose, one step narrower |
| Out-boxer / pro | 55.5 | 56.8 | Loose lines, one step narrower | 66.0 | +9.3 +- 2.3 | High lines, one step wider |
| Pressure fighter / am | 42.0 | 42.5 | High lines, one step wider | 51.5 | +9.0 +- 2.3 | Loose lines, one step narrower; High + Loose, one step wider |
| Pressure fighter / pro | 48.5 | 50.7 | High lines, one step wider | 56.5 | +5.8 +- 2.2 | CLEAR |
| Counter-puncher / am | 49.0 | 44.0 | High lines, one step wider = High + Loose, one step wider | 51.0 | +7.0 +- 2.2 | High lines, natural stance; High + Loose, natural stance |
| Counter-puncher / pro | 57.0 | 58.8 | High + Loose, one step wider | 65.8 | +7.0 +- 2.4 | no guard line, one step wider; High lines, one step wider |
| Volume puncher / am | 57.0 | 56.0 | High lines, one step wider | 59.5 | +3.5 +- 1.6 | High lines, natural stance; Loose lines, one step narrower; High + Loose, one step narrower; High + Loose, natural stance; High + Loose, one step wider |
| Volume puncher / pro | 52.5 | 60.0 | no guard line, one step wider = High + Loose, one step wider | 62.0 | +2.0 +- 1.2 | no guard line, natural stance; High lines, one step wider; High + Loose, natural stance |
| Slugger / am | 50.0 | 52.5 | High lines, one step wider | 59.5 | +7.0 +- 1.9 | High + Loose, natural stance |
| Slugger / pro | 60.5 | 58.0 | High lines, one step wider | 62.5 | +4.5 +- 2.4 | no guard line, natural stance; no guard line, one step wider; Loose lines, one step narrower; Loose lines, natural stance; High + Loose, one step wider |

Best counts: Loose lines, one step narrower 2; High lines, one step wider 6; High + Loose, one step wider 3; no guard line, one step wider 1. The most any one pair wins: 6 of 10 cells (bar: 6 or fewer).
Cells with a clear best (every other pair more than two standard errors under it, seed by seed): 1 of 10 (bar: 4 or more).
Cells whose best pair is on the natural stance: 0 of 10 (bar: 8 or fewer).

## 4. What a guard line costs: the same lines free (v7's rule, no feet) against paid, on the natural stance

| Cell | High lines: free | paid | the feet cost | Loose lines: free | paid | the feet cost | High + Loose: free | paid | the feet cost |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Out-boxer / am | +5.5 | +2.5 | -3.0 +- 1.4 | +9.0 | -1.5 | -10.5 +- 2.3 | +8.0 | +3.0 | -5.0 +- 1.5 |
| Out-boxer / pro | +8.0 | -0.3 | -8.3 +- 1.9 | +11.0 | +0.5 | -10.5 +- 2.3 | +3.0 | +3.0 | +0.0 +- 1.8 |
| Pressure fighter / am | +9.5 | +1.5 | -8.0 +- 1.9 | +5.5 | +2.5 | -3.0 +- 1.2 | +10.5 | +4.0 | -6.5 +- 1.7 |
| Pressure fighter / pro | +5.3 | -2.0 | -7.2 +- 2.0 | +1.8 | -1.0 | -2.8 +- 1.6 | +2.3 | +0.3 | -2.0 +- 1.3 |
| Counter-puncher / am | +10.0 | +4.5 | -5.5 +- 1.6 | +5.5 | -0.5 | -6.0 +- 1.7 | +9.0 | +5.0 | -4.0 +- 1.6 |
| Counter-puncher / pro | +5.3 | -4.8 | -10.0 +- 2.0 | +2.8 | -1.5 | -4.3 +- 1.7 | +6.8 | +2.0 | -4.8 +- 1.4 |
| Volume puncher / am | +3.5 | +1.5 | -2.0 +- 1.2 | +6.0 | -3.0 | -9.0 +- 2.0 | +3.5 | +2.0 | -1.5 +- 1.1 |
| Volume puncher / pro | +1.0 | -4.3 | -5.3 +- 1.6 | +1.5 | -5.3 | -6.8 +- 1.8 | +0.8 | +0.3 | -0.5 +- 1.3 |
| Slugger / am | +8.5 | +3.0 | -5.5 +- 1.8 | +1.0 | -2.0 | -3.0 +- 1.2 | +9.0 | +3.5 | -5.5 +- 1.8 |
| Slugger / pro | +3.8 | -5.0 | -8.8 +- 2.2 | +0.5 | +0.5 | +0.0 +- 1.4 | +3.0 | -1.3 | -4.3 +- 1.8 |

(free and paid are against no guard line on the natural stance, wins in 100.) Pooled over the cells and the three line sets: paid against free -5.1 +- 0.3 wins in 100 (bar: 2.0 or more under, beyond two standard errors). Cells where some line set is 3+ under its free twin: 10 of 10 (bar: 3 or more). Cells where some paid line set on the natural stance does not beat no guard line at all: 9 of 10.

## 5. Is the natural stance always the answer? (each boxer, the 10 cells pooled, 400 bouts a pair)

| Boxer | Natural | Best pair on the natural stance | Wins | Best pair on a shifted stance | Wins | Shifted against natural | Clear |
| :--- | :--- | :--- | ---: | :--- | ---: | ---: | :--- |
| Kira | Narrow | Loose lines | 65.1 | High + Loose, one step wider | 61.3 | -3.9 +- 1.6 | no |
| Samira | Wide | High lines | 54.4 | High + Loose, one step narrower | 47.1 | -7.2 +- 1.8 | no |
| Tess | Shoulder | High + Loose | 52.1 | High lines, one step wider | 57.3 | +5.1 +- 1.5 | yes |
| Danny | Shoulder | High + Loose | 68.4 | Loose lines, one step narrower | 72.6 | +4.3 +- 1.4 | yes |
| Josh | Shoulder | High + Loose | 46.4 | High lines, one step wider | 55.3 | +8.9 +- 1.5 | yes |

Boxers for whom a shifted pair is clearly above the best natural-stance pair: 3 of 5 (bar: 2 or more). The best of several pairs on the same bouts flatters both sides a little; read the size, not the last decimal.

## 6. Does each effect move the result? (the effect off on its two test pairs, 20 seeds, the same dice as with it on)

| Effect off | Test pairs | Bouts whose result changed, in 100 | Wins in 100 with it off against on | Moves it (2 in 100 or more) |
| :--- | :--- | ---: | ---: | :--- |
| the plus kept by the feet | High lines, natural stance; Loose lines, natural stance | 3.8 | +2.0 +- 0.4 | yes |
| High out of its feet: step speed | High lines, natural stance; High + Loose, natural stance | 4.5 | +2.4 +- 0.3 | yes |
| Loose out of its feet: the legs | Loose lines, natural stance; High + Loose, natural stance | 4.4 | +2.2 +- 0.4 | yes |
| a shifted stance changes the boxer | no guard line, one step wider; no guard line, one step narrower | 6.8 | -0.1 +- 0.5 | yes |

## 7. Bars (written in the probe before the run)

- 1 every effect moves the result: PASS.
- 2 a guard line costs something measurable: -5.1 +- 0.3 wins in 100 against free, 10 cells 3+ under = PASS.
- 3 no pair best in more than 6 of 10 cells: 6 = PASS.
- 4 four or more cells clear of the noise: 1 = FAIL.
- 5 the natural stance is not always the answer: clearly beaten for 3 of 5 boxers, best in 0 of 10 cells = PASS.

35080 bouts played in 884 s.

RESULT: tools/guardprobe9.gd -> FAIL (effects all move; cost -5.1 +- 0.3, 10 cells 3+; top pair best in 6 of 10 cells; 1 of 10 cells clear; natural clearly beaten for 3 of 5 boxers and best in 0 of 10 cells)

---

# GUARDPROBE9 - guard v8: the guard line paid for by the feet (S536), sizes run 2

Run: python ops/Tools/godot_slot.py run --who guardrev8 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/guardprobe9.gd -- seeds=40 abl=20 size=2

What is real: the five boxers (Data.PROSPECTS), their opponents (Data's region sheets, by style and sex, re-rated -3.4 amateur / -6.5 pro as stanceprobe1 fitted) and every bout (the game's fight night, walked exchange by exchange).
What is scratch: the guard lines (v7's table), the feet's price on them and the shifted stance's layer. Every arm of a seed fights the same night (same dice): 200 bouts a pair and cell = 5 boxers x 40 seeds. A draw is half a win.

Sizes (set before the run): the plus kept at 0 / 1 / 2 steps from the line's stance [1.0, 0.5, 0.0]; High out of its feet 4.0 points off the exchange a step; Loose out of its feet 4.0 energy after the exchange a step. A shifted stance: { "power": 5.0, "slip": 5.0, "chin": 5.0, "feet": 3.0, "drain": 1.5 } a step.
Line sets: HIGH = High WHEN the opponent loads up / your boxer is hurt / your boxer is tired; LOOSE = Loose WHEN the opponent is tiring / is hurt / boxes at range; BOTH = High WHEN loading up, Loose WHEN tiring, High WHEN your boxer is hurt (probe 7's right three).

Self-check 1: the walk with every guard size off gives the same bout as BoutNight.play_out in 40 of 40 bouts. Self-check 2: the copied guard walk against the game's, max |diff| = 0.000000. Attribute copies the game would have rebuilt (must be 0): 0.

## 1. Who they are

| Boxer | Style | Power | Speed | Natural stance | In his feet | One step off | Two steps off |
| :--- | :--- | ---: | ---: | :--- | :--- | :--- | :--- |
| Kira Mensah | Out-boxer | 54 | 67 | Narrow | Hands Loose | - | Hands High |
| Samira Khan | Slugger | 66 | 57 | Wide | Hands High | - | Hands Loose |
| Tess Reilly | Pressure fighter | 62 | 55 | Shoulder | - | Hands High, Hands Loose | - |
| Danny Osei | Boxer-puncher | 59 | 62 | Shoulder | - | Hands High, Hands Loose | - |
| Josh Harper | Pressure fighter | 63 | 56 | Shoulder | - | Hands High, Hands Loose | - |

## 2. Every cell: wins in 100 bouts by pair (+- one standard error)

### Out-boxer / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 55.5 +- 3.5 | 54.5 +- 3.5 | 55.0 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 55.5 +- 3.5 | 57.5 +- 3.5 | 4.3 | 15.5 points, 0.0 energy |
| Loose lines | 61.0 +- 3.5 | 45.5 +- 3.5 | - | 6.4 | 0.0 points, 21.2 energy |
| High + Loose | 56.5 +- 3.5 | 54.5 +- 3.5 | 52.0 +- 3.5 | 3.4 | 7.5 points, 5.6 energy |

Best: **Loose lines, one step narrower** (61.0); inside two standard errors of it: no guard line, one step narrower; High lines, natural stance; High lines, one step wider; High + Loose, one step narrower.

### Out-boxer / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 59.3 +- 3.2 | 56.8 +- 3.3 | 59.3 +- 3.2 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 53.0 +- 3.3 | 61.8 +- 3.2 | 17.5 | 70.5 points, 0.0 energy |
| Loose lines | 65.5 +- 3.0 | 52.0 +- 3.3 | - | 6.8 | 0.0 points, 20.9 energy |
| High + Loose | 62.3 +- 3.2 | 58.0 +- 3.2 | 58.3 +- 3.2 | 4.2 | 9.2 points, 6.2 energy |

Best: **Loose lines, one step narrower** (65.5); inside two standard errors of it: High lines, one step wider; High + Loose, one step narrower.

### Pressure fighter / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 43.5 +- 3.5 | 42.5 +- 3.5 | 44.0 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 42.5 +- 3.5 | 50.0 +- 3.5 | 6.6 | 24.3 points, 0.0 energy |
| Loose lines | 49.5 +- 3.5 | 43.5 +- 3.5 | - | 2.1 | 0.0 points, 6.4 energy |
| High + Loose | 42.0 +- 3.5 | 45.0 +- 3.5 | 48.0 +- 3.5 | 3.8 | 11.1 points, 3.0 energy |

Best: **High lines, one step wider** (50.0); inside two standard errors of it: Loose lines, one step narrower; High + Loose, one step wider.

### Pressure fighter / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 51.0 +- 3.4 | 50.7 +- 3.4 | 51.2 +- 3.4 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 45.5 +- 3.3 | 55.0 +- 3.3 | 20.8 | 81.4 points, 0.0 energy |
| Loose lines | 50.0 +- 3.3 | 49.0 +- 3.3 | - | 2.7 | 0.0 points, 8.1 energy |
| High + Loose | 49.0 +- 3.4 | 49.5 +- 3.4 | 51.0 +- 3.4 | 4.6 | 13.1 points, 3.7 energy |

Best: **High lines, one step wider** (55.0); inside two standard errors of it: no guard line, one step narrower; no guard line, natural stance; no guard line, one step wider; Loose lines, one step narrower.

### Counter-puncher / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 44.0 +- 3.5 | 44.0 +- 3.5 | 45.0 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 46.5 +- 3.5 | 50.5 +- 3.5 | 5.2 | 20.6 points, 0.0 energy |
| Loose lines | 45.5 +- 3.5 | 40.0 +- 3.5 | - | 3.2 | 0.0 points, 11.3 energy |
| High + Loose | 43.5 +- 3.5 | 47.5 +- 3.5 | 49.5 +- 3.5 | 3.7 | 10.4 points, 4.7 energy |

Best: **High lines, one step wider** (50.5); inside two standard errors of it: High + Loose, natural stance; High + Loose, one step wider.

### Counter-puncher / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 56.3 +- 3.2 | 58.8 +- 3.2 | 63.0 +- 3.2 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 50.7 +- 3.3 | 64.5 +- 3.2 | 18.2 | 73.4 points, 0.0 energy |
| Loose lines | 56.8 +- 3.3 | 57.0 +- 3.2 | - | 3.7 | 0.0 points, 12.1 energy |
| High + Loose | 58.3 +- 3.2 | 57.5 +- 3.3 | 62.0 +- 3.2 | 4.3 | 10.8 points, 5.3 energy |

Best: **High lines, one step wider** (64.5); inside two standard errors of it: no guard line, one step wider; High + Loose, one step wider.

### Volume puncher / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 54.0 +- 3.5 | 56.0 +- 3.5 | 56.5 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 56.5 +- 3.5 | 59.5 +- 3.5 | 4.3 | 16.0 points, 0.0 energy |
| Loose lines | 56.0 +- 3.5 | 50.0 +- 3.5 | - | 4.8 | 0.0 points, 17.1 energy |
| High + Loose | 53.0 +- 3.5 | 56.5 +- 3.5 | 54.5 +- 3.5 | 3.3 | 7.8 points, 5.2 energy |

Best: **High lines, one step wider** (59.5); inside two standard errors of it: High lines, natural stance; Loose lines, one step narrower; High + Loose, natural stance.

### Volume puncher / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 53.5 +- 3.4 | 60.0 +- 3.3 | 62.0 +- 3.3 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 54.8 +- 3.4 | 61.3 +- 3.3 | 16.1 | 63.1 points, 0.0 energy |
| Loose lines | 56.8 +- 3.4 | 52.3 +- 3.4 | - | 5.1 | 0.0 points, 17.2 energy |
| High + Loose | 54.5 +- 3.4 | 60.0 +- 3.3 | 60.3 +- 3.3 | 3.8 | 8.2 points, 5.9 energy |

Best: **no guard line, one step wider** (62.0); inside two standard errors of it: no guard line, natural stance; High lines, one step wider; High + Loose, natural stance; High + Loose, one step wider.

### Slugger / am

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 53.0 +- 3.5 | 52.5 +- 3.5 | 53.5 +- 3.5 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 55.0 +- 3.5 | 59.5 +- 3.5 | 7.5 | 26.7 points, 0.0 energy |
| Loose lines | 53.5 +- 3.5 | 50.5 +- 3.5 | - | 2.3 | 0.0 points, 7.5 energy |
| High + Loose | 51.5 +- 3.5 | 52.5 +- 3.5 | 56.0 +- 3.5 | 6.7 | 19.0 points, 5.5 energy |

Best: **High lines, one step wider** (59.5) - CLEAR.

### Slugger / pro

| | one step narrower | natural stance | one step wider | lines fired a bout (natural) | the feet took a bout (natural) |
| :--- | ---: | ---: | ---: | ---: | :--- |
| no guard line | 55.5 +- 3.3 | 58.0 +- 3.3 | 59.3 +- 3.3 | 0.0 | 0.0 points, 0.0 energy |
| High lines | - | 49.5 +- 3.4 | 61.0 +- 3.3 | 21.0 | 76.9 points, 0.0 energy |
| Loose lines | 58.8 +- 3.3 | 55.5 +- 3.3 | - | 3.1 | 0.0 points, 9.3 energy |
| High + Loose | 52.8 +- 3.4 | 55.8 +- 3.3 | 57.0 +- 3.3 | 7.9 | 20.8 points, 6.6 energy |

Best: **High lines, one step wider** (61.0); inside two standard errors of it: no guard line, natural stance; no guard line, one step wider; Loose lines, one step narrower.

## 3. The summary

| Cell | Today's game (20 seeds) | No guard line, natural | Best pair | Wins | Against no line, natural | Inside the noise of the best |
| :--- | ---: | ---: | :--- | ---: | ---: | :--- |
| Out-boxer / am | 55.0 | 54.5 | Loose lines, one step narrower | 61.0 | +6.5 +- 2.8 | no guard line, one step narrower; High lines, natural stance; High lines, one step wider; High + Loose, one step narrower |
| Out-boxer / pro | 55.5 | 56.8 | Loose lines, one step narrower | 65.5 | +8.8 +- 2.4 | High lines, one step wider; High + Loose, one step narrower |
| Pressure fighter / am | 42.0 | 42.5 | High lines, one step wider | 50.0 | +7.5 +- 2.3 | Loose lines, one step narrower; High + Loose, one step wider |
| Pressure fighter / pro | 48.5 | 50.7 | High lines, one step wider | 55.0 | +4.3 +- 2.3 | no guard line, one step narrower; no guard line, natural stance; no guard line, one step wider; Loose lines, one step narrower |
| Counter-puncher / am | 49.0 | 44.0 | High lines, one step wider | 50.5 | +6.5 +- 2.1 | High + Loose, natural stance; High + Loose, one step wider |
| Counter-puncher / pro | 57.0 | 58.8 | High lines, one step wider | 64.5 | +5.8 +- 2.3 | no guard line, one step wider; High + Loose, one step wider |
| Volume puncher / am | 57.0 | 56.0 | High lines, one step wider | 59.5 | +3.5 +- 1.6 | High lines, natural stance; Loose lines, one step narrower; High + Loose, natural stance |
| Volume puncher / pro | 52.5 | 60.0 | no guard line, one step wider | 62.0 | +2.0 +- 1.2 | no guard line, natural stance; High lines, one step wider; High + Loose, natural stance; High + Loose, one step wider |
| Slugger / am | 50.0 | 52.5 | High lines, one step wider | 59.5 | +7.0 +- 1.9 | CLEAR |
| Slugger / pro | 60.5 | 58.0 | High lines, one step wider | 61.0 | +3.0 +- 2.5 | no guard line, natural stance; no guard line, one step wider; Loose lines, one step narrower |

Best counts: Loose lines, one step narrower 2; High lines, one step wider 7; no guard line, one step wider 1. The most any one pair wins: 7 of 10 cells (bar: 6 or fewer).
Cells with a clear best (every other pair more than two standard errors under it, seed by seed): 1 of 10 (bar: 4 or more).
Cells whose best pair is on the natural stance: 0 of 10 (bar: 8 or fewer).

## 4. What a guard line costs: the same lines free (v7's rule, no feet) against paid, on the natural stance

| Cell | High lines: free | paid | the feet cost | Loose lines: free | paid | the feet cost | High + Loose: free | paid | the feet cost |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Out-boxer / am | +5.5 | +1.0 | -4.5 +- 1.6 | +9.0 | -9.0 | -18.0 +- 2.7 | +8.0 | +0.0 | -8.0 +- 1.9 |
| Out-boxer / pro | +8.0 | -3.8 | -11.8 +- 2.1 | +11.0 | -4.8 | -15.8 +- 2.8 | +3.0 | +1.3 | -1.8 +- 1.9 |
| Pressure fighter / am | +9.5 | +0.0 | -9.5 +- 2.1 | +5.5 | +1.0 | -4.5 +- 1.5 | +10.5 | +2.5 | -8.0 +- 1.9 |
| Pressure fighter / pro | +5.3 | -5.3 | -10.5 +- 2.0 | +1.8 | -1.8 | -3.5 +- 1.8 | +2.3 | -1.3 | -3.5 +- 1.4 |
| Counter-puncher / am | +10.0 | +2.5 | -7.5 +- 1.9 | +5.5 | -4.0 | -9.5 +- 2.1 | +9.0 | +3.5 | -5.5 +- 1.8 |
| Counter-puncher / pro | +5.3 | -8.0 | -13.3 +- 2.3 | +2.8 | -1.8 | -4.5 +- 1.8 | +6.8 | -1.3 | -8.0 +- 1.8 |
| Volume puncher / am | +3.5 | +0.5 | -3.0 +- 1.2 | +6.0 | -6.0 | -12.0 +- 2.3 | +3.5 | +0.5 | -3.0 +- 1.2 |
| Volume puncher / pro | +1.0 | -5.3 | -6.3 +- 1.9 | +1.5 | -7.8 | -9.3 +- 2.2 | +0.8 | +0.0 | -0.8 +- 1.6 |
| Slugger / am | +8.5 | +2.5 | -6.0 +- 2.0 | +1.0 | -2.0 | -3.0 +- 1.4 | +9.0 | +0.0 | -9.0 +- 2.1 |
| Slugger / pro | +3.8 | -8.5 | -12.3 +- 2.4 | +0.5 | -2.5 | -3.0 +- 1.6 | +3.0 | -2.3 | -5.3 +- 2.2 |

(free and paid are against no guard line on the natural stance, wins in 100.) Pooled over the cells and the three line sets: paid against free -7.3 +- 0.4 wins in 100 (bar: 2.0 or more under, beyond two standard errors). Cells where some line set is 3+ under its free twin: 10 of 10 (bar: 3 or more). Cells where some paid line set on the natural stance does not beat no guard line at all: 10 of 10.

## 5. Is the natural stance always the answer? (each boxer, the 10 cells pooled, 400 bouts a pair)

| Boxer | Natural | Best pair on the natural stance | Wins | Best pair on a shifted stance | Wins | Shifted against natural | Clear |
| :--- | :--- | :--- | ---: | :--- | ---: | ---: | :--- |
| Kira | Narrow | Loose lines | 65.1 | no guard line, one step wider | 59.1 | -6.0 +- 1.6 | no |
| Samira | Wide | High lines | 54.4 | no guard line, one step narrower | 46.4 | -8.0 +- 1.7 | no |
| Tess | Shoulder | High + Loose | 51.7 | High lines, one step wider | 57.3 | +5.5 +- 1.7 | yes |
| Danny | Shoulder | High + Loose | 64.9 | Loose lines, one step narrower | 72.6 | +7.8 +- 1.5 | yes |
| Josh | Shoulder | no guard line | 46.0 | High lines, one step wider | 55.3 | +9.3 +- 1.6 | yes |

Boxers for whom a shifted pair is clearly above the best natural-stance pair: 3 of 5 (bar: 2 or more). The best of several pairs on the same bouts flatters both sides a little; read the size, not the last decimal.

## 6. Does each effect move the result? (the effect off on its two test pairs, 20 seeds, the same dice as with it on)

| Effect off | Test pairs | Bouts whose result changed, in 100 | Wins in 100 with it off against on | Moves it (2 in 100 or more) |
| :--- | :--- | ---: | ---: | :--- |
| the plus kept by the feet | High lines, natural stance; Loose lines, natural stance | 3.8 | +1.9 +- 0.3 | yes |
| High out of its feet: step speed | High lines, natural stance; High + Loose, natural stance | 5.6 | +3.3 +- 0.4 | yes |
| Loose out of its feet: the legs | Loose lines, natural stance; High + Loose, natural stance | 7.0 | +4.2 +- 0.5 | yes |
| a shifted stance changes the boxer | no guard line, one step wider; no guard line, one step narrower | 6.8 | -0.1 +- 0.5 | yes |

## 7. Bars (written in the probe before the run)

- 1 every effect moves the result: PASS.
- 2 a guard line costs something measurable: -7.3 +- 0.4 wins in 100 against free, 10 cells 3+ under = PASS.
- 3 no pair best in more than 6 of 10 cells: 7 = FAIL.
- 4 four or more cells clear of the noise: 1 = FAIL.
- 5 the natural stance is not always the answer: clearly beaten for 3 of 5 boxers, best in 0 of 10 cells = PASS.

35080 bouts played in 1084 s.

RESULT: tools/guardprobe9.gd -> FAIL (effects all move; cost -7.3 +- 0.4, 10 cells 3+; top pair best in 7 of 10 cells; 1 of 10 cells clear; natural clearly beaten for 3 of 5 boxers and best in 0 of 10 cells)

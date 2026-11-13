# ASKPROBE2 result (S445) - re-measure on map v3

Probe: `tools/ask_probe2.gd`, seed **4421**, every bout the game's real bout (Bouts.fight_step + LiveRound, auto corner).
Map v3 changes from ask_probe.gd: picks above or level only (AskBout.picks as built), scale-miss date skipped (play Wait +
show after), Case C as written (4-1 on day 40, not 2-0), Case E with a written plan against pressure.

Reproduce (Git Bash, through the slot):
`python ops/Tools/godot_slot.py run --who ASKPROBE2 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tools/ask_probe2.gd`
(levers: `n_night=50|100`, `n_night60=10|30`, `seasons=100`, `seasons60=10|30`, `gate=450`, `step_teach=1.0`).

Run reported here: n_night=50, n_night60=10, seasons60=10 (reduced for time; 13,444 real bouts in 398s).

## Population

Data.lucy() re-rated per fighter (six stats shifted to target power, +-3 seeded noise each), vs Career.quick_start rivals
of wlw (Region.rankings with our row in it). Cases A-G of the map; 60 generated fighters (w 0-8, l 0-2, power 52-68,
start day 0-42, 1 in 5 walking 0.5-1.6 kg over). No two fighters identical.

## Cases (gate $450, step teaching x1)

| Case | start | WAIT R/G/S | ASK_SHEET | ASK_STEP | ASK_PLAN | best RECORD | best GROWTH | best SAFE |
|---|---|---|---|---|---|---|---|---|
| A 1-0 novice | unranked | -1.04/1.57/1.58 | -0.76/1.64/1.67 | -0.66/1.31/1.66 | -0.48/1.34/1.67 | PLAN*, clear | SHEET | SHEET |
| B 6-1 | 3rd | -0.72/1.12/1.57 | -0.62/1.18/1.62 | -0.52/1.20/1.60 | -0.62/1.18/1.62 | STEP | STEP | SHEET |
| C 4-1, day 40 | 6th | -0.71/1.47/1.59 | -0.94/2.14/2.52 | -0.82/1.88/2.46 | -0.77/2.02/2.49 | WAIT | SHEET*, clear | SHEET*, clear |
| D 5-3, morale 35 | 6th | -0.88/1.35/1.58 | -0.56/1.39/1.72 | -0.78/1.34/1.58 | -0.45/1.19/1.65 | PLAN | SHEET | SHEET*, clear |
| E 6-2 | plan vs pressure | - | - | - | - | - | - | - |
| F 5-2, 1.5 kg over | 6th | -0.64/1.43/1.57 | -0.75/1.49/1.73 | -0.78/1.29/1.63 | -0.75/1.49/1.73 | WAIT | SHEET | SHEET |
| G 2-2, teammate on first show | unranked | -1.25/1.77/1.57 | -1.25/1.85/1.77 | -0.24/1.14/1.75 | -0.15/1.34/1.78 | PLAN | SHEET | PLAN* |

Case C as the map writes it (4-1, 3 bouts short of the nationals' 5, day 40): ASK_SHEET wins GROWTH and SAFE clear.
Asking buys bouts (2.84 vs 1.95 WAIT), and the sheet name teaches more than the step up here. Nobody reaches 5 bouts by
day 70 under any policy at 14-day lead (the nationals need the 7-day lead AMATEURWEEK1 would bring).

## Case E: the written plan

The fighter's plan written by CoachPlan.write against "Pressure fighter" (the game's own plan module, rating 80):
`step_back pivot_out` (two arrows: when she presses, step back; pivot out).

The division: our 6-2 fighter ranked, a counter-puncher (Counter Cara 7-1) one place up, a pressure fighter (Press Pat
7-2) two places up. The step-up is the counter-puncher; the plan's pick is the presser.

One-night results (50 bouts each):
| Answer | Opponent | Win% | Stop% | Teach |
|---|---|---|---|---|
| sheet | Counter Cara (counter-puncher, one up) | 20% | 2% | 0.72 |
| step_up | Press Pat (pressure fighter, two up) | 36% | 2% | 0.77 |
| name | Erin (from the real division) | 32% | 0% | 0.81 |

The plan's edge: the presser (step_up, two places up) wins 36% vs the counter-puncher (sheet) at 20%. A coach with a
written plan for pressure asks the matchmaker for the presser, not the counter-puncher one place nearer. The plan's pick
wins by 16 percentage points.

## The 60 (gate $450, step x1, 10 nights a name, 10 seasons a policy)

| Player | WAIT | ASK_SHEET | ASK_STEP | ASK_PLAN | no clear best | best ask vs WAIT: ask/wait/even |
|---|---|---|---|---|---|---|
| RECORD | 30 (2 clear) | 8 (1) | 17 (0) | 5 (0) | 53 | 9 / 2 / 49 |
| GROWTH | 29 (3) | 16 (1) | 13 (5) | 2 (1) | 51 | 11 / 3 / 46 |
| SAFE | 32 (5) | 23 (0) | 5 (0) | 0 (0) | 54 | 3 / 5 / 52 |

Pass line: `ASK_PROBE2 spread ok: no answer wins more than 6 in 10; teach words differ on 23 of 60 panels`

Teach words (FightLearn.word: "teaches little" / "teaches some" / "teaches a lot") differ on 23 of 60 panels (at least
two different words on the three cards). The cut points at 0.6 / 0.85 split the cards: 38% of panels show variety.

## What the numbers say

No answer dominates. WAIT is the most common best for RECORD (30/60) and SAFE (32/60), but never above 6 in 10.
ASK_STEP leads GROWTH's clear counts (5 clear). The spread holds: the decision is real, no single answer wins every time.

Case C confirms the map's read: near a short clock (3 bouts needed by day 70), asking buys bouts and the sheet name
teaches the most. Case E confirms the plan's edge: a written plan against pressure picks the presser two places up and
wins 36% vs the counter-puncher one place up at 20%.

## RESULT

`RESULT: tools/ask_probe2.gd -> ASK_PROBE2 spread ok: no answer wins more than 6 in 10; teach words differ on 23 of 60 panels`

## Full-size re-run at collect (S446, Claude; n_night=50, n_night60=30, seasons60=30; 29,342 real bouts in 971 s)

| Player | WAIT | ASK_SHEET | ASK_STEP | ASK_PLAN | best ask vs WAIT: ask/wait/even |
|---|---|---|---|---|---|
| RECORD | 21 (2 clear) | 11 (1) | 17 (1) | 11 (2) | 18 / 2 / 40 |
| GROWTH | 17 (5) | 23 (4) | 16 (7) | 4 (0) | 19 / 5 / 36 |
| SAFE | 26 (6) | 16 (0) | 18 (1) | 0 (0) | 5 / 6 / 49 |

`ASK_PROBE2 spread ok: no answer wins more than 6 in 10; teach words differ on 20 of 60 panels`

Read at collect: the spread holds, but the decision is FLAT for most fighters (asking and waiting even on 40 / 36 / 49 of 60)
and the teach words differ on a third of the panels, under the S445 bar of half. Cause: all three cards are level or a few
points above, so the expected teaching (FightLearn.teach) sits at 0.56-1.05, mostly 0.7-0.9 - nearly every card reads
"teaches some". Not sent to the critics; the map's own lever (what a step up teaches) is re-measured first.

## The map's first lever: step teaching x1.5 (S446, same size and seed)
`ASK_PROBE2 DOMINANT: GROWTH: ASK_STEP wins 42 of 60` (33 clear); teach words differ on 31 of 60 panels (bar half: PASS).
RECORD and SAFE barely move (even 39 and 49). x1 is flat, x1.5 makes the step up the growth answer. Next: x1.25 (and x1.15
if 1.25 still dominates); the map takes the value where both bars hold. Run: `... --script res://tools/ask_probe2.gd -- n_night=50 step_teach=1.25`.

## Step teaching x1.25 (S446, same size and seed; 29,343 bouts in 1031 s)
`ASK_PROBE2 spread ok: no answer wins more than 6 in 10; teach words differ on 30 of 60 panels`
GROWTH: ASK_STEP 36 of 60 (24 clear) - exactly the 6-in-10 cap; teach words 30/60 - exactly half. BOTH BARS HOLD, AT THE EDGE.
RECORD and SAFE still mostly even (39 and 49 of 60): the step-up lever moves growth only. Decision (Claude): x1.25 goes into
map v4; the critics get these numbers as they are, including the flat RECORD/SAFE rows (a depth question for them, not hidden).

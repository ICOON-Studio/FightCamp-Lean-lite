# S542 ADDENDUM (Claude, the coordinator's rerun) - PASS 6 of 6 at risky purse x1.75, full size

The worker's verdict below (FAIL 4 of 6) is at risky purse x1.5. Its x1.75 check ran 300 careers a cell and read bar 2 as
0 of 10; at the full 2,000 careers the same setting passes every bar (`stage=full reps=2000`, 116 s, RISKY_PURSE 1.75):

| Bar | Result |
|---|---|
| (1) no habit best in more than 6 of 10 | PASS: best arm READER 9, ALTERNATE 1 (among habits alone: SAFE 7, ALTERNATE 3) |
| (2) reader beats every habit by > 2 SE in 5+ types | PASS: 7 of 10; edge +1.2 to +3.7 points on a score of 90-104 (Tess Reilly -0.1) |
| (3) both bouts alive | PASS: safe 35.8% / risky 64.2% |
| (4) waiting is a real question | PASS: waits for 2 types, never for 8 |
| (5) mistakes are felt | PASS: ALWAYS WAIT loses the boxer in 10 of 10; SAFE and READER in none; an early KO costs 3.3 points of win rate in fights 4-6 |
| (6) nothing runs away | PASS: shift 5.0 points at most; both bars inside 0-100 |

Honest limits: the reader's edge is small (about 2-3% of the score), and the split between the two bouts swings hard with
the purse multiple (x1.5 -> 90% safe, x2 -> 81% risky). The owner's rule (interview answer 5): bots only check nothing is
broken; depth and fun are his play and two critics at 8. Critics queued: CRITIC_TURNPRO1_V17_BRIEF.md (kalli, dola).

---

# TURNPROBE17 - turning pro v17, the greybox probe (S542)

**Verdict: FAIL, 4 of 6 bars.** Bar 2 fails: the reader beats every habit in **0 of 10** boxer types (needs 5). Bar 3 fails:
the reader takes RISKY in **10.4%** of fights 1-6 (needs 25%). Bar 1 passes on paper only: ALWAYS SAFE is the best habit
for all 10 types, and for 8 of them the reader just plays ALWAYS SAFE (it leads by +0.04 to +0.78, always under 2 SE).
So in practice one habit (safe every time) is the best line for all 10 types. No critic brief was written (the brief:
FAIL -> which bar, what one change, stop).

The map: `ops/research/DESIGN_TURNPRO1_V17.md`. The probe: `tools/turnprobe17.gd` + `tools/turnprobe17_rules.gd`
(a greybox; nothing under scripts/ changed). Run: `godot --headless --audio-driver Dummy --path . --script
res://tools/turnprobe17.gd -- stage=full reps=2000` (113 s on one slot through `ops/Tools/godot_slot.py`; the trial 27 s).

## Bars (written in the map before any run)

| Bar | Pass | Measured |
|---|---|---|
| (1) no habit best in more than 6 of 10 types | yes on paper, NO in practice | best arm by type: READER, SAFE, READER, READER, READER, READER, SAFE, READER, READER, READER. The READER wins by noise-level margins. ALWAYS SAFE is the best habit in 10/10 and is never beaten by more than 2 SE. |
| (2) reader beats every habit by > 2 SE in 5+ types | **NO** | 0 of 10 |
| (3) reader takes SAFE 25%+ and RISKY 25%+ | **NO** | safe 89.6%, risky 10.4% |
| (4) reader says Not yet for 2+ types, never for 2+ | yes | waits: Reece Doyle, Kai Turner (once each); never: the other 8 |
| (5) SAFE or WAIT loses the boxer in 2+ types; reader in at most 1; an early KO marks fights 4-6 | yes | ALWAYS WAIT loses the boxer in 10/10 types (56-77% of careers); ALWAYS SAFE in 0; the reader in 0. A KO loss in fights 1-3 lowers the win rate in fights 4-6 by 2.9 points (SE 0.3) |
| (6) the confidence shift never passes 5 points; bars stay in 0-100 | yes | max shift 5.0 points; confidence 0-100, hunger 0-100 (both reach their ends and stop) |

## Why it fails (plain words)

Both chances are printed honestly, so each type of boxer has one bout that is simply worth more. The two bars move
that only a little: confidence by at most 5 points, and hunger only matters at 0, which a safe-only line never reaches
in six fights (70 -> about 10). So the best play is "take the safe bout every time" for every boxer, and reading the
bars adds almost nothing. This is the same root cause TURNPROBE16 found ("the honest card solves the decision").
Changing the purse only flips which bout wins: at double purse the reader took RISKY 81% of the time, at x1.5 SAFE 90%,
at x1.75 a mix that passes bar 3, but the reader still beat every habit in **0 of 10** types every time.

## The one change that would fix it

- Bar 3 alone: risky purse **x1.75** (measured, 300 reps: safe 35.7% / risky 64.3%, 5 of 6 bars).
- Bar 2 (the real one): no setting of the approved numbers fixes it (three settings measured, 0 of 10 each). The one
  change Claude recommends for the next round: **let hunger move the win chance too.** A flat boxer (hunger under 30)
  loses up to 5 points, sharing the same 5-point cap with confidence ("the prospect went flat"). Then a long safe run
  makes the safe bout itself worse, and the player has to read the hunger bar to time a risky fight. **Not measured
  here.** It needs the owner's yes, then the next probe.

## What was decided (no questions asked)

1. **The score: the gym's purse cut was added after the one-rep trial.** The score as first written (10 a win, -5 a loss,
   2 a name point, 0.2 x confidence above 50) left out money. In the trial the reader took SAFE in 60 of 60 fights,
   SAFE, WAIT and READER ended identical, and no boxer was lost: the brief's STOP case ("every type converges on the same
   best arm"). Fixed in the map before the sized run: +1 point per $100 of the gym's cut (`Roster.GYM_SHARE` 25%, as built).
   The owner's trade is "big purse, fast name", and leaving money out made RISKY worthless by definition. Score parts are
   printed apart below.
2. **Two approved numbers tuned (before -> after)** after a 300-rep check at double purse (the reader took RISKY 81%,
   nobody was ever lost):
   - safe-win hunger **-8 -> -10**, so ALWAYS WAIT empties hunger by fight 4 and the boxer walks (bar 5). At -8, nobody
     was ever lost.
   - risky purse **x2 -> x1.5**, to bring the reader back from 81% risky. This overshot: 90% safe. No further tuning was
     done after this (decided before the full run). x1.75 was measured afterwards only to name the fix.
3. **How the bouts are made:** each sex has two fixed men. The SAFE man is rated so the sex's middle boxer (Tess Reilly,
   Josh Harper) reads `ProLadder.TUNE_AIM` 0.82 at the offer, and the RISKY man so the same boxer reads `STEP_READ` 0.5.
   Each later fight's men are +0.3 rating. The game's own read (`DebutRead.card`) gives the raw chance, the band holds it
   in 75-90 / 40-55, and confidence shifts it. Strong types (Lucy, Nell) sit at the top of both bands, so waiting gains
   them nothing; weak ones (Samira) sit at the floor.
4. **The pop-up prints the trainer's read of fight 1's two chances four weeks on** (the game's training read). That is
   the only way the reader can judge "Not yet". It is a printed number, not a new rule or choice.
5. **Warnings:** at hunger 0, each booking (fights 2-6 and the booking after fight 6) is one warning; the third booking at
   0 = gone. A boxer who is gone scores 0.
6. **A draw counts as a loss** (the read gives the chance to win). **Stoppage share of a loss:** 30%, +10% for a risky
   bout, +1% for each chin point under 60, held to 10-60% (ESTIMATE: the read does not split losses).
7. **The reader** is a planner over the remaining fights. It uses only what is printed: today's two chances (held for the
   fights to come), the boxer's chin, confidence, hunger, warnings, and today's purse step. Losing the boxer costs it 40
   points.
8. **Fights are 8 weeks apart** (`Matchmaking.NEXT_WEEKS`), the debut 4 weeks out (`Roster.PRO_DEBUT_WEEKS`), and a
   stoppage loss adds the game's 8-week medical rest (`STOP_REST_WEEKS`; hunger -10). Training each week is the game's
   own (`TrainingPreview.plan_gain`, coach Reid 58).

## Population (10 types; each boxes their own sex and class; never two identical)

- 0 Lucy Jackson (f, wlw, Out-boxer, orthodox, age 21, pot 84, 8-2, frame [168, 170], plan speed/technique/defense, chin 66, night 58.4; read safe 0.96 risky 0.79 at the offer, 0.97 / 0.84 8 weeks on)
- 1 Kira Mensah (f, wfw, Out-boxer, orthodox, age 18, pot 86, 9-1, frame [163, 168], plan speed/conditioning, chin 52, night 57.2; read safe 0.92 risky 0.71 at the offer, 0.95 / 0.77 8 weeks on)
- 2 Samira Khan (f, www, Slugger, orthodox, age 18, pot 82, 7-3, frame [172, 171], plan power/defense, chin 63, night 55.5; read safe 0.71 risky 0.38 at the offer, 0.76 / 0.44 8 weeks on)
- 3 Tess Reilly (f, wmw, Pressure fighter, southpaw, age 23, pot 76, 9-4, frame [176, 178], plan conditioning/power, chin 67, night 58.0; read safe 0.83 risky 0.52 at the offer, 0.85 / 0.55 8 weeks on)
- 4 Danny Osei (m, mlw, Boxer-puncher, orthodox, age 20, pot 85, 8-1, frame [173, 176], plan technique/speed, chin 62, night 57.4; read safe 0.92 risky 0.68 at the offer, 0.95 / 0.77 8 weeks on)
- 5 Josh Harper (m, mww, Pressure fighter, southpaw, age 23, pot 79, 7-2, frame [178, 182], plan conditioning/power, chin 64, night 56.9; read safe 0.83 risky 0.52 at the offer, 0.85 / 0.55 8 weeks on)
- 6 Nell Ward (f, wlm, Counter-puncher, southpaw, age 27, pot 72, 10-3, frame [174, 177], plan fight_iq/defense, chin 60, night 61.5; read safe 0.99 risky 0.91 at the offer, 0.99 / 0.91 8 weeks on)
- 7 Reece Doyle (m, mfw, Out-boxer, orthodox, age 19, pot 90, 7-1, frame [167, 172], plan technique/defense, chin 58, night 54.7; read safe 0.85 risky 0.54 at the offer, 0.91 / 0.65 8 weeks on)
- 8 Bayo Adams (m, mmw, Slugger, orthodox, age 29, pot 70, 9-2, frame [182, 185], plan power, chin 70, night 56.7; read safe 0.84 risky 0.48 at the offer, 0.85 / 0.50 8 weeks on)
- 9 Kai Turner (m, mlm, Volume puncher, orthodox, age 22, pot 80, 8-3, frame [175, 175], plan conditioning/speed, chin 55, night 58.7; read safe 0.86 risky 0.56 at the offer, 0.90 / 0.64 8 weeks on)

Pools: women SAFE 43 / RISKY 49.65 (middle boxer Tess Reilly); men SAFE 43.85 / RISKY 50.95 (Josh Harper).
Same dice stream for every arm of a type. 2,000 careers per type per arm = 100,000 careers.

## Feedback loops (the brief's checks)

| Arm | Mean score (10 types) | Boxer gone | Safe / risky a career | Hunger after fights 1-6 (mean of types) | Fight 6: printed less the same bout at confidence 50 (max) | Longest losing run |
|---|---|---|---|---|---|---|
| ALWAYS SAFE | 97.4 | 0.0% | 6.00 / 0.00 | 61 / 52 / 43 / 34 / 24 / 15 | 5.0 points | 6 |
| ALWAYS RISKY | 83.3 | 0.0% | 0.00 / 6.00 | 78 / 86 / 94 / 98 / 99 / 100 | 5.0 points | 6 |
| ALWAYS WAIT | 22.9 | 71.3% | 6.00 / 0.00 | 31 / 22 / 13 / 3 / 1 / 0 | 5.0 points | 5 |
| TURN NOW + ALTERNATE | 92.4 | 0.0% | 3.00 / 3.00 | 61 / 69 / 60 / 68 / 59 / 67 | 5.0 points | 6 |
| READER | 97.7 | 0.0% | 5.38 / 0.62 | 58 / 49 / 40 / 33 / 28 / 24 | 5.0 points | 6 |

- Confidence -> chance -> wins -> confidence: fight 6's printed chance is never more than 5.0 points from the same bout at
  confidence 50 (max shown above). Capped.
- KO loss -> confidence -30 -> next loss: the longest losing run is in the table (ALWAYS RISKY, as expected). A KO in
  fights 1-3 costs fights 4-6 about 2.9 points of win rate. Capped by the same 5 points.
- Hunger -> leaves: one-way sink. Hunger after each fight per arm is above. Only ALWAYS WAIT reaches 0 inside six fights.
- Name -> chances: no path. The two men are fixed by division and fight number, never by the name.
- Purse -> cash: no rule reads cash back.

## Reader against the best habit, per type

| Boxer | Best arm | Reader | Best habit | Reader less best habit | 2 SE | Reader says Not yet |
|---|---|---|---|---|---|---|
| Lucy Jackson | READER | 101.96 | ALWAYS SAFE 101.89 | +0.07 | 1.10 | 0 |
| Kira Mensah | ALWAYS SAFE | 101.24 | ALWAYS SAFE 101.34 | -0.10 | 1.11 | 0 |
| Samira Khan | READER | 86.98 | ALWAYS SAFE 86.28 | +0.70 | 1.60 | 0 |
| Tess Reilly | READER | 93.72 | ALWAYS SAFE 93.48 | +0.24 | 1.54 | 0 |
| Danny Osei | READER | 102.01 | ALWAYS SAFE 101.97 | +0.04 | 1.07 | 0 |
| Josh Harper | READER | 94.76 | ALWAYS SAFE 94.46 | +0.30 | 1.56 | 0 |
| Nell Ward | ALWAYS SAFE | 101.50 | ALWAYS SAFE 101.51 | -0.01 | 1.06 | 0 |
| Reece Doyle | READER | 101.35 | ALWAYS SAFE 100.57 | +0.78 | 1.12 | 1 |
| Bayo Adams | READER | 92.05 | ALWAYS SAFE 91.99 | +0.06 | 1.36 | 0 |
| Kai Turner | READER | 101.39 | ALWAYS SAFE 100.64 | +0.75 | 1.12 | 1 |

## Every type x arm (2,000 careers each; score parts printed apart)

| Boxer | Arm | Score (± SE) | kept | wins | losses | name | conf | gym $ pts | Pro W - L (KO) | Gone | Safe / risky | Not yet | Confidence end | Hunger after fights 1-6 | Gym cut $ | Purse $ | Longest losing run |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | ALWAYS SAFE | 101.89 ± 0.39 | 1 | 54.46 | -2.77 | 10.89 | 2.64 | 36.68 | 5.45 - 0.55 (0.16) | 0.0% | 6 / 0 | 0 | 63.2 | 60.7 / 51.4 / 42.1 / 32.8 / 23.4 / 13.9 | 3668 | 14672 | 4 |
| Lucy Jackson | ALWAYS RISKY | 86.43 ± 0.86 | 1 | 32.88 | -13.56 | 19.73 | -1 | 48.39 | 3.29 - 2.71 (1.1) | 0.0% | 0 / 6 | 0 | 45 | 78.3 / 86.6 / 94.6 / 98.2 / 99.4 / 99.8 | 4839 | 19352 | 6 |
| Lucy Jackson | ALWAYS WAIT | 19.97 ± 0.81 | 0.243 | 11.05 | -1.75 | 2.21 | 0.02 | 8.43 | 5.45 - 0.55 (0.16) | 75.7% | 6 / 0 | 2 | 63.2 | 30.7 / 21.4 / 12.1 / 2.8 / 0.5 / 0.1 | 3668 | 14672 | 4 |
| Lucy Jackson | TURN NOW + ALTERNATE | 96.40 ± 0.66 | 1 | 43.67 | -8.17 | 15.38 | 0.67 | 44.85 | 4.37 - 1.63 (0.63) | 0.0% | 3 / 3 | 0 | 53.3 | 60.8 / 68.9 / 59.6 / 67.7 / 58.5 / 66.7 | 4485 | 17941 | 6 |
| Lucy Jackson | READER | 101.96 ± 0.39 | 1 | 54.46 | -2.77 | 10.92 | 2.65 | 36.71 | 5.45 - 0.55 (0.16) | 0.0% | 5.99 / 0.01 | 0 | 63.2 | 60.7 / 51.4 / 42.1 / 32.7 / 23.4 / 14.1 | 3671 | 14685 | 4 |
| Kira Mensah | ALWAYS SAFE | 101.34 ± 0.39 | 1 | 54.28 | -2.86 | 10.86 | 2.42 | 36.65 | 5.43 - 0.57 (0.2) | 0.0% | 6 / 0 | 0 | 62.1 | 60.7 / 51.4 / 42 / 32.5 / 23.2 / 13.7 | 3665 | 14659 | 4 |
| Kira Mensah | ALWAYS RISKY | 85.14 ± 0.88 | 1 | 32.58 | -13.71 | 19.55 | -1.56 | 48.28 | 3.26 - 2.74 (1.31) | 0.0% | 0 / 6 | 0 | 42.2 | 77.9 / 85.7 / 93.5 / 97.4 / 99 / 99.7 | 4828 | 19305 | 6 |
| Kira Mensah | ALWAYS WAIT | 18.34 ± 0.78 | 0.226 | 10.2 | -1.68 | 2.04 | -0.03 | 7.81 | 5.43 - 0.57 (0.2) | 77.4% | 6 / 0 | 2 | 62.1 | 30.7 / 21.4 / 11.9 / 2.5 / 0.4 / 0.1 | 3665 | 14659 | 4 |
| Kira Mensah | TURN NOW + ALTERNATE | 95.64 ± 0.66 | 1 | 43.51 | -8.24 | 15.33 | 0.22 | 44.83 | 4.35 - 1.65 (0.74) | 0.0% | 3 / 3 | 0 | 51.1 | 60.7 / 68.7 / 59.3 / 67.2 / 57.8 / 65.6 | 4483 | 17931 | 5 |
| Kira Mensah | READER | 101.24 ± 0.39 | 1 | 54.24 | -2.88 | 10.85 | 2.4 | 36.64 | 5.42 - 0.58 (0.21) | 0.0% | 6 / 0 | 0 | 62 | 60.7 / 51.4 / 42 / 32.5 / 23.2 / 13.7 | 3664 | 14656 | 4 |
| Samira Khan | ALWAYS SAFE | 86.28 ± 0.53 | 1 | 47.75 | -6.13 | 9.55 | -0.01 | 35.12 | 4.77 - 1.23 (0.38) | 0.0% | 6 / 0 | 0 | 50 | 61.7 / 53.5 / 45.1 / 36.5 / 27.6 / 18.4 | 3512 | 14049 | 4 |
| Samira Khan | ALWAYS RISKY | 72.13 ± 0.85 | 1 | 28.3 | -15.85 | 16.98 | -2.92 | 45.63 | 2.83 - 3.17 (1.25) | 0.0% | 0 / 6 | 0 | 35.4 | 77.6 / 85.4 / 93.2 / 97.7 / 99.4 / 99.8 | 4563 | 18246 | 6 |
| Samira Khan | ALWAYS WAIT | 33.81 ± 0.90 | 0.443 | 19.12 | -3.71 | 3.82 | -0.41 | 14.98 | 4.97 - 1.03 (0.33) | 55.8% | 6 / 0 | 2 | 53.4 | 31.6 / 23.1 / 14.3 / 5.4 / 1.3 / 0.3 | 3549 | 14194 | 4 |
| Samira Khan | TURN NOW + ALTERNATE | 81.99 ± 0.70 | 1 | 38.24 | -10.88 | 13.51 | -1.54 | 42.66 | 3.82 - 2.18 (0.8) | 0.0% | 3 / 3 | 0 | 42.3 | 61.7 / 69.4 / 61 / 69.1 / 60.2 / 68.4 | 4266 | 17063 | 6 |
| Samira Khan | READER | 86.98 ± 0.60 | 1 | 43.89 | -8.05 | 11.59 | -0.55 | 40.1 | 4.39 - 1.61 (0.53) | 0.0% | 4.7 / 1.3 | 0 | 47.3 | 61.7 / 53.4 / 44.9 / 43.7 / 38.3 / 40.8 | 4010 | 16040 | 5 |
| Tess Reilly | ALWAYS SAFE | 93.48 ± 0.46 | 1 | 50.78 | -4.61 | 10.16 | 1.12 | 36.03 | 5.08 - 0.92 (0.29) | 0.0% | 6 / 0 | 0 | 55.6 | 61.1 / 52.3 / 43.4 / 34.5 / 25.5 / 16.3 | 3603 | 14414 | 5 |
| Tess Reilly | ALWAYS RISKY | 83.39 ± 0.86 | 1 | 31.89 | -14.06 | 19.13 | -1.49 | 47.93 | 3.19 - 2.81 (1.14) | 0.0% | 0 / 6 | 0 | 42.5 | 78 / 86 / 94.1 / 97.9 / 99.4 / 99.8 | 4793 | 19166 | 6 |
| Tess Reilly | ALWAYS WAIT | 26.04 ± 0.86 | 0.33 | 14.53 | -2.62 | 2.91 | -0.15 | 11.38 | 5.18 - 0.82 (0.27) | 67.1% | 6 / 0 | 2 | 57.5 | 30.9 / 21.9 / 12.9 / 3.8 / 0.9 / 0.2 | 3625 | 14501 | 4 |
| Tess Reilly | TURN NOW + ALTERNATE | 91.06 ± 0.67 | 1 | 41.58 | -9.21 | 14.85 | -0.16 | 44.01 | 4.16 - 1.84 (0.71) | 0.0% | 3 / 3 | 0 | 49.2 | 61.1 / 69.2 / 60.4 / 68.4 / 59.4 / 67.7 | 4401 | 17604 | 6 |
| Tess Reilly | READER | 93.72 ± 0.62 | 1 | 43.17 | -8.42 | 13.97 | -0.04 | 45.05 | 4.32 - 1.68 (0.61) | 0.0% | 3.57 / 2.43 | 0 | 49.8 | 61.3 / 52.5 / 43.5 / 44.6 / 50.6 / 58.3 | 4505 | 18018 | 4 |
| Danny Osei | ALWAYS SAFE | 101.97 ± 0.38 | 1 | 54.49 | -2.75 | 10.9 | 2.64 | 36.7 | 5.45 - 0.55 (0.16) | 0.0% | 6 / 0 | 0 | 63.2 | 60.7 / 51.4 / 42 / 32.6 / 23.4 / 13.9 | 3670 | 14681 | 5 |
| Danny Osei | ALWAYS RISKY | 87.12 ± 0.88 | 1 | 33.1 | -13.45 | 19.86 | -0.74 | 48.36 | 3.31 - 2.69 (1.06) | 0.0% | 0 / 6 | 0 | 46.3 | 78.1 / 86.3 / 94.6 / 98.1 / 99.4 / 99.8 | 4836 | 19339 | 6 |
| Danny Osei | ALWAYS WAIT | 19.39 ± 0.80 | 0.235 | 10.72 | -1.7 | 2.14 | 0.04 | 8.19 | 5.45 - 0.55 (0.16) | 76.4% | 6 / 0 | 2 | 63.2 | 30.7 / 21.4 / 12 / 2.6 / 0.5 / 0.1 | 3670 | 14681 | 5 |
| Danny Osei | TURN NOW + ALTERNATE | 96.39 ± 0.66 | 1 | 43.71 | -8.14 | 15.36 | 0.64 | 44.83 | 4.37 - 1.63 (0.63) | 0.0% | 3 / 3 | 0 | 53.2 | 60.7 / 68.9 / 59.6 / 67.7 / 58.4 / 66.5 | 4483 | 17930 | 5 |
| Danny Osei | READER | 102.01 ± 0.38 | 1 | 54.49 | -2.75 | 10.9 | 2.65 | 36.73 | 5.45 - 0.55 (0.16) | 0.0% | 6 / 0 | 0 | 63.2 | 60.7 / 51.4 / 41.9 / 32.6 / 23.3 / 14 | 3673 | 14691 | 5 |
| Josh Harper | ALWAYS SAFE | 94.46 ± 0.47 | 1 | 51.2 | -4.4 | 10.24 | 1.3 | 36.12 | 5.12 - 0.88 (0.28) | 0.0% | 6 / 0 | 0 | 56.5 | 61.1 / 52.2 / 43.2 / 34.2 / 25.1 / 16.1 | 3612 | 14448 | 4 |
| Josh Harper | ALWAYS RISKY | 86.20 ± 0.86 | 1 | 32.85 | -13.57 | 19.71 | -0.93 | 48.13 | 3.29 - 2.71 (1.08) | 0.0% | 0 / 6 | 0 | 45.4 | 78.1 / 86.3 / 94.5 / 98.3 / 99.4 / 99.9 | 4813 | 19244 | 6 |
| Josh Harper | ALWAYS WAIT | 25.25 ± 0.84 | 0.324 | 14.16 | -2.64 | 2.83 | -0.21 | 11.11 | 5.19 - 0.81 (0.26) | 67.6% | 6 / 0 | 2 | 57.8 | 31.1 / 22.1 / 13 / 3.8 / 0.9 / 0.2 | 3619 | 14477 | 4 |
| Josh Harper | TURN NOW + ALTERNATE | 91.19 ± 0.68 | 1 | 41.64 | -9.18 | 14.8 | -0.12 | 44.05 | 4.16 - 1.84 (0.69) | 0.0% | 3 / 3 | 0 | 49.4 | 61.2 / 69.3 / 60.3 / 68.4 / 59.4 / 67.6 | 4405 | 17619 | 5 |
| Josh Harper | READER | 94.76 ± 0.62 | 1 | 43.51 | -8.24 | 14.18 | 0.12 | 45.19 | 4.35 - 1.65 (0.61) | 0.0% | 3.56 / 2.44 | 0 | 50.6 | 61.1 / 52.2 / 43.3 / 44.8 / 50.9 / 58.5 | 4519 | 18077 | 5 |
| Nell Ward | ALWAYS SAFE | 101.51 ± 0.38 | 1 | 54.31 | -2.84 | 10.86 | 2.54 | 36.65 | 5.43 - 0.57 (0.17) | 0.0% | 6 / 0 | 0 | 62.7 | 60.7 / 51.3 / 42 / 32.8 / 23.4 / 14 | 3665 | 14660 | 5 |
| Nell Ward | ALWAYS RISKY | 86.75 ± 0.86 | 1 | 32.99 | -13.5 | 19.79 | -0.99 | 48.45 | 3.3 - 2.7 (1.09) | 0.0% | 0 / 6 | 0 | 45.1 | 78.2 / 86.5 / 94.7 / 98.3 / 99.5 / 99.8 | 4845 | 19375 | 6 |
| Nell Ward | ALWAYS WAIT | 20.32 ± 0.82 | 0.244 | 11.21 | -1.7 | 2.24 | 0.08 | 8.49 | 5.43 - 0.57 (0.17) | 75.6% | 6 / 0 | 2 | 62.7 | 30.7 / 21.3 / 12 / 2.8 / 0.5 / 0.1 | 3665 | 14660 | 5 |
| Nell Ward | TURN NOW + ALTERNATE | 96.55 ± 0.64 | 1 | 43.72 | -8.14 | 15.42 | 0.69 | 44.86 | 4.37 - 1.63 (0.62) | 0.0% | 3 / 3 | 0 | 53.4 | 60.7 / 69 / 59.7 / 67.9 / 58.6 / 66.8 | 4486 | 17942 | 5 |
| Nell Ward | READER | 101.50 ± 0.37 | 1 | 54.28 | -2.86 | 10.87 | 2.52 | 36.69 | 5.43 - 0.57 (0.17) | 0.0% | 5.99 / 0.01 | 0 | 62.6 | 60.7 / 51.3 / 42 / 32.7 / 23.4 / 14.1 | 3669 | 14678 | 5 |
| Reece Doyle | ALWAYS SAFE | 100.57 ± 0.40 | 1 | 53.96 | -3.02 | 10.79 | 2.37 | 36.48 | 5.4 - 0.6 (0.2) | 0.0% | 6 / 0 | 0 | 61.8 | 61 / 51.7 / 42.3 / 33 / 23.5 / 14.1 | 3648 | 14591 | 4 |
| Reece Doyle | ALWAYS RISKY | 85.50 ± 0.88 | 1 | 32.63 | -13.69 | 19.58 | -1.21 | 48.2 | 3.26 - 2.74 (1.15) | 0.0% | 0 / 6 | 0 | 43.9 | 77.9 / 86 / 94.2 / 98 / 99.3 / 99.8 | 4820 | 19272 | 6 |
| Reece Doyle | ALWAYS WAIT | 18.85 ± 0.79 | 0.231 | 10.45 | -1.69 | 2.09 | 0.02 | 7.99 | 5.44 - 0.56 (0.18) | 77.0% | 6 / 0 | 2 | 62.7 | 30.7 / 21.4 / 12 / 2.7 / 0.5 / 0.1 | 3667 | 14666 | 5 |
| Reece Doyle | TURN NOW + ALTERNATE | 94.03 ± 0.66 | 1 | 42.83 | -8.59 | 15.18 | 0.21 | 44.39 | 4.28 - 1.72 (0.69) | 0.0% | 3 / 3 | 0 | 51.1 | 61.1 / 69.1 / 60 / 68 / 58.6 / 66.8 | 4439 | 17754 | 6 |
| Reece Doyle | READER | 101.35 ± 0.39 | 1 | 54.24 | -2.88 | 10.86 | 2.5 | 36.63 | 5.42 - 0.58 (0.18) | 0.0% | 6 / 0.01 | 1 | 62.5 | 45.7 / 36.5 / 27.1 / 17.8 / 8.5 / 2.4 | 3663 | 14650 | 5 |
| Bayo Adams | ALWAYS SAFE | 91.99 ± 0.48 | 1 | 50.05 | -4.97 | 10.01 | 0.89 | 36.01 | 5.01 - 1 (0.3) | 0.0% | 6 / 0 | 0 | 54.5 | 61.2 / 52.3 / 43.5 / 34.6 / 25.8 / 17 | 3601 | 14404 | 6 |
| Bayo Adams | ALWAYS RISKY | 74.45 ± 0.86 | 1 | 28.83 | -15.59 | 17.3 | -2.77 | 46.69 | 2.88 - 3.12 (1.25) | 0.0% | 0 / 6 | 0 | 36.2 | 77.8 / 85.8 / 93.6 / 97.7 / 99.2 / 99.8 | 4669 | 18668 | 6 |
| Bayo Adams | ALWAYS WAIT | 27.54 ± 0.86 | 0.361 | 15.47 | -3.1 | 3.09 | -0.35 | 12.43 | 5.05 - 0.95 (0.28) | 63.9% | 6 / 0 | 2 | 55.3 | 31.1 / 22.1 / 13.2 / 4.3 / 1.2 / 0.3 | 3617 | 14469 | 4 |
| Bayo Adams | TURN NOW + ALTERNATE | 85.97 ± 0.67 | 1 | 39.6 | -10.2 | 13.74 | -1.05 | 43.87 | 3.96 - 2.04 (0.74) | 0.0% | 3 / 3 | 0 | 44.7 | 61.1 / 69.2 / 60.4 / 68.4 / 59.7 / 67.6 | 4387 | 17548 | 6 |
| Bayo Adams | READER | 92.05 ± 0.48 | 1 | 50.05 | -4.97 | 10.03 | 0.9 | 36.05 | 5.01 - 1 (0.3) | 0.0% | 5.99 / 0.01 | 0 | 54.5 | 61.2 / 52.3 / 43.4 / 34.6 / 25.9 / 17.1 | 3605 | 14419 | 6 |
| Kai Turner | ALWAYS SAFE | 100.64 ± 0.40 | 1 | 53.97 | -3.01 | 10.79 | 2.34 | 36.55 | 5.4 - 0.6 (0.2) | 0.0% | 6 / 0 | 0 | 61.7 | 60.8 / 51.5 / 42.1 / 32.7 / 23.4 / 14 | 3655 | 14621 | 4 |
| Kai Turner | ALWAYS RISKY | 85.86 ± 0.85 | 1 | 32.79 | -13.6 | 19.67 | -1.36 | 48.36 | 3.28 - 2.72 (1.22) | 0.0% | 0 / 6 | 0 | 43.2 | 77.9 / 85.9 / 93.9 / 97.7 / 99.2 / 99.8 | 4836 | 19337 | 6 |
| Kai Turner | ALWAYS WAIT | 19.17 ± 0.80 | 0.231 | 10.59 | -1.63 | 2.12 | 0.06 | 8.03 | 5.44 - 0.56 (0.19) | 76.9% | 6 / 0 | 2 | 62.7 | 30.7 / 21.3 / 12 / 2.6 / 0.4 / 0.1 | 3668 | 14673 | 4 |
| Kai Turner | TURN NOW + ALTERNATE | 95.01 ± 0.67 | 1 | 43.22 | -8.39 | 15.3 | 0.3 | 44.58 | 4.32 - 1.68 (0.71) | 0.0% | 3 / 3 | 0 | 51.5 | 60.9 / 68.9 / 59.6 / 67.6 / 58.3 / 66.3 | 4458 | 17829 | 5 |
| Kai Turner | READER | 101.39 ± 0.39 | 1 | 54.26 | -2.87 | 10.86 | 2.47 | 36.67 | 5.43 - 0.57 (0.19) | 0.0% | 5.99 / 0.01 | 1 | 62.4 | 45.8 / 36.4 / 26.9 / 17.6 / 8.2 / 2.3 | 3667 | 14666 | 3 |

## The one-rep trial (tuned numbers; one career per type per arm, printed in full)

STOP checks: no bar left 0-100 (both stop at their ends); every arm loses a fight (losses in the trial by arm:
ALWAYS SAFE 6, ALWAYS RISKY 26, ALWAYS WAIT 6, TURN NOW + ALTERNATE 18, READER 7); the types did not all land on the same arm in
one rep. The first trial (before the score fix) tripped the convergence STOP, see "What was decided" 1.

| Boxer | Arm | Score | W - L (KO) | Not yet | Gone | Fights (bout, printed chance, result, confidence, hunger) |
|---|---|---|---|---|---|---|
| Lucy Jackson | ALWAYS SAFE | 114.3 | 6 - 0 (0) | 0 | no | safe 0.90 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 win c70 h20; safe 0.92 win c74 h10 |
| Lucy Jackson | ALWAYS RISKY | 162.3 | 6 - 0 (0) | 0 | no | risky 0.55 win c62 h80; risky 0.56 win c74 h90; risky 0.57 win c86 h100; risky 0.59 win c98 h100; risky 0.60 win c100 h100; risky 0.60 win c100 h100 |
| Lucy Jackson | ALWAYS WAIT | 0.0 | 6 - 0 (0) | 2 | yes | safe 0.90 win c54 h30; safe 0.90 win c58 h20; safe 0.91 win c62 h10; safe 0.91 win c66 h0; safe 0.92 win c70 h0; safe 0.92 win c74 h0 |
| Lucy Jackson | TURN NOW + ALTERNATE | 141.1 | 6 - 0 (0) | 0 | no | safe 0.90 win c54 h60; risky 0.55 win c66 h70; safe 0.92 win c70 h60; risky 0.57 win c82 h70; safe 0.93 win c86 h60; risky 0.59 win c98 h70 |
| Lucy Jackson | READER | 114.3 | 6 - 0 (0) | 0 | no | safe 0.90 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 win c70 h20; safe 0.92 win c74 h10 |
| Kira Mensah | ALWAYS SAFE | 114.3 | 6 - 0 (0) | 0 | no | safe 0.90 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 win c70 h20; safe 0.92 win c74 h10 |
| Kira Mensah | ALWAYS RISKY | 162.3 | 6 - 0 (0) | 0 | no | risky 0.55 win c62 h80; risky 0.56 win c74 h90; risky 0.57 win c86 h100; risky 0.59 win c98 h100; risky 0.60 win c100 h100; risky 0.60 win c100 h100 |
| Kira Mensah | ALWAYS WAIT | 0.0 | 6 - 0 (0) | 2 | yes | safe 0.90 win c54 h30; safe 0.90 win c58 h20; safe 0.91 win c62 h10; safe 0.91 win c66 h0; safe 0.92 win c70 h0; safe 0.92 win c74 h0 |
| Kira Mensah | TURN NOW + ALTERNATE | 141.1 | 6 - 0 (0) | 0 | no | safe 0.90 win c54 h60; risky 0.55 win c66 h70; safe 0.92 win c70 h60; risky 0.57 win c82 h70; safe 0.93 win c86 h60; risky 0.59 win c98 h70 |
| Kira Mensah | READER | 114.3 | 6 - 0 (0) | 0 | no | safe 0.90 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 win c70 h20; safe 0.92 win c74 h10 |
| Samira Khan | ALWAYS SAFE | 71.0 | 4 - 2 (0) | 0 | no | safe 0.75 win c54 h60; safe 0.75 points c44 h60; safe 0.77 win c48 h50; safe 0.81 points c38 h50; safe 0.82 win c42 h40; safe 0.84 win c46 h30 |
| Samira Khan | ALWAYS RISKY | 16.6 | 1 - 5 (3) | 0 | no | risky 0.40 points c40 h80; risky 0.41 ko c10 h80; risky 0.47 points c0 h90; risky 0.49 ko c0 h90; risky 0.50 win c12 h100; risky 0.51 ko c0 h100 |
| Samira Khan | ALWAYS WAIT | 71.0 | 4 - 2 (0) | 2 | no | safe 0.76 win c54 h30; safe 0.79 points c44 h30; safe 0.81 win c48 h20; safe 0.84 points c38 h20; safe 0.85 win c42 h10; safe 0.89 win c46 h0 |
| Samira Khan | TURN NOW + ALTERNATE | 85.9 | 4 - 2 (0) | 0 | no | safe 0.75 win c54 h60; risky 0.43 points c44 h70; safe 0.77 win c48 h60; risky 0.49 points c38 h70; safe 0.82 win c42 h60; risky 0.54 win c54 h70 |
| Samira Khan | READER | 80.3 | 4 - 2 (0) | 0 | no | safe 0.75 win c54 h60; safe 0.75 points c44 h60; safe 0.77 win c48 h50; safe 0.81 points c38 h50; safe 0.82 win c42 h40; risky 0.54 win c54 h50 |
| Tess Reilly | ALWAYS SAFE | 94.5 | 5 - 1 (0) | 0 | no | safe 0.83 win c54 h60; safe 0.84 win c58 h50; safe 0.85 win c62 h40; safe 0.86 points c52 h40; safe 0.85 win c56 h30; safe 0.87 win c60 h20 |
| Tess Reilly | ALWAYS RISKY | 24.1 | 1 - 5 (1) | 0 | no | risky 0.52 win c62 h80; risky 0.54 points c52 h90; risky 0.54 points c42 h100; risky 0.54 points c32 h100; risky 0.52 points c22 h100; risky 0.52 ko c0 h100 |
| Tess Reilly | ALWAYS WAIT | 94.5 | 5 - 1 (0) | 2 | no | safe 0.85 win c54 h30; safe 0.86 win c58 h20; safe 0.86 win c62 h10; safe 0.87 points c52 h10; safe 0.87 win c56 h0; safe 0.87 win c60 h0 |
| Tess Reilly | TURN NOW + ALTERNATE | 61.1 | 3 - 3 (0) | 0 | no | safe 0.83 win c54 h60; risky 0.54 points c44 h70; safe 0.84 points c34 h70; risky 0.53 points c24 h80; safe 0.82 win c28 h70; risky 0.53 win c40 h80 |
| Tess Reilly | READER | 91.5 | 4 - 2 (0) | 0 | no | safe 0.83 win c54 h60; safe 0.84 win c58 h50; safe 0.85 win c62 h40; risky 0.56 points c52 h50; risky 0.54 points c42 h60; risky 0.54 win c54 h70 |
| Danny Osei | ALWAYS SAFE | 114.3 | 6 - 0 (0) | 0 | no | safe 0.90 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 win c70 h20; safe 0.92 win c74 h10 |
| Danny Osei | ALWAYS RISKY | 72.8 | 3 - 3 (2) | 0 | no | risky 0.55 win c62 h80; risky 0.56 ko c32 h80; risky 0.53 points c22 h90; risky 0.52 ko c0 h90; risky 0.50 win c12 h100; risky 0.51 win c24 h100 |
| Danny Osei | ALWAYS WAIT | 0.0 | 6 - 0 (0) | 2 | yes | safe 0.90 win c54 h30; safe 0.90 win c58 h20; safe 0.91 win c62 h10; safe 0.91 win c66 h0; safe 0.92 win c70 h0; safe 0.92 win c74 h0 |
| Danny Osei | TURN NOW + ALTERNATE | 108.6 | 5 - 1 (1) | 0 | no | safe 0.90 win c54 h60; risky 0.55 ko c24 h60; safe 0.87 win c28 h50; risky 0.53 win c40 h60; safe 0.89 win c44 h50; risky 0.54 win c56 h60 |
| Danny Osei | READER | 114.3 | 6 - 0 (0) | 0 | no | safe 0.90 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 win c70 h20; safe 0.92 win c74 h10 |
| Josh Harper | ALWAYS SAFE | 70.7 | 4 - 2 (1) | 0 | no | safe 0.83 win c54 h60; safe 0.85 win c58 h50; safe 0.86 win c62 h40; safe 0.86 points c52 h40; safe 0.86 win c56 h30; safe 0.86 ko c26 h20 |
| Josh Harper | ALWAYS RISKY | 111.9 | 4 - 2 (1) | 0 | no | risky 0.52 win c62 h80; risky 0.55 win c74 h90; risky 0.57 win c86 h100; risky 0.59 points c76 h100; risky 0.58 win c88 h100; risky 0.59 ko c58 h100 |
| Josh Harper | ALWAYS WAIT | 70.7 | 4 - 2 (1) | 2 | no | safe 0.85 win c54 h30; safe 0.87 win c58 h20; safe 0.87 win c62 h10; safe 0.88 points c52 h10; safe 0.87 win c56 h0; safe 0.87 ko c26 h0 |
| Josh Harper | TURN NOW + ALTERNATE | 86.3 | 4 - 2 (1) | 0 | no | safe 0.83 win c54 h60; risky 0.54 win c66 h70; safe 0.86 win c70 h60; risky 0.57 points c60 h70; safe 0.87 win c64 h60; risky 0.56 ko c34 h60 |
| Josh Harper | READER | 87.5 | 4 - 2 (1) | 0 | no | safe 0.83 win c54 h60; safe 0.85 win c58 h50; safe 0.86 win c62 h40; risky 0.56 points c52 h50; risky 0.55 win c64 h60; risky 0.56 ko c34 h60 |
| Nell Ward | ALWAYS SAFE | 90.5 | 5 - 1 (1) | 0 | no | safe 0.90 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 ko c36 h20; safe 0.89 win c40 h10 |
| Nell Ward | ALWAYS RISKY | 42.5 | 2 - 4 (1) | 0 | no | risky 0.55 points c40 h80; risky 0.54 points c30 h90; risky 0.53 ko c0 h90; risky 0.50 points c0 h100; risky 0.50 win c12 h100; risky 0.51 win c24 h100 |
| Nell Ward | ALWAYS WAIT | 0.0 | 5 - 1 (1) | 2 | yes | safe 0.90 win c54 h30; safe 0.90 win c58 h20; safe 0.91 win c62 h10; safe 0.91 win c66 h0; safe 0.92 ko c36 h0; safe 0.89 win c40 h0 |
| Nell Ward | TURN NOW + ALTERNATE | 54.1 | 3 - 3 (2) | 0 | no | safe 0.90 win c54 h60; risky 0.55 points c44 h70; safe 0.89 win c48 h60; risky 0.55 ko c18 h60; safe 0.87 win c22 h50; risky 0.52 ko c0 h50 |
| Nell Ward | READER | 90.5 | 5 - 1 (1) | 0 | no | safe 0.90 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 ko c36 h20; safe 0.89 win c40 h10 |
| Reece Doyle | ALWAYS SAFE | 114.3 | 6 - 0 (0) | 0 | no | safe 0.85 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 win c70 h20; safe 0.92 win c74 h10 |
| Reece Doyle | ALWAYS RISKY | 83.0 | 3 - 3 (0) | 0 | no | risky 0.54 win c62 h80; risky 0.56 points c52 h90; risky 0.55 win c64 h100; risky 0.56 points c54 h100; risky 0.55 points c44 h100; risky 0.54 win c56 h100 |
| Reece Doyle | ALWAYS WAIT | 0.0 | 6 - 0 (0) | 2 | yes | safe 0.90 win c54 h30; safe 0.90 win c58 h20; safe 0.91 win c62 h10; safe 0.91 win c66 h0; safe 0.92 win c70 h0; safe 0.92 win c74 h0 |
| Reece Doyle | TURN NOW + ALTERNATE | 56.5 | 3 - 3 (1) | 0 | no | safe 0.85 win c54 h60; risky 0.55 points c44 h70; safe 0.89 win c48 h60; risky 0.55 points c38 h70; safe 0.89 win c42 h60; risky 0.54 ko c12 h60 |
| Reece Doyle | READER | 114.3 | 6 - 0 (0) | 1 | no | safe 0.88 win c54 h45; safe 0.90 win c58 h35; safe 0.91 win c62 h25; safe 0.91 win c66 h15; safe 0.92 win c70 h5; safe 0.92 win c74 h0 |
| Bayo Adams | ALWAYS SAFE | 114.3 | 6 - 0 (0) | 0 | no | safe 0.84 win c54 h60; safe 0.84 win c58 h50; safe 0.84 win c62 h40; safe 0.84 win c66 h30; safe 0.85 win c70 h20; safe 0.85 win c74 h10 |
| Bayo Adams | ALWAYS RISKY | 139.4 | 5 - 1 (0) | 0 | no | risky 0.48 win c62 h80; risky 0.49 win c74 h90; risky 0.51 points c64 h100; risky 0.50 win c76 h100; risky 0.51 win c88 h100; risky 0.52 win c100 h100 |
| Bayo Adams | ALWAYS WAIT | 0.0 | 6 - 0 (0) | 2 | yes | safe 0.85 win c54 h30; safe 0.85 win c58 h20; safe 0.85 win c62 h10; safe 0.85 win c66 h0; safe 0.85 win c70 h0; safe 0.85 win c74 h0 |
| Bayo Adams | TURN NOW + ALTERNATE | 111.7 | 5 - 1 (1) | 0 | no | safe 0.84 win c54 h60; risky 0.49 win c66 h70; safe 0.85 win c70 h60; risky 0.50 ko c40 h60; safe 0.83 win c44 h50; risky 0.49 win c56 h60 |
| Bayo Adams | READER | 114.3 | 6 - 0 (0) | 0 | no | safe 0.84 win c54 h60; safe 0.84 win c58 h50; safe 0.84 win c62 h40; safe 0.84 win c66 h30; safe 0.85 win c70 h20; safe 0.85 win c74 h10 |
| Kai Turner | ALWAYS SAFE | 114.3 | 6 - 0 (0) | 0 | no | safe 0.86 win c54 h60; safe 0.90 win c58 h50; safe 0.91 win c62 h40; safe 0.91 win c66 h30; safe 0.92 win c70 h20; safe 0.92 win c74 h10 |
| Kai Turner | ALWAYS RISKY | 72.3 | 3 - 3 (3) | 0 | no | risky 0.55 win c62 h80; risky 0.56 ko c32 h80; risky 0.53 ko c2 h80; risky 0.50 win c14 h90; risky 0.51 ko c0 h90; risky 0.50 win c12 h100 |
| Kai Turner | ALWAYS WAIT | 0.0 | 6 - 0 (0) | 2 | yes | safe 0.90 win c54 h30; safe 0.90 win c58 h20; safe 0.91 win c62 h10; safe 0.91 win c66 h0; safe 0.92 win c70 h0; safe 0.92 win c74 h0 |
| Kai Turner | TURN NOW + ALTERNATE | 60.8 | 3 - 3 (3) | 0 | no | safe 0.86 win c54 h60; risky 0.55 ko c24 h60; safe 0.87 ko c0 h50; risky 0.50 win c12 h60; safe 0.86 ko c0 h50; risky 0.50 win c12 h60 |
| Kai Turner | READER | 114.3 | 6 - 0 (0) | 1 | no | safe 0.89 win c54 h45; safe 0.90 win c58 h35; safe 0.91 win c62 h25; safe 0.91 win c66 h15; safe 0.92 win c70 h5; safe 0.92 win c74 h0 |

## Runs

| Run | Settings | Result |
|---|---|---|
| trial 1 | approved numbers, score without money, 1 rep | STOP: reader 100% safe, SAFE = WAIT = READER, nobody lost |
| diag 1 | + gym cut in the score, 300 reps | 3/6: reader 81% risky; nobody ever lost |
| diag 2 | + safe-win hunger -10, risky purse x1.5, 300 reps | 4/6 |
| trial 2 | the same, 1 rep printed | above |
| **full** | the same, 2,000 reps | **4/6 FAIL (bars 2, 3)** |
| sensitivity | risky purse x1.75, 300 reps | 5/6 (bar 2 fails: 0/10) |
| sensitivity | safe-win hunger -14 (purse x1.5), 300 reps | 4/6 (bars 2, 3 fail) |

Real-world grounding behind the safe and risky numbers is in the map, section 4. `prior_research.py pro debut matchmaking
prospect` returns the TURNPRO1 design rounds and `research/topics/career_booking.md`; the safe band follows the game's
own tune-up read (0.70-0.93, aim 0.82), which was fitted on British small-hall debut records (journeyman opponents
mostly lose). The risky band follows the step up at 0.5.

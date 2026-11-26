# FWLOAD2 result - the fight week's load on the game's own tank and week (S543)

## Verdict: FAIL - cut the choice: the assistant picks the load

Both of the critic's changes were probed on the game's own tank and week. Neither makes the load a choice a player can
win with. **Train through is never the best load in any of the 18 cells.** That holds even when its whole bank lands
before the bell and takes the near line to Usable (30.5 at the bell, against 28.3 on Tick over). Its 12 off the tank costs
more than a Usable line that fires half the time brings back. The two other loads split the cells (Rest up 12, Tick over 7), but the gaps are 1 to 6
wins in 100. **Even a perfect lookup (the best load for each cell, picked on one half of the boxers and scored on the other)
beats "always Tick over" by only +0.78 wins in 100** (+0.61 with today's rules). The one-sentence reader scores +0.51 / -0.52
on the two halves. In the game as built, the load is worth less than one win in a hundred. The assistant as built
(`FightWeekPlan.draft`) is already within 2 wins of the best load in 15 of 18 cells.

Build: **no change to the load's rules.** Cut the choice from the player. The assistant picks the load and the screen says which
one and why, in one line. The fight-week screen keeps the tank bar (the bout's own tank, `FightWeekPlan.bout_tank`), the
sparring nights and their partners, Eat less and the film night. The three load cards go, along with their "best when"
lines and the "Use the pick" button for the load. Do NOT fill `near_usable` / `opp_round1` into `draft`: the pick with those
facts filled is within 2 of the best in only 9 of 18 cells, because it sends near-Usable boxers to Train through, which
never wins (section 3).

## The bars (fixed in `ops/research/DESIGN_FWLOAD2.md` s5 before any run; measured on the CHANGED arm)

| Bar | Needed | CHANGED | TODAY (control) |
|---|---|---|---|
| 1 no load best in more than half (9 of 18) | <= 9 | Rest up 12 - **FAIL** | Rest up 13 - FAIL |
| 2 each load best in 3+ cells | 3 / 3 / 3 | Rest 12, Tick 7, **Train through 0 - FAIL** | 13 / 8 / 0 - FAIL |
| 3 reader beats always Tick over by 3+ on both halves | +3 / +3 | **+0.51 / -0.52 - FAIL** | +0.85 / -0.64 - FAIL |
| 4 reader beats the pick as built by 2+ in 4 cells, or the pick plays it | 4 cells | 4 cells - PASS (moot: the reader itself does not beat Tick over) | 4 cells - PASS |
| 5 nothing runs away (8 weekly bouts) | no arm rising every week; tank 0-100 | **PASS** (no arm rises more than 2 of 7 weeks; tank off 0-32) | PASS |

Bar 4 passes only because the pick and the reader differ in a few cells where Rest up and Tick over are 2-6 apart. Both
come out level with "always Tick over" overall, so the pass shows no depth.

## Each arm by cell (CHANGED rules; win % of bouts fought, 100 boxers a cell, paired dice)

Columns: always Rest up / Tick over / Train through, the best, then the pick as built, the pick with the two facts, and the
reader. After that, tiredness at the bell (R/T/X), the near line's mastery at the bell (R/T/X), and what reader / pick / pick-with-facts chose.

```
  cell                    REST  TICK  THRU | best  | pick(built) pickF reader | t_bell R/T/X        | m112 at bell R/T/X  | reader/pick/pickF
  t35_near_fast           46.9  50.0  46.9 | TICK  |  50.0  46.9  46.9 | 35.4/38.3/45.1 | 26.9/28.3/30.5 | THRU/TICK/THRU
  t35_near_slow           37.0  38.0  35.4 | TICK  |  38.0  35.4  35.4 | 35.5/38.4/45.1 | 26.9/28.3/30.5 | THRU/TICK/THRU
  t35_far_fast            53.0  52.0  49.0 | REST  |  52.0  52.0  52.0 | 35.4/38.3/45.0 | 11.7/14.2/18.2 | TICK/TICK/TICK
  t35_far_slow            43.0  41.0  38.0 | REST  |  41.0  41.0  43.0 | 35.4/38.3/45.0 | 11.7/14.2/18.2 | REST/TICK/TICK
  t50_near_fast           43.0  45.0  38.0 | TICK  |  45.0  38.0  38.0 | 39.6/42.5/49.2 | 26.9/28.3/30.5 | THRU/TICK/THRU
  t50_near_slow           43.0  40.0  36.0 | REST  |  40.0  36.0  36.0 | 39.7/42.6/49.4 | 26.9/28.3/30.5 | THRU/TICK/THRU
  t50_far_fast            44.4  45.5  42.4 | TICK  |  45.5  45.5  45.5 | 39.6/42.4/49.2 | 11.7/14.2/18.2 | TICK/TICK/TICK
  t50_far_slow            41.0  35.0  34.0 | REST  |  35.0  35.0  41.0 | 39.7/42.6/49.4 | 11.7/14.2/18.2 | REST/TICK/TICK
  t58_near_fast           44.0  44.0  35.0 | REST/TICK |  44.0  35.0  44.0 | 42.0/44.9/51.6 | 26.9/28.3/30.5 | REST/TICK/THRU
  t58_near_slow           35.0  33.0  30.0 | REST  |  33.0  30.0  35.0 | 42.0/44.9/51.7 | 26.9/28.3/30.4 | REST/TICK/THRU
  t58_far_fast            44.0  49.5  41.4 | TICK  |  49.5  49.5  44.0 | 42.0/45.0/51.8 | 11.7/14.2/18.2 | REST/TICK/TICK
  t58_far_slow            41.4  36.4  34.3 | REST  |  36.4  36.4  41.4 | 42.0/44.9/51.6 | 11.7/14.2/18.2 | REST/TICK/TICK
  t66_near_fast           39.0  41.0  33.3 | TICK  |  39.0  39.0  39.0 | 44.2/47.2/53.9 | 26.9/28.3/30.5 | REST/REST/REST
  t66_near_slow           50.0  46.0  42.4 | REST  |  50.0  50.0  50.0 | 44.2/47.1/53.9 | 26.9/28.3/30.5 | REST/REST/REST
  t66_far_fast            44.0  43.0  40.0 | REST  |  44.0  44.0  44.0 | 44.3/47.2/53.9 | 11.7/14.2/18.2 | REST/REST/REST
  t66_far_slow            30.0  28.0  25.0 | REST  |  30.0  30.0  30.0 | 44.2/47.1/53.8 | 11.7/14.2/18.2 | REST/REST/REST
  t58_near_fast_bout6     44.4  43.4  36.4 | REST  |  43.4  36.4  44.4 | 41.9/44.8/51.6 | 26.9/28.3/30.5 | REST/TICK/THRU
  t58_far_slow_bout6      35.4  34.3  29.3 | REST  |  34.3  34.3  35.4 | 41.9/44.8/51.5 | 11.7/14.2/18.2 | REST/TICK/TICK
```

The TODAY control, same layout:

```
  t35_near_fast           49.0  50.0  44.9 | TICK  |  50.0  44.9  44.9 | 35.4/38.3/45.1 | 26.5/27.2/28.4 | THRU/TICK/THRU
  t35_near_slow           36.0  38.0  35.4 | TICK  |  38.0  35.4  35.4 | 35.5/38.4/45.1 | 26.5/27.2/28.4 | THRU/TICK/THRU
  t35_far_fast            53.0  52.0  49.0 | REST  |  52.0  52.0  52.0 | 35.4/38.3/45.0 | 10.9/12.2/14.4 | TICK/TICK/TICK
  t35_far_slow            41.0  41.0  38.0 | REST/TICK |  41.0  41.0  41.0 | 35.4/38.3/45.0 | 10.9/12.2/14.4 | REST/TICK/TICK
  t50_near_fast           46.0  45.0  38.0 | REST  |  45.0  38.0  38.0 | 39.6/42.5/49.2 | 26.5/27.2/28.4 | THRU/TICK/THRU
  t50_near_slow           40.0  40.0  36.0 | REST/TICK |  40.0  36.0  36.0 | 39.7/42.6/49.4 | 26.5/27.2/28.4 | THRU/TICK/THRU
  t50_far_fast            45.5  45.5  42.4 | REST/TICK |  45.5  45.5  45.5 | 39.6/42.4/49.2 | 10.9/12.2/14.4 | TICK/TICK/TICK
  t50_far_slow            40.0  35.0  34.0 | REST  |  35.0  35.0  40.0 | 39.7/42.6/49.4 | 10.9/12.2/14.4 | REST/TICK/TICK
  t58_near_fast           46.0  44.0  35.0 | REST  |  44.0  35.0  46.0 | 42.0/44.9/51.6 | 26.5/27.2/28.4 | REST/TICK/THRU
  t58_near_slow           32.0  33.0  26.0 | TICK  |  33.0  26.0  32.0 | 42.0/44.9/51.7 | 26.5/27.2/28.4 | REST/TICK/THRU
  t58_far_fast            48.0  49.5  41.4 | TICK  |  49.5  49.5  48.0 | 42.0/45.0/51.8 | 10.9/12.2/14.4 | REST/TICK/TICK
  t58_far_slow            40.4  36.4  34.3 | REST  |  36.4  36.4  40.4 | 42.0/44.9/51.6 | 10.9/12.2/14.4 | REST/TICK/TICK
  t66_near_fast           43.0  41.0  32.3 | REST  |  43.0  43.0  43.0 | 44.2/47.2/53.9 | 26.5/27.2/28.4 | REST/REST/REST
  t66_near_slow           50.0  46.0  41.4 | REST  |  50.0  50.0  50.0 | 44.2/47.1/53.9 | 26.5/27.2/28.4 | REST/REST/REST
  t66_far_fast            46.0  43.0  40.0 | REST  |  46.0  46.0  46.0 | 44.3/47.2/53.9 | 10.9/12.2/14.4 | REST/REST/REST
  t66_far_slow            30.0  28.0  25.0 | REST  |  30.0  30.0  30.0 | 44.2/47.1/53.8 | 10.9/12.2/14.4 | REST/REST/REST
  t58_near_fast_bout6     45.5  43.4  36.4 | REST  |  43.4  36.4  45.5 | 41.9/44.8/51.6 | 26.5/27.2/28.4 | REST/TICK/THRU
  t58_far_slow_bout6      33.3  34.3  29.3 | TICK  |  34.3  34.3  33.3 | 41.9/44.8/51.5 | 10.9/12.2/14.4 | REST/TICK/TICK
```

8 weekly bouts, 12 careers an arm (bar 5; tiredness at each bell, the tank off range, win %):

```
today rest    t_bell by week: 39.8 46.6 47.2 44.5 42.9 41.4 41.2 41.2 | rises 2 of 7 | tank off 0.0..0.0 | win 51.3% of 80 | loads { "rest_up": 96 } | ok
today tick    t_bell by week: 42.7 50.4 51.1 48.3 46.8 45.2 45.2 44.6 | rises 2 of 7 | tank off 6.0..17.1 | win 48.8% of 80 | loads { "tick_over": 96 } | ok
today through t_bell by week: 48.6 55.8 56.2 53.9 51.5 49.2 48.4 47.3 | rises 2 of 7 | tank off 12.0..32.0 | win 40.3% of 72 | loads { "train_through": 96 } | ok
today pick    t_bell by week: 42.0 47.4 47.4 44.8 43.2 41.6 41.9 41.4 | rises 2 of 7 | tank off 0.0..6.0 | win 50.0% of 80 | loads { "tick_over": 22, "rest_up": 74 } | ok
today pickf   t_bell by week: 44.5 46.9 46.0 43.6 41.2 39.4 39.4 38.8 | rises 1 of 7 | tank off 0.0..19.8 | win 48.6% of 72 | loads { "train_through": 14, "tick_over": 15, "rest_up": 67 } | ok
today reader  t_bell by week: 43.8 46.5 45.8 42.8 40.9 39.3 39.3 38.7 | rises 1 of 7 | tank off 0.0..19.8 | win 48.6% of 72 | loads { "train_through": 13, "rest_up": 78, "tick_over": 5 } | ok
changed rest    t_bell by week: 39.8 46.6 47.2 44.5 42.9 41.3 41.2 41.2 | rises 2 of 7 | tank off 0.0..0.0 | win 48.8% of 80 | loads { "rest_up": 96 } | ok
changed tick    t_bell by week: 42.7 50.4 51.1 48.3 46.8 45.2 45.2 44.6 | rises 2 of 7 | tank off 6.0..17.1 | win 48.8% of 80 | loads { "tick_over": 96 } | ok
changed through t_bell by week: 48.6 55.8 56.2 53.9 51.5 49.2 48.4 47.3 | rises 2 of 7 | tank off 12.0..32.0 | win 40.3% of 72 | loads { "train_through": 96 } | ok
changed pick    t_bell by week: 42.0 47.4 47.4 44.8 43.2 41.5 41.9 41.4 | rises 2 of 7 | tank off 0.0..6.0 | win 48.8% of 80 | loads { "tick_over": 22, "rest_up": 74 } | ok
changed pickf   t_bell by week: 44.5 46.9 46.0 43.6 41.2 39.4 39.4 38.8 | rises 1 of 7 | tank off 0.0..19.8 | win 48.6% of 72 | loads { "train_through": 14, "tick_over": 15, "rest_up": 67 } | ok
changed reader  t_bell by week: 43.8 46.5 45.8 42.8 40.9 39.3 39.3 38.7 | rises 1 of 7 | tank off 0.0..19.8 | win 48.6% of 72 | loads { "train_through": 13, "rest_up": 78, "tick_over": 5 } | ok
```

## What the numbers say

1. **The week rests the boxer, so the start tiredness barely reaches the bell.** A boxer locked at 66 rings the bell at 44
   (Rest up), 47 (Tick over) or 54 (Train through) (`WeekPhase.LOAD_WEEKS` through `Sim.step_day`). The tiredness part of the
   bout's tank is about 0 for Rest up and Tick over in every cell. The tank difference is left to the load's own 0 / 6 / 12. That
   is why the tiredness axis barely moves the answer, and why 66 is not a "rest or lose" state in the game.
2. **Change 1 (bank before the bell) works mechanically but does not pay.** The near line ends at 30.5 on Train through
   (Usable, fires half the time; it was thrown 2-5 times a bout in the trial) against 28.3 on Tick over (does not fire).
   Train through still loses 3-10 wins in 100 to Tick over in every near cell. One extra half-firing combination is worth
   less than 6 points of tank.
3. **Change 2 (flat round reads the opponent) moves 2-4 cells between Rest up and Tick over**, as built to. At -3 against a fast
   starter, Tick over takes the fast cells at 50 and 58 tired. The size of each move is 1-6 wins in 100, about the noise of
   100 paired bouts.
4. **The assistant with the facts filled is worse than as built** (9 of 18 against 15 of 18 within 2 of the best). It follows
   `near_usable` into Train through, the one load that never wins.
5. **The loop is bounded** (bar 5). Tiredness at the bell rises in weeks 1-3 (a bout's toll is 70-85), then falls back. No
   arm climbs every week. Train through carries about 7 more tiredness at every bell and wins 40 % against 49-51 %.

## What was tuned (before -> after)

- `near` (the near line's start): 24 -> 26, after the one-rep trial. At 24 the full bank reached only 28.9, so no load
  crossed Usable. This is a cell setting, not a price.
- `NEAR_GAP` (the reader's "a week from Usable"): 8 -> 5, set from the trial's measured weekly gain (+4.9 at a full bank).
- `fast_edge` stayed -3. Tuning it cannot rescue the verdict. It enters only Rest up's round 1, so the Tick over and
  Train through results do not move. Train through stays best in 0 cells and bar 2 fails at every value. No other number
  was touched.

## Defects found on the way (not fixed here: outside this task's paths)

1. **The bank shrinks the week BEFORE the fight week.** `DrillWeek.FW_BANK_REACH` is 6 days either side of the bout. A Saturday
   bout booked the Saturday before has its Sunday drilling (bout - 6) cut by the stop's share. That drilling is the booking
   week's own pads, before the fight week starts. Seen in the TODAY arm: the near line reads 26.5 / 27.2 / 28.4 at the bell
   by load. No fight-week drilling has run before the bell, so the gap is the previous week's run, banked at 0.2 / 0.5 / 1.0.
   Fix: apply `fw_bank` only to a drilling whose week holds the bout (Monday of the bout's week, or later).
2. **The screen's tank at the lock is not the tank at the bell.** It is computed on today's tiredness. The week's rest days
   then lower it (trial, start 58, Train through: 28 off at the lock, 20 at the bell). `bout_tank` is exactly the bout's
   rule (0 of 5,377 bouts differed at the bell), but on the lock day it shows a number the boxer will not fight on. If the load
   cards stay, the screen should forecast tiredness at the bell (`CampForecast` does this for camps).
3. `FightWeekPlan.draft` never fills `opp_round1` or `near_usable` (l.164-165). Per finding 4, leave them unfilled, or
   remove those two branches from `FightWeekPick.best_stop` when the choice is cut.

## Honest limits

- 100 boxers a cell on paired dice. The standard error of one load's win rate is about 5 points; paired differences are
  smaller (many bouts end the same under two loads). The 1-6 point gaps between Rest up and Tick over are within noise.
  The verdict does not rest on them: it rests on Train through being last in all 18 cells, and on the perfect lookup
  gaining under 1 in 100.
- The opponent's "fast start" is the probe's own file label (no fast-starter habit exists in the game). In the bout, fast and
  slow differ only through `slow_starter` (`GuardWear`) and the style. Change 2 prices Rest up by the label, as the critic asked.
- Every week here is the load alone: no sparring night, no Eat less, no weight cut, no film. A weight cut is the one state
  `FightWeekPick` reads that this probe did not (`tank_weight` -> Rest up).
- One plan (1-2 Sharp, 3b-3 Usable, 1-1-2 near or far) and no coach hired (pad skill 0). A coached club drills faster, which
  makes "near" crossings commoner. It does not change the 12-point tank price.
- Bouts on Saturdays, booked 7 days out. A booking 10-14 days out (the week before) was not cut into cells.

## Reproduce (Git Bash, through the slot; ~11 min and ~1 min on one slot)

```
python ops/Tools/godot_slot.py run --who FWLOAD2 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/fwload2_probe.gd -- mode=cells n=100
python ops/Tools/godot_slot.py run --who FWLOAD2 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/fwload2_probe.gd -- mode=career n=12
```
(`mode=trial` = one boxer a cell, printed in full. Levers: `fast_edge=-3`, `near=26`, `cal=0`, `only=<cell>`.)
Run S543: 1,800 cell-runs (5,400 weeks, 10,800 bouts) in 671 s. Careers: 1,152 weeks in 68 s.

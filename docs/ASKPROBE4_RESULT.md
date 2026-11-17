# ASKPROBE4 result (S511) - does the fight week make the show date a real choice?

Probe: `tools/ask_probe4.gd`, seed **4421**, 60 fighters (ask_probe2's population: Data.lucy re-rated to a target
power 52-68 +-3 a stat, w 0-8 l 0-2, start day 0-42, 1 in 5 walking 0.5-1.6 kg over), the wlw sheet name at idx%3,
no coach hired, cash $17200. 24 seeds an arm: the first half selects the best of the 9, the second half reports it.
Every week runs the game's own days (Sim.step_day) and every bout is the game's own bout (Bouts.fight_step +
LiveRound, auto corner): **15479 bouts, 242031 days stepped, 15708 week-runs** in 1520s. Lock refused 0 weeks.

Reproduce (Git Bash, through the slot):
`python ops/Tools/godot_slot.py run --who ASKPROBE4 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/askprobe4.log --path . --script res://tools/ask_probe4.gd -- count=60 seeds=24 seed=4421 near=10 far=21`
(levers: `count=60`, `seeds=16`, `seed=4421`, `near=10`, `far=21`; the line above is this run).

## The arms

- **NEAR**: the bout booked 10 days out. **FAR**: 21 days out. The same boxer, the same opponent, the same dice
  (c.day = 200000 + 900000 + seed on both), so the only difference is the date and the days it buys.
- **ASSIST**: FightWeekPlan.draft's own stop and nights, locked with the best-ranked free partner on every night.
- **BEST**: the best of the 9 (Rest up / Tick over / Train through x 0/1/2 fight-week nights; 1 night = 6 days out,
  2 = 6 and 3) by win rate on the selection half, reported on the other half. The assistant's week-before night stays.
- The plan is the game's opening board (PlanFight.starter: 1-2, step_back, tie_up, pivot_out) written AFTER the
  booking, so all four lines are unsparred until a night readies them (the v9 rule).

## Per arm (the population above; win% is of bouts fought)

| Arm | Date | win% | fought% | tank off | sharp% | readied | unsparred | plan mastery | plan gain | punch mastery | banked units | injury% | pull-out% | miss% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ASSIST | NEAR | 23.2 | 98.8 | 9.0 | 100.0 | 1.95 | 2.05 | 5.58 | +5.58 | 27.07 | 474 | 10.3 | 1.3 | 0.0 |
| ASSIST | FAR | 22.6 | 97.9 | 11.4 | 100.0 | 1.95 | 2.05 | 9.34 | +9.34 | 26.88 | 534 | 11.6 | 2.1 | 0.0 |
| BEST | NEAR | 30.2 | 98.3 | 1.6 | 20.0 | 2.00 | 2.00 | 5.59 | +5.59 | 27.07 | 180 | 9.2 | 1.7 | 0.0 |
| BEST | FAR | 28.4 | 97.6 | 0.8 | 10.0 | 1.99 | 2.01 | 9.34 | +9.34 | 26.88 | 172 | 10.3 | 2.4 | 0.0 |

Denominators: win%, tank off, tired at bell, plan/punch mastery, plan gain and banked units read the weeks that REACHED A
BELL (fought% of the weeks; a pulled-out or missed-weight week has no first bell). Sharp%, readied, unsparred, the edges
and week-before% read every LOCKED week, and injury%/pull-out%/miss% every week run. The ASSIST arm runs 24 seeds a
fighter, the BEST arm the report half (12); the per-fighter verdict below uses those same win rates.

**Plan mastery** = the mean mastery of the plan's four lines at the bell (FireLevel.mastery_of: the combo's drilled
mastery, each footwork line's bar) - the map's 'pad mastery on the plan's moves'. **Plan gain** = that minus the booking
day (all four lines start at 0 on a fresh signing). **Punch mastery** = the mean of her six punches (DrillWeek/PadWeek).
**Banked units** = FightWeek.banked(stop, the fight week's pad minutes) - RULE-ONLY: no game code calls banked(), so
those units are not written into mastery. **Readied / unsparred** = the plan lines the locked nights ready / leave
unsparred (an unsparred line fires one level down in rounds 1-2). **Tank off** = bout.stale at the first bell.

| Arm | Date | tired at bell | spar edge (r1-2) | r1 edge | week-before% | Rest up | Tick over | Train through |
|---|---|---|---|---|---|---|---|---|
| ASSIST | NEAR | 40.2 | +1.19 | +0.00 | 100 | 0 | 744 | 696 |
| ASSIST | FAR | 45.0 | +1.18 | +0.00 | 100 | 0 | 744 | 696 |
| BEST | NEAR | 35.9 | +1.18 | -1.60 | 100 | 576 | 108 | 36 |
| BEST | FAR | 40.1 | +1.19 | -1.80 | 100 | 648 | 60 | 12 |

## NEAR against FAR, fighter by fighter (tie = inside 2 points of win rate)

| Arm | NEAR better | FAR better | tie | of 60 |
|---|---|---|---|---|
| ASSIST | 16 | 22 | 22 | 60 |
| BEST | 14 | 13 | 33 | 60 |

Granularity, said plainly: the ASSIST arm reads 24 seeds a fighter (win rate moves in 4.2-point steps), the BEST arm
the report half of 12 (8.3-point steps). The brief's tie band is 2 points, so at this size a 'tie' is an exact tie of
the two win rates; a fighter whose dates differ by one seed is counted for the date that won. The pooled arm rows above
carry 1422 bouts an arm, so their win rates are the tighter number.

## The map's bar

- Neither date best for more than 6 of 10 (36 of 60): the assistant arm's dominant date is best for 22 of 60 - **PASS**.
- At least one of win / mastery / injury moves 3+ points between the dates: win 0.7, plan mastery 3.75, injury 1.3 - **PASS** (mastery 3.8 points).
  Mastery here is the plan's lines (the map's pad mastery on the plan's moves); the six punches' own mean moves 0.19 points.

A real choice = both bars hold: **YES**.

## What the game actually wires (grep, S511) - read the table with this

- Wired: the tank's choice layer (BoutRules.tank_parts_for reads bout.load / spar_days / eat_less), Rest up's flat
  round (bout.r1_edge), the partner edge in rounds 1-2 (bout.spar_edge), the unsparred fire shift (FireLevel.round_mastery),
  the fight-week spar evenings and the film night's pad night (WeekPlan.evenings_of), the training injury roll (Injuries.end_week).
- NOT wired (rule or screen text only): the week-before night's one pad night (FightWeek.spar_night.costs_pad_night has no
  caller outside the UI), the late night's x2.5 injury and 3% cut stop (SPAR_LATE_INJURY_X / SPAR_LATE_CUT_STOP), and
  FightWeek.banked's mastery units. A week-before night also never enters bout.spar_days, so it adds no spar evening.
- The assistant's draft places a week-before night whenever the bout is 8+ days out at the draft (FightWeekPlan.WEEK_BEFORE),
  so the NEAR arm at 10 days gets one too: week-before night placed on 100% of NEAR weeks and 100% of FAR weeks.
  The brief's NEAR label says 'no week-before nights'; the rule's threshold is 8 days, and 10 >= 8. Measured as the game does it.
- The probe books exactly 10 / 21 days out as the brief asks; the club's own show day is a Saturday
  (AmateurBooking.fight_day), so the bell's weekday varies with the fighter's start day - the same for both arms of a fighter.

## RESULT

`RESULT: tools/ask_probe4.gd -> ASKPROBE4 done`

## The read at collect (S511, Qwen; appended after the run, as ASKPROBE2's collect notes)

- **The date passes the map's bar but does not change who wins.** Win rate is flat: 23.2% NEAR vs 22.6% FAR on the
  assistant's week (1422 / 1410 bouts), 30.2% vs 28.4% on the player's best-of-9. The measure that crosses the 3-point
  bar is the plan's mastery, +3.75 points (5.58 -> 9.34). What the FAR date buys is drilling time on the plan's lines,
  not victories; it costs tank (+2.4 off at the bell, tiredness 40.2 -> 45.0) and a little injury (10.3% -> 11.6%,
  pull-outs 1.3% -> 2.1%). A real choice by the bar (YES), but a choice about preparation, not about the result.
- **The spread is real.** FAR best for 22 of 60, NEAR for 16, 22 tie (assistant); 14 / 13 / 33 on the best-of-9. Neither
  date reaches the 6-in-10 cap (36 of 60).
- **The map's framing needs one correction.** NEAR at 10 days is NOT "fight week only". FightWeekPlan.draft places a
  week-before night at 8 days out whenever the bout is 8+ days out at the draft, so BOTH dates lock the same week-before
  night (100% of weeks) and run the same last-7-day fight week. The FAR date's extra 11 days are ordinary training weeks
  before the fight week, not a longer fight week. Map v4 STATUS's "near show = less fight week, far show = a full one"
  does not hold as built; the trade is training time, and the week-before night is free as wired (its pad-night cost has
  no caller).
- **The mastery the FAR date buys is on lines that mostly do not fire yet.** The plan is the opening board on a fresh
  signing (the 1-2 combo and the three footwork bars all start at 0); 21 days of pads bring the plan's mean to 9.34 of
  100, still under Usable (30). The +3.75 points is real drilling, but it has not yet turned a line on - which is why the
  win rate stays flat. The unsparred fire shift has little to bite on here (readied ~1.95, unsparred ~2.05, but the lines
  read mastery 0 either way).
- **The player's best-of-9 mostly picks Rest up with 0 fight-week nights** (576/720 NEAR, 648/720 FAR): a full tank
  (1.6 / 0.8 off) beats the assistant's Tick over (9.0 / 11.4 off) even though Rest up opens flat (r1 edge -1.6 / -1.8).
  The flat round costs less than the tank. Fight-week sparring nights are rarely worth it on this population: they ready
  lines that do not fire yet and cost tank, so the selection drops them.
- **Rule-only measures, named so they are not read as game effects:** the week-before night's one pad night, the late
  night's x2.5 injury / 3% cut stop, and FightWeek.banked's units have no caller in the game (grep, S511). The banked
  units column (474 / 534 assistant, 180 / 172 best) is the rule module's number, not mastery the game writes.

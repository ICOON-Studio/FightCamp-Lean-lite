# AMATEURWEEK1 v5 - Claude's code checks for Kalli SQ60 (S451)

Kalli (SQ60) on map v4: Depth 5/10, Play 6/10 - below the 7 bar, so v5 is next. John (SQ62) still out; v5 is written once both are in.

## CHECK (Claude) answers, from the code
1. Stoppage rest: BOTH rules exist. `Injuries.gd` holds the England Boxing 30-day suspension (longer for repeats); `Matchmaking.next_weeks`
   adds `STOP_REST_WEEKS` = 8 weeks to the next offer after a stopped loss. v5 must say which one the fight-week sheet shows (the suspension is
   the rule book; the 8 weeks is matchmaking's own gap on top) and whether the 8 stays.
2. TAPER for an amateur bout: YES, it runs. `WeekPhase.phase(bout, day)` reads any booked bout: 1 week out = taper, 2 = peak, 3+ = build,
   camp or no camp. v4's "TAPER never ran for an amateur bout" is wrong. v5: the fight week's load choice REPLACES the taper week by name
   (Rest up = taper as today, Tick over / Train through = the edits), so the two never fight.
3. Stipend and savings: there is no savings value in the code (no `savings` anywhere in scripts/). The stipend is optional ($250, Pay or Stop).
   v5: drop "the boxer pays" until savings exist, or build savings from a paid stipend only (Kalli's point 12).

## Stale facts Kalli judged on (pack fixed in S451)
- FireLevel is ON since S450 (Kalli's point 7 assumed off): Tick over's "+1 line ready" has a real effect now.
- The office desktop now exists (OFFICE1 collected S451, his Q-213): point 17 is answered; the needs row stays on Home too.
- "Cardio": keep the owner's word where the screen already uses it (S431); Kalli's "Stamina" ask is only for the training-share rows.

## Kalli's 10/10 list, the order v5 takes it in
1 FIGHTWEEKPROBE3 before the build (season row + banked row on the box) - 2 home/away trade (9 wins needs 3 over ranked names; home draws
within 3 places) - 3 trips act on what the fight reads - 4 price the stacked tank - 5 price late sparring (x1.5 injury inside 7 days) -
6 Train through carries +6 tiredness and counts in the load-spike rule - 7 favours lock ranked names for 4 weeks at 0; the kilo moves the
agreed weight - 8 who pays (above) - 9 code facts (above) - 10 regional show calendar - 11 the pick comes from the assistant - 12 game words -
13 a 3-week bout shows week 1 as BUILD - 14 probe order.

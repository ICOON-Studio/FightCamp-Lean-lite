# S485 digest (2026-11-15) - club week v1 wired, Arena x4, STEPVALUE1 started

## Club week (CLUBWEEK1), his S484 answers built
- CHECKs 4, 6, 7, 10 closed (ops/research/CLUBWEEK1_V9_CHECKS_S483.md): pads never short makes StepMastery's turn count
  moot; no later-date path in code and nothing left to trigger it (cut to v2); one coach budget = COACHFIT1's coach time;
  MONEYFOUR1 superseded by FOURMONEY1. v1 plan: ops/research/CLUBWEEK1_BUILD_S485.md.
- Built and wired (tests in tools/run_tests.sh):
  - Loyalty bar on the Overview, "62 - Settled" + hover moves (DarkOverview.loyalty; roster_slate_test). Still checked on
    the hidden desktop (ops/previews/s485/overview_loyalty_bar.png, on the review board, sent to him).
  - LoyaltyWire: sponsorship +5 / -8, Monday drift +1 to 60, wants_sponsor -3 (pot 80+, 8 weeks on a day job)
    (loyalty_wire_test). Hooked from GymSpend.set_stipend and GymSpend.day_events.
  - Pro share under 50 loyalty = 10% (Roster.turn_pro + signing_share, ProOffer line) (loyal_pro_share_test).
  - DayJob (Arena, 2 parse fixes): a day job = 2 of 6 mornings, GymSpend.DAY_JOB_GAIN 0.85 -> 4/6; the week plan marks
    WORK mornings (week_board_clarity_test); Money button hover says it.
  - FilmSeats (Arena, as is): 2 coached film nights a fight week (3 full-time), first come first served; the third boxer
    watches alone, no tell (FightWeekPlan.film_seat, FightWeek screen line) (film_seat_wire_test).
- NOT built: leaving and the talk. No code path removes a fighter; R58 (map S439, Dola 7/7) is the build that does it.
  Note R58's map has the pro share at 12%; his Q-244 says 10% - 10% is what the code has.

## FOURSTART1
- docs/FOURSTART1_MONEY_S485.md: with classes (+$350) and ticket cuts (~$400 a week from ~46 bouts a year), $17,200 lasts
  16 weeks with four sponsored, ~52 weeks with one. Board Q-S294-246 (one sponsored starter, three on day jobs).

## STEPVALUE1 (approved, the fight week shipped)
- Piece 1 (FireLevel reads StepMastery) was already done in S463.
- Pieces 2+4: StepEffect.gd (Arena, as is; ten rows checked against the map).
- Piece 6: StepValue (TASK_STEPVALUE2) on Arena at the wrap-up - collect next session if not landed.
- Left: piece 3 (the ropes count inside the exchange), 5 (StepMastery past 30), the wiring into the exchange, probes 2-7.

## Seats
- Arena: DAYJOB1, FILMSEATS1, STEPEFFECT1 merged; STEPVALUE2 running. Prompts point at a committed TASK file; the lite
  mirror push first; GDSCRIPT TRAPS paragraph in every brief (Arena's two errors: `:=` from an Array element, Array.join).
- Qwen CLASH7 still running at wrap-up (ETA ~13:44): next session collects it (run its hidden film; bar in TASK_CLASH7.md).
- Seat queue: SQ172 John (training K), SQ174 Kalli (STYLE4), SQ175 Kalli (ladder v3) in flight.
- PR 307 (FOURMONEY1) closed: already on main since S484.

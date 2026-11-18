# CLUBWEEK1 v11 - what S519 built (his Q-S294-272 "Yes, build it")

Design: `ops/research/DESIGN_CLUBWEEK1_V11.md` (Dola, critics Dola 8/8/7 + Goose 7/8/6).
Ruling kept: **pads stay FULL** (his Q-S294-260 "full pads, no sharing"). Q-S294-273 asked which stands; his answer
"what do you think ?" -> Claude: full pads. So v11's "pad turns" (one boxer per 20-min turn, SHORT, rotate who goes short,
never-short star) are NOT built: nobody goes short on a pad night. What is scarce instead: the coached mornings (6-7
slots shared by the club), a class night (the whole evening), and the coach's film nights in a fight week.

## Built, section by section
| v11 | What the game does now | Code |
|---|---|---|
| 2 When it appears | One boxer: nothing changes (no morning deal, no forecast). The second signing's one news line: the coach's time is shared now. | `MorningWire.deal` (2+), `Roster.sign_fighter`, Training `_forecast` (2+ and a coach) |
| 3.2 Classes | EXTRA class nights on top of the coach's usual $350 (decided number, untouched): a weekday pad evening becomes a class, +$117 that week, a member every 16 class nights (carry), every boxer on pads that evening drills half the minutes (bag). | `ClubClasses`, `GymSpend.income/_class_members`, `DrillWeek._class_bag`, `ClubWeek.coach_cell` kind "class" |
| 3.3 Coached mornings | The coach deals You 4 + coach 2 (sessional) / 3 (full time) slots a week: a pair training the same ability shares ONE slot (x1.15 each, nearest their shared focus = the ability both rank lowest), the rest 1-to-1 on each boxer's lowest-ranked morning (x1.40 on a weak spot, else x1.25). Computed from the plans as they stand (never stored): the screen, the forecast and the sim read the same deal. | `CoachedMornings.shared_focus/week_deal/day_mult`, `MorningWire`, `WeekPlan.day` (x mult), `Sim.week_ctx` (dow, coached) |
| 3.4 Film alone | Over the coach's film nights the boxer watching alone keeps HALF a read; a second (alone again, a rematch) opens the next tell. (v11's "opens next Monday" lands after a Saturday bout - adapted.) | `OppFile.half_tape`, `FightWeekPlan.lock` |
| 3.5 Sponsorship | HALF the sponsorship: $125, 1 work morning (Tue), gain 5/6. Full 0 / half 1 / none 2 (his Q-243). Loyalty: up from nothing +3, down from full -4, half -> none -4 (ESTIMATES). | `DayJob.count_of/lost_days_of`, `GymSpend.set_half`, `Loyalty.MOVES sponsor_half_*` |
| 3.6 Loyalty | The band word + 4-week trend (↑ rising / → steady / ↘ falling, +-3 over 28 days); no raw number added. | `Loyalty.trend`, `DarkOverview.loyalty` |
| 3.7 Forecast + clash | Training header: the next 4 weeks (quiet / N fight weeks - film n/owned, amber when a boxer watches alone). A bout offer whose week already holds the coach's film nights says so under Accept. | `ClubForecast.weeks/clash`, `Training._forecast`, `BoutPage._answer_row` |

## Every menu it appears on, and what each is wired to
| Menu | Shows | Wired to |
|---|---|---|
| Training: morning tile | `1-TO-1 x1.25` / `SHARED x1.15`, the gain already multiplied; hover "Shared: Power (x1.15)" | `ClubWeek` am.coach <- `MorningWire.of`; gain <- `WeekPlan.day` |
| Training: MORNINGS panel | the week's stat gains, coached mornings included | `WeekPlan.week` (dow, coached) |
| Training: coach row | `CLASS NIGHT boxers on the bag` | `ClubWeek.coach_cell` <- `ClubClasses.on` |
| Training: evening tile | `BAG · class night`, the move's bar at half | `DrillWeek.inputs` (_class_bag) |
| Training: evening panel | `Teach a class tonight: +$117` / `Back to pads tonight` + the note | act `tkclass` -> `ClubClasses.toggle` |
| Training: header strip | 4 weeks: quiet / fight weeks · film n/owned (amber) | `ClubForecast.weeks` |
| Training: WORK morning | one WORK tile on half, two on none | `DayJob.lost_days_of` |
| Money: in and out | `Class nights +$117` line | `GymSpend.income` class_nights -> `Sim._with_bjj` |
| Money: fighters and money | `half` + `Start $250` / `Stop`; `Half $125` on full or none | act `stipend fid|half` -> `GymSpend.set_half` |
| Boxer Overview | `53 - Settled  ↘ falling`, hover "Last 4 weeks: -9" | `Loyalty.trend` |
| Bout offer (versus) | amber clash line under Accept | `ClubForecast.clash` |
| Fight week / news | "watched the tape alone: half a read" / "finished the read: a new tell" | `OppFile.half_tape` |
| News (once) | "Two boxers now share the coach's time ..." | `Roster.sign_fighter` |

## Tests
morning_deal, class_nights, loyalty_trend, half_tape, half_sponsor, club_forecast, club_week_walk (the golden path through
Main's acts); all in tools/run_tests.sh. Neighbours green: training_k, golden_path, two_boxers_two_years, week_plan,
club_deal, coach_nights, test_club, gym_spend, game_money, dues_wire, money_close, evenings, pad_week, pad_view, side_panel,
loyalty, loyalty_week, loyalty_wire, approach_ui, approach_wire, home_look, day_job, film_seats, film_seat_wire, opp_file,
fight_week, fight_week_screen, film_night, plan_bout, menus_round4, refuse_walkin, male_boxer, recruit, roster_flag.
Stills: `tools/club_week_still.gd` -> ops/previews/s519 (training_deal, training_class_night, training_forecast,
bout_clash, money_class_line, overview_loyalty_trend).

## Not built (and why)
- Pad turns / SHORT / rotate / never-short star / cover coach / pads volunteer: pads are full (his ruling).
- Twist cards' priced choices (3.8): the 16-card deck already runs (WeekTwist); v11's two-choice cards not yet re-priced.
- "Prioritise next week" conversation option: no shortage to prioritise with full pads; the other two (promise, tell it
  straight) were already built (Promises, Loyalty.can_tell_straight).
- Work-evenings toggle (negotiate hours): the evening is the pad night; a lost evening is a new kind of WORK - later.
- MONEYFOUR2 (class money vs mastery lost) and MORNINGSPROBE2 (does each morning policy win 30-70%) should measure the
  ESTIMATES above on the built code.

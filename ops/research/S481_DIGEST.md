# S481 digest (2026-11-15)

## Built: THE FIGHT WEEK (FIGHTWEEK2) - his S473 "Yes, build it", Q-238 v9, C402 "ok"
- scripts/state/FightWeekPlan.gd (NEW): mark (at booking: bout.fight_week, host club, f.sparred = her plan), lines (READY /
  UNSPARRED), partners (2 own-club free + 3 outside, deterministic, PartnerMatch.rank), draft (FightWeekPick; the night is
  placed with NO partner - map v9 4.1/4.6), read (tank, round one, each night's match, lines readied, r1 edge), lock.
- scripts/ui/modals/FightWeek.gd (Frame A) + scripts/ui/FightWeekPartner.gd (Frame B) + scripts/ui/FightWeekActs.gd;
  scenes/modals/FightWeek.tscn; MainFlow/Main/OfficeDesk wired; Needs: FIGHT WEEK flag + Home row.
- Lock writes bout.load, spar_days, eat_less, r1_edge (best night's PartnerMatch edge + Rest up's flat round), unsparred
  (move ids; FireLevel.round_mastery fires them a level down in rounds 1-2), fw_film (WeekPlan: film takes a pad night),
  f.sparred += the readied lines. Partner cost: own club free; outside $160 or a favour (Career.favours, 1 per host to start).
- Rules changed: Bouts.camp_due is false for a fight-week bout; Bouts.weigh takes the WeighGap gap at a club show; Sim cuts in
  the fight week as in a camp; an unset week's load = FightWeek.DEFAULT_STOP (Tick over; his Q-229 note "one rest day");
  a camp set on a club-show bout makes it a camp bout (start_camp + CampForecast drop the fight-week keys).
- Tests: tests/fight_week_screen_test.gd (golden path, 23 ok) added to tools/run_tests.sh with coach_fit_test. golden_path_test
  now expects FIGHT WEEK on the top bar; its missed-weight career is a camp bout. Green: the 24 touched tests (camp_protocol,
  camp_cards, week_plan/phase, evenings, spar_nights, weigh_forecast, save_load, fight_week, grey_reason, opp_file, week_strip,
  office_desk, first_week, nocamp_page, evening_edits, no_pronoun, words_on_screens, poster_reveal, home_look, fire_level,
  bout_rules, test_jump, golden_path, fight_week_screen).
- Stills (real, hidden desktop, tools/fight_week_still.gd): docs/mockups/s481/real/fight_week_frame_{a,b}_real.png, on his
  review board.

## Collected
- COACHFIT2 (Arena PR 301): CoachFit.gd + test, 92 checks 0 failures on the PC.
- STYLE1 (Goose #298): FAIL gate 1 - named styles worth 0-1.3 wins in 100 (bar 1.5-4). Part B used the probe's own career
  model, not the game loop: not evidence. -> STYLE2 to Goose #302.
- CLASH5 (Qwen): no fix; root cause - one boxer's stack runs first and reads the peer's arms a frame stale; 12 tunings failed.
  -> CLASH6 (two-phase clash) on Qwen, wt LEAN_CLASH6.

## His questions
- "why the nightly didnt run ?" - it ran (05:00 PC task, 348 pass / 21 FAIL lines); start printed the old cloud check's
  "no finished cloud nightly yet". nightly_fetch.py now prints the PC result.
- Q-239 "why do we need 2 pages ... how do you set the plan up ?" - one page, the flowchart; the setup in four clicks drawn
  (docs/mockups/s481/plan_flowchart_v2.png) -> Q-S294-240 on his board.

## Seats queued
SQ166 John + SQ167 Maria: club week v9 critics. SQ168 Dola: training K as a layout spec (HTML cut off twice).

## Not done (FIGHTWEEK3)
Pull-out roll + fall-through card (FightWeekEvents), Train it off / Ask for a kilo, favours earned by filling a late gap, the
week-before night's pad-night cost, the win band on the right panel.

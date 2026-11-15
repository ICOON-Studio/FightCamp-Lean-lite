# S486 digest (2026-11-15) - a fighter can leave: Leaving + loyalty hooks built, Approach/Promises rules in, CLASH8 on Qwen

## Built (Claude)
- R58 LEAVE1: scripts/state/Leaving.gd - leave (own Monday under 25 after two words; approach), let_go, let_go_price, monday.
  A bout inside 14 days is boxed first (leaves_after), one further off goes with them; pro offer withdrawn; reputation
  -2 / -5 (ranked top 5 or pro), let go -1 / -3; a pro's release fee = StarDeal.YEAR_BONUS of GymSpend.year_take, min $500;
  the place frees; an amateur boxes on for Eastside ABC in c.rivals ("left", "from"); team-mates under 50 take
  Loyalty "teammate_left" -2. Hook: GymSpend.day_events Monday after LoyaltyWire.week. tests/leaving_test.gd 24 checks.
- R58 LOYALHOOKS1: Loyalty.MOVES offer_passed -3, no_bout -3, bout_won +2, bout_lost -1, stopped -3, goal_met +5,
  goal_missed -4, decline_pro -8, turn_pro +5, signing_class -4; HALVED_WHEN_LOYAL (bout_lost, stopped at 70+, toward 0).
  Hooks: Bouts.passed (decline + expiry, never the mismatch, never injured or booked), BoutFinish (result + goal),
  Roster (decline_pro, turn_pro after the share is set, sign_fighter same div), LoyaltyWire.idle_week (4 fit Mondays
  with no bout). tests/loyalty_hooks_test.gd.
- Defects fixed on sight: Halo._outside set size on full-rect anchors (warning on every HeadlineCard; container path now
  top-left anchors, elsewhere offsets); CoachedMornings words Cardio / Ring IQ -> Stamina / Fight IQ (Data.LABEL).
- Green: leaving, loyalty_hooks, loyalty, loyalty_wire, gym_spend, golden_path (0 anchor warnings), halo, coached
  mornings, loyal_pro_share, menu_world, next_offer, pro_ladder, recruit, roster_rows_page, truth_pass, world_slate.
- Export: Builds/FightCamp.exe; WHAT_TO_TRY S486.

## Agents
- Arena: STEPVALUE2 merged (the brief's -0.5 stack example was wrong; the table's -2.5 right), APPROACH1 + PROMISE1 merged
  as is (pass first run), LOYAL3 running (bot-club probe on Approach.answers; the id LOYAL1 was taken in S461 - the
  overwritten TASK_LOYAL1.md was restored).
- Qwen: CLASH7 NOT merged - SkelPump fixed the order (09_jab f19 defender reads fresh) but depths unchanged 0.054 / 0.057 m;
  branch qwen/clash7 pushed and kept. CLASH8 launched 13:03 (BASE qwen/clash7): layer_trace the frames after the clash
  pass, fix only the layer that undoes it. STYLE4 queued after it.
- Goose: 3 runs used today (STYLE1-3) - STYLE4 went to Qwen instead.
- Seats: John TRAINGAME2 5/5/6, Kalli (fresh) 4/5/4 -> v2 brief to Kalli SQ176 with the code facts (240 units a night,
  each v1 night was a FULL night on one card so only another night closes the 1.8 gap; Stamina ability vs Cardio group;
  Fight IQ; 70 kg is a women's class). Kalli STYLE4 levers -> TASK_STYLE4 (named style already needs 3 moves at 60+, so
  her "lever x moves/3" gate is already true). SQ175 ladder v3 still at Kalli.
- seat_dispatch contract gate: OWNS/REGRESSION must be plain paths that exist (notes in parentheses on the next line).

## Not done / next
- APPROACHWIRE1 (Claude): the approach on screen and in the week - Monday Approach.due, the Overview card with five
  columns, the talk, each answer's act, unanswered -> Leaving.leave; Let go on the Overview; promises listed.
- Q-S294-246 (four starters' money) still open.

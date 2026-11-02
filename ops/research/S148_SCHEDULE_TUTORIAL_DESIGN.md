# S148 - Schedule, ladder and tutorial redesign (design for the operator's verdict; nothing built yet)

Operator 2026-10-03: "the scheduled events in the calendar are kind of confusing for the player ... make the player
interaction meaningful, logical and build a tutorial to explain where, why, how and help him advance from the regional
gym to the national". Evidence: J59 (John, 15 unsurveyed games incl. Corner King: Boxing Tycoon), K84 (Kalli, sources +
10 rules + wireframe), J52 (tutorial), J54 (menus), D66 (no onboarding), today's screen (s137_exe_walk/55_schedule.png).

## What confuses today (read off the screen)
1. 19 "obligations" in January - almost all are WORLD events (RIZIN, Glory, ONE, World Taekwondo) with no link to a
   Nicosia boxing club. Your own things drown.
2. Codes nobody explained: "NL MED", "NL CAMP", "RV WEIGH" (fighter initials + jargon).
3. 6 tabs + 8 filters and no answer to "what do I do next, and by when?".
4. An event never says whether YOUR fighter can enter it, or what he needs to.

## The design (each line tagged with its source)
### A. Schedule opens on MY GYM, not the world
- NEXT UP card, top-left of the content (K84 rule 8; NN/g attention-left): the next dated thing for your gym - "Entry
  closes Fri 9 Jan: Club show, Iron Parish - Ruiz (welter, 2-0) can enter", one line WHY ("a bout is the only way up the
  ladder"), ONE gold button (ENTER / SET CAMP / WEIGH IN). (J59 #1: one list, deadline on every row.)
- Below it: a WEEK-BY-WEEK LIST of only your obligations - entry deadlines, camps, weigh-ins, medicals, bouts, the
  monthly bill - each row: date, icon, full fighter name + portrait, plain words (no codes), the action. (J59 #1, #2;
  WCBM2's worst review: booked fights "can't tell ... from the Calendar".)
- The month grid becomes a secondary view; WORLD events move to their own tab, filtered to your sport and region by
  default (one switch to show all). (J59 #1; today's noise.)
### B. Every event says who can enter and what is missing
- Row badge: "OPEN to Ruiz" (green) or "LOCKED - needs 3 wins (Ruiz 2/3)" (amber). (J59 #4: each gate stated;
  Corner King warns when an offer is above your gym's standing.)
- The opponent is shown before you commit (J59 #7, WCBM2's 111-up complaint).
### C. THE LADDER panel (Fights area): you in the table, the next gate named
- Rows REGIONAL -> NATIONAL -> INTERNATIONAL (the game's own VenueLadder levels); your fighters placed on their row;
  under each row the gate with progress: "Regional -> National: 3 amateur wins + ranked top 10 (Ruiz 2/3, #14)".
- A GYM row too: "Regional gym -> National gym: reputation 40 + 2 coaches + a mat room (you: 22, 1, no)". (J59 #4, #5
  tiers have names and a payoff; Corner King's ladder side-column; Boxing School 2's "fights needed" count.)
- When a gate opens: one inbox notice with the action button inside (J59 skeleton #4, Corner King title-shot email).
### D. Continue stops only on decisions
- Skip to: next decision / next fight; it stops at an entry deadline, a weigh-in, fight day (setting: every day).
  (J59 #3, Corner King patch 0.0.25.) Continue never moves (J54 P6, K84 rule 9).
### E. The guided first career (tutorial)
- Inside the real save, optional at new career, skippable at any step, every chapter replayable from the HANDBOOK
  (top bar, left of the date). (J52 s6d, K84 rules 3, 9; J59 #6 All Your Wrestling.)
- Side card next to its target, one spotlight, never covers Continue; reason first, then how; max 3 new things
  per step (K84 rules 1, 5, 6; Hodent).
- OBJECTIVES list top-right: the current chapter's 3 goals, collapsible (K84 rule 7; Two Point, Planet Coaster 2).
- Chapters (about 12 steps total, J52's 18 cut by a third - K84 rule 4):
  1. YOUR GYM (3): HOME picture and pins - sign your first boxer in Scouting - set his week's training.
  2. FIRST BOUT (4): NEXT UP card - enter a club show before its deadline - set the camp - weigh-in and fight night.
  3. THE MONEY (2): the week review (NET, bills) - the monthly bill and dues.
  4. UP THE LADDER (3): the Ladder panel and the next gate - grow the gym (a room, a coach) - the goal "National gym".
- It ends by saying it is over and where the Handbook is; after that only a hint-dot on a screen opened the first
  time (K84 rule 10).

## Open for the operator
1. The four tutorial chapters and their order.
2. Gym gate numbers (reputation 40, 2 coaches, mat room) are EXAMPLES - authored balance, labelled invented.
3. Month grid kept as a secondary view (yes/no).

## THE LADDER RULE (operator 2026-10-03, verbatim: "the fighter needs 3 wins to be able to access the national tournaments
## each loss brings him back a bit at the rankings, then another 3 wins in national (same logic applies with losses), and
## then he can get offers from low tier to higher tier international tournaments depending on his ranking" + "the numbers are
## indicative but ... find the right number of fights needed to be noticed at each tier in our research")

### Today's code (Explore map, S148 - file:line in the agent report)
- Gate = FAME only (local 0 / regional 75 / featured 220, GameState.gd:8065, FightGate.gd:36-40, book_fight :13773); fame
  never falls (a loss still +1, AthleteDevelopment.gd:801-805) -> ~7 wins to regional, ~19 to featured, never back down.
- No international offer tier (FIGHT_TIERS stops at featured, GameState.gd:213); "international" is only an arena choice.
- One ranking per division, PRO bouts only (amateur skipped, GameState.gd:15572); win +24 / loss -6.
- Rank never picks the offer tier (every tier is offered at once, get_fight_offers :7996); no per-level win counter.
- Nothing tells the player the next requirement.

### Proposal (numbers authored from research, labelled invented; one data file so the operator's 3 can be swapped in)
- REGIONAL -> NATIONAL: 5 net wins at regional (win +1, loss -1, floor 0). Anchor: England Boxing senior development
  min ~5 contests (G101 l.45); DBV class C < 7 wins (G101 l.57).
- NATIONAL -> INTERNATIONAL: 7 more net wins at national (12 total). Anchor: DBV B <= 14 wins; USA national open 10-15
  bouts + win floor (G101 l.54, l.57).
- INTERNATIONAL: offer tier by division rank - #11-15 low-tier internationals, #6-10 mid, top 5 major events, top 3 +
  2-fight streak -> title shot (existing request, FighterRequests.gd:83-91). Anchor: elite > 25 wins or a vest (DBV),
  compressed for play.
- Losses: -1 level progress AND ranking -12 (was -6). Amateur bouts count toward ranking. Fame keeps money/attention
  (purse, sponsors, members) but stops being the gate.
- Hooks (agent map): level state settled beside the ranking update (GameState.gd:15572); the gate in
  get_fight_tier_fame_requirement + FightGate.check + book_fight's copy; get_fight_offers loops only the fighter's
  level; FIGHT_TIERS gains an international row + VenueLadder.level_for; get_amateur_read / fighter card / CareerGoals
  show "N/5 wins to NATIONAL".
- Pace: ~1 bout / 5 game weeks -> national in ~6-8 months, international in ~1.5-2 years.

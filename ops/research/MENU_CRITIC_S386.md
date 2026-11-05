# Menu map + screen order - harsh critic review (S386, operator: "i want critics to check the game design menu/order rate it
# see if it makes sense can be compacted or needs to be more analitic, and ... start working on the missing scenes")

Critic: Claude sub-agent (read-only), read docs/menu_prototype.html, RESTART_PLAN, Data.gd, FighterPage/Fights/BoutPage/Money/Career,
both Miro menu maps and 6 real screenshots. Ratings: MENU STRUCTURE 4/10, FIRST-HOUR ORDER 3/10.

## Why (top)
- FM-sized menus over Punch-Club content: 7 rail areas / 28 tabs + 7-tab fighter page + 8 modals for 1-2 fighters; stubs
  (Gym > Floor, Facilities, Events, Search, Deals).
- One job in many places: Training (2), Camp (4), Goal (3), Results (2), Money (4).
- First hour: a new career opens with the no-gi BJJ grappler already signed (Career.gd:57) - week-1 review stamps her while
  "No fighter trained this week"; the boxer can stay an unsigned APPLICANT into week 3; empty week reviews fire; the bout is
  accepted with the opponent file at 0 of 4; first fight ~4 weeks of CONTINUE away; Miro's "guided first month" has no code.

## Compact / merge (critic's proposal)
Fighters = Roster + Scouting; Training/Camp/Playbook/Record/Goals become fighter-page tabs (Overview, Week, Playbook, Record,
Contract); PLAYBOOK leaves the rail (7 -> 6 areas); Fights = one page (offers on top, dated timeline, results); Gym = one Club
page (Staff+Members+Facilities), hide Floor; World: News into Mail, hide Search, Nationals into the fighter's road; Camp has one
owner (the camp modal = the fighter's Week tab).

## More analytic
Bout page: her 7 stats vs the opponent's estimated ranges, win-chance band narrowing with scouting, rank impact, readiness vs
camp weeks. Offers rows: mismatch number, opponent rank, ticket cut. Training: whole-point ETAs ("Technique 61 in ~3 weeks"),
goal projection vs deadline, 4-week sparklines (not +0.05). Week review: planned vs actual, causes, goal projection, rank move,
cash runway. Result: landed/thrown per round, round scoring strip, rank change. Fighter page: vs division average and next opp,
last-5 form. Money: runway vs the 4-weeks-below-$0 rule, next 3 bills.

## Missing scenes - necessary
1. Fight-week matchup + readiness (between camp and weigh-in): stats vs opponent, file found, weight + fatigue, win band, one lever.
2. First-week guided path: sign the boxer -> hire coach -> set week 1 -> CONTINUE; no week review until someone trained; skip toggle.
3. Ladder view: her division table, her row + the next 3 reachable opponents.
Nice to have: 3D gym floor, Search, Events, Deals depth, BJJ belt road (post-boxing scope - NOTE: conflicts with operator S353), season summary.

## Ranked build list
1. (S) Ana/BJJ behind a switch + forced sign -> coach -> first week + no empty week review   [BJJ part conflicts with operator S353]
2. (M) Bout page comparison + win band + rank impact
3. (M) Week review around whole points, causes, goal projection, runway
4. (M) Training/Camp/Playbook into the fighter page, PLAYBOOK off the rail   [operator S359: Playbook "really fun" - keep its access]
5. (M) Fight-week readiness screen before the weigh-in
6. (S) Fights tabs into one page + ladder strip; hide stub tabs (Floor, Search, Events)

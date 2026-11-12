# HOSTSHOW1: host your own club show (design map, round 3, S439)

Sources read whole: `CRITIC_PACK.md`, `SCOPE_FOUR_FIGHTERS_S428.md` (item 4: "a permit, a doctor, an MC, a card of about 15 bouts with your
fighters and others, ticket money; the show is the unit of R37"), `R37_ASK_FOR_A_FIGHT_MAP_S428.md` (favours: "a clean show with a club earns a
favour with it; a pull-out by you costs one"), `HYPE_MAP_S432.md`, `BOXING_MANAGER_COMPARE_S425.md`.
Code read for round 3 (each claim names its file and number): `scripts/rules/ClubShow.gd` (whole), `scripts/state/Region.gd` (`day_events` 92-129:
`busy` holds only `f.bout` opponents 101-106, `SHOW_BOUTS` 2 a division a show 14, `before` 183-190, `rankings` 168-179 with ours at `rating` 0.0 176),
`scripts/state/Data.gd` (`SHOW_FIRST_DAY` 12, `SHOW_EVERY_DAYS` 14, rivals 66-185 and their clubs), `scripts/state/Roster.gd` (`pro_ready` 174-184,
`check_pro` 188: only with no bout booked), `scripts/state/BoutNight.gd` (goal judged at the bout 426-432, `update_rank` 433, `check_pro` 459),
`scripts/state/Bouts.gd` (`withdraw_bout` 270-280 and its news words 274, `weigh` 328-342, `short_notice` 252, `check_pro` 413),
`scripts/rules/FighterGoal.gd` (`progress` 96-158: MET only when every target is reached; `SUCCESS_MORALE_DELTA` +10, `FAILURE_MORALE_DELTA` -20),
`scripts/rules/FighterProfile.gd` (`MORALE_EVENTS` 20-33; `month_no_fight` has no caller: grep finds only line 25), `scripts/state/GymSpend.gd`
(`member_cap` 115, `member_target` 132, `member_limit` 140-147), `scripts/rules/GymSlots.gd` (`member_room` 67 = places x 3), `assets/data/gym_slots.json`
(the opening floor: 22 places), `scripts/rules/Membership.gd` (48 + 0.6 a point, x the dues band's draw: Cheap 1.15, Premium 0.85), `scripts/state/Sim.gd`
(`weigh_forecast` 131-155: one weight, no spread; the coming weeks' twist cards are not drawn), `scripts/rules/BoutRules.gd` (`WEIGH_TOLERANCE` 0.05 87,
`MISSED_WEIGHT_COST` 88, `TICKET_CUT` 89, `stale_energy` 165: 2 Energy a fatigue point over 50, at most 20, only with a camp), `scripts/rules/WeekPlan.gd`
(`CUT_DEFICIT` 500 74, burn 245-263).

Marks: **CODE** = in the code today (file and name given). **ESTIMATE** = ours, measured by HOSTPROBE1 (section 9) before a screen shows it.
**NEW** = a rule that does not exist yet. **[R]** = a real-world number from the research files above. Game text never uses he, she, her or him.

Drawn: `docs/mockups/s439/hostshow/screen_r3.html` / `.png` (Fights > Our show, Thu 9 Jul, 16 days out, the moment Priya Nair's no arrives).

## 0. What changed in round 3 (each critic finding answered in the mechanic)
| Finding | What changed |
|---|---|
| Three rank lines wrong by `Region.before` | Every rank line is now a CONDITION, worked with `before` on the table after the night's other bouts and the region's show before it. Danny's ladder row now says "No. 3 only if Danny boxes and wins and Liam wins"; the novice tile "No. 3 if Liam beats Dean (38 in 100), else No. 4"; Lucy's ladder row "counts only if Lucy boxes Maria and wins". ShowCard tests one case each (task 6). |
| The region's show on Sat 18 Jul ignored | HOLD RULE (NEW, one line in `Region.day_events`' `busy`): every name on our card, opponent or visiting pair, is held from the region's shows from the day it goes on the card. The show is a node on the timeline with the names still free ("Priya Nair and Ellie Ward free: may meet"), and every rank line counts it (Maria's route: 33 in 100, both roads counted). |
| No combined number; the player multiplies | Each Lucy tile prints one number: "Pro offer from this show: N in 100", counting a second ask after a no; "Lucy wins N in 100" with the band in brackets. |
| "Pay their travel $120" was always right | CUT. Replaced by FAVOURS per club (R37 brought forward): a small count each (0 to 3), spent on +3 in 10 on a yes, on a ladder swap, on a stand-down without bad blood; earned by a clean bout of ours against one of that club's boxers. The same club's one favour now has two uses on the screen (section 4.5). |
| The return-bout promise had no real price | Its price is now the pro offer: `check_pro` runs on the night (BoutNight 459, CODE) and the return bout is written the Monday after, so the offer is not blocked, but turning pro breaks the promise: that club's favours -2. Shown on the tile. |
| Ladder Swap was free | A swap costs one favour with EACH club that moves a boxer, and both clubs must say yes (7 in 10, 3 days). Its options show inline with their odds and the Supervisor's band. The one swap worth drawing: Erin v Priya, two names above Lucy, one of whom must lose. |
| Danny's ladder did nothing | True (`before`: a Liam win leaves Liam 8-5 above Danny 4-1). The pair stays one plain line; no swap is offered: at 4 wins a rank opens nothing (the pro offer needs 7, CODE). |
| Samira: no miss chance, Stand down a lookup on the chip | Three priced tiles: Keep the cut (miss 1 in 6), Harder fight week (two Hard interval mornings: miss 1 in 25, Energy -12 on the night), Stand down (-25 seats, one Islington favour). The miss chance is NEW (`WeighOdds`, section 4.4). |
| Danny's "Leave off" only had costs; "-6 morale" is not in the code | The -6 is gone from the screen until MOODIDLE1 lands. The real price found in the code: the goal is judged at the bout (`BoutNight` 426-432) and is MET only when the target is reached, so a bout before the goal is done costs -20 morale (CODE). Leave off keeps the full weeks: the goal is met Thu 23 Jul and pays +10 at the next bout. |
| The price grid was a lookup per hall | CUT. Each hall has its price; the hall is the choice; the door price can only be cut at the read. |
| The ticket read panel was not actionable for 4 days | It is a timeline node until Mon 13 Jul. The favours panel takes its place. |
| Member room named only the premises | Read from `GymSpend.member_limit`: the opening floor's 22 places x 3 = 66 binds before the Unit's 70 and the coaches' 110; reputation 30 fills it at standard dues (Cheap: 16). An "Add places" button opens the gym picture. |
| Wrong words | Our stand-down writes its own news line (`withdraw_bout` gets a reason, NEW). No pronouns; "reputation" in full; "brings 28 tickets". |

## 1. The idea in five lines
1. About three times a year (`ClubShow.EVERY_DAYS` 112, CODE) the club puts on its own amateur show: you pick the date and the hall, and you are the
   matchmaker.
2. For each of your boxers you choose whom to ask (a name above, a name below, an outside novice, a skills bout, wait, or nobody) and how (as it is,
   with a favour, or with a promised return bout); each tile prints the yes chance, the win chance, the rank line as a condition, and the pro-offer
   chance from the show.
3. The coach fills the rest of the card; pairs that hold a name above one of your boxers are LADDER pairs, and a swap costs favours with both clubs.
4. The region's shows go on around yours; names on your card are held from them, the free names may move the table before your night.
5. The night: your bouts in front of your own crowd; the sheet gives the money against boxing the same bouts away, reputation part by part (and the
   members it can still buy), the rank moves, the pro offer if it came, and the favours earned or spent.

## 2. What is built today (read in the code)
- `ClubShow.gd` (pure, 59 lines): COST $3,500 at booking (comment: venue ~$2,000, officials + doctor + ambulance ~$1,200, trophies ~$300), TICKET $25,
  HALL 400, EVERY_DAYS 112, LEAD_DAYS 28, draw = 40 + 0.7 a member + 1.0 a reputation point + 2.5 a junior + 25 a home boxer, LUCK 0.70-1.15, RAFFLE
  $600-$1,400, one member per 40 tickets on a night that made money. CODE.
- `GymSpend.book_show` / `day_events`: pays, rolls luck and raffle, pays tickets and raffle, adds members, one news line. `home_boxers` = every
  uninjured amateur, boxing or not. CODE. One screen: Club > Money, CLUB SHOW row (`ClubSpend._show`). CODE.
- An away amateur bout pays $450 (`BoutRules.TICKET_CUT` 89). Win +8 members, +5 reputation; loss -1, -2; stoppage loss -2, -4 (`BoutRules` 90-99).
  A short-notice win doubles the reputation only (`BoutNight` 363-366). CODE.
- The region: a show every 14 days from day 12 (`Data` 101-102); at each, up to 2 bouts a division (`Region.SHOW_BOUTS`) from the rivals not booked
  against one of ours (`busy` = `f.bout` opponents only, 101-106), the novice rule both ways. `rankings` orders by net wins, then wins, then rating;
  ours carry 0.0 (176) and lose every tie. CODE.
- Pro offer: `pro_ready`: 7 wins and a top-3 place, or 9 wins; `check_pro` makes it only when no bout is booked, and runs after every bout
  (`BoutNight` 459, `Bouts` 413) and in the weekly step (`Sim` 406). CODE.
- Goals: judged at the bout night (`BoutNight` 426-432): MET only if every target is reached that day (`FighterGoal.progress` 127-137), else missed;
  met +10 morale, missed -20 (`FighterGoal` 29, 31). CODE.
- Morale moves (`FighterProfile.MORALE_EVENTS`): win +8, loss -12, booked +5; `month_no_fight` -6 has no caller. CODE.
- Weight: `Sim.weigh_forecast` gives one weight for the weigh-in day, with next weeks' twist cards left undrawn (144). The weigh-in is the day
  before; `made_weight` allows 0.05 kg; a miss calls the bout off and the club pays $300 (`Bouts` 328-342). CODE.
- `stale_energy`: 2 Energy a fatigue point over 50, at most 20, and only when the bout has a camp (`BoutRules` 165-168). CODE.
- Members: `member_target` = min(`natural_members`, `member_cap`); `member_cap` = min(premises - upgrades' room, coaching cap, equipment places x 3) +
  kit; `member_limit` names which binds. The opening floor holds 22 places (66 members). CODE.

## 3. What is thin
1. The show has no card; every uninjured amateur counts 25 tickets whether boxing or not.
2. One decision (book or not), always yes for a grown club.
3. A night leaves only cash: nothing touches reputation, ranks or the pro offer.
4. It lives only on Club > Money.
5. World defects: ours lose every rank tie (RANKTIE1); the men's lightweight novice pool empties (Liam Doherty is open after one more bout);
   several "London" opponents carry clubs far away (`Data` 66 Guadalajara, 69 Leicester, 72 Belfast, 183 Rotunda, 184 Everton; DATAFIX1).
   Section 6 uses the club names the code holds today.

## 4. The mechanics, each a decision with its options and prices

### 4.1 Date (8 weeks out or more)
- One of the next four free Saturdays at least 8 weeks out ([R] England Boxing permits 8 to 12 weeks ahead; `LEAD_DAYS` 28 becomes 56).
- A Saturday that is also a region show (CODE days 12 + 14k) splits the crowd: draw x0.8 (ESTIMATE). Each boxer shows per date: free, booked elsewhere
  (`f.bout.day`), suspended, in the nationals (`Champs.active`). CODE.
- The region's show a week before ours matters too (4.6): the screen names it per date.
- A decision because the nearest Saturday is often the one a boxer cannot make.

### 4.2 Hall (one choice at booking; the price comes with the hall)
| Hall | Seats | Rent | Ticket | Card | A name above says yes (base) | Full (85%+) | Half-empty (<50%) |
|---|---|---|---|---|---|---|---|
| The gym floor | 120 | $300 | $35 | 6 bouts | 3 in 10 | +3 reputation | -3 |
| Community hall | 250 | $1,000 | $25 | 9 bouts | 5 in 10 | +4 | -3 |
| Town hall | 400 | $2,000 | $25 | 12 bouts | 7 in 10 | +6 | -4 |
Every hall also pays officials, doctor and ambulance $1,200 and medals $300 (the `ClubShow` comment's split, CODE comment). 30% of the rent at
booking. All other numbers ESTIMATE ([R] club show crowds 200-500, tickets GBP 12-20).
The booking screen shows per hall: likely net, net on a bad night (1 in 10), full chance, half-empty chance, the names' yes (`ClubShow.v2.preview`).
A decision because the halls trade money, a sure full room, and the names: the town hall buys +2 in 10 on every name above and three more pairs
(more ladder pairs) for less likely money and a real chance of a half-empty -4 (6.10). The price was a separate choice in round 2: per hall one price
always won, so it went.

### 4.3 Your boxers on the card (the matchmaker's choice, one per boxer)
The card opens 19 days out; the bout sheet closes 3 days out ([R] R37). One open ask per boxer; answers in 3 days (NEW, ESTIMATE). Posters print at
the ticket read, 12 days out: a main event settled by then sells its poster tickets (4.7). A name who says no is spent for that boxer this show.
Every tile prints: yes chance; "<boxer> wins N in 100 (band)" (`BoutRead.band`, CODE); the rank line on a win and a loss AS A CONDITION
(`RankLine.after`, NEW, on `Region.before`, CODE, after the night's other bouts and the region's show); the pro-offer chance from the show
(`Roster.pro_ready`, CODE, on each branch); seats it brings; reputation.
- A NAME ABOVE: yes = the hall's base + 1 in 10 for every 2 rating points that name holds over ours, at most 9 in 10 (ESTIMATE). Win +5 reputation,
  +8 members (CODE). The card's highest-ranked opponent makes the main event (4.7).
- A NAME BELOW: yes 9 in 10 (ESTIMATE). A home win over a name below: +3 reputation, not +5 (ESTIMATE, [R] HYPE_MAP 2.1); members +8 (CODE).
- AN OUTSIDE NOVICE (only when the pool holds no legal name): always yes, travel $80, no tape (`OppFile`, CODE), band about 30-70.
- A SKILLS BOUT (only when the pool holds no legal name): the same outside novice, $80, three rounds, no winner given ([R] England Boxing skills bouts).
  It runs through `BoutNight` without a result (NEW: no record, rank, win/loss morale, members or reputation), so `booked` +5 applies and the GOAL IS
  JUDGED, as at any bout (CODE 426-432).
- WAIT FOR THE REGION'S SHOW: no ask now; ask once after it (one ask only: the answer must land before the sheet closes). Costs the poster tickets;
  keeps the favours; the rank lines are read with the region's result known.
- NOT ON THE CARD: full training weeks; other clubs' offers keep coming (CODE); the goal is not judged that night. (`month_no_fight` -6 appears on the
  tile only once MOODIDLE1 gives it a caller.)
- HOW TO ASK (inside each tile, where it can change anything): AS IT IS; WITH A FAVOUR (that club's favours -1: +3 in 10, still at most 9 in 10);
  PROMISE A RETURN BOUT (9 in 10, no favour now: our boxer's next bout is fixed, away at their show against the same name within 12 weeks, $450 cut as
  usual, CODE; HostShow writes it into `f.bout` the Monday after our night, so the night's `check_pro` (BoutNight 459) is not blocked; turning pro or
  standing down breaks it: that club's favours -2 (NEW)). A how-to-ask choice that cannot change the yes (a name already at 9 in 10) is not drawn.
- STAND DOWN (after a yes): `Bouts.withdraw_bout` (CODE: camp ends, offers resume after 5 days) with our own words in the news (NEW reason); the
  boxer's seats leave the draw; that club's favours -1.
- RULES ON EVERY TILE: the novice rule (`experience_match_ok`, CODE); the Supervisor's line: no bout whose band tops out under 30 for either boxer
  (NEW, on the band the player sees). A refused name is greyed with its reason. Weight class matches (product rule): no catchweights.

### 4.4 Weight on our own show (a decision with three prices)
- MISS CHANCE (NEW `WeighOdds.miss`, pure): runs `Sim.weigh_forecast` once for each twist card that can be drawn on each coming Monday (WeekTwist's
  weights), and counts the share over limit + 0.05. Printed "misses 1 in 6".
- KEEP THE CUT: on a miss the bout is off on the weigh-in day; we host, so no $300 (NEW); the crowd has its tickets; reputation -2 and that club's
  favours -1 (ESTIMATE / NEW).
- HARDER FIGHT WEEK: two of the fight week's rest mornings become Hard intervals (the week editor, CODE): about -0.17 kg (11.0 MET x 62 kg x 0.75 h x
  1.3 x 2 / 7,700, `WeekPlan` 245-263 formula; ESTIMATE hours) and fatigue about 56 on the night: Energy -12 by `stale_energy` (CODE rate; NEW: the
  fight week counts as a camp of protocol 1 for it). Win chance falls (shown).
- STAND DOWN: section 4.3.
- A decision because each answer pays in a different coin: risk and a favour, Energy on the night, or seats and a favour for sure.

### 4.5 Favours with other clubs (R37's ledger, brought forward)
- Each club holds 0 to 3 favours with us (NEW, `Career.favours`, starts at 1 with each club a boxer of ours has met, 0 with Eastside ABC).
- EARN: a clean bout of ours against one of that club's boxers, home or away (no pull-out and no missed weight by us): +1, at most 3.
- SPEND: +3 in 10 on a yes; one per club on a ladder swap; a stand-down or a missed weight (-1, forced). A broken return-bout promise: -2.
- OWED (below 0): that club's yes -2 in 10 on everything until a clean bout brings it back to 0.
- A decision because one club's single favour has more than one use on the same screen (Belfast Gloves ABC's: Erin's yes, or half of the Erin v Priya
  swap), and every one spent now is not there for the next show or for an away ask (R37).

### 4.6 The region's show before our night (a rule, shown)
- HOLD (NEW, `Region.day_events`' `busy` also takes `c.show` card names): a name on our card does not box at the region's shows.
- The names still free in a division with one of ours can box (CODE, 2 bouts a division). The timeline names them, and every rank line is read
  over both outcomes. In section 6 the Maria route counts "Priya Nair loses on Sat 18 Jul" as its second road.

### 4.7 The crowd: followings, visitors, main event (rules)
- Each of our boxers on the card brings 10 + 3 a win (ESTIMATE; replaces `PER_HOME_BOXER` 25): Lucy 28, Samira 22, Danny 22.
- Each boxer from another club brings 3 supporters; the host pays $40 travel each (ESTIMATE). Outside novices bring none ($80).
- MAIN EVENT: the bout with the highest-ranked opponent closes the night. If settled by the posters it sells half its boxer's following again, +10 with
  a pro offer on the line (ESTIMATE). Main-event win +3 reputation, loss -3 (ESTIMATE).

### 4.8 Ladder pairs (visiting bouts that move our boxers)
- The coach fills the card with legal pairs; visiting bouts are settled first on the night with `Region._rival_bout` (CODE), so `update_rank` and
  `check_pro` on our bouts see them.
- A LADDER pair holds a name above one of ours whose loss can lift our boxer. Its line says the condition in full ("counts only if Lucy boxes Maria and
  wins") and the odds (`WorldBout.fast`, probed).
- SWAP: the legal swaps inline, each with its odds, the Supervisor's band, and its price (one favour with each club that moves a boxer; both say yes 7
  in 10; 3 days). Pairs that move none of ours are one line, no button.

### 4.9 The ticket read (12 days out; a timeline node until that day)
Advance luck is drawn; the read shows sold so far (69% of the night's figure, [R]) and the band for the night. Options, each with its money against Keep:
KEEP; DOOR PRICE $15 for walk-ups (x1.3 draw on the last third); SELL (each boxer on the card gives up one fight-week pad evening, 75 min of pads =
about 2.6 mastery on the move drilled, `PadWeek` 2.1 an hour, CODE rate; +10 seats each); ANA SELLS (one no-gi class less: the closest syllabus move
-1.1, 3.2 a week over 3 classes, CODE; +10 seats; no fight-week cost); MOVE DOWN (deposit lost, smaller hall, card cut from the visiting pairs); CANCEL
(deposit lost, -3 reputation, every club on the card -1 favour).

### 4.10 Pull-outs, the night and the sheet
- An invited opponent pulls out 1 in 10 in the last week (ESTIMATE): tougher replacement (`Bouts.short_notice`, CODE), outside novice, or stand down.
  A night with under two-thirds of its card is a SHORT NIGHT: -2 reputation (ESTIMATE; on the sheet, not on the planning screen).
- The night: visiting bouts settle first, then ours as fight nights (`Bouts.fighting_today`, CODE), main event last; "Sim to result" for any.
- THE SHEET: money in parts, NET, against away ($450 a boxer who had a legal away bout, CODE); reputation part by part; members (CODE) and where they
  settle under `member_cap` with `member_limit` named; rank moves; the pro offer; favours earned and spent; next show's crowd (full: +15% of sold;
  half-empty: -10%; ESTIMATE).

## 5. Every decision (B before, D during, A after; the last column is the designer's test, NEVER printed)
| When | Decision | Options and prices | Right when (never on screen) |
|---|---|---|---|
| B | Date | 4 Saturdays; region-show clash x0.8; who is free | The date most boxers can make, unless cash is needed sooner |
| B | Hall | Gym floor / community / town (4.2) | Gym floor: a young club or tight cash. Community: most money. Town: a boxer one win from the pro offer whose name above says no too often |
| B | Lucy's route | Erin as it is 40 / with the favour 44 / with a promise 44 / Maria 36 / Maria + swap 54 / wait 37 (in 100, section 6) | Strong Lucy and favours needed elsewhere: Erin as it is. Favours to spare: Maria + swap. Belfast Gloves favour wanted later: wait |
| B | Samira's weight | Keep (1 in 6) / harder week (1 in 25, Energy -12) / stand down (-25 seats, a favour) | Margin 0.1 kg: harder week. 0.4: keep. 0.8 over: stand down |
| B | Danny | Outside novice / skills bout / leave off | Goal done and morale Steady: novice. Goal done and Flat: skills bout. Goal on the line: leave off |
| B | Ladder swap | Keep the coach's pair / swap (a favour each club) | Swap when it turns a condition into a near-certainty for a pro offer |
| B, read | Keep / door / sell / Ana sells / move down / cancel | 4.9 | Sell when the band ends within 30 of full and no move is one session from Sharp |
| D | Pull-out | Tougher / novice / stand down | Tougher when its band stays 40+ |
The probe (section 9) checks each row against these cases; any tile that wins in every case is cut or re-priced.

## 6. One show, played (real numbers; CODE or ESTIMATE on each)
State on Mon 25 May 2026 (day 140): 58 members, reputation 24, standard dues, no juniors, the Unit (70), one hired coach (coaching cap 110), the opening
floor (22 places: room 66, CODE `member_limit` "equipment"), cash $11,700. Natural members at reputation 24: 62 (CODE); reputation 30 fills the 66.
Favours: Belfast Gloves ABC 1, Leicester ABC 1, Islington BC 1, Dale Youth ABC 1, Everton Red Triangle ABC 1, Eastside ABC 0 (NEW).
Boxers (records are the state assumed for the example):
- Lucy Jackson 6-1, women's 60 kg, No. 4, novice (7 bouts), fight power 62.5 (RANKTIE1 rating), goal met.
- Samira Khan 4-2, women's 65 kg, No. 4, novice, forecast 64.9 kg for 65.0, morale Steady 58.
- Danny Osei 4-1, men's 60 kg, No. 4, novice; lost Sat 27 Jun; morale Flat 41; goal "Stamina for five rounds" (`five_round_engine`: Conditioning +2.5,
  set Mon 29 Jun, deadline Mon 27 Jul, CODE archetype), +1.3 done on Thu 9 Jul.
- Ana Ribeiro (no-gi): not on the boxing card; can sell tickets at the read (4.9).
Tables: women's 60: 1 Dana Whitfield 14-2, 2 Erin Doyle 8-2 (65.5, Belfast Gloves), 3 Priya Nair 7-1 (63.5, Leicester), 4 Lucy 6-1, 5 Sophie Turner 8-4
(open), 6 Chloe Bennett 6-3 (Dale Youth), 7 Maria Ortega 4-2 (61.5), 8 Ellie Ward 4-2. Women's 65: 1 Kerry Walsh, 2 Rosa Delgado 7-2, 3 Laura Finch 5-2
(62.0, Islington), 4 Samira 4-2, 5 Jade Okoro 3-1. Men's 60: 1 Mateusz Kowalczyk, 2 Arjun Patel 10-3, 3 Dean Clarke 8-5, 4 Danny 4-1, 5 Liam Doherty 7-5.

1. BOOK (Mon 25 May): Sat 25 Jul (day 201); region shows Sat 18 Jul and Sat 1 Aug (days 194, 208, CODE). Community hall, $25. Deposit $300.
2. CARD OPENS (Mon 6 Jul): Samira asks Laura (5 + 1 = 6 in 10); Lucy asks Priya (5 in 10). The coach's women's 60 pairs: Erin v Chloe (LADDER for
   Lucy), Dana v Sophie (no ladder); men's 60: Dean v Liam.
3. THU 9 JUL (drawn): Laura YES; Priya NO. Lucy's routes (worked with `before`; wins from `BoutRead.band`, ESTIMATE):
   - ERIN AS IT IS: yes 6 in 10 (5 + 3.0/2); Lucy wins 45 (38-52). Win: Lucy 7-1 (net 6) passes Erin 8-3 (net 5). Sat 18 Jul: Erin, Chloe, Dana, Sophie
     are held, so Priya and Maria (both novices, the only two free) meet. Priya wins: 8-1 (net 7), Lucy No. 3. Priya loses: 7-2 (net 5), Lucy No. 2.
     Either way top 3 with 7 wins: PRO OFFER on the night. Loss: 6-2 (net 4), behind Sophie 8-4 and Chloe if Chloe wins her new pair: No. 5 or 6.
     A no (4 in 10) leaves one ask after the posters: Maria (below, 33). Pro offer from the show: 0.6 x 0.45 + 0.4 x 0.33 = 40 in 100. Main event:
     Lucy's (Erin No. 2): +24 poster seats instead of Samira's +11.
   - ERIN WITH A FAVOUR (Belfast Gloves 1 -> 0): 9 in 10: 0.9 x 0.45 + 0.1 x 0.33 = 44 in 100.
   - ERIN WITH A PROMISE: 9 in 10, 44 in 100; and in the 41 in 100 where the offer comes, turning pro breaks the promise: Belfast Gloves 1 -> -1 (owed).
   - MARIA AS IT IS: yes 9 in 10; Lucy wins 65 (58-72). Win: 7-1 ties Priya on net and wins; Priya's 63.5 beats 62.5: No. 4 unless (a) Chloe beats Erin
     in the ladder pair (42 in 100): Erin 8-3 drops, Lucy No. 3; or (b) Erin wins and Priya loses on Sat 18 Jul: Maria is held (on our card), so the free
     novices are Priya and Ellie, who meet; Priya loses 25 in 100: Lucy passes Priya (7-2), No. 3. Road: 0.42 + 0.58 x 0.25 = 0.565.
     Pro offer: 0.9 x 0.65 x 0.565 + 0.1 x (Erin after a no: 0.6 x 0.45) = 33 + 3 = 36 in 100. Win reputation +3. Main event stays Samira's.
   - MARIA + SWAP ERIN v PRIYA (Belfast Gloves 1 -> 0, Leicester 1 -> 0; both clubs yes 7 in 10; Supervisor: Erin wins 55, band 48-62, allowed): one of
     the two names above Lucy must lose; a Lucy win is No. 3 either way. 0.9 x 0.65 x (0.7 + 0.3 x 0.565) = 51, + about 3 if Maria says no = 54 in 100.
   - WAIT FOR SAT 18 JUL: no ask; Priya and Maria (both free) meet there. Priya loses (35 in 100): any Lucy win is No. 3, then ask Maria (5-2 by then,
     yes 9, wins 62): 56. Priya wins: ask Maria (4-3) or Erin, about 27. 0.35 x 0.56 + 0.65 x 0.27 = 37 in 100; both favours kept; no poster seats
     (-13 against Erin); one ask only, answered Tue 21 Jul, the sheet closes Wed 22 Jul.
   - DANNY (goal +1.3 of 2.5 done; full weeks bring it to 2.5 on Thu 23 Jul; with the fight week from Mon 20 Jul, Light with three rest days, 2.2 on the
     night, ESTIMATE from `Sim.daily_gain`):
     Outside novice: booked +5; wins 50 (30-70); win: "No. 3 if Liam beats Dean (38 in 100), else No. 4" (Dean 9-5 net 4 beats Danny 5-1 net 4 on wins);
     loss: 4-2, No. 5; goal judged on the night, 2.2 of 2.5: missed -20 (CODE). Morale after: win 41+5+8-20 = 34 Flat, loss 14 Low. +22 seats.
     Skills bout: booked +5, goal missed -20: 26 Low. +22 seats.
     Leave off: goal met Thu 23 Jul (+10 at the next bout, CODE); morale 41 now; 0 seats.
   - SAMIRA (miss 1 in 6, NEW `WeighOdds`): Keep; Harder week (64.73 kg, miss 1 in 25; fatigue 56: Energy -12; wins 38 -> 33); Stand down (-25 seats:
     22 following + 3 Laura's supporters; Islington 1 -> 0). Samira v Laura: wins 38 (31-45); win: 5-2 (net 3) passes Laura 5-3: No. 3 (Jade, free on
     Sat 18 Jul, reaches 4-1 at best: net 3, 4 wins, below); loss: 4-3, No. 5.
   The player asks Erin as it is, keeps Samira's cut and leaves Danny off (goal on the line).
4. FORECAST (with those picks): club 40 + 0.7 x 58 + 24 = 104.6 (CODE formula); followings 28 + 22 = 50; posters 24; supporters: 6 visiting pairs = 12
   + Laura + Erin = 14 x 3 = 42; draw 220.6 at $25 in 250 seats. Luck 0.75-1.10 x 0.93-1.05 (200,000 draws, ESTIMATE): sold 171 (1 in 10 under) / 202
   likely / 233 (1 in 10 over); full (213+) 36 in 100; never half-empty. Costs: hall $1,000 + $1,200 + $300 + travel 14 x $40 = $560: $3,060.
   Likely: 202 x $25 = $5,050 + raffle about $1,000 - $3,060 = +$2,990; 1 in 10 under +$2,160; 1 in 10 over +$3,820. Away instead: $900 (Lucy and Samira
   $450 each, CODE). What moves it: Maria instead of Erin -13 seats; Danny on the card +22 seats (full room 61 in 100, likely +$420); Samira stands down -25.
5. SUN 12 JUL: Erin says yes. Erin v Chloe ends; the coach pairs Chloe v Ellie.
6. MON 13 JUL, THE READ: advance luck 0.96: sold so far 220.6 x 0.96 x 0.69 = 146; the night 197 to 222. Sell (+20 seats for two pad evenings) would
   lift the full chance; the player keeps (Lucy's pads are on the main event's answer).
7. SAT 18 JUL: Priya beats Maria (Priya 8-1). Lucy's win line still reads No. 3.
8. FRI 24 JUL: Samira makes 64.95 kg (CODE tolerance 65.05).
9. THE NIGHT (Sat 25 Jul): walk-up 1.00: 212 sold (85% is 213: just short of full). Money: 212 x $25 = $5,300 + raffle $1,050 - $3,060 = NET +$3,290.
   Visiting bouts first: Dean beats Liam. Samira loses to Laura (-1 member, -2 reputation; 4-3, No. 5). Lucy beats Erin (+8 members, +5, main event +3):
   7-1, No. 3; `check_pro` on the night: PRO OFFER ($1,500 debut purse, CODE). Reputation 24 + 6 = 30. Members 58 + 8 - 1 + 5 (212 / 40) = 70; target
   min(48 + 18 = 66, room 66) = 66: 4 drift away; the sheet says "the gym is full: the equipment's 66 places; Add places". Favours: Belfast Gloves +1
   (2), Islington +1 (2). Against away: +$3,290 against $900.
10. THE BAD NIGHT, same picks: advance 0.76, walk-up 0.95: 159 sold (64%). 159 x $25 + $700 - $3,060 = +$1,615. Lucy loses (-2, main event -3; 6-2,
    No. 5), Samira loses (-2): reputation 17, target 58. Still over the $900 away; the pro offer is months off.
11. THE TOWN HALL, BAD NIGHT (12 bouts: 9 pairs + Laura + Erin = 20 visitors x 3 = 60; draw 104.6 + 50 + 24 + 60 = 238.6; travel $800; costs $2,000 +
    $1,200 + $300 + $800 = $4,300): luck 0.70: 167 sold, 42%: HALF-EMPTY -4. 167 x $25 + $600 - $4,300 = +$475: LESS than the $900 away.

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows (only what the player can act on) | Wired to |
|---|---|---|
| Fights > OUR SHOW (tab beside Bouts) | PLAN: 4 Saturdays (who is free, region-show clash), 3 hall cards. BOOKED: header (date, hall, seats, price, booked date, days); timeline (asks left, posters and read, the region's show with the free names, fight week, sheet, weigh-in, night); a row per boxer (weight, condition, morale, goal chips; tiles with yes, win, conditional rank lines, pro offer from the show, seats; how to ask inside the tile; stand down; weight answers); ladder pairs with priced swaps; THE NIGHT (seats bar, what moves it, money that adds up, against away); REPUTATION AND MEMBERS (parts, the binding member limit, Add places); FAVOURS (per club). THE READ on its day. AFTER: the sheet | `ClubShow` v2, `ShowCard`, `HostShow`, `RankLine`, `Favours`, `WeighOdds`, `Region` (hold rule, RANKTIE1), `Roster.pro_ready`, `BoutRead.band`, `Sim.weigh_forecast`, `Sim.daily_gain`, `FighterGoal.progress`, `GymSpend.member_target` / `member_limit` |
| Club > Money > CLUB SHOW row | Not booked: "Plan a show" (opens the tab), greyed with the opening date. Booked: date, hall, deposit, likely net | `ClubSpend._show`, `GymSpend` |
| Club > People (new FAVOURS line under staff) | Each club and its favours, what earns one | `Favours` (R37's Network screen later) |
| Home: notice board + COMING UP | "The card is open: ask opponents"; "Priya Nair said no: ask for Lucy before the posters"; "Ticket read"; "Samira: weight answer"; "Pull-out"; "Show night". COMING UP: the show, the read, the region's show, the sheet | `Needs`, `HomeNeeds`, `Career.show` |
| Top bar | Flags SHOW CARD / TICKET READ / PULL-OUT / SHOW NIGHT; NEEDS YOU while a boxer on the card has no ask out before the posters | `Clock.next_stop`, `Needs.blockers` |
| Fighter page > Overview, NEXT BOUT | "Our show, Sat 25 Jul, main event v Erin Doyle" or "Asked: Erin Doyle, answer Sun 12 Jul"; an owed return bout; the goal chip says "judged at the bout" when a bout is booked before it is met | `Career.show`, `f.bout`, `Sim.goal_read` |
| Fighter page > Week | The fight week; harder-week mornings if chosen; a TICKETS evening if chosen at the read | AMATEURWEEK1, `DrillWeek` |
| Fights > a bout offer | For a boxer on our card: "on our show that night"; an owed return bout arrives marked "promised"; an offer against a club we hold favours with shows "+1 favour on a clean bout" | `Bouts.day_events`, `Favours` |
| Fight night: tale of the tape | "Crowd 212, our show, main event" | `FightNight`, `Attendance.of` |
| Result and the Why: THE CLUB tile | "Our show: on the night's sheet" instead of +$450; main event part; "No. 3: 7 wins, a pro offer"; favour earned | `BoutNight` (no cut on our show), `RankLine`, `Favours` |
| The night's sheet | Section 4.10 | `ClubShow.settle`, `RankLine.after`, `Region`, `GymSpend.member_limit`, `Favours` |
| World > News and Rankings | Visiting results "on Anvil Street's show"; rank arrows | `Region._rival_bout`, `Region.rankings` |
| Week review (the Monday after) | The show's net and reputation with causes; members settling; favours | `WeekReview`, `Career.show.night` |
| Club > Money: one-offs and cash forecast | Deposit; the night's costs; tickets and raffle; the likely net in the runway line | `Career.pay`, `CashForecast` |
| Handbook | Club show, Hall, Card, Main event, Posters and the ticket read, Ladder pair, Swap, Favours, Skills bout, Return bout, Short night | `Handbook` |
GOLDEN-PATH STEP (task 10): book the community hall; ask a name above (answer no), then a second name with a favour (yes); leave a boxer with a goal on
the line off; take the harder fight week for a boxer 0.1 kg over; keep at the read; fight the bouts; check the sheet's net, away line, reputation parts,
member limit, rank lines, pro offer on the night, favours earned and spent, against `ClubShow.settle`, `Roster.pro_ready` and `Favours`.

## 8. Build tasks (each under 500 lines, one owner, the test red first)
| # | Task | Owner | Owns | The test (red on main first) |
|---|---|---|---|---|
| 1 | RANKTIE1: ours carry `BoutRules.fight_power` (no camp) as `rating` | Qwen | `Region.gd` (one line + helper), `tests/rank_tie_test.gd` | "ours with a higher power wins the tie" |
| 2 | MOODIDLE1: `month_no_fight` -6 on the 30th day without a bout | Qwen | `Roster.gd` (~15), `tests/mood_idle_test.gd` | "30 days with no bout costs 6 morale" |
| 3 | DATAFIX1: regional opponents' clubs inside the region | Qwen | `Data.gd` 66-185 club strings | `tests/data_clubs_test.gd` |
| 4 | HOLD1: names on our show's card are busy at the region's shows | Qwen | `Region.gd` `day_events` (~6), `tests/region_hold_test.gd` | "Erin on our card does not box on Sat 18 Jul" |
| 5 | Favours + WeighOdds (pure) | Qwen | `scripts/rules/Favours.gd` (~120), `scripts/rules/WeighOdds.gd` (~90), tests | "a stand-down costs one", "owed: yes -2 in 10", "64.9 of 65.0 misses on a head-cold week" |
| 6 | ShowCard + RankLine: tiles, conditional rank lines on `before`, pro offer from the show, swaps with prices | Qwen | `ShowCard.gd` (~320), `RankLine.gd` (~120), `tests/show_card_test.gd` | "Danny's ladder row: No. 3 only if Danny wins and Liam wins", "the novice tile: No. 3 if Liam beats Dean, else No. 4", "Lucy's ladder row counts only with a Lucy win over Maria", "Erin v Priya swap: a Lucy win is No. 3 both ways" |
| 7 | HOSTPROBE1 (pure, cloud) | Goose | `tools/host_probe.gd`, `ops/research/HOSTPROBE1.md` | section 9 bars |
| 8 | ClubShow v2: halls, two-part luck, followings, supporters, travel, posters, room reputation, main event, short night, comeback, `settle`, away line | Qwen | `ClubShow.gd` (~230), `tests/club_show_v2_test.gd` | "half-empty town hall costs 4", "a full gym's reputation adds no members" |
| 9 | HostShow state: book, asks, answers, posters, read, weight answers, stand down with our words, pull-outs, return bout written the Monday after, visiting bouts first, skills bout through BoutNight with no result, fight week as protocol 1 for `stale_energy` | Claude | `HostShow.gd` (~420), small edits `GymSpend.gd`, `BoutNight.gd`, `Bouts.withdraw_bout` (reason) | `tests/host_show_flow_test.gd` ("the pro offer comes on the night with a promise made") |
| 10 | Fights > Our show tab from screen_r3 | Cursor | `OurShow.gd` (~460) + `OurShowTiles.gd` (~300) | `tests/our_show_screen_test.gd` |
| 11 | Needs, top bar, Money row, People favours line, fighter NEXT BOUT, offers, the sheet, Why tile, Week review, News | Cursor | `Needs.gd`, `HomeNeeds.gd`, `ClubSpend.gd` edits; `ShowSheet.gd` (~300) | `tests/host_show_needs_test.gd`, `tests/show_sheet_test.gd` |
| 12 | Golden path (section 7) | Grok Dev | `tests/host_show_golden_test.gd` | walks it end to end |
Order: 1-4 now (they fix the world either way), 5, 7, then 6 and 8, 9, then 10 and 11, then 12. Discipline: boxing. Ships ON (`GameSwitches.GAME_ON`).

## 9. Probe bars (HOSTPROBE1, before any screen shows an ESTIMATE)
- Lucy's route: across (strong, weak, wants the nationals) x (favours 0, 1, 2 with Belfast Gloves) each of Erin as it is / with a favour / promise /
  Maria / Maria + swap / wait is best in at least one case and in no more than half.
- Favours: spending one best in no more than 3 of 4 asks; the swap best in no more than 2 of 3 cases.
- Samira: across margins 0.1 / 0.4 / 0.8 kg each of keep / harder / stand down best once.
- Danny: across (goal met, Steady) / (goal met, Flat) / (goal on the line) each tile best once (checked by hand in 6.3: novice / skills / off).
- Hall: no hall best for all three clubs (young 40/10, mid 58/24, grown 120/60); the town hall loses against away at least 1 night in 8 for the mid club.
- Every printed rank line equals `Region.rankings` after a replayed night in 1,000 seeds (no line printed as certain is ever wrong).
- The cut rule: any choice worth under $150 and under 1 reputation and under 3 in 100 of a pro offer is cut, not drawn.

## 10. What was rejected, and why
- Pay their travel $120 (round 2): $80 never binds against $11,400; always right below 9 in 10. Replaced by favours.
- The 3 x 3 hall and price grid (round 2): one price won in every hall. The price comes with the hall.
- A swap for Danny's ladder (Dean v Arjun): it buys a rank number with no prize at 4 wins; a favour spent on it is never right.
- Catchweights (a 57.5 kg novice at 59, a 66 kg Samira): booking matches weight class (product rule, WORKFLOW 5).
- A members' slot of skills bouts for families: needs juniors and adult members' bouts the game does not hold yet (`PER_JUNIOR` exists, the junior
  card does not); it comes with the youth section's map.
- Asking two names at once: R37 owns parallel asks; here one open ask per boxer keeps the 3-day clock a price.
- A reserve bout on standby: the outside novice already covers a pull-out at $80 on the day.
- "Make main event" as a choice (round 1), Change on every visiting pair (round 1), per-pair supporters, two outside novices: read-offs or under the cut.
- Host or not as a decision; shows every 12 weeks; pro cards, belts, TV; a BJJ bout on the card; choosing officials; bar and raffle choices.
- Morale -6 printed before MOODIDLE1: a cost the game does not apply.

## 11. Risks, said plainly
- Every number marked ESTIMATE (yes chances, win odds, the twist-card miss chance, followings, favours) is ours until HOSTPROBE1.
- The hold rule thins the region's shows in a division where our card takes four names (women's 60: only Priya and Maria free); rank movement slows.
- Judging the goal at a skills bout may feel harsh; the tile says it plainly, and the Handbook explains it is the same rule as any bout.
- Favours start at 1 with every club met: a player who never hosts never spends them; R37 uses the same ledger for asks.
- RANKTIE1 changes every rank tie in the game; tests that read ranks rerun with it.
- Three of our bouts in one night: "Sim to result" exists; the sheet must not wait for all of them.
- Cash: the night's costs ($3,060 here) land in a month with stipends; CashForecast must carry them.

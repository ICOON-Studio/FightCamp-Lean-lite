# DESIGN_HOSTSHOW1_V6 - host your own club show (design map, round 6, S540)

Task: `ops/research/TASK_HOSTPROBE3.md`. v6 = map v5 (`DESIGN_HOSTSHOW1_V5.md`) with HOSTPROBE2 section 7 done
(`docs/HOSTPROBE2_RESULT.md`: v5 FAILED, 3 of 9 bars). Owner Q-308 (S540): "Yes, keep it" - favours stay at the game's own
rate, about 3 a year; v6 does not move it. Bar (owner S534): probe first, then two fresh critics at 8+ DEPTH and 8+ PLAY.
FREE HAND (owner S534): remove, add, interconnect. Probe: `tools/hostprobe3.gd` + the flagged rules copy
`tools/hostprobe3_rules.gd`; result `docs/HOSTPROBE3_RESULT.md`.
**HOSTPROBE3 (S540): FAIL, 5 of 9 bars** - the points line (43) is out of reach in a season, the hall read misses the grown
club, the favour beats "as it is" in 4 of 16, the card beats the lazy ask in 14 of 36. Its section 7 is the next round.

Owner rules carried: S448 names only in headers; S412 any gym, any boxers, no fixed he/she; S425 every menu it appears on and
what it is wired to (section 7); S398 only actionable info on screen; S532 tooltips explain, never repeat the label.

Marks: **CODE** = in the game today, file:line read on 2026-11-23. **NEW** = a rule this map adds. **ESTIMATE** = a number of
ours the probe measures before any screen shows it.

## 0. HOSTPROBE2 section 7, item by item

| # | Section 7 said | v6 does |
|---|---|---|
| 1 | Favours: keep the built rate (2.9 a year); the bar becomes "spent at shows <= earned, and 'as it is' beats 'with a favour' in 1 of 3" | Kept (owner Q-308 "Yes, keep it"). No new earn rule; our show only spends. The probe's favour bar is the owner's |
| 2 | Give the pro chase a reason to ask up: the pro call on LADDER POINTS | **NEW, interconnect with TURNPRO:** the call needs top 3 AND the ladder points of a 7-0 record (LadderPoints.seed_of(7, 0) = 43), or the points of a 9-0 record (seed_of(9, 0) = 53) at any rank. The lines are the built rule's own records (Roster.PRO_WINS 7, PRO_WINS_ANY_RANK 9, Roster.gd:34-36) put in the game's own points (LadderPoints.gd:18-19). A win over a name above pays +11-14, over a name below +2-5 (LadderRep.change, LadderRep.gd:27-46), so at the line the harder win brings the call nearer. Declines and the national finalist rule stay as built (Roster.gd:186-196). The probe also runs the rule over whole seasons against the built one (B8): the call must not move far for a sensible coach |
| 3 | The hall: two halls shown as a read of the club, not a decision | **The hall is a read.** The gym floor is CUT (never within $1,546 of the next hall). The booking screen prints Community and Town side by side as the club's likely night (seats, net, full / half-empty) and names the one that pays; the player books it. A player may still book the other (one click), but it is not presented as a choice to weigh |
| 4 | Reserves: 2 as the coach's default | **Two standby reserves, a line on the sheet** ($40 each). Not a choice. The probe checks 2 is best or within $50 of best for every club and hall |
| 5 | The read: give "sell" a real price or cut it | **Boxers sell is CUT** (a taper pad night is worth $0.20-$0.80 to the read). Day 12 keeps the posters and the seat count; Cancel stays only as the emergency line (deposit lost, -3 rep) |
| 6 | Boxer C: cut Leave off as a show choice | **Leave off is CUT** as a show choice. A boxer with a tight goal is simply not put on the card (the Fighter screen's own choice); with no legal regional name the card offers the outside novice |
| 7 | Side defect: BoutRead's edge cache has no morale | Not this map's (no scripts/ change in a probe task). Queued as its own fix in the result |

## 1. The idea in five lines
1. About three times a year (CODE ClubShow.EVERY_DAYS 112, ClubShow.gd:12) the club hosts its own amateur show: you pick the
   date; the hall is read from the club (Community or Town); you are the matchmaker.
2. For each boxer on the card you choose whom to ask (the name above, the name below, or wait for the region's show) and how
   (as it is, with one of the favours the game already keeps, or a promised return bout that holds the pro call until it is boxed).
3. The pro call now reads ladder points, so at the line a win over a name above is worth more than a win over a name below.
4. The coach fills visiting pairs and books two standby reserves against the game's own pull-out rate (35 in 100 a bout).
5. On the night: visiting bouts, ours, the sheet - cash against boxing away, reputation, members, ladder points, and any pro offer.

## 2. Built today (CODE, read 2026-11-23)
- ClubShow.gd:8-20, 26-27: COST $3,500, TICKET $25, HALL 400, EVERY_DAYS 112, LEAD_DAYS 28, draw = 40 + 0.7 members +
  1.0 rep + 2.5 juniors + 25 home boxers, LUCK 0.70-1.15, RAFFLE $600-$1,400, TICKETS_PER_MEMBER 40.
- Away amateur bout: TICKET_CUT $450 (BoutRules.gd:113); win +8 members +5 rep (114-115); loss -1 / -2 (120-121); stoppage
  loss -2 / -4 (122-123).
- Region shows every 14 days from day 12 (Data.gd:107-108), 2 bouts a division (Region.gd:17), novice rule both ways
  (AmateurBooking.gd:31); the table sorts by ladder points first (Region.gd:200-212, LadderPoints).
- Pro offer: Roster.pro_ready 7 wins + top 3, or 9 wins (Roster.gd:186-196); check_pro needs an empty f.bout, ProOfferWire.waited
  and no nationals (Roster.gd:200-214).
- Favours: Career.favours {club: n} (Career.gd:87-90), start 1 (FightWeekPlan.gd:31), cap 3, every 2nd host bout +1, late gap
  +1, spend checks (FightWeekEvents.gd:8-9, 77-94); used by sparring partners ($160 or 1, PartnerMatch.gd:43, 169-178), the
  kilo (WeighGap.gd:69-87), next month's slot after a pull-out (FightWeekEvents.gd:44-56).
- Pull-outs: 35 in 100 on fight week's Monday (FightWeekEvents.gd:5, 15-21); PullOutWire.eligible skips a HOME bout today
  (PullOutWire.gd:45-48) - the build widens it to the show's card.
- Morale moves win chance only through the mood's trust in the corner (FighterProfile.gd:39 TRUST, read in BoutRead.gd:235).
- Pads: a pad night = 240 drill minutes, half in a taper week (PadWeek.gd:38, 94; WeekPlan.gd:68 TAPER_PADS 0.5).

- Ladder points: LadderRep.change (LadderRep.gd:27-46): Elo-style, 16 x (1 - expected), a stoppage x1.15 and +2; gap 0 ->
  +8, a name 10 above -> +11, 20 above -> +14; 10 below -> +5, 20 below -> +2. Seeds: 8 + 4 x net wins + bouts (LadderPoints.gd:18-19).

## 3. What is thin today
The show is one row on Club > Money (GymSpend.book_show): no card, no asks, no hall; one boxer may be put on our night as the
"top of our show" (HomeBout, S488). Everything below is NEW unless marked CODE.

## 4. The mechanics

### 4.1 Date (8 weeks out or more)
Pick one of the next four free Saturdays at least 8 weeks out (NEW; LEAD_DAYS 28 -> 56). A Saturday on a region show
(12 + 14k, CODE) is marked; each boxer's line says free / booked / suspended / in nationals (Champs.active, CODE).

### 4.2 The hall (a read, not a choice)
| Hall | Seats | Rent | Card | Reach on the club part | Name above yes (base) | Full 85%+ | Half-empty under 50% |
|---|---|---|---|---|---|---|---|
| Community hall | 250 | $1,000 | 9 bouts | x1.0 | 5 in 10 | +4 rep | -3 rep |
| Town hall | 400 | $2,000 | 12 bouts | 0.6 + 0.01 x reputation (0.6-1.25) | 7 in 10 | +6 rep | -4 rep |

Fixed costs $1,500 (officials, doctor, ambulance, medals; ClubShow.gd:3-5 anchors); 30% of the rent as deposit; raffle $5 a seat
(ESTIMATE); visitors' travel $40 each (ESTIMATE); 3 supporters a visitor (ESTIMATE); two reserves $40 each.
**The read (NEW):** each hall's likely night at a middle luck (0.925 of ClubShow.LUCK) with every bout boxed: seats, net, and
full / half-empty reputation at $333 a point. The screen prints both, names the one that pays ("Your club fills Community hall:
likely +$2,300. Town hall would be half-empty: likely -$900"), and books it on one click. Hover on "reach": "A bigger hall fills
from your club's name; your boxers' own followers come anywhere."

### 4.3 Your boxers on the card
Card opens 24 days out, posters 12 days out, the bout sheet closes 3 days out. One open ask a boxer; the answer in 3 days. Every
tile prints: yes chance (N in 10), win chance (BoutRead, CODE), ladder points if won / lost (LadderRep.change, CODE), "No. 3 or
better: N in 100" (with stoppages), pro offer chance (v6 rule), seats.
- **The name above** (nearest legal name higher on ladder points): yes = hall base + 1 in 10 a 2 rating points it leads ours
  (cap 9, ESTIMATE). Win +5 rep +8 members (CODE) and the main event (+24 poster seats, +3 / -3 rep, ESTIMATE). No legal name
  above = no tile.
- **How to ask the name above:** As it is / **With a favour** (-1 of the built favours with that club, +3 in 10; "Favours with
  <club in header>: 1 of 3") / **Promise a return bout** (9 in 10, no favour; booked away on their show 4-12 weeks later against
  the same name; "No pro offer until the return bout", CODE Roster.gd:207).
- **The name below:** yes 9 in 10 (ESTIMATE); a home win +3 rep (ESTIMATE), +8 members (CODE). At the pro line the tile prints
  the points it would bring against the line's 43 ("Pro line: 43 points. A win here: 39").
- **Wait for the region's show:** no ask until its result; then the name above if the win chance is 40 in 100 or better, else
  below. Loses the main event's poster seats if it misses the posters.
- **Outside novice** (only when no legal regional name): always yes, $80, no tape, ~50 in 100. Not a choice beside the others.

### 4.4 The pro call on ladder points (NEW, interconnect with TURNPRO)
`pro_ready` with 0 declines becomes: (rank 1-3 on the region table AND ladder points >= 43) OR ladder points >= 53. 43 and 53 are
the seeds of a 7-0 and a 9-0 record - the built rule's own lines in the game's own points. Shown on Fighter > Overview as a
"Pro line" bar (points now / 43, and the rank). 1+ declines and the national finalist stay as built. This touches TURNPRO15's
area: the build task goes through the TURNPRO map's owner (handoff line in TURNPRO's next round), and its tests
(tests/pro_call_test.gd) move with it.

### 4.5 Favours (the built ones, the game's rate)
No new ledger. Club > People > FAVOURS shows each host club's count (0-3) and what earns one (CODE: a late gap filled, every 2nd
bout boxed on their show). Our show spends one on an ask; it earns none. About 3 earned a year (HOSTPROBE2: 2.9).

### 4.6 The region's show before our night
Names on our card are held from it (HOLD1, NEW: Region.day_events busy). Free names box as today (CODE).

### 4.7 Crowd
Each of our boxers brings 10 + 3 x wins (ESTIMATE); each visiting boxer 3 supporters; the main event's posters +24 (ESTIMATE).

### 4.8 Pull-outs, reserves, the night, the sheet
Each invited bout falls through 35 in 100 in fight week (CODE FightWeekEvents.gd:5). Two standby reserves (the default, $40 each;
travel only if they box). Fewer than two-thirds of the card boxed = short night, -2 rep (ESTIMATE). Cancel (emergency only): the
deposit, -3 rep. The sheet: cash against boxing away, reputation parts, members against member_limit with "Add places", ladder
points and rank changes, "Review pro offer" when check_pro fires, favours spent, the next show's date.

## 5. Every decision ("right when" is the probe's test, never on screen)
| When | Decision | Options and prices | Right when |
|---|---|---|---|
| Booking | Date | four Saturdays | clear of each boxer's other bouts and the region show |
| Card | Each boxer's route | above as it is / with a favour / promise / below / wait | promise: far from the line and the name above is beatable; above at the line: the points reach 43; below: a safe win when the points already clear the line; favour: when the yes is the prize and one is spare |
Read, not decided: the hall (4.2), the two reserves (4.8). Cut: the gym floor, boxers sell, Leave off.

## 6. One show (short)
A mid club (58 members, rep 24) is read Community hall: likely +$2,300 against Town's half-empty night. Boxer A (3-1, 23 points)
asks the name above with a promise: yes 9 in 10, "No pro offer until the return bout" (no offer is near at 3 wins). Boxer B
(6-1, 35 points, the pro chase): the name above is the only route to 43 on one win (+11 or more), the name below leaves B at 38-40
and a second bout away; B asks up as it is. Two visiting bouts fall through; both reserves box. The sheet: net against away, rep,
B's points 47 and No. 2: "Review pro offer".

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows (only what the player can act on) | Wired to |
|---|---|---|
| Fights > OUR SHOW (tab beside Bouts) | PLAN: 4 Saturdays; the hall read (both halls' likely night, the one that pays named, Book). BOOKED: header (date, hall, seats, days); timeline (card opens, posters, region show, night); a row a boxer: route tiles (yes, win, points if won / lost, No. 3 or better, pro offer, seats; As it is / Favour [count] / Promise ["No pro offer until the return bout"]); THE NIGHT: seats bar (club / followings / posters / visitors), net against away; "2 standby reserves" line. AFTER: the sheet | ClubShow v2 (halls, reach, read, settle), ShowCard (tiles), HostShow (asks, reserves, pull-outs via FightWeekEvents.pulls_out), RankLine (with stoppages), LadderRep.change, BoutRead.chance, Roster.pro_ready (v6) / check_pro, FightWeekPlan.favours |
| Club > Money > CLUB SHOW row | Not booked: "Plan a show" (opens the tab). Booked: date, hall, deposit, likely net | GymSpend, CashForecast |
| Club > People > FAVOURS | Each host club's favours 0-3 and what earns one | Career.favours, FightWeekPlan.favours |
| Home: notice board + COMING UP | "The card is open: ask opponents"; "An opponent said no"; "Posters up"; "Pull-out on the card"; "Show night" | Needs, HomeNeeds |
| Top bar | SHOW CARD / PULL-OUT / SHOW NIGHT; NEEDS YOU while a card boxer has no ask out before the posters | Clock.next_stop, Needs.blockers |
| Fighter > Overview | NEXT BOUT: "Our show, main event" or "Ask out, answer in 3 days"; a promised return bout: "Return bout booked - no pro offer until it is boxed". PRO LINE bar: points / 43, rank | f.bout, HostShow, Roster.pro_ready (v6), LadderPoints |
| Fights > a bout offer | "Held for our show" when the boxer is on our card; points if won / lost | Bouts.day_events, HostShow, LadderRep.change |
| Result and the Why: THE CLUB tile | "Our show: on the night's sheet" (no $450 away cut), main-event rep, points, rank, pro offer | BoutFinish, RankLine |
| The night's sheet | cash parts, rep parts, members + Add places, points and rank changes, Review pro offer, favours spent, next date | ClubShow.settle, Region, GymSpend.member_limit |
| World > News & Rankings | visiting results "on our show"; rank arrows | Region._rival_bout, Region.rankings |
| Week review | net cash and rep with causes | WeekReview |
| Handbook | Club show, Hall read, Reach, Main event, Standby reserves, Return bout, Favours, Pro line, Short night | Handbook |

Golden-path step: the read books Community; boxer A asks the name above with a promise (yes); boxer B at the pro line asks the
name above as it is; a pull-out is covered by a reserve; the night; the sheet shows net against away, B's points over 43 and the
pro offer, and "no pro offer until the return bout" on A.

## 8. Build tasks (each under 500 lines, red test first)
| # | Task | Owns | Red test |
|---|---|---|---|
| 1 | PROLINE1: pro_ready on ladder points (0 declines), the Pro line bar | Roster.gd pro_ready, FighterOverview line | "6-1 at 35 points: a win over a name below (+4) gives no call; over a name above (+12) at No. 2 does" |
| 2 | HOLD1: names on our card are busy at region shows | Region.gd day_events | "a name on our card skips the region show" |
| 3 | ClubShow v2: two halls, reach on the club part, the hall read, raffle, two reserves, short night, settle | ClubShow.gd | "the read names Town for a rep-60 club, Community for rep 10" |
| 4 | ShowCard + RankLine with stoppages, points if won / lost | ShowCard.gd, RankLine.gd | "printed No. 3 within 1 point of 20,000 seeds" |
| 5 | HostShow: asks, favour spend, promise = return bout on f.bout, pull-outs on the card, reserves | HostShow.gd, PullOutWire.eligible | "a promised boxer gets no pro call before the return bout" |
| 6 | OurShow UI | OurShow.gd, OurShowTiles.gd | tests/our_show_screen_test.gd |
| 7 | Needs, top bar, Money row, People favours, NEXT BOUT, sheet, Handbook | Needs.gd, HomeNeeds.gd, ShowSheet.gd | tests/show_sheet_test.gd |
| 8 | Golden path | tests/host_show_golden_test.gd | the section 7 step |
Ships ON (GameSwitches.GAME_ON). Nothing is built before HOSTPROBE3 passes and two fresh critics score 8+ DEPTH and 8+ PLAY.

## 9. Probe bars
Written in docs/HOSTPROBE3_RESULT.md s3 before the run: HOSTPROBE2's bars for the decisions v6 keeps (not loosened), the owner's
favour bar, and two new ones for the new rule (B8 the pro line over seasons, B9 above and below differ at the line).

## 10. What was rejected, and why
- v4's own favour ledger: made the favour near free and duplicated a built one.
- The gym floor (HOSTPROBE2: never best, -$1,546 at best edge): $1,500 fixed costs against 64-160 seats.
- Boxers sell (a taper pad night moves the read by 0.0002: free seats) and Leave off (the mood term moves the next bout 0-1.6
  points): both solved, not choices.
- Reserves 0 / 1 as a choice: 2 was best everywhere at $40 against 35 in 100.
- A 7-win count at the pro line: any win counted the same, so the name below was the pro chase's answer in 61 in 100 of cells.
- Weight answers on our show, the skills bout, door price, move down, the ladder swap (HOSTPROBE1 B7).
- Newcomers as the pro chase's name above: they arrive below a 6-win boxer on ladder points.

## 11. Risks
- With the hall, reserves and the read solved, the show's depth rests on the card alone: A3 (best card beats the lazy ask by
  $1,000 in half the cells) decides whether that is enough. HOSTPROBE2 measured the card alone at 27 of 108.
- The pro call on points can slow a weak boxer's call (B8 measures it over seasons).
- Town reach and the $5 raffle are ESTIMATES until the probe.

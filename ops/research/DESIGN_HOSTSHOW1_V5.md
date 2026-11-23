# DESIGN_HOSTSHOW1_V5 - host your own club show (design map, round 5, S539)

Owner (S539, typed in the HOSTPROBE1 tab): "Apply the section 7 changes and run HOSTPROBE2". v5 = map v4
(`DESIGN_HOSTSHOW1_V4_REVISE_KALLI_KALLI.md`, Kalli S463) with every item of HOSTPROBE1 section 7 done
(`docs/HOSTPROBE1_RESULT.md`, d893ce13d: v4 FAILED, 2 of 10 bars). Bar (owner S534): probe first, then two fresh critics at
8+ DEPTH and 8+ PLAY. FREE HAND (owner S534): remove, add, interconnect. Probe: `tools/hostprobe2.gd` + the flagged rules
copy `tools/hostprobe2_rules.gd`; result `docs/HOSTPROBE2_RESULT.md`.

Owner rules carried: S448 names only in headers (rows and tiles say "your boxer", "the opponent"); S412 any gym, any boxers,
no fixed he/she; S425 every menu it appears on and what it is wired to (section 7); S398 only actionable info on screen;
S532 tooltips explain, never repeat the label.

Marks: **CODE** = in the game today, file:line read on 2026-11-23 (S539). **NEW** = a rule this map adds. **ESTIMATE** = a
number of ours the probe measures before any screen shows it.

## 0. HOSTPROBE1 section 7, item by item

| # | Section 7 said | v5 does |
|---|---|---|
| 1 | One favour, the built one | v4's ledger (cap 2, 26-week lapse, three earn rules) is GONE. The show's "with a favour" ask spends from the built `Career.favours` (CODE Career.gd:87-88; every host starts at 1, FightWeekPlan.gd:31, 137-138; cap 3, FightWeekEvents.gd:8; earned by filling a late gap, FightWeekEvents.gd:78-79, and every 2nd bout boxed on a host's show, FightWeekEvents.gd:9, 84-88, BoutFinish.gd:137). Our own show earns NOTHING (that made spending free). The favour's price is the game's own: an outside sparring partner costs $160 or 1 favour (CODE PartnerMatch.gd:43, 169-178) |
| 2 | Price the promise with what the game counts | The promised return bout is booked on the boxer (`f.bout`) from our night, so `Roster.check_pro` skips them (CODE Roster.gd:207: `(f["bout"] as Dictionary).is_empty()`): **no pro call until the return bout is boxed**, away on their show 4-12 weeks later, against the SAME name above. Lose it and the pro offer can go. The tile says so: "No pro offer until the return bout". The favour the promise earned in v4 is removed |
| 3 | Hall reach by name, not by building | The hall's reach multiplies the CLUB part of the draw only (CODE ClubShow.gd:14-16, 26-27: 40 + 0.7 members + 1.0 reputation); followings, posters and visitors' supporters come whatever the hall. Town's reach = 0.6 + 0.01 x reputation (0.6 to 1.25, NEW ESTIMATE): 0.70 for a rep-10 club, 0.84 at 24, 1.20 at 60. Gym floor 0.8, Community 1.0 as v4 |
| 4 | Cut the weight section (4.4) | CUT. Fight week already has the amateur answers: train it off, ask for a kilo, the host re-match (CODE WeighGap.gd:43-87, Bouts.gd:373) |
| 5 | Cut the Skills bout, door price, move down, ladder swap; Cancel only as an emergency line | CUT, all four. Cancel stays as a line on the read (deposit lost, -3 reputation), never offered as a plan |
| 6 | Boxers sell at its real price | The price is the game's: one fight-week pad night less (PadWeek.nights_for taper, PadWeek.gd:79-94; run_week, PadWeek.gd:369-418), read by BoutRead.chance (BoutRead.gd:382) for the show bout, times what a win is worth over a loss. The probe computes it per boxer (`tag: price`) |
| 7 | The pro chase needs a legal name above | Newcomers cannot supply one: a newcomer arrives "a little under the sheet's level" with 0-2 bouts (CODE Newcomers.gd:2-7, 40-70), so on ladder points (8 + 4 net wins + bouts, LadderPoints.gd:18-19) every newcomer sits BELOW a 6-win boxer. So the "name above" tile DROPS where no legal name is above; the pro chase there is "name below" against "wait for the region's show" |
| 8 | Print the rank number with stoppages, or a band | Printed with stoppages: each region pair's four outcomes (each side by stoppage or on points) and ours (a win on points, a loss stopped 1 in 5), through the game's own LadderPoints.settle (stoppage = x1.15 and +2, LadderRep.gd:27-46) and Region.rankings order |
| 9 | Side defect: AskDates "a month without a fight costs 6 morale" | Fixed in S539 (9ebfb3342: the false line was dropped). Not this map's |

## 1. The idea in five lines
1. About three times a year (CODE ClubShow.EVERY_DAYS 112, ClubShow.gd:12) the club hosts its own amateur show: you pick the
   date and the hall, and you are the matchmaker.
2. For each boxer on the card you choose whom to ask (the name above, the name below, wait for the region's show, an outside
   novice, or leave off) and how (as it is, with one of the favours the game already keeps, or a promised return bout that holds
   the pro call until it is boxed).
3. The coach fills visiting pairs; up to 2 standby reserves cover the game's own pull-out rate (35 in 100 a bout, CODE
   FightWeekEvents.gd:5).
4. Twelve days out the ticket read: keep, or have your boxers sell tickets for a fight-week pad night.
5. On the night: visiting bouts, ours, the sheet - cash against boxing away, reputation, members, rank, and any pro offer.

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

## 3. What is thin today
The show is one row on Club > Money (GymSpend.book_show): no card, no asks, no hall choice; one boxer may be put on our night as
the "top of our show" (HomeBout, S488). Everything below is NEW unless marked CODE.

## 4. The mechanics, each a decision with its options and prices

### 4.1 Date (8 weeks out or more)
Pick one of the next four free Saturdays at least 8 weeks out (NEW; LEAD_DAYS 28 -> 56). A Saturday on a region show
(12 + 14k, CODE) is marked; each boxer's line says free / booked / suspended / in nationals (Champs.active, CODE).

### 4.2 Hall (one choice at booking)
| Hall | Seats | Rent | Card | Reach on the club part (NEW) | Name above yes (base) | Full 85%+ | Half-empty under 50% |
|---|---|---|---|---|---|---|---|
| The gym floor | equipment places x 4 (needs 16 places) | $300 | 6 bouts | x0.8 | 3 in 10 | +3 rep | -3 rep |
| Community hall | 250 | $1,000 | 9 bouts | x1.0 | 5 in 10 | +4 rep | -3 rep |
| Town hall | 400 | $2,000 | 12 bouts | 0.6 + 0.01 x reputation (0.6-1.25) | 7 in 10 | +6 rep | -4 rep |

Fixed costs officials, doctor, ambulance $1,200 + medals $300 (CODE ClubShow.gd:3-5 anchors); 30% of the rent as deposit;
raffle $5 a seat sold (ESTIMATE); visitors' travel $40 each (ESTIMATE); 3 supporters a visitor (ESTIMATE). The booking preview
prints, per hall: likely net, a bad night's net (1 in 10), full and half-empty chances. Hover on "reach" explains: "A bigger hall
fills from your club's name; your boxers' own followers come anywhere."

### 4.3 Your boxers on the card
Card opens 24 days out, posters and the ticket read 12 days out, the bout sheet closes 3 days out. One open ask a boxer; the
answer in 3 days. Every tile prints: yes chance (N in 10), win chance (BoutRead, CODE), "No. 3 or better: N in 100" (with
stoppages, hover opens the outcomes), pro offer chance, seats.
- **The name above** (nearest legal name higher on ladder points): yes = hall base + 1 in 10 a 2 rating points it leads ours
  (cap 9, ESTIMATE). Win +5 rep +8 members (CODE) and the main event (+24 poster seats, +3 / -3 rep, ESTIMATE). **No legal name
  above = no tile** (section 0 item 7).
- **How to ask the name above:** As it is / **With a favour** (-1 of the built favours with that club, +3 in 10; the tile says
  "Favours with <club in header>: 1 of 3") / **Promise a return bout** (9 in 10, no favour; the boxer is booked for the return,
  away on their show 4-12 weeks later, against the same name; **"No pro offer until the return bout"** on the tile, CODE
  Roster.gd:207).
- **The name below:** yes 9 in 10 (ESTIMATE); a home win over it +3 rep (ESTIMATE), +8 members (CODE).
- **Wait for the region's show:** no ask until its result; then the name above if the win chance is 40 in 100 or better, else
  below. Loses the main event's poster seats if it misses the posters.
- **Outside novice** (only when no legal regional name): always yes, $80, no tape, ~50 in 100.
- **Leave off:** a full training week; away offers go on (CODE).

### 4.4 (cut in v5: weight on our own show - fight week's own answers stand)

### 4.5 Favours (the built ones)
No new ledger. The FAVOURS list on Club > People shows each host club's count (0-3) and what earns one (CODE: a late gap filled,
every 2nd bout boxed on their show). Our show spends one on an ask; it earns none.

### 4.6 The region's show before our night
Names on our card are held from it (HOLD1, NEW: Region.day_events busy). Free names box as today (CODE).

### 4.7 Crowd
Each of our boxers brings 10 + 3 x wins (ESTIMATE); each visiting boxer 3 supporters; the main event's posters +24 (ESTIMATE).

### 4.8 (cut in v5: ladder pairs and swaps)

### 4.9 The ticket read (12 days out)
- **Keep.**
- **Your boxers sell:** each boxer on our card gives up one fight-week pad night for +10 seats. Price = the game's: the win
  chance that pad night was worth (PadWeek -> BoutRead, measured per boxer in HOSTPROBE2).
- Cancel (emergency line only): the deposit, -3 rep.

### 4.10 Pull-outs, reserves, the night, the sheet
Each invited bout falls through 35 in 100 in fight week (CODE FightWeekEvents.gd:5). Up to 2 standby reserves at $40 each
(ESTIMATE; travel only if they box). Fewer than two-thirds of the card boxed = short night, -2 rep (ESTIMATE). The sheet:
cash against boxing away, reputation parts, members against member_limit with "Add places", rank changes, "Review pro offer"
when check_pro fires, favours spent, and the next show's date.

**Reference (owner pasted MMA Empire's patch notes, S539), in our words:** their official weigh-in gives the opponent three
answers on a miss (accept, ask a replacement, cancel); their backup fighter is reserved at booking and steps in after an injury
or one missed weight if eligible. Ours: the weigh-in answers already exist for away bouts (WeighGap ways, the host's 1-in-3
re-match, Bouts.gd:373), and amateur misses are near zero (FAVOURPROBE1: 0 kilo asks in 160 club-years), so a miss rule on our
show would be a choice that never comes up - not taken. The standby reserve IS their backup fighter; HOSTPROBE2 measures whether
0 / 1 / 2 reserves is a real choice at the game's 35 in 100.

## 5. Every decision ("right when" is the probe's test, never on screen)
| When | Decision | Options and prices | Right when |
|---|---|---|---|
| Booking | Hall | Gym floor / Community / Town (4.2) | gym floor: small club, cheap; Community: the middle; Town: a club with a name |
| Booking | Reserves | 0 / 1 / 2 at $40 | 2 on a long card, 0-1 on the gym floor |
| Card | Each boxer's route | above as it is / with a favour / promise / below / wait | promise: far from the pro line; below or wait: at the pro line; favour: when it is spare |
| Card | Boxer with a tight goal | outside novice / leave off | leave off when the goal's morale is worth more than the seats |
| Read | Read | keep / boxers sell | sell when the hall is short of full |

## 6. One show (short)
A mid club (58 members, rep 24, 22 places) books Community hall with 2 reserves. Boxer A (3-1) asks the name above with a
promise: yes 9 in 10, "No pro offer until the return bout" (no pro offer is near at 3 wins, so the price is the return bout's
loss risk only). Boxer B (6-1, the pro chase) has no legal name above: the tile is gone, and the choice is the name below now
against waiting for the region's show. Twelve days out the hall is short of full: both boxers sell (one taper pad night each).
Two visiting bouts fall through; both reserves box. The sheet: net against away, rep, members, and B's pro offer on the night.

## 7. Every menu it appears on, and what each is wired to
| Menu | What it shows (only what the player can act on) | Wired to |
|---|---|---|
| Fights > OUR SHOW (tab beside Bouts) | PLAN: 4 Saturdays, 3 hall cards with likely / bad-night net and full / half-empty chances, reserves 0-2. BOOKED: header (date, hall, seats, days); timeline (card opens, posters + read, region show, night); a row a boxer: route tiles (yes, win, No. 3 or better with stoppages, pro offer, seats; As it is / Favour [count] / Promise ["No pro offer until the return bout"]); THE NIGHT: seats bar (club / followings / posters / visitors), net against away. READ on day 12: Keep / Your boxers sell (seats and the pad night's win chance). AFTER: the sheet | ClubShow v2 (halls, reach, settle), ShowCard (tiles), HostShow (asks, reserves, pull-outs via FightWeekEvents.pulls_out), RankLine (with stoppages, LadderPoints.settle), BoutRead.chance, Roster.pro_ready / check_pro, FightWeekPlan.favours, PadWeek (sell price) |
| Club > Money > CLUB SHOW row | Not booked: "Plan a show" (opens the tab). Booked: date, hall, deposit, likely net | GymSpend, CashForecast |
| Club > People > FAVOURS | Each host club's favours 0-3 and what earns one | Career.favours, FightWeekPlan.favours |
| Home: notice board + COMING UP | "The card is open: ask opponents"; "An opponent said no"; "Ticket read ready"; "Pull-out on the card"; "Show night" | Needs, HomeNeeds |
| Top bar | SHOW CARD / TICKET READ / PULL-OUT / SHOW NIGHT; NEEDS YOU while a card boxer has no ask out before the posters | Clock.next_stop, Needs.blockers |
| Fighter > Overview, NEXT BOUT | "Our show, main event" or "Ask out, answer in 3 days"; a promised return bout: "Return bout booked - no pro offer until it is boxed" | f.bout, HostShow |
| Fighter > Week | Fight week with the pad night given to selling marked | PadWeek nights, WeekPhase |
| Fights > a bout offer | "Held for our show" when the boxer is on our card | Bouts.day_events, HostShow |
| Result and the Why: THE CLUB tile | "Our show: on the night's sheet" (no $450 away cut), main-event rep, rank, pro offer | BoutFinish, RankLine |
| The night's sheet | cash parts, rep parts, members + Add places, rank changes, Review pro offer, favours spent, next date | ClubShow.settle, Region, GymSpend.member_limit |
| World > News & Rankings | visiting results "on our show"; rank arrows | Region._rival_bout, Region.rankings |
| Week review | net cash and rep with causes | WeekReview |
| Handbook | Club show, Hall, Reach, Main event, Ticket read, Standby reserve, Return bout, Favours, Short night | Handbook |

Golden-path step: book Community with 2 reserves; boxer A asks the name above with a promise (yes); boxer B at the pro line asks
the name below; read: sell; reserves fill two pull-outs; the night; the sheet shows net against away, the pro offer for B and
"no pro offer until the return bout" on A.

## 8. Build tasks (each under 500 lines, red test first)
| # | Task | Owns | Red test |
|---|---|---|---|
| 1 | HOLD1: names on our card are busy at region shows | Region.gd day_events | "a name on our card skips the region show" |
| 2 | ClubShow v2: halls, reach on the club part, town reach by rep, $5 raffle, reserves, short night, settle | ClubShow.gd | "town hall reach 0.70 at rep 10" |
| 3 | ShowCard + RankLine with stoppages | ShowCard.gd, RankLine.gd | "printed No. 3 within 1 point of 20,000 seeds" |
| 4 | HostShow: asks, favour spend, promise = return bout on f.bout, pull-outs at FightWeekEvents rate on the card, reserves | HostShow.gd, PullOutWire.eligible | "a promised boxer gets no pro call before the return bout" |
| 5 | OurShow UI | OurShow.gd, OurShowTiles.gd | tests/our_show_screen_test.gd |
| 6 | Needs, top bar, Money row, People favours, NEXT BOUT, sheet, Handbook | Needs.gd, HomeNeeds.gd, ShowSheet.gd | tests/show_sheet_test.gd |
| 7 | Golden path | tests/host_show_golden_test.gd | the section 7 step |
Ships ON (GameSwitches.GAME_ON). Nothing is built before HOSTPROBE2 passes and two fresh critics score 8+ DEPTH and 8+ PLAY.

## 9. Probe bars
HOSTPROBE1's bars (docs/HOSTPROBE1_RESULT.md s3) minus those whose options v5 cut (B1c swap, B4 weight), not loosened; written in
docs/HOSTPROBE2_RESULT.md s3 before the run.

## 10. What was rejected, and why
- v4's own favour ledger (cap 2, lapse, earn on our card): made the favour near free ($45 measured) and duplicated a built one.
- The promise's "lock" as its only price: nothing in the game counted it.
- Hall reach on the whole draw: made Town best for every club.
- Weight answers on our show, the skills bout, door price, move down, the ladder swap: never within $150 / 1 rep / 3 pro of the
  next option (HOSTPROBE1 B7).
- Newcomers as the pro chase's name above: they arrive below a 6-win boxer on ladder points.
- An MMA-Empire-style miss rule on our show: amateur misses are near zero here.

## 11. Risks
- Few real levers may be left once the dead ones are cut: HOSTPROBE2 decides.
- The sell price is tiny if one taper pad night barely moves the read; then "sell" is free seats.
- Town reach and the $5 raffle are ESTIMATES until the probe.

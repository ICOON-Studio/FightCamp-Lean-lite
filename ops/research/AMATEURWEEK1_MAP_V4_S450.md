# AMATEURWEEK1 v4: the amateur fight week (S450)

What changed from v3 (ops/research/AMATEURWEEK1_MAP_V3_S449.md), and why:
- Kalli scored v3 at Depth 6, Play 7 (SQ58, ops/research/AMATEURWEEK_CRITIC_S449_BRIEF_KALLI.md). v4 answers all 18 of the logic points and all 15 "to reach 10" items (table, section 13).
- John's real numbers (SQ57, ops/research/J_CAMPCOSTS_S449_BRIEF_JOHN.md, England Boxing Rules 2026 and measured prices) replace every (J) in v3:
  - the weigh-in moves to bout day
  - matching is at walking weight inside the rule-book gap
  - the $300 miss fee goes (it is not in the rule book)
  - trips and cottages get seasonal prices
  - the taper follows the evidence
- The fight-week price list is MEASURED through the game's real bout (FIGHTWEEKPROBE1, docs/FIGHTWEEKPROBE1_RESULT.md). Section 4 quotes it.
- Code facts read in S450 (Claude):
  - Pad nights belong to each boxer (PadWeek.nights_for per fighter, USUAL_PADS 3). There is no shared pool.
  - The taper runs only inside a camp (PadWeek.pad_share, phase "taper"). A no-camp amateur bout has none today.
  - A stoppage rests a boxer 8 weeks (Matchmaking.STOP_REST_WEEKS), not 30 days.

Sources (kept from v3):
- His S428 scope change, "make it so amateur fights do not require fight camp and can happen within a week".
- Q-209 "Yes, fight week first"; Q-210 "Yes, that order".
- His S448 camp interview, "the buffs need to be real and reflect in the fight", "Fight week too", and who pays: "affect mood/morale, relationship and not always available for the fighter to pay".
- His S448 direction, "Booking a fight i think is better to be an option within a fighters profile tab".
- The look: camp plan v3 (docs/mockups/s449/camp_v3/camp_plan_v3.png).

Words: the map writes "the boxer" and roles ("your assistant", "the head coach"). The screens follow the names-only-in-headers rule (S448): a name appears only in a header, and rows never carry he or she.

## 1. The idea
- An amateur bout comes 1 to 3 weeks out and has no camp (John: firm club matches are made about 1 to 3 weeks out from availability lists). Camps stay for pro fights, title fights and the nationals.
- The player finds the bout on THE BOXER'S OWN PAGE (Fights tab): up to three bouts that pull different ways. If the player does not want to choose, "Coach picks the bout" takes the card that fits the boxer's goal and says why.
- The days before the bell use the camp plan screen, cut to one week (two when the bout is two weeks or more out).
- Every choice lands on ONE box the player reads before saying yes, ON FIGHT NIGHT:
  - the tank at the first bell
  - sharp or flat in round 1
  - plan lines ready
  - the scale margin
  - the win band
- A later date buys something you can see:
  - a trip away (hills, seaside)
  - a punch finished: "two weeks: Uppercut Usable"
  - a full tank with the work banked

## 2. Find a fight (the boxer's page, Fights tab)
- When the boxer is READY, the tab shows up to three bouts from the coming shows, as versus cards (the tale-of-the-tape look). Taking one closes the others. Each card shows:
  - WHEN: days to the bell.
  - HOME OR AWAY, and the favour count with that club (section 7).
  - RANK: what a win and a loss do to the boxer's place (section 3). Under 4 wins the boxer has no place: the card shows "wins to the table: n" instead.
  - WHAT YOU KNOW: the opponent's file, out of five habit groups. A debutant has no tape: "no bouts, no tape" and film is greyed.
  - THE RISK: the chance of being stopped, and the rest if it happens: 8 weeks (Matchmaking.STOP_REST_WEEKS).
  - THE WEEK IT BUYS: ON FIGHT NIGHT at the coach's default week.
- READY / BUILDING (until a date) / RESTING sits on the same tab.
- THE SHEET'S RHYTHM:
  - The next sheet comes 21 days after a points bout, and the day the 8-week rest ends after a stoppage. The sheet is never dead on arrival.
  - At most 11 bouts a season. The tab shows "bouts this season 7 of 11".
  - The 21-day gap allows up to 17 a year. The cap is what holds a season to 9 to 11, as real club boxers box.
- The Fights rail page becomes a list: one row per boxer with the sheet's state and its best card. A click opens that boxer's Fights tab. Taking a bout happens in one place only.
- REPLACES (code): AmateurBooking's one offer at a time and its 8-12 weeks' lead time, for amateur bouts only. John found no source for the long lead. Pro offers keep theirs.

## 3. The bout sheet's trades
"Home" is a show in your own town, run by the regional board: no cost to the club. It is NOT the hosted club show (HOSTSHOW1: $3,500, every 16 weeks, later).

| Choice | Gives | Costs |
|---|---|---|
| Home show | the club keeps the $450 ticket cut; a win brings +8 members and +5 reputation (the code's numbers) | home cards draw names BELOW the boxer: a win adds a win but no place |
| Away show | the host puts its ranked names on its own card, so away is where the boxer climbs (a win over a name above takes that place); free facts on two boxers seen that night; an away win still brings +4 members, +3 reputation (half) | no ticket cut; the van $40 |
| Novice (under 4 wins) | home: the ticket cut, as above; away: free facts and +1 favour with the host | no place to climb yet: the card counts wins to the table |
| Pass | the boxer stays fresh; the next sheet comes in 7 days | mood -3; 6 weeks without a bout = FLAT in round 1 of the next (ring rust); two passes on the same club = it stops calling for 8 weeks |
| Loss to a name above | no place lost | counts in the record |
| Loss to a name below | a new rule (NOT in code today): drops two places | the record |

- The home-judging edge in v3 is REMOVED. Amateur scoring is meant to be neutral, and no measured home effect was found. John's critic answer SQ59 can bring it back only with a measured source.
- The money line: four boxers at about 10 bouts a season is about 40 bouts. The year's ticket money runs from $0 (all away) to $18,000 (all home).
- The card shows the season so far: "home 5, away 3: $2,250 earned, 2 places climbed".
- REPLACES (code): the ticket cut and the members per win now depend on home or away. They used to come with every bout. BudgetProbe re-runs the break-even and the runway on the new income before the build freezes.

## 4. The fight week screen (the camp plan, one week)
Opened from the bout card ("Plan the week") or filled by "The coach runs this week". The layout is camp plan v3, scaled down.

### WHERE TO TRAIN
Prices are for the boxer plus one coach for a week (John, measured on 13 Nov 2026, in GBP x 1.25). Buffs multiply stats the fight reads.

| Location | Cost | Fight-night buffs | Injury | When |
|---|---|---|---|---|
| Home gym | free | none; pad nights as usual | x1.0 | always |
| City club, commute | $150 | new sparring styles: +1 plan test a sparring night; Fight IQ gains x1.3 | x1.3 | always |
| City club, stay over | $1,000 | as the commute, plus one extra sparring night | x1.3 | bout 2+ weeks out |
| Hill cottage | $575 off-season, $1,000 peak | Cardio gains x1.25; Legs gains x1.2 | x1.1 (steep path) | bout 2+ weeks out (the week away, then a week home) |
| Seaside house | $590 off-season, $1,150 peak | recovery +15%; Legs gains x1.15; mood +3 | x1.0 | bout 2+ weeks out |

- Peak season is June to August.
- THE CAP: no location may be worth more than 4 wins in 100 on its own. A probe (CAMPPLACE1) measures each one before the numbers freeze.

### HOW HARD
Three sliders with picture stops. Under each stop, what it does on fight night in numbers.

THE WEEK'S LOAD:

| Stop | Tank at the bell | Round 1 | Banked this week | Carried into next week |
|---|---|---|---|---|
| Rest up | full | FLAT (round-1 edge 2.0 against) | a fifth | nothing |
| Tick over | 6 off | sharp, +1 line ready | half | nothing |
| Train through | 12 off | sharp | a full week | +1 tiredness |

- The probe's prices: section 4b.
- Every point of tiredness over 50 costs 1 off the tank (no cap).
- John's taper (Bosquet 2007; Buglioni 2016): 1 rest day, the same number of sessions, volume cut 40-60%. "Tick over" is that taper. "Rest up" is more rest than the evidence supports; the FLAT round 1 is what it costs.
- REPLACES (code): nothing is cleared. The camp's TAPER phase never ran for an amateur bout, so the load slider IS the amateur bout's taper.

SPARRING: 0, 1 or 2 nights. Each night is one plan test against a live partner, and tiredness rises.
- John: hold the last sparring 7 or more days out.
- On a one-week bout, every sparring night also costs 3 off the tank.
- On a two-week bout, sparring in week 1 is free of that cost.

THE WEIGHT: shown only when the boxer walks outside the gap (section 6). Stops:
- Hold.
- Eat less: 1 off the tank per 0.1 kg, up to 10.
- Train it off: tiredness.

### WHAT THE WEEK BUILDS
- Technique, Power and Cardio shares, always 100%. They apply only to the banked part of the week.
- THE SECOND WEEK'S PUNCH: a two-week bout adds 2 pad nights.
  - If a move would cross Usable (30) or Sharp (60) in that time, the card shows "two weeks: Uppercut Usable" (MoveMastery's pace).
  - That is the only "finished punch" line.

### WHO PAYS (any trip)
John: club boxers get no stipend beyond the club's and have about $25-75 a week to spare. Trips are paid by the club or crowdfunded.

| Payer | Cash | Mood (0-100 scale; a win is +8, a loss -12) | Loyalty (the hidden Loyalty trait) |
|---|---|---|---|
| The club | the club pays it all | +3 | none |
| Half each | half from the club, half from the boxer's savings | +1 | none |
| The boxer | all from savings; greyed with "can't afford it" | win +4, loss -5 | +1 |

- Savings is a new number on the boxer, filled by the stipend's leftover ($25-75 a week; John).

### THE COACH'S PICK
- The pinned note: the head coach's face, a one-line reason, and how sure the coach is. Sureness grows with the coach's rating.
- "Use coach's pick" fills every slider.

### ON FIGHT NIGHT
- The tank, sharp or flat, lines ready (each with its per cent), the scale margin and the win band. It moves live with every slider.
- Each row shows its change from the coach's default week.

## 4b. The price list (FIGHTWEEKPROBE1, measured through the real bout; docs/FIGHTWEEKPROBE1_RESULT.md)
400 bouts a cell, three calibrated pairs (even 45 %, edge 69 %, under 38 % at a full tank), seeds 4421-4423, a men's class.
- THE TANK IS CURVED: 0 to 8 off costs 0 to 4 wins in 100 (inside the noise), 12 to 20 off about 0.7-1.0 a point; the full 25 costs
  8 (even), 16 (edge), 12 (under). The load stops sit on the flat part (8 and 12 off): a "Train through" costs about 2-4.
- TODAY'S FLAT ROUND 1 (the stance cost, 0.6) IS WORTH ABOUT 1 WIN IN 100 and moves round 1 itself by 0-2. Too small to price anything.
- TODAY REST UP WINS FOR ALL THREE PAIRS and the spread is 2 to 6: a lookup, half the 10-12 target.

FIGHTWEEKPROBE2 (S450, same pairs, 400 bouts a cell; LiveRound reads bout["r1_flat"], 0 = sharp, round 1 only):
| Flat round 1 | 0 | 1.0 | 2.0 | 3.0 |
|---|---|---|---|---|
| EVEN: win / round 1 won | 49 / 48 | 48 / 46 | 46 / 43 | 45 / 41 |
| EDGE | 72 / 55 | 71 / 52 | 70 / 49 | 69 / 46 |
| UNDER | 33 / 27 | 32 / 25 | 31 / 23 | 29 / 20 |
Even a 3.0 flat costs the bout only 3-4 wins (round 1 itself 7-9). With Rest up's flat at 2.0 the shapes read: EVEN Rest up 45, Tick
over (6) 45, Tick over (8) 45, Train through 42; EDGE 70 / 69 / 67 / 67; UNDER 26 / 28 / 27 / 26. Rest up no longer wins every pair, but
every gap is inside the noise.

THE FINDING (it changes the target): in this engine a fight week's levers on FIGHT NIGHT are worth at most about 5 wins in 100 (the whole
25-point tank 8-16, a flat round 1 3-4). The v3 target "best week vs laziest 10-12 in 100 on fight night" cannot be met without making
one week outweigh a fighter's training, which would be untrue to boxing (a fight week sharpens, it does not build). So v4's target is
THE TRADE, measured over a season, not one night:
- On fight night: no stop wins every pair (met at flat 2.0); the best-to-worst fight-night gap stays under 5 in 100.
- Over the season (FIGHTWEEKPROBE3 through the career harness, 26 weeks, three players: always Rest up / always Train through / the coach's
  pick by matchup and tiredness): the banked work (Train through = a full week, Tick over = half) must make the always-Rest-up player
  finish the season 4-8 wins in 100 behind the coach's pick, and the always-Train-through player lose 2-5 more stoppages or injuries.
  Season gap best-vs-laziest: 8-12 in 100. That is where the week's decision weighs, and it is the number the critics get.

v4's prices (Rest up's flat at 2.0, from the table above):
| Stop | Tank at the bell | Round 1 | Fight-night credit | Banked |
|---|---|---|---|---|
| Rest up | full | FLAT: a round-1 edge of 2.0 against the boxer (round 1 about 5 points worse) | none | a fifth |
| Tick over | 6 off | sharp | +1 plan line ready (the sharpening session) | half |
| Train through | 12 off | sharp | none | a full week, +1 tiredness carried |

## 5. The film evening, and tells confirmed in the fight
- Film takes ONE of the boxer's own pad nights (PadWeek: each boxer has 3). The boxer pays for film with one fewer pad night. The v3 "shared evenings" and "goes to the bag" lines are gone.
- One evening answers ONE of five habit groups. They map onto the code's opponent file (OppFile):

  | Habit group | OppFile entry |
  |---|---|
  | entries | weapon |
  | preferred range | weapon |
  | reactions under pressure | habits |
  | defensive habits | habits |
  | when the opponent starts slow or fades | weakness |

- A debutant has no tape: film is greyed, with the reason.
- The opponent's file shows the five groups, each SEEN, CONFIRMED or UNKNOWN.
- A tell seen on tape is a guess until the fight shows it:
  - A plan line built on a SEEN tell runs at 90% in round 1.
  - At the first corner minute the corner says whether it showed. CONFIRMED gives full value from round 2. Not seen drops the line to Works.
  - A CONFIRMED tell is kept for the rematch at half value.
  - NEEDS FireLevel on: the progression build's FIRELEVEL3 switches move levels on in the fight. Until it lands, plan lines fire every time and the 90% line is not built.
- Free facts come at AWAY shows only: up to two boxers at your weights, one group each. This is part of the home or away trade.
- The pool refreshes: two new names a weight each season, one leaves.

## 6. The weight, at walking weight (England Boxing Rules 2026, John)
- Matching is at actual weight plus a gap, never the class limit. The gap is the smaller boxer's weight-category width (rule 2.7.8):
  - 2.5 kg at 57-65 kg
  - 5 kg at 65-75 kg
  - youth uses the same rule (2.6.6)
- Each bout card names the agreed weight.
- Inside the gap: no weight question, and the slider is hidden. Just outside: Eat less or Train it off. A club-show cut is 0 to 1 kg (John).
- THE WEIGH-IN IS ON BOUT DAY, one hour before the boxing (rule 7.1.3). It moves from the day before in code.
- A MISS: the bout is off, or re-matched on the night if the other boxer is inside the gap. The host takes 1 favour.
  - The $300 fee goes: it is not in the rule book.
  - Youth tolerance is 300, 500 or 700 g by weight band (rule 7.1.14).
- ASK FOR A KILO costs one favour (section 7). The opponent then starts with 5 more in the tank.
- The boxer's card: "can take a bout in 7 days: yes / no".
- The regional table stays per class.

## 7. Favours
- A count of 0 to 3 per club, shown on each bout card and on the region's club list.
- EVERY CLUB STARTS AT 1, and a club below 1 comes back to 1 after 12 weeks with no ask. The climb can never be locked from day 0.
- Earned:
  - taking a late replacement on their show
  - saying yes to their kilo ask
  - an away novice bout on their show
  - (later) putting their boxer on your hosted show
- Spent:
  - asking for a kilo
  - pulling out of their show late
  - missing weight on their show
- AT 0: the club still offers its ranked names, but only on away cards, and never agrees to a kilo.
- Favours never buy rank or wins.

## 8. Things that happen, and routine bouts
- A BOUT FALLS THROUGH: 25 in 100 in the week before a show. John: club shows lose a quarter to a half of their bouts; the low end is used.
  - The matchmaker offers ONE late replacement, 0 to 5 days out: less known, or up to a kilo heavier inside the gap, or three bouts more experienced (never across the novice line).
  - Take it: +1 favour with the host.
  - Go home: no bout, mood -6, the week spent.
  - Continue stops for it.
- TWO SHOWS ON ONE NIGHT:
  - The head coach takes one corner and your assistant takes the other.
  - The assistant's calls are right 0.5 + rating/200 of the time (rating 58 is about 0.79, 74 about 0.87).
  - With no assistant, a club member works the corner: calls are right 1 in 2, and there is no ONE CHANGE.
- ROUTINE: "The coach runs this week" fills the default week in one click. The clock stops only for a fall-through, a weigh-in margin under 0.2 kg, or two shows on one night.

## 9. Code rules this map replaces or adds (by name)
| Code today | v4 |
|---|---|
| AmateurBooking: one offer at a time, 8-12 weeks' lead | BoutSheet: three cards, 1-3 weeks out, for amateur bouts; pro offers unchanged |
| A $450 ticket cut and +8 members / +5 rep on every bout | home only; an away win at half (+4 / +3); BudgetProbe re-run |
| Weigh-in the day before, $300 for a miss | bout day, 1 hour before; a miss = bout off or re-matched, -1 favour, no fee |
| TAPER only inside a camp | unchanged; the amateur bout's load slider is its taper |
| A stoppage rests 8 weeks | unchanged; the next sheet comes the day it ends |
| Nationals entry: 5 bouts, 3 months, age 19-40, closes week 10 | unchanged; the v3 "win share line" is DROPPED unless John confirms a real selection |
| A loss moves no place | new: a loss to a name below drops two places |
| Plan lines fire every time (FireLevel off) | the 80% / 90% lines wait for FIRELEVEL3 |
| No savings on the boxer | new: savings |
| No favours | new: Favours |

## 10. Critics' points, each answered
Kalli SQ58 (v3), logic points 1 to 18 and the "to reach 10" list (K1 to K15):

| Point | v4 |
|---|---|
| 1 Favours start nowhere (K1) | every club starts at 1, comes back to 1, at 0 still offers ranked names away |
| 2 Sheet vs suspension (K4) | the sheet comes when the 8-week rest ends; the "30 days" was not the code's number |
| 3 9-11 bouts do not follow (K4) | a cap of 11 a season, shown |
| 4 Ticket cut and members (K3) | home only, away at half; BudgetProbe re-run listed |
| 5 What is a home show | a regional-board show in your own town, not HOSTSHOW1 |
| 6 Home judging (K14) | removed |
| 7 Rank before the table (K5) | the novice road: "wins to the table: n"; the drop-two rule listed as new |
| 8 Nationals line (K6) | dropped unless John confirms |
| 9 One offer, lead times (K6) | BoutSheet replaces it for amateurs; the Fights rail lists each boxer's sheet |
| 10 TAPER | the code read: taper never ran for an amateur bout; the load slider is it |
| 11 Pad nights (K7) | per boxer; film costs the boxer's own night |
| 12 Mood scale (K2) | sized on 0-100; "bond" replaced by the existing Loyalty |
| 13 Weight (John) | rule-book gaps, bout-day weigh-in, no fee |
| 14 Free facts (K13) | away only |
| 15 Five groups vs the file (K13) | mapped onto weapon / habits / weakness; debutant greyed |
| 16 80% / 90% lines | wait for FIRELEVEL3, said |
| 17 A named coach in the rules (K12) | your assistant by role, sized by rating; no assistant = a member |
| 18 Names and pronouns | the map writes the boxer and roles |
| K8 Load stops all live | priced by the probe (section 4b) |
| K9 Location numbers | the table in section 4, with the 4-in-100 cap and CAMPPLACE1 |
| K10 Second week's punch | the "two weeks: Uppercut Usable" rule |
| K11 Coach picks the bout | section 1 |
| K15 Probe order | section 12 |

## 11. Every menu it appears on, and what each is wired to
| Menu | What it shows | Wired to |
|---|---|---|
| Boxer page, Fights tab | up to three bout cards, READY/BUILDING/RESTING, the season line (home/away, earned, places, bouts of 11), Coach picks the bout | BoutSheet (new), Region, RankLine, OppFile, Favours |
| Fights rail page | one row per boxer: sheet state + best card; opens the tab | BoutSheet |
| Bout card | ON FIGHT NIGHT at the default week, the risk, what you know, favours with that club, "two weeks: <move> Usable" | FightWeek (new), BoutRules, OppFile, MoveMastery |
| Fight week screen | locations with costs, buffs and injury; load / sparring / weight sliders; shares; who pays with mood and loyalty; the coach's pick; ON FIGHT NIGHT live | FightWeek, CampPlace (new), PadWeek, Money, savings, Loyalty |
| Week board (Training) | the fight week's nights, film on the boxer's own pad night, trip days | WeekPhase, PadWeek |
| Office desktop (OFFICE1) | the bout and fight-week chips on the calendar; "Needs you" for an open sheet | OfficeDesk |
| Boxer card (Roster) | "can take a bout in 7 days"; the tank bar in fight week | Fighters, weigh_forecast |
| Tape room | five groups SEEN / CONFIRMED / UNKNOWN; free facts from away shows | TapeRoom, OppFile |
| Playbook | each line ready (after FIRELEVEL3: its per cent) | GamePlan, PlanLines |
| Region / club list | each club's favours | Favours |
| Continue | stops for a fall-through, a tight weigh-in, two shows | Clock, Needs |
| Fight night | the bout-day weigh-in first; the corner chosen | BoutNight |
| Corner minute (round 1) | CONFIRMED / Not seen (after FIRELEVEL3) | the corner read, OppFile |
| Result page | the sizes ("Legs: 14 off the tank, round 3 lost"), the rank earned, the season line | FightWhy, RankLine |
| Money | home ticket cuts, the van, trips by payer | Money, GymBills |

## 12. Build order
1. Probes:
   - FIGHTWEEKPROBE1 (done, section 4b)
   - BudgetProbe on the home/away money
   - CAMPPLACE1: each location under 4 in 100
   - the favour test: can a new club reach a ranked away name inside 8 weeks
   - the season count of bouts under the cap
2. Pure rules with tests: FightWeek, BoutSheet, CampPlace, Favours, TellConfirm, Savings.
3. Wire-ups:
   - the bout-day weigh-in
   - the miss rule
   - the home-only ticket cut
   - the stop rest feeding the sheet
4. Screens, one a task: the Fights tab with bout cards, the Fights rail list, the fight week screen (camp plan look), the week board's nights, the corner's confirm line (after FIRELEVEL3), the result's sizes.
5. Golden path: Find a fight, pick, plan the week (one trip, one film), weigh-in on the day, the fight, the result with sizes and the rank earned.

## 13. Open for him (taste and scope, on the board after the critics)
- Away shows are where the boxer climbs: the club-boxing feel he wants?
- Savings on each boxer (new): yes or no.
- Hills and seaside only for bouts two weeks out: right, or too strict?

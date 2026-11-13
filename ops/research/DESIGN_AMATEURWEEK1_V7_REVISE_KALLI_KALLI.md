# DESIGN_AMATEURWEEK1_V7_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ73)

Brief: research/DESIGN_AMATEURWEEK1_V7_REVISE_KALLI.md
Sent: 2026-11-13 21:10 | collected: 2026-11-13 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Writing v7 of the fight week map now. It answers both critics' lists point by point.

Part 1 of 3

# AMATEURWEEK1 v7: the amateur fight week (S459)

v7 is a full map. It replaces v6 (S455) and v5 (S451), so nothing outside this page stands.

Critics on v6: Kalli SQ71 (Depth 5, Play 6) and John SQ72 (Depth 6, Play 7). They found the same four things:
- The SEASON line printed the answer.
- The tank cap made tired boxers pay least.
- Half each and late sparring were dominated.
- Sparring "confirmed" nothing.

v7 makes each choice best in a state the player can read off the screen. Every number is marked MEASURED, GAME (already in the code or the pack) or ESTIMATE (to be measured before build).

**Owner rules kept, quoted:**
- S448: "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". A name appears once, in the screen's header. Everywhere else the text says the boxer, her / him, the opponent, your assistant or the head coach.
- S412 SANDBOX: any gym, any boxers, men or women; no fixed he or she.
- Females never fight males. Slots are by sex and class.
- Section 7: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- "Gym" is the facility; "camp" is only pre-bout preparation. Amateur bouts have no camp, so this screen is the FIGHT WEEK.
- S455: the art stays consistent. This screen is drawn in Look B, the gym whiteboard.
- Everything new ships switched ON.

**Words:** "under 4 wins", never "novice". Classes always in kg ("your other 65 kg boxer"). Stats on this screen use the Attrs names (the 14 abilities). Power, Technique and the other old seven appear only as the summary on the profile.

## 1. The idea

An amateur bout is booked 1 to 3 weeks out and has no camp. The FIGHT WEEK SCREEN covers the bout's last two weeks:
- **Bout 2+ weeks out:** a slim WEEK BEFORE strip (trip and sparring night) sits above the fight week.
- **Bout 1 week out:** the fight week only.
- **Bout 3 weeks out:** week 1 is a normal BUILD week on the week board.

**PEAK (K8):** for an amateur bout, the WEEK BEFORE strip replaces PEAK. That week runs as BUILD plus whatever the strip sets. The fight week replaces TAPER and is set by the load stop. CHECK (Claude): today WeekPhase gives PEAK to a 2-week amateur bout, so this needs a WeekPhase branch for amateur bouts.

Every choice lands on ON FIGHT NIGHT, which has three rows: TONIGHT, BANKED and SEASON.

## 2. The bout sheet

**SLOTS BY CLASS.** A show offers 8 to 12 bouts as slots by sex and class. A card needs an open slot in the boxer's class.
- Two of the club's boxers in one class: the slot goes to the one who has waited longer since their last bout.
- The other boxer's card says why: "this slot went to your other 65 kg boxer" (K15).
- A sheet shows up to three cards. Slot test target: 2 or more on average.

**PASS (J9; K13 not taken).** Passing a whole sheet is free. Only refusing a card that a club offered by name counts against that club. Two refusals in 8 weeks lock that club out for 8 weeks.
- Each named card shows "refused 1 of 2".
- K13 (one pass to every club on the sheet) is not taken, because it locks three clubs for one press.

**REMATCH (K, missing option).** When a boxer met before is on a sheet, the card is marked REMATCH and the tells found last time come back at SEEN.

**ASK FOR A NAMED AMATEUR OPPONENT (K, missing).** This is not in this map. The pack agrees the panel ("Ask for a fight" under the offers) and it waits on bot test R37. The sheet keeps space for it under the cards.

**THE REST WINDOW (J5).** On the boxer page's Fights tab: "next bout no sooner than 3 / 5 / 8 weeks", default 3.
- It replaces the fixed 21 days after a points bout.
- It moves the next sheet, and so Train through's state and ring rust.
- After a stoppage loss, the window can't be set shorter than the code's rest (the 30-day suspension and `Matchmaking.STOP_REST_WEEKS`). Both stay.

**RING RUST:** 6 weeks READY without a bout puts the boxer FLAT in round 1. It counts from the end of any suspension.

**THE HOME TICKET CUT** is the game's $450 (GAME; no sourced share exists).

**THE NATIONALS (J8).** Entry needs 5 bouts in the last 12 months and 3 months registered.
- Each card shows "bouts to entry n of 5" and the entry week.
- In year 1, when entry week 10 can't be reached, the card says "next entry: week 10, next year".
- During a run the sheet is closed, with the reason.
- The nationals screen has no next-year state today, so it has to be built.

**YOUR ASSISTANT PICKS THE BOUT.** The pick reads the boxer's goal: a rank goal picks away, a money goal picks home.
- Under 4 wins there's no table, so a rank goal is greyed with that reason (J).
- New goal types in FighterGoal:
  - "Climb to top 3 by <date>"
  - "Bring $n to the club this season"
  - "Three bouts before the nationals"
- "Bring $n" stays a boxer goal because it counts only that boxer's bouts. Club goals aren't built.

**PRO PACE:** at 9 to 11 bouts a season and 61% wins (MEASURED), 9 wins take about 1.4 seasons. This goes to the owner's board (section 13).

## 3. The bout sheet's trades

**Home:** $450, +8 members, +5 reputation (GAME).

**Away:** a chance at a ranked place, and two more boxers' facts on file.

**The loss-below rule:** "a loss to a name below drops two places" changes the pack's rank rule. It's on the owner's board and is not built without a yes. Until then an away loss costs only the record.

**Favours with a host (0 to 3):**
- Earned by filling a late gap.
- Spent on ASK FOR A KILO or a re-match after a miss.
- Test target: an average club sits at 1 to 2.

## 4. The fight week screen

### 4.1 WHERE TO TRAIN

Prices include food for two at $120 a week (John S449) and $50 of extras.

| Trip | Cost a week | What it does (shown on TONIGHT) | Price beyond cash | Fall-through refund (J11) |
|---|---|---|---|---|
| Home gym | free | nothing extra | none | - |
| City club, commute with your assistant | $150 + $120 food | a partner in the opponent's style; round-1 edge 1.0 against that style (ESTIMATE, about 1-1.5 in 100) | injury x1.15 for the week (K7, ESTIMATE); assistant away by day, evening class RUNS (K7: a commute is days only) | none; the banked week stays |
| City club, the boxer goes alone (J12) | $150 + $60 food | half the edge (0.5) | +1 tiredness a day of travel (ESTIMATE); no coach away | none |
| Hill cottage (week before only) | $745 off-season, $1,170 June-August | one rule (K6): the week before banks in full with no TrainingLoad entry, and the fight week starts with 10 less tiredness | the coach is away for the whole week | half |

- **Seaside house:** CUT, because a free home Rest up week already gives the rest.
- **The style partner (K, missing option "pick the partner"):** not taken. The opponent's file has one style word, and habits aren't styles, so there's never a second partner to pick. The style is free at booking, so the city club always shows. Its price is now the injury, the food and the money.

**THE COACH GOES TOO.** The cottage takes your assistant, or the head coach if there's no assistant. A commute takes them by day only. The screen prints the cost at home:
- **Assistant away a full week:** the other boxers train at the coach factor with only the head coach (K13), and the evening class stops (-$350). CHECK (Claude): today's factor with only the head coach present. The screen prints the real number, not "60%".
- **Head coach away:** no head-coach edge, and no shouts for any other bout that week.

**CAMPPLACE1** measures each trip per use against a home Rest up week. Target: 1 to 4 wins in 100 for that bout (ESTIMATE target).

### 4.2 THE TANK (K5, J3)

The tank is capped at 25 off. Parts stack in this order: the load stop, sparring, the weight, then tiredness over 50 (1 off per point).

The cap cuts tiredness last, so the greyed overflow always reads "tiredness already lost: n". A tired boxer still pays in full for Train through, sparring and a cut.

Part 2 of 3

### 4.3 THE WEEK'S LOAD: each stop best in a state you can read

| Stop | The week | Tank at the bell | Round 1 | Banked (J4) | Carried | Best when (printed on the stop) |
|---|---|---|---|---|---|---|
| Rest up | three rest days (today's TAPER) | clears tiredness over 50; no load part | FLAT, edge against 2.0 under 40 start tiredness, 1.0 at 40-64, none at 65+ (K2, ESTIMATE) | a fifth of the week's pad units | tiredness to 30 | start tiredness 65+, or a heavy cut |
| Tick over (default) | one rest day, volume cut by half (J14, matching John's S449 evidence) | 6 off | sharp; ONE chosen plan line fires one level up in rounds 1 AND 2 (K2) | half | nothing | most weeks under 65 |
| Train through | full week | 12 off | sharp | the full week's pad units (720 for 3 pad nights) on the plan's moves | +6 tiredness; the week enters TrainingLoad's ratio (1.3x high, 1.5x spike: 2-4x injury, GAME) | a plan move sits within one week of Usable or Sharp ("Uppercut Usable by the bell"), or the opponent is rated 5+ below |

**The Tick over line picker (K17)** offers only lines at Usable or Sharp. Raw lines don't fire, and Signature can't go up.

**Train through (K3, J4)** banks in mastery, not stat points. The stop prints the crossing it buys. With FireLevel on, a move that crosses to Usable fires 1 use in 2 that night (GAME), so the state is common and the player can see it.

**BANKED** shows the Attrs number and the move, never a range. Example: "Strength +0.4, Uppercut 27 to 31". The +0.4 is an ESTIMATE; the probe prints the real figure.

### 4.4 SPARRING: the night that gets a plan ready (K4, J2)

**Rule:** a plan line written or changed since the boxer last sparred is UNSPARRED. It fires one level down in rounds 1 and 2. A Usable line drops to Raw, which doesn't fire.

A sparring night readies lines and runs a PLAN TEST against a club partner of the nearest style. The test rates each line (Beats it / Works / Walks into it) before the bell, so the player can still change the plan.

Sparring no longer confirms tells (K5, J). Only the fight confirms a tell.

The player places 0, 1 or 2 sparring nights on days of the two weeks (K6: nights, not a last day).

| Night | Price | Readies |
|---|---|---|
| Week before (8+ days out) | one pad night's mastery lost (K4: never free) | two lines |
| Fight week, 7 or 6 days out | 3 off the tank | two lines |
| Fight week, 5 or fewer days out | 3 off the tank and x1.5 training injury | every line |

Each night's price is separate, so two fight-week nights cost 6 off the tank.

**Why each choice has a state:**
- **No sparring:** right when the plan is unchanged since the last sparring (all lines ready), or with a heavy cut.
- **Week before:** right when there's time.
- **Late night:** right when the player rewrote the plan after the tape.

Measure target: sparring is worth 2 to 5 wins in 100 a bout when the plan is new (ESTIMATE target).

**Your assistant's default:** a week-before night when one exists, else a 7-day night when the tank stays under 12 off, else none.

### 4.5 THE WEIGHT (K11, J7: one rule)

**The match:** the slot is the class, so the boxer must make the class limit at the weigh-in on bout day. Inside the class, opponents are paired within the category width of each other's walking weight.

**A cut is a choice to box down** for that class's slots and ranked names. Walk-ins walk 2 to 4 kg over their lightest class, so the first-hour choice is "box at 60 kg in 3 weeks, or at 65 kg now". The first-hour cut stays a real choice.

**Ways to make weight:**
- **EAT LESS:** the diet cut (GAME).
- **TRAIN IT OFF:** 0.3 kg for +8 tiredness. It's better than Eat less only at low tiredness, about under 42 at the bell (DERIVED by John).
- **ASK FOR A KILO:** costs 1 favour, inside the smaller boxer's category width. When it would cross, it's greyed with the reason. CHECK (John): the 2026 widths against the game's classes.

**A MISS:** re-matched on the night when the host has a fitting spare (1 in 3, ESTIMATE). Otherwise the bout is off, the club pays $300 (GAME) and the host takes 1 favour.

### 4.6 WHO PAYS (K8, J6)

Savings come from the boxer's own job: $25 to $75 a week by background, shown at signing. They stop only if the background says "full-time on the stipend".

| Payer | Club's cash | Mood (ESTIMATE) | Gate |
|---|---|---|---|
| The club | full | +3; -2 with each other boxer when the club paid for this one more often in the last 8 weeks | none |
| Half each | half | +3 on a win, 0 on a loss | savings cover half |
| The boxer | none | +6 on a win, -6 on a loss; savings under $100 after paying make the boxer SKINT, -2 a week until savings refill | Confidence solid (55+), and savings cover it; otherwise greyed with the reason |

At 61% wins (MEASURED) the boxer row is about +1.3 mood, half each about +1.8 and the club +3 minus the fairness cost. Each row wins somewhere:
- **The club:** money is safe and this boxer hasn't been favoured.
- **Half each:** the safe middle.
- **The boxer:** cash is short and the boxer is confident with savings.

BudgetProbe re-checks that each row is best for some boxer. If one never is, it's cut.

### 4.7 FUNDRAISER (K9, J13)

- A club night in place of one evening class, at most once every 8 weeks, needing a coach in the gym that night.
- The take follows reputation (ESTIMATE): under "Known locally" it nets about -$150, and at "Respected" or above about +$150.
- With your assistant away the class has already stopped, so a fundraiser can't run that week. No free night.

### 4.8 YOUR ASSISTANT'S PICK

- The pick reads five facts: start tiredness, the weight's tank cost, the opponent's round-1 style, the gap in rating, and whether the plan is unsparred. It names the one that drove it.
- It's wrong at (1 - sureness). Sureness = 0.5 + rating / 200 (Luke Reid 0.79, Marcus Hale 0.87). When wrong, it takes the next-best stop and still gives its reason.
- The pick card names no one. It says "your assistant" beside the portrait.

### 4.9 SEASON, the price line (K1, J1)

SEASON shows each stop's measured season cost against Tick over (a fixed baseline), for the boxer's start-tiredness band only. Example: "Rest up here: -1 to +2 in 100".

The opponent gap, weight, unsparred lines and moves near a tier stay out of the line. The player weighs them, and so does the pick, so SEASON never prints "the best stop". The numbers print only from FIGHTWEEKPROBE4.

## 4b. The price list (what must be measured)

**FIGHTWEEKPROBE4** runs on BoutSheet with 9 to 11 bouts a season, the rest window, the load ratio, unsparred lines, mastery banking, the new Rest up and the new tank order. It reports, for each state (start-tiredness band, rating gap, a move near a tier, a new plan, a cut), which stop wins.

Build targets:
- Each load stop is best in at least 1 fight week in 5, within each tiredness band (K2).
- A whole fight week's best-to-worst gap is 3 to 8 in 100 (today's is under 5, MEASURED).

**THE ASSISTANT PROBE (K14, J1):**
- **Measure:** "always the pick" against "the best stop each week", and a reader who weighs the facts against "always the pick".
- **Target:** a reader beats the pick by 2+ in 100 a season.
- **If the gap from pick to best stop is under 1 in 100:** the load slider becomes two stops (Tick over / Rest up), defaults to the pick, and is folded under "Change the load". It's not called a decision.

## 5. The film evening (K10, J10)

- A film night costs a pad night and opens one tell group. A tell is checked at the first corner minute where the opponent's mode matched it.
- A fade or slow start is checked at the round-2 minute. An amateur bout has minutes only after rounds 1 and 2.
- **Tells can be wrong:** a SEEN tell is true at 70% after one film night and 90% after two (ESTIMATE). A tell whose mode came up and didn't show drops a level. A tell whose moment never came stays SEEN. That gives the second film night a price and gives CONFIRMED a meaning.

Part 3 of 3

## 6-8. Favours and things that happen (K12, J11)

**Late replacement asks:** a host asks at most once per show, only when the boxer fits the gap and is READY (about 1 ask in 6 shows, ESTIMATE).

**Own-bout fall-through:** 35 in 100 in the final week (ESTIMATE). CHECK (John): the amateur pull-out rate in the final week. If his range is lower, use its middle.

**One stop per boxer per bout at most.** All asks and fall-throughs wait for Monday and stop the clock once, as one need on Home.

**The fall-through card has three answers:**
- Take the replacement.
- Go home: Rest up's carry, mood -6.
- Ask the host for next month's slot: -1 favour, booked.

**Refunds:** the cottage refunds half, the commute nothing. The banked week always stays.

## 9. ON FIGHT NIGHT (the one gold frame)

**TONIGHT:**
- The stacked tank: choices in colour, tiredness in grey, overflow hatched, with its price in wins.
- Round 1 sharp or flat.
- Each plan line's fire share, tagged ready, UNSPARRED, SEEN or CONFIRMED.
- The scale margin.
- The win band.

**BANKED:** the Attrs points, the moves crossing a tier by the bell, and tiredness carried.

**SEASON:** this stop against Tick over in this tiredness band, with its range.

Each row shows its change from your assistant's pick. Hovering any number shows its parts. There's no PEAK CAMP row and no "gains x" multiplier.

## 10. Critics' points, each answered

| Point | v7 |
|---|---|
| K1 / J1 SEASON prints the answer | against Tick over, tiredness band only (4.9) |
| K2 Rest up from 40 | FLAT at every band with a shrinking edge; full tank defined; Tick over's line rounds 1-2 (4.3) |
| K3 / J4 Train through unreachable | banks in mastery; best when a move is near a tier (4.3) |
| K4 / J2 Sparring buys nothing | unsparred lines fire a level down; nights ready lines plus a plan test; week-before night costs a pad night (4.4) |
| K5 / J3 Tank order | choices first, tiredness last (4.2) |
| K6 / J Cottage two rules | one rule, -10 tiredness (4.1) |
| K7 City club free | injury x1.15, food $120, class runs on a commute (4.1) |
| J12 Boxer goes alone | added (4.1) |
| K8 / J6 Half each dominated | rows re-priced, Confidence gate, skint, fairness (4.6) |
| K9 / J13 Fundraiser chore | every 8 weeks, coach needed, reputation odds go negative (4.7) |
| K10 Round-3 minute | round-2 minute only (5) |
| J10 Tells never wrong | 70% / 90% truth (5) |
| K11 / J7 Weight contradiction | slot = class limit, pairing within width; a cut = box down (4.5) |
| K12 / J11 Fall-throughs | one stop a bout, refunds, three answers (6-8) |
| K13 Pass to every club | not taken (cascade); J9 named refusals only (2) |
| K14 Probe unreachable | re-measured; fallback to two stops (4b) |
| K15 / J14 Words | kg classes; Attrs names on screen; banked names its number |
| K16 Mockup | redraw as this screen in Look B; needs BoutSheet and RegionShows, not built (12) |
| K17 Tick over line | Usable or Sharp only (4.3) |
| K8 PEAK clash | strip replaces PEAK for amateur bouts; CHECK (Claude) (1) |
| K13 Coach factor | prints the real factor; CHECK (Claude) (4.1) |
| J5 Rest window | 3 / 5 / 8 weeks on the Fights tab (2) |
| J8 Nationals year 1 | rolling 12 months; "next entry" (2) |
| J14 Tick over vs evidence | one rest day, volume halved; Rest up keeps three (4.3) |
| J14 STOP_REST_WEEKS | kept; the window can't undercut it (2); no rule change for the board |
| J Rank goal under 4 wins | greyed with reason (2) |
| K missing: ask named opponent | waits on R37, agreed panel (2) |
| K missing: rematch | REMATCH card, tells back at SEEN (2) |
| K missing: partner choice | not taken: one style word per file (4.1) |

## 11. Menus: every place the mechanic appears

| Menu | What it shows / lets you do | Wired to |
|---|---|---|
| Home (needs) | one need for an open sheet; one Monday need for asks and fall-throughs | Needs, BoutSheet |
| Office desktop | the sheet and the bout dates in the next four weeks | Desktop (built), BoutSheet |
| Fights rail page | each boxer's sheet: up to 3 cards, PASS, "refused n of 2" | BoutSheet, RegionShows |
| Bout card / versus screen | slot reason, REMATCH, "bouts to entry n of 5" / next entry, home or away trade, win band | BoutSheet, Nationals, OppFile |
| Boxer page, Fights tab | rest window 3 / 5 / 8; your assistant picks the bout (goal-read, greyed reason) | Matchmaking, FighterGoal |
| Fight week screen | WEEK BEFORE strip (trip, sparring night); week magnets; LOAD, SPARRING, WEIGHT sliders; who pays; the pick; ON FIGHT NIGHT | FightWeek, CampPlace, TrainingLoad, WeekPhase, PadWeek, Savings |
| Week board | BUILD week of a 3-week bout; the strip's settings shown read-only | WeekPlan, WeekPhase |
| Playbook, Game plan | UNSPARRED tag on changed lines; plan test results | Playbook, StrikeMap, FireLevel |
| Tape room | film nights, SEEN tells with their truth share | OppFile, TapeRoom |
| Corner minute (rounds 1 and 2) | CONFIRMED / Not seen, fade check at round 2 | FightNight, OppFile |
| Result page / Why | lines that fired a level down because unsparred, named in AGAINST YOU | Why |
| Roster boxer card | savings a week; SKINT flag; "can take a bout in 7 days" | Savings, Recruit |
| Goals (boxer page) | the three new goal types | FighterGoal |
| Money | trips by payer, fundraiser nights (every 8 weeks), refunds | GymBills |
| Championships | rolling entry count and next entry week | Nationals |
| Continue button | stops once a Monday for the asks | Clock |

## 12. Build order

1. **Probes:**
   - FIGHTWEEKPROBE4 (by state, 4b).
   - The assistant probe.
   - CAMPPLACE1 (per use, against a home Rest up week).
   - BudgetProbe (payer rows, fundraiser by reputation).
   - The favour test (1-2).
   - The slot test (2+ cards a sheet).
   - The sparring test (2-5 in 100 for a new plan).
2. Not built yet and needed first: BoutSheet, RegionShows, the WeekPhase amateur branch, Savings, the Nationals next-year state.
3. The fight week screen, from a redrawn Look B mockup of THIS screen, cut to the 10/10 layout below. Seaside, PEAK CAMP, gains-x and the dark style are dropped from the camp v3 mockup.
4. The rest window, REMATCH, fall-through card.
5. Tells' truth share and the film change.

**The screen at 1920×1080:** the shell (dark top bar, left rail) around a whiteboard.
- **Header (96 px):** both portraits, the names once, the class in kg, records, days to the bell, home or away, favours with the host, the scale margin now and on the day.
- **Left (440 px):** trip cards with cost, tonight's number and refund; the red-edged COACH AWAY card; the payer row with savings and mood.
- **Centre (920 px):** seven day columns of magnets (sparring night red, film night a tape magnet); the LOAD, SPARRING and WEIGHT sliders; plan line chips (ready, UNSPARRED, SEEN, CONFIRMED).
- **Right (560 px):** ON FIGHT NIGHT in the one gold frame.
- **Bottom strip (120 px):** your assistant's note, Use the pick, Back to the coach's week, and the red Lock the week.

Green is used only for Continue.

## 13. Open for the owner (on the board after the critics)

- The pro road: "9 wins with 3 over ranked names", or keep "9 wins at any rank"; and the pace (about 1.4 seasons).
- A loss to a name below drops two places: yes or no.
- Savings from the boxer's own job ($25-75 a week): yes or no.
- The rest window replacing the fixed 21 days: yes or no.
- Tick over at one rest day (the evidence) instead of today's three-day TAPER: yes or no.

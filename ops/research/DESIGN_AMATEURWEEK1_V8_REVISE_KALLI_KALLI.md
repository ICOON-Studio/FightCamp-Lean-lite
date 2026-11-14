# DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI - Kalli answer (seat queue SQ88)

Brief: research/DESIGN_AMATEURWEEK1_V8_REVISE_KALLI.md
Sent: 2026-11-14 02:41 | collected: 2026-11-14 03:11 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# AMATEURWEEK1 v8: the amateur fight week (S459)

Part 1 of 3

v8 is a full map. It replaces v7 (S459, seat SQ73), and nothing outside this page stands.

**Critics on v7:**
- John SQ80: Depth 6, General design 5, Play 6.
- Dola SQ79: Depth 8, General design 8, Play 7.

John's eight build faults decide this version:
1. The tank cap still makes tired boxers pay nothing.
2. Eat less has no tank number.
3. The weight rule mixes a class limit with a weight gap.
4. Fall-throughs land after the bout, and the cottage refunds a stay that already happened.
5. A plan test followed by a change loops back to unsparred.
6. The player can't pick who takes a shared slot.
7. The fundraiser and film have loose edges.
8. Pack changes are missing from the build list.

**Number marks:**
- **MEASURED:** from a probe already run.
- **GAME:** in the code or the pack today.
- **ESTIMATE:** ours, measured before build (section 12).
- **NEW:** a rule this map adds.
- **[R]:** a real-world source.

**Owner rules kept, quoted:**
- **S448:** "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule". A name appears once, in the screen header. Everywhere else the text says the boxer, the opponent, your assistant or the head coach.
- **S412 SANDBOX:** "the player runs any gym with any boxers, men or women". There is no fixed he or she.
- Females never fight males, and slots are by sex and class.
- **Section 7:** "i do not want stupid and unecessary information to be displayed unless the player can really do something about it".
- "Gym" is the facility and "camp" is pre-bout preparation only. Amateur bouts have no camp, so this screen is the FIGHT WEEK.
- **S455:** the art stays consistent; the screen is Look B, the gym whiteboard. Everything new ships switched ON.

**Words:**
- Say "under 4 wins", never "novice".
- Classes are always in kg.
- Stats on this screen use the Attrs names (the 14 abilities).
- The old seven (Power and the rest) appear only as the profile summary.

## 0. Every critic point, answered

**John SQ80, To reach 10/10:**

| # | Point | What v8 does (or why not, in one line) |
|---|---|---|
| J1 | Tank cap exploit | **Done (4.2).** The tank has two layers: tiredness over 50 is capped at 25, and choices subtract after it, uncapped. At start tiredness 75, Train through costs 25 + 12 = 37 off. |
| J2 | Eat less number; FLAT at 65+; Rest up timing | **Done (4.3, 4.5).** Eat less costs 4 off the tank (ESTIMATE). Rest up at 65+ reads "Sharp, no boost". Rest up brings tiredness to 30 before the bell. |
| J3 | Weight rule | **Done (4.5).** Club shows weigh in on bout day, 1 hour before, and match inside a gap table [R] EB 7.1.3 / 2.7.8. The class sets the slot and the ladder, not a cut line. Championships keep the class limit the day before. |
| J4 | Fall-through timing; cottage refund | **Done (6).** The pull-out roll fires on the Monday of fight week, 5 days out, before Saturday. The cottage gives no refund and is allowed only for championship rounds. |
| J5 | Plan test loop; which two lines; one-boxer club; late sparring price | **Done (4.4).** A changed line goes back to UNSPARRED, and the screen says so before the change. The player picks the two lines. A one-boxer club spars a club member. Sparring 5 or fewer days out costs 5 off the tank and ×2.5 injury. |
| J6 | Pick the boxer for a shared slot | **Done (2).** The slot defaults to the longer wait, with a Swap button. |
| J7 | Fundraiser and film edges | **Done (5).** The fundraiser is cut from this map; it belongs to Club > Money and changes no fight week. Film is locked on a debutant. A second film night either raises SEEN 70 to 90 or opens the next group. "Drops a level" now reads "cleared as false". |
| J8 | Pack changes listed; savings vs stipend; layout | **Done (11, 12).** Matchmaking lead time and Set camp are listed. Savings grow only while the stipend is Off. Back to the coach's week is gone. Controls are called magnets and pills. The WEEK BEFORE strip gets its own row. |

**Dola SQ79, To reach 10/10:**

| # | Point | What v8 does (or why not, in one line) |
|---|---|---|
| D1 | Run every probe; fall back to two stops | **Done (12).** No ESTIMATE prints before its probe. The two-stop fallback stays. |
| D2 | Build the missing systems first | **Done (12, step 2).** BoutSheet, RegionShows, the WeekPhase amateur branch, Savings, the Nationals next-year state, and the home-show weigh-in. |
| D3 | Ask for a fight panel | **Not in this map.** The panel is agreed and waits on bot test R37; the sheet keeps its space (2). |
| D4 | Plan readiness row | **Done (9).** One line at the top of ON FIGHT NIGHT: "n ready, n UNSPARRED". |
| D5 | Next-best hover | **Done (4.3).** Hovering a stop shows the next stop's price and what it buys. It never says "best". |
| D6 | Lock weight / lock load toggle | **Not taken.** Load and weight are already separate controls that don't move each other, so a lock adds a button with nothing to lock. |
| D7 | Season at a glance | **Done through what's built.** The Office desktop already shows the next four weeks; the header links to it. |
| D8 | Source the pull-out rate | **Done (6).** John sourced 25–50% [R]; 35 in 100 sits inside that range. |

**Dola's missing options:**
- **A search for a short-notice bout:** this is the fall-through card's "Take the replacement", since the host offers the name.
- **A rest window per bout:** the window is already per boxer, on that boxer's Fights tab.
- **A calendar several weeks ahead:** this is the Office desktop.

## 1. The idea

An amateur bout is booked 1 to 3 weeks out and has no camp. The FIGHT WEEK SCREEN covers the bout's last two weeks:
- **2+ weeks out:** a WEEK BEFORE strip (trip and sparring night) sits on its own row above the fight week.
- **1 week out:** fight week only.
- **3 weeks out:** week 1 is a normal BUILD week on the week board.

For an amateur bout the WEEK BEFORE strip replaces PEAK; that week runs as BUILD plus whatever the strip sets. The fight week replaces TAPER and is set by the load stop. This needs a WeekPhase amateur branch (NEW). CHECK (Claude): today WeekPhase gives PEAK to a 2-week amateur bout.

Every choice lands on ON FIGHT NIGHT, which has three rows: TONIGHT, BANKED and SEASON.

## 2. The bout sheet

**SLOTS BY CLASS:**
- A show offers 8 to 12 bouts as slots by sex and class.
- When two of the club's boxers share a kg class, the slot defaults to the one who has waited longer since their last bout.
- A **Swap** button gives the slot to the other boxer. That boxer's card says "this slot went to your other 65 kg boxer" (NEW).
- A sheet shows up to three cards. Slot test target: 2+ cards on average.

**PASS:**
- Passing a whole sheet is free.
- Refusing a card a club offered by name counts against that club; two refusals in 8 weeks lock that club out for 8 weeks.
- Each named card shows "refused n of 2".

**REMATCH:** when a boxer met before is on a sheet, the card is marked REMATCH and the tells found last time come back at SEEN.

**ASK FOR A NAMED OPPONENT:** agreed, and waits on R37. The sheet keeps space under the cards.

**LEAD TIME (NEW):**
- Amateur offers land 1 to 3 weeks out, not the pack's 8–12 weeks (Matchmaking change, listed in 12).
- Set camp never appears for amateur bouts.

**THE REST WINDOW:**
- Set on the boxer page's Fights tab: "next bout no sooner than 3 / 5 / 8 weeks", default 3.
- It replaces the fixed 21 days after a points bout.
- It can't be set shorter than the 30-day suspension or `Matchmaking.STOP_REST_WEEKS` (both GAME, both kept).

**RING RUST:** 6 weeks READY without a bout puts the boxer FLAT in round 1, counted from the end of any suspension.

**HOME AND AWAY:**
- **Home:** the $450 ticket cut, +8 members, +5 reputation (GAME).
- **Away:** a chance at a ranked place, plus the opponent's facts on file.
- The loss-below rule ("a loss to a name below drops two places") stays on the owner's board. Until a yes, an away loss costs only the record.

**THE NATIONALS:**
- Entry needs 5 bouts in the last 12 months and 3 months registered.
- Cards show "bouts to entry n of 5" and the entry week.
- In year 1, when week 10 can't be reached, the card says "next entry: week 10, next year".
- The sheet is closed during a run, with the reason.
- The next-year state is NEW.

**YOUR ASSISTANT PICKS THE BOUT:**
- A rank goal picks away; a money goal picks home.
- A rank goal under 4 wins is greyed: "no table under 4 wins".
- New FighterGoal types (NEW):
  - "Climb to top 3 by <date>"
  - "Bring $n to the club this season"
  - "Three bouts before the nationals"

**FAVOURS WITH A HOST (0 to 3):**
- Earned by filling a late gap.
- Spent on Ask for a kilo, or on a re-match after a miss.
- Test target: an average club sits at 1 to 2.

**PRO PACE:** 9 to 11 bouts a season at 61% wins (MEASURED) means about 1.4 seasons to 9 wins. This goes to the owner's board (13).

Part 2 of 3

## 4. The fight week screen

### 4.1 WHERE TO TRAIN (one trip per bout; the card says which week it uses)

Food for two costs $120 a week [R] John S449, and extras $50.

| Trip | Week | Cost | What it does (shown on TONIGHT) | Price beyond cash |
|---|---|---|---|---|
| Home gym | either | free | nothing extra | none |
| City club, commute with your assistant | week before **or** fight week | $150 + $120 food | a partner in the opponent's style: round-1 edge +1.0 against that style (ESTIMATE, about 1 to 1.5 in 100) | injury ×1.15 that week (ESTIMATE); assistant away by day, and the evening class still runs |
| City club, the boxer goes alone | week before **or** fight week | $150 + $60 food | half the edge (+0.5) | +1 tiredness a travel day (ESTIMATE); no coach away |
| Hill cottage | week before, **championship rounds only** (regional and national draws) | $745 off-season / $1,170 June to August [R] | the week before banks in full with no TrainingLoad entry, and fight week starts 10 tiredness lower | the coach is away all week; no refund once the stay starts |

- **Why the cottage is championship-only:** at $1,095 to $1,520 with the lost class, it costs 5 to 7 weeks of an early club's profit for a $450 bout. In a championship run a loss ends the run, so the price can be worth it there. CAMPPLACE1 checks this, and if the cottage is never best even there, it's cut.
- **Seaside house:** stays cut, because a free home Rest up week gives the same rest.
- **Partner choice:** not taken, because the opponent's file holds one style word.

**COACH AWAY (a red-edged card, shown only when the trip takes a coach):**
- **Assistant away a full week:** the other boxers train at the head coach's factor (the screen prints the real number) and the evening class stops (−$350, GAME). CHECK (Claude): the coach factor with only the head coach present.
- **Head coach away:** no head-coach edge, and no shouts at any other bout that week.

### 4.2 THE TANK (two layers, NEW, answers J1)

The tank is the energy ceiling at the first bell, and it's built from two layers.

| Layer | Parts | Cap |
|---|---|---|
| Tiredness | 1 off for each point of start tiredness over 50 | 25 |
| Choices (after the tiredness layer, uncapped) | load stop (Tick over 6, Train through 12), each fight-week sparring night (3, or 5 when 5 or fewer days out), Eat less 4 | none |

**Worked at start tiredness 75 (25 over 50):**

| Choice | Tank at the bell |
|---|---|
| Rest up | tiredness to 30 before the bell, so 0 off |
| Tick over | 25 + 6 = 31 off |
| Train through | 25 + 12 = 37 off |
| Train through + two late sparring nights | 25 + 12 + 10 = 47 off |

A tired boxer pays every point of every choice.

**On screen:** the tank bar shows the tiredness layer in grey and the choices stacked in colour after it, each with its price in wins in 100 on hover. Every number in the table above is an ESTIMATE until FIGHTWEEKPROBE4 runs.

### 4.3 THE WEEK'S LOAD (three stops, each best in a state you can read)

| Stop | The week | Tank (choice layer) | Round 1 | Banked | After the bell | Best when (printed on the stop) |
|---|---|---|---|---|---|---|
| Rest up | three rest days | 0; tiredness brought to 30 **before the bell** | under 40 start tiredness: FLAT, −2.0 edge; 40 to 64: FLAT, −1.0; **65+: Sharp, no boost** (ESTIMATE) | a fifth of the week's pad units | nothing extra | start tiredness 65+, or a heavy cut |
| Tick over (default) | one rest day, volume halved [R] John S449 | 6 off | Sharp; ONE chosen plan line fires one level up in rounds 1 and 2 | half the pad units | nothing extra | most weeks under 65 |
| Train through | full week | 12 off | Sharp | the full week's pad units (720 for 3 pad nights, GAME units) on the plan's moves | +6 tiredness; the week enters TrainingLoad's ratio (1.5× spike: injury ×2–4, GAME) | a plan move sits within one week of Usable or Sharp, or the opponent is rated 5+ below |

- **The Tick over line picker** offers only lines at Usable or Sharp.
- **Train through banks mastery** and prints the crossing it buys ("Uppercut 27 to 31: Usable by the bell"). With FireLevel ON (GAME, S450), a move that crosses to Usable fires 1 use in 2 that night.
- **BANKED** shows the Attrs number and the move, never a range ("Strength +0.4": ESTIMATE until the probe).
- **Next-stop hover (D5):** hovering a stop shows the next stop's tank, round-1 and banked lines side by side ("Train through instead: 6 more off, Uppercut reaches Usable, +6 tiredness after"). It names prices, never "best".

### 4.4 SPARRING: the night that gets a plan ready

**THE RULE:**
- A plan line written or changed since the boxer last sparred is UNSPARRED and fires one level down in rounds 1 and 2. Usable drops to Raw, which doesn't fire.
- Before any change after a sparring night, the screen says so: "changing this line makes it UNSPARRED until the next sparring night" (answers J5).

**WHAT A NIGHT DOES:**
- It readies lines and runs a PLAN TEST against a partner of the nearest style.
- The test rates each line (Beats it / Works / Walks into it) before the bell.
- If the player changes a line after the test, that line is UNSPARRED again; a second night readies it, at that night's price.
- Sparring never confirms tells; only the fight does.

**WHICH LINES:**
- An early night readies two lines, which the player picks.
- The default is the first two UNSPARRED lines in plan order.

**ONE-BOXER CLUB (NEW):**
- With no second boxer in the right weight (the first weeks before the second walk-in), the partner is a club member.
- The plan test then rates only "Works / Walks into it", and Beats it shows as "?".
- The night still readies lines.

| Night (0, 1 or 2 placed as magnets) | Price | Readies |
|---|---|---|
| Week before (8+ days out) | one pad night's mastery | two lines |
| Fight week, 7 or 6 days out | 3 off the tank | two lines |
| Fight week, 5 or fewer days out | **5 off the tank, ×2.5 training injury, a cut that ends the bout 3 in 100** (ESTIMATE; NEW, overrides the pack's no-sparring TAPER on purpose and prices it [R] Buglioni, Boxing News 2016) | every line |

**When each choice is right:**
- **No night:** the plan is unchanged since the last sparring.
- **Week before:** there's time.
- **Late night:** the player rewrote the plan after the tape and accepts the risk.

**Your assistant's default:** a week-before night when one exists, else a 7-day night if the choice layer stays under 12, else none.

Sparring test target: worth 2 to 5 wins in 100 when the plan is new (ESTIMATE).

### 4.5 THE WEIGHT (one rule, answers J3)

**AT CLUB SHOWS (every amateur bout outside a championship), NEW, [R] EB 2026 rules 7.1.3 and 2.7.8:**
- The weigh-in is on bout day, 1 hour before boxing. This needs a home-show branch in `Bouts.weigh`, which runs the day before today. CHECK (Claude).
- The two boxers are matched at walking weight within this gap:

| Bout | Gap allowed |
|---|---|
| Classes up to 65 kg (women's 57 / 60 / 65, men's 57.5 / 60) | 2.5 kg |
| Classes above 65 kg (women's 75, men's 70 / 75) | 5 kg |
| Skills bout | 2 kg |

- The gap never reads the game's 10 kg class jumps.
- **The class decides the slot and the ladder table only.** Boxing down a class is a choice to enter that class's table and slots, and the cut is how to get there. A walk-in 2 to 4 kg over the lightest class chooses "box at 60 kg in 3 weeks, or at 65 kg now".

**WAYS TO MAKE THE MATCH:**
- **EAT LESS** (Cut 500 kcal, GAME): 4 off the tank (ESTIMATE).
- **TRAIN IT OFF:** 0.3 kg for +8 tiredness. It beats Eat less only when start tiredness is under about 42 (DERIVED by John).
- **ASK FOR A KILO:** −1 favour with the host, only when the boxer is within 1 kg of the gap's edge. Greyed with the reason otherwise.

**A MISS (outside the gap on the day):**
- The host re-matches on the night if it has a fitting spare, 1 in 3 (ESTIMATE).
- Otherwise the bout is off, the club pays $300, and the host takes 1 favour.
- The $300 is a GAME value, not a rule-book fine.

**CHAMPIONSHIPS (regional and national draws):** the class limit, the day before, as today (GAME). No kilo is asked and no favour is spent.

### 4.6 WHO PAYS

**Savings (NEW):**
- Savings come from the boxer's own job: $25 to $75 a week by background, shown at signing.
- They grow only while the stipend is **Off** on Club > Money. With the stipend On, savings stay where they are (answers J8).

| Payer | Club's cash | Mood (ESTIMATE) | Gate |
|---|---|---|---|
| The club | full | +3; −2 with each other boxer when the club paid for this one more often in the last 8 weeks | none |
| Half each | half | +3 on a win, 0 on a loss | savings cover half |
| The boxer | none | +6 on a win, −6 on a loss; savings under $100 after paying make the boxer SKINT, −2 a week until savings refill | Confidence 55+ and savings cover it; otherwise greyed with the reason |

At 61% wins (MEASURED) that comes to:
- The boxer row: about +1.3 mood.
- Half each: about +1.8.
- The club: +3, less the fairness cost.

BudgetProbe cuts any row that is never best for some boxer.

### 4.7 YOUR ASSISTANT'S PICK

- The pick reads five facts: start tiredness, the weight's tank cost, the opponent's round-1 style, the rating gap, and unsparred lines. It names the one fact that drove it.
- It's wrong at (1 − sureness), where sureness = 0.5 + rating / 200 (Luke Reid 0.79, Marcus Hale 0.87; GAME ratings). When wrong, it takes the next stop and still gives its reason.
- The card says "your assistant" beside the portrait and names no one.

### 4.8 SEASON, the price line

- SEASON shows each stop's measured season cost against Tick over, for the boxer's start-tiredness band only ("Rest up here: −1 to +2 in 100").
- The rating gap, the weight, unsparred lines and moves near a tier stay out of the line, so SEASON never prints the answer.
- The numbers print only from FIGHTWEEKPROBE4.

Part 3 of 3

## 5. The film evening

**What a night does:**
- A film night costs one pad night and opens one tell group.
- A tell is checked at the first corner minute where the opponent's mode matched it.
- A fade or a slow start is checked at the round-2 minute, because amateur bouts have minutes only after rounds 1 and 2.

**LOCKED ON A DEBUTANT (NEW):** when the opponent has no bouts, the film magnet is greyed: "no tape on a debutant" (GAME: no bouts means no tape).

**TRUTH:** a SEEN tell is true 70 in 100 (ESTIMATE). A tell whose mode came up and didn't show is **cleared as false**. A tell whose moment never came stays SEEN.

**THE SECOND FILM NIGHT is a choice (NEW):**
- **Look again:** raises one group's SEEN tells from 70 to 90 in 100.
- **Next group:** opens the next tell group at 70.

The choice is right one way or the other depending on how many lines rely on one tell.

**The fundraiser** is cut from this map. It changes no fight week, and if kept it belongs to Club > Money (J7).

## 6. Things that happen

**THE PULL-OUT ROLL (answers J4):**
- It fires on the **Monday of fight week, 5 days out**, and stops the clock once, as one need on Home.
- Own-bout fall-through is 35 in 100 per bout. That's inside John's sourced 25–50% for the final week ([R] Northants Telegraph 2025; Sussex Express 2015).

**The fall-through card has three answers:**
- **Take the replacement:** the host's name, at short notice (GAME: a tougher name, double reputation on a win).
- **Go home:** tiredness carries as under Rest up; mood −6.
- **Ask the host for next month's slot:** −1 favour, booked.

**What stays and what's lost:**
- A banked week always stays.
- A commute that already happened refunds nothing.
- The cottage is only used in championship rounds, where a draw doesn't fall through, so it has no refund rule.

**Late replacement asks:** a host asks at most once per show, only when the boxer fits the gap and is READY, about 1 ask in 6 shows (ESTIMATE). These land with Monday's need.

**At most one stop per boxer per bout.**

## 7–8. What each option changes (summary)

| Option | Changes |
|---|---|
| Swap slot | which of two same-class boxers gets the slot |
| Pass sheet / refuse named card | nothing / that club's count toward its lockout |
| Rest window 3 / 5 / 8 weeks | when the next sheet comes; ring rust |
| Trip | round-1 edge, injury, cash, the coach at home, tiredness |
| Load stop | tank, round 1, banked mastery, tiredness after |
| Sparring nights | ready lines and a plan test, against tank, injury and cut risk |
| Eat less / Train it off / Ask a kilo | the weight margin, against 4 tank / +8 tiredness / 1 favour |
| Who pays | club cash, boxer savings, mood, fairness |
| Film night / look again / next group | which tells you know and how sure you are |
| Fall-through answers | the bout tonight, mood, a favour |
| Use the pick | the assistant's settings, with the reason |

## 9. ON FIGHT NIGHT (the one gold frame)

**PLAN READINESS (top line, D4):** "n ready, n UNSPARRED, n SEEN tells" in marker. Clicking it highlights those lines.

**TONIGHT:**
- The two-layer tank: tiredness grey, choices coloured, each with its price in wins in 100 on hover.
- Round 1: Sharp, Sharp (no boost) or FLAT.
- Each plan line's fire share, tagged READY, UNSPARRED, SEEN 70 / 90 or CONFIRMED.
- The scale margin against the gap.
- The win band.

**BANKED:** the Attrs points, the moves crossing a tier by the bell, and tiredness after the bell.

**SEASON:** this stop against Tick over in this tiredness band, as a range.

Each row shows its change from your assistant's pick, and hovering any number shows its parts. There is no PEAK CAMP row and no "gains ×".

## 10. Menus: every place the mechanic appears

| Menu | What it shows / lets you do | Wired to |
|---|---|---|
| Home (needs) | one need for an open sheet; one Monday-of-fight-week need for the pull-out roll and asks | Needs, BoutSheet, Clock |
| Office desktop | the sheet and bout dates for the next four weeks (D7) | Desktop (built), BoutSheet |
| Fights rail page | each boxer's sheet: up to 3 cards, PASS, "refused n of 2", Swap on a shared slot | BoutSheet, RegionShows |
| Bout card / versus screen | slot reason, REMATCH, "bouts to entry n of 5" / next entry, home or away trade, win band, the weight gap | BoutSheet, Nationals, OppFile, WeighGap (NEW) |
| Boxer page, Fights tab | rest window 3 / 5 / 8; your assistant picks the bout (goal read, greyed reason) | Matchmaking, FighterGoal |
| Fight week screen | WEEK BEFORE strip row; seven day columns of magnets (sparring red, film tape); LOAD three-stop pill; WEIGHT pills; trip cards; COACH AWAY card; who pays; the pick; ON FIGHT NIGHT | FightWeek, CampPlace, TrainingLoad, WeekPhase (amateur branch), PadWeek, Savings, WeighGap |
| Week board | the BUILD week of a 3-week bout; the strip's settings read-only | WeekPlan, WeekPhase |
| Playbook, Game plan | UNSPARRED tag and the warning before a change; plan test ratings ("?" with a club member) | Playbook, StrikeMap, FireLevel |
| Tape room | film nights, SEEN 70 / 90, cleared as false, debutant lock | OppFile, TapeRoom |
| Corner minute (rounds 1 and 2) | CONFIRMED / Not seen; fade check at round 2 | FightNight, OppFile |
| Fight night: weigh-in | bout-day scale 1 hour before at club shows; class limit the day before at championships | Bouts.weigh (home-show branch, NEW), WeighIn |
| Result page / Why | lines that fired a level down because unsparred, named in AGAINST YOU | Why |
| Roster boxer card | savings a week (stipend Off only); SKINT flag | Savings, Recruit |
| Goals (boxer page) | the three new goal types | FighterGoal |
| Money | trips by payer; commute and cottage costs; stipend Off/On and savings | GymBills, Savings |
| Championships | rolling entry count, next entry week, cottage allowed | Nationals |
| Continue button | stops once on the Monday of fight week for the roll and asks | Clock |

## 11. Pack changes this map makes (answers J8)

- **Matchmaking:** amateur offer lead goes from 8–12 weeks to 1–3 weeks. Set camp is never raised for amateur bouts.
- **WeekPhase:** an amateur branch. WEEK BEFORE replaces PEAK; the fight week's load stop replaces the fixed TAPER.
- **Bouts.weigh:** bout-day weigh-in and a gap match for club shows. Championships unchanged.
- **The 21-day rest after a points bout** becomes the rest window (3 / 5 / 8). Suspension and STOP_REST_WEEKS are unchanged.
- **TAPER's no-sparring rule** is overridden for late sparring at a stated price.
- **Savings** are a new value tied to the stipend toggle.

## 12. Build order

1. **Probes (no ESTIMATE prints before its probe, D1):**
   - **FIGHTWEEKPROBE4:** by state. Each stop best in at least 1 fight week in 5 per tiredness band; best-to-worst gap 3 to 8 in 100.
   - **Assistant probe:** a reader beats the pick by 2+ in 100 a season. If pick-to-best is under 1 in 100, load folds to two stops (Tick over / Rest up) under "Change the load".
   - **CAMPPLACE1:** each trip per use against a home Rest up week, target 1 to 4 in 100. The cottage must be best in at least one championship state, or it's cut.
   - **BudgetProbe:** each payer row best for some boxer.
   - **Tank test:** at start tiredness 75, Train through plus a late night costs at least 4 in 100 more than Tick over.
   - Favour test (1 to 2); slot test (2+ cards); sparring test (2 to 5 in 100 for a new plan); film test (look again vs next group each best in some state).
2. **Systems first (D2):** BoutSheet, RegionShows, the WeekPhase amateur branch, Savings, the Nationals next-year state, the Bouts.weigh home-show branch, WeighGap.
3. **The fight week screen,** from a redrawn Look B mockup of this screen. Seaside, PEAK CAMP, gains-× and the dark style are dropped.
4. **The rest window, Swap, REMATCH, the Monday pull-out card.**
5. **Tell truth, look again / next group, the debutant lock.**

**The screen at 1920×1080 (Look B):** the dark shell (top bar and left rail) around a whiteboard.
- **Header (96 px):** both portraits with the names once, the class in kg, records, days to the bell, home or away, favours with the host, and the margin against the gap now and on the day. A link opens the next four weeks on the Office desktop.
- **WEEK BEFORE strip (84 px, own row, only 2+ weeks out):** the trip pill and the week-before sparring magnet.
- **Left (440 px):** trip cards (cost, week, tonight's number); the COACH AWAY card (only when a coach leaves); the payer row (savings, Confidence gate, SKINT).
- **Centre (920 px):** seven day columns of magnets (sparring red, film tape); the LOAD three-stop pill with the line picker and next-stop hover; the WEIGHT pills (Eat less, Train it off, Ask a kilo with its favour); plan line chips.
- **Right (560 px):** ON FIGHT NIGHT in the one gold frame, with the readiness line on top.
- **Bottom (120 px):** your assistant's note, **Use the pick**, and the red **Lock the week**. Green is used only for Continue.

## 13. Open for the owner

- **Pro road:** "9 wins with 3 over ranked names" or keep "9 wins at any rank"; the pace is about 1.4 seasons.
- **Loss to a name below:** drops two places, yes or no.
- **Savings from the boxer's job** ($25 to $75 a week, stipend Off): yes or no.
- **Rest window replacing the fixed 21 days:** yes or no.
- **Tick over at one rest day** instead of today's three-day TAPER: yes or no.
- **Club-show weigh-in on bout day within a gap** (EB rules) instead of the class limit the day before: yes or no.
- **Cottage for championship rounds only:** yes, or cut.

**CHECKs:**
- **Claude:** the WeekPhase amateur branch; the coach factor with only the head coach; the home-show branch in Bouts.weigh.
- **John:** whether a host may re-match a missed boxer on the night under EB rules, and how often.

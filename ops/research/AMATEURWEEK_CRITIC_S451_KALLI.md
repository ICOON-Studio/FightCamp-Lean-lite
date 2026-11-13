# AMATEURWEEK_CRITIC_S451_KALLI - Kalli answer (seat queue SQ64)

Brief: research/AMATEURWEEK_CRITIC_S451_BRIEF.md
Sent: 2026-11-13 15:34 | collected: 2026-11-13 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring THE AMATEUR FIGHT WEEK, the v5 map, on this brief alone. First I'm checking whether camp plan v3 is on my computer.

Part 1 of 3

# THE AMATEUR FIGHT WEEK, v5: critic (S451, Kalli)

Judged on this map, the pack with its S451 additions, and `docs/mockups/s449/camp_v3/camp_plan_v3.png`, which I opened with the file tool. I didn't open the Miro board, the real screens or the probe result docs; the probe numbers are judged as the map quotes them.

**Verdict:** Depth 6/10, Play 6/10.

What now works:
- Home and away are a real trade: only away climbs, and a loss to a name below costs two places.
- The kilo, favours and who pays now each move something.
- FIGHTWEEKPROBE3 gives the box a real season line for Rest up.

What still breaks it:
- The probe shows Train through is free today. The map's fix aims for Train through to sit 2 to 4 behind the pick, and Rest up is already 6 behind. That leaves Tick over (the default) as the stop that's always right.
- The two trips with the biggest effects can only be taken in the week before the fight week, so their "fight week" effects land on a normal week.
- All sparring on the fight week screen is late sparring by definition.
- The mockup is a 21-day camp screen, not this week.

## 1. Logic check

**1. Tick over becomes the stop that's always right.** By 4b, always Tick over sits at -0.2 against the pick, Rest up at -6.1, and Train through at +1.2 (inside its ±1.6). The build target moves Train through to 2 to 4 behind. Then no state makes Rest up or Train through right, and "Use the pick" is the same click every week. The probe reports averages over a season, not which stop wins in which state (high carried tiredness, an opponent below, a long gap to the next bout).

**2. The BANKED row's size doesn't match 4b.** 4b says a full week against a fifth is "about 3 stat points a season" over about 5.5 bouts, so about 0.5 a fight week. The map then has the row show "+1 to +2 stat points this week". That's two to four times too big.

**3. "Roughly double" is a guess.** Season gaps with 9 to 11 bouts are said to "roughly double". That isn't measured, and 4b is the map's own price list. The re-run on BoutSheet has to come before the box prints a season line.

**4. Trips land on the wrong week.**
- The hill cottage and the seaside house only open for a bout 2 or more weeks out: "the week away, then the fight week home". So the trip week is the normal BUILD week, which already banks in full. "Banks in FULL at Tick over's tank cost" buys nothing there, and the seaside's "banks half" makes that week worse than staying home.
- Only "clears 6 tiredness" and "mood +5 / tiredness to 30 at most" reach fight night, and only if they carry through the fight week.
- The map needs to say what carries over and show it on TONIGHT, or the two trips are dominated by staying home.

**5. Fight-week sparring is always late.** The fight week screen is the last 7 days, and "late sparring" is inside 7 days. So every sparring night on this screen carries x1.5 injury and 3 off the tank. "Week-1 sparring is free on a 2-week bout" sits on the normal week board, not this screen's slider. The slider's 1 and 2 are only right when a plan test is worth more than the tank and injury price, which the map never measures. The pack's TAPER (no sparring) and the assistant's default ("1 sparring night if 2+ weeks out") also need saying which week that night is in.

**6. "+1 plan line ready" isn't a rule.** With FireLevel on, every line fires at its level's share. "One more line at its level" doesn't say which line or what changes. Write it as a number: one chosen line runs at the next level's share in round 1.

**7. The film confirm punishes tells that can't show yet.** "Starts slow or fades" maps onto weakness, and a fade can't show in round 1. A SEEN tell that's real but hasn't been triggered yet would be marked "not seen" at the first corner minute and dropped a level, so the rule punishes being right. The same goes for any habit tied to an opponent mode that didn't come up in round 1 (Loading up, Tiring).

**8. Shows have fewer slots than three cards need.** A show has 8 to 12 bouts across the weights, and women never fight men, so it's spread over 8 classes. That's about one bout per class per show. Two or three shows a fortnight give a boxer one or two fitting cards, rarely three. Two of the club's boxers in one class compete for the same slot, and the map doesn't say who gets it.

**9. Ring rust after every stoppage.** The 30-day suspension, then a sheet 1 to 3 weeks out, puts the next bout 5 to 7 weeks after the last. Most stoppage losses then trigger "6 weeks without a bout = FLAT in round 1" on top of the suspension. If that's not meant, count ring rust from the suspension's end.

**10. Two decided numbers, only one on the owner's board.** The pro road change goes to the owner. "A loss to a name below drops two places" changes the pack's rank rule (a loss moves no place) and is listed as a "new rule" without the same flag. Both go to the owner's board.

**11. Pass isn't defined.** Taking one card closes the others, so leaving two cards isn't a pass. "Two passes on one club's cards" needs a definition: declining the whole sheet, or declining a card from that club while taking another club's.

**12. Ask for a kilo against the category width.** Moving the agreed weight 1 kg can push the gap past the smaller boxer's width (rule 2.7.8). The kilo must stay inside the gap, or the option is greyed with the reason. CHECK (John).

**13. "Novice" means two things.** Here it means under 4 wins. In the pack's matchmaking it means 0 to 10 bouts (the unsafe-mismatch rule). One word per concept: call this one "unranked" or "under 4 wins".

**14. Shares in the old words.** "Technique, Strength, Stamina": Technique is now a summary read from the abilities (S448), not something a morning trains. Name what the sessions really move, for example Strength, Stamina and Accuracy or Timing. CHECK (Claude): which abilities the morning sessions feed now.

**15. The city commute's southpaw effect is narrow.** It only matters for an orthodox boxer facing a southpaw for the first time. On every other card, its only effect is +1 plan test a night, at x1.3 injury. Show the trip's stance line only when the opponent is a southpaw.

**16. The mockup isn't this screen.**
- `camp_plan_v3.png` is a 21-day camp ("Regional final, 21 days out, Build, Peak, Fight week"). It has the CITY CLUB TRIP stay-over the map cuts, and prices of $875, $400 and $1,000 against the map's $575 to $1,150, $150 and $590.
- Its buffs are the ones the map rejects: Cardio gains x1.25, Legs gains x1.2, recovery +15%.
- It uses the words Cardio, Power and Legs, and "bond +" and "your coaches' fit", from an unagreed system.
- It labels the pick "YOUR COACH" and "Coach's pick", not your assistant.
- There's no BANKED or SEASON half, no stacked tank, no Rest up / Tick over / Train through, and no who-pays row tied to the stipend.
- It's drawn dark, not in the whiteboard style (Look B).

**17. Names.** The map keeps names in headers only, and its corner, free-fact and pick lines use roles. The mockup's header ("LUCY JACKSON vs PRIYA NAIR") is the allowed place. No breach found in the map. The redraw must keep "your assistant" under the pick portrait.

Part 2 of 3

## 2. Depth: 6/10

I went through each choice over a season with four boxers, using 4b.

**Which bout, home or away:** real now.
- Home pays $450 and +8 members, but it can't climb, and a loss to a name below costs two places.
- Away climbs and gives facts and favours, with no cut.
- A boxer near the top 3 goes away. A cash-tight club goes home.

The trade depends on the show calendar giving both kinds of card (logic 8). Without the owner's yes on the pro road, a home-only boxer still turns pro at 9 wins, so the away pull is weaker for the second half of a career.

**Unranked boxers:** small but fine. Home pays, and away earns a favour.

**Where to train:** two of four trips do almost nothing (logic 4). The commute is the only one used week to week, and mostly for its plan test.

**Load:** after the fix, Tick over is always right (logic 1). Today Train through is always right. Neither is a decision. Here's where each stop could be right:
- Rest up: when carried tiredness is high, because each point over 50 costs a tank point.
- Train through: against an opponent well below, with a long gap to the next bout.

The map doesn't build or measure those states.

**Sparring:** usually 0 on this screen (logic 5).

**Weight:** real now. Eat less up to 10 off, stacked with load, reaches the steep part of the curve. The kilo saves exactly that for one favour.

**Film:** real and buildable now that FireLevel is on, but the confirm rule needs fixing (logic 7).

**Who pays:**
- Club pays: +3 mood whatever happens.
- Half each: less mood for half the cash.
- The boxer pays: +4 on a win, -5 on a loss, a bet worth taking above about 56% to win.

That's a real money-against-mood trade when cash is tight, and a no-brainer (club) when it isn't. Acceptable.

**Favours:** real now. The 0-lock costs ranked names for 4 weeks, and the host's call-in makes the count move.

**A chore by the tenth bout?**
- About 40 bouts and 10 fall-throughs a season across four boxers.
- "Your assistant runs this week" takes most fight weeks in one click.
- If Tick over is always right, nearly every week will be.
- The sheet stays a real choice each time, which keeps the tab alive.

## 3. Play: 6/10

**It pulls me on:**
- Three versus cards every few weeks per boxer.
- "Ranked wins 2 of 3".
- The kilo and favour game with rival clubs.
- A host calling in a favour.
- "two weeks: Uppercut Usable" now that FireLevel makes it worth something.
- CONFIRMED in the first corner minute.

**What holds it at 6:**
- The fight week itself settles into the default.
- The two picture trips don't change fight night.
- The sparring slider is a trap.
- The screen the owner will see (the mockup) shows the old camp, not this.

## 4. Options

**Missing:**
- **A state line on the load stops,** saying when each one is best ("tiredness 58: Rest up clears it to 30").
- **"Last sparring: n days out"** across the last two weeks, instead of a count of fight-week nights.
- **Slot sharing** when two of the club's boxers fit one slot at a show.
- **What a trip carries into the fight week,** on the TONIGHT half.
- **A defined Pass,** and its counter per club on the bout card.
- **Ring rust's start date** after a suspension.

**Useless as written:**
- The hill cottage's "banks in full" and the seaside's "banks half" (they land on a normal week).
- Fight-week sparring 1 and 2 for most boxers.
- "+1 plan line ready" until it's a number.
- The commute's stance line against an orthodox opponent.

**The menus:**

| Menu | Right place? | Found? | Can't act on or wrong |
|---|---|---|---|
| Boxer page, Fights tab | Yes | Yes | Three cards rarely fill (logic 8); two boxers in one class share a slot with no rule |
| Fights rail page | Yes | Yes | Nothing |
| Bout card | Yes | Yes | The kilo must stay inside the width (logic 12); the Pass counter is undefined |
| Fight week screen | Yes | From the card | Trip effects land on the wrong week; the sparring slider is always late; Tick over is always right; the BANKED size is overstated |
| Week board (Training) | Yes | Yes | Say which week the default sparring night sits in |
| Office desktop | Yes (S451) | Yes | Nothing |
| Home | Yes | Yes | Nothing |
| Boxer card (Roster) | Yes | Yes | Nothing |
| Tape room | Yes | Yes | Nothing |
| Playbook | Yes | Yes | A SEEN line at 90% is fine; the confirm rule needs fixing |
| Region / club list | Yes | Hard | Fine |
| Continue | Yes | Yes | Nothing |
| Fight night | Yes | Yes | The bout-day weigh-in is new; fine |
| Corner minute (round 1) | Yes | Yes | It can't confirm a fade or a mode that didn't show (logic 7) |
| Result page | Yes | Yes | Fine |
| Money | Yes | Yes | Away bouts at $0 cut income against today; needs BudgetProbe |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Make each load stop best in a state, and measure it by state.**
   - Rest up: clears carried tiredness to 30, and its flat round 1 only applies when tiredness at the start of the week is under 40. A tired boxer's rest isn't "too much".
   - Train through: right when the opponent's rating is 5 or more below and the next sheet is 4 or more weeks away (the banked week counts more when no fight week follows).
   - Re-run FIGHTWEEKPROBE3 with the load-ratio cost and x1.5 late sparring, on BoutSheet with the show calendar. Have it report, for each state, which stop wins.
   - Build target: each of the three stops is the pick in at least 1 fight week in 5. Always taking one stop costs 2 to 6 in 100.
2. **Fix the BANKED row** to its measured size (about 0.5 a fight week between full and a fifth) and let the SEASON line carry the weight. Print the season line only from the re-run.
3. **Make trips act on the fight week.**
   - A trip in the week before carries into the fight week:
     - The hill cottage: start the fight week at tiredness -6, and the fight week's Tick over costs 3 off, not 6.
     - The seaside: tiredness 30 at most and mood +5 at the bell.
   - Drop the "banks" lines for both.
   - The commute stays a fight-week option, showing its stance line only against a southpaw.
   - Each trip shows its TONIGHT number. CAMPPLACE1 measures each trip per use, not per season.
4. **Replace the sparring count with "last sparring: 9, 7, 5 or 3 days out"** across the last two weeks.
   - 9 is free.
   - 7 costs 3 off the tank.
   - 5 and 3 each add 3 off and x1.5 training injury.
   - Every choice gives the same plan tests. Now the price is when, not how many, and each stop is right somewhere.
5. **Fix the film confirm.**
   - A group is checked at the first corner minute where the opponent's mode matched it. A fade is checked at the round-2 or round-3 minute.
   - A tell that hasn't had its chance stays SEEN, with no drop.
   - Only a tell whose mode came up and didn't show drops a level.
6. **Give shows slots by class.**
   - Each show offers slots by sex and class, from its 8 to 12 bouts.
   - Two of the club's boxers in one class: one card goes to whichever has more days since their last bout, and the other card says why it's missing.
   - Measure that the sheet averages two or more cards.
7. **Put both decided-number changes on the owner's board:** the pro road (9 wins with 3 over ranked names), and a loss to a name below costing two places. Build neither without his yes.
8. **Define Pass** (declining the whole sheet), with a per-club count on each card ("passed 1 of 2"). Start ring rust's 6 weeks at the suspension's end.
9. **Tick over's line, as a number:** one plan line, picked on the screen, runs at the next level's fire share in round 1.
10. **Cap the kilo** at the smaller boxer's category width. Greyed with the reason when it would cross. CHECK (John): the 2026 widths against the game's classes.
11. **Words:** "under 4 wins", not novice; shares named after the abilities the sessions really feed. CHECK (Claude).
12. **Redraw the mockup** for this one-week screen:
    - the three load stops
    - the stacked tank
    - BANKED and SEASON
    - the map's trip list and prices
    - the assistant's face labelled "your assistant"
    - no Cardio, Power, Legs, bond or fit
    - the whiteboard style
13. **Probe order:**
    - the FIGHTWEEKPROBE3 re-run (by state, BoutSheet)
    - CAMPPLACE1 (per use)
    - BudgetProbe (with away at $0)
    - the favour test
    - the slot test (cards per sheet)

These need things the game can't do yet: BoutSheet, RegionShows with slots, Favours, Savings, CampPlace, the bout-day weigh-in, TellConfirm.

### The 10/10 fight-week screen at 1920×1080

The shell stays: dark top bar, left rail. The content is the whiteboard. The boxer's name and the opponent's appear once, in the header.

- **Header** (full width, about 110 px): both comic portraits, the names, class and record, days to the bell, home or away with the club's favours, the agreed weight against walking weight, and ranked wins against the pro road.
- **Where to train** (left, about 560 x 420 px): polaroid cards for home, commute, cottage and seaside. Each shows its cost, its injury factor, and ONE TONIGHT number ("tiredness -6 at the bell"). A locked card says why ("bout 1 week out").
- **How hard** (centre, about 760 x 420 px): three picture rows.
  - **Load:** Rest up, Tick over, Train through, each with tank and banked numbers and a state line ("tiredness 58: Rest up clears to 30").
  - **Last sparring:** 9, 7, 5, 3 days out.
  - **Weight:** only when outside the gap, with Ask for a kilo and its favour cost.

  Under them, the stacked tank bar with its price in wins, marker-red past 12 off.
- **ON FIGHT NIGHT** (right, about 560 x 760 px, the one gold frame):
  - TONIGHT: tank, sharp or flat, the chosen line at its level, the scale margin, the win band.
  - BANKED: stat points at their true size, the move crossing a line, tiredness carried.
  - SEASON: the measured line for this stop.

  Each row shows its change from your assistant's week.
- **Film and the file** (left, under the trips, about 560 x 300 px): the five groups SEEN / CONFIRMED / UNKNOWN, with which round can check each one. Film on one of the boxer's own pad nights. Greyed for a debutant.
- **Who pays and your assistant's pick** (centre, under the sliders, about 760 x 300 px): Club, Half each, Boxer, with cash and mood (the boxer options greyed with the stipend reason). The pinned note from your assistant, with a one-line reason, sureness, and Use the pick.
- **Season strip** (full width, bottom, about 110 px): home and away so far, money, places climbed, bouts of 11, favours by club, the next sheet's date, and Continue's next stop.

There's no score and no best-week badge. Hovering any number shows its rule.

CHECK (Claude): which abilities the morning sessions feed; whether a stoppage's 30 days and STOP_REST_WEEKS both run for amateurs today.
CHECK (John): the 2026 category widths against the kilo ask; a club's ticket share at a board show.

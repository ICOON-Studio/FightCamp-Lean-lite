# AMATEURWEEK_CRITIC_S455_BRIEF_KALLI - Kalli answer (seat queue SQ71)

Brief: research/AMATEURWEEK_CRITIC_S455_BRIEF.md
Sent: 2026-11-13 18:40 | collected: 2026-11-13 19:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring the amateur fight week now. First I'm opening the camp plan v3 mockup to check it against the map.

Part 1 of 3

# THE AMATEUR FIGHT WEEK: critic (S455, Kalli)

Judged on PART A over PART B, the pack, and `docs/mockups/s449/camp_v3/camp_plan_v3.png`, which I opened with the file tool. I didn't open the Miro board, the real screens or the code.

**Verdict:** Depth 5/10, Play 6/10.

The bout sheet is the best part:
- Home against away (money against places).
- Slots by sex and class, so females never meet males by construction.
- Favours, and a pass that only counts when pressed.

Choosing between three cards is a real weekly question.

The fight week under it is mostly solved:
- The SEASON line tells the player which stop is best.
- Rest up wins whenever the boxer starts tired.
- Sparring 9 days out is free.
- Club pays wins the mood column.

On top of that, the assistant probe's target can't be reached, so by the map's own rule the load slider gets cut.

## 1. Logic check

**1. The SEASON line gives the answer away.** It "compares each stop with the best stop for this boxer this week". The stop showing "0" is the right one, so the player stops reading and picks it, and the load choice is gone. The same line is the probe's own measure: a player who reads the box always matches the best stop.

**2. Rest up wins from 40 tiredness up, not 65.** From 40 up, Rest up is sharp in round 1 with a full tank, and it carries tiredness down to 30.
- Tick over is 6 off (inside the noise, by 4b) plus one line one level up in round 1 only.
- At 50+, every point over 50 adds to Tick over's tank, and Rest up clears it.

Rest up is therefore right in every week starting at 40+, which after a bout and a normal week is most weeks. FIGHTWEEKPROBE3's Rest up cost came from the FLAT round, which v6 removes for exactly these boxers.

**3. Train through's "best when" almost never happens.** "The next sheet is 4+ weeks away", but the next sheet comes 21 days after a points bout. Only a stoppage loss, a pass or the nationals make it 4+ weeks.

**4. The order of the tank cap rewards being tired.** Parts stack tiredness first and weight last, then stop at 25. A boxer already at 20 off from tiredness and load pays only 5 of a 10-off cut. The more worn out the boxer, the cheaper the weight. The overflow should fall on the part the player can't choose, or the cap should go.

**5. Sparring can't confirm a tell.** PART B section 5 defines CONFIRMED as the opponent showing the tell in the fight, which a club partner can't do.
- A line not built on a tell already fires at its full share, so "confirms one line" adds nothing to it.
- On a SEEN line it adds only the 10% gap, in round 1.

So sparring buys almost nothing, at 3 off the tank or x1.5 injury.

**6. "Last sparring day" against nights.** The choice is one day (9, 7, 5 or 3), but 5 or 3 "confirms TWO lines (the second night)". Which two nights? Is the tank 3 or 6? PART B's "inside 7 days" late-sparring rule also clashes with PART A's "7 days out: no injury".

**7. Sparring 9 days out is always right.** On a 2-week bout it's free and buys a line, and the assistant's default takes it. Nobody picks "none" there.

**8. PEAK against the WEEK BEFORE strip.** The pack's PEAK (2 weeks out) is "hardest, sparring twice". The strip sets one last sparring day and a trip. Say whether the strip replaces PEAK for amateur bouts. CHECK (Claude): WeekPhase on a 2-week amateur bout.

**9. The film rule has a minute that doesn't exist.** "A fade or slow start is checked at the round-2 or round-3 minute." An amateur bout is 3 rounds, so the only corner minutes are after rounds 1 and 2. A fade that shows in round 3 can never be checked.

**10. Matching at walking weight against the first-hour cut.** PART B section 6 matches at actual weight plus the gap, "never the class limit". So a walk-in 2 to 4 kg over the class needs no cut for an amateur bout, and "the first-hour cut stays" doesn't follow. Either amateur matching uses the class limit, or the first-hour lesson changes.

**11. The style is always known.** The city club "shows only when the opponent's file names a style", but the style word is free at booking (pack 4.6). It always shows. At injury x1.0 it's pure gain for $190 whenever there's money.

**12. Cottage units are mixed.**
- "Starts at tiredness -6" only changes the tank above 50.
- "Tick over then costs 3, not 6" is a second, separate rule.
- "The WEEK BEFORE runs as Train through with no load-ratio cost": Train through is a fight-week stop, not a week-before setting.

Say what the cottage does in one unit.

**13. Coach away.**
- "The other boxers train at 60%" while the head coach is at home. The pack's 60% is "without any coach". CHECK (Claude): the coach factor with only the head coach present.
- A commute is daily, so why does the assistant miss the evening class (-$350)?
- The city's "$40 food" doesn't match John's $120 for two.

**14. "Half each" is dominated.** At the measured 61% wins:
- Boxer pays: 0.61 × 6 - 0.39 × 3 = +2.5 mood, $0 to the club.
- Half each: 0.61 × 2 - 0.39 × 1 = +0.8 mood, and the club pays half.

Half each loses on both counts at any win rate over about 25%. "A confident boxer wants to pay" isn't tied to Confidence.

**15. The fundraiser is a chore.** It gives -$350 for $300 to $600, about +$100 on average, pressed every week by anyone short of money. When the assistant is away the class stops anyway, so the fundraiser is free that week.

**16. The assistant probe can't be met.**
- Luke Reid (58) is wrong 21% of the time, and Marcus Hale (74) 13%.
- A wrong pick takes the next-best stop. One night's best-to-worst gap is under 5 in 100, and next-best is usually 1 to 2.
- 21% × about 1.5 is about 0.3 in 100 a season, against a 2+ target.

By the map's own rule the load slider is cut.

**17. Tick over's line.** "One level up in round 1": a Signature line can't go up, and a Raw line (under 30) doesn't fire at all. Say which lines the picker offers.

**18. A pass on a sheet of three clubs.** Does one press add a pass to each club shown? "Passed 1 of 2" is per club, but PASS is per sheet.

**19. Fall-throughs.** 35 in 100 in the final week is about 3 to 4 a season per boxer, so about 14 Continue stops a season for four boxers, plus the host asks. A fall-through after a paid cottage week loses the money. The map doesn't say whether it's refunded.

**20. Word breaches.**
- "This slot went to your other welter": welter isn't one of the game's amateur classes (women's 57/60/65/75 kg, men's 57.5/60/70/75 kg). Say "your other 65 kg boxer".
- WHAT THE WEEK BUILDS says "Strength" while Data.LABEL says Strength circuit leads to Power, and Power is the summary (S448). Two words for one thing.

**21. Names.** The map uses roles only, and I found no name outside a header. "His board" and "his answer" refer to the owner and never reach a screen.

**22. The mockup is the 3-week camp, not this screen.**
- It still has the Seaside camp, which v6 cuts.
- It has no WEEK BEFORE strip, no load stops (Light/Normal/Hard instead), no tank bar, and no TONIGHT, BANKED and SEASON.
- It has "Cardio" and "Legs gains x1.2" (not game words), "gains x1.25" (the flat buff the map bans), and "Fight IQ x1.3".
- Its prices are $875, $400 and $1,000 a week, against the map's $745 and $190.
- It shows PEAK CAMP ("All three lines met = +1 to every stat").
- The pinned note says "YOUR COACH" where the map says "your assistant".
- Gold appears on at least four things.
- It's dark, not Look B.

The header "LUCY JACKSON vs PRIYA NAIR" is the only place names appear, which is correct.

Part 2 of 3

## 2. Depth: 5/10

I played four boxers across a season: two at 60 kg (one woman, one man), a 65 kg woman, and a man at 70 kg.

**Which bout: real.** Home gives $450, +8 members and +5 reputation. Away gives a place and two boxers' facts. That's a true pull every 4 to 6 weeks per boxer, made sharper by the club's money and by the slot going to whoever has waited longer.
- A rank goal or a money goal decides it for the assistant, and mostly for the player too.
- Without the two-places rule, an away loss costs only the record. So once a boxer is at 4 wins, away is the default for anyone climbing.

**Home or away when the card is level: real** until the money is safe. After that, away always wins.

**Where to train:**
- **City club:** taken whenever there's money, with no injury cost and the style always known.
- **Cottage:** only on 2-week bouts, and its gain is in mixed units. Hard to judge.
- **Home:** the default.

That's one real decision in three trips.

**Load:** solved by the SEASON line (logic 1), with Rest up winning from 40 tiredness up (logic 2) and Train through almost never best (logic 3). By the tenth bout this is one click.

**Sparring:** 9 days out on 2-week bouts, none or 7 on 1-week bouts. It buys almost nothing (logic 5).

**Film:** costs a pad night and gets one habit group. A real trade against mastery, and the best small choice here.

**Who pays:** club pays when there's cash and boxer pays when there isn't. Half each is never right.

**Favours:** a real slow resource. The kilo ask against keeping a club's ranked names is a real trade.

**Chores by bout ten:**
- The fundraiser every week.
- The goal mapping in the assistant's pick.
- About 14 fall-through stops a season.
- Choosing the Tick over line again every bout.

## 3. Play: 6/10

**It pulls me on:**
- A new sheet of three cards every few weeks.
- Watching "bouts to entry 3 of 5" and "passed 1 of 2".
- An away win taking a place.
- A late replacement call.
- A tell turning CONFIRMED at the first corner minute.

**What holds it at 6:** once the sheet is picked, the week screen asks seven choices whose answer is printed on it. Most weeks the player presses "Use the pick" and Continue.

## 4. Options

**Missing:**
- **A refund or partial refund rule** when a bout falls through after a paid trip.
- **The choice of which two sparring nights** a 5 or 3-day choice uses, and the tank for each.
- **A way for the player to ask for a named amateur opponent on the sheet.** AskBout rules exist (pack 4.5). The map gives three cards and no ask.
- **A rematch card** for a CONFIRMED tell kept at half value. The map keeps the tell but never brings the rematch.
- **The cottage's refund or cancel** when the bout moves.
- **Boxer pays tied to the Confidence trait,** and greyed with the reason when savings are short.
- **For the city club:** a choice of which style partner when the file names two habits.

**Useless as written:**
- Half each.
- Sparring "none" on a 2-week bout.
- Train through outside a pass or a suspension.
- The SEASON line in its current form (it's the answer, not a price).
- The fundraiser as a weekly money press.
- The round-3 minute for a fade.

**The menus:**

| Menu | Right place? | Found? | Can't act on or wrong |
|---|---|---|---|
| Boxer page, Fights tab | Yes (S448) | Yes | Pass per sheet against per club undefined; no ask for a named opponent; goal mapping decides the pick |
| Fights rail page | Yes | Yes | Fine |
| Bout card | Yes | Yes | "Your other welter" is not a class; risk line fine; "bouts to entry n of 5" good |
| Fight week screen | Yes | From the card | SEASON line shows the answer; tank cap order rewards tiredness; cottage mixed units; half each dominated; sparring "confirms" nothing |
| WEEK BEFORE strip | Yes | Yes | Clashes with PEAK; free 9-day sparring always right |
| Week board | Yes | Yes | Fine once the strip replaces PEAK by name |
| Office desktop / Home | Yes | Yes | Fine, one need for an open sheet |
| Boxer card (Roster) | Yes | Yes | Savings from the background fine; "can take a bout in 7 days" fine |
| Tape room | Yes | Yes | The round-3 check doesn't exist |
| Playbook | Yes | Yes | The Tick over line pick must exclude Raw and Signature |
| Region / club list | Yes | Yes | Fine |
| Continue | Yes | Yes | About 14 fall-through stops a season for four boxers |
| Corner minute (round 1) | Yes | Yes | CONFIRMED / Not seen fine; the round-2 minute is the last check |
| Result page | Yes | Yes | Fine |
| Money | Yes | Yes | The fundraiser as a weekly press |
| Goals (boxer page) | Yes | Yes | Fine; "Earn $n for the club" is a club goal on a boxer page |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Stop printing the answer.** The SEASON line shows each stop's measured season cost against Tick over (a fixed reference), at the boxer's start tiredness band. It never compares against "the best stop this week". The assistant's pick carries the recommendation, with its sureness, and can be wrong.
2. **Give Rest up a price at every tiredness.** Rest up is FLAT in round 1 at any start tiredness, with an edge that shrinks as start tiredness rises (2.0 under 40, 1.0 at 40 to 64, none at 65+). Tick over's line bonus also applies to round 2. FIGHTWEEKPROBE4 must show each stop best in at least 1 week in 5 within each tiredness band, not only overall.
3. **Make Train through's state reachable.** Change "best when" to: the opponent is rated 5+ below, OR the boxer is 2+ weeks from crossing a move to Usable or Sharp (the banked week finishes it). Print that crossing on the stop.
4. **Make sparring buy something real.**
   - A sparring night is one PLAN TEST against a partner of the club's nearest style, as camp does. The test shows how a plan line rates (Beats it / Works / Walks into it) before the bell, so the player can change it.
   - A test doesn't confirm tells. Only the fight does.
   - Pick nights, not "last day": 0, 1 or 2, each placed on a day. A night inside 7 days costs 3 off the tank and x1.5 injury.
   - On a 2-week bout, the free week-before night costs a pad night's mastery instead of nothing.
5. **Fix the tank cap.** Remove the cap, or let the overflow fall on tiredness (which the player didn't pick this week), never on the weight or sparring.
6. **One cottage rule, in one unit.** The week before banks in full with no load-ratio entry, and the fight week starts with 10 less tiredness (so it changes the tank only above 50). Drop "Tick over costs 3". CAMPPLACE1 measures it per use.
7. **Give the city club a price beyond cash.**
   - Injury x1.15 for the week (a strange partner and a strange gym).
   - The assistant's evening class runs only if the commute is days only.
   - Food at John's $120 for two, or explain the $40.
8. **Who pays, without a dominated row.**
   - Club: +3.
   - Boxer: +6 on a win, -3 on a loss, and only offered when Confidence is solid (55+). Otherwise greyed with the reason.
   - Half each: +4 on a win, 0 on a loss (the safe middle).
   - Re-check with the measured win rates that each row is best for some boxer.
9. **Fundraiser:** once every 8 weeks, not weekly, and it needs a coach in the gym that night.
10. **Film timing:** a fade or slow start is checked at the round-2 minute. A fade that never came stays SEEN.
11. **Weight:** amateur matching uses the class limit when the boxer is outside the class's gap, so the first-hour cut stays. ASK FOR A KILO stays as written. CHECK (John): the 2026 category widths.
12. **Fall-throughs:** one stop per boxer per bout at most. A paid trip refunds half when the bout falls through. Keep 35 in 100 only if John's range holds for the final week. CHECK (John).
13. **Passes:** PASS adds one pass to every club on the sheet, shown before pressing ("passing adds 1 to each club").
14. **The assistant probe:** measure "always the pick" against "the best stop each week" instead of "a reader". If the gap is under 1 in 100, keep the slider but default it, and don't call it a decision.
15. **Words:** class labels in kg ("your other 65 kg boxer"); one word for Strength circuit's stat.
16. **Redraw the mockup** as the fight week screen. The fight week screen needs the bout sheet (BoutSheet) and the show calendar (RegionShows), which the game doesn't have yet.

### The 10/10 fight week screen at 1920×1080

The shell stays: dark top bar, left rail. The content is a whiteboard (Look B). Names appear only in the header.

- **Header** (full width, about 110 px):
  - Both portraits, with the names, the class in kg and the records.
  - Days to the bell, home or away, and the favour count with the host.
  - The win band.
  - One red button: Lock the week.
- **WEEK BEFORE strip** (full width, about 140 px, only on 2+ week bouts): three trip magnets (home, city club, hill cottage), each with its cost, its one number, and the coach-away cost in one line. Plus a sparring night slot with its pad-night cost.
- **The fight week** (centre-left, about 1150 x 420 px): seven day columns, with mornings and evenings as magnets.
  - Under them, three picture-stop sliders, each stop showing its tank and banked numbers:
    - LOAD: Rest up, Tick over, Train through
    - SPARRING: nights placed on days
    - WEIGHT: Hold, Eat less, Train it off, Ask for a kilo, greyed with the reason when it would cross
  - The Tick over line picker shows only lines at Usable or Sharp.
- **WHO PAYS** (centre-left, under the week, about 1150 x 140 px): three cards (club, half each, the boxer) with cash and mood on a win or a loss, greyed with the reason.
- **Your assistant's pick** (right, about 620 x 220 px): face, one-line reason naming the fact that drove it, sureness word, Use the pick.
- **ON FIGHT NIGHT** (right, about 620 x 480 px, the one gold frame):
  - TONIGHT: a stacked tank bar (tiredness, load, sparring, weight) with its price in wins, sharp or flat, lines ready at their fire share, the scale margin.
  - BANKED: stat points this week in the trained abilities, the move crossing a line, tiredness carried.
  - SEASON: this stop against Tick over at this tiredness band, measured.
  - Each row shows its change from the assistant's pick.

There's no PEAK CAMP row, no Seaside card and no gains-x multipliers. Hovering any number shows its parts.

CHECK (Claude): WeekPhase on a 2-week amateur bout; the coach factor with only the head coach present.
CHECK (John): 2026 category widths; amateur pull-out rate in the final week.

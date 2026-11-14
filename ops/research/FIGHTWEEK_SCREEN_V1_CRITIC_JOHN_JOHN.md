# FIGHTWEEK_SCREEN_V1_CRITIC_JOHN_JOHN - John answer (seat queue SQ140)

Brief: research/FIGHTWEEK_SCREEN_V1_CRITIC_JOHN.md
Sent: 2026-11-14 23:10 | collected: 2026-11-14 23:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading the fight week screen against the map now. A check of the numbers and rules comes first, then the scores and To reach 10/10.

# Fight week screen v1: logic check

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the real screens. I judged from the map and the HTML, read as code. The screen has every section the map asks for, but its numbers contradict each other in six places, and it uses the dark style the map dropped.

**1. The tank doesn't add up.**
- The bar's legend reads tiredness 3, Tick over 6 and sparring 3. That's 12 off, so the tank should be 88, but it shows 85.
- The grey segment is drawn 6% wide, so the drawing says tiredness costs 6 while the legend says 3.
- Start tiredness itself is never printed anywhere. Yet every "best when" label on the load stops ("tiredness 65+", "most weeks under 65") depends on it. The player is told when each stop is right but never given the number to check.

**2. Tuesday's sparring is priced at the wrong distance from the bell.**
- The bell is on Sunday, so Tuesday is 5 days out. The map (4.4) prices that at **5 off the tank, ×2.5 injury and a 3 in 100 cut**. The screen shows "−3 tank".
- The pack has club shows on Saturdays. On a Saturday show Tuesday is 4 days out, which is still the late price.
- **Fix:** put the bell on Saturday, and let each sparring magnet print the price for its own day.

**3. ON FIGHT NIGHT shows today's plan, not the plan at the bell.**
- Two sparring nights are on the board: the week-before one and Tuesday's. The week-before night readies two lines, and Tuesday's (5 days out) readies every line.
- So no line can still be UNSPARRED at the bell, yet the frame shows "1 UNSPARRED", tags the check-hook line "level down", and the tank in the same frame does count Tuesday's sparring.
- The frame is labelled TONIGHT, so it has to show the state after the planned week.

**4. Two firing shares can't happen.**
- FireLevel only has 1 in 2 (Usable), 3 in 4 (Sharp) and always (Signature). "Pressed → step back: 1 in 3" isn't a value the game has. A step below Usable 30 is never planned, under S463.
- The Tick over line ("Waits → feint, body hook") should go up a level in rounds 1–2, from 1 in 2 to 3 in 4. The frame still says "fires 1 in 2", so the main thing Tick over buys is invisible on the frame that sums it up.

**5. The plan has four lines but the frame shows three.**
- The chips show four lines. The ON FIGHT NIGHT lines and the readiness count only cover three: "Inside → tie up" has no tag and no row.
- "2 SEEN tells", but only one line carries a SEEN tag.

**6. The COACH AWAY card contradicts the map.**
- The map has the commute with your assistant "away by day, and the evening class still runs". The full-week card (class stops, −$350) belongs to an assistant away all week, which is the cottage.
- The screen puts the full-week card under the commute, so the commute is shown $350 dearer than it is.
- It also prints "0.85 (head coach only)" as a fact. The map leaves that factor as an open CHECK for Claude.

**7. Banked uses an old stat name.**
- Banked shows "Technique +0.4". The map says this screen uses the Attrs names, and Technique is one of the old seven (a profile summary only). It should read Accuracy or Timing.
- The "moves crossing a tier by the bell" row is missing.

**8. Smaller faults.**
- **Weight:** "inside the 2.5 kg gap by 0.6" is measured against the opponent's walking weight, which the screen never shows. Ask for a kilo is greyed as "only within 1 kg of the gap", but the real reason is that it isn't needed.
- **The week-before trip with 2 days left:** at 9 days out (Friday), the commute is booked for a week that has two days left. The screen should say how many days it covers or lock it.
- **Units:** five different units sit side by side: "+1.0" edge, "×1.15", "in 100", "%" and "level down". Under S422 the player should see one, wins in 100, with the parts on hover.
- **The open hover:** the Train through hover is drawn open over the Train through card itself, so it hides the stop it describes.
- **The host:** Fitzroy Lodge is a real England Boxing club (Lambeth, since 1946). The pack allows real names only where legal, so use a fictional host.

**What holds:**
- Names are only in the header. "Her" and "she" on the payer rows refer to that boxer, which S412 allows.
- Every choice prints its price beside it.
- The assistant's pick names its single driving fact, and "Sure 4 in 5" matches Luke Reid's 0.79.
- Trip costs ($270 and $210) and the payer split ($135) match the map.
- The SKINT and savings gate shows its reason.
- Only one red button.

## Scores

**Clarity 5.**
- Each choice prints its cost beside it, and the assistant's line says what it would do and why in one sentence. That part reads in 10 seconds.
- Fight night doesn't. The tank sum is wrong, the firing shares contradict the Tick over boost, the frame shows the plan before the week instead of at the bell, and start tiredness (the number every "best when" label depends on) isn't printed.
- Five units and the words "edge" and "level down" are jargon under S422.

**Completeness 6.**
- Present:
  - the week-before strip;
  - seven day columns;
  - three load stops with the line picker and the next-stop hover;
  - three weight pills;
  - trip, coach-away and payer cards;
  - the pick, with Use the pick and Lock the week;
  - the readiness line, tank, round 1, lines, scale, win band, banked and season.
- Missing, from the map's sections 9 and 10:
  - start tiredness;
  - the moves crossing a tier in Banked;
  - each row's change from the assistant's pick;
  - the late-sparring injury and cut prices;
  - which two lines a sparring night readies (the picker);
  - what the film night opens, and the second-film choice (Look again or Next group);
  - the other trips' fight-night numbers (the strip pills show cash only);
  - which weight pill is on;
  - the opponent's walking weight, for the gap;
  - the dark shell, with its top bar and CONTINUE.
- Useless as drawn:
  - the morning words ("roadwork", "intervals") can't be clicked and change nothing here;
  - the "(hover: wins in 100 each)" instruction text;
  - "Next 4 weeks" duplicates the Office desktop, though it's cheap.

**Play 6.**
- The decision is real. Trip, load, sparring and weight each trade tank, injury, cash or mastery, and the pick makes the usual week one click.
- Because the frame never shows the change from the pick, overriding it gives no felt result. The player can't see "my call: +2 in 100 against the pick".
- The bout itself is missing from the screen (home or away, what a win gives). That's the reason to care this week.

## To reach 10/10

1. **Compute ON FIGHT NIGHT at the bell, from the board as set.** Sparring placed earlier in the week readies its lines, Tick over raises its line (3 in 4 in rounds 1–2), and the tank equals 100 minus the parts shown.
2. **Print start tiredness** in the load header ("Start tiredness 53: band 40–64"), and light the "best when" label that matches it.
3. **Make each sparring magnet price its own day:** 7–6 days out costs 3 off; 5 or fewer costs 5 off, ×2.5 injury and a 3 in 100 cut. Put the bell on Saturday. Clicking a magnet opens the two-line picker.
4. **Use only FireLevel shares** (1 in 2, 3 in 4, always). Write "doesn't fire in rounds 1–2" in place of "level down". List every plan line, with every SEEN tag.
5. **One unit:** every edge, risk and boost in wins in 100, with its parts on hover. Drop "+1.0", "×1.15" and "%" from the face of the screen. Write injury as "injury risk +15%" on hover only.
6. **Fix the coach card:** commute means away by day and the class runs. Show the full-week card only for the cottage. Leave the factor out until Claude's CHECK lands.
7. **Show each row's change from the pick** in ON FIGHT NIGHT ("+3 tank, −1 in 100 against the pick"), so an override has a visible price.
8. **Complete Banked:** Attrs names only, plus the moves crossing a tier by the bell and tiredness after.
9. **Complete the film magnet:** its price (one pad night), the tell group it opens, and Look again / Next group on a second night.
10. **Weight:** print the opponent's walking weight beside the gap, show which pill is on, and give Ask for a kilo the true greyed reason.
11. **Redraw in Look B, the cream whiteboard, inside the dark shell** (top bar with CONTINUE, and the left rail). Make Lock the week the one pulsing button, and use green only where the rule allows.
12. **Put the bout in the header:** home or away and what it gives ("Away: a ranked place on a win"), with a fictional host club.

## The 10/10 page (1920×1080)

**Shell:** a dark top bar (the gym, the date, cash, and CONTINUE reading "to Mon, the pull-out roll") and the left rail. The rest is a cream whiteboard in an aluminium frame, with marker text in Permanent Marker and Kalam.

**Header (96 px):**
- one portrait and name per side, the class in kg and records;
- "AWAY at Northgate ABC: a ranked place on a win";
- favours shown as magnets;
- the scale: "61.4 now · opponent walks 60.2 · inside the 2.5 kg gap by 0.6 on the day";
- "9 days" circled in red marker.

**WEEK BEFORE strip (84 px):** trip pills, each with cash and its fight-night number ("City club with your assistant, $270, +1 in 100 against counterpunchers, 2 days left"), and the week-before SPAR magnet ("one pad night, readies Loads up and Inside").

**Left (440 px):** the selected trip card, with the other trips as one-line rows beneath for comparison. The coach card only appears when a coach leaves for the week. Payer rows with their mood and savings; the boxer row greyed with "savings $90, needs $270".

**Centre (920 px):**
- **"Start tiredness 53"** as a big marker number.
- Seven day columns ending in a circled **SAT FIGHT NIGHT · weigh-in 1 h before**. The magnets print their price: Tue SPAR "5 off · injury risk up · cut 3 in 100"; Wed FILM "one pad night · opens the habit group".
- The three load stops, with "best when" lit for the band. Tick over has the line picker.
- Weight pills with the selected one ticked.

**Right (560 px): ON FIGHT NIGHT in the one gold frame.**
- "4 ready · 0 UNSPARRED · 1 SEEN" at the top.
- The tank at 84, its segments labelled tiredness 3, Tick over 6 and sparring 5. Hover shows wins in 100 for each.
- Round 1: Sharp.
- Four plan lines:
  - Waits: 3 in 4 in rounds 1–2, then 1 in 2;
  - Pressed: 1 in 2;
  - Loads up: 1 in 2;
  - Inside: 1 in 2.
- The scale against the gap, and the win band "47–59 in 100", in red marker: "+1 against the pick".
- Banked: Accuracy +0.4, Uppercut 27 to 29 (Usable needs 30), tiredness after +0.
- Season: −1 to +2 in 100.

**Bottom (120 px):** the assistant's quote and its one fact; Use the pick; the red Lock the week, which is the only button that pulses.

**The stress state on the same page:** start tiredness 75 with Train through and a late sparring night.
- The tank reads 53 in red: 25 for tiredness, 12 for Train through, 5 for sparring and 5 for the cut.
- Round 1 reads "Sharp, but the tank is low from round 2".
- The pick card says "Rest up: tiredness drives it".

## Sources
- Fitzroy Lodge ABC, [home page](https://fitzroylodge.club/) and [about page](https://fitzroylodge.club/about/), read 2026-11-14. OFFICIAL: a real England Boxing club at 180 Lambeth Road, London, in its current home since 1946.
- Everything else is DERIVED from the critic pack (FireLevel S451, StepMastery S463, club shows on Saturdays, the coach ratings) and the map's sections 4, 9 and 10. The tank sum is 3 + 6 + 3 = 12, which leaves 88, not the 85 on screen.

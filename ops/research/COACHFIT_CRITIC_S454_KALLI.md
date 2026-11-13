# COACHFIT_CRITIC_S454_KALLI - Kalli answer (seat queue SQ69)

Brief: research/COACHFIT_CRITIC_S454_BRIEF.md
Sent: 2026-11-13 17:40 | collected: 2026-11-13 18:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring COACHFIT1 v3 against the pack. First I'm opening the office mockup again to check it against this version.

Part 1 of 3

# COACHFIT1 v3: critic (S454, Kalli)

Judged on this map, the pack and `docs/mockups/s449/office/office_a.png`, which I opened with the file tool. I didn't open the Miro board, the real screens or the code.

**Verdict:** Depth 6/10, Play 5/10.

What now works:
- Assigning by area, coach energy as a two-week trade, the graded taught-out warning, and swapping for this week only or for good all make who-trains-whom a weekly question.

What still breaks it:
- The fit's own parts can't reach the numbers the map prints. The best possible fit is about 70, so TOP FIT never shows and the gain spread is roughly x0.86 to x1.08, not x0.80 to x1.20.
- The probe target of 0.5 stat points a week can't be reached even at the full spread.
- Light and Normal mornings at 0.6 quietly cut today's training for every boxer.
- Two of the modes are the flat +5% the map says it bans.

## 1. Logic check

**1. The fit can't reach TOP FIT.** v3 never states the base (v1 said 50). From 50:
- Best case: temper +8, load 0, bond Corner +6, taught out 0, weakest stat +6 = **70**.
- Worst case: 50 -10 -14 -6 -6 = **14**.

So TOP FIT (80+) never appears, and "x1.20 at 100" is never used. The real spread is about x1.08 to x0.86 on gains, and x0.91 to x1.10 on tiredness. That's the same problem the last critics flagged as invisible.

**2. The FITPROBE1 bar can't be met.** By the pack, a fully focused week adds about 1.0 point times the coach factor (about 0.9), so roughly 0.9 points to the focused stat. Three coached sessions are only part of that week.
- At the map's own full x0.80 to x1.20, TOP FIT against RISKY moves about 0.36 a week.
- At the reachable spread from point 1, it moves about 0.15.

">= 0.5 stat points a week" fails by design.

**3. Mornings left alone cut today's training.** Pack 4.1: every morning is multiplied by the coach factor. With Luke Reid at rating 58 that's 0.91, and with Marcus Hale at 74 it's 1.02. v3 makes Light and Normal mornings "alone, 0.6" unless coached. That cuts most of a boxer's mornings by about a third against today, and moves every growth number in the game. FITPROBE1's arm "fit at 50 = today" is then not today.

**4. Coach energy doesn't add up.** 10 energy holds "8 normal sessions with room for a corner night", but 8 + 3 = 11. And 16 to 22 coached sessions against "12" needs explaining: 12 is one assistant's 8 plus the head coach's 4. Two load models are still live:
- PADPOOL1 gives 8 club pad nights a week.
- The mockup says "pad nights 4 of 6" for the head coach and "3 of 3" for the assistant.

On top of that, "two fighters on the same pads counts once" is stated for growth but not for energy.

**5. The head coach against the 60% rule.** Pack: "Without any coach, training runs at 60%." v3 gives the player, who is always present, a rating of 60 or 45, so the coach factor is 0.92 or 0.815. Either the 60% rule goes, or the head coach's rating only applies to sessions they're assigned to. CHECK (Claude): how CoachAreas treats "no coach" today. "4 sessions + the office" also needs a cost for the office.

**6. Mood bands are wrong.** The Motivator's "+8 with a fighter on Low mood (under 40)". In the game, Low is under 30 and Flat is 30 to 49.

**7. Flat +5% perks, against the map's own rule.** Motivator DRILL "gains x1.05" and Steady hand BUILD "gains x1.05 on conditioning" are the flat "+5% training" the rules section forbids.

**8. The Technician's line is already met.** POLISH reaches Sharp moves "from rating 65", and the milestone example says "reached 65: polish now reaches Sharp". The pads coach (Luke Reid) already has pads 74. Also, "moves already Usable" doesn't say whether that includes Sharp (60+).

**9. Bond outruns its own target.** One pads coach on four fighters runs 3 sessions a week with each, and -1 a week "apart" never applies to an area coach the fighter sees every week. That gives four Working pairs in about 3 weeks and four Trusted pairs in about 12 from that coach alone, against "two or three pairs reach Trusted in a season". "Apart" needs a definition: no session together that week.

**10. FOR GOOD wipes a bond the pair already has.** Bond is per coach and fighter. Moving the pads area to a coach who already runs the fighter's strength mornings at Working can't "start at Stranger".

**11. The fighter's ask is usually moot.** Bond is built by sessions together, so the coach a fighter trusts is most often already on her or his pads. The ask only means something when that coach isn't.

**12. Who shouts in an assistant's corner is undefined.**
- The player still picks the shouts. The map has to say the corner coach only changes how many are heard.
- Three multipliers stack: morale trust 1.05 to 0.7, coachability, and bond 0.90 to 1.10. Fired up times Corner is 1.155. That needs a cap as well as the floor.

CHECK (John): how many seconds an amateur corner may have, and whether the head coach may stand behind an assistant.

**13. A raise is cheaper to refuse.**
- Pace: +1 per 10 sessions, and a coach doing 8 pads sessions a week gains 5 points in about 6 weeks. That's a raise about 8 times a season, taking $450 a week to about $850.
- Working to rule costs one session a week for 4 weeks, against $50 a week for good. Say No wins on money every time.
- Whether a second refusal stacks is undefined.

**14. The second club coach.** The pack's job runs members' fitness classes (+40 members). v3 also puts that coach on fighters' conditioning mornings with 5 energy. Say whether the classes still run and what they cost in energy.

**15. The predicted gain is printed in the wrong stat.** "+0.26 Power": Power is now a summary read from the abilities (S448), not something a session trains. Print Strength, Stamina, Accuracy and so on.

**16. Names.** The map keeps names in headers: "the pads coach", "the fighter", and corner cards with the name in their header. No breach found in the map. In the mockup, the mail line "Your coach: The welterweight is sharp" comes from the assistant, since the player is the head coach, so it should read "Your assistant". The mockup has no names outside the header.

**17. The mockup.**
- It shows the office desktop, not the Staff app. There's no table, energy pips, fit words, modes or corner pick.
- The staff strip counts pad nights, not energy.
- The class labels "Welter 69 kg", "Light 60 kg" and "Feather 57 kg" are pro words, and 69 kg isn't a class in either list.
- It's drawn dark, not in the whiteboard style (Look B).

Part 2 of 3

## 2. Depth: 6/10

I tried to break it with four boxers, the head coach and two assistants.

**Assignment is real, and right for the right reason.** With 16 to 22 coached sessions against about 12 to 20 energy, someone trains alone or someone goes over budget. Over budget against next week's camp is a real two-week trade. Taught out moves the best table through a season.

**Mostly the same pick every week.** Within a week the fit varies only from about 14 to 70, and most of that comes from load and bond, which the player doesn't pick freshly each week. So the table settles: the pads coach on pads, the conditioning coach on conditioning, until a taught-out warning or a fight week. That's a decision about once a month per fighter, not weekly.

**Tempers:**
- **Motivator:** hired only when someone is often low. LIFT's -12 to -8 is worth about 4 mood per loss.
- **Drill sergeant:** PUSH is right with a disciplined, steady fighter and wrong with a flat one. That's a real mode choice.
- **Technician:** POLISH and TEACH split cleanly on whether moves are under or over 30. Real, but it's decided by the fighter's moves, so it's mostly automatic.
- **Steady hand:** TAPER inside 14 days and BUILD otherwise. Per coach, with mixed calendars across four fighters, this is a real trade. The only mode that is.

**Bond:** it matters at the corner (calls heard) and in the fit (-6 to +6). As written, nearly every pair reaches Trusted (logic 9), so it stops telling pairs apart.

**Growth:** noticed through raises, mainly as a cost (logic 13). The school and ceiling lines help.

**Predicted gains in hundredths:** "+0.26" against "+0.22" on one row is too small to feel, which hides the decision that does exist.

## 3. Play: 5/10

**It pulls me on:**
- Seeing "taught out in about 3 weeks".
- Choosing who works the corner and reading "about 4 of 6 heard".
- A fighter's ask.
- A raise to answer.

**What holds it at 5:**
- 20 cells and up to 4 mode toggles a week, with differences in hundredths. "Coach runs it" will take it most weeks.
- TOP FIT, the headline word, never shows.
- The mornings cut makes everything slower without a choice.

## 4. Options

**Missing:**
- **The week's total per fighter and area** in whole points ("pads this week: +0.9 Accuracy"), not per session.
- **A cap and a shown result** where morale trust, coachability and bond multiply at the corner.
- **A rule for a second refusal** of a raise, and what the coach does next.
- **What the head coach's office time costs,** and what "4 of 5" means on the head coach's card.
- **The second club coach's split** between members' classes and fighters' mornings.
- **"Apart" as a shown state** on the bond pips (no session together this week).

**Useless as written:**
- TOP FIT (it can't occur).
- Motivator DRILL and Steady hand BUILD, which are flat +5%.
- The Technician's "from rating 65" line for the current pads coach.
- The fighter's ask when that coach is already on the pads.
- FOR GOOD's "starts at Stranger" for a pair that already has a bond.

**The menus:**

| Menu | Right place? | Found? | Can't act on or wrong |
|---|---|---|---|
| Week board (Training) | Yes | Yes | TOP FIT never shows; gains in hundredths; "Power" is a summary stat; mornings at 0.6 cut today's gains |
| Staff app, coaches | Yes | From the desktop | Energy 8 + corner 3 > 10; the 65 line already met; Say No beats Pay |
| Staff app, table | Yes | Yes | 20 cells weekly; FOR GOOD resets an existing bond; office cost undefined |
| Staff app, market | Yes | Yes | Fine; the ceiling range must sit above today's rating |
| Office desktop | Yes (S451) | Yes | The mockup counts pad nights, not energy; "Your coach" should be "Your assistant" |
| Fighter page, Training | Yes | Yes | Bond pips with no "apart" state |
| Fighter page, moves | Yes | Yes | Fine; step arrows wait for STEPMASTERY1 |
| Learning-slot cards | Yes | Yes | Fine |
| Monday review | Yes | Yes | A raise about every 6 weeks per coach; the second refusal undefined |
| Bout card / fight week | Yes | Yes | Who shouts is undefined; no cap on the stacked multipliers; CHECK (John) on corner seconds |
| Fight: shouts | Yes | Yes | Fine once the cap exists |
| Result page | Yes | Yes | "Cost about 3 in 100" needs BONDPROBE1 first |

Part 3 of 3

## 5. To reach 10/10

Mechanics, most important first.

1. **Make the fit reach its own range.**
   - State the base, 50.
   - Size the parts so the best real pair can reach 90 and the worst 10:
     - temper and mode -15 to +15
     - bond -10 / 0 / +8 / +12
     - weakest stat +8
     - taught out -4 / -8 / -12
     - load 0 / -8 / -16
   - Or keep the parts and set the words on the reachable range (TOP FIT 65+, RISKY under 30).
   - FITPROBE1 checks that TOP FIT shows on at least 1 row in 5 at some point in a season.
2. **Measure the fit where it can be felt.** Keep gain x0.80 to x1.20, and set the FITPROBE1 bar per area across a season: TOP FIT against RISKY worth at least 3 stat points in that area over 26 weeks. Print the week's total per area on the row, not each session's hundredths.
3. **Don't cut today's mornings.** An uncoached Light or Normal morning keeps today's factor from the best coach on staff in that area. Assigning a coach to a morning adds the fit on top and costs energy. FITPROBE1's "today" arm must match today's numbers.
4. **Fix the energy sums in one unit.**
   - An assistant has 11 energy (8 sessions + one corner night), or the corner costs 2.
   - A pad night with two fighters costs the coach 1 energy and counts once for growth.
   - Retire the pad-night count (PADPOOL1's 8, the mockup's "4 of 6") in favour of energy.
   - The head coach: 5 energy, the office costs 1.
5. **Settle the head coach and the 60% rule.** The player is always a coach. Sessions nobody is assigned to use the head coach's factor (60 in their background's area, 45 elsewhere), and the 60% rule only applies when the head coach is in the office. CHECK (Claude): CoachAreas.rating_for and the "no coach" case.
6. **Replace the flat modes.**
   - Motivator DRILL: +1 plan test per pad night that coach runs.
   - Steady hand BUILD: that coach's sessions raise the load-spike limit from 1.5 to 1.7 (the injury rule in 4.1).
   - Each mode changes something the player can see that isn't a flat gain.
7. **Make bond scarce.**
   - Bond builds only from pads, sparring and corner nights.
   - "Apart" means no session together that week (-1).
   - Thresholds 0 / 10 / 45 / 110, so one coach with four fighters reaches Trusted with one or two of them in a season.
   - FOR GOOD keeps the pair's existing bond. The -20 only falls on the coach losing the area mid-camp.
8. **Make raises a real choice.**
   - Growth +1 per 15 sessions (a raise about every 9 weeks).
   - Say No: energy -1 for 4 weeks. A second No within 12 weeks: energy -2 for 8 weeks.
   - Pay: the coach's ceiling range narrows by 2 at the top end (the coach invests).
   - The S412 bots check that neither answer wins more than 60% of the time.
9. **The corner.**
   - The player always shouts. The corner coach changes only how many calls are heard: morale trust times coachability times bond, capped at 1.10, floor 0.5.
   - The head coach working the corner costs 3 of their 5 energy, so fight week costs the office or a session.
   - CHECK (John): amateur seconds and who may stand in the corner.
10. **The fighter's ask** fires only when the trusted coach isn't already on her or his pads.
11. **Number and word fixes:**
    - Low is under 30.
    - The Technician's Sharp line set above the pads coach's 74 (for example 80), or dropped.
    - Predicted gains in the trained abilities, not Power.
    - The second club coach keeps the members' classes, and each fighter's morning they take costs a class (-5 members' target).
12. **Redraw the mockup** as the Staff app:
    - the table
    - energy, not pad nights
    - "Your assistant" in the mail
    - class labels from the game's lists
    - the whiteboard style
13. **Probe order:**
    - FITPROBE1, with the reachable range and the season-per-area bar
    - BONDPROBE1, with the new thresholds
    - the raise test, with the S412 bots

These need things the game can't do yet: the Staff app (OFFICE2), per-area coaches on mornings, the asks mechanic for coaches, step mastery, the rival gym's offer.

### The 10/10 Staff app at 1920×1080

The shell stays: dark top bar, left rail. The content is a whiteboard in the office. The only names on the screen are in each coach card's header.

- **Header** (full width, about 100 px): "Staff, week 11". Coach energy totals ("used 34 of 36"), sessions alone this week, the next fight week, and how many roster places are open. One pulsing button: Lock this week.
- **The table** (centre-left, about 1150 x 620 px): fighter rows (portrait, class and record), with five area columns.
  - Each row starts with that fighter's week total in whole points for her or his focus ability, and the best swap's gain.
  - Each cell shows a coach magnet, a fit word with a bar, the week's points for that area, bond pips, and one warning chip (FRICTION, TAUGHT OUT IN 3 WKS, ALONE, OVER BUDGET).
  - Clicking a cell opens the swap popover, with This week only and For good, each showing its price.
  - Under the table: Copy last week, Coach runs it, and a lock per cell.
- **Coach cards** (right, about 620 x 620 px, stacked):
  - Each card: comic portrait with the name in the card's header, temper word, and a mode toggle with its effect in one line.
  - Energy pips ("9 of 11", red past the line), area ratings with growth ("62 to 63 in 4 sessions"), the ceiling range.
  - The school's moves as chips, wage, and the raise if one is asked (Pay / Say no, each with its cost).
- **Fight week strip** (bottom-left, about 1150 x 200 px, the one gold frame), shown only when a bout is within 14 days.
  - Who works the corner, as candidate cards with "about 4 of 6 heard" and the win swing.
  - The energy each candidate gives up, and the cutman beside them on pro nights.
- **Market** (bottom-right, about 620 x 200 px): filters for area, temper, ceiling and wage. Two or three cards with temper, school, ceiling range and wage, and Hire (greyed with the reason when cash or the roster blocks it).

There's no fit score total and no best-table badge. Hovering any number shows its parts.

CHECK (Claude): the "no coach" rule in CoachAreas; which abilities each morning session feeds.
CHECK (John): amateur corner seconds.

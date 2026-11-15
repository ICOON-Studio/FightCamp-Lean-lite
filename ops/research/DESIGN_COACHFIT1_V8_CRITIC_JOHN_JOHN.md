# DESIGN_COACHFIT1_V8_CRITIC_JOHN_JOHN - John answer (seat queue SQ148)

Brief: research/DESIGN_COACHFIT1_V8_CRITIC_JOHN.md
Sent: 2026-11-15 01:10 | collected: 2026-11-15 01:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading COACHFIT1 v8 against the pack now. I'll check its numbers and rules first, then send the scores and To reach 10/10.

# COACHFIT1 v8: logic check

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the mockups. I judged from the pack and the map.

**What adds up.** I re-ran the formulas and most of them hold:
- **Fit:** the range is 50 + 10 + 12 + 10 = 82 at the top, and 50 − 12 − 18 − 4 − 6 − 3 = 7 at the bottom, clamped to 10.
- **Multipliers:** gain is ×1.32 at 82, and tiredness is ×1.10, ×1.00 and ×0.92 at 10, 50 and 82.
- **Ceilings:** 75, 86, 80 and 70 all round down correctly.
- **Everyday budget:** 4.5, 9.0, 10.5 and 11.0 are right.
- **Week 10.3:** the 11.0 default is right. Fit 56 gives ×1.06, and 48 gives ×0.98. The 1,080 units lose 86. Word taken in is 0.896 with the assistant and 0.853 with the head coach. Answers B, C and D add up to 10.0, 9.0 and 8.0. C plus LIFT gives 105%.
- **Raises:** $50 is 6.2 members' dues.

Last round's evening-stat fault is gone. Evenings now scale drill units, as the code does.

**Names:** they appear only in headers and in table 9.1 of the doc. I found no fixed he or she.

**1. The worked week has a phase error, and it decides the answer.**
- Answer A says "next week starts at 9 of 10, still in PEAK". In the pack, PEAK is the single week 2 weeks out, and the next week is TAPER. That week is light, with three rest days and no sparring (S451 `WeekPhase`).
- So next week the 65 kg boxer costs about 2 pad nights plus a corner, 5 of 10. Borrowing 1 is free.
- With that fixed, **A plus LIFT** (11.5 of 10, −8 fit, word taken in 105%, no bond lost, −86 units) is roughly as good as C plus LIFT. The map's verdict ("A is the borrowing trap") doesn't hold in this example.
- **Fix:** make the 65 kg boxer's bout 3+ weeks out, so they're in BUILD and still building next week, or else drop the claim.

**2. Shared sparring has no cost, so it's always the right pick.**
- Two boxers on one sparring night cost 2.0 instead of 3.0, and each keeps the full 180 share. There's no downside, so whenever two boxers spar in the same week, sharing always wins.
- **Fix:** give it a real cost. For example, a clubmate can't match the opponent's style or stance (the $160 outside partner can), or the two must sit within one weight class, or both take the sparring injury roll.

**3. Coaching a non-FOCUS morning is mostly a loss.**
- FOCUS gives −3 on the boxer's other coached mornings. So a coached non-FOCUS morning reads 47, below the 50 an uncoached morning gets, and it costs 0.5 or 1.0 coach time.
- It only pays with a Motivator and a Flat boxer, a Technician and a boxer with coachability 70+, or the +0.5 bond from Hard.
- MORNINGPROBE's 20–50% target will likely fail on mornings outside FOCUS. Drop the −3, or make it apply only to the boxer's *uncoached* mornings.

**4. The coach's request is near useless both ways.**
- Granting gives +3 fit on one morning. A morning is a fifth of about 1.0 stat a week, so that's about +0.006 of a stat point, for +0.5 coach time.
- Refusing costs −2 bond, half a week's bond.
- Either make the request about an evening (+3 fit on 240 units is about +7 units, still small) or a real swap ("let me corner Saturday"), or cut it.

**5. The Strength coach edge is changed without a NEW tag.**
- Pack 4.1 gives the head coach's Strength edge as body mornings +10% and craft −10%, club-wide.
- Section 7 limits it to "the head coach's own sessions". That narrows a CODE rule and must be marked NEW, with an owner question.

**6. The head coach's Working start fades.**
- The head coach starts at Working (8) with every boxer, but bond falls −1 a week without nights together. The head coach rarely runs nights, so most pairs are Strangers by week 9, and the emergency cover in 3.6 and answer C then run at −4.
- **Fix:** no decay below Working for the head coach. They're there every evening.

**7. Level 2 doesn't match England Boxing's real course.**
- **Fee:** the map's $600 is too high. England Boxing's Level 2 Full Coach course costs **£231, which is $289 in game** (OFFICIAL). It runs **4 days**, with the assessment on the last day. One course held in London ran over two weekends.
- **Away time:** the coach would miss about 4 days, which can be two weekends, not a whole week of cover.
- **The 52-week rule is right:** "a Level One Assistant Coach for a minimum of one year" (Coaching Rules Policy, Feb 2026).
- **A failed assessment:** EB gives one free retake within 12 months.
- **Sparring:** the policy also says "Only a Level Two Full Coach can supervise/take sparring". That applies to the two assistants too. The map lets both run sparring nights without saying they hold Level 2. Add it to the coach card ("Level 2"), or the rule is applied to one coach only.
- **Head coach:** since 1 June 2025, every club must list a Level 2 coach as its head coach. The player's head coach is Level 2 by rule, which is worth one line on the card.

**8. The scarcity claim isn't derived.**
- "One coach usually holds 1–2 Trusted pairs." Bond is per pair, at about 4 a week, so a coach running every evening for 3 boxers gets all 3 to Trusted by week 11.
- Coach time is the only limit: 10 coach time covers about two BASE boxers. Say that, or BONDPROBE1's "at most 2" line is testing the budget rather than bond.

**9. Small things.**
- **Rounding:** the hover gives 0.82 for the head coach's factor. 0.9 × 0.906 = 0.815, which rounds down to 0.81 under the map's own rule.
- **Empty rows:** M20 and M21 do nothing. Drop them from the table.
- **Too fine to matter:** LIFT taking a 47 boxer to exactly 50 (Steady) is a knife edge built on an ESTIMATE. The worked week shouldn't hinge on it.

**Real-world support:**
- England Boxing's Level 1 / Level 2 split (no sparring at Level 1, a year before Level 2) gives the promoted coach a real, sourced growth beat. That's the strongest new idea in v8.
- Jowett's coach-athlete relationship research supports slow, per-pair bond.

## Scores

**Depth 7.**
- **Real trades:**
  - coach time against the corner's 3 points;
  - which boxer takes the 60 side of a shared pad night;
  - TEACH against POLISH when one boxer has Raw cards and the other Sharp;
  - SHIELD as a free cushion against LIFT, which costs time and strips the cushion from the Steady boxers;
  - which assistant to hire (pads to 74 against conditioning to 86 and sparring to 74);
  - Pay, a day off or no, each priced in coach time;
  - promoting the club coach against keeping the fitness classes;
  - Level 2 after a year.
- **Ties to the rest of the game:** mastery, FireLevel tiers, steps (S463), plan lines, the corner, morale and money.
- **Held at 7:**
  - shared sparring always wins (point 2);
  - coaching a non-FOCUS morning is a loss (point 3);
  - the coach's request is too small to matter (point 4);
  - the worked week's example no longer proves its own fork (point 1).

**General design 6.**
- **Good:**
  - the formulas add up;
  - evenings scale drill units, as the code does;
  - one focus;
  - one over-budget rule;
  - honest tags;
  - 22 wired menus;
  - probes with pass lines;
  - nothing builds before the owner OKs the mockup.
- **Held at 6:**
  - the phase error in 10.3 (point 1);
  - the Strength edge is narrowed without a tag (point 5);
  - the Level 2 fee and away time are wrong, and the assistants' own Level 2 is never stated (point 7);
  - six CHECKs for Claude are still open, two of which can move BALANCE;
  - no probe has run;
  - 22 menus is a lot of surface for one mechanic.

**Play 6.**
- Working by week 2, Trusted by about week 11 with a "Write it" plan line, raise asks, the Level 2 beat after a year, and a Monday line comparing your board to the coach's. These are things to look forward to.
- Most rewards are still multipliers in single digits. TRAINBALANCE caps a full season of TOP fit at +4 to +8 wins in 100, which is right for balance, but the player feels it mainly on the Monday page.

**It meets the owner's bar: 7 / 6.**

## Options: what each changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Drag a coach onto a cell (This week / For good) | Fit on that cell, bond with that pair, coach time | Keep |
| Leave a morning uncoached | Fit 50, no coach time | Keep |
| FOCUS pill (locked to the camp focus in camp) | +10 on one morning area | Keep. Drop the −3 on other mornings |
| Shared pad night, 60/40 pick | Saves 0.5 coach time; the 40 side loses 96 units a night | Keep |
| Shared sparring night | Saves 1.0 coach time, no loss | **Always the right pick; give it a cost** |
| SHIELD / LIFT | Loss −9 for all, or +3 morale a week for Flat boxers at +0.5 time | Keep |
| POLISH / TEACH | Usable and Sharp cards ×1.15, or New and Raw ×1.10 | Keep |
| Rest this week | Wipes borrowing, +3 next week, bond paused | Keep |
| Pay / Give a day off / Say no | +$50 and +1 time, −1 time for good, or the rating held and −1 time for 4 weeks | Keep |
| Promote the club coach | A third coach for +$170; fitness classes and +40 members gone | Keep |
| Send on Level 2 | Sparring opens, +2 coach time, ceilings +5 | Keep, at $289 and 4 days |
| Boxer's ask: Hear / Overrule | ±5 morale and a swap for this week | Keep |
| Coach's request: Grant / Refuse | +3 on one morning, or −2 bond | **Near useless: rework or cut** |
| Pick the corner (fight week strip) | Word taken in 85–105%, 3 coach time | Keep |
| Let go | A week's pay; cover applies | Keep |

**Missing options**
- **Send a member or volunteer on Level 1.** That's a free-wage helper who runs pads and bags, which is how real English clubs grow staff. The real course costs £176–220, about $220–275.
- **Book an outside sparring partner against a shared clubmate night.** This would give point 2 its cost: the outside partner costs $160 but matches the opponent's style.
- **Level 2 for an assistant who lacks it,** if either assistant is Level 1.
- **Copy last week** for the board (held back). Without it, a two-boxer club re-drags every camp week.
- **A cutman or second as a corner helper,** not just a pro-night staff job. An England Boxing corner normally has two seconds. NOT CHECKED this pass, so it's a CHECK (John).

**Useless or empty**
- The coach's request (point 4).
- A coached non-FOCUS morning without a temper match (point 3).
- Menu rows M20 and M21.

## To reach 10/10
1. **Fix 10.3:** make the 65 kg boxer's bout 3+ weeks out so they're in BUILD, rerun A to D with next week's real cost, and only then name the answer. This is the map's proof of choice.
2. **Give shared sparring a cost:**
   - a clubmate can't match the opponent's stance or style, while the $160 outside partner can;
   - the two boxers must sit within one class (5 kg);
   - both take the sparring injury roll.
3. **Run the probes:** FITPROBE1, TRAINBALANCE, BOTSUITE, COACHTIMEPROBE, BALANCE and MORNINGPROBE. Replace the ESTIMATEs in 2.1, 3.3, 6.1 and 8 with the measured numbers.
4. **Close Claude's six CHECKs,** starting with whether both assistants can be hired and which rating `WeekPlan` reads for a pad session (the second can move BALANCE).
5. **Fix mornings:** drop FOCUS's −3, or apply it only to uncoached mornings. Then MORNINGPROBE can pass.
6. **Correct Level 2:**
   - $289 (£231 × 1.25);
   - 4 days away, which can be two weekends;
   - one free retake;
   - mark each assistant as Level 2 on the coach card, since only Level 2 may take sparring;
   - the head coach is Level 2 by club rule (since 1 June 2025).
7. **Tag the Strength edge change as NEW** and put it to the owner, or keep it club-wide as the code has it.
8. **Rework or cut the coach's request.** It should ask for something that matters ("let me corner Saturday", or take an evening) with a real price.
9. **Stop the head coach's bond decaying below Working.**
10. **Add "Send a member on Level 1"** as a cheap way to add coach time: about $250, 4 days away, 4 coach time, no sparring.
11. **Trim the menu table:** drop the empty rows, and merge M7 and M8's hover-only lines into M5, so the build is closer to 15 touchpoints than 22.
12. **Draw M1 at 1920×1080 in two states,** a quiet BASE week and the fixed 10.3 week, for the owner's OK before C13.

## The 10/10 page (1920×1080, Club > People, "Coaches this week", Look B)

**Shell (0–64 px):** the dark top bar shows the gym, "Week 12 · Sat 28 Mar", and cash with "running +$310 a week". The big button reads "CONTINUE: to Mon, the week review", and it is the only green on the page. The left rail sits beside it.

**Header (64–150):** "COACHES THIS WEEK" in marker on cream paper, with Saturday's bout circled in red. Three coach budgets are chalked in: "Assistant 9.5 of 10 · You 2 of 4 · Club coach 8 of 8".

**Left (24–480): coach cards on polaroids.**
- **Sessional assistant:** the name sits on the card header only. Temper Motivator. A SHIELD / LIFT switch with "LIFT +0.5". Ten coach-time pips, one hollow and marked "borrowed". Ceilings: pads 74, sparring 58, conditioning 75. "Next +1 pads in 6 sessions". School chips, a "Level 2" chip, and the wage. A yellow sticky reads "Asks $50 a week: Pay / Give a day off / Say no".
- **You:** four pips, "sessions at 0.81", and the Strength edge.
- **Club coach:** eight pips and "NO SPARRING: LEVEL 1". The button "Send on Level 2 · $289 · 4 days" is greyed, with its reason: "after 52 weeks: 31 to go".

**Centre (500–1440): who runs what.**
- Two boxer rows, each with a portrait, the class in kg, the record and a FOCUS pill. The 60 kg boxer's pill reads "locked: camp" and the 65 kg boxer's reads "Speed".
- Five area cells per row. Each holds a coach magnet, the fit word with a bar ("GOOD 64"), the gain in its own unit ("Jab +2.4", "Speed +0.4") and bond pips.
- Hover is open on one cell, listing the parts: "Trusted +6, LIFT right +4, 0.5 over 0, = 60; slowed by potential".
- A Coach's pad nights row on top shows the 60/40 pick: "−96 units: about −1 Jab for your 65 kg boxer".
- Sparring cells show "Clubmate (free) / Outside partner $160, matches the southpaw".

**Right (1460–1896): on Monday.**
- FOCUS now and after the week ("Speed 62 to 63").
- "Trusted next week with your 60 kg boxer: +1 plan line".
- "Next week 9.5 of 10".
- "Your board this week: +0.3 Speed, +2 Jab over the coach's", in the one gold frame.
- Risks in red, each with its word: "OVER BUDGET", "AT THE COACH'S LIMIT IN ABOUT 5 WEEKS".

**Bottom strip (fight week, 900–1040):** three corner magnets.
- Assistant: "word taken in 90%, costs 3".
- You: "85%, 3 of 4".
- "+LIFT: Flat to Steady by Saturday, 105%".
- Picking one greys the cells it moves for a beat.

**Hard case on the same page:** the club coach's sparring cell is refused, with "NO SPARRING: LEVEL 1", and the assistant's pips run 1.5 over in amber with "Rest next week".

## Sources
- England Boxing, [Level 2 Full Coach](https://www.englandboxing.org/england-boxing-level-2-full-coach/), read 2026-11-15. OFFICIAL: £231, 4 days with assessment on day 4, one year at Level 1 first, one free reassessment.
- England Boxing, [Coaching Rules Policy (Feb 2026)](https://www.englandboxing.org/wp-content/uploads/2026/02/Coaching-Rules-Policy-Updated-Feb-26.pdf), read 2026-11-15. OFFICIAL: "Only a Level Two Full Coach can supervise/take sparring"; a minimum of one year at Level 1.
- England Boxing, [Message to clubs (fees from 1 June 2025)](https://www.englandboxing.org/news_articles/a-message-to-england-boxing-clubs-members-and-coaches/), read 2026-11-15. OFFICIAL: every club needs a Level 2 head coach; Level 1 course £176, Level 2 course £220. The current course page says £231.
- England Boxing, [Level 2 course, London, June 2024](https://www.englandboxing.org/event/england-boxing-level-2-coaching-course-police-boxing-association-june-2022/), read 2026-11-15. OFFICIAL: four days over two weekends, £200.
- Jowett, [The coach-athlete relationship (review)](https://www.tandfonline.com/doi/full/10.1080/1750984X.2024.2416968), read 2026-11-14. MEASURED (review).
- The game prices are DERIVED at £ × 1.25: the course is $289, and Level 1 is about $220–275.
- Every other figure is DERIVED from the critic pack and the map's own formulas.

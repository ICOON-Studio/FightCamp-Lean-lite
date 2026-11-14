# DESIGN_PLANFLOW1_V2_CRITIC_JOHN_JOHN - John answer (seat queue SQ133)

Brief: research/DESIGN_PLANFLOW1_V2_CRITIC_JOHN.md
Sent: 2026-11-14 20:45 | collected: 2026-11-14 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading PLANFLOW1 v2 against the pack now, and checking for real UK corner evidence. Logic comes first, then the scores, options, To reach 10/10 and the page.

# PLANFLOW1 v2: critic

Scores: **depth 7/10, general design 6/10, play 7/10**. It **passes the owner's bar** (6+ and 6+).

v2 fixes v1's main faults:
- The modes are the fight's six.
- Steps carry a real price (the study slot).
- Plan B is one arrow, not a bar.
- Test it costs an evening.
- Answers come from the book only.
- Every shown state is printed as a word.

What holds general design at 6 is a set of smaller faults:
- "found modes" isn't in the opponent's file today, but it's tagged as if it were;
- the price to take a step to Sharp is out of line with the study slot;
- Test it may leak hidden information;
- the timing rules are mixed up;
- some code names leak onto the screen.

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the mockups. I judged from the map and the pack, and checked the England Boxing and IBA scoring rules myself.

Names: the editor header (12.1) names both boxers once, which is allowed. Boxes, diamonds, warnings, the round line and the Why say "your boxer" or "the opponent". I found no fixed he or she. The critic names in section 0 are design notes, not screen text.

## Logic check

**1. "Found modes" is new data, tagged as if it were in the code.**
- The pack's file holds three kinds of hidden fact: the best weapon, each habit and the weakness (4.6). Tape opens them in the order weapon first, weakness last.
- How often the opponent uses each mode isn't a tell anywhere in the pack. So the "free or found" table in 4.1, GUESS, the share bands and the blank branches on the opponent's tree all rest on a new tell type. Only the share count is tagged NEW plus CHECK.
- **Fix:** tag "mode as a tell" NEW and give it a slot in the tape order. My suggestion: weapon, then the opponent's most-used mode, then habits, then the second mode, then the weakness. Then tape days decide how much of the tree an amateur camp can fill.

**2. Film is free inside a camp, so lever 1 only bites without one.**
- The camp's Film (tape study) is free and opens a tell every few camp days (4.3). The Tape Room is in Fight prep.
- So the "costs a pad evening" price applies only to bouts with no camp. Under S428 those are short-notice amateur bouts, where an opponent with no bouts has no tape at all.
- The result:
  - in pro and title camps, film is close to free and GUESS rarely happens;
  - in quick amateur bouts, everything non-free is a GUESS, whatever the player does.
- **Fix:** keep one price for film. A camp's film days take camp nights like a Film evening does, so 4.3's "free" becomes "a camp night". Or state outright that a camp buys tape, and make the camp's intensity the trade.

**3. Taking a step to Sharp is priced faster than the slot that gets it to Usable.**
- The slot gives about 6 a week using the week's pad nights (S463).
- The NEW route, "about 4 weeks on half a pad night" for 30 to 60, is about 7.5 a week on half of one night.
- So the Sharp route is quicker and cheaper than the Usable route. That breaks the "same budget as punches" claim in section 5.
- With pads at 2.1 an hour, half a 75-minute night is about 1.3 a week for a punch. Four weeks gives about 5, not 30.
- **Fix:** take the step pad card rate from the same 240 units a pad night as punches, and print the weeks that gives. Probe 4 (STEPS-ONLY) only means something after that.

**4. Test it may find what film hasn't.**
- 3.5 runs the plan "against the opponent's file" and reports which diamonds fired. If the test uses the hidden real opponent, a GUESS diamond that fires tells the player which mode is real, so one sparring night does a film evening's job and grades the plan too.
- **Fix:** Test it plays against what's known: free modes plus found ones. Unfound modes are drawn evenly and the result is marked "with 2 modes guessed". Or say plainly that a test also opens one tell, and price it the same as film.

**5. The timing rules answer the wrong question.**
- "Slow starter: presses in round 1 only" puts a diamond on the opponent pressing in a round where a slow starter doesn't press.
- "Fades late: from round 3 on the tires diamond" adds nothing, because the tires diamond only fires when the opponent is Tiring anyway.
- What both habits really change is **your** pace by round, and the Playbook already has round-by-round pace (Push / Steady / Save, 4.7).
- **Fix:** cut the round filter. A found "slow starter" suggests Push in round 1, and "fades late" suggests Save then Push. Validate prints it, with no NEW mechanic.

**6. The bell box carries most of the bout, and PlanRead hits it hardest.**
- Lost exchanges return to the opening box (3.3). In a close bout, about half of the 18 exchanges start there: the bell plus every loss.
- PlanRead pays full value for 2 uses a round, so the bell box is the most-worn piece in the plan, while other boxes are rarely reached.
- That's real depth: diamonds belong on the bell box, and a long combination there costs energy every lost exchange. But the editor doesn't show it.
- **Fix:** each box prints its expected uses a round ("about 3 a round, 2 at full"), from the probes. Pass line 6, "4+ exchanges a bout through boxes after a won exchange", is too easy across 18 exchanges, so change it to a share for each box.

**7. Swapping "resets its PRESSURE", but PRESSURE isn't held per piece.**
- In the pack, PRESSURE builds on the **opponent** from right answers that win. There's no per-line PRESSURE.
- **Fix:** either make PRESSURE per line (NEW, a probe) or drop the line. The real cost of a swap is already in the code: the new piece starts fresh, which is a **gain** under PlanRead. So the swap should cost something else, for example taking the minute's one change.

**8. The corner minute already has the plan swap, so don't double it up.**
- Pack 4.8 lists "change one plan arrow" in the corner minute **separately** from ONE CHANGE (a habit fix, Elbows in, Gloves high).
- 7.3 calls the swap "the corner's existing one change" and holds it with "Say nothing / No fix", which belongs to the shouts and fixes.
- **Fix:** M11 is the plan arrow change drawn on the tree, tagged CODE. ONE CHANGE stays its own row, so the player still gets both, as today.

**9. Labels: GUESS and "OK at best".**
- It isn't clear whether a GUESS changes what the line pays, or only what the label says. Probe 10 implies the pay is capped.
- If the code's rating says BEST and the screen says OK, the screen is lying. If the pay is capped, a guess that happens to be right is still punished, which is the real cost of not filming.
- **Fix:** state it as a rule: "an unfound mode's answer pays as OK, even when right", and the hover says why.

**10. Words on the screen.**
- "FixLab's line is outlined" uses a code name. Write "your coach's pick".
- Stage 3's "Holds the plan: 70%" breaks the map's own "no percents" and 7.6. Print the band instead (likely / even / unlikely).
- "Lines 5 of 6": good, and it's one word throughout.

**11. Amateur reuse needs a scope.**
- It doesn't say whether "SEEN: met before" applies only to round 1, since PlanRead resets at the bell, or to every round.
- Amateur rematches are rare at club shows, so this has little weight either way.
- **Fix:** round 1 only. Then it's a fair, small punishment that a fresh opening box can dodge.

**12. CHECK (John), answered with the real rule.**
- England Boxing (Rule Book 2023/24, 12.10.1): a club coach who wants the scores must ask the Supervisor in writing within 20 minutes of the **end** of the bout, and gets the bout totals only, in random order.
- IBA rules (2022, 18.8): judges' round scores "must not be disclosed or displayed until the winner of the Bout is announced".
- So amateur corners never see the cards during a bout. "We think we're ahead" as your coach's own count is right.
- Whether UK corners formally keep their own count: no written source. It's coaching practice, NOT FOUND as a rule.
- That makes owner question 2 ("last round, behind on your coach's count") real, but only as a trigger that can be wrong. Keep it in stage 3 with the uncertainty printed.

## Scores, with reasons

**Depth 7.**
- Every piece pulls on a budget the rest of the game already has:
  - pad time and the single study slot (training);
  - film evenings (the week);
  - a sparring night per test (camp phases: no sparring in TAPER);
  - line slots (the coach you hired);
  - SEEN (the pro career).
- Seven levers come from causes the fight already has, so no plan shape dominates:
  - film is the route to BEST against an unfree mode;
  - share is a bet between a strong answer on a rare mode and a fair one on a common mode;
  - PRESSURE rewards a diamond that fires early;
  - PlanRead caps any one line;
  - a wrong diamond costs more than an empty one;
  - drilling is the budget;
  - SEEN punishes a pro's one favourite punch.
- The bell box carrying most of the bout (point 6) is a real trade the player has to find.
- Held to 7: in camps, film is close to free (point 2), and quick amateur bouts are mostly GUESS whatever the player does, so the found-mode bet only works in the middle of the range.

**General design 6.**
- Good:
  - one Plan B;
  - answers from the book only;
  - every state printed as a word;
  - menus wired to code files;
  - a stage cut that follows S469;
  - probes with pass lines;
  - every critic point answered or openly declined.
- Held to 6:
  - found modes are new data tagged as code (point 1);
  - the step rate to Sharp is out of line with the slot (point 3);
  - Test it may leak (point 4);
  - the timing rules are wrong (point 5);
  - per-piece PRESSURE doesn't exist (point 7);
  - the swap is mixed up with ONE CHANGE (point 8);
  - FixLab on screen and a percent in stage 3 (point 10).
- All of these are fixable without changing the structure.

**Play 7.**
- Three real beats:
  - filling the opponent's tree film by film before the bout;
  - the corner minute, with "Presses: never fired" at the top of the swap list;
  - "The plan, lit up" afterwards, with counts for each piece.
- The section 10 failure path is the best teaching moment in the map. It has no rigged roll and points to a fix the player can make.
- Stage 1's live round is passive: the strip only reports. The play lives before the bout and in the minute.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Coach's preset at booking | Free-mode plan, about +3 to +7 over none | Keep |
| Film evening | One tell, −1 pad night | Keep. Price camp film the same (point 2) |
| Scout ($250, pro) | Weapon and weakness | Keep |
| Study slot (one step to 30) | Steps become plannable | Keep |
| Step pad cards to Sharp | A step fires 3 in 4 | Keep. Re-price from units (point 3) |
| Boxes (one per place) | What your boxer does after a won exchange | Keep. Show expected uses (point 6) |
| Diamonds (one per mode per box) | What to do when a mode holds | Keep |
| GUESS diamond | Pays as OK | Keep. State the pay rule (point 9) |
| Diamond order number | Which of two diamonds fires | Keep only if the CHECK shows two modes can hold at once. Otherwise **useless** |
| Round filter on a diamond | Nothing that the mode and pace don't already do | **Useless** (point 5) |
| Tray, drag to pad night | Mastery for the plan's pieces | Keep |
| Test it (a sparring night) | A worth band and fire counts | Keep. Test against what's known only (point 4) |
| Validate | Warnings, no score | Keep |
| Lock at the first bell | Edits allowed until the fight | Keep |
| Load saved plan / Copy a team-mate's plan / × clear one / Start again | Starting points | Keep. Copying by opponent is near useless (team-mates rarely share an opponent), so copy by style |
| Corner swap (REPLACE / REMOVE / no change) | One plan piece a round | Keep, as the CODE arrow change beside ONE CHANGE (point 8) |
| "Go for the finish" beats a hurt diamond | Order of rules | Keep |
| Save to this opponent's file | Rematch | Keep |
| Amateur reuse SEEN | The most-used line pays as a third use | Keep, round 1 only (point 11) |

**Missing options:**
- **Expected uses on each box,** so the player can see the bell box carries the bout (point 6).
- **"Ask your coach to rewrite with the film so far"** (one press, with the line cap): the free middle path between the preset and writing it all by hand. The pack's assistant already writes plans.
- **Pace link from a found habit** (slow starter or fades late) to the Playbook's round pace, in place of the round filter.
- **In the corner minute, "Show me the opponent's mode count this round"** ("pressed 1 of 6 exchanges"). It's the information the swap needs, and the fight already decides the mode every exchange.

## To reach 10/10

1. **Make "the opponent's mode" a new tell type** with a place in the tape order (weapon, then the top mode, habits, the second mode, the weakness). Tag the tree, GUESS and the share as built on it.
2. **One price for film:** camp tape days take a camp night, the same as a Film evening. Otherwise found modes are free in every camp.
3. **Re-price step pad cards** from the 240 pad units at the punch rate. Print the weeks from 30 to 60, and run STEPS-ONLY after.
4. **Test it plays against the known file only,** with unfound modes drawn evenly and the result marked "n modes guessed".
5. **Write the GUESS pay rule** ("pays as OK, even when right") as a rule with a hover.
6. **Cut the round filter.** Found slow starter and fades late suggest round pace in Validate.
7. **Each box prints its expected uses a round** and how many pay in full (PlanRead). Change pass line 6 to a minimum share for each box.
8. **M11 is the plan arrow change (CODE),** separate from ONE CHANGE. Drop "resets its PRESSURE", or probe a per-line PRESSURE first.
9. **Replace "FixLab" with "your coach's pick",** and stage 3's "70%" with a word band.
10. **Amateur reuse SEEN applies in round 1 only.**
11. **Add "Your coach rewrites it"** (one press, using the found tells) and the corner minute's mode count.
12. **Run probes 1–8, 10 and 11,** then replace every ESTIMATE in 5, 6.3 and 7.5.
13. **Settle the Claude CHECKs:** habit as `when`, two modes at once, FireLevel for steps.
14. **Stage 2's aimed shout** makes the live round something you do, not something you watch. Stage 1's strip stays a report.

## The 1920×1080 page (Fighter > Playbook > Game plan, Look B whiteboard)

**Header (0–120):** your boxer's polaroid on the left and the opponent's on the right, each name once; 60 kg, the style words, the stances; "bout in 18 days". The dark top bar holds CONTINUE, the only green.

**Left (40–440), THE FILE as a tree:**
- The bell place at the top and six mode branches.
- **Tires and Hurt** are marked FREE.
- **Presses** is FOUND, "3 of 4 films · often".
- **Waits to counter** is blank, "not seen yet: 1 Film evening (−1 pad night)".
- The red "biggest hole" box appears only once the weakness is found.
- A pace sticky, "Slow starter: Push round 1", with Use it.
- At the foot: Film evening, Your coach rewrites it, Load the saved plan (only if one exists).

**Centre (480–1440), the chart:**
- The bell box at the top is the biggest card. It prints the move, "SHARP 64 · fires 3 in 4 · +2.1" and "about 3 uses a round, 2 in full".
- The boxes by place hang below it, joined by marker arrows labelled with places. Thin grey arrows run back up, labelled "lost: back here".
- Each diamond sits right of its box and prints the mode, the answer, BEST / OK / WRONG / GUESS, the share band, and an ×.
- A Raw piece carries a red stamp, "UNDER 30: SKIPPED".

**Right (1480–1880), WHAT IT COSTS:**
- Lines 5 of 6.
- Drill cards 7 against pad nights 5.
- Study slot: pivot out, 2 weeks to 30.
- Film evenings 2.
- The Validate list, one line a warning.
- The last test, "+6 to +10 over no plan · 1 mode guessed", in gold (the one gold).

**Bottom (980–1060):** Validate, Test it in sparring (Thu), Save, Clear.

**The corner minute (M11) uses the same chart, dark:**
- **Left:** the counts ("Body hook fired 3, won 2"; "the opponent pressed 1 of 6") and "we think we're ahead".
- **Centre:** the chart with dead diamonds outlined, REPLACE or REMOVE.
- **Right:** the bench with fire rates, and your coach's pick outlined.
- Below, separately, the ONE CHANGE row as today.

## Sources
- England Boxing, [Rule Book 2023/24](https://www.englandboxing.org/wp-content/uploads/2023/09/Rule-Book-Final.pdf), read 2026-11-14. OFFICIAL:
  - 12.10.1: a club coach gets the bout score totals only, on a written request within 20 minutes of the end of the bout, in random order;
  - 11.1.7: with manual scoring, the round scores go to the Supervisor between rounds, not to the corners.
  - I didn't check the 2026 edition's numbering for these clauses.
- IBA, [Technical and Competition Rules](https://www.iba.sport/wp-content/uploads/2022/09/20220901-IBA_Technical__Competition_Rules.pdf) (2022), read 2026-11-14. OFFICIAL, 18.8: the judges' round scores "must not be disclosed or displayed until the winner of the Bout is announced".
- Whether UK amateur corners keep a formal count of their own: NOT FOUND.
- All other figures are DERIVED from the critic pack (4.2 pad rates, S463 slot rate, PlanRead, FireLevel, 59/45/41) and the map's own numbers.

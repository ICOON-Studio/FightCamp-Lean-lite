# DESIGN_COACHFIT1_V7_CRITIC_JOHN_JOHN - John answer (seat queue SQ125)

Brief: research/DESIGN_COACHFIT1_V7_CRITIC_JOHN.md
Sent: 2026-11-14 18:40 | collected: 2026-11-14 19:12 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading COACHFIT1 v7 against the pack now. Logic first, then the scores, options, To reach 10/10 and the page.

# COACHFIT1 v7: critic

Scores: **depth 6/10, general design 5/10, play 6/10**. It **misses the owner's bar** by one point on general design.

v7 is far tighter than a typical map. It has one formula for fit, honest marks, a full wiring table and probes with pass lines. What holds design at 5:
- the evening half of the system trains stats, but in code evenings train move mastery;
- the worked bout week, which is meant to prove the choice, has arithmetic that doesn't hold;
- "focus" now means three things;
- release 1 may have only one assistant, and most of the depth needs two.

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the mockups. I judged from the map and the pack.

Names: rows, Monday lines and menu text keep to S448. The names appear only in table 9.1 of the design doc ("Sessional assistant: Luke Reid"), which is fine for a doc but must never reach a screen. I found no fixed he or she (S412).

## Logic check

**1. Evenings train moves, not stats. This is the biggest fault.**
- In the pack (4.1, 4.2, S448), each morning adds a small amount to one stat. Pad and sparring nights carry drill cards and raise move mastery: 240 units a pad night, 180 shared on a sparring night.
- Table 3.1 maps Pads evenings to Accuracy and Timing, and Sparring to Defence and Inside fighting. 10.3 then prices pad nights in "+1.0 Accuracy". That's a new stat gain on evenings that the code doesn't have, and it isn't tagged NEW.
- **Fix:** fit multiplies the **drill units** on evenings (240 × 1.14 at GOOD) and the **stat gain** on mornings. Then fit feeds FireLevel (Usable 30, Sharp 60), which ties coaches to the plan. The better design was already there for free.

**2. The worked bout week (10.3) doesn't add up, and it's the map's proof of choice.**
- **Answer C doesn't reduce the assistant's load.** The assistant's 10 is pads 3.0, lone pad 1.0, sparring 3.0 and corner 3.0. The two Hard weights mornings were never in it. Moving them to the head coach leaves the assistant at **10 of 8**, not 7. For C to work, the head coach has to take an evening: a sparring night (1.5) plus the lone pad night (1.0) gives 7.5 of 8 and 2.5 of 4.
- **Fit 46 is MIXED, not RISKY.** The fit table puts RISKY under 40. And 0.96 ÷ 1.14 gives +0.84, not +0.86.
- **The "word taken in" figures ignore morale.** The fighting boxer is Flat, so trust is 0.85 before anything else:
  - A or C: 0.85 × 1.004 × 1.00 = **85%**, not 100%;
  - B: 0.85 × 1.004 × 0.95 = **81%**, not 95%.
  The Flat boxer is the reason LIFT is in the example, so the example has to show the 85%.
- The shared pad nights split the PEAK boxer's pad units 60/40 in its hardest week, and no answer prices that.

**3. "Focus" now means three things.**
- There's the signing "starting focus", the camp focus (Conditioning, Power, Technique, Defence, Speed: the old summary stat names), and the new FOCUS pill.
- In camp, the camp focus and the FOCUS pill can point at different stats.
- POLISH and TEACH also test "the boxer's FOCUS moves", but FOCUS is a stat, so FOCUS moves aren't defined.
- **Fix:** one word per concept. In camp, the FOCUS pill **is** the camp focus, locked to it. Outside camp, it's the pill. Rename the camp list onto Attrs names. The mode test reads the moves on this week's drill cards.

**4. The head coach and the cheap third coach.**
- Pack 5.7 shows two hire cards when there's no assistant, "Hire Luke / Hire Marcus", which reads as one or the other. If the CHECK finds only one assistant can be hired, release 1 is one assistant plus you (4 coach time). Then the mode forks between coaches, swaps, the second-best corner and the shared-night pick mostly disappear.
- **Fix:** answer that CHECK before scoring v8. If it's one assistant, make the promoted club coach the release 1 second coach and design for that pair.
- The head coach is a Stranger to every boxer on day 0, though they're the owner who signed them. Start the head coach's pairs at Working.

**5. The promotion breaks England Boxing's real rules.**
- A Level 1 Assistant Coach "cannot take sparring", can only assist under a Level 2, and "can corner a boxer in competition". Level 2 needs at least one year at Level 1.
- The promoted club coach should:
  - corner (allowed);
  - run pads, bags and conditioning;
  - **not** run sparring nights, until a Level 2 step at least 52 weeks later.
- That's a real, cheap second coach with a limit you plan around, and a second growth beat (the Level 2 course).

**6. The raise pays for a ceiling nobody reaches in season one.**
- Coach factor stays on the overall rating (4.2), so growth only moves the teaching ceiling. The map's own day-one note says boxers at 55–65 are almost never taught out against ceilings of 75–86.
- So paying $50 a week buys nothing for about a year, and refusing costs only −1 coach time for 4 weeks. Refusing is the dominant early answer.
- **Fix:** a raise also adds coach time (+1), or a paid pair grows bond 25% faster. Or area growth also lifts the coach factor in that area only, with BALANCE probing it.
- **The raise money is wrong.** $100–150 a week is about 12–19 members at $35 a month ($8.08 a week each), not 30–45.
- **The pace is wrong.** +1 per 15 pad sessions at about 6 a week gives a raise every 12.5 weeks, so about 4 asks a year, not 2–3. If "every 5 area points" sums across areas, it's more. Say per area or summed.

**7. Borrowing coach time can spiral.**
- 10 of 8 leaves next week at 6, and a PEAK week at 6 goes over again.
- Fractions aren't covered: is 0.5 over −8 or nothing?
- **Fix:** at most 2 borrowed. 0 to 0.5 over is free, up to 1.5 over is −8, and over that is −18.

**8. Quarrels have no source in release 1.**
- Only the Drill sergeant quarrels, and it's release 2. Yet the quarrel need (M3), the QUARREL RISK tag, three quarrel answers and an ASKS1 test are all release 1.
- **Fix:** move them to release 2, or give the Technician a release 1 clash (a coachability-under-30 boxer in POLISH: 1 in 8 a week).

**9. Modes: SHIELD barely counts, and the Motivator lowers fit for Steady boxers.**
- With no Flat or Low boxer, LIFT is "wrong" (−4), so the player must toggle to SHIELD every week. SHIELD's "price" ("Flat and Low get nothing extra") isn't a price, and whether twist cards cost morale at all isn't in the pack.
- **Fix:** let SHIELD be the Motivator's base state at 0, with LIFT as a paid boost. Or give SHIELD a real job: halving the morale cost of a loss for every boxer, at 0 coach time.
- TEACH's "+2 on a move one session from its tier" is a cliff the player can't see. Drop it and keep ×1.10.

**10. Gaps against the stats and the code.**
- **Film evenings** sit under Pads and train Accuracy and Timing. In code, Film opens tells. If it gives anything, Fight IQ fits.
- Flexibility, Fight IQ, Composure and Heart are in no area.
- **Steps (S463 `StepMastery`)** are learned in the study slot on pad nights at about 6 a week. Fit should multiply that too, and the map never mentions it.
- The extra plan line from Trusted does nothing when the coach already gives 6. Say "+1, up to 6", or let Trusted raise the cap to 7.
- The 0.50 floor on word taken in never binds: the lowest is 0.70 × 0.90 × 0.95 = 0.60.
- Rounding: 55 + 90 × 0.35 = 86.5, and the map gives 86. 55 + 45 × 0.35 = 70.75, and it gives 70. Pick one rounding.

**11. Fit could beat the plan, against the game's own rule.**
- FITPROBE's target of 10–13 more points on the FOCUS stat over 26 weeks is close to the pack's "10 points better wins about 95%" (that's on overall stats, but still).
- BALANCE only checks the corner, not the training.
- **Fix:** add a probe that TOP against average fit over a season moves bout wins by no more than the plan does (+14 in 100). Run it with the pack's headroom clamp, which will eat part of the gain.

**12. A second weekly page.**
- The Week tab per boxer stays, and M1 adds a club-wide board in an Office app that's AGREED, NOT BUILT and has no mockup the owner has OK'd.
- Pack 7: screens come only from agreed mockups, and weekly jobs mustn't turn into chores.
- **Fix:** the coach's default must be good enough that a player who never opens M1 loses nothing (BOTSUITE's other side). Get the owner's OK on a mockup of M1 before building.

**Real-world support:** Jowett's 3+1Cs research (closeness, commitment, complementarity, co-orientation) ties good coach-boxer relationships to faster skill learning and reaching performance goals. That backs bond as a slow, per-pair track that pays in learning.

## Scores, with reasons

**Depth 6.**
- Real trades:
  - coach time against the corner's 3;
  - who gets the 60 on a shared night;
  - a mode that favours one boxer over another;
  - leaving a morning uncoached when the fit is poor;
  - bond you lose by swapping;
  - a raise against a coach who works less.
- It touches training, mastery, the plan, the corner, morale and money.
- Held to 6:
  - refusing raises is dominant in year one (point 6);
  - SHIELD barely counts (point 9);
  - quarrels have no source in release 1 (point 8);
  - with one assistant, most forks collapse (point 4).

**General design 5.**
- Good: one fit formula, honest CODE, NEW and ESTIMATE tags, 21 wired menus, probes with pass lines, and the v6 faults fixed.
- Held to 5:
  - evenings train stats against the code (point 1);
  - the showcase week's arithmetic is wrong in three places (point 2);
  - focus means three things (point 3);
  - the raise money and pace are wrong (point 6);
  - borrowing can spiral (point 7);
  - quarrels are built with no cause (point 8);
  - Film and steps are left out (point 10).
- Fixing points 1 to 3 alone would take it to 6.

**Play 6.**
- Working in 2 weeks, Trusted near week 11 with a visible plan line, asks and raises on the Monday page, and the Why naming what the fit won: all good reasons to come back.
- But the moments are small multipliers on numbers. The one live decision (the bout week) is muddied by its own example.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Drag a coach onto a cell (This week / For good) | Fit on that cell; bond builds with that pair; coach time | Keep |
| Leave a morning uncoached | Fit 50, no coach time | Keep. A real answer when fit is RISKY |
| FOCUS pill | +10 fit in that area | Keep, but merge with camp focus (point 3) |
| Shared pad night, pick the 60 side | Saves 0.5 coach time; the 40 side loses about a fifth of its pad gain | Keep |
| Mode switch (LIFT/SHIELD, POLISH/TEACH) | Whom the coach favours this week | Keep POLISH/TEACH. SHIELD is **nearly useless** as written (point 9) |
| Rest this week | +3 coach time next week, no sessions | Keep. It's the cure for borrowing |
| Pick the corner | Word taken in against coach time | Keep, with the morale term shown |
| Pay / Say no to a raise | $50 a week against −1 coach time | Keep, but paying needs a year-one payoff (point 6) |
| Let go (a week's pay) | Frees the wage; cover takes the cells | Keep |
| Promote the second club coach | A cheap third coach; fitness classes stop | Keep, with the England Boxing sparring limit (point 5) |
| Boxer's ask: Hear / Overrule | ±5 morale, swap this week | Keep |
| Coach's request: Grant / Refuse | +3 fit on one cell; refusing costs nothing | **Near useless.** Grant is always right. Give it a cost (it takes 0.5 coach time from another cell) or cut it |
| Quarrel answers | Bond and morale costs | **Useless in release 1** (point 8) |
| Twist card "Assistant off sick" | Cover choice | Keep |
| Interview line "Best fit: the pads coach" | Nothing to act on at signing | **Useless** under the pack's rule. Move it to the boxer's first Monday |

**Missing options:**
- **Drill a step with a chosen coach:** fit on the S463 study slot.
- **Send the club coach on the Level 2 course:** about 52 weeks after promotion, a fee, and it opens sparring nights.
- **Take a boxer yourself as head coach for good:** a head coach bond track starting at Working, with a visible cost in office time.
- **Pay with time, not money:** a raise answered with "+1 day off a week" (−1 coach time for good, no cash). That's a real UK club answer for volunteers.
- **Forgive the borrowed time:** the Rest this week button shown on the over-budget need itself.

## To reach 10/10

1. **Fit multiplies drill units on evenings and stat gain on mornings.** Remove the evening-to-stat map. The Monday line says "Jab 41 to 47: good fit with the pads coach". Fit then speeds FireLevel tiers.
2. **Rewrite 10.3 so it adds up.** Under C the head coach takes the lone pad night and one sparring night (7.5 of 8 and 2.5 of 4). Print the word taken in with Flat morale (85% Working, 81% Stranger) and the LIFT case that crosses to Steady (100%). Fit 46 is MIXED. Price the PEAK boxer's 60/40 split.
3. **One focus.** The FOCUS pill is the camp focus in camp. Camp focus uses Attrs names, and mode tests read this week's drill cards.
4. **Answer "can both assistants be hired" before v8.** If not, design release 1 for one assistant plus the promoted club coach plus you.
5. **The England Boxing rule for the promoted coach:** pads, bags, conditioning and corner, no sparring nights. A Level 2 course after 52 weeks, for a fee, opens sparring (+2 coach time, teaching ceiling +5).
6. **Give the raise a payoff in year one:** paid means +1 coach time for good, or bond grows 25% faster with that coach. Fix the cost line to "about 12–19 members" and the pace to 3–4 asks a year per area, or sum across areas and say so.
7. **Cap borrowing at 2.** Up to 0.5 over is free. The over-budget need carries the Rest this week button.
8. **Quarrels:** move them to release 2, or give the Technician a release 1 clash with a printed chance.
9. **Modes:** SHIELD is the free base and LIFT a +0.5 boost. Remove TEACH's +2 cliff.
10. **Fill the gaps:** Film gives Fight IQ or nothing. Fit applies to the step study slot. "+1 plan line, up to 7" for Trusted. Drop the 0.50 floor. One rounding rule.
11. **A balance probe on training:** a season of TOP fit against average must not move bout wins more than a good plan does (+14 in 100), with the headroom clamp on.
12. **The head coach starts at Working** with every boxer the club signs.
13. **The owner OKs a mockup of M1 before build.** BOTSUITE also checks that a player who never opens M1 loses under 2 wins in 100.

## The 1920×1080 page (Office > Staff, "Coaches this week", Look B whiteboard)

**Dark top bar (0–64):** the week, the bout circled ("Sat, 60 kg"), cash, and CONTINUE in green, the only green on the frame.

**Left column (32–452), coach cards on cream paper:** three magnets stacked, each 128 px tall.
- The name in the card header, once, then the portrait and role (sessional assistant, head coach, club coach).
- The temper word with an icon, and the mode switch (SHIELD | LIFT +0.5).
- Coach time pips "7.5 of 8", with hollow pips for borrowed and a cap mark at 2.
- Teaching ceiling per area as five short ticks, and the school as five move chips.
- Growth: "Pads 76 · next +1 in 6 sessions".
- The wage, then **Rest this week** and **Let go**.
- When asked, a yellow sticky: "Asks +$50: +1 coach time for good · Pay / Say no".
- The club coach card shows "No sparring nights (Level 1)" and **Send on the Level 2 course**.

**Centre (484–1436), who runs what:** one row per boxer, 96 px each.
- The portrait, "60 kg", the record and the FOCUS pill (locked to the camp focus during camp).
- Seven evening and seven morning slots folded into five area cells, each with:
  - the coach magnet, the fit word and a 0–90 bar;
  - the gain in its real unit ("+58 units Jab" for an evening, "+0.4 Speed" for a morning);
  - bond pips;
  - at most one tag (OVER BUDGET, TAUGHT OUT IN 4 WEEKS, NO SPARRING: LEVEL 1).
- Hovering a cell lists every fit part and the binding ceiling.
- The shared pad night is a split magnet with a 60/40 handle and "−0.3 of a pad night for the 40 side".

**Right column (1468–1888), on Monday:**
- Each boxer's FOCUS number now and after the week.
- Bonds crossing a step ("Trusted next week: +1 plan line").
- Next week's coach time per coach.
- Risks in red.
- The one gold frame on the week's best gain.

**Bottom strip (fight week only, 880–1040):** the corner choice as three magnets.
- **Assistant:** word taken in **85%** (Flat · Working), costs 3, which leaves "the 65 kg boxer's lone pad night to the head coach".
- **Head coach:** **81%**, costs 3 of 4.
- **LIFT this week:** "+3 morale, Flat to Steady by Saturday: 100%".
- Picking one moves the cells it displaces, shown greyed for a beat.

**Pairs with:** the Week tab card showing the same coach face and fit word, and the Monday lines in the real unit.

## Sources
- England Boxing, [Coaching Rules Policy (Feb 2026)](https://www.englandboxing.org/wp-content/uploads/2026/02/Coaching-Rules-Policy-Updated-Feb-26.pdf), read 2026-11-14. OFFICIAL: a Level 1 Assistant Coach can't take sparring or run a club and can corner in competition; Level 2 needs a minimum of one year at Level 1.
- England Boxing, [Coaches](https://www.englandboxing.org/coaching/), read 2026-11-14. OFFICIAL: three levels; Level 1 is a 4-day course and assists ringside and in supervised sparring.
- England Boxing, [Coaching Handbook Part 1](https://www.englandboxing.org/wp-content/uploads/2026/02/EB_Boxing-Coaching-Handbook-Part-1_09_02_26.pdf), read 2026-11-14. OFFICIAL: Level 1 delivers bags and pads, warm-ups and circuits.
- Jowett, [The coach-athlete relationship within a cross-boundary team of experts](https://www.tandfonline.com/doi/full/10.1080/1750984X.2024.2416968), read 2026-11-14. MEASURED (review): good-quality relationships are linked to learning skills and reaching performance goals.
- Real sessional coach pay rises (the $50): NOT FOUND, not researched this pass.
- All other figures are DERIVED from the critic pack and the map's own formulas.

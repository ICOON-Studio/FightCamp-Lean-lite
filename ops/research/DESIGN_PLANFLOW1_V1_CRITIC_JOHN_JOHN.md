# DESIGN_PLANFLOW1_V1_CRITIC_JOHN_JOHN - John answer (seat queue SQ119)

Brief: research/DESIGN_PLANFLOW1_V1_CRITIC_JOHN.md
Sent: 2026-11-14 15:29 | collected: 2026-11-14 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading PLANFLOW1 v1 against the pack now. Logic first, then the scores, options, To reach 10/10 and the page.

# PLANFLOW1 v1: critic

Scores: **depth 6/10, general design 5/10, play 7/10**. It **misses the owner's bar** by one point on general design.

The core idea is right: draw the plan the game already has as an if-then chart, not a second system, and make the film nights the price of the best answers. What holds it back:
- the step answers cost nothing and always work, which breaks the map's own pad-time budget;
- the IF list mixes up the opponent's modes with the habits on file;
- three depth levers are tagged CODE but the pack says they aren't built;
- most amateur bouts no longer have a camp to watch film in.

I couldn't open `CRITIC_ACCESS.md`, the board or the mockups, because your computer is offline, so I judged from the map and the pack.

Names: the map keeps to S448 and S412. Names appear only in the two header polaroids and the scorebug, and I found no fixed he or she. One tidy-up: the doc's own title line carries the author's seat name, which is fine for a file but must not reach a screen.

## Logic check

**1. The step answers are free and always fire. This is the biggest hole.**
- S448 says the step and defence answers (step back, pivot out, cut off, herd, feint, tie up and the rest) are `StrikeMap` arrows. They have no mastery and always work in full. FireLevel (S451) only applies to punches and combinations.
- In section 3.1, at least one "best" answer in nine of the ten rows is a step: step back, pivot out, cut off, herd, feint, tie up.
- So a plan built from steps never gets a red stamp, never uses a pad night, and fires 4 in 4. That breaks lever 4 ("pad time is the budget"), and in practice it's the dominant plan. Probe 4 would catch it, but the design should close it first.
- **Fix:** give steps mastery the way punches have it, drilled on pads or shadow (shadow gains 0.85 an hour, CODE). Or keep steps at full strength but cap them at one diamond. The first fix is cleaner and matches how real footwork is drilled.

**2. Two different things are both called "IF".**
- The pack has two layers:
  - **Modes**, the way the opponent is fighting this exchange. There are six (Pressing, Boxing at range, Waiting to counter, Loading up, Tiring, Hurt), shown live as a clue.
  - **Habits** on the file, found by tape. The code's examples are drops the right after the jab, slow starter, fades late, chases the stoppage.
- The map's ten IFs are the six modes plus four new ones: shells up, circles away, switches stance, bites on feints. Those four aren't modes the fight can be in. Adding them is fight-engine work (new modes in PlanFight with their own odds), not the "tell name" CHECK the map files them under.
- And the habits that do exist in code are missing from the IF list.
- **Fix:** keep the six modes as the IFs, with a free or found rule, and turn the real habits into modifiers:
  - "drops the right after the jab": a found IF whose answer counters over the jab;
  - "slow starter": a round 1 IF;
  - "fades late": tires from round 3;
  - "chases the stoppage": a hurt-bait IF.
  These already exist and need no new mode.

**3. The found-only rule takes away something players can do today, and the map tags it as CODE when it's NEW.**
- Today any plan can say "when the opponent presses, step back", with no film (Playbook 4.7).
- The map gates every non-free situation behind film. That gate is the map's main depth lever, and it's a good one, because film then costs pad time. But it's a new rule.
- The style word is free at booking, so the "free for this style" mode gives a fair floor.
- **Fix:** tag it NEW and price it. Keep "Rate against another kind of opponent" for practising without a bout ("No bout booked: try the plan against each kind of opponent", agreed in section 6).

**4. Three levers are tagged CODE, but the pack says they aren't built.**
- The opponent adjusting by round 2 is "AGREED, NOT BUILT" (4.7).
- A corner waiting for your best line (the map's ProRead) is "measured and NOT in the game" (4.2): it cost 7 wins in 100, and no answer won back more than 3.7.
- Section 4.3 and probe 4 lean on both of them.
- If Claude's S469 brief found them in code, the pack needs updating. If not, they're a build with a known balance problem: no answer wins back more than 3.7 of the 7 lost.
- **Fix:** tag both as the pack does, and add a probe for the ProRead answer (rotate the read diamond) so it can win back at least half.

**5. The baseline numbers don't match the pack.**
- The map says 59, 46 and 43 "of close bouts". The pack says 59, 45 and 41, in one matchup.
- Probe 1's +12 over no plan is about what a good plan already gives (+14).
- The real step up the map asks for is GOOD at 62–66. That's a stronger plan, so probe 8 (a 10-point stat gap still wins 90%+) has to hold against the more powerful plan.
- **Fix:** use the pack's figures, say "one matchup", and run the probes across the six styles.

**6. Most amateur bouts have no camp, so they have no film.**
- Since S428, amateur bouts don't need a camp and can come within a week. S451 makes the week before any booked bout TAPER.
- The decision flow starts at "Camp, film study". So for a short-notice amateur bout there's no film, no found IF, and the plan is the preset plus free modes. That's most of the early game.
- **Fix:** Film as an evening on the Week is already in code (Rest, Pads, Sparring, Film). Let a Film evening open a tell whenever a bout is booked, camp or not, and let the Tape Room run from Fight prep without a camp. An opponent with no bouts has no tape (CODE), and that stays.

**7. Plan B is box 1 drawn twice.**
- The map shows it honestly: a lost exchange goes back to the opponent's card, which is the opening card, so Plan B is the opening box's any-time arrow.
- Box 1 also sits on the opening card. So "Set Plan B" in section 1 and the Plan B bar edit the same arrow as box 1.
- **Fix:** drop "Set Plan B" as a decision and the bar as a second control. Draw the return arrow from every box to box 1, labelled "lost: back here". If `when: lost_last` is cheap, that's the real Plan B, and it belongs in v1, not v2.

**8. One word is used for three things.**
- "Reads" means your edge over the opponent in a round (the pack calls it PRESSURE).
- "ProRead" and "they've read it" mean the other corner reading your plan.
- "Expects the body" pips are a third kind of pip.
- **Fix:** use PRESSURE for your edge (the pack's word), "seen" for the corner reading your plan, and make the bait pips a kind of PRESSURE with a target, as 5.4 half-says already.

**9. Answers name moves the game doesn't have.**
- "Jab to the body", "feint low + cross over the top", "let the hands go (1-2-3-2)", "front headlock" (BJJ) and "the finishing combination your boxer owns" aren't moves or combinations in the book.
- "Let your hands go" is a corner call, not a move.
- **Fix:** every answer is a book move, a book combination or a `StrikeMap` arrow. A new one goes in as NEW content with its own pad mastery.

**10. Slot counts disagree with each other.**
- v1's editor allows 4 boxes and 3 IFs, which is 7.
- v2 starts a green boxer at 3, and today the coach sets 4–6 lines.
- So v2 cuts a fighter's plan from v1's 7 to 3, and v1 already beats the coach's cap.
- **Fix:** v1 keeps the coach's 4–6 as the slot count, with boxes and IFs sharing it. v2 adds the fighter's bouts and Fight IQ on top, capped at 7.

**11. Limited tests are scarcity the game can't explain.**
- "Tests left 2 of 3" has no source and no refill.
- **Fix:** a test costs a sparring night. The sparring night already spreads 180 units over the plan's moves (S448), so testing also drills the plan. It's a real trade against a pad night, and it's honest.

**12. The lock at the weigh-in only takes something away.**
- In code the weigh-in is the day before; in real amateur boxing it's 1 hour before.
- Locking the plan there adds a rule with no choice in it, since the corner minute changes one arrow anyway.
- **Fix:** lock at the first bell.

**13. BJJ ships at launch but lands in v3.**
- No-gi is BUILT and ships beside boxing.
- **Fix:** v1 draws the BJJ positions as boxes over the existing BjjTree with the two free IFs (stalls, tires). The found BJJ habits come once the 3-beat check passes.

**14. The live panel works against "dark and tight".**
- The agreed fight night cuts the minute to three rows of stats. A 620 px flowchart beside the shout bar is a second thing to read every 30 seconds.
- **Fix:** live, show only the box in play and a FIRED flash with its count, at about 300 px. The full chart lives in the corner minute and "The plan, lit up".

**15. The cut trigger and "behind on the count".**
- A cut, or the eye closing, already has a state for the cutman card (R28, agreed). That's the safe hook for a cut IF.
- The John CHECK on whether UK amateur corners keep their own round count: I haven't sourced it this pass, so treat it as NOT FOUND.
- A trigger off the corner card's own count is still honest as written, because the map labels it "can be wrong". I'd keep it.

## Scores, with reasons

**Depth 6.**
- Real trades:
  - a film night costs about 240 drill units and buys a found IF;
  - habit share is a bet (a strong answer to a rare habit against an ok answer to a common one);
  - an early IF is worth more, because pressure builds through the round;
  - a wrong IF costs more than an empty one, since the energy ceiling shrinks.
- It ties into training, the Tape Room, the corner minute and the Why.
- Held to 6:
  - step answers are a free dominant pick (point 1);
  - the adjust and corner-read counters aren't built, and one has a measured balance problem (point 4);
  - short-notice amateur bouts collapse to the preset (point 6).

**General design 5.**
- Good: one system with a new look, every element mapped to an existing structure, 14 menus wired, no new screen, and a failure path with no rigged roll.
- Held to 5:
  - modes and habits are mixed up, and four IFs need engine work (point 2);
  - NEW and NOT BUILT pieces are tagged as CODE (points 3 and 4);
  - the baseline doesn't match the pack (point 5);
  - Plan B is duplicated (point 7);
  - one word means three things (point 8);
  - answers aren't in the book (point 9);
  - the slot counts contradict each other (point 10);
  - BJJ is pushed to v3 (point 13).
- Points 1 to 4 and 7 would take it to 6 or 7.

**Play 7.**
- A FIRED diamond is a moment the player waits for. The corner minute shows the counts and lets you make one change on the chart. The Why names the diamond that never fired, and the next opponent's file gives a reason to come back and redraw.
- It loses points because v1 watches rather than steers, and the live panel is heavy for a dark screen.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Coach's preset loads at booking | A plan worth about half a good one, with no work | Keep. It's the floor |
| Film night (camp or Week) | Opens one tell (one found IF) and costs about 240 drill units | Keep, and open it without a camp (point 6) |
| Scout $250 (pro) | Weapon and weakness at once | Keep |
| Draw the main line (3–4 boxes) | Which move fires on each card after a won exchange; each box is a move to drill | Keep |
| Place an IF on a found or free habit | Best answers against that mode, at a pad cost | Keep. Step answers need a cost (point 1) |
| Set Plan B | Same arrow as box 1 | **Useless as a separate option** (point 7) |
| The tray, THE PLAN vs the opponent | Pad nights go to the plan's moves; under 30 the box is skipped | Keep. The best link in the map |
| Test it (limited tries) | Worth against no plan, and which IFs fired | Keep, but pay for it with a sparring night (point 11) |
| Lock at the weigh-in | Nothing the player chooses | **Useless.** Lock at the bell |
| Live, v1 | Watch which IF fires | Keep, smaller (point 14) |
| v2 shout aimed at a box | Forces a box next exchange, inside two a minute | Keep. One system with the shout bar |
| Corner minute, one change on the chart | Fixes the arrow that failed; resets its pressure | Keep |
| v2 slots from bouts, Fight IQ, coach | Plan size grows with knowledge | Keep, starting from the coach's 4–6 (point 10) |
| v2 HURT: hold / tie up / shell | What the boxer does when hurt | Keep |
| v2 last exchange, last round behind | Late-round gambles | Keep. Label it "your coach's count" |
| v3 expects-the-body pips | Bait set-ups pay off | Keep as PRESSURE with a target |
| v3 Composure check | The plan can fall apart after a knockdown | Keep, with the chance always shown |
| v3 named plans | Known plans are seen sooner | Keep, after the corner read is built |
| Load preset | Resets to the coach's plan | Keep |

**Missing options:**
- **Load a saved plan for this opponent** (rematch). Section 4.5 says it's saved on the file, but no menu has the button. Put it on M1 and M13.
- **Copy a plan from a team-mate** who fought the same opponent or style. The file is the club's, not one fighter's.
- **Drill a step answer**, as a shadow or pad card for footwork arrows (point 1).
- **Film night outside a camp**, on the Week's evening popover, whenever a bout is booked (point 6).
- **Clear one box or IF** rather than the whole plan. Clear All is the only removal on the bottom bar.

## To reach 10/10

1. **Price the step answers.** Give `StrikeMap` arrows mastery: New, Raw, Usable at 30, Sharp at 60, drilled on pads or shadow, with FireLevel applied. Re-run probe 4 with a STEPS-ONLY bot, which must finish under GOOD.
2. **IFs are the six modes; habits are modifiers.** Free or found by style, as written. Map the real habits (drops the right after the jab, slow starter, fades late, chases the stoppage) to IFs or timing. Drop or cost the four new modes as fight-engine work.
3. **Correct the tags.** The found-only rule is NEW. Adjust and the corner read are AGREED, NOT BUILT, the read with its known 7 against 3.7 problem. Add a probe that rotating the read IF wins back at least half.
4. **Film without a camp.** A Film evening on the Week or Fight prep opens one tell whenever a bout is booked. The Tape Room runs from Fight prep. A first-bout opponent has no tape.
5. **One Plan B.** Remove the bar. Draw "lost: back here" arrows to box 1. Build `when: lost_last` in v1 if it's one line.
6. **One word per idea.** PRESSURE (your edge), "seen" (their corner read), PRESSURE with a target (bait).
7. **Answers from the book only.** Every answer is a book move, a book combination or a `StrikeMap` arrow. New ones go in as NEW content with mastery.
8. **Slots:** v1 uses the coach's 4–6 shared by boxes and IFs. v2 adds bouts and Fight IQ, capped at 7.
9. **Test it costs a sparring night;** remove the try count. **Lock at the first bell.**
10. **Baseline from the pack** (59, 45, 41, one matchup). Probes across six styles and three seed sets, with probe 8 run against the stronger GOOD.
11. **BJJ in v1** with positions as boxes and the two free IFs. The found ones come after the 3-beat check.
12. **A smaller live panel:** the box in play, FIRED and its count. The full chart in the corner minute and the result.
13. **Add the missing buttons:** load saved plan, copy from a team-mate, clear one box.

## The 1920×1080 page (Fighter > Playbook > Game plan, Look B whiteboard)

**Header (0–120):**
- Your boxer's polaroid on the left with the name once, then class, stance and the style word.
- VS, and the opponent's polaroid on the right with the name once, then style, stance, and "bout in 18 days".

**Left column (40–440), THE FILE:**
- The six modes as magnets. Each shows FREE (by style), FOUND with its share ("3 of 4 films"), or LOCKED ("a Film night opens one").
- The habit stickies under them ("drops the right after the jab: found"), each with **Add IF**.
- A **Film night** button showing its price, "−240 drill units, Tue".
- **Load preset**, **Load saved plan** (only when this opponent has one), and **Copy from a team-mate**.

**Centre (480–1440), the chart:**
- The top box "BELL: long range" with its main move.
- Up to the slot count of boxes down the board, joined by arrows labelled with the card each move leads to.
- From every box, a thin grey return arrow to the top, "lost: back here".
- IF diamonds beside their boxes, each with the mode word, the answer, a best/ok/wrong dot, and the share.
- Each box and diamond shows its tier and number ("SHARP 64", "fires 3 in 4"), its edge, and a red stamp under 30. Steps show their tier too.
- A small × on each box clears that one.
- A grey HURT stub on each box (fixed in v1).

**Right column (1480–1880), WHAT IT COSTS:**
- Slots "5 of 6".
- Drill cards against pad nights before the bout ("6 cards, 5 nights").
- Red stamps listed one line each.
- The worth line "+8 over no plan, last sparring test" in gold, the one gold on the frame.
- **Test it in sparring (uses Thu's sparring night)**.

**Bottom ledge:** Save plan and Clear. Continue lives in the top bar.

**Hover:** every number breaks down: match × pad time − the card's average, and the share's films.

**Fight night pairs with it:** a 300 px strip beside the shout bar with the box in play, a FIRED flash and its count. The corner minute opens the full chart with the counts and FixLab's outline, and **Change one** on each piece.

## Sources
- No new outside sources this pass. Everything above is checked against the critic pack (sections 4.2, 4.7, 4.8, S428, S448 and S451) and the map's own tables. The UK corners' round-count CHECK is NOT FOUND (not researched yet).

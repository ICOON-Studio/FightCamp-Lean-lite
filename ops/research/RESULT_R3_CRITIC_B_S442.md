6/10 - fight result page, round 3 (docs/mockups/s442/result/fight_result.png), critic B (boxing coach of twenty years who plays management games)

Checked against docs/mockups/s442/result/bout.json, the hover text in fight_result.html, and the critic pack. I read no other review of this screen.

## 1. Score: 6

The page is honest: nearly every number on it matches the bout, and the measured "what would have won it" section is something no boxing game I know offers. It is not yet a corner's debrief, for four reasons. The causes are ranked by exchanges lost, not by what would have changed the result, so the first fix button is the one the page's own measurement says does nothing. The damage panel contradicts itself. One row of the grid contradicts the plan lines drawn above it. And the two lessons a coach would give first are missing: "you knew her weapon and threw into it" and "the out-boxer spent the night on her own ropes".

## 2. Does the story hold together as boxing?

Most of it does, and it checks out against the data:
- Cards 28-29, 28-29, 29-28. Judge 3 gave Lucy round 2, and round 2 was 3-3 in exchanges and 20-22 in punches. All correct. "Round 2 decided it" is the right headline.
- All 18 exchange results, the punches landed in each, and Priya's game per exchange match the data.
- Line C fired three times (R1-1 won, R2-1 lost, R3-1 lost). The two round calls (Hands up for R2, Tie up for R3) are correct.

Wrong, empty or contradictory:
- **The damage panel argues with itself.** A green tick says "No place went below fine". The same panel says "INJURY ROLL None - full training", then "No sparring until Sun 29 Mar". Three lines up, the hurt row puts a star on 4 exchanges where Lucy was hurt. A coach reads this as "she was fine, she trains fully, she can't spar for 3 weeks, and she was hurt four times". All four are true in the game's terms (no body place under 55, no injury roll, a 46-damage stand-down, hurt flags). The page never says how they fit together. "The head took 46 damage" has no scale, and the hover says the stand-down is 5, 10 or 21 days.
- **The range rows contradict the plan line.** Line C is "At long range". In R2-1 and R3-1 it fired, yet the range rows put the gold bar on "Inside". The page draws one distance (the RingDuel place) while the exchange records another (`at`: long/mid/inside/clinch/own_ropes). The two disagree on many exchanges: R2-1 and R2-2 are "long" but drawn Inside, and R3-5 is "inside" but drawn At range.
- **The real geography is missing.** By `at`, Lucy fought 7 of 18 exchanges on her own ropes. She is an Out-boxer. That is the story a corner would tell, and the page has no word "ropes" anywhere. Its three rows (At range / In the pocket / Inside) fold the ropes into "In the pocket".
- **"Corner: no call in round 1"** is printed under a round where two shouts are drawn (Draw the lead, Hands up). It means "no corner minute before round 1", but it reads as "you said nothing".
- **Hurt/habit row.** The two arrows in R1 mean "Lucy's slow-starter habit was punished", yet Lucy won both of those exchanges. The underlying line reads "Priya made Lucy pay" on an exchange Lucy won. Also, Priya's file weakness is "Slow to start" and Lucy won round 1 4-2, but the page connects neither.
- **The tiredness card overstates.** "Under 35 from R3-4" covers three exchanges (R3-4, -5, -6), and Lucy won one of them. The card says "2 of 2 lost". Priya was lower than Lucy at the last bell (21 v 23), so tiredness did not separate them. In the data, "Tank at the last bell" is 39 v 34 in fight_stats but 23 v 21 in the exchange records. Two numbers for the same bell; the build must pick one.
- **The corner minute is absent.** Only the call is shown. The data shows nothing else was used in either minute: no fix, no talk, no set-up. Pace stayed Steady for all 18 exchanges and Aim was never set. A coach would say this out loud.
- **The plan's coverage is never said.** The plan had a line for only 5 of 18 exchanges (13 improvised). The dots show it, but no sentence does.

## 3. "What decided it" and "What would have won it"

The page's ranking (exchanges lost): 1 Priya loading up (4), 2 Line C (2), 3 Fought hurt (2), 4 Tired (2).

The page's own measurement over 200 nights:

| Plan | Wins in 200 |
|---|---|
| As written | 35 |
| Add a Step back line for her loading up | 39 |
| No line C | 65 |
| Line C rewritten to Double jab | 96 |
| Both changes | 100 |

So:
- **Cause 1 is the wrong cause to rank first, and its fix is useless.** "Playbook: add Step back" moves 35 to 39 in 200, which is dice noise. Yet it is the first button in the card row and the first button in the FIXES bar. A player who presses the first button changes nothing. Rank causes by measured lever, or at least never put an unmeasured or measured-useless fix first.
- **The real problem behind cause 1 is skill.** Hands up was the right call every time she loaded up (big edge, Lucy graded only "OK" at it) and won 1 of 4. That points to defence and head movement in training, not to a plan line. The page has the evidence and draws the wrong conclusion.
- **Line C should be cause 1.** It is the measured lever (+61 in 200), and it is a boxing truth. Priya's file was fully open before the bout: her weapon is "right hand counter over the jab". Line C threw One-two-hook at a counter-puncher who counters over the jab. The page never mentions that the player had this information. That is the lesson that makes a player scout and read files next time.
- **Cause 3 (Fought hurt) is derived.** It admits "Comes from 1 and 2". A derived cause should not take a rank slot. Missing causes that deserve its place:
  - The minute call fitted the end of the last round, not the opening of the next. Priya opened every round waiting to counter, and the R2 and R3 calls had no edge there. The "Clash" line hides this in small red text.
  - Pace never moved.
  - On her own ropes 7 of 18.
- **Cause 4's fix (Training: Cardio) is not measured** and is not supported by the bout: both fighters were tired and Priya more so. Cardio also moves about a point a focused week, so it cannot matter for the next bout.
- **The "this bout without line C: WIN" line misleads.** It shows a win for dropping line C, while the measured best fix (Double jab) still loses this exact night (round 2 goes 3-3 again). The page should say plainly: "the rewrite loses this night but wins half the time; taking line C out wins this night but a third of the time".
- **"of 200" is a lab unit.** Say it as a chance (18% to 48%) or "nights in 10". Mark gaps under about 5 points as luck.
- **Double jab needs its boxing reason.** Against "right hand counter over the jab", a coach will frown at a double jab unless told why: the second jab lands as she sits on the first. The game's own NEXT line says "Try Feint and draw", while the page says Double jab. One answer, with one reason.
- **Only plan changes were measured.** Corner changes (an opening call of Draw the lead, Push for the last minute of R3) were not. The page calls its section "measured", but half the levers of the night are untested.

## 4. Marks that lead nowhere, and lessons not drawn

Lead nowhere or duplicate:
- The FIXES bar repeats three card buttons word for word.
- "Fought hurt" has no button, and says so.
- The arrows in the hurt row do nothing in a win.
- Line B ("Beats it - Priya never pressed") is a dead line with no action. It should say: "this line never fired; use the slot".
- The judge grid's orange box needs its hover to mean anything.

Lessons not drawn:
- You knew her weapon (the file was complete before the bout) and threw into it.
- The out-boxer lost the ring: 7 of 18 on her own ropes, and 2 of her 4 hurts came there.
- Your shouts were right 6 of 6 and won 2: the corner was right, the fighter lacked the tools. Train defence.
- Every round opened with her waiting to counter. Call for the opening.
- Priya faded in R3 and nobody raised the pace.
- Learned on Priya: "smells blood and forgets to defend". It is in the bout's aftermath and is a pure fight lesson (a counter when you are hurt), but the page leaves it out. Her file is now complete for a rematch.
- The plan had a line for 5 of 18 exchanges.
- With this plan she was a 1-in-6 shot and still took it to a split. That is the honest frame for the whole page.
- There is no "watch round 2 again", although round 2 decided it.

## 5. Words and readability

- **Jargon:** "Turned 1 exchange", "cost 14 of the tank", "R3-4", "Under 35", "fit 2 of 4", "Clash:", "35 of 200", "Fit: Big edge / Small edge", "PLAN LINE C ✓/✗", "WHO WON IT".
- **Code names in the hovers:** RankLine, Exchanges.round_of, BoutMarks, FightStats, PadEdit.drill_it, Data.LABEL, Exchanges.MODES, RingDuel. A player reads hovers; these must go.
- **Unexplained on the face:**
  - the coloured squares in the plan table (red = won, blue = lost; red is also Lucy's colour, which helps, but nothing says so)
  - grey vs green dots in the corner row
  - the megaphone glyph
  - stars and arrows in the hurt row
  - the gold bars in the range rows
  - "100 / 0" on the energy axis

  The hovers explain them, but the face should carry a one-line key.
- **Words that should be a picture:** "Hurt 4 times: 2 loaded, 1 on line C, 1 again" belongs as marks on the grid with a cause beside each. "No sparring until..." belongs as a small calendar bar.
- **Too small or too faint:** "35 = tired", "Lucy tired from R3-4", the row labels "At range / In the pocket / Inside", "Comes from 1 and 2" (grey on dark), and "won 1 of 2" in the plan table are about 14 px or low contrast. The bottom-right "Clash" line is the most useful sentence in that panel and is drawn as small red text.

## 6. To reach 10/10 (most important first)

1. **Rank "What decided it" by measured lever, and put line C first.** Each card shows its measured effect ("Double jab here: 18% to 48%"). Never show a fix button whose measured effect is under about 5 points. Drop "add Step back" as a button and move it to a "Not why she lost" line.
2. **Tie cause 1 to the scouting file.** "Her file said: right hand counter over the jab. Line C threw into it at the start of every round." Name the weapon and the round-openers.
3. **Replace "Priya loading up" with "Right call, not the tools".** Hands up had a big edge in all 4 and won 1; Lucy is only OK at it. The button opens the Week with a defence/slip-rope morning. Label it "not measured" until the game can measure a stat change over 200 nights, then measure it.
4. **Fix the damage panel into one truthful story:** "Hurt 4 times, nothing lasting: no cut, no injury. Head damage 46 means no sparring until Sun 29 Mar; pads, bag and runs go on. Most worn: right ribs 59 (hurt below 55)." Remove "full training" and the green tick.
5. **Draw one distance per exchange in boxing words:** Long / Mid / Inside / Clinch / ROPES, from the exchange's `at`. Make it agree with the plan line's place, flag own ropes in gold, and give the count (7 of 18) in the story.
6. **Give each round one plain sentence above its exchanges** (why it went that way), then the 6 tiles. For example: "R2: opened with line C into her counter, lost by the smallest margin of the night; a loaded cross hurt Lucy; Tie up got her to the bell."
7. **Add the corner lesson as a cause:** "The minute called the last round". Each round opened with her waiting to counter, the R2 and R3 calls had no edge there, and Draw the lead won that moment in R1. Measure "opening call = Draw the lead" over 200 nights.
8. **Add "Never pushed a fading opponent".** Pace Steady for 18 of 18, and Priya tiring and lower at the bell in R3. Measure Push for the last minute of R3.
9. **Say "What would have won it" as chances, with the night's result beside each.** For example: "18% as written, lost; 48% with Double jab, lost this night (R2 3-3 again); 32% without line C, won this night". Add "gaps under 5 points are luck" and one boxing reason for Double jab. Make the game's NEXT line agree with it (not "Feint and draw").
10. **Put the frame in the header:** "With this plan she wins 1 night in 6. She took it to a split." Keep "One judge's view of round 2 from a win" on the judge grid.
11. **Put a key on the face of the grid**: tile colour = who won, score = punches landed, letter = plan line (red = walks into her game), gold chip = your shout with its name, HURT, ROPES. Delete the stars, arrows, dots and megaphones that need a hover.
12. **Cut the FIXES bar duplicates** to three actions: line C to Double jab, drill Double jab on the pads, Watch round 2 again. Then Continue.
13. **Add "Learned on Priya: smells blood and forgets to defend; her file is complete"** and "the plan covered 5 of 18 exchanges"; one line each.
14. **Clean the hovers of code names**, and fix the slow-starter line that says "made Lucy pay" on exchanges Lucy won.
15. **Nothing under 15 px; no grey text under about 4.5:1 contrast.**
16. **For the build: one energy number at the last bell** (39 v 34 or 23 v 21, not both). And make the Why's "-5% worth" agree with the measured as-written vs no-line-C gap (18% v 32%).

## 7. My 10/10 drawing

docs/mockups/s442/result_r3_critic_b/ten.html, rendered to docs/mockups/s442/result_r3_critic_b/ten.png (1920x1080, every number from bout.json). Layout:
- **Header:** the verdict with the judge grid, round 2 marked, and the 1-in-6 frame.
- **Rounds:** three round columns, each with one sentence and six tiles (her game, punches, Long/Mid/Inside/Clinch/ROPES, plan letter, named shout, HURT) under an on-screen key.
- **Causes:** "What decided it" ranked by lever: line C into her weapon (measured), right call not the tools, the minute called the last round, never pushed a fading opponent, plus a "Not why she lost" line.
- **Measured fixes:** "What would have won it" as chances with this night's result beside each.
- **Damage:** one truthful story.
- **Footer:** the Priya lesson, Watch round 2, Continue.

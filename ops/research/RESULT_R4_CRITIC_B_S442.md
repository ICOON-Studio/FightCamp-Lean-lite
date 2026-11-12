Score: 6/10 (critic B, boxing coach, fresh read; screen docs/mockups/s442/result/fight_result_r4.png, checked against bout_r4.json)

# Fight result page, round 4: a corner's read

The page is honest about the scorecards and it puts one measured fix first. It does not yet read like a corner's debrief.
It misses the second half of the best fix. It ranks a guess above measured numbers. It gives two of its five cause cards to
things it then calls luck. And it never says the plain truth of the night: Priya was the better boxer, Lucy stood on her own
ropes, and even the best plan only makes this an even fight.

## 1. Score
6. The data is real and most numbers check out. The top fix is right. The page is not yet a corner's debrief because:
- the story of the night is spread over bars and chips that the player has to decode;
- the strongest measured fix (100 of 200) is missing;
- the second-ranked card has no measured number behind it.

## 2. Does the story hold together as boxing? (checked against bout_r4.json)
Correct: the cards are 28-29, 28-29, 29-28, a split. Round 1 went 4-2 to all three judges. Round 2 went 3-3 in exchanges and
20-22 in punches landed, and two judges gave it to Priya. Round 3 went 1-5. Every exchange's punches, mode, plan line and shout
matches the file. The hurt marks match the exchanges after which Lucy was hurt (R2 e3-4, R3 e1 and e3). The energy points at
each bell (68-65, 39-40, 23-21) are right. The "turned it" mark sits on R2 e1, line C lost by a margin of -0.34, which is the
narrowest exchange of the night. That is a fair choice.

Wrong, empty or contradictory:
- **Two distance models on one page.** The WHERE rows use the ring place (At range / In the pocket / Inside), but the chips
  use the plan's place (long / mid / inside / clinch / ropes). They disagree. In R3 e5-6 the bars say "At range" while the
  exchange is "inside" by the plan's place; in R2 e1 line C fires "at long range" while the bar says "Inside". A boxing person
  reads that as nonsense. The "≠ plan card: another distance" chip is the page admitting the clash rather than fixing it.
- **The out-boxer on her own ropes is the clearest story, and nothing says it.** By the plan's places, Lucy was on her own
  ropes in 7 of 18 exchanges and won 3. At long range, where an out-boxer lives, she boxed only 5. Each rope exchange came
  during or straight after a Priya load-up. The ROPES chips are drawn, but no line or cause names it.
- **"Not on Priya's file before the bout" (cause 1) is the wrong lesson.** Her game ("Counter-puncher: waits to counter")
  was known at booking, and the plan board itself rated line C "wrong" (Walks into it) against a counter-puncher before the
  bell. The truth: you wrote a line the board told you was wrong. The tape only explains why it hurt so much.
- **"Tired at the end" (cause 3) is not a cause of this loss.** Lucy finished on 23 and Priya on 21, so Priya was the more
  tired. Pushing the last minute measures -1 in 200. The real tiredness story is that line C, punished 3 times, cost Lucy 14
  of her tank (fight_why). The page never links the energy line to that.
- **"Last bell 23-21, Lucy first"**: "Lucy first" reads as "Lucy got there first". It means the order of the numbers.
- **The Nationals line in the header** ("needs 3 months registered (5 weeks to go)") hides the fact that entries close in 9
  days, so she is out of this year's championship whatever the result. The fight did decide one thing here, and the page
  misses it: this was bout 5 of 5, so the bout requirement is now met.
- **Damage is told one-sided.** "The head took 46 damage" gets no comparison: Priya took 12. That 4-to-1 gap is the counter
  over the jab doing its work, and the page should show it. Data check: in body_map both heads end at 63.4 of 100, which
  does not fit 46 against 12. One of those numbers is wrong in the build.
- **Lucy's own slow-starter habit cost her an edge twice in round 1** (habits_paid). It is not shown. She won the round, but
  it is a habit with a fix (the corner's habit fix, the trial focus).
- **The corner tells a mixed story.** Card 4 says "Draw the lead instead: this night won", then "luck, no button". The plan
  card says the best fix "lost again". A player meets three "this night" results with no line saying the dice fall differently
  when one thing changes. One sentence fixes it.

## 3. The cause cards
Measured over 200 nights in bout_r4.json:

| Change | Wins of 200 | Gain |
|---|---|---|
| As written | 35 | - |
| Rewrite C to Double jab | 96 | +61 |
| Rewrite C and add "when she loads up: Step back" | 100 | +65 |
| Delete C | 65 | +30 |
| Add the load-up line only | 39 | +4 |
| Draw the lead from round 1 | 36 | +1 |
| Push the last minute | 34 | -1 |

- **The best fix is incomplete.** "C to Double jab and B to Step back when she loads up" is the measured best at 100, and it
  is not on the page. Line B ("Step back when she presses") never fired, because Priya never pressed, while she loaded up 5
  times. A wasted line slot is a lesson this page should teach. The data even carries the new line's option (mid|loadup, Step
  back, Beats it).
- **Card 2 (Training: Defence focus) is mis-ranked.** It is unmeasured, but it sits above two measured cards and carries a
  button. Its own heading ("Right call, not the tools") is right. The honest card is: "1 of 5 won against loaded shots with
  the right call; no plan line fixes it (+4 of 200); this is a Defence gap." Its button then needs a measured gain (replay
  with Defence +N), or no number.
- **Cards 3 and 4 are not causes.** By the page's own numbers they are luck (+-1). They take two of five premium slots and
  push the real second cause (the wasted line B, the ropes) off the page. Fold them into one grey "measured, not causes" row.
- **A cause is missing: the gap in class.** With no line C the fight is 65 of 200, and with the best plan only 100 of 200.
  Priya, ranked 4th and 5-1, was the better boxer. A corner would say so first, so the player learns that the plan made it
  close and training has to make it a win. The card for this cause is the Defence one.
- **The right panel ("Plan, of 200, this night")** is the most useful table on the page, but it is drawn as small text and
  repeats card 1. Merge it into the cause area as one bar ladder.

## 4. Rows and marks that lead nowhere; lessons not drawn
Rows and marks that lead nowhere:
- the WHERE three-bar rows (no action, and they clash with the chips);
- the energy line (no cause attached);
- "Your 6 shouts, big edge 6 of 6" (every shout was right, so what do I do?);
- the "≠" chips;
- "Round call, all round" with "No call before round 1" (only luck is measured);
- the Nationals header line;
- the footer "a rematch starts with everything known" (an amateur cannot ask for a rematch: AGREED, NOT BUILT).

Lessons not drawn:
- line B waited for a situation that never came;
- an out-boxer on her own ropes;
- Priya's counters doing 4x the damage;
- line C's 14 tank cost;
- the plan board had already flagged C;
- the ceiling of the best plan;
- Lucy's slow start;
- the new habit found on Priya ("smells blood and forgets to defend"), which is a real answer for a rematch or for similar
  opponents and is not shown.

## 5. Words and size
- **Jargon:** "edge", "big edge 6 of 6", "under the tired line", "the minute called the last round", "Lucy is OK at it",
  "plan card: another distance", "fit to Priya", "Lucy first", "Wins in 200 nights" (say "if they fought 200 times").
- **Should be pictures:** the four cause headings are sentences that each need a re-read. A bar ladder of wins of 200 says it
  at a glance. "Round 2 swung it" should be a highlighted card cell (it is), not a sentence and a cell.
- **Too small:** the legend row (about 14 px), the WHERE labels, the "≠" and ROPES chips, the energy labels, the numbers
  box's sub-labels and the right-hand "Plan" table. The exchange shout chips ("DRAW THE LEAD" split onto two lines) are
  cramped.
- **One colour per fighter** holds (orange Lucy, blue Priya). Good. Keep it.

## 6. To reach 10/10 (most important first)
1. **Best fix = both lines.** "C: Double jab + B: Step back when she loads up", 35 to 100 of 200, as the one gold button
   ("Rewrite C and B in the plan"). Show Double jab alone (96) and Delete C (65) as rungs below it, on one bar ladder with a
   dashed 100-of-200 line marking an even fight.
2. **Say the ceiling in one bold line.** "Even the best plan wins 1 night in 2: Priya was the better boxer." Attach the
   Defence card to it. Give the training button a measured gain (replay 200 nights with Defence +N), or show it without a
   number. Never rank it above measured rungs.
3. **Cut cards 3 and 4 to one grey row**, "Not causes, measured as luck: Draw the lead from round 1 36, push the last minute
   34", with no button.
4. **One distance model.** Use the plan's places (long, mid, inside, clinch, own ropes) for the exchange strip and for the
   numbers. Delete the three-bar WHERE rows and the "≠" chips.
5. **Add "Where it was fought" as a cause picture:** on her own ropes 7 of 18, won 3; at long range only 5. Name it as an
   out-boxer's problem.
6. **Write the right lesson for line C:** "The plan board rated it Walks into it before the bout." Keep the tape note as the
   reason it hurt.
7. **One plain verdict line per round under its header**, for example "3-3, lost on punches 20-22: C lost the opener by a
   hair; two loaded crosses hurt Lucy on the ropes".
8. **Show damage for both fighters** (head 46 v 12, hurt 4 v 0). Fix the body map so it agrees with the damage totals.
9. **Attach the tank cost to line C** ("punished 3 times, 14 of her tank") and drop "Tired at the end" as a cause.
10. **Replace the Nationals header line with what the bout decided**: "5 of 5 bouts done; entries close in 9 days, 5 weeks
    short of registration: next year". Do the same for the ladder: "a win would have put Lucy on the table".
11. **Show Priya's completed file**, including the new habit (smells blood and forgets to defend). Delete the rematch promise
    until an amateur can ask for one.
12. **One sentence** explaining "this night" against "200 nights" (the same dice fall differently once one thing changes).
13. **Words:** no "edge", "tired line", "Lucy first", "OK at it". Minimum text 14 px, shout chips on one line.

## 7. My 10/10
docs/mockups/s442/result_r4_critic_b/ten.html, rendered to docs/mockups/s442/result_r4_critic_b/ten.png (1920x1080, checked:
nothing overlaps or is cut off). Every number in it comes from bout_r4.json.

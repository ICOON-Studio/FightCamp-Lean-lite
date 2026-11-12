6/10

# Fight result page (docs/mockups/s441/result/fight_only.png): critic A, S442

Read as a player of Football Manager, Title Bout, Boxing Manager and OOTP. I only read the picture, CRITIC_PACK.md and CRITIC_ACCESS.md.

## 1. Score: 6

The depth is real and the numbers agree with each other. I checked them all. 8+10 exchanges = 18. Rounds 4-2 / 3-3 / 1-5 match the bars. Plan A won 2 of 2, B 1 of 2, C 0 of 3, and the chips in the timeline match. Shouts won 2 of 4, also matching. Punch subtotals add up (26+25=51, 38+13=51, Priya 29+43=72). The three cards agree with the round results. Few sims are this honest.

It still loses points. The answer to "why did I lose" is two lines of small text with arrows, not a picture. The causes are listed side by side, but not linked to each other or ranked. Bar scales change from row to row. Several numbers cannot be read without guessing ("Range wanted Lucy 9 · Priya 12 of 18", "Big edge / round lost"). A lot of space goes on two large stock body renders that say less than a short list would. I would not ship it yet.

## 2. The ten-second test

- **Who won.** You can tell in about one second: "LOST", "SPLIT DECISION", "Two judges to one for Priya Nair". You read that first, and it should be first.
- **Why.** It takes 10 to 20 seconds. The WHY box is the most important thing on the page, but it is two lines of 19 px text in the middle of the screen. The facts are there: level after 2, round 3 lost 1-5, energy 36 v 50, line C 0 of 3, pinned on the ropes twice. Their order is not shown. The real chain is that line C walked into her pressing, a wrong planned answer shrinks the energy ceiling (pack 4.7), so her legs went and round 3 was lost. The screen never says that line C caused the legs going, and that is the most useful thing it could say.
- **What it cost.** "Cut over the left eye: out 3 weeks" is clear. But the body map shows Right ribs at 33, which is critical, and nothing explains what that means next week. Either it costs something, so say it, or it explains the result, so link it to Priya's body hooks (7/16).
- **Read order.** After LOST, the eye goes to the three big blue judge totals and then to the two glowing blue bodies. The bodies pull too hard for what they say. The judge totals are fine, but the swing card (Judge 3, R2) is a small 14 px note.

## 3. What is missing, what is useless, and what each would change

**Missing:**
- **A ranked "what would have won it"** (replay the bout without line C's mistake, with Cardio +3, with fitting shouts, and show the win chance out of 100 for each). This turns two competing buttons (Train Cardio, Rewrite C) into a decision. The Why already replays the dice without the plan's edge (pack 4.9), so this extends something the game does. It needs building.
- **Which round decided it.** Show "R2 was 3-3; take it on two cards and you win." Today that is a 14 px note under Judge 3. It explains a split decision better than anything else.
- **What was learned about the opponent.** Tape tells found in the bout ("presses harder in round 3", "steps in behind the jab"). A rematch or another meeting in the regional table depends on this, and the opponent's file is a core system (4.6).
- **Knockdowns and counts**, even "none". In a sim a decision's credibility starts there.
- **The corner minute's choices** (ONE CHANGE, RECOVER, TALK) and whether each helped. Only the shouts are graded. The corner minute is a core mechanic and gets no feedback.
- **An action on the cut.** The physio staff job brings injuries back a quarter sooner. Offer it here, with its price, instead of just stating "out 3 weeks".
- **Watch the decisive round** in 3D. "Replay the plan" exists, but you cannot jump to round 3.

**Useless, or cannot be acted on:**
- The body legend (fine / hurt / critical / doctor / cut) is printed twice.
- Healthy body places (Lucy's head 58, right eye 69, nose 62, left ribs 66; Priya's head 63, eyes 66/60, left ribs 71) explain nothing and lead to no action. Show only the places that got hurt.
- "THE RESULT" heading: the page is obviously the result.
- "Range wanted Lucy 9 · Priya 12 of 18" adds up to more than 18 and has no meaning a player can recover. Either explain it ("fought at Priya's range 12 times") or cut it.
- Long 7 / Mid 5 / Inside 6 / ropes 2 adds up to 20 against 18 exchanges, so ropes is an overlay, which is not said. The bar is hard to read and nothing on the page asks you to act on it, except indirectly through line C.
- "Big edge, round lost" under CORNER reads like a contradiction. Fit and outcome need separate columns: "fits" and "won next / lost next".
- Mastery words in the punch table (Sharp / Usable / Learning) have no column header. "Sharp" sits next to Lucy's worst accuracy (30%), which is interesting, but nothing says so.
- The "Tiredness, mood and the club's money: on Home" line is fine as a pointer, but it is grey text where a link button would do.

## 4. Graphics or paragraphs

It is about 60% graphics, but the most important part, the WHY, is a paragraph. Places that should be pictures:
- **WHY** should be a chain of 3 to 4 tiles with icons and arrows (plan line, then tank, then legs, then cards), not two text lines.
- **Energy.** Two 2 px lines that almost overlap, no axis, no threshold. "Legs went" is the turning point, and the graph cannot show it. It needs thick lines, a 0-100 scale, a dashed "legs go" line at 50, and a marker where she crossed it.
- **Exchange bars.** There is no axis, and nothing says what the height means.
- **Opponent mode strip.** The bands do not line up with the round columns ("Waiting to counter" runs across the R1/R2 gutter). Draw them per exchange cell.
- **Plan and shout chips.** They sit under only some exchanges, with no empty markers, so you cannot tell which exchange a chip belongs to without counting.
- **Punch table.** The bars use different scales per row: Lucy's "Counters 6" bar is full, while her "To the head 38" bar is no longer than Priya's 51. Use one scale per row, from the centre out, and say so.
- **Text too small at 1080p**, under about 16 px: "of 100" in the body headers, the body legends, "R2 (3-3) to Lucy", the punch legend (landed / blocked / slipped / missed / better on the row / No counts), the timeline legends (hurt / habit / call / fits / half / wrong), the "/156", "/88" denominators, the chips' tick and cross marks, the hatch patterns for blocked and slipped. The owner has already said "fonts are small".

## 5. Does it look like a serious AAA sim? What looks cheap

It reads as a serious stats page more than most indie sims. What looks cheap:
- The **two blue x-ray stock bodies**: the same female anatomical render for both corners, no corner colour, with the panel's empty space around them. A sandbox game will show men and women, so a stock female anatomy model is wrong half the time.
- **Portraits** are 50 px circles at the bottom of each panel. The fighters' faces are the emotional anchor, and here they are an afterthought.
- **The verdict mixes fonts**: a comic marker font for "LOST" and "SPLIT DECISION" next to a condensed technical sans everywhere else. Choose one voice for the verdict.
- **Hatched bar patterns** at this size look like rendering noise.
- **Thin 1 px borders and the same dark grey everywhere.** Nothing separates the five panels, so it reads as one dense sheet.
- **Bottom buttons are brown-on-brown and look disabled.** The two real decisions (Rewrite C, Drill the 1-2-3) are small chips inside panels, while "Replay the plan" gets the big button.

## 6. To reach 10/10, most important first

1. **Make the WHY a causal chain of 4 icon tiles** across the width under the verdict: "Line C: presses → step in, walked into it 3/3" → "each one cut her tank, 36 v 50 at the bell" → "round 3, legs went, exchanges 1-5" → "all 3 judges, round 3, lost 28-29". Use 22 px+ numbers and no sentences.
2. **Add "What would have won it"**: 3 ranked levers from replaying the bout about 200 times (line C rewritten, Cardio +3, every shout fitting). Each gets a bar showing the new win chance against the 42% before the bell, and each has its action button. Needs a counterfactual replay in the rules; the Why's no-plan replay is the start of it.
3. **Make the scorecard a 3x3 grid** (judge x round, red/blue cells, totals). Outline the swing cell and write one line under it: "Round 2 decided it: 3-3, Priya cleaner".
4. **Rebuild the round timeline on one grid of 18 exchange cells.** The mode band, bars, plan chip, shout chip and events all line up per cell, with a dot where nothing happened and a stated meaning for bar height ("taller = clearer"). Put the round headers with exchange score and judges' verdict on top.
5. **Make energy a real chart**: 4 px lines, a 0-100 scale, a dashed "legs go" line at 50, a marker and label where she crossed it ("under 50 after line C"), and the end values per round.
6. **Replace the two big stock bodies** with one small neutral silhouette per fighter showing only the hurt places (hook lines out of the body, per the S437 rule). Next to it: the hurt places with numbers and their cause ("Right ribs 33, Priya's body hooks 7/16"), and a red COST box: "Out 3 weeks, misses the 14 Mar show, Nationals 1 bout to enter".
7. **Change the punch table** to one scale per row from the centre out, the leader's number in gold, and 8 rows at most: exchanges, landed, jabs, power, body, counters, hurting shots, avoided. Move per-punch rows and mastery words into hover or the R1/R2/R3 tabs.
8. **Grade the plan and corner with outcome squares**: each plan line gets its grade (Beats it / Walks into it) and a won/lost square per use. Each shout gets FITS / HALF / WRONG plus "won next / lost next". Add the corner-minute choices (one change, recover, talk) with the same grading.
9. **Put a footer of real decisions in order of value**: Rewrite line C (primary, with "+19 in 100 v her"), Train Cardio next week (+9), Watch round 3, Physio for the cut ($75 a week, back sooner), then Continue. Remove Replay the plan as a top-level button, or keep it as Watch round 3.
10. **Add "New on her file"**: tells found in this bout, linked to the opponent file.
11. **Show the fighters' faces** at about 130 px in the header, with record before → after, regional rank before → after, and win chance before the bell. Cut "THE RESULT".
12. **Set every text to 15 px minimum, numbers 20 px+.** Use one sans for the verdict, delete the duplicated legends and the hatch patterns, and add panel headers in one accent colour with 6 px rounded panels on a slightly lighter card colour.

## 7. My 10/10 drawing

- docs/mockups/s442/result_critic_a/ten.html
- docs/mockups/s442/result_critic_a/ten.png

It uses the same bout and numbers as the reviewed mockup. The replay win chances (61 / 51 / 47 in 100), the 14 Mar show date and the tells found are sample values that show the shape of the feature. They are not measured numbers.

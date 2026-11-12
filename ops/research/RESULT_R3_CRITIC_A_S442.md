Score: 6/10

# Fight result page, round 3 - critic A (fresh, S442)

Judged: `docs/mockups/s442/result/fight_result.png` (1920x1080), against `ops/research/CRITIC_PACK.md` and the owner's screen rules. No other review read.
My 10/10: `docs/mockups/s442/result_r3_critic_a/ten.html` -> `ten.png`.

## 1. Score: 6
The depth is real and rare: an exchange-by-exchange strip, a measured "what would have won it" from 200 replays, plan lines graded against her game, shouts graded by fit. That is simulator-grade information. What holds it at 6: the page tells you *what happened* everywhere and *what to do* only weakly; the colour language fights itself; half the marks need a legend that is not there; the "why" and the "fix" are in two separate boxes that you have to join in your head; there is no primary next action.

## 2. The ten-second test
- **Who won**: yes, at once. "LOST" in big red top-centre is where the eye lands first, then the scorecards.
- **Why**: partly. "Round 2 decided it" and four ranked cards exist, but the ranking is by exchanges lost (Priya loading up, 4 of 5) while the measured best fix is a different thing (line C -> Double jab, 35 to 96 of 200). The player has to read two panels and compare to find the real lesson.
- **What it cost**: barely. The damage box is bottom-left, small, and says "No place went below fine" next to "The head took 46 damage" with no scale.
- **What to do next**: weak. Four equal tan "Fixes" buttons plus the same buttons again inside the cards; none is marked as the best. The most eye-catching button on the page is the red "Continue", i.e. the page pushes you to leave.
- Eye path: LOST -> scorecards -> red/blue bars of the timeline -> Continue. The measured-fix panel (the most valuable thing on the page) is a top-right box of thin bars and is read last.

## 3. Things I could not understand without help (with place)
1. Timeline "WHO WON IT" labels (4-3, 5-2, 6-1), middle band: no unit. Punches landed? Edge? And the order flips (winner first), so "4-3" over a blue bar reads as Lucy 4-3.
2. Plan-line chips "C✓", "C✗", "A✓", "A✗", middle band: no key on that row; the A/B/C key is at the bottom right.
3. The orange outline around R2 "C✗": unexplained (I guessed: the decisive exchange).
4. Corner-call row dots (grey, green, yellow-green) vs "Big edge" chips with a left-pointing speaker icon: the dots and chips mix two encodings; the icon reads as a Back arrow.
5. "Corner: no call in round 1" under a row that shows two Big-edge shouts in round 1: contradicts itself unless you know "corner call" means the between-rounds call, not the shouts.
6. HURT / HABIT row: the left arrows (R1 ex 1-2) and starbursts have no legend. Whose habit? Whose hurt?
7. "At range / In the pocket / Inside" lanes sit under the HURT/HABIT label as if they belonged to it.
8. Energy chart labels "68 65", "39 40", "23 21": two numbers jammed together, colour the only key; the gaps between rounds (recovery) are not explained; the ring marker in R3 is only explained by text far below it.
9. "35 of 200", "96 of 200" (top right): "of 200" what? Replays of this bout - not said.
10. "This bout without line C: WIN 29-28, 29-28, 28-29" beside "No line C at all: 65 of 200": the two numbers measure different things (same dice vs 200 replays) and look contradictory.
11. Damage: "The head took 46 damage" (bottom-left): of what scale? If bands are "fine over 55", a head at 54 would be hurt, which contradicts "No place went below fine". Either the copy or the number is wrong - check it in the code.
12. "WHY" as a row label inside the damage box: means "reason", collides with the game's word "the Why".
13. THE NUMBERS butterfly: bars are not on one scale per row (red "2 won at range" is full width, blue "2" is full width, red "3 inside" full, blue "2 inside" short, red 58 shorter than red 2). The bars lie.
14. Plan table, right: "Priya never pressed" next to line B with no swatches; "fit 2 of 4" vs "won 2" - two different measures side by side without a header.
15. "Clash: R2-1 Hands up, move your head + line C ..." (red line, bottom right): R2-1 notation is jargon.
16. "Hurt 4 times: 2 loaded, 1 on line C, 1 again" (card 3): "1 again" is unclear.

## 4. Missing / useless
Missing (a sim player wants it after a fight):
- **Win chance before the bout vs result** ("you were 58% to win"): the single line that tells you if this was bad luck or bad prep. The game has the band; it is not shown. Changes: player trusts or distrusts his plan.
- **The cause joined to its measured fix** on one card ("Line C walked into her counter: 2 of 3 lost -> rewrite to Double jab: 35 -> 96 of 200"). Today they are two boxes.
- **One recommended action** (highlighted) and a way back to this page after it.
- **Watch the turning point**: the 3D fight exists; a "watch R2 exchange 1" button turns the strip into a story. Changes nothing in the sim but sells the plan as the star.
- **Rank earned in plain words**: "Unranked -> Unranked" is honest but useless; "1 more win to join the regional ladder (enters at 4 wins)" is what the scope change (every fight shows the rank earned) actually asks for.
- **Hover detail per exchange** (who threw what, the dice, the edges) - the page needs a promise that it exists.
- **Knockdowns / counts** row (none here, but the row should exist so a stoppage page looks the same).
Useless or not actionable:
- The duplicated Fixes bar (same three buttons already on the cards). Keep one place.
- "Comes from 1 and 2" card (Fought hurt) with no action: keep it, but say what fixing 1 and 2 removes, or fold it into those cards.
- "Left the other hurt 0" and other low-value rows in THE NUMBERS are fine as context, but the panel has no action; it should be compact.
- "No standing counts" under the verdict: fine when there were none, but takes a headline slot.

## 5. The nine-point recipe
1. Limited colour palette - **fail**. Red means Lucy, losing, Walks into it, Risky, the Continue button and the clash line. Blue means Priya and "Waiting to counter". Green means Big edge and Beats it. Gold/tan means buttons and lanes. Too many jobs per colour.
2. Contrast separates UI from background - **partly**. Panels are near-black on black; good text contrast, weak panel edges; grey sub-text ("Comes from 1 and 2") is low.
3. Consistent font and buttons - **partly**. One display font + one sans, fine; buttons in three styles (tan fix, outlined chip with icon, red Continue).
4. Highlight the selected button - **fail**. No selected/recommended state anywhere.
5. Prioritise most-used interactions - **fail**. Continue is the loudest; the best fix is equal to the weakest.
6. Obvious what to do - **partly**. "FIXES" exists but not "do this one".
7. Subtle animations - **not judgeable** in a still; nothing indicates a reveal order (the week review lands rows one at a time; this page should reveal verdict -> why -> fix).
8. Group similar elements - **partly**. Causes and their measured fixes are split; corner info is split between the strip, the corner text lines and the bottom-right table.
9. Hide non-essentials until needed - **partly**. Exchange detail hidden is right; the full NUMBERS table and the "This bout without line C" line could go to hover.

## 6. Small / cheap
- Too small at 1080p: plan-line dots and chip letters (~13 px), the "Fit:" legend (top right of the strip), "At range / In the pocket / Inside" labels, the "100 / 0" energy axis, "35 = tired", "Lucy tired from R3-4", the grey card sub-lines. Body text is ~15-16 px; fine.
- Cheap-looking: the left-pointing speaker glyph (reads as Back); the double number "68 65" on top of the line ends; the orange outline that looks like a selection bug; portraits in heavy red/blue boxes look like a fighting-game select screen rather than a serious sim; red Continue.
- Look: dark and tight suits the agreed fight-night style. It reads as a data dashboard, not yet "AAA sim": no hierarchy between the headline lesson and the supporting data.

## 7. To reach 10/10 (most important first)
1. **Merge "what decided it" and "what would have won it" into one row of cause cards**, each: cause, exchanges lost, the measured replay bar (as written 35 -> with fix N, "of 200 replays of this bout"), and its one button. Rank by measured gain, and mark the top one "BEST FIX" with a gold outline.
2. **One primary action**: the best fix as a gold primary button in the footer; Continue becomes a neutral secondary ("Continue to the gym"). Remove the duplicate Fixes bar or make it the only place the buttons live (not both).
3. **Fix the colour language**: your fighter one hue (amber), the opponent one hue (steel blue), on every element; green/red only for good/bad outcomes; corner red/blue only as a small tag. Never red for your own fighter.
4. **Label every row of the strip in place**: "Who won it - punches landed, Lucy-Priya, up = Lucy"; always print scores in the same order (yours first); "Plan line used" with the fit colour on the chip; "Your shout" chips with the call's name, fit-coloured; "Where" lanes with their own label; "Lucy hurt ✸" as its own row with the symbol in the label; energy legend with "dash = tired (35)".
5. **Mark the turning point** with a labelled outline ("TURN") and a footer button "Watch the turning point" that plays that exchange in 3D.
6. **Header: rank earned in words** ("Ladder: off - 1 win to enter"; opponent "No. 4 -> No. 3") and "Round 2 swung it: 2 judges gave it to Priya" as the one-line verdict. Add the pre-bout win chance ("you were 58%").
7. **Damage as a body figure with each place's remaining health on a 0-100 bar and the hurt line drawn**; fix the 46-damage vs "fine" contradiction in the code or the copy; keep Injury and Sparring-until as two lines; drop the "WHY" label.
8. **THE NUMBERS: one scale per row** (each row's max = the bigger of the two), yours left in your colour, hers right; indent sub-rows.
9. **Plan and corner table with column headers** ("fit to her game", "exchanges", "result") and swatches in fighter colours; replace "R2-1" with "round 2, exchange 1" or a hover.
10. **Hover/click promise on the strip**: "Hover an exchange for who threw what and why - click to watch it", and build that hover.
11. **Reveal order** (subtle animation): verdict, then scorecards, then the cause cards fill their bars, then the strip draws left to right.
12. Raise all text to at least 15 px; give the decisive "TURN" and chip glyphs proper icons, not a Back arrow.

Drawing: `docs/mockups/s442/result_r3_critic_a/ten.png` (HTML beside it). Content is the same bout; the per-exchange shout names in the drawing are sample words where the original only gave a fit dot, and the "pre-bout chance" line is listed as a change but not drawn (the bout's real figure was not on the page).

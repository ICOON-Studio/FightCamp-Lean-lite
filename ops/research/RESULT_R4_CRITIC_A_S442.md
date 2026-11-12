Score: 6/10

# Fight result page r4 - critic A (fresh, S442)

Screen: `docs/mockups/s442/result/fight_result_r4.png`. Read with CRITIC_PACK.md and CRITIC_ACCESS.md only.
My 10/10: `docs/mockups/s442/result_r4_critic_a/ten.html` -> `ten.png`.

The page is honest and deep. Every exchange, line and shout is traceable, and the fixes are measured. As a page it is an
analyst's worksheet, not a finished sim screen. Four causes get the same weight, two of them end in "luck, no button",
the plan is explained in four places, and the most-used button (Continue) is the weakest thing on screen. The rules
"hide non-essentials", "group similar" and "only what you can act on" are each broken at least once.

## 2. The ten-second test

| Question | Got it? | Where |
|---|---|---|
| Who won | Yes, at once | Big red LOST, split, 28-29 28-29 29-28 |
| Why | Half | Card 1 has the gold frame, but cards 2-4 use the same red headline at the same size and compete with it |
| What it cost | No | Bottom-left paragraph, the last place the eye goes; no picture of the body |
| What to do next | Mostly | The gold "Rewrite line C: Double jab". Then "Training: Defence focus" and Continue both ask for attention, and two cards have no button |

Eye path: LOST (red, 80 px), then the yellow judge-3 R2 cell, then the gold "BEST FIX" frame. The yellow cell pulls the eye
to the one judge who gave round 2 to LUCY, which is the opposite of the sentence beside it ("2 judges gave it to Priya").

## 3. Elements I could not understand without help

1. Score grid, judge 3 R2 (yellow box): why that cell. It marks the judge who disagreed, not the round that decided it.
2. Card 1 "Wins in 200 nights v Priya 35 -> 96": a count out of 200, not a percent. The grey stub before 35 reads as an empty bar. 17.5% to 48% would read in one glance.
3. Card 1: the tell given is "right hand counter over the jab", and the fix offered is a Double jab, two jabs into that counter. A boxing player will doubt it. It needs one clause on why the double jab is safe.
4. Card 5 (top right, Plan / of 200 / this night): "this night" is a second measurement with its own lost/won column. "No line C at all: 65, won" next to "Double jab: 96, lost" tells me removing the line wins tonight, while the best fix loses tonight. That contradicts the BEST FIX card.
5. Card 2 title "Right call, not the tools". "The tools" is not a game word. "Lucy is OK at it" says nothing measurable. "Not measured: replays change plan, corner" is developer language.
6. Cards 3 and 4: "this night lost", "35 -> 34 of 200 nights: luck, no button". "The minute called the last round" and "2 openers lost, no edge" are hard to parse. "The minute" is the corner minute, not named.
7. Timeline "WHERE - At range / In the pocket / Inside": three rows of grey bars with uneven fill. I cannot tell whether a bar means time spent, the place of the exchange, or a share. They look like skeleton loading bars.
8. "ropes, clinch: the plan card" and the chip with the not-equal sign ("plan card: another distance"): cryptic. I needed the legend and still do not know what "plan card" means here.
9. Round call row: grey and green dots under the call text are 6 px and carry the "fits / no edge" meaning alone.
10. "TURNED IT" under R2 exchange 1: a 3-4 exchange, nearly a draw. Without a reason it looks arbitrary.
11. Energy numbers "68-65 / 39-40 / 23-21" sit on the line with no "end of round" label. "dash = tired (35)" is in the left label column, far from the dash.
12. Plan panel "Your 6 shouts ... big edge 6 of 6": "big edge" is a third word for fit, beside "Works" and "Beats it".
13. Plan panel "Priya never pressed" sits in the won/lost column, where a count is expected.
14. Footer "a rematch starts with everything known": amateurs cannot ask for a fight (pack 4.5). It promises an action the game does not give.
15. No time on the exchanges (0:30 ... 3:00). "Late in round 3" has to be counted.

## 4. Missing, useless, and what each would change

Missing (a sim player looks for these after a bout):
- Landed / thrown and accuracy for each fighter. "Punches landed 58 v 70" without thrown cannot separate "out-worked" from "out-landed". It would change how the player reads Defence against Volume.
- Knockdowns and counts, even when zero. It is the first stat any boxing sim shows.
- The stat gap behind cause 2. "The fix is training" needs Lucy's Defence against what was needed. Without the number, the training button is a guess.
- A body picture: head 46 damage is buried in a sentence. The pack's result screen has a body report ("which part went first"). It would make the sparring lock self-explanatory.
- What the bout revealed about Priya: the footer says the file is open, but not what is new. The tells are what the player uses next time.
- Watch an exchange: the 3D shows settled rounds, so clicking an exchange or the swing round to watch it is the natural link from analysis to film.

Useless or not actionable:
- "Nationals: needs 3 months registered (5 weeks to go)": this bout did not change it, and nothing can be done about it here. Cut it.
- Cards 3 and 4 as full cards: both end in "luck, no button". They earn one line each in a "ruled out" strip, not 40% of the cause row. Ruling them out is still worth showing, because it stops the player from chasing them.
- Card 5 "this night" column: it confuses rather than explains. Keep only the 200-replay chance.
- Legend line above the timeline (full width, about 14 px): hover it, or label the chips themselves.
- The rematch promise in the footer (see 3.14).

## 5. The nine-point recipe

| Point | Verdict | Evidence |
|---|---|---|
| Limited colour palette | Partly | Orange/blue per fighter is good, but red does three jobs (LOST, every cause headline, line C, hurt) and yellow does two (the button and the "look here" frames) |
| Contrast UI vs background | Partly | Panels #1a on #12 barely separate; grey 14 px labels on dark are weak |
| Consistent font and buttons | Partly | Three button looks (gold fill, dark outline, dark Continue); the green outlined shout chips look like buttons but are not |
| Highlight the selected button | Fail | Yellow marks the main button and two non-clickable frames (R2 judge cell, R2 column), so it does not mean "press" |
| Most-used interactions first | Fail | Continue, pressed after every bout, is a small dark box in the corner |
| Obvious what to do | Partly | One gold button, but three calls to action plus two "no button" cards |
| Subtle animations | Not shown | Nothing specified: the bars, the energy line and the 35 -> 96 gauge should tween in order, cause 1 last |
| Group similar elements | Fail | The plan appears in card 1, card 5, the timeline row and the bottom-right panel; the shouts in card 2, the timeline and the bottom-right panel |
| Hide non-essentials | Fail | Legend, WHERE bars, energy numbers, nationals line and the two luck cards are all shown at once; nothing sits behind a hover |

## 6. Too small, cheap, paragraphs

- Too small at 1080p: the legend row; "Lucy-Priya, bar up = Lucy won"; the WHERE row labels; "dash = tired (35)"; the round-call dots; the won/lost squares in the plan panel (~12 px); "all 3 judges Lucy" (grey ~14 px).
- Looks cheap: the WHERE grey bars (placeholder look); flat panels without depth or edge light; the portraits are the only art and are cut square; Continue looks disabled.
- Should be pictures, not paragraphs: "What it cost Lucy" (four sentences, should be a body figure with damage and a lock chip); cards 2-4 (three or four lines each, should be one gauge or stat bar each); card 5 (a small table written as prose).

## 7. To reach 10/10 (most important first)

1. One hero cause, not four equal cards. Cause 1 gets a wide card with a before/after chance gauge in PERCENT (18% -> 48%, "200 replays, same fighters") and the gold button. Add one clause on why the double jab beats her counter.
2. Fold cards 3 and 4 into a "Checked and ruled out" strip: one row each with its replay result (18% -> 17%), no headline, no red.
3. Rewrite cause 2 in game words with its number: "Right call, not enough Defence. Lucy's Defence 54, about 60 needed against her loaded right", a stat bar with the target tick, and the button "Set Defence focus".
4. Delete card 5's "this night" column and the "No line C at all" row, or show them only on hover. One measurement per page.
5. Make Continue the clear, consistent primary exit: a light solid button with its destination ("Continue: back to the gym"). Gold stays only for the best fix. Never use the button colour for a non-button frame: mark the swing round with a gold outline label "decided the fight", not the button fill.
6. Score grid: highlight the two judges' R2 cells that went to Priya (the swing), not judge 3's.
7. Replace the three WHERE bar rows with one row of three dots (range / pocket / inside, one filled), with CLINCH / ROPES chips beside it. Drop the not-equal "plan card" chip, or name it in words.
8. Add timestamps under each exchange and make each column clickable: "watch this exchange in 3D".
9. Bottom left becomes a body figure: head and ribs coloured by damage, injury roll result, and a lock chip "No sparring until Sun 29 Mar". No sentences.
10. Numbers panel: add landed/thrown (accuracy), head/body and knockdowns/counts (0 is shown, not omitted). Fold "at range / pocket / inside" into one line.
11. Plan panel: one vocabulary for fit (Beats it / Works / Walks into it) for both lines and shouts. "never used" in muted text, not in the count column.
12. Footer: "NEW ON PRIYA'S FILE" listing the tells this bout revealed. Remove the rematch promise until amateurs can ask for a fight.
13. Cut the nationals line from the header. Keep the record, ladder and rank arrows, the stakes the bout moved.
14. Legend to hover or to self-labelled chips. Minimum text 14 px at 1080p; no grey under #9a on the dark panels.
15. Animation order: the scores land, then the timeline draws left to right, then the energy line, then the causes fill. The best fix gauge tweens last, with the gold button settling as it finishes.

Note on my drawing: the thrown counts (141, 125), the Defence 54 / ~60, the rib damage and the extra tells are sample values I
made up to show the layout. The game must supply the real ones (thrown counts and a "needed" stat may not exist in the code
yet; NOT ESTABLISHED).

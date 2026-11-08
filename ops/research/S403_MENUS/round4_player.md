# Round 4, the player's read (decades of management sims, eight MMA fighters, every Monday for years)

| Page | Score | Done | Partly | Not |
|---|---|---|---|---|
| Home | 7 | 9 | 1 | 0 |
| Fighter Week (Lucy + Aisha pages) | 7 | 10 | 0 | 0 |
| Profile (Tomas, Aisha, Kwame) | 6.5 | 9 | 1 | 0 |
| Playbook (Megan, ground, combos) | 7 | 10 | 1 | 0 |
| Fight night | 7.5 | 8 | 1 | 0 |
| Money | 7 | 9 | 1 | 0 |
| World | 7 | 9 | 1 | 0 |

Nothing is "Not". The pages are close. What holds them under 8 is a short list of contradictions between pages, listed per page below. Most are one-line fixes.

## Home
- H1 Done. Win bar with width and "30-50%", a chip for what a win does, same chip on Megan's note.
- H2 Done. Megan, Kwame, Tomas red; Danny and "Two in camp" amber; review grey; legend shows both colours with the facts words.
- H3 Done. Amber trade-off, "Pad nights: Lucy 2, Aisha 1".
- H4 Done. One icon set in the table, no stray dots.
- H5 Done. Members 68/70, reputation, break-even in the members tooltip (drawn open).
- H6 Partly. Josh, Tomas, Kwame show a dash with the reason in a tooltip, Aisha is amber. But Danny (no fight booked, a contract note only) still shows 69.2 / 70.0, and the rule was "only when a fight is booked or a limit is near".
- H7 Done. All / Need me / Camp / Injured / Free.
- H8 Done. Tint legend and a tooltip naming the reason (Aisha 38).
- H9 Done. Next-step links on each line; Danny reads Fight IQ, Lucy reads Speed.
- REMOVE Done. No Cash row, no clipboard, no crest, "All news and mail" is a small link.
Blockers:
- Lucy is 2-1 and the stake chip says "A win puts Lucy in the top 10", while World says she enters the table at 4 wins. A win makes 3. One of the two facts is wrong (facts.json `stake` versus `entry`). The same chip is on World, so it counts there too.

## Fighter Week (Lucy, and Aisha)
- W1 Done. Lucy Mon and Wed, Friday reads "Aisha's night" in grey; weight from facts.
- W2 Done. "Takedown defence 41 is the gap" links to the Takedown drills chip (not-built mark); the Do it button says exactly that.
- W3 Done. All five controls in the header row.
- W4 Done. Chooser drawn open under Thursday, three groups, not-built mark on Grappling only.
- W5 Done. One row of eight faces with planned / coach runs it / not planned, red dot on Megan.
- W6 Done. Only the five attributes that move, plus one big goal bar with the cap tick.
- W7 Done. Labels clear of the curve; twist card has numbers on both answers (fatigue 68 to 63, knee risk 4% to 11%); Jab in the tray.
- W8 Done. Fatigue, pads, sparring, intervals icons present.
- W9 Done. Aisha page: week 3 of 6, Mat rounds / Takedown drills / Cage work, BUILD bands, one Friday pad night.
- REMOVE Done. No zero line, no permanent row of pills, no grey pips.
Blockers:
- Lucy's Tuesday evening is "Sparring with Aisha". Aisha's own Tuesday evening is Weights. Thursday matches, Tuesday does not. A player trusts these two grids to agree.
- Aisha is "week 3 of 6" of camp with the fight 40 days (nearly 6 weeks) away. A 6-week camp at week 3 means about 3 weeks to go, not 40 days. The BUILD band on her chart also runs to "week 6" and then the fight is off the chart.

## Profile (Tomas, Aisha, Kwame)
- P1 Done. All 12 skills as bars in three labelled groups, three best starred, not-built mark on the group headers, no paragraph. Stars check out on all three fighters.
- P2 Done. Key line is on the page; deltas only when not zero; no contradicting pairs.
- P3 Done. Tomas: Stamina 44 to 46.5 by Mon 23 Mar, +0.1 a week, OFF TRACK, one button.
- P4 Done. Pay line under every name with contract end and next money; offer card says what he earns now, shows the why, three answers.
- P5 Partly. Ghost tick for the division average and a band word in each tooltip are there. But the band words are wrong in many tooltips against the page's own rule: Tomas Stamina 44 "fair" while the bar is amber "under 45"; Aisha Flexibility 82 "strong" and Escapes 79 "strong" (elite); Kwame Strength 80 and Heart 80 "strong", Recovery 42 and Submissions 44 "fair", Clinch 68 "solid". About 14 tips disagree with the weak/fair/solid/strong/elite bands (weak under 45, fair under 55, solid under 65, strong under 75, elite above).
- P6 Done. One sticky per fighter, same pattern on all three.
- P7 Done. Shield on Durability; "No fight booked" instead of a lock.
- P8 Done. Aisha: ground skills on top. Kwame: caps equal now, yearly drop per attribute, age curve, "About 3 fights left", retirement card on top.
- P9 Done. Kwame's tooltip draws the slot rule with Maria's numbers (Rib, fit Mon 23 Mar, 21 days).
- REMOVE Done. No skills paragraph, no zero deltas, no weight row in Body, no "5 of 19" chips.
Blockers:
- Aisha's "Fight prep" tab is greyed with no reason on her Profile and on her Playbook, though she is in camp with a fight booked. The player cannot open the tab the game needs. (Tomas, Kwame and Megan are right to be grey.)
- Money lists Aisha's contract talk dated before Sat 11 Apr with "Open the talk". Her Profile top card shows the fight, not that talk (the P9 rule puts a dated talk before a booked fight), and Home has no need for it. Three pages disagree about whether she has a talk.
- Band words contradict the amber rule and the bands (see P5).
- Smaller: the Aisha sticky says "Defence is the hole, work on it", while her Week page says the gap is Takedowns and the Do it button is Takedown drills. Same fight, two different gaps.

## Playbook (Megan standing, Aisha ground, Combos)
- B1 Done. Hatched "?" chips on every rating and "Style only: every rating is an estimate".
- B2 Done. Body silhouette with the target lit and the distance (inline art).
- B3 Done. Standing and Cage and ground tabs; range ruler with one chip per place; on the ground page the empty Get-up chip is a visible hole.
- B4 Done. Scout $250 beside the locked line, "best for Megan", "Takedowns 30 is too low" on the grey one, Find a coach.
- B5 Done. Five-bar chart beside Sound plan.
- B6 Done. One Fight shape row, opened only for the tooltip.
- B7 Done. Drag handles, "drag a move here", swap and clear icons, clear lighter.
- B8 Done. Group icons and the test icon.
- B9 Done. Six real lines in full colour, one mark.
- B10 Partly. The Combos tab shows today's flow well (build, key lessons, hit rates vs three opponent kinds, play / clear / save / drill) with Megan's moves. Lucy's moves are not drawn at all; her 1-2 only appears as a chip in the book.
- REMOVE Done. Chalkboard no longer repeats chips; "5 of 6 lines" replaces the half-blue bar; the "More" button is gone (three plain links instead).
Blockers:
- The greyed "Fight prep" tab on Aisha's ground page (see Profile).

## Fight night
- F1 Done. Set-up "1-2 Usable" is there. Counts add up: 7 right (3+1+1+2+0), 7 wrong (1+3+0+1+2), 1 neutral.
- F2 Done. Picked cards look different from "coach suggests"; two picked, "2 of 2 used"; Clear head greyed with "Lucy is not hurt".
- F3 Done. Cutman card is "Left eye closing" plus two buttons, no NEW tag.
- F4 Done. One small body each, red on the hurt places, legs included, "rocked" on Priya, three numbers each; the rest in a tooltip.
- F5 Partly. Separate strip "Once the round starts" with glyphs and words, position label, and the tooltip lists the ground set. But "2 of 2 used" is shown on the corner fixes, not on this strip.
- F6 Done. "lasts to round 3 at this pace".
- F7 Done. Six-exchange strip, star on the takedown.
- F8 Done. "Write the line" on NEXT.
- REMOVE Done. No 1x / 2x / Skip, no twelve-number grid, smaller Clear head and Set-up tiles.
Blockers: none. (Judge cards add up: 9-10, 10-9, 9-10 = 28-29 on all three; Lucy 2-2 and Priya 10-3 after the loss.) One thing to look at, not a blocker: "Ice the ribs" is offered while the body tooltip shows both ribs fine (64, 58) and the only hurt site is the left eye.

## Money
- M1 Done. Ranked, Youth and Strength corner first, Club show grey with "from Mon 6 Apr", Bigger unit last, grey, "cash would fall to 1 wk" (brief said 2; the sums give 1.6 to 2, so I let it pass).
- M2 Done. Coaches panel with cost, moves opened, face chips; one not-built mark.
- M3 Done. Stipends -$0 in Out; table shows "off", "Start $250", and an "Earns the gym" column.
- M4 Done. Kit text true; dues bands show the weekly effect; Cheap grey "the place is full".
- M5 Partly. Runway numbers and paybacks are right on every priced tag (checked 9, 7, 8, 7, 10 weeks against cash and costs). Mats ("bought") and Cage ("price not set") have the icon but no number.
- M6 Done. 8 weeks forward, dotted, bills, Lucy's and Aisha's purses, "if you do nothing".
- M7 Done. Break-even in the members tooltip.
- M8 Done. One line each, "Open the talk", no answer buttons; Maria's rib shown as costing nothing.
- M9 Done. Cashbook tab beside The books.
- REMOVE Done.
Blockers:
- Aisha's contract talk is listed here, but Home has no matching need and her Profile does not show it (see Profile).

## World
- R1 Done. Both old sections gone.
- R2 Done. Ranks 1 to 10, Lucy pinned at the bottom with "Enters the table at 4 wins".
- R3 Done. Bands (hatched when not scouted, amber for Priya's partly scouted), scouted eyes, trend, age, finish rate with KO / Sub icon, style, Ask for this fight on rows in reach.
- R4 Done. Eight faces with a state icon and rank; small sport tabs.
- R5 Done. Side-by-side on the 10 attributes with ranges; Ask (grey, with the reason) and Scout $250 with what it buys.
- R6 Done. "#5 to #1: 4 wins".
- R7 Partly. The key covers champion, challenger, next opponent, scouted, up, down and more, but the state icons on the eight-face picker (booked, camp, injured, offer, contract, free, leaving, retiring) are not keyed here.
- R8 Done. News box stays.
- REMOVE Done. No Dev column, one action button per row, faded arrows on rows out of reach.
Blockers:
- Same stake contradiction, on one page: the bottom row says Lucy "Enters the table at 4 wins" (she has 2 wins), while the chip and Title route say "A win puts Lucy in the top 10".

## One-line fixes that would lift all seven to 8 or more
1. Fix Lucy's stake line to match her 2-1 record and the 4-win entry rule (facts.json).
2. Make Lucy's Tuesday sparring partner match Aisha's Tuesday.
3. Make Aisha's camp week match her 40 days to the fight.
4. Turn on Aisha's Fight prep tab.
5. Put Aisha's contract talk on Home and in her Profile top slot, or take it off Money.
6. Correct the band words in the Profile tooltips.

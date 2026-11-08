# Round 4, designer seat: seven menus checked against FIXLIST_R4

Seat: senior sports-management designer. Read CRITIC_PACK, CRITIC_ACCESS, facts.json, roster_mma8.json, each PNG and each page's HTML (titles and data-tip). Arithmetic checked by hand. No game or mockup file changed. `check_mockups.py` prints MOCKUPS OK for all twelve pages.

| Page | Score | Done | Partly | Not |
|---|---|---|---|---|
| Home | 7 | 9 | 1 | 0 |
| Fighter Week (with Aisha's page) | 7 (Lucy 8, Aisha 6) | 8 | 2 | 0 |
| Profile (Tomas, Aisha, Kwame) | 7 | 7 | 3 | 0 |
| Playbook (standing, ground, combos) | 7.5 | 10 | 1 | 0 |
| Fight night | 8 | 9 | 0 | 0 |
| Money | 7 | 9 | 1 | 0 |
| World | 7 | 7 | 2 | 0 |

Nothing is "Not" done. The fixes are on the pages. What holds the scores below 8 is a short list of contradictions between pages, listed per page and summed up at the end.

---

## 1. HOME (7)

Arithmetic checked and correct: needs count 4, "in 3 days", 18 / 21 / 40 days, weights vs limits (0.8 / 0.3 / 0.6 / 0.8 / 2.6), members 68/70, break-even 31, bills $5,668.

- H1 Done. Win bar with 30-50% and the stake chip; same chip on Megan's note.
- H2 Done. Megan, Kwame, Tomas red; Danny and the pads note amber; the legend carries both phrases from facts.
- H3 Done. Amber, "trade-off", "Pad nights: Lucy 2, Aisha 1. Only 3 a week."
- H4 Partly. The eight icons come from kit.js and there are no stray dots. But the icon colours do not match the pins (blocker 1).
- H5 Done. 68/70, reputation 41, break-even in the open tooltip.
- H6 Done. Josh and Tomas show a quiet dash; Aisha amber; the rest only within 1 kg of the limit.
- H7 Done. All / Need me / Camp / Injured / Free.
- H8 Done. Rested / Tired / Overreached key plus the open tooltip naming Aisha's reason.
- H9 Done. Lucy's line is Speed, Danny's is Fight IQ, each with a next-step link.
- REMOVE Done. No cash row, no clipboard, no crest; "All news and mail" is a small link.

Blockers
1. Row icon colours disagree with the pins and with the other pages. Home draws Megan's offer icon amber although her note is a red pin; Kwame's icon has no colour although his note is red; Maria's is red here but neutral on every other page. Rule 9 and rule 2 say one state, one look. (Fighter Week, Profile, Playbook and World show Megan, Tomas and Kwame red.)
2. The Lucy stake chip says "A win puts Lucy in the top 10", but the same facts say she "Enters the table at 4 wins". Lucy is 2-1: a win makes 3 wins. Both cannot be true. Same fact on World (see there).
3. Tomas's weight is a dash here ("nothing to cut for") but his Profile header shows 80.0 of 77.0 in amber (see Profile).

---

## 2. FIGHTER WEEK (7: Lucy page 8, Aisha page 6)

Arithmetic checked and correct on Lucy's page: plan totals (Stamina 0.10+0.10+0.06 = 0.26, Strength 0.14, Explosiveness 0.12, Fight IQ 0.08+0.08 = 0.16, Speed 0.05); pad count 2+1 of 3; phases (BUILD 3 weeks out, PEAK 2 weeks out, TAPER fight week); Stamina 62, cap 80, goal 65.

- W1 Done. Lucy Mon and Wed; Friday reads "Aisha's night" in grey; weights from facts.
- W2 Partly. Lucy's page is right: "Takedown defence 41 is the gap" links to the Takedown drills chip, and Do it swaps Thursday's Speed bag for it. Aisha's page breaks it: the advice says "Takedowns 54 is how you get her down" and the goal bar is Takedowns 54 to 60, but the chip and the Do-it train Takedown defence +0.4. Nothing in her week raises Takedowns.
- W3 Done. This week / Next week, Coach runs it / I run it, both copy buttons, Back to the coach's week.
- W4 Done. Chooser open from the selected Thursday card, three groups, mark on the Grappling header, coach's pick tag.
- W5 Done. One row of eight faces with planned / coach-run / not planned and a red dot on Megan's pad-night clash.
- W6 Done. Only moving attributes, plus one large goal bar with the cap tick.
- W7 Done. Chart labels clear of the curve; twist card has numbers on both answers; Jab in the pad tray.
- W8 Done. fatigue, pads, sparring, intervals icons present.
- W9 Partly. The page exists with Mat rounds, Takedown drills, Cage work, BUILD bands and Friday pads. It disagrees with itself and with Lucy's page (blockers 2 to 4).
- REMOVE Done. No zero line, no pill row, no grey pips.

Blockers
1. See W2: Aisha's goal (Takedowns) is not trained by the session the coach recommends (Takedown defence).
2. On Aisha's week the grappling cards differ from the chooser. Cage work shows "Strength +0.10" in the week but "Clinch +0.3" in the chooser; Takedown drills shows "Explosiveness +0.10" in the week but "Takedown defence +0.4" in the chooser. The brief says same chips everywhere.
3. Sparring does not match between the two pages. Lucy's week has sparring with Aisha on Tuesday and Thursday; Aisha's week has Weights on Tuesday evening and sparring only on Thursday.
4. "Camp week 3 of 6" against "40 days" to the fight. Six camp weeks ending on Sat 11 Apr put 2 Mar in week 1, not week 3. Either the weeks or the days are wrong. The fact appears on Home, Profile and Playbook too.
5. Smaller: Takedown drills at +0.4 and Cage work at +0.3 are about double what the pace rule gives one morning (about 0.2 at Normal, less with headroom). Not a cross-page contradiction, so not counted.

---

## 3. PROFILE (7)

Arithmetic and numbers checked: facts line up (Tomas Stamina 44 / cap 52, goal 46.5 by Mon 23 Mar: 3 weeks at +0.9 = 46.7, at +0.1 = 44.3, so OFF TRACK is true; match $120 gives net +$183 and runway 9 weeks; perk thresholds against caps). Stars are the true top three on all three pages.

- P1 Done. Twelve skills in three labelled groups, same bars, three best starred, mark on the Standing grappling and Ground headers, no paragraph.
- P2 Done. Key line shown; falling arrow only beside Durability's -0.1; no zero deltas.
- P3 Done. Goal from facts, OFF TRACK chip, one "Set the week" button.
- P4 Done. Pay line on all three pages; offer card uses `why`; Match / Promise / Let him go.
- P5 Partly. Band word and ghost tick are on every bar, but the words contradict the game's bands (weak under 45): Stamina 44, Flexibility 40, Defence 40, Footwork 42 and Takedown defence 42 are called "fair" while Takedowns 38 is called "weak". Stamina is the weakness the whole page is about.
- P6 Done. One sticky ("Work on Stamina: open the Week").
- P7 Done. Durability uses the shield; the weight chip says "No fight booked"; no lock beside the scale.
- P8 Partly. Kwame's page is complete: caps equal now, yearly drops, age curve, "About 3 fights left", retirement talk as the top card. Aisha's page has ground skills starred and an overview that does not match her week (blocker 2 and 3).
- P9 Done. Kwame's tooltip draws the slot rule and uses Maria's numbers (Rib, fit Mon 23 Mar, 21 days).
- REMOVE Partly. Skills paragraph, zero deltas and "5 of 19 moves" are gone, but Tomas's header still carries a weight chip with nothing booked.

Blockers
1. Band words (P5 above).
2. Aisha's "Fight prep" tab is grey on her Profile, Playbook and Ground pages, but she is in camp with a booked fight (her own Week page and Home show Fight prep live). Grey with no reason, and wrong.
3. Aisha's sticky says "Defence is the hole. Work on Defence: open the Week", but her week has no Defence session; her coach and her goal bar talk about Takedowns.
4. Tomas shows 80.0 of 77.0 while Home hides it (nothing booked). One rule, applied differently.
5. Money lists a contract talk for Aisha ("First top-10, talk before Sat 11 Apr"). Her Profile has no contract card and Home has no need for it. Rule 10 says the decision lives on her Profile.

---

## 4. PLAYBOOK (7.5)

Arithmetic checked: "5 of 6 lines" matches five filled lines; "3 may beat the game, 2 work" matches three "Beats it?" and two "Works?" chips on both Megan's and Aisha's pages; "7 of 19 learned" for Megan and "6 of 19" for Aisha match the roster; the book lists 19 moves; fight shape "Steady, Steady, Push" matches the round buttons.

- B1 Done. Hatched "?" chips on every rating; "Win chance 35-60% ?"; "style only: every rating is an estimate".
- B2 Done. Body silhouette with the thigh lit and the distance bar; Aisha's page shows the armbar on the ground.
- B3 Done. Standing / Cage and ground tabs; five-place ruler with a chip per place; line list under it.
- B4 Done. Scout $250 with what it opens; "Keep it standing: best for Megan"; "Take it down: Takedowns 30 is too low"; Find a coach.
- B5 Done. Five-bar chart beside Sound plan.
- B6 Done. One Fight shape row, drawn open once for the tooltip.
- B7 Done. Drag handles, "drag a move here", swap and clear icons with clear lighter.
- B8 Done. Group icons and the test icon.
- B9 Done. Aisha's six lines (wall, top, bottom, escape, submission, get-up), full colour, one mark on the header; get-up empty and flagged on the ruler.
- B10 Partly. Combos page is built (move picker, chain, key lessons, hit rates marked as estimates, Play it / Clear / Save / Drill). It draws Megan only. Lucy's moves (Lead hook, Body hook, Uppercut, Low kick, Double leg) appear only as locked buttons.
- REMOVE Done.

Blockers
1. Aisha's "Fight prep" tab grey (see Profile blocker 2).
2. Minor, not counted: the Mid ruler chip has an amber outline with no key.

---

## 5. FIGHT NIGHT (8)

Arithmetic checked and correct: Why counts 7 right, 7 wrong, 1 neutral equal the sum of the lit lines (3+1+0+1+2 right; 1+3+2+0+1 wrong; one neutral); scorecards 28-29 on all three judges from 9-10, 10-9, 9-10; record 2-1 becomes 2-2 and Priya 9-3 becomes 10-3 and stays #5; round 1 positions 2:35 + 0:40 + 1:45 = 5:00; control 6:30 matches the Why; the body-site numbers in the tooltips match the three shown.

- F1 Done. Set-up available with 1-2 Usable; counts add up.
- F2 Done. Picked cards look different from the coach's dashed suggestions; "2 of 2 used" is true; the tooltip says "unpick one to add another"; Clear head is grey with its reason.
- F3 Done. Cutman card is "Left eye closing", two buttons, no note, no NEW tag.
- F4 Done. One body figure each, red where it hurts, legs and a Rocked mark, three numbers; the full list in the tooltip.
- F5 Done. Separate "Once the round starts" strip with glyph and word; position label; the ground set is in the tooltip.
- F6 Done. "lasts to round 3 at this pace".
- F7 Done. Six-exchange strip with the star on the takedown.
- F8 Done. "Write the line" on the NEXT line.
- REMOVE Done. No 1x, 2x or Skip; no twelve-number grid.

Blockers: none.
Notes, not blockers: "Ice the ribs" is offered while the hurt site is the left eye and the ribs read 64 and 58; the Body report says the ribs went first, which only fits later in the fight. Four labels are 12 px.

---

## 6. MONEY (7)

Arithmetic checked and correct: in $1,720 (550+420+400+350); out $1,417 (450+416+380+0+171); net +$303; bills 4 x weekly = $5,668; runway 10 weeks; break-even 31 (the $247 weekly shortfall over the $8.08 a member brings); Youth net +$553, coach net +$23, bigger unit net -$67, Premium about -$50; Tomas net +$183, Danny +$53; Aisha $2,500 bonus gives 8 weeks. Chart events line up with the weeks (bills W11 and W15, purses in W11 and W14) and the dips match the sums.

- M1 Partly. Order mostly fits (cheap and useful first, Bigger unit last, grey, no pin, "cash would fall to 1 wk" which is right at 1.6; Club show grey with its date). But Second evening coach sits first with a red "buy" pin although it adds a $280 weekly cost, the place is full and net drops to +$23.
- M2 Done. Coaches panel with cost, moves, face chips, one mark on the header.
- M3 Done. Stipends $0 in Out; table shows off, Start $250, earns the gym.
- M4 Done. Mats ours, strength coach not hired; Cheap grey "the place is full"; weekly effect on each band.
- M5 Done. Runway on every tag, payback on Youth and the Club show.
- M6 Done. Eight weeks forward, dotted, events 1 to 4, "if you do nothing".
- M7 Done. Break-even tooltip.
- M8 Done. One-line contract notes with Open the talk; tooltip on the stipend row explains Maria's rib costs nothing.
- M9 Done. Cashbook tab.
- REMOVE Done.

Blockers
1. Aisha's contract talk is on Money but not on Home or her Profile (see Profile blocker 5).
2. The Coaches panel has no Hire button and no hired state, so a player cannot act on it, and its prices (about $1,250 a week for all four) are not shown against the $303 net or the runway the way every other tag is.
3. Strength corner says "Power and conditioning gain 10% more". "Power" is not one of the ten agreed attributes.

---

## 7. WORLD (7)

Arithmetic checked: ranks 1 to 10 plus Lucy pinned; win-chance bands run in a sensible order (#4 25-62, #6 40-76, #10 60-92); the news line fits the ladder (Priya up two to #5, Nina falling); the title route "#5 to #1: 4 wins" is four wins.

- R1 Done. Both sections gone.
- R2 Done. Ten ranks, Lucy pinned at the bottom with "Enters the table at 4 wins"; no "places up" sentence.
- R3 Done. Win band, scouted, trend, age, finish rate with KO/Sub icon, style; Ask for this fight on rows 4, 6, 7, 8.
- R4 Done. One row of eight faces with state icon and rank; small sport tabs.
- R5 Done. Side by side on the ten attributes, ranges for the unscouted, Ask (grey with its reason) and Scout $250 with what it buys.
- R6 Partly. "#5 to #1: 4 wins" starts at #5, but Lucy is unranked and by this page's own rule is pinned until 4 wins (blocker 1).
- R7 Partly. Champion, challenger, next opponent, scouted, up, down, KO, Sub, bands and faded rows have keys. The state icons on the division picker (camp, injured, offer, contract, free, leaving, retiring) have none; only "booked" does.
- R8 Done. News box kept.
- REMOVE Done.

Blockers
1. Same contradiction as Home: "A win puts Lucy in the top 10" and a title route from #5, against "enters at 4 wins" with Lucy at 2 wins. After beating Priya she has 3.
2. Priya's row shows the green "Scouted" eye while the page says her weakness is not found and the band is the "partly scouted" one. The key needs one word for it.
3. The open tooltip sits over Sofia Lund's row and cuts off her style text.

---

## Contradictions to fix before the next round, in order of weight
1. Lucy: "a win puts her in the top 10" against "enters the table at 4 wins" (Home, World, facts).
2. Aisha's camp: "week 3 of 6" against "40 days" (facts; Home, Week, Profile, Playbook).
3. Aisha's week: goal Takedowns but the session trains Takedown defence; grappling chips differ between the week and the chooser; Tuesday sparring differs from Lucy's page; the Profile sticky says Defence.
4. Aisha's "Fight prep" tab grey on three pages although she has a booked fight; Aisha's contract talk exists on Money only.
5. State icon colours differ between Home and the other pages (Megan, Kwame, Maria).
6. Weight shown on Tomas's Profile, hidden on Home; band words under 45 called "fair".
7. Money: Coaches panel has no hire action; "Power" wording.

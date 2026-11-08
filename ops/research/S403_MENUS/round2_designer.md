# Round 2, designer review of the seven S403 menus

Judged from the seven PNGs against CRITIC_PACK, MOCKUP_RULES, shared_facts, YARDSTICK and roster_mma8. I did not open the HTML `title` text, so tooltip judgements cover only the tooltips drawn open on the stills. Grey and triangle items are treated as planned options, not faults, except where the page contradicts itself.

| Page | Score | Biggest fault |
|---|---|---|
| Home | 7 | A red "stops the clock" need whose button is greyed and cannot be pressed; need counts disagree between pages |
| Fighter Week | 7.5 | The fighter-switching strip and "other fighters" row are text-only and cannot be acted on |
| Profile | 6.5 | No goal, morale, traits, habits or perk road; the game's people-layer is missing |
| Playbook | 6.5 | Plan lines are rated "Beats it / Drilled" for moves the same page calls "not built"; no way to add the 6th line |
| Fight night | 7 | Too many fix rows, with no clear count of which use the two instructions; "left eye 66" has no unit |
| Money | 6.5 | The numbers contradict each other (sponsors, evening classes, "31 members", a falling cash chart) and there is no staff hire |
| World | 5.5 | Its main table, MMA, is greyed; the division shown does not match the selected fighter; tooltip hides rows |

## Cross-page faults (fix these first, they cost every page)

1. The top bar changes meaning page to page: Home "NEEDS YOU (4)" red, Week and Profile and Playbook "(6)" red, World "(3)" blue with a different Menu icon, Money "CONTINUE" with no needs at all. Same day, same state, same open offer (Megan, answer Thu 5 Mar). Rail badges disagree too: Fights shows 1 on Home, Money and Week, 2 on World; Fighters shows 3 only on World. Pick one count rule (red needs only, as in the pack, section 5.0) and compute every page from it. Money must show NEEDS YOU, because Megan's offer stops the clock on Thursday.
2. World is drawn in a different type size, rail spacing and top bar than the other six. The owner's complaint was "no art consistency". Rebuild World from the same kit as Home.
3. Grey, grey-with-triangle and amber are used for three meanings: not usable now, not built, and "waiting". On Home a red-pinned need (Tomas's offer) is greyed and triangled, so the player cannot tell whether the clock stops for it or not. Rule: a need that stops the clock must always have a live button, even if the answer is partly unbuilt.
4. The 11 attributes use two icon sets of different weight (Profile bars vs Week header). Keep one.
5. Status colour used alone: fighter strip dots (green, amber, red), pin colours on Money, the freshness bars on Home. Add a shape (the same icon set) for each state.

---

## 1. Home: 7/10

What works: needs as stickies with dates and one button each, red / amber / grey legend, next-fight card with the 19-day countdown, one row per fighter with a single next-step button, since-last-Monday with causes. It is the right page and the eight rows still fit.

Missing options (given the game):
- No Ask-for-a-fight that works, only a greyed one on Josh (the free, ranked #7 kickboxer). That is right for the pack (pro only), but Josh is the one fighter with nothing booked and no action at all. Give him a live "Find a bout" button so the row is never a dead end.
- Maria (injured) has "Rehab" greyed. Rehab is a decision (physio, how hard); it should open her Week with the rehab plan, not be grey.
- No pad-night need is live: the "Two fighters in camp" sticky is grey "when ready", but the Week page shows the pad-night split is already live this week. The two pages disagree on timing.
- Week review is "ready" and green. The pack says it must sit here and never pop up; fine, but it is the only item the player must do every Monday and it sits at the bottom right of the board with a pastel green that reads as optional.

Information the player cannot act on:
- "Next bills Mon 16 Mar, about $5,668" and the in/out/net block are read-only and duplicated on Money. Keep one line and the "Open the books" button; drop In/Out/Net.
- "SINCE LAST MONDAY" gains are fine, but "4 new members joined, 68 of 70" has no action. Cut or hover it.
- Freshness bar column has no heading text, only a battery glyph. A bar with no number cannot be acted on; it needs the fatigue word on hover and a tick at 80 (overreached).

Icons guessed wrong:
- Scale icon for weight: fine. Battery icon for freshness: guessed as battery or phone charge, not "fatigue". Use the stamina pulse icon the Week page uses.
- The row-leading icons (calendar, arrows, plus-in-circle, envelope, document, hourglass) are all decorative; "document" for a contract and "calendar" for a booked fight are fine, but the plus-in-circle for an injury reads as "add". Use a bandage or cross.
- Josh row uses a calendar-with-dot for "no fight booked". Looks booked. Use an empty calendar with a slash.
- The anvil crest icon under the rail has no label and no function stated.

Works for the other fighters? Yes, this is the page that does best here. Josh's weight 86.5 over 84.0 with "no cut yet" is the only warning in red with no button. Add "Plan cut" there.

To reach 8, in order:
1. Make every red need's button live (Tomas "Hear it", Kwame "Talk"); show unbuilt parts inside the modal, not on the sticky.
2. One need count, same on all pages (see cross-page).
3. Give Josh and Maria live buttons ("Find a bout", "Plan rehab").
4. Cut the In/Out/Net block to the cash line and "Open the books".
5. Replace the battery icon with the stamina icon and add the fatigue word on hover; swap the injury and no-fight icons.

---

## 2. Fighter Week: 7.5/10

What works: this is the strongest page. Fatigue curve with the 80 line, the circled fight, phase bands (PEAK, TAPER), seven days of morning and evening cards with the stat each adds, the coach's one change with its cost on the button, Hold / Cut diet, a twist card with two priced answers, and the pad-night split with the cost to the other fighter in red. A designer would ship the structure.

Missing options:
- No camp controls on the page: focus, intensity (Light / Standard / Hard) and sparring partner (club mate or $160 outside mate). Only "Open Fight prep" is offered. The pack makes these the camp's three choices; the week is where the player will want them. Add a small camp strip above the cards.
- No way to pick the sparring partner per night. Each Sparring card says "with Aisha" but no control. Aisha is a BJJ fighter in camp for Sat 11 Apr; the page does not warn that sparring costs her her own week.
- Intensity per session is shown as dots (two filled of three) but there is no legend. The `Light | Normal | Hard` popover exists in the game; draw the dots as a small three-step icon with a tooltip.
- "Save as template" is greyed-triangled. Fine, but "All mornings Light" and "Back to the coach's week" are live and look identical to the template button.
- Weigh-in is the day before the fight (Fri 20 Mar). It is not drawn on the chart. Add a scale marker on Fri 20.

Information the player cannot act on:
- Stat lines in the header (Stamina +0.26, Strength +0.14, and so on) are useful once; the same numbers repeat on every morning card. Keep the header totals and drop the per-card second line, or keep per-card and cut the header.
- The "SAME PAGE, OTHER FIGHTERS" strip is three sentences of text in cream boxes. The player cannot act on them, and the pack says "no flavour text". Turn them into three mini-weeks (one line each: the plan icon string, one button "Open"). The Kwame line is greyed with a triangle: "Maintain week", that is not a built feature, so it is a promise, not a view.
- The fighter strip at top has coloured dots with no legend.

Icons guessed wrong:
- Stamina uses a heartbeat line, which reads as heart rate or health. Use a lung or a battery-with-bolt, and keep Explosiveness as a bolt. Right now stamina and explosiveness are neighbours with similar jagged glyphs.
- The tiny up-arrow with a number (↑5) on each card is never explained. Two readings: "5 points up", "5 minutes". Add a tooltip and a label on the first card.
- Sparring icon (a glove with a small tick) reads as a clipboard at this size. Pads (a target) is fine.
- Fight IQ lightbulb: fine. Hand speed hand: fine.

Works for the other fighters? Maria (rib injury) the page shows her only as a text line; the grid itself would need a rehab state (only legs and core, no sparring, greyed cards). Draw that variant. Danny (prospect) works. Kwame (veteran, caps equal to now) needs a "maintain" state where the "+" numbers are zero; as drawn every card shows a positive gain, so the page has no honest way to say nothing grows.

To reach 8.5:
1. Add the camp strip: focus, intensity, partner.
2. Mark the weigh-in on the curve.
3. Explain the ↑ number and the dot meter with one legend line.
4. Replace the "other fighters" text with three live mini-weeks.
5. Draw the injured variant for Maria and the zero-growth variant for Kwame.

---

## 3. Profile (Tomas Novak): 6.5/10

What works: the 11 attributes are shown, split Body (8) and Mind (3), each with a bar, potential tick, star for "wins fights", red arrow for "loses them", an 8-week trend. Skills are in a second column with grappling and ground folded and greyed with the reason. "Work on Stamina: open the Week" ties the sticky to the fix. The rival offer sits on top with three answers. Strong.

Missing options (the pack's people layer is almost all absent):
- No goal. The header chip and the Goal card (title, days left, meter, status, "Talk to") are core to morale and the fighter's road. Not on the page.
- No morale word (Fired up / Steady / Flat / Low) and so no hint that a Low fighter ignores the corner.
- No traits, no habits, no coach's notes (n of m). The pack says fighters are people (traits, habits, moods), and habits are what the fight plan and the corner's "habit fix" act on. Tomas's habit would explain "gone by round 3".
- No perk road (Finisher at Power 70 would be nearly reached by Tomas; a perfect pull).
- No record or History access beyond a button; no "next bout" card; no combos.
- Buttons at the bottom (Plan the week, Fight plan, Find a bout, Goals so far) are a second navigation; Plan the week and Fight plan duplicate tabs. Cut them or move the goal button up.
- The Style slider (Patient to Forward) is a good idea but shows no way to see the effect except text; it is the only control on the page. Good.

Information the player cannot act on:
- "8 weeks, change" green sparkline for only three attributes and nothing for the rest looks inconsistent: either every row has a trend or the page says "no change". Right now silence reads as a bug.
- Age line "Age 25: prime until about 31" is useful but needs an action: nothing to do. Hover it.
- Height, reach and stance are facts, fine.
- "Recovery 46 red arrow" and "Stamina 44 red arrow" are the two he needs most, but there is no button that raises either. Only the sticky does. Put a small "Train" button on any red-arrow row.

Icons guessed wrong:
- Explosiveness (bolt) and Stamina (heartbeat line) as above.
- Durability uses a shield, which reads as Blocking or defence. Use a skull with a crack, or a bone.
- Heart for Heart is fine; anchor for Composure is a guess (anchor = steady, ok but not obvious); needs the tooltip, which the owner wanted.
- The warning triangles on grapple blocks are fine.
- "Show" buttons on Grappling and Ground look like a button of equal weight to "Open the Playbook". Make them link-weight.

Works for the other fighters? Partly. Aisha: the striking list would be mostly orange bars with the Grappling and Ground blocks collapsed, so her best skills (Submissions 88, Guard 86) are hidden by default; a rule is needed: the sport group the fighter is best at opens first. Lucy (21, everything still low, high caps) works because of the ticks. Kwame: caps equal now, so ticks sit at bar ends; the "no tick: no room to grow" key covers it. A fighter with two sport tabs (Boxing / MMA / BJJ) is solved, but the tab row shows MMA 8-5 selected with BJJ greyed even though Tomas trains neither; the pack says the sport switch appears only once both are trained. Show one tab.

To reach 8:
1. Add the Goal chip in the header and a GOAL card (title, days left, meter, status, Talk).
2. Add a Mind strip: morale word and three trait/habit chips with their tooltip.
3. Add the perk road as one row of locked and unlocked icons.
4. Add a Train button on any red-arrow attribute.
5. Open the group the fighter is best at by default; show the sport tab only when two sports are trained.
6. Swap shield for a durability icon and unify the sparkline rule.

---

## 4. Playbook (Megan Hughes, Game plan tab): 6.5/10

What works: situation chips, five lines with the answer, the mastery pips, "Beats it / Works" tag, drilled bar, round-by-round pace buttons, the chalkboard that plays a line on hover, the move book by group with the New / Raw / Usable / Sharp / Signature legend, and "Test it". The page gives the owner's "really fun to learn from" feeling.

Contradictions (these cost a whole point):
- The plan rates Teep, Low kick, Elbow and Knee as "Beats it" with drilled bars and 4-pip mastery, while the move book to the right marks Knees and elbows and Kicks as "not built yet in the fight" with a triangle. A design that prices an answer cannot also say the answer is not in the fight. Either grey the whole line with a triangle and "not in the fight until MMA ships", or drop the ratings. As it stands the player is asked to trust numbers the same page says are not built.
- Situation chip "WANTS THE CLINCH" is greyed, yet "In the clinch: Knee" is a live line. Same issue.
- "Offer, not booked: tape opens when it is" and "Beats it / Works" ratings: rated against whom? There is no opponent tell yet (the pack says ratings appear against the opponent's game). The header says rating against "each kind" via chips; the ratings shown are for DANA WHITFIELD, #8 (selected chip), so a rating exists but no tape. Say "Rated against a pressing fighter" in the chip row.

Missing options:
- No "+ Write a line" button, although the header says "5 of 6 lines". The sixth slot is invisible. Show an empty dashed row.
- No coach skill note (the number of lines comes from the assistant coach). Hover on "5 of 6 lines".
- Moves and Combos tabs exist, but the Game plan tab does not link to "Drill on pads" for a single line; only a top-right button.
- No habit/tell link: "What your plan should answer: no tell found yet" at the bottom is in smallest type with a lock; that is the best learning loop in the game and is the footer.
- No "Load a real plan" icon shown (hidden in "More: flow, map, real plans").
- Muay Thai specific: knees, elbows and clinch entries need an "inside" and "clinch" place in the plan; they are present as lines, good. The grappler (Aisha) would need "On top / On the bottom" as live lines; here they are locked "All New: needs one move at Raw". Good, but the lock icon (padlock) is the same as the "grey, not usable now" padlock; keep.

Information the player cannot act on:
- "Fight starts: Stand / Take it down / Keep it standing" are three greyed buttons with a note "MMA first-exchange choice: not built yet". Fine as plan.
- "Combos: 1-2 usable: go-to; + Build one; Kick and knee combos not built yet" is a good row.
- Pace row R1 to R3 at 5:00 each: if Megan's offer is a 5-round fight (top-10 usually five), only 3 rounds are drawn.

Icons guessed wrong:
- The circular-arrow button on each line (change the answer?) reads as "refresh/replay". The same arrow in the toolbar also means replay. Use a swap icon for "change answer" and keep the arrow for replay.
- The drag-handle (three lines) at left looks like a menu or a list; fine for drag but needs the tooltip.
- Pips for mastery: three colours with four segments but the legend row uses a different pattern (blocks). Make the pips match the legend exactly.

Works for the other fighters? Aisha: nearly every line locked, which is honest. Lucy: boxing lines are all live, but "double leg" is raw. Kwame: Cross and Check hook Signature, a short book; the page needs to show a book of four moves without looking empty. Maria (wrestler): the grappling lines are all "not built", so the page for the person with the best plan material looks the emptiest. That is a planned-state problem, not a design fault, but add a "plan the ground game ships with MMA" empty state.

To reach 8:
1. Remove the contradiction: grey the lines and ratings that use unbuilt moves.
2. Add the visible sixth-line slot and a "+ Write a line" button.
3. Move "What your plan should answer" up next to the sound-plan bar, with one button per found tell.
4. Say who the ratings are against, in plain words, in the chip row.
5. Replace the repeated circular arrows with distinct icons.

---

## 5. Fight night: 7/10

What works: dark and tight, as agreed. Handwritten adapted note replaces the coach's line, three stat rows, rows for Habit fix, Plan, Recover (3/3), Set-up, Talk, Cutman, Pace and Aim, "Say nothing" and a single red button. The result side: the Why with Your plan / Against you / What decided it / Next is the best element in the whole set; the scorecards are consistent (three cards 29-28 for Priya, "Unanimous decision"). Body report with "Train the ribs next week". The plan, lit up.

Missing options:
- Throw in the towel is greyed with a triangle; OK. But there is no way to ask for a doctor stop, and the cutman card is the only eye handling. The pack: "stop it (she loses, the eye is safe) or go on" appears; good, and never pre-selected; good.
- No way to see the round so far: no per-round score estimate. The pack says scorecards after each round are held back, so this is correct. But the player cannot see how the plan is going except the three rows. Add a one-line "plan: 2 of 3 answers working this round".
- No switch for watching the 3D round vs a summary: only 1X / 2X / skip controls. Fine.
- Opponent mode is shown ("PRIYA IS PRESSING") but the adapted note says she now shoots when you step back. The mode box and the note conflict visually: pressing vs shooting. Show "pressing, shoots when you step back".

Information the player cannot act on:
- "Left eye 66" and "Nose 38": 66 of what? No unit or bar. A damage number that is not a bar and not a word cannot be acted on. Use a bar with the word (fine, closing) and the cutman card appears from it.
- "Your card R1 10-9" is ambiguous: whose 10? Write "R1: Lucy 9-10" or draw the cards from the player's side. On the result side, "Priya's score first" repeats that ambiguity: the player's fighter should be first.
- "Energy at the bell: R1 62" next to the Energy 62 chip duplicates. Keep one.
- The result page has a "To the scorecards" button although the scorecards are already on the page. Remove it or make the page start without them.
- "On the floor: takedowns on Lucy 5 of 9, escapes 4 of 6, submissions tried 1" is greyed and triangled yet contains specific numbers. If not built, do not show the numbers.

Icons guessed wrong:
- ENERGY bolt chip: same glyph as Explosiveness on the other pages; the owner's 11 attributes use the bolt for Explosiveness. Use the stamina icon here.
- The two dots after "Instructions that get through this minute" are the only count of the two instructions. They are unlabelled and the six rows below look like six choices. Number the rows or show "1 of 2 used".
- The three control icons at top (play, step, skip) are standard. OK.

Works for other fighters? Kwame (veteran, chin going) would need a "durability" row and the fights-left forecast; there is room only in the three stat rows. Tomas (gasses by round 3) needs the Energy chip to be a bar with the round-3 estimate; as drawn it is a number only. Aisha: the Sprawl, Get up, Protect the arm calls are drawn greyed, good.

To reach 8:
1. Count the instructions: show "2 to give" with a counter, and group Habit fix + Plan + Talk as the 'three fixes' (Recover and Set-up are jobs, Cutman is an alert).
2. Give damage numbers a bar and a word; "Left eye 66" becomes a closing-eye bar.
3. Put the player's fighter first on the cards.
4. Remove the redundant "To the scorecards".
5. Reconcile the opponent mode box with the adapted note.

---

## 6. Money: 6.5/10

What works: the whiteboard books, runway ("10 weeks in hand" is right: 14,820 / 1,417), net, next bills (4 x 1,417 = 5,668, correct), in/out bars that sum (1,720 and 1,417), priced upgrade tags with one effect each, the red / grey / green pin legend, dues band and kit budget on chalkboards, contract-talk stickies with the cash left after (14,820 - 2,500 = 12,320). The contract-talk sticky for Aisha is the best piece.

Contradictions (these are lies to the player, so they cost the most):
- Sponsors are already +$400 in "In, a week", but the sponsors strip offers "Sign a sponsor" for the same two (Ironclad $250, Bow Road $150), which total exactly $400. Either they are signed (show them signed) or the income is wrong.
- Evening classes are +$350 in income, but "Evening coach (0 now)" is a buy tag. The pack says classes need a coach.
- "Dues alone cover the costs at 31 members (68 now)": $35 a month is about $8 a week a member, so 1,417 needs about 175 members. Even with all other income it is wrong. Recompute or say "dues plus classes".
- The cash chart falls from $17,200 (W1) to $14,820 (W9) while the page says "Each week the tin grows +$303" and the circled number is in green. A falling line with a green growth label reads as broken. Either the chart shows the last weeks only or it explains the drop (the show-night $16,900 loss, a bill).
- Stipend: Lucy and Danny show "Pay $250" while the other six show 25%. Fine, but the pack says the stipend is optional for amateurs and stops for pros; every MMA pro in the eight should read "stipend n/a, share 25%". Lucy is 2-1 and Danny 3-0, amateurs; consistent.

Missing options:
- Staff jobs: physio ($75, injuries back a quarter sooner), strength and conditioning ($100), cutman ($150 a pro night), second coach. Maria has a rib injury and the page has no physio. This is the biggest missing option; the pack lists the Club > People staff jobs as part of the economy, and "Staff" is a cost line here with no way to change it.
- Loan / overdraft, insurance and the England-Boxing-style fees are not visible; fine as a cashbook detail, but the bills line says "about $5,668" with no breakdown button.
- Camp costs (outside partner $160), pro licence and medicals ($230, $875, $140) for a fighter turning pro: none are previewed. Megan's top-10 offer and Aisha's bout have no cost line.
- Sponsor choice shows names but not what the player gives up.
- Tomas's retention card is greyed and says "the figure shows here", which means the player cannot see what Match the offer costs (the sticky on the Profile says 25% to 20%). Show the weekly number. This is the one decision on the page where money matters and the card hides the number.
- Cage (MMA) premises card: "Price not set", fine.

Information the player cannot act on:
- "Fixes 68 of 70. 140 members, rent +$370 a week. Leaves about 2 weeks": the effect numbers are right; but "leaves about 2 weeks" is runway after the move, good, and actionable.
- The "68 of 70 nearly full" green sticky repeats the premises tag. Remove it or turn it into the Move button.
- The per-fighter share table has eight rows, six of which say 25% and have no button. Collapse the six into one line, keep the two with a Pay button and any contract talk.
- The "FACILITIES: heavy bags worn" is fine and has a button.

Icons guessed wrong:
- The runway icon (a clock) beside "10 weeks in hand" is a time icon but reads as "next bills"; the calendar beside "Next bills" is right. Swap runway to a fuel gauge or a tin.
- Plain shapes for upgrades (house, dumbbell, two people, a figure, a ring) are drawn well; the Club grant bid cube icon is a hexagon with no meaning.
- Colour pins (red, green, grey) carry the legend only by colour.

Works for the other fighters? The contract stickies work for two (Aisha, Danny) and the per-fighter table for all eight. A retiring Kwame ("share ends if retired") is covered, and Tomas has a greyed sticky. Good coverage.

To reach 8:
1. Fix the four contradictions (sponsors, evening classes, the 31 members line, the cash chart).
2. Add a staff-jobs row (Physio, S&C, Cutman, Second coach) with costs and effects.
3. Show the real cost of Match the offer on the Tomas card.
4. Collapse the per-fighter table to the rows that have a decision.
5. Add an upcoming-costs line for Aisha's camp and Megan's offer, and a breakdown on the bills figure.
6. Change the NEEDS state on the top bar (see cross-page).

---

## 7. World: 5.5/10

What works: a fighter strip with one chip per fighter showing the division and an icon for the state; two division tables with a development column; "News: results that touch you", fixtures by date, a Championships card with Open the road. The idea that rivals develop and climb (the DEV column) is the page's best idea.

Faults:
- The page's core table is the MMA division and it is greyed with a triangle. A page whose main content is "not built" is a placeholder, however well filled. Planned, so not a fault of design, but the live table beside it is Boxing women's lightweight, which none of the eight fights in. Lucy is bantamweight; no selected fighter belongs to the live table. The strip text says "Showing women's bantamweight, MMA, and the boxing region", while the live table is titled "Women's lightweight, amateur: the region's club shows". The label and table disagree.
- Lucy appears in the MMA table as "not ranked yet: enters at 4 wins, has 2" in the table and is also in the greyed region, so the page's one actionable row (her own) is greyed.
- Selecting a fighter should swap both tables to that fighter's division; with eight fighters across seven weight classes there is no way to see all of them except clicking each face.
- The tooltip "Developing: sharper each month" covers the last-bout text of rows 3 and 4. Tooltips must not hide the row they explain; place it above the header.
- "Ask for a fight" is offered for Priya Nair, who is already Lucy's booked opponent. The action row should offer "Open the file" and "Scout $250" and hide the ask when the fight is booked.
- "Dana Whitfield offered to Megan Hughes: answer by Thu 5 Mar" is a news line in a greyed box. It is the most urgent thing on the page and has no button. Add "Open the offer".
- Three of four news items are greyed and triangled. A news column that is 75 per cent grey is not a usable column. Show only live items in full and collapse the rest behind a "MMA news when it ships" row.
- Nationals line "a boxer needs 5 bouts, entries close Mon 16 Mar" is for a boxing amateur; none of the eight MMA fighters qualifies, so the card is not actionable for this roster. The pack says Championships is a tab; here it is a small card.
- The No-gi line names Ana Ribeiro, who is not one of the eight; use a roster name or hide it.

Missing options:
- Rival file open from any row (a modal in the pack): rows are links but the page shows no hint.
- Filters: sport (Boxing / MMA, shown), weight class, region, pro vs amateur.
- Belts and the title picture (champions, mandatory challengers) are not on the page.
- Fixtures show only dates; there is no "book" or "watch" action.
- A scout list (who I have scouted, what I know): the pack says scouting is a core loop.

Information the player cannot act on:
- "SINCE DEC" arrows, DEV arrows and last-bout text on eleven rows from other gyms: only rows near the player's fighter matter (the opponent, the next rank above). Highlight the five-place band around each fighter, which is the promoter's reach (about 5 places above), and fade the rest.
- Rank table rows show no stake: what a win over each would give. A 'What a win gives' hover would make the table useful.

Icons guessed wrong:
- Fighter chips: a lock for Josh (no fight) reads as unavailable. A padlock is the grey-state symbol on the other pages; do not reuse it for a free fighter. An envelope for an offer, a plus-in-box for injury, a doc for contract, an exit arrow for a bigger gym's offer, and a people icon for retirement: the last two would be guessed wrong. Use a door for leaving and a rocking chair or a sunset for retiring, or keep text.
- The pencil icon beside rows (next opponent) reads as "edit".
- The DEV arrow (curving up) vs the "since Dec" triangle: two arrows meaning different things in adjacent columns.

Works for the other fighters? Not well. Each of eight needs its own division table; the page shows two at once and switches by click. It works for Lucy and Aisha in concept. Kwame (heavyweight, 37) and Josh (middleweight) have no table drawn. The chips show rank but no way to scroll. Test it with Josh: the page would show the boxing region only.

To reach 8:
1. Rebuild in the same kit as the other six pages.
2. Make the selected fighter drive both tables (their division and sport); show the live table first.
3. Show only the five-place band around each fighter, with what a win gives.
4. Put buttons on the news lines that need an answer (Megan's offer).
5. Fix the tooltip placement, the "Ask for a fight" on an already booked opponent, and the lock / people icons.
6. Add belts and champions in one row, and the scouted-opponent list.

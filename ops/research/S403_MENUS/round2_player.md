# Round 2, the player's review: seven menus, eight MMA fighters

Read in full first: CRITIC_PACK, CRITIC_ACCESS, MOCKUP_RULES, shared_facts, YARDSTICK, roster_mma8. Opened the seven PNGs (the HTML `title` text was not opened, so tooltips are judged only where one is drawn open). I did not open the real game screens.

Summary scores: Home 7, Fighter Week 6.5, Profile 6.5, Playbook 7, Fight night 7, Money 6.5, World 6.

Problems that cut across all seven (fix once, lifts every page):
1. The NEEDS YOU count is different on every page. Home says 4 but shows six sticky notes; Fighter Week, Profile and Playbook say 6; World says 3; Money turns the button into CONTINUE. Rail badges also disagree: Home Fights 1, World Fighters 3 and Fights 2. One count, one rule, drawn the same everywhere.
2. Grey-with-triangle is overused on things the page itself calls active. Megan's best moves (Knee Signature, Elbow, Teep, Low kick) are greyed "not built" in the move book but the game-plan lines that use them are live and rated "Beats it". It cannot be both. Same on Home: "Hear it", "Talk", "Set pads" are greyed because a stat is unmet, but the sticky notes themselves are items I must act on this week.
3. The triangle-warning mark is on so many rows that it stops reading as a mark. When 30% of a page is grey-triangle I stop reading the page. Keep the mark but group the unbuilt MMA stuff into one collapsed strip per page, or show the triangle only on the item's label, not on a whole row of buttons.
4. Numbers disagree with the shared facts or with themselves in small places (listed per page). A player who spots one wrong number trusts none.

---

## 1. Home - 7/10

What I would want to do and cannot:
- Act on a need without leaving: "Answer Megan's offer" opens a page, which is fine, but I cannot see the win chance, the purse or the weight margin on the sticky itself. The one decision that stops the clock in 3 days should show the three numbers I need (chance, money, weigh-in margin vs 5 weeks' notice).
- Sort or filter the eight-row table. With 8 fighters I want to sort by "what needs me first" or by next date. Today the order is fixed.
- See at a glance who is idle. Josh has "No fight booked" and an "Ask for a fight" button greyed; the only free fighter has no live action on Home.
- See a fighter's morale / mood. It is a core mechanic (trust in the corner) and nothing on Home shows it. Only freshness.

What I would never look at or press:
- "MMA CLOCK 5:00, CAGE" greyed pill on the next-fight card: dead weight until MMA, and it is next to the one live button.
- The long column header strip "Your fighters (8) - the button on each row is its next step - your plan - the coach's week" is a legend I read once. Put the two dots in a tooltip.
- The "growing +$303 a week" line is also repeated in the Club This Week panel (Net +$303). Duplication.

Icons that leave me guessing:
- The TODAY column icons (calendar, arrows-in-circle, plus-in-circle, envelope, document, calendar, arrow-out, hourglass). Six near-identical outline circles. The meaning (booked / camp / injured / offer / contract / free / leaving / retiring) is not readable without hovering. Colour the circle by state, and make injured red, offer amber, leaving a door.
- The scale icon and battery icon column headers are fine; the "this week" flag icon at the end of Lucy's row is unexplained.
- The anvil crest under the rail is decoration; it does nothing I can see.

Does it work for each of the eight?
- Lucy: yes, the countdown card is her. Aisha: also in camp but the next-fight card is Lucy only; Aisha's 40-day fight is a row, correct. Maria injured: rehab row ok. Megan offer, Danny contract, Tomas leaving, Kwame retiring: each has a one-line state and a button, good. Josh: weak, nothing actionable.
- Weights: Lucy 60.2 / 61.0 is "1.0 under", it is 0.8. The row maths is wrong for the one fighter whose weigh-in is in 19 days.
- Kwame's weight cell shows "111.0 / -": a bare dash is a placeholder. Say "no class cap, heavyweight".
- Danny 20 years old with a contract note, but "3-0 / -" is the only trace that he is a prospect; nothing says "has growth room". Fine for Home, covered on Week.

What brings it to 8, most important first:
1. Make Needs You consistent (top bar count equals the visible notes; six notes means "NEEDS YOU (6)", with a red/amber split shown as "2 red, 3 amber, 1 grey").
2. Put the decisive numbers on the three red sticky notes (chance / money / weight margin for Megan; what Danny costs to keep; what Tomas gets elsewhere). Today each note is a headline only.
3. Fix Lucy's weight cell, replace Kwame's "-".
4. Colour-code the TODAY icon circles by state and make the legend a tooltip.
5. Add a sort chip row above the fighter table: Needs me, Next date, Weight, Freshness.
6. Add a small mood face (fired up / steady / flat / low) next to freshness, since it changes how the corner works.
7. Remove the "MMA CLOCK" pill from the next-fight card or move it into the fight-prep page.

---

## 2. Fighter Week (Lucy) - 6.5/10

What works: the whiteboard is the right idea, the fatigue curve with the fight date circled and PEAK / TAPER bands is the best single visual in the set. Gains per session (+0.10 etc.) shown on each magnet is exactly the kind of true number I want. The twist sticky with two priced answers is good.

What I would want to do and cannot:
- Drag one session to another day: the text says to, but the cards look locked (no handle, no drop slot). Show a grab handle and an empty "drop here" outline on a day.
- See the whole eight. The bottom strip "Same page, other fighters" gives one sentence for three of them and omits five. It is not a view of the other fighters' weeks; it is a teaser. I need either the strip as small week thumbnails for all eight (colour only for risk) or a "Compare weeks" mode, because the coach's pad nights depend on two fighters sharing the same evenings.
- See the effect of the total Lucy plan against her fight date (3 weeks to peak) in numbers: "Stamina 62.0 to 62.3, target 65 in 3 weeks" is shown, but 62.3 vs 65 means the plan cannot make the target and the page does not say so loudly. The red button says "Do it: Stamina 62.3 of 65" which sounds like success. It should say "still 2.7 short of 65; this week's best fix gets 0.3".
- Swap a morning for a different session on a day without opening a popover (a right-click or a "..." on the card).
- Rest days: two Rests Sunday (Fatigue goes down) but no way to say "rest Wednesday instead".

What I would never look at or press:
- "Save as template" greyed with triangle: I do not see why it is unbuilt for MMA, nothing about it is MMA. If it is a real feature, make it work; if not, remove it.
- The row of session chips (ROADWORK, INTERVALS, ... REST) is a palette. It is useful, but it takes a full row and the greyed unbuilt chips (KICK BAG, TAKEDOWN DRILLS, MAT ROUNDS, CAGE WORK, MOBILITY) are five more greyed things. Collapse into "+ more sessions (5 not built yet)".
- The "Pin a card to keep it in the tray" line is instruction text on screen; a tooltip would do.

Icons that leave me guessing:
- Header summary line: stamina (pulse line), strength (barbell), explosiveness (lightning), fight IQ (bulb), hand speed (hand). Fine, the stamina tooltip is shown open. But the "gains this week" line gives five stats with no sign of what the plan gives up (what is NOT trained, e.g. Foot speed, Recovery, Flexibility zero). Show the zeros so I see the gap.
- The small icons on evening cards (target for pads, glove-ish for sparring, camera for tape) are readable. The "+" green cross next to "5 with Aisha" is a medical cross, it reads as injury. Use two people.

Does it work for each of the eight?
- Lucy: yes. Aisha (in camp, 3 of 6): her own week is not here, and she shares the sparring with Lucy ("5 with Aisha"), so I need her week one click away; the avatar strip at the top does that, good.
- Maria injured: only the bottom strip, "Rehab week legs and core only, no sparring". Good.
- Josh/Tomas/Megan (no bout): they would have no phase; the page must say BASE and still offer a week. Not shown, so I cannot judge it. Danny, the prospect: the sentence "Headroom first" is a nice touch.
- Kwame: "Maintain week" and "Fight IQ 90, protects Durability 31" is greyed with a triangle. A veteran week not being built is a real gap since a fading veteran is where weekly decisions matter most (what do I protect).
- Josh the kickboxer: his best sessions (Kick bag, Roadwork, Mat rounds) are greyed here, so a striker's week is mostly unbuilt; fine as planned but the page for him would be half grey.

What brings it to 8, most important first:
1. Make the "Do it" and goal line honest: show shortfall against target and what would close it ("2.7 short; add 2 Hard stamina mornings and drop pads Tue to reach 64.4").
2. Show all eight weeks in a compact comparison strip, with shared pad nights drawn so I can see the clash.
3. Add drag handles and drop slots; show a ghost of the weekly fatigue change while dragging a card.
4. Show the zero-gain stats in the header summary line (greyed "Foot speed +0.00, Recovery +0.00").
5. Remove or build "Save as template"; collapse unbuilt session chips into one strip.
6. Replace the green cross icon with a two-person icon.
7. Make the Coach's pad nights bar a real control: it is a yellow bar with tiny - and + buttons; show cost to Aisha in numbers ("Aisha: Jab gains 0.04 less").

---

## 3. Profile (Tomas) - 6.5/10

What works: three columns Body / Skills / Mind; the 11 attributes each with a cap tick and a star for "wins fights"; the style slider with its stated cost; the sticky "One big right hand, gone by round 3. Work on Stamina first" with a button that goes to the Week is the best line in the set. The tooltip for Orthodox is clear.

What I would want to do and cannot:
- See what he is like as a person. The agreed model has morale, traits, habits and a goal; this page shows none. The profile loses: goal (the owner's "Goal, N days" chip is gone), morale, perks, coach's notes, habits ("fades late" shows only as a sticky), and the history of results. This is the "Overview" tab; most of what the owner built for months is missing.
- See last results. Eight pro fights, five losses; I want the last three outcomes and how he lost (stopped, points). Only "History" tab holds it, but the Overview has no trace.
- Pick what to train from here. The Stamina bar has a +0.1 trend but I cannot press it.
- Compare with the division. 80 kg of 77 limit, #22 at welterweight, but I never see what a #10 welterweight looks like. A "target: top 10 average" marker would tell me how far he is.
- Change his style slider here (it is described as "you set it" but looks like a display).
- Use the offer. The three answers are on the top strip: "Match the offer: share 25% -> 20%", "Promise something: pick one", "Let Tomas go: stipend ends". Good, but nothing says what the bigger gym is, what it pays, or how likely he stays if I promise.

What I would never look at or press:
- The hidden "Grappling" and "Ground" blocks: two large greyed boxes with their own triangle and "Show" buttons take a third of the middle column to say "not built". One collapsed line "Grappling, ground: not built until MMA ships" would do.
- The BJJ sport tab greyed: the explanatory line "BJJ: not training it. Put Tomas on the mat and it opens." is flavour copy on a page that should show only actions. The tab is enough.
- "Goals so far" and "Fight plan" bottom buttons duplicate tabs.

Icons that leave me guessing:
- The star and the red down arrow next to numbers: the legend at the top right ("how far it can go. No tick: no room to grow. wins fights, loses them") is a sentence of text carrying three symbols. It works only after reading it; put it in a tooltip on the headers.
- Cap tick marks on bars: with the grey bar behind, the tick sits left of the end, and the blue bar fills to the left of the tick; I read the tick as the cap but the empty space after it is ambiguous.
- Heart (heart icon), Composure (anchor), Fight IQ (bulb): the anchor is a guess, a calm face or a steady hand reads better.
- Two bars (Recovery, Stamina) show a red down arrow beside a green "+0.1" trend line: opposite signals on the same row. Explain, or show only one.

Does it work for each of the eight?
- Tomas (power puncher, no stamina): ideal test; the Stamina warning works.
- Aisha (BJJ specialist, poor striker): her striking block would be all weak and the grappling block, hidden for everyone, is exactly where her strengths are. For her the page would show a mostly weak striking column with the strong skills behind a greyed unbuilt box. That is a bad profile for a BJJ player in an MMA game until the ground game lands.
- Kwame (veteran, no room): every cap tick sits on the bar end, which reads as "no ticks"; the legend says "No tick: no room to grow", so the page handles him, good.
- Danny (prospect, all stats around 44-70, caps 70-98): the page would show a wall of long gaps between bar and cap; good, that is a growth story.
- Lucy: boxer learning the mat; BJJ tab, grappling, ground all grey; she would look weak in every column that matters to her plan.

What brings it to 8, most important first:
1. Put back the owner's must-haves on the Overview: goal chip with days left, mood (face + word), 1-2 habit lines ("fades after round 2"), perks road as one row of icons.
2. Add a last-three-results row with how each ended.
3. Collapse Grappling/Ground into one grey line each with the triangle, no "Show" buttons, no big boxes.
4. Make the stat rows pressable: click a bar to open the Week with that stat as the target.
5. Give the bigger-gym offer real numbers (their share, stipend, our retention chance) and put it as the top card with the three answers; it is already there in shape.
6. Fix contradictory trend marks (red arrow plus +0.1).
7. Swap the anchor icon for something that means "calm".

---

## 4. Playbook (Megan, Game plan tab) - 7/10

What works: the lines are plain English ("At long range -> Low kick"), each answer is rated Beats it / Works with pip bars and drill bars, the chalkboard shows the move on hover, and the round pace buttons per round are easy to read. "Sound plan: 3 answers beat the game, 2 work, 5 of 6 lines" is a real hook; it is the fun part.

What I would want to do and cannot:
- Pick the opponent. The tag row (Dana Whitfield #8, Walks you down, Boxes at range, ...) is a filter but I cannot tell which is selected beyond blue. Fine. I cannot compare two plans or reload a saved plan (the "More: flow, map, real plans" button hides it).
- Reorder lines (there is a drag handle on each row but nothing shows a target).
- See which lines the opponent can counter. "Beats it / Works / Walks into it" is vs a style; I would also like to see which line fails against which opponent habit.
- Set the first exchange: "Fight starts: Stand / Take it down / Keep it standing" is greyed with triangles. For MMA this is one of the biggest decisions; unbuilt is understandable but this row is the one I would look at first.
- Edit the combos: the COMBOS strip shows "1-2 usable go-to" and "+ build one" and says "Kick and knee combos: not built yet". Kick combos are Megan's game.

What I would never look at or press:
- The three greyed rows "On the cage wall", "Defending a takedown", "Plan B ...": triangle plus lock plus "Not built yet" text. Three rows of nothing. Fold into one "3 more situations unlock with MMA rules".
- "On top" and "On the bottom" locked rows with "All New: needs one move at Raw" text: for a Muay Thai fighter I would never fill these. They are correctly locked, but they crowd the board.
- The clock icon, list icon and refresh icon beside Watch under the chalkboard: three tiny unlabelled round buttons.

Icons that leave me guessing:
- Per-row circular arrows and X (replace / clear): ok after one use.
- Pip bars (3 of 4 blue) next to each move; meaning (mastery tier) is in the legend on the right "New Raw Usable Sharp Signature" but the pip colours (blue, green, gold) are not tied to that legend: the Knee pips are gold and the Cross pips are green, but the legend shows Usable in green and Sharp in blue. Hmm: Cross is Usable (green), Low kick Sharp (blue), Knee Signature (gold). It is consistent, but I had to check. Put the tier word on hover only; fine.
- "Test it" play button: promising, but "limited tries" is not on the button.

Does it work for each of the eight?
- Megan (Muay Thai): strong; her lines fit. But her best moves are greyed in the move book while the plan uses them (see cross-cutting item 2). That is the headline defect.
- Maria (wrestler, Double leg Signature), Aisha (BJJ, Armbar Signature): the plan board offers only standing rows live; their signature moves live only in the greyed Takedowns / Submissions groups. For both the board would be empty of anything they are good at. They would see mostly "Not built yet".
- Josh (kickboxer): mostly live, as Megan. Kwame (counter-fighter) fine. Tomas fine. Lucy (learning the mat): standing lines fine, ground locked correctly.
- Danny the all-rounder: nothing special; fine.
- The page shows 7 of 19 learned: only for Megan. Good.

What brings it to 8, most important first:
1. Resolve the contradiction: a move the game cannot play yet must not be ratable in a live plan line. Either grey the plan lines that use an unbuilt move, or mark their moves as live in the book.
2. Collapse the unbuilt rows into one strip and use the freed space to show the opponent's likely reply to each of my lines.
3. Put the opening choice (Stand / Take it down / Keep it standing) as one full-width row at the top, even greyed, because it is the biggest MMA decision; it is currently squeezed under the tags.
4. Show the tier word beside each pip bar at normal size (not only the legend).
5. Label the three small round buttons under the chalkboard with a word each.
6. Fix the polaroid: Megan's portrait has scribble text drawn over the face ("ME..." over her chin) that reads as a rendering bug.

---

## 5. Fight night (Lucy v Priya, corner minute + result) - 7/10

What works: dark, tight, handwritten coach note, the minute laid out as rows (Habit fix, Plan, Recover, Set-up, Talk, Cutman), every option shows its price in small text ("+3 each", "-0.5 power, tiring, riskier"). The Why panel is the hook: "No answer for the shot", three lines, a Next line that tells me what to do. The cutman card is placed behind a divider, never pre-selected, and says it does not use up one of the two instructions. That is the best handling of a high-pressure decision in the set.

What I would want to do and cannot:
- See where the fight is. MMA is standing / clinch / ground; this page has no position strip. "Control 0:10 vs 2:10" is the only hint and it is greyed with a triangle. In round 2 against a wrestler I need to know that she is on the ground and for how long. I see "Priya is pressing" but not "Lucy is on her back".
- See stamina for both sides: Lucy's energy 62 appears twice, Priya's energy not at all.
- See round result so far: the Your Card chip row shows R1 10-9, R2 -, R3 -. It does not say whose round R1 was.
- Throw in the towel: greyed with a triangle. In MMA that is a real decision, but while greyed it just sits in the top bar.

What I would never look at or press:
- "Watch 1X 2X" and the three transport buttons plus "Skip to the bell": five controls for a corner minute where nothing plays. I would press Skip to the bell once and ignore the rest.
- The "Round 1 in numbers" panel carries three rows (Landed, Damage, Control) with long bars; Landed 24 of 58 vs 9 of 21 comes across, but "Left eye 66" and "Nose 38" are damage numbers whose scale I cannot read (is 66 bad or good?). A damaged eye shown as a red bar fills the same space as the whole Landed comparison.
- "Aim: Own game / Head / Body / Legs" in the lower strip repeated with "Pace: Push / Steady / Save": useful, but low-contrast and cramped at the bottom, the area I look at last.

Icons that leave me guessing:
- Energy bolt, water drop, snowflake, heart with lock: ok. The eye icon in the cutman row is fine.
- The red dot on the coach note and the blue "PRIYA IS PRESSING" box have no key; the note is the coach, the box is the opponent's mode, but they sit side by side in the same weight.
- Result panel: 29-28 each judge works, but each judge row also shows a row of scores 62, 48, 31 labelled "Energy" with a bolt (Lucy's energy per round?). The bolt on the judge table looks like a typo.

Consistency problems:
- The Why says "Control time: Priya 6:30, Lucy 0:40" while the minute shows control as 0:10 vs 2:10 after one round. 2:10 in one round, 6:30 over three: plausible. Fine.
- The Result panel (after round 3) is next to the corner minute (round 2) on one still, as if the same moment. Make clear this is two pages. As a design for review that is a layout note, not a game fault.
- The Round list "R1 10-9" under Your Card says Lucy 10-9 in round 1; the result table shows Priya's score first, R1 10-9, meaning Priya took round 1. Same label, opposite meaning. Fix by writing "R1 Priya 10-9" or by colouring the winner.

Does it work for each of the eight?
- Lucy v Priya (striker learning the mat vs wrestler): good test, and the page works.
- Aisha (BJJ): fighting a striker, she wants Take it down, Sweeps, Sub attempts. The corner minute would show almost everything greyed (Sprawl, Get up, Protect the arm are greyed here). A BJJ fighter's corner would be mostly unbuilt.
- Tomas (one big right hand, gone by round 3): the corner minute needs "Save energy / Go for it now" as a clear choice; the Pace row covers it.
- Kwame (veteran, legs and chin going): the Recover rows and Talk work, plus Throw in the towel greyed. Good.
- Josh (kickboxer, hates the floor): Aim Legs is greyed. Same for Megan with Knee. The kicking fights have no live buttons.

What brings it to 8, most important first:
1. Add a position/range strip across the top of the round numbers (standing, clinch, ropes, floor) with seconds in each, even greyed for ground until built.
2. Show both fighters' energy and a short damage word beside each bar (Eye: closing, Nose: bleeding) instead of raw 66/38.
3. Fix the round-card meaning (whose round was it) in the Your Card chip row.
4. Move Pace and Aim up beside the corner rows; they are the continuous choices and should not be at the foot.
5. Cut the transport row to Skip to the bell plus a speed toggle.
6. Remove the stray bolt on the judge table.

---

## 6. Money (Club books) - 6.5/10

What works: the sums agree (550+420+400+350 = 1,720 in; 450+416+380+171 = 1,417 out; net +303; 14,820 / 1,417 is about 10 weeks). Price tags with a red pin for "buy now", grey for "not yet", green for owned is a clear scheme. The chalkboards for Dues and Kit are the most readable controls on the page. "Each week the tin grows +$303" with "Dues alone cover the costs at 31 members" is the best sentence on any money page I have seen in this kind of game.

What I would want to do and cannot:
- See the bills. "Next bills Mon 16 Mar, about $5,668" is a headline with no breakdown. A weekly out of $1,417 is not $5,668 a month; I want rent, wages, insurance, fees in a click.
- See a forecast: runway under a plan (bigger unit, one more coach, cut kit). The price tags give one effect line each ("Rent +$370 a week") but no "net after" number.
- Press the Cashbook: it is a brown tab, "every payment, last 8 weeks. Open it." It is the only place a leak would show, and it is a decoration-sized button.
- Sell or cancel: no way to refund an upgrade or end a sponsor. (Ironclad $250 a week is listed as an active deal but I cannot see the end date.)
- Compare per-fighter profit: the Each Fighter table shows share and next money, but not whether each fighter costs the gym or earns it (stipend vs bouts).
- Re-sign Danny from Money (the sticky offers it: "Re-sign with stipend" / "Re-sign as now") but the same decision is a red note on Home. Two places to do one job.

What I would never look at or press:
- The Facilities line ("Heavy bags worn. The rest is fine. Repair, $120") is a tiny tab at the bottom right that would be a Home note; it is a $120 decision, not a money page.
- The "68 of 70 the place is nearly full" green sticky repeats Premises.
- The greyed Club grant bid and Cage tiles: two big grey squares. Cage: "price not set" is placeholder text.

Icons that leave me guessing:
- The row icons on price tags (a building, a barbell, two stick figures, a stick figure with a halo, a poster, a hexagon, a cage grid, a mat) are drawn as simple line art; the "Youth section" two figures and "Evening coach" figure with a plus are fine. The hexagon for Club grant is a mystery.
- Red, grey and green pins: "buy now / not yet / ours" is explained only by a tiny legend text "red pin: buy - grey: not yet - green: ours".
- The small clock beside "10 weeks in hand" has a tooltip open ("Runway: weeks of costs the tin covers"); the other icons beside the headline numbers (cash, net) have none shown.

Does it work for each of the eight?
- Aisha (first top 10, contract talk with a $2,500 bonus option): yes, a real decision.
- Danny (contract ends, stipend or not): yes.
- Tomas (bigger gym calls): the sticky is greyed with a triangle and "the figure shows here" with no figure. The one fighter who is leaving has no number. That is the page's largest hole.
- Kwame retiring: only "share ends if retired". No pension, no farewell fight money.
- Maria injured: "none until Mon 23 Mar". Fine. Josh: "none, no fight booked".
- MMA costs ("MMA fees, travel: unpriced" greyed) is honest. But 8 fighters to feed a gym with $5,668 bills and 68 members is believable; it does not show that eight fighters cost more than the roster of 3 the rules allow. A place counter "8 of 8 places" is missing.

What brings it to 8, most important first:
1. Fill the Tomas sticky with the numbers (what he costs to keep per week, what the other gym pays, what we lose in share).
2. Add a bills breakdown behind "Next bills about $5,668" and make the Cashbook a real button with a visible count.
3. Show net-after for each price tag ("net +$303 -> -$67 a week" for the bigger unit) so every tag is a decision, not a price.
4. Merge the Danny and Aisha contract stickies with their Home notes: the same note, one place to act, the other place a link.
5. Remove the Facilities line from this page (Home or Club); collapse the greyed Cage and Club grant tiles into one row.
6. Show sponsor end dates and a Cancel.
7. Add a roster-places counter and a per-fighter "costs/earns" column.

---

## 7. World (Rankings) - 6/10

What works: the "Your eight" strip with a rank and a tiny state icon is a good hook; the DEV column (Developing arrows, sharper each month) shows rivals as living; the opponent's actions (Open the file, Scout $250, Ask for a fight) sit directly under the table.

What I would want to do and cannot:
- Get at the eight. The strip shows eight faces, but only one division can be opened at a time (Lucy's). Aisha, Maria, Megan, Danny, Josh, Tomas, Kwame sit in six different weight classes; there is no way to see all my fighters' standings at once. A "My fighters in the tables" row for each would tell me the real story.
- See a championship path: no belt, no title picture, no gap to the next rank. The Championships tab is present; this Rankings tab does not tell me "Lucy needs 4 wins, #5 Priya is two places up".
- Use the news to act: "Rosa Lindqvist won by stoppage" is Aisha's opponent and it is greyed with a triangle; I want a Scout button right on the news item.
- Search or filter the table by gym or style (twenty ranked per division in the rules).

What I would never look at or press:
- The whole MMA table is greyed with a triangle, but it carries the single most important opponent info (Priya Nair, the next fight) and the live buttons "Open the file / Scout $250 / Ask for a fight" at the foot. If those are live, the table is not "unbuilt"; if the table is unbuilt, the buttons are a lie.
- "Your eight" strip icons: calendar, arrows, plus, envelope, document, lock, exit door, two people. They are the same icon language as Home's TODAY column and just as hard to tell apart.
- The Boxing table titled "Women's lightweight, amateur" (Lucy is a bantamweight at 61 kg, so she does not belong there) and the first row Imogen Frost with a 14-2 record is not relevant to anyone in my gym. For a pure MMA release this table is the wrong default: first show the table for the selected fighter's own division.

Icons that leave me guessing:
- The "Dev" column arrows in green and the small pen icon on Priya's row (the "next opponent" mark) are in the footer legend, but the legend at the foot of the table is tiny.
- The tooltip drawn over the Rankings table ("Developing: sharper each month. Rivals who improve climb the table") covers the last-bout text of rows 3 and 4. A tooltip should not cover content in the style sample.

Does it work for each of the eight?
- Lucy: her row appears as "-" under the MMA table, "not ranked yet: enters at 4 wins" with a calendar icon. Good, and she faces #5; she cannot reach #5 by one fight, which is realistic.
- Aisha #9 flyweight, Maria #5 flyweight, Megan #14 featherweight, Josh #7 middleweight, Tomas #22, Kwame #12 heavyweight: all have a rank in the roster file, but the page can show only one table at once; for six of the eight I see nothing.
- Danny, 3-0 lightweight: unranked, no row.
- Tomas, Josh, Kwame: men; the women's tables shown do not matter to them; the page does not switch.

What brings it to 8, most important first:
1. Make the table follow the face that is selected: click Aisha, see the flyweight table with her row highlighted and her next opponent marked. Today only Lucy's is drawn.
2. Resolve the greyed MMA table that has live buttons: either the table is real (MMA rankings exist in the mockup) or it is not.
3. Add "where I stand" per fighter: rank, gap to next, title or contender status in one line each, under the strip.
4. Put an action on each news item that touches me (Scout, Open the file, Ask for a fight).
5. Move the tooltip so it does not cover table text.
6. Default the page to the selected fighter's division, with the other sport behind the SPORT switch.
7. Count and rails: unify the Fighters 3 / Fights 2 badges with the other pages.

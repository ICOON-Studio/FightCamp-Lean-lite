# S403 menus, round 1: senior designer review

Seven pages read as PNGs, judged against CRITIC_PACK, MOCKUP_RULES, YARDSTICK and roster_mma8.json. I did not open the HTML, so tooltip text is judged only where the stills show it open. Grey and warning-triangle items are treated as planned options, not faults, except where the grey state is applied inconsistently (said where it happens).

Overall: the look is coherent and the information density is good for a PC sim. All seven look like one game, which was the owner's complaint last time. The recurring problems are (1) the seven pages do not agree with each other on facts (dates, opponents, who is injured), which makes the set read as seven mockups rather than one game; (2) several pages are built around one fighter and give no way to run eight; (3) icons are used well on Home and the Week, but a few icon-only rows (Home "The club this week") would be guessed wrong; (4) the MMA-specific decisions (weight class change, striking vs ground plan, camp split) are shown as greyed future items but their absence from the live layout means the live layout is still a boxing layout.

| Page | Score |
|---|---|
| Home | 7 |
| Fighter Week | 6.5 |
| Profile | 6.5 |
| Playbook | 6 |
| Fight night | 6.5 |
| Money | 6.5 |
| World | 6 |

---

## Cross-page defects (fix these first, they cost every page points)

1. Facts contradict across pages. Home (Mon 3 Aug, week 31): Lucy fights Priya Nair in 19 days, Maria Ortega is injured 3 weeks. Fighter Week (Mon 2 Mar, week 9): Lucy fights Maria Ortega in 19 days / "fights in 12 days" in the same page, tape study of Maria Ortega, and Aisha is camp partner "week 3 of 6" while Home has Aisha in her own camp. Fight night calls the opponent "Priya Ortega", 10-3 #5, wrestler who grinds on the wall (that is Maria Ortega's data with Priya Nair's first name) while Home says Priya Nair, 3-1, wrestling club. World is on Mon 12 Jan, week 2, with Lucy fighting Maria Ortega on Sat 31 Jan. Pick one calendar day and one fixture list and use it everywhere. A critic or the owner will read these as bugs in the design.
2. Fight night result: three judges all 28-29, header says "Split card". Three identical cards are unanimous. Also "Priya's round" beside "10-9 on your card, Rounds 0-1": whose round was it? Fix the data.
3. Number of rounds and length: the MMA release fights 3x5 (or 5x5 for a title). Fight night, Home and the Week all still read as three short boxing rounds ("Round 2 of 3", "R1 R2 R3" pace). Show the real MMA round clock (5:00) or the page is not "ready for the release".
4. Greying is applied inconsistently. In the Playbook the game plan lines Teep, Low kick, Elbow, Knee are live and coloured, while the same moves in the Move book are grey with warning triangles ("not built yet in the fight"). A player cannot tell if a kick line works. Same on Fighter Week: Low kick and Double leg cards grey, "Cross" card live, but Lucy's evening already says "Tape study: Maria Ortega" for a fight in which grounded moves are the opponent's whole game. Decide one rule: a thing that cannot fire in the fight is grey everywhere it appears.
5. One top-bar state shown three ways: NEEDS YOU (2) red on Home, NEEDS YOU (3) blue on Week/Profile/Playbook, CONTINUE on Money. Fine as states, but the blue vs red NEEDS YOU is meant to mean "clock stops" versus not. Say it by the colour rule consistently, and the count must match the Home notes (Home shows six notes and a count of 2).
6. Tooltips drawn open collide with content. Week: the open Stamina tip covers the "Click a day to change a session" line; the fatigue tip hides the fatigue explainer line; Playbook: the Knee tip sits on top of the legend. A still can't hover, but opened tooltips should sit in empty space and never hide a number. Show one, not three.
7. Weight is the first real decision of the game and MMA makes it worse (class change, hard cuts: Aisha, Josh, Tomas "very hard cut"). It is a tag on the profile, a column on Home, a pill on the Week. Nowhere is there one place that says: kg now, limit, kg to lose, days left, diet, and what the cut costs in fatigue/strength. Give it one consistent chip (scale icon + "now / limit") that appears on Home, Week header, Profile header and Fight night tale of the tape.

---

## 1. Home: 7 / 10

What works: needs as sticky notes with the clock rule in one line; the next-fight strip; one row per fighter with a status icon; Since last Monday with causes; Coming up. It is the best of the seven and the structure matches the agreed plan. The eight-fighter table fits without scrolling.

### Missing options
- Row-level action. The table says "click a name for the fighter page" and that is the only action. The jobs the player does every Monday with eight fighters are: open this fighter's week, set camp, accept/pass an offer, book a fight. Put one verb button per row where there is a state (the Today column already has icons; make the icon the button: calendar = Fight prep, envelope = Answer, document = Talk, exit arrow = Hear it). Today only Josh's "Ask for a fight" is a button, and it is grey.
- "Week plan done?" per fighter. This week column shows what the plan is (Pads, sparring, roadwork) but not whether it is written or a coach default, or whether it is stale. With eight fighters the player needs a tick or a dot for "I changed this" versus "coach week", and the coach's one change as a flag.
- Injury and fitness detail in the row: Maria (rib) shows "No offers until fit" in a tooltip, good, but Kwame's chin/durability (31, the legs are going) has no warning anywhere on Home.
- Weight cuts: the weight column is the right idea but "2.6 to lose, 26 days to go" is cut into two grey lines; a cut that is behind schedule (Tomas, 3.0 to lose, amber bar) needs the days left on the row, not only in Since last Monday.
- Sort and filter: eight rows is fine; nobody will want a filter. Do add sort by next fight, because the next event is what you scan for.
- Nothing for the second walk-in / a prospect, the BJJ athlete Ana, or a free roster place. Roster limit and open places should be one line ("8 of 8 places, full").

### Useless or repeating information
- "Aisha is 2.6 kg over, cut on pace" appears in Since last Monday, in the weight column of her row, and as a red/amber row. Pick one. Likewise Maria's rib injury appears in Since last Monday, the Today column, the tooltip and again on the Money page as a sticky note.
- "Danny Osei's contract ends" is a sticky, then a Coming up line, then a Money sticky. Three places for one decision. The decision lives on one page; the others link.
- The Coming up list repeats the same fight dates already on the next-fight strip and in the table.
- Club this week: the four rows are unlabeled icons with numbers ($1,720, $1,417, 68 up 4, Luke Reid). Money in, money out, members, coach: only the first has an open tooltip. "Luke Reid" next to a clipboard icon is guessable by nobody. Members and the coach carry no action; "Luke Reid" is not actionable. Cut the coach row and put "Open the books" as the only action.
- All six sticky pins are the same red. The legend says red stops the clock, amber comes next, the rest can wait. Visible colour of the pins should carry that (red: Megan offer; amber: Tomas, Danny; steel: Kwame, pads, week review). Right now the colour system is stated and not used, and the top bar says only 2 needs.
- "MMA RULES, CAGE" grey chip in the next-fight strip is a constant reminder of a missing feature; it should appear once (a tooltip or a single "MMA rules not built" mark on the strip), not on every page.

### Icons and tooltips
- Good: the Today icons (calendar, shoe/camp, cross for injury, envelope, document, circle, exit arrow, hourglass) are a reasonable set. The exit arrow for "a bigger gym has called" is plausible, the hourglass for retiring is a guess (it reads as "waiting"). The "no fight booked" circle-dash reads as "do not" and is wrong: use an empty calendar.
- Column heads: scale and battery icons with no text. Scale is clear; the battery for "freshness/fatigue" is clear only because of the bar. Fine, but the bar colour must mean fatigue risk and the tooltip must say the number (e.g. "62 of 100, overreached from 80").
- The sticky notes use handwriting for the body text; the two-line reading is fine but "Answer by Thu 6 Aug." is small italic on a busy yellow. The deadline is the actionable part: bold it or make it a stamp.

### Does it work for the other seven fighters?
Yes, it is built for eight. It fails on Kwame: age 37 retiring is a sticky note, but nothing shows him as a retirement risk in the table (age, decline arrow). Booked/camp/injured/offer/contract/free/leaving/retiring are all covered by icons, which is the best use of the roster in the set.

### Fixes to reach 8
1. Make the status icon a button (one verb per state) and delete the "click the name" instruction line.
2. Colour the pins by need level, make the deadline a bold stamp, and make the top-bar count match the notes (or say how many are red).
3. Remove duplicates: contract ends, injury and cut each live in one place; the right column keeps only things that are not on the table.
4. Add a coach-week vs "mine" dot and the coach's one-change flag to the This week column.
5. Label or cut the Club this week icons; keep only money in/out, with "Open the books".
6. Fix the "no fight booked" icon, and show age/decline on veterans (Kwame) in the record column.
7. One MMA-not-built mark for the strip, not a chip per item.

---

## 2. Fighter Week: 6.5 / 10

What works: the whiteboard metaphor is correct, sessions are cards with the gain they add, the fatigue bar with peak and overreach marker is a very good, honest number, the coach's one change has the effect on the button ("Do it: 62.3 of 65, still short, peak fatigue 75 -> 76"), the twist card has two priced answers, the pad-night split between two fighters (Lucy 2, Aisha 1 of 3) is the new agreed row and it is present. Kick bag, takedown drills, mat rounds, cage work, mobility greyed with warnings is exactly the planned-option treatment.

### Missing options
- A fighter switcher. With eight fighters and two in camp the player moves between Lucy's and Aisha's week constantly. There is no previous/next fighter arrow or a thin strip of the eight portraits. The pad split row is the only link to Aisha and it is a label, not a route.
- A camp overview. Two fighters share the coach's pad nights, but the player cannot see Aisha's three pad nights from here, nor what the split does to her (the red note "Aisha's Jab gains less on 1 night" is the only cost). Show the other fighter's pad column faded in the same grid, or a two-row bar.
- Sparring: who, how hard, what it risks. Evenings say "Sparring" and a gain, with no partner choice, no injury risk, no load spike warning (acute/chronic ratio, which the game has). The Fatigue bar covers fatigue but not injury; one icon (bandage) with the risk band on each Hard or sparring card.
- Weight forecast. The diet pills Hold / Cut 500 kcal are there with no kg result. Show "now 60.2, on the day 60.6, limit 61.0" next to the pills. For Aisha and Tomas (very hard cut) this is the whole week.
- The fight date on the board. The agreed look is "the fight date circled". Here the fight is "in 12 days" in text; the grid shows this week only. Add a weeks strip (this week, next week, fight week) with a circle on Sat 21 Mar and the phase colours (base, build, peak, taper).
- Copy week / apply to all days / repeat. Changing seven mornings one popover at a time is slow. "Set all mornings to Light" and "copy last week" are the two things a repeat player wants, and a one-click "taper" in fight week.
- Rest: nothing shows days off as a decision beyond Sunday cards; a "rest" magnet should be draggable like the others.
- No undo / "reset to coach's week" for a single day (only the whole week).

### Useless or repeating information
- "-9 night" under every evening card (e.g. "72 -9 night") is cryptic. It is the fatigue number at night and the change; without a label this is noise. Show only the fatigue line once as a thin sparkline under the week, not seven small numbers.
- The first line lists five gains (Stamina +0.26 etc.), then every card repeats its own gain, then the coach's line repeats "Stamina 62.0 -> 62.3, target 65 in 3 weeks". The total is useful; the target line plus the coach's line plus the Do-it button are three statements of one fact.
- "Evenings: Pads, Sparring, Film, Rest. Each session Light, Normal or Hard." is a how-to line permanently printed.
- Header chips: Camp: Peak, Fights Maria Ortega, Camp partner Aisha Rahman: three chips plus the Peak pill in the board header plus "Fight in 12 days". The same facts four times.
- "MORNING" tray of sessions at the bottom: the nine chips are the palette, fine; but each chip repeats the word of its session icon.

### Icons and tooltips
- Session icons (sun in the corner of every morning card, target for pads, pencil for sparring, camera for tape study, moon for rest) are close to guessable; the sun on every morning card says nothing, it is a "morning" marker and could be removed since the row already is the morning row. The pencil for sparring is wrong: a pencil reads "edit". Use two gloves.
- The stat gain chips with icons (heartbeat for stamina, dumbbell strength, bolt explosiveness, lightbulb Fight IQ, hand speed) are the right use of icons. The fatigue bar with a battery is good.
- Intensity: NORMAL / LIGHT as tiny capsules with a battery number is too small to read as a choice; use three-step dots or a segmented control on the card.
- Pad split buttons (50/50, 70/30, 30/70) are fine as text.

### Does it work for the other seven?
Partly. For a wrestler or BJJ specialist (Maria, Aisha) the morning palette is boxing-heavy (roadwork, speed bag, slip rope) with mat rounds greyed; with kick bag and takedown drills greyed they have almost nothing real to schedule. That is a content gap the mock makes honest, but it means the page is nearly useless for the grappler until MMA lands. For the veteran (Kwame, no room to grow, caps equal now) the "+0.14 per week" gains and "target 65 in 3 weeks" do not apply: the week for a veteran is maintenance and recovery; the page needs a "no room to grow" state that swaps the gains for "keeps his edge / protects the body" and shows durability risk. For the young prospect the headroom is the story but it is not shown (a ceiling indicator on the stat chip).

### Fixes to reach 8
1. Add a fighter strip (eight small portraits with a dot for needs and a camp marker) above the board, plus left/right.
2. Add a weeks strip with the fight date circled and the phase colour; remove the duplicate chips.
3. Put weight forecast (now / on the day / limit) beside the Hold / Cut pills.
4. Show the sparring partner and an injury-risk icon on Hard and sparring cards; replace the pencil with gloves.
5. Replace the seven "-9 night" numbers with one fatigue line under the week; remove the permanent how-to line.
6. Show the other fighter's pad nights in the shared-pad row, as a two-colour bar of three nights, with the cost to each.
7. Add "copy last week", "all Light", and a "veteran / no growth" state so the veteran and the grappler both have a real week.

---

## 3. Profile (Tomas Novak): 6.5 / 10

What works: three columns with the agreed 11 attributes in Body and Mind, skills grouped Striking / Grappling / Ground, a "style you set" slider, a sport switch (Boxing / MMA 8-5 / BJJ greyed), a single sticky with one thing to work on, and the rival-gym offer as the top card with three answers. The bars show now and ceiling (tick), with a weekly change number. Hover text says what each number does. This is a credible RPG-style board.

### Missing options
- Weight: the header tag says "very hard cut" but there is no weight line on the page (kg now, class limit, cuts per camp, class change). For an MMA athlete one body means a weight class and moving class is a real decision (Lucy fights at bantamweight, Megan at featherweight). Add weight, limit, and a "move up a class" action.
- Contract and goals are a button ("Contract and goals") rather than a visible card. The offer from a bigger gym is on this page, so contract length, wage, share and the goal talk should be one glance (a small contract strip) and the three answers should preview their price ("Match the offer: stipend $X, share 25% -> 20%").
- Injury history and durability story: "No injury, Fresh" only. A fighter page needs the damage ledger (last injuries, body places hurt, fights left) because Durability is a headline attribute here (Kwame 31).
- Age curve. Age and a stat ceiling are shown but not the prime window. A veteran and a prospect read the same on this page except for ticks. Add "prime until 31 / past prime, declining" as one line with an icon.
- Scouting: skills with a range (prospects, unscouted) are not on the page; the page assumes exact values. A prospect (Danny) should show ranges until trained/scouted.
- Style dial: it is set by the player but there is no effect statement of what Forward does besides "starts fast and presses", and nothing shows the opposite risk (gone by round 3; Tomas has stamina 44).
- Which coach trains which skill ("one thing to work on and where it is trained") is in the sticky note but is not a button. Make "Work on: Stamina" a button into the Week with the sessions highlighted.
- Primary attribute potential ("how far it can go"): ticks are shown but no overall potential (stars) like the signing card; the player decides keep/sell on this page.

### Useless or repeating information
- Moves block (Cross: Signature, Lead hook: Sharp, etc.) duplicates the Playbook; the rule says moves stay in the Playbook, not on the attribute page. Keep a one-line "5 of 19 moves, signature Cross" and a link.
- 17 skill rows is too many for a glance. The grappling and ground rows are grey for a striker, which is correct for planning, but a power puncher sees a wall of grey bars. Collapse Grappling and Ground by default with a one-line summary ("ground game: weak, 16-30").
- The sticky note says "Stamina 44 and Recovery 46 are the weak spots. No ground game: Guard 24, Submissions 16" and these numbers are right there on the bars. It is a good coach voice but half of it repeats the board. The new info is the action line only.
- "Fresh" and "No injury" as two separate items in the body footer, plus the header chips; and the height, reach, stance footer (stance repeated in the header, and the tooltip explaining it). The tooltip about stance being a fact, not a bar, appears open and covers the Body footer.
- "Not built yet: needs the running world..." italic line under the offer duplicates what the greyed buttons and triangle already say.

### Icons and tooltips
- Attribute icons (dumbbell, bolt, hand, feet, heartbeat, loop-back for recovery, infinity for flexibility, shield) are a strong set; flexibility as infinity is a guess but tooltips cover it; Composure as an anchor and Heart as a heart are good.
- Ruler icons for height and reach are both the same ruler, so "179 cm tall" and "182 cm reach" are told apart by text only; fine, text is right here.
- The warning triangles beside whole rows (Clinch, Guard) say not built; the triangle repeated six times on one column is clutter, one triangle per group header is enough.
- Colours: orange bars (weak) versus blue (OK) are used consistently with Home's meaning; add a legend or put "weak under 45" in a tooltip.

### Does it work for the other seven?
It stresses the roster decently: the wide grey ground block fits a striker, but for the grappler (Aisha) the Striking block becomes a grey, weak half and the ground half is not grey; the page needs a way to open on the sport/skill group that matters. For the veteran the ceiling ticks sit exactly on the bar end, the bars show nothing about decline; for the prospect (Danny, caps 26 above now) all bars look alike, so the story "nothing bad, nothing great yet" needs a ceiling/hidden-potential line. The sport switch shows only Tomas' view; Lucy (boxer learning MMA) needs an unlocked MMA tab with crossover cost, and a pure boxer needs the MMA tab visibly locked.

### Fixes to reach 8
1. Add a weight line (kg now / limit / cut difficulty) and a move-class action to the Body column.
2. Make contract visible as a strip (length, share, wage, ends in X weeks) and preview each answer's price on the offer card.
3. Collapse Grappling and Ground (and unused groups) to one summary line unless the fighter trains them.
4. Replace the moves block by one line and a link; keep the sticky for the single action and make "Work on" a button to the Week.
5. Add an age/prime line and a "no room to grow" state for veterans, and scouted ranges for prospects.
6. Add the injury ledger (last injuries, fights left) beside Durability.
7. Group the grey/not-built triangles: one per group.

---

## 4. Playbook (Megan Hughes, Game plan tab): 6 / 10

What works: the plan as rated lines against a kind of opponent (Rate against chips, each line Beats it / Works / Walks into it), the chalkboard preview that plays the move, lines-used meter 5 of 6, round pace R1-R3 Push/Steady/Save, "Test it / See the flow / Open the map / Load a real plan". The move book with levels and grey-with-triangle for not built. The owner calls this area the fun part; the bones are right.

### Missing options
- The plan is not tied to a bout. "No bout booked: try the plan against each kind of opponent" is correct for a rating but there is no way to pick the actual upcoming opponent (the Offer is open: "top-10 fight, 5 weeks' notice") and see the lines rated against her file. The agreed fight-prep link ("What your plan should answer") is missing: scouted tells with a "Write it" button for each.
- Drill status per line. The game's own rule: a plan the fighter has not drilled works less well. The lines show a rating and not how much pad time they have. Add a drilled bar or "Raw/Usable/Sharp" on each line (already a chip for the move, but it is the move, not the line), and a "Drill this on the pads" button which drops the card into the Week.
- Round-by-round plan. Pace is per round, but the lines are not. Real plans change by round (take the kicks early, clinch late). At least R1 / R2+ lines or "switch at round 3".
- MMA structure: the plan has lines for Outside, Long, Mid, Inside, In the clinch, On the cage wall, Defending a takedown, On top, On the bottom. For the specialist this is the right skeleton. The missing choice is the first-exchange game: "who wants to take it down / keep it standing" (a default stance for the fight). That one setting decides MMA plans, with a risk of being taken down.
- Adaptation: opponents adjust by round 2 (agreed). The page shows no "what happens if she adapts", e.g. a second answer per line (plan B). Without this the Fight night "she has adapted" note has nothing to point to.
- Combos and Moves tabs are not on the page, so I cannot judge them; the tab strip also carries "Escapes are in Moves" as a note rather than a design.

### Useless or repeating information
- Each line shows move name + level chip (SHARP) + rating chip (WORKS / BEATS IT). Two chips per line plus the same moves again in the Move book on the right with the same levels. The right column could be the single place for levels; lines show only the rating.
- "THE PLAN SO FAR Sound plan" with a bar, plus "3 answers beat the opponent's game, 2 work", plus the lines meter 5 of 6, plus rating chips on each line: four summaries of the same quality. Keep the one sentence.
- "Go-to combination: None drilled yet; build one under Combos" plus a grey chip "Kick and knee combinations" with a triangle. Redundant; the chip is not an option.
- Header chips (Muay Thai, Marks easily, Offer: top-10...) repeat Home; the opponent chip should be the one live link.
- The portrait carries a baked-in name ("MEGAN HUGHES") under a polaroid that already has a caption: the name appears three times.

### Icons and tooltips
- Move-book group icons (hand, feet, a slash for knees/elbows, dumbbell for takedowns, padlock for submissions, scale for Ground) are weak: the dumbbell for takedowns and the scale for ground are guesses; the padlock reads "locked" when it means "submissions". Use a joint-lock/arm icon, or text only here.
- Warning triangle at the right of each group and on rows (Teep not built etc.): the repeated triangle plus greying is clear enough; more than half the page is now triangles, which hides the fact that the live part is the lines.
- Watch, Steps, Drill, Replay, Slow motion: five buttons, play icon on Watch only. A play/triangle, steps, loop, rewind and slow-motion icon set would do it with tooltips.
- Pace chips PUSH / STEADY / SAVE as text across three rounds is correct (a decision); fine.

### Does it work for the other seven?
Weak where it matters. Aisha (BJJ): the lines that matter are On top, On the bottom, defending a takedown; they are grey with locks ("No move at Usable: only New") for Megan, which is right for Megan, but for Aisha the whole list would be live and the striking lines empty, and the move book (7 of 19) has a very different shape. The page's right column is sorted by group in a fixed order; it should open on the fighter's strongest group. The veteran Kwame (counter fighter, lines "Wait to counter") and the one-punch Tomas (a go-to combo, round 3 fade) need "tires" and "loads up" situations rated; Rate against shows the situations, which is good. Prospect: not enough drilled to hold six lines; the page should say so (a locked line says what unlocks it, which it does).

### Fixes to reach 8
1. Add an opponent selector (the booked/offered opponent or each kind) and show each line's rating against his file, with "Write it" for found tells.
2. Add drill level per line and a "Drill on the pads" button that opens the Week with the card dropped in.
3. Merge the four quality summaries into one, remove the move level chip from lines, keep levels in the move book.
4. Add a round split (R1 / R2+ / when she adapts: plan B per line).
5. Add the MMA fight-start choice (stand / take it down / keep standing) as the first setting above the lines.
6. Fix the move-group icons (use grapple/lock/arm shapes) and sort the move book by the fighter's strongest group.
7. Show Moves and Combos tabs in the same pass so the owner's "really fun" area can be judged.

---

## 5. Fight night: 6.5 / 10

What works: dark and tight, the coach's handwritten note, one corner screen with clear rows (Habit fix, Plan, Recover with 3 points, Set-up, Talk, Cutman, In the round), the "she has adapted" note replacing the coach's line and marking the line that stopped working (ADAPTED chip on "Step back, then jab"), "Two instructions get through this minute: 2 left", the cutman card flagged NEW and never pre-selected, the result with the three judges, the Why (Your plan / Against you / What decided it / Next), the body report with a "Train the ribs next week" button, the plan lit up. This is the strongest page for how well it follows the agreed design and the Why.

### Missing options
- Stop the fight / throw in the towel. For MMA a corner can end a fight; there is a cutman stop but no general "stop the fight" or "pull her out" button for a fighter who is hurt and ignoring.
- Position and what to do. For the ground (In the round: Sprawl, Get up, Protect the arm greyed), the options are named but there is no position indicator (who is on top, where) in the numbers block; the "Stand-up / Cage wall / Floor" bar has a warning triangle, so this is deliberate. When it is built, the shout bar needs a position strip. For now the live set of 3 shouts from boxing (Jab and move, Tie up, Hands up) plus 3 greys is fine.
- Round-score so far. The bout is judged on rounds; the corner minute says "10-9 on your card, Rounds 0-1" but then "Priya's round": a clear running score per judge (or your card only) is important for deciding Push or Save in the last round. Show the card for every round in a row of small boxes.
- Fighter condition: only energy (62 with a bolt icon). Hurt body places, cuts, damage so far (which Body report only gives after). A small body map with the hurt places is the corner's real information. Right now Recover offers "Ice on the ribs" without a visible reason on the same screen except "-3 body hits".
- Watch controls: 1x/2x, step, skip to bell are there; "Sim the round" and "Skip bout" are not, and neither is a choice of highlights vs full. The tale of the tape before the fight and weigh-in are not shown; fine for one page, but the pre-bout screen (the other half of the player's decision) is not among the seven.

### Useless or repeating information
- "Replaces the coach's note from round 2. The line that stopped working is pre-marked below." is design commentary on a game screen. Cut from the mock or move to the tooltip. The ADAPTED chip and the note already say it.
- "Round 1 in numbers" shows 24 of 58 / 9 of 21 landed and then control time, takedowns, floor time: seven numbers when the agreed rule is three rows in the minute. The two grey rows with triangle are not built; but even the live row "0 of 1, 2 of 5" looks like takedowns and costs reading time. Keep three: landed, damage, control.
- The "Cutman" row is shown and pre-selected nothing: correct and the rule says only when an eye is closing, so showing it on the same screen as "Left eye closing" is the conditional state. Fine; but the page also carries the text "Only when an eye is closing" on its label; drop that line from the real game.
- Header "Watch 1X 2X" plus "Skip to the bell" plus "Start round 2 with this plan": three ways to end the minute.
- Result: "Priya Ortega wins on points" plus judges plus "Lucy now 2-2" plus "Priya 10-3 #5"; fine. "After Back home: the goal talk" is a caption the player doesn't need.

### Icons and tooltips
- Bolt for energy, water drop + bolt for recovery, snowflake for ice, heart for clear her head (with a padlock), eye for cutman: all good. Dots (+3 each ... ) for the number of recover points are a clear use of icons.
- Control icons (play-next, skip) are guessable. Dumbbell/clock icons in the numbers block (down arrow = takedowns?, clock = control time) are guesses; the target icon in the middle is landed, which is fine, but the down arrow and clock need titles and a plain label.
- Talk options (Calm down, Fire up, Tell the truth) must stay words: they are decisions with the prices written under each. Correct.
- Pace and Aim chips as text: correct (decisions).

### Does it work for the other seven?
Mostly it is a page about one fight. For a kickboxer (Josh) the "In the round" row works (Jab and move, Hands up) but the leg-kick answer is missing in the shouts; for the BJJ fighter (Aisha) three of the six shouts and all the numbers would be grey/ground, i.e. the page is largely unbuilt for her, and "Stand-up / Cage wall / Floor" is the key bar. For the one-punch Tomas, "Go for the finish" and the late-round energy plan matter more than any of the rows shown: the corner needs a visible "loads up now" clue from the opponent mode (the opponent fights in one mode at a time, per the pack); here "PRESSING NOW" is a chip near Priya's name, small and easy to miss. For a veteran with chin going (Kwame), the Talk row should show a cost if he is hurt (trust, ignores).

### Fixes to reach 8
1. Fix data: the opponent name, 28-29 x3 "split", "Priya's round" vs 10-9 on your card.
2. Cut the round numbers to three rows (landed, damage, control) and the design commentary lines; make the opponent mode ("pressing now / waiting to counter") a large clue chip in the middle of the page.
3. Add a body map of hurt places and cuts beside Recover, so each Recover choice shows what it fixes.
4. Add a running scorecard (one box per round per judge) and "stop the fight" as a corner action.
5. Show MMA round length (5:00) and number of rounds in the header.
6. Add a position strip (stand-up / clinch / cage / ground) to the In-the-round row, greyed for now.
7. Show what the Why costs: add one line on the result card: "Money and members move" only if a link to Home; remove the post-Back-home caption.

---

## 6. Money: 6.5 / 10

What works: the books as a whiteboard with a cash-last-12-weeks line, in/out bars, "each week the tin grows +$303", runway line (10 weeks), bills date, the 8-weeks-below-$0 warning, price tags as notes (bigger unit, strength corner, youth section, evening coach, club show, club grant, cage, mats), dues and kit budget as chalk options, stipends, sponsors, facilities, and sticky notes for decisions (contract talks for Aisha, Danny's contract, Tomas' bigger gym, 68 of 70 members, Maria's physio). It reads as the gym's tin, not a spreadsheet, which the owner demanded. The "place is full" sticky and "Keep 25%: pay $2,500" show that money decisions are tied to the fighters, which is correct for this game.

### Missing options
- Per-fighter finance. The stipend list shows two people but not what each fighter earns the club or costs it (purse share, ticket cuts, camp costs). The pack says per-fighter costs are held back, so this is allowed; but with eight, "who pays for themselves" is the question; at least a net weekly figure per fighter in the stipend list.
- Forecast and bills. "Bills Mon 17 Aug, $3,960 so far" is a header line; there is no list of what is due when (rent, fees, insurance, tax, licences), nor a "pay later / spread" option. MMA adds medicals, licence fees, travel and fly-in costs ("Regional MMA show, fly to feather"), cage hire. None appears under costs.
- Fight purses and the promoter. The gym's share of a pro purse and the next payday should be on the page: "next purse: Megan, top-10 fight, gym share $X, in 5 weeks". Right now money comes in only as dues, classes, sponsors.
- Loan/overdraft and a "what if" line. The game has a loan for debt starts and an overdraft rule; a gym 10 weeks from empty with a sudden $12,000 move needs to see the effect before buying ("Leaves 2 weeks of costs" is in the Bigger unit note, good); the same line must be on every buy button (Strength corner says "Leaves 7 weeks"; Club show says tickets range; Youth: no such line).
- Staff: Hire second coach, pay changes, let go: only the evening coach is here; the agreed second club coach is a Club > People job, but a money page that is about staff costs should link.
- Members and dues band: shown at the bottom, and the dues band choice is on a chalkboard; the effect on members (Cheap +15% members, Premium -30%) is in a line of tiny chalk text. The decision with the highest money impact is the smallest thing on the page.

### Useless or repeating information
- Runway appears three times: header (10 weeks in hand), "8 weeks below $0 closes the gym" and "Each week the tin grows"; plus the chart. The close-the-gym warning belongs in the header only when a risk exists (runway under 8 weeks), as the rule says; at 10 weeks of runway and positive weekly net it is noise.
- Contract talk for Aisha and Danny and Tomas' offer also appear on Home as sticky notes and on Profile; here they are again as stickies. The money consequence is the new piece, keep that only.
- The chart has two axis labels W20/W26 and a $17,200 label; the single point labels ("$16,900 show night", "$14,820") are useful; the dashed $0 line is good.
- Two lines about ticket cuts: "A bout adds a $450 ticket cut" and the one-offs list shows bout ticket cuts of $1,350 and the club show line; fine but "Dues alone cover the costs at 31 members (68 now)" is a good line, while "Hover a line for its weeks" is a how-to.
- The Cashbook sticky "every payment in and out, last 8 weeks. Open it." duplicates the "One-offs last 8 weeks" box above it.

### Icons and tooltips
- Price tag icons (house, dumbbell, two figures, person, poster, hexagon for grant, cage grid, mats) are decent; the hexagon for grant is a guess; the cage is a grid, correct.
- Lock icons on "Price tags" and on "needs a second coach (1 now)": the lock means "can't buy"; good, with a reason. The coloured pins (red/grey/green) on each tag are the status: they must be explained once.
- Runway: clock icon with "10 weeks in hand" and its open tooltip is correct; the tooltip explains the number, which is what tooltips are for.
- Stipend and dues choices as text pills are correct. The icon for "Sign a sponsor" (tag) and "Facilities" (wrench) work.

### Does it work for the other seven?
The page is gym-level, so it matters through the notes: Aisha (contract talks), Danny (contract ends, full-time stipend), Tomas (bigger gym), Maria (physio) are all represented, which is good use of the roster. The stipend panel says "The other six are pros or past amateur: no stipend, they take a share"; with eight fighters it is a long path from 8 people to 2 rows: pros have shares and bonus structure that need their own mini-list (share %, ends in N weeks). For Kwame (retiring) there is no money consequence (end of share, send-off). MMA events cost flights and fees: a "Regional MMA show, fly to feather" appears on World and nowhere in costs.

### Fixes to reach 8
1. Add a "due soon" bills list (dates and amounts) and the next purse/ticket income per fighter.
2. Show the effect line on every buy button ("leaves N weeks") including the club show and youth section; make the dues band control bigger with the member effect.
3. Add a per-fighter net line to the stipend/contract area (cost and return), with shares for pros.
4. Cut duplicate content: the Cashbook sticky, the runway warning when not at risk, and the notes repeated from Home; keep stickies only for decisions that cost money.
5. Add MMA costs (medicals, licences, travel, cage) as greyed lines in Out a week.
6. Move the loan/overdraft state and staff pay into the page (even as a greyed row) so the page is the whole book.
7. Explain pin colours once (a legend or a tooltip on the first pin).

---

## 7. World: 6 / 10

What works: Rankings per division as a table with a Developing arrow and the Since column; sport toggle (Boxing / MMA greyed with a triangle); one sticky listing "Your eight on the tables"; Around the region limited to what touches you; Fixtures and events; the no-gi line at the bottom (the belt is the ladder). The open tooltip on Developing explains it well. The right column is a good filtered news feed.

### Missing options
- A way to get from a ranking to an action. A rival is a link (click a name for the file), but nothing on the page lets the player act on the table: ask for a fight with the #4 (the agreed Ask for a fight), scout, or see which of my eight is near this table. The top-three opponents and "Dana Whitfield, number 1, is on the table for Lucy: not safe" is a news line; make the row clickable to the bout page.
- Championships and the road: the tab exists, but on this page the player cannot see where their fighters stand in a title/entry race (nationals entries close, needs 5 bouts, has 4 in the news line). A "my road" strip per fighter under the table: next step, what it needs, dates.
- Filtering: eight divisions (women's flyweight to men's heavyweight) as chips, one table shown for boxing and one for MMA at the same time. Both tables at once is a good use of space, but the chips mix a boxing row and an MMA grid in a way that is hard to read (what is selected?). Show which division is open and the player's fighter row highlighted in each.
- Rival detail inline. A click opens the rival file (modal); a hover with style, tells found and a "scout" button would save the trips.
- Movement over time: Since Dec arrows only. A rank sparkline per fighter or a "moved 2 places up" is enough; but for your own fighters a line chart of rank over months in the club's records is missing (fine, it was held back as a progress chart).
- Other organisations: a fighter's ladder across promotions (MMA has regional shows, "fly to feather", "light to heavy": weight class change fights). The fixtures list has them greyed, which is right; the option to enter or ask is not on the page.

### Useless or repeating information
- The sticky "Your eight on the tables: Ranked Josh #7, Kwame #12, Aisha #9, Megan #14, Tomas #22. Unranked: Lucy, Danny." repeats the ranks already shown by the chips on each division (#5 #9 etc.), Home and the fighter list. It is a pointer to the table; with the player's rows highlighted in the tables it can go.
- "Around the region" repeats fixtures (Lucy fights Maria Ortega on Sat 31 Jan also in Fixtures; Nationals entries close in both). Use news for results and moves, Fixtures for dates.
- "RIVALS DEVELOP" red ribbons on each table header plus the Developing column header plus the tooltip: the ribbon states the feature, not the information; show the arrow only.
- The no-gi bar: "Ana Ribeiro 4-2 in opens... No-gi has no ranking table: the belt is the ladder" takes a full-width band on every visit for one fighter who isn't one of the eight; fine for boxing release, but with MMA this belongs in Fixtures.
- Menu tooltip (open at top right) is irrelevant to World.

### Icons and tooltips
- Fixtures icons (calendar for shows, crossed gloves for novices, document for entries close, cage/hexagon for MMA, medal-like for amateur regionals) are guessable but the crossed gloves look like a slash; three different calendar-like glyphs.
- Development arrows (green up-trend, red down triangle, = for no change) and a knife-like icon on Maria's row (what is that? a takedown icon? unclear) and a dumbbell on Aisha's; these side icons in the Dev column look like they mean a skill. Without a legend they are guessed wrong.
- Greyed sport toggle and the warning triangles: three triangles in the header (chips, MMA toggle, table) are one fact.
- Rank chips in the division chips (#5 #9) are text and small; use a highlighted player's row instead.

### Does it work for the other seven?
It names all eight (five on tables, two unranked), and a division chip appears for each class, which is exactly what the roster test wants. But it is an MMA flyweight table only: Women's Bantamweight (Lucy), Featherweight (Megan), Lightweight (Danny), Middleweight (Josh), Heavyweight (Kwame) show a dash or a rank with no table beneath, so for seven of eight fighters the page is just a chip. The player needs a second table slot or a "my fighters on their tables" view: eight rows, rank, nearest opponent above/below, last move. The unranked (Lucy and Danny) are the prospects with nothing to read: the page shows "enters at 4 wins (3 so far)" for boxing only.

### Fixes to reach 8
1. Add a "My eight" view: one row per fighter with division, rank, the fighters above and below, and the fighter's next step to move up.
2. Make a row clickable to a bout/ask action (Ask for a fight, Scout) with the agreed reason when refused.
3. Highlight your fighter's row in each table and remove the sticky that repeats ranks.
4. Remove the duplicate news/fixtures lines; keep one list sorted by date and one for results that touch you.
5. Replace the Dev-column side icons with a legend or text ("developing", "wrestling takedowns").
6. Put the Championships road (what she needs, dates) as a strip under each table.
7. Move the no-gi line into Fixtures; drop the "Rivals develop" ribbon.

---

## What the set still lacks as a whole (beyond per-page)
- The pre-fight screen (tale of the tape, weigh-in, scouting file, "what your plan should answer") is the other half of the fight decision and is not in the seven; the Playbook and the Week both lean on it. It is in the agreed menu list; judge it before building.
- Eight fighters need one place to compare them quickly (potential, age, contract, fitness). Home's table is that place but carries no potential or contract; add one icon column for "contract ends" and one for "ceiling".
- The planned MMA features that are greyed should be stated once per page ("MMA rules and the cage are not built"), not per element.

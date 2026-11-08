# Round 3 - designer review of the seven menus (S403)

Judged against CRITIC_PACK (the game as it will be at MMA release), MOCKUP_RULES, shared_facts, YARDSTICK and the eight-fighter roster. Judged from the seven stills only; the tooltip `title` text in the HTML was not audited. A warning triangle is read as a planned option, not a fault. Scale: 6 = works but would be rebuilt in places; 8 = I would ship it.

| Page | Score | Biggest fault |
|---|---|---|
| Home | 7 | The matchup card hides what you need to decide (win chance, stakes); pin colours contradict the legend |
| Fighter Week | 7 | Own numbers contradict each other (3 pad nights shown, 2 allocated; weight 60.4 vs 60.2 on Home); the coach's advice does not fix the gap it names |
| Profile | 6 | Built for a striker; a grappler's profile would collapse into a text paragraph. Star and arrow icons unexplained |
| Playbook | 6.5 | Plan ratings claim "Beats it" with nothing scouted; the move preview is a placeholder diagram, not a body |
| Fight night | 6.5 | Contradicts itself in three places and carries too much in the corner minute |
| Money | 6.5 | The shop does not rank purchases by what they do; the first card is the worst buy; no discipline coaches |
| World | 5.5 | Half the page repeats Home; the one real world table has no decision power |

---

## 1. HOME - 7/10

### What works
Needs-first board, the four needs match shared_facts, one row per fighter with a state icon plus the action pill, the cash/bills box with a link to the books. It is the best of the seven. The row-per-fighter table survives eight fighters.

### Options missing (given the mechanics)
- **Win chance and stakes on the matchup card.** Lucy (2-1) fights Priya (9-3, #5), and the card shows only a countdown, the weight and a "3 x 5:00 CAGE" chip. The game computes a win band, a rank at stake and the weight risk. A player deciding whether to cut, camp hard or pull out needs the band (e.g. a bar "long shot, wide: unscouted") and "a win takes #5". Same gap on Megan's note (she is #14 and the opponent is #8, with no chance shown).
- **Members and reputation.** The club box has cash and bills only. 68 of 70 places is the fact that makes the second coach and the bigger unit matter (Money says "the place is full"), but Home never shows it. Add a members chip, e.g. "68/70", with a small reputation tick.
- **Find a fighter / sign.** Rail has no Grow entry and Home has no way in. With 8 of 8 places used it is arguably right to be absent, but then say why: grey "Find a fighter" with "roster full, 8 of 8".
- **Contract and stipend state per fighter.** Danny's contract end is the whole need, but the row shows nothing about what he is paid.

### Information the player cannot act on
- "Since last Monday" lines have no action (Lucy's hand speed 62 to 63, Danny's Fight IQ). The causes are worth keeping (agreed), but give each line its one next step where there is one: Maria's rib gets "Plan rehab", which already exists in the row, so link it.
- Weight cells: "2.5 over, no fight, no cut yet" for Josh and "3.0 over, no cut yet" for Tomas. With no fight booked there is nothing to do; show it grey-small or drop it. Two red weights with no action read as nagging.

### Icons likely to be guessed wrong
- Today column: Aisha's camp icon (arrows between two blocks) reads as "strength training"; Josh's icon (a circle with a slash inside) means nothing; Kwame's hourglass reads "waiting", not "retiring". The same state uses different icons on World (Kwame is a bell there, Josh an empty circle). Pick one icon per state and use it on every page.
- The circled "F" flag on Lucy's week, and the blue/hollow dots after every "this week" plan, have no key. If the dot is "coach runs it / I run it", say so in a tooltip; if not, remove.
- Scale and pulse column headers are fine but need tooltips ("weight now / limit", "freshness").

### Other fighters
Works for all eight. The table is the strongest part; Kwame and Josh rows are sparse but honest.

### Fixes to reach 8 (most important first)
1. Matchup card: add a win-band bar with its width (wide = unscouted) and one chip for what a win/loss does to the rank ("win: take #5"). Same chip on Megan's note.
2. Pin colours must follow the legend. Four red pins are counted as needs, but Danny's is four weeks away and a Thursday-before-Friday-before-Monday sequence cannot all "stop the clock". Danny's pin amber, and make the top bar's "2 stop the clock" a number a player can verify from the pins (it currently matches none of the dates). The amber legend chip is on the board and no pin uses it.
3. Promote "Two in camp: the pads" out of grey. It is a real conflict (Week page) that changes Lucy's training this week; it is the only note with a trade-off. Make it amber and say "Lucy 2 / Aisha 1 pad nights, unset".
4. One icon per state across Home, Week, Profile, World (see above), with a one-line legend in the table header tooltip.
5. Fill the empty bottom-right: put members 68/70 and reputation there. Currently a third of the right column is blank.
6. The top-bar sentence differs per page ("2 stop the clock. First: ..." on Home, Money, World; "Answer Megan Hughes's offer by Thu 5 Mar. Time stops there" on the others). One bar, one sentence.

---

## 2. FIGHTER WEEK - 7/10

### What works
The whiteboard planner with the fatigue curve behind it, phases coloured, fight date circled, the 80 overreach line, forecast per attribute at the top, per-session "+stat" and fatigue arrows, the twist card with two priced answers, the coach's one change with its effect on the button. This is the core mechanic and it looks like the fun part. The eight-avatar switcher on top is good.

### Contradictions to fix (these cost trust)
- **Pad nights.** Coach's pad nights say Lucy 2 / Aisha 1 of 3, yet Lucy's grid shows three Pads evenings (Mon, Wed, Fri) plus two Sparring. Either two of the three pads are hers and the third is visibly Aisha's (greyed with "Aisha's"), or the split is 3/0.
- **Weight.** Home: 60.2 / 61.0, 0.8 under. Here: 60.4 of 61.0 and "now 60.4". One fact set was the whole point of round 2.
- **Advice versus action.** The coach says "Takedown defence 41 is the gap" and the Do-it button makes Monday roadwork Hard for stamina. Nothing on the page trains the named gap (takedown drills sit greyed under "+5 MORE"). It is fine that they are not built, but the advice must then point at the greyed chip: "Takedown defence 41: the fix is Takedown drills (not built yet)". Right now the player is told one thing and sold another. Also the camp focus chips are Stamina / Hard; the Priya matchup needs a defence focus.
- Jab is Lucy's Sharp move and is not in the pad tray; the tray shows Cross, Body hook, Lead hook, Uppercut, Low kick, Double leg, 1-2.

### Options missing
- **This week / next week.** Today is Mon 2 Mar; the page is Next week (9-15 Mar) only. The current week (2-8 Mar) is half-played and the left of the curve shows it, but there is no switch. The pack has THIS/NEXT.
- **"Coach runs it / I run it"** per fighter (agreed, not built): needs a visible switch on this page; it is the answer to eight fighters' weeks.
- **Undo / "copy last week".** Plain, useful, not there.
- Sparring partner choice per night (the "with Aisha" tag is not a picker) and its cost.
- A way to see the opponent's gap in one place: the quote is the only link; add a chip "Priya: shoots, Takedown defence 41 is your gap" that opens Fight prep.

### Information the player cannot act on
- "ALL EIGHT WEEKS" strip at the bottom: tiny block glyphs, unreadable at game size, and the avatar row already switches fighter. Cut it or make it a real "who is unplanned" row (one icon per fighter: planned / not planned / coach-run).
- "Foot speed 0, Recovery 0, Flexibility 0, Durability 0" as a grey line: keep, it shows what is not trained, but only one such line, with a lock if the sessions exist and are simply not chosen.

### Icons likely to be guessed wrong
- Roadwork and intervals share the same "Stamina" arrow glyph. Fine (same stat), but then Weights / Heavy bag glyphs repeat for different stats. The glyph belongs to the stat, the label to the session; keep that, but draw a different glyph for Intervals (a stopwatch) so the grid scans.
- The dot rows (Light/Normal/Hard) and "up-arrow 5" need the legend that exists at the top right; keep it and make it larger. The "peak 75, Fri 13 Mar" and "Fight Sat 21 Mar" labels overlap the curve itself: they read badly in the one place the player looks first.
- The target ring beside "Pads" and the cup-like icon beside "Sparring" are guessable only with the tooltip; add the word on first view.

### Other fighters
- Maria (injured): the whole grid must turn into a rehab week with disabled sessions and reasons. Not drawn; say "Rehab: sessions greyed with the reason" in the header when injured.
- Josh (nothing booked): no phases, no peak; the chart would be flat BASE. Fine if the curve simply drops the phase bands.
- Kwame (37, Durability 31): fatigue costs differ; the sessions' "up-arrow N" must be per fighter. It is.
- Aisha (camp week 3 of 6): the phase bands will be BUILD, not PEAK/TAPER. Fine.
- Grapplers (Aisha, Maria): the session library lists only striking/conditioning sessions; the "+5 more" row hides mat rounds, takedown drills and cage work behind a triangle. For two of eight fighters that is their main training. Move mat rounds and cage work out of the "more" list into the main chips with the triangle on the chip.

### Fixes to reach 8
1. Reconcile pad nights, weight and the coach quote (the three contradictions above).
2. Add THIS WEEK / NEXT WEEK and "Coach runs it / I run it" in the header row beside "Back to the coach's week".
3. Put grappling sessions (mat rounds, takedown drills, cage work, mobility) in the visible chip row with the "not built" mark per chip, so the grappler's week can be drawn.
4. Replace the bottom "all eight weeks" strip with the unplanned-fighters row, or cut it.
5. Fix the chart label collisions (peak and fight labels sit on the line).
6. Give the twist card quantities: "Train through: knee injury risk +x%" and "Rest: fatigue 68 to 63" are the right shape; the first option has no number.

---

## 3. PROFILE (Tomas Novak) - 6/10

### What works
Body / Skills / Mind in three columns, each attribute with a bar, a cap tick and a weekly change; 11 attributes shown correctly with Hand speed and Foot speed apart; the habits and traits panel with the Patient-Forward slider and the one sentence that turns numbers into a plan ("Forward starts fast; Stamina 44 runs out by round 3"); the rival-gym card on top with three answers; the sticky "work on Stamina: open the Week" is a good action-on-information. Perk road is clear.

### Biggest faults
- **It is a striker's page.** Skills show seven striking bars; grappling and ground are a paragraph of numbers in a box with a warning mark. Half the roster (Aisha, Maria, Danny, the ground game of anyone) lives there. A BJJ specialist would have seven striking bars in the 30s and a wall of text for what she is good at. Make the Skills column a three-way switch (Striking / Grappling / Ground-cage) with the same bar component, show the fighter's top three skills first, and make the not-built part a header mark, not a text blob.
- **Unexplained icons in the corner legend.** "how far it can go star, down arrow, info" gives three marks with no mapping. On the bars, Recovery 46 and Stamina 44 show a red down arrow beside a positive +0.1 delta. Is the arrow "below the weight class norm", "falling", or "weak point"? The star beside Explosiveness and Strength is "strength" (top attribute) or "at cap"? Strength 86 of 94 is not at cap. State it in the page: star = top three, arrow = weak point, and have the tooltip say it.
- **The goal is not clearable and is labelled "at risk".** Stamina 44 to 50 in 21 days at +0.1 a week is +0.3. The design promise is ~70% clearable goals; this one is impossible. Either show the goal as OFF TRACK and the offered fix "set a goal you can reach", or the weekly delta must be shown as what a focused week gives (about +0.9 on a Hard plan). As drawn the number the player is looking at says the game is cheating.
- **The decision card is missing its main fact.** "A bigger gym offers Tomas $600 a week more; match costs the gym $120 a week." What does Tomas earn now? What does $120 buy? Why does matching $600 cost $120? None of that is on the page. Add "now: $250 stipend, 25% share" and an explanation tooltip on the $120. It is also a decision with three entrances (Home "Hear it", this card, Money "Match / Let go") and Money offers only two of the three answers (no "Promise something"). One decision, one set of answers.

### Options missing
- Contract and pay (stipend or share, end date) for every fighter; Danny's page needs it more than anything.
- Injury and fight history in one line (the goal card has the last three, good): add the age curve for veterans ("prime until about 31" exists in text, make it a small bar).
- Weight class "Move up a class" is greyed with a lock and a triangle: good. A "Cut" option with a date is not available because no fight is booked: fine.
- Only Recovery and Stamina carry a "Train" button. Why those two? Put it on every attribute with a gap, or on none (the sticky already links the Week).

### Information the player cannot act on
- Height, reach, stance are facts with icons; fine and small.
- Morale line "Below 30 stops listening to the corner": keep (the pack uses trust), but it is a tooltip, not a sentence.
- Perk road: six perks shown, eight exist; the others (Counter sense etc.) are hinted. Fine. But "Finisher is open: Explosiveness reached 70" in the drawn tooltip uses the old Power stat in the pack; check the rule text matches the 11 attributes.

### Icons
- Durability uses a skull. A skull says "death/KO" and sits beside the Iron chin perk (also a skull-like head). Use a shield or a cracked-shell glyph for Durability.
- Counter sense uses the same target icon as camp focus on the Week page. Different thing, same glyph.
- Lock beside the scale line is ambiguous (locked weight? locked class?). Spell out "no fight booked: no cut date".

### Other fighters
- **Aisha (BJJ):** fails as described: striking bars in the 30s, grappling in a paragraph.
- **Danny (prospect):** caps are far above current; it works, but "how far it can go" should show "unknown until a trial/scouting" for a prospect with the Amateur-coach edge off.
- **Kwame (veteran):** cap equals current on every row; the cap ticks sit on the bar ends and the stars/arrows are meaningless. The page should switch to a decline view: each attribute's yearly drop, "fights left", retirement option next to the talk.
- **Maria (injured):** injury needs a prominent place; currently a small "no injury in 12 months" line. For her it must be the top card with the return date.
- **Megan (marks easily):** a label tag exists in the header; fine.

### Fixes to reach 8
1. Skills column to a Striking / Grappling / Ground switch with identical bars; fighter's top three first.
2. Explain stars and arrows in one visible legend line; remove contradictory arrow-plus-delta pairs.
3. Fix the goal so it is clearable or marked off-track; show the weekly rate from the actual plan.
4. Put current pay and what matching buys on the rival-gym card; make Money show the same three answers.
5. Pay/contract line in the header chips for every fighter.
6. A veteran/decline variant (age curve, fights left, retire talk) and an injured variant (return date on top).

---

## 4. PLAYBOOK (Megan Hughes, Game plan tab) - 6.5/10

### What works
The plan as lines with "answer, rating, drilled bar, change/clear" is clear and readable; Rate against chips; pace by round; fight-starts; "Sound plan" meter; the locked lines say what unlocks them; the move book by group with mastery pips is a good reference. The "you can always see how your plan made the difference" idea is carried through.

### Biggest faults
- **Ratings claim certainty they do not have.** The header says "only record and style are known" and then rates three answers "Beats it" against Dana Whitfield. If nothing is scouted, "Beats it" is a guess from style. Mark the rating as estimated (hatched chip or a "?" until scouted) and show how confident ("style only: wide"). The game's whole promise is that the Why is honest; the plan page cannot oversell.
- **The preview board is a placeholder.** Two circles and an arrow with the words "low kick". The pack says a body plays each move. For a game whose fun is "to try and also learn from the book", the preview must be a mannequin showing the zone hit (leg, ribs, head) and the distance. Draw a silhouette with the target highlighted and the defender's reaction.
- **Stand-up and cage states are mixed in one list.** "Outside, At long range, At mid range, Inside, In the clinch" are five places on one axis, then the cage states (Wall, On top, On the bottom) are separate banded rows below and greyed. A striker needs the stand-up axis; a grappler needs the ground axis. Offer a two-tab switch (Standing / Cage and ground) so Aisha's page is mostly the second tab and Megan's the first.
- The "Outside" and "At long range" lines are hard to tell apart for a player; draw the five places as a small range ruler above the lines (the same icon on each line).

### Options missing
- "Scout $250" or "Wait for tape" on the locked line "no tell found yet". World has Scout; the Playbook lock should offer it (pro/MMA opponent) with the price and what it opens.
- Fight-starts choices (Stand / Take it down / Keep it standing) show no consequence. Which option does Megan's profile favour? Add a "best for Megan" mark and a grey reason on the one she cannot do (Takedowns 30).
- Aim (head/body/legs) from Fight night is not set in the plan; fine, but a "legs first" plan against a wrestler is an obvious MMA line and the Game plan has no field for it.
- Moves tab and Combos tab content are not drawn on this page; judged as agreed, but the Combos tab is the part the owner calls fun, and none of the seven pages shows it. A seventh still is needed.
- How to learn a new move: "A new move needs a coach who teaches it" is a sentence. It needs a button "Find a coach for Takedowns" that opens the Money staff list (see below).

### Information the player cannot act on
- "Sound plan: 3 answers beat the game, 2 work, 5 of 6 lines" is useful; the half-blue bar is not read by anyone. Turn it into a number out of 6 with colour.
- The chalkboard text "Default play: long range, Low kick. Beats: walks you down" repeats the chips; show it only when a line is hovered.

### Icons likely to be guessed wrong
- Submissions use a chain-link glyph (reads "link/share"). Takedowns use a double chevron (reads "collapse"). Kicks use a diagonal stroke. Knees/elbows use a return arrow. The group names are beside them so the damage is low, but if you keep the icons, use a hand, a leg, a knee, an arm-lock, a mat figure.
- "Test it: limited tries" has a play glyph that looks like Watch. Use a flask or dice.

### Other fighters
- **Aisha (BJJ):** needs On top / On the bottom lines live (Armbar Signature, Triangle Sharp). The locked row currently says "needs one move at Raw", which she has, so it unlocks; works.
- **Lucy:** boxer-first; most lines Boxing; takedown and kick lines are Raw and greyed. Works.
- **Kwame, Tomas:** works; Tomas has few lines (5 moves), the 6-line cap is the right pressure.
- **Danny (all-rounder, everything Usable):** the move book would be full of Raw/Usable; the six lines are a real choice. Good.

### Fixes to reach 8
1. Mark every rating as estimated until the opponent is scouted; show the width.
2. Replace the chalkboard arrow with a body (silhouette plus target zone) for every move.
3. Split the board into Standing and Cage and ground, with a range ruler on the first.
4. Add Scout/Tape action on the locked line, "best for Megan" on the fight-starts row, and "Find a coach" on moves that need one.
5. Draw the Combos tab as the seventh still; it is the owner's favourite part and it is not in the set.
6. Replace the chain, chevron and diagonal icons.

---

## 5. FIGHT NIGHT (corner minute and result) - 6.5/10

### What works
Dark, tight, handwritten coach note, the fixes cap ("pick up to two"), the opponent's mode as a clue, the cutman card that is not preselected, the Why with four plain lines that name the next action, the scorecards that agree with the label (28-29 x3 is unanimous), the 3-up rows of damage bars. It looks like a place you would not leave.

### Contradictions (fix these before anything else)
- **Set-up is greyed with "Lucy has no combination yet. Drill one on the pads."** The Week page shows Lucy with the 1-2 combination (Usable, jab-cross) in her tray, and the Playbook of Megan has "1-2 usable: go-to". Either Lucy has it or she does not.
- **The Why says "3 right answers, 2 wrong, 1 neutral"**; the lit-up plan below lists 3/4 + 1/1 + 2/3 right = 6 right and 1/4 + 0/2 wrong-ish = more than 2 wrong. The two panels must add up. A player will check one against the other.
- **"Pick up to two" with three gold outlines** (habit fix, step back plan, tell the truth) and "2 left". Selected state must be visibly different from the coach's default.
- "Clear head" and "Set-up" are greyed with a lock; Clear head has no reason. Every grey needs its reason.

### Options missing
- **Legs** in the body bars. Six sites per fighter (L eye, R eye, nose, jaw, L ribs, R ribs); the Aim chips offer LEGS. In MMA low kicks are a whole game; show L leg / R leg and the leg-kick count as bars.
- A visible "rocked" state per fighter (hurt but not down), next to the energy chip. The pack's opponent mode "Hurt" has no counterpart on the screen.
- Time-based wording: the page shows the corner minute AND the in-round call row (Jab and move, Tie up, Hands up, Sprawl, Get up, Protect the arm) at the bottom. In-round calls are every 30 seconds; the corner minute is a pause. Put them on two separate states or label the lower row "calls once the round starts".
- No in-round "Say nothing" meaning: the button is on the bottom row between two groups; the rule says only two instructions per minute fully land; show the count "2 of 2 used".
- The result page has one exit (Back home). Add "Write the line" on the NEXT row (action on information); right now NEXT is the only row without a button, and the result is where the player has just been told what to do.

### Information the player cannot act on
- The "Where the fight is" strip (Standing 2:35, Clinch 0:00, Wall 0:40, Ground 1:45) is pure history; mark it as unbuilt (it is) and decide whether it is worth the space in a tight page: it is the MMA fight in one line and it earns it, but only if it shows "Priya on top" as the thing to change.
- 1X / 2X / Skip to the bell in a corner minute (a pause): not applicable; show them in the round view, not here.
- "Throw in the towel" unbuilt warning: ok, but it needs the consequence in its tooltip.

### Icons likely to be guessed wrong
- Energy battery glyph in the headers is clear. The eye icon in the cutman card is clear. The heart-with-lock beside "Clear head" reads "health locked"; use a head-with-ring.
- Water drop and snowflake for recover jobs read fine.
- The red "NEW" tag and "NOT BUILT YET" tag share a style with the rest of the page; the first is a feature flag the player should never see. Keep "not built yet" marks, drop "NEW".

### Other fighters
- **Aisha (grappler):** the in-round call set must switch on position (guard calls, sweeps, submission chains). The drawn set (Sprawl, Get up, Protect the arm) is for the fighter on the bottom against a wrestler; for the person on top it is different. Show the position's call set, not a fixed row.
- **Kwame (heavyweight, Durability 31):** the damage bars matter most for him and "stop it / go on" is his fight; works.
- **Tomas (power):** the "NOW!" set-up moment is the whole point; set-up is greyed here; fine if he has a combination.
- **Josh (kickboxer):** needs the legs and the kick-defence line; no leg bars is a gap for two of eight fighters.

### Fixes to reach 8
1. Fix the three contradictions and give every grey a reason.
2. Add leg bars and a rocked state; drop one row of eye/nose bars to make space.
3. Split corner minute from in-round calls visually; show "2 of 2 instructions used".
4. Put an action on the Why's NEXT line ("Write the line").
5. Make the call set depend on the fighter's position and the move set (grappler on top vs bottom).
6. Remove speed and skip controls from the corner view.

---

## 6. MONEY - 6.5/10

### What works
The books are honest: the totals add up (550+420+400+350 = 1,720; 450+416+380+171 = 1,417; net +303), the bills box adds to $5,668, runway has a tooltip, the chart shows the $0 line, "leaves N weeks" tells a player what a purchase does to the tin. Price tags with pins by state (red buy, grey not yet, green ours) is a good board.

### Biggest faults
- **The ordering is backwards.** "The one that fits now first" puts the Bigger unit ($12,000, net goes from +$303 to -$67 a week, leaves 2 weeks) first. That is the worst purchase on the board today; it should be last or greyed with its reason ("would take the tin to 2 weeks"). Rank the cards by the net weekly gain per dollar and by the effect on runway, and put the one the club can actually afford at the top-left.
- **The decisions that cost most are not on the page.** There is no discipline coach (striking, wrestling, BJJ, Muay Thai). The Playbook says a new move needs a coach who teaches it; Money's staff box offers Physio, Strength coach, Cutman only, and the Second evening coach card is an "evening" coach, not a discipline. For an MMA gym the biggest recurring cost, and the thing that unlocks the move book, is missing. Add a "Coaches" section with one card per discipline, each showing which fighters it helps (face chips).
- **Stipends are inconsistent.** The "Fighters with money to decide" table shows Lucy and Danny with "Stipend $250" outlined buttons, but the weekly Out has no stipend line (Coach, Rent, Staff, Power/kit/fees only). If both were paid the costs would be +$500 a week. Show the stipend state as a clear toggle (paid/stopped) and include it in Out.
- **Kit budget text claims "(matted floor, strength coach)".** Matted floor is owned; the strength coach is not hired (it is in the Staff box with "Hire $100"). Fix the sentence.
- **Dues bands**: "Cheap draws 15% more members" is useless at 68 of 70 places. Show the weekly income effect of each band ("Premium: about +$X a week, about N fewer members") and grey Cheap with the reason "the place is full".

### Options missing
- Members and reputation trend (68 of 70, +/- a week) beside Dues.
- Loan / overdraft state, if any (the pack says one exists with no screen; leave a slot).
- Pro purse forecast for each booked fighter ("Next money" shows only $450 for Lucy and Aisha; a top-10 fighter with a promoter should show a bigger line).
- Rent and the fee calendar (annual affiliation fees) in the bills box, rather than "Power, kit, fees" lumped.

### Information the player cannot act on
- "Leaves 7 weeks" is jargon in a sentence; use the runway icon plus a number on every card, and keep the sentence in the tooltip.
- "Dues from 31 members cover what the other income leaves (you have 68)": a break-even statement; useful once, as a tooltip on the members chip, not a handwritten line.
- The fighter contract notes (Aisha's and Danny's) sit on Money and on Home and on the Profile: three homes for a decision. One home (Home), the others link to it; Tomas's card already decides in place and Danny's does not.

### Icons likely to be guessed wrong
- Building, dumbbell-bar, two-stickmen (youth), single stickman (coach), poster (show) are fine. The coin-with-clock for "in hand" is not obviously runway; the dial/gauge glyph beside "10 weeks in hand" is better but the two icons next to each other differ in style. Use the gauge for runway everywhere.
- The "Cage" card shows a grid icon that reads "fence/shop"; fine with the label.

### Other fighters
Works for all eight; the "Fighters with money to decide" table is the right shape for a roster. Add a status column: stipend / share / contract date. Kwame is retiring: show the retirement payout or contract end in the same table so the club's costs fall visibly.

### Fixes to reach 8
1. Re-rank the price tags by affordability and effect; the first card is the Strength corner; the Bigger unit gets a grey "tin would fall to 2 weeks".
2. Add Discipline coaches (striking, wrestling, BJJ, Muay Thai) with the fighters they teach as face chips.
3. Include stipends in the weekly Out and make paid/stopped a visible toggle.
4. Fix the kit text and put effect numbers on the dues bands; grey Cheap with the reason.
5. Replace "leaves N weeks" sentences with the runway icon and number on each card.
6. Keep one home for each contract decision (Home), link from here.

---

## 7. WORLD (Rankings) - 5.5/10

### What works
The news box is good: three results that touch you, each with an action (Open the offer, Scout $250); the divisions per fighter; the movement arrows are legible; the scouted-opponents box is the right idea. The numbers agree with the other pages (Priya 9-3 #5, Rosa 6-2, Dana #8).

### Biggest faults
- **Half the page is Home again.** "Where your eight stand" repeats the fighter table (record, opponent, date, button) and "Fixtures by date" repeats the needs (Answer Megan's offer, Answer the gym about Tomas). The rule is one home per job; the world's job is rivals and the ladder. Remove the duplicates; use the space to show the ladder.
- **The rank table has no decision power.** Rows hold gym, record, style, last bout and a movement arrow. Nothing says who is beatable, who the next opponent should be, or what a win does. Add a win-chance column (a band, wide when unscouted), a scouted icon (weapon / weakness known), and a per-row "Ask for a fight" for fighters within the promoter's band (about five places up). The pack says the pro player asks for a named opponent; that action belongs on the ranking table and today lives on Home for Josh only.
- **The DEV column is cryptic.** Four icons (medal, flag, trending arrow, sword) share one narrow column with a legend at the bottom right that lists some of them. The flag (challenger) is not in the legend; "next opponent" and "booked" are not rival properties. Split into two columns: "Scouted" and "Trend".
- **Sport toggle and division chips conflict.** Eight chips with state icons choose a division; a BOXING/MMA toggle also exists; the line says "showing the division of the face selected". For Aisha and Maria (both flyweight) the chips pick the same table; for Lucy the table is bantamweight. That is acceptable, but it hides every other division, and a player cannot compare. Use division tabs with the gym's fighters as face badges on the rows.
- **"4 places up" for Lucy.** She is unranked in the table, sitting below #6, and Priya is #5; the row beneath says "#5 is 4 places up". Count it from what the table shows (two places) or from the entry rule (she enters at 4 wins).
- **"Scout $250" is offered beside "Already scouted: weapon known".** Say what the $250 now buys: "opens the weakness".

### Options missing
- A title route per fighter: Maria is #5 and Kira Voss is champion; the table shows "champion, challenger" in a header only. Add "Title: #5 to #1, 4 wins, mandatory challenger in N weeks".
- Championships tab content for MMA (events, belts); not drawn in this set, so it cannot be judged. The same for News.
- A watch-list: follow a rival so that their next bout lands on Home. Cheap, agreed spirit (rivals that develop).

### Information the player cannot act on
- "Since Feb" movement arrows for fighters the player will never fight (Sofia, Zoe). Keep them for the five who matter (next opponent, the one above, the champion) and dim the rest.
- "Last bout" text for every row is the right amount only for scouting targets.

### Icons likely to be guessed wrong
- Kwame is a bell here and an hourglass on Home; Josh an empty circle here and a different glyph on Home. The tags on the fighter chips (calendar, arrows, plus-cross, envelope, document, exit, circle, bell) are the same states as Home but not the same icons.
- Medal for the champion is fine; flag for challenger reads "report/flag a problem"; sword for next opponent reads "weapon found". Use a crown, a ladder step, crossed gloves.
- Trending arrow for "developing" is the one right icon. Good.

### Other fighters
- **Kwame (#12 heavyweight):** a retiring veteran needs the ladder from the other side (who replaces him, last title shot). Nothing is drawn.
- **Tomas (#22 welterweight):** works if the table windows around him; right now the table only shows the top six, so someone at #22 would need a second scroll window.
- **Danny (unranked, 3-0):** the entry rule line is useful; works.

### Fixes to reach 8
1. Delete the duplicated fighter table and fixtures; use the space for the ladder around the selected fighter (the five above, the five below).
2. Add win-chance, scouted and trend columns; "Ask for a fight" per row within the band.
3. Division tabs instead of the eight chips plus a toggle; the gym's fighters appear as faces on rows.
4. Reconcile "places up" with the table; show the title route per fighter.
5. One icon set across Home, Week, Profile and World (the state icons).
6. Draw the Championships tab with MMA belts so the page can be judged as a whole.

---

## Across all seven (applies before any single fix)
- **One fact set is still leaking.** Lucy's weight (60.2 vs 60.4), the pad nights (2 vs 3), the combination (Week: has 1-2; Fight night: has none), the plan counts in the Why (3 right vs 6 right), the stipends on Money, the strength coach in the kit text, the "4 places up", and the top-bar sentence changing from page to page. None of these is a design problem; they are the first thing a critic or the owner will find.
- **One icon per state across pages.** Fighter-state icons (camp, injured, offer, contract, free, leaving, retiring) differ between Home and World; define the set once.
- **MMA grappling is drawn as text.** On Profile it is a paragraph, on Week it is behind "+5 more", on Playbook it is greyed rows, on Fight night it is the Ground strip with a mark. Two of eight fighters (Aisha, Maria) and half the game are grappling; give it a first-class bar, chip and row on every page, with the "not built" mark on the header, not on the content.
- **The Combos tab is the owner's favourite part and is not in the set.** Draw it.

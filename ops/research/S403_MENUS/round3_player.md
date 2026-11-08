# Round 3, the player's read of the seven menus

Read as someone who will use these every Monday for years, with eight MMA fighters on the books and one assistant coach. Scores are for the design as drawn. A warning triangle is read as "planned, not built" and is not marked down as a fault. An 8 means I would happily play with it as it stands.

| Page | Score | Biggest fault |
|---|---|---|
| Home | 7.5 | Colours and counts disagree with themselves (red pins vs "2 stop the clock"), and the fighter table cries wolf on weight |
| Fighter Week | 6.5 | Too much packed into one board, and its own numbers contradict Home and each other |
| Profile (Tomas Novak) | 7 | Grappling skills are a text paragraph, so the grappler's page is mostly words |
| Playbook (Megan Hughes) | 7 | Two jobs on one page (the plan and the move book) and the plan reads as a spreadsheet of lines |
| Fight night | 7 | Corner minute is overloaded and a design note leaks onto the screen as UI text |
| Money | 7 | No forecast, and nothing to pay for the discipline coaches that eight MMA fighters need |
| World | 6.5 | Shows six rows of one division, repeats Home's action table, legend does not cover the icons it draws |

---

## 1. Home: 7.5

What works. The sticky-note needs board is the best thing in the set. Four red pins, a date on each, one button each, and the top bar says what stops the clock first. The next-fight strip (19 days, weight, opponent) answers "what is coming" in one glance. One row per fighter with a state icon, a button that matches the state (Fight prep, Plan rehab, Answer, Talk, Ask for a fight), weight and freshness is exactly the weekly scan I want with eight people.

What I want to do and cannot.
- Sort or filter the eight. With 8 I want "show only those who need me" and "sort by next date". The table has no sort affordance.
- Tell at a glance which fighter is tired or about to break. The freshness bar has no label, and the bar colours (green, orange) are never explained.
- See who is wasting a week. Danny and Josh show a week plan but nothing says "no bout, no goal, plan is generic".
- See the one coach's workload. Luke Reid carries eight fighters. The amber "Two in camp: the pads" note is the only trace of it.

What I would never look at or press.
- The weight column for fighters with no bout. Josh "86.5 / 84.0, 2.5 over, no fight, no cut yet" and Tomas "3.0 over, no cut yet" are red numbers for a problem with no date. That is noise and breaks the owner's "only what you can act on" rule. Show weight only when a bout or a goal makes it matter; Aisha 2.6 over with 40 days to go should be amber at most.
- "All news and mail (6 new)" as a pill under three lines. Fine, but it competes with the real needs.
- The "Cash $14,820" row inside THE CLUB: it repeats the top bar.

Where an icon leaves me guessing.
- The state icons in the Today column (door-arrow for Tomas, hourglass for Kwame, document for Danny, envelope for Megan). The words beside them save it, but then the icons add nothing; either let the icon carry the state or drop the words, not both. Make the icon set mean something consistent (money, injury, offer, camp, retirement).
- The anvil at the bottom of the rail with no label (the club crest). Fine if it is a known crest, but it looks like a button.
- The pulse icon over the freshness column and the scale icon over the weight column are right; the clipboard next to "YOUR FIGHTERS (8)" is a mystery.

Do the eight make sense. Yes, on this page all eight have a sensible line. Kwame "Retiring: talk Fri 6 Mar" and Tomas "Offer, answer Mon 9 Mar" are the right states. Josh's "Ask for a fight" is the right nudge.

Contradictions to fix. The legend says red STOPS THE CLOCK, four notes carry red pins, but the top bar says "2 stop the clock". Either only two pins are red or the line is wrong. Lucy is 60.2 on Home and 60.4 on her Week page. Fix those, or the player stops trusting every number.

Fixes to reach 8, most important first.
1. Make the red-pin count and the top bar line agree. A player trusts the clock line more than anything else on the page.
2. Show weight only when a bout, a goal or a limit is within reach; colour red only when it is a problem on a date (cut starts, weigh-in).
3. Label the freshness bar with a word on hover and a tint legend ("fresh / tired / overreached 80+"), and put a one-word reason in the tooltip.
4. Add a filter row over the table: All, Need me, Camp, Injured, Free. One row of chips is enough.
5. Add one cell to the table or the Coming Up list: "Pad nights: Lucy 2, Aisha 1", so the amber coach-pads note has a number I can see without opening it.
6. Drop the Cash row from THE CLUB, since the top bar has it, and use the room for the week's bout income.

---

## 2. Fighter Week (Lucy Jackson): 6.5

What works. The fatigue strip with PEAK and TAPER bands, the fight date circled in red marker and weigh-in marked is the Look B whiteboard working properly: I can see where the camp lands against fight day. Mornings as cards with a stat gain and a fatigue arrow, evenings as pad or sparring nights, the coach's one change with a "Do it" button, and the twist card as a sticky note are all the right ideas for the week mechanic. The hover on "Stamina: how long the fighter holds the pace" is the right style.

What I want to do and cannot.
- Copy this week to the next, or to the next four. Writing a week for each of eight fighters by hand is the job; the page offers "All mornings Light" and "Back to the coach's week" only.
- See the cost of the pads dispute in numbers on the page. It has the Lucy 2 / Aisha 1 of 3 control, which is good, but the board beside it shows Lucy on pads three evenings (Mon, Wed, Fri) while the control says she gets 2. These do not agree. A player will click the control and watch the board and not know which is true.
- See what each session adds toward the goal and the cap. "+0.10" per session is true but unreadable. I want "Stamina 62.0 -> 62.3 this week; cap 80" as a bar I can see move as I change a card. The text line is there but small; make it the page's anchor.
- Change the week for the other seven without leaving. The strip "All eight weeks" at the bottom is tiny black pips under each name. It is a good idea drawn too small to use.

What I would never look at or press.
- "Foot speed 0, Recovery 0, Flexibility 0, Durability 0" in the totals line. Zeros for four attributes are clutter; show only what moves.
- The 11 individual attribute gains in the header: five are shown with icons, four are zeros. Six lines of numbers I cannot act on. Show the top three and a "+3 more" hover.
- The strip of nine session pills (ROADWORK, INTERVALS ...) with "+5 MORE ... MAT ROUNDS, CAGE WORK, MOBILITY". It reads as a palette to drag from, but nothing says drag. Show it only when a card is selected, as the chooser.

Where an icon leaves me guessing.
- The up-arrow with a number under each session ("↑5", "↑2"). It means fatigue added; the legend sits top right in small print. Make it a flame or battery icon with its own tooltip.
- The "Light / Normal / Hard" dots legend is fine; the dots on each card are not tied to it until I read the legend.
- Hand icon on Sparring cards vs the target icon on Pads: both read as "a thing", not "sparring" and "pads". A glove and a mitt would do.
- The warning triangles on the Low kick and Double leg tiles are good ("Raw. Kick pads: not built"), but the triangle on the lower right of the strip is a bare triangle with no title.

Do the eight make sense. Not yet. Only Lucy is shown. The grappler (Aisha) needs mat rounds, cage work and takedown drills as first-class session cards, and all three are hidden behind "+5 MORE" with a warning. For Aisha, Maria and Kwame the week is mostly grappling or low-intensity rest, and nothing here says how Kwame's week differs. Injured Maria needs a rehab week; the page would show rest and nothing else. Prove the page works for Maria and Kwame.

Contradictions to fix. Weight 60.4 on this page vs 60.2 on Home. Pad nights 2 on the control vs 3 on the board. Tape study on Priya "one tell" while Home and World say Priya's weapon is already known.

Fixes to reach 8, most important first.
1. Make every number on the page agree with Home and with itself (weight, pad nights). The player will test the pads control first.
2. Cut the header to the three attributes that move and the goal line; show the rest on hover.
3. Show the session chooser only on selecting a card; give the freed room to the stamina-to-goal bar, drawn large, with the cap tick.
4. Add "Copy to next 4 weeks" and "Copy from [fighter]" next to "Back to the coach's week".
5. Make the "All eight weeks" strip readable: each fighter gets a mini-row of seven bars with a tint for hard/rest, and a red dot where a week conflicts (two fighters on the same pad night).
6. Draw the grappler version: Aisha's morning and evening cards with mat rounds, drilling and cage work, so the page is proven for a non-striker.
7. Replace the hand/target icons for sparring/pads with glove/mitt, and give the fatigue arrow a flame icon.

---

## 3. Profile (Tomas Novak): 7

What works. The three-column split Body / Skills / Mind with "the same in every sport" over the first and last is a clear idea. Eleven attributes drawn as bars with a cap tick, a weekly delta and a "Train" button on the two weak ones is genuinely useful: I can see Stamina 44 is why he fades. The rival gym offer as a top banner with three answers (match it costs $120 a week, promise something, let him go) is a strong, honest card. Habits and traits with the Patient to Forward slider, the goal with "still needs +6", and the perk road (Finisher and Fast hands open, the rest locked with "58 of 70") all give me things to do. The sticky "One big right hand. Gone by round 3. Work on Stamina first" is the coach talking exactly as intended.

What I want to do and cannot.
- Compare him to anyone. Bars with no band words (weak, fair, solid, strong, elite) and no division average mean "62 Inside fighting" has no meaning. Add the band word on hover and a ghost tick for the division average.
- See what he costs and earns. Contract, stipend, share of purse and next purse are not on the profile; the offer banner talks about $600 and $120, but the baseline (what he earns now) is absent. For Danny's contract and Kwame's retirement the same card slot needs a different banner and the page does not show it.
- See why the goal is at risk. "Stamina 44 -> 50 in 21 days, still needs +6" with a weekly delta of +0.1 is impossible. The design says goals are clearable about 70% of the time; this one is not. Either the delta is wrong or the goal is an obvious trap. Fix one.
- Jump from a weakness to its fix. "Train" on Stamina is good; a weak skill (Head movement 36, falling) has no "Train" or "Drill" button.

What I would never look at or press.
- The 0.0 deltas on six attributes. Show a delta only when it is not zero.
- "5 of 19 moves" with two chips. Fine as a link to the Playbook, but the "Open the Playbook" button is already there; the chips add little.
- The scale row at the bottom "80.0 of 77.0, 3.0 to lose, padlock" and "MOVE UP A CLASS": a man with no fight booked has no weigh-in. It belongs on the week or fight prep page.

Where an icon leaves me guessing.
- The star on Explosiveness, Strength and Inside fighting (maybe: best-in-class or a perk driver), the red down arrows next to Recovery, Stamina and Head movement (falling). No legend; the owner's "icons and tooltips" rule means the tooltip has to carry it, but a still shows none of them.
- Blue vs orange bars: orange seems to mean below the line for the division, but nothing says so.
- Perk icons (bolt, hand, skull, wind, bulb, target) are fine since the names are written under them.

Do the eight make sense. Mostly. Danny (everything is low and has a high cap) would look great, with ticks far to the right. Kwame has current equal to cap on every bar, which means every tick sits at the end of the bar and no bar can grow; the page has no way to show his decline (Durability 31 and falling) other than a small arrow. The grappler is the weak case: the Skills column says "STRIKING" and puts the whole grappling and ground game into one grey text block with a warning triangle ("Grappling Clinch 50, Takedowns 38 ..."). For Aisha (Guard 86, Submissions 88, Armbar Signature) that text block would be the page. It is the opposite of icons and bars. Show grappling as a second bar block under striking, behind a "Striking / Grappling / Ground" switch, not a paragraph.

Fixes to reach 8, most important first.
1. Replace the grappling paragraph with real bars, one block per skill group (Striking, Grappling, Ground), each with its own tick and delta. Test it on Aisha.
2. Add a band word and a division-average ghost tick to each bar so the numbers mean something.
3. Put a CONTRACT strip under the banner row: stipend or share, next purse, ends date. Then every one of the eight (Danny's contract end, Kwame's retirement talk) has a slot for its banner.
4. Fix the goal so it can be met at his rate, or show "not reachable at +0.1/wk; train Stamina Hard" as the card's honest line.
5. Show a delta only when it is not zero; remove weight from this page unless a bout is booked.
6. Add a Train or Drill button to every weak skill, not just two attributes.
7. For the veteran, show an age curve line (peak, now, cliff) under the Mind column, so decline reads as a path and not a flat bar.

---

## 4. Playbook (Megan Hughes, Game plan tab): 7

What works. The plan as lines ("Outside: Teep", "In the clinch: Knee") with a rating chip (Works, Beats it) and a Drilled bar is the fun part of the game and it reads at once. The chalkboard that plays the default line when I hover is a lovely idea. The rounds row (Push / Steady / Save per round) and "Fight starts: Stand, Take it down, Keep it standing" give me real choices. The move book on the right with four-pip mastery tiers and a hover tooltip ("Knee, Signature: the best answer to a fighter who presses in the clinch") is clear, and the not-built sections are drawn as they will work. The opponent chips (Walks you down, Boxes at range, ...) to rate the plan against each kind are the right way to practise before a bout is booked.

What I want to do and cannot.
- See the plan as a picture. The agreed design says "lines drawn on a board". Here it is a list of five rows and a chalkboard that shows one line at a time. A map of ranges (outside, long, mid, inside, clinch, wall, ground) with my answer at each spot would let me see holes at a glance. The rows give me only the lines I wrote.
- See what I have no answer for. "5 of 6 lines" is good, but the opponent's weakness or habit is not matched to an empty line. "Answers to write: no tell found yet. Tape opens when booked" is correct but gives me nothing to do now; offer "Rate against each kind" as a button beside it, not only the chips above.
- Test the plan from this page. "Test it: limited tries" is there. A result readout (win chance, where the plan breaks) should appear beside it.
- Drag a move from the book onto a line. The two panes are side by side, so drag and drop is the obvious gesture; nothing says it works. The swap and cross icons per line are the only affordances.

What I would never look at or press.
- The pace and "Fight starts" rows hold the same weight as the lines, so the board is a stack of five different things (rating chips, sound plan, fight starts, rounds, combos, lines). Round pace is a real decision, but only a third of players will ever change it from Steady. Fold it behind a "Rounds" disclosure.
- "More: flow, map, real plans" is three features in one button.
- The "Marks easily" tag: on a Muay Thai fighter whose Inside answer is Elbow, the game should warn about cuts or the tag is decoration. As drawn, it does nothing.

Where an icon leaves me guessing.
- The swap arrows and the X at the end of each row: swap what with what? "Change this answer" and "Clear this line" need titles and a colour (the X should not look the same weight as swap).
- The "Hands", "Knees, elbows", "Kicks", "Takedowns", "Submissions", "Ground" group icons are all small marks. Hands is a fist and Kicks a boot-like zigzag, but Takedowns (double chevron) and Submissions (link) are guesses. The words beside them save this.
- The lock beside "On top, On the bottom" is clear; the warning triangles are clear.

Do the eight make sense. For Megan, yes. Grappling lines (cage wall, on top, on the bottom) are drawn as unbuilt and are one-liners each; for Aisha, Maria and Josh's opposite (hates the floor) the plan's ground half is where the whole plan lives, and a grappler's page would be nearly all locked UC rows. Maria's takedown, wall and control game has one line in the "On the cage wall" row. The design needs to prove it holds six real ground lines (top, bottom, escape, submission attempt, wall, get-up) as a list like the striking one, drawn in full colour with one UC mark.

Fixes to reach 8, most important first.
1. Draw the lines as a range map (a ring-and-cage board with six places and one chip per place), keeping the list as a detail view. This is the "plan is the star" page; it should look like a plan, not a form.
2. Put "Rate against each kind" as a ready result beside Sound plan: a five-bar mini chart (one bar per opponent type).
3. Fold rounds and fight starts into one "Fight shape" row that opens on click.
4. Show a full ground half drawn for the grappler, using a second list with the same row design.
5. Warn on a cut-prone fighter in the line (an Elbow line against a "marks easily" fighter's opponent does not matter; elbows from her matter for her cuts) and in general show a one-icon risk on any line that costs her energy or exposes her.
6. Add an obvious drag handle and say "drag a move here" in the empty 6th line.

---

## 5. Fight night: 7

What works. Dark and tight, as the owner wanted. The coach's sticky ("She has adapted: Priya now shoots when you step back") sitting on top of the opponent's clue ("Priya is PRESSING, and shoots if you step back") is exactly the right use of the adaptation mechanic. Three choice rows (Habit, Plan, Talk) with a clear price on each ("+1.0 power, saves energy, safer", "-0.5 power, tiring, riskier") is a strong decision grid. "Fixes: pick up to two, 2 left" with the dots is the right limit. The result panel is excellent: the Why (Your plan, Against you, What decided it, Next) is the hook of the whole game and it is drawn plainly. The body report with a "Train the ribs next week" button, scorecards that agree with the label (28-29 three times is unanimous), and the plan lit up as lines with hit rates are all the way I want to learn from a loss.

What I want to do and cannot.
- See the fight flow in the corner. Position times (Standing, Clinch, Wall, Ground) and control time are there, but I cannot see round 1 as a story (who landed when, where it turned). One strip per round with big moments would be enough.
- Rewatch or skip the round. There are 1X, 2X and Skip to the bell, but nothing about Watch the round.
- Check the opponent's health at a glance. The body table (L eye 48, R eye 82, Nose 70, ribs 64/58 ...) has twelve numbers; I want a body figure that glows red where it hurts.
- Call the fight ("Throw in the towel" is a UC button with a warning). Fine, but the corner needs the call "stop it or go on" on the eye, and the card exists only as a red box with spec text (below).

What I would never look at or press.
- A design note shows as screen text: "Not one of the two instructions. Nothing is pre-selected." and "Left eye closing" on the cutman row. The first sentence is a rule for the designer. A player should see "Left eye closing: stop it or go on" and the two buttons only.
- The twelve body numbers per fighter. The agreed note says cut stats to three rows; the page still carries a six-cell grid per side with two numbers per cell. Keep the three that matter in this minute (the one that hurts, the one that works, energy).
- The "Set-up: a combination" locked tile and the greyed "Clear head" tile both sit in the Recover row. A grey tile that only says "no" teaches nothing; the tooltip is good but the tile itself should shrink.
- "Round 1 was Priya's 10-9 on your card" in the middle: fine for a points fight but it fights for space with the opponent clue.

Where an icon leaves me guessing.
- ENERGY 62 with a battery icon is clear. The target icon for LANDED and the clock icon for CONTROL are fine.
- The three "In the round" calls (JAB AND MOVE, TIE UP, HANDS UP, SPRAWL, GET UP, PROTECT THE ARM): wording is fine, but they are all text pills; the owner wanted icons. A tiny glyph for each (jab arrow, clinch, guard, sprawl) would make the row readable at a glance during a 30-second shout.
- Ice, water and drop icons in RECOVER work.

Do the eight make sense. For Lucy against Priya, yes. Kwame's counter style (Pressing opponent, "reads everything") would need the "She has adapted" mirrored: his Fight IQ 90 should show the opponent's adaptation faster. Tomas, who tires in round 3, needs the energy ceiling visible in the corner; the page shows ENERGY 62 but no "will last until" line. The injured eye vs a Marks-easily fighter (Megan) is exactly the cutman card's case, so it is right to draw. The grappler's corner (Aisha on her back, "Submissions tried 1") has only one line, "On the floor: takedowns ..." under the result and nothing in the corner minute to help her; drawn calls like GET UP and PROTECT THE ARM are there but locked as UC.

Fixes to reach 8, most important first.
1. Remove the design-note text from the cutman card; keep "Left eye closing" and the two buttons; do not pre-select, just do not say so.
2. Cut the body grid to three rows in the minute and move the full twelve to a hover or a small body figure.
3. Add a round strip (six 30-second exchanges as small bars, big moment marked) between the clue and the fixes, so I see how round 1 was won and lost.
4. Give each in-round call a glyph and keep the word, so a 30-second decision reads fast.
5. Show an energy-until line ("lasts to round 3 at this pace") under ENERGY, so a fading fighter's corner calls have a number.
6. Draw one grappler corner: the same grid with sweeps, escapes and submission defence as the Fix choices.

---

## 6. Money: 7

What works. "The Books" on the whiteboard with cash, runway ("10 weeks in hand"), net a week and next bills in the header is the right summary. The in and out bars in marker, "Each week the tin grows +$303" circled, the bills table that adds up to $5,668 (checked: 1,800 + 1,664 + 1,520 + 684 is right, and 10 weeks of runway is right at $1,417 a week) are honest and true. Price tags ordered by "the one that fits now first", with a net effect and what it leaves ("Net +$303 to -$67 a week"; "the place is full. Net +$23 a week") is the best buying screen I have seen in this set: it tells me the second evening coach is nearly worthless right now, which is a real decision. Sticky notes on the right carry the contract talks and the rival offer with their consequences in dollars. Dues and kit as chalkboards with the effect line is clear.

What I want to do and cannot.
- See the future. The cash chart ends today. I want a line to Sat 11 Apr with the known events on it: bills Mon 16 Mar ($5,668), Lucy's purse Sat 21 Mar, the contract choices, Aisha's bout. A manager needs "what will my tin look like the day the bills hit".
- See what each fighter earns the gym. The table "Fighters with money to decide" shows share or stipend and next money, which is a start; I want a total column (income minus stipend) so Danny's $250 stipend can be weighed against his $0 purse.
- Pay for the staff MMA needs. The staff list carries a Physio ($75), a Strength coach ($100) and a Cutman ($150 a pro night). Eight MMA fighters need a striking coach, a wrestling coach and a BJJ coach; the Playbook says "A new move needs a coach who teaches it". There is no discipline coach on the money page. This is the biggest gap for the MMA release.
- Compare the buy options with a payback number. "Leaves 2 weeks" on the Bigger unit and "Leaves 7 weeks" on Strength corner is the right idea written badly; "Leaves 2 weeks" does not say of what.

What I would never look at or press.
- "Dues from 31 members cover what the other income leaves (you have 68)". I cannot parse this sentence; the 31 comes from nowhere on the page. Cut it or say "break-even: 31 members".
- The Club show card ("$3,500, Leaves 7 weeks, from Mon 6 Apr") greyed with a countdown is fine, but a red-pinned card for something that is not available yet is confusing. Red means buy and the card is greyed; pick one.
- The CASHBOOK link (26 lines, last 8 weeks) is useful but it is the only place I can see where the money actually went; it should be a tab, not a note.

Where an icon leaves me guessing.
- Coins, calendar and stopwatch icons in the header are clear. The pin colours (red buy, grey not yet, green ours) are explained only in tiny type at the top of the tags.
- The gauge icon by "10 weeks in hand" has a tooltip, good.
- The sketched icons on the price tags (house, dumbbell, two figures, one figure, a poster, a bank, a cage, a mat) are charming and guessable.

Do the eight make sense. Mostly. The fighter money table separates Lucy, Aisha and Danny (money to decide) from the other five (25% share, nothing due), which handles eight well. Tomas's offer note is in the sticky. Kwame's retirement and a retirement payout, or Maria's rehab cost, are absent; an injured fighter costs the gym a stipend and a physio and the books do not show it. The cage price tag "PRICE NOT SET" with a UC mark is the right way to show the MMA cost.

Fixes to reach 8, most important first.
1. Extend the cash chart forward 8 weeks with dotted known events and an "if I do nothing" line.
2. Add discipline coaches (striking, wrestling, BJJ, Muay Thai) to the Staff panel as UC rows, each with a cost and the moves it unlocks, so the MMA release already has a slot.
3. Replace "Leaves N weeks" with a labelled icon ("runway after: 2 wks") on every price tag, and add a payback number (weeks to earn it back) on those that earn.
4. Cut or rewrite the "Dues from 31 members" sentence into "break-even: 31 of 68 members".
5. Make greyed cards grey all the way (no red pin) and put the reason in words on the card ("from Mon 6 Apr").
6. Add per-fighter net (income minus stipend, camp and physio) as one extra column in the fighter table.
7. Show injury cost lines (Maria: stipend, physio) in OUT, A WEEK.

---

## 7. World: 6.5

What works. Using the "your eight" chips to pick the division is a good idea, and the status icons on each chip (calendar, envelope, plus for injured, door for leaving, bell) tell me who needs what without opening anything. The table has the right columns for a ranking: rank, fighter, gym, record, style, last bout, movement since February and a Dev column (developing, champion, next opponent). Rival movement arrows (up 2, down 1) and "Developing: improving fast. Rivals who improve climb the table" is the mechanic I came for. "Open the file" and "Scout $250" under the table and "Scouted opponents" on the right are useful. The news column says only what touches me ("Rosa Lindqvist won by stoppage: Aisha Rahman's opponent"), which is exactly the owner's rule.

What I want to do and cannot.
- See the whole division. Six rows of a table headed "women's bantamweight, pro, the region" with a champion and a challenger; where are ranks 7 to 15? Lucy sits at the bottom unranked, so I cannot see where she would enter or who is below. Add a scroll, or collapse to "top 10 plus mine".
- Compare my fighter to the opponent. Priya Nair is highlighted, but the only way to see how she matches Lucy is "Open the file". A "versus" panel with the eleven attributes side by side (even as ranges until scouted) is the page's missing payoff.
- Find the next opponent for a fighter with no bout. Josh "Ask for a fight" lives in the lower table, a long way from the division he would pick from. Click a name in the rankings, and a button "Ask for this fight" appears; that is the real way to use a ranking.
- See finish rates, age, reach, and weight in the table. For MMA these are the columns that tell me what a ranked fighter is. Style as one word is thin.

What I would never look at or press.
- The lower table "Where your eight stand" repeats Home and Fights with the same Talk, Hear it, Open the offer, Fight prep and Scout buttons. This is a third place to answer Megan's offer. The owner's rule is one home per job; here the buttons should go and the table should become a plain "next step up" list.
- The sport toggle "Boxing / MMA": Boxing is greyed and the page is all MMA. Fine for the release, but until a player has both sports it is a dead control.
- "Fixtures, by date" duplicates Coming Up on Home.

Where an icon leaves me guessing.
- The Dev column icons. The legend in the bottom right lists next opponent (sword), booked (calendar), developing (trend arrow) and champion (medal), but the table also shows a blue flag against Hana Ito and Rosa's news line, and a red tint on Priya's row, neither explained. The flag looks like "challenger" or "scouted" and I cannot tell.
- The "your eight" status icons are good, but the door arrow for Tomas and the bell for Kwame are guesses until hover.

Do the eight make sense. For Lucy, yes. For the others, only through clicking a chip: eight clicks to see eight divisions. Kwame, a heavyweight at #12 who is retiring, has a division where nothing is shown about what his retirement would open. Aisha (BJJ) sees only a striking-style table; her division needs a "submissions" column since her wins come that way. Megan jumps six places up for a #8 fight; the page shows "#8 is 6 places up: her offer" and that is right.

Contradictions to fix. Lucy is unranked, yet "Priya Nair #5 is 4 places up". Four places above what? Say "unranked, 5 places to the table" or show where she would enter. The legend must cover every icon drawn.

Fixes to reach 8, most important first.
1. Show a full division (ranks 1-10 plus mine, scrollable), with my fighter's row placed in order or pinned at the bottom with its entry point drawn.
2. Add a side-by-side panel when I click a rival: my fighter and the rival on the eleven attributes (ranges when not scouted), with "Ask for this fight" or "Scout $250" on it.
3. Strip the action buttons from "Where your eight stand" (they live on Home and Fights) and keep it as a read-only ladder.
4. Add finish rate, age and weight to the table, and "Sub" or "KO" to the style cell as an icon.
5. Make the legend complete and show it open once on the page (flag, red tint, sword, calendar, trend, medal).
6. Show all eight divisions in one overview strip: each chip already has the rank, so make the chips open a small card with the next opponent and the top three.
7. Fix the "4 places up" line for an unranked fighter.

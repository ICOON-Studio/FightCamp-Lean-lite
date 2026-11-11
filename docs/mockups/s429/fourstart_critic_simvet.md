Seat: veteran player and designer of management sims (football, boxing, hospital and tycoon games). My 10/10 drawing: `docs/mockups/s429/fourstart_10_simvet.png` (source `fourstart_10_simvet.html`).

# FOURSTART1 review: four fighters at the start, and the guide's read

Read: CRITIC_PACK, CRITIC_ACCESS, `fourstart_for_critics.md`, `amateurweek_for_critics.md` (because the two lean on each other), the scope note S428, the hands probe result, and the code the design names (GymSpend, GymUpgrades, Recruit, WeekCoach, WeekPlan, PadWeek, TrainingPreview, GuideLines, FirstWeek, FighterGoal, Roster, BoutRules, MoveMastery, NoGi, BjjOpen, Data, Career, Sim). No earlier score was used.

## Scores

| What | Score | In one line |
|---|---|---|
| Depth of the whole design | 4 / 10 | The right skeleton (four people, one coach, one paid seat), but three of the four decisions have one right answer today |
| 1. Who trains full time | 4 / 10 | A two-way choice with a sum behind it, and the rule contradicts itself |
| 2. What each one trains | 3 / 10 | A lookup: one simple rule beats the guide for every fighter, every week |
| 3. Who gets Reid's hands | 5 / 10 | Real scarcity, but the payoff is flat and nothing shows what a place buys |
| 4. Who fights first | 2 / 10 | Not a choice: one offer, Tess's, and taking it is always right |
| The guide's read | 5 / 10 | A good teacher for week one; as a career mechanic it is advice the player learns to out-think or to click blindly |

## What works

- Four people sharing one coach and one paid seat is how a manager game should start. One fighter gave the player a to-do list; four give the player something to be short of. The owner's instinct here is right.
- The four are well cast: a prospect, a raw puncher, a veteran near the ceiling, a grappler. Four weight classes, three styles, three ages. A player can tell them apart in ten seconds.
- The staggered start (one has an offer, one is fresh, one has a goal, one competes in week 3) is the right cure for day-one overload.
- The read gives four different answers on four fighters with today's numbers. As a lesson ("fighters differ, so their weeks differ") it lands at once, and the two-line tooltip with the other choice's number is honest.
- "Advice, never a lock" and "the read changes as the fighter changes" are the right rules.
- The design names its own worst risk (section 7: if the read is always right it is a lookup). It is right about that. The cure it offers does not hold yet (below).
- The hands are truly scarce already: the probe found one fighter with her own three pad nights owns every answer in only 6% of camps. Sharing six places between three boxers will bite. That is the best raw material in the design.

## Where the design assumes something the game does not do

1. **"Day job: no mornings" and "gains 15% slower" cannot both be true.** In the code a day job only multiplies number gains by 0.85 (`GymSpend.gain`). Nothing removes mornings: the week board, `WeekPlan.days_of` and `Sim.step_day` never look at `day_job`. And five of the seven numbers (power, speed, defence, conditioning, chin) are built only by morning sessions (`WeekPlan.SESSIONS`, `WeekCoach.BUILDS`). Evenings build technique (pads) and ring sense (sparring) only. So a fighter with no mornings does not gain 15% slower; that fighter cannot build most numbers at all.
2. **The read points three fighters at sessions they cannot do.** Slip rope (Samira) and speed bag (Lucy) are morning sessions. Only one of the four has mornings. So the paid seat decides whose read can be followed, and the other reads are dead text. The design never says this.
3. **"The club can pay one stipend" is not a rule in the game.** The Money page has a Start button per fighter (`MoneyPanels`), and `GymSpend.set_stipend` is free and instant in both directions. Today a player can pay all four, or move the seat every Monday at no cost.
4. **The seat does nothing for Ana.** `set_stipend` and the 0.85 act on the boxers; the mat side (`NoGi`, `Grapplers`) never reads `day_job`. So decision 1 is a choice among three, and Tess (near her ceiling) is never the answer: it is a choice between two.
5. **Shared pad places are all new.** Today each fighter owns her nights (`PadWeek.nights_of(f)`, `f["pad_week"]`). There is no evening kind for "on the bag" (the kinds are pads, sparring, rest, film). The design says "new" in the table, which is honest, but the size of the change is the whole evening system.
6. **The guide is a one-fighter machine.** `GuideLines.line` reads `c.fighter()` (the first fighter only). Its steps (`FirstWeek.STEPS`) are sign, coach, week, go, offer, prep, fight, club. With four fighters already signed, "sign" is gone, and the design never says whether Reid is already hired or the player still chooses between Reid and Hale. The three club tasks after the first fight (sign a second boxer, get both a bout) mean nothing with four from day one, and the design does not say what replaces them.
7. **The numbers the read uses are not the numbers the player sees.** The built Overview shows ten attributes and five skills (Lucy: Strength 60, Speed 63, Stamina 57, Defence 57). The read averages the seven trained numbers underneath (power 58.4, conditioning 61.6). "Defence 50, the lowest number in the gym" has to be true on the screen, or the tooltip will argue with the page.
8. **Two ceilings.** The recruit card shows a ceiling per number that leans by style (`Recruit.ceiling`: potential +6 on the style's number, -6 on its gap). The training pace uses the plain potential. The read quotes the plain one. A slugger's power "ceiling 88" on the card will pace as if it were 82.
9. **REST at tiredness 70 fires in an ordinary week.** The game's danger line is 80 (`WeekPlan.OVERREACHED`). The coach's own weeks peak between about 59 (a quiet week on a real screen) and 70 (the code's own note on the standard week). The REST read would cut in during ordinary weeks and push the other reads aside.
10. **Tess's read and the rule's text disagree.** The table says TEACH A PUNCH is for "every number near its ceiling". Tess's speed (55) still grows 0.84 a week, defence 0.72, technique 0.70. She only lands on TEACH A PUNCH because her style number (conditioning) grows 0.48, a hair under the 0.5 line; and her speed is 5.6 under her average, a hair under the 6 line. Two near misses decide her read. It will flip back and forth on tiny changes, and "Tess is what she is" is false advice while three numbers still grow well.
11. **Tess is over the limit.** In the data she walks at 76.1 kg for a 75.0 class. The design's line for her ("Keep the legs fresh") skips the scale; today's guide would say she will not make weight. Morning sessions are what burn weight in this game; evenings do not move it. A day-job Tess with no mornings can only diet, and ten days of diet is on the edge.
12. **Tess is one win from a promoter.** She is 6-4. The pro offer comes at 7 wins with a top-3 regional place (`Roster.PRO_WINS`, `PRO_RANK`), and her table has six names. If she wins the ten-day bout the "veteran who stays" may get a pro offer in week 2. Check it before the build.
13. **The opponent's file cannot pull against the read for amateurs.** The design lists it as a reason to go against the guide. But the other new design says an amateur offer comes 1 to 2 weeks out and "nothing learnt after the offer arrives in time". One week moves a number by about one point. So by the time the file exists it is too late to train for it.
14. **Samira's goal.** The signing goal for a fighter with bouts is "next bout inside a month": 28 days, a booked bout plus conditioning (`FighterGoal`, `Roster.SIGNING_GOAL_CARDED`). "Due in three weeks" needs a goal that started a week ago. More important: it asks for conditioning, a morning number, which she cannot build on a day job.
15. **Ana's read names what already happens.** Her classes already drill "the move closest to owned" by default (`NoGi`). "The escape she fails most" exists (`BjjOpen.leak_of`) but it is read from an open's result, and her first open is in week 3.
16. **Money table.** It leaves out Ana's mat coach ($34 a class, about $170 a week), the mat members' dues (about $203 a week), and the first sponsor ($250 a week). Roster places are 3 in the code as the design says; the change to 4 is needed.

## Lookups and dominant plays

A dominant play is one the player can use every time without thinking, because nothing ever makes it wrong.

1. **"Lowest number first."** The night's base strength is the plain average of six numbers (`BoutRules.fight_power`), and a number grows fastest when it is furthest below potential. So the best training for strength is always the lowest number. This beats the guide itself: for Lucy the read says speed (+0.83 a week), while defence gives +1.07 and power +1.02. One rule, every fighter, every week, for the whole career. The read's "sharpen the weapon" is simply a slower way to the same average, unless a perk is in reach, and the read never mentions perks.
2. **"The seat goes to Samira."** She has the fastest gain in the gym (1.25), she is 18, and her goal needs mornings. Tess is never right; Ana cannot use it. And because switching is free, the sharper version is **seat-hopping**: move the seat every Monday to whoever gains most that week (Tess while she must make weight, Samira after).
3. **"Always say yes."** Pass is free and gives nothing. An even amateur bout gives +8 members, +5 reputation and $450 for a win, and takes 1 member and 2 reputation for a loss. There is one offer, for one fighter. "Who fights first" has no second answer.
4. **"Deal 2-2-2, and nothing to whoever fights inside two weeks."** A boxer off the pads still learns at half speed on the bag, so the total craft learnt in the gym is nearly the same however the six places are dealt. Mastery gain slows as a move nears its cap (`MoveMastery.gain`), so an even split is close to best. And nothing learnt in a fight week arrives in time, so the boxer about to fight never deserves a place. No screen shows a date or a fight that a place would win.
5. **"Follow the light, or get told off on Monday."** The review will say what the read's pick would have given. A player who cannot do the sums learns to click the lit session; a player who can do them learns the guide is wrong (play 1). Neither is making a decision.
6. **"Light mornings before a fight."** The FIGHT read tells the player to go light for 14 days. The fight-week design calls "fresh or sharp" a choice. The guide answers it before the player sees it.

What would make each a decision is in the last section.

## Menu by menu: missing options, useless options, what each option changes

**Create, step 2 (start cards).** Options: the three starts. Each changes cash, members and rent.
- Missing: what the start changes for the four (how many paid seats it can carry, who stayed). Missing: any say in who stayed. The sandbox rule (any gym, men or women) is broken by four fixed women.
- Useless now: the head-coach card "Amateur coach: a prospect's exact potential" (step 1). The four arrive with known potential and the roster is full, so this edge does nothing for months. "Strength coach" shrinks to the one fighter with mornings.

**Home.** Options: one button per fighter row (opens what that fighter needs), the guide's button.
- Missing: the one shared job, "Deal the week" (the seat and the six places), as a single need. Four rows hide the fact that the four are competing.
- Useless: a row for a fighter who needs nothing (Lucy "fresh") unless it says when the next thing comes. The guide's bubble and the row saying the same thing twice.

**Gym picture.** No options: a light on a place.
- Missing: whom the light is about, now that "training" is one place for four people.
- Useless: more than one light at a time.

**Fighters (cards).** Options today: open the page. Shown: class, style, read chip, stipend or day job.
- Missing: the seat switch on the card with its price in weeks of cash; pad places held this week; next fight and days. Above all a view where the shared things are dealt across all four at once.
- Useless: the read chip as "icon and one word" if it cannot be pressed (the owner's rule: only what the player can act on). The "Invite to a trial" buttons under the cards: the roster is full from day one, so they are grey for months. Say what opens a place instead (a second club coach, $280 a week).

**Fighter page, Overview.** Options: follow the read or not; the seat switch (changes $250 a week and that fighter's mornings).
- Missing: the other pulls beside the read: the goal with its days and mood price, the perk the style number opens and in how many weeks, who is next on the ladder. "My call" as a state, so the chip stops nagging after the player chooses otherwise.
- Useless: a third adviser. This page already has COACH SAYS and the agreed profile has "one thing to work on and where it is trained"; the week board has "the coach's one change" with a Do it button. With the guide's read that is three voices on one fighter that can disagree. One voice.

**Fighter page, Training (week board).** Options: each morning's session and Light, Normal or Hard (changes one number, weight and tiredness); lock in.
- Missing: a "Do it" for the read that says how many mornings change (the read names a session, the week has six different ones). "Coach's week / the read's week / mine". For a day-job fighter: anything at all to do in the morning row.
- Useless: the light on a session when the coach has already written the week around the same focus: the "decision" is pressing Lock in. A board with an empty morning row for three of four fighters is dead space.

**Training, evenings (the six places).** Options: who holds each of the six places (changes how fast that boxer's card grows: pads 2.1 an hour, bag 1.05).
- Missing: ONE screen for the three boxers (dealt on each fighter's own board, the player cannot see whom a place is taken from). What a place buys: the date the card turns Usable, and whether that is before a fight. Sparring pairs by weight (60, 65 and 75 kg: Tess has nobody her size). A way to buy more hands (a fourth evening, or Hale instead of Reid). The film evening taking a place (it is in the fight-week design, not on this menu).
- Useless: the 50/50, 70/30 night splits on top of place dealing: two layers of fiddling for a flat payoff. "On the bag at half" as an automatic penalty: it should be a pick.

**Grappler page (Ana).** Options: drill a move, stripe call, enter the open, who teaches.
- Missing: anything she shares with the other three. She takes no pad place, the seat does nothing for her, she has her own coach. She is a second, smaller game on the same save.
- Useless: a read that names the drill the class already runs by default.

**Fights / Bout page.** Options: Accept (books the bout, starts the fight week) or Pass (nothing).
- Missing: a second offer to weigh against the first. What this fight week takes from the other three (the film evening, the cut). The scale forecast for a day-job fighter. "A win may bring the promoter" for Tess.
- Useless: Pass, while it is free and an even match is always worth taking. The compare card with one candidate compares nothing.

**Money.** Options: Start or Stop each stipend ($250 a week each).
- Missing: the runway for 0, 1, 2, 3 and 4 seats before the click. A notice rule. What the seat buys in the fighter's own terms (mornings).
- Useless: four Start buttons if the club "can pay one" (either cap it or let it hurt: I prefer letting it hurt). A stipend line for Ana while the seat does nothing for her.

**Week review (Monday).** Options: Next week.
- Missing: what the player's own pick bought that the read's would not (a perk a week nearer, the goal on track). What the deal cost someone else ("Lucy's third place cost Samira the cross by a week"). "Same deal next week / change it".
- Useless: "what the read's pick would have given" when the player followed the read (the two numbers are the same). Four reviews one after another with one button: with four fighters that is four ceremonies every Monday. One page for the club.

## To reach 10/10 (most important first)

1. **One clear rule for the paid seat, shown as mornings.** Full time = six mornings. Day job = two mornings (Saturday and Sunday). Drop the hidden x0.85. Every weekday evening a day-job boxer is not on Reid's pads becomes a SOLO evening: the player picks either one morning-type session at Light (0.6 of a morning) or bag work on a card (half the pad gain). So a week of numbers is worth about 1.2 for the full-timer and 0.4 to 0.76 for a day-job boxer, and being off the pads becomes a trade (numbers instead of craft), not a fine. The seat switch reads "6 mornings / 2 mornings" on the Fighters card, the Overview and Money. Measure a year of each before the build.
2. **Make weakness against weapon a real trade, and show every pull.** The read becomes a card with up to four lines, each with a number and a date, and the player picks one:
   - Weakness: "Slip rope: Defence 50, +1.2 a week".
   - Weapon: "Heavy bag: Power 66, +0.6 a week. Finisher at 70: about 7 weeks" (the perks exist; show the nearest one).
   - Goal: "Samira asked for the engine: +3.1 in 21 days. Mood +10 or -20".
   - Ahead: "Next on the ladder: Okoro, Finch. Answers owned: 1 of 3" (this replaces the opponent's file, which comes too late to train for).
   And one new fight rule so the average is not everything: a trained number 6 or more under the fighter's own average is a HOLE. From the fighter's third bout (there is tape now) an opponent's corner finds it: +1.0 to the opponent's edge in the matching exchanges from round 2, until the number is within 3 of the average. Test bar before the build: a bot that always trains the lowest number must not beat a bot that picks by perk, goal and ladder by more than 3 wins in 100 over a season; and neither may beat a bot that mixes.
3. **The seat costs money and commitment, and Ana can hold it.** No hard cap of one. The switch shows the runway for each count (from the design's own numbers: 0 seats about 36 weeks, 1 about 24, 2 about 18, 3 about 14, 4 about 12; MONEYFOUR1 replaces these). A switch takes effect next Monday. A fighter taken off the seat inside 8 weeks loses 10 mood ("I left my job for this"). For Ana the seat means five classes a week, not three: the belt and new mat members come sooner (a mat member pays $110 a month against a boxing member's $35). Now the seat is a choice among four, between the best sport play (a boxer), the best money play (Ana) and the best people play (the one with a goal).
4. **One screen where the week is dealt: Fighters > The week** (my drawing). Four rows. Per row: the seat, the read's pulls, the mornings, the evenings, what the week gives. Across the rows: the three pad evenings with two places each, the sparring pairs, the seats and the runway. A line at the bottom says what the last move cost someone else, with Undo. One red button locks the week for all four. The fighter pages keep their boards for fine edits. And one voice: COACH SAYS, "the coach's one change" and the guide's read become this one read; the old trainer speaks it in the first weeks, Reid after.
5. **Give a pad place a payoff the player can see.** Each place shows the date its card turns Usable or Sharp and marks it "before the York Hall show" or "after". Switch on the rule the game already has and keeps off (a planned line fires 1 time in 2 at Usable, 3 in 4 at Sharp, always at Signature: measured at about 2.8 wins in 100 a step), so craft is worth dealing for. Sparring needs a partner within 6 kg: Lucy (60) and Samira (65) can spar each other; Tess (75) has nobody, so her sparring night costs $40 for an outside mate or she gets no ring sense that week. More hands can be bought: a fourth pad evening costs Reid one evening class (about $115 off that week's class money); Marcus Hale full time ($1,090) holds five evenings, ten places. That keeps the coach hire a decision, tied to the hands.
6. **Make "who fights first" a choice.** On Monday of week 1 two offers stand for the same show: Tess against an even opponent (she is 1.1 kg over; a win is her 7th), and Samira against a harder one (her goal needs a bout inside 21 days). Taking both means two film evenings (two of the six places gone, so Lucy's week shrinks) and two cuts. Passing Samira's puts her goal at risk (-20 mood). Pass is no longer free: that fighter's next offer comes two weeks later (until asking for fights and favours are built). Every offer shows a line: "This fight week takes from the others: Wednesday's pad place".
7. **Repair the read's rule.**
   - REST when the week's forecast peak is 80 or more, or the fighter is hurt (not at 70).
   - Order: FIGHT, REST, FIX THE WEAKNESS (6 or more under own average and pace 1.0 or better), SHARPEN THE WEAPON (style number at pace 0.5 or better), BUILD WHAT IS LEFT (any number at pace 0.6 or better: Tess's speed), TEACH A PUNCH (only when every number is under 0.5).
   - A read holds for at least two weeks and needs one full point of clearance to flip, so it never flickers.
   - FIGHT covers the last seven days only and does not choose fresh or sharp for the player. In days 8 to 14 it speaks about the scale when the forecast misses ("Tess is 1.1 kg over. Start the cut today.").
   - It uses the numbers the Overview shows, and one ceiling (pick `Recruit.ceiling` or the plain potential, and use it for the pace and the card alike).
8. **Keep a signing choice at the start.** As the guide introduces each fighter, the player picks that fighter's starting focus (the three that exist: signature +10 now, habit gone in 4 weeks, ceiling +5). And let the player choose who stayed: three boxers from five or six (Lucy, Samira, Tess, Kira, Danny, Josh), no two in one weight class, plus Ana. The start cards differ in seats: Fresh doors carries one seat for about 24 weeks; In debt carries none and has the loan; Backed carries two and the backers want the first show won.
9. **Tie Ana to the others.** Besides the seat: when her open night and a club show fall on the same Saturday, the player can be in one building only. The other runs with the assistant in the corner (calls at the assistant's level). With four fighters this clash comes about once a month, and it is the agreed "coach runs it / I run it" in its smallest form. Her read offers two drills, not one: "the hole the last open found" against "the move closest to owned", each with its date (fewer losses at the next open, or the stripe sooner).
10. **One Monday page for the club.** A row per fighter: what the week gave. Only where the player went against the read: both results side by side, with what the player's pick bought. One line for the deal's cost to the others. Two buttons: "Same deal next week" and "Change the deal".
11. **Check before building.** Tess's 7th win and the pro offer (I would make a fighter with four or more losses need 9 wins). The first-hour club tasks (replace "sign a second boxer / get both a bout" with "get all four a fight", "fill a second seat", "open a fifth place"). Add Ana's coach, the mat dues and the sponsor to the money table.

What the game cannot do yet and these need: shared pad places and solo evenings (new evening system), the seat for a grappler, a guide that speaks about more than the first fighter, two offers at once in week 1, a pass that delays the next offer, the hole rule in the fight, and an assistant running a corner alone.

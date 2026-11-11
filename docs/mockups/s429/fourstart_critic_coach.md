Seat: head coach of a real amateur boxing club (mixed group, one assistant on the pads). My 10/10 drawing: `docs/mockups/s429/fourstart_10_coach.html` (picture: `fourstart_10_coach.png`).

# FOURSTART1 through a club coach's eyes

Read first: the critic pack, the access page, the design page, its sister page (amateur fight week), and the code it names:
`GymSpend.gd`, `Data.gd` (the fighters' numbers), `Recruit.gd`, `TrainingPreview.gd`, `WeekPlan.gd`, `WeekPhase.gd`,
`WeekCoach.gd`, `BoutRules.gd` (fight strength), `MoveMastery.gd`, `GymUpgrades.gd`, `Career.gd`, `BjjSide.gd`, `GuideLines.gd`.

## Scores

| What | Score |
|---|---|
| Depth of the whole design | **4 / 10** |
| 1. Who trains full time (the stipend) | 3 |
| 2. What each one trains (follow the guide or not) | 4 |
| 3. Who gets Reid's hands (six pad places) | 5 |
| 4. Who fights first | 2 |
| The guide's read of each fighter | 5 |

Four fighters with four different needs is the right start, and it is how a club really looks on the day you take it over.
But as written the four "decisions" are four separate sums. None of them costs anything in another, and three of them have
one answer a careful player finds once and never thinks about again.

## What works

- The cast is a real gym: a prospect, a raw puncher with no defence, a tough veteran near the end of her growth, and one on
  the mat. I have had that exact group. The numbers in `Data.gd` match the page (Samira defence 50.5 against an average of
  57.9; Lucy's lowest is 3.5 under her average).
- The guide speaking one short line a fighter is how an old trainer hands a gym over. "Samira hits hard and gets hit" is
  what he would say.
- Reid's hands as the scarce thing is true. In a small club the thing you run out of is not bags or floor, it is good
  hands and good eyes.
- The staggered start (one has a bout, one is fresh, one has a goal due, one competes in week 3) is the right way to stop
  day one being four problems.
- Putting the numbers behind the line in a tooltip, and saying what the other choice gives, is honest.

## Where the page and the game disagree (checked in the code)

1. **A day-job fighter and the guide's advice cannot both be true.** Every body number is built by a MORNING session
   (`WeekPlan.SESSIONS`: slip rope builds defence, speed bag builds speed). Evenings build only technique (pads) and ring IQ
   (sparring). The page says a day-job fighter has no mornings and also "gains 15% slower". In the code today `day_job` is
   only a x0.85 on gains and the week board still has all seven mornings. If the mornings really go, three of the four
   fighters cannot do what the guide tells them: Samira's "slip rope first" is a morning she does not have. If the mornings
   stay, the stipend buys 15% and nothing else.
2. **The read is wrong about Tess by its own rule.** Tess: speed 55, potential 76, so speed still grows 0.84 a week;
   defence 0.72, technique 0.70. "Every number is near its ceiling" is false. Her weapon (conditioning 64) grows 0.48, which
   misses "half pace" by 0.02, and her lowest number (speed) is 5.6 under her average, which misses "6 under" by 0.4. So
   no row of the table fits her: the rule as written returns nothing, and the line "Tess is what she is" is not what the
   numbers say.
3. **The read is wrong about Lucy by the fight's own sum.** `BoutRules.fight_power` is the plain average of six numbers
   (chin is not in it). A point is a point wherever it lands. Lucy's speed bag gives +0.83 a week; the slip rope would give
   +1.07 and the heavy bag +1.02. So "sharpen the weapon" is the worse week unless the fight makes an out-boxer's speed
   count for more than a point. Today it does not.
4. **Two ceilings.** Training uses one potential for every number (`pot`). The signing card (`Recruit.ceiling`) shows a
   ceiling per number: +6 on the style's own number, -6 on its gap. The card would show Tess's conditioning ceiling as 82
   while the read calls her finished at 76. The player will see both.
5. **Tess is 1.1 kg over (76.1 against 75) with a bout in ten days, and the guide says "keep the legs fresh".** A cut costs
   tiredness. The first thing any coach says about her is the scale. `WeekCoach.advice` already puts weight before
   everything else; the read does not look at weight at all.
6. **Ring IQ has no morning.** It is built only by sparring. If a fighter's low number is ring IQ the read has no session
   to ring.
7. **Ana's read has nothing to read.** I could not find anywhere the game records which escape she fails (looked in
   `Grapplers.gd`, `BjjWalk.gd`, `BjjOpen.gd`, `BjjTree.gd`). Today the mat drills "the move she is closest to owning".
8. **Reid's eyes are free and endless.** His coach factor multiplies every fighter's mornings in full, however many there
   are. Only his pad hands are counted. In a real club a $450-a-week sessional coach is not in the building at 10 in the
   morning for one boxer.
9. **Money left off the page:** the mat side has its own coach paid by the class ($34, `BjjSide.COACH_CLASS`) and its own
   dues; three boxers' registrations ($18 each). Roster places must go from 3 to 4 (`GymUpgrades.PREMISES[0]`), which also
   means Find a fighter opens with nobody signable.
10. **The word "read" is taken.** `TheRead.gd` is the fight's read meter (how fast a fighter reads a habit). The pack's
    rule is one word per concept. And the Overview already has a COACH SAYS card, the week already has "the coach's one
    change" with a Do it button. A third voice that can disagree with the other two needs one home.

## Where it is not how a club works

- **Nobody decides on day one from a sheet of numbers.** A coach who takes over a gym watches them for a week: three
  rounds on the pads, a spar, a run. The old trainer's word is a hand-over note, and it comes with his favourites.
- **The first read of a fighter is the habit and the person, not the lowest number.** "She drops the right after the jab",
  "she will not do roadwork unless someone is stood there", "she is flat since the last loss". The game has habits, mood,
  discipline and coachability. The read uses none of them. Samira's discipline is 34 and Tess's coachability is 36: those
  two facts would change what I do with each more than any bar.
- **Sparring is the real weekly headache with this group and the page does not mention it.** 60 kg, 65 kg, 75 kg and a
  grappler. Lucy and Samira can work together, carefully, because Samira hits. Tess has nobody within 10 kg. Tess is also
  the only southpaw, which makes her worth gold to the other two.
- **Two fighters a night for 75 minutes is generous, not scarce.** A pad man gets five or six boxers through three rounds
  each in a session. What is scarce is whose pads get real attention. Fine as a game rule, but then where are MY hands?
  The guide's own line is "You can't hold every pad", which says I hold some. And seniors hold for juniors in every club.
- **Amateurs are not paid.** What decides who trains in the morning is the job, the college timetable, the shift pattern.
  Each of the four should have her own reason and her own free hours.
- **"Who fights first" in a club is the matchmaker ringing: "I need a welter or a middle for the 17th."** One place, two
  of yours could take it. And on a Saturday I am in one corner, not two.

## Lookups and always-best plays

1. **The stipend goes to whoever has the biggest gain, and never to Tess.** 15% of Tess's 0.5 a week is nothing; 15% of
   Samira's 1.25 is the most. One line of arithmetic, done once.
2. **Or to nobody.** $250 a week buys about 0.15 of a point a week on a club losing $728 a week. Dropping it adds about 13
   weeks of runway (23 to 36). If "none" is allowed it is probably the best play; if it is not allowed, the choice is forced
   and small.
3. **Flip the stipend every Monday.** `set_stipend` changes at once, free, no notice, no mood cost. Take it off whoever is
   in fight week, hurt or suspended (they are not building) and give it to whoever is. Always right, always dull.
4. **Follow the light.** The read picks the fastest-growing number (Samira) so following it is the best week by
   construction. The page's own three "pulls" barely pull: with no amateur camp the opponent's file only matters in fight
   week, when the read says FIGHT anyway; a day job removes the option rather than weighing against it; the goal is the
   only real one. And the Monday line "what the read's pick would have given" grades the player against the lookup.
5. **Ignore the weapon.** Because fight strength is a flat average, "train the number furthest under potential" beats
   "sharpen the weapon" every week for every fighter (Lucy: 1.07 against 0.83).
6. **Pads: chase 30, then stop caring.** A move is usable at 30 and, as the game stands, sharp is worth about 1 win in 100
   over usable. So the best deal is always: places to whoever has a move under 30 that her next opponent's file asks for,
   nothing for anyone else. And the fighter with a bout this week needs none (a new punch takes two weeks). The price of
   losing a place is small too: the bag gives half, so two pad nights and a bag night is 83% of three pad nights.
7. **Accept Tess's bout.** Accept is free, pass is free, there is one offer and one fighter it fits. A booked bout is +5
   mood, a win is +8 members and $450. There is nothing to weigh, so decision 4 is not a decision.
8. **Ana: nothing.** She takes no pad place, has no offer, and the page does not say she can hold the stipend. Zero of
   the four decisions touch her. For this design the gym has three fighters and a portrait.

## Every menu in the table: what is missing, what is useless, what each option changes

| Menu | Options it has, and what each changes | Missing | Useless |
|---|---|---|---|
| Create, step 2 | Pick one of three starts: sets cash, members, rent | Which four you get (or at least who holds the stipend when you arrive, and why) | "Four fighters stayed" on all three cards is the same line three times: it tells apart nothing |
| Home | Four rows, each with the one thing that needs you; opens that thing | One line for the club's scarce things this week (stipend holder, pad places dealt, who spars whom, whose corner on Saturday) with a button to the one board where they are set | The guide bubble once the first week is over, unless it turns into the chip |
| Gym picture | A light on the place to go; a click goes there | Nothing | A light on "training" is useless with four fighters unless it names WHOSE training |
| Fighters (cards) | Open a fighter; flip stipend / day job (changes gains and $250 a week) | Sort or flag by "no pads this week" and "no partner this week"; what the stipend would give each fighter side by side; the notice rule | The read chip as one word: "Fix" tells me nothing I can act on without the number and the session |
| Fighter page, Overview | The read in one line; the stipend switch | The other candidate with its price; the habit, mood and weight beside it; one voice with COACH SAYS | A second coach's card saying a different thing from COACH SAYS |
| Fighter page, Training (week board) | Morning sessions and Light / Normal / Hard (which number grows, weight, tiredness); the light on one session | For a day-job fighter: which mornings exist and why the rest are grey; who is stood over each morning (Reid, you, nobody) | The light on a session a day-job fighter cannot do; "Back to the coach's week" if the coach's week ignores the read |
| Training, evenings | Deal six pad places (who learns moves at full or half speed) | Your own hands; a senior holding; the sparring pair and who sits out; the outside partner ($40 a visit exists in `BoutRules`); what a place is worth to each fighter this week (which move crosses 30 or 60, and when) | Dealing places to a fighter in fight week, as the rules stand |
| Grappler page (Ana) | Drill a move (which move she owns sooner) | The stipend for her; how many classes a week and what they cost; her open against your Saturday | "The mat's read" until the game records where she loses |
| Fights / Bout page | Accept or Pass on Tess's offer (books the bout; pass changes nothing) | A second fighter who could take the same place; the scale (1.1 kg over) on the offer; what a pass costs | Pass, while it is free and changes nothing |
| Money | A stipend line per fighter; the runway | "No stipend" and what it saves; the mat coach's line; what each bout brings in | Three stipend lines that read $0 |
| Week review (Monday) | Next week | What your choice gave someone else and took from someone else (the pad place, the spar, the corner) | "What the read's pick would have given": it is a mark out of ten for obeying |

## To reach 10/10 (most important first)

1. **One board for the club's week, where the four decisions are made together and each one shows who pays.** Fighters >
   "Club week" (my drawing). Four rows, one per fighter. On it: the one stipend as a token you place; mornings as cells
   that are open, at work, or coached; Reid's six pad places and your own two as tokens on Mon / Wed / Fri; Thursday's
   sparring pair; the matchmaker's one place on the card; a Start week button. Moving any token shows the change on BOTH
   fighters' rows before you let go ("Samira defence +0.4 to +1.2; Lucy speed +0.8 to +0.3"). Home shows the one-line
   summary and links here.
2. **Make the stipend a commitment with a person attached.**
   - Day job, exactly: two mornings a week (Saturday, Sunday) instead of six, evenings as now. Drop the x0.85. So a day-job
     fighter's body numbers grow at about a third of full time, and the guide's morning advice still works for everyone.
   - The stipend moves only on a Monday, and then cannot move for four weeks. The fighter who loses it: mood -8 (she has to
     find work again).
   - "Nobody" is allowed; Money shows "no stipend: +$250 a week, runway 36 weeks".
   - Each fighter has her own line: Lucy, call centre, would hand her notice in tomorrow. Samira, college, has Tuesday and
     Thursday mornings free even without it (four mornings), but see point 3. Tess, warehouse shifts, turns it down under
     $350. Ana, barista: on the stipend she takes five classes a week instead of three.
3. **Mornings need someone stood there.** Reid is sessional: his $450 covers three evenings and TWO mornings a week, which
   you place. You have four mornings of your own to give. A morning with a coach present trains in full; a morning alone
   trains at 60% (`CoachAreas.ALONE_FACTOR`, already in the game) and a fighter with discipline under 45 misses one alone
   morning in three (shown as a chip: "Samira skips mornings alone"). Now the fastest gain in the gym (Samira's defence)
   belongs to the fighter least likely to do the work unwatched, and the stipend is only worth what you can supervise.
4. **Make the weapon worth more than a point, so "fix or sharpen" is a real argument.** In fight strength, the number a
   style is built on (`Recruit.CLASSES` third entry) counts 1.5; the number it lacks counts 0.5; the rest 1.0 (weights
   still sum to 6). Lucy: speed +0.83 x 1.5 = 1.25 against defence +1.07. Close, so the next opponent decides it. Also:
   against a named style one number counts 1.5 for that bout (a pressure fighter: your defence; an out-boxer: your
   conditioning). Measure both on `BalanceHarness` before building. Use ONE ceiling everywhere (`Recruit.ceiling`), so the
   signing card and the read agree.
5. **Rebuild the read as the old trainer's hand-over, two picks, never one light.** Order: (a) SCALE: over the limit with
   a bout inside 14 days; (b) FIGHT; (c) REST; (d) HABIT: a habit the next opponent's file punishes ("drops the right:
   Croft's overhand"), trained out on YOUR pads only; (e) FIX and SHARPEN shown side by side with their weighted gains, the
   trainer's favourite marked; (f) TEACH A PUNCH only when the best gain left is under 0.5 a week. Fix the gap so every
   fighter gets a read (Tess today gets none). Add the person in a chip: mood, discipline, coachability. In week 1 show each
   number as a range of plus or minus 3 that closes when you have watched that fighter on the pads or in sparring once
   (the game already has scouted ranges): the trainer's note is certain, the numbers are not, and he is wrong about one of
   the four (random by save). Rename it: fold it into COACH SAYS, drop the word "read", and make the week's "one change"
   line the same voice.
6. **A real "who fights first": one place, two takers, one corner.** Monday, week 1, the matchmaker: "York Hall, Sat 17
   Jan. I can use ONE of yours: a middle or a welter." Tess v Amy Croft (4-3): likely win, 1.1 kg to lose, $450, moves her
   up the table, teaches her nothing. Samira v Jade Okoro (2-1): meets her "bout inside 21 days" goal (missed = mood -12),
   but defence 50 against a straight right, and a stoppage loss is 28 days out. Pass on both: the matchmaker's favour -1
   and the next call two weeks later. Then in week 3 put Ana's open and the next club show on the same Saturday: you
   corner one; the other gets Reid (your calls are not available, hers land at 0.85) or is simulated.
7. **Make the six places bite, and add the other hands.**
   - Switch on the rule that is already built and measured: a planned line fires 1 in 2 at Usable, 3 in 4 at Sharp, always
     at Signature (+2.8 wins in 100 a step). Then pads after 30 matter.
   - Your hands: 2 places a week. Same mastery as Reid's, and the only place a habit is trained out.
   - A senior holds: a boxer with 6 or more bouts (Tess) can hold one place a week at 0.7 of Reid's gain. It costs her that
     evening's own work and gives her mood +3 the first month. That is the job a veteran near her ceiling really has.
   - Thursday sparring is a pair you pick. Within 5 kg: full. 5 to 10 kg: full for the lighter, half for the heavier, and
     the lighter one's tiredness +6 if the heavier has power 65 or more. Over 10 kg: not allowed. Sparring a southpaw once
     removes the first-round penalty against southpaws (the game has this for a paid partner). Nobody to spar: bring an
     outside mate for $40 (`BoutRules.PARTNER_FEE`) or she does shadow at 0.85.
   - Each pad token, when held over a fighter, shows what it buys: "Check hook 22 to 27: Usable in 2 weeks, not 3".
   - Run HANDSPROBE again for three boxers on 6 + 2 + 1 places before the build, as the page already says.
8. **Bring Ana inside or say plainly she is outside.** Inside means: she can hold the stipend (point 2); her classes are a
   dial, 2 / 3 / 5 a week at $34 a class; her open can clash with your corner (point 6); and `BjjOpen` keeps a tally of the
   position she lost each match from, so the mat's read has something true to say ("lost 3 of 6 from under mount").
9. **The Monday review tells the story of the trade, not the mark.** Per fighter, one line: what she got, what it cost
   another. "Samira: defence +1.1 (your Tuesday and Thursday mornings). Lucy trained alone twice: speed +0.5, not +0.8."
   After each bout the Why names the week's choice that showed up in the ring.
10. **Small honest fixes.** Roster places 4 at the first unit and Find a fighter says "no place: a second club coach
    opens one" on every card. Money shows the mat coach and all four registrations. The Create cards say who the four are.
    The guide's FIGHT line for Tess says the weight first: "Tess is a kilo over. Ten days."

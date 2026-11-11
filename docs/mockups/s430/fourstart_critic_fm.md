DEPTH: 5/10

# FOURSTART1 reviewed from the football-manager chair

Seat: a designer of squad games (many players, one training ground, too few coaching hours, a match every week).
Read: CRITIC_PACK, CRITIC_ACCESS, `fourstart_map.md`, and the code named below. Nothing else about this design.
My 10/10 picture of the Club week board: `docs/mockups/s430/fourstart_10_fm.png` (page: `fourstart_10_fm.html`).

Short version: the frame is right and it is the frame of a 7. Three shared things, four people, and every move
shows who pays. But with the design's own numbers almost every choice has one answer, the board is solved in
week 1 and nothing un-solves it. I would play this happily for six to eight hours, not twenty.

## A. Depth: 5 out of 10, and the three reasons

1. **The skeleton is the right one (this is what lifts it to 5).** Seats, coached time and places on the card
   are shared by four people, and the board shows what a move gives one and takes from another before you let
   go. That is exactly how a squad game makes one decision change the next. Most designs never get this far.
2. **The numbers give one answer to nearly every choice (this is what holds it under 7).** I count six
   choices where the design's own figures pick the winner for you (section B). The two it is proudest of,
   "who gets the coach" and "weakness or weapon", are the clearest: both reasons point at the same fighter,
   and the weakness wins by a third.
3. **Nothing changes after week 1.** The roster is full on day one (4 of 4 places), nobody arrives or leaves,
   the seat is locked by its own rule, the sparring pair is fixed by body weight, and the only event is one
   place on a card every other Saturday. A squad you cannot change, on a calendar that asks one question a
   fortnight, is a puzzle you solve once.

## What I checked in the code (the design's claims about today's game)

| Claim in the design | True? | Where |
|---|---|---|
| A day job trains at a hidden x0.85 | Yes | `scripts/state/GymSpend.gd:30` |
| Training alone is 60% | Yes | `scripts/rules/CoachAreas.gd:8` |
| Fight strength today is a plain average | Yes, of six numbers, the chin is not in it | `scripts/rules/BoutRules.gd:182-186` |
| Three starting focuses (+10 signature, habit in 4 weeks, ceiling +5) | Yes | `scripts/rules/Recruit.gd:36-38` |
| 3 roster places at the first unit | Yes | `scripts/rules/GymUpgrades.gd:27` |
| Reid $450, Hale $1,090 | Yes (Reid is rated 58) | `scripts/state/Data.gd:28,31` |
| Samira: defence 50, low discipline; Tess 6+ bouts, 1.1 kg over | Yes (50.5, discipline 34; 6-4, 76.1 kg) | `scripts/state/Data.gd:210-217` |
| A mat member pays $110, a class costs $34 | Yes | `scripts/rules/BjjSide.gd:19-20` |
| Evening classes with a coach $350 (so one evening is about $115) | Yes | `scripts/rules/GameMoney.gd:10` |
| A missed goal: "mood -12" (3.5) and "mood -20" (3.3) | The code says -20; -12 is the number for a lost bout | `scripts/rules/FighterGoal.gd:31`, `FighterProfile.gd:20` |
| Samira's defence "+1.25 a week" (3.2) and "+1.2" (3.3) | 1.25 is the cap before the coach; with Reid (58) it is about 1.13, alone 0.75 | pack 4.1, `Data.gd:28` |
| "In week 3 Ana's open and the club show fall on the same Saturday" | Not on today's calendar: shows are day 12 then every 14, opens day 33 then every 35. The first shared Saturday is 14 March, then one every ten weeks | `Data.gd:101-102`, `NoGi.gd:28-29` |
| The trainer rests a fighter at tiredness 80 | Today it is 70 | `scripts/rules/TrainRead.gd:11` |
| MONEYFOUR1 (the seat money) | Not checked: I did not open research files | |

## B. The hunt

### Dominant plays (one choice that is always right)

1. **Your mornings go to Samira. Every week.** The design calls this a tension: "the fastest gain in the gym
   belongs to the fighter least likely to work unwatched". It is the opposite of a tension. Both facts say the
   same thing. A coached morning is worth 1.0 against 0.6 alone for anybody: a lift of 0.4. For Samira alone
   is 0.6 times two in three = 0.4, so the lift is 0.6, and it lands on the fastest number in the gym. And she
   is the only one of the six starters under discipline 45 (Kira 64, Tess 62, Danny 60, Josh 80). A real
   tension needs the two facts on different people.
2. **Fix the weakness first, then never think about it again.** Design's own figures: slip rope, defence
   +1.2 a week, counting 1.0 = 1.2. Heavy bag, power +0.6 a week, counting 1.5 = 0.9. The weakness wins by a
   third before the other corner's +1.0 is even counted, and by double against a pressure fighter (defence
   counts 1.5 that night: 1.8 against 0.9). It stops being a weakness when it is within 3 of her average,
   about 5 points: four to five weeks. After that the rule is asleep.
   Worse: **only one of the six starters has a weakness at all.** By the design's rule (6 or more under the
   fighter's own average) I get: Samira's defence 7.4 under, yes. Kira's chin 5.7, Tess's speed 5.6, Josh 4.2,
   Lucy 3.5, Danny 2.9: all no. Pick a trio without Samira and section 3.4 never happens in the first months.
3. **Tess takes York Hall.** A likely win, $450, and a win brings 8 members and 5 reputation
   (`BoutRules.gd:90-91`). Samira's price is her goal, "a bout inside 21 days". But in today's code that goal
   is met the moment a bout is BOOKED, not fought (`FighterGoal.gd:217-234`), and the matchmaker calls again
   on Monday 19 January, inside the 21 days. So: Tess now, book Samira in week 3, everybody is happy. And
   "teaches her little" has no number behind it, so the easy win costs nothing.
4. **Reid goes to Ana's open. Always.** He corners at 0.85 in a bout the design itself says has one
   decision. The boxer's corner has eight calls and a corner minute. Nobody will ever send Reid to the ring.
5. **Tess holds pads. Always.** One more pad place at 0.7 for the price of one evening of the fighter with
   the lowest ceiling in the gym (potential 76), and her mood goes UP 3. Switch it on in week 1, forget it.
6. **The seat goes to the highest ceiling who says yes at $250.** Lucy (84) in the design's trio. There is no
   second candidate: Samira already has four free mornings, Tess wants $350, Ana's seat has no numbers.

### Free choices (no cost)

- **Never giving a seat.** A fighter minds LOSING a seat (-8). Nobody minds never having one. So "nobody" is a
  safe line with the bank growing $270 a week.
- **Samira's Tuesday and Thursday mornings.** Four mornings without a seat is two thirds of a seat for nothing.
  Fine as character, but it makes her the best value in the gym on top of points 1 and 2.
- **Passing on both bouts.** The cost is "a favour lost" (no number, nothing it buys) and "the next call two
  weeks later", which is when the next show is anyway (`Data.gd:102`).
- **The week-1 ranges.** Plus or minus 3 closes when you watch a fighter on pads or sparring. Every boxer
  has a pad night in week 1. It closes by itself; the player decides nothing.
- **The trainer's one wrong note.** You find out in week 2 when the range closes, having lost one week of
  mornings (about one point). The only place it can bite is the starting focus, and there it is a blind
  bet, not a choice: you cannot look before you pick.

### Dead options (never right)

- **Tess on a seat.** $350 against $250 for the fighter with the lowest ceiling and the most miles.
- **The fourth pad evening at $115.** It buys two pad places, about 5 points of mastery (2.1 an hour, 75
  minutes each). A whole step of 30 points is worth 2.8 wins in 100. So $115 buys half a win in a hundred.
  A price that never pays is not a choice. Make it a scarce favour, not a price (section E).
- **Ana on 2 classes.** Saves $34 and slows the belt. Right only when the club is broke.
- **Training the number the style lacks.** It counts half. That is intended, but then it should not be offered
  as a pull. Two holes in the rule itself: a boxer-puncher "lacks" chin (`Recruit.gd:16`) and the chin is not
  in fight strength (`BoutRules.gd:184`), so Danny has no half-number and simply gets stronger than the
  others for free; and a counter-puncher is "built on" ring IQ, which mornings cannot train
  (`TrainRead.gd:17`), so that style can never follow the weapon pull.
- **Pass on both**, as written (above).

### Exploits

- **The goal met by booking** (point 3 above).
- **The fighter's own Training page as a back door.** The design gives two places to edit the same week. If a
  pad night can be added on the fighter's page, the cost to the others is not in front of you. The page must
  not own any shared slot.
- **A day-job boxer kept off the pads.** Two weekend mornings plus five solo evenings at 0.6 = 5.0 mornings'
  worth a week, free. A paid seat is six mornings, but alone ones count 0.6: with two coached that is 4.4.
  The design must say whether the solo evening is cut again by the alone rule, and whether a seated boxer has
  solo evenings too. As written the free boxer can out-train the paid one on numbers.
- **The weakness rule starts at the third bout.** Kira (1-0) can ignore her chin for two bouts. Small.

### Decided once, never reopened

- The seat (four weeks' lock, -8 to move it, one obvious holder).
- The sparring pair. With Lucy, Samira and Tess there is exactly ONE legal pair: Lucy and Samira are 5.0 kg
  apart (60.9 and 65.9, right on the design's line, so the rule must say which side 5.0 falls), Tess is 10.2
  from Samira. "A pair you pick" is not a pick. And the design does not say whether a woman may spar a man;
  if not, Danny and Josh (10.3 kg apart) have nobody either.
- Who holds for whom, Ana's dial, the coached mornings, the starting focus, the trio.

### Numbers that make a choice trivial

- **Pad places are not scarce.** Six from Reid, two from you, one from Tess: nine places for three boxers.
  Today's ordinary week is three pad nights each (`PadWeek.gd:52`). Nine for nine. The headline scarcity of
  the board is short by nothing in a quiet week.
- **Coached mornings: the design does not say how many fighters one coached morning covers.** If a coach
  covers everybody in the room, put the coaches on Saturday and Sunday when all three are in, and the
  scarcity is gone. If one coach is one fighter, six mornings for about eleven wanted is real. This one
  sentence decides whether the second scarce thing exists.
- **Opponent-specific training cannot move a bout at amateur lead times.** Two weeks at +1.2 is 2.4 points;
  at weight 1.5 instead of 1.0 that is 0.2 of a point of fight strength: under one win in a hundred (the pack:
  5 points = 72%). Only the long view (AHEAD, the ladder) can matter, so the board must show three shows
  ahead, not one.

## C. Every menu in the design's table

| Menu | What each option changes | Missing | Useless |
|---|---|---|---|
| **Create, step 2** | The trio fixes who can spar whom, which show places you can ever take, and whether a weakness or a skipper exists (only Samira brings either). The start card fixes seats. | At the moment of picking: who can spar whom (a line between the cards), who has nobody, each one's seat line and price. Whether men and women may spar. Why Lucy and Danny (both "Lightweight") count as different classes. | Ana drawn as a pick: she is fixed. Show her as already there. |
| **The guide, week 1** | The focus: +10 on the signature now (Sharp at once for most), a habit gone in 4 weeks (frees your own pad places, the only ones that train a habit), or +5 ceiling (about +0.2 a week on every number for the whole career: the long game wins any career over ten weeks). | "Watch first, pick the focus next Monday" so the wrong note can be caught by playing. A way to test the trainer: spend one of your mornings watching instead of coaching. | The range as a decision: it closes by itself. |
| **Club week board** | Seat: 2 mornings to 6, -$250 a week. Coached morning: 0.6 to 1.0 on that session. Pad place: mastery and a date. Sparring pair: full, half, tiredness. Place on the card: who fights. Start week. | The week's totals: asked against owned for mornings and pad places, and who goes short (the pair view alone hides the whole). The twist card (four fighters draw four a week today: where do they go?). Diet and the scale (the trainer's first check has no control here). Light / Normal / Hard. Tiredness forecast per row. "Same as last week" in one press, so a quiet week is still one click. "Reid deals it" per fighter (the agreed "Coach runs it"). The next three shows. | The runway for every seat count, every week: it changes once in four weeks, put it behind the seat. The place on the card in a week with no offer. |
| **Home** | Nothing itself: it links. | "Who goes short this week" in one line, with the button. "Deal as last week". | Repeating the pulls. |
| **Fighters cards** | Opens the fighter. | The seat's end date. Weeks since the last bout (the -6 a month clock). What the fighter has asked for. A button on the flag that does the thing. | The discipline chip on five of six starters: show it only when it bites, as the design says. |
| **Fighter page, Overview** | Shows the pulls. | The buttons to choose the pull here, or it is information without an action (the owner's rule). "Their corner knows" yes or no on the weakness. Pulls you refused and what that will cost at the goal's end. | The ranges after week 2. |
| **Fighter page, Training** | Session and intensity of that fighter's own slots; solo evenings. | A plain mark on the slots the board owns (coach, pad place, sparring): they cannot be changed here. | Any second way to deal a shared slot. |
| **Grappler page (Ana)** | Drill: "the position the last open found" (fewer losses) or "closest to owned" (the stripe sooner). Classes 2 / 3 / 5: speed of the belt, $34 each. Seat: 5 classes. | What 5 classes give in numbers: the stripe date and how many mat members. A cost for 5 besides money (tiredness before an open), or 5 is always right when you can pay. Who teaches (already in the game). Anything she shares with the boxers besides money. | The "2" on the dial. |
| **Fights** | Who takes the one place; what that fight week takes from the others; which corner you stand in. | The next two shows and the class each asks for. What a pass costs and buys, in a number. What each bout teaches, in a number. The rank earned (owner's S428 rule). An away place on the same night. | "Pass on both" as written. The corner clash while it is Ana against a boxer. |
| **Money** | Runway by seat count; Reid's hours; the fourth evening. | Ana's mat as its own line (members x $110 against classes x $34). The second coach ($280) shown as "opens a fifth place". Hale against Reid as pad places (10 against 6) for +$640. | The fourth pad evening at $115. |
| **Week review (Monday)** | Only "Next week". | The trainer's score ("Reid's picks this month: 3 right, 1 wrong"). For each choice you made against him, the one number it was worth. "Change it" beside a line, landing on that slot. Who went short. | A "cost" line where no other choice existed. |
| **The Why after a bout** | Shows which week's choice showed in the ring. | Each line tied to a dated board choice ("3 weeks of slip rope, defence 50 to 54: Okoro's corner did not find it") with a button back to the board. It must be worked out by replaying the bout without the change, as the Why does today, or it will tell stories. | Nothing. |

## D. What a player actually does

- **Week 1: a full and good hour.** Pick three of six. Four introductions, four focuses. Give Lucy the seat.
  Put your four mornings on Samira, Reid's two on Lucy. Deal nine pad places three, three, three. Tess holds
  one. Lucy spars Samira (the only pair). Tess takes York Hall and starts the cut. Start week. It is the best
  hour in the design, and close to too much at once; the one-at-a-time introductions are the right answer.
- **Week 5: the first Monday the seat may move, and it will not** (-8, and nobody else is a candidate).
  Samira's defence is about to leave the weakness rule. Ranges closed three weeks ago. The player presses the
  trainer's favourite on four rows, shifts two pad places toward whoever fights on Saturday, picks the taker
  for the next place, starts the week. Five minutes. Ana's first open (7 February) clashes with nothing.
- **Week 20: one question a fortnight.** Who takes the place. Everything else is last week again. No weakness
  left, no range, no habit, the seat where it was in January, the same pair sparring, the same nine pad
  places, the bank flat. Nobody has arrived, nobody has left, nobody is unhappy enough to matter. Week 20
  asks almost nothing. That is the 5.

## E. To reach 10/10 (most important first)

1. **Make every week over-asked, and say how far a coach stretches.**
   Rule: one coached morning covers ONE fighter, or TWO who do the same session (each then at 0.8).
   Each fighter's chosen pull carries a ticket: the coached mornings and pad places it wants. The four tickets
   together must always ask for more than the gym owns: aim at 9 mornings asked for 6 owned, 11 pad places
   for 9. Cut Reid to two pad evenings (four places) at $450 if that is what it takes; nine for nine is not
   scarcity. A fighter left short two weeks running: mood -3 and a chip "short again".
   Screen: three counters across the top of Club week, "ASKED 9, HAVE 6, 3 SHORT", and a red corner on every
   slot that goes without. Start week names the short ones. No week can be "accept all four".

2. **Let the squad change: a fifth place, the trial mat.**
   Rule: every four weeks one prospect trains with the club for two weeks (first the three you did not pick
   at Create, then the scouted ones). On trial they use one pad place and one coached morning a week, taken
   from the four. At the end: sign (only if one of the four leaves, or you pay the second coach, $280 a week,
   for a fifth place) or pass. Going the other way: a fighter at Low mood on three Mondays running asks to
   leave, and the rival gym's offer (already agreed, R58) arrives for your best one.
   Screen: a "Trial mat" card on Club week (face, dates, what it takes); the sign-or-pass choice on Fighters.
   This is the single thing that keeps week 20 and week 60 asking "who are my four".

3. **Break the six single answers with numbers.**
   - Seat: sold as a four-week block that ends by itself with NO mood loss (-8 only if you pull it early),
     mood +5 when given. A block that covers a booked bout adds the camp's night edge (+0.6). The seat then
     follows the fight calendar instead of sitting on one fighter. Tess takes it at $250 when it covers a
     ranked bout. Screen: the seat chip on each row shows "to 2 Feb"; Money shows the next block's price.
   - Coach against skipper: split the two reasons. Use what the code already holds: each coach has a rating
     per kind of work (`CoachAreas.gd:9,63`; Reid: pads 74, bag 64, conditioning 48, `Data.gd:30`). Show on
     every slot what THIS coach adds to THIS session against training alone ("Reid on the bag +58%, on
     roadwork +39%"). Then who gets the coach depends on what they train. And let a
     team-mate in the room stop the skipping (Tess beside Samira on Saturday: no skip, no lift).
   - Weakness: gap 4, not 6 (then Kira's chin, Tess's speed, Josh's defence and Samira all have one). The
     built-on number counts 2.0, not 1.5 (then at the design's own example weapon 0.6 x 2.0 = weakness
     1.2 x 1.0, and the next opponent breaks the tie). The other corner finds a weakness only if its style
     hunts that number, shown on the offer: "Okoro's corner will find it". Fix the two style holes: no style
     may be built on a number mornings cannot train, and none may lack a number that is not in fight strength.
   - Senior holds: mood +3 for four weeks, then -2 a week from week 5 unless she has a bout booked ("I am a
     boxer, not a pad man"). Twelve held weeks open "Tess as pad coach, $150 a week" when she retires.
   - Fourth pad evening: not $115. Reid has THREE extra evenings a quarter, shown as three tokens on his
     card. A scarce favour is spent with care; a price that never pays is never paid.
   - Corner clash: make it boxer against boxer. From week 6 the matchmaker sometimes offers an AWAY place on
     the same night as the home show (a ranked opponent, no ticket cut). One fights with you, one with Reid
     at 0.85, and the fighter left with Reid on a first or ranked bout: mood -5.

4. **One club twist a week, aimed at something shared.**
   Replace four personal twist cards with one for the club: "Reid is off Wednesday: two pad places gone",
   "a visiting pro gives one sparring session: who gets it", "the boiler is out: no mornings Thursday",
   "Tess's shift changed: no Saturday". Two or three answers, each with a price on two named fighters.
   Screen: a card at the bottom of Club week; Start week waits for it. This is what un-solves last week's
   deal every Monday.

5. **Show three shows ahead, and give every bout something it teaches.**
   Rule: the matchmaker names the class each of the next three shows asks for. A bout teaches ring IQ by how
   hard it was: +0.3 for a likely win, +1.0 for an even one, +1.5 for a step up. The bout goal is met when
   the bout is FOUGHT. The matchmaker holds three favours: a pass spends one, a favour buys "name the class
   next time", and at none your next home place goes to the rival club's boxer, who takes the rank step.
   Screen: "The card" strip on Club week and on Fights: three shows side by side, the takers under each with
   chance, rank, what it teaches, and the waiting clock of whoever is left out ("Samira waits: 26 days").
   Giving Tess the 17th is then a three-show plan, not one click.

6. **Put Ana on the same floor.**
   Rule: once a week Ana can take one boxer for a mat morning (clinch and engine: conditioning as a coached
   morning at 0.8, and "Tie up" works 10% better for four weeks). It costs her one class of her own drill.
   And one boxer within 10 kg can be her drilling body for an evening: her drill +30%, the boxer's evening
   gone. Give her seat its numbers: 5 classes = the stripe N weeks sooner and +2 mat members a month.
   Screen: her Saturday slot and the boxer's Saturday slot joined on the board.

7. **A trainer with a taste you learn, and a score.**
   Rule: Reid is a pad man: his star goes to the weapon and to pads two times in three. Hale's goes to the
   engine. The fighter's own wish and the ladder sit beside his star, so the player judges between three
   voices. The Monday review keeps his score. Spending one of your own mornings WATCHING (no lift for
   anyone) closes a range or checks one of his notes: "watch or coach" is then a real use of a scarce morning,
   and it returns with every trial fighter.
   Screen: the three pull chips on each row carry whose voice it is (Reid's face, the fighter's face, the
   ladder); the review line "Reid this month: 3 right, 1 wrong".

8. **Write the missing numbers into the map.** How many fighters a coached morning covers. Whether a solo
   evening is cut by the alone rule and whether a seated boxer has them. Which side of the line 5.0 kg falls,
   and whether men and women spar. -20, not -12, for the missed goal. What a favour is. The calendar change
   that makes the first clash. Mat members per class for Ana.

## F. My 10/10, drawn

`docs/mockups/s430/fourstart_10_fm.png` (page: `docs/mockups/s430/fourstart_10_fm.html`), 1920x1080.
The Club week board with changes 1 to 7 on it:
- top: the three shared things as counters (coached mornings ASKED 9 / HAVE 6, pad places ASKED 11 / HAVE 9,
  seats and the bank), and the next show;
- four rows: the fighter with mood and the seat block's end date; three pulls, each marked with whose voice
  it is; seven days of mornings and evenings with the coach's face on each coached slot, a red corner on each
  slot that goes short, grey for the day job; what the week gives as bars with dates;
- bottom: the card for three shows with the takers side by side, the move in your hand showing both fighters'
  change, this week's club twist, and the trial mat.
Tess's and Ana's portraits are stand-ins (the game holds no menu portrait for either under their names).

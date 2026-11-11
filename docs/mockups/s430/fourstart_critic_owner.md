DEPTH: 5/10

# FOURSTART1 read by a club owner and head coach (20 years, one paid coach, boxers with day jobs)

Reviewed: `docs/mockups/s430/fourstart_map.md`. My 10/10 board: `docs/mockups/s430/fourstart_10_owner.png` (source `fourstart_10_owner.html`).
I read the pack, the access page and the code. Every number I checked has its file and line.

## A. Depth: 5 out of 10

The first month is good. Week 1 is the best first hour this game has had on paper: four people, three shared things, and a board that
shows what a move costs somebody else. After the deal is found the board stops asking. I would play five or six hours happily, not twenty.

The three reasons it sits at 5:

1. **Most of the choices are made once.** The three boxers, each starting focus, who holds the seat, how the pad places are split. Nothing
   in the design changes who can come, what a seat costs or what Reid offers from one week to the next, so the board of week 20 is the
   board of week 6 with a different name in fight week.
2. **The shortages are loose, or not stated, on the design's own numbers.** Nine pad places for nine wanted. A seat for nobody grows the
   bank and nothing answers it. A coached morning does not say how many boxers it covers. Passing on a bout has no upside at all.
3. **Weakness against weapon, the headline, touches one fighter for three weeks.** Only Samira starts with a number 6 under her own
   average, and at +1.2 a week she is safe in three weeks. A full-time boxer has six mornings and simply does both.

What keeps it off a 3 or 4: every move shows both sides before you let go, the fighters' own lines about the seat are people and not
numbers, and "the fastest gain belongs to the one who skips alone" is exactly the kind of knot a real gym has.

## B. The hunt

### What I checked in the code
- Day job gains x0.85 today: true, `scripts/state/GymSpend.gd:30`. The seat switch is free and instant today: `GymSpend.gd:101-110`.
- Alone trains at 60%: true, `scripts/rules/CoachAreas.gd:8`.
- Fight strength is a plain average of six numbers (chin is not one): true, `scripts/rules/BoutRules.gd:182-186`.
- Three starting focuses: true, `scripts/rules/Recruit.gd:35-39`. What each style is built on and lacks: `Recruit.gd:11-18`.
- Reid: $450, three evenings, pads 74: `scripts/state/Data.gd:28-30`. First unit holds 3 fighters today: `scripts/rules/GymUpgrades.gd:27`.
- The six boxers and their numbers: Lucy `Data.gd:52-60`, the other five `Data.gd:205-226`.

### Dominant plays (one answer is always right)
- **The seat goes to Lucy, in week 1, for good.** She gains four mornings for $250. Samira already has Tuesday and Thursday free, so
  her seat buys two mornings, and she skips one alone morning in three (discipline 34, `Data.gd:213`). Tess wants $350 for the same four
  mornings with a ceiling of 76 against Lucy's 84 (`Data.gd:215`, `Data.gd:55`). Ana is below. Three "plays", one answer.
- **Ceiling +5 beats Sharpen the signature for anyone you keep.** +10 mastery is three pad sessions with Reid (2.1 an hour x 1.25 hours
  x his lift 1.30 = 3.4 a session, `scripts/rules/MoveMastery.gd:8`). +5 potential is +0.2 a week on every number below the pace cap
  (pace is (potential - number) / 25), for the whole career.
- **Fix Samira's defence first, always.** Her six numbers average 57.0 and defence is 50.5. Slip rope gives +1.2 at full weight AND
  takes away the other corner's +1.0. The weapon gives +0.6 x 1.5 = 0.9 and removes nothing. Three weeks, then it is over.
- **Take the bout for Samira.** The design says her goal missed costs mood -12. The code says a missed goal is -20 and a met one +10
  (`scripts/rules/FighterGoal.gd:29-31`); -12 is what a loss costs (`scripts/rules/FighterProfile.gd:20`). So she boxes and loses: +10 - 12 = -2.
  She does not box: -20. Boxing is better for her even when she loses.

### Free choices (no cost)
- **Tess holds a pad place.** With nine wanted and eight places, hers is the ninth every week, and it lifts her mood +3 in the first month.
- **Closing the week 1 ranges.** One pad or sparring session closes a fighter's plus or minus 3. Eight places, three boxers: all closed
  by Wednesday, before the first pull matters. So the trainer being "wrong about one of four" costs nothing.
- **Nobody on a seat.** The bank grows about $270 a week (the design's number) and nothing in the design pushes back: no fighter asks,
  no rival club calls, no mood moves.

### Dead options (never right)
- **Pass on both bouts.** A favour lost and two weeks of waiting, for nothing in return.
- **Ana's seat as "the best money play".** Today mat members arrive only from a medal (gold 2, silver 1) and once from the blue belt (3):
  `scripts/rules/BjjSide.gd:26-27`. Three members at $110 a month (`BjjSide.gd:19`) are $76 a week. The seat costs $250 plus two more classes at $34
  (`BjjSide.gd:20`) = $318 a week. Blue comes at about 15 months on three classes (`scripts/rules/NoGi.gd:5`), about 9 on five. So the seat
  spends about $12,400 to bring $76 a week six months sooner, worth about $2,000. It loses $10,000 unless the member rule changes.
- **Tess's seat at $350 and Samira's seat** (above). **Two classes a week for Ana**: it saves $34 and slows the belt; no situation is named where that is right.
- **Four seats**: the design itself says most clubs close. Do not offer it as an equal button.
- **Training the number a style lacks.** At a weight of 0.5 and a ceiling 6 lower (`Recruit.gd:57-61`), Lucy's power is worth about
  0.4 a week against 1.0 or more for anything else. And Tess's lacked number is defence, the one number that counts 1.5 against a
  pressure fighter. The two rules pull the same number in opposite ways and the design does not say which wins.
- **Sparring is "a pair you pick"** but the named three have one legal pair. Lucy 60.9 and Samira 65.9 are exactly 5.0 kg apart; Tess 76.1
  is 10.2 over Samira, banned by 200 grams (`Data.gd:54`, `210`, `214`). There is nothing to pick.

### Numbers that make a choice trivial
- **Pads: 6 + 2 + 1 = 9 places, and three boxers on today's standard week want 3 each = 9.** Most weeks "what it costs another" will read "nothing".
- **Weakness needs 6 under the fighter's own average.** I ran all six. Samira 6.5 under (defence). Kira 4.7, Tess 4.5, Josh 3.4, Lucy 2.6,
  Danny 2.4. One fighter in six has a weakness on day one, and the three the design names include her by luck.
- **Reid in the corner: calls land at 0.85.** That is the same as a fighter in a Flat mood. You corner whichever bout is closer and forget it.
- **"Tess against Croft: a likely win."** Tess's six numbers average 59.5; Croft is rated 61.0 (`Data.gd:173`). At 5 points for 72% that is about
  43%. Samira (57.0) against Okoro (59.5, `Data.gd:168`) is about 39% before her defence is found, less after. Both are underdogs, so "safe win or risky goal" is not the real choice.
- **A fourth pad evening for $115.** Two places for what a sharp line gives (about 2.8 wins in 100 after roughly nine sessions) is right
  only in the last days before a bout when a line is a point or two short. Fine, but say that on the button.

### Decided once and never reopened
The trio. The three starting focuses. The seat (see above). The 3 / 3 / 2 pad split. Ana's classes dial. Reid or Hale.

### Exploits
- Put every boxer on the pads once in week 1 to read all the true numbers before choosing anything.
- If the wrong note is "set by the save", a reload shows which note is wrong. Draw it when the fighter is first watched, not at the start.
- A seat moved on a Monday holds four weeks: seat a fighter the Monday before a run of bouts, drop the seat after. The -8 mood is cheaper than $1,000.

### Not said, and it matters
- How many boxers one coached morning covers. If one: with nobody on a seat only weekend mornings exist and you cannot use your four. If all: no shortage.
- Whether a full-time boxer also gets solo evenings, and whether a solo session is 0.6 once or 0.6 twice (light, and alone).
- How many of your pad places train a habit out, and whether the "habit gone in 4 weeks" focus uses them.
- How often "one place, two takers" happens after week 1. Only week 1 and week 3 are written.
- The seat lines of Kira, Danny and Josh. Whether "no two in one class" stops Lucy and Danny (both lightweights), and whether a man and a woman spar.
- One twist card for the club, or four.
- The calendar: opens start on day 33 and come every 35 days (`NoGi.gd:28-29`), shows on day 12 and every 14 (`Data.gd:101-102`). The first shared
  Saturday is 14 March, week 10, not week 3.

### Untrue to a real club, in ways a player would feel
1. **Nobody's week is fixed.** Shifts change, exams come, overtime is offered. Every real week starts with "who's in tonight?". Here the
   call centre, the college and the warehouse never move. This is the least true thing in the design and the one that costs it the most depth.
2. **A coach on the floor coaches the room.** I stand by four bags and watch four boxers. Only the pads are one to one.
3. **A middleweight spars a welter every week.** "Body only", "you just jab", "she only defends". A flat ban over 10 kg is not how gyms work.
   And sparring at another club costs no money. It costs the coach's evening and the petrol.
4. **A boxing pad man does not corner a grappling open.** Ana's own class coach goes with her.
5. **The phone.** The thing every club coach knows is missing: the opponent who pulls out on Thursday, the replacement who is 2 kg heavier
   with five more bouts, and the favour you bank with the matchmaker by saying yes. And the promise to the one left out: "the next one is yours".
6. **No small club pays an amateur $250 a week from $35 subs.** As a game device it works. It would feel truer as a sponsor's money with a
   name on it (Ironclad's $250 a week is exactly one seat) and a sponsor who has a view on who should hold it.

## C. Every menu in section 4

| Menu | Missing | Useless | What each option changes |
|---|---|---|---|
| Create, step 2 | What the trio does together: lines between the three showing who can spar whom, who can hold pads (6 bouts: Tess, Josh), each one's job and free mornings. The seat lines of Kira, Danny, Josh. | The class rule with no reason shown. | The trio fixes the sparring pairs, the senior holder and the seat prices for the year. |
| The guide, week 1 | "Decide after I have seen them": the focus picked at the end of week 1, not before the first session. | The plus or minus 3 range (one session closes it). The wrong note (costs nothing). | Signature: three pad sessions' worth. Habit: frees your own pad places. Ceiling: +0.2 a week on every number for good. |
| Fighters > Club week | Your own time as one pool. Who can come next week. Counter on the bout. Each fighter's week total and tiredness peak. "Same as last week" and "the trainer deals it". Only changed cells lit. | The sparring pair. The seat switch after week 1. The four-seat count. Pass. | Seat: 2 or 6 mornings and $250. Coached morning: 100% or 60%. Pad place: a move's date. Senior hold: a ninth place at 0.7. Fourth evening: two places for $115. Bout: who boxes and who loses a pad place. |
| Home | A need when coach time is unplaced or a seat may move this Monday. The phone call with its answer-by day. | Nothing. | Opens the right thing; changes nothing itself. |
| Fighters cards | This week's free sessions (the shift). Who they can spar. "Not seen under the lights yet". | "6 mornings / 2 mornings": it never changes after week 1. | Nothing; it is a reading. Put the seat offer on the card. |
| Fighter page, Overview | The button to pick the pull here, and the seat offer with its price (information with no action breaks the owner's rule). How many points until the weakness is safe. | The ranges after week 1. | The pull sets the trainer's light and the review line. |
| Fighter page, Training | Light / Normal / Hard on a solo evening. The diet. | A second place to drag shared things. Lock coach, pads and sparring here with "change on Club week", or two screens will disagree. | Session kind and effort for her alone. |
| Grappler page | Who corners her open (you, her class coach, nobody). What five classes cost her (tiredness, a free evening). "Teach the beginners" beside the dial. | Two classes a week. The seat, on today's member numbers. | Classes: belt date at $34 each. Drill: next open's odds against the stripe date (this one is a real pull). |
| Fights | Counter. The favour with this matchmaker. A promise to the one left out. Ask for a bout for the other one. What happens when the opponent pulls out. | Pass as written. | Who boxes; whose goal is met; who loses the pad place; which corner is Reid's. |
| Money | What the seat has brought since it was given (bouts, wins, members), so it can be judged and moved. What the bank is saving for (the bigger unit, $12,000, as a bar). Reid against Hale in places and mornings. | The four-seat column. | Seat count: the runway. Fourth evening: -$115. |
| Week review | A button on each "it cost another" line ("give Lucy Tuesday next week"). Which alone morning was skipped. | Cost lines that read zero. | Nothing unless the lines carry buttons. |
| The Why | Whether the other corner found the weakness, and from which bout's tape. | Nothing. | Teaches; its "train it next week" button should set the pull. |

## D. What a player actually does

- **Week 1 (twenty good minutes).** Picks three, meets them, takes Ceiling for the young ones and Habit for one. Seats Lucy. Puts everyone
  on the pads once to read the true numbers. Gives the York Hall place to Samira because not boxing costs her more than losing. Deals pads
  3 / 3 / 2 with Tess holding the ninth. Slip rope for Samira. Start week.
- **Week 5 (two minutes).** The same board. Samira's defence is safe, so her pull moves to power. One fighter is in fight week and takes a pad
  place. Ana's first open is that Saturday with no show beside it, so no clash. The interest is in the bout, the plan and the corner, which
  the game already had.
- **Week 20 (one click, sometimes two).** Still Lucy's seat, still 3 / 3 / 2, the roster is full at four so nobody new can join. A pull changes
  when a number crosses a line, about once a month for each fighter. The board asks "who is in fight week?" and nothing else. With no seat
  the bank has about $20,000 and the only question it raises is the move to the bigger unit, which is the old game's question, not this design's.

## E. To reach 10/10 (most important first)

1. **The rota moves, and you see it two weeks ahead.** Tess alternates earlies and lates by the week (lates: weekday mornings free, no weekday
   evenings, so no Reid). Samira has term (Tuesday and Thursday mornings), an exam fortnight (two sessions a week) and holidays (all mornings).
   Lucy is offered overtime about one week in four and asks you (yes: she loses Saturday; no: mood -3). Club week greys "at work" cells from the
   rota; a strip "Who can come, next 3 weeks" sits under the board. A seat removes the rota for that fighter: that is what the money buys.
2. **Your own week is the currency: 8 blocks.** Replace "four mornings and two pad places". A block is one of: a coached session (covers up to
   3 boxers doing the same kind of work, bag or road or strength); pads (2 places, the only ones that fix a habit or rehearse a plan); a
   sparring trip (two boxers get a full spar at another club, favour +1 there); an evening at another club's show (favour +1 with its
   matchmaker). Shown as 8 gold blocks on Club week; Start week warns when any is unplaced. Grouping two boxers on one session against giving
   each their best one is then a pull every week.
3. **A weakness rule that reaches every fighter.** The other corner goes for your lowest number once it is 3 or more under your average, and
   gets +0.25 for each point under (Samira +1.6, Kira +1.2, Tess +1.1, Josh +0.85), from round 2, when they have tape. A plan line can cover it
   (uses one of your lines). A pull is 3 sessions a week: a seat holder carries two pulls, a day-job boxer one. Overview and Club week show
   "found by the other corner: +1.6 until defence 54".
4. **The phone is a relationship.** Three matchmakers, each with favour 0 to 5 shown as pips on Fights and on Club week. Places offered to you:
   1 at favour 0 to 1, 2 at 2 to 3, 3 at 4 to 5. Every call has Take, Counter (another opponent, a week later, or 1 kg; -1 favour; answer next
   day) and Pass (free when he has someone else, -1 when he has not, and it says which). One bout in five, the opponent pulls out in fight week:
   a replacement up to 2 kg heavier or 3 bouts more seasoned; take it (favour +2) or go home (mood -6, no ticket cut). The one left out gets a
   promise with a date; kept +5 mood, broken -10.
5. **Four seats that are four different things, and a price for none.** Lucy $250: full time. Tess $150: junior coach, holds 3 pad places a week
   at 0.7 and takes the Saturday juniors (her seat buys hands, not her training). Samira $120: a college bursary, +2 mornings, and she must
   turn up (two skipped mornings ends it). Ana $250: five classes and she teaches the beginners (saves $68). No seat for 8 weeks: Eastside
   offers your best prospect a job with mornings off; match it with a seat, a promise, or lose her. Money shows what each seat has brought
   since it was given.
6. **Make pads short.** A fight-week boxer needs both of your places (without them planned lines fire one step lower). A fourth and fifth pad
   session in a week still pay, at 0.7 and 0.5. A habit takes 6 of your places. Then nine wanted becomes twelve or more against nine, and
   "what it costs another" always has a number in it.
7. **You only know a boxer after a hard spar and a bout.** Pads close technique, speed and power. Sparring closes defence, engine and ring IQ.
   Heart and nerve close only after a first bout under you ("rises on the night +2" or "gym fighter -3"). The trainer's wrong note is about
   one fighter's night. Draw it when first seen. Who boxes first is then also "who do I need to learn about". Cards show "not seen under the lights".
8. **The corner clash with teeth.** Reid in the corner: one instruction a minute, not two, and no set-up call; a boxer with coachability under 45
   (Tess 36, Danny 34) takes half from him. Ana's open: you, or her class coach for $34 (her calls at her own belt), never Reid.
9. **Sparring as it is.** Any pair may spar. Over 5 kg it is conditioned: the lighter gets full work, the heavier gets defence only, at half.
   Over 10 kg the lighter takes +10 tiredness. The outside spar costs a block of your time, not $40.
10. **Starting focus picked after week 1, and rebalanced.** Signature: +10 mastery and the move never fades. Ceiling: +5 on the three numbers
    you choose, not all. Habit: gone in 4 weeks without using your pad places.
11. **Create shows the trio as a club.** Lines between the three picks: full spar, half spar, no spar; a pad icon on who can hold; job and free
    mornings; seat price. Write the seat lines for Kira, Danny and Josh.
12. **Board comforts that week 20 needs.** "Same as last week" and "the trainer deals it" buttons; only cells that changed since last week are
    lit; each row ends with its week total and tiredness peak; shared cells are locked on the fighter's own Training tab.
13. **Set the numbers straight before the build.** Tess against Croft is about 43%, not likely; a missed goal is -20, not -12; the first shared
    Saturday is 14 March; say whether 5.0 kg is "within 5"; say which rule wins when the lacked number is also the one the opponent's style
    makes count 1.5; grey the four-seat option with its reason.

Needs something the game cannot do yet: favour with a matchmaker (4), the rival club's approach (5) and the night trait (7) need small new
rules; none needs the full living world.

## F. The picture

`docs/mockups/s430/fourstart_10_owner.png` (1920 x 1080). The Club week board with changes 1, 2, 4, 5 and 6 on it: grey "at work" cells from a
rota that moves (Tess on lates has no pads this week), a colour edge on every session for who coaches it (you, Reid, Tess holding, alone), one
of your pad places in the hand with both fighters' change shown before letting go, the phone with favour and Counter, the trainer's three
pulls with dates, your 8 blocks, who can come for the next three weeks, and four seats at four prices.

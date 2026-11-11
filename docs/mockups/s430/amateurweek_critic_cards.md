DEPTH: 5/10

# AMATEURWEEK1 read by a card-game designer

Seat: I make roguelike deck-builders. I look for a small set of priced choices each turn, one shared purse, risk against
reward, runs that never repeat, and no pick that is always right. I read the critic pack, the access page, the design, and the
game's code where the design quotes it. I read no other opinion.

My 10/10 drawing: `docs/mockups/s430/amateurweek_10_cards.png` (page: `amateurweek_10_cards.html`).

## A. The score: 5 out of 10

Three reasons it sits at 5 and not higher or lower.

1. **It has one real purse, and that is the good part.** Reid's evenings, with the loser named ("film for Tess costs Samira
   her pads"), is exactly the kind of shared cost a good card game runs on. The bout sheet (pick one of three) is a real draft.
   Without these two it would be a 3. But the purse has no printed size (the design never says how many pad places the club
   has in a week), and three words are used for one thing (pad place, pad evening, evening).
2. **Most of the named choices turn into a look-up after three bouts.** With the design's own numbers: home beats away on every
   line, a pass is a free re-deal, the weight answer flips at exactly 0.5 kg, training weight off is free once the legs are at
   their cap, the week shape follows one flag that half the opponents do not carry, and keeping lines ready is a fixed bill.
   The sums are in part B.
3. **It gets thinner the longer you play, where a good run gets richer.** A fought opponent's file opens for good, the free
   facts from shows cover the region inside a season, the pool is four legal names a weight, the other corner never has a bad
   week, and nothing in a season builds. Fight week nine has fewer live choices than fight week two (part D). And the design
   says itself that the stakes are not measured: no one yet knows what one point of the tank buys.

I would play this happily for about five hours. Seven needs the changes in part E.

## Is what the design says about today's game true? (checked in the code)

| The design says | The code says | Where |
|---|---|---|
| Home pays a $450 ticket cut; a win brings +8 members, +5 reputation | True | `scripts/rules/BoutRules.gd` lines 89 to 91 |
| A "no camp" loss of 1.5 points and its line in the Why exist and must go | True | `BoutRules.gd` line 56, lines 199 to 201, line 282 |
| The tape needs a camp today | True: sessions count from the camp's start | `scripts/rules/OppFile.gd` lines 4 to 5, 160 to 162 |
| Stoppage ban 30 days | True | `scripts/state/Injuries.gd` line 4 |
| Five names a weight in the data | True (four to six) | `scripts/state/Data.gd` lines 163 to 181 |
| "Slow to start" and "Fades after round 2" are on the files | True, but only 7 of the 15 women listed carry one of them | `Data.gd` lines 163 to 177 |
| Heavy legs cost 1 a point over 50, at most 12 | New. Today it is 2 a point, at most 20, and only after a camp | `BoutRules.gd` lines 34 to 36, 165 to 168 |
| "RankLine shows the line; this is the rule behind it" (beat a name above, take the place) | NOT true today. The amateur table is sorted by wins minus losses, then wins, then rating. Take-the-place is the pro rule | `scripts/rules/RankLine.gd` lines 7 to 14; `scripts/state/Region.gd` line 183 |
| 9 to 11 bouts a year | The sum holds: 21 days wait + 12 or 19 days lead = 33 to 40 days a bout, 365 / 40 = 9.1, 365 / 33 = 11.1 | today: 10 days wait, `scripts/state/Bouts.gd` line 44; lead 2 to 4 weeks, `scripts/rules/AmateurBooking.gd` lines 10 to 11 |
| The opponent's tank | Always full at the bell today. The other corner has no week | `scripts/state/BoutNight.gd` line 297 |

One note for the pack, not the design: the pack says club offers come 8 to 12 weeks out; the code says 2 to 4 weeks.

## B. The hunt, with the sums

### 1. Always right: take the home bout
| | Home | Away |
|---|---|---|
| Cash | +$450 | -$40 |
| Members and reputation on a win | +8, +5 | +3, +2 |
| A close round | yours 6 in 10 | theirs 6 in 10 |

Home is better on all three lines. The gap is $490 a bout, more than a week of rent ($1,800 a month).
How big is the judging line? In the round rule each corner rolls up to 13.5 either way (`BoutRules.gd` line 61), so two even
boxers finish a round within one point about 2 times in 27, or 7 rounds in 100. Moving those from 5-in-10 to 6-in-10 lifts a
round by 0.7 in 100 and a three-round bout by about 1 win in 100. So home against away is worth about 2 wins in 100. (My
estimate, from the round rule; the watched fight may differ a little.) That is decoration beside $490.

If each of the three bouts is home half the time, a sheet holds a home bout 7 times in 8 (1 - 0.5 x 0.5 x 0.5 = 0.875). A player
who always takes it earns 36 x 0.875 x $450 = **$14,175** a year, not the design's "$8,000 with half at home". Either the
money figure is wrong or the choice is not a choice. The design needs a rule for how a sheet is built (part E, change 3).

### 2. Free: the pass
A pass costs no cash and 7 days. In those 7 days the boxer trains a full week instead of an eased one (the design's own table:
an eased week banks a fifth to a half). So a pass GIVES half a training week and a fresh sheet. The only brake, "pass the same
club twice in a row", almost never bites: three names from up to three clubs, new names every sheet. A sharp player re-deals
until the sheet shows a home bout, a name above, and a file already open.

### 3. A free roll on the ladder
Win over a name above: take the place. Lose to a name above: nothing. So a Number 6 offered the Number 1 at 20 in 100 loses
nothing on the table by trying. Nine tries a season: 1 - 0.8 to the ninth = **87 in 100** to hold the top place by the end of
the season without getting any better. The pro offer needs 7 wins and a top-three place (`scripts/state/Roster.gd` lines 30 to
31), so the top-three half of that is nearly free.

To be fair, the rest of this choice is good and should stay. At home, a hard bout at 35 in 100 is worth +2.2 members and -5.0
mood on average (0.35 x 8 - 0.65 x 1; 0.35 x 8 - 0.65 x 12); a soft one at 70 in 100 is worth +5.3 members and +2.0 mood,
and risks 0.3 x 2 = 0.6 of a place. Wins count too (9 wins at any rank also brings the pro offer). That is a real pull between
the table and the club. Cap the jump and it works.

### 4. The weight: a look-up at 0.5 kg, a dead answer, and a free ride
- Eat less: 1 off the tank for each 0.1 kg. Ask for a kilo: the opponent gets 5. So: over by 0.5 kg or less, eat (costs 5 or
  less). Over by more, ask (5 beats 6 to 10). The answer is read off the scale, not decided.
- Hold and hope: the design gives the scale no swing, and the game's forecast is exact ("61.4 now, 59.9 on the day" on today's
  bout page). When the forecast says over, holding is a certain miss. Never right.
- **The free ride.** Heavy legs stop at 12 off. Train through already costs "about 12". So a boxer who trains through can train
  any amount of weight off for nothing more. Compare for a boxer 1.0 kg over:
  rest up and eat it off = tank 90, flat in round 1, a fifth of a week banked;
  train through and sweat it off = tank 88, sharp, the whole week banked.
  Two points of tank for a sharp round and four fifths of a training week. The second is right every time.
- A missed weight costs $300 today (`BoutRules.gd` line 88). The design says "a favour is lost" and does not say whether the
  $300 stays.

### 5. The week shape: a number is missing, and one shape is squeezed out
- "Flat in round 1" has no price. Without it nobody can tell whether Rest up is ever right.
- Tick over against Train through: 4 points of tank apart, half a training week apart. Nine bouts a year is 4.5 training weeks.
  At the game's pace of 1 point a focused week that is up to 4.5 points in one stat a year. Strength on the night is the plain
  average of six stats (`BoutRules.gd` lines 184 to 186), so +0.75 on the night, for good. The pack's measure (5 points better
  wins 72 in 100) makes that about +3 wins in 100 in every later bout. The design caps the whole shape job at half of 10 to 12
  wins in 100, so 4 points of tank is worth under 2 wins in 100, once. From the second season on, anyone with room to grow
  should train through every time.
- For a boxer at the ceiling the banked week is worth nothing, so the shape is Rest up or Tick over, and that hangs on the
  missing price of flat.
- The opponent's side of the choice ("slow starter, stay sharp; fader, save the tank") exists for 7 of 15 names. For the other
  8 the shape depends only on your own boxer. So: decided once a boxer, reopened for about half the opponents.

### 6. Film: used up by the fifth fight week
- After a bout the whole file of that opponent is open and stays open (`OppFile.gd` lines 138 to 152).
- Five names a weight, one of them an open-class boxer with 14 to 18 bouts whom a novice may not meet
  (`AmateurBooking.gd` lines 12, 31 to 34): four legal names. Nine bouts a year against four names is each name twice. After
  four or five bouts every legal file in that weight is open.
- On top, the free facts: 36 club bouts a year, up to 2 facts each = up to 72 a year, against 15 names x 3 hidden facts = 45 in
  three weights.
- So the film evening, the design's best single trade, has nothing left to ask by the middle of the first season. The
  six-month stale mark brings a little back, as a re-check, not a discovery.

### 7. Keeping lines ready: a bill, not a choice
A line counts only on the night, so walking it matters only in the 14 days before a bell, less the last three. Between bouts
there is no reason to do it. For four lines that is two pad places a bout, every bout, the same. "Four lines ready OR something
new, not both" is only true in a fight fortnight, and the player will pay the two places first without thinking.

### 8. Decided once and never reopened
- Two of yours on one night: nothing is gained by it (one corner lost, one film lost), so the player never books it.
- READY / BUILDING / RESTING: the design does not say what RESTING gives that BUILDING does not. One of them is dead.
- "Reid runs this week": needed with 36 bouts a year, but the bill shows no number for what Reid's week costs against your own,
  so the player cannot tell when the click is cheap.

### 9. Numbers that are too small to matter
- The van, $40, against $14,600 start cash and $1,800 rent. Never a decision. The same for the $40 southpaw evening.
- The judging tilt, about 2 wins in 100 (above).

### 10. A word used and never defined: the favour
"When you hold a favour with that club", "a favour is lost with the host". How one is earned, how many can be held and where
they show is not in the design. It is the second currency this design is missing (part E, change 4).

### 11. Money the owner should see before the yes
Today four fighters bring 28 x $450 = $12,600 a year from bouts (the design's own figure). The design's plan brings about $8,000,
and after 18 vans, $7,380. That is $4,600 to $5,200 less a year, close to three months of rent, for more bouts. The owner has
already said the money was too harsh once (`BoutRules.gd` line 94).

### 12. Not measured
The design says it: no one knows what a point of the tank is worth. Every price on the bill (10 for a kilo, 12 for the legs, 5 for
the asked kilo) is a guess until the tank-price probe runs. The score above assumes the probe lands near the 10 to 12 wins in
100 the design aims for.

## C. Every menu in the design's table

| Menu | Missing | Useless | What each option changes |
|---|---|---|---|
| Home | A "Reid runs it" button on the row. The club's pad places for the week as one strip (spent / left). A mark when two boxers are in fight week together | Nothing | Opens the one pick; the price shown is another boxer's lost pad place |
| Fights: the bout sheet | What a pass costs. Favours held with each club. Who you would watch and who would watch you. The other boxer's tank. Whether one of yours is on that night. The ask for a kilo (it is a term of the bout, it belongs at the yes) | RESTING beside BUILDING unless they differ. The stoppage chance if all three read 3 to 5 in 100: show it only when one is twice the others | Pick: sets the date, the cash, the rank at stake, the file you start from, and closes the other two. Pass: 7 days. Switch: whether sheets come |
| Fights: the names at each weight | An action on each row. As drawn it is a table to read, and the owner's rule is that every shown thing must be something the player can act on: "Ask for this name (1 favour)", "Watch at the next show" | The "when next free" column unless you can ask for the name | Nothing today. With the ask: it starts a bout |
| Bout page: the week's bill | Reid's default week as the base line, and yours against it. The named boxer's loss in their own words ("uppercut a week later"). The opponent's tank beside yours. The home or away tilt inside the win band | The scale block when the boxer is 0.5 kg under or more: hide it | Scale answers move the tank and the miss chance; evenings move lines ready and other boxers' growth; the shape moves tank, round 1 and growth |
| Fighter page, the week board | The growth lost as a number ("-0.4 technique this week"). The injury chance of Train through. The last three days greyed on the board ("too late for lines") | Tick over, until it has a job of its own (part E, change 7) | The shape rewrites the week's sessions; the film night moves two boxers to the bag |
| Fighter card | By how much over ("1.1 kg over: a 7-day bout costs 10 tank"), and the action: start a slow cut now | The tank bar outside fight week | Nothing by itself; it should open the diet switch |
| Tape room | What each question would unlock BEFORE the pick: "you own the answer" or "no answer in the book" (a fact you cannot answer is worth nothing). A "re-check" action on a stale fact | The question about when they start slow or fade, for the 8 of 15 names that do neither | The pick opens one fact; the fact allows one plan line or sets the shape |
| Playbook, Game plan | The tick "bring this line Saturday". The mark "this corner has seen it: half". The worth of a dropped line beside the new one | Ready / 80% marks when no bout is booked | Which lines count in full on the night; which punch is finished |
| The guide | A stop: it should go quiet after the third fight week | Nothing | Nothing; it names the trade |
| Continue button | A stop when a pad evening has two claims and no pick. A stop on the last day a nearly-learnt punch can still be finished | The stop for two shows on one night, if the corner was picked at the booking | Stops the clock |
| Fight night | A last answer at the scale when the boxer is over by 0.3 kg or less (dry out: -0.3 kg, -6 tank, flat) and the ask for a favour there. Without one, "Step on the scale" is a button with no choice | The weigh-in step when the margin is safe (the design already skips it when the margin is 0.2 kg or more: good) | The corner picked decides who shouts: you, or Reid at 6 in 10 |
| Result and the Why | The same sizes for the road not taken: "Rest up would have been +12 tank". What Reid's week would have scored. A button on each line: "walk this line next week", "train X" | Nothing. The sizes are the best idea on this table | Nothing yet; with the buttons it sets next week |
| Week review (Monday) | What the places bought: "2 places on film, 1 line, 3 rounds won with it" | The running count alone: a number to read with nothing to press | Nothing; add "give Samira the place back next week" |
| Money | The season's total from shows beside last season's | The van line | Nothing |

Menus the table leaves out, and should have: World > Rankings (the ladder rule changes there); the Roster cards (the "Set camp"
corner flag goes, a "fight week" flag comes); the top-bar flags (the same); Club > People (Reid's card should carry his week of
places); the no-gi athlete's page (does the fourth fighter take any of Reid's evenings? not said); the nationals page (its camp
stays: what happens to a club bout booked inside it? not said).

## D. Fight week two against fight week nine

**Week two** (Tess, early season). Three names she has not met. Every file reads 1 of 4. The film question matters and so does
which night it takes. She owns three lines and a check hook at 21 of 30, so the pad places are fought over: finish the punch,
walk the lines, or film. Her weight on a 7-day bout is a new problem. I count five or six live choices.

**Week nine** (the same boxer, autumn). The sheet shows three of the same four legal names; she has boxed each twice. All
files are open, so the film evening has nothing to ask unless a stale mark is up. Her plan is full and the two places to keep
it ready are paid by habit. Her shape is known: she is near her ceiling, so she eases off, and for each of the four names the
player already knows which round to push. Her weight answer is known: she walks 1.1 kg over, so it is "ask for the kilo, or
eat it". What is left: the rematch rule (the winning line is worth half, so one line must change: this is good and it is the
only thing that makes the player think), which other boxer is in fight week, the 15 in 100 pull-out, and where she stands on
the table. I count two live choices, and one of them is "home or away", which part B shows is no choice.

**What makes two fight weeks differ in this design:** the name (from four to seven), home or away, the rank gap, how full the
file is, who else is in fight week, the boxer's weight and legs on the Monday, the pull-out.

**Is it enough? No.** Everything on that list is either learnt (names, files, the boxer's own weight) or small. Missing are
the three things that keep a card game fresh on the fiftieth hand:
- the other side changes too (the opponent has no week: always a full tank, never just back from a hard bout);
- the table deals you something new (the game already has a weekly twist card; the design does not say one word about what it
  does in a fight week);
- the season builds (no run of form, no stakes that rise toward the end, no prize for the table).

## E. To reach 10/10 (most important first)

1. **Print the purse: Reid's pad places.** Rule: Reid gives 3 pad evenings a week, 2 places each: 6 places a week for the whole
   club (a second club coach adds 2 evenings). One word everywhere: "pad place". Every fight-week job has a price in places:
   walk two lines 1; finish a punch 1 place for each 4.5 points still short (21 of 30 = 2 places, as the design has it); film 2
   (the whole evening); stay sharp 1 place inside the last five days; southpaw rounds 1. Screen: one strip of the places left
   to the bell, a face on each place, on the Bout page's bill, on Home and on the week board, with the count "Tess 7, Samira 3
   (-1), Jo 2 (-1)".
2. **Turn the plan into a hand.** A plan holds six lines; a bout takes the ones walked for it: "bring 4 of 6", picked against
   this opponent's file. Lines left behind run at 80%. This replaces the flat 14-day upkeep (a bill) with a pick that changes
   every bout. Add the eye: any boxer who was on the same show card as yours has seen the line that won you rounds, and it is
   worth half against that corner for their next two bouts. So a show is also "who watches me". Screens: Playbook Game plan
   (a tick on each line, an eye on a seen line), the sheet card ("Croft's corner has seen the one-two"), the bill.
3. **A sheet with no best card, and a pass with a price.** Sheet rule: at most one home bout, and it never carries the best
   rank prize; one bout is always against a name above; one is the least-known file. Before it is shown, check that no card
   beats another on all four of cash, rank, win band and file; if one does, redraw it. Pass: costs 1 favour, or is free and
   one of the three names stays on next week's sheet. Ladder: a win over a name above climbs at most 3 places (Number 6 beats
   Number 1: Number 3). State in the design that the amateur table changes from the record sort to this ladder. Screen: the
   bout sheet; World > Rankings.
4. **Favours: the second currency.** 0 to 3 held with each club, drawn as dots on every sheet card and on the club's row in
   World. Earn 1: box away at their show; take a late replacement on their card; send a boxer to fill their card. Spend 1: ask
   for a kilo; pass a sheet; ask for a named opponent (the agreed "Ask for a fight"); move a bout a week. Lose 1: miss the
   weight; go home from their show. This is what makes an away bout worth taking.
5. **The other corner has a week.** Each name on the sheet carries a tank at the bell: boxed 7 days ago -8; boxed 14 days ago
   -4; coming down a weight -6; back from a stoppage -5 and flat in round 1; fresh 0. It shows for free if one of yours shared
   a show card with them in the last 14 days, else "?". The film's third question becomes "their week" (their tank and whether
   they start slow or fade), so film has a question that is new every bout and never runs out. Screens: a tile on the sheet
   card, the two tank bars side by side on the bill, a line in the Why ("Morgan had boxed 7 days before: 8 off").
6. **Weight with a real gamble and no free ride.** One cap for the whole tank (weight and legs together, at most 22 off)
   instead of 10 and 12 apart, so training weight off always costs. The scale swings 0.2 kg either way on the day and the bill
   prints the chance ("made 3 in 4"): now Hold is a bet with odds. Eat less: 1 off for each 0.1 kg up to 0.5 kg, then 2 for
   each 0.1 kg. Ask a kilo: 1 favour, and they get 5. At the scale, over by 0.3 kg or less: "dry out" (-0.3 kg, -6 tank, flat
   in round 1). Say whether the $300 for a missed weight stays. Screens: the scale block on the bill; the weigh-in step.
7. **Three shapes, three jobs.** Print flat's price (start the probe at -2 points in round 1). Rest up: full tank, flat, +4
   mood (the game's rest week already gives it). Tick over: 8 off, and sharp only if 1 pad place is spent inside the last five
   days (ties the shape to the purse). Train through: 12 off, the whole week banked, injury chance x1.5 that week. Show the
   growth lost as a number. Screens: the week board, the legs block on the bill.
8. **A season that builds.** (a) A run: three wins in a row and the home gate is $600, and sheets carry a fourth, harder card;
   two losses in a row and sheets drop to two cards for a month. (b) The table pays: top two in the region at the season's end
   are seeded at the nationals and bring +10 members. (c) Each show night has one printed condition, drawn from six ("small
   ring", "a judge who likes body work", "late bell: bouts at 10 pm, 3 off every tank"), shown on the sheet card. (d) Six
   fight-week cards for the twist deck the game already has ("their coach asks YOU for a kilo: yes earns a favour", "the local
   paper wants a picture: +2 members, 1 pad place"). Screens: the sheet, Home, the week board's twist slot.
9. **Two on one night gets a prize.** Two of yours on one home card: gate $450 + $300, and +2 members on each win. The price is
   already there (one corner, one film). Screen: the sheet card ("Samira boxes that night").
10. **A third answer to the pull-out.** Take the replacement; go home (at home you keep half the gate, $225; away you earn the
    favour); or send another of yours who is READY and can make that weight in three days. Screen: the stop on Continue.
11. **Reid's week is the base line.** The bill prints two win bands: "Reid's week 36 to 50, your week 41 to 55". The Why prints
    what each pick moved and what the other pick would have. Then the one click is honest.
12. **Measure before the build, and publish the table.** One point of the tank = how many wins in 100; each job at most 6; the
    best week against Reid's week 4 to 6. No screen is built before this table exists.
13. **More names.** Seven a weight at least, two arriving and two leaving each season, so nine bouts are not four names twice.
14. **Keep the gate.** Decide the money on purpose: with change 3 (one home bout a sheet at most) four fighters bring about
    36 x 0.5 x $450 = $8,100; add the run bonus and the two-on-a-card prize to bring it back near today's $12,600, or tell the
    owner the cut.

# The card game - the whole scope (CARDSCOPE1, S537)

Owner S537: "it can be any variation of a card game as long it can reach 10/10". This page is the design the card game
is built from. It replaces the patch loop on `proto/cardgame` (four rounds, stuck at 4-5 out of 10). Nothing here is built
yet except the bot probe in `proto/cardscope/` (result: `docs/CARDSCOPE1_PROBE.md`).

**Status: probed, not yet passed.** 6 of 7 core fun bars pass after three runs; the card pool fails its bar
(section 6). Sections 1, 2, 4 and 5 stand as written before the probe; section 3 carries the numbers and the two rule
changes the probe forced.

Follows: `CARDPROTO3_CRITIC_SDK.md` (5/5/5: one no-read line wins 78%, Predict is a trap, five systems change nothing),
`CARDPROTO2_CRITIC_ARENA.md` (a free tell made the game one lookup: 76.7%), `JOHN_CARDGAMES_RESEARCH_JOHN.md` (take
shown tendencies, uneven rewards, open discard piles; a read needs something to read).

**The game in one line.** Every exchange is three beats. The opponent lays three cards, two face up and one face down.
You answer each beat with a card from your hand, paid in wind. You can solve what you see; you must bet on what you
cannot; and scouting, watching his patterns and wearing him down make the bet easier.

---

## 1. What makes the best ones fun

Written from play knowledge of each game, in our own words. No text or art copied.

| Game | The decision each turn | What is hidden, what is shown | How a good player beats a weak one | Comebacks and luck | What keeps you playing |
|---|---|---|---|---|---|
| Slay the Spire | Three energy, five cards: how much to defend against what is coming, how much to hit, how much to build for later. | The enemy's next move is shown with its exact number. Your draw order is hidden. | Deck building (few, fitting cards; removing weak ones), counting the draw pile, spending health as a resource. | Luck is the draw and the offers; no dice in a hit. Potions and relics save a bad fight. | A pick after every fight; the deck "comes online"; one more fight. |
| Balatro | Which five cards to play and which to throw away, with few hands and few discards. | Everything is open: you can look at the whole remaining deck. | Odds, and building a scoring engine out of jokers; money kept earns interest. | Boss rounds change one rule and break lazy builds. Scores grow by multiplying, so a build can explode late. | Poker hands everyone knows, numbers that climb, a shop after every round. |
| Inscryption | Which creature goes in which lane, and what to sacrifice to pay for it. | His next cards wait in a visible back row. | Small decks, stacking abilities on one card, sacrifice order. | The fight is a pair of scales: you win by tipping them 5, so a losing board can be turned in one turn. | Broken combinations found by the player; a map of fights and campfires. |
| Monster Train | Where to place units on three floors and in what order to cast. | Every wave is shown before it arrives. | Two clans combined, upgrades stacked on a few cards. | The last room is a final stand that can still win a lost fight. | Each run mixes two clans; upgrades are choices, not numbers. |
| Fights in Tight Spaces | Play move and attack cards on a small grid against enemies whose attacks are marked on the floor. | All enemy attacks are shown. | Positioning so that enemies hit each other; combo counter spent at the right moment. | Draw luck only. | A martial-arts fight that reads like a puzzle you solved. |
| Marvel Snap | One or two cards into three places, six turns, both sides reveal together; double the stakes if you think you are winning. | His cards are hidden until played; the places are open. | Reading his deck from the first cards, bluffing the double. | Six turns: every game is decided on the last one. | Three minutes a game; three places = three small fights. |
| Hand of Fate | The dealer lays your own cards as the adventure. | Chance cards are shuffled in front of you; a sharp eye follows them. | Choosing which risks go into your own deck. | Luck you chose yourself. | Finishing a card's story unlocks the next card. |
| Punch Club | Pick skills before the round; the round plays itself. | Nothing to read mid-round. | Grinding stats. | None the player makes. | The life outside the ring. Reviews: "the least sense of control" in the fight. |
| Yomi / Exceed / 1-2 Punch (John's memo) | Both reveal one card together. | Yomi: nothing. 1-2 Punch: discard piles are open, so you count what he still holds. | Reading a human; uneven rewards make the right pick depend on the moment. | - | Mind games with a person across the table. |

**What the good ones share (the rules this design follows):**
1. **Show the threat, hide the draw.** The best single-player card fights show what the enemy will do. The player's skill
   is the answer, not a guess. Slay the Spire's own first version hid it and its makers called that "a guessing game".
2. **Bluffing needs a person.** Yomi and Snap work because a human is across the table. Against a program a blind
   reveal is either noise (he is random) or a lookup (he is predictable). Our four rounds measured both: 14% forecast
   hits when blind, 76.7% wins from one lookup when the tell was good.
3. **Exact numbers, no dice in the hit.** A card does what it says. Luck lives in the draw and in what is face down.
4. **A scarce resource that carries over.** Energy, hands, blood. The turn is hard because you cannot do everything.
5. **Small decks you shape.** Every pick is weighed against the next opponent; removing a card is as strong as adding one.
6. **A visible tug of war.** Scales, a score to beat, three places. The player always sees how close it is.
7. **Rule twists per opponent.** Boss rounds and elite fights force a different line from the same deck.
8. **Short fights, a choice after each.** Five to eight minutes, then a pick.

---

## 2. Four forms compared (the current prototype's form gets no preference)

### Form A - the blind duel (today's prototype; Yomi-like)
*One bout:* both corners put one card face down and turn them over together, eighteen times. A table says which card
beats which. A tell chip hints at his card.
*The player decides:* one card out of five, by guessing his.
*Where skill shows:* knowing the table, following the tell.
*Risk (measured, four rounds):* with a weak tell it is a guess (forecast right 14%); with a good tell it is a lookup (76.7%
from "play the heaviest card that beats the chip"). There is no middle that stays a decision, because one piece of
information maps to one best card. The 17 by 17 table cannot be learned from play.

### Form B - the hand game (Balatro-like)
*One bout:* each round you draw eight punch cards and play up to five as a combination; "one-two", "one-two-hook",
"body-head" score like poker hands (points times a multiplier). Each round has a score to beat set by the opponent; his
style is a rule twist ("southpaw: lead-hand cards score half"). Drills level up a combination.
*The player decides:* which cards to play, which to throw away, which combination to build toward.
*Where skill shows:* odds, building a scoring engine between bouts.
*Risk:* there is no opponent to read. It is solitaire with a boxing skin: nothing he does this second changes what
you should play, which is exactly the weakness the gym game already has ("choices that do not depend on the moment are
fake"). Defence has no place in it. *Worth stealing:* combinations as named hands that drills level up.

### Form C - three places (Snap-like)
*One bout:* three judges are three places on the table: one counts punches, one counts heavy shots, one counts defence.
Each of six turns both corners put cards face down at the judges and reveal together. Win two judges to win the round.
*The player decides:* where to put strength, where to give up.
*Where skill shows:* reading where he commits, the last-turn swing.
*Risk:* face-down play against a program again (rule 2); and cards placed "at a judge" stop feeling like punches thrown at
a man. *Worth stealing:* the three judges as three visible races, each won on its own, shown before the bell.

### Form D - the exchange in three beats (shown-threat card fight; Slay the Spire and Fights in Tight Spaces-like)
*One bout:* twelve exchanges. In each, he lays three cards in order, two face up, one face down. You answer beat by beat
from a hand of five, paying wind: guard what you see, hit where he is open, and decide what to do about the face-down
card. Then the beats play out one by one and the hidden card flips.
*The player decides:* how to spend a short hand and short wind across three beats, and how much to stake on the hidden
one.
*Where skill shows:* the order of cards (a jab that lands feeds the cross), counting his discards, knowing his habits,
saving wind for the round that matters, stealing a judge at the bell.
*Risk:* the player chair is stronger than his (you see, he does not), so opponents must be better boxers on paper; if all
three cards were shown it would be a pure puzzle with no nerve in it; if none were shown it is Form A again.

### The pick: Form D, with one piece each from B and C
- Form D is the only one where **the opponent's action this second is what you answer** (the brief's "a real read of the
  opponent") while most of the decision is solvable skill (rule 1) and the rest is an honest, sized bet.
- The amount shown is a **dial**, not a guess at the right design: a novice opponent shows all three cards (the tutorial),
  a good one hides one, a champion hides two early in a round. A tired or hurt boxer cannot hide anything. The probe
  measures the dial at 0, 1, 2 and 3 cards shown; 0 shown is Form A on the same rules, so the two top forms are
  greyboxed side by side.
- From B: **named combinations** that drills level up. From C: **three judges with three tastes**, shown before the bell,
  each round won judge by judge.
- It matches the gym game: the coach reads the other boxer and answers. "The better boxer usually wins; a good plan
  gives the underdog a real chance" becomes literal: he has the better numbers, you have the eyes.

---

## 3. The chosen design

### 3.1 The exchange (the core decision)

A bout is rounds of **four exchanges** (amateur: 3 rounds = 12 exchanges; pro debut: 4 rounds). One exchange:

1. **He lays three cards**, one per beat, from his own hand and wind. Two are face up, one is face down. A beat may be
   left empty (face up or face down: an empty face-down beat is his bluff).
2. **You answer**: at most one card on each beat from your hand of five, paid in wind. A beat you leave empty gives one
   wind back (you breathe).
3. **The beats play out in order.** On each beat your card meets his. Then the face-down card flips where it stands.
4. Played cards go to the open discard piles. You keep the cards you did not play and draw back up to five.

**What meets what on a beat** (the whole table; there is no other). Numbers are the ones the probe ran:

| Your card | Against his punch | Against his guard | Against nothing |
|---|---|---|---|
| A punch | Both land. The faster one lands clean; the slower loses 2. | A block at the right height stops 4 of it (a jab is gone, a cross does 2, an uppercut still does 6 and counts). Wrong height: lands. Slipped or rolled by the right card: misses, and he counters on the next beat. | Lands clean. |
| Block (high or low, chosen as you play it) | Right height: stops 4. Wrong height: it lands. | Nothing. | Nothing. |
| Slip (beats straight punches) / Roll (beats hooks) | Right shape: it misses and your punch on the next beat is a counter (+4, lands first). Wrong shape: it lands, +2. | Nothing. | Nothing. |
| Step back | It misses. No counter, no credit from the judges. | Nothing. | Nothing. |
| Tie up (once a round) | Smothered: nothing lands, and his punch on the next beat loses 4. An uppercut still lands. | Nothing. | Nothing. |
| Feint (free) | You are hit. | He bites: his guard on the next beat does not work and your punch there does +4. | Nothing. |
| Cross counter | Against a straight punch: his misses and yours lands 6. Otherwise it is a slow cross. | As a punch. | As a punch. |
| Empty | You are hit clean. | +1 wind. | +1 wind. |

**Combinations.** A punch that lands clean makes your punch on the next beat do +2. Drilled combinations do more:
jab then cross +4, body hook then lead hook +4, jab-cross-lead hook +6 on the hook. A blocked or missed punch ends the
chain, so where he puts a guard matters as much as whether he has one.

**Why this is hard and not a lookup.** Three things pull against each other on every exchange:
- *The hand.* Five cards, and the right guard for his shown punch may not be among them. Use the slip now, or keep it
  for the cross he follows the jab with?
- *The wind.* You get 3 back an exchange; a block costs 1, a slip, roll or step back 2, a cross 2, an uppercut 3. Guarding
  both shown punches properly leaves nothing to hit with. Which shot do you take so that you can throw one?
- *The face-down card.* It can be a punch (you want a guard), a guard or a trap (your big punch is wasted or
  punished), or nothing (you wasted a card). A block is the cheap half-answer, a slip or roll the dear full answer that
  also pays a counter but only against one shape, a jab the cheap probe.

There is no accuracy roll and no damage roll anywhere. A card does what it says.
Measured: a bot that sees the cards but only chases damage wins 38.9%; one that also plays the judges, the wind and his
patterns wins 63.0%; one that could see the face-down card too would win 80.0%. So most of the skill is in the part you
can solve, and the bet on the hidden card is the rest.

### 3.2 Wind, damage, knockdowns

- **Wind** pays for cards. It tops out at 7, comes back 3 after each exchange, +1 for each beat you left empty, +2 more on
  the stool. Unspent wind is kept, so one quiet exchange buys one loud one. A body hook that lands takes 1 wind from him
  at once; every 8 body damage lowers his top wind by 1 for the rest of the bout. **A boxer on 1 wind or less cannot
  hide a card**: everything he lays is face up.
- **Head.** 112 points (105 to 122 by boxer). At 70 taken a boxer is *hurt*.
- **Knockdown.** 24 head damage in one exchange (18 when hurt) puts a boxer down: the exchange ends, the round is 10-8 on
  every card, he loses 2 wind and his next exchange is laid face up. Three knockdowns or a full head track stop the bout.
  Sized from play: a normal exchange does about 10, one in twenty does 20; the loser of a full bout takes 75 to 110.
- Measured: 10.8% of bouts stopped, none in round 1, 0.52 knockdowns a bout.

### 3.3 The judges (how close fights and comebacks happen)

Three judges sit, shown before the bell. **Every judge counts clean punches (2 points each).** Each also has one taste:
- **likes work**: half a point for every punch thrown;
- **likes hurt**: a point for every 6 damage done;
- **likes craft**: a point for each punch of his you blocked, slipped or rolled, and for each counter you landed.

Each judge gives each round 10-9 to whoever has more of his points (10-8 after a knockdown). A level round goes to
damage, then to the boxer who won the round's last exchange. A bout is never drawn. The three counts are on screen all
round as three small scales. On the last exchange of a round the player can see exactly what steals a judge.

*Changed after run 2:* the first version gave each judge one thing only (clean punches / damage / defence). The boxer who
sees always won the defence judge (30-27 in 7 bouts of 10), every judge's rounds fell the same way all night, and only
21% of bouts turned late. With a shared count and a taste on top, 31.4% of bouts are won from level or behind after
round 2, half the decisions are split, and 12.3% are one-sided.

Comebacks come from honest places, none of them a rubber band: every round is scored on its own; the knockdown line
falls for a hurt boxer, so the man behind has a live finish late; body work done early is paid late; the corner minute.

### 3.4 What the player sees of the opponent, and how reading pays

| Source | What it gives | When |
|---|---|---|
| The two face-up cards | The solvable part of the exchange. Measured: worth 44 points of win rate over seeing none. | Always (novices show all three; professionals hide two in the first two exchanges of a round). |
| His patterns | What the face-down card usually is after what he has shown: "follows the jab with the cross", "finishes with the hook", "goes to the body first". Watching him alone names the hidden card 4 times in 10 (2 in 10 without watching). | Learned exchange by exchange; the screen keeps the tally so the player does not have to. |
| His habits on film | The same patterns known before the first bell, printed on the face-down card when they apply. | Found in camp. |
| His wind | What he can afford face down. On 1 wind or less he hides nothing. | Always. |
| The corner: "Watch him" | The whole next round is laid face up. | A corner pick. |
| A knockdown | His next exchange is face up. | Earned. |
| **His read of you** | He remembers what you do on each beat and against the face-down card, and answers it. A chip shows what his corner has noticed. Measured: a player who always blocks high on the hidden card loses 7 more points to an opponent who adapts. | Grows with his class; novices do not adapt. |
| His discard pile | Open, as a reminder of what he has thrown. **Not a skill:** counting it was worth nothing in the probe, so the game does the count and prints it. | Always. |

### 3.5 The cards

Thirteen cards went into the probe. The last column is what the probe said about each.

| Card | Wind | Does | Its job | Probe |
|---|---|---|---|---|
| Jab | 1 | 2 head, fast, straight | Opens a combination, beats slower punches to the mark, cheap probe at the hidden beat. | Works: most played (24%), good against two styles, poor against two. |
| Body jab | 1 | 2 body, fast, straight | Goes under a high guard; starts a chain cheaply. | Works: best pick against the pressure fighter, middling elsewhere. |
| Cross | 2 | 6 head, straight | The money end of the one-two. | Played a lot (16%) but more copies never help: the starting deck has enough. |
| Lead hook | 2 | 6 head, hook | Punishes a slip; ends the 1-2-3. | Same as the cross. |
| Body hook | 2 | 4 body, hook, takes 1 wind | The investment: his wind, then his secrets. | Weak: three rounds are too short for the investment to pay. Needs the longer pro bouts or a bigger wind bite. |
| Uppercut | 3 | 10 head, slow | Splits a block, catches a slip, a roll or a tie-up. | Weak: opponents rarely guard, so there is little to split. |
| Cross counter | 3 | Beats a straight for 6 | The read made into a card. | **Too strong**: the best pick against three of four styles even after its price went from 2 to 3. |
| Block | 1 | High or low, stops 4 | The cheap half-answer to anything. | Works: top-five pick everywhere, never the best. |
| Slip | 2 | Straight misses, counter next beat | The full answer to a known straight. | Works as designed: +23 points against the out-boxer, -18 against the pressure fighter. |
| Roll | 2 | Hook misses, counter next beat | The full answer to a known hook. | Best against the pressure fighter, as designed, but weaker than the slip. |
| Step back | 2 | Everything misses | Safe against the unknown, earns nothing. | Middling to poor. |
| Tie up | 1 | Smothers this beat and softens his next | Survival when hurt; once a round. | **Too strong**: second-best pick against every style. |
| Feint | 0 | Takes away his next guard, +4 | Turns a shown guard into an opening. | **Dead**: worst pick against every style; he seldom guards. |

Sharp and Signature versions (from drilling) change one thing each; sized in the build phases, not in this probe.

### 3.6 The corner minute

Between rounds pick one of three (a better coach offers a fourth):
- **Water** - full wind, and 1 more wind back per exchange for the round.
- **Ice** - 20 head damage back.
- **Watch him** - the whole next round is laid face up.

Measured: always taking the same one costs 1 to 7 points against choosing by the state of the fight, but a random pick is
only 1.6 behind the informed one. The corner is not yet the decision it must be (bar B17 failed); phase 5 owns it.

### 3.6b The opponent on paper

He lays blind and you answer seeing two cards, so at equal numbers the seeing boxer wins nearly every bout (run 1:
99.9%). The opponent is therefore **the better boxer on paper**: more wind (top and back per exchange) and heavier
hands, in steps, each opponent boxer with his own step. That is the gym game's own rule ("the better-trained boxer
usually wins; a good plan gives the underdog a real chance") turned into the card game's difficulty. Measured by class,
the reader's win rate: novice 97.5%, open class 76.9%, regional 64.1%, title 44.2%, professional 27.0%.
A boxer who lays blind gets little from guards, so opponents' decks are punches and traps; their defence is their
numbers. A cautious opponent style has to be built from fast punches and counters, not from blocks.

### 3.7 How FightCamp feeds the deck (the link to the gym game)

| In the gym game | In the card bout |
|---|---|
| A move at Usable (30) | One copy of its card in the fight deck. |
| A move at Sharp (60) / Signature (85) | The Sharp / Signature version of the card. |
| A combination drilled on the pads | That named combination's bonus, one step per tier. |
| Style | The starting mix (out-boxer: jabs, step back; pressure: body hooks, tie up; counter-puncher: slip, roll, cross counter; volume: many cheap punches) and which judge suits her. |
| Conditioning | Top wind and wind back per exchange. |
| Chin (Durability) | Head points and the knockdown line. |
| Power | Heavier cross, hooks and uppercut (half as much on the jabs). |
| Hand speed | Wins trades between punches of the same speed. |
| Technique | Hand size (5, 6 at 70). |
| Defence | A block stops 6, not 4. |
| Ring IQ | The first exchange of every round is laid face up for her. |
| Heart | Loses 1 wind, not 2, when knocked down. |
| Camp focus and intensity | The camp stat for this bout; a peak camp starts round 1 with a full hand of chosen cards. |
| Tape study in camp | Habits found: printed on the face-down card when they apply (worth too little in the probe: phase 3). |
| The game plan (lines) | Each plan line names one card that is always in the opening hand of a round. |
| Outside sparring partner of his style | His first exchange of the bout is laid face up. |
| The coach | How many corner cards are offered, and how many plan lines. |
| Perks | A standing rule each, e.g. Stiff jab: the jab never loses a trade; Body snatcher: body hooks take 2 wind; Iron chin: knockdown line +1; Second wind: once a bout, full wind on the stool. |
| Morale | Fired up: +1 wind at the first bell. Low: one card fewer in hand. |
| After the bout | Head and body totals feed the injury roll; the Why lists the reads that paid and the ones that cost. |

### 3.8 The run (the ladder)

Standing alone, the card game is one boxer's road from novice to her professional debut: **eight bouts**, one deck carried.
- **The ladder:** two novice bouts (he shows all three cards), two open-class bouts (he hides one, adapts a little), two
  regional bouts (hides one, adapts), a title bout, the pro debut over four rounds (hides two early in a round). Each has
  three judges drawn from five tastes and an opponent with a style, two habits and one best weapon.
- **Between bouts, one of:** *drill* (pick 1 of 3: a new card, a Sharp version, a combination step), *drop a habit*
  (remove a card), *film* (find one habit of the next opponent), or *rest* (head damage carried from the last bout is
  healed; unhealed damage is carried in). One only: a war costs the next camp.
- **What grows:** the deck (12 to about 16), card versions, combinations, a perk after bouts 2, 4 and 6, what you know of
  the next opponent.
- **What is lost:** head points carried into the next bout; a stoppage loss costs the next camp pick (suspension); the
  third loss ends the run.
- Inside FightCamp the same ladder is simply the career: the weeks are the picks.

---

## 4. Fun as numbers (written before the probe; each one a bar)

Population: four player boxers and four opponent boxers from other clubs, one of each style, all different in cards and
numbers; never the same boxer on both sides. Unless a bar says otherwise the opponent is the "regional" class (hides
one card, adapts, two habits) and bots sit in the player's chair. The bots: **random** (any legal answer), **fixed line**
(the best of all fixed three-card patterns, found by search), **greedy** (most damage this exchange, sees the face-up
cards, no counting, no judges, no wind plan), **reader** (public information only: counts his cards, learns his patterns,
plays the judges and the wind), **all-seeing** (the reader with the hidden card shown: the ceiling, not a legal player).

Core bars (the task's list):

| # | Bar | Pass when |
|---|---|---|
| B1 | Reading beats a fixed line | reader wins 15+ points more than the best fixed line |
| B2 | Thinking beats not thinking | reader wins 30+ points more than random |
| B3 | No line that needs no reading | the best fixed line stays under 45% and no fixed line is within 10 points of the reader |
| B4 | Close fights | one-sided bouts (every judge gives every round to one boxer, or a stoppage before the last round) are under 35% |
| B5 | Decided late | in 30%+ of bouts the winner was level or behind on the cards after round 2 of 3 |
| B6 | Every card has a matchup | each card is a top-four pick against at least one opponent style and a bottom-half pick against another |
| B7 | The run has choices | in an 8-bout ladder 3+ offers per run have 4+ points between the best and worst card, and informed picks win more bouts than random picks |

Supporting bars:

| # | Bar | Pass when |
|---|---|---|
| B8 | A ladder of skill | random < fixed < greedy < reader < all-seeing, and reader beats greedy by 8+ |
| B9 | The hidden card is a bet, not the game | all-seeing beats the reader by 5 to 20 points |
| B10 | Showing beats guessing | the reader's lead over random with two cards shown is 10+ points bigger than with none shown (Form A) |
| B11 | Stoppages | 10 to 25% of bouts; 0.3 to 1.0 knockdowns a bout; under 3% stopped in round 1 |
| B12 | No blanks | exchanges where no punch lands under 15%; beats where nothing happens under 25% |
| B13 | No dead card, no card for everything | each card is 3%+ of the reader's plays where it is in the deck; none over 30% |
| B14 | Split cards | 15%+ of points decisions are split (2-1) |
| B15 | Film and counting pay | knowing his two habits before the bell is worth 4+ points; counting his discards 3+ |
| B16 | He reads you back | the best fixed line loses 8+ points against the adapting opponent compared with one who does not adapt |
| B17 | The corner is a decision | an informed corner pick beats a random one by 3+ points; each corner card is the informed pick 15%+ of the time |
| B18 | Styles | every player style against every opponent style wins between 40% and 90% for the reader |

Verdict rule: PASS = every core bar passes. Supporting bars that fail are named with their cause and go into the build
phases as that phase's bar.

---

## 5. Keep and throw away from `proto/cardgame`

**Keep**
- The boxing words and card names; lines written from what actually happened (never "slips the hook" when it landed).
- Seeded bouts (same seed, same bout) and the rule "the page plays exactly what the harness tests".
- A harness that fails the run when a bar is missed. It measured honestly; that is how we know the form is wrong.
- The open discard pile and "the odds climb as his cards run out" (it becomes the main read).
- Head and body kept apart, with the body taking wind.
- Judges with tastes and no drawn bouts (now three judges whose tastes are the three ways to win a round).
- House rules: opponents from other clubs, women box women, names only in headers.

**Throw away**
- **The blind one-card reveal.** Four rounds proved it is a guess or a lookup.
- **The 17 by 17 table and 34 named exceptions.** Nobody learns 289 cells from play. The new table is section 3.1.
- **React / Predict and the tell chip.** Predict never raised a win rate in any arm; the chip was the lookup.
- **Accuracy and damage rolls.** Surprise came from dice, not from the other corner.
- **The range track, the trap and the ropes.** Four rounds of work for 3.7% of exchanges.
- **The referee ladder and the "dead exchange" rules.** Patches for problems the new form does not have.
- **Combinations as a stack of cards against one card.** That was the 78% shield line. A combination is now three beats
  that each meet his card.
- **Camp as stat nudges of 4 or 5** (inside the noise) and **corner cards that swap small numbers** (every one within 2
  points of a random pick).
- **Catch breath, Pivot out, Cut off, Check hook, Pull counter** as cards.
- The code itself is not carried over: new rules, new module. The test habits are.

---

## 6. Probe result (full table: `docs/CARDSCOPE1_PROBE.md`)

**Verdict: FAIL on one core bar. 6 of 7 core bars pass, 6 of 11 supporting bars pass.** Three measured runs, as the
brief allows: the design as first written, one resize, one design change. No fourth run was made.

| Run | What changed | Core | What it showed |
|---|---|---|---|
| 1 | Nothing (numbers set on paper) | 3 of 7 | The seeing chair wins everything: reader 99.9%, 92% of bouts stopped, 2.4 knockdowns a bout. |
| 2 | Resize only: damage doubled for finer steps, a block stops 4 instead of nearly all, slip/roll/step back cost 2, knockdown line and head points sized from measured damage, the opponent better on paper | 5 of 7 | Reader 66.8%, stoppages 10.3%. Still failing: decided late 21.4% (judges locked), cards without matchups, styles a lottery (6.8% to 100%). |
| 3 | Design change: judges share a count and add a taste (3.3); each opponent boxer sized on his own and rebuilt from punches and traps (3.6b); cross counter dearer; corner cards stronger | 6 of 7 | Decided late 31.4%, one-sided 12.3%, split decisions 49.9%, informed deck picks +18 points over random picks. **Fails B6.** |

**What passed and matters most:** reading beats any fixed line by 63 points (no fixed line wins at all); thinking beats
damage-chasing by 24; the hidden card is part of the skill, not all of it (+17 for seeing it); showing two cards beats
showing none (Form A on the same rules: the best legal bot wins 11%); close fights; late turns; honest stoppage rates;
almost no blank exchanges; an 8-bout run where the pick before each bout is worth 2 more wins a run.

**What failed, and the cause in the design:**
- **B6, every card has a matchup (core).** Three cards break it: Cross counter and Tie up are right against everybody,
  Feint is wrong against everybody; and more copies of the plain power punches never help. Cause: in the design change
  the opponents became punch-heavy (a blind boxer gets nothing from guards), so cards that beat guards have nothing to
  beat and cards that stop punches are always wanted. The matchups that do exist are large (Slip is +23 against one
  style and -18 against another), so the card pool needs re-cutting, not the exchange. Owned by phase 4.
- **B15, film and counting.** Knowing his habits before the bell is worth 1.7 points, watching his patterns 1.3,
  counting nothing. Cause: against the hidden card the safe answers (block, jab) are nearly as good whatever the odds,
  so better odds change few answers. The read is real (the all-seeing bot is 17 up) but knowledge does not yet buy
  enough of it. Owned by phase 3: a known habit must flip the card outright when it applies, and a trap must punish the
  safe answer.
- **B16, he reads you back.** 7.1 points against a one-note player (bar 8); fixed lines cannot show it because they win
  nothing either way. Near miss; phase 3.
- **B17, the corner.** Informed pick only 1.6 over a random pick. Phase 5.
- **B18, styles.** 28% to 100% by pair (bar 40 to 90). The out-boxer's quick hands erase the volume puncher; the
  counter-puncher's deck has no answer to body work. Content sizing, phase 3.
- **B8** fails only on "random below fixed": both win nothing (0.0%). The part that matters (reader 24 over greedy) passes.

**The floor is too hard:** a random or fixed-line player wins no bouts at regional class. That is right for the bars and
wrong for a first hour. The ladder starts at novice class (everything face up, reader 97.5%) for that reason; phase 2
must check a human beginner there.

**Honest limits:** bots, not people. Nothing here says a person enjoys it; phase 2 exists to find that out early.
Sizing between runs used its own seeds (300000 and up) and looked at win rate, stoppages, one-sided and late shares;
the bar tables ran on other seeds. The bars in section 4 were committed before the first run and were not edited.

## 7. Open decisions for the owner (taste and scope only)

1. **Where it lives.** The page describes a card game that can stand alone (the 8-bout run) and can also be fight night
   inside FightCamp (3.7). Phases 1 to 6 build it standing alone in the browser, as the prototype was; phase 8 is the
   link. Whether it replaces the 30-second-call fight night or sits beside it is his call after he has played phase 2.
2. **He is better on paper.** The player is the underdog with the better eyes in every bout past novice class. If that
   reads as unfair at the table, the alternative is to take turns leading (he answers your three cards every second
   exchange); it costs a second rule set and was not probed.

## 8. The build plan (one job a phase; each ends on its test and its fun bar)

| Phase | Builds | Test | Fun bar to pass before the next phase |
|---|---|---|---|
| 1. The rules module | `proto/cardbout/rules`: the exchange, wind, knockdowns, judges, the bout, seeded; ported from `proto/cardscope` (rules.mjs, bout.mjs) with its 32 checks | `node proto/cardbout/rules.test.mjs` | B1 to B5, B9 to B12, B14 re-measured on the new module, same numbers as run 3 |
| 2. The table | One page: his three slots, your hand, wind, the three judges' scales, beat-by-beat reveal with one true line per beat, the flip of the hidden card; novice and regional opponent | a page test that plays a seeded bout through the page's own calls | The owner plays 3 bouts. A bout takes 5 to 8 minutes; he can say after each exchange why he won or lost it |
| 3. The opponents | 8 boxers (two a style) each with a weapon, two habits, own paper; a known habit flips the hidden card; his corner's read shown as a chip; a trap card that punishes the safe answer | harness block "opponents" | B18 (every pair 40 to 90%), B15 (habits known 4+), B16 (8+) |
| 4. The card pool | Re-cut from the probe: Cross counter beats the cross only; Tie up costs 2; Feint reworked or cut; Uppercut and Body hook given their targets; Sharp and Signature versions; named combinations as drills | harness block "cards" (the card table of the probe) | **B6** (every card top-four somewhere and bottom-half somewhere), B13 |
| 5. The corner and film | Corner cards as orders for the round (three now, five with plan cards); film in camp | harness block "corner" | B17 (informed 3+ over random, each card 15%+ of picks) |
| 6. The run | The 8-bout ladder: drill / drop / film / rest, perks, damage carried, three losses | harness block "run" | B7 on the real run; a good bot finishes 30 to 50% of runs; a run takes 40 to 60 minutes |
| 7. Words and feel | Varied true lines, timing of the reveal, the sound of the flip | line test: no line contradicts its beat | The owner plays a full run |
| 8. The link | A deck built from a Career boxer (3.7), result written back (damage, the Why) | adapter test with a golden boxer | His call (decision 1) |

No phase starts before the one above it has passed its bar. The card-pool changes named in phase 4 are proposals from
the probe's table, not measured. Two fresh critics score this page first (`CARDSCOPE1_CRITIC_KALLI.md` is queued; the
second is a later SDK job).

# The card game - the whole scope (CARDSCOPE1, S537)

Owner S537: "it can be any variation of a card game as long it can reach 10/10". This page is the design the card game
is built from. It replaces the patch loop on `proto/cardgame` (four rounds, stuck at 4-5 out of 10). Nothing here is built
yet except the bot probe in `proto/cardscope/` (result: `docs/CARDSCOPE1_PROBE.md`).

Follows: `CARDPROTO3_CRITIC_SDK.md` (5/5/5: one no-read line wins 78%, Predict is a trap, five systems change nothing),
`CARDPROTO2_CRITIC_ARENA.md` (a free tell made the game one lookup: 76.7%), `JOHN_CARDGAMES_RESEARCH_JOHN.md` (take
shown tendencies, uneven rewards, open discard piles; a read needs something to read).

**The game in one line.** Every exchange is three beats. The opponent lays three cards, two face up and one face down.
You answer each beat with a card from your hand, paid in wind. You can solve what you see; you must bet on what you
cannot; and scouting, counting his cards and wearing him down make the bet easier.

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

**What meets what on a beat** (the whole table; there is no other):

| Your card | Against his punch | Against his guard | Against nothing |
|---|---|---|---|
| A punch | Both land. The faster one lands clean; the slower loses 2. | Blocked at the right height: 1 or 0 gets through, no score. Wrong height: lands. Slipped or rolled by the right card: misses, and he counters on the next beat. | Lands clean. |
| Block (high or low, chosen as you play it) | Right height: 1 or 0 gets through. Wrong height: it lands. An uppercut splits a block: half lands. | Nothing. | Nothing. |
| Slip (beats straight punches) / Roll (beats hooks) | Right shape: it misses and your punch on the next beat is a counter (+2, lands first). Wrong shape: it lands, +1. | Nothing. | Nothing. |
| Step back | It misses. No counter, no credit from the judges. | Nothing. | Nothing. |
| Tie up (once a round) | Smothered: nothing lands, and his punch on the next beat loses 2. An uppercut still lands. | Nothing. | Nothing. |
| Feint (free) | You are hit. | He bites: his guard on the next beat does not work and your punch there does +2. | Nothing. |
| Cross counter | Against a straight punch: his misses and yours lands 4. Otherwise it is a slow cross. | As a punch. | As a punch. |
| Empty | You are hit clean. | +1 wind. | +1 wind. |

**Combinations.** A punch that lands clean makes your punch on the next beat do +1. Drilled combinations do more:
jab then cross +2, body hook then lead hook +2, jab-cross-lead hook +3 on the hook. A blocked or missed punch ends the
chain, so where he puts a guard matters as much as whether he has one.

**Why this is hard and not a lookup.** Three things pull against each other on every exchange:
- *The hand.* Five cards, and the right guard for his shown punch may not be among them. Use the slip now, or keep it
  for the cross you know he still holds?
- *The wind.* Three cards cost about four wind and you get three back. Guarding both shown punches leaves one punch of
  your own. Leaving a beat empty buys wind for the next exchange. Body punches take his wind away.
- *The face-down card.* It can be a punch (you want a guard), a guard or a counter (your big punch is wasted or
  punished), or nothing (you wasted a card). A block is the cheap half-answer, a slip or roll is the full answer that
  also pays a counter but only against one shape, a jab is the cheap probe, a feint in front takes his guard away.
  Which is right depends on what he still holds, what he did the last three times, and what the judges need.
There is no accuracy roll and no damage roll anywhere. A card does what it says.

### 3.2 Wind, damage, knockdowns

- **Wind** pays for cards. It tops out at 7, comes back 3 after each exchange, +1 for each beat you left empty, +2 more on
  the stool. Unspent wind is kept, so one quiet exchange buys one loud one. A body hook that lands takes 1 wind from him
  at once; every 4 body damage lowers his top wind by 1 for the rest of the bout. **A boxer on 1 wind or less cannot
  hide a card**: everything he lays is face up.
- **Head.** 32 points. At 20 taken a boxer is *hurt*.
- **Knockdown.** 8 head damage in one exchange (6 when hurt) puts a boxer down: the exchange ends, the round is 10-8 on
  every card, he loses 2 wind and his next exchange is laid face up. Three knockdowns or 32 head damage stop the bout.
- So the body is the early investment (his wind, then his cards, then his secrets) and the head is the late finish
  (hurt lowers the knockdown line just when wind runs short).

### 3.3 The judges (how close fights and comebacks happen)

Three judges sit, each with one taste, shown before the bell:
- **The counter** scores clean punches landed, one each.
- **The puncher's judge** scores damage done.
- **The purist** scores defence: each punch of his you blocked, slipped or rolled, and each counter you landed.

Each judge gives each round 10-9 to whoever led his own count (10-8 after a knockdown). A judge's level round goes to
damage, then clean punches, then the boxer who won the round's last exchange. A bout is never drawn.
The three counts are on screen all round as three small scales. On the last exchange of a round the player can see
exactly what steals a judge ("one clean punch takes the counter").

Comebacks come from four honest places, none of them a rubber band:
1. Every round is scored on its own: a round lost badly costs the same as a round lost by one punch.
2. The knockdown line falls for a hurt boxer, so the man behind on the cards has a live finish late.
3. Body work done in round 1 is paid in round 3.
4. The corner minute (3.6) lets the man behind fix what is losing the fight.

### 3.4 What the player sees of the opponent, and how reading pays

| Source | What it gives | When |
|---|---|---|
| The two face-up cards | Solvable part of the exchange. | Always (novices show all three; champions hide two in the first two exchanges of a round). |
| His discard pile and his card list | What the face-down card can still be: "both crosses are gone this round". | Always open; the list comes from the file. |
| His wind | What he can afford face down. On 1 wind or less he hides nothing. | Always. |
| His habits (film) | A habit is a fixed pattern, e.g. "follows the jab with the cross", "finishes with the hook", "covers up after a big shot". A habit found on film is printed on the face-down card when it applies ("film: the cross, most times"). | Found in camp, or learned by watching him during the bout. |
| The corner: "Watch him" | His first two exchanges of the next round are laid face up. | A corner pick. |
| A knockdown | His next exchange is face up. | Earned. |
| **His read of you** | He remembers what you do on each beat and against the face-down card, and answers it: block high on the hidden card every time and it becomes a body shot; throw the cross into it every time and it becomes a slip. A chip shows what his corner has noticed. | Grows with his class; novices do not adapt. |

Reading pays in three sizes: counting (free, always), habits (bought with camp time), nerve (mixing your own answers so
he cannot read you).

### 3.5 The cards

Thirteen cards. Each has one job; a card with no job is not in the game.

| Card | Wind | Does | Its job / when it is the wrong card |
|---|---|---|---|
| Jab | 1 | 1 head, fast, straight | Opens a combination, beats slower punches to the mark, cheap probe at the hidden beat. Wrong against a slip. |
| Body jab | 1 | 1 body, fast, straight | Goes under a high guard; starts a chain cheaply. Wrong against a low block. |
| Cross | 2 | 3 head, straight | The money end of the one-two. Wrong against a slip or a cross counter. |
| Lead hook | 2 | 3 head, hook | Punishes a slip; ends the 1-2-3. Wrong against a roll. |
| Body hook | 2 | 2 body, hook, takes 1 wind | The investment: his wind, then his secrets. Wrong when the bout is short or he rolls. |
| Uppercut | 3 | 5 head, slow | Splits a block, catches a slip, a roll or a tie-up. Wrong in a trade (slow: loses 2) and dear. |
| Cross counter | 2 | Beats a straight for 4 | The read made into a card. A slow cross when the read is wrong. |
| Block | 1 | High or low | The half-answer to anything: cheap, never pays a counter, split by the uppercut. |
| Slip | 1 | Straight misses, counter next beat | The full answer to a known straight. Walks into a hook. |
| Roll | 1 | Hook misses, counter next beat | The full answer to a known hook. Caught by straights and the uppercut. |
| Step back | 1 | Everything misses | Safe against the unknown, earns nothing. |
| Tie up | 1 | Smothers this beat and softens his next | Survival when hurt; once a round. Caught by the uppercut. |
| Feint | 0 | Takes away his next guard, +2 | Turns a shown guard into an opening. Wrong against a punch. |

Sharp and Signature versions (from drilling) change one thing each: e.g. Sharp jab lands first against anything,
Sharp block lets nothing through, Signature cross +1. Sized in the build phases, not in this probe.

**Cut because it changed nothing or could not be learned** (blunt list in section 5): the 17 by 17 table and its 34 named
exceptions, React/Predict, the tell chip, accuracy rolls, the range track with trap and ropes, the referee ladder, Catch
breath as a card (an empty beat does it), Pivot out, Cut off, Check hook and Pull counter as separate cards.

### 3.6 The corner minute

Between rounds pick one of three (a better coach offers a fourth):
- **Water** - 3 more wind.
- **Ice** - 4 head damage back.
- **Watch him** - his first two exchanges next round are face up.
Later phases add plan cards (swap two cards between deck and bench; name the judge to chase). Each corner card must beat
a random pick in its own situation or it is cut.

### 3.7 How FightCamp feeds the deck (the link to the gym game)

| In the gym game | In the card bout |
|---|---|
| A move at Usable (30) | One copy of its card in the fight deck. |
| A move at Sharp (60) / Signature (85) | The Sharp / Signature version of the card. |
| A combination drilled on the pads | That named combination's bonus, one step per tier. |
| Style | The starting mix (out-boxer: jabs, step back; pressure: body hooks, tie up; counter-puncher: slip, roll, cross counter; volume: many cheap punches) and which judge suits her. |
| Conditioning | Top wind and wind back per exchange. |
| Chin (Durability) | Head points and the knockdown line. |
| Power | +1 on cross, hooks and uppercut at 70. |
| Hand speed | Wins trades between punches of the same speed. |
| Technique | Hand size (5, 6 at 70). |
| Defence | A blocked punch lets nothing through. |
| Ring IQ | The first exchange of every round is laid face up for her. |
| Heart | Loses 1 wind, not 2, when knocked down. |
| Camp focus and intensity | The camp stat for this bout; a peak camp starts round 1 with a full hand of chosen cards. |
| Tape study in camp | Habits found: printed on the face-down card when they apply. |
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

## 6. Probe result and the build plan

Filled in after the probe: see the end of this page.

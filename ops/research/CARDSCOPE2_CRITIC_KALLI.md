# Critic brief: the card game, scope round 2 (CARDSCOPE2, S537) - you are a FRESH critic

You judge a DESIGN, not a build: the scope page for a card game in which a boxing bout is fought with cards, inside (or
beside) our boxing gym management game. Only a bot greybox exists (rules and bots, no page); nobody has played it.
Read the whole game first (PART 3, the critic pack: facts only), then the scope page (PART 1), then the bot probe's
table (PART 2). Text marked [R2] on the scope page is new in this round. Be blunt; a kind score is useless.

Score, each out of 10, with the reasons:
1. DEPTH - real, repeated decisions with trade-offs; a real read of the opponent; skill beats luck; no dominant card or
   line; it connects to the rest of the gym game.
2. PLAY - would this be fun to play for an evening: tension, surprise, agency, pace, comebacks, a reason to start another
   bout and another run.
3. GENERAL - clear, consistent with the game's words and rules, buildable, nothing useless.
The bar (owner S534): 8+ on DEPTH and 8+ on PLAY, or it does not go on.

Also answer, each in a few lines:
- Which cards or options are missing, which are useless, and what each one changes (owner S403).
- The lead now changes hands every exchange and both boxers are equal on paper. The boxer who answers wins the exchange
  more often than not. Is "two exchanges hunted, two hunting" a good rhythm, or should the leader get something more?
- A rule-of-thumb beginner (guard what you see, block the hidden card) still loses almost every bout from regional class
  up, while a player who lets the table do the sums gets about half way to the best bot. Is the table of section 3.9
  enough, or must the rules themselves make "guard what you see" a sound line? How?
- The bars that still fail (PART 2 names each with its cause). For each: is the page's answer right, and what would you
  do instead? The page's answers are proposals, not measured.
- Body work turned out to be the strongest plan once wind was equal. Is that good boxing or a new dominant line?

End with **To reach 10/10**: the concrete changes that would take it to 10, most important first, each specific enough
to build (owner S405). Then describe your 10/10 table for one exchange where YOU lead as a 1920x1080 page (an HTML file
is welcome) (owner S411).
Plain words; names only in headers (the body says "your boxer", "the opponent").

---

# PART 1 - the scope page

# The card game - the whole scope (CARDSCOPE1 and CARDSCOPE2, S537)

Owner S537: "it can be any variation of a card game as long it can reach 10/10". This page is the design the card game
is built from. It replaces the patch loop on `proto/cardgame` (four rounds, stuck at 4-5 out of 10). Nothing here is built
yet except the bot probe in `proto/cardscope/` (result: `docs/CARDSCOPE1_PROBE.md`).

**Status: probed twice, not yet passed.** Round 1 (he always led, better on paper): 6 of 7 core bars, critic 6 / 5 / 6.
Round 2 (the lead changes hands, equal paper, a trap card, habits that rule the hidden card, deck limits): the fight
itself now stands on equal paper (reader 58% at regional, level damage, a real mix face down, traps on 38% of your
leads), but the round fails 8 of its 12 new bars in the final run. Section 6b says which and why; the build plan
(section 8) now starts with a phase 0 for them.

**How to read the round 2 marks.** Text marked **[R2]** was changed or added in round 2 (CARDSCOPE2), after the fresh
critic's 6 / 5 / 6 (`CARDSCOPE1_CRITIC_SDK.md`); each mark says why. Unmarked text stands from round 1. Round 1's
result is kept in section 6, round 2's in section 6b.

Follows: `CARDPROTO3_CRITIC_SDK.md` (5/5/5: one no-read line wins 78%, Predict is a trap, five systems change nothing),
`CARDPROTO2_CRITIC_ARENA.md` (a free tell made the game one lookup: 76.7%), `JOHN_CARDGAMES_RESEARCH_JOHN.md` (take
shown tendencies, uneven rewards, open discard piles; a read needs something to read).

**The game in one line. [R2]** Every exchange is three beats, and the lead changes hands every exchange. The boxer who
leads lays three cards, two face up and one face down; the other answers each beat with a card from his hand, paid in
wind. When he leads you solve what you see and bet on what you cannot. When you lead you choose what he may see and what
trap lies face down. Both boxers have the same wind and the same hands on paper.
*(Round 1: he always led and was the better boxer on paper. Changed because the critic showed that one patch was the root
of most faults: he never tired, he was all punches, you only ever answered.)*

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

0. **[R2] The lead changes hands.** You lead exchanges 1 and 3 of a round, he leads 2 and 4, so you have the last
   answer before the bell. The rules below are the same whoever leads.
1. **The leader lays three cards**, one per beat, from his own hand and wind. Two are face up, one is face down, and the
   leader chooses which. A beat may be left empty (face up or face down: an empty face-down beat is a bluff).
2. **The other boxer answers**: at most one card on each beat from his hand of five, paid in wind. A beat left empty
   gives one wind back (a breath).
3. **The beats play out in order.** On each beat the two cards meet. Then the face-down card flips where it stands.
4. Played cards go to the open discard piles. Both keep the cards they did not play and draw back up to five.

**[R2] What leading is for.** The answering boxer sees two of three cards, so he wins the exchange more often than not
(measured in sizing: about 8 damage for 4 when answering, about 7 for 10 when leading, the same for both corners). A round
is therefore two exchanges where you are hunted and two where you hunt. On your lead the questions are: what do I show
that he cannot punish cheaply, what do I lay face down (a punch he walks onto, a slip that turns his answer into my
counter, the check hook behind a shown jab, nothing at all to save wind), and how much wind do I keep for my answer.

**What meets what on a beat** (the whole table; there is no other). Numbers are the ones the probe ran:

| Your card | Against his punch | Against his guard | Against nothing |
|---|---|---|---|
| A punch | Both land. The faster one lands clean; the slower loses 2. | A block at the right height stops 4 of it (a jab is gone, a cross does 2, an uppercut still does 6 and counts). Wrong height: lands. Slipped or rolled by the right card: misses, and he counters on the next beat. | Lands clean. |
| Block (high or low, chosen as you play it) | Right height: stops 4. Wrong height: it lands. | Nothing. | Nothing. |
| Slip (beats straight punches) / Roll (beats hooks) | Right shape: it misses and your punch on the next beat is a counter (+4, lands first). Wrong shape: it lands, +2. | Nothing. | Nothing. |
| Step back | It misses. No counter, no credit from the judges. | Nothing. | Nothing. |
| Tie up (once a round; **[R2]** costs 2, was 1) | Smothered: nothing lands, and his punch on the next beat loses 4. An uppercut still lands. | Nothing. | Nothing. |
| Feint (free) | You are hit. | He bites: his guard on the next beat does not work and your punch there does +4. | Nothing. |
| Cross counter **[R2]** | Against **the cross only**: his misses and yours lands 6. Against anything else it is a slow cross. (Round 1: any straight punch. That made it right against everybody.) | As a punch. | As a punch. |
| Check hook **[R2, new: the trap]** | Against a jab or a body jab: his misses, yours lands 6 and **his card on the next beat is lost** (paid, does nothing). Against any other punch it is a short hook for 4. | Against a block: goes round it, lands 6, his next beat is lost. A roll makes it miss and counters. | A short hook for 4. |
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
Measured in round 1 (he always led): a bot that sees the cards but only chases damage wins 38.9%; one that also plays the
judges, the wind and his patterns wins 63.0%; one that could see the face-down card too would win 80.0%. Round 2's
numbers on equal paper are in section 6b.

### 3.2 Wind, damage, knockdowns

- **Wind** pays for cards. It tops out at 7, comes back 3 after each exchange, +1 for each beat you left empty, +2 more on
  the stool. Unspent wind is kept, so one quiet exchange buys one loud one. The same numbers for both boxers **[R2]**.
- **[R2] Body work takes wind, now and later.** A body hook that lands takes 2 wind out of what he gets back after the
  exchange (was 1, taken at once), and every 6 body damage taken is 1 wind less back each exchange for the rest of the
  bout, never under 1 (was: every 8 lowered his top wind). Why: with 3 wind back nobody could ever be found on 1 wind, so
  "tired" never happened (critic: 0.0% of exchanges). Wind turned out to be the strongest currency on equal paper (one
  extra wind an exchange for a round was worth about 25 points of win rate in sizing), so body work is now a real plan.
- **A boxer on 1 wind or less cannot hide a card**: his lead is laid face up. A floored boxer's next lead is face up too.
- **Head. [R2]** 95 points (89 to 104 by boxer; was 112). At 59 taken a boxer is *hurt*. Sized down because on equal paper
  nobody is hit twice as hard as the other any more.
- **Knockdown.** 24 head damage in one exchange (18 when hurt) puts a boxer down: the exchange ends, the
  round is 10-8 on every card, he gets 2 wind less back and his next lead is laid face up. Three knockdowns or a full
  head track stop the bout.
- Round 1 measured 10.8% of bouts stopped and 0.52 knockdowns a bout; round 2: section 6b.

### 3.3 The judges (how close fights and comebacks happen)

Three judges sit, shown before the bell. **Every judge counts clean punches (2 points each).** Each also has one taste:
- **likes work**: half a point for every punch thrown;
- **likes hurt**: a point for every 6 damage done;
- **likes craft**: a point for each punch of his you blocked, slipped or rolled, and for each counter you landed.

Each judge gives each round 10-9 to whoever has more of his points (10-8 after a knockdown). A level round goes to
damage, then to the boxer who won the last exchange, then **[R2]** to a coin from the bout's seed (in the greybox a level
judge fell to the opponent by default: a code fault the critic found). A bout is never drawn. The three counts are on screen all
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
| The two face-up cards | The solvable part of the exchange. Round 1 measured: worth 44 points of win rate over seeing none. | Whenever he leads (novices show all three; professionals hide two on their first lead of a round). |
| **[R2] His two habits** | Each opponent has two habits that rule his face-down card: a trigger you can see and the card that then lies face down. One ends on a punch, one does not, so knowing which applies changes the answer. Out-boxer: *follows the jab with the cross* / *covers up behind the cross*. Pressure fighter: *goes to the body first* / *rolls under after his hook*. Counter-puncher: *slips, then the cross* / *opens with the check hook*. Volume puncher: *follows the jab with the cross* / *takes the last beat off*. He keeps to a habit 90 times in 100 when its trigger is on the table. (Round 1's habits were patterns among shown cards, worth 1.7 points: they flipped no answer.) | A habit rules about two of his leads in three. |
| **[R2] A habit you know** | The card is printed on the face-down slot when the trigger is on the table ("usually: Cross"). Film in camp finds one habit before the bell; the tally under each slot (what lay face down there, and after which shown card) finds the other by about round 2. | Camp, then watching. |
| His wind | What he can afford face down. On 1 wind or less he hides nothing. | Always. |
| The corner: "Watch him" | His leads of the next round are laid face up. **[R2]** His corner can pick it too: then yours are. | A corner pick. |
| A knockdown | His next lead is face up. | Earned. |
| **[R2] How he answers you** | When you lead, the table keeps what he has done in the same spot: against a shown head punch, a shown body punch, a shown guard, nothing shown, and against your face-down card. That is what you lay a trap on. | Grows through the bout. |
| **His read of you** | He remembers what you do on each beat and against the face-down card, and answers it. A chip shows what his corner has noticed. Measured: a player who always blocks high on the hidden card loses 7 more points to an opponent who adapts. | Grows with his class; novices do not adapt. |
| His discard pile | Open, as a reminder of what he has thrown. **Not a skill:** counting it was worth nothing in the probe, so the game does the count and prints it. | Always. |

### 3.5 The cards

Thirteen cards went into the round 1 probe; round 2 has fourteen (the Check hook). The last column is what the round 1
probe said about each; round 2's card table is in `docs/CARDSCOPE2_PROBE.md`.

**[R2] Deck rules (close the breaker deck).** A deck holds 12 to 16 cards, at most 4 copies of a card and at most 2
Cross counters. "Drop a habit" can never take a deck under 12. Round 1 had no limits and the critic's 10-card deck with
4 Cross counters won the pro debut 78% of the time.

| Card | Wind | Does | Its job | Round 1 probe |
|---|---|---|---|---|
| Jab | 1 | 2 head, fast, straight | Opens a combination, beats slower punches to the mark, cheap probe at the hidden beat. | Works: most played (24%), good against two styles, poor against two. |
| Body jab | 1 | 2 body, fast, straight | Goes under a high guard; starts a chain cheaply. | Works: best pick against the pressure fighter, middling elsewhere. |
| Cross | 2 | 6 head, straight | The money end of the one-two. | Played a lot (16%) but more copies never help: the starting deck has enough. |
| Lead hook | 2 | 6 head, hook | Punishes a slip; ends the 1-2-3. | Same as the cross. |
| Body hook | **[R2]** 3 (was 2) | 4 body, hook, takes 2 wind out of what he gets back (was 1) | The investment: his wind, then his secrets. | Weak: three rounds are too short for the investment to pay. Needs the longer pro bouts or a bigger wind bite. |
| Uppercut | 3 | 10 head, slow | Splits a block, catches a slip, a roll or a tie-up. | Weak: opponents rarely guard, so there is little to split. |
| Cross counter | 3 | **[R2]** Beats the cross for 6 (was: any straight) | The read made into a card: lay it where you know the cross is coming. | **Too strong** in round 1: the best pick against three of four styles even after its price went from 2 to 3. |
| Check hook **[R2]** | 2 | Catches a jab or a block for 6 and takes his next beat; otherwise 4, hook | The trap that punishes the safe answer. Face down behind your own shown jab, or his against yours. | New in round 2. |
| Block | 1 | High or low, stops 4 | The cheap half-answer to anything. | Works: top-five pick everywhere, never the best. |
| Slip | 2 | Straight misses, counter next beat | The full answer to a known straight. | Works as designed: +23 points against the out-boxer, -18 against the pressure fighter. |
| Roll | 2 | Hook misses, counter next beat | The full answer to a known hook. | Best against the pressure fighter, as designed, but weaker than the slip. |
| Step back | 2 | Everything misses | Safe against the unknown, earns nothing. | Middling to poor. |
| Tie up | **[R2]** 2 (was 1) | Smothers this beat and softens his next | Survival when hurt; once a round. | **Too strong** in round 1: second-best pick against every style. |
| Feint | 0 | Takes away his next guard, +4 | Turns a shown guard into an opening. | **Dead**: worst pick against every style; he seldom guards. |

Sharp and Signature versions (from drilling) change one thing each; sized in the build phases, not in this probe.

### 3.6 The corner minute

Between rounds pick one of three (a better coach offers a fourth):
- **Water** - full wind at the bell. **[R2]** No longer 1 more wind back all round: on equal paper that alone was worth
  about 25 points and made the pick automatic.
- **Ice** - 30 head damage back **[R2]** (was 20).
- **Watch him** - his leads of the next round are laid face up.
- **[R2]** His corner picks from the same three with the same rule of thumb (hurt: ice; short of wind: water; else watch
  you). In round 1's greybox it could never pick "watch".

Measured: always taking the same one costs 1 to 7 points against choosing by the state of the fight, but a random pick is
only 1.6 behind the informed one. The corner is not yet the decision it must be (bar B17 failed); phase 5 owns it.

### 3.6b The opponent on paper **[R2: replaced]**

*Round 1:* he always led blind, so he had to be the better boxer on paper (up to twice your wind, heavier hands) to make
a fight of it. The critic traced most faults to that one patch.

*Round 2:* **equal paper up to and including regional class.** Same top wind, same wind back, same hands. What makes
one class harder than the last is how he boxes, not what he is given:

| Class | Bouts of the run | He shows | How he boxes | Paper |
|---|---|---|---|---|
| Novice | 1, 2 | all three cards on his leads | loose leads, answers almost at random, does not read you | equal |
| Open class | 3, 4 | two of three | still loose, starts to read you | equal |
| Regional | 5, 6 | two of three | tidy leads, answers well, reads you | equal |
| Title | 7 | two of three | sharp, reads you fully | top wind +1 |
| Professional (four rounds) | 8 | one of three on his first lead of a round | sharp | top wind +1, heavier hands |

So the first hidden card arrives at bout 3 with nothing else changing (the critic's cliff was two changes at once), and
his numbers move only from the title bout. His decks hold guards, the check hook and a feint again, because a leader who
can hide one card and an answerer who sees two both have a use for them.

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
- **The ladder [R2]:** the five classes of 3.6b: two novice bouts, two open-class, two regional, a title bout, the pro
  debut over four rounds. Equal paper until the title bout. Each has
  three judges drawn from five tastes and an opponent with a style, two habits and one best weapon.
- **Between bouts, one of:** *drill* (pick 1 of 3: a new card, a Sharp version, a combination step), *drop a habit*
  (remove a card), *film* (find one habit of the next opponent), or *rest* (head damage carried from the last bout is
  healed; unhealed damage is carried in). One only: a war costs the next camp.
- **What grows:** the deck (12 to about 16), card versions, combinations, a perk after bouts 2, 4 and 6, what you know of
  the next opponent.
- **What is lost:** head points carried into the next bout; a stoppage loss costs the next camp pick (suspension); the
  third loss ends the run.
- Inside FightCamp the same ladder is simply the career: the weeks are the picks.

### 3.9 The table does the sums **[R2, new]**

The critic: the reader's edge over a rule of thumb "is mostly exact sums over 112 lines ... depth a program has; a person
gets it only if the table does the sums". So the table does them. This is a rule of the design, not a nicety of the page:

- **Three result strips, one a beat.** As you hold a card over a beat, the strip under it shows what happens there
  against the card you can see: damage both ways, who lands first, the combination bonus, what a block leaves, a lost
  beat. Lifting the card takes it back. Nothing is hidden in a rulebook.
- **The face-down beat shows a range**, worst to best over the cards he can still be holding and can pay for (the game
  does the count of his discards), and the habit if one is known ("usually: Cross").
- **Three small scales, one a judge**, move as you place cards: what this exchange would do to each count.
- **Wind as pips for both boxers**, his dimming as he tires; "cannot hide a card" lights up at 1.
- **When you lead** the strips show what each beat does if he stands still, and under each of your slots what he has
  done in that spot so far (3.4, last row). The table cannot show his answer; that is the bet.
- **After the beats** each strip keeps its one true line, so "why did I lose that exchange" is on the screen.

*Its bar (C10, section 4b):* a bot that places one card at a time and keeps whatever the printed numbers like best, with
no memory, no counting and no plan, must close half the gap between the rule-of-thumb beginner and the reader. If it
does, the skill the probe measures is one a person at this table can reach. The owner's bar for phase 2 stays: after each
exchange he can say why he won or lost it, and he wins at least 1 bout of 3 at open class.

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

### 4b. Round 2 bars (CARDSCOPE2; written and committed before the round 2 run, not loosened afterwards)

Round 2 answers the fresh critic (`CARDSCOPE1_CRITIC_SDK.md`, 6 / 5 / 6), items 1 to 6 and 10 of its list. B1 to B18
above stay exactly as written and are measured again on the changed greybox. The bars below are added; C1 to C4, C6, C7,
C8, C9, C11 and C12 are the critic's own numbers, C5 and C10 are ours for the two items the critic left without a
number ("target mix" and "the table does the sums").

Population as in section 4. Two bots are added to the harness. **Beginner** is the critic's rule-of-thumb player: one
rule per shown card (a straight punch: cross counter if it is a cross, else slip, else block; a hook: roll, else block;
a guard: hit round it; nothing shown: jab, cross, hook in order), one fixed answer to the face-down card (block), and
when it leads it lays jab, cross, hook in order with the last card face down. No counting, no judges, no memory.
**Table player** is a person helped by the table of section 3.9: it places one card at a time and keeps the placement
whose printed numbers are best (damage both ways on the shown beats, the middle of the printed range on the face-down
beat, the three judges' counts for this exchange). No memory, no counting, no plan for the wind, no look past this exchange.

| # | Bar | Pass when |
|---|---|---|
| C1 | Equal paper holds (critic item 1) | with the same wind and the same hands on both sides, the reader wins 55 to 65% at regional class |
| C2 | He tires (item 1) | he starts 5 to 15% of exchanges on 1 wind or less (reader's bouts, regional) |
| C3 | Nobody is the heavier hitter (item 1) | in the reader's bouts damage dealt and damage taken are within 10% of each other. The critic wrote "for the winner"; read as: the boxer who wins is not hit harder by rule. The share of wins with more head damage taken than given is printed beside it |
| C4 | You set traps (item 1) | when the reader leads, its face-down card is something other than a punch in 30%+ of leads |
| C5 | The hidden card is a fork (item 2) | of the cards he lays face down: punches under 55%, guards or the trap 20%+, nothing or a feint 15%+ (critic's target 45 / 30 / 15 / 10; it was 81 / 15 / 2 / 2) |
| C6 | No fixed answer to the hidden card (item 2) | the reader forced to always block, always jab, always punch or always leave it empty wins 10+ points less than the reader who chooses, each of the four |
| C7 | The answers spread (item 2) | of the reader's answers to his face-down card no class (punch / block / evade or tie up / nothing / feint) is over 40% (a punch was 62%) |
| C8 | No breaker deck (item 3) | no legal deck the search finds wins the pro debut over 50% with the reader. The search: the critic's two breaker decks made legal, every card stacked to its limit on the neutral deck cut to 12, then two rounds of one-card swaps from the best of those |
| C9 | No pair is a key (item 3) | in the card table no added pair lifts any pair-up by more than 25 points (Cross counter was +62 against the out-boxer) |
| C10 | The table makes the skill a person's (item 4) | the table player closes half or more of the gap between the beginner and the reader, and is 10+ points over the beginner (regional) |
| C11 | No cliff (item 5) | the beginner wins 70%+ at novice, 45 to 60% at open class, 25 to 40% at regional (it was 72 / 16 / 12) |
| C12 | Habits rule and flip (item 6) | one of his two habits is on the table in 50%+ of his leads; where a known habit applies, the reader's answer to the face-down card differs from its answer without the habit in 30%+ of those exchanges; B15 as written |

Item 10 (the two code faults) is a test, not a bar: `engine.test.mjs` must show a level judge going to damage, then the
last exchange, then a coin from the seed that falls both ways, and his corner picking every corner card.

**Round 2 verdict rule: PASS = B1 to B7 and C1 to C12 all pass.** Supporting bars B8 to B18 that fail are named with
their cause. The brief's run rule stands: the design as written, one resize (numbers only), one design change, stop.

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

## 6b. Round 2 result **[R2]** (full tables: `docs/CARDSCOPE2_PROBE.md`)

**Verdict: FAIL.** Final run: 6 of 7 round 1 core bars, 4 of 12 round 2 bars, 5 of 11 supporting bars. Two measured
runs: as sized, then the one resize (Body hook 3 wind, knockdown line 24 / 18, habits kept 90 in 100). The third run was
not spent on a patch.

| Critic item | Bar | Final run | |
|---|---|---|---|
| 1 | C1 equal paper holds (reader 55 to 65% at regional) | 57.8% | PASS |
| 1 | C2 he tires (5 to 15% of exchanges on 1 wind or less) | 2.3% (6.6% before the resize) | FAIL |
| 1 | C3 nobody is the heavier hitter | 7.0 dealt, 7.0 taken an exchange | PASS |
| 1 | C4 you set traps (30%+ of your leads) | 38.0% | PASS |
| 2 | C5 the hidden card is a fork | punch 43.8, guard or trap 30.3, nothing 22.5, feint 3.4 (was 81 / 15 / 2 / 2) | PASS |
| 2 | C6 no fixed answer to it (each 10+ under free choice) | block -30, jab -11, empty -22, a punch -9 | FAIL (by 1.4) |
| 2 | C7 the answers spread (no class over 40%) | a punch 50.4% (was 62%) | FAIL |
| 3 | C8 no breaker deck over 50% in the pro debut | 61.1% with four Check hooks (46.5% before the resize) | FAIL |
| 3 | C9 no added pair lifts a pair-up over 25 | +50.6 Check hook (run 1: +47.2 Body hook; round 1: +62 Cross counter) | FAIL |
| 4 | C10 the table player closes half the beginner-reader gap | 46.2% (beginner 4.3, table player 29.0, reader 57.8) | FAIL |
| 5 | C11 no cliff (beginner 70+ / 45 to 60 / 25 to 40) | 81.0 / 43.1 / 4.3 | FAIL |
| 6 | C12 habits rule and flip | on the table in 70.8% of his leads; the answer flips in 31.9%; film +5.3; counting +0.9 | FAIL (on counting only) |
| 10 | the two code faults | both fixed and tested | done |

**What round 2 settled.**
- The lead can change hands with one rule set, and on equal paper the game still separates players: random 1%, damage
  chaser 31%, reader 58%, all-seeing 66%. No fixed line wins a bout.
- He is no longer a different kind of boxer: same wind, same hands, guards and traps in his deck, and what he lays face
  down is a punch less than half the time.
- Knowledge now changes answers: a known habit is worth 5.3 points and flips the answer to the hidden card in a third of
  the exchanges where it applies (round 1: 1.7 points, no flips).
- The corner became a decision by accident of equal paper (informed 4.9 over random, each card a quarter or more of the
  picks: B17 passes). Wind is the strongest currency in the game.

**What is still wrong, in order of weight.**
1. **The answering boxer wins by hitting, so guards are worth nothing.** Leading, a boxer deals about 7 and takes 10;
   answering, 8 and 4. The best answer to a shown punch is a faster or harder punch, not a guard. That one fact is behind
   C11 (the beginner guards and loses 96% of bouts at regional class), B6 (Block, Slip, Roll, Step back and Feint are
   bottom-half picks against every style), C7 and C6 (a punch into the unknown is right half the time).
   *Phase 0 (a) and (b):* a guard that works must pay (a block also earns the counter; a Parry for the jab), and the lead
   must be worth holding (evade and keep the lead).
2. **Whichever card takes his next action away is the key card.** Round 1: Cross counter. Run 1: Body hook (his wind).
   Run 2: Check hook (his next beat). Sizing one up moves the crown. *Phase 0 (c):* limit the Check hook to 2 copies like
   the Cross counter, and size "takes his next action" as one family, not card by card.
3. **He tires only through the body, and that fights with point 2** (C2 passed at 6.6% while the Body hook was the key).
   *Phase 0:* a second road to being tired that is not a card (for example, a third card in one exchange costs a wind
   more), so the Body hook can be sized down without him never tiring.
4. **The table helps the answer, not the lead.** The table player answers as well as the damage chaser and stops there.
   *Phase 2:* the lead needs its own help on the table (what he did in this spot before), and C10 is measured again.
5. **Bars written for the old shape.** B10 (showing beats guessing) and B8's "fixed above random" no longer measure what
   they were written for now that both corners lead; they are kept as written and reported failed, not reworded.

**Honest limits.** Bots, not people; nobody has played an exchange. Sizing used its own seeds and the bar tables others,
but the reader's weights were tuned in sizing, so the reader is a better player than round 1's. The beginner's lead
("jab, cross, hook in order") is our definition, not the critic's; it spends all its wind and that is part of its score.

## 7. Open decisions for the owner (taste and scope only)

1. **Where it lives.** The page describes a card game that can stand alone (the 8-bout run) and can also be fight night
   inside FightCamp (3.7). Phases 1 to 6 build it standing alone in the browser, as the prototype was; phase 8 is the
   link. Whether it replaces the 30-second-call fight night or sits beside it is his call after he has played phase 2.
2. ~~He is better on paper.~~ **[R2] Decided: the lead changes hands and the paper is equal.** Decided by Claude under
   the owner's FREE HAND (S534: "you can remove, add from scratch or interconnect") because the fresh critic showed it is
   a structural fix, not a taste: it is what lets him tire, gives his guards and traps a use and gives the player a trap
   of her own to set. It did not cost a second rule set: the same exchange rules serve both corners. Probed in round 2.

## 8. The build plan **[R2: revised]** (one job a phase; each ends on its test and its fun bar)

Changed from round 1: a phase 0 is added because round 2 did not pass; phase 1 ports the round 2 greybox (turns to lead,
equal paper, the trap, habits, deck rules); phase 2 builds the table of 3.9 and carries its bar; phases 3 and 4 own the
bars round 2 left open.

| Phase | Builds | Test | Fun bar to pass before the next phase |
|---|---|---|---|
| 0. Round 3 on the greybox (no page) | Only what section 6b names as the cause of a failed bar: (a) a use for the lead beyond damage control (the critic's Pivot: evade a straight and keep the lead; a clean lead keeps the lead); (b) "guard what you see" made sound: a block that works also earns the counter, a Parry for the jab; (c) the card pool re-cut on the round 2 card table (weak guards, Feint, Step back; Body hook sized); (d) the counter-puncher's deck against body work | `node proto/cardscope/engine.test.mjs`, then the five probe commands | C6, C7, C10, C11, B5, B6, C9 and B18 as written. One round, bars not loosened. If the two critics still score under 8 after it, the owner gets "cut it or keep it" |
| 1. The rules module | `proto/cardbout/rules`: the exchange, who leads, wind, knockdowns, judges, the bout, seeded; ported from `proto/cardscope` (rules.mjs, bout.mjs) with its checks | `node proto/cardbout/rules.test.mjs` | B1 to B5, B9, B12, B14 and C1 to C5 re-measured on the new module, same numbers as the greybox |
| 2. The table | One page built to 3.9: both sets of slots, the three result strips filling in as a card is held over a beat, the range and the habit on the face-down beat, the three judges' scales, wind pips for both, the turn of the table when the lead changes; novice and open-class opponent | a page test that plays a seeded bout through the page's own calls; the strip numbers equal the rules module's | C10 on the page's own numbers. The owner plays 3 bouts: a bout takes 5 to 8 minutes; after each exchange he can say why he won or lost it; he wins 1+ of 3 at open class |
| 3. The opponents | 8 boxers (two a style), each with two habits (one ending on a punch, one not), a weapon and his own deck; the five classes of 3.6b; his corner's read of you shown as a chip | harness block "opponents" | B18 (every pair 40 to 90%), C12, B16 (8+), C11 |
| 4. The card pool | Whatever phase 0 kept, plus Sharp and Signature versions and named combinations as drills; deck rules enforced in the picks | harness block "cards" (the card table of the probe) | B6 (every card top-four somewhere and bottom-half somewhere), B13, C8, C9 |
| 5. The corner and film | Corner cards as orders for the round with a cost each (critic item 7); film in camp finds one habit | harness block "corner" | B17 (informed 3+ over random, each card 15%+ of picks), B15 |
| 6. The run | The 8-bout ladder: drill / drop / film / rest, perks, damage carried, three losses | harness block "run" | B7 on the real run; a good bot finishes 30 to 50% of runs; a run takes 40 to 60 minutes |
| 7. Words and feel | Varied true lines, timing of the reveal, the sound of the flip | line test: no line contradicts its beat | The owner plays a full run; after a loss he says "I lost because of what I played, not because of what he had" |
| 8. The link | A deck built from a Career boxer (3.7), result written back (damage, the Why) | adapter test with a golden boxer | His call (decision 1) |

No phase starts before the one above it has passed its bar. Phase 0's changes are proposals from the round 2 tables, not
measured. A fresh critic scores this page first (`CARDSCOPE2_CRITIC_KALLI.md` is queued; a second, code-checked critic is
a later SDK job).


---

# PART 2 - the bot probe, round 2

# CARDSCOPE2 - the bot probe of the card game scope, round 2 (S537)

Design: `ops/research/DESIGN_CARDGAME_SCOPE.md` (text marked [R2]; bars in sections 4 and 4b). Greybox: `proto/cardscope/`
(plain node, no page, no Godot). Round 1: `docs/CARDSCOPE1_PROBE.md`. Critic answered: `ops/research/CARDSCOPE1_CRITIC_SDK.md`
(6 / 5 / 6), items 1 to 6 and 10 of its list.
`node proto/cardscope/engine.test.mjs` -> RESULT: PASS - all 45 checks green.
`node proto/cardscope/probe.mjs fixed 2`, `ladder 2`, `info 2`, `cards 2`, `breaker 2`, then `report` print the tables below.

## Verdict: FAIL (run 2: 6 of 7 round 1 core bars, 4 of 12 round 2 bars; run 1: 5 of 7 and 6 of 12)

Taking turns to lead on equal paper works as a fight: the reader wins 58% at regional class with the same wind and hands
as the opponent, damage is level (7.0 dealt, 7.0 taken an exchange), the opponent's face-down card is a real mix (44%
punch, 30% guard or trap, 23% nothing), the reader lays a trap of its own on 38% of its leads, a known habit changes the
answer in 32% of the exchanges where it applies and is worth 5.3 points. It does not yet pass: a rule-of-thumb beginner
still wins 4% at regional class, a punch is still the answer to the hidden card half the time, guards are bottom-half
picks against every style, and each sizing made a different card the key (Body hook in run 1, Check hook in run 2).

## What was changed for round 2 (critic item -> change)

| Critic item | Change in the greybox |
|---|---|
| 1. Take turns to lead, equal paper | The lead changes hands every exchange (you lead 1 and 3, he leads 2 and 4), same exchange rules for both corners. No wind or power step for the opponent up to regional class; classes differ in how well he leads and answers. Title: top wind +1. Pro: top wind +1, heavier hands. |
| 2. The hidden card a fork | New card Check hook (the trap: catches a jab or a block for 6 and takes the next beat). Opponent decks re-cut with guards, the trap and a feint. Each opponent has two habits that rule his face-down card, one ending on a punch, one not. |
| 3. Close the breaker deck | Cross counter beats the cross only; a deck holds 12 to 16 cards, at most 4 of a card, at most 2 Cross counters; Tie up costs 2. |
| 4. The table does the sums | Designed (scope page 3.9). Its bar is a bot: the table player places one card at a time on the printed numbers only. |
| 5. Smooth the cliff | Bout 3 adds the hidden card and nothing else; his numbers move only from the title bout. The critic's rule-of-thumb player is in the harness as the beginner bot. |
| 6. Knowledge flips answers | A known habit prints its card on the face-down slot when its trigger is on the table; the reader keeps a tally of what lay face down on each beat and after each shown card. |
| 10. Two code faults | A level judge goes to damage, then the last exchange, then a coin from the seed (tested: it falls both ways). His corner picks every corner card (tested). |
| Also needed to make 1 work | Body work lowers the wind he gets back (so a boxer can be found on 1 wind); corner sizes (water is full wind only, ice 30); head points 95 and the knockdown line sized for level damage. |

## How it was run

- Bots in the player's chair: random; the best of all 4,096 fixed three-card lines (searched, then re-measured on fresh
  seeds with each choice of face-down beat); greedy (most damage now); reader (public information only); all-seeing (the
  reader shown his face-down card: a ceiling); beginner (the critic's rule of thumb); table player (scope page 4b).
- Population: 4 player boxers x 4 opponent boxers from other clubs, one of each style, all different in cards and numbers,
  never the same boxer on both sides; 500 bouts a pair a bot; card table 3,000 bouts a cell; 1,200 runs of 8 bouts;
  breaker search 17 decks and two rounds of one-card swaps, the best five re-measured on 1,000 bouts.
- The round 2 bars were written and committed (54e078a58) before any round 2 code ran and were not edited afterwards.
  Two wordings were fixed in the instruments, not the bars: the "no counting" arm of B15 now ignores his discard pile
  entirely (in round 1 it still dropped cards that had run out), and "bottom half" in B6 is ranks 8 to 14 of 14 cards.
- Before run 1 the numbers were sized on separate seeds (300000 and up, `calib.mjs`, `diag.mjs`): the classes, head
  points, the knockdown line, the corner, how body work takes wind, and the reader's own weights (it was losing to the
  damage chaser until it valued wind and took water in the corner). The bar tables ran on the probe's own seeds.
- Two measured runs: run 1 as sized; run 2 after the one resize the brief allows (numbers only: Body hook costs 3 not 2,
  knockdown line 24 / 18 not 22 / 16, he keeps a habit 90 not 85 times in 100). **The third run (one design change) was
  not spent**: what still fails needs the design work named below, not one more patch, and the method rule of this
  project (findings drive the queue) says to scope that first.
- Bots are not people: nothing below says a person enjoys it.

## What failed, and the cause in the design

| Bar | Run 1 | Run 2 | Cause |
|---|---|---|---|
| C11 no cliff (beginner 70+ / 45-60 / 25-40) | 78.8 / 44.2 / 5.7 | 81.0 / 43.1 / 4.3 | Novice passes, open class is 2 short, regional is far off. Equal paper did not close the gap, so the cliff was never the paper. The rule of thumb guards what it sees and never throws when he shows punches: as the answering boxer it deals 2.5 damage and takes 5.5, where the reader deals 8 and takes 4. With the opponent loose enough for the beginner to win 38%, the reader wins 92% (sizing run). "Guard what you see" has to become a sound line by rule. |
| C10 the table (half the gap) | 38.3% | 46.2% | The table player answers almost as well as the greedy bot (29.0 v 30.8) with one card placed at a time, so the sums are reachable. It stops short because the table cannot help its lead: it leads like the beginner and spends all its wind there. |
| C6 no fixed answer to the hidden card | block -22, jab -8, punch -5, empty -17 | block -30, jab -11, punch -9, empty -22 | Three of four pass in run 2. "Always a punch" is 1.4 short: with nothing face down 23% of the time and a trap that only catches jabs and blocks, a cross or a hook into the unknown is rarely punished. |
| C7 answers spread (none over 40%) | punch 47.7 | punch 50.4 | Same cause. The reader's answers to the hidden card are a punch or nothing (83%); a block or an evade is one answer in six. |
| C2 he tires (5-15%) | 6.6% PASS | 2.3% | Only body work can put a boxer on 1 wind. Run 1 passed with the Body hook at 2 wind; it was then the key card (+47), so the resize made it dearer and he stopped tiring. Tiring and "no key card" pull on the same number. |
| C8 no breaker deck (50%) | 46.5% PASS | 61.1% | Run 2: four Check hooks win the pro debut 61% (neutral deck 10%). The trap is too good in bulk against opponents who jab and block. A copy limit of 2, as for the Cross counter, is the obvious rule; not measured. |
| C9 no pair is a key (25) | +47.2 Body hook v out-boxer | +50.6 Check hook v out-boxer | Wind is the strongest currency on equal paper (one more wind an exchange for a round was worth 25 points in sizing), and both cards take his next action away. |
| C12 habits rule and flip | 66.5% / 29.9% / B15 fails | 70.8% / 31.9% / B15 fails | The two new parts pass in run 2. It fails only through B15's second half: counting his discards is worth 0.9 (bar 3). Knowing both habits is worth 5.3 (bar 4). |
| B6 every card has a matchup (round 1 core) | 13 of 14 flat | 13 of 14 flat | The card table has the same order against every style: Check hook, Body hook, Body jab on top; Block, Slip, Roll, Step back, Feint at the bottom everywhere. More guards never help because the answering boxer wins by hitting, and the leader's guards are seen. |
| B5 decided late (30%) | 27.8% | 30.6% PASS | Fewer knockdown rounds after the resize (0.30 a bout, was 0.74). |
| B8 ladder of skill | fails on one step | same | Random 0.8, fixed 0.0, greedy 30.8, reader 57.8, all-seeing 65.7. Only "fixed above random" fails: no fixed line wins a bout. Reader over greedy by 27. |
| B10 showing beats guessing | 51.6 / 60.4 / 57.1 / 50.7 | 50.6 / 61.6 / 58.7 / 45.8 | The dial now turns for both corners, so hiding more also protects the reader's own leads. The reader's lead over random is best with one card shown, worst with all three. The bar was written for a game where only he led. |
| B11 stoppages 10-25% | 3.2%, 0.74 knockdowns | 1.8%, 0.30 | On level damage (84 a bout against 95 head points) few bouts end early. The damage chaser stops or is stopped far more often; the reader boxes safely. |
| B15 film and counting | +4.4 / +1.6 | +5.3 / +0.9 | Film passes its half. Counting does not pay; round 1 said the same. |
| B16 he reads you back (8) | 0.6 | 1.7 | Fixed lines win nothing either way; a reader who always blocks the hidden card loses 1.7 more to the adapting opponent. |
| B18 styles 40-90% | 8.2 to 94.0 | 16.8 to 87.6 | The counter-puncher and the pressure fighter against the volume puncher (17 to 19%). Content sizing. |

Passed in both runs: B1 to B4, B7, B9, B12 to B14, B17, C1, C3, C4, C5.

## Run 2 - after the one resize (the greybox as committed)

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 500 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 3000 bouts a cell. Run: 1200 runs of 8 bouts. Breaker: pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure 250 bouts an opponent.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 57.8% v best fixed line 0.0% = +57.8 (- / - / -, hides beat 1) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 57.8% v random 0.8% = +57.0 |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 0.0% on fresh seeds (screen best 0.0%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 24.9% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **PASS** | 30.6% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Jab, Body jab, Cross, Lead hook, Body hook, Uppercut, Cross counter, Block high, Slip, Roll, Step back, Feint, Check hook |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.23 wide offers of 7.47 a run; bouts won: informed 67.0%, random pick 59.9%, no pick 58.4%; wins a run 5.01 v 4.16 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 0.8 / 0.0 / 30.8 / 57.8 / 65.7 |
| B9 | The hidden card is a bet, not the game (all-seeing 5 to 20 over the reader) | **PASS** | +7.9 |
| B10 | Showing beats guessing (reader lead over random 10+ bigger with 2 shown than with 0) | **FAIL** | lead over random with 0 / 1 / 2 / 3 cards shown: 50.6 / 61.6 / 58.7 / 45.8 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 1.8% stopped, 0.30 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (no punch lands in under 15% of exchanges; dead beats under 25%) | **PASS** | 3.8% of exchanges, 17.9% of beats |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | share of cards played: Jab 26.9, Body jab 4.6, Cross 18.1, Lead hook 15.1, Body hook 3.4, Uppercut 2.4, Cross counter 2.0, Block high 13.1, Slip 3.6, Roll 2.6, Step back 0.8, Tie up 1.8, Feint 0.0, Check hook 5.7 |
| B14 | Split cards (15%+ of points decisions) | **PASS** | 21.9% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | both habits known +5.3 (one habit +3.7), counting +0.9, watching him +3.8 (reader 57.8%) |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 0.0% v a non-adapting opponent, 0.0% v the adapting one; a reader who always blocks high on the hidden card: 29.8% v 28.1% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **PASS** | informed 57.8%, random 52.9%, always water 52.1%, ice 55.2%, watch him 48.9%; informed picks water 26.2%, ice 33.2%, watch him 40.6% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 16.8%, highest 87.6% |
| C1 (core) | Equal paper holds (reader 55-65% at regional, same wind and hands) | **PASS** | 57.8% |
| C2 (core) | He tires (starts 5-15% of exchanges on 1 wind or less) | **FAIL** | 2.3% of exchanges |
| C3 (core) | Nobody is the heavier hitter (damage dealt and taken within 10%) | **PASS** | dealt 7.0 and taken 7.0 an exchange (ratio 1.00); 28.4% of wins with more head damage taken than given |
| C4 (core) | You set traps (your face-down card is not a punch in 30%+ of leads) | **PASS** | 38.0% of the reader's leads |
| C5 (core) | The hidden card is a fork (punch under 55%, guard or trap 20%+, nothing or feint 15%+) | **PASS** | punch 43.8%, guard or trap 30.3%, nothing 22.5%, feint 3.4% |
| C6 (core) | No fixed answer to the hidden card (always block / jab / punch / empty each 10+ under free choice) | **FAIL** | free 57.8%; always block 28.1%, jab 47.1%, a punch 49.2%, empty 36.3% |
| C7 (core) | The answers spread (no class of answer to the hidden card over 40%) | **FAIL** | punch 50.4%, block 9.0%, evade or tie up 7.7%, nothing 33.0%, feint 0.0% |
| C8 (core) | No breaker deck (no legal deck over 50% in the pro debut) | **FAIL** | best of 17 decks and 2 swap rounds: 61.1% (2 Jab, 2 Body jab, 1 Cross, 2 Block high, 1 Slip, 4 Check hook); neutral deck 10.2% |
| C9 (core) | No pair is a key (no added pair lifts a pair-up by more than 25) | **FAIL** | biggest lift +50.6 (Check hook v out) |
| C10 (core) | The table makes the skill a person's (table player closes half the beginner-reader gap, 10+ over the beginner) | **FAIL** | beginner 4.3%, table player 29.0%, reader 57.8%: 46.2% of the gap |
| C11 (core) | No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional) | **FAIL** | beginner 81.0 / 43.1 / 4.3% |
| C12 (core) | Habits rule and flip (a habit on the table in 50%+ of his leads; the answer flips in 30%+ where one applies; B15) | **FAIL** | habit on the table in 70.8% of his leads; answer differs in 31.9% of 24215 exchanges where a known habit applies; B15 fails |

Round 1 core bars (B1-B7): 6 of 7 pass. Round 2 bars (C1-C12): 4 of 12 pass. Supporting bars (B8-B18): 5 of 11 pass. Verdict: **FAIL**.

Reader by pair (player style v opponent style): out v out 76.8, out v press 75.0, out v counter 85.8, out v volume 76.4, press v out 59.4, press v press 51.6, press v counter 84.2, press v volume 18.6, counter v out 40.2, counter v press 41.8, counter v counter 55.0, counter v volume 16.8, volume v out 54.0, volume v press 69.8, volume v counter 87.6, volume v volume 31.8

Opponent class (beginner / table player / greedy / reader): novice 81.0 / 91.4 / 91.2 / 93.6, open class 43.1 / 83.2 / 81.5 / 91.1, regional 4.3 / 29.7 / 31.2 / 58.6, title 1.9 / 18.6 / 20.9 / 46.6, professional 0.5 / 6.7 / 7.6 / 27.8

Cards shown by the leader 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: [0] 6.9, 42.8, 57.5, 91.6  [1] 2.9, 37.6, 64.5, 82.3  [2] 1.1, 31.3, 59.8, 68.9  [3] 0.3, 39.2, 46.1, 46.1

Best fixed lines found: - / - / - (hides beat 1) 0.0%; - / - / - (hides beat 2) 0.0%; - / - / - (hides beat 3) 0.0%; - / - / Jab (hides beat 1) 0.0%; - / - / Jab (hides beat 2) 0.0%; - / - / Jab (hides beat 3) 0.0%

Breaker search, final measure: 61.1% swap round 2: Jab out, Body jab in [2 Jab, 2 Body jab, 1 Cross, 2 Block high, 1 Slip, 4 Check hook]; 47.9% swap round 1: Cross out, Body jab in [3 Jab, 1 Body jab, 1 Cross, 2 Block high, 1 Slip, 4 Check hook]; 40.8% Check hook stacked to its limit [3 Jab, 2 Cross, 2 Block high, 1 Slip, 4 Check hook]; 29.7% Body hook stacked to its limit [3 Jab, 2 Cross, 4 Body hook, 2 Block high, 1 Slip]; 27.4% Body jab stacked to its limit [3 Jab, 4 Body jab, 2 Cross, 2 Block high, 1 Slip]

What two more copies of a card are worth (reader win %, neutral deck alone: out 20.5, press 38.3, counter 56.4, volume 10.5):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 19.1 (9) | 41.6 (5) | 59.3 (6) | 12.5 (6) |
| Body jab | 40.0 (3) | 58.2 (1) | 75.3 (3) | 29.6 (2) |
| Cross | 19.2 (8) | 36.9 (6) | 58.4 (8) | 10.6 (7) |
| Lead hook | 30.4 (4) | 41.8 (4) | 67.0 (4) | 13.1 (5) |
| Body hook | 50.5 (2) | 43.5 (3) | 83.3 (1) | 18.1 (3) |
| Uppercut | 24.1 (6) | 32.6 (8) | 62.5 (5) | 9.5 (8) |
| Cross counter | 26.4 (5) | 26.5 (10) | 58.9 (7) | 6.9 (9) |
| Block high | 12.0 (11) | 24.0 (11) | 33.3 (11) | 6.4 (10) |
| Slip | 14.0 (10) | 16.6 (14) | 29.0 (14) | 6.4 (11) |
| Roll | 10.1 (12) | 27.0 (9) | 34.0 (10) | 6.3 (12) |
| Step back | 9.1 (14) | 22.9 (12) | 31.1 (12) | 5.1 (13) |
| Tie up | 22.6 (7) | 35.2 (7) | 45.8 (9) | 15.3 (4) |
| Feint | 9.2 (13) | 18.1 (13) | 30.8 (13) | 4.6 (14) |
| Check hook | 71.1 (1) | 46.8 (2) | 81.2 (2) | 34.7 (1) |

## Run 1 - as sized before the first measured run

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 500 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 3000 bouts a cell. Run: 1200 runs of 8 bouts. Breaker: pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure 250 bouts an opponent.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 58.4% v best fixed line 0.0% = +58.4 (- / - / -, hides beat 1) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 58.4% v random 1.0% = +57.4 |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 0.0% on fresh seeds (screen best 0.0%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 31.9% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **FAIL** | 27.8% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Jab, Body jab, Cross, Lead hook, Body hook, Cross counter, Block high, Slip, Roll, Step back, Tie up, Feint, Check hook |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.34 wide offers of 7.68 a run; bouts won: informed 71.2%, random pick 62.1%, no pick 61.9%; wins a run 5.47 v 4.42 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 1.0 / 0.0 / 30.8 / 58.4 / 64.4 |
| B9 | The hidden card is a bet, not the game (all-seeing 5 to 20 over the reader) | **PASS** | +6.0 |
| B10 | Showing beats guessing (reader lead over random 10+ bigger with 2 shown than with 0) | **FAIL** | lead over random with 0 / 1 / 2 / 3 cards shown: 51.6 / 60.4 / 57.1 / 50.7 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 3.2% stopped, 0.74 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (no punch lands in under 15% of exchanges; dead beats under 25%) | **PASS** | 3.9% of exchanges, 18.9% of beats |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | share of cards played: Jab 26.4, Body jab 4.3, Cross 17.8, Lead hook 14.8, Body hook 6.9, Uppercut 2.2, Cross counter 2.0, Block high 12.1, Slip 3.5, Roll 2.2, Step back 0.8, Tie up 1.5, Feint 0.0, Check hook 5.7 |
| B14 | Split cards (15%+ of points decisions) | **PASS** | 15.4% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | both habits known +4.4 (one habit +3.4), counting +1.6, watching him +2.9 (reader 58.4%) |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 0.0% v a non-adapting opponent, 0.0% v the adapting one; a reader who always blocks high on the hidden card: 37.0% v 36.4% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **PASS** | informed 58.4%, random 53.5%, always water 52.8%, ice 54.5%, watch him 50.3%; informed picks water 24.2%, ice 32.6%, watch him 43.2% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 8.2%, highest 94.0% |
| C1 (core) | Equal paper holds (reader 55-65% at regional, same wind and hands) | **PASS** | 58.4% |
| C2 (core) | He tires (starts 5-15% of exchanges on 1 wind or less) | **PASS** | 6.6% of exchanges |
| C3 (core) | Nobody is the heavier hitter (damage dealt and taken within 10%) | **PASS** | dealt 7.0 and taken 7.0 an exchange (ratio 0.99); 25.1% of wins with more head damage taken than given |
| C4 (core) | You set traps (your face-down card is not a punch in 30%+ of leads) | **PASS** | 32.8% of the reader's leads |
| C5 (core) | The hidden card is a fork (punch under 55%, guard or trap 20%+, nothing or feint 15%+) | **PASS** | punch 45.1%, guard or trap 28.6%, nothing 22.6%, feint 3.8% |
| C6 (core) | No fixed answer to the hidden card (always block / jab / punch / empty each 10+ under free choice) | **FAIL** | free 58.4%; always block 36.4%, jab 50.0%, a punch 53.2%, empty 41.4% |
| C7 (core) | The answers spread (no class of answer to the hidden card over 40%) | **FAIL** | punch 47.7%, block 8.4%, evade or tie up 6.2%, nothing 37.7%, feint 0.0% |
| C8 (core) | No breaker deck (no legal deck over 50% in the pro debut) | **PASS** | best of 17 decks and 2 swap rounds: 46.5% (3 Jab, 2 Cross, 3 Body hook, 1 Uppercut, 1 Block high, 1 Slip, 1 Check hook); neutral deck 14.0% |
| C9 (core) | No pair is a key (no added pair lifts a pair-up by more than 25) | **FAIL** | biggest lift +47.2 (Body hook v out) |
| C10 (core) | The table makes the skill a person's (table player closes half the beginner-reader gap, 10+ over the beginner) | **FAIL** | beginner 5.7%, table player 25.9%, reader 58.4%: 38.3% of the gap |
| C11 (core) | No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional) | **FAIL** | beginner 78.8 / 44.2 / 5.7% |
| C12 (core) | Habits rule and flip (a habit on the table in 50%+ of his leads; the answer flips in 30%+ where one applies; B15) | **FAIL** | habit on the table in 66.5% of his leads; answer differs in 29.9% of 21281 exchanges where a known habit applies; B15 fails |

Round 1 core bars (B1-B7): 5 of 7 pass. Round 2 bars (C1-C12): 6 of 12 pass. Supporting bars (B8-B18): 5 of 11 pass. Verdict: **FAIL**.

Reader by pair (player style v opponent style): out v out 76.2, out v press 28.2, out v counter 87.2, out v volume 67.6, press v out 94.0, press v press 48.2, press v counter 93.8, press v volume 57.6, counter v out 39.6, counter v press 8.2, counter v counter 49.4, counter v volume 14.8, volume v out 75.2, volume v press 48.6, volume v counter 89.6, volume v volume 56.8

Opponent class (beginner / table player / greedy / reader): novice 78.8 / 89.5 / 90.2 / 94.7, open class 44.2 / 79.2 / 80.8 / 90.9, regional 5.7 / 26.5 / 31.4 / 58.2, title 3.2 / 18.0 / 22.0 / 50.3, professional 1.1 / 6.2 / 7.9 / 28.6

Cards shown by the leader 0 / 1 / 2 / 3 - random, greedy, reader, all-seeing: [0] 7.4, 46.6, 59.0, 88.5  [1] 2.7, 36.9, 63.1, 78.9  [2] 1.0, 31.6, 58.1, 66.4  [3] 0.4, 35.6, 51.1, 51.1

Best fixed lines found: - / - / - (hides beat 1) 0.0%; - / - / - (hides beat 2) 0.0%; - / - / - (hides beat 3) 0.0%; - / - / Jab (hides beat 1) 0.0%; - / - / Jab (hides beat 2) 0.0%; - / - / Jab (hides beat 3) 0.0%

Breaker search, final measure: 46.5% swap round 2: Block high out, Uppercut in [3 Jab, 2 Cross, 3 Body hook, 1 Uppercut, 1 Block high, 1 Slip, 1 Check hook]; 39.4% swap round 1: Body hook out, Check hook in [3 Jab, 2 Cross, 3 Body hook, 2 Block high, 1 Slip, 1 Check hook]; 38.0% Body hook stacked to its limit [3 Jab, 2 Cross, 4 Body hook, 2 Block high, 1 Slip]; 24.2% Check hook stacked to its limit [3 Jab, 2 Cross, 2 Block high, 1 Slip, 4 Check hook]; 19.9% Uppercut stacked to its limit [3 Jab, 2 Cross, 4 Uppercut, 2 Block high, 1 Slip]

What two more copies of a card are worth (reader win %, neutral deck alone: out 43.6, press 19.1, counter 64.0, volume 24.2):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 37.2 (8) | 18.3 (5) | 64.7 (7) | 22.5 (7) |
| Body jab | 62.1 (3) | 30.8 (2) | 73.1 (4) | 36.1 (3) |
| Cross | 42.7 (7) | 17.0 (7) | 68.8 (6) | 19.7 (8) |
| Lead hook | 50.8 (5) | 19.3 (4) | 73.1 (5) | 26.1 (4) |
| Body hook | 90.8 (1) | 46.5 (1) | 88.5 (1) | 55.8 (1) |
| Uppercut | 54.9 (4) | 15.5 (8) | 73.6 (3) | 23.3 (6) |
| Cross counter | 45.9 (6) | 7.8 (12) | 62.3 (8) | 14.5 (9) |
| Block high | 23.2 (11) | 9.6 (10) | 39.6 (11) | 13.0 (10) |
| Slip | 28.7 (10) | 6.0 (14) | 35.0 (14) | 12.6 (11) |
| Roll | 22.1 (12) | 11.4 (9) | 39.8 (10) | 12.3 (12) |
| Step back | 20.5 (14) | 8.3 (11) | 37.7 (12) | 11.1 (13) |
| Tie up | 36.5 (9) | 17.2 (6) | 51.3 (9) | 24.6 (5) |
| Feint | 20.8 (13) | 7.0 (13) | 37.3 (13) | 10.5 (14) |
| Check hook | 84.0 (2) | 19.4 (3) | 83.8 (2) | 41.7 (2) |


---

# PART 3 - the game (critic pack)

> Also read `ops/research/CRITIC_ACCESS.md`: the Miro board, the real screens, the mockups and the eight MMA fighters. Written S403 from the code; update it when a mechanic or screen lands.

## What every critic must return (operator S405: "i want the critics everytime to state what to change to reach 10/10")
Whatever you score (a screen, a film, a mechanic, a design), end with **To reach 10/10**: the concrete changes that would take it from your score to 10, most important first, each specific enough to build. If it needs something the game cannot do yet, say so. A score without this list is not finished.


# FightCamp critic pack: the whole game, for judging whether a screen has the right options

Owner's rule: "i want every screen you design to have the right options so every critic needs to know the whole game design and mechanics to guide you".
This pack is facts only: no scores, no verdicts, no earlier critic comments, and nothing that is merely proposed. Written 2026-11-08 from the code
and the agreed plans. Where a document and the code disagree, the pack says what the code does.

How to read the status tags:
- BUILT = it is in the game now and a player can use it.
- AGREED, NOT BUILT = the owner approved it (or a plan he approved includes it) but the game does not do it yet. Judge a screen as if it will exist.
- PARTLY = some of it is in the game; the pack says which part.
- NOT ESTABLISHED = the pack could not confirm it from the code or the plans. Do not assume either way.
Names only in headers (owner S448: "notice how the names are only mentioned on the header , nowhere in text menus options , follow that rule"): a person's name sits in the screen's header once; options, buttons, rows, lines and tooltips say her / him / the opponent / your coach. Flag every name you see outside a header.
A screen should offer an option only if the player can act on it (rule in section 7). "Option" below means anything the player can press, drag, pick or type.

## 1. What the game is

- A boxing gym management game for PC (Godot 4.7, Windows). The player is the head coach and owner of one small boxing club. Not a promoter, not a fighter,
  not a tycoon. The club lives on members who pay monthly dues; a fighter's bouts add ticket cuts, reputation and new members.
- Scope for the first release: boxing and no-gi BJJ (the owner decided BJJ ships beside boxing). MMA comes in the first update after launch. Kickboxing and
  Muay Thai are not scheduled. Early Access is the target; no date.
- The player controls: whom to sign and which starting focus; the coaches and staff hired; the week of training for each fighter (mornings, pad and sparring
  evenings, diet); which bouts to take or ask for; the camp before a bout; the game plan written as lines; combinations built and drilled; the corner calls
  and corner minute on fight night; the fighter's next goal; the club's money (dues, spending, deals, upgrades).
- The player does NOT control: the punches thrown. The fight is settled by rules (exchanges of 30 seconds); the 3D fight only shows the settled round and
  never decides. The player also does not control fighters' moods directly, rival fighters, the weather/twist cards, injuries, or when offers arrive.
- The fun, in the owner's and the design's words: raising an unknown into a champion; the plan is the star; you can always see how your plan made the
  difference (the Why after every fight); every week costs something (training, weight, fatigue and money pull against each other); fighters are people
  (traits, habits, moods); fast and honest (anything one click from anywhere, true numbers). The three core mechanics beside the corner (owner S354):
  the morning sessions that add up to a goal and an intensity (the week), the evening move and combination planner, and a fight plan that is fun to design.
  The Playbook/Combos area is the part the owner calls really fun ("to try and also learn from the book").
- Design rule on results: the better-trained fighter usually wins; a good plan turns close fights and gives underdogs a real chance. Measured in tests:
  good plan about 59% of bouts, no plan 45%, bad plan 41% (one matchup). Training beats planning: 5 points better in stats wins about 72%, 10 points about 95%.
- Not mobile, not casual: no timers, gacha, daily rewards or ads. Real stats stay visible. Deeper, not wider (owner approved "build all proposed systems").
- Tone: a gym, warm and tactile, not a spreadsheet. Plain words, one word per concept, no flavour text.

## 2. A career from the first minute to the first pro fight

Time model: the clock runs day by day when the player presses the big CONTINUE button. It stops by itself every Monday (the week review) and for
anything that needs the player (a bout offer on its last day, weigh-in, fight night, injury choice, trial day, walk-in). Day 0 is Monday 5 January 2026.
The button says what it is stopping for ("to Thu 15 Jan, the offer expires"). Quiet week = one click.

1. Title screen: Resume career (if a save exists), New career, Quick start (a ready club, London), Load career, Settings, Credits, Quit.
2. New career, two steps. Step 1 YOU: your name and one of four head coaches on photo cards (Old hand, Ex-pro, Amateur coach, Strength coach), each with one
   edge. Step 2 YOUR CLUB: country, city, gym name, and one of three starts that double as difficulty: Fresh doors (normal), In debt with one good boxer (hard),
   Backed with big expectations (risky). A switch lets the player skip the first-hour guide. Quick start takes the first coach card and Fresh doors.
3. Day 0, Home: the first-hour card (the job: keep the doors open; the first show date; who you are), a walk-in fighter waiting at reception (Lucy Jackson in
   the standard start; other starts and the male-boxer start use other names). The guide strip runs three stages: FIRST WEEK (sign, coach, week, go),
   FIRST FIGHT (offer, prep, fight), THE CLUB (second boxer, bouts for both, set the first boxer's next goal). It can be skipped.
4. Sign the walk-in: an RPG-style card (class from style, potential in stars, each attribute's ceiling, two traits, one habit, a signature move, an
   ambition) and ONE starting focus. Hire an assistant coach (Luke Reid sessional $450 a week, or Marcus Hale full-time $1,090 a week; $1,000 signing fee).
   Without any coach, training runs at 60%. Open the Week and lock in week 1 (the coach has already written a week). Press CONTINUE.
5. Monday of week 2 (day 7): the first bout offer arrives, for the club show on Saturday of week 4 (day 26). Until the first bout is fought there is no twist
   card and no ask. She starts about 1.4 kg over the limit, so weight is the first real decision (a cut needs starting in week 1). Accept shows a poster
   reveal and offers the camp.
6. Fight prep: camp (focus, intensity, partner, film), game plan, weigh-in the day before, fight night, result, Why, goal talk. After the first bout: a second
   walk-in arrives the next Monday, a rival coach (Frank Doyle, Eastside ABC) is named in the news, three club tasks appear on the guide strip, and Ana (the
   no-gi athlete) is teased, then asks to join after the club's second bout or by week 9.
7. The loop afterwards: offers every couple of weeks (a club show every other Saturday from day 12), camps, nationals, money pressure, more fighters.
8. Amateur road: the National Amateur Championships. Entry needs 5 bouts and 3 months registered, age 19-40; entries close in week 10; a London regional then a
   national draw. While in it, no other offers come. A loss, injury or missed weight ends the run.
9. Turning pro: a promoter's offer arrives at 7 wins with a top-3 regional rank, or at 9 wins at any rank. The debut is 4 rounds, about 4 weeks after signing.
   The gym pays the licence ($230) and, the first time, medicals ($875) and the trainer's licence ($140). Stipend stops. After the debut a pro joins a world
   division table unranked and the promoter brings three offers per fight (see 4.12). Older docs said "the game ends near the first pro fights"; the code
   goes further (pro ladder, belts, ageing, retirement), see section 8.
   BUILT S523 (turning pro v2): two fictional promoters. Bow Lane (ticket house: $1,500, less $25 a ticket short of 60 sold,
   floor $500, 50% of tickets past 60, debut 4 weeks out, opponent 1.0 under) and Harrow & Finch (guarantee house: $1,800,
   30% past 70, debut 6 weeks out, opponent 1.5 under). Who calls follows the debut ticket forecast (family 20 + half the
   members + 2 a win + 10 a title + 10 for topping the club's own show): within 15 of 60 both call side by side, else one.
   The offer stands 14 days (running out is not a No: the call returns after 2 more wins); no first call at 32+. One ask
   per promoter, its answer shown before pressing: later debut (+2/+4 weeks for $150/$300 off), softer opponent (and the
   next 2 offer sets are tune-ups), better split (taken 20+ over break-even, a +5 counter at 5-19, else won't), own ticket
   price (Bow Lane), costs from the purse (Harrow & Finch counter). The offer shows the gym at signing, the gym each week
   after, the boxer's money and when the gym is even again; morale on each button (a title-chaser before the nationals
   minds). The debut pays the gym 25% of the purse and of the ticket share. For the first 6 pro fights Harrow & Finch adds
   a second tune-up, Bow Lane a second step up. NEXT STEP shows tickets vs each break-even in wins, age line, declines left.
10. The club failing: 8 weeks in a row below $0 closes the gym. A closed gym shows a summary that cannot be dismissed (New career / Load career / Title).

## 3. The fighter: three layers

Plan agreed by the owner (2026-11-08): a fighter has primary attributes (what the fighter IS, same in every sport), skills (how good at one sport) and moves
(a jab, a low kick, an armbar; each has its own level in the Playbook: New, Raw, Usable at 30, Sharp at 60, Signature at 85).

AGREED, NOT BUILT: the 10 primary attributes. Operator: "these 10 lookok"; one Speed for hands and feet (the game's Hand speed becomes Speed). Strength; Explosiveness; Speed;
Stamina; Recovery; Flexibility; Durability; Fight IQ; Composure; Heart. One Strength number for the whole body (no number per hand; left/right differ through
moves and stance). Merges: Chin and Toughness become Durability; boxing Conditioning and BJJ Cardio become Stamina. Power is not its own number (it comes from
Strength, Explosiveness and skill). Weight cut, height, reach and stance are written facts, not bars. "Marks easily" is a label for cuts, not a bar. Aggression is
a slider you set (Patient to Forward), not a bar. Technique and Defence become skills. Explosiveness and Recovery stay only if the fight really uses them.
AGREED, NOT BUILT: 12 skills (ops/research/S400_REVIEW/SKILLS_PROPOSAL_S404.md). Boxing 5: Accuracy, Timing, Defence, Footwork, Inside fighting. Kickboxing and Muay Thai 6: those + Clinch. No-gi BJJ 5: Takedowns, Guard, Top game, Submissions, Escapes. MMA 12 in three groups. The profile design (one body and mind for every sport; only skills swap; a sport switch appears only once the
fighter trains both; crossing over costs training time) is agreed in shape; the mockup number lists (24 numbers, 25 for a boxer) predate the 10-attribute list.

BUILT today (what screens show):
- Boxing: 7 trained stats: Power, Hand speed, Technique, Defence, Conditioning, Ring IQ (fight IQ), Chin; plus Footwork (derived from speed and defence) and
  the personality values Heart, Discipline, Confidence, Coachability, Temper (Loyalty exists but is not on the board). Amateur women's lightweights sit 55-65;
  bands: weak under 45, fair under 55, solid under 65, strong under 75, elite above. Each stat has a potential ceiling ("tick") and a weekly delta.
- Moves with mastery (0-100): Jab, Cross, Lead hook, Body hook, Uppercut, Check hook; from 30 a move is a "weapon" the fight can use. Combinations (the
  book: 1-1, 1-2, 1-1-2, 2-3, 1-2-3, 1-2-3-2, 3b-3, 1-2-3b, 1-6-3, slip 2-3) unlock when their moves are weapons; players can also build their own.
- Body: weight vs class limit, condition (fatigue word), injuries. Style word (Out-boxer, Pressure fighter, Counter-puncher, Volume puncher, Boxer-puncher,
  Slugger). Stance. Age. Record. Rank in the region.
- Personality and habits, learned not shown as numbers in the ring: 6 traits (heart, temper, confidence, discipline, coachability, loyalty) and habits
  (for example drops the right after the jab, slow starter, fades late, chases stoppage). A coach's-notes card fills in with words from fights and sparring.
- Morale (stored 0-100): Fired up (75+), Steady (50+), Flat (30+), Low. Moves: win +8, loss -12, goal met/missed, rest week +4, a month without a fight -6,
  bout booked +5, wrong corner call -2, right call +1. Morale is also trust in the corner: Fired up 1.05, Steady 1.0, Flat 0.85, Low 0.7 of the corner's
  word taken in; a Low fighter stops listening.
- BJJ athletes have 6 stats (strength, cardio, flexibility, explosiveness, composure, aggression) and mastery per move; belts, not ranks.
- Perks (the perk road): open for good when attributes reach a need, each changes one thing in a bout: Iron chin (Chin 70), Stiff jab (Technique 65),
  Second wind (Conditioning 70), Ring general (Ring IQ 65, corner calls work 25% better), Counter sense (Defence 65 + Check hook weapon), Body snatcher (Body
  hook weapon), Finisher (Power 70), Fast hands (Hand speed 70).

## 4. Every mechanic

### 4.1 The week and training plan - BUILT
- Choice: for each fighter a week of seven mornings (a session each: roadwork, intervals, heavy bag, weights, speed bag, slip rope, shadow, neck work, or rest;
  each at Light, Normal or Hard) and seven evenings (Pads, Sparring, Rest, Film). The coach writes the week from the camp phase and repeats it; the player edits
  exceptions (click a day, a popover). "Back to the coach's week" resets. Diet: Hold or Cut 500 kcal a day.
- Phases counted back from a booked bout: BASE (no bout), BUILD (3+ weeks out), PEAK (2 weeks out, hardest, sparring twice), TAPER (fight week: light, three rest
  days, no sparring).
- Changes: each morning adds a small amount to one stat (pace 1.0 per focused week x coach factor x headroom clamp((potential-stat)/25, 0.10, 1.25), a morning
  is a fifth of it, Light x0.6, Hard x1.3, less when tired); kcal and weight; fatigue (0-100, "Week tiredness"; from 80 she is overreached: gains x0.6 and
  injury risk x3). The Week tab shows plan totals, the goal line, the coach's one change with a "Do it" button, and the weeks to fight night.
- Coach factor: 0.5 + rating x 0.7 per cent; no coach = 60%. Strength coach head-coach edge: body mornings +10%, craft mornings -10%.
- Twist card: once a week the coach draws one (sore wrist, rain, weights room shut, partner ill, head cold, visiting pro, quiet week; or a choice card such as
  tight knee, scale will not move, night off, heating breaks, combo clicking, southpaw in town, old coach visits, sponsor photoshoot, rival talks trash). Two
  answers each with a visible price; unanswered = the coach's pick on Monday. Planned vs actual is shown on the review.
- Training load: acute vs usual load; a spike (ratio 1.5+) raises injury risk 2-4x.
- Two fighters in camp competing for the coach's pad nights: AGREED, NOT BUILT (see 4.2).

### 4.2 Pads, combinations and mastery - BUILT (pad nights for two fighters AGREED, NOT BUILT)
- Evenings are nights that carry drill cards. A pad night is 75 minutes split over its cards; a sparring night gives every card already in her hands a share.
  Standard week: 3 pad nights; camp 2+1 / 2+2 / 3+2 pad+spar for Light/Standard/Hard.
- Choice: drag a drill card (a move or combination) onto a pad night; split a night 50/50, 70/30, 30/70; remove or clear; pin cards in the tray; "+ drill it".
- Mastery gain per hour of drilling: pads 2.1, heavy bag 1.05, shadow 0.85, sparring 1.5, speed bag 0.9, double-end bag 1.2. Undrilled moves fade slowly.
  A drilled combination also holds its punches. Tiers: New, Raw (under 30), Usable (30), Sharp (60), Signature (85). A move at 30+ is a weapon.
  Today a planned line fires every time once it is usable; sharp is worth about 1 win in 100 over usable. In the game but SWITCHED OFF (S427,
  measured on 400 bouts a cell): a planned line fires 1 use in 2 at usable, 3 in 4 at sharp, always at Signature (sharp then +2.8 wins in 100
  over usable, Signature +2.7 over sharp). BUILT for professional bouts (S458-S462, `ProRead`): the opponent's corner studies your boxer's
  last two professional fights and waits for the punch thrown most; two real weapons or a feint line blunt it. Amateur bouts: not read across bouts.
- A combination in a fight costs energy (longer costs more); a flurry is limited by hand speed and tiredness; a signature (drilling, not length) may run one
  punch past the speed cap. Own combinations built in the Playbook (Combos tab) get their own pad mastery.
- AGREED, NOT BUILT: with two fighters in camp the coach's pad nights are shared; the top row of "Learn on the pads" shows how many go to each (cost to the
  other fighter), only while two are in camp; a needs flag says when the second camp starts.

### 4.3 Fight camp - BUILT
- Opened by "Set camp" (a need once a bout is 3+ weeks off, or from Fight prep). Choices: camp focus (one of Conditioning, Power, Technique, Defence, Speed);
  intensity Light / Standard / Hard (3, 4, 5 nights; focus multiplier 1.1/1.2/1.35; fight-night edge +0.25/+0.6/+1.0; all free); Partner: club mates (free) or an
  outside mate of the opponent's stance or style ($160); Film (tape study, free).
- Changes: the camp stat gets a forecast to fight night; scale forecast; tape study opens one tell on the opponent's file every few camp days (weapon first,
  weakness last). A camp whose three lines are all met on fight night (made weight, stat on target, never overreached) gives PEAK CAMP: +bonus to every stat for
  that fight. A southpaw partner removes a round-1 penalty for an orthodox boxer who never faced one.

### 4.4 Weight - BUILT
- Each fighter has a class limit (amateur, from Data.gd: women's 57/60/65/70/75 kg, men's 55/60/70/75 kg; the pro ladder groups them by ProLadder.division_for). Weigh-in is the day before. Diet Hold/Cut and training burn move weight;
  the bout page and Fight prep forecast "now / on the day". Missing weight calls the bout off and the club pays $300 for the empty slot. A boxer over his
  class can get a bout he can make (a later date). The Old hand head coach makes cuts easier (120 kcal a day more).

### 4.5 Booking and matchmaking - PARTLY
- Amateurs BUILT: offers arrive (a club show every other Saturday; one offer at a time per fighter, answer by a date, usually 8-12 weeks lead at clubs, 2-4
  weeks in the first hour). Each offer: Accept or Pass, both free. An unsafe mismatch (a novice, 0-10 bouts, against an open fighter) cannot be accepted. Win chance
  shown as a band that widens when unscouted. Ask for a fight (amateurs, built S512-S518): the sheet name, a step up or a name you pick, at one of the next club shows; a host can say No with its reason, a No to a boxer ON A RUN is a DUCK, two ducks in 8 weeks and that corner OWES the bout. The door opens the day after a bout (S520); the asked show still falls after the 10-day rest, and the sheet sends its own offer when the rest ends if nothing was asked.
- Pros BUILT (after the debut, on Fights): the promoter brings three offers per fight (TUNE-UP likely, STEP UP about even, PAYDAY long shot) standing 7 days; OR the
  player asks for a named boxer within the promoter's band (about 5 places above, unranked reach 15; a top-5 name needs 3 fans); Scout costs $250 and opens the
  opponent's weapon and weakness and narrows the chance range. A promoter refuses if you duck the step up twice. Each row shows chance, what a win gives (place,
  fans), what a loss costs, stoppage risk, pay (gym's 25% of the purse), and the gap to the next fight (quick, normal, hard night).
- Rank rule: beat someone above you and take their place; beat someone below and nothing moves; a losing record is never ranked in the top 10. Purse: $1,500 unranked
  + $400 per place; tickets follow fans and how close the fight looks. Pro rounds: 4 unranked, 6 ranked, 8 top 10, 10 for a title.

### 4.6 Scouting and the opponent's file - BUILT
- Free at booking: record, look, style word. Hidden until found: best weapon, each habit, weakness. Amateur: tape study in camp opens one a session. Pro: scout
  for $250; the weapon is public tape. A found tell names its answer (a plan situation, a corner call or a drill). The Ex-pro head coach opens one tell the day
  a bout is booked. An opponent with no bouts has no tape. The Tape Room (Fight prep, "Watch the tape") plays 3-4 films of her past bouts, SPOT the tell, then
  YOUR ANSWER picks a move that becomes a plan line.

### 4.7 The game plan (Playbook) - BUILT
- A plan is lines: "At long range -> One-two", "When she presses -> Step back" (places: outside, long, mid, inside, clinch, ropes; situations: she presses, boxes at range,
  waits to counter, loads up, tires). Each answer is rated vs the opponent's game: Beats it / Works / Walks into it, and its edge over improvising, times her pad
  time. Rate against another kind of opponent; round-by-round pace Push/Steady/Save; a go-to combination. The coach's skill sets how many lines (a plan holds
  4-6). Real fight plans can be loaded; See the flow; Open the map. With no plan written the assistant coach writes one (poor to about half of a read plan).
- A plan the fighter has not drilled works less well; a wrong answer costs. During a bout: planned right answers that win exchanges build PRESSURE on the opponent
  (cuts her output); planned wrong answers she is punished for shrink her energy ceiling.
- BUILT (`PlanRead`): inside a round the opponent adjusts - a planned line pays in full for its first 2 uses in that round, then less each use; it resets
  at the bell. AGREED, NOT BUILT: their note replaces the coach's line in the corner minute naming the line that stopped working.

### 4.8 Fight night - BUILT
- A bout is 3 rounds of 3 minutes (amateur), 4 (pro debut), more later. A round is six 30-second exchanges, each settled by dice on an edge (training, plan, corner call,
  pressure, tiredness). The opponent fights one way at a time (Pressing, Boxing at range, Waiting to counter, Loading up, Tiring, Hurt), shown as a clue.
- Every 30 seconds the player may shout one of the 3 calls that fit, or say nothing: Jab and move, Go to the body, Draw the lead, Hands up move your head, Let your
  hands go, Breathe pick your shots, Tie up, Go for the finish. Each has a best / ok / wrong match to the opponent's mode, needs stats, costs or gives energy; only
  two instructions per minute get through fully. Pace (Push / Steady / Save) and Aim (Own game / Head / Body / ribs / the hurt head) persist from shout to shout.
  A set-up "NOW!" fires a learned combination into a gap the opponent opens: big edge, or a cost if wrong.
- Corner minute between rounds: the corner card (what worked, what hurt, the call), the plan call, ONE CHANGE for the next round (a habit fix, or Elbows in: half the body punches go to the head, saving their energy and adding head damage, or Gloves high: the reverse; moved punches change where she is hit and what it costs, measured not to change who wins), RECOVER with 3 points (water, ice on the ribs, clear
  her head when hurt), SET-UP (a combination x a gap), TALK (calm / fire up / the truth), change one plan arrow, cutman job (close the cut, enswell an eye, nothing).
  Trust: a wrong call she followed costs trust; a Low fighter ignores shouting.
- Knockdowns and counts come from power and damage vs chin, heart for the count; amateur RSC at 3 counts in a round or 4 in a bout. Injury roll after the bout.
- Result: scorecards (3 judges), win on points / stoppage / draw, "what decided it", the Why, a body report (which part went first, with a "Train X next week"
  button), "The plan, lit up" flow, then Back home and the goal talk. Watch modes: with a picture the 3D fight plays (1x/2x, Skip round, Skip bout); headless runs
  stay in words. "Sim to result" skips the fight. Highlights/full modes in design notes: NOT ESTABLISHED as options in the UI.
- AGREED, NOT BUILT: a cutman card for a closing eye, "stop it (she loses, the eye is safe) or go on (risk of a lasting cut)", behind a divider, never a pop-up,
  never pre-selected, not using one of the two fixes (the 3D corner has a cutman job row today; whether its stop-or-go choice exists is NOT ESTABLISHED).

### 4.9 The Why - BUILT (the hook)
- After a bout, plain lines: YOUR PLAN (graded against having no plan: right answers, wrong answers, neutral, worth about +X% chance), AGAINST YOU (what the opponent's
  habits cost), NEXT (what to train or write). Graded by how each planned move answered what the opponent was doing, not by the dice; "swing" counts replay the
  dice without the plan's edge. A readable reason for every random swing (R11): AGREED, NOT BUILT as a general feature; it lives on existing rows.

### 4.10 Damage, injuries, suspension - BUILT
- Six body places per boxer take punches (head, ribs, etc.); bands fine over 55, hurt 55, critical 35, doctor 15. Bout injury roll from settled damage (about 6% a
  3x3 bout; 72% head/neck, 20% cuts); training injury about 1.3% a week, more when overreached. Stoppage loss = 30-day suspension, longer for repeats. While out: no
  offers, a quarter of gains. A fighter hurt before a bout: choice "pull out" (club pays the empty slot) or "fight hurt" (less energy: minor 10, moderate 15, serious 20).
  A damage ledger and fights-left forecast exist for pros in the world model.

### 4.11 Morale, trust, goals - BUILT
- Goals with deadlines (for example Debut inside a month, Next bout inside a month, Southpaw answer, Five-round engine), set in the office after each bout (Goal talk:
  pick one of the offered goals). Status ON TRACK / AT RISK / OFF TRACK / MET / MISSED; ~70% clearable by design; meeting or missing moves morale. "Her asks" can be
  heard or overruled (morale +5 / -5). The ambition shown on the signing card does not yet change anything (the design says a kept goal should build loyalty, a broken one may make a fighter leave: AGREED, NOT BUILT). Overruling a low-coachability fighter hurts more.

### 4.12 Staff - PARTLY
- Head coach (you): one of four edges: Old hand (cuts easier), Ex-pro (one tell on file when a bout is booked), Amateur coach (a prospect's exact potential), Strength
  coach (+10% body mornings, -10% craft mornings). Assistants: Luke Reid and Marcus Hale (above); training quality, plan lines taught (more with better rating), evening
  classes +$350 a week. Staff jobs on the Club page (each changes one number): Second club coach 10 h ($280 a week: +1 roster place, +40 members, runs fitness classes);
  Strength and conditioning ($100: training injury risk -15%, a pro camp's bill halved); Physio ($75: injuries back a quarter sooner); Cutman ($150 a pro night: half
  the post-bout layoffs). Letting a staff member go costs a week's pay. Letting the main assistant coach go: NOT ESTABLISHED (Let go exists on the staff jobs).
- "Coach runs it / I run it" per fighter: AGREED, NOT BUILT (the Roster has no such column).

### 4.13 Money and the gym - BUILT
- The week review gives one short reason beside any change in members (word getting round, gym full, less room, dues too steep, more than the gym's name can hold).
- Income each week: members' dues ($35 a month each standard; bands Cheap $25 / Standard $35 / Premium $45 change who joins), evening classes (+$350 with a coach), no-gi
  dues, sponsors, fitness classes, juniors' dues. Costs: rent $1,800 a month (bigger premises more), England-Boxing-style fees ($315 club + $18 a boxer + $35 a coach a year),
  coach, fighter stipends ($250 a week, optional), heating and power by season, insurance $1,250 a year, staff, kit budget (Low $0 / Standard $45 / Good $80 a week),
  upgrades' upkeep. Wages and upkeep are billed every 28 days. Start cash = 1 / 3 / 6 months of costs by start. Runway under 8 weeks warns; below $0 is red; 8 weeks in a
  row below $0 closes the gym. A loan ($180 a week for 26 weeks) comes with the debt start; the backed start loses $5,000 if the first show is lost. An overdraft rule
  exists (offered after 12 weeks of trading, 16% a year) but NOT ESTABLISHED as having a screen.
- One-offs: a bout adds a $450 ticket cut; camps cost a partner fee when used; repairs; a club show you host ($3,500, tickets $25, up to 400 seats, every 16 weeks, can lose
  money); a club grant bid once a year (answer in 42 days, needs a second coach, odds follow reputation).
- Spending choices on the Money page: Premises (Unit 70 members/3 places, $1,800 rent; Bigger unit 140/5, $3,400, $12,000 to move; Club building 250/7, $5,500, $25,000);
  Upgrades (matted floor $2,400; strength corner $3,600; fitness class kit $1,500; youth section $1,800), each bought once, works after a week, one visible effect; Sponsors
  (Ironclad $250/week from the start; Bow Road Physio $150 after the first win; bigger sponsors later); dues band; kit budget; evening coaches; pro stipends and contract talks.
- Members: walk toward a target set by reputation, dues band, premises and coaches (at most 6 a week). A win adds +8 members and +5 reputation; a loss removes 1 and 2 reputation;
  a stoppage loss 2 and 4. Facilities (floor, ring, bags, lockers, office) can be repaired once ($120 bags) for +2 reputation.
- A pro's share to the gym starts at 25% (manager 15% + trainer 10%); contract talks at the first top-10 and the first belt (keep 25% for a bonus or drop the share), then yearly.

### 4.14 Rankings, titles, the world - PARTLY
- Amateur regional table (the region's club-show boxers; a player's fighter enters at 4 wins); rankings move as rivals fight each other at shows; news lines. Nationals and the
  regional bracket (BUILT). World pro tables for four divisions (women's and men's lightweight and welterweight, about 20 ranked each): boxers age, peak, decline and retire
  (damage ledger and age), new ones arrive yearly, belts at four levels (area, national, continental, world) with mandatory challengers and vacated belts, rivals improve (BUILT in the
  rules; its screens are on Fights, not World). An open-ended career, year review, three club goals a year, club tiers, a record book of champions and rivalries,
  a named rival gym that poaches and rematches, promises/poaching at contract time, a career clock with retirement talk, youth-section home-grown prospects, a commentary line
  and a press card are AGREED (owner "all of them", Q-S294-120) and mostly NOT BUILT; Records (the gym's own history log with filters) and the youth section exist.

### 4.15 BJJ (no-gi) - BUILT
- Athletes (Ana Ribeiro) are on the mat, not in the ring: belts white, blue, purple, brown, black with 4 stripes each (IBJJF floor: blue needs 2 years, purple 1.5, brown 1; minimum
  ages 16/16/18/19). The week is 3 classes; a class drills the syllabus move she is closest to owning (+3.2 a week; owned at 30, signature 50). Choices: drill a move; stripe call
  (now / hold / early) with morale and loyalty costs; promote; enter opens (no-gi tournaments every 35 days, 8-person brackets); fight an open yourself (the player calls the moves on the move
  graph) or simulate it; who teaches (hired coach or the athlete). No ranking table: the belt is the ladder. 5-10 minute matches by belt; points: takedown 2, sweep 2, pass 3, knee on belly 2,
  mount 4, back 4. A BJJ athlete costs a roster place and a no-gi coach by the class.
- The match runs on two-sided beats of about 11 seconds (S405): each side either acts on its pick or works its grips, and a holding lead can draw the referee's 20-second stall count.
  Measured over 1,000 bouts: white belts finish about 34% of matches, the first to score keeps the bout about 80% of the time, and a one-belt gap wins about 74%.
  Her mat plan (BUILT S515-S516): a hand of plan lines (a white belt holds 3), shown line by line on the open's result and counted in a season
  book ("this season N of M: works / fails"). Measured (mat_book_test, S516): a white belt tried her plan lines ONCE in four opens - with a hand
  of 3 and early losses, most opens end before a line comes up.

### 4.16 Perks - BUILT (listed in section 3).

## 5. Every screen in the game today

### 5.0 The shell (on every game screen)
- Top bar, left to right: Back (<) and Forward (>) arrows (greyed when none); gym name; date and week (hover card); red/amber flags (not on Home): GYM CLOSED, BELOW $0, LOW CASH,
  APPLICANT, TRIAL, PRO OFFER, SET CAMP, WEEK REVIEW, WEIGH-IN, NEW GOAL (each opens its thing); cash with "running +/- $N a week" (hover card); the big button; Menu.
- The big button: CONTINUE ("to <date>, <reason>"), RUNNING (click to pause), NEEDS YOU (n) (opens the first red need), or GO TO FIGHT NIGHT. Space also presses it.
- Menu: Mail (opens World News; shows a new count), Save, Load, Settings, Handbook, Quit to title.
- Left rail: Home, Fighters, Fights (badge = open offers), Club, World; the club crest (hover: name, members). Keys 1-5 reach the rail (design note: NOT ESTABLISHED in code).
- A guide strip (first-hour guide only): the current stage's steps, what to do and why, a button for the next step, and Skip the guide.
- Settings: text size (Small/Medium/Large/Largest), window (Windowed/Full screen), days run at (Normal/Fast/Fastest), four sound sliders (all, punches/ring, crowd, music),
  Autosave (every Monday, last weeks kept / Off). Handbook: search and group filter (All, Words, The club, The week, The plan, Fight night, Money) with links to areas. Credits.

### 5.1 Title; 5.2 Create (see section 2). Create buttons: Back to title, Next: your club, Back, Open the gym; picks for coach, country, city, gym name, start.

### 5.3 Home (no tabs) - BUILT
- Notice board of needs as pinned notes, each with a button: Meet the walk-in; Answer a bout offer (Open); Weigh in; Set camp; Hire a coach (Staff); money warning (Money);
  a sponsor waiting (Deals); Enter for the nationals (Nationals); Week N review ready (Open); New goal waiting (Talk); Trial today (Watch the trial); Pro offer (Hear it);
  Hurt before the bout (Decide); competes today (Go to the mats); The gym has closed (See the summary). Red = stops the clock; amber should come next; steel can wait.
- First-hour card until the first bout (the job, show date and countdown, you). The next fight as a matchup card (button: Go to fight night, or the next step).
- YOUR FIGHTERS table: fighter (name opens the page), record, rank, next fight, weight, freshness, this week's plan. Right column: SINCE LAST MONDAY (each fighter's biggest gain
  with its cause, injuries, rank moves, new members; "All news and mail"), THE CLUB THIS WEEK (money in, costs, members, coach), COMING UP (bouts, weigh-ins, championship dates, bills).

### 5.4 Fighters > Roster - BUILT
- A sortable table (columns: fighter, record, rank, The Road, and more) with flag chips per fighter that open the thing that needs her; a card per no-gi athlete with belt,
  stripes, classes, "<name>'s mat: Playbook"; buttons: Meet the walk-in, Open training, Set camp (locked with a reason when it cannot start), See offers.
- Fighters > Find a fighter: PROSPECTS NEAR <city> as face cards with scouted ranges for four stats (a range until the trial; the Amateur coach edge shows exact potential),
  button Invite to a trial (free; she comes in on the Monday; signing costs the stipend). States: trial date, signed, passed. The reception walk-in is separate.

### 5.5 Fighter page (tabs: Overview, Week, Fight prep (only with a bout or camp), Playbook, History)
- Header: portrait, name, weight class, age, stance, record, goal chip ("Goal, N days: still needs X - at risk").
- Overview: NEXT STEP (the road: next step and what it needs; Enter for the nationals; the whole road on hover); attribute board (radar of eight against potential plus all values with weekly
  delta, hover says what each does in a fight); BODY (weight of limit, condition, injury), COACH SAYS, COACH'S NOTES n of m; GOAL (title, days left, meter, status, quote;
  Talk to <name> when a goal talk is waiting), NEXT BOUT; buttons Plan the week, Fight plan (n arrows), Find a bout; perk road; moves with mastery bars (hover plays the move); combos
  learned (gold = thrown in fights); contract text ("club stipend $250 a week, until turning pro") and goals so far.
- Week: head (NEXT/THIS WEEK dates, tiredness), PLAN TOTALS, seven columns of morning and evening cards (click opens a popover: Light | Normal | Hard and sessions; Rest | Pads | Sparring
  and the drill cards), goal line, the coach's one change with a Do it button, Back to the coach's week, the twist card (choose an answer), LEARN ON THE PADS tray (drag a card to an
  evening), THIS CAMP (diet pills Hold / Cut 500 kcal) only with a bout booked, a skills road below.
- Fight prep: VS <opponent> (club, record, game), days to fight night and weigh-in, ONE primary button that moves with the state (Set the camp / Write the game plan before sparring /
  Watch the tape / Step on the scale / Check the week), the tale of the tape with the win chance and how sure it is, WHAT YOUR PLAN SHOULD ANSWER (each found trait with its answer and
  "Write it"; hidden ones say what opens them), CAMP AND WEIGHT (scale margin, the camp stat's line to fight night, Change the week).
- Playbook (boxer): tabs Moves (move book by place in the ring; Watch/Steps, Drill, Replay, Slow motion), Game plan (see 4.7: Write a line / Change / Clear this line, Answer: <best>,
  Rate against, Load a real plan, Test it (limited tries), See the flow, Open the map, Build plan in the move browser), Combos (build a chain from "+ move" buttons, Play it, Clear, Save to the
  book, Drill it on the pads, Watch on the pads, chain hit rates vs opponent types), Escapes (folded into Moves in the agreed menu). A body plays each move on the right.
- History: every bout she fought (and brought) with result, opponent, cards and why; milestones.
- No-gi athlete page: one Record view: THE ROAD TO BLACK BELT (five belts with stripes), TO <NEXT> BELT (mat time, moves owned, syllabus), COACH'S CALL (give the stripe, Promote to <belt>, next opens
  with Enter, who teaches), RECORD in opens; her Playbook is a mat book (moves by group, Systems, Drill, Undo, a game tree with FELT and links).

### 5.6 Fights (no tabs) - BUILT
- Amateur: OFFERS ON THE TABLE (a card per offer: opponent face, record, win band, chips; Open) with each fighter's STANDING beside it (booked or free, next on the road, Enter for the
  nationals); when none, the line says when the next offer can come. For a pro: a strip, NEXT FIGHT table (offers, asks: Take this fight / Book <name> / Scout ($250)) and THE ROAD (champions and
  places around her). No-gi opens card with Enter. Fixtures list (calendar), RESULTS (who beat whom, cards, why).
- Bout page (an offer): head chips (Legal, even match / Weight at risk / Not safe), tale of the tape, stats vs the estimate, win band and ranks at stake, SCOUTING file (locked lines say what
  tape study opens), TERMS (date, 3 x 3 minutes, weight, on the scale now/on the day, time for a camp, purse none, club ticket cut $450, answer by). Buttons: Accept the bout (disabled with a
  reason when unsafe or answered), Pass. Accept plays the poster reveal and offers Set the camp / Later.

### 5.7 Club (tabs: People, Money, Records) - BUILT
- People: STAFF (you as head coach with your edge; the assistant card with training quality, plan lines, cost, net weekly; two hire cards when none: Hire Luke / Hire Marcus; no-gi coach line;
  STAFF JOBS with Hire / Let go), MEMBERS (on the books and drift, reputation word, dues band).
- Money: CASH WEEK BY WEEK chart; NOW (cash, weekly in, costs, net, month's bill, runway line, break-even members); WHERE IT COMES FROM / WHERE IT GOES bars; STIPENDS (Pay/Stop the stipend);
  CONTRACT TALKS (Keep 25%: pay a bonus / Drop to a lower share); PREMISES (Move); UPGRADES (Buy); KIT BUDGET (Low/Standard/Good); evening coaches (Hire one / Let one go); CLUB GRANT (Bid for a grant);
  CLUB SHOW (Book the show); ONE-OFFS IN and PAID OUT (last 8 weeks); DEALS (Sign a sponsor); FACILITIES (Repair); dues bands buttons.
- Records: the gym's own history, newest first, with filters (who: everyone / each fighter / coach / gym; what: bouts, honours, people...).

### 5.8 World (tabs: News, Rankings, Championships) - BUILT
- News: AROUND THE REGION (other clubs' bouts, names are links) and fixtures/events. Rankings: a table per division the gym has a fighter in (rank, fighter, gym, record, style, last bout; click a name for the rival file; a
  fighter enters at 4 wins; no-gi says the belt is the ladder). Championships: the road to the nationals per amateur (rings for what she still needs, Enter, the London regional and national draw brackets, titles).
- Rival file (modal): record, style and the tells found so far; locked lines say what tape study unlocks.

### 5.9 Modals (open on a press or when the clock stops on them; nothing else opens by itself)
- Interview/Trial (walk-in, prospect): the fighter as an RPG recruit, one starting focus (Sharpen the signature +10 mastery, Fix the habit gone in 4 weeks, Raise the ceiling +5 potential), Sign or Pass.
- Pro offer: the debut money picture (tickets she sells, her share, what the gym pays now, what ends); buttons Turn <name> pro / Stay amateur.
- Goal talk: pick one of the goals offered, Set goal or Later.
- Camp: see 4.3; buttons Later / Start (shows the cost).
- Weigh-in: Step on the scale (made or missed). Injury choice: pull out or fight hurt.
- Fight night: tale of the tape (Begin fight, Sim to result); rounds with shout bar, Sim the round; corner minute (call buttons, fixes, jobs, Say nothing / No fix); To the scorecards / To the result;
  result with Train X next week, The plan lit up, Back home.
- Week review (per fighter): bars fill to the next whole point, moves drilled, new weapon, rank change, planned vs actual, pads cards turning over, money, the coach's word; rows land one at a time with the biggest
  surprise last; the only button is Next week. Open night (BJJ): Simulate this bout or Fight it, Back to the gym. Closed gym summary. Info boxes (Settings, Handbook, Credits).

## 6. The seven approved menus, and the agreed structure of all menus

Owner, Q-S294-127: "Yes, build the seven": Home, Fighter Week, Boxing profile, Playbook, Fight night, Money, World. A shared warm-wall kit (WarmKit: wall, whiteboard, paper, sticky, magnet, chalkboard, marker
ledge) is built first so screens cannot drift. None of the seven is rebuilt in the kit yet; the screens in section 5 are the current ones. Agreed structure: five rail buttons (Home, Fighters, Fights, Club, World); one
home per job; no mailbox (Mail opens World News and the Monday page replaces the week-review pop-up); nothing opens by itself; time is one big button saying what it stops for; one booked fight runs in a straight line
(Home countdown, camp, weigh-in, tape, fight night, the Why).

- Home (agreed): needs first, the job, the next fight, one row per fighter, Since last Monday with causes, the club's week, what is coming; the week review folds in as a need that "sits here, never pops up"; the line
  under the big button names the next stop; the first-week guide card only in the first hour.
- Fighter Week (agreed): the whiteboard: sessions as magnets, the fight date circled, colour only means risk, one red button moves the week on; plan totals, fatigue, the goal line, the coach's one change with the effect on the
  button; Learn on the pads; ADD "Coach's pad nights" as the top row, two fighters in camp only, with the cost to the other fighter (R55).
- Boxing profile (agreed in shape; numbers superseded by the 10 attributes in section 3): tabs Overview, Week, Playbook, History on one portrait header; three columns Body, Skills, Mind with a style line ("Keeps it
  long"), one thing to work on and where it is trained; the sport switch only once she trains both; a rival gym's offer with its three answers (match it, promise something, let her go) as the top card when it
  comes (R58, needs the running world).
- Playbook (agreed): Moves (Escapes folded in), Game plan (lines drawn on a board, plays a default at once, rate against each kind of opponent), Combos; "No bout booked: try the plan against each kind of opponent".
- Fight night (agreed): dark and tight, handwritten coach notes, three fixes / time for two; stats cut to three rows in the minute; the "she has adapted" note (14 words at most) replaces the coach's note (R25); a
  cutman card only when an eye is closing (R28); the result with scorecards and the Why (plan, against you, next); the money lines move from the Why to Home; no "one change for next time" (the Why's NEXT carries it).
- Money (agreed): the gym's books on the whiteboard: cash, runway, in and out, bills, deals, repairs, upgrades; dues bands wait for the owner's call on the cut.
- World (agreed): News cut to only what touches you; Rankings with rivals that develop (movement arrows, Developing column); Championships; fixtures; no-gi "belt is the ladder".
- Other menus in the agreed map (not in the seven; final text per MENU_STRUCTURE_S402): Start (three starts, already in game); First week; Fighters (a real roster); Fights (Ask for a fight sits under
  the offers: level, date window, an answer with its reason; it waits for the bot test that a smart ask beats a plain one, R37); Fight prep ("What your plan should answer", no injury-risk lines on camp
  choices); Club > People (staff cards keep their faces; members panel cut); Grow (finding and signing only plus the pro offer; no prospect deadlines); Top bar (no change).
- Held back, do not build from an old mockup: one change after the Why, camp injury risk, scorecards after each round, members panel, prospect deadlines, sponsor line and per-fighter costs, the progress chart on History.
- Conditional elements and when each appears: Coach's pad nights (two fighters in camp, until a camp ends); Needs flag for the second camp (the second camp starts, until she opens the Week); Cutman card (an eye reaches
  the closing state at the bell); Adapted note (from round 2, when the opponent has answered one of your lines); Rival offer (the running world sends one; a flag only, answered or past its date); Ask for a fight
  (always, once a boxer is signed); Swing reason (a random roll moved a number you can see, scrolls off with the week).

## 7. The owner's standing rulings on screens (quoted or near-verbatim)

- Only actionable information: "i do not want stupid and unecessary information to be displayed unless the player can really do something about it". Cut it, hover it, or put the action on it.
- One top bar and modals; nothing opens by itself; moments come as flags on the top bar. A week review sits as a need on Home.
- No flavour text; plain words; one word per concept (Raw, Usable, Sharp, Signature everywhere). Hover explains every number.
- Not mobile: "thats not how sim/manager games look , its very simplestic no actual stats to make the player understand how good the fighter is". Real stats stay. Not an 80s spreadsheet; no placeholders.
- Do NOT judge against a generic management sim ("they seems like economic management simulator"). Judge fit to this game and its plan.
- Look B, the gym whiteboard: marker notes, polaroid, needs as sticky notes, the cash tin, the fight date circled; warm tan plaster wall, wood and aluminium frames, cream paper. ONE art style across menus
  ("no art consistency" was his complaint). Stylized comic portraits in menus are on and must match the fighter. Marker fonts Permanent Marker and Kalam.
- Screens come only from agreed mockups; nothing is built on a menu he has not OK'd. A generic Money page was reverted.
- Fight night goes dark and tight (the Miro "Corner minute"); the coach's notes stay handwritten.
- Everything new ships switched ON. Hover cards on top-bar date and cash. Animated meters (every bar tweens).
- Weekly job pages must not become a pop-up. One-click reach from anywhere. Two Point alignment is parked (the gym floor is out of the first release).
- No gym still with the Day Plan or a drawer open; stills of fights show both fighters head to feet; boxers wear boots (visual rules for pictures).
- Scouting means opponents; finding fighters is "Find a fighter". The facility is a "gym"; a fight camp is only pre-bout preparation. Fighters are fictional; organisations real-named only where legal.

## 8. Where the documents and the code differ, and what could not be established

Code wins. For the critic: do not judge a screen against these older statements.
- Autosave, Settings and Handbook: docs say "not built"; they are built (autosave every Monday).
- Pros have no offers/world after the debut (docs): the code has a pro ladder, promoter offers, asking, scouting, belts, ageing and retirement.
- Ask for a fight: docs say impossible; it exists for pros only. Amateurs cannot ask.
- Gym closes after 4 weeks below $0 (CLAUDE.md numbers) vs 8 weeks in code. Gym's share of a pro purse 35% (CLAUDE.md) vs 25% in code. A loss costs 3 members and 2 reputation (CLAUDE.md) vs 1 and 2 in code (stoppage 2 and 4).
- Ex-pro head-coach edge: design says one extra corner call; code gives one opponent tell on file at booking. Old hand: design "cheaper camps"; code: easier weight cuts.
- Roster limit "up to 8": code gives 3 places, +2 per premises tier, +1 per second coach (5 and 7 at the larger premises).
- Four rail buttons plus Playbook: the Playbook is reached from the fighter page, not the rail. Docs on Fights tabs are out of date (one page).
- "Coach runs it", year review and club goals, club tiers, rival gym, poaching, career clock: not in code. Overdraft has rules but no screen found. Keys 1-5 for the rail and highlights/full watch options: not found.
- NOT ESTABLISHED: the exact number of moves in the Playbook; whether the 3D corner's cutman choice offers "stop it / go on"; whether the week review ever opens without a press (the owner listed it as a defect on 2026-11-08);
  the owner's answer on an open-ended career and a roster of 8; whether R11 (readable reason for every swing) exists beyond the Why; crossover numbers between boxing and BJJ (left blank on purpose).

## Added S409
The building: chosen once at new career, one of four gym plans, each with one small permanent edge (5% more members, 5% more show income, 3% better power and technique training, or injured boxers back 10% sooner).
The gym on Home has people in it: the club's fighters and members, working at equipment and walking the floor. More members, more people (2 to 12). Decoration only: they take no clicks.

## Added S410
- The shell's top bar is dark on every game screen (5.0).
- Fighters > Roster (5.4) is now full-body cards on a painted gym: weight class and rank, a corner flag for the most urgent answer (Set camp, Offer, Weight, Mood low), Condition / Mood / Weight tiles, the next fight and days to it; a click opens the fighter's page. Under them, Scouted for you: up to four prospects, with Invite to a trial. A Cards / Table switch keeps the sortable table (Rank, The Road, Goal).
- Fights > a bout offer (5.6) opens as a versus screen: the two boxers on a red and a blue wall, the tale of the tape (record, age, weight on the day against the limit, height, stance), the win chance and how sure it is, what a win and a loss change, Full report / Pass / Accept. Full report is the old bout page: stats against the estimate, win band, ranks at stake, the file, the terms.
- The game does not hold a venue, last-five form or a fighter's reach, and there is no scouting before accepting an amateur offer.

## Added S448 (code check)
- The attributes in section 3 marked AGREED, NOT BUILT are in the code: `scripts/rules/Attrs.gd` holds the 14 abilities (Strength,
  Explosiveness, Speed, Stamina, Recovery, Flexibility, Durability, Fight IQ, Composure; skills Accuracy, Timing, Defence, Footwork,
  Inside fighting) plus Heart; the old seven (Power, Hand speed, Technique, Defence, Conditioning, Ring IQ, Chin) are kept as a summary
  read from them. Punches are moves with mastery. Our own fighters have no height or reach value yet (opponents do).
- The plan's step and defence answers are `StrikeMap` arrows: step in, step out, step back, cut off, herd, pivot out, push off, feint,
  tie up, roll out. BUILT since S463 (`StepMastery`): each of the 10 has its own mastery bar, given at signing from Footwork; a step fires by its
  bar like a punch (under Usable 30 the coach never plans it and it mostly fails). Training a step (S463, greybox): the fighter page's WHAT TO LEARN NEXT card puts ONE step or defence in the study slot; the week's pad nights raise
  it about 6 a week (step back 0 to 32 in about 5 weeks); at Usable 30 it leaves the slot. One slot only. NOT BUILT: nothing takes a step past 30
  (to Sharp 60), sparring gives a step nothing, and two steps cannot be learned at once.
- Coaches: Luke Reid pads 74 (rating 58), Marcus Hale pads 58 / conditioning 90 (rating 74).
- Units: the code counts a pad night as 240 drill units (PadWeek.PAD_NIGHT_MINUTES) for the 75 real minutes in 4.2; a sparring night shares 180
  units over the moves on the fighter's cards and plan. Mastery maths uses the units.

## Added S451 (code check; where this and an older line above disagree, this wins)
- FireLevel is ON since S450: a planned line fires 1 use in 2 at Usable, 3 in 4 at Sharp, always at Signature. The line in 4.2 that says
  "SWITCHED OFF" is out of date.
- Our own fighters now have height and reach, and the fight reads them (S450). The S448 line saying they have none is out of date.
- Phases come from any booked bout, camp or no camp: a bout 1 week out makes the week TAPER (WeekPhase.phase), also for an amateur bout.
- Two rest rules after a stoppage loss, both in code: the 30-day suspension (Injuries) and the next bout offered 8 weeks later than usual
  (Matchmaking.STOP_REST_WEEKS).
- The office is a full-screen computer desktop (owner's Q-213 "A, full screen", S451): the gym's office pin opens it. Its Desktop shows what
  needs you, the next four weeks (bouts, bills, dues), mail, the fighters with each one's flag, money 8 weeks ahead and the staff. Its other
  apps (Mail, Schedule, Fighters, Staff, Finance, Records) are AGREED, NOT BUILT; today they lead to the existing pages.

SANDBOX (S412): the player runs any gym with any boxers, men or women. Never write about one boxer as the story, and never a fixed he or she in text or mockups.

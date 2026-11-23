# The card game - the whole scope (CARDSCOPE1 to 5, S537 to S539)

**[R5] Status after round 5 (CARDSCOPE5, S539): every art's own mechanic now decides the line and the hold reads
true, but the table and two other clauses fail; verdict FAIL (4 of 7 core bars).** Seven arts now (the owner added
kickboxing in S538). Each art's mechanic became a rule about what is *playable* (section 3T), and switching it off now
changes the pilot's turn in 57 to 96% of turns for every art (round 4: 0 to 43%). The hold's printed rule is now the
best answer in 100% of 6,494 held turns (round 4: 48.9%): a submission has a printed price that rises a turn, a pin
has no price at all (only the Escape card). Measured once on fresh seeds (section 6e): a bout is 24.7 decisions = 3.3
minutes; knockouts end 22.6%, points leads 19.6%, holds 15.6%. **Failing:** the style table (19 of 21 pairings inside
40 to 60; kickboxing beats BJJ 64.8, loses to sambo 38.5; BJJ averages 46.6), the blind judge (48.5% on round 4's
instrument, 89.0% at its best reading, bar 90) and one clause of the clocks bar. **No critic is queued: the brief asks
for one only on a pass.** Read 3T, 6e and 8 for the current design; the picture of one turn is
`proto/cardscope5/turn_mock.png`.

**[R4] Status after round 4 (CARDSCOPE4, S538): six martial arts on one strip; the style table balances, two core bars
fail, verdict FAIL (5 of 7 core bars, P3 decided).** The rally now runs on a four-range strip (KICK - PUNCH - CLINCH -
GROUND) with boxing, karate, judo, wrestling, BJJ and sambo, three ways to win (knockout, a points lead of 8, a hold)
and one AI pilot that flies any deck. Measured on fresh seeds (section 6d): every one of the 15 style pairings is inside
41 to 59; a bout is 24.7 decisions = 3.3 minutes; knockouts end 18%, points leads 16%, holds 24%, the cards 42%; the
impatient beginner wins 35%; the cheap decks that broke round 3 win 19 to 25%. **The owner's limb points were probed
first and lose to the single wind pool on every clause** (6d). Failing: P6 (four of the six styles' own mechanics change
what a card does, not which card is right) and P5's first clause (the hold's printed rule tells you to Make room at
once; the right play waits for the last tick). **No critic is queued: the brief asks for one only when the core bars
pass.** Read 3S, 4d, 6d and 8 for the current design; the picture of one turn is `proto/cardscope4/turn_mock.png`.

**[R3] Status after round 3: the form changed, and the fight is now right in the places round 2 was wrong; 18 of 24
core bars pass, verdict still FAIL.** The owner's interview (fast and punchy, about 5 minutes, every number shown,
standalone; `OWNER_CARDGAME_INTERVIEW_S537.md`) outranks the critics, so round 3 dropped the three-beat exchange for
**the rally** (section 2b, design in 3R): he throws face up, you answer with one guard and throw back, one card at a
time, one face-down trap each. Measured (section 6c): a bout is 37 decisions = 5.0 minutes; a boxer who never guards
wins 2% (round 2: guards were worth nothing); the table player, who only reads the printed numbers, wins 47% where the
best bot wins 59%; the two chairs are level (53%); no card pair is a key (+11, was +51). Still failing: the rule-of-thumb
beginner at regional class (20%, bar 25 to 40; it was 4%), a thin deck of cheap punches in the pro debut (68%), card
matchups, and three bars missed by a hair. **Read 2b, 3R, 4c, 6c and 8 for the current design; sections 3, 6 and 6b are
the record of rounds 1 and 2.**

Owner S537: "it can be any variation of a card game as long it can reach 10/10". This page is the design the card game
is built from. It replaces the patch loop on `proto/cardgame` (four rounds, stuck at 4-5 out of 10). Nothing here is built
yet except the bot probe in `proto/cardscope/` (result: `docs/CARDSCOPE1_PROBE.md`).

**Status after round 2 (kept for the record): probed twice, not yet passed.** Round 1 (he always led, better on paper): 6 of 7 core bars, critic 6 / 5 / 6.
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

### 2b. Round 3: the form changes to Form E, the rally **[R3]**

**Why change the form at all.** The owner's interview (S537, `OWNER_CARDGAME_INTERVIEW_S537.md`) came after Form D was
picked: *fast and punchy* (chosen over "chess-like reading" and "tense gamble"), a bout of about 5 minutes, every number
shown, standalone. Form D is a three-beat puzzle with a blind bet in it, 112 legal answers an exchange: the opposite
feel. And round 2 found its fault is structural: both cards on a beat land, so the boxer who sees answers a punch with a
faster punch, and a guard is never the best card.

**What his reference games do** (store pages, reviews and play knowledge; our words; where a rule could not be
confirmed it is left out):

| His game | What its turn is | What we take |
|---|---|---|
| Hearthstone | Players take turns; several cheap cards a turn from a small energy pool; the board is open, the hand hidden; "secrets" are face-down cards that fire when the other player does one named thing. | Take turns. Open table, hidden hand. The face-down trap that fires on one named action, and the skill of playing round it. |
| Kungfu Card (the kung fu card game) | Each clash one side attacks and the other defends; the defender sees the attack and answers it; a pattern in the cards laid steals the initiative. | The defender answers a punch he can see. A good answer takes the initiative (our counter). |
| Mixed Martial Cards | Stamina and a short hand; defence cards are dodge, slip, block and counter; an attack can hide what it really is. Matches of 20 minutes and more. | Guards as cards, each for one kind of attack. Not the length. |
| MMA Arena | A fight deck built from a large pool of moves, turn by turn up a league ladder. Mixed reviews. | A deck of moves is not enough by itself: the turn has to be a decision. |
| Clutchtime | Every action of the sport is a card; a set stamina a turn; cheap cards feed bigger ones (pass, then shoot); the game ends on the clock. | A set wind a turn; the cheap card that sets up the dear one (jab, then cross); rounds that end by themselves. |
| Ironbound | A duel of 5 to 10 minutes in turns. | The size of a bout. |
| Rune Coliseum | Both sides queue actions and they clash. | Rejected for us: a queue laid blind is Form A again (measured: a guess or a lookup). |
| Breachway, Starless Abyss, Monster Train | You see what the enemy will do, then spend a small energy pool on cards; the build is the long game. | Show the threat, hide the draw. The run between bouts. |

Six of his ten show the threat before you answer it, two are duels in turns with an open table, none is a three-beat
programme. **Form E is the shape they share, cut to a boxing exchange:**

*One bout:* three rounds, three turns each. On your turn you first **answer** the punches he threw at you last turn,
all face up: one guard on one of them, or take them. They land or miss at once. Then you **throw** your own punches,
face up, and may set **one trap** face down. He does the same. So your answer and your attack are one turn, one
card at a time, and every punch on the table is seen before it lands.
*The player decides:* which of his punches to stop with the one guard (the jab that opens the chain, or the cross
behind it), how much wind goes into the volley and in what order, which punch leads into his face-down card, and what
trap to leave for him.
*Where skill shows:* the order of a volley, what he can still hold (the table counts it), his habits with the trap,
wind kept for the turn that matters, the judges at the bell.
*Why a guard is worth a card here, by rule:* a punch does not stop a punch. If you only hit back, everything he threw
lands. The guard is played against a punch you can see, so it never misses.
*Risk:* with everything seen it could be a sum with one answer. Measured in section 6c.

**The pick: Form E.** It keeps what the two probed rounds proved (show the threat; no dice; a scarce wind; three
judges; a trap that punishes one kind of punch) and drops what they proved wrong (beats that trade; a bet inside every
exchange; a lead that is only a chore). It is also the only form here where a bout is 30 to 35 small decisions.

---

## 3R. The round 3 design: the rally **[R3]** (this replaces 3.1 to 3.6b and 3.9; 3.7 and 3.8 stand, the link is no longer a phase)

**A bout** is 3 rounds (the pro debut 4). **A round** is three turns each, taken in turn, then a last answer at the
bell for the boxer who threw first. A coin decides who throws first in round 1; it changes hands every round.

**A turn:**
1. **Wind comes back** (3, to a top of 6; what you did not spend is kept). Draw up to five cards.
2. **Answer.** His volley lies face up in the order he threw it. Play **one guard** on one punch (a Parry on a jab is
   free of that limit), or Tie up, or nothing. The volley lands at once, in order.
3. **Throw.** Play punches one at a time, as many as wind and hand allow. They lie face up in front of him until his
   turn. You may set **one trap** face down. End the turn.

**What a guard does** (the whole table):

| Guard | Wind | Against | Result |
|---|---|---|---|
| Block | 1 | any punch | stops 4 of it (1 of an uppercut); what is left lands but is not a clean punch |
| Slip | 2 | jab, body jab, cross, uppercut | it misses; your first punch this turn is a counter (+3) |
| Roll | 2 | lead hook, body hook, uppercut | it misses; your first punch this turn is a counter (+3) |
| Parry | 1 (run 1: free) | jab, body jab | it misses; does not use up your one guard |
| Tie up | 4 (run 1: 2) | the whole volley, once a round | every punch does half and none is clean |

**The volley.** A punch that lands clean makes the next punch of the same volley do +2. A stopped punch breaks that
chain, so the one guard is a real choice: stop the jab and the cross behind it is 6, not 8; stop the cross and the jab
still opens for the hook. There is no accuracy roll and no damage roll.

**The trap** (one face-down slot each). A trap is free to set and watches for one kind of **lead** punch, the first of
his volley: Check hook for a jab or body jab, Cross counter for a cross or uppercut, Pull counter for a hook. If he
leads with that, his punch misses and he takes 8 clean (run 1: 6). If he leads with anything else it comes back to your hand at
your next turn, unseen. So a set card asks one question, fast: *what do I lead with?* What he can hold is printed (his
deck list less what has been played), and his habits say which.

**Wind, damage, knockdowns.**
- The boxer who throws first in a round gets 1 wind less back on that first turn (he is feeling him out; run 1: 2
  less), and nobody gets wind back for the answer at the bell. Without these two rules the first thrower won 60%.
- Head 68 to 75 points by boxer; *hurt* at 42 taken. Body punches go to the body: every 8 body damage is 1 wind less
  back for the rest of the bout, and a body hook that lands clean takes 1 wind out of his next turn.
- **Knockdown:** 18 head damage from one volley (14 when hurt; run 1: 16 and 12). He is down: the round is 10-8, he throws nothing that
  turn and gets 2 wind less back next turn. Three knockdowns or a full head track stop the bout.

**The judges** stand as in 3.3: three judges, each counts clean punches (2 points), plus one taste each (work: half a
point a punch thrown; hurt: a point for every 5 damage; craft: a point for every punch stopped and every trap sprung).

**The corner** stands as in 3.6: water (full wind), ice (14 head points back), watch him (his traps lie face up next
round). Not yet a decision in this form: water is right three times in four (6c).

**The cards** (fourteen):

| Card | Wind | Does | Its job |
|---|---|---|---|
| Jab | 1 | 2 head | Opens the chain; the cheap lead into a set card (unless it is the Check hook) |
| Body jab | 1 | 2 body | The same to the body: toward his wind |
| Cross | 2 | 6 head | The money punch behind the jab |
| Lead hook | 2 | 6 head | The same with the other shape: gets past a Slip |
| Body hook | 2 | 4 body, takes 1 wind from his next turn | The investment |
| Uppercut | 3 | 9 head; a Block stops only 1; either Slip or Roll beats it | Beats the blocker, loses to the mover |
| Block, Slip, Roll, Parry, Tie up | 1, 2, 2, 1, 4 | as the guard table | One answer a turn |
| Check hook, Cross counter, Pull counter | 0 | as the trap rule | The one hidden card |

**Deck rules.** 12 to 16 cards, at most 4 of a card, **at most 2 of each trap**.

**His habits.** Each opponent has two, each a thing you can see and the trap that follows: O-out *after your jab, the
Check hook* / *after your cross, the Cross counter*; O-press *after your hook, the Pull counter* / *after a quiet turn
of yours, the Cross counter*; O-counter *after your cross, the Cross counter* / *after your hook, the Pull counter*;
O-volume *after your jab, the Check hook* / *after a quiet turn, nothing*. He keeps a habit 90 times in 100; if he
does not hold that trap he sets none.

**The classes** (equal paper to regional, as round 2): novice plays loose (two turns in three at random) and sets no
trap; open class is still loose (38 in 100) and sets traps; regional is tidy, counts what you hold and reads what you
lead with; title: top wind +1; professional: top wind +1, heavier hands, four rounds.

**The table shows every number** (owner: "show me everything"). Under each of his punches: what it will do to you as
things stand, and what it does under each guard in your hand. Under your volley: what each punch does if he stands
still, the chain marked. Beside his set card: which traps he can still hold, and "usually: Check hook" when a known
habit applies. Wind as pips, the three judges as three scales, the knockdown line as a mark on the damage of the
volley in front of you. The "table player" bot (section 4c) plays from these printed numbers alone.

---

## 3S. The round 4 design: the rally on a strip, six martial arts **[R4]** (greybox `proto/cardscope4/`; replaces 3R's boxing-only table, keeps its turn)

Follows `OWNER_CARDGAME_INTERVIEW_S537.md` (fast and punchy, every number shown, six martial arts, his "maybe" on limb
points) and `CARDREF2_MARTIAL_ARTS.md` sections 3b, 6 and 7. One picture of a turn with every number:
`proto/cardscope4/turn_mock.png` (a mockup, not a build).

**The board.** One strip, one marker: **KICK - PUNCH - CLINCH - GROUND**. On the ground a ladder of four rungs for the
man on top: guard, half guard, side pin, mount or back. Every card prints where it can be played and where it sends
the bout. Every round starts at KICK. A ground phase where the man on top lays no attack for a turn is stood up by the
referee.

**The turn (round 3's rally, kept).** He threw his cards at you face up. You pick **one answer** (a card, or Cover up
which is always there: 1 wind, 2 off one strike) or take it; his cards then land in order. Then you lay your own volley
face up, one card or step at a time, paid in wind; it lands on his turn. Nothing is rolled. A card that is no longer
legal when it lands (you stopped his entry, the range changed) misses. **Steps** (in, out) are laid like cards and cost
no wind after sizing; Let him up costs 2, Get up from underneath 3.

**Hand and deck.** A deck is exactly 15: 12 cards of your art (at most 3 of one) + 2 Sprawl + 1 Escape. You draw a
fresh hand of 5 every turn; the pile is open. Wind: start 4, 3 back a turn, most 6, 2 at the stool. Two rounds of five
turns each.

**Three clocks, all on screen.** *Health* 30, 0 = knockout. *Points*: clean scoring strikes, takedowns, throws,
passes and pins; a lead of 8 ends it. *The hold*: a submission or pin goes on as a countdown of 1 to 3 of the held
fighter's turns; at 0 it is the tap (the bout) or the pin (its points, then both stand). At the last bell the cards
decide: points + damage dealt / 3.

**The hold as a race both can read.** The held fighter keeps the hand he has (no new hand while held). His ways out:
the **Escape** card if he holds it (1 wind); **Make room** once a hold (3 wind): this tick does not count and he draws
2 new cards. The holder pays to squeeze each turn (2 wind, then 3, then 4) or lets go. Because the pile is open, the
holder can see when the other man's one Escape is already gone: that is the moment to go for the hold, and using your
Escape to stand up costs you your safety.

**The six styles: a small own pool and one own mechanic each** (12 cards on the shared core; MMA is the ruleset where
they meet, not a seventh pool).

| Style | Owns | Wins by | Its own mechanic (switchable in the greybox) |
|---|---|---|---|
| Boxing | PUNCH | knockout | **combinations**: the jab steps in from KICK by itself; every clean punch behind another +1; jab, cross, hook clean in order = +5 damage and 3 points |
| Karate | KICK | points (kicks score 1 / 2 / 3 as in WKF) | **in-and-out**: the reverse punch blitzes from KICK, and a karate volley that is not stopped ends back at KICK |
| Judo | CLINCH | the big throw (6 points behind a grip), the pin | **the grip**: laid face up this turn, it pulls him into the CLINCH, he cannot step out, and next turn's throw cannot be stopped |
| Wrestling | where the bout is | takedown points, ground strikes, the fall | **the tie-up read**: laid this turn; if he punches into it the Double leg is clean next turn, if he stays quiet the Single leg is |
| BJJ | GROUND, top and underneath | the tap | **chains**: a hold he escapes makes your next hold free, from anywhere on the ground |
| Sambo | throw, then a leg | leg locks from any rung | **throw-to-lock**: the turn after a scored throw (or a caught kick) the leg lock costs nothing |

**Answers are the matchups.** Block and Cover up stop strikes; Slip a punch (and your next punch +4); Step off a strike
or a grip (and you are back at KICK); Tie in turns his strike into the CLINCH; Sprawl and Front headlock stop a
takedown, grip or tie-up that is not clean; Catch the kick takes a kicker down; Escape ends a hold.

**The cards as sized** (`node proto/cardscope4/report.mjs`; rungs 0 to 3 = guard to mount; "top1" = on top at half
guard or better, "under0" = underneath in guard):

| Style | Card | In deck | Wind | Where | What it does |
|---|---|---|---|---|---|
| boxing | Jab | 3 | 1 | PUNCH | 2 damage, steps in from KICK |
| boxing | Cross | 2 | 2 | PUNCH | 4 damage |
| boxing | Lead hook | 2 | 2 | PUNCH CLINCH | 5 damage, 1 pt |
| boxing | Body hook | 1 | 3 | PUNCH CLINCH | 4 damage, takes 1 wind |
| boxing | Uppercut | 1 | 3 | PUNCH CLINCH | 6 damage, cannot be blocked |
| boxing | Slip | 1 | 1 | answer | a punch: it misses, your next punch +4 |
| boxing | Block | 2 | 1 | answer | a strike: 6 off |
| karate | Front kick | 2 | 2 | KICK | 2 damage, 1 pt, a kick |
| karate | Roundhouse | 2 | 2 | KICK | 5 damage, 2 pt, a kick |
| karate | Head kick | 2 | 3 | KICK | 6 damage, 3 pt, a kick, takes 1 wind |
| karate | Leg kick | 2 | 1 | KICK PUNCH | 1 damage, a kick, hurts the leg (1 wind) |
| karate | Reverse punch | 2 | 2 | PUNCH | 4 damage, 1 pt, blitz from KICK |
| karate | Step off | 2 | 2 | answer | a strike, a grip or a tie-up: it misses and you are back at KICK |
| judo | Grip | 2 | 1 | PUNCH CLINCH | set-up: next turn's throw or shot is clean |
| judo | Hip throw | 2 | 2 | CLINCH | takedown to rung 2, 2 pt (+2 behind a grip), 5 damage, clean if grip |
| judo | Foot sweep | 2 | 1 | CLINCH | takedown to rung 1, 2 pt, clean if grip |
| judo | Shoulder throw | 1 | 2 | CLINCH | takedown to rung 2, 6 pt, 5 damage, needs the grip |
| judo | Hold-down | 2 | 1 | top2 top3 | pin (+2 pt), countdown 2 |
| judo | Armlock | 2 | 3 | top2 top3 | submission, countdown 3 |
| judo | Tie in | 1 | 2 | answer | a strike: 1 off and you are in the CLINCH |
| wrestling | Tie-up | 2 | 1 | PUNCH CLINCH | set-up: next turn's throw or shot is clean |
| wrestling | Double leg | 2 | 2 | PUNCH CLINCH | takedown to rung 1, 2 pt, clean if struck |
| wrestling | Single leg | 2 | 2 | PUNCH CLINCH | takedown to rung 1, 2 pt, clean if quiet |
| wrestling | Body lock slam | 1 | 3 | CLINCH | takedown to rung 2, 3 pt, 5 damage |
| wrestling | Ground strikes | 2 | 2 | top | 6 damage, 1 pt |
| wrestling | The fall | 1 | 3 | top1 top2 top3 | pin (+4 pt), countdown 2 |
| wrestling | Ride | 1 | 1 | top | up one rung, 1 pt |
| wrestling | Front headlock | 1 | 2 | answer | a takedown, a grip or a tie-up, and 1 point |
| bjj | Guard pull | 2 | 3 | PUNCH CLINCH | to the ground, you underneath in guard |
| bjj | Sweep | 2 | 1 | under0 under1 | takedown to rung 1, 2 pt |
| bjj | Guard pass | 2 | 2 | top0 top1 top2 | up one rung, 3 pt |
| bjj | Triangle | 2 | 2 | under0 | submission, countdown 3 |
| bjj | Armbar | 2 | 1 | under0 top2 top3 | submission, countdown 1 |
| bjj | Rear choke | 1 | 2 | top3 | submission, countdown 1 |
| bjj | Kimura | 1 | 2 | under1 top1 top2 | submission, countdown 1 |
| sambo | Sambo throw | 2 | 2 | PUNCH CLINCH | takedown to rung 0, 3 pt, 1 damage |
| sambo | Leg trip | 2 | 2 | PUNCH CLINCH | takedown to rung 0, 1 pt |
| sambo | Knee bar | 2 | 2 | GROUND | submission, countdown 2 |
| sambo | Ankle lock | 2 | 3 | GROUND | submission, countdown 3 |
| sambo | Chest hold | 1 | 1 | top | pin (+2 pt), countdown 1 |
| sambo | Overhand | 2 | 3 | PUNCH | 6 damage |
| sambo | Catch the kick | 1 | 1 | answer | a kick: it misses and he is taken down |
| every deck | Sprawl | 2 | 1 | answer | a takedown, a grip or a tie-up |
| every deck | Escape | 1 | 1 | answer | a hold or a pass; played in your turn: stand up |

**What round 4 cut from round 3, and why.** The face-down trap slot (it was a burden to its own deck in 6c; the grip
and the tie-up are set-ups laid face up that do its job). The three judges, knockdowns and the corner minute (three
clocks replace them; a corner plan can come back as a later phase). The body track (one "takes 1 wind" mark on four
cards instead). Limb points (probed, 6d). Three rounds became two of five turns: the bout must fit 5 minutes with four
ranges to cross.

**For the later asks.** The AI pilot (`plan.mjs`, public information only: his open pile, the table) flies all six
decks and beats each style's hand-written script (P10), so it can be the opponents and the ghost of another player's
deck. A deck is a style name + 15 card ids: a file of under 300 bytes. Asynchronous battles stay a later layer.

---

## 3T. The round 5 design: what each art may play **[R5]** (greybox `proto/cardscope5/`; changes 3S's mechanics, hold and card table, keeps its board, turn and clocks)

Follows round 4's finding (6d): four of the six mechanics changed what a card *does*, not which card is *right*. In
round 5 every mechanic is a rule about **where a card may be played or what must come before it**, so the same hand
plays differently in each art. Each can be switched off in the greybox (the deck then follows the plain rules: a card
only at its printed range, a hold only a turn after the takedown). One picture of a turn: `proto/cardscope5/turn_mock.png`
(a mockup, not a build).

**Seven arts** (owner S538 added kickboxing: it stands and trades, no takedowns, no ground cards).

| Art | Its place | Its own mechanic: what it lets him play | Without it |
|---|---|---|---|
| Boxing | PUNCH, and inside | **Combinations.** The jab steps in from KICK by itself. A punch laid right behind a punch costs 1 wind less. The short punches (hook, body hook, uppercut) also work in the CLINCH. Jab, cross, hook clean in order: +7 damage, +2 points | every punch needs PUNCH range and its full price |
| Kickboxing | KICK to CLINCH, on his feet | **Hands and feet.** His kicks also land from PUNCH range. A strike of another kind than his last (kick, punch, knee) costs 1 less and goes to its own range by itself: a punch behind a kick steps in, the knee behind a punch takes the CLINCH, a punch behind the knee pushes off to PUNCH | kicks need KICK, the knee needs the CLINCH, each move between is a paid step |
| Karate | KICK | **In-and-out.** The reverse punch blitzes in from KICK (1 less) and he is back out; his kicks also land from PUNCH range and spring back to KICK; a volley that is not stopped ends at KICK; a grip does not hold him | he must step in to punch and step out again |
| Judo | CLINCH | **The grip.** No throw without it. The grip pulls the other man into the CLINCH; he cannot step out and cannot shoot or throw. A grip that has stood a turn makes the throw unstoppable | throws go from the CLINCH with no grip and can always be stopped |
| Wrestling | wherever the bout is, then on top | **Chain wrestling and the ride.** His shot travels from any standing range. A stuffed shot leaves him tied up in the CLINCH and his next shot cannot be stopped. Under him, Get up wins back one rung a turn (under anybody else two) | a takedown needs the CLINCH; a stuffed shot is just lost |
| BJJ | GROUND, underneath | **The guard.** Pull guard is his own step from any standing range (2 wind). His holds and sweeps work from underneath, and at once behind the pull | nothing works from underneath; he needs a takedown he does not own |
| Sambo | PUNCH to a leg | **Punch, throw, lock.** His throw also goes from PUNCH range; laid right behind his own punch it cannot be stopped; a lock may be laid in the same volley behind the throw; his leg locks go on from any place on the ground, on top or underneath | throw from the CLINCH only, the lock waits a turn and needs a settled top position |

**The hold, as printed on the table (replaces 3S's "Make room" and "squeeze").** While held you keep your hand and get
2 wind a turn instead of 3. **The rule: Escape if you hold it; else break free the first turn you can pay; else hang
on.**
- A **submission** prints its price (3 to 6 wind) and its countdown (1 to 3 of your turns). The price goes up 1 every
  turn you stay in, so the first turn you can pay is the cheapest. Countdown at 0 = the tap, the bout.
- A **pin** has no price: wind does not buy the way out, only the Escape card does. It scores at the top of every turn
  it is on (1 or 2 points) and again when its countdown ends (+2 or +3); then both stand in the CLINCH, where an escape
  also leaves them.
- So the two holds ask different things of the man on top: a submission races the other man's **wind** (go for it when
  he is spent), a pin is sure points against his one **Escape** (go for it when the open pile shows it gone). That is
  the pin's reason to be taken: in round 4 it ended 0.9% of bouts, here 4.0%.

**Other rules as they now stand.** Health 37. A step in or out costs 1 wind (round 4: free); Let him up 1, Get up 2.
Cover up 1 wind, 2 off one strike. A ground phase where the man on top lays no attack is stood up after one turn. At
the last bell: points + damage dealt / 8. A deck is 15: 12 of your art + 2 Sprawl + 1 Escape; a new hand of 5 every
turn; wind 4 at the start, 3 back a turn, most 6, 2 at the stool; two rounds of five turns.

**The cards as sized** (`node proto/cardscope5/report.mjs`; rungs 0 to 3 = guard, half guard, side pin, mount or back;
"top1" = on top at half guard or better, "under0" = underneath in guard; "Where" is the printed range, the mechanic's
wider range is in the last column):

| Style | Card | In deck | Wind | Where | What it does |
|---|---|---|---|---|---|
| boxing | Jab | 3 | 1 | PUNCH | 2 damage, steps in from KICK |
| boxing | Cross | 3 | 2 | PUNCH | 4 damage, 1 pt |
| boxing | Lead hook | 2 | 2 | PUNCH | 5 damage, 1 pt, boxing: also inside, in the CLINCH |
| boxing | Body hook | 1 | 3 | PUNCH | 1 damage, takes 1 wind, boxing: also inside, in the CLINCH |
| boxing | Uppercut | 1 | 3 | PUNCH | 6 damage, 1 pt, boxing: also inside, in the CLINCH, cannot be blocked |
| boxing | Slip | 1 | 3 | answer | a punch: it misses, your next punch +1 |
| boxing | Block | 1 | 1 | answer | a strike: 4 off |
| kickboxing | One-two | 2 | 2 | PUNCH | 6 damage, 2 pt, kickboxing: behind a kick it steps in, behind the knee it pushes off to PUNCH |
| kickboxing | Left hook | 2 | 2 | PUNCH | 3 damage, kickboxing: behind a kick it steps in, behind the knee it pushes off to PUNCH |
| kickboxing | Low kick | 2 | 1 | KICK PUNCH | 1 damage, a kick (karate, kickboxing: also from PUNCH), hurts the leg (1 wind, his steps +1 that turn) |
| kickboxing | Body kick | 2 | 2 | KICK | 5 damage, 2 pt, a kick (karate, kickboxing: also from PUNCH) |
| kickboxing | High kick | 1 | 3 | KICK | 7 damage, 2 pt, a kick (karate, kickboxing: also from PUNCH) |
| kickboxing | Knee | 2 | 2 | CLINCH | 1 damage, 2 pt, kickboxing: behind a punch it takes the CLINCH by itself |
| kickboxing | Check | 1 | 2 | answer | a kick: it misses, your next strike +1 |
| karate | Front kick | 3 | 3 | KICK | 1 damage, 1 pt, a kick (karate, kickboxing: also from PUNCH) |
| karate | Roundhouse | 2 | 2 | KICK | 4 damage, 2 pt, a kick (karate, kickboxing: also from PUNCH) |
| karate | Head kick | 1 | 3 | KICK | 5 damage, 3 pt, a kick (karate, kickboxing: also from PUNCH), takes 1 wind |
| karate | Leg kick | 1 | 2 | KICK PUNCH | 1 damage, a kick (karate, kickboxing: also from PUNCH), hurts the leg (1 wind, his steps +1 that turn) |
| karate | Reverse punch | 3 | 2 | PUNCH | 4 damage, 1 pt, karate: blitz from KICK and back out |
| karate | Step off | 2 | 2 | answer | a strike, or a takedown that is not clean: it misses and you are back at KICK |
| judo | Grip | 3 | 1 | PUNCH CLINCH | pulls him into the CLINCH, he cannot step out; throws need it; stood a turn = the throw cannot be stopped |
| judo | Hip throw | 2 | 2 | CLINCH | takedown to rung 3, 2 pt, 4 damage, needs the grip |
| judo | Foot sweep | 2 | 1 | CLINCH | takedown to rung 3, 2 pt, needs the grip |
| judo | Shoulder throw | 1 | 1 | CLINCH | takedown to rung 3, 5 pt, 5 damage, needs the grip |
| judo | Hold-down | 2 | 1 | top1 top2 top3 | pin (2 pt at the top of every turn, +3 at the end), countdown 1, no price: only the Escape card gets out |
| judo | Armlock | 1 | 3 | top2 top3 | submission, countdown 2, break free 5 wind (+1 a turn) |
| judo | Tie in | 1 | 3 | answer | a strike: 4 off and you are in the CLINCH |
| wrestling | Double leg | 2 | 2 | CLINCH | takedown to rung 1, 2 pt, wrestling: from any standing range; cannot be stopped behind a stuffed shot |
| wrestling | Single leg | 2 | 1 | CLINCH | takedown to rung 0, 2 pt, wrestling: from any standing range; cannot be stopped behind a stuffed shot |
| wrestling | Body lock slam | 1 | 3 | CLINCH | takedown to rung 0, 3 pt, 2 damage, wrestling: from any standing range; cannot be stopped behind a stuffed shot |
| wrestling | Ground strikes | 3 | 1 | top | 5 damage, 1 pt |
| wrestling | The fall | 1 | 2 | top1 top2 top3 | pin (1 pt at the top of every turn, +2 at the end), countdown 1, no price: only the Escape card gets out |
| wrestling | Ride | 1 | 1 | top | up one rung, 0 pt |
| wrestling | Front headlock | 2 | 2 | answer | a takedown that is not clean: it is stuffed |
| bjj | Sweep | 2 | 2 | under0 under1 | takedown to rung 1, 2 pt, from underneath (BJJ only) |
| bjj | Guard pass | 3 | 1 | top0 top1 top2 | up one rung, 3 pt |
| bjj | Triangle | 2 | 2 | under0 | submission, countdown 3, break free 3 wind (+1 a turn) |
| bjj | Armbar | 2 | 3 | under0 top2 top3 | submission, countdown 1, break free 6 wind (+1 a turn) |
| bjj | Rear choke | 1 | 3 | top3 | submission, countdown 1, break free 6 wind (+1 a turn) |
| bjj | Kimura | 2 | 3 | under1 top1 top2 | submission, countdown 2, break free 3 wind (+1 a turn) |
| sambo | Sambo throw | 2 | 2 | CLINCH | takedown to rung 0, 3 pt, 1 damage, sambo: also from PUNCH; right behind his own punch it cannot be stopped; a lock may follow in the same volley |
| sambo | Leg trip | 2 | 2 | CLINCH | takedown to rung 1, 1 pt, sambo: also from PUNCH; right behind his own punch it cannot be stopped; a lock may follow in the same volley |
| sambo | Knee bar | 2 | 2 | GROUND | submission, countdown 2, break free 3 wind (+1 a turn), sambo: from any place on the ground |
| sambo | Ankle lock | 1 | 3 | GROUND | submission, countdown 3, break free 6 wind (+1 a turn), sambo: from any place on the ground |
| sambo | Chest hold | 1 | 3 | top | pin (1 pt at the top of every turn, +2 at the end), countdown 1, no price: only the Escape card gets out |
| sambo | Overhand | 3 | 1 | PUNCH | 4 damage, 1 pt |
| sambo | Catch the kick | 1 | 2 | answer | a kick: it misses and he is taken down, 1 pt |
| every deck | Sprawl | 2 | 1 | answer | a takedown or a grip |
| every deck | Escape | 1 | 1 | answer | a hold or a pass as it is laid; played in your turn: stand up |

**What round 5 cut or replaced, and why.**
- **The Tie-up card and the tie-up read** (wrestling): the read asked the other man a question he never had to answer.
  Chain wrestling replaces it: the stuffed shot itself is the set-up.
- **The Guard pull card and BJJ's "chains"** (a free next hold): the pull is now a step he always has, so a BJJ hand is
  never dead on the feet; the free hold changed nothing (5.2% in round 4).
- **Sambo's free lock the turn after a throw** (0.0% in round 4): he laid the lock free or not. Now the lock goes on in
  the volley of the throw, which nobody else may do.
- **Make room and the squeeze price** (the hold): two extra sums on a turn that should be one glance. One printed price
  that rises replaces both.
- **Every "+1" mechanic** (boxing's +1 a chained punch, judo's +2 points behind a grip): numbers on the same card, not
  a different card.
- Kept from round 4 unchanged: the strip, one answer a turn, face-up volleys, three clocks, the wind pool (limb points
  stay out, 6d), the open pile, the fixed 15.

---

## 3. The round 1 and 2 design (Form D; kept for the record, replaced by 3R)

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

### 4c. Round 3 bars (CARDSCOPE3; written and committed before any round 3 code ran, not loosened afterwards) **[R3]**

Round 3 changes the form (section 2b: the rally; one card at a time, every punch thrown face up, the answer to his
punches and your own attack are the same turn, one face-down trap slot). The owner's interview outranks the critics:
fast and punchy, a bout of about 5 minutes, every number shown. The words the bars need:

- **A turn**: first you answer the punches he threw at you (a guard on any of them, or take it), they land or miss at
  once, then you throw your own and may set one trap face down. **A volley**: the punches one boxer throws in one turn.
- **A set card**: the one trap a boxer may have face down. It catches one kind of punch (the jab; the cross and the
  uppercut; the hooks) and is gone at his next turn if nothing walked onto it.
- **A decision**: one card played (a guard, a punch, a trap set), one turn ended, one corner pick. 8 seconds each.

Bots in the player's chair: **random**; **fixed line** (a fixed order of card names played top down every turn while
wind lasts, guards on the biggest punch they stop; the best of 400 searched orders and re-measured on fresh seeds);
**greedy** (most damage thrown less damage taken this turn; no judges, no wind plan, blind to set cards); **beginner**
(the rule of thumb: guard what you see with the right guard, biggest punch first, then jab, cross, hook with what is
left; sets nothing, ignores his set card); **table player** (one card at a time, keeps whatever the printed numbers like
best: damage both ways if he stands still, the judges' counts, the middle of the printed range for his set card, the
printed share of his turns with each punch; no memory, no plan); **reader** (public information only: what guards and
traps he can still hold, his habits, the judges, wind kept for later); **all-seeing** (the reader shown his set card and
his hand: a ceiling). Population as in section 4: 4 player boxers x 4 opponents, all different; regional class
unless a bar says otherwise.

**Kept exactly as written:** B1 to B9, B11, B13 to B18, C1, C3, C8 to C12 (in C10 and C11 "beginner" is the beginner
above; in C12 "his leads" are his turns and "the answer to the face-down card" is the volley thrown at his set card).

**Kept, with the old shape's words replaced by this form's (same numbers):**

| # | Bar | Pass when |
|---|---|---|
| B10 | Showing beats guessing | the reader's lead over random is 10+ points bigger with his punches thrown face up than when they must be guarded unseen |
| B12 | No blanks | volleys from which nothing lands (none thrown, or all stopped or caught) under 15%; cards that end up doing nothing (a trap nothing walked onto) under 25% of cards played |
| C2 | He tires | he starts 5 to 15% of his turns with 2 wind or less after his wind comes back (he cannot both guard and throw a power punch) |
| C4 | You set traps | the reader sets a trap on 30%+ of its turns |
| C5 | The set card is a fork | of the traps he sets no one kind is over 55%; he has a trap down on 20 to 85% of his turns (so a turn with nothing set is 15%+) |
| C6 | No fixed answer to the set card | the reader forced, whenever he has a card set, to always ignore it / always lead with the jab / throw only jabs and body jabs / throw nothing wins 10+ points less than the reader who chooses, each of the four |
| C7 | The answers spread | of the reader's volleys at a set card, sorted by first punch (jab / body jab / cross or uppercut / hook / none), no class is over 40% |

**New in round 3:**

| # | Bar | Pass when |
|---|---|---|
| D1 | Fast and punchy (owner) | a bout takes 3 to 6 minutes of real decisions: the reader's and the table player's bouts average 22.5 to 45 decisions (x 8 s), and 95% of bouts are under 7 minutes (52 decisions) |
| D2 | Guards are worth something (round 2's real fault) | the reader forbidden to guard wins 15+ points less; the reader made to guard everything it can first wins 5+ points less; 30 to 70% of punches thrown are stopped; two or more guard cards are top-half picks against some style in the card table |
| D3 | The chairs are equal | reader against reader over the 16 pairs, the boxer who throws first in round 1 wins 45 to 55% |
| D4 | Quick turns | the choices in front of the player at one decision (cards that can legally be played, with their targets, and "end the turn") average under 10 and are never over 20 |
| D5 | No trap deck | deck rule: at most 2 of each trap. The best deck the breaker search finds holds its win rate by C8, and a deck with 6 traps wins less than the neutral deck plus the best 2 |

**Round 3 verdict rule: PASS = B1 to B7, C1 to C12 and D1 to D5 all pass.** Supporting bars B8 to B18 that fail are named
with their cause. Run rule as before: sizing on its own seeds (300000 and up), then the design as written, one resize
(numbers only), one design change, stop.

### 4d. Round 4 bars (CARDSCOPE4; written and committed before any round 4 code ran, not loosened afterwards) **[R4]**

Round 4 puts the rally on a four-range strip with six martial arts (section 3S). The bars are CARDREF2's probes
(`CARDREF2_MARTIAL_ARTS.md` section 7), in the order they are run. Words: **AI pilot** = one planner that plays any deck
from public information; **impatient line** = the rule of thumb (best fitting answer on the biggest threat, then the
dearest playable card until nothing is left); **scripted pilot** = a hand-written priority list for one style.
Population: the six style decks, all 15 pairings, both chairs, the coin deciding who goes first; never a mirror. A
decision is one answer, one card or step, or "end the turn"; 8 seconds each as in round 3.

| # | Bar | Pass when |
|---|---|---|
| P3 | Limb lights against one wind pool (the owner's idea; decided first, the rest runs on the winner) | Three arms on the same cards: wind only, five limb lights only, both. An arm with limbs is kept only if it beats wind on DEPTH (the AI pilot's win share over the impatient line is 3+ points bigger, AND the share of turns the AI ends with a playable card unplayed is higher, AND the cheap deck with the impatient line wins no more than under wind) and is NO WORSE ON TIME (modelled seconds a turn at most 10% over wind's; the model: 2 s a decision + a look at every legal option, 0.6 s for a wind price, 0.4 s for each limb icon). Otherwise the wind pool stays |
| P1 | The four-range strip | boxing against wrestling: the bout visits 3+ ranges in 80%+ of bouts; neither deck over 60%; the bout averages at most 37.5 decisions (5 minutes) |
| P2 | Three clocks against one | all 15 pairings with (a) health only, (b) health + a points lead of 8, (c) + the hold. With (c): knockout, points lead and hold (tap or pin) each end 15%+ of bouts; 40 to 70% of bouts end before the last bell; an AI pilot made blind to one clock (its weight set to 0) loses 5+ points, each of the three |
| P5 | The hold is a visible race | the held fighter's AI answer equals the rule printed on the table ("Escape if you hold it, else Make room once, else hang on") in 100% of held turns; a hold ends 15 to 30% of the bouts that reach the ground; of holds that go on, 20 to 80% finish (no "always tap", no "never tap"). Reported beside it: the same bouts with a hidden roll of the same average |
| P6 | Each style's own mechanic | with the mechanic switched off, the AI pilot's turn (answer or volley) differs in over 50% of that style's turns, each of the six; a nearest-profile judge that sees only kinds of action and ranges (no card names) names the style from 10 turns in 90%+ of logs |
| P4 | The six-by-six table | AI pilot in both chairs: every one of the 15 pairings inside 40 to 60; every style's average inside 47 to 53 |
| P10 | One pilot for every deck | for each style, the AI pilot's average against the other five is no more than 5 points under the scripted pilot's for that style |
| D1 | Fast and punchy (owner; as round 3) | AI against AI: 22.5 to 45 decisions a bout for one chair, 95% of bouts under 52 |
| D4 | Quick turns (as round 3) | choices in front of the player at one decision average under 10, never over 20 |
| R-C8 | Round 3's thin cheap deck, on the new form | decks are a fixed 15 (so "thin" is closed by rule); the three cheapest legal decks (boxing, karate, a two-art mix), against the six style decks flown by the AI pilot, win at most 50% with the impatient line and at most 55% with the AI pilot |
| R-C11 | Round 3's beginner at regional | the impatient line with a style deck against the AI pilot wins 25 to 40% over the 30 seats |
| R-B6 | Round 3's card matchups | by lift (win share in bouts where the card was played, less the deck's share, per opponent style; a correlation, not a pick test): 75%+ of style cards are top-three in their deck against one style and bottom-half against another |

**Round 4 verdict rule: PASS = P3 decided and P1, P2, P4, P5, P6, P10, D1 all pass.** R-C8, R-C11, R-B6 and D4 are
reported and owned by a build phase if they fail. Run rule (the brief): sizing on its own seeds (300000 and up), then
the measured run on other seeds; a probe that fails twice is redesigned (FREE HAND), and the redesign is written down.
P7 (rulesets as replay), P8 (cross-training) and P9 (the animation budget) are named as next and not run.

### 4e. Round 5 bars (CARDSCOPE5) **[R5]**

**The round 4 bars, unchanged** (the brief: "written before the run, not loosened"): P1, P2, P4, P5, P6, P10 and D1
exactly as in 4d, the same verdict rule, the same run rule (sizing on seeds from 300000, the measured run once on
500000000). P3 was decided in round 4 and is not re-run. Two things changed around the bars, neither in their favour:
the owner added a seventh art (S538), so "all pairings" is 21 cells where the bars were written for 15, and "each of
the six" reads "each of the seven". P6's judge is reported on round 4's instrument (the bar) and on two finer readings
beside it (6e says why).

---

### 4f. Round 6 bars fixed before implementation and measurement **[R6]**

The round-5 bars are not loosened. P1 retains its boxing-versus-wrestling matchup and thresholds; the selected two-art slice has no wrestling deck, so the round-6 run reports boxing versus BJJ as the labelled slice substitution and does not claim literal P1 pass. The other bars use the two playable arts (boxing and BJJ). Probe population: both seats, 200 bouts per pairing, measured seed base 500000000, mode=wind; sizing data is frozen from `proto/cardscope5/sized.json`. Bars:

| # | Fixed pass bar |
|---|---|
| P1 | Boxing v wrestling, 3+ ranges in 80%+ of bouts; neither deck wins over 60%; at most 37.5 decisions. Report boxing v BJJ as the round-6 slice substitution. |
| P2 | Health-only, health + points lead, then + hold: report all three end mixes; with all clocks, KO, points lead and hold (tap/pin) each end 15%+; 40–70% end early; pilot blind to each individual clock loses 5+ points. |
| P5 | Printed hold answer is selected in 100% of held turns; holds end 15–30% of ground bouts; 20–80% of holds finish. |
| P6 | Mechanic-off changes the pilot turn in >50% of turns for each playable art; round-4 blind judge names style from ten turns in 90%+. Report finer judge readings separately, never as a substitute. |
| P4 | The two-art pairing is 40–60%; each art's average is 47–53%. |
| P10 | AI pilot is no more than five percentage points below the scripted pilot for each playable art against the other included art. |
| D1 | AI v AI: 22.5–45 decisions per bout for one chair; 95% of bouts under 52. |
| L1 | In 100 seeded career runs, 30–70 win the title; a complete player-paced ladder run is 20–40 minutes, with the decision-time model disclosed. |
| L2 | In ten predeclared training states, every one of the four options is the utility-maximizing pick in at least one state and no option is best in more than six. |

No tuning after this sheet; report measured values even when a bar fails. The existing cardscope5 measured values remain the round-5 baseline, not round-6 results.

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

## 6c. Round 3 result **[R3]** (full tables: `docs/CARDSCOPE3_PROBE.md`; greybox `proto/cardscope3/`)

**Verdict: FAIL. Final run (run 2): 18 of 24 core bars, 3 of 11 supporting bars.** Run 1 as sized: 14 of 24. Run 2
after the one resize (numbers only: Parry 1 wind, Tie up 4, the first thrower 1 wind less instead of 2, knockdown line
18 and 14, a trap does 8, ice 14). The design-change run was **not spent**: the two changes tried on sizing seeds (an
unsprung trap thrown away instead of coming back; the body track cut) each scored 17, not better than 18.

| What round 2 got wrong | Bar | Round 2 | Round 3 (run 2) | |
|---|---|---|---|---|
| The answering boxer wins by hitting; guards are worth nothing | D2 never guards / stopped / guards top-half somewhere | Block, Slip, Roll bottom-half everywhere | never guards 1.8% v 59.1%; 31.8% of punches stopped; Block, Slip, Roll, Parry top-half picks | fixed (D2 still fails on one clause, below) |
| A rule-of-thumb beginner wins 4% at regional | C11 (70+ / 45-60 / 25-40) | 81.0 / 43.1 / 4.3 | 83.7 / 48.4 / 20.0 | two of three pass; regional 5 short |
| The table helps the answer, not the lead | C10 half the gap | 46.2% | 69.3% (beginner 20.0, table player 47.1, reader 59.1) | PASS |
| A punch answers the hidden card half the time | C7 no class over 40% | a punch 50.4% | lead with the jab 36.7, cross or uppercut 16.1, hook 22.1, nothing 25.1 | PASS |
| No fixed answer to it | C6 each 10+ under free choice | 3 of 4 | ignore -18.5, jabs only -24.6, nothing -32.3, jab first -9.7 | FAIL by 0.3 |
| Four Check hooks break the debut; each sizing crowns a key card | C8 50% / C9 25 / D5 | 61.1% / +50.6 | 67.5% / +11.3 / six traps 5.3% | C9 and D5 pass; C8 fails on another deck |
| He tires only through one card | C2 5-15% | 2.3% | 11.7% | PASS |
| (owner) Fast and punchy | D1 3 to 6 minutes | 12 three-beat exchanges | 37.4 decisions = 5.0 min, 95% under 5.6 min | PASS |
| (new) The chairs are equal | D3 45-55% | - | first thrower wins 52.9% | PASS |
| (new) Quick turns | D4 under 10 choices | 112 legal answers | 5.0 choices at a decision, most 15 | PASS |

Also passing: B1 to B5, B7, C1 (reader 59.1%), C3 (damage 59.5 dealt, 54.4 taken), C4 (a trap on 63% of your turns),
C5 (his traps 43 / 28 / 29 by kind, one down on 60% of his turns), B9 (+5.2), B10, B14.

**What still fails, and the cause in the design:**
1. **C11, the beginner at regional (20.0%, bar 25).** The bar's beginner sets no trap and ignores his. In this form the
   trap is free, so never setting one gives away a free threat every turn, and leading jab-first walks onto his Check
   hook. The damage chaser, just as blind, wins 21%. A player who only reads the printed table wins 47%. The game needs
   to *teach* the set card (open class shows his trap face up for the first two rounds), not a softer trap.
2. **C8, the breaker (67.5% in the pro debut).** Not a key card this time (C9 passes at +11): a thin deck of the
   cheapest punches (five Body jabs, three Jabs, three Crosses) with four guards and no trap. Two causes: body damage
   takes his wind for the rest of the bout and five Body jabs do it for 1 wind each; and a trap is a burden to its own
   deck (below), so the style decks are weaker than a plain one.
3. **B6, card matchups (10 of 14 flat).** Cross, Lead hook, Body hook and Roll swing by opponent. Jab, Body jab,
   Block and Parry (1 wind) are good against everybody; Uppercut (3) and Tie up (4) are bad against everybody: with 3
   wind a turn and one guard, the price decides before the matchup does. The three traps are bottom-half almost
   everywhere: a trap that nothing walks onto comes back to the hand and sits where a punch would be.
4. **D2's last clause (guards all it can: -1.7, bar 5).** With one guard a turn, using it is nearly always right.
   The decision is which punch and which guard, not whether. Either the bar is wrong for this form or a guard must
   cost the counter it could have been (critic's call).
5. **C12 (the volley changes in 17.3% of turns where a known habit applies, bar 30; habits known +3.8, bar 4).** A trap
   only watches the lead punch, so a habit can only change the lead; and the count of what he can still hold already
   says most of it (counting is worth 9.1).
6. **C6, jab first (-9.7, bar 10).** Leading with the jab is the cheap probe and is punished only by the Check hook.
7. **Supporting bars:** stoppages 1.8% (bar 10 to 25; knockdowns 0.39 a bout pass); 19.5% of volleys land nothing
   (bar 15); the corner (water is best always: 62.3% v 59.1% informed); he does not read you back (1 point);
   one style pair under 40% (pressure fighter v volume 37.8%); Tie up 2.9% of plays at 4 wind; the damage chaser (21%)
   is under the best fixed line (31%).

**Honest limits.** Bots, not people; nobody has played a turn. The form was sized on its own seeds (300000 and up)
before run 1, and that sizing changed two rules, not only numbers, which the first draft of 4c did not have: **one
guard a turn** (with a guard on every punch, guarding everything was automatic and 40% of volleys landed nothing) and
**a trap is free, watches the lead punch only and comes back if nothing walks onto it** (at 2 wind and thrown away it
was a card no deck wanted). The bars of 4c were not edited; its sentence "a guard on any of them" now reads "one guard
on one of them". The opponent at regional class is the reader's own planner without habit knowledge, so "reader 59%"
is a measure against a near-copy of itself with a different deck.

## 6d. Round 4 result **[R4]** (greybox `proto/cardscope4/`; raw output `proto/cardscope4/measured/m_p3.txt`, `m_all.txt`)

**Verdict: FAIL. P3 decided (the wind pool stays); 5 of 7 core bars pass (P1, P2, P4, P10, D1); P5 and P6 fail.**
Supporting: D4, R-C8 and R-C11 pass, R-B6 fails. Measured once, on seeds 500000000 and up (sizing used 300000 to
about 113 million), 200 bouts a seat = 400 a pairing, 6,000 a table; P3 at 150 a seat.

**P3, the owner's limb points, decided first.** Same cards, three arms. A limb is a light (lead arm, rear arm, lead
leg, rear leg, hips); a card spends the lights printed on it; a leg kick darkens a leg for a turn.

| | AI pilot's win share over the impatient line (depth) | Turns ended with a playable card held back | Modelled seconds a turn | Cheap decks with the impatient line (boxing / karate / mix) |
|---|---|---|---|---|
| Sizing run, first-draft numbers: wind | 57.7 | 5.4% | 10.1 | 24 / 48 / 19 |
| limb lights only | 59.0 (+1.3; bar +3) | 3.8% (lower) | 8.3 | 37 / 38 / 29 |
| both | 52.4 | 6.7% | 10.3 | 44 / 43 / 25 |
| Measured run, sized numbers: wind | 65.2 | 4.2% | 12.8 | 18 / 24 / 20 |
| limb lights only | 54.1 | 3.7% | 9.3 | 61 / 67 / 35 |
| both | 53.9 | 3.8% | 12.0 | 61 / 64 / 37 |

Neither limb arm passes in either run: the lights make a turn quicker to read (8 to 9 seconds against 10 to 13) but
they do not make it harder to call, and they open the cheap deck again (a limb is free every turn, so a deck of
one-limb cards is never short). **The single wind pool stays.** What is kept of the idea: a hurt leg as a status (the
leg kick takes 1 wind from his next turn), and "defence costs offence" through the one answer a turn. Honest limit: the
measured run's numbers were sized under wind, so that run leans toward wind; the sizing run did not, and it says the
same.

**The core bars (measured run).**

| # | Bar | Measured | |
|---|---|---|---|
| P1 | boxing v wrestling: 3+ ranges in 80%+; neither over 60%; at most 37.5 decisions | 3+ ranges 100%; boxing 48.0%; 30.4 decisions | PASS |
| P2 | with all three clocks: knockout, lead and hold each end 15%+; 40 to 70% end early; blind to a clock loses 5+ | knockout 18.8, lead 16.4, hold 24.7 (tap 23.8, pin 0.9); 59.8% early; blind to health -12.8, to points -8.0, to the hold -8.9. (Health only: 31.6% early. Health + points: 51.3%.) | PASS |
| P5 | the pilot's answer = the printed rule in 100% of held turns; a hold ends 15 to 30% of ground bouts; 20 to 80% of holds finish | **48.9%** of 10,374 held turns; 24.8%; 27.2% | **FAIL** (clause 1) |
| P6 | mechanic off changes the pilot's turn in over 50% of turns, each style; a blind judge names the style from 10 turns in 90%+ | boxing 33.5, karate 18.0, judo 42.9, wrestling 19.0, BJJ 5.2, sambo 0.0; judge 52.8% | **FAIL** |
| P4 | all 15 pairings inside 40 to 60; every style's average inside 47 to 53 | 15 of 15 (41.0 to 59.0); averages boxing 50.8, karate 51.0, judo 48.2, wrestling 50.4, BJJ 47.4, sambo 52.3 | PASS |
| P10 | the AI pilot no more than 5 under each style's scripted pilot | ahead in all six: boxing +11.1, karate +11.3, judo +19.8, wrestling +20.9, BJJ +4.1, sambo +4.0 | PASS |
| D1 | 22.5 to 45 decisions; 95% under 52 | 24.7 decisions (3.3 minutes); 95% under 43 | PASS |
| D4 | choices at a decision under 10 on average, never over 20 | 2.8; most 11 | PASS |
| R-C8 | cheap decks: at most 50% with the impatient line, 55% with the AI | boxing 19.6 / 24.3, karate 25.0 / 32.7, mix 19.3 / 22.5 | PASS |
| R-C11 | the impatient line with a style deck wins 25 to 40% | 35.0% | PASS |
| R-B6 | 75%+ of style cards have a matchup (by lift) | 24 of 42 = 57.1% | FAIL |

The style table (row = you, AI pilot in both chairs, both seatings folded):

| you \ him | Boxing | Karate | Judo | Wrestling | BJJ | Sambo | average |
|---|---|---|---|---|---|---|---|
| Boxing | - | 53.8 | 48.0 | 48.0 | 53.5 | 50.5 | 50.8 |
| Karate | 46.3 | - | 52.5 | 56.8 | 58.5 | 41.0 | 51.0 |
| Judo | 52.0 | 47.5 | - | 43.3 | 47.8 | 50.2 | 48.2 |
| Wrestling | 52.0 | 43.3 | 56.8 | - | 48.0 | 52.0 | 50.4 |
| BJJ | 46.5 | 41.5 | 52.3 | 52.0 | - | 45.0 | 47.4 |
| Sambo | 49.5 | 59.0 | 49.8 | 48.0 | 55.0 | - | 52.3 |

It is balanced, but it is **not CARDREF2's intended triangle**: here karate beats wrestling and BJJ, sambo beats
karate (the caught kick), wrestling beats judo; boxing is level with everybody. The search was told "inside 40 to 60",
not "who should beat whom". Round 3's failures on the new form: the thin cheap deck and the beginner at regional are
closed (a fixed 15; 35%); card matchups are still short.

**What fails, and the cause in the design.**
1. **P6, the own mechanic (0 to 43%, bar 50; judge 53%, bar 90).** Redesigned once during sizing (the first sizing read
   0 / 15 / 31 / 0 / 4 / 0 because the search had priced the set-up cards out of use: the Tie-up, the Grip, the Cross
   and the leg locks were pinned cheap, the punch chain was moved into boxing's mechanic, the sambo throw made legal
   from PUNCH). Still failing, for one reason: **four of the six mechanics change what a card does, not which card is
   right.** A sambo fighter lays the leg lock after the throw whether it is free or not (0.0%); a BJJ fighter lays the
   next hold whether it is free or not (5.2%); a wrestler shoots the same shot clean or not (19.0%). Only the mechanics
   that change what is legal (the jab stepping in, the grip) move the line. And the judge cannot tell wrestling, sambo
   and boxing apart from kinds of action and ranges (23%, 33%, 47%): three of the six decks do the same thing in the
   same place. To try in round 5: each mechanic becomes a rule about what is *playable* (a wrestler's shot is only
   legal behind a tie-up or a sprawl; a sambo leg lock only in the turn after a throw, from any rung; a BJJ hold from
   underneath only as the second link of a chain), and each art gets one place on the strip nobody shares.
2. **P5, clause 1 (48.9%, bar 100).** A count over 1,200 more bouts shows where the pilot leaves the printed rule
   ("Escape if you hold it, else Make room once, else hang on"): it always plays Escape when it holds it; with 2 or 3
   ticks left it hangs on and makes room on the last tick (the rule says at once); under a pin worth 2 points it does
   not pay 3 wind for room. Nothing is hidden: the rule on the table is worded wrong. Reworded "Escape if you hold it;
   on the last tick Make room, unless it is a pin; else hang on", the same count agrees in about 96% - read after the
   run, not a pass. Round 5 prints that rule and makes room worth its price under a pin, or leaves the clause to the
   critic's call.
3. **R-B6, card matchups (57%, bar 75).** 18 of 42 cards are good or bad against everybody; the answers are the
   matchup cards, the attacks mostly are not.

**Honest limits.**
- Bots, not people; nobody has played a turn. The pilot looks two cards deep and reads the open pile; it is the
  measure and the opponent at once, so "50%" is a deck against a deck under one pilot.
- **The numbers are a search's, not a designer's.** Seven search passes on sizing seeds moved about 90 numbers (real
  sport points pinned: karate 1 / 2 / 3, a takedown 2). Some prices are odd and stay unpolished: the Cross (4 damage,
  no point) is weaker than the Lead hook at the same 2 wind; the Ankle lock is dearer and slower than the Knee bar; the
  Overhand costs 3; the Front headlock's point and the caught kick's points were sized to 0; steps cost nothing.
- **The rules changed during sizing, not only numbers** (each because the first draft measured broken; bars untouched):
  a fresh hand of 5 every turn (hands clogged with answers: BJJ won 16%); 15 = 12 + 2 Sprawl + 1 Escape (holds
  finished 2%); the jab steps in from KICK, kicks need KICK and only the reverse punch blitzes (karate beat boxing 97
  to 3, then lost 17 to 83); Step off also beats a grip; a held fighter keeps his hand and Make room draws 2 (holds
  finished 9 to 17%); wrestling got a pin, The fall; the pilot reads the open pile for his Escape.
- A turn offers 2.8 choices on average. That passes D4 and is fast; it may also be thin. The critic should look there.
- P1's own pair ends early in 94% of bouts (knockout 44, lead 49): single pairings are far from the all-pairs shape.
- Pins end 0.9% of bouts: the pin clock is nearly unused next to the tap (23.8%).
- P7 (rulesets as replay), P8 (cross-training) and P9 (the animation budget) are named as next and were not run.

## 6e. Round 5 result **[R5]** (greybox `proto/cardscope5/`; raw output `proto/cardscope5/measured/m_all.txt`)

**Verdict: FAIL. 4 of 7 core bars pass (P1, P5, P10, D1). P5 and P6's first clause, the two things the round was for,
now pass; P4, P6's judge clause and one clause of P2 fail.** Supporting: D4 and R-C8 pass, R-C11 and R-B6 fail.
Measured once, on seeds 500000000 and up, after sizing on seeds 300000 to about 360 million; 200 bouts a seat = 400 a
pairing, 8,400 a table. Nothing was re-sized after the measured run.

| # | Bar | Round 4 | Round 5, measured | |
|---|---|---|---|---|
| P1 | boxing v wrestling: 3+ ranges in 80%+; neither over 60%; at most 37.5 decisions | 100%; 48.0; 30.4 | 3+ ranges 100%; boxing 44.3%; 24.9 decisions | PASS |
| P2 | knockout, lead and hold each end 15%+; 40 to 70% end early; blind to a clock loses 5+ | 18.8 / 16.4 / 24.7; 59.8%; -12.8, -8.0, -8.9 | knockout 22.6, lead 19.6, hold 15.6 (tap 11.6, pin 4.0); 57.9% early; blind to health -13.9, to points -9.6, **to the hold -2.2** (health only: 36.6% early; health + points: 52.2%) | **FAIL** (last clause) |
| P5 | the pilot's answer = the printed rule in 100% of held turns; a hold ends 15 to 30% of ground bouts; 20 to 80% of holds finish | 48.9%; 24.8%; 27.2% | **100.0%** of 6,494 held turns; 18.9%; 23.9% | PASS |
| P6 | mechanic off changes the pilot's turn in over 50% of turns, each art; a blind judge names the art from 10 turns in 90%+ | 0.0 to 42.9; 52.8% | boxing **63.7**, kickboxing **57.0**, karate **61.4**, judo **57.1**, wrestling **72.3**, BJJ **95.8**, sambo **63.4**; judge **48.5%** | clause 1 PASS, clause 2 **FAIL** |
| P4 | every pairing inside 40 to 60; every average inside 47 to 53 | 15 of 15; 47.4 to 52.3 | **19 of 21** (38.5 to 64.8); averages 46.6 to 52.6 (BJJ 46.6) | **FAIL** |
| P10 | the AI pilot no more than 5 under each art's scripted pilot | ahead in all six | ahead in all seven: boxing +17.0, kickboxing +33.5, karate +34.0, judo +18.1, wrestling +15.3, BJJ +10.3, sambo +30.7 | PASS |
| D1 | 22.5 to 45 decisions; 95% under 52 | 24.7; 43 | 24.7 decisions (3.3 minutes); 95% under 37 | PASS |
| D4 | choices at a decision under 10 on average, never over 20 | 2.8; 11 | 3.0; most 15 | PASS |
| R-C8 | cheap decks: at most 50% with the impatient line, 55% with the AI | 19.6 / 24.3, 25.0 / 32.7, 19.3 / 22.5 | boxing 6.5 / 10.3, karate 6.7 / 36.6, mix 3.6 / 2.4 | PASS |
| R-C11 | the impatient line with a style deck wins 25 to 40% | 35.0% | **20.5%** | FAIL |
| R-B6 | 75%+ of style cards have a matchup (by lift) | 57.1% | 31 of 47 = 66.0% | FAIL |

The style table (row = you, AI pilot in both chairs, both seatings folded):

| you \ him | Boxing | Kickboxing | Karate | Judo | Wrestling | BJJ | Sambo | average |
|---|---|---|---|---|---|---|---|---|
| Boxing | - | 53.3 | 49.0 | 45.8 | 43.5 | 56.0 | 40.3 | 48.0 |
| Kickboxing | 46.8 | - | 52.5 | 53.0 | 57.2 | **64.8** | **38.5** | 52.1 |
| Karate | 51.0 | 47.5 | - | 47.0 | 54.8 | 49.7 | 59.3 | 51.5 |
| Judo | 54.3 | 47.0 | 53.0 | - | 44.3 | 51.0 | 41.3 | 48.5 |
| Wrestling | 56.5 | 42.8 | 45.3 | 55.8 | - | 47.5 | 56.2 | 50.7 |
| BJJ | 44.0 | **35.2** | 50.2 | 49.0 | 52.5 | - | 48.8 | 46.6 |
| Sambo | 59.7 | **61.5** | 40.8 | 58.8 | 43.8 | 51.2 | - | 52.6 |

It reads like a sport now, which round 4's table did not: the wrestler beats the boxer and the judo man, the sambo man
beats the two strikers who stand in punching range and loses to the one who will not stay there (karate) and to the
better wrestler, the kickboxer walks out of the guard puller's guard. It is also why the bar fails: sharper arts make
sharper pairings.

**The blind judge, three readings of the same 8,400 logs** (10 turns of one fighter; kinds of action and ranges only):

| Reading | All | Boxing | Kickboxing | Karate | Judo | Wrestling | BJJ | Sambo |
|---|---|---|---|---|---|---|---|---|
| Round 4's instrument, **the bar**: every action filed under the range the turn began at; a kick and a punch one kind | **48.5** | 3.5 | 10.5 | 65.3 | 99.7 | 12.7 | 90.5 | 57.2 |
| Each action filed under the range it is laid at | 81.5 | 68.8 | 55.3 | 81.2 | 99.7 | 81.3 | 99.7 | 84.5 |
| The same, and a kick is its own kind | 89.0 | 80.7 | 93.2 | 85.2 | 99.2 | 80.7 | 99.7 | 84.3 |

**What fails, and the cause.**
1. **P6, the blind judge (48.5%, bar 90; 89.0% at the kindest reading, which also fails).** Round 4's instrument files
   a whole turn under the range it began at. In round 5 cards carry the fighter (the jab steps in, the shot travels,
   the blitz goes in and out), so most turns of the boxer, the kickboxer and the wrestler "begin at KICK" and look the
   same to it (3.5, 10.5, 12.7%). That is an instrument that has gone blind, not a pass: read where each action is laid
   and with a kick as its own kind, the judge is at 89.0 and the real remaining confusions show. Boxing (80.7) is taken
   for kickboxing or sambo: all three punch at PUNCH range. Wrestling (80.7) is taken for judo: a takedown, then top.
   Karate (85.2) and sambo (84.3) lose logs the same way. Judo and BJJ are unmistakable (99%).
2. **P4, the table (19 of 21; BJJ averages 46.6).** Two cells, one fighter: the kickboxer. Against BJJ (64.8) he has
   nothing to do on the ground and does not need it: he stands up for 1 wind or the referee stands them up after one
   idle turn, so every guard pull costs the BJJ man 2 wind for one turn of attacks. Against sambo (38.5) his kicks are
   caught and he has no ground card against a leg lock that goes on in the volley of the throw. Sizing took the worst
   cell from 27 off (where the last five passes began) to 11 to 15 off and stopped there: with rules this sharp a
   number that helps one pairing hurts the next (sambo beats boxing 59.7 and judo 58.8 and loses to karate 40.8 and
   wrestling 43.8). The table needs pair-specific cards, not more passes over the same numbers.
3. **P2, blind to the hold (-2.2, bar -5).** Two causes. The probe blinds the pilot by setting two hold weights to 0;
   round 5's pilot has a third (how long a man stays held), so the "blind" pilot still sees holds. Counted after the
   measured run on 4,200 other bouts, and so not a pass: -3.7 with two weights at 0, -7.8 with all three. And holds
   weigh less than in round 4: the tap ends 11.6% of bouts (was 23.8%), because a submission can now be bought off the
   first turn the held man has the wind.
4. **R-C11, the beginner (20.5%, bar 25 to 40; it was 35.0).** The impatient line ignores the mechanic, and a mechanic
   that decides what is playable leaves it holding dead cards: 8.2% with karate, 8.6% with BJJ, 35.3% with wrestling.
   The price of P6's first clause; the teaching of each art's one rule has to carry it.
5. **R-B6, card matchups (66.0%, bar 75; it was 57.1).** Better, still short.

**How the round was run (honest account).**
- The job ran twice. The first run made the rule changes and eleven sizing passes and stopped mid-sizing; the second
  (S539) picked up its files, changed four more rules, sized again and measured. Rules changed by the second run, each
  with its reason: a pin cannot be bought off and ends in the CLINCH (the pilot rightly refused to pay 6 wind out of a
  one-turn pin: P5 read 93.3%); sambo's leg locks from anywhere became part of its mechanic (sambo's P6 read 34.8%);
  the kickboxer's punch behind the knee pushes off to PUNCH (kickboxing read 51.7%); the wrestler's ride (he was on top
  for 2% of his turns: his ground cards were dead and the judge took him for a judo man).
- **The numbers are a search's, not a designer's**, more than in round 4: about 110 numbers and, new, the count of each
  card in a deck. Odd prices stay: the Front kick costs 3 wind for 1 damage and a point; the Shoulder throw (5 points)
  costs 1; the Knee does 1 damage; the Ride scores nothing. The first sizing tool fitted its own seed (a table 2 cells
  off on its seed was 5 off on the next), so a second tool was written (`tune2.mjs`: candidates screened on three
  seeds and kept only if better on four others).
- **BJJ stands on one number.** Tried during sizing: with Pull guard at 1 wind instead of 2, BJJ averaged 75%. A design this sensitive to
  one price is not finished.
- 14.3% of turns end with nothing laid, and a decision offers 3.0 choices on average. Fast (3.3 minutes); possibly
  thin. Pins end 4.0% of bouts (0.9% before), still the small clock.
- Bots, not people; one pilot is the measure and the opponent at once. P7, P8 and P9 were not run.

## 6f. Round 6 result **[R6]** (one line in `proto/cardgame/`; harness `probe.mjs`)

**Verdict: FAIL — the two-art rules slice is playable and the ladder/training layer is implemented, but P2, P4, P5, P6's mechanic clause, and both L1 clauses fail.** The core bars were fixed first in 4f. Cards were ported with `sized.json` loaded as a browser-compatible JSON module; `N.mode='wind'` remains. Probe: `node proto/cardgame/probe.mjs all per=200 seed=500000000 tag=r6core`, both seats, AI pilot; 200 bouts per directional pairing where stated. The 100-run ladder result uses the deterministic pilot and its published 8-second/player-decision duration model (an estimate, not wall-clock human play).

### Pick: BJJ, not judo
Round 5 chose the art whose mechanic changes the turn most and whose blind-judge score is best. BJJ: P6 mechanic-off changed the turn in **95.8%** (3,781 turns), versus judo **57.1%** (4,509); the finest blind judge named BJJ **99.7%**, versus judo **99.2%**. Round 6 retained BJJ's strong signal: **99.6%** (718 turns); the two-art blind judge was **98.0%** on round 4's instrument (90% bar). The portfolio is boxing + BJJ. Judo and the other five styles remain out of the playable slice.

### Fixed-bar results

| # | Bar / slice measurement | Round 6 measured | Result |
|---|---|---|---|
| P1 | Original boxing v wrestling: 3+ ranges ≥80%, neither wins >60%, ≤37.5 decisions | boxing 44.3%; 3+ ranges 100%; 24.9 decisions — PASS on unchanged matchup. Wrestling is not in this slice. Boxing v BJJ substitution: boxing 54.4%, 3+ ranges 98.6%, 23.2 decisions; both shares ≤60%. | PASS original; slice analogue PASS (labelled substitution) |
| P2 | KO, points lead, hold each ≥15%; early 40–70%; each clock blind loses ≥5 points | Health only: KO 42.3%, cards 57.8%. +points: KO 40.5%, lead 7.0%, cards 52.5%. +hold: KO 9.0%, lead 4.8%, tap 30.3%, pin 0%, cards 56.0%; early 44.0%. Blind health 27.8% (−22.2); blind points 50.8% (−0.8); blind hold 41.5% (−8.5), where 50 is no loss. | **FAIL** (KO/lead shares and blind-points clause) |
| P5 | Printed answer 100%; holds end 15–30% of ground bouts; 20–80% of holds finish | Printed answer **100.0%** of 611 held turns; hold ends **31.3%** of ground bouts; **17.0%** of holds that go on finish. Hidden-roll control p=17.0: 19.8% ground-bout ends; AI over impatient 64.0% (visible race 76.5%). | **FAIL** (both rate bounds) |
| P6 | Each mechanic-off turn change >50%; blind judge ≥90% | Boxing **49.3%** (706 turns), BJJ **99.6%** (718); round-4 judge **98.0%** overall (boxing 96.0, BJJ 100.0). Finer readings 97.5%. | **FAIL** (boxing mechanic clause); judge PASS |
| P4 | Pairing 40–60%; each style average 47–53% | Boxing v BJJ 56.5%; averages: boxing **56.5%**, BJJ **43.5%**; 0/1 cells outside 40–60. | **FAIL** (both style averages) |
| P10 | AI no more than 5 points below scripted pilot per art | Boxing AI 55.0%, scripted 50.5% (+4.5); BJJ AI 46.5%, scripted 40.0% (+6.5). | PASS |
| D1 | 22.5–45 decisions/bout; 95% under 52 | 22.8 decisions; 95th percentile 35; max choices 7. | PASS |
| L1 | 30–70 title wins of 100; complete run 20–40 minutes | **100/100 titles**; mean **11.7 bouts / 30.3 modeled minutes** per run at 8 seconds per player decision (no 80-bout caps). | **FAIL** (title rate; duration PASS) |
| L2 | Every training option best in ≥1 and ≤6 of ten states | Boxing jab/cross/hook/block: **3/3/2/2**. BJJ sweep/pass/triangle/escape: **3/3/2/2**. | PASS |

P4 and P2's score lines show why a two-art slice is not automatically balanced: rounds and cards play, but BJJ's folded share is still outside the unchanged style-average band. P1's literal bar passes on the measured boxing/wrestling pair; the slice analogue is separately printed and is not relabelled as the literal bar.

### Form, ladder, training, and cuts

- **Form:** one shared four-range strip (KICK–PUNCH–CLINCH–GROUND), face-up rally, wind pool, projected-state previews and card-level damage/result text.
- **Ladder:** visible Club → Area → National → Title shot → Title defences 1–3, a rank number, wins advance one rung and losses drop one rung (with the club floor).
- **Training:** exactly four style-specific choices between bouts; each prints energy cost and failure chance and either adds a card or upgrades one card. Failure spends energy only; no stat decay. L2's ten reproducible tactical states cycle 3/3/2/2: boxing KICK entry, PUNCH exchange, CLINCH infighting, KICK under an incoming volley; BJJ bottom guard, top position, threatened bottom guard, held bottom position. Utility uses playability, card value, training cost/failure and the situation-specific synergy. It is a synthetic state sweep, not human preference data.
- **Cut:** kickboxing, karate, judo, wrestling and sambo are out of the playable slice; no asynchronous battles, animations or critics this round. The five prior Arena test modules and their old rules are retained under `proto/cardgame-legacy/` because the standing instruction is to keep every found test; the previous playable rules are no longer loaded by the page. The legacy suite still runs and passes.
- **Visual gate:** not verified. This Linux workspace has no Chromium/Edge/Firefox or installed browser automation, while `tools/render_mockup.py` imports Windows-only `msvcrt` and requires a Windows Edge executable. Therefore the requested 1920×1080 and phone stills were not fabricated; `ops/previews/card_r6/` remains empty. Do not treat this as visually checked.

## 6g. Round 6b result **[R6b]** (CARD CARDFIX6B; `proto/cardgame/`, harness `probe.mjs` + `ladder-probe.mjs`; tag `card-r6b`)

**Verdict: FAIL on three clauses — P2's points clock, P4 at the protocol seed, P6's boxing mechanic — and the page plays.** P1 (literal and slice), P5, P10, D1, L1 and L2 pass; P2 passes every share and two of its three blind clocks. Probe: `node proto/cardgame/probe.mjs all per=200 seed=500000000 tag=r6b` (raw `proto/cardgame/out/r6b.txt`), both seats, AI pilot, mode=wind; ladder: `node proto/cardgame/ladder-probe.mjs` (`out/r6ladder.json`). Not READY FOR THE OWNER'S PLAY: three core clauses still fail.

### What was fixed, in the card's order

1. **The page loads and plays.** `ui.js` imported `actions` from `engine.mjs`, which does not export it (it lives in `plan.mjs`): the module graph never linked and nothing rendered. The two engine answers `@cover`/`@break` are not keys of `CARDS`, so `cardText`/`names` died on them. Now: the import is from `plan.mjs`; the pure text helpers live in `ui-text.mjs`, the DOM module in `ui.js`, a stub document in `uidom.mjs`; `engine.test.mjs` links the whole graph and `ui.test.mjs` **plays the page by script**: whole bouts in both chairs, a ladder step with the training turn, a win at the title shot, a win at defence 2 then defence 3, the cut at six losses, a new career. Answer buttons carry `data-id` so a reader (or a test) can sprawl the sweep or break the hold. Played: yes, in `node --test proto/cardgame/*.test.mjs`.
2. **The belt is won at the title shot.** `takesTitle(career, won)` reads the rung before `resultCareer` moves it; a win at "Title shot" makes the boxer champion and the three defences follow. In the simulation the title is sticky for the count (a defence lost and regained is still a title won) and the career ends at the defence-3 win or at six losses. The page's `finishBout` mirrors it: `complete` is a win at the last defence *read before the rung moves* (it used to complete one defence early).
3. **Rivals by rung.** `RIVAL_RECIPE`: Club = a novice of the player's own art from another club, his three best cards swapped for his cheapest (the house rule "opponents from other clubs", and the bout in which the guard drill and the escape practice have something to be right in); Area = the other art's printed deck, two best cards upgraded once; National 4×2, Title shot 6×2, Defence 1 8×3, Defence 2 10×4, Defence 3 12×5. Club is flown by the impatient line, the rest by the AI pilot. L1 (below) went from 100/100 to 48/100.
4. **Training upgrades in place.** A second upgrade of a card replaces the copy already in the deck (`jab+1` → `jab+2`), never adds one; the deck stays 15. **L2 measures the ladder's own states**: ten training states per art, every ⌊n/10⌋-th of a 100-run ladder in run order (not the four hand-made states). A state is where his cards were laid (share by position), whether he was hit, held or behind. Boxing's third option changed from Hook placement to Escape practice: in none of the ladder's sampled states had the boxer laid a card in the CLINCH, so the hook had no state to be right in, while the grappler had him in a hold in 3 of 10 states and the Escape card is the one way out.

### Sizing (what changed in `sized.json` from the round-6 freeze)

| Key | Round 6 | Round 6b | Why |
|---|---|---|---|
| hp | 37 | **42** | KO share 9→20% with the hold on; 40–70% early still holds (62%) |
| turns | 5 | **7** | 14 turns a bout: the three clocks each get to 15%+ |
| lead | 8 | **7** | the points clock ends 17% of bouts (was 4.8) |
| cap | 6 | **5** | the wind pool the combination discount plays against; P5 ends 26% (bar 15–30) |
| heldBack | 2 | **1** | wind comes back slower while held; the held man can still pay his way out (the round-6 value 2 let him out too often: 17% of holds finished) |
| pass.pts / sweep.pts | 3 / 2 | **4 / 3** | BJJ's points clock (lead ends 17%, all BJJ's) |
| triangle.w | 2 | **3** | the guard's finish costs what a pass does |
| brk triangle/armbar/choke/kimura | 3/6/6/3 | **4/6/7/4** | holds finish 52% (bar 20–80), end 26% of ground bouts (bar 15–30) |

Every other key is the round-6 freeze. `dmgPer` stays 8: at 9–12 the boxer's damage counts for less at the cards and BJJ's folded share goes to 53–60.

### Fixed-bar results (seed 500000000, per=200, `out/r6b.txt`)

| # | Bar | Round 6b measured | Result |
|---|---|---|---|
| P1 | Boxing v wrestling: 3+ ranges ≥80%, neither wins >60%, ≤37.5 decisions; report boxing v BJJ as the slice | Wrestling: boxing wins **18.5%**, 3+ ranges **100%**, **25.0** decisions (95%: 39). Slice, boxing v BJJ: boxing wins **50.9%**, 3+ ranges **82.4%**, **30.4** decisions (95%: 48); ends KO 19.9 lead 19.2 tap 24.8 pin 0.0 cards 36.2. | PASS original; slice PASS (labelled substitution) |
| P2 | Health only, +points, +hold: KO, lead, hold (tap/pin) each ≥15%; early 40–70%; each clock blind loses ≥5 points | Health only: KO 40.8, cards 59.3. +points: KO 37.0, lead 22.3, cards 40.8. +hold: **KO 20.0, lead 17.3, tap 24.8, pin 0.0**, cards 38.0; **early 62.0**. Blind health: mean loss **21.4** (the blind boxer loses 50.2, the blind grappler gains 7.5); blind points: mean loss **2.2** (boxer loses 6.7, grappler gains 2.3); blind hold: mean loss **6.6** (boxer gains 5.5, grappler loses 18.8). Blind pilots fly each art against the full AI flying the other, both seats, against the full AI's own share (instrument rewritten, see below). | **FAIL** (the points clock alone; every share, early and the other two clocks pass) |
| P5 | Printed answer 100%; holds end 15–30% of ground bouts; 20–80% of holds finish | Printed answer **100.0%** of 95 held turns; holds end **26.0%** of ground bouts; **52.3%** of holds that go on finish; 0.50 holds a bout. Hidden-roll control p=52.3: 22.3% ground-bout ends; AI over impatient 68.0 (visible race 76.0). | PASS |
| P6 | Mechanic-off changes the turn in >50% for each art; round-4 blind judge ≥90% | Boxing **45.0%** (929 turns), BJJ **100.0%** (1,013); round-4 judge **90.0%** (boxing 80.0, BJJ 100.0); finer readings 90.0%. | **FAIL** (boxing's mechanic clause, 5 points short); judge PASS |
| P4 | Pairing 40–60%; each art's average 47–53% | Boxing v BJJ **57.8%**; averages boxing **57.8**, BJJ **42.3**; 0/1 cells outside 40–60. Same config, standalone `p4`: ten seeds **46.8–53.8** (mean 51.1; 7 of 10 inside 47–53); per=400 at seed 500M **50.5 / 49.5**. | **FAIL** at the protocol seed (see "why" below) |
| P10 | AI no more than 5 points below the scripted pilot per art | Boxing AI 53.5, scripted 53.0 (+0.5); BJJ AI 55.0, scripted 43.5 (+11.5). | PASS |
| D1 | 22.5–45 decisions a bout; 95% under 52 | **32.4** decisions; 95th percentile **48**; max choices 8. | PASS |
| L1 | 30–70 title wins of 100; 20–40 minutes | **48/100 titles** (seeds 610/620/630M: 47/50/49); **31.0** modelled minutes a run (8 s a player decision, disclosed), 13.8 bouts a run, 52 cut at six losses, 0 capped; 31.0 minutes for a title winner over 14.8 bouts. By rung: Club 99.0, Area 55.4, National 38.6, Title shot 40.5, D1 29.9, D2 32.1, D3 22.2. | PASS |
| L2 | Every training option best in ≥1 and ≤6 of ten states | Boxing jab/cross/escape/block: **2/4/3/1**. BJJ sweep/pass/triangle/escape: **5/2/2/1**. States: ten of a 100-run ladder per art. | PASS |

### Why the three that fail still fail

- **P2, the points clock (mean loss 2.2, bar 5).** The points-blind pilot loses 6.7 points as the boxer and *gains* 2.3 as the grappler (its 50.5 against the full grappler's 48.3). On this engine the points ride on the cards the pilot plays anyway (the cross, hook and uppercut carry the boxer's points, the sweep and pass the grappler's), and the lead end is visible to a points-blind pilot through `S.over` in its own projection, so blindness to the points only changes close calls. Levers tried, measured under the new instrument: `lead` 5 (boxing's lead share 35%, P4 45.2, no blind-points gain), `dmgPer` 9–30 (points decide the cards; mean loss at most 2.6, at `dmgPer` 12 with `cross.pts` 2, while P4 went to 40–47), `jab.pts` 1 (boxer 66–86%), cross/hook `pts` 2 and bodyhook `dmg` 6 (mean loss −2.1 to 2.5, P4 44–57). Not fixable by sizing: a clock the pilot cannot see must cost it a *decision*, and on this ladder it does not.
- **P6, boxing's mechanic (45.0%, bar >50).** The boxer lays cards in 12% of his act turns (KICK 8.7%, CLINCH 2.9%; never a whole turn at PUNCH); 79% of his turns he sits on top of the guard with nothing of his to lay (steps 41% of his laid cards), and the combination mechanic has no card there. The discount still changes the punch line after `@stand` in 39% of those turns and the jab's entry in 89% of the KICK turns; the three-beat finisher never fires in AI-v-AI (0 combos in 800 bouts: the grappler's cover stops one punch of the three, and the line is never clean). Levers tried: wind `cap` 4 (44.9, and holds never go on: ends 0%), `start` 3 (46.4), pricier punches so the discount carries the line (boxing 28–32%, KO 0%), `comboDmg` 8–20 (no change: no combos), `cover` 1 and `coverW` 2 (40–47), ground-and-pound from the top (54.6 but the boxer punches into triangles: 28/72), `@pull` restricted to PUNCH/CLINCH as its card text says (the AI boxer steps out to KICK and BJJ never reaches the ground: 0.5%). A mechanic can only change turns in which the art has a card to play.
- **P4 at the protocol seed (57.8 / 42.3).** Cards decisions go to the boxer (280 of 319 in an 800-bout direct count: 27.7 damage dealt a bout against none), so BJJ's folded share is its tap share plus its lead share, and a three-point swing in the tap share moves P4 five points. The same binary at ten seeds reads 46.8–53.8 (mean 51.1) and 50.5 / 49.5 at per=400; the protocol sample is the high draw. Reported as measured: FAIL.

### Instrument: the blind-pilot measure in a two-art slice

`probe.mjs p2` used `table(() => blind, () => AI)`: with two arts the blind pilot only ever flew the lower-index art and the fold compared its two seatings, so the round-6 "blind points 50.8 (−0.8)" was a seat asymmetry, not a loss. Rewritten: the blind pilot flies each art against the full AI flying the other, both seats folded, and its share is compared with the full AI's own share for that art (the `c` arm's fold). The line now prints both arts and the mean loss; the bar is the mean loss (5+). Under the old instrument this sizing read "blind points 53.3"; under the new one it reads 2.2. The health and hold clocks pass under either.

### Form, ladder, training, and cuts

- **Form:** unchanged: one strip, face-up rally, wind pool, three clocks (health, points, hold), judges by cards. The boxer spends most of a bout on the ground because BJJ sits to guard from any range; the standing exchange is one or two turns a cycle. That is the slice as designed, and it is what caps P6 boxing.
- **Ladder:** Club (own art, novice) → Area → National → Title shot → three defences; the rival's deck by recipe above; the belt at the title shot; six losses and the gym cuts you; a career ends at the defence-3 win. A defence rival's upgraded sweep scores seven at once and a free one-turn triangle can end a bout before the player's first turn unless the corner holds a sprawl, a break or the Escape: the top of the ladder is meant to be hard (D3 won 22%), and the page offers the answers on the table.
- **Training:** four options a turn, upgraded in place. Boxing: Jab timing, Cross power, Escape practice, Guard drill. BJJ: Sweep entries, Guard passing, Triangle control, Escape practice. Utility: where his cards were laid (fit), the card's kit, a situation synergy (KICK share for the jab, PUNCH for the cross, hit for the guard drill, held for the escape; bottom for the sweep, top for the pass, behind for the triangle, held for the escape), cost and failure. Weights sized on the ladder's own ten states so each option is the pick in 1–6 of them; the hand-made spread test (KICK entry, PUNCH exchange, held, hit) still cycles.
- **Tests:** `node --test proto/cardgame/*.test.mjs` 36/36; legacy `node proto/cardgame-legacy/rules.test.mjs` 32/32. Added: the module-graph link, `@cover`/`@break` words, the title at the title shot (table and page), the career ends at the last defence won, rivals by rung with the club novice of the player's art, the in-place upgrade, L2 on the ladder's own states, the training-state reader on a no-card bout. Adapted, not weakened: the rival test now expects the player's art at Club and the other art above (same length and upgrade checks); the cut test's hopeless deck meets the Area boxer (a club novice of its own art could only coin-flip it); the spread test's third boxing state is "held" in place of "CLINCH infighting", which the real ladder never produces. The 500-line rule holds (largest file 313 lines).
- **Cuts:** the three failing clauses are reported, not tuned to; the levers above are cut because each broke a passing bar. Visual gate: unchanged from round 6 — no browser in this workspace; the page was played through its DOM stub, not seen.

## 6h. Round 7 result **[R7]** (TASK CARDROUND7; `proto/cardgame/`, harness `probe.mjs gate=play` / `gate=ship`; tag `card-r7`)

**Verdict: PASS on the one thing — the PLAY gate passes (6/6) and stays passing; this is the first build the owner may open.** The owner signed the pre-production plan (S541, all five answers Yes), so from this round his play sits at the PLAY gate, not behind the bar sheet (plan section 1 STOP 3). The SHIP gate is measured and printed beside it (11/15): the four failing rows are the known clauses — P2's points-blind, P6's boxing mechanic (both the 6g analyses), plus draw variance on the P10/beginner lines — and they are the hand-sizing targets of round 9, not tuned here. No rule or number change beyond CARDFIX6B's list: `sized.json`, the engine numbers and every card are untouched; this round is a gate, a log and an opening.

### The one thing, in its four parts

- **(a) The node test that links the page and plays it.** `ui.test.mjs` already imported the graph through the stub document and played a whole bout plus a ladder step through the page's own calls; it is now the standing test for the PLAY gate's first two rows, and `probe.mjs gate=play` re-runs the same scripted player inside the harness so the gate is one command. A broken import or a crash fails the row, the gate and the process (exit 1).
- **(b) The two tables of plan section 7.** `node proto/cardgame/probe.mjs gate=play` and `gate=ship` print the PLAY table (6 bars) and the SHIP table (PLAY plus P2, P4, P5, P6, P10, L1, L2, the beginner, and P1). P1 is measured on the slice — boxing v BJJ, both seats, labelled as the substitution, never on wrestling, which is not in the build (STOP 5) — and L2 on the ladder's own ten real states per art from `simulateLadder`. Protocol per=200 seed=500000000 so the rows stay comparable to 6g; the gate's own bout seeds are fresh (crash run at 900M+). Raw: `out/gate-play.{txt,json}`, `out/gate-ship.{txt,json}`.
- **(c) The play log and its copy button.** `playlog.mjs` keeps, per career, every decision the player makes (pick, each training pick and its outcome, every answer, card, step and end turn, the bells, the bout's end, the verdict) with its seconds from the start of the career and its phase; a career ended by the cut, by the last defence or by his own New career button gets a `stopped` line, so "where it stopped" is in the log, not asked. The verdict screen carries one **Copy play log** button: the browser takes it to the clipboard; under the stub document (no clipboard) the same text is left on the table (`state.lastLogText`) for a reader or a test.
- **(d) The first-10-minutes script as the opening (plan section 3).** Minute 0:00: two fighters to pick, two lines each — *where he wins* and *his one rule* (the boxer: standing, in the pocket, clean punches and the knockout; combinations. The BJJ man: on the ground, from underneath, the tap or the pass points; the guard). Minute 0:30: the first bout is club level and the rival's **first volley is one card** (`oneCardFirstVolley`, a pure wrapper tested directly — the pilot wants three, the player sees one; his next volley and every later bout is the full line), so the first answer is one card against one and the table shows what each answer does. Minute 3:30: the verdict says **in one line why the bout ended**, built from the engine's own final state (`whyLine`: knockout / points lead with the lead number / tap / pin / cards with both scores) and tested to match the finish in both chairs. The rest of the script was already on the table in 6g: the strip greys the hand off the ground, the result shows rung and rank, training prints cost and failure, a loss drops one rung, never below the club.

### PLAY gate (measured, `out/gate-play.txt`)

| # | Bar | Measured | Result |
|---|---|---|---|
| 1 | The page's module graph links (a broken import fails the test) | ui.js linked under the stub document | PASS |
| 2 | A scripted player finishes a bout and a ladder step through the page's own calls | 1 bout to a verdict; then verdict, training, the next bout on the table | PASS |
| 3 | The printed numbers equal the engine's | 58 card lines, steps and previews checked; 0 mismatches (`printedProblems`, also a node test) | PASS |
| 4 | D1: 22.5–45 decisions a bout, 95% under 52 | 30.7 decisions; 95th percentile 48 | PASS |
| 5 | Every pairing inside 40–60 | boxing v bjj: 50.2 / 49.8 | PASS |
| 6 | No crash in 1,000 bot bouts | 1,000 of 1,000 clean | PASS |

**PLAY GATE: PASS (6/6).**

### SHIP gate (measured, `out/gate-ship.txt`)

| # | Bar | Measured | Result |
|---|---|---|---|
| 1–6 | (the PLAY rows above) | (as above) | PASS |
| 7 | P2: each way to win ends 15%+; early 40–70%; a pilot blind to any one loses 5+ | KO 18.0 lead 16.0 tap 25.0 pin 0.0; early 59.0; blind health 21.5, points **−1.5**, hold 6.4 | **FAIL** (points-blind) |
| 8 | P1 (slice, boxing v BJJ): 3+ ranges ≥80%, neither wins >60%, ≤37.5 decisions | 3+ ranges 84.8%; 50.2 / 49.8; 30.7 decisions | PASS |
| 9 | P4: pairing 40–60%; each art's average 47–53 | 50.2 / 49.8 | PASS (this draw; 6g showed 46.8–53.8 over ten seeds, mean 51.1) |
| 10 | P5: the hold is a readable race (printed answer 100%; ends 15–30% of ground bouts; 20–80% of holds finish) | 100.0% of 119 held turns; ends 27.0; finish 47.6 | PASS |
| 11 | P6: each art plays differently (mechanic off >50% of its turns; blind judge ≥90%) | boxing **46.5** / bjj 100.0; judge 90.5 | **FAIL** (boxing's mechanic clause) |
| 12 | P10: the pilot flies every deck (AI no more than 5 below the scripted) | boxing AI 47.5 / scripted 59.0 (**−11.5**); bjj AI 49.5 / scripted 38.5 (+11.0) | **FAIL** (boxing line) |
| 13 | L1: 30–70 titles in 100 | 48/100; 31.0 modelled minutes a run (8 s a player decision) | PASS |
| 14 | L2: every training option best in 1–6 of ten real ladder states (from simulateLadder) | boxing 2/4/3/1; bjj 5/2/2/1 | PASS |
| 15 | The beginner at 25–40% (the impatient line against the AI, per art) | boxing **49.5**; bjj **0.0** | **FAIL** (both lines) |

**SHIP GATE: FAIL (11/15).** The four failures are exactly the territory round 9 exists for (plan section 12: "the slice to the SHIP gate, sized by hand" — Kalli writes the two decks' numbers with a one-line reason each, then the pair cards, the ladder Edges and the beginner lesson). P2's points-blind and P6's boxing mechanic fail for the reasons 6g measured (the points ride on the cards the pilot plays anyway; the boxer spends most of his turns on top of the guard with nothing of his to lay), and this draw's P2 points-blind is even smaller (−1.5 vs 6g's 2.2). P10/beginner is the impatient/scripted line's draw variance, the same variance 6g documented on P4 (ten seeds 46.8–53.8): the scripted boxer line is the high draw this time. Nothing here is tuned; the card allows no rule or number change.

### Form, tests, and cuts

- **Form:** unchanged — one strip, face-up rally, wind pool, three clocks, judges by cards. The only behaviour change a player sees is the opening: two fighters with their two lines, the first volley of one card, and the one-line why at the verdict.
- **Tests:** `node --test proto/cardgame/*.test.mjs` **40/40** (was 36); legacy `node proto/cardgame-legacy/rules.test.mjs` 32/32. Added: the printed numbers equal the engine's (58 lines, `printedProblems` in `ui-text.mjs`); the play log records each decision with its seconds, the copy button returns it, and the career's last line is where the player stopped; the first volley is one card (the wrapper tested directly, the page tested through a played bout); the verdict's why-line matches the finish in both chairs. Adapted, not weakened: the pick-screen test now expects the round-7 opening's words (`PICK YOUR FIGHTER`, the two lines per fighter) in place of `PICK YOUR ART` — same intent, the screen renders two fighters. The 500-line rule holds (largest file 347 lines, the test file).
- **Cuts:** the SHIP gate's four failing rows are reported, not tuned. The gate's page row uses the same seeded career as the tests (seed 640); the crash row's 1,000 seeds are fresh so a seed-specific crash cannot hide behind the protocol draw. Visual gate: unchanged from 6g — no browser in this workspace; the page was served over HTTP (all modules 200) and played by script through the DOM stub, not seen. Claude's scripted session: picked the boxer, trained Jab timing (Jab II landed in the bout), won the club bout by knockout — the verdict said "Knockout - Club challenger's health reached 0." — advanced to Area at rank #92, started the Area bout, and pasted the play log (43 decisions, pick to bout 2).

## 6i. Round 8 result **[R8]** (TASK CARDROUND8 — the guide; `proto/cardgame/`, harness `probe.mjs gate=play` / `gate=ship`; tag `card-r8`)

**Verdict: PASS on the one thing — the first bout of a new career runs with a coach: six lines, one at a time, each at the moment its thing first happens, each pointing at its element on screen, each generated from the engine's numbers; the node test sees them exactly once in order in bout 1 and none in bout 2; the PLAY gate stays 6/6 and the suite is 47/47.** The owner's round-7 log (S541: lost bout 1 by knockout with no warning; Cover up 7 of 12 answers; Step in/in/out/out/in in 4 s; a turn ended with no card; first answer 41 s; "i didnt understand the design, maybe a guide would be useful") is answered line for line: his volley and what an answer is (line 1), the strip and what Step in/out does (line 3), wind and why a card is greyed (line 2), the warning before he picks (item 3). The only game change is the first bout's opponent (item 2); its win rate is below.

### The one thing, in its five parts

- **(a) `guide.mjs`: the six lines and their moments.** One table, `GUIDE`, in the brief's order — *His volley; Wind; The range strip; Laying cards; Points, health and the ways to win; The bell and the rounds* — each `{ id, title, target, text() }`. `text()` is a function that reads the engine when the line is spoken (`N.back`, `N.cap`, `N.stepW`, `N.hp`, `N.lead`, `N.rounds`, `N.turns`, the strip's four keys), so no number is typed into a sentence and none can drift from `sized.json`; the test mutates `N.lead` and `N.turns` and reads the new numbers in the words. `target` is the id of the element the line points at (`volleysheet, wind, range, hand, score, rounds`); `guideMoment(id, ctx)` says when a line is due from what the coach can see of the bout (the answer table up; your own hand and wind on screen; a point or a point of health moved; the bell rung or the bout ended), and `nextGuideLine(seen, ctx)` returns the **first unsaid line whose moment has come** — a line whose moment has not come holds the rest, so the order is the brief's, always.
- **(b) The coach card (`ui.js`).** `coachDue()` is asked by every screen: null unless the guide switch is on and this is the first bout of the career (or its verdict, where a line still unsaid is said). `paint(html, due, wire)` renders the screen and, when a line is due, ONE card over it (`.coach-veil` + `.coach`: tag, title, one or two sentences, **Got it**) and wires only Got it — never more than one line on screen. The target element carries `.coach-target` (a gold ring above the veil, so it is seen lit under the card). Got it pushes the id into `state.guideSeen`, logs `coach: <title>` to the play log, and renders; the scripted player in the tests and in the gate clicks it before anything else. The bell line is due at the first bell (`wrapRound`) and, if the bout ends first, at the verdict (the verdict carries `#rounds`: "The bout ended in round r of N").
- **(c) The low-health warning (item 3).** `volleyThreat(S, m)` clones the bout and runs `resolveIncoming` on it with no answer — the engine measures its own volley, so the warning can never disagree with the resolution. `ko` if it would take the health to 0, `low` if under a quarter; `threatLine` gives the red line ("This volley knocks you out unless you answer." / "…under a quarter of your health…"), printed by `answerTable` as `<p class="warn" id="warning">` above the answers, before the player picks. Tested iff: shown when and only when the laid volley would KO.
- **(d) The How to play page and the switch (items 4 and 5).** A **How to play** button on every screen (pick, training, fight, verdict, the page itself): one page — a small picture of the strip (`rangeStrip(null, 'picture')`: KICK - PUNCH - CLINCH - GROUND in a row), the same six lines as the guide (`howtoLines()` renders `guideLines()`, six `.howto-line`s, under the ten-line bar), and the switch **Coach lines: ON/OFF**. The switch is on for a new career (`state.guide = true` at the pick) and turns itself off when the player leaves the first bout's verdict; the page's switch turns it either way.
- **(e) The first bout's opponent (item 2) — the only game change.** `rivalFighter(career, 0)`: for `career.bouts === 0` the rival is **the other art** at the softest club deck — the printed deck with his three best cards swapped for his cheapest (`RIVAL_RECIPE[0] = { swap: 3 }`) — and `rivalPilot(0, career)` flies him by **that art's own priority list** (`scripted`), so a BJJ novice really sits to guard in the first bout (the impatient line cannot: at KICK a grappler has no card to lay). After the first bout a club novice is what he was in round 6 — the player's own art, diluted, impatient corner — so the ladder's club bouts and L2's states are unchanged from 6h. From Area up, unchanged. Measured over 400 seeds per art, first bout only:

| Who plays the first bout | Boxing v the BJJ novice | BJJ v the boxing novice | Lost by KO in round 1 |
|---|---|---|---|
| the AI pilot (the gate's player) | **56.3%** | **56.0%** | 0/400, 0/400 |
| the page's own scripted line (the tests' player) | **57.8%** | **0.0%** (281/400 by KO, over 3 rounds) | boxing 0/400; bjj **4/400** |
| a reader (answers the dearest card, pulls guard) | 57.8% | **24.5%** | 0/400, 0/400 |

The first bout may be lost, as the brief allows, and the boxer's is a coin flip; the page's own bjj line — which lays the first card in its hand and never pulls — loses to the boxing novice, and in 4 of 400 seeds in round 1, before the bell line (the verdict still says it). A player who reads the first five lines is not knocked out in round 1 (0/400 as either art). Before round 8 the club novice was the player's own art: the AI pilot won 99.5% (boxing) / 97.0% (bjj) of club bouts against him — the first bout is now a bout, not a walk-over, and it teaches the two arts' difference as plan section 3 asks.

### The guide's lines, in order (as rendered with `sized.json`)

1. **His volley** → the volley sheet. *His volley is face up: what he throws this turn, a card or a step at a time. A card can be answered - each answer says what it stops; a step only moves the bout.*
2. **Wind** → the wind stat. *Wind pays for your cards. The number by your name is what you have now; 3 comes back at the start of each of your turns, up to 5. A greyed card costs more wind than you have, or does not work where you stand.*
3. **The range strip** → the strip. *The strip is where the bout stands: KICK - PUNCH - CLINCH - GROUND. Every card says the range it works at. Step in costs 1 wind and takes you a range in; Step out costs 1 wind and takes you a range out.*
4. **Laying cards** → your hand. *Lay your cards one at a time: each is paid in wind and resolves on his turn. End turn when your volley is laid.*
5. **Points, health and the ways to win** → the score strip. *Health is 42; points come from clean punches and takedowns. The ways to win: a knockout (his health gone), a points lead of 7, or a hold - a submission or a pin.*
6. **The bell and the rounds** → the round/turn stat. *2 rounds of 7 turns each. At the bell the last volley is resolved; the next round starts standing.*

### PLAY gate (measured, `out/gate-play.txt`)

| # | Bar | Measured | Result |
|---|---|---|---|
| 1 | The page's module graph links (a broken import fails the test) | ui.js linked under the stub document | PASS |
| 2 | A scripted player finishes a bout and a ladder step through the page's own calls | 1 bout to a verdict (by ko); then verdict, training, the next bout on the table — Got it clicked at every coach line | PASS |
| 3 | The printed numbers equal the engine's | 58 card lines, steps and previews checked; 0 mismatches | PASS |
| 4 | D1: 22.5–45 decisions a bout, 95% under 52 | 30.7 decisions; 95th percentile 48 | PASS |
| 5 | Every pairing inside 40–60 | boxing v bjj: 50.2 / 49.8 | PASS |
| 6 | No crash in 1,000 bot bouts | 1,000 of 1,000 clean | PASS |

**PLAY GATE: PASS (6/6).**

### SHIP gate (measured, `out/gate-ship.txt`)

| # | Bar | Measured | Result |
|---|---|---|---|
| 1–6 | (the PLAY rows above) | (as above) | PASS |
| 7 | P2 | KO 18.0 lead 16.0 tap 25.0 pin 0.0; early 59.0; blind health 21.5, points −1.5, hold 6.4 | **FAIL** (points-blind, the 6g clause) |
| 8 | P1 | 3+ ranges 84.8%; 50.2 / 49.8; 30.7 decisions | PASS |
| 9 | P4 | 50.2 / 49.8 | PASS |
| 10 | P5 | printed answer 100.0; ends 27.0; finish 47.6 | PASS |
| 11 | P6 | boxing **46.5** / bjj 100.0; judge 90.5 | **FAIL** (boxing's mechanic, the 6g clause) |
| 12 | P10 | boxing AI 47.5 / scripted 59.0; bjj AI 49.5 / scripted 38.5 | **FAIL** (boxing line) |
| 13 | L1 | **52/100** titles; **29.9** modelled minutes a run (6h: 48, 31.0) | PASS |
| 14 | L2 | boxing **3/4/2/1**; bjj **5/2/1/2** (6h: 2/4/3/1, 5/2/2/1) | PASS |
| 15 | The beginner | boxing **49.5**; bjj **0.0** | **FAIL** (both lines) |

**SHIP GATE: FAIL (11/15)** — the same four rows as 6h, for the same reasons; nothing was tuned. One note on the way: the round was first built with the other art at **every** club bout, which moved L2 to boxing 3/5/2/0, bjj 6/1/3/0 (FAIL) — the training states came from bouts the ladder's own club line had never fought. Narrowed to the first bout alone (what the brief names), L2 is back in its bar and L1 sits where 6h did within the draw.

### Form, tests, and cuts

- **Form:** unchanged — one strip, face-up rally, wind pool, three clocks, judges by cards; no rule or number touched (`sized.json`, the engine numbers and every card are round 6b's). What a player sees new: the coach's card at each new thing in the first bout, the red warning line in the answer table, the How to play button and page, the other art across the table in bout 1.
- **Tests:** `node --test proto/cardgame/*.test.mjs` **47/47** (was 40): engine 29, ui 18. Added: the guide shows each line exactly once in the first bout, in order, with its element on screen and highlighted, and the play log has the six `coach:` lines; the lines are generated from the engine's numbers (mutating `N` changes the words); the warning shows iff the laid volley would KO (over a sweep of laid volleys and healths, through `answerTable`); the How to play button is on every screen and its page holds six `.howto-line`s and the strip picture; the switch is on for a new career, off after the first bout, and the page's switch turns the coach off; the first bout is against the other art at a club novice's deck and his corner plays his art (`state.first === 1`, the volley opens the bout); the first bout is not lost by a knockout before the coach's last line (120 seeds per art, the boxer by the page line, the BJJ man by the reader — 0 round-1 KOs). Extended, not weakened: engine test 27 ("the other art at every rung") now also checks the first-bout exception — once a bout is fought, a club novice is the player's own art with the impatient corner; ui test 7 ("a rival is the other art with better cards at every rung, and a club novice is the weakest") keeps its intent. Adapted: tests 3, 4, 6, 9 assert `His volley, face up` or `Choose a card or end your turn` where they said `End turn` — the answer screen has no End turn, and the first bout now opens on it. The 500-line rule holds (largest file 354 lines, `ui.test.mjs`); legacy `node proto/cardgame-legacy/rules.test.mjs` 32/32.
- **Cuts:** no browser in this workspace for Claude — the page was served over HTTP (every module 200) and the first bout was played by script through the DOM stub with the guide on (ui test 12, gate row 2), not seen; the owner's play is the visual gate. A live preview of `proto/cardgame/` is left running for him. The page's own bjj line is 4/400 round-1 KOs (above); not tuned — the coach's five lines before the bell are the fix the brief asks for, and a player who reads them is not knocked out in round 1.

000. **[R5] Seven arts, and what "balanced" should mean.** Kickboxing is in (his S538 ask). With every art playing its
   own way the table reads like a sport (the wrestler beats the boxer, karate beats the sambo man) and two of 21
   pairings fall outside 40 to 60. Claude's plan is to bring those two back inside (section 8). His to say after he has
   played a turn: should every pairing be near even, or may an art have a bad matchup, as in the sports?
00. **[R4] His limb points: probed, and the single wind pool measured better (6d).** His idea, his "maybe"; kept
   from it: a hurt leg as a status. His to overrule after he has played a turn. **[R4] The six arts are in**, on one
   strip; whether a turn with four ranges still feels "fast and punchy" (3.3 minutes by the bots) is his to say at the
   first page.
0. **[R3] The form changed to the rally (Claude, under FREE HAND).** It is his to veto after he has played phase 2:
   the question for him is only "does a turn feel fast and punchy", which no bot can answer.
1. **Where it lives. [R3] Decided by the owner (interview): standalone.** The link to the gym game is no longer a
   phase; section 3.7 stays as a note for later.
   ~~The page describes a card game that can stand alone (the 8-bout run) and can also be fight night
   inside FightCamp (3.7). Phases 1 to 6 build it standing alone in the browser, as the prototype was; phase 8 is the
   link. Whether it replaces the 30-second-call fight night or sits beside it is his call after he has played phase 2.~~
2. ~~He is better on paper.~~ **[R2] Decided: the lead changes hands and the paper is equal.** Decided by Claude under
   the owner's FREE HAND (S534: "you can remove, add from scratch or interconnect") because the fresh critic showed it is
   a structural fix, not a taste: it is what lets him tire, gives his guards and traps a use and gives the player a trap
   of her own to set. It did not cost a second rule set: the same exchange rules serve both corners. Probed in round 2.

## 8. The build plan **[R3: revised]** (one job a phase; each ends on its test and its fun bar)

Changed in round 3: the plan builds the rally (3R), not the three-beat exchange; the owner plays at phase 2, before any
more bot rounds, because the open question is now feel, not arithmetic; phase 8 (the link to the gym game) is gone
(owner: standalone). Phase 0 is small and named.

| Phase | Builds | Test | Fun bar to pass before the next phase |
|---|---|---|---|
| 0. Round 4 on the greybox (no page), one job | Only the causes 6c names: (a) the trap as a card worth its place (tried and not enough: thrown away when unsprung; to try: it does not take a hand slot, or it pays 1 wind when it comes back); (b) the price ladder (Uppercut 3 and Tie up 4 are dead, 1-wind cards are good everywhere): Uppercut cannot be blocked at all, Tie up back to 3 with one a deck; (c) body work: only a clean Body hook takes wind, the Body jab does not; (d) the open class shows his trap face up for two rounds, so the set card is taught before it bites; (e) the corner as orders with a cost (critic item 7 of round 1) | `node proto/cardscope3/engine.test.mjs`, then `node proto/cardscope3/probe.mjs run3` and `report.mjs run3` | C11, C8, B6, C6, C12 as written, and nothing that passes now may fail. The critics score the page in parallel; if both are under 8 after phase 2 the owner gets "cut it or keep it" |
| 1. The rules module | `proto/cardbout/rules`: the turn (answer, then throw), wind, the trap slot, knockdowns, judges, the bout, seeded; ported from `proto/cardscope3` (cards.mjs, engine.mjs) with its 29 checks | `node proto/cardbout/rules.test.mjs` | D1, D3, D4, B1 to B5, C1 to C5 re-measured on the new module, same numbers as the greybox |
| 2. The table | One page built to 3R "the table shows every number": his volley face up with the result under each punch and under each guard in hand, your volley with the chain marked, the set card with what he can still hold, wind pips, three judges' scales, the knockdown mark; novice and open-class opponent | a page test that plays a seeded bout through the page's own calls; the printed numbers equal the rules module's | C10 on the page's own numbers. **The owner plays 3 bouts:** a bout takes 3 to 6 minutes; he calls it fast and punchy or not; after each turn he can say why it went the way it did; he wins 1+ of 3 at open class |
| 3. The opponents | 8 boxers (two a style), each with two habits, a weapon and his own deck; the five classes; what his corner has noticed about your leads shown as a chip | harness block "opponents" | B18 (every pair 40 to 90%), C12, B16 (8+), C11 |
| 4. The card pool | Whatever phase 0 kept, plus Sharp and Signature versions and named combinations as drills; deck rules enforced in the picks | harness block "cards" (the card table) | B6, B13, C8, C9, D5 |
| 5. The corner and film | Corner orders with a cost each; film finds one habit before the bell | harness block "corner" | B17, B15 |
| 6. The run | The 8-bout ladder: drill / drop / film / rest, perks, damage carried, three losses | harness block "run" | B7 on the real run; a good bot finishes 30 to 50% of runs; a run takes 35 to 50 minutes |
| 7. Words and feel | True lines for each punch as it lands, the flip of the trap, sound, speed of the volley | line test: no line contradicts what happened | The owner plays a full run; after a loss he says "I lost because of what I played, not because of what he had" |

**[R4] The plan after round 4.** Phase 0 is now **round 5 on `proto/cardscope4`** (one job, no page): the two failing
core bars and nothing else - (a) each style's mechanic as a rule about what is playable, and one place on the strip
per art (P6); (b) the hold's printed rule reworded and the pin made worth its room (P5); (c) the numbers polished by
hand where the search left them odd, the table re-measured (P4 must still pass); then P7 (seven rulesets as a tour),
P8 (cross-training) and P9 (the animation budget: time first, then one strip per art through the existing sprite
baker). Then two fresh critics (Kalli and a code-checked one), 8+ on DEPTH and PLAY before any page. Phases 1 to 7
build the rules of `proto/cardscope4`, not of cardscope3: the six-style table replaces the eight boxers, the strip and
the three clocks replace the judges. **Asynchronous ghost battles** (owner S537) come after phase 6, the run: the pilot
and the 15-id deck file they need exist already (3S).

**[R5] The plan after round 5.** Phase 0 is **round 6 on `proto/cardscope5`** (one job, no page), four items and
nothing else: (a) **the table**: the kickboxer gets one answer to the ground (his one copy of Check becomes a card
that also frees a caught leg, or a second Escape) and the guard pull stops being one price (BJJ must not swing from 47
to 75 on 1 wind): then `tune2.mjs` with pair-specific cards, P4 measured again; (b) **the judge**: its instrument is
fixed first and committed before the run (each action filed where it lands, a kick, a punch and a knee as kinds),
then boxing, kickboxing and sambo get one thing at PUNCH range the other two never do, and wrestling one thing on top
judo never does; (c) **the clocks probe** blinds all three hold weights, and the submission is looked at again (the
tap fell from 23.8 to 11.6%); (d) **the beginner** (20.5%): each art's one rule taught on the table, R-C11 re-measured.
The numbers the search left odd are polished by hand in the same job. Then P7, P8, P9 and the two fresh critics as in
the round 4 plan. Phases 1 to 7 now build the rules of `proto/cardscope5`.

No phase starts before the one above it has passed its bar, except that phase 0 and phase 1 may run side by side (the
rules port does not depend on the numbers). A fresh critic scores this page first (`CARDSCOPE3_CRITIC_KALLI.md` is
queued; a second, code-checked critic is a later SDK job).

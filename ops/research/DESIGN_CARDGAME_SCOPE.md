# The card game - the whole scope (CARDSCOPE1, 2 and 3, S537)

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

## 7. Open decisions for the owner (taste and scope only)

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

No phase starts before the one above it has passed its bar, except that phase 0 and phase 1 may run side by side (the
rules port does not depend on the numbers). A fresh critic scores this page first (`CARDSCOPE3_CRITIC_KALLI.md` is
queued; a second, code-checked critic is a later SDK job).

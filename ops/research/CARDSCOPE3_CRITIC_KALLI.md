# Critic brief: the card game, scope round 3 (CARDSCOPE3, S537) - you are a FRESH critic

You judge a DESIGN, not a build: the scope page for a standalone card game in which a boxing bout is fought with
cards. Only a bot greybox exists (rules and bots, no page); nobody has played it. Be blunt; a kind score is useless.

**The owner outranks you and us.** Read PART 0 first: his own answers. He wants a bout that is FAST AND PUNCHY (he
picked that over "chess-like reading" and over "tense gamble"), about 5 minutes, quick turns, every number shown on
the table, a standalone game, and he named the card games he enjoys. Judge the design against THAT taste. A change
that makes a bout slower, longer or more of a sum must say what it buys him.

Then read PART 1, the scope page. Round 3 changed the form: read its sections 2b (why, and what his reference games
do), 3R (the design: the rally), 4c (the bars, written before the run), 6c (the result) and 8 (the build plan).
Sections 3, 6 and 6b are the record of the two earlier rounds (a three-beat exchange with a hidden card) and are there
so you can see what was tried and measured; do not score them. PART 2 is the bot probe's full table. PART 3 is the gym
game this grew out of (facts only; the card game no longer has to connect to it).

Score, each out of 10, with the reasons:
1. DEPTH - real, repeated decisions with trade-offs; skill beats luck; no dominant card, deck or line; something to
   learn over ten bouts that is not arithmetic.
2. PLAY - would this be fun for an evening for THIS owner: speed, punch, agency, surprise, comebacks, a reason to
   start another bout and another run.
3. GENERAL - clear, consistent, buildable, nothing useless.
The bar (owner S534): 8+ on DEPTH and 8+ on PLAY, or it does not go on.

Also answer, each in a few lines:
- **The form.** Is the rally (he throws face up; you answer with one guard, then throw back; one face-down trap each)
  the right form for fast-and-punchy boxing? If you know Hearthstone, Ironbound, Clutchtime, Kungfu Card, MMA Arena,
  Mixed Martial Cards, Rune Coliseum, Breachway, Starless Abyss or Monster Train from play, say what each does that
  this should steal and what it should avoid. If one of their structures fits better, describe one turn of it.
- **One guard a turn.** With a guard on every punch, guarding everything was automatic. With one, using it is nearly
  always right and the choice is which punch and which guard. Is that enough of a decision? What would make "do I
  guard at all" a real question without slowing the turn?
- **The trap.** Free to set, watches his lead punch only, comes back to the hand if nothing walks onto it. In the
  numbers it is a fork for the opponent (no kind over 43%) but a burden to its own deck. What is the right rule for
  the one hidden card in a fast game: what it costs, what it catches, what happens when it is not sprung?
- **The beginner.** A rule of thumb (right guard on the biggest punch, then jab, cross, hook; never sets a trap,
  ignores his) wins 84% at novice, 48% at open class and 20% at regional (the bar asks 25 to 40). A player who only
  reads the printed numbers wins 47%. Is teaching the set card enough, or must the rules carry the beginner further?
- **The bars that still fail** (PART 2 names each with its cause, the page's section 6c and phase 0 of section 8 give
  our answer). For each: is our answer right, and what would you do instead? Our answers are proposals, not measured.
- **Cards.** Which of the fourteen are missing a job, which are useless, what is missing, and what each change does.
  The 1-wind cards are good against everybody and the 3 and 4-wind cards bad against everybody: is a 3-wind-a-turn
  economy too tight for a price ladder?
- **The run.** Eight bouts, a pick between bouts. What would make him start a second run?

End with **To reach 10/10**: the concrete changes that would take it to 10 for this owner, most important first, each
specific enough to build and to measure with bots (owner S405). Then describe your 10/10 table for one turn, the
moment you have his three punches in front of you and a card set against you, as a 1920x1080 page (an HTML file is
welcome) (owner S411).
Plain words; names only in headers (the body says "your boxer", "the opponent").

---

# PART 0 - the owner on the card game (read first; it outranks every critic)

# The owner on the card game - interview S537 (2026-11-22)

His answers, verbatim where quoted. Every card-game scope, critic and build job reads this first; it outranks a critic's
taste.

- **Card games he enjoyed:** "breachway, hearthstone, clutchtime, rune coliseum, starless abyss, mma arena, monster train,
  mixed martial cards demo, kungfu card" and "i also like a lot ironbound". These are the reference set - study what each
  does well (our words and numbers only; nothing copied). Two are fight-sport card games (MMA Arena, Mixed Martial Cards):
  closest to ours.
- **How one bout should feel:** "Fast and punchy" (picked over chess-like reading and tense gamble). Quick turns, lots of
  action, a bout under ~5 minutes. Depth must come without slow sums.
- **Where it lives:** "its standalone prototype" - a standalone game for now; the link to the gym game is not the goal.
- **Help on screen:** "Show me everything" - preview damage and results as each card is placed; the skill is the choice,
  never the arithmetic.
- **Form:** any card-game variation, "as long it can reach 10/10" (earlier the same day).

## What this changes in the S537 scope (Claude)
- CARDSCOPE1's bout (twelve exchanges, 5-8 min, a three-beat puzzle) is too slow for "fast and punchy": a bout of ~5 min,
  fewer and faster turns, full previews.
- Phase 8 "the link" leaves the plan; a standalone run is the product.
- The reference set replaces the brief's list (Slay the Spire, Balatro, ...) as the games to beat.

---

# PART 1 - the scope page

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

---

# PART 2 - the bot probe, round 3

# CARDSCOPE3 - the bot probe of the card game scope, round 3 (S537)

Design: `ops/research/DESIGN_CARDGAME_SCOPE.md` (2b the form, 3R the design, 4c the bars, 6c the result). Greybox:
`proto/cardscope3/` (plain node, no page, no Godot; `proto/cardscope` is rounds 1 and 2 and was not touched).
Read first: `ops/research/OWNER_CARDGAME_INTERVIEW_S537.md` (fast and punchy, about 5 minutes, every number shown).
`node proto/cardscope3/engine.test.mjs` -> RESULT: PASS - all 29 checks green.
`node proto/cardscope3/probe.mjs run2 per=400 card=800 runs=400` then `node proto/cardscope3/report.mjs run2` print the table below.

## Verdict: FAIL (run 2: 18 of 24 core bars, 3 of 11 supporting; run 1: 14 of 24 and 4 of 11)

The form changed: the three-beat exchange is gone, the bout is a **rally**. He throws his punches face up; on your
turn you answer them with one guard (or take them), they land at once, and you throw back; each boxer has one
face-down trap that watches for one kind of lead punch. What round 2 named as the real fault is fixed by rule: a punch
does not stop a punch, so a boxer who never guards wins 1.8% of bouts against 59.1% for the one who chooses, a third of
all punches are stopped, and Block, Slip, Roll and Parry are top-half picks against some style. A bout is 37 decisions,
5.0 minutes at 8 seconds each. A player who only reads the printed numbers, one card at a time, wins 47.1% where the
best bot wins 59.1% and the rule-of-thumb beginner 20.0%. It does not pass: the beginner is still 5 points short at
regional class (round 2: 4.3%), a thin deck of cheap punches wins the pro debut 67.5%, ten of fourteen cards have no
matchup swing, and three bars miss by a hair (C6 by 0.3, B15 by 0.2, D2 on one clause).

## What changed for round 3 (round 2 finding -> change)

| Round 2 finding | Change in the greybox |
|---|---|
| The owner: fast and punchy, about 5 minutes, quick turns | One card at a time. A turn is "answer, then throw". 3 rounds of 3 turns each. 5 choices in front of you at a decision (round 2: 112 legal answers an exchange). |
| The answering boxer wins by hitting, so guards are worth nothing | Punches no longer meet on a beat. His volley lands on you unless you stop it; hitting back stops nothing. A guard is played against a punch you can see, so it never misses. |
| A punch answers the hidden card half the time | The hidden card is a trap in its own slot. It watches the first punch of your volley only: the question is what to lead with (jab / cross or uppercut / hook), or to throw nothing. |
| Four Check hooks break the debut; every sizing crowns the card that takes his next action | At most 2 of each trap. No card takes his next action or his cards any more; a trap makes one punch miss and lands 8. |
| A rule-of-thumb beginner wins 4% at regional | "Guard what you see, then jab, cross, hook" is now a legal, sound-looking line; the table prints the result of every guard and every punch before you commit. |
| He tires only through one card | Wind is short for both (3 back, top 6): a boxer starts 11.7% of his turns on 2 wind or less, from body work, a knockdown, or having spent it. |

## How it was run

- Bots in the player's chair: random; the best of 400 fixed lines (a fixed order of card names played top down; best 5
  re-measured on fresh seeds); greedy (damage thrown less damage taken, blind to traps); beginner (the rule of thumb:
  right guard on the biggest punch, then jab, cross, hook; sets no trap, ignores his); table player (one card at a
  time on the printed numbers); reader (public information only); all-seeing (shown his trap and his hand: a ceiling).
- Population: 4 player boxers x 4 opponent boxers from other clubs, one of each style, all different in cards and head
  points, never the same boxer on both sides; 400 bouts a pair a bot (6,400 an arm); card table 800 bouts a cell;
  400 runs of 8 bouts; breaker search 32 decks and two rounds of one-card swaps, the best five re-measured on 1,000 bouts.
- The round 3 bars were written and committed (573c584a1) before any round 3 code existed and were not edited.
- **Sizing before run 1, on its own seeds (300000 and up, `calib.mjs`, `diag.mjs`, small probes), changed two rules, not
  only numbers.** (1) With a guard allowed on every punch, guarding everything was automatic (free choice 58%, "guard
  all" 57%), 40% of volleys landed nothing and a trapless deck of guards won 90%: now **one guard a turn** (a Parry is
  extra). (2) A trap at 2 wind that was thrown away unsprung was a card no deck wanted: now a trap is **free, watches
  the lead punch only, and comes back to the hand** if nothing walks onto it. Also sized there: the first thrower of a
  round gets less wind back (he won 60% without it), no wind back for the answer at the bell, head points, decks.
  The sentence in 4c "a guard on any of them" therefore reads "one guard on one of them"; no bar changed.
- Two measured runs: run 1 as sized; run 2 after the one resize (numbers only: Parry 1 wind not 0, Tie up 4 not 2, the
  first thrower 1 wind less not 2, knockdown line 18 / 14 not 16 / 12, a trap does 8 not 6, ice 14 not 10).
  **The design-change run was not spent.** Two candidates were tried on sizing seeds: an unsprung trap thrown away
  face up (17 of 24: the last clause of D2 passes, C1 and C4 fall out) and the body track cut (17 of 24: C6 and B15
  pass, C2 and D3 fall out). Neither beat 18, so run 2 stands as the result.
- Bots are not people: nothing below says a person enjoys it. The regional opponent is the reader's own planner
  without habit knowledge and with another deck.

## What failed in run 2, and the cause in the design

| Bar | Run 1 | Run 2 | Cause |
|---|---|---|---|
| C11 no cliff (beginner 70+ / 45-60 / 25-40) | 83.1 / 48.1 / 18.1 | 83.7 / 48.4 / 20.0 | Novice and open class pass. At regional the bar's beginner never sets its own free trap and leads jab-first onto his Check hook. The equally trap-blind damage chaser wins 21.4%; the table player, who reads the printed line under the set card, 47.1%. The set card has to be taught (open class: his trap face up for two rounds), not softened: trap damage 4, 6 or 8 moved the beginner by under 2 points in sizing. |
| C8 no breaker deck (50%) | 59.7% (two Tie ups, a Parry) | 67.5% (five Body jabs, three Jabs, three Crosses, Parry, Block, Slip, Roll) | No key card any more (C9: biggest lift +11.3). The winner is a thin deck of the cheapest punches with four guards and no trap. Body damage takes his wind for the rest of the bout and the Body jab buys it for 1 wind; and a trap is a burden to its own deck, so the style decks are weaker than a plain one (the neutral deck wins 29.8% of pro debuts, the four style decks 28.2%). |
| B6 every card has a matchup | 10 of 14 flat | 10 of 14 flat | Cross, Lead hook, Body hook and Roll swing by opponent. The 1-wind cards (Jab, Body jab, Block, Parry) are good against everybody and the dear ones (Uppercut 3, Tie up 4) bad against everybody: with 3 wind a turn the price decides first. The traps are bottom-half nearly everywhere (Check hook 5th against the volume puncher, Pull counter 5th against the pressure fighter): a trap that nothing walks onto comes back and sits in the hand where a punch would be. |
| D2 guards are worth something | fails on one clause | fails on one clause | Three clauses pass (never guards 1.8% v 59.1%; 31.8% of punches stopped; four guards top-half somewhere). "Guards all it can" is only 1.7 under free choice (bar 5): with one guard a turn, using it is nearly always right. The decision is which punch and which guard. |
| C12 habits rule and flip | 17.2% / B15 passes | 17.3% / B15 fails by 0.2 | A habit is on the table in 79% of his turns. It changes the volley in 17% of the turns where it applies (bar 30): a trap watches the lead only, so a habit can only change the lead, and the count of what he can still hold already says most of it (counting +9.1). |
| C6 no fixed answer to the set card | jab first -9.4 | jab first -9.7 | Three of four pass by 18 to 32 points. Leading with the jab is the cheap probe: it costs 1 wind and only the Check hook punishes it (28% of his traps). |
| B8 ladder | greedy under fixed | same | 4.7 / 30.9 / 21.4 / 59.1 / 64.3. The damage chaser is blind to traps; the best fixed line happens to set them. Reader over greedy by 38. |
| B11 stoppages 10-25% | 5.5%, 0.85 knockdowns | 1.8%, 0.39 | The resize raised the knockdown line to get close rounds (B5 and B14 pass in run 2). Head points 68 to 75 against 54 taken a bout: bouts go to the cards. |
| B12 no blanks (15% / 25%) | 19.2% / 15.1% | 19.5% / 15.7% | One volley in five lands nothing: a single punch met by the one guard. Dead cards pass. |
| B13 no dead card | passes | Tie up 2.9% | At 4 wind the Tie up is nearly unplayable; at 2 it was the best card against every style. It needs a rule, not a price. |
| B15 film and counting (4+ / 3+) | +4.4 / +9.8 | +3.8 / +9.1 | Counting passes for the first time in three rounds: what he can still hold is printed and it changes what you throw. Habits are 0.2 short. |
| B16 he reads you back (8) | 0.5 | 1.4 | His tally of what you lead with changes which trap he sets only when no habit applies. |
| B17 the corner | water always best | water always best | Informed 59.1%, always water 62.3%, random 49.0%. Wind is still the strongest currency; ice and "watch him" are wrong picks nearly always. |
| B18 styles 40-90% | 51.5 to 83.8 PASS | 37.8 to 79.8 | One pair under 40 after the resize (pressure fighter v volume puncher). Content sizing. |

Passed in both runs: B1 to B4, B7, B10, C1, C2, C4, C5, C7, C10, D1, D4, D5. Passed in run 2 only: B5, B9, B14, C3, C9, D3.

## Run 2 - after the one resize (the greybox as committed)

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 400 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 800 bouts a cell. Run: 400 runs of 8 bouts. Breaker: pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure 250 bouts an opponent.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 59.1% v best fixed line 30.9% = +28.2 (Jab > Tie up > Roll > Slip > Block > Parry > Cross counter > Lead hook > Pull counter > Body hook > Check hook > Uppercut > Body jab > Cross) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 59.1% v random 4.7% |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 30.9% on fresh seeds (screen 34.4%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 19.8% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **PASS** | 32.3% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Jab, Body jab, Uppercut, Block, Slip, Parry, Tie up, Check hook, Cross counter, Pull counter |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.6 wide offers of 8.0 a run; bouts won: informed 80.0%, random pick 64.7%, no pick 69.9%; wins a run 6.40 v 5.17 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 4.7 / 30.9 / 21.4 / 59.1 / 64.3 |
| B9 | The set card is a bet, not the game (all-seeing 5 to 20 over the reader) | **PASS** | +5.2 |
| B10 | Showing beats guessing (lead over random 10+ bigger with punches shown than unseen) | **PASS** | shown 54.5, unseen 17.9 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 1.8% stopped, 0.39 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (volleys from which nothing lands under 15%; dead cards under 25%) | **FAIL** | 19.5% of volleys, 15.7% of cards |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **FAIL** | Jab 19.9, Body jab 8.0, Cross 13.1, Lead hook 11.1, Body hook 12.6, Uppercut 5.0, Block 7.0, Slip 5.3, Roll 4.3, Parry 4.9, Tie up 2.9, Check hook 14.1, Cross counter 15.5, Pull counter 16.0 |
| B14 | Split cards (15%+ of points decisions) | **PASS** | 16.8% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **FAIL** | both habits known +3.8 (one habit +2.7), counting +9.1, the tally +0.0 |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 32.3% v a non-adapting opponent, 30.9% v the adapting one; a reader who always leads with the jab: 50.5% v 49.4% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **FAIL** | informed 59.1%, random 49.0%, always water 62.3%, ice 40.0%, watch him 41.2%; informed picks water 76.4%, ice 20.5%, watch him 3.2% |
| B18 | Styles (every pair 40-90% for the reader) | **FAIL** | lowest 37.8%, highest 79.8% |
| C1 (core) | Equal paper holds (reader 55-65% at regional) | **PASS** | 59.1% |
| C2 (core) | He tires (starts 5-15% of his turns on 2 wind or less) | **PASS** | 11.7% of his turns |
| C3 (core) | Nobody is the heavier hitter (damage dealt and taken within 10%) | **PASS** | dealt 59.5 and taken 54.4 a bout (ratio 1.09); 29.2% of wins with more head damage taken than given |
| C4 (core) | You set traps (the reader sets one on 30%+ of its turns) | **PASS** | 63.0% of its turns |
| C5 (core) | The set card is a fork (no kind over 55%; a trap down on 20-85% of his turns) | **PASS** | Cross counter 43.2, Check hook 27.8, Pull counter 29.0; a trap down on 59.9% of his turns |
| C6 (core) | No fixed answer to the set card (each of four forced answers 10+ under free choice) | **FAIL** | free 59.1%; always ignore 40.6%, jab first 49.4%, jabs only 34.5%, nothing 26.8% |
| C7 (core) | The answers spread (no class of first punch at a set card over 40%) | **PASS** | jab 36.7%, body jab 0.0%, cross or uppercut 16.1%, hook 22.1%, none 25.1% |
| C8 (core) | No breaker deck (no legal deck over 50% in the pro debut) | **FAIL** | best found: 67.5% (Jab, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Parry, Block, Slip, Roll, Body jab, Body jab); neutral deck 29.8% |
| C9 (core) | No pair is a key (no added pair lifts a pair-up by more than 25) | **PASS** | biggest lift +11.3 (Body jab v out) |
| C10 (core) | The table makes the skill a person can reach (table player closes half the gap, 10+ over the beginner) | **PASS** | beginner 20.0%, table player 47.1%, reader 59.1%: 69.3% of the gap |
| C11 (core) | No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional) | **FAIL** | beginner 83.7 / 48.4 / 20.0% |
| C12 (core) | Habits rule and flip (a habit on the table in 50%+ of his turns; the volley flips in 30%+ where one applies; B15) | **FAIL** | habit on the table in 79.0% of his turns; volley differs in 17.3% of 17289 turns where a known habit applies; B15 fails |
| D1 (core) | Fast and punchy (3-6 minutes: 22.5-45 decisions; 95% under 52) | **PASS** | reader 37.4 decisions = 5.0 min (95%: 42); table player 37.2 = 5.0 min (95%: 42) |
| D2 (core) | Guards are worth something (no guard -15, guard all -5, 30-70% of punches stopped, 2+ guards top-half somewhere) | **FAIL** | never guards 1.8%, guards all it can 57.4%, free 59.1%; 31.8% of punches stopped; top-half guards: Block, Slip, Roll, Parry |
| D3 (core) | The chairs are equal (first thrower wins 45-55%, reader v reader) | **PASS** | 52.9% (player chair 45.9%) |
| D4 (core) | Quick turns (choices at a decision under 10 on average, never over 20) | **PASS** | 5.0 on average, most 15 |
| D5 (core) | No trap deck (six traps under the neutral deck plus the best two) | **PASS** | six traps 5.3%, neutral + 2 Body jab 46.4% |

Core bars (B1-B7, C1-C12, D1-D5): 18 of 24 pass. Supporting bars (B8-B18): 3 of 11 pass. Verdict: **FAIL**.

Reader by pair (player out, press, counter, volume; each v opponent out / press / counter / volume): 44.5, 46.0, 72.3, 57.0, 58.3, 72.8, 58.8, 37.8, 47.8, 45.8, 61.5, 60.5, 73.8, 71.8, 79.8, 58.3

Opponent class (beginner / table player / greedy / reader): novice 83.7 / 95.0 / 84.0 / 96.6, open class 48.4 / 83.7 / 49.8 / 90.2, regional 20.0 / 47.1 / 21.4 / 59.1, title 9.8 / 32.5 / 11.5 / 44.1, professional 2.6 / 17.5 / 5.4 / 28.2

Best fixed lines: 30.9% Jab > Tie up > Roll > Slip > Block > Parry > Cross counter > Lead hook > Pull counter > Body hook > Check hook > Uppercut > Body jab > Cross; 30.9% Lead hook > Check hook > Cross counter > Roll > Slip > Body jab > Uppercut > Tie up > Parry > Pull counter > Body hook > Block > Jab > Cross; 30.0% Cross counter > Jab > Tie up > Pull counter > Slip > Check hook > Block > Body hook > Cross > Roll > Lead hook > Uppercut > Body jab > Parry; 29.2% Check hook > Slip > Tie up > Roll > Jab > Cross > Parry > Cross counter > Uppercut > Pull counter > Body hook > Lead hook > Body jab > Block; 18.5% Parry > Slip > Roll > Block > Jab > Cross > Lead hook > Body hook > Uppercut > Body jab

Breaker search, final measure: 67.5% swap round 2: Lead hook out, Parry in [Jab, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Parry, Block, Slip, Roll, Body jab, Body jab]; 62.1% swap round 1: Lead hook out, Body jab in [Jab, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Lead hook, Block, Slip, Roll, Body jab, Body jab]; 59.4% swap round 1: Cross out, Body jab in [Jab, Jab, Jab, Body jab, Body jab, Cross, Cross, Lead hook, Lead hook, Block, Slip, Roll, Body jab, Body jab]; 58.1% swap round 2: Jab out, Check hook in [Check hook, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Lead hook, Block, Slip, Roll, Body jab, Body jab]; 55.4% swap round 2: Jab out, Pull counter in [Pull counter, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Lead hook, Block, Slip, Roll, Body jab, Body jab]

What two more copies of a card are worth (reader win %, neutral deck alone: 54.6, 78.9, 82.1, 61.5):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 59.1 (4) | 78.8 (4) | 85.6 (3) | 50.1 (7) |
| Body jab | 65.9 (1) | 88.9 (1) | 90.8 (1) | 58.3 (2) |
| Cross | 46.5 (9) | 67.1 (8) | 70.9 (7) | 53.8 (4) |
| Lead hook | 49.5 (7) | 57.6 (12) | 66.9 (10) | 54.1 (3) |
| Body hook | 65.0 (2) | 61.6 (10) | 74.6 (6) | 42.0 (11) |
| Uppercut | 34.5 (12) | 49.1 (14) | 47.0 (14) | 45.0 (8) |
| Block | 57.6 (5) | 85.4 (2) | 84.3 (4) | 52.9 (5) |
| Slip | 50.3 (6) | 67.4 (7) | 78.8 (5) | 42.1 (10) |
| Roll | 34.8 (11) | 80.6 (3) | 69.1 (9) | 43.8 (9) |
| Parry | 62.8 (3) | 70.9 (6) | 86.9 (2) | 63.9 (1) |
| Tie up | 32.5 (14) | 63.1 (9) | 66.6 (11) | 32.0 (14) |
| Check hook | 49.1 (8) | 56.8 (13) | 65.1 (12) | 52.9 (5) |
| Cross counter | 36.6 (10) | 59.3 (11) | 69.3 (8) | 34.3 (13) |
| Pull counter | 33.4 (13) | 76.6 (5) | 61.3 (13) | 35.8 (12) |

## Run 1 - as sized before the first measured run

Population: 4 player boxers x 4 opponents (16 pairs), regional class, 400 bouts a pair. Card table: neutral 12-card deck + 2 copies of one card v each opponent boxer, reader, 800 bouts a cell. Run: 400 runs of 8 bouts. Breaker: pro debut (class 5, four rounds), reader, neutral boxer with the deck v each of 4 opponents; final measure 250 bouts an opponent.

| # | Bar | Result | Measured |
|---|---|---|---|
| B1 (core) | Reading beats a fixed line (15+) | **PASS** | reader 64.2% v best fixed line 36.0% = +28.2 (Lead hook > Check hook > Cross counter > Roll > Slip > Body jab > Uppercut > Tie up > Parry > Pull counter > Body hook > Block > Jab > Cross) |
| B2 (core) | Thinking beats not thinking (30+) | **PASS** | reader 64.2% v random 4.7% |
| B3 (core) | No line that needs no reading (best fixed under 45%, 10+ under the reader) | **PASS** | best fixed 36.0% on fresh seeds (screen 44.8%) |
| B4 (core) | Close fights (one-sided under 35%) | **PASS** | 21.8% one-sided |
| B5 (core) | Decided late (30%+ won from level or behind after round 2) | **FAIL** | 28.5% |
| B6 (core) | Every card has a matchup (top four v one style, bottom half v another) | **FAIL** | no matchup swing: Jab, Body jab, Body hook, Uppercut, Roll, Parry, Tie up, Check hook, Cross counter, Pull counter |
| B7 (core) | The run has choices (3+ wide offers a run; informed picks beat random picks) | **PASS** | 7.8 wide offers of 8.0 a run; bouts won: informed 82.9%, random pick 68.5%, no pick 73.2%; wins a run 6.63 v 5.48 |
| B8 | A ladder of skill (random < fixed < greedy < reader < all-seeing; reader 8+ over greedy) | **FAIL** | 4.7 / 36.0 / 26.5 / 64.2 / 68.8 |
| B9 | The set card is a bet, not the game (all-seeing 5 to 20 over the reader) | **FAIL** | +4.6 |
| B10 | Showing beats guessing (lead over random 10+ bigger with punches shown than unseen) | **PASS** | shown 59.4, unseen 21.1 |
| B11 | Stoppages 10-25%, knockdowns 0.3-1.0 a bout, round-1 stoppages under 3% | **FAIL** | 5.5% stopped, 0.85 knockdowns a bout, 0.0% in round 1 |
| B12 | No blanks (volleys from which nothing lands under 15%; dead cards under 25%) | **FAIL** | 19.2% of volleys, 15.1% of cards |
| B13 | No dead card, no card for everything (3%+ where held, none over 30%) | **PASS** | Jab 20.0, Body jab 8.0, Cross 13.2, Lead hook 11.1, Body hook 12.3, Uppercut 5.0, Block 6.9, Slip 5.2, Roll 4.2, Parry 5.3, Tie up 5.1, Check hook 13.7, Cross counter 15.0, Pull counter 15.9 |
| B14 | Split cards (15%+ of points decisions) | **FAIL** | 11.5% |
| B15 | Film and counting pay (habits known 4+, counting 3+) | **PASS** | both habits known +4.4 (one habit +3.0), counting +9.8, the tally +0.0 |
| B16 | He reads you back (best fixed line loses 8+ to the adapting opponent) | **FAIL** | fixed line 36.5% v a non-adapting opponent, 36.0% v the adapting one; a reader who always leads with the jab: 55.5% v 54.8% |
| B17 | The corner is a decision (informed 3+ over random; each card 15%+ of informed picks) | **FAIL** | informed 64.2%, random 47.2%, always water 69.5%, ice 35.3%, watch him 36.5%; informed picks water 78.2%, ice 18.7%, watch him 3.1% |
| B18 | Styles (every pair 40-90% for the reader) | **PASS** | lowest 51.5%, highest 83.8% |
| C1 (core) | Equal paper holds (reader 55-65% at regional) | **PASS** | 64.2% |
| C2 (core) | He tires (starts 5-15% of his turns on 2 wind or less) | **PASS** | 11.0% of his turns |
| C3 (core) | Nobody is the heavier hitter (damage dealt and taken within 10%) | **FAIL** | dealt 59.9 and taken 52.8 a bout (ratio 1.13); 20.6% of wins with more head damage taken than given |
| C4 (core) | You set traps (the reader sets one on 30%+ of its turns) | **PASS** | 62.0% of its turns |
| C5 (core) | The set card is a fork (no kind over 55%; a trap down on 20-85% of his turns) | **PASS** | Cross counter 43.2, Check hook 27.8, Pull counter 29.1; a trap down on 57.9% of his turns |
| C6 (core) | No fixed answer to the set card (each of four forced answers 10+ under free choice) | **FAIL** | free 64.2%; always ignore 46.8%, jab first 54.8%, jabs only 38.2%, nothing 31.3% |
| C7 (core) | The answers spread (no class of first punch at a set card over 40%) | **PASS** | jab 38.1%, body jab 0.0%, cross or uppercut 16.9%, hook 23.2%, none 21.7% |
| C8 (core) | No breaker deck (no legal deck over 50% in the pro debut) | **FAIL** | best found: 59.7% (Jab, Jab, Jab, Parry, Cross, Cross, Cross, Lead hook, Lead hook, Block, Slip, Block, Tie up, Tie up); neutral deck 31.5% |
| C9 (core) | No pair is a key (no added pair lifts a pair-up by more than 25) | **FAIL** | biggest lift +25.4 (Parry v out) |
| C10 (core) | The table makes the skill a person can reach (table player closes half the gap, 10+ over the beginner) | **PASS** | beginner 18.1%, table player 52.4%, reader 64.2%: 74.5% of the gap |
| C11 (core) | No cliff (beginner 70%+ novice, 45-60% open class, 25-40% regional) | **FAIL** | beginner 83.1 / 48.1 / 18.1% |
| C12 (core) | Habits rule and flip (a habit on the table in 50%+ of his turns; the volley flips in 30%+ where one applies; B15) | **FAIL** | habit on the table in 79.1% of his turns; volley differs in 17.2% of 17059 turns where a known habit applies; B15 passes |
| D1 (core) | Fast and punchy (3-6 minutes: 22.5-45 decisions; 95% under 52) | **PASS** | reader 37.7 decisions = 5.0 min (95%: 43); table player 37.5 = 5.0 min (95%: 43) |
| D2 (core) | Guards are worth something (no guard -15, guard all -5, 30-70% of punches stopped, 2+ guards top-half somewhere) | **FAIL** | never guards 1.9%, guards all it can 61.9%, free 64.2%; 33.1% of punches stopped; top-half guards: Block, Slip, Roll, Parry, Tie up |
| D3 (core) | The chairs are equal (first thrower wins 45-55%, reader v reader) | **FAIL** | 41.1% (player chair 50.8%) |
| D4 (core) | Quick turns (choices at a decision under 10 on average, never over 20) | **PASS** | 5.0 on average, most 15 |
| D5 (core) | No trap deck (six traps under the neutral deck plus the best two) | **PASS** | six traps 2.5%, neutral + 2 Parry 48.6% |

Core bars (B1-B7, C1-C12, D1-D5): 14 of 24 pass. Supporting bars (B8-B18): 4 of 11 pass. Verdict: **FAIL**.

Reader by pair (player out, press, counter, volume; each v opponent out / press / counter / volume): 53.3, 51.5, 56.8, 69.3, 69.3, 83.8, 55.8, 62.8, 58.5, 61.5, 62.8, 80.3, 68.0, 68.5, 58.8, 66.3

Opponent class (beginner / table player / greedy / reader): novice 83.1 / 95.8 / 88.1 / 97.2, open class 48.1 / 85.7 / 57.9 / 91.0, regional 18.1 / 52.4 / 26.5 / 64.2, title 11.1 / 39.0 / 17.2 / 51.3, professional 3.8 / 20.2 / 7.3 / 29.3

Best fixed lines: 36.0% Lead hook > Check hook > Cross counter > Roll > Slip > Body jab > Uppercut > Tie up > Parry > Pull counter > Body hook > Block > Jab > Cross; 35.8% Cross counter > Jab > Tie up > Pull counter > Slip > Check hook > Block > Body hook > Cross > Roll > Lead hook > Uppercut > Body jab > Parry; 31.5% Slip > Tie up > Uppercut > Pull counter > Check hook > Parry > Cross counter > Lead hook > Body hook > Jab > Block > Cross > Roll > Body jab; 29.7% Cross counter > Uppercut > Lead hook > Parry > Tie up > Check hook > Body jab > Body hook > Block > Pull counter > Jab > Slip > Roll > Cross; 18.6% Parry > Slip > Roll > Block > Jab > Cross > Lead hook > Body hook > Uppercut > Body jab

Breaker search, final measure: 59.7% swap round 2: Roll out, Block in [Jab, Jab, Jab, Parry, Cross, Cross, Cross, Lead hook, Lead hook, Block, Slip, Block, Tie up, Tie up]; 57.0% swap round 2: Cross out, Jab in [Jab, Jab, Jab, Parry, Jab, Cross, Cross, Lead hook, Lead hook, Block, Slip, Roll, Tie up, Tie up]; 56.5% swap round 2: Jab out, Parry in [Parry, Jab, Jab, Parry, Cross, Cross, Cross, Lead hook, Lead hook, Block, Slip, Roll, Tie up, Tie up]; 54.7% swap round 1: Body jab out, Parry in [Jab, Jab, Jab, Parry, Cross, Cross, Cross, Lead hook, Lead hook, Block, Slip, Roll, Tie up, Tie up]; 54.4% swap round 1: Lead hook out, Body jab in [Jab, Jab, Jab, Body jab, Cross, Cross, Cross, Body jab, Lead hook, Block, Slip, Roll, Tie up, Tie up]

What two more copies of a card are worth (reader win %, neutral deck alone: 54.4, 84.9, 68.5, 76.4):

| card | v out | v press | v counter | v volume |
|---|---:|---:|---:|---:|
| Jab | 48.0 (7) | 82.6 (5) | 63.3 (6) | 64.8 (7) |
| Body jab | 52.0 (5) | 87.4 (2) | 71.5 (4) | 66.9 (5) |
| Cross | 44.3 (10) | 75.4 (8) | 49.9 (10) | 71.4 (3) |
| Lead hook | 52.9 (4) | 68.5 (10) | 45.8 (12) | 71.4 (3) |
| Body hook | 50.6 (6) | 66.0 (12) | 50.0 (9) | 55.1 (11) |
| Uppercut | 39.0 (11) | 59.6 (14) | 34.4 (14) | 65.1 (6) |
| Block | 48.0 (7) | 87.4 (2) | 63.9 (5) | 62.1 (9) |
| Slip | 53.8 (3) | 69.0 (9) | 73.9 (3) | 57.4 (10) |
| Roll | 33.9 (13) | 82.5 (6) | 61.9 (7) | 53.4 (12) |
| Parry | 79.8 (1) | 85.9 (4) | 84.1 (1) | 92.6 (1) |
| Tie up | 63.6 (2) | 93.1 (1) | 79.4 (2) | 75.8 (2) |
| Check hook | 46.8 (9) | 62.1 (13) | 45.9 (11) | 62.3 (8) |
| Cross counter | 35.8 (12) | 67.5 (11) | 57.6 (8) | 43.4 (14) |
| Pull counter | 33.3 (14) | 79.6 (7) | 42.5 (13) | 48.6 (13) |

---

# PART 3 - the game this grew out of (critic pack; facts only)

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

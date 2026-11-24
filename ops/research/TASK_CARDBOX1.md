# TASK_CARDBOX1 - break real boxer v boxer bouts down into card against card (a paper, no engine code)

Model: Arena's strongest reasoning model. Discipline: boxing. Seat: Arena (public mirror ICOON-Studio/FightCamp-Lean-lite).
Deliverable: ONE new file, `proto/cardgame/CARDBOX1_BREAKDOWN.md`, on your own branch, a PR into main. No other file.

## Why
The owner played the card game prototype (`proto/cardgame/`, boxing v Brazilian jiu-jitsu) and said: "THE CARD GAME
DOESNT MAKE SENSE ... BREAKDOWN A real mma fight and make it workwith card logic. the real test should be a boxer vs
boxer , donot mix classes untill all arts cards are ingame." Then: "give references we have of other card games ,
breakdown boxer vsboxer fights see how a breakdown to card vs cards would go."

So: forget mixed arts. One sport, boxing, two boxers. Start from how real bouts go, not from our code.

Our boxer v boxer today, measured over 400 bot bouts (`node proto/cardgame/mirror.mjs`): every bout ends by knockout
(400 of 400); the man who goes SECOND wins 69.5%; the combination rule fires 0.02 times a bout; the body hook 0.10
times; 81% of turns are spent at punching range; 68 decisions a bout; both men end near zero health. It is a race to
zero, not a boxing match. Read `proto/cardgame/README.md`, `cards.mjs` (the boxing cards and `N`) and `engine.mjs` only
to know what exists. Do NOT patch them.

## What to write
### Part 1 - three real bouts, broken down
Pick three well-documented professional bouts you know round by round: (a) an out-boxer against a pressure fighter,
(b) a bout that ends by stoppage after a turn-around, (c) a close decision. Name them. For each: the styles, then
ROUND BY ROUND what decided the round - who controlled range and how, the jab, the lead and the counter, body work and
when it paid, clinches and the referee's break, knockdowns and the count, tiredness, what each corner changed between
rounds, and how the judges scored it (10-point must).
Mark every statement you are not sure of with (UNSURE). An invented punch count is worse than none: give CompuBox-style
numbers only if you are sure of them. A second seat will check your facts against sources.

### Part 2 - the parts of a boxing bout a card game must carry
From part 1, the list of things that decide real bouts, each with: what it is, how often it matters (your estimate,
marked as such), and what a player would DECIDE about it. At least: range and who sets it; the jab as a tool (score,
blind, measure, set up); the lead against the counter; combinations (why a second punch lands when the first is seen);
head against body (what body work buys later); defence kinds (block, parry, slip, roll, step back, clinch) and what each
gives back; feints; the ropes and the corner; tiredness within a round and across rounds; getting hurt, the knockdown,
the count and surviving; the bell; the corner's minute; the judges and stealing a round; a stoppage by the referee.

### Part 3 - card against card
Propose TWO different ways to turn that into a turn of cards, and walk ONE real round from part 1 through each, exchange
by exchange, as cards laid by both men: what each holds, what he lays, what the other sees and answers, what changes
(health, tiredness, position, the round's score). After each walk: where it read like the real round, where it did not.
The two ways must differ in the turn itself (for example: attacker lays a volley face up and the defender answers one
card of it, as we have now - against both men committing at once - against an initiative that passes when an attack is
defended). Use the references below; say which game each idea comes from.

Each way must answer, in one line each:
1. Why would a bout go to the judges? (ours never does)
2. Why is going first or second not an advantage? (ours: second wins 69.5%)
3. Why would a player throw a combination, a body punch, a feint? What does the other man do about each?
4. What is hidden and what is shown?
5. How long is a bout in decisions? (the owner's bar: fast and punchy, 22 to 45 decisions a bout for one player)
6. What does a weak player do, and how does a skilled one beat him?
7. What does the corner minute decide?
8. Which numbers would a later probe measure to say it works? (bars, not tuned values)

### Part 4 - your pick
Which of the two you would build first, the ten to fifteen cards of its boxing deck (name, what it does, in words), and
the three things most likely to go wrong when bots play it.

## References - other card games, in our own words (from the owner's installed games; do not copy any of their text)
- **Mixed Martial Cards (the closest to ours).** One fighter has the initiative. He lays one attack card and picks a
  hidden mode: normal, full power or feint. The defender may commit an answer BEFORE seeing the card (some dodges and
  counters only work as a prediction), then reacts to the card he now sees, then both get a short follow-up window. A
  defended attack hands the initiative over; an undefended one keeps it; a combo card keeps it. Three tracks a fighter:
  head health, body health, stamina. Rests between periods where a coach lesson is picked. Ends by knockout, body
  knockout or the clock with judge points earned for damage. A weak player throws until his stamina is gone and bites
  on every feint. Too long for us: 20 minutes a match, three answer windows a turn.
- **MMA Arena.** A coin picks the attacker and roles flip every turn; each turn 3 moves are dealt and one is picked.
  Nothing is telegraphed. Little skill: "pick the biggest number I can pay for".
- **Clutchtime (basketball).** A fixed stamina each turn, draw to hand size, play until the stamina is gone. No dice:
  a shot scores unless a defence card is ALREADY WAITING for it - defence is laid face up, before the shot. A held big
  card gets 1 cheaper every turn it stays in the hand. 16-card starting decks.
- **Kungfu Card.** Both draw to 5; one attacks. A round is up to three clashes, card against card, the lower number
  takes the difference; a technique card against a move does its own effect. The man who took more damage attacks next
  round (a comeback rule). The attacker may stop a round early. The heart of it: a move that completes three of a kind
  or a run of three ACROSS BOTH MEN'S laid cards is a "disrupt". One shared 52-card deck; everything laid is shown.
- **Hearthstone / Monster Train / Breachway (general deck games).** Planning a resource two turns ahead; timing your
  best card against the turn the other side is open.
Ideas our earlier notes drew from them: a feint with a warning; the lead going to the man who took more; a pattern
across both boxers' cards; a dear card getting cheaper in the hand; defence laid before the attack; a body stoppage
without dice; a clock on the turn.

## Not allowed
No change to any existing file. No mixed arts, no ground, no kicks. No dice as the main resolver (the owner's game
shows what will happen before a card is played). No copied text from any game.

## Feedback loops
Nothing is built here. In part 3 name, for each way, the loop most likely to run away (for example: the leader on
points stops throwing; a hurt man gets hurt more) and the rule that caps it.

## Prior research
`ops/research/CARDREF1_REFERENCE_GAMES.md` (summarised above), `ops/research/CARDBOX_SCOPE_S549.md` (the plan this is
phase 1 of), `ops/research/CARDREAL_AUDIT.md` (the position model of the mixed game - not needed here).

## What would a human do?
A designer would watch three fights with a notebook, write what decided each round, and only then deal cards on a table
against a friend and replay one round by hand. This task is that notebook and that table.

## Prefab check
No code. The reference games above are the prefabs for ideas; nothing of theirs is copied.

## Contract
OWNS: proto/cardgame/CARDBOX1_BREAKDOWN.md
RED_TEST: none (a paper)
REGRESSION: proto/cardgame (node --test stays 90 of 90: no existing file changes)
VISUAL: none

## Result
PR body: the three bouts named, your pick in two lines, and `RESULT: proto/cardgame/CARDBOX1_BREAKDOWN.md -> written`.

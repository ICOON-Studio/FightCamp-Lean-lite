# CARDREF1 - the owner's reference card games, read from their installed files (S537)

Research only. Owner S537: "check what is installed on e, also check my steam account and if something is needed to
download, do it and check it". CARDSCOPE3's table of his games came from store pages; this page replaces it with what the
installed files say.

**How it was read.** Read-only, nothing launched, nothing hooked, nothing of theirs copied here: every line below is our
words and counts. Plain script and table files were read directly (Clutchtime, Kungfu Card). Unity games were read with
UnityPy and the .NET type tables (names of fields, fixed numbers). Mixed Martial Cards ships its rules as scrambled
JavaScript; its text table was decoded on paper by our own script (no code of theirs was run) and the decoded copy was
deleted afterwards. Scratch scripts: `E:\tmp\cardref1` (outside the repo).

**What was there (checked 2026-11-22, manifests re-checked at the end):**

| Game | State | How deep the read went |
|---|---|---|
| Mixed Martial Cards Demo | installed | deep: all card definitions, phases, tutorial lessons, deck templates |
| MMA Arena (1047380) | installed (finished downloading) | deep on rules and fixed numbers; the table of move values is not in the local files |
| Clutchtime (2995450) | installed (finished downloading) | deep: the whole rule set is plain script |
| Kungfu Card | installed | deep: the in-game rules book and the run file |
| Ironbound | installed | **not read**: its six data packs are encrypted. Opening a lock on an online game is more than "read the installed files", so it stays closed. Nothing new on it. |
| Breachway | installed | medium: the card table (1,823 entries) |
| Starless Abyss (3167970) | installed (finished downloading) | light: card and unit fields from the code |
| Monster Train (1102190) | installed, but in the C: Steam library, not E: | light: phases and balance fields; the values sit in a bundle not read |
| Rune Coliseum | **not installed**: the folder holds only old save files and a translation list | nothing new; public knowledge only |
| Elite MMA Manager Demo 0.8.7 | installed | light: it is not a card game |
| Hearthstone | not on this PC (Battle.net) | public rules only |

Where a number is from public knowledge and not from a file, it says so.

---

## 1. Mixed Martial Cards (demo) - the closest to ours

**The turn.** One boxer has the *initiative*. He lays one attack card and picks, hidden, one of three *modes*: normal,
full power, or feint. The other answers in up to three small windows: he may commit an answer *before* seeing the card
(a prediction: some dodges and counters only work this way), then he *reacts* to the card he now sees (a block, dodge or
counter that fits that attack, or pass and take it), then both get a short *surprise* window for a follow-up card. Each
window has a clock, 20 seconds as a rule (10 to 30).

**Who goes next.** A defended attack hands the initiative over. An undefended one keeps it. A *combo* card keeps it
even when blocked, unless the attacker took damage. A landed counter takes it back at once. Passing on the first turn
of an exchange costs a card at the next draw.

**The feint is the hidden bit.** The defender sees the card but not the mode. If he spends a defence on a feint he is
thrown off for the next attack; if he calls it (does not bite), the attacker loses the initiative; if he tries to
*counter* a feint he is left wide open. The coach's lessons say it outright: plain attacks rarely land, feint first,
then go full power where you want it.

**Resources.** Three tracks on each fighter: head health, body health and stamina, plus a grappling resource on the
ground. Tutorial bouts set head health to 20 and to 40; the normal value was not confirmed. Body shots drain the other
man's stamina. A long exchange makes every further attack cost more stamina. Running out of stamina in a submission
loses; stamina overkill gives a chance of a body knockout.

**The cards (124 definitions in the file, 54 of them switched off in the demo).**

| Kind | Count | Numbers |
|---|---|---|
| Attacks | 60 (punch 29, kick 21, knee 15, elbow 15; head 25, body 18, legs 7) | stamina cost 0 to 7, most cost 2 (58 of 135 costed entries; 27 are free, 17 cost 1, 17 cost 3) |
| Blocks | 22 | each names what it stops (a kick to body or leg, a punch to the head...) |
| Counters | 12 | several must be played as a prediction |
| Dodges | 5 | |
| Ground game | submissions 18, takedowns 6, control 12, position 10 | position and control move by -3 to +4 a card |
| Damage | | body health 1 to 10 (most 3 to 5); head health 4 to 25 (most 6 to 8); stamina 1 to 7 (most 3 to 5) |

About a dozen statuses (injured leg, injured body, limp, cut, stunned, wide open, off rhythm...), each a small number
that changes later cards and wears off "after the exchange", "after the rest" or never.

**Rests.** The bout is cut by rest times (the counter in the code steps in fives). At a rest the player picks a coach
*strategy* (from 2 he brought) and a coach *action* (from 3 he brought) and gets stamina back: the rest is a decision,
not a heal. The coach also speaks during play (about 60 lines: "they are repeating their moves", "keep your eye on the
jab", "you cannot go for the big finisher without a set-up").

**Decks.** A template deck is 15 to 17 different striking cards at 2 copies each (about 30 to 34 cards), a separate
grappling deck, 1 or 2 perks and a coach. A few cards are capped at 2 copies. Skill level 1 or 2 gates cards.

**Hidden and shown.** Shown: the attack card. Hidden: its mode, the hand, five cards marked "secret until the reaction".
One perk shows the incoming card early but never the mode.

**Ending.** Knockout, body knockout, submission, or the clock: then judge points, earned whenever you do damage.

**Around the bout.** Coach lessons, a ladder of single bouts with branches (bouts 3 to 8), an endless mode with boosters;
online play with a rating, spectating and chat votes.

**Weak v skilled.** The weak player throws real punches until he is out of stamina and bites on every feint. The skilled
one counts the other's stamina, feints when the other has a counter ready, and ends an exchange before it gets dear.

## 2. MMA Arena

**The turn.** A coin decides who attacks first; the roles flip every turn. On his turn a fighter is dealt **3 moves** and
picks. A turn has a 20 second clock. A round is 300 seconds; a match is 3 rounds.

**Resources.** Health tops out at 100. Stamina starts from a base of 10; the code holds two fixed numbers, 5 for the
attacking side and 7 for the defending side (our reading: what a turn gives back in each role, so defending rests you).

**Cards.** A move belongs to one of nine disciplines (boxing, kickboxing, karate, Muay Thai, wrestling, judo, ju-jitsu,
MMA, misc) plus basics, aims at head, torso or leg, and needs one of 11 positions (standing, or one of five ground
positions seen from top or bottom). A move has one value, one stamina cost and often a *secondary* effect out of 19
(combo, counter, critical, evade, hold, knockout, stun, submission, takedown, feint, sweep, clean hit...). A move has 3
levels; level raises value and cost. **The table of values is not in the local files** (it comes from their server or a
bundle not found), so no damage range is given here.

**Deck.** Up to 40 moves, at most 3 of one. The game can also deal by discipline rule or in a fixed order.

**Hidden and shown.** Nothing is telegraphed: you see your three moves and his last one.

**Ending.** Knockout (an attempt is a tapping mini-game), submission, technical knockout, or the rounds on points.

**Around the bout.** A phone game's shell: leagues, tournaments, gates that ask for a belt or stars, sponsors, quests,
timers on energy. Thirteen computer levels from easiest to "calculating".

**Weak v skilled.** Little: with 3 dealt moves and no information about him, the turn is "pick the biggest number I can
pay for". The skill is outside the bout, in the deck and the levels.

## 3. Clutchtime (basketball deckbuilder)

**The turn.** Each turn you get a fixed stamina and draw to your hand size, then play cards until the stamina is gone.
Every card played takes game clock: 15 seconds as shipped (the setting allows 6 to 20). A quarter is 10 or 12 minutes,
so **a quarter is 40 or 48 card plays for both teams together and a match 160 to 192**; the screen shows the plays left.
Four quarters, then overtime of 5 minutes if level.

**Resources.** Stamina 5 a turn at the easiest level, up to 8 on the hardest (one arcade mode goes to 20); draw 5 to 7;
hand cap 10. From the fourth level up there is a *shot clock*: a cap on cards a turn, 9 falling to 4. The computer
team's stamina and draw climb through a season (5 rising by one a fixture) up to the level's cap. **Difficulty is
resources and tempo, not a cleverer opponent.**

**Cards (107 definitions).**

| Kind | Count | Cost | Does |
|---|---|---|---|
| Shots | 15 | 0 to 6, most 3 | 2 points (6 cards) or 3 points (9 cards) |
| Free throws | 3 | 0 | 1 point |
| Assists | 7 | 1 | set up the next card (draw, cheaper shot) |
| Actions | 24 | 0 to 3, 11 are free | draw 1 to 6, stamina back 1 to 9 |
| Defence | 11 | 0 to 5 | laid on the table ahead of time; stops his next shot |
| Team cards | 40 | 0 to 7 | lasting effects |
| Hindrances | 6 | 1 | dead weight pushed into a deck |

**No dice.** A shot scores unless a defence card is already waiting for it. Defence is laid **face up, before** the shot
it stops, so the shooter sees it and plays round it: an "unstoppable" shot ignores it, and a foul stops a shot at the
price of free throws. Eight shots are unstoppable.

**Three rules worth noting.** (1) A *held* card: one big shot gets 1 cheaper every turn it stays in the hand. (2)
*Boost*: a reward that adds 1 to every number on one card for good. (3) *Leverage*: give up named cards to upgrade
another. Fifteen cards do not use up clock ("instant").

**Decks.** Every team starts on **16 cards** (typical: 3 threes, 2 rebounds, 2 passes, 2 lay-ups, 1 or 2 dunks, 1 or 2
steals, 1 block, 1 foul, 1 drive). Rewards come in 8 tiers and decks grow past 35 to 50; the computer's deck grows too
and is kept at one shot in four.

**Around the match.** Tournament, season or full season; knock-out series of best-of-5 and best-of-7; six difficulty
levels; home crowd noise as a meter that gives the home team an extra card or stamina.

**Weak v skilled.** The weak player shoots into a waiting block and runs out of stamina with shots in hand. The skilled
one strips the defence first, holds the dear shot until it is cheap, and counts the plays left in the quarter.

## 4. Kungfu Card (its own rules book is in the files)

**The round.** Both draw up to **5**. One is the attacker. A round is up to **three clashes**, left to right: in each
the attacker lays a card face up, then the defender lays one. Then all clashes resolve in order.

**Resolution, no dice.** Move against move: the lower number takes the difference. A *technique* against a move does its
full damage. A defence card stops a move outright and half of a technique (rounded up).

**Who attacks next round.** The one who **took more damage** last round, or who pulled off a disrupt; otherwise the same
attacker again. The beaten side gets the lead.

**Ending a round early.** After at least one clash the attacker may stop the round. The defender then takes back one of
his cards after resolution. Not allowed two rounds running.

**The disrupt, the heart of it.** A move card that completes **three of a kind or a run of three, counting the cards
both players have laid**, cuts the round off: the rest is skipped, the disrupter draws one of his technique cards, flips
the top move of the deck for that much damage, and knocks the other's stance card off the table.

**The deck is shared.** One 52-card deck and one discard pile for both: moves 1 to 9 in four suits, defence cards and
three kinds of stance card. So both players can count exactly what is left. What is personal sits outside the deck: 5
technique cards chosen from your school and 2 *principles* (passive or once-a-round powers) that lie **face up** all
bout. A stance card stays on the table and gives a once-a-round power (join two moves into one of 9 or less; swap a
card; join two moves into a defence).

**Hidden and shown.** Shown: every card laid, both principles, both stances, the deck's make-up. Hidden: the hands, and
a few effects that turn a laid card face down.

**Around the bout.** Nine schools. A run mode of 10 regions, 18 opponents, 284 events and 150 relics; online duels.
Health per fighter was not found in the files.

**Weak v skilled.** The weak player plays his biggest number each clash. The skilled one watches for the third card of
a set, feeds a low card to finish his own run, and stops the round one clash early when ahead.

## 5. Ironbound

Not read (encrypted packs, see the table at the top). The only line that stands is the old one: a duel in turns of 5 to
10 minutes. Nothing here is used below.

## 6. Hearthstone (public rules, not from files)

Turns alternate. Mana starts at 1 and grows by 1 a turn to 10, refilled each turn. Deck 30, hero 30 health, draw 1 a
turn, opening hand 3 or 4, hand cap 10, board cap 7. The table is open, the hand hidden. A *secret* is a face-down card
that fires when the other player does one named thing; the known answer is to test it with the cheapest action first. A
turn has about 75 seconds. A match is about 7 to 12 turns each.
**Weak v skilled.** The same cards; the skilled player plans mana two turns ahead, tests secrets in the right order and
counts what has been played.

## 7. Breachway

A space duel with cards. The card bundle holds 1,823 entries (497 are upgraded copies, about 116 belong to enemies);
three rarities (1,694 / 99 / 30); six categories. **Every card carries its own rest time after use: 0 to 8 turns, most
4 to 6** (565 have none). So the deck does not simply cycle: the strong card is away for a known number of turns.
About 740 entries stay in play after being laid, for 1 to 6 turns or the whole fight. Costs sit inside behaviour
graphs and were not read. Public knowledge: the enemy shows what it will do; the long game is the ship's build.
**Weak v skilled.** The skilled player times the rest of his best cards against the turns the enemy is open.

## 8. Starless Abyss

Cards played on a hex map. A card has an energy cost **and a heat cost**, a damage, a shield value, a range and a repeat
count. Eight card types (attack, defence, magic, tech, strategy, status, curse, malfunction), three rarities, ten
factions. Units have armour and shield apart and move by points. Heat is the second purse: spend it now, pay later
(malfunction cards). Values are spread over one class a card and were not tallied.

## 9. Monster Train (C: library)

Four rooms (three floors and the core). The fixed order of a turn in the code: place, your cards, the fight resolves
floor by floor, the enemy climbs. The balance sheet has fields for energy a turn, top energy, cards a turn, hand cap,
room on a floor, upgrade slots a unit and a spell, core health; the values are in a bundle not read (public knowledge:
3 energy, 5 cards, 2 upgrade slots a card). The game previews the result of a play before you commit to it.
**Weak v skilled.** The fight itself runs alone; skill is the build and the placement.

## 10. Rune Coliseum and Elite MMA Manager

**Rune Coliseum** is not installed (only old saves). The round 3 verdict stands: a queue laid blind is Form A again.
**Elite MMA Manager** is a manager sim, not a card game: the bout is simulated and the player's one lever is a plan out
of five (passive, defensive, balanced, aggressive, all out) or "auto". Eleven fighter backgrounds, sixteen career
types, six personalities. Useful for the gym game, not for the cards.

---

## 11. Side by side

| | What you decide in a turn | Decisions a bout | Resource | Hidden / shown | Deck / hand | Telegraph | Long game |
|---|---|---|---|---|---|---|---|
| **Our rally (R3)** | one guard on a seen volley, then a volley and one trap | 37 (5.0 min) | wind 3 back, top 6 | all punches shown; hand and 1 trap hidden | 12 to 16 / 5 | his whole volley | 8-bout ladder |
| Mixed Martial Cards | attack + hidden mode; or prediction, reaction, surprise | long (matches 20 min+) | stamina, cost 0 to 7, most 2; three health tracks | card shown, mode hidden | about 30 + ground deck | the card, not the mode | lessons, ladder, online rating |
| MMA Arena | 1 of 3 dealt moves | 3 rounds of 300 s, 20 s a turn | stamina base 10; 5 attacking, 7 defending | nothing shown ahead | 40, max 3 copies / 3 | none | leagues, move levels 1 to 3 |
| Clutchtime | many cards till stamina or the clock is out | 160 to 192 card plays, both sides | stamina 5 to 8 a turn; cards a turn 9 to 4 | defence laid face up | 16 growing to 35+ / 5 to 7, cap 10 | his waiting defence | season, rewards in 8 tiers |
| Kungfu Card | one card a clash, attacker first; stop the round early | 3 clashes a round | none: the hand of 5 is the resource | all laid cards, powers face up | shared 52 / 5 | the attacker's card | 10-region run, 150 relics |
| Hearthstone (public) | several cards from mana | 7 to 12 turns each | mana 1 growing to 10 | board shown; hand and secrets hidden | 30 / up to 10 | none; secrets are guessed | collection, ranks |
| Breachway | cards from energy; each then rests 0 to 8 turns | - | energy types | enemy plan shown | - | yes | ship build |
| Starless Abyss | cards + movement on hexes | - | energy and heat | map open | - | positions | run |
| Monster Train (public numbers) | place units, cast spells | about 5 turns a fight | 3 energy, 5 cards | previewed outcome | starter deck growing | full preview | run, 2 upgrades a card |

**Three things the files say that the store pages did not.**
1. The two games nearest to ours in *feel* (Kungfu Card, Mixed Martial Cards) both make the defender answer **a card he
   can see** and both hang the bout on **who holds the lead**; our rally has the first and only a coin for the second.
2. Nobody among them lets a cheap card be thrown without limit: Mixed Martial Cards raises the price as the exchange
   runs, Clutchtime caps cards a turn, Breachway rests each card, MMA Arena caps copies at 3. Our round 3 breaker (five
   Body jabs in a thin deck, C8) walks through the one door all four closed.
3. The corner minute is a **choice of plan** in Mixed Martial Cards (one strategy of 2, one action of 3), not a heal.
   Ours is a heal, and water wins three times in four.

---

## 12. What each would teach our rally form (buildable, against the round 3 failures in 6c)

Most useful first. Each is one rule a greybox probe can switch on; none has been probed.

**A. Close the cheap-card door (C8, the thin deck of Body jabs wins 67.5%).** Three ways, one from each game, to probe
one at a time:
- *Mixed Martial Cards:* the volley gets dearer as it runs. Rule: the fourth and every later punch of a volley costs
  +1 wind; the same card twice in one volley costs +1 the second time.
- *Clutchtime:* a cap on cards a turn that tightens with class. Rule: at most 4 punches a volley at regional, 3 at title.
- *Breachway:* a card rests. Rule: a 1-wind punch played this turn cannot be played on your next turn.
- And *MMA Arena's* deck rule as the cheap backstop: at most 3 of any 1-wind card (ours is 4).

**B. The corner becomes a plan, not a heal (supporting bar: water is best always).** *Mixed Martial Cards* rest and
*Kungfu Card* stances. Rule: at the bell pick **one plan card of three you brought**, face up for the next round, with
a once-a-round power. Examples to size: "work the body" (body punches +1 this round), "counter-punch" (your counter is
+5, not +3, once), "box and move" (one Slip costs 1). Water and ice stay as the fallback. It lies face up, so he plays
round it, and a knockdown knocks it off the table (the Kungfu rule) - which also makes a knockdown bite harder.

**C. The dear card gets cheaper in the hand (B6: Uppercut at 3 and Tie up at 4 are bad against everybody).**
*Clutchtime's* held card. Rule: each of your turns the Uppercut stays in your hand it costs 1 less, down to 1; it goes
back to 3 when played. He can count how long you have held it (the table shows it), so it is a threat that grows in the
open. Same rule for Tie up down to 2.

**D. A trap that does not watch the lead (C6 jab-first is a safe probe, C12 a habit only changes the lead).**
*Hearthstone's* secrets differ in what they watch, which is what makes the cheap test unsafe. Rule: one new trap that
watches the **second** punch of his volley, or "a volley of three or more". Then leading with a jab tests only two of
the four traps, and a known habit can change the shape of the whole volley, not only its first card.

**E. Teach the trap by showing it (C11, the beginner wins 20% at regional).** *Clutchtime's* defence and *Kungfu Card's*
powers lie face up and are still interesting. Rule: in novice and open class his trap lies **face up**; at regional it
turns face down. (6c already points this way; two reference games do exactly this.) Add the *Mixed Martial Cards* coach
voice: one spoken line when a known habit applies ("he sets the check hook after your jab").

**F. The lead goes to the man who took more (a comeback rule; chairs D3).** *Kungfu Card.* Rule: from round 2 the boxer
who took more damage last round throws first, instead of the lead simply changing hands. To probe against D3 (first
thrower 45 to 55%) and the comeback bars; it may replace the "1 wind less" patch on the first thrower.

**G. A pattern across both boxers' cards (B6 matchups, D2 "which punch to stop").** *Kungfu Card's* disrupt. Rule: jab,
cross, hook landed **in that order** in one volley is a *combination*: it draws you one finisher card (a big single
punch you cannot put in a deck). He breaks it by stopping the middle card, so the one guard now has a second reason
beside damage, and a deck is built to reach its combination.

**H. A feint, with a warning (D2: guarding all you can is always right).** *Mixed Martial Cards.* Rule: once a turn one
punch of your volley may be laid as a feint (1 wind, it looks like the punch). If he spends his guard on it the guard
is gone and your next punch chains as if the feint had landed; if he lets it through nothing happens and you paid 1
wind. The table counts how many feints he has thrown this bout. **Warning:** this puts a guess back into a form the
owner picked for "fast and punchy, every number shown", and the blind forms measured as a guess or a lookup. Probe it
last, and only if D2 still fails after B, C and G.

**I. A body stoppage without dice (supporting bar: stoppages 1.8%, bar 10 to 25).** *Mixed Martial Cards* gives a
chance of a body knockout when stamina is overdrawn. Our no-dice version: a clean body punch on a boxer with **no wind
left** is a knockdown. It gives the body deck a way to finish and makes "keep one wind" a real decision.

**J. A clock on the turn (owner bar D1, fast and punchy).** Both fight games use 20 seconds a decision. Rule: an
optional 20 second turn clock, on by default from regional class; out of time = the volley as it lies.

**K. Later, for the run and the gym link (not round 4).** Card levels 1 to 3 from use (*MMA Arena*; fits pad-time
mastery in the gym game), a reward that adds 1 to one card for good (*Clutchtime* boost), two upgrade slots a card
(*Monster Train*), difficulty by resources and tempo before cleverness (*Clutchtime's* six levels: our classes already
do "top wind +1"; a volley cap by class would be the second dial).

**What not to take.** The length of Mixed Martial Cards (20 minutes and more a match, three answer windows a turn) and
Clutchtime (160+ card plays); MMA Arena's turn (one of three dealt moves, nothing known about him: the turn the mixed
reviews complain about); any shared deck (ours is two boxers with their own styles); queues laid blind.

## 13. Honest limits

- Files, not play: nobody here has played a turn of any of them. Counts are of definitions in the files, which include
  switched-off, enemy and upgraded entries where said.
- Not read: Ironbound (encrypted), MMA Arena's move values (not local), Breachway's costs, Monster Train's balance
  values, Starless Abyss's per-card values, the starting health in Mixed Martial Cards and Kungfu Card.
- Two readings are ours and marked as such: MMA Arena's 5 and 7 as stamina by role, and the rest "every five" in Mixed
  Martial Cards.
- Section 12 is a list of probes, not results. By the project rule each lever is probed on the greybox before two fresh
  critics see it.

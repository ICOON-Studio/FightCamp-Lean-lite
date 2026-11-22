# CARDSCOPE3 - fresh critic, code-checked (SDK seat, S537)

Read first: the owner's interview (fast and punchy, about 5 minutes, every number shown, standalone, his ten games).
Then the critic pack, the critic brief, the scope page (2b, 3R, 4c, 6c, 8) and the probe table. Then I played the
round 3 greybox (`proto/cardscope3`, the rally; `proto/cardscope` is rounds 1 and 2) through node with my own
policies, written outside the repo. Nothing in `proto/` was edited. `engine.test.mjs`: 29 checks green.

## Scores

| What | Score | In one line |
|---|---|---|
| DEPTH | **5 / 10** | The lead punch and the wind are real choices, but a 12-card body deck played with no thought wins 87% at regional class, and three rules a person can hold match the table player. |
| PLAY | **5 / 10** | It is fast. It is not punchy: a trap springs once in three bouts, 2% of bouts end early, one turn in six the best play is to throw nothing, and knockdowns come from the draw. |
| GENERAL | **6 / 10** | Clear, honest, buildable, bars written first. A few contradictions on the page, three cards with no job, and the breaker search only looks through the eyes of the best bot. |

Bar is 8 and 8. **It does not go on as written.** The form is worth one more round: the faults below are rules and
numbers, not the shape.

## How I played it

All at regional class unless said, 16 pairs (4 player boxers x 4 opponents), 60 bouts a pair an arm (960 bouts),
deck arms 120 to 150 bouts an opponent, my own seeds (900000 and up). About 40,000 bouts in all; I also read bouts
turn by turn.

| Policy in the player's chair | Open class | Regional | Notes |
|---|---:|---:|---|
| Their reader (best bot) | 90.7% | 59.4% | matches the page (59.1) |
| Their table player | 85.6% | 47.6% | matches (47.1) |
| Their beginner | 48.5% | 19.1% | matches (20.0) |
| **Impatient**, heavy punches first: best guard on the biggest punch, spend all wind, slap any trap down, never look at his set card | 77.5% | 33.2% | walks onto his trap 1.07 times a bout; stopped 19% |
| **Impatient**, jab first | 76.5% | 37.9% | |
| **Three rules**: guard the biggest punch; lead with the kind his remaining traps catch least; set the trap for his commonest lead | 82.2% | 46.8% | as good as the table player, no sums |
| Three rules + his habit known | 85.1% | 51.0% | a habit is worth about 4 |
| Three rules, 1-wind guards only | 64.3% | 27.9% | Slip and Roll matter: 19 points |
| Three rules, never guards | 13.8% | 1.8% | guards matter |
| Break: turtle (guards and traps, never throws) | 3.2% | 0.4% | does not break it |
| Break: bank wind, then unload | 62.8% | 23.8% | does not break it |
| Break: slugger, no guard | 1.4% | 0.6% | does not break it |

Decks, neutral boxer (70 head), regional class and title class:

| Deck (all legal) | Policy | Regional | Title |
|---|---|---:|---:|
| The four style decks | reader | 59.4% | - |
| Neutral 12 | reader / three rules | 71.9% / 55.6% | - |
| **4 Body jab, 4 Body hook, 4 Block** | **impatient, jab first** | **86.7%** | **55.5%** |
| 4 Body jab, 4 Body hook, 2 Jab, 2 Block | three rules / impatient | 82.5% / 72.5% | 58.0% / 45.5% |
| 4 Body jab, 4 Body hook, 2 Jab, 2 Block | reader | 88.8% | (pro debut 39.6%) |
| 4 Jab, 4 Body jab, 4 Cross, 2 Parry, 2 Block | reader / three rules | 85.6% / 71.0% | (pro debut 54.2%) |
| 4 Jab, 4 Cross, 4 Lead hook (no guard) | reader | 16.5% | |
| Six traps + 3 Jab, 3 Cross, 2 Hook, 2 Block | reader | 19.6% | |
| 4 Uppercut, 4 Jab, 2 Cross, 2 Slip | reader | 22.9% | |

What a bout is made of (reader in the chair, style decks, 960 bouts; second column my three rules with the body deck):

| Measure | Style decks, reader | Body deck, three rules |
|---|---:|---:|
| His punches are coming and I hold no guard I can play | 41.2% of those turns | 35.8% |
| Knockdowns on me, share with no playable guard in hand | 98.6% | 91.4% |
| I throw nothing this turn | 16.0% | 4.7% |
| He throws nothing / exactly one punch | 18.8% / 25.0% | 27.4% / 33.6% |
| Traps he sets a bout / sprung on me a bout | 5.4 / 0.15 | 5.1 / 0.46 |
| He sets the same trap as the turn before | 36.3% | 40.3% |
| My traps sprung a bout (reader) | 0.22 | - |
| His wind at the start of his round-3 turns | 4.13 | 2.96 |
| The reader uses a guard when one is playable | 93.3% | |
| Reader's turn equals the three-rule turn: guard / lead kind / trap / whole turn | 81.1% / 70.7% / 96.3% / 40.0% | |

## DEPTH 5 / 10 - the evidence

**What is real.**
- The lead punch is a decision. The reader and my rule pick the same kind of lead 71% of the time, so about three
  leads in ten need more than a rule. Ignoring his set card costs 18 points.
- Wind kept for later is a decision: the reader ends 41% of its turns with wind left, and "bank then unload" loses,
  so neither "spend it all" nor "save it all" is right.
- Slip and Roll against Block is a decision: playing only 1-wind guards costs 19 points.
- No simple line breaks the fight: turtle, slugger and banker all lose badly. That is better than rounds 1 and 2.

**What is not.**
- **A dominant deck with a brainless line.** Twelve cards, 4 Body jab, 4 Body hook, 4 Block, played by a bot that
  never looks at his set card (it walks onto 0.92 traps a bout) wins 86.7% at regional class, where the best bot
  with the four style decks wins 59%. At title class it still wins 55.5%. The page found the body deck in the pro
  debut only and only through the reader; it is worse than reported, because it needs no skill. Cause: every 8 body
  damage is 1 wind less back for the rest of the bout, with no ceiling, so by round 3 he starts his turns on 2.96
  wind and throws nothing or one punch on 61% of them. The deck has no head punch worth the name and wins on the
  cards with damage 50 to 49. It is also the least punchy way to box.
- **The guard is not a choice, it is a draw.** When a guard is playable the reader plays one 93% of the time and
  it is my one-line rule's guard 81% of the time. The other side of it is worse: on 41% of the turns his punches are
  coming you hold no guard you can play. With 3 or 4 guards in 14 to 16 cards and each fitting some shapes only,
  defence is mostly what you drew.
- **The trap is a standing ban, not a play.** At regional class he sets 5.4 traps a bout and 0.15 spring. Mine
  spring 0.22 a bout. He re-sets the same card as last turn 36% of the time because it came back unseen. So the one
  hidden card is a sign on the table that says "do not lead with the cross", turn after turn, and the answer (lead
  with something else, or throw nothing) costs no thought once you can count. The page's own bars agree: jab first
  costs under 10, habits change the volley 17% of the time.
- **Ten bouts in, what is left to learn?** Three rules reach 47 to 51%. The reader is 8 to 12 points above that, and
  the all-seeing bot only 5 above the reader. That is a thin ladder above the rules: count his traps, guard the
  cross not the jab, keep one wind. Most of the reader's edge is in the last 30% of leads and in wind kept.
- Ten of fourteen cards have no matchup (the page says so). Body jab is the best or second best card to add against
  every style; that is a card for everything.

## PLAY 5 / 10 - the evidence, for this owner

**Fast: yes.** 37 decisions, 5.0 minutes, 5 choices at a time. All my policies landed between 31 and 38 decisions.
This is the first round that fits what he asked for in length.

**Punchy: no.** Punchy means big moments that come often and that I caused.
- **The trap, the one "gotcha" in the game, fires 0.37 times a bout** between two good boxers (0.15 on you, 0.22
  for you). In his Hearthstone a secret springs most games. Here you set a card five times a bout and it comes back
  five times. Twelve of your 37 clicks a bout are setting or re-setting a card that does nothing.
- **Almost no bout ends early**: 2% stoppages at regional class, 0.38 knockdowns a bout. Head 68 to 75, 54 taken.
  Every bout goes to three judges' cards. A boxing game where nobody goes down is not his "lots of action".
- **Knockdowns are not earned.** 99% of the knockdowns on the reader happened with no playable guard in hand. The
  first bout I read turn by turn: he opens with three Lead hooks, my hand is Jab, Cross counter, Parry, Lead hook,
  Cross. Nothing fits. Knockdown, and by rule I throw nothing that turn. Ten seconds in, two turns gone, no choice
  made. That is the "I lost because of what he had" the page's own phase 7 bar forbids.
- **One turn in six the best play is to throw nothing** (16% for the reader, 19% for him), and a quarter of his
  volleys are one punch. In a 9-turn bout that is one or two turns of "pass". The cause is the wind (3 back) meeting
  the ban of the trap: holding a Cross and an Uppercut against a likely Cross counter, the right move is to wait.
- **Comebacks are quiet.** 32% of bouts turn after round 2, which is fine on paper, but they turn on half-points
  of three judges, not on a punch. "Hurt" at 42 changes only the knockdown line; nothing on the table gets wilder
  when a boxer is hurt.
- **The impatient player** (the owner on a first evening, pressing the biggest card): 77% at open class, 33 to 38%
  at regional, stopped in one bout of five there, and the thing that beats him is a face-down card he was never
  made to care about. The step from open class to regional is a wall for exactly the way he said he wants to play.
- Agency is good where it exists: everything is seen, nothing is rolled, the guard never misses. He will be able to
  say why a turn went the way it did. That is worth keeping.

**Can the rally reach 10 for this owner?** It can reach 8, and I think 9. The skeleton is the one his games share:
see the threat, answer, hit back, a small pool, one secret. What stands between this and 10:
1. the hidden card must spring (a threat that never fires is not a thrill);
2. defence must be a choice every turn, not a draw (a floor everyone has, then cards that do more);
3. punches must add up to something: named combinations, a hurt state that matters, bouts that can end;
4. body work must be a plan, not a lock;
5. the long game (the run) is three lines on the page and is half of why he plays Monster Train, Breachway and
   Starless Abyss a second time.
Nobody can score 10 from bots. After the list below, the proof is him playing three bouts and starting a fourth
unasked.

## GENERAL 6 / 10

Good: one page, the old rounds kept apart, every number named, bars written before the run and not loosened, the
limits said out loud ("bots, not people"; the regional opponent is the reader's near-copy). The build plan is small
steps with a test each. He plays at phase 2. All right calls.

Faults found reading the page against the code:
- 4c says a set card "is gone at his next turn if nothing walked onto it"; 3R and the code say it comes back to the
  hand. And the code throws a set trap away at the bell of each round (`bout`, the round loop): on no page.
- 6c and the probe say the breaker deck has "five Body jabs"; the list printed beside it has four (five would be
  illegal).
- The trap cards carry a wind price of 2 in `cards.mjs` that nothing reads (`trapCost` 0 is used). Harmless, but a
  port to the rules module will trip on it.
- The breaker search (C8) plays every deck with the reader. A breaker deck is found by a simple player, not a
  perfect one: mine needed a 15-line bot. The search must also run each deck with the impatient line.
- "Hurt" has a wind rule that is switched off (`hurtBack` 0) and "last lead" too: leftovers.
- Three cards have no job (below). The corner is known to be no decision and still sits in the turn count.
- Phase 0 lists five changes in one job with the rule "nothing that passes now may fail". Five rule changes at once
  cannot be told apart in one run. Split it (see the list).

## The questions of the brief

**The form.** Yes, keep the rally. It is the right cut of what his games share. What each should give it:
- Hearthstone: a secret that fires on a named action and *stays until it fires*. Take that. Avoid long boards.
- Kungfu Card: a pattern in the cards laid takes the initiative. Take it as named combinations (below).
- Clutchtime: the cheap card feeds the dear one, and the clock ends it. The chain does the first; make it bigger.
- Mixed Martial Cards: guards for shapes, an attack that hides what it is (a feint). Take the feint. Avoid its length.
- MMA Arena: a pile of moves without a decision per turn is its fault. The body deck here is that fault.
- Ironbound: a 5 to 10 minute duel with a build behind it. The size is right already.
- Monster Train, Breachway, Starless Abyss: the build is the long game and each fight ends with a pick that
  changes how the next one plays. The run here must carry that weight.
- Rune Coliseum: rightly rejected.
I would not change the structure. I would change what is on the table inside it.

**One guard a turn.** Which punch and which guard is a decision only when you hold two guards that fit, and you
hold none 41% of the time. Two changes, neither slows the turn:
1. A floor: **Cover up** is not a card. Always there, 1 wind, takes 2 off one punch, breaks the chain, no craft
   point. Now every turn has a guard question, and guard cards are the better answers you built your deck for.
2. A price for guarding: **if you play no guard, your first punch this turn is a trade: +2** (you sat down on your
   shots instead of moving). "Guard all it can" then has something to lose and D2's last clause can pass. Measure
   it: guards-everything 5 or more under free choice; never-guards still 15 or more under.

**The trap.** Right rule for one hidden card in a fast game:
- It is set once and **stays down until it springs or you swap it** (swap = 1 wind). No coming back, no re-set
  clicks, no hand slot. That alone takes about 5 dead clicks out of a bout.
- It watches **the first punch of its kind anywhere in the volley**: full (8) on the lead, half (4) and that punch
  misses if it comes later. Now jab-first is not a free probe for the cross behind it.
- **A Feint card** (0 wind, a punch that does nothing, one per volley): it springs his trap harmlessly if the trap
  watches the kind you name. The player's tool against the ban; his against yours.
- When it springs, the boxer who set it draws a card. A sprung trap should swing the turn.
- Bar: 1.5 to 2.5 traps sprung a bout, reader against regional; no kind over 55%; the six-trap deck still loses.

**The beginner.** Teaching is right but not enough. Carry him by rule too: at open class his trap lies face up
all bout, at regional for round 1; and the table's line under his set card must be one phrase ("lead with a hook or
a jab"), not three percentages. The wall is real: impatient 77% then 33%. Bar: the impatient line wins 30 to 45% at
regional.

**The bars that still fail, and the page's answers.**
- C11 beginner: face-up trap in open class, agreed; add round 1 at regional and the Cover up floor (it lifts every
  weak player).
- C8 breaker: "only a clean Body hook takes wind" is needed and not enough (my deck has four Body hooks). Also cap
  the lasting loss at 1 wind for the bout, and give one step back at the stool. Then run the search with the
  impatient line as well as the reader.
- B6 matchups: "Uppercut cannot be blocked" is right. "Tie up back to 3, one a deck" is the third price for a card
  with no rule; make it an action instead (below). The traps stop being bottom-half once they stay down.
- D2 last clause: the trade bonus above.
- C12 habits: a trap that watches the whole volley gives a habit more to change. If it still fails, drop the bar:
  counting already does the job (+9) and it is the better skill.
- C6 jab first: fixed by the same change (a later cross is no longer safe behind a jab).
- "It does not take a hand slot": yes. "It pays 1 wind when it comes back": no, that pays a boxer for being ignored.
- The corner as orders with a cost: yes, or cut the corner until phase 5 and take it out of the decision count.

**Cards.**
- No job: **Tie up** (2.9% of plays at 4 wind, best card everywhere at 2), **Uppercut** (bottom against every
  style), **the three traps as hand cards** (bottom-half, 0.2 springs a bout).
- Too good everywhere: **Body jab** (first or second against every style, the engine of the breaker), **Parry**
  (free of the one-guard limit, top three against three styles), **Block** (4 off anything for 1).
- Near twins: Cross and Lead hook differ only in which guard and trap meets them. Fine for now; give each one named
  combination so they are not the same card in play.
- Missing: Cover up (the floor, an action), Feint, a finisher that needs a hurt opponent (Overhand: 3 wind, 8, +4
  and cannot be slipped against a hurt boxer), a breather (Clinch as a once-a-round action: no card, your turn
  ends, his volley does half; replaces Tie up), a card that draws (Footwork: 1 wind, draw 2, your next guard this
  bout costs 1 less), named combinations.
- The price ladder: 3 wind a turn is too tight for prices 1 to 4. Do not add wind (it adds length). Give the dear
  cards a rule the cheap ones cannot have: Uppercut cannot be blocked and ignores a Cover up; the finisher needs
  hurt. And tax the cheap ones: only the first two 1-wind punches of a volley count for the work judge.

**The run.** What makes him start a second one:
- Four boxers to pick, each a start deck, one signature card nobody else gets and one rule of her own.
- Every pick changes how the next bout plays: Sharp and Signature versions that change a rule, not +1.
- Named combinations as the build: drill jab-cross, then jab-cross-hook, and they print on the table when live.
- Opponents with one rule twist each from open class up (southpaw: Slip and Roll swap; iron chin: knockdown line
  +4; fast starter: he throws first every round).
- Six bouts, not eight, about 30 minutes. Fast and punchy applies to the run too.
- A run-end line that names the next thing to try ("you never landed a body shot").

## To reach 10/10 (most important first; each can be built and measured on the greybox)

1. **End the wind lock.** Body jab takes no wind. Only a clean Body hook does: 1 from his next turn. Lasting loss
   is capped at 1 wind for the bout and 1 step comes back at the stool. *Bar:* no legal deck, played by the
   impatient line or the three-rule line, over 50% at regional class or over 45% at title; he throws nothing or one
   punch on under 30% of his round-3 turns (now 61% against the body deck).
2. **Search for breakers with simple players.** Add two bots to `bots.mjs`, the impatient line and the three
   rules, and run every breaker deck through all three. *Bar:* C8 as written, on the worst of the three.
3. **The trap stays down and watches the whole volley** (full on the lead, half later, swap for 1 wind, no hand
   slot, springing draws a card), plus the **Feint** card. *Bar:* 1.5 to 2.5 traps sprung a bout; set-trap clicks
   under 3 a bout (now about 6); C6 passes on all four; throw-nothing turns under 8% (now 16%).
4. **A guard floor and a guard price.** Cover up always available (1 wind, 2 off one punch, breaks the chain);
   no guard played = first punch +2. *Bar:* turns with punches coming and nothing to answer with under 5% (now
   41%); knockdowns taken with no card guard in hand under 40% (now 99%); D2 all four clauses.
5. **Make punches add up.** The chain grows: second clean punch +2, third +3, fourth +4. Three named combinations
   in the start decks (jab-cross +2 more; jab-cross-hook: the hook cannot be rolled; body hook then head hook +3).
   Hurt matters: a hurt boxer's Cover up takes 1 off, not 2. Head points down to 58 to 64. *Bar:* stoppages 10 to
   25%, knockdowns 0.6 to 1.0 a bout, volleys of two or more punches 70%+, a bout still under 45 decisions.
6. **Fix the three dead cards and the three best ones.** Uppercut cannot be blocked. Tie up leaves the deck and
   becomes the Clinch action. Parry counts as your one guard. Block takes 3. Add Overhand and Footwork. *Bar:* B6
   with at most 4 flat cards; B13; no card first or second against more than two styles.
7. **Carry the beginner.** His trap face up all bout at open class and in round 1 at regional; one phrase under the
   set card. *Bar:* C11 as written, and the impatient line 30 to 45% at regional.
8. **He reads you back, and shows it.** A chip: "he has seen you lead with the jab 4 times in 5", and his trap
   follows it when no habit applies. *Bar:* B16 (8 or more).
9. **The corner: cut it now, bring it back as orders in phase 5.** One order a round with a price (press: +1 wind
   this round, Cover up off; box: one free Cover up a turn, no trade bonus; body: body hooks +2, head punches -1).
   *Bar:* B17.
10. **The run as in the section above** (four boxers, rule-changing upgrades, combinations as the build, twists,
    six bouts). *Bar:* B7; informed picks 10 or more over random; a good bot finishes 30 to 50% of runs; 30 minutes.
11. **Order of work.** Items 1 to 4 are one greybox round each, in that order, a run after each so each change is
    seen alone. Then build the table (phase 2) and put it in his hands before items 5 to 10 are sized further: feel
    is the open question and no bot answers it. Clean the page (the three contradictions above) on the way.

## My 10/10 table for one turn (1920 x 1080)

The moment: his three punches lie in front of you, his card is set, it is your move. One file allowed in this job,
so it is described, not drawn.

- **Top strip, 90 high.** Round 2, turn 2 of 3. Three judges as three small scales, each with its taste in one word
  (work, hurt, craft) and who leads it. Left his head bar with the hurt mark, right yours, both with numbers.
- **His side, y 110 to 430.** Centre: his volley, three cards 220 wide, left to right in the order they land:
  Jab, Cross, Lead hook. Under each, large, what it will do to you as things stand: 2, 8, 8. An arrow joins them
  with "+2, +3" on the links (the chain). Above the row a line: **"18 to the head: knockdown"** in red, with a tick
  mark on a thin bar at the knockdown line. To the right his set card face down, and under it one phrase: "catches
  a cross or an uppercut (2 left) or a hook (1 left). Usually after your cross: Cross counter." To the left his wind
  as pips (he has 1 left) and his hand as five backs.
- **The answer row, y 450 to 560.** Hover or pick a guard and the three numbers above change on the spot: Slip on
  the Cross shows 2, miss, 6 and "your first punch +3"; Cover up on the Cross shows 2, 6, 6. The red knockdown line
  goes away when the total drops under it. No sums left to do.
- **Your side, y 580 to 900.** Your volley builds left to right as you click: each punch with what it does if he
  stands still, the chain marked, and a small shield icon when he can still hold a guard for that shape ("Roll: 1
  left"). The lead slot is outlined in the colour of his set card when your lead is a kind it can catch, with
  "-8 if it is the Cross counter". Your own set card to the right, face up to you, with "he has led with the jab 3
  of 4".
- **Bottom, y 910 to 1060.** Your hand of five, fanned, playable ones raised. Left: wind as six pips, the ones this
  turn would spend greyed as you hover. Always there, beside the hand: Cover up and Clinch as two buttons with their
  price. Right: one big button, "Throw" (or "Hold" when the volley is empty), and under it the forecast for the
  round on each judge if nothing is stopped.
- Motion: on "Throw" the volley slides to his side in a quarter second; on his turn the guards drop on the punches
  and each punch lands with its number in order, about a second for the whole volley. A sprung trap flips in the
  middle of the table and stops everything for half a second. That flip is the moment the game is built to sell;
  it has to happen more than once in three bouts.

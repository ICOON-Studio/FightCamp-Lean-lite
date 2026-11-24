# BOXCARDS1 - boxer v boxer as a card game, on paper and measured (S550)

Phase 2 of `CARDBOX_SCOPE_S549.md` (owner Q-332 "Yes, go"). Owner S549: "the real test should be a boxer vs boxer ,
donot mix classes untill all arts cards are ingame". This page is the rules, one walked bout, and the bot numbers of a
small greybox (`proto/boxcards/`, 272 lines, 12 tests). There is no page to play yet: that is phase 3, after critics.

Inputs: Arena's paper `proto/cardgame/CARDBOX1_BREAKDOWN.md` (its part 2 list of fourteen things, and its finding
that one card against one seen card never lands the big punch); the old mirror bout (`node proto/cardgame/mirror.mjs`).
John's source check of the three real bouts (SQ325) has NOT landed: no number below comes from those bouts.

## The one idea
The leader lays a VOLLEY of up to three cards face up. The other man lays ONE answer. One defence cannot cover three
punches - that is what a combination is. The game is which answer he holds, and what you put first.

## A bout
- Three rounds (an amateur bout). In a round each man leads three times, turn about: six exchanges a round.
- Round 1: a coin says who leads first. Later rounds: the man behind on the cards leads first.
- Each man has his own deck of 28 cards and a hand of 5, refilled before every exchange. At the bell: a fresh hand.
- No dice anywhere. The only chance is the draw. Both men see: both volleys and answers, wind, daze, the round's
  points, the cards already played. Hidden: the hands.

## What each man carries
| Bar | What it is | What moves it |
|---|---|---|
| Wind (6) | pays for every card; 3 comes back before each exchange, all of it at the bell | a body punch lowers the TOP of the bar by 1 for the rest of the bout (floor 2) |
| Daze (0 up) | how rung his head is | a head punch adds its number; 1 fades before each exchange, 1 at the bell |
| Round points | clean punches this round | jab 1, body hook 1, cross / hook / uppercut 2 |

## The cards (28 a man)
| Card | In deck | Wind | Clean, it does | Note |
|---|---|---|---|---|
| Jab | 5 | 1 | daze 1, 1 point | reaches a man who steps back; cannot be countered |
| Cross | 3 | 2 | daze 3, 2 points | can be laid as a counter |
| Lead hook | 3 | 2 | daze 3, 2 points | can be laid as a counter |
| Body hook | 3 | 2 | his wind bar 1 shorter for the bout, 1 point | goes under a block |
| Uppercut | 2 | 3 | daze 4, 2 points | goes through a block |
| Feint | 2 | 1 | nothing itself | the punch behind it cannot be slipped; a volley that opens on it cannot be countered |
| Block | 3 | 1 | 2 off every head punch of the volley; a blocked punch does not score | not the uppercut, not the body |
| Slip | 3 | 1 (2 when his wind bar is 4 or less) | ONE punch he names misses; his next lead hits 2 harder | not the punch behind a feint |
| Step back | 2 | 1 | every punch but the jab falls short | then he is on the ropes: no second step back until he has led |
| Clinch | 2 | 1, and 1 from the leader | the first card of the volley happens, the rest is smothered | not twice running |
| Counter (a Cross or Lead hook from the hand) | - | 2 | he takes the first punch, his punch lands clean, the volley ends | only when a power punch or body hook LEADS the volley |

So what goes first decides what he may answer with:

| The volley opens with | He cannot | It loses to |
|---|---|---|
| a jab | counter | a slip of the big punch behind it, a block, a clinch after the jab |
| a feint | counter, slip the next punch | a clinch (the whole volley wasted), a step back |
| a power punch | - | a counter, a step back |
| a body hook | block it | a counter, a step back |

## Knockdown, count, stoppage
- A CLEAN cross, hook or uppercut that takes his daze to 7 or more puts him down.
- Down: the round is a point worse for him (10-8), the volley ends, he loses his next lead of the round (the count and
  the cover-up), he gets up with daze 6 and it does not fade before the bell. So a man who has been down must hold on.
- Twice down in a round, or three times in the bout: the referee stops it. Down with a wind bar of 3 or less (the body
  has been worked): he does not beat the count.

## The judges
At the bell the man with more clean points takes the round 10-9. Level: the man who threw more punches. Still level:
10-10. After three rounds the cards are added; level cards go to the man with more clean points in the whole bout.

## Measured: 400 bot bouts (`node proto/boxcards/probe.mjs`)
| What | Old game, boxer v boxer | BOXCARDS1 | Bar (scope phase 3) |
|---|---|---|---|
| Goes to the cards | 0% (400 of 400 knockouts) | 83.3% | 40-70% - MISS |
| The man who leads first wins | 30.5% | 54.6% | 45-55% |
| A combination (2+ punches of one volley land) | 0.02 a bout | in 90% of bouts, 1.74 a bout | most bouts |
| Decisions a bout, both men | 67.9 | 32.2 | 22-45 |
| Empty leads | - | 9.3% | under 10% |
| Cards never used | Sprawl, Escape | none (every card in 96%+ of bouts) | none |
| Knockdowns | - | 0.60 a bout, in 36.8% of bouts | - |
| How it ends | knockout | decision 82%, stoppage 15%, body knockout 1.5%, draw 1% | - |
| Answers laid | - | step back 23%, block 23%, slip 21%, clinch 18%, counter 7%, none 9% | - |
| A volley opens with | - | jab 54%, power punch 26%, feint 19%, body hook 1% | - |
| The reading bot v the biggest-volley bot | - | wins 91.6% | skill must show |

5 of 6 bars. The miss: 83% of bouts go to the cards against a bar of 40-70. That bar was Claude's (S549), written with
twelve-round bouts in mind. With the knockdown line at 6 instead of 7 it is 79% and half of all bouts have a knockdown,
which is too many for three rounds. Not tuned further: this is a question for the critics and for him (below).

Weak spots the numbers show: a volley almost never OPENS with the body hook (0.9%: it costs the leader 1.03 daze in
counters for 0.83 points); the body knockout is rare (6 of 400); the wind bar ends at 5.1 of 6, so tiredness is mild.

## One bout, walked (seed 7; `node proto/boxcards/probe.mjs walk=1 seed=7` prints every hand)
Round 1.
1. B leads jab - body hook - uppercut. A steps back: the jab lands, the other two fall short. B has spent 6 wind for
   one point, and A is on the ropes.
2. A leads jab - jab - body hook. B ties him up after the first jab; the referee breaks them. 1-1.
3. B, short of cards, leads a bare uppercut. A holds a cross and counters: he takes the uppercut and lands the cross as
   it comes. 3-3, both men marked.
4. A leads feint - body hook - body hook (the feint so that it cannot be countered). B steps back; nothing lands.
5. B jabs. A slips it: his next lead is loaded.
6. A leads jab - hook - hook. B blocks all three; nothing scores.
   Bell: level on clean punches, A was busier. A 10-9.

Round 2. B, behind, leads first.
1. B: jab - cross - cross into A's block. Nothing scores.
2. A: jab - hook. B holds no answer: both land. A 3-0.
3. B: jab - feint - body hook. A clinches after the jab.
4. A: a bare uppercut. B steps back, it falls short.
5. B: hook - body hook. A steps back.
6. A: feint - cross - uppercut. B blocks: the cross is smothered, the uppercut goes through the block. A 5-1.
   Bell: A 10-9. B's head is at 5.

Round 3. B must win it big.
1. B: jab - cross - body hook into a block; only the body hook counts. A's wind bar drops to 5.
2. A: uppercut - cross. B slips the uppercut, the cross behind it lands clean on a rung head: B IS DOWN.
3. B's lead is lost to the count.
4. A: cross - body hook. B holds a clinch, but a clinch lets the first punch through. The cross lands: down again.
   The referee stops it. A wins in round 3.

## Where the mechanic shows (wired when the page is built)
| Screen | What it shows | Wired to |
|---|---|---|
| The card page, the table | the volley face up, the answer, what will happen before he confirms | `rules.mjs` resolve on a copy |
| The card page, the two corners | wind bar and its shortened top, daze against the knockdown line, on the ropes, loaded counter | the man's state |
| The card page, the round strip | clean points this round, punches thrown, the three judges' rounds so far | `bell`, `verdict` |
| The hand | what each card costs now (a slip is dearer when tired) and which answers the shown volley allows | `answers`, `slipCost` |
| The ladder page | unchanged for now (training and rungs stay; only boxing playable) | - |

## Not in the greybox (named so nobody assumes it)
The corner's minute as a choice (today: a fresh hand only), styles (out-boxer, pressure fighter: both men have the
same deck), a range track (step back and the ropes stand in for it), the referee's point for holding, cuts.

## Feedback loops
- Leading costs wind and risks a counter -> nobody leads. Seen in the first trial run (18 empty leads of 18). Capped:
  a level round goes to the busier man, wind returns each exchange, a jab cannot be countered. Measured: 9.3% empty.
- A man who is ahead coasts. Capped: the man behind leads first each round; an empty lead scores nothing and loses the
  busier-man tiebreak. Measured by the empty-lead share.
- Down -> hurt -> down again. Wanted, but capped by the bell (daze drops, a fresh hand) and by step back, slip and
  block still working for a hurt man. Measured: 61 stoppages from 240 knockdowns.
- Body work -> shorter wind bar -> fewer answers -> more body work. Capped at a bar of 2, and one body hook is 1 point
  for 2 wind. Measured: bars end at 5.1 of 6 - the loop is too weak, not too strong.
- One-rep trial: a single bout printed turn by turn before any 400-bout table (done; it found the "nobody leads" bug).

## Questions the critics get
1. Does the walked bout read as a boxing match? Which exchange would a boxing man not believe?
2. The clinch lets the first punch through, so it does not save a hurt man. Right or wrong?
3. Three rounds and 83% decisions: right for an amateur bout, or too quiet?
4. Is there a best volley or a best answer that a player would find and repeat?
5. What does the corner's minute have to decide?

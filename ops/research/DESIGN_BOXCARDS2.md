# BOXCARDS2 - boxer v boxer, the volley turned one punch at a time (S550)

Version 1 (`DESIGN_BOXCARDS1.md`) failed Arena's code-checked critic: real bout 5, depth 6, play 6, bar 8
(`BOXCARDS1_CRITIC_ARENA.md`). Its main finding: the answerer saw the whole volley, so one block or one step back
covered a combination. This page is version 2: rules, one walked bout, bot numbers. Code: `proto/boxcards/rules2.mjs`,
`bot2.mjs`, `probe2.mjs`, `boxcards2.test.mjs` (18 tests). No playable page yet (the page on port 8798 is version 1).

## VERDICT (Arena, a fresh code-checked critic, `BOXCARDS2_CRITIC_ARENA.md`): real bout 6, depth 5, play 7 - FAILS the bar of 8
Against version 1 (5 / 6 / 6): real bout +1, play +1, depth -1. It confirms the clairvoyance, the blanket block, the
forced trade and the free breather are fixed, reproduces every number on this page, and finds no blind pilot over 50%
(its own five: best 50.0%). Why it still fails:
- NO RANGE. Nothing says where the two men stand, so a step back, a clinch and a body hook are card facts, not ring
  facts. This is the first item of both critic rounds and of Arena's fourteen. It is the METHOD finding: version 3 is a
  range track, written and probed as its own scope - not a third patch round.
- DEPTH IS NOT PROVEN: the reading bot looks one exchange ahead; "no exploit found" is not "skill beats the draw".
  Only hands played by a person can show it. THE NEXT GATE IS THE OWNER'S PLAY of the page.
- Four contract faults, all FIXED in S550 with tests (21 of 21): a feint let him clinch before any real punch; a
  smothered punch still counted as thrown; a knockdown on a round's last exchange cost no lead; this page said "wind
  bar" where the code means the bar's top (now said plainly below). After the fixes: 80.0% to the judges, first lead
  53.8%, a combination in 89.8% of bouts, a knockdown in 43.0%, empty leads 7.1%, 4 of 6 bars as before.
- Its sweeps: a breather at 2 points is the only tested price that keeps empty leads under 10% (0: 22%, 1: 14%, 3: 4%);
  the slip-and-counter is not too cheap (at 2 wind little moves); a fourth round is not the way to more decisions.

## The one idea
The leader lays up to three cards FACE DOWN. They turn over one at a time. At each punch the other man decides: pay
to stop it, or take it. He sees how many cards are still face down, never what they are. A combination lands because
he ran out of wind or answers, or saved them for a punch that never came.

## What changed from version 1 (and which finding each answers)
| Version 1 | Version 2 | Arena's finding |
|---|---|---|
| The whole volley face up, ONE answer | One punch at a time, an answer to each if he can pay | the answerer is clairvoyant |
| A block took 2 off every head punch | A block stops ONE punch (a big one still shakes him: 1) | one block covers a combination |
| A step back made every non-jab miss | That punch falls short and the volley ends; the cards not turned go back to the leader | every committed punch magically misses |
| A clinch let the first card through, then smothered the rest | No clinch on the first card (he has to come in first); on a later card it smothers that punch and ends the volley. A third hold in a round costs a point | clinch waits for the first card |
| A counter was a forced trade over the first punch | Two kinds: SLIP AND COUNTER (a slip plus a punch from the hand: his punch misses, yours lands clean, the volley ends) and a TRADE over the lead punch only (both land) | the counter is a compulsory trade |
| A slip loaded his next lead | The counter is thrown at once, or not at all | a banked +2 until his next lead |
| Every card of the volley counted as thrown | Only punches that turned count | phantom punches for the busier man |
| A knockdown took a point (could be 9-9) | The man who scored the knockdown takes the round 10-8 | a knockdown round can score 9-9 |
| A pilot could lay anything | The engine refuses a volley he cannot lay and an answer he may not give | no legality check |
| A breather was free | A breather: +2 wind, a fresh hand, and 2 points to the other man | three slots with nobody punching |

## A bout
Three rounds; each man leads three times a round, turn about. A coin for the first lead; later the man behind on the
cards leads first. Own deck of 28, hand of 5 refilled before every exchange, a fresh hand at the bell. No dice.
Shown: every card once turned, both wind bars and head bars, round points, punches thrown, cards already played.
Hidden: the hands and the face-down cards.

## The bars a man carries
- Wind (6): pays for every card as it turns or is laid. 3 back before each exchange, all at the bell. A body punch
  takes 1 off the top of the bar for the whole bout (floor 2).
- Head (0 to 8): a clean head punch adds its number; 1 fades before each exchange and at the bell.

## The cards (28)
| Card | In deck | Wind | When it lands clean |
|---|---|---|---|
| Jab | 5 | 1 | head 1, 1 point. Never countered, never out-stepped |
| Cross | 3 | 2 | head 3, 2 points |
| Lead hook | 3 | 2 | head 3, 2 points |
| Body hook | 3 | 2 | his wind bar 1 shorter, 1 point. A block does not stop it |
| Uppercut | 2 | 3 | head 4, 2 points. A block does not stop it |
| Feint | 2 | 1 | nothing itself: the NEXT punch turns hidden, so he answers it blind |

| Answer | In deck | Wind | What it does to the punch that has just turned |
|---|---|---|---|
| Block | 3 | 1 | a head punch does not score (a big one still adds 1). Wasted on a body hook or an uppercut |
| Slip | 3 | 1 (2 when body work has cut the TOP of his wind bar to 4 or less) | it misses; the volley goes on |
| Slip and counter | a Slip + any punch | slip + the punch | it misses, his punch lands clean, the volley ends. Not against a jab, not blind |
| Step back | 2 | 1 | it falls short and the volley ends. Then he is on the ropes (no second step back until he has led). Not against a jab |
| Clinch | 2 | 1, and 1 from the leader | it is smothered and the volley ends. Not until one real punch of the volley has turned (a feint does not count), not twice running; the third in a round costs a point |
| Trade (a Cross or Lead hook) | - | 2 | both punches land, the volley ends. Only over the LEAD punch, never a jab |

Cards the leader never turned (the exchange was stopped) go back to his hand and cost him nothing.

## Knockdown, count, stoppage, judges
A CLEAN cross, hook or uppercut that fills his head bar to 8 puts him down: the round is 10-8, the volley ends, he
loses his next lead, he gets up with his head at 6 and it does not clear before the bell. Twice down in a round or
three times in the bout: stopped. Down when body work has cut the TOP of his wind bar to 3 or less: counted out (whatever wind he has at that moment).
At the bell: 10-9 on clean points; level, the man who threw more; else 10-10.

## Measured: 400 bot bouts (`node proto/boxcards/probe2.mjs`)
| What | Version 1 | Version 2 | Bar |
|---|---|---|---|
| Goes to the judges | 83.5% | 79.3% | 40-70% (S549; disputed below) - MISS |
| The man who leads first wins | 53.6% | 53.0% | 45-55% |
| A combination in the bout | 90% | 87.5% | most |
| Decisions a bout, one man / both | 16 / 32 | 17.4 / 35 | 22-45 (the scope did not say one man or both) - MISS for one man |
| Empty leads | 9.3% | 7.8% | under 10% |
| Cards never used | none | none | none |
| A knockdown in the bout | 36.8% | 45.0% | - (too many: see open points) |
| How it ends | decision 82%, stoppage 15% | decision 79%, stoppage 19%, counted out 2% | - |
| At a punch he | - | takes it 28%, blocks 20%, slips 15%, clinches 13%, steps back 12%, slips and counters 8%, trades 4% | - |
| Punches where he had a real choice | - | 73% | - |
| A volley opens with | jab 55%, power 26%, feint 18% | jab 54%, feint 25%, power 19%, body 2% | - |

Blind pilots against the reading bot, 400 bouts each seat (the share the blind pilot wins):
slugger 0.5% / 0.7%; always jab-cross-hook 17.5% / 20%; jabs only 8% / 9%; never leads 0% / 0%; takes everything 4% / 1%;
always clinches when he may 48.5% / 48.6%; always steps back when he may 48.5% / 47.5%; always his first legal answer
32% / 35%. None over 50%.

## One bout, walked (seed 6: `node proto/boxcards/probe2.mjs walk=1 seed=6`)
Round 1.
1. A lays jab, cross, uppercut. B takes the jab, then ties A up before the cross lands. A keeps the uppercut.
2. B lays jab, cross, body hook. A does the same: takes the jab, clinches the cross.
3. A: feint, then a hidden punch. B steps back blind; it was a body hook and it falls short.
4. B: feint, then a hidden punch. A blocks blind; it was a body hook, the block is wasted. A then blocks the cross.
5. A: feint, jab, uppercut. B steps back blind from the jab (wasted: a jab reaches), then slips the uppercut and
   counters with a cross.
6. B takes a breather: 2 points to A. Level at 4-4, both threw the same: 10-10.

Round 2.
1. B jabs; A slips it.
2. A: jab, hook, cross. B blocks the jab, slips the hook and counters with an uppercut. A keeps the cross.
3. B: feint, body hook (A slips it blind), jab (lands).
4. A lands a single body hook.
5. B: two jabs; one blocked, one lands.
6. A: jab, cross, hook. B blocks the jab, slips the cross and counters with a cross. B 10-9. A's head is at 4.

Round 3. A, behind, leads first.
1. A: feint, body hook. B steps back blind.
2. B: jab, jab, body hook. A slips the first, clinches the second.
3. A has nothing to lead with and takes a breather: 2 points to B.
4. B: jab, jab, body hook. A is out of wind for answers: all three land.
5. A: jab, cross. B slips the jab, then slips the cross and counters with a hook.
6. B leads a single uppercut. A cannot answer. He is down as the bell goes. B 10-8.
B wins 30-27.

## Open points (what the critic is asked)
1. A knockdown in 45% of three-round bouts is too many. With the head bar at 9 it is 31.5% and 86% go to the judges.
   Swept after this page went to the critic (not changed yet): four leads a round with a head bar of 10 (up at 7):
   a knockdown in 34% of bouts, 84% to the judges, 22 decisions a man, 5 of 6 bars.
2. The slip-and-counter decides most rounds in the walked bout. Is it too cheap (3 wind, two cards)?
3. A breather costs 2 points. Right, or a blunt tool?
4. Three rounds give one man 17 decisions. More exchanges a round, or is 17 quick decisions right for five minutes?
5. Still missing from version 1's list: the corner's minute as a choice (two versions measured, both switched off),
   styles, a range track, three judges.

## Where it shows (when the page is built)
| Screen | What it shows | Wired to |
|---|---|---|
| The table | his cards face down with a count, the punch that has just turned, each answer with what it does and costs before he lays it | `answers`, `exchange` on a copy |
| The two corners | wind bar and its shortened top, head bar against the knockdown line, on the ropes, holds this round | the man's state |
| The round strip | clean points, punches thrown, the rounds so far | `bell`, `verdict` |
| The hand | a slip's price when tired; which punches can follow it as a counter | `slipCost`, `answers` |

## Feedback loops
- Defending costs wind and cards -> a weaker lead next -> he is led at again. Capped: 3 wind back each exchange, a
  fresh hand at the bell. Measured: first lead wins 53%.
- Nobody leads (seen in the first trial bout of this version: 17 empty leads of 18). Capped by: a jab cannot be
  countered, a trade only over the lead punch, no clinch on the first card, a breather costs 2 points. Measured: 7.8%.
- Down -> hurt -> down again: capped by the bell, the lost lead and the stoppage rule. Measured: 0.73 knockdowns a bout.
- Holding -> survival -> more holding: capped by "not twice running" and the referee's point. Measured: 0 points
  taken in 400 bouts, so the cap never bites; a pilot that always clinches wins 48.5%.
- One-rep trial before every table: done twice; both times it found the "nobody leads" fault.

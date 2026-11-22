# CARDSCOPE1 - fresh critic (SDK), code-checked

Read: `CRITIC_PACK.md`, `CARDSCOPE1_CRITIC_KALLI.md` (the brief), `DESIGN_CARDGAME_SCOPE.md`, `docs/CARDSCOPE1_PROBE.md`,
and the greybox code (`proto/cardscope`: cards, rules, bout, opponent, bots). Nothing in `proto/cardscope` was edited.
My policies ran from a scratch file outside the repo, importing the engine, with `check: true` (every answer legal).

## Scores

| What | Score | In one line |
|---|---|---|
| DEPTH | **6 / 10** | The exchange is a real decision and no rule-of-thumb solves it; but five of its levers are switched off in practice and one deck breaks the run. |
| PLAY (fun) | **5 / 10** | Nobody has played it; on the numbers you only ever answer, he never tires, and a sensible beginner falls off a cliff at the third bout. |
| GENERAL | **6 / 10** | The best-argued page in this line of work (bars written first, failures named); the plan builds the table before fixing what the table will feel like. |

The mechanic does not yet reach the 8 + 8 bar. It is worth another round, not a cut: the faults are in the opponent and
the card pool, not in the three-beat exchange.

## What I played (about 34,000 bouts, own seeds 770000 and 900000 up; 5 read beat by beat)

Population every time: the page's 4 player boxers against its 4 opponents, all different, never the same boxer on both
sides; regional class unless said. "Lookup" is my own policy: a person's rule of thumb, one rule per shown card
(straight punch: cross counter, else slip, else block; hook: roll, else block; guard: hit round it; nothing shown: jab,
cross, hook in order), one fixed answer to the face-down card, no counting, no judges, no memory.

| Policy | Wins | What it shows |
|---|---:|---|
| Their reader, my seeds (960 bouts) | 60.6% | The probe's 63.0% repeats. |
| Their greedy, my seeds (960) | 37.3% | The probe's 38.9% repeats. |
| Lookup, block the hidden card (2,400) | 11.0% | A sensible rule table loses. The exchange is not a lookup. |
| Lookup, jab the hidden card (2,400) | 13.3% | Same. |
| Lookup, step back / leave it empty (2,400 each) | 14.2% / 0.0% | Leaving the hidden beat empty never wins. |
| Lookup with no fallback (plays nothing when the right card is not in hand) | 0.5% | Guarding only what you can guard properly is a 99% loss. |
| Lookup by class: novice / open / regional / title / pro (1,600 each) | 72 / 16 / 12 / 5 / 3% | **The cliff:** 72% to 16% between the second and third bout of the run. |
| Reader, hidden answer forced: free / block high / jab / empty (800 each) | 60.3 / 41.6 / 47.9 / 12.5% | The bet on the hidden card is real: a fixed answer costs 12 to 48 points. |
| **Breaker:** neutral deck + 4 Cross counters, lookup (800) | 29.8% (from 2.3%) | One card lifts a no-thought player 27 points. |
| **Breaker:** 10 cards (4 Cross counter, 3 Block, 2 Jab, 1 Tie up), lookup (800) | 37.9% | Same card, thinner deck: as good as their greedy bot with no thinking. |
| **Breaker:** the same 10 cards with their reader, regional / pro (240 each) | **93.3% / 78.3%** | **The run is broken.** The probe's reader wins 27.0% of pro bouts; this deck wins 78%, with 0 stoppages. |

Measured inside the reader's bouts (640 bouts, about 7,600 exchanges):

| Fact | Number | Why it matters |
|---|---:|---|
| Exchanges where he is on 1 wind or less | **0.0%** | "A tired boxer cannot hide a card" never happens. Body work, wind reading and "one quiet exchange buys a loud one" exist for you only. |
| Wind at the lay: you / he | 4.8 / 8.9 (pro: 10.2) | In code the regional out-boxer has top wind 10 and gets 6 back; you have 7 and 3. The page says "more wind, in steps", not "twice yours". |
| What he lays: punch / guard / feint / nothing | 82 / 16 / 1 / 1% | He throws 2.96 cards of 3 every exchange. The empty face-down bluff in the rules does not exist in play. |
| What the face-down card is | punch 81%, guard 15% | It is not "punch, trap or nothing". It is "which punch". |
| What the reader puts against it | a punch 62%, nothing 17%, block 9%, slip or roll 4% | The best play against the unknown is to trade, not to read. Defence is one answer in seven. |
| Damage an exchange, to you / to him (reader) | 9.1 / 8.8 | You win on the cards while taking slightly more. 31% of wins are with more head damage taken than given. |
| Legal answers an exchange | 112 | Rich enough. Also too many to weigh by eye without help (see PLAY). |

## DEPTH 6 / 10 - evidence

For:
- **No rule of thumb wins.** My lookup takes 11 to 14%, their damage search 37%, their reader 61%, the all-seeing bot 80%. Four clear steps of skill, and I could not close the gap with a table. That is the thing the old prototype never had.
- **The hidden card is a sized bet.** Forcing any one answer on it costs 12 to 48 points; seeing it is worth 17. Neither a guess nor the whole game.
- **Deck picks matter** (probe: informed picks +18 points). Too much, in one case: see the breaker.

Against (each one is a lever the page promises and the greybox does not deliver):
1. **He never runs out of wind.** 0.0% of exchanges on 1 wind or less. So the body hook, "take his wind, then his secrets", reading what he can afford face down, and the corner's water are dead on his side. Half of section 3.2 is decoration.
2. **He is 82% punches.** Feint has nothing to draw, the uppercut nothing to split, slip and roll cannot be baited, the "empty bluff" never appears. The probe names this cause itself; it is larger than the page admits because it also flattens the hidden card to "which punch".
3. **One card and a thin deck solve the run.** Cross counter costs your whole wind income (3) and one copy can be played every exchange; his decks are 50 to 67% straight punches. Drop the deck to 10 and the pro debut goes from 27% to 78%. "Drop a habit" plus "pick a new card" is a solved run.
4. **Knowledge buys nothing yet** (probe B15: film +1.7, patterns +1.3, counting 0; B17: corner +1.6). I agree with the probe's numbers. Four of the eight "what the player sees" rows in 3.4 are worth under 2 points each.
5. **The depth that exists is arithmetic.** The reader's edge over my lookup is mostly exact sums over 112 lines (who is faster by 2, what a block of 4 leaves of a cross of 8, chain +2 or +4 or +6, counter +4). That is depth a program has; a person gets it only if the table does the sums (see PLAY).
6. **Style pairs 28 to 100%** (mine: out-boxer v volume 100%, counter v pressure 28%) - content, as the probe says.

## PLAY 5 / 10 - evidence

- **Unplayed.** No person has laid a card. The page says so honestly; the score cannot be higher than a promise.
- **You only answer.** Twelve times a bout he lays, you react. You never set a trap, never bluff, never make him guess. Every game in the page's own table that scores high on feel (Spire, Inscryption, Snap) lets the player set something up that pays later. Here the only set-up is inside your own three beats.
- **He does not get tired, you do.** He plays 3 cards, you 2.5 of the cheapest (jab 24% and block 19% of all plays; uppercut 1.9%, cross counter 2.4%). The loud turn is rare. A player will read "he has twice my wind" as the game cheating, not as "better on paper".
- **The beginner's cliff.** A sensible rule-of-thumb player wins 72% of novice bouts and 16% of open-class bouts. The first hidden card arrives together with more wind and heavier hands for him. Two changes at once, at bout 3.
- **Guarding loses, trading wins.** The page's own one-liner ("guard what you see, hit where he is open") is the losing line (0.5 to 11%). The winning line is to out-trade him and take the cards. A new player who does what the tutorial sentence says is knocked out 45% of the time.
- **Good:** short bouts, one true table, no dice, three judges on screen, split cards half the time, one bout in three turns late, stoppages 10%. Read as text the bouts make boxing sense (jab-cross-hook lands for 2, 10, 12; a cross counter takes a jab away).

## GENERAL 6 / 10

For: bars committed before the first run and not edited; three runs and then stop; every failure has a cause; the old form's faults are measured, not asserted; keep/throw list is right. My runs repeat the headline numbers on other seeds.
Against: (a) phase 2 puts the owner at the table before phases 3 and 4 fix the two things he will feel first (he never tires; one card wins); (b) open decision 2 (taking turns to lead) is filed as taste, but it is the structural fix for the page's biggest design cost and should be probed, not asked; (c) the page states things the greybox does not do (the tired-boxer rule, the empty bluff, "counting his discards" as the main read in section 5 while 3.4 says it is worth nothing); (d) code: a level judge falls to the opponent (`|| -1` in bout.mjs), so every true tie is his; the opponent's corner never picks "watch him".

## Can Form D reach 10/10 fun?

The exchange can. Form D as written cannot, for one reason: **the seeing chair is so strong that the only way to balance it was to make him a different kind of boxer** (double wind, heavier hands, all punches). That one patch is the root of most failures above: wind dead on his side, body work dead, guards and feints dead, the cross counter always right, the player always the one being hit harder. Sizing the card pool (phase 4) will not undo it.

What stands in the way, in order:
1. The lead never changes hands (no traps, no bluffs, no initiative to win).
2. Balance by raw numbers instead of by the rules of the exchange.
3. The hidden card is a punch four times in five, so "read" means "trade".
4. The sums are too many for a person; without a preview the skill is invisible.
5. One card plus deck thinning solves the run.
6. Knowledge (film, patterns, corner) changes almost no answers.

My estimate of the ceiling: with items 1 to 4 fixed and probed, 8 to 9 as a fight; 10 needs the run and a person saying "one more bout", which no bot can show.

## Cards

**Useless as they stand (cut or rework):**
- Feint - worst pick against everybody; he guards 16% of beats.
- Step back - 2 wind to earn nothing with no judge credit; 1 to 2% of plays.
- Uppercut and Body hook - their targets (a guard to split, a wind to drain) do not exist against these opponents.
- Roll - the slip's weaker twin while hooks are a minority; fold both into one "evade" with a chosen side, or give hooks their own opponents.
- Watch him (corner) - the informed pick 59% of the time yet always-picking it loses 7 points; a trap for the player.
- The open discard pile - worth nothing by the probe's own count; print the count or drop it.

**Too strong:** Cross counter (see the breaker); Tie up (second-best against every style at 1 wind).

**Missing:**
- **A trap that punishes the safe answer** (the probe asks for it; nothing is specified). Proposal - *Check hook*, 2 wind: if your card on this beat is a jab or a block, it lands 6 and your next beat is lost.
- **A card that wins the lead** - *Pivot*, 2 wind: evades a straight; next exchange you lay first.
- **A cheap answer to the jab only** - *Parry*, 1 wind: a jab misses and your jab on the next beat is a counter. Gives the commonest shown card its own cheap read instead of the block.
- **A level change** - *Feint low, go high* as his card: looks like a body punch face up, lands to the head unless you blocked high. Makes a shown card unsafe without hiding it.
- **A breath card** - *Cover up*, 0 wind: stops 2 of anything, +1 wind. Today the only way to save wind is to be hit clean.
- **A finisher** - *Flurry*, 3 wind, playable only against a hurt boxer: three light punches on one beat. Gives the man behind the late finish section 3.3 promises.
- **A body card that pays in three rounds** - Body hook takes 2 wind now (the page's own perk, made the base card) once he can actually run dry.

## TO REACH 10/10 (most important first; each can be built and probed)

1. **Take turns to lead, and make him equal on paper.** Odd exchanges he lays three (two up, one down) and you answer; even exchanges you lay three (two up, one down) and he answers with the same rules. Remove the wind and power steps from regional class down (top wind 7, back 3 for both). Probe bars: reader 55 to 65% at regional with equal paper; he is on 1 wind or less in 5 to 15% of exchanges; damage given and taken within 10% of each other for the winner; your face-down card is something other than a punch 30%+ of the time in the reader's best play.
2. **Re-cut what he lays so the hidden card is a fork.** Target mix face down: punch 45%, guard or trap 30%, nothing 15%, feint 10% (today 81 / 15 / 2 / 2). Add the trap card above to every opponent deck. Bar: no single answer to the hidden card (block, jab, punch, empty) within 10 points of the free choice, and the reader's answers to it spread so that no class of answer is over 40% (today a punch is 62%).
3. **Close the breaker.** Cross counter beats the cross only (not jab or body jab), a deck may hold at most 2, and a deck may not go under 12 cards. Tie up costs 2. Bar: no deck of legal cards wins the pro debut over 50% with the reader, and no single added pair lifts any pair-up by more than 25 points (today +62 against the out-boxer).
4. **The table does the sums.** Phase 2's page shows, as each card is placed, the exact result of every beat against a face-up card (damage both ways, who lands first, chain bonus, what the block leaves) and a range against the face-down one, plus what each judge would score. Without this the 49-point gap between a rule of thumb and the reader is invisible to a person. Bar for the owner's three bouts: after each exchange he can say why he won or lost it, and he wins 1+ of 3 at open class.
5. **Smooth the cliff.** Split the two changes: bout 3 hides one card with equal paper; his numbers move only from the title bout. Bar: my lookup policy (kept as a "sensible beginner" bot in the harness) wins 70%+ novice, 45 to 60% open class, 25 to 40% regional (today 72 / 16 / 12).
6. **Make knowledge flip answers.** A known habit prints the card on the face-down slot when its trigger is on the table (the probe's proposal) and each opponent's two habits rule 50%+ of his exchanges. Film finds one habit; watching finds the other by round 2. Bar B15 as written (4+ points) and the reader's answer to the hidden card differs with and without the habit in 30%+ of the exchanges where it applies.
7. **Corner cards as orders, each with a cost.** Replace water / ice / watch him with orders that change a rule for the round: "Go to the body" (body punches +2, head punches -2), "Box and move" (evades cost 1, punches thrown do not score with the work judge), "Close the show" (knockdown line -4 for both). Bar B17 as written and each order the informed pick 20%+ of the time.
8. **Give the weak cards a target instead of a number.** With guards and tired opponents back (items 1 and 2), re-measure Feint, Uppercut, Body hook, Roll, Step back before changing them; then add Parry, Pivot, Cover up and Flurry one at a time, each kept only if it is top-four against one style and bottom-half against another (B6). Step back earns the craft point when it makes a power punch miss.
9. **Styles inside 40 to 90%** (B18) after the re-cut: the volume opponent needs one counter for fast straights, the counter-puncher's deck one answer to the body.
10. **Fix the two code faults before porting:** a level judge goes to damage, then the last exchange, then a coin from the seed, never to the opponent by default; the opponent's corner can pick every corner card.
11. **Run and feel** (phases 6 and 7 as planned), with one added bar: of 10 people or the owner over 3 runs, the sentence "I lost because of what I played, not because of what he had" after a loss.

Order matters: items 1 to 3 change the numbers every later phase is sized on, so they are one more probe round on `proto/cardscope` before phase 1 ports anything. If item 1 fails its bars, Form D stays an underdog puzzle and should be scored against an 8, not a 10.

## My 10/10 in words (no picture: this job was limited to this one file)

One table. Top: his three slots, left to right, two cards face up, one back; under each, small, what the last three face-down cards on that beat were. Middle: three result strips, one a beat, filling in live as I place a card ("your jab lands first 2 - his cross 8 becomes 6"), the face-down strip showing a range and the habit if one is known. Bottom: my hand of five, my wind as seven pips, his wind as pips beside his slots, dimming as he tires. Right edge: three small scales, one a judge, each with its taste as one word, moving as I place cards. Every second exchange the table turns round: my three slots on top, I choose which one goes face down, and his answers flip one by one.

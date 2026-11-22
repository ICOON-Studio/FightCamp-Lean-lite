# CARDPROTO3 - second critic (fresh SDK job, code-checked), round 3

Fresh critic, no author context, no earlier critic file read. Read: `proto/cardgame/README.md`, `rules.js`, `rules-data.js`,
`rules-exchange.js`, `rules-ai.js`, `rules-camp.js`, `rules-tell.js`, `rules-judge.js`. Nothing in `proto/` was edited; the
harness lived outside the repo and drove the real page sequence (`createGame` -> 4 `pickCampCard` -> `startFight` ->
`playExchange` / `pickCorner` until `isOver`).

Population: all 16 legal ordered pairs of the roster (same sex, other club), 30 to 300 seeds a pair, roughly 45,000 bouts in
total against the engine opponent. Boxers differ in stats, deck, style and habits. Win rates on 640 bouts are +/- 4 points,
on 480 bouts +/- 4.5, on 300 bouts +/- 5.5.

## Scores

| | score | one line |
|---|---|---|
| DEPTH | **5 / 10** | The table is real and reading pays, but one mechanical combo wins 78% with no reading, and five described systems change nothing. |
| PLAY (fun) | **5 / 10** | Judged from transcripts and numbers, not from a human sitting at the page: 81% of bouts end in a 5-0 card, Predict is a trap, and the best line is the same three clicks every exchange. |
| GENERAL | **5 / 10** | Clean, tested, honest code and a good boxing table. Not at the 8 / 8 bar. |

Below the bar on both. Verdict: another round, not the board.

## Evidence

### 1. There is a dominant strategy: a cheap defence in front, two punches behind (the biggest finding)

In a combination only the FIRST card meets his card for his damage (`rules-exchange.js` line 224: his strike resolves against
`combo[0]` only). Cards two and three each resolve on their own table cell and he never answers them. So the cheapest
defence card goes first as a shield and the two biggest punches ride behind it for one extra wind each.

| policy in the player chair (640 bouts, same seeds) | wins | damage dealt / taken | stoppages |
|---|---|---|---|
| random legal card | 32.3% | 55.6 / 68.9 | 8.6% |
| engine chooser (film + tell) | 52.7% | 66.3 / 63.2 | 13.4% |
| engine chooser, public only (no film, no tell) | 52.7% | 66.7 / 65.6 | 13.8% |
| always the largest-damage card | 50.3% | 67.1 / 67.8 | 15.3% |
| engine card + 1 biggest punch behind it | 62.8% | 75.2 / 61.7 | 18.0% |
| engine card + 2 biggest punches | 65.0% | 76.3 / 61.6 | 18.9% |
| 3 biggest punches, no thought | 59.4% | 73.1 / 63.3 | 18.6% |
| **cheapest defence + 2 biggest punches ("shield")** | **77.8%** | 88.6 / 54.4 | 30.8% |
| cheapest defence + 1 biggest punch (480 bouts) | 74.4% | 81.4 / 57.0 | 24.0% |

The shield reads nothing: no film, no tell, no range. It beats the best honest reader I could write (64.7%) by 13 points.
By boxer it wins 60% (Mara) to 95% (Lena); the engine chooser with the same boxers wins 40% to 67%. Wind does not stop it:
the shield is short of wind in 26.5% of its exchanges (engine: 3.8%) and ends on 2% of its tank, and still wins 78%,
because being gassed costs only 8 accuracy and 40% of the damage. The README gate "a one-card strategy over 45%" cannot see
this, because the harness never plays a combination.

Sample (Lena v Ines, seed 4242, round 1): `slip+cross+jab` v jab: dealt 25.2, took 0. `slip+uppercut+cross` v cross: dealt
14.8, took 0. Stopped her in round 3.

### 2. Smart play does beat random, and the ceiling is high

- Random 32.3%, largest-damage 50.3%, engine 52.7%, my reader (film habit if live, else the free tell, else the engine)
  58.4%, the same reader buying the tell whenever wind is over 30: **64.7%**.
- A cheat that knows his card and answers it from the table: **96.9%**. So the table itself has plenty of skill in it; the
  public information is what limits a reader.
- Always the same card (else random), all 17 cards: 30.3% to 36.9%. No single card dominates. Good.

### 3. Film barely changes the result

Win rate by habits on film at the bell (640 bouts each):

| policy | 0 habits | 1 habit | 2 habits |
|---|---|---|---|
| engine chooser | 54.2% | 52.0% | 52.0% |
| reader | 57.4% | 56.9% | 61.4% |
| reader buying tells | 66.3% | 62.1% | 66.3% |

The engine chooser with film and tell scores exactly what it scores without them (52.7% both). A habit is live in only 17%
of exchanges (1,928 of 11,393). Film study at camp forced into the plan: 50.4%, no gain. The Study corner: 50.2%.

### 4. The tell works, and buying it is close to automatic

The chip is right 59.6% of the time (README says 60%: true). For a player who answers the shape, buying every look is worth
+6.3 points (58.4% -> 64.7%) for 4 wind. That is a real decision only when wind is tight; above 30 wind it is always yes.
The engine's own use of a bought tell is worth less than the 4 wind (52.7% -> 46.6%).

### 5. Predict is a trap, and the player does not choose the forecast

`predictedCard` picks the forecast for the player; "Predict" is one button that bets on the engine's guess. How often that
guess is right, measured against the card he actually throws:

| situation | forecast right | share of exchanges |
|---|---|---|
| no habit live, no tell seen | 14.2% | 70% |
| free tell seen, no habit | 30.7% | 13% |
| habit live, card under 85% likely in hand | 32.2% | 14% |
| habit live, card 85%+ likely in hand | 60.1% | 3% |

Always predicting: **14.1%** wins, stopped in 65.8% of bouts. Predicting only on a live habit: 50.5% (worse than never:
52.7%). Predicting only on an 85%+ habit: 51.7% (still not better). The reader with Predict on a habit: 54.8% v 58.4%
without. I found no situation where pressing Predict raises the win rate. The README's "predict share 31.2%" measures an AI
pressing it, not that it pays.

### 6. Effects that are described and change nothing (each checked in code and by counting)

- **Clinch "leaves his next punch 15% looser".** `nextPunchAcc` is set at lines 275 / 280 and deleted at line 282 of
  the same exchange. 337 won clinches in my run: the penalty was present at the next exchange 0 times. Inert.
- **The ropes.** With the engine in both chairs: 0 of 11,393 exchanges on the ropes; the trap is live in 1.2%. With a
  player who throws Cut off every time it is in hand: 0.07% of exchanges on the ropes, 50.0% wins. The AI cannot build the
  ladder at all: `aiLegal` exempts only Clinch from the no-repeat rule, not Cut off. The whole "pressure has a currency"
  paragraph is not in the played game.
- **Corner cards.** Forcing each card whenever it is offered: Ice 52.3%, Stool 51.0%, Study 50.2%, Change the plan 50.0%,
  Breathe 49.8%, Gloves high 49.2%; a random corner pick 50.0%. Every corner pick is inside the noise. The AI never picks
  Change the plan (0 of 958 picks).
- **Five judges with tastes.** Of 554 decisions, 517 (93%) were 5-0, 20 were 4-1, 17 were 3-2. Which judges sit does not
  matter.
- **`lastLandedClean`** is reset and read but never set to true (0 times).
- **The opponent's feint** is never cleared when the opponent punches (only the player's is, line 235); it stayed live more
  than one exchange in 7 of 23 cases. A small free accuracy bonus for one chair.
- **Reactive speed bonus**: the opponent gets it always, the player only on React; and the player's damage is always cut
  10% (`a.head *= guard`) while the player's own cut needs React. The chairs are not the same game.

### 7. Camp is a weak decision

1,920 bouts an arm: informed camp **53.5%**, random drill **50.9%**, worst drill every week **46.0%**. Informed over random
is +2.6 points on my seeds, not the README's +8.5 (the removal in my random arm is still the smart removal, which may be the
difference; either way the drill choice alone is worth under 3 points). Forcing each drill (480 bouts, +/- 4.5): all 16 sit
between 45.8% (Breath work) and 54.0% (Body work): no drill is clearly good. The printed `DRILL_VALUE` order (Right-hand
7.2 best, Double-jab 1.0) does not match (Right-hand 50.4%, Double-jab 53.3%). Stat drills also remove a card
(`removalsFor` returns at least 1), which the drill text does not say.

### 8. Fairness from both corners

The roster allows only 6 of the 16 style pairs (no counter v out, no same-style pair but out v out, and so on), so "all 16
style pairs" cannot be tested through the real page. By boxer pair, engine chooser, 300 bouts each:

| pair | player wins | reversed |
|---|---|---|
| Kwame v Tomas (pressure v counter) | **66.0%** | 46.3% |
| Kwame v Rio (pressure v counter) | **63.3%** | 44.7% |
| Rio v Piotr (counter v volume) | 58.7% | 52.3% |
| Lena v Ada (out v out) | 50.7% | 41.0% |

Kwame is outside the 42-58 band against both counter-punchers, and the player chair is worth points on its own (Rio v Piotr
58.7 and Piotr v Rio 52.3 add to 111, Kwame v Tomas and back add to 112): the chair asymmetries in point 6 show here.

### 9. Variety

- 419 distinct exchange lines in 11,393 exchanges; the top 40 lines are 42% of everything read. The same five sentences
  ("jab and jab trade; neither man gives ground") come back 150 to 180 times each. There are only six reason endings unless
  a named pair fires.
- Nobody takes any damage in 37.2% of exchanges (misses and defence wins count; the README's 8.3% counts only the `n`
  code). More than one exchange in three is a blank for the player watching.
- Range is alive: mid 47%, inside 38%, out 15%.
- 13.4% stoppages, 0.59 knockdowns a bout: as printed.

### 10. Tests

`node proto/cardgame/rules.test.mjs` -> RESULT: PASS - all 32 checks green
`rules.round2.test.mjs` -> RESULT: PASS - round 2 (19 checks green)
`rules.round3.test.mjs` -> RESULT: PASS - round 3 Part A (11 checks green)
`rules.round3b.test.mjs` -> RESULT: PASS - round 3 Part B (16 checks green)
`rules.round3c.test.mjs` -> RESULT: PASS - round 3b second pass (17 checks green)

No test deleted or touched. Note the last file prints "round 3b second pass" as its own name.

## Useless or near-useless cards and options

- **Predict (the mode)**: never raised a win rate in any arm; always-on loses 86% of bouts.
- **Catch breath**: the opponent AI played it 0 times in 11,393 exchanges; the player engine 1.4%. Breath work is the worst
  drill (45.8%).
- **Feint**: 0.7% of the opponent's cards, 0.6% of the player's. Under the README's own 1% gate in my runs.
- **Pivot out**: 0.8% / 0.6%. Its job (off the ropes) never comes up because the ropes never happen.
- **Cut off as a ladder**: the trap and ropes are unreachable (point 6); Cut off is just a 6-wind closing step.
- **Check hook**: 1.9% / 1.3%; its two named kills (Cut off, Clinch) are rare cards themselves.
- **Clinch's accuracy penalty**: inert.
- **Corner cards**: all six within +/- 2 points of a random pick; Change the plan never chosen by the AI.
- **Film study, Study the corner**: no measurable gain.
- **Gloves high**: 49.2%, the worst corner; it softens your own punches for one wind on a card played 4% of the time.

## Missing cards and options

- **The player's own forecast**: name the card (or at least the shape) you predict. Today the engine guesses for you.
- **An answer to combinations**: nothing the opponent holds punishes a second and third card. No "counter the combination"
  outcome, no card that interrupts.
- **A body jab / body straight**: the only body punch is the inside Body hook, so wind attack is impossible from range.
- **A finishing choice when he is hurt** (go for it / stay patient): hurt changes his habits but offers the player nothing new.
- **A shell / cover-up**: one card to survive when hurt that is not the Clinch (which the referee punishes).
- **A corner instruction that changes his next round** ("box", "press", "go to the body"): corners today move only wind
  and damage numbers, and none of them moves the result.
- **Southpaw / stance** or any second axis besides shape and range: the table is the only axis of the read.
- **The shown-attack variant (Part C)** is not built; the blind reveal is the only mode.

## TO REACH 10/10 (most important first)

1. **Close the shield combo.** Make every card of a combination meet his card: his strike resolves against the WORST
   cell of the combination for the thrower (or against the last card thrown), not against `combo[0]`. Add: a combination's
   later cards land only if the card before it did not lose (`l` or `X` ends the combination). Gate it in `balance.mjs`:
   no fixed combination policy (shield+1, shield+2, three biggest punches, engine+2) above 55%.
2. **Make wind bind on combinations.** Extra cards cost +2 and +4 wind (not +1 each); a gassed punch does 40% damage and
   loses 20 accuracy (today 60% and 8); a boxer at 0 wind cannot throw a combination. Target: a 3-card combination is
   affordable about twice a round, not every exchange.
3. **Let the player call the forecast.** Predict asks for a shape (10 buttons) or a named card. Right shape = win one step
   better; right card = clean win with the card's effect. Wrong = today's penalty. Target: predicting on a 60% tell or an
   85% habit is worth +3 to +6 points over never predicting, and always predicting stays under 40%.
4. **Fix the two chairs.** Give the player the same speed bonus and the same 10% cover rule as the opponent in both modes
   (or neither), clear `foe.feint` when the opponent punches, set `lastLandedClean`. Gate: every ordered boxer pair A v B
   plus B v A sums to 100 +/- 4 with the same policy in both chairs.
5. **Make the pressure ladder real.** Add `cut_off` to the `aiLegal` exemption so the AI can cut the ring twice; let one
   Cut-off win plus one won punch at inside also count toward the ropes. Target: 8 to 15% of a pressure fighter's exchanges
   on the ropes, Pivot out over 3% of cards played, and Kwame back inside 42-58 against Tomas and Rio (today 66 and 63).
6. **Wire the clinch penalty.** Move the `delete ...nextPunchAcc` to after the NEXT exchange has read it (store it on the
   side, clear it when consumed). Test: after a won clinch the next punch's hit chance is 0.15 lower.
7. **Make film matter.** A known habit fires 85% of the time (not 70%) and the file shows whether the card is in his hand
   this exchange once it has been seen twice; every boxer gets three habits so one is live in about 35% of exchanges (today
   17%). Target: the reader gains 6+ points from 0 to 2 habits on film (today +4 at best, 0 for the engine).
8. **Make corners decide something.** Triple the numbers that matter and add instructions: Ice 18 head for 5 wind; Breathe
   +24; Gloves high: Block also beats the Body hook next round; new "Go to the body" (body punches +25%, head punches
   -15% next round); new "Box and move" (start at out range, Step back costs 1). Gate: the best corner pick of an offer
   beats a random pick by 4+ points, and no corner card is picked under 5% of the time by the AI.
9. **Make camp a build, not a nudge.** Stat drills +8 (not +5) and say on the card that a card leaves the deck; card
   drills let the player choose the removal on the page; re-measure `DRILL_VALUE` on this round's rules (it is the round-3
   table and no longer matches). Gate: informed v random drill choice 6+ points with the same removal rule in both arms,
   and at least two drills are bad for at least one style.
10. **Give the judges a job.** Raise each judge's taste so that split cards are 25 to 35% of decisions (today 7%); show the
    three sitting judges before the bell so volume v damage v defence is a plan. Gate: the same bout re-scored under two
    different panels changes the winner in 10%+ of decisions.
11. **Cut the blanks.** Count "nobody takes damage" (not only code `n`) and bring it from 37% to under 20%: a defence
    that wins always pays its printed counter as damage, and a miss against a non-punch still scores a touch (1 head).
12. **Fix the dead cards.** Catch breath: 10 wind (not 6) and legal after any card. Feint: a won feint also shows his next
    card's shape for free. Check hook: also beats Jab at inside. Each must reach 3%+ of cards played by the AI.
13. **Vary the words.** Three sentence variants per outcome code and per named pair, picked by seed; name the range and
    the round situation ("on the inside", "late in the round"). Target: the top 40 lines under 20% of all lines (today 42%).
14. **Open the roster so the page can play every style pair**: one more club or two more boxers a sex, so counter v out,
    volume v volume and the other ten pairs can be tested from both corners through the real sequence.
15. **Add the missing cards**: Body jab (straight, out/mid, 2 head 5 body, cost 5), Cover up (guard, beats every punch
    shape as `l`, cannot be played twice in a row), and one interrupt card that beats any combination of two or more.
16. **Then build Part C (the shown-attack variant)** and put a human on the page: none of the PLAY score above comes from
    a person playing it.

No 10/10 picture was drawn: this job may add only this one file.

# Card game round 9 - why boxing beats jiu-jitsu 77 to 23: two bouts walked from each side (S548)

Owner S548, on waiting for Arena's limit: "can ludo or dola do the job?" Ludo cannot (pictures and sound only) and Dola
cannot run the engine, so Claude ran Arena's branch on the PC (FightCamp-Lean-lite,
`arena/f591a0d9-fightcamp-lean-lite`, e0e15a7; a shallow clone in the scratchpad, nothing merged) and walked the bouts.
Tools: a 40-line tracer on the engine's own hooks (`bout(..., { onAnswer, onAct })`), 400 bot bouts, seats alternated,
seed 500000000 + 7919 x i (the gate's protocol). Nothing here is a balancing number.

## What 400 bouts say before any change
- Boxing wins 77.0%: 307 knockouts, 1 on the cards. Jiu-jitsu wins 23%: 81 on the points lead, 11 taps.
- The boxer ends every bout on 42 of 42 health. **The jiu-jitsu man deals 0.0 damage a bout** and ends on 3.
- The floor is reached in 92% of bouts, and still only 11 taps: a submission card is laid in about 1 bout in 10.

## Rule 1 - A REAL ERROR: the man who pulls guard landed on TOP
Walked in bout seed 500000000 (r1 t3, r1 t7) and 500007919 (r1 t6): the jiu-jitsu man has his tie, the boxer steps out
of the clinch, the jiu-jitsu man answers by pulling him down - and the engine seats the PULLER on top (`gtop`) and the
boxer underneath. Every finishing card of his deck is played from his back in the guard (`gb`): triangle, armbar,
sweep, kimura. So he arrives on the floor holding "tie up, triangle, kimura, choke, sweep", can lay none of them, nobody
works, and the referee stands them up after one quiet exchange (`stallMax` 1). In a real fight the man who pulls guard
lands on his back with the other man inside his guard: that is what "pull guard" means, and it is what the engine's own
`@pull` act already does (moves.mjs, the `id === '@pull'` branch: the puller `a` goes to `gbot`).

The line (moves.mjs, inside `id === '@out'`, the `ans === '@pull'` answer; `d` is the answering man = the puller):
```
-        placeBoth(S, d === 0 ? ['gtop', 'gbot'] : ['gbot', 'gtop'], { g: 'closed' }); S.tie = null; S.stall = 0;
+        placeBoth(S, d === 0 ? ['gbot', 'gtop'] : ['gtop', 'gbot'], { g: 'closed' }); S.tie = null; S.stall = 0;
```
Tried locally: 61 of 61 tests still green. 400 bouts after: boxing 70.5% (237 knockouts, 37 cards, 8 lead), jiu-jitsu
29.5% (**68 taps**, was 11; 50 lead). Triangle is laid in 61% of bouts (was 11%), sweep 49% (10%), armbar 33% (9%).
The gate's own number: boxing 71.0 / jiu-jitsu 29.0 (was 77.5 / 22.5). Needs a red test first: "a pull that answers a
step out of his own tie seats the puller in the guard, bottom".

## Rule 2 - standing and apart, the jiu-jitsu man has nothing to do 4 turns in 10
Walked in bout seed 500031676 (after the fix; boxing by knockout, 45 damage to 0): r1 t1 he holds sweep, escape,
up-kick, choke, armbar and lays nothing; r1 t2 pass, kimura, triangle, triangle, sprawl: nothing; he loses 24 health
before his first Tie up comes to hand in r1 t3. Round 2 the same: two turns of nothing, knocked out on 4 health.
Counted over 400 bouts: of his 1,771 turns standing apart he lays NOTHING in 688 (39%). The cause is the deck, not a
number: the boxer's deck has 10 cards of 15 he can lay standing; the jiu-jitsu deck has 2 (the two Tie ups). His
finishing cards are all floor cards, and the only door to the floor is a card he holds two of.
What a real fight says (for the designer to choose from, not decided here):
- Reaching for a grip is not a rare event. A grappler can always step in and reach; what is uncertain is whether he
  gets it, and what he eats on the way in. That is a free move with a price (the boxer's answer: a punch on the way in
  or a sprawl), with the Tie up CARD as the sure version - not a card or nothing.
- Sitting to guard is already free in the rules (`@pull` with no tie = "he sits, the boxer stays standing", where
  Up-kick and Sweep work against a standing man) - and the bot NEVER does it: 0 sits in 400 bouts. Either the bot's
  worth for sitting is wrong, or sitting is as bad as it looks (a seated man against a boxer who just walks away);
  walk two bouts with a scripted sit before deciding.
- He never hurts anyone: 0.0 damage a bout, Up-kick laid in 3% of bouts. A jiu-jitsu man is not a striker, so this may
  be right - but then his standing turns need the grip door above, or every standing exchange is free for the boxer.

## The decisions gate (21.0 against 22.5-45)
After rule 1: 21.6. Rule 2 is the same problem seen from the other gate: 688 turns in which one man decides nothing.
Giving him a real standing choice (reach or sit or cover) should move both; measure, do not size.

## For Arena (the next message)
1. Red test for rule 1, then the one-line fix; `node --test` green; the play gate re-run.
2. Rule 2: walk two bouts each side WITH a scripted sit and with a free reach, say which the real fight supports, build
   that one; no balancing number; engine.mjs under 500 lines.
3. Gate rows 1 and 2 ("the page offers no #skip") are the gate script clicking before the coach's line (`#gotit`): fix
   the script's order, not the page.

## DONE the same session (owner S548: "fix both yourself, dont wait for arena")
Round 9 is on main (`proto/cardgame`, Arena's branch e0e15a7 plus four commits), each fix red first:
1. Rule 1, the one line in moves.mjs. Test: "a pull that answers a step out of his own tie seats the PULLER in the guard".
2. Rule 2 was the BOT, not the rules. The rules already had the free standing choice the walk asked for: Step in (at
   punch range it is the clinch entry, and he can be hit coming in) and Sit down (Pull guard with no tie). Tried on 400
   bouts with the bot's empty standing turns filled: step in 69.8% boxing (no help: a clinch without a hold card is
   still a dead hand), **sit down 52.8%**. The bot never sat because its look-ahead is two cards deep and a seat pays
   three moves later. Now it sits when it would lay nothing standing apart - not once the referee has warned it that
   round (the third stand-up costs a point). plan.mjs, 6 lines. Test: "the bot's jiu-jitsu man with no entry sits down".
   The page already offers the player the same button ("Sit down - 1 wind"); nothing changed for a human.
3. The gate script read the verdict's button before the coach's line (probe.mjs; ui.test.mjs already had the order).
Result: `node --test` 63 of 63 (47 before round 9; none deleted: engine 29, ui 18, real 16 new). PLAY GATE 6 of 6:
24.1 decisions a bout (22.5-45), boxing 57.3 / jiu-jitsu 42.8 (40-60), 1,000 bouts clean. engine.mjs 484 lines.
Played through the page in the browser pane as the jiu-jitsu man to a verdict (a careless line: sit every turn, never
cover - lost by knockout with 2 points off for not engaging, as the referee's rule says).
Not done: the owner's own play of round 9; round 9b (the critics' changes).

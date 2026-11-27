# OCTAGON1 - the agents' cup at Octagon Tactics, boxing first (S570)

Owner S570: "fix whaever you think and make a small cup between agents including you and then revweiw and report how
fun it was and how to get better". His design: ops/research/octagon/*.pdf. Rule calls: docs/OCTAGON1_RULES.md. Engine:
proto/octagon/ (engine.mjs, versus_oct.mjs, sim.mjs). Every bout log, every player's reasons and verdict:
ops/research/octagon/cup/. Drive: ops/Tools/versus_by_message.mjs game=octagon.

## The cup (four seats, each card sealed before the other is seen; seat a = Out-Fighter, b = Pressure Boxer)
| bout | result | how |
|---|---|---|
| Semi 1: Gemma (local model) v Maria (Grok) | Gemma 29-28 | decision; round 3 was six passes - both out of stamina or holding no card legal at Long |
| Semi 2: Claude v John (Grok) | Claude, KO round 2 | Pull Counter on his opening hook rocked him; Read Tendency showed his hand; Slip & Cross on his Cross |
| Final: Gemma v Claude (Claude as the Pressure Boxer) | DRAW 28-28 | Claude led 19-18 into round 3, then held a dead hand at Long for four exchanges; Gemma's last jab took the round |
| 3rd place: Maria v John | John 29-28 | decision; John passed four exchanges with a dead hand |

Champions: Gemma and Claude, shared (the final was drawn).

## How fun it was - the players' own scores (1-10)
| player, bout | FUN | DEPTH | CLARITY | VARIETY |
|---|---|---|---|---|
| Claude, semi (won) | 7 | 7 | 6 | 6 |
| John, semi (lost) | 4 | 6 | 7 | 7 |
| Gemma, semi (won) | 8 | 7 | 9 | 7 |
| Maria, semi (lost) | 5 | 6 | 6 | 4 |
| Claude, final (draw) | 6 | 7 | 6 | 6 |
| Gemma, final (draw) | 9 | 8 | 9 | 7 |
| John, 3rd (won) | 5 | 7 | 6 | 6 |
| Maria, 3rd (lost) | 7 | 7 | 6 | 6 |
| **mean** | **6.4** | **6.9** | **6.9** | **6.1** |
(Gemma, the small local model, scores higher than every other seat on every line; without it the means are fun 5.7,
depth 6.7, clarity 6.3.)

What everyone liked: the named counters - a Pull Counter on a hook, Slip & Cross on a cross, Check Hook on a man walking
in - are real boxing reads and they pay; the Lead makes winning an exchange feel like taking over; another agent is more
fun than a script ("she pushed me toward the fence", "Claude reacted to my range shifts"). Rounds 1 and 2 were good card
fights in every bout.

What spoiled it: 3 of 4 bouts had a round of forced passes.

## How to get better - in order (how many verdicts named it)
1. **No dead hands (5 of 8).** At one range a whole hand can be unplayable, and holding 5 cards you draw nothing new.
   Every fighter always gets two free basic moves - STEP IN (one range closer, 1 stamina) and COVER UP (head guard, 0
   stamina) - and may discard one card a turn to draw one.
2. **Stamina comes back a little every exchange (3 bouts ran dry in round 3).** +1 an exchange; the PDFs give none.
3. **A rocked man can always cover up (3 of 8).** Today rocked + no Counter / Defend in hand = a free exchange for the
   other man. Bots: a free Cover Up when rocked cuts KOs 25% -> 9-16%, both styles stay 40-47%.
4. **The Lead +1 speed, not +2 (Claude, John).** With +2 the man who wins one exchange wins every speed race after it
   (the Out-Fighter's Liver Shot beat the Pressure Boxer's Uppercut at Close, 7 v 5). Bots at +1: styles 43-46%.
5. **Show the numbers before the pick (Maria, John, Claude):** each card's final speed with the Lead, range and trait
   bonuses; the round's running damage + counters; a read that is stale (cards drawn since).
6. **The Pressure Boxer needs a way in (John, Claude):** Cut the Cage halves an incoming jab; Pull Counter also at
   Close; the Pressure Boxer +1 speed at Close. (Bots: +1 at Close without the reach tie-break tilts to him 50-55% -
   tune before keeping.)
7. **Count body damage once (Maria):** the Liver Shot's own stamina cut and the every-5-body-damage cut both landed on
   one hit.
8. **Read Tendency shows two of his cards, not his whole hand (Claude):** with the whole hand and range rules I knew
   his options exactly.

## Is it worth going on?
Yes. Rounds 1 and 2 already play as real boxing reads, and the two biggest complaints (dead hands, stamina running dry)
are rules, not the idea. Fixes 1-4 are built as switches in engine.mjs (TUNE: cover, lead; the basic Step In, the
discard and +1 stamina are the next edit). Next: build fixes 1-4 and 7-8 as v2, re-run the cup on v2 (same four seats +
Kalli), then the bars and two critics. If fun reaches 8: the Muay Thai cards, then grappling.

OCTAGON1 DONE

## After the cup: v2 built and measured (bots, 400 bouts a line)
`useV2()` in proto/octagon/engine.mjs (`versus_oct.mjs new ... v2=1`, `sim.mjs v2=1`). Each fix measured alone first:
the always-there Step In + Cover Up swung it to the Pressure Boxer (54-58% v 22-25%: a free walk-in kills the
Out-Fighter's Long game, and a free head guard stops his head-only damage while the Liver Shot goes under it); +1
stamina an exchange did the same (60-62%) and doubled KOs. So v2 is: a rocked man can always Cover Up (it halves);
a hand with no playable card is swapped for a fresh one; discard one card a turn to draw one; the Lead +1 speed; Read
Tendency shows 2 cards; the Liver Shot cuts the stamina cap once; the Pressure Boxer loses his +1 on hooks; health x1.3.
Result: the styles 43-43 / 46-39 (reader bots), 44-41 (random), KOs 11-33%, comebacks 16-23%, draws ~15% - and no dead
hands by construction. Still open: the rerun of the cup on v2 (agents), and the numbers shown before the pick (fix 5).

## Cup v2 (round 1) and cup v3 (round A) - the target is FUN 8 and DEPTH 7 (owner S570: "keep playing until you reach until 8 fun 7 depth")
| version, bout | result | FUN / DEPTH / CLARITY / VARIETY |
|---|---|---|
| v2: Claude v Kalli | Claude KO round 3 | Claude 7/8/8/7, Kalli 7/7/5/6 |
| v2: John v Maria | John KO round 3 | John 6/7/8/6, Maria 6/6/5/5 |
| v3 (his 52-card CSV): Claude v John | Claude KO round 3 (both rocked twice, 18-18 into round 3, a combo through his guard) | Claude 8/8/7/7, John 6/7/6/7 |
| v3: Kalli v Maria | Maria 29-28 (round 3 ran dry: both on 0 stamina, circling) | Kalli 7/7/6/6, Maria 7/7/6/6 |
Means so far - v2: fun 6.5, depth 7.0; v3 (4 verdicts): fun 7.0, depth 7.25. Depth is at target; fun is not.
What moved fun: rounds that swing (both men rocked), round 3 alive, the speed numbers shown, the CSV's Snap Jab and Mid feint.
v3.1 built from John's verdict (a combo after a BLOCKED first card at half; a free Hold Ground every turn; a counter that
answers nothing costs 2) - on bots it tilts to the Pressure Boxer 61-65%: decks to retune before cup round B.
Still missing for fun 8 (round A): round 3 runs dry on stamina (Maria), the guard is the safe answer too often - a repeated guard should cost 1 or a body shot +1 against it (Maria), four cards decide most exchanges (Kalli).
Paused while the owner plays (RAM 95% with his game open): no new bouts, no bot runs.

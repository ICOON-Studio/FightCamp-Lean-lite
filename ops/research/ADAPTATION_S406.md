# One adaptation per round - design v1 (S406)

Operator S405, "Yes, both": the holo's hit numbers are the reason you choose. Between rounds, one choice, picked from the
problem on the holo. Two conditions: it must COST something (no free best pick), and it REPLACES part of the corner minute
instead of adding to it. Nothing is built until he approves this page.

## What was measured (S406, the game's own bouts; Lucy against each of the 3 opponent styles, paper edge -10 / 0 / +10, 40 bouts a cell)
Punches landing on her per round, median, as the holo counts them:

| Opponent style | Head | Body | Hot spot of the round |
|---|---|---|---|
| Pressure fighter | 12-18 | 7 | head 63%, body 37% (body 54% when she is 10 points better) |
| Counter-puncher | 14-21 | 3-4 | head 99% |
| Volume puncher | 14-21 | 3-4 | head 96% |

Three findings change the pitch:
1. **"Pick from the biggest number" is no choice.** The head is the biggest number in 9 rounds of 10. The example of 7 to the liver happens only against pressure fighters.
2. **A head punch costs her nothing in the result today.** Knockdowns come from who won the round and by how much (Knockdowns.gd), not from how many punches reached the head. Body punches do cost: 1.2 energy each for the rest of the fight. So "Elbows in: fewer body shots, more head shots" would be a free best pick, the exact thing the operator ruled out.
3. **Every body punch lands on the same side.** The game has one body punch, the lead hook: against an orthodox opponent the holo's liver counts everything and its ribs read 0. The change below treats the body as one place. A rear-hand body punch is a separate job.

So the choice is not "where was she hit most". It is **what will end this fight first: the head or the tank?** Head punches move her toward a knockdown, body punches empty her. The holo shows both numbers, the energy bar shows the tank.

## The rule
At the corner, one optional change for the next round: **ONE CHANGE**. It lasts one round.

| Change | Offered when (last round) | What it buys | What it costs |
|---|---|---|---|
| **Elbows in** | 4 or more body punches landed | Half of the body punches that would land go to the head instead. Each one moved saves her 1.2 energy. | Each moved punch adds head damage, so a knockdown comes closer |
| **Gloves high** | 10 or more head punches landed | About 15 of every 100 punches move from the head to the body. Each one moved takes head damage off | Each moved punch is a body punch: 1.2 energy for the rest of the fight |
| **The habit fix** (exists today) | The coach has seen one of her habits punished | The habit costs less for a round | It takes the one slot, so the other two are off |
| **Leave it** | Always | Nothing moves: plays exactly as today | - |

What keeps it from being free:
- **Each change is priced in the other thing's currency.** A fresh fighter with a good chin wants Elbows in. A tired fighter must not take Gloves high. A fighter who has been hurt must not take Elbows in. The right pick depends on her energy and how the head is doing, which are on the screen.
- **She takes it in only as far as she listens:** the gain scales with how well she takes instruction and her trust in the corner (today's rule for habit fixes). The price is paid in full. A fighter who has stopped trusting her corner pays for a change she barely makes.
- **Asking for the same change two rounds running holds 70%:** the opponent has seen it.
- **Against a counter-puncher, Elbows in is rarely offered** and saves little: the real problem there is the head. This is intended: different opponents ask different questions.

## On the screen
It takes the place of the FIX ONE HABIT step, in the same spot. Nothing is added. Each button is one line with the two numbers worked out from last round:

    ONE CHANGE (OPTIONAL)
    [ Elbows in   about 3 fewer to the body, saves 4 energy; about 3 more to the head ]
    [ Gloves high about 3 fewer to the head; about 3 more to the body, costs 4 energy ]
    [ Fix: drops her right after the jab ]    [ Leave it ]

- The coach's pick carries a small mark: tired (under 40 energy) -> Elbows in; head damage high -> Gloves high; a habit that cost her twice or more -> the fix. Never pre-selected.
- The next corner card reports what it did, as the habit fix does today: "Elbows in held: 3 fewer to the body, 3 more to the head. She took it in 80%."
- Holo: moved punches show up by themselves, because the ring lands the body punches the exchange counted.
- **To make room (S405 critics: "the corner is crowded", "five small headings with no priority"):** Set-up and Talk fold behind one "More" line, keeping the coach's default. The corner then reads: the second's points, ONE CHANGE, the plan. Three decisions, which is what a corner gets across in a minute (J68: 2-3 instructions, more is not credible).

## Numbers (proposals, tuned before they ship)
Head damage per moved punch 2.0 (Knockdowns: a clearly lost round adds 18, so three moved punches are a third of that). Elbows in: body share x 0.5. Gloves high: body share + 0.15 (today 0.20, or 0.35 against a body puncher).

**Bars, on the balance harness** (tools/exchange_balance.gd, a new policy per change, all three opponent styles, edges -10 to +10, 400 bouts a cell):
1. No change taken every round wins more than 2 points above Leave it, in any opponent style.
2. A corner reading her energy and head beats the best always-the-same change by at least 2 points.
3. Each change is the best answer in at least one opponent style and state.
4. Leave it plays byte-identical to today (golden_path, save_load unchanged).
5. Knockdowns per bout stay within 15% of today when the coach's mark is followed.

## How it fits the rest
- No new dice: the same roll decides how many body punches land, only the share moves, so a bout with no change plays exactly as today.
- It lives in the round's own record, so it ends at the bell by itself. "Sim the round" reads the same numbers as a watched round.
- Plan call ("Hands up, move your head" and the rest): the whole round's game. ONE CHANGE: how she carries her guard inside that game. Pace (Push / Save) stays the shout bar's.
- Later, "the opponent adapts" (R25, after the fighter model): her note names which line stopped working, and this slot is where you answer.
- Boxing only. The live screens can use it the day it lands. MENUFIGHT1 is re-briefed with ONE CHANGE in the corner's fix row.

## Not in this version
A rear-hand body punch and left/right sides on the body. Eyes and cuts (the cutman owns them, pro corners only). An offer by punch type. Any change to Pace or to the plan calls.

## Files when built
scripts/rules/Adaptation.gd (new, pure, tests); scripts/state/LiveRound.gd one call at the body split and one at damage; scripts/state/BoutNight.gd the `adapt=` part; scripts/ui/CallButtons.gd + scripts/fight3d/CornerOverlay.gd the row and the fold; scripts/fight3d/FightCast.gd the card's offers; tests/adaptation_test.gd; tools/exchange_balance.gd the policies.

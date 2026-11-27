# KICKFIX5 - finish the kicks balance: stopped at the PC's memory gate before F4 could run (S569 console worker)

2026-11-27 - PC console worker (Fable 5.2, main checkout) - kickboxing - no page, tool or test changed.

Claude Code stopped the run chain at about 12:16 because the PC was critically low on memory (RAM 93-98%, ArcheAge open
at 6-8 GB). The chain was waiting at the watchdog gate at that moment (RED twice in a row), so no run was cut in half. The
harness says not to start a run again that it stopped for memory, so F4 has not been measured. I stopped the chain's
leftover waiter (my own process, by PID) so nothing starts by itself when memory frees up.

| version | N | seed | bars passed | each red bar with its number | low kick lands | overhand lands | knockdowns | stoppages | plan mix (hands only / kick counted) | strikes a beat | limp bouts, stops after a limp |
|---|---:|---:|---|---|---|---|---|---|---|---|---|
| Boxing page control (today's order.html, its own table) | 56 | 1 | 8/9 | landing: jab 66%, body jab 65% (over by rounding), overhand 71%, rear uppercut short 41% | - | 71% | 2.3 | 14% | two 19%, none 13% (PASS) | 1.01 | 0/56, 0/8 |
| Boxing page control | 56 | 2 | not run | stopped at the gate | | | | | | | |
| F3 (KICKFIX4, the base to beat) | 56 | 1 | 5/9 | dead push off 3%, rear uppercut 3%, clinch 2%; jab 67%, body jab 78%, low kick 87%, head kick 30%; KD 2.9; two 10%, none 30% | 87% | 61% | 2.9 | 32% | two 10%, none 30% / two+ 25%, none 9% | 1.17 | 11/56, 5/18 |
| F3 | 56 | 2 | 5/9 | dead rear uppercut 3%, clinch 2%; jab 69%, body jab 73%, overhand 72%, low kick 77%; stops 50%, KD 3.1; two 9%, none 30% | 77% | 72% | 3.1 | 50% | two 9%, none 30% / two+ 26%, none 9% | 1.18 | 7/56, 2/28 |
| F4 = F3 + a teep covers the lead leg in its moment | - | - | written, not run | ops/research/s558_balance/kick_fix_f4.json loads on kick.html (checked); table, N=12 and N=56 still to do | | | | | | | |

## What the control already says
On seed 1 the boxing page is red on ONE bar only (landing). So for a kicks version to count as finished on seed 1 it may be
red on landing only: the dead-switch bar (clinch 2%, rear uppercut 3% on every kicks version so far) and the plan-mix bar
(two 10%, none 30% by the hands-only count) are NOT red on the boxing page and must come up too. The plan-mix bar passes
when a kick counts as a strike (two or more 25%, none 9%); the hands-only count cannot pass on a page where four of ten
beats are a kick, so I would judge that bar with kicks counted and say so beside each number. The dead-switch bar needs a
real fix (the clinch and the rear uppercut are thrown in under 3% of beats).

## Why F4 will probably not be enough, and what F5 should be (not run)
The low kick lands 77-87% because the kicker only throws it when it is nearly sure to land: a checked kick costs him 2
health and gives the other man a counter, a landed one takes 1. A harsher check makes him pickier, not less accurate (F1:
87% -> 86% / 84%). A teep is 5-7% of beats and covers one moment, so F4 moves this little.
F5 (one line of why: a low kick at a man who is backing off falls short - it misses, nobody's shin is hurt): Back off
makes the low kick MISS instead of being checked, only Hold your ground checks it, and checkHurt goes back to 1. A cheap
miss makes the kick worth throwing on a guess, so it is thrown more and lands less. Watch the limp numbers: more low
kicks thrown is the limp loop's input.

## Feedback loops
- Limp, too passive, stamina: nothing new measured (F4 not run). Control: 0 limp bouts, 1.01 strikes a fighter-beat (boxing), stamina bar 5.76 at the last bell.

## To resume (needs memory: the chain uses one job while ArcheAge is open, an F4 table is then about 3 hours)
`bash E:/FightCamp/wt_tmp/KICKFIX5/run.sh c1 control:2 table:f4 play:f4:12:1 > E:/FightCamp/wt_tmp/KICKFIX5/c1.log 2>&1`
then `play:f4:56:1 play:f4:56:2` if the trial gate passes. The chain waits on RED by itself and commits each result.

## For the owner
Nothing went on kick.html today: the PC ran out of memory while ArcheAge was open and the measuring was stopped before the first kicks version could run.
The boxing page was measured as the yardstick (8 of 9 bars on seed 1), and the next kicks version (F4) is written and ready to run.
The player feels no change yet; the kicks need about two hours of free PC (game closed) per version, or about five with the game open.

KICKFIX5 BLOCKED: Claude Code stopped the run chain for low memory (RAM 93-98%, ArcheAge open) before the F4 table started; only the boxing control on seed 1 finished. It is not restarted until someone says so.

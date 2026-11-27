# KICKFIX5 - finish the kicks balance: stopped twice for low memory, F4 still not measured (S569 console worker)

2026-11-27 - PC console worker (Fable 5.2, main checkout) - kickboxing - no page, tool or test changed.

Claude Code stopped the run chain at about 12:16 because the PC was critically low on memory (RAM 93-98%, ArcheAge open
at 6-8 GB). The chain was waiting at the watchdog gate at that moment (RED twice in a row), so no run was cut in half. The
harness says not to start a run again that it stopped for memory, so F4 has not been measured. I stopped the chain's
leftover waiter (my own process, by PID) so nothing starts by itself when memory frees up.

| version | N | seed | bars passed | each red bar with its number | low kick lands | overhand lands | knockdowns | stoppages | plan mix (hands only / kick counted) | strikes a beat | limp bouts, stops after a limp |
|---|---:|---:|---|---|---|---|---|---|---|---|---|
| Boxing page control (today's order.html, its own table) | 56 | 1 | 8/9 | landing: jab 66%, body jab 65% (over by rounding), overhand 71%, rear uppercut short 41% | - | 71% | 2.3 | 14% | two 19%, none 13% (PASS) | 1.01 | 0/56, 0/8 |
| Boxing page control | 56 | 2 | 8/9 | landing: jab 68%, overhand 70% | - | 70% | 2.2 | 21% | two 20%, none 13% (PASS) | 1.01 | 0/57, 0/12 |
| F3 (KICKFIX4, the base to beat) | 56 | 1 | 5/9 | dead push off 3%, rear uppercut 3%, clinch 2%; jab 67%, body jab 78%, low kick 87%, head kick 30%; KD 2.9; two 10%, none 30% | 87% | 61% | 2.9 | 32% | two 10%, none 30% / two+ 25%, none 9% | 1.17 | 11/56, 5/18 |
| F3 | 56 | 2 | 5/9 | dead rear uppercut 3%, clinch 2%; jab 69%, body jab 73%, overhand 72%, low kick 77%; stops 50%, KD 3.1; two 9%, none 30% | 77% | 72% | 3.1 | 50% | two 9%, none 30% / two+ 26%, none 9% | 1.18 | 7/56, 2/28 |
| F4 = F3 + a teep covers the lead leg in its moment | - | - | written, not measured | ops/research/s558_balance/kick_fix_f4.json loads on kick.html (checked); its table ran 30 minutes (2 of its beat rows) and was stopped; table, N=12 and N=56 still to do | | | | | | | |

## Second start, 13:23 to 13:57 (the owner closed his game at 13:20 and asked for the restart)
The chain started with RAM at 60% and three jobs. The boxing control on seed 2 finished in 4 minutes (8 of 9, row above,
committed and pushed). The F4 table started at 13:27. At about 13:56 Claude Code stopped the chain again for critically
low memory: RAM 90%, CPU 100%, with Chrome at 7.2 GB, the Claude consoles at 6.6 GB, a 1.4 GB Godot render (RECOIL1) and
two COUNTERS2 measuring chains running beside it. The F4 table itself held 318 MB. Its processes had outlived the stop,
so I ended them myself by PID (two bash, one node, all mine) to honour it: nothing of KICKFIX5 runs now and nothing starts
by itself. The half-built table is not kept (balance.mjs writes it only at the end).

Both seeds now agree: the boxing page is red on the landing bar ONLY (jab and overhand on both seeds; body jab and the
rear uppercut falling short on seed 1). So a finished kicks version may be red on landing only, on both seeds.

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

## To resume (needs memory; three measuring workers and a render at once is more than the PC holds beside Chrome)
`bash E:/FightCamp/wt_tmp/KICKFIX5/run.sh c3 table:f4 play:f4:12:1 > E:/FightCamp/wt_tmp/KICKFIX5/c3.log 2>&1`
then `play:f4:56:1 play:f4:56:2` if the trial gate passes. The chain waits on RED by itself and commits each result.

## For the owner
Nothing went on kick.html yet: the measuring was stopped for low memory a second time, 30 minutes into the first kicks version (F4), with two other measuring workers, a render and Chrome running beside it.
The yardstick is complete: the boxing page passes 8 of 9 bars on both seeds, so a kicks version has to match that.
The player feels no change yet; the kicks need about two hours a version with the PC to themselves - run KICKFIX5 alone, or after COUNTERS2 and RECOIL1 finish.

KICKFIX5 BLOCKED: Claude Code stopped the run chain for low memory a second time (13:56, RAM 90%, CPU 100%) during the F4 table; both boxing controls are done (8/9, 8/9), F4 is written and unmeasured. It is not restarted until someone says so.

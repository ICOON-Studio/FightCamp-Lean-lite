# KICKFIX4 - E3 plus the three fixes KICKFIX3 named (S566 console worker, stopped part way)

2026-11-26 - PC console worker (Arena at its daily limit) - kickboxing - no page, tool or test changed.

The run chain was stopped by Claude Code for low memory at about 22:30 (ArcheAge open, RAM 89%). The F3 table it had
started went on as an orphan; I stopped it (my own process, by PID) because the owner was playing. The harness says not to
restart a run it stopped for memory on my own, so the N=56 runs are not done. What finished:

| version | N | seed | bars passed | each red bar with its number | low kick lands | overhand lands | knockdowns | stoppages | plan mix (hands only / kick counted) | strikes a beat | limp bouts, stops after a limp | stamina bar at last bell |
|---|---:|---:|---|---|---|---|---|---|---|---|---|---|
| E3 (KICKFIX3, base) | 56 | 1 | 5/9 | dead clinch 2%; body jab 67%, overhand 73%, low kick 87%; stops 50%, KD 3.1; two 8% | 87% | 73% | 3.1 | 50% | two 8%, none 30% / not counted | not counted (no E3 table on the PC) | 10/56, 3/28 | 6.12 |
| **F1** checkHurt 2 | 12 | 1 | 5/9 | dead feint 3%, push off 2%, overhand 3%, rear uppercut 1%, clinch 1%; jab 75%, body jab 74%, low kick 81%; stops 42%, KD 2.7; two 10%, none 30% | 81% | 60% | 2.7 | 42% | two 10%, none 30% / two+ 28%, none 7% (PASS both ways) | 1.23 | 0/12, 0/5 | 5.71 |
| F2 low kick keeps the rear hand | 12 | 1 | 5/9 | dead overhand 3%, rear uppercut 2%, clinch 2%; jab 76%, body jab 77%, lead uppercut 81%, overhand 42% (short 50%), low kick 91%; stops 50%, KD 3.5; two 9%, none 32% | **91%** | 42% | 3.5 | 50% | two 9%, none 32% / two+ 25%, none 8% (PASS both ways) | 1.19 | 5/12, 2/6 | 5.29 |
| F3 both | - | - | not run | table stopped at beat 2 of 6 | | | | | | | | |
| F4 | - | - | not run | only if F3 keeps the low kick over 65% | | | | | | | | |

Trial gate (N=12: no switch over 40%, no kick over 90%, under half of stoppages after a limp): **F1 survives** (top switch
Cross 28%, low kick 81%, 0 of 5). **F2 fails**: the low kick lands 91%. With the rear hand kept up, the overhand counter on a
low kick is gone (overhand 73% -> 42%), so the kick is cheaper and is thrown and lands more (15-16% of beats, limps in 5 of 12 bouts).

What F1 does at N=12: knockdowns 3.1 -> 2.7 and stoppages 50% -> 42%, both just over the bar; the overhand drops under 65%;
the low kick is 81% (still over 65%). Counting a kick as a strike, the plan-mix bar passes (two or more 28%, none 7%). By
balance.mjs's hand-only count it stays red (two 10%). The new red is the jab and body jab landing 74-75%.

## Feedback loops
- Limp: F1 0 limp bouts in 12; F2 5 in 12 (2 of 6 stoppages), so the reflex check of E3 alone no longer caps it once the low kick is free.
- Too passive: strikes a beat F1 1.23, F2 1.19. E3's volume was not counted (KICKFIX3 did not report it, and E3's table is
  not on the PC), so the 80% test against E3 is open. Next run: build kick_fix_e3.vt.json and count it with kf_play.mjs.
- Stamina: bar at the last bell 5.71 (F1), 5.29 (F2), never at capMin 4.

## To resume (all in E:\FightCamp\wt_tmp\KICKFIX4: run.sh, kf_play.mjs; F1 and F2 tables are there)
1. `bash run.sh table f3` then `bash run.sh play f3 12 1` (jobs 1 while ArcheAge is open; about 70 min a table at jobs 3).
2. `bash run.sh play f1 56 1`, `bash run.sh play f1 56 2`; the same for F3 if it survives.
3. For the volume bar: `bash run.sh table e3` and `bash run.sh play e3 56 1`.

## Which version for kick.html (provisional, N=12 only)
F1 is the likely one: a checked low kick costs the kicker 2 health, like shin on shin.
For the player: kicking low into a man who holds his ground or backs off now hurts you twice as much, so the low kick waits for him to step in.
Do not take F2 alone: a low kick with the guard kept up becomes free and the limp comes back.

Regression: kick_test.mjs and page_parse not re-run, because no page, tool or test was touched (tweak files only).

KICKFIX4 BLOCKED: Claude Code stopped the run chain for low memory while the owner played ArcheAge. F1 and F2 N=12 are done (F1 survives, F2 fails at low kick 91%); F3 and every N=56 run are still to do (steps above).

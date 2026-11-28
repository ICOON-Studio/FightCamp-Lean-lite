# KICKFIX6 - the kicks on the rebuilt kick.html: control and F6 measured (S570 worker, resumed S571)

2026-11-27 - PC console worker (Opus 5.5, main checkout) - kickboxing (Puncher's chance, kick.html) - no page, tool or test changed.

## What ran
19:49: two run chains started at one job each (two jobs in all, beside BUILD1 and RULES569). The watchdog read AMBER, RAM 84%,
no llama-server.
- chain A: the kicks control (kick_base.json = the rebuilt kick.html, no tweak): its own table, then N=56 on seeds 1 and 2;
- chain B: F6 (kick_fix_f6.json, unchanged from KICKFIX5): its own table, then the N=12 trial gate.
Both tweaks were checked to load on the rebuilt page first (control health 18 and low kick speed 2; F6 health 22 and low kick speed 3).
At about 20:50, an hour into the two tables (each needs about 3.5 hours at one job), Claude Code stopped both chains because
the PC was critically low on memory. At 20:51 the watchdog read RED: RAM 93%, ArcheAge Chronicles 7.3 GB (the owner is
playing), CPU 70%. The chain processes had outlived the stop, so I ended them myself by PID (four bash and two node, all
mine). Nothing of KICKFIX6 is running now and nothing will start by itself. balance.mjs writes a table only when it is done,
so the two half-built tables were lost.

| version | N | seed | bars passed | low kick lands | knockdowns a bout | stoppages | limp bouts (stops, to the bell) |
|---|---:|---:|---|---|---|---|---|
| control (rebuilt kick.html, own table) | 56 | 1 | 4 of 9 | 88% | 4.2 | 96% | 34/56 (20, 1) |
| control | 56 | 2 | 5 of 9 | 89% | 4.4 | 98% | 31/56 (23, 0) |
| F6 = F5 + low kick speed 3 + head kick 3 stamina + health 22 | 12 | 1 | 4 of 9 | 90% | 2.7 | 50% | 8/12 (4, 4) |

RESUMED (S571 session, 27-28 Nov, both chains in the background beside ArcheAge; they waited on RED by themselves):
chain B ended 03:03, chain A 05:08. Results: ops/research/s558_balance/results/kickfix6_control_n56_s1.txt, _s2.txt,
kickfix6_f6_n12_s1.txt.

## What the numbers say
- The control is broken the way KICKFIX5 said: almost every bout is stopped (96-98%, 4.3 knockdowns), a kick lands about
  9 times in 10 (low 88%, head 91%), and 56-61% of beats throw nothing. Five dead switches (clinch 2%, teep 2%, overhand 2%).
- F6 halves the stoppages (50%) and the knockdowns (2.7), the men throw more (no strike 30%, two strikes 33%), the cross
  and the body kick become real weapons (44% and 56% landed), and 4 of 8 limp bouts reach the bell.
- F6 does NOT fix the low kick (still lands 90%), kills the head kick (2% of beats: 3 stamina is too dear) and makes the
  feet go first 62% of ordered beats (the order bar fails). Stoppages 50% and knockdowns 2.7 are still above the bars
  (10-40%, 0.5-2.5).

## Decision
F6 does not pass its trial: same bars passed as the control (4 of 9), two new failures. It goes in as the base for F7, not
on the page. F7 (ops/research/TASK_KICKFIX7.md): find why F6's leg cover (feet hold / back off / a feet teep, which
replaced the Check switch) still lets 90% of low kicks land, and fix it to 50-65%; head kick back to 2 stamina; KICKFIX5's
clinch smothers kicks. Nothing on kick.html yet. The N=56 run of F6 is not needed.

## Feedback loops
The limp loop (more low kicks thrown, more limps, no back off, more low kicks) was not measured: no run finished.

## To resume (needs the PC without ArcheAge or the local model: about 4.5 hours at two jobs, 3.5 hours at three)
```
bash E:/FightCamp/wt_tmp/KICKFIX6/run.sh cA 1 table:control play:control:56:1 play:control:56:2 > E:/FightCamp/wt_tmp/KICKFIX6/cA.log 2>&1
bash E:/FightCamp/wt_tmp/KICKFIX6/run.sh cB 1 table:f6 play:f6:12:1 > E:/FightCamp/wt_tmp/KICKFIX6/cB.log 2>&1
```
(or one chain at jobs 2 or 3 when alone). Before each step the chain waits while the watchdog is RED, RAM is 88% or more, or
llama-server holds more than 4 GB. It commits each result to ops/research/s558_balance/results/kickfix6_*.txt. If the F6 trial
passes, run `play:f6:56:1 play:f6:56:2`.

## For the owner
Nothing changed on kick.html. The test version halves the knockouts but low kicks still land 9 times in 10, so it is not good enough yet.
The next version makes a man who stands his ground or backs off stop the low kick, and makes the head kick cheaper again.
You feel no change until that version passes.

KICKFIX6 DONE: F6 trial fails (4 of 9 bars like the control; stoppages 96% -> 50% but the low kick still lands 90%, the head kick dies); next F7 = F6 + a leg cover that works + head kick 2 stamina + clinch smothers kicks (TASK_KICKFIX7.md)

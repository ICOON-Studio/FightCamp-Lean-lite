# KICKFIX6 - the kicks on the rebuilt kick.html: stopped for low memory before any number (S570 console worker)

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

| version | N | seed | bars passed | low kick lands | knockdowns | stoppages | limp bouts, stops after a limp |
|---|---:|---:|---|---|---|---|---|
| control (rebuilt kick.html, own table) | 56 | 1, 2 | not measured: table stopped at about 1 of 3.5 hours | | | | |
| F6 = F5 + low kick speed 3 + head kick 3 stamina + health 22 | 12 | 1 | not measured: table stopped at about 1 of 3.5 hours | | | | |

## Decision
The harness says not to restart a run it stopped for memory, and the owner is playing, so I am not restarting anything.
F7 and F8 are not written: each must follow what the control and F6 show, and neither has a number yet. KICKFIX5's
candidate for F7 still stands: a clinch smothers kicks (the clinch was dead at 2% of beats on every kicks version).

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
Nothing went on kick.html: the kicks measuring was stopped for low memory an hour in, while your game was running, before any number came out.
The player feels no change yet.
It needs about 4.5 hours with the PC free of the game and the local model. The commands to restart it are above.

KICKFIX6 BLOCKED: stopped for low memory at about 20:50 (RAM 93%, ArcheAge 7.3 GB, watchdog RED) about an hour into the control and F6 tables, before any number; my leftover processes are ended, nothing runs or restarts by itself; resume commands above

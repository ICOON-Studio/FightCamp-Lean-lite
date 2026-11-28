## METHOD (S569, fight pictures; S570 update; S571: LAYERS1 brief ready, waits on his look): two men baked per picture + the page sliding the whole picture makes every clip that ends a few px off a jump. LAYERS (one man per picture, the page owns each spot) is APPROVED (S570: he bought Cascadeur Indie + the Animo pack) and phase 0 is DONE (holds + jab, 0 jumps, docs/LAYERS0_RESULT.md, ?layers=1). No new patch layer on the two-man pictures; the next fight-picture work is LAYERS phase 1.
## METHOD (S572, Octagon; S573 + S574 update): S574 owner: 'focus on balance first then fun and depth' - every rule change: a TUNE switch OFF, pool_sim n=200 x seeds 7/11/13 (40-60%), ON only between cup rounds; then a BALANCE rating from all four seats before fun/depth. v6.9 (ours) and LITE (`lite=1`, his v2.7 + the fewest fixes) are both kept. the owner's own rules are the line. v5.4 (his v2.0 rulebook, `v5=1`) and v6.3 (his v2.7 Director's Cut + the cup's fixes, proto/octagon/cards_v6.mjs, `v6=1`; `pure=1` = v2.7 as written) are both kept; the cup now plays v6 (owner S573 sent v2.7 and asked to fix what it misses from the 7/8 version). No league / campaign / relic / boss work before the fights are balanced. Every rule change: a TUNE switch OFF, pool_sim n=40 (40-60%), ON only between cup rounds.

# S575 handover (written 2026-11-28, S574 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S574_DIGEST.md` and
`docs/OCTAGON_V6_RESULT.md` (section "S574").

## S575: DO THESE FIRST
(after this page was first written, S574 also ran cup r21: v6.9 Kalli v John 7.0/6.5 - r20's 8/8 did not hold; LITE Claude v Maria 7.0/7.0 - up from 6.5/5.5; comboHalf, cutOnce (v6.9), circleFeint now ON. Start with cup r22 on BOTH; the open asks are in docs/OCTAGON_V6_RESULT.md "Cup round 21".)
0. FIRST (owner S574: "focus on balance first then fun and depth also try my version too"): LITE (his v2.7 + the fewest
   fixes, `v6=1 lite=1`) to fun 8 / depth 8 like v6.9. Cup r21 on LITE (the Range Jab repeat tax is ON since r20 - not yet
   played). Open asks (r20): the man ahead guards out the last two exchanges (John, Maria); the cut shows a card EVERY
   exchange - once a round (John); Cut the Cage loses to the cheapest paw (John); the step-in jab should show itself (Maria).
   Each: a TUNE switch OFF, pool_sim, ON between rounds; bots now v6.9 44-55%, LITE 46-57%.
1. v6.9 cup r21 with the other two seats (r20 fun 8 / depth 8 was Claude + John only). Pairings: Kalli v John, Claude v
   Maria. `node ops/Tools/versus_by_message.mjs E:/FightCamp/tmp/octcup4/r21_<a>_v_<b> a=<seat>:<via> b=<seat>:grok
   game=octagon v6=1 [lite=1] pa=<id> pb=<id> seed=21x`; Claude plays with a scratchpad o21.sh (copy of
   oct6.sh: plan / exit 3 = tell / show) and writes <dir>/VERSUS_CLAUDE.md. A balance ask goes by
   `node ops/Tools/grokbot_direct.mjs send <seat> <file>`, collected by E:/FightCamp/tmp/octcup4/balance_ask/wait.py <dir>.
2. COLLECT: LAYERS1 (worker, rendering on 28 Nov 03:00; family b committed 61da431ec), RULES569 (chain_p2), TYPES1
   (docs/TYPES1_RESULT.md), KICKFIX6 (chains).
3. His card art idea (S574: "gritty graphic-novel ink illustrations with bold rim lighting matching card color"; his UI kit:
   ops/research/octagon/v27_uikit/) once he says the fights are balanced. BUILD1 round 4, MMCPLAY1, LONG3 when a seat frees.

## Rules learned in S574 (also in memory)
- Balance first means: rate BALANCE from every seat, not fun/depth, until he says otherwise.
- His files are the line: check his card text before saying a rule is his (the Stance Guard repeat cost was ours).
- Bots cannot see stalling or feint-farming: those fixes are measured by the agents; the bots only show they break nothing.

# S574 handover (written 2026-11-28, S573 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S573_DIGEST.md` and
`docs/OCTAGON_V6_RESULT.md`.

## S574: DO THESE FIRST
0. FIRST (owner S573: "Next session"): measure the three balance fixes from the v6.6 balance rating (all four seats 6/10,
   Out-Fighter 4 from all four; docs/OCTAGON_V6_RESULT.md): John - 2+ speed faster stops the slower punch outright; Kalli - a
   neutral reset costs the man ahead on the live score 1 stamina; Maria - a Step-In Jab catching a fake lands the damage OR
   closes the range, not both + Lead. Each a TUNE switch OFF, pool_sim n=40, then ON the ones that lift the out-fighters
   (Metronome 43%, Long Night 35%) without breaking 40-60%, then ask all four for a balance rating again.
1. OCTAGON CUP ROUND 18 on v6.6 (statuses + live score; fun 8 is the target; v6 best r15 7.5, r17 v6.5 7.25). The v6 cup has its own
   table from r14 (Kalli 10, Claude 10, Maria 5, John 0) - the owner asked for it. Pairings next: Claude v Kalli, John v Maria. `node ops/Tools/versus_by_message.mjs
   E:/FightCamp/tmp/octcup4/r17_<a>_v_<b> a=<seat>:<via> b=<seat>:grok game=octagon v6=1 pa=<id> pb=<id> seed=17x`; Claude plays
   with a scratchpad oct6.sh (plan; exit 3 = WAIT for your tell - `show` until "TELL: his card", then choose). 
2. Open asks after r17: a widening cut should score (John); the Step-In Jab off a fake pays too much (Maria x3); a
   counter-puncher needs a way out of Close (Maria); tell the cut man which card his cut showed (Claude); a cutman card
   between rounds (Claude). Measured and left OFF (bots 37-61%): heavyTrade (a heavy punch trades through a faster straight - John r15, Claude r16; Maria
   r16 wants the opposite: the fast jab should keep the slow puncher off) and stanceTax=2. Open asks: Pull Counter 5 -> 4
   (Kalli r13 + r15, Maria r16: one counter decides a round; the 6 = his 5 + the +1 reflex bonus), a rocked man gives something
   up (Maria r15, Claude r16), a live round score (Kalli r12, r13, r15), the always-there cards still half of all plays (r16).
3. COLLECT: LAYERS1 (worker tab of S572; paused itself for his ArcheAge at 01:30 on 28 Nov), RULES569 (chain_p2); KICKFIX6 COLLECTED by S571 on 28 Nov (docs/KICKFIX6_RESULT.md: F6 trial fails, 4 of 9 bars; F7 = F6 + low kick check + head kick 2 stamina + clinch smothers kicks, brief ops/research/TASK_KICKFIX7.md, launch when the PC is free of ArcheAge).
4. BUILD1 round 4, MMCPLAY1, LONG3 when a seat frees.

## Rules learned in S573 (also in memory)
- A bot pool cannot see a safe card being overplayed (the Stance Guard was played 9 of 18 by two agents; the bots never did):
  a free always-there card needs a cost from the start.
- Check an always-there (virtual) card everywhere the hand is checked: legality, combos, discard (two bugs this session).
- The tell's log line is read by BOTH men: name who sees whose colour.

# S573 handover (written 2026-11-28, S572 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S572_DIGEST.md`.

## S573: DO THESE FIRST
1. OCTAGON CUP ROUND 13 on v5.3 (ON in cards_v5.mjs): `node ops/Tools/versus_by_message.mjs E:/FightCamp/tmp/octcup4/r13_<a>_v_<b>
   a=<seat>:<via> b=<seat>:grok game=octagon v5=1 pa=<id> pb=<id> seed=13x` (Claude a=claude:worker, plays with a scratchpad
   oct.sh: seal with `versus_oct.mjs plan <bout> who=a card=..`, wait until `n` changes, `show`). Means: r10 7.25/7.0,
   r11 7.75/7.25 (best), r12 7.5/7.0 - FUN 8 is the target. Open asks: two Close attacks per deck (Pressure and Out-Fighter
   ran dry at Close), guard v guard should cost something (Kalli), Pull Counter too strong an opener (John).
2. v6 = his v2.6 fight rules + his v2.6 boxing cards (BOX-01..12, FIQ-01..04, SYS-01 Signature Stance Guard - always
   available; Desperation Surge; non-stacking speed cap) as proto/octagon/cards_v6.mjs + `v6=1`, never touching v5. Watch:
   Shoulder Twitch Feint and Low-Kick Fake cost 0 and beat Counter AND Defend; Initiative +2 (on v5 the bots put
   Pressure at 57-64% with +2). Bots first, then one cup round on v6 beside v5.3.
3. COLLECT: LAYERS1 (tab c1 of S572; cross family passed, docs/LAYERS1_RESULT.md), RULES569 (tab c1 of S571, no result page
   yet), KICKFIX6 (two balance chains since 22:43, tables building; results in ops/research/s558_balance/results/kickfix6_*.txt).
4. Board: Q-S294-348 (C: drive 8 GB: AMD usage log + Ollama installers - his files, never delete without his yes);
   Q-S294-349 (v2.6 career layer: answered in chat "leave the league design after we balance the fights" - close it);
   Q-S294-350 (which v2.6 list: his synchronized files agree - close it).
5. BUILD1 round 4, MMCPLAY1, LONG3 when a seat frees.

## Rules learned in S572 (also in memory)
- His Chrome: never open tabs in his window; if Chrome is needed, a NEW window for Claude's tabs.
- Bots never hold twice (holdTax read 0 change) and finish 10% where agents finish ~50%: some rules only the cup can show.
- A say(v, ...) line prints the defender's name first - check log grammar after every new rule line.
- Check his design files card by card against each other before building (v2.6 came in three rounds: real names, blank
  card pages, CSV and PDF with different cards, then a synchronized pair).


# S572 handover (written 2026-11-27, S571 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S571_DIGEST.md`.

## S572: DO THESE FIRST
1. OCTAGON CUP ROUND 7 on v4.6 (ON in fighters_v4.mjs; never played): Claude (silk) v Maria (snapshot), John (truck) v
   Kalli (longnight). `node ops/Tools/versus_by_message.mjs E:/FightCamp/tmp/octcup4/r7_<a>_v_<b> a=<seat>:<via>
   b=<seat>:grok game=octagon v4=1 pa=<id> pb=<id> seed=7x` (run_in_background); Claude plays with a scratchpad
   oct.sh (seal = `versus_oct.mjs plan <bout> who=a card=..`, wait until `n` changes, then `show`) and writes
   <dir>/VERSUS_CLAUDE.md (format: ops/research/octagon/cup4/r6_claude_v_kalli). Means so far: v4.5 r6 fun 7.0 depth
   7.0 (depth AT target). FUN needs 8. Every change: a TUNE flag OFF, pool_sim n=40 (keep 40-60%), then ON between
   rounds - never mid-bout (the engine is re-read every exchange). Next asks in S571_DIGEST "Not done".
2. COLLECT: RULES569 (tab c1, docs/RULES569_RESULT.md), TYPES1 (tab c2, docs/TYPES1_RESULT.md), KICKFIX6 (its two
   chains ran as background bash of S571 - if gone, resume from docs/KICKFIX6_RESULT.md commands; results in
   ops/research/s558_balance/results/kickfix6_*.txt).
3. LAYERS phase 1 APPROVED (owner S571: "Yes, do all moves"): launch ops/research/TASK_LAYERS1.md as a console worker
   FIRST THING if ArcheAge is closed (renders need the PC without the game; it was open at the end of S571, RAM 90%).
4. BUILD1 round 4 (a hurt part must actually take cards in the probe) when a seat frees; MMCPLAY1, LONG3.

## Rules learned in S571 (also in memory)
- Agents finish far more bouts than the bots (87% v 48%): a bot finish band is no target for agent fun; watch bout length in the cup.
- The cup's v4 help printed no v2/v3 rules until S571 - check `versus_oct.mjs help v4=1` after every rule change.
- A display that leaves out a bonus the rules use (NOW speed) reads as unfairness to players - one function for both.

# S571 handover (written 2026-11-27, S570 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S570_DIGEST.md`.

## S571: DO THESE FIRST
1. OCTAGON (the owner's own design; his target "keep playing until you reach until 8 fun 7 depth"): FIX THE STAMINA LOCK
   first (proto/octagon/engine.mjs) - the dead-hand swap must count cards unplayable by RANGE only (not stamina), a swap
   pays no reshuffle penalty, a man under 3 stamina gets +1 for an exchange he does not attack. Bots (`node
   proto/octagon/pool_sim.mjs n=40`) keep the pool inside 40-60%. Then finish the v4 middleweight cup (drafted:
   ops/research/octagon/cup4/draft.log): rounds 2-3 = Claude (Iron) v John (Ghost) + Kalli (Body Shop) v Maria (Snapshot);
   Claude v Kalli + John v Maria. `node ops/Tools/versus_by_message.mjs <dir> a=claude:worker b=<seat>:grok game=octagon
   v4=1 pa=<fighter> pb=<fighter>`; Claude plays with scratchpad oct.sh-style seal / wait / show. Report the means
   against FUN 8 / DEPTH 7 (v3 was 7.0 / 7.25). The counter that answers nothing costs 2 STAYS (owner: "this stays of
   course its very good even better i think than what mmc does").
2. WORKERS: KICKFIX6 and RULES569 were STOPPED at the end of S570 to free memory (owner: "Yes, free it" while he played):
   relaunch both from ops/research/TASK_KICKFIX6.md and TASK_RULES569.md (their committed results show where they were).
   BUILD1 (tab c1) was on its round-3 probe - collect it.
3. LAYERS phase 1 (docs/LAYERS0_RESULT.md): every family re-rendered with `layers=1` masks, one render at a time, to a
   seat; his look at http://127.0.0.1:8797/order.html?layers=1 first.
4. Queue: TYPES1 (his four card types inside Puncher's chance), MMCPLAY1, LONG3 (Arena, Browser 2).

## Rules learned in S570 (also in memory)
- When he plays (ArcheAge 7 GB): one worker; ask before closing or pausing - he said "you have my permission" in S570
  for that one time; the safety check refuses Stop-Process / suspend without it.
- A cup's Gemma seat loads 9 GB (llama-server): unload after (`ollama.exe stop gemma4:12b`).
- `git rm --cached` + `git commit -- <dir>` puts the files back; proto/ has a .gdignore now.

# S570 handover (written 2026-11-27, S569 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S569_DIGEST.md`.

## S570: DO THESE FIRST
0. ONERULES1 FIRST (owner S569: "shouldnt kicks and everything else get worked all at once ? because how it knows the
   current changes ?"): kick.html and head.html are hand-kept copies WITHOUT the v0.568.12 feint fix - KICKFIX5 measured
   on yesterday's rules. ops/research/TASK_ONERULES1.md: build every page from order.html (make_kick.py, make_head.py),
   re-measure the kicks winner there, then stack the winners (COUNTERS2 H3b, RULES569, kicks) one at a time and measure.
1. COLLECT the three console workers that ran overnight: KICKFIX5 (docs/KICKFIX5_RESULT.md - the owner wanted the kicks
   finished on 27 Nov; a finished version goes on kick.html), COUNTERS2 (docs/COUNTERS2_RESULT.md), RULES569
   (docs/RULES569_RESULT.md - R5 the exchange that gets dearer first). Missing page = read the tab / E:/FightCamp/wt_tmp
   logs, relaunch with "resume from docs/<ID>_RESULT.md" (a worker stopped for memory never restarts itself).
2. BUILD1 (his Breachway idea, ops/research/TASK_BUILD1.md) to a free seat: design + greybox probe + two critics at 8+.
3. LAYERS: he said "we can buy the animations and cascaduer now if needed" - ask ONCE whether Cascadeur (Indie) and the
   Animo boxing pack are bought; then LAYERS_SCOPE_S569 phase 0 (holds + jab, one man per picture, ?layers=1).
4. MMCPLAY1 (agents play Mixed Martial Cards from its own rules) when a seat frees; LONG3 to Arena (limit resets daily).
5. Public site is at v0.569.7; v0.569.8-9 (guard cards, strip pictures) need his OK to push (a push cuts bouts).
6. Services: page server 8797, gate 8798, match server 8796, Gemma - they survived the last session; check with
   Get-NetTCPConnection before starting copies (S569 started duplicates and cut a Gemma bout).

## Rules learned in S569 (also in memory)
- Heredocs eat backslashes (a `
` became a line break three times): Edit tool or String.fromCharCode(10).
- One heavy thing of mine at a time beside the workers: a 2 GB game copy + headless runs stopped two workers for memory.
- To playtest an Electron reference game: back up its %APPDATA% folders, run it on the hidden desktop with --mute-audio
  --remote-debugging-port, drive it through CDP (scratchpad cdp.mjs / play_mmc.mjs), restore the saves after (diff -rq = 0).

# S569 handover (written 2026-11-27, S568 - Opus 5.5)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S568_DIGEST.md`.

## S569: DO THESE FIRST
1. FEINTFIX2 IS DONE AND ON THE PAGE (v0.568.12): G1 'a feinting hand guards nothing before its feint' (his correction),
   8 of 9 bars on both seeds on the page's own rebuilt table; G2/G3/G12/G13 not taken (they kill the overhand, the feint
   or the Hearns film). The loop is still 35/53/37% (bar 30): a next feint round only with a new idea. COLLECT KICKFIX4
   (arena/b9de29e2): arm `python -u ops/Tools/arena_watch.py 180 KICKFIX4=b9de29e2:docs/KICKFIX4_RESULT_ARENA.md`; its
   result page still carries the S567 BLOCKED line - judge it by its commits / pull request. IT WENT SILENT at 04:14 UTC on
   2026-11-27 (189+ min, last commit 'E3 table and N=56 seed=1 volume baseline'): open its Arena chat (Browser 2,
   chat id b9de29e2) and send 'Keep working' - an Arena chat that ended its turn with runs queued does nothing. The live match server was
   restarted in S568 after the feint fix (owner: 'Yes, restart it'); Gemma now rejoins by itself after a server restart.
2. RESTART FOUR SERVICES in terminal tabs (they die with the session): page server `python proto/cardgame/serve.py 8797 twohands`,
   the gate `powershell -NoProfile -ExecutionPolicy Bypass -File proto/twohands/site/run_gate.ps1`, the match server
   `node proto\twohands\site\match_server.mjs`, and GEMMA `node proto\twohands\site\match_llm_bot.mjs` (the local AI he plays).
3. HIS ANSWERS (ask the ones still open, short): his play of the hand of cards + lanes (v0.568.9-11); head moves onto the
   main page (measured first) or drop the Head row; Q-345 tells (cut / try once more); the public push of v0.568.1-11
   (ASK FIRST, a push cuts bouts); COUNTERS round two (the worker's fixes) or park; keep three moments or work on one
   action (ONEACT1 said: a toy for the pace); the 1.9 GB AMD usage log on C: (his file; C: AMBER).
4. Then LONG3 after the feint fix; INSIDE1 Phase 2 when his game is closed.

## Rules learned in S568 (also in memory)
- A local model is a real-time player only with think=false and num_ctx 8192 (Ollama's default context here is 262,144:
  20 s a beat). It holds ~9.5 GB loaded: the watchdog went RED on memory - load it only during bouts.
- Python heredocs eat backslashes: a `\b` became a backspace byte in ring_ui.js, `\n` a real line break. Patch scripts go
  in a file (Write tool), or use the Edit tool; check with `od -c` when a regex is involved.
- "Nothing appears" from him = the change is too small to see, not a cache: make the choice plain (its own row, its own
  words), check it with real clicks in the browser and a full-size still before saying it is fixed.
- A terminal tab's prompt line after a worker ends is a suggestion, never his words.

# (below: the S568 handover as S567 wrote it)

# S568 handover (written 2026-11-27, S567 - Fable 5.2)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S567_DIGEST.md` (both parts).

## S568: DO THESE FIRST
S568: (1) collect the four Arena runs - FEINTFIX2 (95892a39: G1 'the feinting hand does not guard first' is a CORRECTION by his word, it goes on the page if it holds the bars; the best of G2 / G3 on top if G1 alone does not fix the loop), SHORTBEAT1 (2a3d0ae3), TELLS5M (4c40abf4: fails = his keep-or-cut, no fifth round), KICKFIX4 (b9de29e2: judge by its pull request). (2) RESTART THE THREE SERVICES in terminal tabs (they die with the session): page server `python proto/cardgame/serve.py 8797 twohands`, the gate `powershell -NoProfile -ExecutionPolicy Bypass -File proto/twohands/site/run_gate.ps1`, the match server `node proto\\twohands\\site\\match_server.mjs`. The Render site needs nothing. (3) After ANY page change he should see publicly: make_site.py + push the test repo (it restarts the public server: ASK FIRST, it cuts bouts). (4) Then LONG3 (the jab that meets him does health) after the feint fix; the screen's clarity (three reviewers: 5, 5, 7): a per-moment cover row, the range named large, a guided first beat; point versus_by_message.mjs at the match server; INSIDE1 Phase 2 (his game closed). NEVER ask about the Cascadeur plan or the packs.

## Rules learned in S567 (also in memory)
- After ANY edit to a .js / .mjs file: `node --check <file>`. An apostrophe inside a single-quoted string killed version.js and play_cli.mjs.
- Read a test line before the commit, in its own step: `cmd | tail -1 && git commit` commits on a failing test.
- A push to the public test repo restarts the public server and cuts online bouts: ask him first.
- Never run the Antigravity tool (agy.exe) while he is at the PC: it opened tabs in his browser.
- He does not want to be asked about purchases (the Cascadeur plan, the packs): he says when they are bought.
- One move a hand a beat: say rules like that ON the page; three of his messages in a row were the page not saying what it had done.
- Scripts with apostrophes or nested quotes go in a file (Write tool, the scratchpad), never in a heredoc.

## Services (all three die with the session: restart them in terminal tabs)
- page server 8797: `python proto/cardgame/serve.py 8797 twohands`
- test link gate 8798 (his tailnet, https://beast.tail6f2f5c.ts.net:8443): `powershell -NoProfile -ExecutionPolicy Bypass -File proto/twohands/site/run_gate.ps1`
- match server 8796: `node proto\\twohands\\site\\match_server.mjs` (the gate passes /api on to it)
- PUBLIC: https://punchers-chance-test.onrender.com - Render, Free plan, from E:/FightCamp/tmp/punchers-chance-test (make_site.py builds it; push = deploy). His Render and GitHub are signed in in the built-in browser pane.

## S567 in one screen
S567 (Fable), part 2. ON THE PAGE (v0.567.1 to v0.567.9, all pushed): punch cards show the ranges they reach and damage beside stamina, his punches too; a Replay round button at the bell; health, stamina, guard and ground as round gauges; move names in the commentary are links to their cards; after a pick the overview comes back with the move in its lit row (owner: 'i selct an action to go as second and it deltes the first one' - one move a hand, now said), a move card can be dragged onto a slot, the no-step feet card reads 'Stay put (no step)'; the strip has two sides (his 'like rune colossieum'): yours left, his right, his slots fill as each moment plays with the result timed to the picture. NEW PAGES: scene.html (four famous exchanges on our rules, checked on film: 10 of 14 match the ring; the timed counter and the check hook do not exist in our rules), online.html (Play online). PLAYING EACH OTHER: proto/twohands/site/match_server.mjs (port 8796), reached on his tailnet through the gate (:8443/online.html) and PUBLIC on Render: https://punchers-chance-test.onrender.com (private repo ICOON-Studio/punchers-chance-test, a personal code + the notice, Free plan; codes in proto/twohands/site/data/tester_codes.json on this PC). THE AGENTS' LEAGUE (his ask; versus.mjs, versus_by_message.mjs, league.mjs): 15 bouts, Claude (Opus console worker) 13 points, Ziva 12, Dola 9, John 7, Maria 3, Kalli 0; mean verdicts fun 7.4, depth 6.8, clarity 7.2, variety 6.0; every top seat names the FEINT as the broken plan; Antigravity out (its tool opened tabs in his browser). REVIEWS: Arena solo ALLPLAY3 fun 8 depth 8 clarity 7 variety 7; Ludo from a still fun 7 depth 8 clarity 5 variety 6; Toribash read (TORIBASH_NOTES_S567). COLLECTED: TELLS4M (4 of 7, not for the page), PROGP4 (no new upgrade pair passes two seeds), LONG1 (none; with LONG2 none). FIXED ON THE WAY: play_cli.mjs could not start since the S565 rename (a quote), version.js broken for one version (an apostrophe), a commit that went out with a failing play test.

# (below: the S567 handover as S566 wrote it; its METHOD lines all stand - quote them)

# S567 handover (written 2026-11-26, S566 - Fable 5.2)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page, then `ops/research/S565_DIGEST.md` (S566 is the section just below).

## S567: DO THESE FIRST, IN THIS ORDER (written at the S566 wrap-up, 22:05 on 2026-11-26)
1. DO NOT ASK HIM (S567: "not yet and stop asking"): he says when these are bought or looked at. The three were:
   - the Cascadeur paid plan ("not now i will do it tomorrow"; Indie is enough; Free cannot export; 40% off annual until 7 Dec);
   - the Animo "Boxing Additional" pack, RenderHub, $69.99 ("this is very good ... i will buy this also tomorrow");
   - his look at the strip + preview + held-hand words + still dashed line (v0.566.3 on http://127.0.0.1:8797/order.html).
2. COLLECT WHAT RAN OVERNIGHT (all four were alive at 22:02):
   - console workers on the PC: KICKFIX4 (tab c1; F1 table + trial committed 20:51) -> docs/KICKFIX4_RESULT.md;
     TELLS4M (tab c2; step 1 committed 20:09, on the version-4 runs) -> docs/TELLS4M_RESULT.md. They commit to main by
     pathspec themselves: `git pull` brings their results. If a result page is missing, their tabs are gone with the
     session: read E:\FightCamp\wt_tmp\<ID>\*.log, then relaunch with the same prompt (ops/research/WORKER_S566.md).
   - Arena (BROWSER 2: `select_browser`, Browser 1 shows Log in): LONG1 arena/cba93bd0 (on L2), PROGP4 arena/efb38a10 (on
     its 4th card). Arm `python -u ops/Tools/arena_watch.py 180 LONG1=cba93bd0 PROGP4=efb38a10` under Monitor. An Arena
     chat that ended its turn with runs "queued" does nothing: open it and send "Keep working".
3. THEN, by what he bought: TASK_CASC_MCP (the overhand first; 2026.3 is installed, our channel answers, csend's output
   return is broken: fix first) and TASK_GUARDSTANCE1 (his idea: four readable guard stances, the preview adjusts first).
   WATCH A PACK'S PREVIEW BEFORE USING OR RECOMMENDING IT. LONG1 + LONG2 judged together -> TASK_LONG3 (the jab that meets
   him does health). INSIDE1 Phase 2 stills. No Godot change was made in S566: no export was run.
4. PARKED BY HIM: the "Step in a moment later" button (Q-344) - stays on wait.html, do not ask again.
5. ZIVA: plan cancelled, paid until 2026-12-19 - give it heavy work before then; the free model only after.

## S566 in one screen (read first)
HIS TWO MARKS ON THE Q-344 PICTURE, BUILT (v0.566.1; stills on 8787/review; his look is the gate):
- C520 "can you add a strip with slots for each action so it is clear what happens when ,and player can drage the slot to
  change the order , also would be nice if a holographic preview plays the current sellection" -> `proto/twohands/strip_ui.js`
  (loaded after body_ui.js by order, head, kick and so by the built punch and wait pages): three numbered slots under the
  ring, a card per moment (name, what it does at the range it happens at, what its hand leaves open), drag a card to
  another slot (a click: one slot earlier); a see-through blue copy of his boxer (`#ghost`, the blue runs with red masked
  away) plays the chosen moves once after every change and again while the mouse is on the strip, the playing slot lit.
  It hides the page's old chip row and body_ui's sentence row; rules untouched (it sets P.ord and calls plan()).
  `window.stripState()` is the browser check; `beat_shot.mjs` beats take `"hold": [ms, ..]` (more plan shots, the strip's
  state printed) and `"plan_only": true`.
- C521 on the help box "i do not understand what it does, maybe reoharse and use basic terminology" -> body_ui.js: "Choose
  your moves: 1. Click a part of your boxer (the blue one) ... 2. Its moves show here: click the one you want."; the top
  bar says "click your boxer to choose his moves".
- Q-344 IS CLOSED: PARKED. On the board he wrote "idonot understand what you mean"; after a plain explanation in chat he
  said "park that for now ? what do you think ?" and Claude agreed. The late step stays on wait.html (measured, working),
  NOT on the main page; do not ask again unless he brings it up. LESSON: a board question names the thing the player
  sees ("the Step in a moment later button"), never the measure ("holds the bars on both seeds").
COLLECTED: TELLS3M (docs/TELLS3M_RESULT.md): 4 of 7 bars, NOT for the page - obeying every tell blind wins +8 / +10 / +29
points over the no-tell control (a fake hides under 3 damage, so it costs nothing), and the reader bot is wrong in the
probe. -> ops/research/TASK_TELLS4M.md (reader bot fixed, then version 4: a fake may hide ONE 3-damage punch).
KICKFIX3 (docs/KICKFIX3_RESULT.md): E2 and E3 5 of 9 at N=56, the limp loop capped; E3 is the base. ->
ops/research/TASK_KICKFIX4.md (checked low kick costs 2; the low kick keeps the rear hand up; both; plan mix both ways).
NOT LAUNCHED: arena.ai showed "Log in" in Chrome (his sign-in; asked). The lite mirror is pushed (4ed19e17): once he is
signed in, open two chats and name the two TASK files. KDPIC1 NOT LAUNCHED: the watchdog was RED on memory (96%) with
ArcheAge open. LONG1 (cba93bd0) and LONG2 (193e5c2c) were still running at the end (LONG1 quiet 90 min on its L2 / L3
tables: open its chat before calling it dead).
A page_play_test of head.html or kick.html takes 3-4 minutes each beside his game: run them in the background.
RUNNING AT ARENA (Browser 2) since 20:34: LONG1 cba93bd0 (told to keep working) and PROGP4 efb38a10. Cascadeur: his "not now i
will do it tomorrow" - ask once at the start whether the plan and the 2026.3 update are done, then launch TASK_CASC_MCP.
ZIVA: Basic plan CANCELLED on his word (S566), paid until 2026-12-19: give Ziva its heavy work (playtests, motion) BEFORE
that date; from 2026-12-20 the free model only (about 50 small messages a day), never propose re-subscribing.
KDPIC1 COLLECTED (docs/KDPIC1_RESULT.md, tools/pics2d_ko_room.gd): the knockdown stays inside the ropes and the stage (he
turns as he falls, a share of his travel cut; 0 jumps). LEFT: from the furthest-back spot the stage still cuts him (needs
the page to follow the downed man: a ring_ui.js change, not done). THE OVERHAND IS BLOCKED: no take in our files, 12 Ludo
candidates, none an overhand -> it is the FIRST take of TASK_CASC_MCP.
CASCADEUR 2026.3 IS INSTALLED (2026.3.0.17632, S566 21:18). Our hidden channel works on it (/health: server 0.4.0); csend.py's
printed output no longer comes back (fix first); 2026.3 serves MCP itself at 127.0.0.1:8765/mcp, so no bridge. All of it is in
TASK_CASC_MCP.md 'State after S566'. LEFT FOR HIM: the paid plan ("not now i will do it tomorrow"). Chrome still holds a
leftover 'Unconfirmed 397121.crdownload' (600 MB) in his Downloads: his to discard.
PACKS (S566): no pack lists an overhand. The Animo Boxing Animation Pack is REJECTED by him on sight ("all its hooks look
terribel and aim at the sky"): never recommend a pack before watching its preview. The Animo "Boxing Additional" pack
(RenderHub, $69.99: knockdowns, hit reactions, Philly shell): "this is very good", HE BUYS IT TOMORROW - ask once, then fit
its knockdowns and start ops/research/TASK_GUARDSTANCE1.md (HIS IDEA: each guard set-up its own readable stance, the
preview adjusts first, the fighter hops into it on Fight). Bought files stay out of AI tools and the public mirror.
CASCADEUR (his S566 mail + "you do the rest"; "should we wait or work on 3d at the same time at punchers chance ? we could
use the 3d fight on it too"): ops/research/TASK_CASC_MCP.md written - scope = takes Puncher's chance is MISSING, authored
in Cascadeur 2026.3, rendered by our picture tools (one take serves both games); NOT the realtime 3D fight code. We already
drive its script server (ops/Tools/cascadeur/): no new bridge first. WAITS FOR HIM: a paid plan (Free exports .casc only;
Indie is enough) and his update from 2026.2.3 to 2026.3. Told him: yes in parallel, as ONE narrow worker, after KDPIC1.
LONG2 COLLECTED (docs/LONG2_RESULT.md): NONE for the page. The page already lands the waiting cross (a cross from Long in
29-30% of Long beats, 11-13% land, nearly all on a man stepping in). K2 (the cross half) 8 of 9 page bars on both seeds but
the +1 is spent on the high lead it causes; K3 (jabs score 2) changes NO bout: the solver's worth() counts health, never
points, so a points-only rule moves nothing. Its next step: the jab half in HEALTH (a jab landing as he steps in from Long
is a counter, +2), alone and with K2. JUDGE WITH LONG1 when it lands, then one brief (LONG3). The strip's drag is proved
with a real mouse: `beat_shot.mjs` beats take `"drag": [from, to]` (slot 3 -> 1 and 1 -> 2 reorder as they should).

## METHOD lines - quote all of them in your first message
- ## METHOD - THE GAME IS CALLED PUNCHER'S CHANCE (owner S559: "We will name it "Puncher's chance" for now"; S565: "why you
  call the game with the wrong name ?", "wtf ? i didnt mean to add a mechanic , it was the name of game"). "Ring
  Switches" was Claude's working name: NEVER say it to him, on a page, on the board or in a question. Old notes, file
  names, code comments and the lines below still carry it - read it as Puncher's chance. The comeback switch S559-S562
  built under the game's name is "All in" now (punch.html, a trial page; ids pch / punch_chance_* / PUNCHCHANCE1-2 keep
  their spelling). He never asked for it: his keep-or-cut call after he tries it. Bots only have judged it (version F:
  8 of 9 bars on both seeds, comeback 10% -> 15%, knockdowns 2.3-2.5); no playtester and no critic has seen it.
- ## METHOD - RING SWITCHES IS THE MAIN LINE (owner S553, S555). The pages: `proto/twohands/order.html` (boxing, the
  source), `punch.html` (order.html + the Puncher's chance switch: BUILT by `python proto/twohands/tools/make_punch.py
  [tweak.json]`, never edited by hand), `kick.html`, `head.html` (head movement, with its own pictures since S561),
  `body.html` (the lit-limb toy). The rules sit above each page's `// ---- the page` mark.
- ## METHOD - THE SLICE IS BALANCED ON THE INSTRUMENT, NEVER BY HAND (owner S555). A change is a tweak file first;
  `node proto/twohands/tools/balance.mjs table` + `play n=84`; rules_test 37, kick_test 12, head_test 11, punch_chance_test
  13, page_parse, page_play_test 4 (`page_play_test.mjs punch.html` for the copy). A weaker strike lands MORE.
- ## METHOD - THE FIGHT MUST BE SEEN: HIS CAMERA (S559 #16), one fixed ring camera, every render `south=blue`. A new rule
  or picture is proved SHOWN with `node proto/twohands/tools/beat_shot.mjs <out> <page> '<beats json>'` (headless Edge;
  it prints the pictures a beat played; a beat can set `"hp": [yours, his]`).
- ## METHOD - A HEAD MOVE IS STAGED WITH THE GLOVE THROUGH THE PLACE THE HEAD WAS (S561, `tools/pics2d_head.gd`): never
  the plain miss staging (it gives ground: "he stood far away"). The slip is a lean from the Spine bone; the roll takes
  pro_right_weave on both men.
- ## METHOD - ONE ART AGAINST ITSELF FIRST (owner S549, S559 "Yes, kickboxer first").
- ## METHOD - CONSOLE WORKERS IN PARALLEL (owner S559), up to 3 through `ops/Tools/claude_cm.ps1`; the Workflow / Agent
  tools are refused. NODE-ONLY MEASURES GO TO ARENA: `git push`, `python ops/Tools/lite_mirror.py --lean push`, Chrome
  arena.ai/agent (wait ~12 s for the repo selector), a prompt naming the committed TASK file. While his game is open: ONE
  job on the PC, no second render.
- WHEN HE SAYS "ON THE BOARD" ASK WHICH BOARD IN ONE LINE IF IT IS NOT PLAIN (S561: "a jumpsuit for punchers chance on
  the board" was a jump button on the OPS BOARD; a new playable page always gets its jump button there the same turn:
  `ops/Tools/opsboard/roadmap.html`, the PAGES list).
- Appended comments are `/* */`, never `//`.
- ## METHOD - THE TELLS (S563, S564; his "show opponents intentions like card games?"): NEVER his whole plan; ONE body tell
  from the beat he already chose (5 of 5 playtesters). VERSION 3 is the current one (`play_cli.mjs ... tells=3`,
  tells.mjs LIES3/CAP3): a fake never hides a bigger punch, at most 2 a round, a second rule of his own state. It reaches
  the page only after TELLS3M (bars against the no-tell control - the page's men are beaten 67-83% by the control alone)
  and his yes - as a POSE of his body (TASK_TELLS2PAGE) plus the cue word in the ring's corner badge, never near the men.
- `play_cli.mjs` and `tells.mjs` are imported LIVE by every running playtest: keep old calls working when you change them.
- ## METHOD - NOTHING NEAR THE FIGHTERS (owner S562: "i told you do not put text or anything near the fighters"): no bar,
  tick, label or marker on, under or beside the men. Ring readouts in ONE badge in the ring's top-left corner, the rest in
  the panels; a readout says what it means for a choice (memory feedback_nothing_near_fighters_s562).
- ## METHOD - EVERY CLIP STARTS AND ENDS WHERE THE MEN STAND (owner S562: "the distance between fighters is not consistant
  when clips play"): a run is made at each page range it can happen at (`tools/pics2d_anim.gd range=` / `short=1`), proved
  by the edge table (hold before, first frame, last frame, hold after; > 8 px = a jump), never by a shrunk strip.
- ## METHOD - A CLOUD RUN IS WATCHED, NOT POLLED (S565): arm the Monitor tool on `python -u ops/Tools/arena_watch.py 180
  <ID>=<branch id> ...` (30 min, re-arm): one line when a run's result page carries its done line, a STALL line after 75
  quiet minutes (a table build commits nothing for an hour: open the chat before calling it dead). Read a branch with
  `git fetch --no-write-fetch-head --no-tags https://github.com/ICOON-Studio/FightCamp-Lean-lite.git
  +refs/heads/arena/<id>-fightcamp-lean-lite:refs/lite/arena/<id>`, then `git diff --name-status refs/lite/main...refs/lite/arena/<id>`
  and `git show <ref>:<path> > <path>` for each ADDED file (never a whole branch, never Arena's Merge).
- A NEW SLOT IN A PLAN'S ORDER (S565, the 'wait') must be known to `proto/twohands/body_ui.js` words(): it reads
  `ACT[P[sl]]` for every slot. page_play_test does not load body_ui.js - only `beat_shot.mjs` (headless Edge) caught it.
- ## METHOD - EVERY PAGE CHANGE HAS A VERSION AND A CHANGELOG LINE (owner S565: "add a changelog with every fix showing
  which version we running"): `proto/twohands/version.js`, newest first, v0.<session>.<n>, plain words, same commit.
- A COPY PAGE IS BUILT, NEVER EDITED: punch.html by make_punch.py, wait.html by make_wait.py. After any order.html edit run
  both, then page_parse + page_play_test on order, punch, head, kick, wait; wait_test 5.

## His words in S565
"how can i get my brother a link to test the game ? also maybe add a changelog with every fix showing which version we
running"
-> BUILT: `proto/twohands/version.js` (the list; the top entry is the running version, shown as v0.<session>.<n> beside
the sound button on every page) and `proto/twohands/changelog.html`. THE RULE FROM NOW ON: every change a player can
see or feel on a page adds one plain line at the top of `RS_CHANGES` with a new number, in the same commit; then
make_punch.py + make_wait.py. A measure that changed nothing on a page is not an entry.
-> THE LINK: "make it public but ask for email (maybe nda proof ) when someone sign ins and you keep a log of who uses
the link ?" and, on the host, "i use render / onrender" -> ops/research/TASK_TESTLINK1.md (decided: a Render WEB SERVICE
running our own small Node server in front of a built copy of proto/twohands; sign-in = email + a personal code Claude
makes per tester; a confidentiality notice whose acceptance is recorded; a visit log at /owner/log; Render reads a NEW
PRIVATE repo ICOON-Studio/punchers-chance-test, never the main one).
Then he asked "or can you do it via tailscale ?": YES - Tailscale is installed and signed in here (machine beast; it
already serves tcp 9791 for something else: never touch it). The same gate, identity from Tailscale, nothing on the web,
PC must be on, his brother installs Tailscale and is shared the machine (limit the guest to the game's port first).
WHICH WAY IS HIS CALL (asked in chat): Tailscale (private, PC on) or Render (always on, browser only).
HE CHOSE "Tailscale". BUILT AND LIVE ON HIS TAILNET (S565): the gate `proto/twohands/site/server.js` (GATE_TEST 7),
https://beast.tail6f2f5c.ts.net:8443/ -> 127.0.0.1:8798, his log at /owner/log. START THE GATE AGAIN in a terminal tab at
session start (`powershell -NoProfile -ExecutionPolicy Bypass -File proto/twohands/site/run_gate.ps1`): it ran in the
S565 session's tab. The notice is APPROVED ("Yes, use them"). Steps for him: docs/TESTLINK_INVITE_STEPS.md (from Tailscale's docs). OWED:
reading HIS access rules (he signs in to the Tailscale admin page; Chrome showed the login page) to give the exact
edit - DONE S565: the guest rule is SAVED in his Tailscale rules (members keep everything, invited guests reach
port 8443 only; details and the undo in the steps file). LEFT: his invite (Machines -> beast -> Share), then check his
brother appears in /owner/log and cannot open the address without :8443. (Old line: the limit-to-one-port rule BEFORE he
invites his brother (his other served pages would be open to a guest); the invite is his click. See the task's STATE.
(The Render lines below are the other way, not built.)
BUILD AND TEST IT ON THE PC FIRST (server.js + server_test.mjs + make_site.py need nothing from him). Then HIS part:
connect the test repo in his Render dashboard (Blueprint) himself; free or paid instance (asked); the testers' emails;
his OK on the notice's words (draft it for him). NOTHING IS PUBLISHED before those.
Also asked, unanswered: close the worker consoles left from S560-S564 (idle, about 1.5 GB together)?

## OPEN ON THE BOARD
Q-344: "Your step a moment later holds the bars on both seeds. Put that switch on the main page?" (Yes, main page / Keep
its own page / Drop it). On "Yes, main page": moment_gap_b.json's three rule edits + make_wait.py's page patches go into
order.html, `balance.mjs table out=proto/twohands/vtable.json` is rebuilt (15 min at jobs=2), punch.html and wait.html
rebuilt, the page tests, `balance.mjs play n=84` on two seeds, body_ui.js already knows the wait.

## RUNNING AT THE HANDOVER (Arena runs are on ICOON-Studio/FightCamp-Lean-lite; collect as the METHOD line says)
- LONG1 arena/cba93bd0 (TASK_LONG1.md) - the stopping jab (L1), the lead hand as a fence (L2, Dola), both (L3), control L0.
- LONG2 arena/193e5c2c (TASK_LONG2.md) - Kalli's waiting cross: K0 counts what the page already does (a cross at Long
  already lands on a man stepping in), K1 her two bonuses, K2 the cross half, K3 the jab half.
  JUDGE BOTH TOGETHER: bars 8+ of 9 on both seeds and never under the control; the jab's use up (real anchor: the jab is
  40-44% of punches thrown by pros, G99_COMPUBOX_AVERAGES; on the page the two jabs are ~27%, the head jab 8%); Long at
  most 45% of beats; the man walking in still gets in. One version goes to him as a toy page (make_<x>.py, as wait.html).
- TELLS3M arena/181a4c7c - passes -> ask him on the board (one line + the words-tool transcript): the tell on the page as
  a pose of his body? -> TASK_TELLS2PAGE.
- KICKFIX3 arena/c178d87d (quiet for 90+ min, its chat alive on a long run: open the chat).
- BOUNCE1 DONE (99d787712, docs/BOUNCE1_RESULT.md): both men bounce while he plans (2.6 cm dip, two a second; numbers
  BOB_DIP_M / BOB_SWAY_M / BOB_CYCLE in tools/pics2d_bob.gd, BOB_S in ring_ui.js). One page screenshot checked here (his
  camera, blue left, nothing near the men); his play closes it. THE RENDER SLOT IS FREE: launch KDPIC1 (TASK_KDPIC1.md)
  as the next console worker, one render at a time, his game closed.
- Page server: `python proto/cardgame/serve.py 8797 twohands` (check it after any session archive).

## COLLECTED IN S565 (results on main)
- KDHEAL1: keep the get-up [6, 4]. KDFIRST (own count): on the page the man dropped first wins 13% (UFC 34.4% when the
  fight goes on), dropped twice 9% (7%). Reported to him. If he wants the "walk into a punch at 1 health" exploit gone:
  measure "up on no more than he had, no stamina refill" - never a lower floor.
- MOMENTGAP1: B (only the step a moment later) 8 of 9 on both seeds; A (a free wait anywhere) 7 of 9. wait.html built on
  its own table (vtable_wait.json). Q-344 asked.
- CLINCHFIX3: none (H1 48 / 57 / 53%, H2 37 / 58 / 42%, bar under 30%). THIRD FAILED CLINCH ROUND: no fourth clinch fix.
  The loop in probe_clinch.mjs is "step in, FEINT, OVERHAND" then "clinch"; without the clinch the same man wins 7-13%.
  CROSS-CHECK (ops/research/s558_balance/results/clinchx_<base|d|e|f>_loop.txt, n=60, the page's own table): today
  38 / 63 / 70%; D (the feint opens the overhand only Inside) 33 / 42 / 37%; E (a punch landing in your feint moment
  wastes it) 25 / 33 / 32%; F (both) 22 / 25 / 25% - UNDER THE 30% BAR AGAINST EVERY MAN, the clinch untouched. The
  clinch was never the exploit: it paid for a feint-then-overhand nobody could cover. If JABLAND2 F holds 8+ of 9 on
  both seeds (Arena), F is the page change for the landing bar AND the clinch loop: re-run probe_clinch on F's own
  table, then tweak -> order.html. If only D or E holds the bars: the same check on that one, H1 added if it misses 30%.
- AIEMPTY1 (collected after the ship, docs/AIEMPTY1_RESULT.md): NONE as briefed, WITH A FINDING. Filtering his empty
  beats (ai_no_empty.json) takes them to 0 in his plain beats but makes him stronger: the player-bot's wins v the Jabber
  76 -> 77%, v the Slugger 71 -> 63%, v the Body Snatcher 75 -> 52% (the brief's bar was "within 5 points"). His empty
  beats were a hidden handicap the S555 skill numbers were set with - and today the player-bot beats every man 71-76%
  (his S555 words: "vs the jabber you win very easy"). 53% of the empty beats come from the solved mix itself (a back
  off at Long with no punch, a step in at Inside): a rules question, not a filter. NEXT (his taste: how hard the men
  should be): AIEMPTY2 = the filter + the three skill numbers set again on the instrument to a target he names.
- JABLAND2 (collected after the ship, docs/JABLAND2_RESULT.md): NONE. The jab half works in every version (jab lands
  34-42%, thrown 7-10%). But any feint fix kills the feint AND the overhand in the solved mix (1-2% of beats, floor 3%):
  D 7 of 9 both seeds, E 8 of 9 (nearest), F 7 of 9; the surviving feint-overhand pairs still land 83-94%. SO THE CLINCH
  CROSS-CHECK'S WINNER (F: the loop 22-25%) CANNOT GO ON THE PAGE. What is known: the loop stands on the feint leg; the
  fix must cut the feint -> overhand opening WITHOUT making the feint worthless. NEXT (a design question, ask Kalli and
  Dola with both result pages, then one probe): e.g. the feint opens only ONE line (his reacting hand), the overhand needs
  the Inside AND a spent opponent, or the overhand's own price and reach change. The jab half alone (version c's: the
  rear glove held high catches the jab, the jab costs 0) can be measured for the page on its own.
- ALL IN (the comeback switch): his S565 words "sounds fun if it is balanced properly" and "but how would that work later
  if we add mma and the fight is on the ground ?" - kept as a trial page. Answered as a direction only: on the ground the
  all-in action is a committed FINISH (a submission attempt or a ground-and-pound burst): it ends or nearly ends the
  fight if it is not defended, and a failed one costs the position (he escapes or reverses). Design it before any MMA
  page; first let real players try the boxing one (him, then a playtester round - play_cli has no punch.html mode yet).
- HIS QUESTION "how are we progressing with knee,elbow,head intergration ? have the balnced finished or not yet ?" was
  answered: boxing 7-8 of 9 (the overhand), head movement 7 and 8 of 9, kicks 5-6 of 9 (KICKFIX3 running), knees and
  elbows NOT STARTED (the instrument reads the punch tables, so they are measured the day they are added). Order stays:
  one art against itself first, kickboxer first.
- PROGP2 (his Q-340 "Yes, a choice"): at Sharp "cheaper or faster" is a real choice for the Overhand only (57% / 55%),
  nearly for the lead uppercut (59 / 53). The hook's cheaper card is dead (43%); body hook, rear uppercut and body cross
  always take cheaper; the cross is too strong both ways (62 / 63); the jabs have nothing to give. NEXT: PROGP4, a pair
  of its own for each punch (docs/PROGP2_RESULT.md lists one candidate pair each, unmeasured) - a brief with
  `## Feedback loops`, per-man damage and reach read from the man's own table (probe_sharp.mjs has stamina and speed).
- INSIDE1 steps 1-4 + GLIDE2 (the S564 render worker): Inside is 0.55 m, everything at Inside re-made, 0 jumps there;
  punches 33 jumps -> 2, head moves and kicks 43 -> 8. Left, named in the result pages: the low kicks' last picture
  (8-10 px), red_low_kick_missed and red_jab_missed refused by the camera at Long and Mid. INSIDE1 Phase 2 (the
  see-through overlap where the men cover each other) is NOT started: 3-4 Inside stills to him first.

## FIRST (in this order)
0. S566: his look at the strip + preview; Arena sign-in -> launch KICKFIX4 and TELLS4M; items 2 and 3 below are DONE or
   superseded by the S566 section (JABLAND2 none, TELLS3M and KICKFIX3 collected).
1. His answers: Q-344, the consoles. Collect what has ended (arena_watch prints it).
2. JABLAND2 + the clinch cross-check -> one page change if a version holds the bars (tweak -> order.html, table,
   balance two seeds, both make scripts, the page tests, head.html too).
3. TELLS3M -> the board question, then TELLS2PAGE. AIEMPTY1, KICKFIX3.
4. LONG1 + LONG2 -> one Long rule as a toy page for him.
5. BOUNCE1 collected (your own look at its pictures) -> KDPIC1. Then INSIDE1 Phase 2 stills for him.
6. TASK_PROGP4.

## Waiting on the owner
- Q-344 (above); his play of wait.html ("Pick your moment" on the ops board), the body view (order.html), punch.html.
- The old worker consoles.

## Seats
Arena for node-only measures (push, `python ops/Tools/lite_mirror.py --lean push`, Chrome arena.ai/agent, wait ~15 s for
the branch selector, a prompt naming the committed TASK file; the branch id is the last 8 characters of the chat URL);
console workers (`ops/Tools/claude_cm.ps1 --model claude-opus-5-5 --permission-mode auto "<prompt naming the TASK file>"`);
Ziva for playtests; Dola by `play_by_message.mjs via=dola`; Antigravity by `via=agy`; Grok bots (John, Kalli, Maria) -
`gbot.py send --to "<bot>" --file <f>`; `seat_queue.py drain` collects a seat answer now instead of at the half hour.

## Model for S566
Opus, medium effort, Fast off - collecting six measures, his answer to Q-344, then one page change at a time.

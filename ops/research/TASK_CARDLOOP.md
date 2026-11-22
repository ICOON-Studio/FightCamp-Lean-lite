# TASK CARDLOOP - finish the card-game prototype loop as headless SDK jobs (replaces the Arena loop)

Run with `python ops/Tools/sdk_run.py --id CARDLOOP<n> --budget <usd> "<this file's round prompt>"`. Repo root, no browser tools, never run Godot.

## Where it stands (2026-11-22)
Prototype `proto/cardgame/` (HTML/JS rules, node tests, 2,000-bout balance sim). Rounds 1-3 merged (round 3 = FightCamp-Lean PR 442: 95 checks green = rules.test 32 + round2 19 + round3 11 + round3b 16 + round3c 17; balance.mjs PASS). Scores so far: round 1 Kalli 4/4/5, Arena critic earlier rounds ~4/5/4, round 2 Kalli 5/4/5 (DEPTH/PLAY/GENERAL). Round-3 critics are pending: Kalli SQ290 (answer lands in ops/research/CARDPROTO3_CRITIC_KALLI_KALLI.md) and an Arena chat https://arena.ai/agent/01a20362-68fd-7381-b745-5ef003088e4d (its PR, if it lands, is CARDPROTO3_CRITIC_ARENA.md - use it, but open no more Arena chats). Rounds used 3 of 6. Leftover asks: ops/research/CARDPROTO3_PARTD_KALLI_R2.md (pressure currency, dead-exchange rules, lines from outcome code, honest arms for all style pairs, React below Speed 65, Lead hook fixes, Change the plan) and TASK_CARDPROTO3.md Part B items not met.

## The bar
Two FRESH critics each give DEPTH >= 8 and PLAY (fun) >= 8. At most 6 rounds in total; after round 6 under 8, stop and ask the owner "cut or keep".

## The loop, one round per job
1. Read the newest critic files (CARDPROTO<n>_CRITIC_KALLI_KALLI.md, CARDPROTO<n>_CRITIC_ARENA.md or the SDK critic's file) and their "TO REACH 10/10" lists.
2. Build the fixes yourself, most important first, in proto/cardgame/ only. Keep each script under 500 lines (split a module if needed). Never delete or weaken a test; add tests for each new rule.
3. Run ALL `node proto/cardgame/rules*.test.mjs` and `node proto/cardgame/balance.mjs 2000`. Acceptance: no fewer checks than 95, tell-follower 58-62%, no card over 65% win, draws 0%, stoppages 10-20%, every style pair 42-58%. Fix until green. Play one bout in a browser build only if a tool for it exists; otherwise load index.html logic through node and check ui.js loads every rules-*.js file it needs.
4. Commit by pathspec (`git add -- <files>` then `git commit -m ... -- <files>`), `git pull --no-rebase --no-edit`, push main. Message ends with the Co-Authored-By line the harness gives.
5. Update the README with the real numbers and write ops/research/CARDPROTO<n+1>_CRITIC_KALLI.md (header + README + balance table + 3 transcripts of same-sex AI v AI bouts, no earlier scores; copy the pattern of CARDPROTO3_CRITIC_KALLI.md), then `cd ops && python Tools/seat_queue.py add --seat kalli --brief research/CARDPROTO<n+1>_CRITIC_KALLI.md`.
6. Stop and report: what changed, numbers, queued critic id.

## The second critic (replaces the Arena code-checked critic)
A separate fresh SDK job (no author context, read-only: it adds only ops/research/CARDPROTO<n>_CRITIC_SDK.md) following TASK_CARDPROTO3_CRITIC_ARENA.md: play 20+ bouts through node (AI v AI, random, always-same-card, largest-damage, reading policy using public tell/film), score DEPTH/PLAY/GENERAL with evidence, missing and useless cards, and an ordered "TO REACH 10/10" list. It must not edit proto/.

## Owned files and commands
Owned: proto/cardgame/** and ops/research/CARDPROTO*.md. Do not touch anything else. Tests: `node proto/cardgame/rules.test.mjs`, rules.round2/3/3b/3c.test.mjs, `node proto/cardgame/balance.mjs 2000`.

## When 8+/8+
Stop the loop; publish a screenshot with `python ops/Tools/review_add.py --stage S537 ...` and ask the owner on the board (20 words max). Then the roguelike run layer (proto/cardgame/run.js, ~8-bout ladder, one deck carried, pick 1 of 3 cards after a win) through the same critic loop.

# TASK CARDSCOPE4 - card game scope round 4: six martial arts, limb points probed against the wind pool (S538)

Model: claude-fable-5-2 (headless on the API credit, ops/Tools/sdk_run.py). Discipline: card game prototype (owner ask, standalone).
Node greybox only (no Godot: the PC runs Godot probes beside you). The patch loop on Arena's prototype is STOPPED; this is scope.

## Read first (they outrank any critic's taste)
1. ops/research/OWNER_CARDGAME_INTERVIEW_S537.md - fast and punchy (bout under ~5 min), standalone, show every number, his
   reference games, SIX martial arts (BJJ, wrestling, judo, karate, MMA, sambo - plus boxing), animations where possible, his
   "maybe": action points per limb (keep only if it measures better), async ghost battles later (keep an AI pilot + a
   deck that saves as a small file in mind; do not build).
2. ops/research/CARDREF2_MARTIAL_ARTS.md - sections 3b, 6, 7 (the proposal and probes P1-P10).
3. ops/research/DESIGN_CARDGAME_SCOPE.md (round 3 "rally" form), proto/cardscope3/ (its greybox), and the two round-3 critics:
   ops/research/CARDSCOPE3_CRITIC_SDK.md (5/5/6: a 12-card body deck with a no-thought line wins 87% at regional; traps 0.37 a
   bout) and CARDSCOPE3_CRITIC_KALLI.md. Their ordered lists to reach 10 are inputs.
4. ops/research/CARDREF1*.md (how the closest games limit cheap cards; Mixed Martial Cards' corner = a plan choice).

## Do
1. proto/cardscope4/ - copy cardscope3's engine/bots/probe shape (Node .mjs, one file under 500 lines each), add the four-range
   strip and the six styles of CARDREF2 section 6 (each with its one own mechanic and win clock). Bars for every probe are
   written in DESIGN_CARDGAME_SCOPE.md BEFORE the run (CARDREF2's bars; do not loosen them after).
2. Run, in this order, and stop to redesign (FREE HAND, owner S534) when one fails twice:
   P3 limb points vs one wind pool vs both (the owner's idea; decide it first, everything after uses the winner);
   P1 the strip; P2 the clocks; P5 the hold as a visible race; P6 each style's own mechanic; P4 the full style table;
   P10 one AI pilot within 5 points of the best scripted pilot on the P4 table. Also re-run round 3's failures (the thin
   cheap deck, beginner at regional, card matchups) on the new form. P7-P9 are named as next, not run.
3. Update ops/research/DESIGN_CARDGAME_SCOPE.md as round 4 (form, numbers, bars passed / failed, what was cut and why), a
   one-screen mockup of a turn at 1920x1080 (proto/cardscope4/turn_mock.html, render with tools/render_mockup.py) showing
   every number the owner asked to see.
4. If the core bars pass: write ops/research/CARDSCOPE4_CRITIC_BRIEF.md (fresh critic; opens with the interview + the scope doc,
   never an earlier score; DEPTH / PLAY / GENERAL /10; reads the greybox code; ends with the ordered list to reach 10 and a
   drawn 10/10 page). Queue Kalli: `python ops/Tools/seat_queue.py add --seat kalli --brief research/CARDSCOPE4_CRITIC_BRIEF.md`.
   Do not critique your own work: the second (code-checked) critic is Claude's to launch - say in the report that it is due.

## Prior research
The four documents above; `python ops/Tools/prior_research.py card game martial arts limb`.

## What would a human do?
A designer prototypes the new resource on paper against the old one, keeps whichever makes turns harder to call without
making them slower, and only then adds the styles on top.

## Prefab check
None (own rules; reference games read for ideas only, nothing copied).

## Contract
OWNS: proto/cardscope4/ (new), ops/research/DESIGN_CARDGAME_SCOPE.md, ops/research/CARDSCOPE4_CRITIC_BRIEF.md
RED_TEST: proto/cardscope4/engine.test.mjs (node --test)
REGRESSION: none (standalone)
VISUAL: no (one mockup still for the owner)

## Rules
No script over 500 lines. node only (`node --test proto/cardscope4/`), long probe output to a file. Commit only your paths
(`git add -- <new>` then `git commit -m ... -- <paths>`), end with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`,
push, report in two lines, stop.

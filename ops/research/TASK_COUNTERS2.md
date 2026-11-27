# TASK COUNTERS2 - the check hook, round two: make it a read, not a sure thing (S569)

Kind: probe. Model: Opus 5.5 console worker (PC, main checkout). Discipline: boxing (Puncher's chance, order.html).
Owner S569, asked "Second round or park?" on the two counters: "Second round" - the check hook only (the timed counter stays
parked: it made waiting at Long a habit). Seat rules: read ops/research/WORKER_S566.md first (commit by pathspec
`git commit -- <files>`, no questions, watchdog before each table, ONE run at a time, jobs=1 while a game is in the
watchdog's top list; ANOTHER WORKER (KICKFIX5, tab c5) runs kick tables beside you - if the watchdog is AMBER on CPU use
jobs=1, on RED wait).

## Where COUNTERS1 stopped (read docs/COUNTERS1_RESULT.md first)
H2 (counters1_h2.json): a lead hook after your own back off keeps its pull +1 when his step in cuts you off, and his held
rear hand does not block it. Mayweather's exchange MATCHES; chosen 5% of beats (good); but it lands 98-100% whenever he cuts
you off - nothing answers it inside the beat - and seed 1 lost a bar (order: feet first 60%+). 6 of 9 seed 1, 8 of 9 seed 2.

## The page changed since: measure on TODAY's page
v0.568.12 put the feint fix on order.html (a feinting hand guards nothing before its feint; vtable.json rebuilt). The
control is today's page: reuse the FEINTFIX2 G1 runs only if they are the page's own runs at the same n and seeds (say
which), else run today's page the same way as each version.

## The versions (tweaks: `src` patches only; order.html is never edited)
- H3 = H2 + the answer: a man who steps in with his LEAD hand held high is not caught - the check hook is blocked as a
  normal lead hook is. (A real fighter walking in behind a high lead guard eats no check hook.) So it pays only against a
  man who rushes in with the lead hand busy or low.
- H3b, only if H3's trial fails a bar: H3 without the +1 (the check hook does its base damage; the win is that it lands
  at all on a man who cut you off).
- One more of your own, only if both fail, aimed at the bar that killed them, with one line of why.

## Do
1. scene_check on each version (`node proto/twohands/tools/scene_check.mjs tweak=<f>`): Mayweather's hook must still MATCH
   (if H3 blocks it, the scene's Hatton must have his lead hand busy or low - read scenes.js, say what the film shows; do
   NOT edit the scene to make a version pass), no other check turns to MISMATCH.
2. One-rep trial n=12 seed 1 (table jobs per the rules above), then n=84 mirror seeds 1 and 2, and opp=0|1|2 n=84 seed 1.
   Results: ops/research/s558_balance/results/counters2_<v>_<run>.txt; commit + push each.
3. The feint loop (probe_clinch.mjs, loop + no clinch, n=60) on a passing version, beside today's.
4. If a version passes every bar: a TOY page, not the main page - proto/twohands/check.html built the way punch.html /
   wait.html are built (read their make_*.py; a new make_check.py), and one version.js line. `node --check` each file,
   `node proto/twohands/tools/page_play_test.mjs check.html` must pass. The owner decides if it goes on order.html.
5. docs/COUNTERS2_RESULT.md: one table (version x seed: bars passed, each red bar's numbers, chosen %, lands when chosen,
   lands when he cut you off, step in %, Long %), scene_check lines, the three men, the feint loop; THREE plain lines for
   the owner (what the player would feel). Last line `COUNTERS2 DONE` or `COUNTERS2 BLOCKED: <why>`.

## The bars
- The page's nine bars on both seeds: at least as many as today's page on the same seed; never losing "mirror 40-60%".
- Mayweather's exchange MATCHES; no other scene check turns to MISMATCH.
- The check hook is a choice and a read: chosen in 2-15% of beats; when he cuts you off it lands 45-80% (not 98%).
- Stepping in stays alive: at least 22% of beats; Long at most 45%.
- No man gains more than +5 points of wins against the mix player over today (H2 gave the Slugger +9).
- The feint loop is not worse than today against any man.

## Feedback loops
- A hook that punishes stepping in -> fewer step ins -> more Long -> the jab carries more -> less need to step in: capped by
  "step in at least 22%" and "Long at most 45%"; the n=12 trial reports both; under 22% at n=12 = stop that version.
- The answer (lead held high when stepping in) -> fewer lead jabs on the way in -> the step in is slower to pay -> fewer
  step ins: the same cap; report lead-high-on-step-in % beside today.
- None other: damage numbers, reach and judges untouched.

## Prior research
docs/COUNTERS1_RESULT.md, docs/SCENES1_RESULT.md, docs/FEINTFIX2_RESULT.md,
proto/twohands/scenes.js, tools/scene_check.mjs (tweak= exists), ops/research/s558_balance/counters1_h2.json (the base).

## What would a human do?
A boxing coach: the check hook catches a man who rushes in square with his hands busy; a man who walks in behind a high
lead hand is not caught. Make it pay for reading a rusher, not for every step in.

## Prefab check
Not applicable (our own rules).

## Contract
- OWNS: ops/research/s558_balance/counters2_h3.json, ops/research/s558_balance/counters2_h3b.json,
  ops/research/s558_balance/counters2_h4.json, ops/research/s558_balance/results/counters2_h3_n12_s1.txt (and the other
  counters2_* result files), proto/twohands/tools/make_check.py, proto/twohands/check.html, proto/twohands/version.js
  (one line, only with a toy page), docs/COUNTERS2_RESULT.md
- RED_TEST: H2 at n=84 seed 1: 6 of 9, the check hook lands 100% when he cuts you off
- REGRESSION: node proto/twohands/tools/rules_test.mjs; node proto/twohands/tools/scene_check.mjs (10 of 14 unchanged)
- VISUAL: none

## Not yours
order.html and every other page, ring_ui.js / body_ui.js / hand_ui.js / strip_ui.js / clock_ui.js, balance.mjs, the
feint rules, kick.html (KICKFIX5 owns it today). No push to the public test repo. Never "Ring Switches" in a result.

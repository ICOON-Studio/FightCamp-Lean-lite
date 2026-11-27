# TASK KICKFIX5 - finish the kicks balance TODAY: F4, then your own fixes, then kick.html (S569)

Kind: probe. Model: Fable 5.2 console worker (PC, main checkout). Discipline: kickboxing (owner S559 "Yes, kickboxer first").
Owner S569: "put a fable console for kicks i want it finished today". Arena hit its daily limit mid-F4 (KICKFIX4).
Seat rules: read ops/research/WORKER_S566.md first (commit by pathspec `git commit -- <files>`, no questions to the owner,
watchdog `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` before every table, ONE
run at a time, jobs=1 while ArcheAge (or any game) is in the watchdog's top list, else jobs=3; on RED wait, never push on).
Never open anything on his screens; never push to the public test repo.

## Where KICKFIX4 stopped (read docs/KICKFIX4_RESULT.md and docs/KICKFIX3_RESULT.md first)
Base E3 (ops/research/s558_balance/kick_fix_e3.json): 5 of 9 at N=56. F1 (checkHurt 2): 5/9 both seeds. F2 failed the
trial (low kick 91%). F3 (F1 + F2): 5/9 both seeds, low kick 87% / 77%. Tweaks f1-f3 and all results are on main.
F4 was never pushed: kick_fix_f4.json does not exist. E3 volume: 1.18 strikes a fighter-beat (80% floor 0.94).

## What "finished" means (the bar for today)
The boxing page (order.html, v0.568.12) itself is red on jab / body jab / overhand landing (67% / 66% / 73%) and push off
(3%). So a kicks version is FINISHED when, on BOTH seeds at N=56, every red bar is one the boxing page also has red on that
seed (run today's order.html the same way for the control, or reuse ops/research/s558_balance/feintfix2_g1 results if they
are the page's own runs - say which), AND the kick bars hold: low kick lands at most 65%, knockdowns at most 2.5 a bout,
stoppages at most 40%, under half of stoppages after a limp, strikes a beat at least 0.94, mirror 40-60%.

## Do, in order
1. F4 = F3 + a teep also covers the lead leg in its moment (KICKFIX4's brief). Write kick_fix_f4.json (`src` pairs are exact
   text of kick.html, no trailing newline), N=12 trial (no switch over 40%, no kick over 90%, under half of stoppages after a
   limp), then N=56 seeds 1 and 2. Commit + push each result.
2. If F4 is not finished: up to THREE more versions (F5, F6, F7), each built on the best so far, each aimed at the red bar
   that killed the last one, with ONE line of why (a real-fight reason: e.g. a low kick into a man who backs off falls
   short; a checked kick leaves the kicker on one leg for the next moment). Same N=12 gate, then N=56 both seeds.
   Stop at the first finished version.
3. If one is finished: put it on kick.html (proto/twohands/kick.html - the tweak's src pairs applied as real edits; rebuild
   any page the build tools make from it), one plain line in proto/twohands/version.js (next 0.569.<n> - pull first and
   take the next free number), `node --check` every .js/.mjs you touch, then
   `node proto/twohands/tools/kick_test.mjs` and `node proto/twohands/tools/page_play_test.mjs kick.html` (3-4 min, run it
   in the background) must pass. If a kick test fails because the rule changed on purpose, say which line and why; do
   not weaken a test to pass.
4. docs/KICKFIX5_RESULT.md: one table (version | N | seed | bars passed | each red bar with its number | low kick lands |
   overhand lands | knockdowns | stoppages | plan mix both ways | strikes a beat | limp bouts / stops after a limp), the
   boxing-page control beside it, then THREE plain lines for the owner: which version went on kick.html and what the
   player feels. Last line `KICKFIX5 DONE` or `KICKFIX5 BLOCKED: <why>`.

## Feedback loops
- The limp: low kicks -> limp -> no back off -> more low kicks. Capped by E3's reflex check; report limp bouts and stops
  after a limp every run; a version over half fails.
- A costlier low kick -> fewer kicks -> more holding at range -> fewer strikes: strikes a beat at least 0.94 (80% of E3),
  else "too passive", not a pass.
- Stamina: body kicks shorten his bar -> he throws less -> more kicks: `N.capMin` 4 stays; report the bar at the last bell.
- One-rep trial: N=12 before any N=56, for every version.

## Prior research
docs/KICKFIX4_RESULT.md, docs/KICKFIX3_RESULT.md, docs/KICKFIX2_RESULT.md, docs/RINGSWITCH_S558.md (the bars),
ops/research/topics/kicks_legs.md. Commands: `node proto/twohands/tools/balance.mjs table page=kick.html tweak=<f>
out=E:/FightCamp/wt_tmp/KICKFIX5/<v>.vt.json iters=300 jobs=<n>` then `play who=mix opp=mirror n=<N> seed=<s> tweak=<f>
table=<vt>` (check balance.mjs's own usage lines for the exact page argument; KICKFIX4's result files show the runs).

## What would a human do?
A kickboxing coach: a checked shin hurts the kicker; a low kick thrown at a man moving away falls short; the rear glove
stays by the chin on the cheapest kick. Fix the cause the numbers name, one at a time.

## Prefab check
Not applicable (our own rules).

## Contract
- OWNS: ops/research/s558_balance/kick_fix_f4.json, ops/research/s558_balance/kick_fix_f5.json,
  ops/research/s558_balance/kick_fix_f6.json, ops/research/s558_balance/kick_fix_f7.json,
  ops/research/s558_balance/results/kick_fix_f4_n12_s1.txt (and the other kick_fix_f4-f7 result files),
  proto/twohands/kick.html, proto/twohands/version.js (one line), docs/KICKFIX5_RESULT.md
- RED_TEST: F3 at N=56: 5 of 9 on both seeds (low kick 87% / 77%)
- REGRESSION: node proto/twohands/tools/kick_test.mjs; node proto/twohands/tools/page_play_test.mjs kick.html
- VISUAL: none (rules only; no picture changes)

## Not yours
order.html and every other page, ring_ui.js / body_ui.js / hand_ui.js / strip_ui.js / clock_ui.js, balance.mjs and every
tool and test. The game is Puncher's chance: never "Ring Switches" in a result.

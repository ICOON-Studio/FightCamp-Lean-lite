# TASK KICKFIX2 - the kick version that holds 8 of 9 bars (S560, measure loop)

Kind: probe. Model: claude-opus-5-5. Discipline: kickboxing (owner S559 "Yes, kickboxer first").
Seat: console worker. Estimate: 3 hours, most of it balance runs (10-20 min each).

## Why
`proto/twohands/kick.html` (kicks on the feet switch) has had five measured versions: base 4 of 9, fix A 4, B 6, C 5, D 4
(`E:/FightCamp/tmp/s559_kick/kick_*.txt`, tweaks `ops/research/s558_balance/kick_*.json`). B is the best and still has two
kicks dead. The next version must come from WHY each failed, not from one more number change.

## What S560 read in the five results (check each against the txt before you build on it)
1. B killed the body kick (1% of beats) and the head kick (0%) by taking Long away from them. At Mid a slow kick (speed 3)
   loses to the cross (speed 2, 3 health: he is "beaten to the punch"), and a body cross does the body kick's job for less.
   Kicks are LONG weapons in these rules (the leg outreaches the arm). The range bar did not need B's change: fix A,
   with every kick at Long and Mid, fought Inside / Mid / Long 28 / 36 / 36%.
2. The low kick lands 94% (A), 70% (B), 96% (C): its landing rate is set by whether a check is worth playing, not by the
   kick's own numbers. At 1 health and 12% of beats nobody spends his feet switch on a check. C made "hold your ground" a
   check and it still landed 96%: men hold Inside (where the low kick does not reach) and step at Long and Mid.
3. Fix A's other reds come from the kicks' price and damage: 3.7 knockdowns and 55% stoppages (body kick 3, head kick 4);
   "no punch in the plan" 37% of beats (a kick costs 3-4 stamina and drops the rear hand, so nothing goes with it);
   feet first in 61% of ordered beats.

## Versions to measure (tweak files on kick.html; one at a time; start from A's reach, NOT B's)
- E1 "cheaper, lighter kicks": fix A + body kick 2 health and 2 stamina (it still shortens his stamina bar and can still be
  caught); head kick stays 4 health, 4 stamina.
- E2 "the low kick punishes the man coming in": fix A + a man who HOLDS or BACKS OFF checks by reflex (the leg line is covered);
  only a man who steps in or kicks in that beat has his lead leg planted. The separate Check switch goes (as in C's tweak).
  Real kickboxing: the low kick is what stops the man walking forward. Expect: the low kick lands about as often as he
  steps in or kicks; the Boxer style (walks in, never kicks) eats them.
- E3 = E1 + E2.
- E4: your own, from what E1-E3 show (say why before you run it). Stop at four versions; report the best.
Bars: the nine of `balance.mjs` (`N=56 sh proto/twohands/tools/balance_batch.sh <out> <tweak>`); out folder
`E:/FightCamp/tmp/s560_kick/`. kick_test.mjs 12 must still pass with a tweak that changes no tested rule; if a tweak
changes one (the check), say which test and why, and do NOT edit the test: list it for the session.

## If you are ARENA (a cloud clone of the lite mirror; the owner is using his PC, so this runs with you)
- The five earlier results are in the repo: `ops/research/s558_balance/results/kick_*.txt`. Read A, B and C before anything.
- No PC watchdog, no E: drive: your out folder is `tmp_kick/` in the clone (do not commit the `*.vt.json` tables; DO commit
  each `<name>.txt` result as `ops/research/s558_balance/results/<name>.txt`).
- Node only (`node proto/twohands/tools/balance.mjs`, `sh proto/twohands/tools/balance_batch.sh`); no Godot, no images.
  Set jobs to your core count: edit nothing, call `balance.mjs table tweak=<f> out=<vt> iters=300 jobs=<n>` then
  `balance.mjs play who=mix opp=mirror n=<N> tweak=<f> table=<vt>` yourself.
- COMMIT AND PUSH AFTER EVERY FINISHED RUN (a tweak file + its result txt), so a session that ends early leaves its numbers.
  Order: the N=12 trials of E1, E2, E3 first (push), then N=56 for each that survived (push each), then E4 if time.
- Delete no test and change no page. Open ONE pull request at the end with docs/KICKFIX2_RESULT.md; never merge it.

## Feedback loops
- The limp (4 low kicks landed = no back off) under E2: a limping man cannot back off, so he holds (checks) or steps in
  (open): low kicks -> limp -> more low kicks land. Cap already in the rules: the limp only removes the back off; count how
  many bouts reach a limp and how they end (stop and say so if over half of all stoppages follow a limp).
- Stamina: a cheaper body kick shortens his stamina bar more often -> he throws less -> more kicks. Cap in the rules:
  N.capMin 4. Report the average stamina bar at the last bell.
- One-rep trial first: N=12 for each version; a version with a switch over 40% or a kick landing over 90% is dropped
  before its full run.

## Not allowed
Change NO page (tweak files only; `src` pairs are exact text of kick.html, no trailing newline) and no test. Your tables go
to your out folder, never to `proto/twohands/vtable.json`. Other workers are running: one balance run at a time, and read
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once` before each (RED = wait).
Commit ONLY your paths by pathspec (`git commit -- <files>`), `git diff --cached --stat` first.

## Contract
- OWNS: ops/research/s558_balance/kick_fix_e*.json, ops/research/s558_balance/results/kick_fix_e*.txt, docs/KICKFIX2_RESULT.md
- RED_TEST: B's bars (6 of 9: dead kicks, low kick 70%, 2.7 knockdowns)
- REGRESSION: kick_test.mjs 12 passed, page_parse ok (the page itself is not edited)
- VISUAL: none

## Result
`docs/KICKFIX2_RESULT.md`: one table - version | bars passed | each red bar with its number | low kick lands | body / head
kick used and lands | knockdowns | stoppages - then which version should go on the page and what it changes for the player
in three plain lines. End with `KICKFIX2 DONE` or `KICKFIX2 BLOCKED: <why>`.

## Prior research
docs/RINGSWITCH_S558.md (the bars); ops/research/topics/kicks_legs.md; kick.html's header (the real numbers: kicks land
~60%, a low kick ~40%, a limp after 8-12 clean thigh kicks); `python ops/Tools/prior_research.py low kick check landing`.

## What would a human do?
A designer asks what each kick is FOR (range, the man coming in, the finisher), makes the defence a choice the other man
actually faces, and measures one change at a time.

## Prefab check
Not applicable (our rules).

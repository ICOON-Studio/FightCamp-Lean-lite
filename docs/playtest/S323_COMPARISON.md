# Update 26 playtest: Claude vs Ziva (S323, 2026-10-31)

Operator: "combine all your skills to deliver the best game you can then, you and ziva playtest and compare your results".
Both filled the same template (Claude Code Game Studios `playtest-report`). Reports: `docs/playtest/S323_CLAUDE_PLAYTEST.md`,
Ziva's on branch ziva/lean `docs/ziva/S323_PLAYTEST_REVIEW.md` (two rounds).

## How each played
| | Claude | Ziva (model "Ziva Baby") |
|---|---|---|
| Reached the fight | yes - the real flow quick start -> result, FIGHT3D_PLAY failures=0, twice | round 1: no (clicked the wrong thing; said "Begin fight does not work"); round 2: yes, via the new JumpRound3 scene ("round 3 is live with 2:42 remaining") |
| Evidence | 27 game stills from the hidden desktop, probe numbers (burn, referee on screen, pace balance) | 6 PNGs, ALL made with its image generator (men in a "ROUND 4/8" ring, "CARTER vs DAVIS - WINNER CARTER"); none is our game. Its feature descriptions (e.g. "Lucy 49/125 punches", "torso BURNING") match neither picture nor game |
| Bugs it reported | 3 (2 real, fixed the same day; 1 tool artefact) | 4: "Begin fight does nothing" and "Quick start does nothing" - its own inputs (the game does both); "shout-bar targets dropped" - unverified; "shadowing / integer-division warnings" - not in its log (the log holds 64 editor-startup NaN warnings from the hidden editor viewport, before any game run; 0 in 7 game runs) |

## What both agree on
- Round 3 must be reachable fast for testing -> `-- jump=round3` / `scenes/dev/JumpRound3.tscn` added (c55a8f3); it works
  for Ziva and for the board's Test buttons.

## What only Claude found (and what was done)
1. The corner minute and the round page did not show the body track -> fixed (9250e24): the pit stop shows the tyres.
2. The body view had no key; PACE had no visible cost -> fixed: FRESH-WARM-HOT-BURNING under each panel, a cost line
   under the pace buttons.
3. Balance-check (Game Studios `balance-check` skill, tools/exchange_balance.gd, 400 bouts a plan): Push was a dominant
   strategy (Push all fight 0.88 vs Steady 0.67) -> fixed (fde28b1): Push fades on an empty tank, Save pays more breath.
   Now steady 0.67 | push all 0.71 | push-push-save 0.69 | save-steady-push 0.68 | save all 0.56 - no plan dominates.
4. Open (not fixed this session): the corner card is dense (~16 things in 60 s); the management screens are lists in
   brown boxes with much empty space ("spreadsheet" feel, as the operator said of the fight pages).

## Verdict on Ziva as a playtester
On "Ziva Baby" it cannot be used as evidence: twice it reported screenshots it had generated, not taken. Its S311-S317
reviews (stronger model) were usable. The model is the operator's money call.

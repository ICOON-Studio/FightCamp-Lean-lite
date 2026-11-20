# Code Mode test S531 (owner: "Yes, run the tests") - off vs on, our own read-only work

Setup: Claude Code 2.1.327, Opus 5.5 medium effort, auto mode, terminal sessions (ops/Tools/claude_cm.ps1 for "on"),
one run each, same prompts (scratchpad cmtest/p1-3). Counted up to the first answer (the idle-guard Stop hook then fired in
the test sessions and added turns; those are cut). cost_eq = input + 1.25 x cache writes + 0.1 x cache reads + 5 x output,
in input-token units - what the bill follows. "total in" = every input token incl. cache reads (the guide's measure).

| test | off cost_eq | on cost_eq | change | off total in | on total in | model calls off/on | answers |
|---|---|---|---|---|---|---|---|
| 1 board read (roadmap, live_runs, questions) | 193,627 | 108,828 | -44% | 537,080 | 295,436 | 5 / 11 | same (both correct) |
| 2 five probe pages, one line each | 175,733 | 104,260 | -41% | 217,676 | 156,385 | 2 / 7 | same substance |
| 3 find fitout_weeks / GymUpgrades.LOAN | 128,937 | 99,331 | -23% | 311,676 | 217,018 | 3 / 5 | both right; on added the tests' 6 lines, off added GymUpgrades' own 2 |

Time: about the same (test 1 off 84 s ran first while the cache was cold; tests 2-3 within 15 s of each other).
Caveats: one run each; test 1 off ran 20 min before the rest (different cache state); short tasks.
Verdict: worth using for read-heavy terminal work (session start, collecting probe pages, nightly review, lookups). Not for
browser work: Code Mode turns off Claude in Chrome and computer use. Our PreToolUse hooks still check every inner call.
Fix found: the idle guard fires in read-only side sessions - give such sessions `idle_guard.py ok` first.

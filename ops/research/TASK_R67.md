# TASK R67 — THE BACKLOG NOBODY WROTE UP (claude)

Model: top tier, effort high, Fast off. One session.

Written after the fact, 2026-09-08, so the pass is recorded the way every other
piece of work in this repository is: a task file, a gate, a digest and a
HANDOFF block. The five items came from the operator, off `triage` plus the
board's own `COMPLETE?` rows.

## Why this exists

`triage` shipped 2026-09-08 and immediately found work that had landed and
never reached the board. Five separate holes, none of them a missing feature:

1. **Eleven finished tasks with no HANDOFF block** — C30, C32, C33, C40, C43,
   K18, R47–R51. The board printed them `COMPLETE?`, which means "a digest
   exists and nobody wrote the block".
2. **Three agent reports stranded on Cursor branches** — U3, U5, U10. Written
   correctly, pushed to the agent's own branch, so `inbox` could never see
   them.
3. **82 task files whose `done --task` gate could not run.** With no
   `## Owned files` section the gate found nothing to check and returned 0.
4. **`fight_simulation_test.gd:631`** referenced
   `FightSimulation.BOXING_MIN_ROUND_SCORE`, removed by R38. Three Codex
   digests (C33, C40, C45) reported the SCRIPT ERROR; nobody was ever assigned
   it.
5. **R66's ring arithmetic was never retrofitted onto ArenaFit**, and its
   10.68 m sat beside `arena_fit_test`'s 11.88 m looking like a defect.

## What to do

- Write the eleven blocks from the digests, then `sweep`.
- Recover the branch-only mail onto master, ack it, and rule on each branch.
  Land anything on a branch that is still a live defect on master.
- Close the vacuous gate in `Tools/agent_comms.py` and backfill the sections.
  Every backfilled path must come from the task file's own words.
- Read the boxing round-score floor where R38 put it: `min_round_score` on
  `boxing.scoring_profile`.
- Make `ArenaFit` compute R66 section 4's table, and say in the test which ring
  each of the two figures belongs to.

## The trap

**Do not gate any of this on an exact count.** The suite's failure count moves
under you as the fixes land; write every gate as a ceiling.

## Owned files

```
Tools/agent_comms.py
Godot/tests/fight_simulation_test.gd
Godot/tests/arena_fit_test.gd
Godot/scripts/RankingsHubPanel.gd
Godot/tests/rankings_hub_panel_test.gd
research/R66_CELL_SIZE_RULING.md
research/R67_DIGEST.md
```

## Parse gate

```
python Godot/tools/check_scripts.py Godot/tests/fight_simulation_test.gd Godot/tests/arena_fit_test.gd Godot/scripts/RankingsHubPanel.gd Godot/tests/rankings_hub_panel_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/arena_fit_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_simulation_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_hub_panel_test.gd
```

Then the full suite once, in the background, before the commit.

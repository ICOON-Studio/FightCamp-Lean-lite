# TASK SPLITFIX1 - make game_training_split_test independent of world generation (Arena)

Model: any. Seat: Arena (cloud). Tier: one test file only.

## The defect
`Godot/tests/game_training_split_test.gd` (~150 lines) is a behaviour lock on weekly training (SPLIT2). It is RED on
master: it signs "the first two UK boxers `get_recruitable_athletes('United Kingdom', 400)` lists with different stats"
(lines 56-71) and then compares their stats/fatigue/stat-change rows to hard-coded numbers (EXPECTED_STATS,
EXPECTED_FATIGUE, EXPECTED_CHANGES, lines 7-35). Any change to world generation (a new organization in the catalog,
a new athlete field) re-orders or replaces those two boxers, so the lock reads red although training did not change.
Proven on the PC (S231): master shows 33 FAILs, a catalog change shows 69 - in both the two fighters are simply
different people (the gains per day are the same numbers).

## What to build
Pin the FIXTURE, not the world: after signing two recruits, overwrite EVERY field of each signed athlete that weekly
training, fatigue and the stat-change history read (stats, stat_history, fatigue, age, recovery/condition fields,
potential/talent fields, traits, injuries, weight - find them by reading `Godot/scripts/state/GameTraining.gd` and the
week-advance training path in `Godot/scripts/GameState.gd` (never read GameState.gd whole: grep `func advance_week`,
`_apply_week_training`, `fatigue` and read those windows)). Use two DIFFERENT fixed athlete dictionaries (never two
identical fighters). Then re-record EXPECTED_STATS / EXPECTED_FATIGUE / EXPECTED_CHANGES from that fixed fixture.

## Acceptance
1. `godot --headless --path Godot --script tests/game_training_split_test.gd` prints 0 FAIL lines.
2. Prove the independence: add one extra athlete to the world before signing (or shuffle the recruit list) in a
   SECOND test function of the same file - the numbers must stay identical.
3. Prove it can still read worse: a third function doubles one station's gain (monkey-patch the program to a
   different focus) and must produce at least one mismatch (report it as a passed control check, not a FAIL).
4. Only `Godot/tests/game_training_split_test.gd` changes. Never delete or weaken another test.

## Prior research
research/S231 notes in this file; SPLIT2 history: `git log --oneline -- Godot/tests/game_training_split_test.gd`.

## What would a human do?
Freeze the inputs of a golden test; a golden test that depends on a random world is a flaky test.

## Prefab check
None - a test fixture.

## Trap
Headless `--script` runs keep game switches OFF (that is the control arm) - do not pass `-- as_game`.

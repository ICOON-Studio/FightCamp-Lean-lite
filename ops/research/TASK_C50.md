# TASK C50 — THE FOURTH RESULT (codex)

Model: gpt-5.6-luna, effort **high**, Fast off. One session.
**QUEUED BEHIND R70 — do not start until R70 is on master.** Both tasks edit
`GameState.gd`, and two agents in one file is this project's most reliable way
to lose work. `git log --oneline -5` showing an `R70:` commit is the green light.

## Why this exists

You wrote C48. It found that a No Contest **is not a missing string — it is a
missing fourth result across the whole settlement graph**, which is why J3 D8
kept looking cheap and was not. Your own seam list, with lines:

- the live path maps an empty `winner_side` to a **draw** (`GameState.gd:11319-11323`)
- `_apply_fight_result` defaults a missing result to a **loss** (`:11478`)
- the Grand Prix reads every non-win as an opponent victory and an
  **elimination** (`:8867-8952`)
- the world's watched and auto-resolved paths are win/loss only
  (`WorldPopulation.gd:968-1008`, `:1659-1697`)

So an NC added naively becomes a loss in four places at once. This task is the
build C48 recommended, and C48 is the spec: read
`research/C48_THE_RESULT_THAT_IS_NOT.md` and follow its seam list.

## What to build

C48's own cheapest-honest-build, and nothing wider:

1. **An additive explicit `no_contest` result type.** No winner. No W/L/D
   mutation, no ranking movement, no belt movement — **an NC in a title bout
   never moves the belt.**
2. **Physical mileage is still preserved.** The fight happened to the body
   whatever the record says: damage, mileage and the injury ledger are not
   rolled back. This is the one thing an NC must NOT erase.
3. **`technical_decision`**, which is scored, wrapping the existing card
   outcome rather than replacing it. R38 already ships UD / SD / MD.
4. **Every consumer taught to skip an NC** rather than silently counting it:
   `FightRecordStats.gd`, `CareerEpilogue.gd`, `CareerArc.gd`, `Mileage.gd`,
   `BoutRead.gd`, `PostFightRead.gd`, and the streak logic in
   `WorldPopulation.division_rankings`.
5. **Nothing generates one yet.** C48 says so explicitly and it is the right
   scope: the type exists, is recorded, and is handled everywhere — what
   *causes* an NC (accidental foul, overturn, anti-doping) is a separate stage
   and J3 D9 owns the doping half.

## Owned files

The files C48's seam list names, and only where the list names them.
`GameState.gd` is **14,072 lines — never open it whole**; go straight to the
line windows above and to whatever `grep -n '"draws"'` and
`grep -n _apply_fight_result` return.

```
Godot/scripts/GameState.gd
Godot/scripts/WorldPopulation.gd
Godot/scripts/FightRecordStats.gd
Godot/scripts/CareerEpilogue.gd
Godot/scripts/CareerArc.gd
Godot/scripts/Mileage.gd
Godot/scripts/BoutRead.gd
Godot/scripts/PostFightRead.gd
Godot/assets/data/competition_rulesets_v2.json
Godot/tests/fight_log_test.gd
Godot/tests/bout_read_test.gd
research/C50_DIGEST.md
```

**Not owned:** `Godot/scripts/ChampionshipRead.gd` and
`Godot/scripts/RankingsHubPanel.gd`. An NC must not move a belt — assert that
through the existing reads rather than by editing them.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/WorldPopulation.gd Godot/scripts/FightRecordStats.gd Godot/scripts/CareerEpilogue.gd Godot/scripts/CareerArc.gd Godot/scripts/Mileage.gd Godot/scripts/BoutRead.gd Godot/scripts/PostFightRead.gd Godot/tests/fight_log_test.gd Godot/tests/bout_read_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_log_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/bout_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/championship_read_test.gd
```

Then the full suite once in the background before the commit. Fails=0 or better.

## The one trap

**The three defaults are the danger, not the new type.** Adding
`no_contest` is easy; the bug ships in the places that never asked. An empty
`winner_side` already means draw, a missing result already means loss, and the
Grand Prix already means elimination — so a result that is none of those
inherits whichever default it passes through first. Write a test that puts an
NC through **each** of those three paths and asserts the record is unchanged,
before you write the type.

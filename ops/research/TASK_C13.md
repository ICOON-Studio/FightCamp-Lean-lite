# TASK C13 — THE RANKINGS READ API (Codex)

Model: medium, effort medium, Fast off. Three gaps K15 named, one commit.

## Why

K15's RANKINGS study (`research/K15_DIGEST.md`) rules RANKINGS earns
its own rail item (`ManagementChrome.NAV_ITEMS` forgot a route that already
exists) and lists three GameState gaps to confirm before the build starts:
movement since last week (↑/↓/—), an OUR marker on ranking rows, and a
focused-fighter division helper so the board can open on THE DIVISION
without four pickers. This task delivers exactly those three; the RANKINGS
build itself is Claude's and is not started.

## Deliver in `Godot/scripts/GameState.gd` / `WorldPopulation.gd`

1. **`is_ours: bool`** added to every entry `get_division_rankings`
   (`GameState.gd:9262`, entries built by `WorldPopulation._board_entry`,
   `WorldPopulation.gd:1035`) and `get_p4p_rankings` (`GameState.gd:9267`,
   entries built inline at `WorldPopulation.gd:1059`) return — true when the
   entry's `id` is one of `get_roster()`'s athlete ids, false for a pure
   world athlete. Add the key; do not rename or remove an existing one.
2. **Movement since last week.** Add `"movement": <int|null>` to the same
   entries: the change in rank position (1 = top) since the prior week's
   board for that exact division key (discipline+weight_class+sex) or P4P
   list, positive = moved up. Persist last week's ordered id list per board
   in the career save (a new key under `simulation_world`, alongside
   `championships` — `WorldPopulation.ensure_championships` at
   `WorldPopulation.gd:833` is the pattern to follow for lazy-init on old
   saves) and refresh it once per `advance_week()` (`GameState.gd:4792`).
   An id with no prior-week entry (new to the board, or no snapshot exists
   yet — first week on an old save) reports `movement: null`. Never invent
   a number.
3. **`get_focused_division(athlete_id: String) -> Dictionary`** — reads
   that roster athlete's own `primary_discipline`/`discipline`,
   `weight_class` and sex (same `athlete_sex()` helper `WorldPopulation.gd`
   uses) and returns `{"discipline", "weight_class", "sex"}`. Empty `{}`
   for an unknown id or an empty roster. This is what RANKINGS opens on
   for the profile's focused fighter — no new stat, just a projection of
   fields that already exist on the athlete dict.

## Rules

- #1 and #3 are pure reads. #2 needs exactly one new persisted field (the
  prior-week snapshot); no other save data changes, no schema version bump
  — an old save without the key simply has no prior week, so its first
  read is `movement: null` across the board, which is correct, not a
  migration.
- No screens, no rail item, no new `SceneRouter` route. `RankingsBoard.gd`
  is discarded, not touched — the RANKINGS build is a later Claude stage.
- Snapshot storage must not affect `get_championships()`,
  `get_champion_superfight_offers()`, or any other existing reader of
  `simulation_world`.

## Owned files

- `Godot/scripts/GameState.gd`
- `Godot/scripts/WorldPopulation.gd`
- NEW `Godot/tests/rankings_api_test.gd`

Nothing else.

## Parse gate, before any test run

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/WorldPopulation.gd Godot/tests/rankings_api_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_api_test.gd
```

Cover: a roster fighter's entry carries `is_ours: true` and a world
athlete's does not; first read after a fresh career has `movement: null`
for everyone; calling `advance_week()` twice with a synthetic rank change
between them (swap two athletes' `ranking_points`) produces a non-null
movement that matches the direction of the swap; `get_focused_division`
on a real roster id matches that athlete's own fields and on an unknown
id returns `{}`.

Then `smoke_test.gd`, then the full suite once before the commit (Git
Bash, from `Godot/`, `GODOT` = the console exe path): `for f in
tests/*.gd; do timeout 600 "$GODOT" --headless --path . --script "$f"
>/dev/null 2>&1 || echo "FAIL rc=$? $f"; done`. If the wrapper detaches
and cannot return a trustworthy summary (C12's note), say so plainly in
the digest rather than claiming a suite result you do not have — parser +
focused + smoke passing is enough to land on, same as C12.

## Finish

Check `git status -s` first, `git add -- <your files>` only, one commit,
push `master`, then append your own `HANDOFF.md` block (max 8 lines,
never rewrite anyone else's) and write `research/C13_DIGEST.md`.

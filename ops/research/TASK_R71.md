# TASK R71 — THE HONOURS READ (claude)

Model: top tier, effort **high**, Fast off. One session. Runs in parallel with
G22 and U13; Claude is also the splicer for G22.

## Why this exists

R70 retired the world titles this game should never have created and moved them,
whole, into `simulation_world.retired_championships` — holder, reign and
defences intact, `title_status: "retired"`, `retired_reason: "event_discipline"`.
It shipped `GameState.get_retired_championships()` to read them.

**That read has exactly one reference in the codebase: its own definition.** A
fighter who really held the judo world title for forty weeks has an invisible
career, and the only honours surface the game has is one gold chip built from
`get_athlete_titles()` at `DevelopmentPanel.gd:405-407`.

This task is the seam between the record and the screen.

## What to build

`GameState.get_athlete_honours(athlete_id: String) -> Array` — one copy-safe
read that answers "what has this fighter won", across both tables, for roster
and world athletes alike.

It spends **`TitleHonours.gd`**, the pure module G22 is writing to the contract
below. Do not reimplement that composition here and do not copy it: this
function gathers the two dictionaries, hands them over, and returns the result
isolated.

- Take the isolated-copy discipline the other championship reads use. Look at
  `get_championships_read()` — it holds ONE `career.duplicate(true)` across the
  whole read because the championship accessors perform save migration on
  demand, and asking a screen question must never land those maintenance writes
  in the live Career. Same guarantee here, and one copy, not two.
- `get_retired_championships()` and `get_championships()` are the two sources.
  Both already run `ensure_championships`.
- Return `.duplicate(true)`.
- No active career → `[]`.

## The contract (identical in G22 and U13 — do not drift from it)

`TitleHonours.rows(athlete_id: String, championships: Dictionary, retired: Dictionary, current_week: int) -> Array`
returns rows sorted held → interim → retired, `since_week` descending inside
each, ties by `key` ascending. Each row carries exactly:

`key`, `discipline`, `weight_class`, `sex`, `standing` (`"held"` / `"interim"` /
`"retired"`), `label`, `since_week` (int), `defenses` (int), `weeks_held` (int),
`weeks_held_source` (`"counted"` / `"absent"`), `organization_id`,
`retired_reason`.

`TitleHonours.summary(rows: Array) -> Dictionary` returns `held`, `interim`,
`retired` (ints) and `chip` — `""`, `"CHAMPION"`, `"CHAMPION ×N"`,
`"INTERIM CHAMPION"`, `"RETIRED TITLE"` or `"RETIRED TITLE ×N"`.

`weeks_held` is **always 0** and `weeks_held_source` **always `"absent"`** on a
retired row: R70 deliberately stamped no retirement week, so the game does not
know when that reign ended and must not derive a length from `since_week`.

## Owned files

```
Godot/scripts/GameState.gd
Godot/tests/athlete_honours_test.gd
research/R71_DIGEST.md
```

**Not owned:** `Godot/scripts/TitleHonours.gd` (G22),
`Godot/scripts/DevelopmentPanel.gd` (U13), `Godot/scripts/WorldPopulation.gd`,
`Godot/scripts/ChampionshipRead.gd`.

`GameState.gd` is **14,134 lines — never open it whole.** The window you want is
`sed -n '10455,10530p'` — `get_championships()` at `:10455`,
`get_retired_championships()` at `:10473`; `get_athlete_titles()` and
`get_championships_read()` sit just below. Re-find with
`grep -n 'func get_retired_championships' Godot/scripts/GameState.gd` if it has
drifted — Codex is landing C51 in this same file.

## Sequencing, stated honestly

G22 delivers `TitleHonours.gd` and its own test. This task's read cannot pass a
parse gate until that module is on `master`, so:

1. Write the read and its test now, against the contract above.
2. When G22 lands, splice it, run `title_honours_test.gd` and
   `athlete_honours_test.gd`, then the full suite.
3. If G22's module disagrees with the contract, **the contract wins** and
   Claude fixes the module rather than bending the read — an unseen test on
   either side was written from the contract, not from anyone's code.

## The trap

**A retired title must never re-enter the standings through this read.** The
whole point of R70's shape is that `championships` is the only table any
booking, settlement, interim or double-champ path consults, and a retired row
lives outside it. This function reads both tables and must therefore be the one
place that is careful: it returns rows for a SCREEN, and nothing it returns may
be written back, counted as held, or handed to a path that books a fight.

Second trap: R70's board chips are built from the belt keys themselves, so
nothing here may add a key to `championships` — not even transiently inside the
isolated copy — or a discipline chip reappears over an empty board.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/athlete_honours_test.gd Godot/scripts/TitleHonours.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/athlete_honours_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/title_honours_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/championship_read_test.gd
```

Then the full suite once in the background before the commit. Fails=0 or better.

# TASK C14 — THE CREATION READ API (Codex)

Model: medium, effort medium, Fast off. Read-only, one commit.

## Why

R28 rebuilds career creation on Kalli's K13 study (`K13_DIGEST.md`): ONE flow
under a new CreationChrome, COUNTRY → CITY → GYM, with a committed trail. The
data it needs exists but is scattered across six getters plus a file the
screen parses itself, and **none of it has ever been read without a career**.

`CountryMap.gd` (252) parses its own country JSON for map polygons and then
calls `get_country_data` (`GameState.gd:194`) and
`get_country_combat_profile` (`:198`) per hover. `CityScreen.gd` (404) reads
`get_country_data` again, builds cities by hand, and calls
`generate_starter_boxing_floor` (`:2889`) at the moment the player types a
name. `GymHub.gd` (156) is a post-save confirmation stub that reads live
career state. R28 deletes all three, and it should ask GameState once per
step instead of assembling this itself.

The critical property is **pre-career purity**: every read here runs with
`career` EMPTY, before `finalize_new_career` (`:2542`) exists to save
anything. Anything that assumes an active career is a crash on the first
screen of a new game.

## Deliver, in `Godot/scripts/GameState.gd` (append at the end only)

1. **`get_creation_markets() -> Array`** — one row per country in
   `world_regions` (`:153`, loaded at `:175`), each carrying what K13's
   COUNTRY board draws: `country`, `economy`, `talent_depth`,
   `combat_popularity`, the specialty disciplines with their values (the
   labels through `world_discipline_label`), `city_count`, `gym_count`. Sort
   by country name so the board's order is stable between runs. No map
   geometry: the polygons stay with whatever draws a map.
2. **`get_creation_city_board(country_name) -> Dictionary`** — the country's
   header numbers plus a `cities` array. Per city: `city`, `rival_gyms`
   (count and the two or three names K13's CITY board shows),
   `organizations`, `events` — from `get_rival_gyms` (`:289`),
   `get_world_organizations` (`:584`) and `get_world_events` (`:658`),
   filtered to that city where those APIs support it. An unknown country
   returns `{}`.
3. **`get_creation_gym_take(country_name, city_name, gym_name) -> Dictionary`**
   — the exact gym the player would open: `starter_floor` from
   `generate_starter_boxing_floor(gym_name)` (`:2889`), the starter roster
   take from `generate_starter_boxing_roster(gym_name)` (`:3210`) reduced to
   what a silhouette row needs (name, age, primary discipline, record),
   `starting_cash` (`STARTING_CASH`, `:75`), the floor's used/total space and
   its weekly upkeep. Both generators are seeded by
   `hash("...|" + seed_key)`, so **the preview must be the same gym the save
   gets**: use the gym name as the key, exactly as `finalize_new_career`
   does, and say so in the digest.
4. **`Godot/tests/creation_api_test.gd`** — the three reads with `career`
   EMPTY (assert `has_active_career()` is false throughout), an unknown
   country, an empty gym name, and the one that matters: the previewed floor
   and roster are IDENTICAL to what a real `begin_new_career` +
   `finalize_new_career` produces for the same name.

## Rules

- **Read-only.** No writes, no new save fields, no migration, and nothing
  that begins or finalizes a career. R28 owns the writes and they already
  exist.
- **No career required, and no career touched.** If any path needs a Career
  copy, use the disposable-copy pattern C4-C12 established.
- Do not change `finalize_new_career`, the generators, or `world_regions`
  loading. If a generator turns out to mutate state, report it rather than
  fixing it here.
- Names and numbers are the world data's. Invent no market that
  `world_regions` does not carry.

## Owned files

- `Godot/scripts/GameState.gd` (append at the end only)
- NEW `Godot/tests/creation_api_test.gd`

Nothing else. R28 owns the screens and is not started.

## Parse gate, before any test run

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/creation_api_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/creation_api_test.gd
```

Then `smoke_test.gd`, then the full suite once before the commit (Git Bash,
from `Godot/`, `GODOT` = the console exe):
`for f in tests/*.gd; do timeout 600 "$GODOT" --headless --path . --script "$f" >/dev/null 2>&1 || echo "FAIL rc=$? $f"; done`.
It is 122 files and takes about eight minutes; the suite was green at
`bedae1f`.

## Finish

Check `git status -s` first, `git add -- <your files>` only, one commit, push
`master`, then convert your `HANDOFF.md` block to COMPLETE with the hash (max
8 lines) and write `research/C14_DIGEST.md`.

`HANDOFF.md` has mixed line endings. Append your block without reformatting
anyone else's, and never rewrite another agent's block.

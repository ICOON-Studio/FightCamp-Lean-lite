# TASK R68 — THE BELT HAS A PROMOTION (claude)

Model: top tier, effort high, Fast off. One session.

Operator decision 2026-09-08, taken off R67's recovered mail: the CHAMPIONS
board must show only the most popular promotion's belts, and reach every other
promotion's through a filter.

## Why this exists

Two things, and they turn out to be one thing.

**The regression.** `get_championships_read()` built contenders for EVERY belt
in the world by swapping in a fresh `career.duplicate(true)` per belt — 58
copies to draw eight. Cursor measured it at 520 ms against 129 ms for the eight
singular calls it replaced, reproduced three times, and reported it on a branch
`inbox` could not see. `get_championships()` under it is 0.3 ms, so the whole
cost was the copying.

**The gap.** A belt was `discipline|weight|sex` and nothing sanctioned it, so no
screen could say WHOSE title it was. The organizations table already carries
`disciplines`, `discipline_weights`, `tier` and `reputation` — everything
needed — and nothing read them for this.

Scoping the read needs a scope worth having, and "the promotion you have heard
of" is that scope.

## What to build

1. **`WorldPopulation`**: `promotions_by_standing()` (tier, then reputation,
   then id — total and deterministic) and `sanctioning_organization_id()`.
   Stamp `organization_id` on every belt at seed AND by migration, once, never
   overwritten. A discipline no promotion runs stamps `""` — a recorded answer.
2. **`ChampionshipRead`**: an `organization` block on every row, with its own
   `source` so "no promotion runs kickboxing here" does not read as a missing
   name. Plus `contenders_loaded`, because an empty `contenders` array must not
   mean both "nobody is ranked" and "you did not ask".
3. **`GameState`**: `get_championships_read(scope)` — ONE copy, contenders only
   for the scope, every belt row still returned. `get_promotions_read()`.
4. **`RankingsHubPanel`**: a promotion strip above the discipline strip,
   defaulting to rank 1; the discipline chips become that promotion's belts.

## The traps

- **Every belt ROW must still come back** whatever the scope. The chips are
  built from them; a board that cannot see what it is not showing cannot offer
  to show it.
- **A scope matching nothing looks identical to no scope** unless the read says
  which it was. Pass the flag; do not infer it from an empty dictionary.
- Additive only. No existing read key changes name, type or meaning (R62).

## Owned files

```
Godot/scripts/WorldPopulation.gd
Godot/scripts/ChampionshipRead.gd
Godot/scripts/GameState.gd
Godot/scripts/RankingsHubPanel.gd
Godot/scripts/BeltLineage.gd
Godot/tests/championship_read_test.gd
Godot/tests/rankings_hub_panel_test.gd
Godot/tests/belt_lineage_test.gd
research/R68_DIGEST.md
```

`GameState.gd` is **13,900+ lines — never open it whole.** The championship
reads are one window: `sed -n '10515,10620p'`.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/WorldPopulation.gd Godot/scripts/ChampionshipRead.gd Godot/scripts/GameState.gd Godot/scripts/RankingsHubPanel.gd Godot/scripts/BeltLineage.gd Godot/tests/championship_read_test.gd Godot/tests/rankings_hub_panel_test.gd Godot/tests/belt_lineage_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/championship_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/rankings_hub_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/belt_lineage_test.gd
```

Then the full suite once, in the background, before the commit. Fails=0 or
better.

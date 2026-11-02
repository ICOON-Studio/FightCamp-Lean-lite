# TASK U5 — CURSOR — THE BELT BOARD, ONE READ

Model: top tier, effort **high**, Fast off. One session, one branch.

You own `Godot/scripts/RankingsHubPanel.gd` and its test. Nobody else touches
that file this cycle.

## Why this exists

`get_championships_read()` (`GameState.gd:10408`) returns EVERY belt in the
game in one pass through `ChampionshipRead.build_many()`. It was built by C26,
it is tested by `Godot/tests/championship_read_test.gd`, and it has **zero
callers outside `Godot/tests/`**.

Meanwhile the CHAMPIONS tab calls the SINGULAR read once per weight class:

```
RankingsHubPanel.gd:158   # get_championship_read() deep-copies the whole career twice per call
RankingsHubPanel.gd:162   if tab == "champions" and game_state != null and ...
RankingsHubPanel.gd:164       _belt_reads[str(belt_weight)] = _dict(game_state.get_championship_read(...))
```

`WEIGHT_CLASSES` (`:65`) is eight entries, so opening one tab is eight builds
and sixteen deep copies of the career. The file's own comment at `:158` already
says this is the cost. The plural read pays it once.

## Owned files

- `Godot/scripts/RankingsHubPanel.gd` (952 lines — read it whole, it is small
  enough). Anchors: `rebuild:127`, the loop at `:158-164`,
  `_build_champions:427`, `_belt_entry:469`, `_belt_mark:540`,
  `_holder_band:621`, `_vacancy_text:679`, `contract_for_test:831`,
  `_belt_entries_for_test:862`.
- `Godot/tests/rankings_hub_panel_test.gd`.

Read `Godot/scripts/ChampionshipRead.gd` (219 lines) whole — it is the shape of
every row you receive. `empty()` at `:7` is the complete key list.

## The work

**1. One call.** Replace the per-class loop with a single
`get_championships_read()` and key the resulting array by weight class for the
current discipline and sex. Behaviour on screen must not change from this
alone — same belts, same order, same marks. `_belt_entries_for_test()` is the
proof and must keep passing unchanged.

**2. What one call makes possible.** The plural read is the whole board, so the
board can finally say things a per-belt read never could. Spend
`Godot/scripts/BeltLineage.gd` for this — Grok's G15 module, pure statics, no
preloads:

- `BeltLineage.reign(row, current_week)` → weeks held, defence count, weeks
  since the last defence, and an `unknown` list.
- `BeltLineage.board(rows, current_week)` → the longest current reign, the most
  defences, the newest champion, the vacant count.

**If `BeltLineage.gd` is not on master when you start, ship part 1 alone and
say so in your digest.** Do not write your own copy of it.

**3. The honest empties.** A belt with `since_week: 0` has no reign to state —
print nothing, never "0 WEEKS". `vacancy_reason.source == "absent"` already
means the save does not record why a belt is vacant (`ChampionshipRead.gd:58`);
that stays absent and `_vacancy_text:679` keeps its wording.

## Refusals

- No new UIKit factory, no new token, no new tab.
- Never infer a lineage. The save has no title-history array: who took the belt
  from whom is NOT knowable and may not be printed.
- No projection, no "dominant", no "weak era", no ranking of champions by
  anything the read did not hand you.
- Do not touch `GameState.gd`, `ChampionshipRead.gd` or any other panel.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/RankingsHubPanel.gd
```

Then, from `Godot/`:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/rankings_hub_panel_test.gd
```

plus `tests/championship_read_test.gd` and `tests/rankings_api_test.gd`, then
the full suite once in the background before the commit.

## The trap

`rebuild()` runs on every redraw and every tab switch. The plural read is one
call but it is not free — take it ONCE per rebuild into `_championships` /
`_belt_reads` the way the singular read is taken today, and never inside
`_belt_entry()` or any per-row builder. A read in a row builder is eight calls
again with extra steps.

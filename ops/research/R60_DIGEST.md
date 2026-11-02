# R60 DIGEST — THE BODY HEALS AT SIX SPEEDS

The six regions now heal at different speeds, and **not one heal rate was
invented**. J12 D1 refuses a per-region rate — the literature does not carry
one — so the difference comes from the injuries the regions are already
carrying. A torn ligament and a bruise cap their region differently because
their own graded dates say different things, which makes the difference
exactly as sourced as Q2's ladders are.

## What changed

**`BodyReadiness.region_ceiling(athlete, region, current_week) -> int`** —
derived from the stored injury every time it is asked, never stored. Before
`train_week`: the amber threshold (60). From `train_week` to `compete_week`:
that region's `competition_threshold()`. From `compete_week`: 100, and
`resolve_due_injuries` removes the injury on the weekly pass anyway. No injury,
or no week, returns 100.

**`region_ceiling_reason(...) -> String`** — `""`,
`"injury_pre_training"` or `"injury_pre_competition"`. Ids, never words:
`InjuryWords` (Q3) and `RecoveryWords` (Q4) own every string a player reads.

**`_apply_recovery`** takes the week from `context` (already present at every
caller via `_body_activity_context`) and clamps through `_raise_capped`. The
LOAD path in `apply_activity` is untouched — training damage is not healing,
and a ceiling must never push a number up.

**`forecast_weeks_to_training`** carries the ceiling through the simulation, so
the gym's estimate stops promising green before the injury allows it. One
guard added: a caller that passed no `current_week` keeps the old behaviour
rather than being capped against absolute injury dates by a synthesised
week 1..52.

**`GameState.gd`** — the status auto-clear gains one condition: a live injury
on any region holds `injured`. Fatigue and readiness are unchanged. And
`_body_read()`'s region rows gain `ceiling` and `ceiling_reason`.

**`body_readiness_rules.json` is unchanged.** The stage needed no new constant,
which is the point: the ceiling is two thresholds that already existed applied
on dates that already existed.

## The trap, and the test that holds it

A ceiling is not a floor. The obvious `mini(value, ceiling)` drags a region
DOWN the moment an injury is named on an already-healthy one, wiping condition
the fighter earned before the bout. `_raise_capped` clamps only the amount
being ADDED: a region at 95 that gets diagnosed still reads 95 and simply
stops climbing. `_test_r60_a_ceiling_is_not_a_floor` asserts exactly that.

`_test_r60_an_uninjured_region_is_untouched` asserts the literal pre-R60 value
(51 for an 80-conditioning rest week), so a regression in the untouched path is
loud rather than subtle.

## Two things worth knowing

**An UNKNOWN-graded injury caps nothing.** It carries no dates, and inventing a
week to cap against would launder a guess into the save. It is live, it is
named, and it does not move the number.

**`get_athlete()` returns a copy; the roster row is the live object.** The
integration test asserts on the roster row — an athlete can also leave the gym
between weeks, which empties an id lookup mid-test. Retention does not read
`status` or `injured`, so the honest flag does not drive departures.

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_readiness_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_readiness_integration_test.gd
```

`body_readiness_test` 0 failures (4 new R60 groups), `body_read_test` 46 checks
0 failures (was 40), `body_readiness_integration_test` 0 failures (1 new group).

## What R60 does NOT do

No screen work — U9 owns `ProfileRevampPanel.gd` and now has `ceiling` and
`ceiling_reason` waiting for it. No second clock:
`medical_hold_until_week` remains the one medical clock. No age anywhere
(J12 D4/D9, J13, closed). No words.

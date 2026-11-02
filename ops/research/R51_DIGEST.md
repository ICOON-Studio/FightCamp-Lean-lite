# R51 — THE YEARS TURN (digest)

**R51a** landed first (commit `9998f86`): `Godot/scripts/Aging.gd`, the one
age curve, pushed ahead of its own pass so C34 was unblocked.

**R51b** is the pass that consumes it. A fighter on the player's roster now
gets older, and a career can end.

## What landed

- `_advance_aging(career_week, overrides)` — one pass a week in
  `advance_week()`, beside `_advance_ambitions` / `_advance_career_goals`.
  Deliberately NOT in `_advance_daily_systems`: a birthday is a week, not a
  seventh of one, and this pass draws no dice for the daily scale to spread.
- `_apply_birthday()` — the age moves one year, `Aging.year_step()` returns
  the deltas already clamped, and this applies them blindly. Potential erodes
  past the peak and never rises. `athlete["aging"]` records the band and what
  the last year cost.
- Headlines are rationed: a routine birthday is silent, a band change
  (entering or leaving the peak years) and ages 30 / 35 / 40 get one line.
- **The ask.** Over `AGING_RETIRE_PRESSURE_LINE` (62) a fighter raises a
  `retire` request and the player answers GRANT or DECLINE. Nobody leaves the
  roster without the desk seeing the ask. Deliberately outside
  `max_open_per_gym` — dropping the ask would retire someone silently.
- `_retire_athlete()` — the shape of `_transfer_athlete_to_rival()`, minus a
  gym to go to: off the roster, into the world population with
  `status: "retired"`. **That makes the two dead `status == "retired"`
  opponent filters (`GameState.gd:5519`, `:5691`) mean something for the
  first time.** `career["retirements"]` keeps the record; `get_retirements()`
  reads it.
- `get_aging_read(athlete_id)` — band, peak window, years to/past it, weeks to
  the next birthday, what the last year cost, what the next one will cost, and
  the pressure against the line. No screen, no factory, no token this stage.
- `assets/data/fighter_requests.json` — one new `retire` definition (kind
  `retire`, actions grant / decline). It has no `trigger_holds` branch, so the
  random weekly roll can never raise it: only the aging pass does.

## Guarantees held

- **No RNG.** The birthday is derived from the id, the ask fires on a
  threshold. No seeded stream anywhere else shifts, so no fight outcome
  changes because this stage exists.
- **No save migration.** Every new key defaults to absent; a fighter with no
  `age` recorded is left alone rather than started at 1.
- `WorldPopulation.gd` untouched — the world's side of the same curve is C34.

## Still authored, still unsourced

Every constant in `Aging.gd` and the pressure line here is AUTHORED and
graded UNKNOWN pending **J10**. Replace them wholesale when the study lands
rather than nudging them.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/aging_test.gd
```

70 checks, 0 failures (35 for the module, 35 for the pass).
`fighter_requests_test.gd` was updated for the eighth request definition.

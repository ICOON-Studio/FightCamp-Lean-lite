# TASK C26 — THE CHAMPIONSHIP READ API (Codex)

**Status: COMPLETE 2026-09-06 (`c320496`), Q8 fixed. Depends on R41, which is on `master`** —
`title_status`, `is_title_bout` and the interim fields exist; read the contract
below against the real files before you start.

Model: Sonnet, effort medium, Fast off. This is the C4 / C7 / C19 / C20 / C23 /
C24 / C25 pattern for the eighth time: one read, no writes, no UI, honest
empties.

## Why this exists

R41 landed this morning and changed what a belt IS. A title bout is now a flag
written when the bout is **booked** (`is_title_bout`), not a fact discovered
from its result, and every belt carries
`title_status ∈ {vacant, champion, interim}`. While a recognised champion is
held out past the authored window, the division carries an **interim** holder
on the same belt entry — `interim_holder_id`, `interim_holder_name`,
`interim_since_week` — which is consumed by unification the moment the champion
fights for the belt again (`unified_week`).

**Nothing can ask for any of it.** `get_championships()`
(`GameState.gd:9479`) returns the raw dictionary keyed by
`"<discipline>|<weight class>|<sex>"`, so every screen that wants a division's
belt splits that key itself, looks the holder up itself, and has no idea what
`title_status` means. `get_athlete_titles()` (`:9549`) already decorates a
fighter's own belts — **use it, do not re-derive it**, and do not re-break
two-division on `get_athlete_title()` (`:9531`, first belt found).

One read, the way C24 did it for organizations. **It never moves a belt and
never decides one**: every value it returns is already stored.

## What to build

In `Godot/scripts/GameState.gd`, in the read-API region alongside the other
`get_*_read` functions:

```gdscript
func get_championship_read(division_key: String) -> Dictionary
func get_championships_read() -> Array
```

`get_championship_read` takes a belt key (`"boxing|Lightweight|male"`) and
returns:

| Key | Type | Meaning |
|-----|------|---------|
| `key` | String | Echoed back. `""` and an otherwise-empty read for an unknown key — never a guess. |
| `discipline` / `weight_class` / `sex` | String | The key, split once, here, so no screen splits it again. |
| `division_label` | String | The line a screen prints: `"Men's Lightweight — Boxing"`. Built from the parts, never stored. |
| `title_status` | String | `vacant` / `champion` / `interim`, straight from the belt. A belt from a save with no status has already been migrated by `ensure_championships()` — do not migrate it again. |
| `holder` | Dictionary | `{"id", "name", "record", "ranking_points", "is_ours": bool}` for the recognised champion, `{}` when the belt is vacant. `is_ours` is true when the id is on the player's roster. |
| `interim_holder` | Dictionary | Same shape, `{}` unless `title_status == "interim"`. **Never** presented as the champion. |
| `is_interim` | bool | Convenience, and the one flag a screen needs to know not to print two champions. |
| `champion_unavailable_weeks` | int | Weeks the recognised champion is still held out (`WorldPopulation.hold_weeks_left`). `0` when he is bookable. This is the only honest reason an interim exists. |
| `since_week` / `last_defended_week` / `defenses` | int | The reign, exactly as stored. `defenses` is trustworthy for the first time — R41 stopped counting ordinary bouts as defences. |
| `vacated_by` / `vacated_week` | String / int | R7's record of who gave the belt up. `""` / `0` when nobody did. |
| `unified_week` | int | The week an interim was last consumed; `0` when none ever was. |
| `contenders` | Array | The division's top five from `get_division_rankings()`, `{"id", "name", "rank", "ranking_points", "is_ours"}` — **call it, do not re-rank.** |

`get_championships_read()` returns one row per belt, newest capture first, and
must not be a loop of full reads if that costs a screen a visible pause — one
pass over `get_championships()` is enough.

Plus the one question the calendar now has an answer to and no way to ask:

```gdscript
func get_bout_title_stakes(event_id: String, bout_index: int) -> Dictionary
```

Returns `{"is_title_bout": bool, "stamped": bool, "key": String,
"division_label": String, "for_interim": bool, "unification": bool}`.
**`stamped` is the honest one**: an announced open slot has no second name yet
and carries no flag, and a card from a save written before R41 carries none
either. `stamped == false` means *nobody has decided yet* — it does **not**
mean "not a title bout", and the read must never flatten it to `false`.

## Rules

- **Read only.** No writes to `GameState`, no mutation of anything handed in or
  returned by an accessor, no belt moved, no interim created, no status
  decided. If a value is not already stored, it is not yours to compute — the
  one exception is the labels and `contenders`, which are assembled from reads.
- **Honest empties.** An unknown key, a division with no belt (the engine
  refuses to seed one behind fewer than three fighters), a vacant belt, a bout
  index that does not exist: all return an empty-but-shaped dict, never
  `null`, never an invented champion, never an error string as data.
- **No UI**, no scene edits, no new autoload.
- No real federation's or official's name anywhere in the output (J1 §4.1).
- `GameState.gd` is ~8k lines. **Never read it whole.** Work from the anchors.

## Anchors

- `Godot/scripts/GameState.gd:9479` `get_championships`, `:9491`
  `get_division_rankings`, `:9531` `get_athlete_title`, `:9549`
  `get_athlete_titles`.
- `Godot/scripts/WorldPopulation.gd` — `division_key`, `TITLE_STATUS_*`,
  `hold_weeks_left`, `may_crown_interim`, `apply_title_logic`, `vacate_title`.
- `Godot/assets/data/championship_rules.json` — the interim window.
- `Godot/scripts/PostFightRead.gd` — C23's module shape, if you split this out
  the way C23/C25 did.
- `research/TASK_R41.md` — what the flag means and why.

## Parse gate (before any test run)

```bash
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd
```

(plus any new module file you add)

## Tests

New `Godot/tests/championship_read_test.gd`:

| ID | Assertion |
|----|-----------|
| Q1 | A seeded belt reads `champion`, names its holder, splits its key, and its `defenses` match the stored reign |
| Q2 | An unknown key returns an empty-but-shaped read — no crash, no invented champion |
| Q3 | A held-out champion with an interim reads `is_interim`, names BOTH, and never presents the interim as the champion |
| Q4 | `champion_unavailable_weeks` is 0 for a bookable champion and matches the hold otherwise |
| Q5 | A vacated belt carries `vacated_by` / `vacated_week`; one with no successor reads `vacant` with an empty holder |
| Q6 | `contenders` comes from the division rankings and flags the player's own fighters with `is_ours` |
| Q7 | An unstamped bout reads `stamped == false` and is **not** flattened to `is_title_bout == false`; a stamped one reads its real flag |
| Q8 | The read moves nothing: championships, rankings and every athlete are byte-identical before and after |

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/championship_read_test.gd
```

Then `title_flag_test.gd`, `titles_rankings_test.gd` and `rankings_api_test.gd`
must pass **unchanged**. Full suite once before the commit.

## Owned files

```
Godot/scripts/GameState.gd            (the read region only)
Godot/scripts/ChampionshipRead.gd     (new, if you split it out)
Godot/tests/championship_read_test.gd (new)
```

Claude owns `WorldPopulation.gd` and the settlement region of `GameState.gd`
this cycle (R43, the purse). **Stay out of both.** Check `git status -s` before
staging, and push `master` when the suite is green — do not wait to be asked.

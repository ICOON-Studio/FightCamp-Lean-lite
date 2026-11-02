# TASK R41 — THE TITLE BOUT IS A DECISION, NOT AN ACCIDENT (Claude)

**Status: COMPLETE 2026-09-06.** Greenlit by the operator 2026-09-06. J3 priority rank 2.
No dependency on any other agent — runs while Codex holds C25.

Model: Opus, effort high, Fast off. It edits `GameState.gd` and
`WorldPopulation.gd`, and it touches saved career state.

## The bug, exactly

`WorldPopulation.apply_title_logic()` (`WorldPopulation.gd:936-963`) decides
after the fact whether a fight was for a belt:

```gdscript
if holder_id != winner_id and holder_id != loser_id:
    return false
```

**That is the whole test.** If the champion is one of the two names, the belt
moves. A Grand Prix quarter-final, a short-notice replacement bout, a catchweight
one-off — every one of them takes the title if the holder loses it, and every one
of them counts as a title defence if he wins. `WorldPopulation.gd:837` then
writes `bout["title_fight"] = apply_title_logic(...)`, so the bout is *declared*
a title fight by its own result. Nothing anywhere in `Godot/scripts/` contains
`is_title_bout`, `title_status` or `interim` — verified 2026-09-06.

J3 D1: a title bout is a **flag on the bout**, not "whoever shares a cage with
the holder". J3 D2: interim exists as a real published object (WBC Rule 1.27,
IBF Rule 17, UFC practice) with **zero** game state.

## What to build

### Stage A — the flag

`is_title_bout` is set when the bout is **booked**, and read at settlement.

- Stamp it on the bout/offer record at creation, the way R39 stamps the ruleset
  (`WorldPopulation.merge_real_organizations` is the pattern; read how the
  ruleset stamp rides the bout and copy its shape).
- `apply_title_logic()` gains the flag as its authority. The holder-is-present
  check stays as a **guard** — a bout flagged as a title bout between two
  non-holders is a data error and must return false, not invent a champion.
- `bout["title_fight"]` stops being an output of the result and becomes an echo
  of the input.

**Legacy saves are the main case.** A bout already on a player's calendar has no
flag. Do NOT retroactively strip a scheduled title fight: an unstamped bout
falls back to today's behaviour exactly once (holder present → title bout), the
same fallback R39 used for unstamped events. New bookings always carry the flag.
Say this in the code comment, not just here.

### Stage B — `title_status`

`title_status ∈ {vacant, champion, interim}` on the championship dict.

- `ensure_championships()` (`:879`) and the migration at `:912-929` are where
  existing saves get theirs: a belt with a holder becomes `champion`, a belt
  without one becomes `vacant`. No belt changes hands during migration.
- An interim belt is created **only** when the holder is unavailable past a
  data-authored window — and the unavailability the game already has is the
  medical hold (`BodyReadiness.medical_hold_until_week`). Do not author a new
  reason and do not invent the window inline: it goes in data with the rest of
  the championship rules.
- On the holder's return: a **unification bout**. The interim is consumed —
  elevated or beaten — and is never a second keepable belt (J3 Q3). An interim
  holder who beats the returning champion becomes the champion; there is not
  then an interim and a champion in one division.
- `vacate_title()` (`:974`) already hands a surrendered belt to the best
  remaining contender (R7). It now has to say which status it leaves behind.

### Out of scope, deliberately

- **Belt-on-the-scale** (a title does not change hands unless both made the
  contracted weight, J3 Q9 / D11) is J3 rank **3** and is one rule on top of
  this flag. It is R42. Do not fold it in.
- Org-scoped belt keys, mandatories, rankings formulas, the boxing alphabet
  (J3 D3/D4/D5 — scenery or later research).
- No UI. `RankingsHubPanel` and the profile read whatever the accessors return;
  a later stage dresses interim.

## Rules

- Additive to the save. Every field defaults so an untouched save loads and
  plays identically, and no belt moves on migration. This is the R39 contract.
- No invented durations. If the interim window needs a number, it is authored
  in `Godot/assets/data/` next to the other championship rules with a comment
  saying it is a game rule, not a real federation's published one.
- `get_athlete_titles()` (`GameState.gd:9501`, plural) already exists — G4
  landed. Use it; do not re-derive a fighter's belts, and do not re-break
  two-division on `get_athlete_title()` (`:9483`, first belt found).
- No real federation's name attached to an invented rule (J1 §4.1).

## Anchors

- `Godot/scripts/WorldPopulation.gd:879` `ensure_championships`, `:912-929` the
  championship migration, `:936-963` `apply_title_logic`, `:974` `vacate_title`,
  `:837` and `:1194` the two world-side callers.
- `Godot/scripts/GameState.gd:10268,10270` the Career-side callers,
  `:9431` `get_championships`, `:9483` `get_athlete_title`,
  `:9501` `get_athlete_titles`, `:9524` `get_champion_superfight_offers`.
- `Godot/scripts/BodyReadiness.gd:34-43,118` the medical hold that is the only
  honest source of "the champion is unavailable".
- `research/J3_THE_DECISION_QUEUE.md` — D1, D2, D3, the Area 1 anchor
  table, and Q1/Q2/Q3/Q9.
- `Godot/tests/titles_rankings_test.gd` — the contracts already frozen. R41
  must agree with them and must not restate them.

## Parse gate (before any test run)

```bash
python Godot/tools/check_scripts.py Godot/scripts/WorldPopulation.gd Godot/scripts/GameState.gd
```

## Tests

New `Godot/tests/title_flag_test.gd`:

| ID | Assertion |
|----|-----------|
| T1 | A bout flagged `is_title_bout` between the holder and a challenger moves the belt, and increments `defenses` when the holder wins |
| T2 | An UNflagged bout involving the holder moves nothing and does not count as a defence (J3 Q2 — the Grand Prix case) |
| T3 | A flagged bout between two non-holders returns false and creates no champion |
| T4 | A legacy bout with no flag at all falls back to today's behaviour once, so a scheduled title fight in an old save still resolves as one |
| T5 | Migration gives every existing belt `champion` or `vacant` and moves no belt |
| T6 | An interim is created only while the holder is unavailable, and never while the holder is bookable |
| T7 | On the holder's return the interim is consumed by unification; no division ever holds a champion and an interim at once (Q3) |
| T8 | An interim holder who beats the returning champion becomes `champion`, and the interim entry is gone |
| T9 | No data file or code path contains an invented federation-attributed rule; the interim window is labelled a game rule |

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/title_flag_test.gd
```

Then `titles_rankings_test.gd`, `rankings_api_test.gd` and
`world_management_ui_test.gd` must pass **unchanged**. Full suite once, in the
background, before the commit (137 files as of `a7872fa`).

## Owned files

```
Godot/scripts/WorldPopulation.gd
Godot/scripts/GameState.gd
Godot/assets/data/           (the interim window only, if one is needed)
Godot/tests/title_flag_test.gd   (new)
```

Codex holds `ScorecardRead.gd`, the two C25 accessors in `GameState.gd` and
`scorecard_read_test.gd`. **`GameState.gd` is shared this cycle** — check
`git status -s` before staging, stay out of the read-API region, and rebase
rather than merge if C25 lands first.

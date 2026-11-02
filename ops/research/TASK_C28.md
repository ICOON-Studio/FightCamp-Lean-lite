# TASK C28 — THE ATHLETE'S PURSE READ (Codex)

**Status: ASSIGNED 2026-09-07.** Depends on R43 (`b300d3c`), C27 (`5afdfed`),
R42 (`a534dad`) and J6 (`b508488`). The tenth read in the
C4 / C7 / C19–C27 pattern.

Model: Sonnet, effort medium, Fast off. One session.

## Why this exists

C27 answered *what the gym's week costs*. Nothing answers the other half:
**after R43 the fighter holds the money, and no read says what happened to
it.** `get_athlete_cash()` (`GameState.gd:10287`) returns one integer. The
settlement writes a rich log row and then the game forgets how the number was
reached.

J6 A1 found the reason this matters: the settlement subtracts an **opaque
`expenses` integer** and nothing tells anyone it is the fighter's own
uncovered travel and accommodation rather than a commission take, a tax or a
gym cut. A read that shows the breakdown is how that stops being invisible.

## What to build

`GymLedgerRead.gd`'s sibling: **`AthletePurseRead.gd`** (new, pure), plus one
thin wrapper on GameState.

- **`get_athlete_purse_read(athlete_id)`** — the wallet now, career earnings,
  and the per-bout rows behind them, newest first, built from `career.fight_log`
  (the rows written at `GameState.gd:10583`). Per bout: gross bout-agreement
  money (show purse, win bonus, performance bonus, gate share), the weight
  fine if the scale took one, the logistics debit, the manager share if one
  was ever collectible, and **what actually landed in the wallet**.
- **Every line carries `source` in `{evidenced, invented, absent}`**, exactly
  as C27's ledger lines do. This is not decoration: M8 shipped the visual
  grammar for these three states (`research/M8_THE_BOOKS.md`) and a
  screen will read this field to pick the chip.
  - the contracted purse and the bonuses are **evidenced** — they are what the
    signed terms said;
  - the logistics debit and any authored magnitude are **invented** (J6: 450
    and 300 are game-authored, nothing published backs them);
  - a manager share that was never collectible is **absent at $0**, a present
    row by refusal, **never a missing row** (M8's rule, J5 G6's three gates).
- **Name the logistics debit honestly.** J6 A17: it is uncovered travel and
  accommodation. Do not surface the word `expenses` bare, and do not present
  it as a commission cut, a tax or a gym cut — none of those exist here.
- **A bout row R42 blocked is not flattened.** The log row may carry
  `title_blocked_by_weight` in `{winner_missed, both_missed}`; pass it through
  so a screen can say the belt could not follow the result. Absent on every
  bout the scale did not touch, and on every row written before R42.
- **Old saves and missing keys read as `absent`, never as zero-that-looks-real.**
  A log row written before a key existed has no opinion; say so with `absent`.

## Out of scope

- **No settlement edits, no money arithmetic, no UI.** This is a read.
- Do not touch `_apply_fight_result`, `_settle_billing`, `weekly_projection`,
  `GymLedgerRead.gd`, `FightContract.gd`, or `Membership.gd` — Claude holds
  every one of those for R44 this cycle. Your region is the read API around
  `:9616`–`:9620` and your own new file.
- Do not add a commission line, a tax line, or a trainer / cutman percentage.
  J6 A4 / A6 / A10 refused all three; a read must not invent what the game
  does not have.
- No new dollar magnitude of any kind. If R44 lands a named logistics key on
  the log row while you work, read it with a default and mark it `absent` when
  it is missing — do not wait on it and do not write it.

## Files

- `Godot/scripts/AthletePurseRead.gd` (new).
- `Godot/scripts/GameState.gd` — **the read-API region only**, one wrapper
  beside `get_gym_ledger_read()` (`:9616`). Nothing else in this file.
- `Godot/tests/athlete_purse_read_test.gd` (new).

## Parse gate (before any test run)

```
python Godot/tools/check_scripts.py Godot/scripts/AthletePurseRead.gd Godot/scripts/GameState.gd Godot/tests/athlete_purse_read_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/athlete_purse_read_test.gd
```

Then `gym_ledger_read_test.gd` and `fight_log_test.gd`, and the full suite
once before the commit.

## Done

Digest `research/C28_DIGEST.md`, your own HANDOFF block (append only —
never rewrite another agent's), push `master`, and message Claude.

# TASK C30 — THE BOUT THAT CAN BE READ AGAIN (Codex)

**Status: ASSIGNED 2026-09-07.** Depends on C23 (`get_post_fight_read`), C25
(`get_scorecard_read`), R38 (the three judges) and R42
(`title_blocked_by_weight`). The eleventh read in the C4 / C7 / C19–C29
pattern, and the first that has to make a read survive.

Model: Sonnet, effort medium, Fast off. One session.

## Why this exists

C23's post-fight read is built from a **live** `fight_state`: the range
aggregates come out of `fight_state["log"]`, and the log dies with the ring.
The moment `record_watched_world_bout()` (`GameState.gd:2390`) files the
result, everything that made the bout legible is gone — the round cards, the
three judges' totals, the decision type, the band the fight was argued on.
What survives into `athlete["fight_history"]` (`:10627`) is a winner, a
method and a settlement.

So: **a bout can be read exactly once, and only if the player watched it.**
Open the same fighter's record a week later and the card is unrecoverable. A
simulated bout never had one at all. R45 is building the screen that reads a
decision; nothing lets any other screen ever read that decision again.

## What to build

A pure module plus a persisted summary. **Persist only what cannot be
derived** — the log is discarded, so the aggregates must be written at record
time; everything derivable from the stored cards is derived on read.

- **`Godot/scripts/BoutRead.gd`** (new, pure) — `summarize(fight_state, result)`
  returns the copy-safe decision summary a recorded bout keeps: the per-round
  cards, the judges' totals and `decision_type` in C25's shape, the range
  aggregates in C23's shape (`bout_band`, `bout_owner`, `owner_share`,
  per-round dominant band), the rounds completed and the scoring style. Reuse
  `PostFightRead` and `ScorecardRead` — do not re-derive their logic, and do
  not change either file.
- **Write it once, at the door.** `record_watched_world_bout()` (`:2390`) and
  the world-bout path beside it stamp the summary onto the recorded row.
  **Additive only:** every existing key on that row keeps its meaning and its
  position, and no existing caller changes behaviour.
- **`get_bout_read(athlete_id, bout_index)`** — one wrapper beside
  `get_athlete_purse_read()` (`:9620` region) returning the stored summary
  for a bout in that fighter's history, newest-first indexed the way the purse
  read indexes its rows.
- **`source` grammar, as C27 and C28 ship it.** A bout recorded before this
  task has no summary: that is **`absent`**, a present refusal, never a
  zeroed card that looks real. A simulated bout that never had a log gets the
  cards it does have and `absent` for the range block — do not synthesise a
  band from nothing.
- **`title_blocked_by_weight` rides along** unchanged when the row carries it
  (R42, C29), so a belt that could not follow the result is still readable a
  season later.

## Out of scope

- **No UI.** Claude holds `FightResultPanel.gd` and `FightNightScreen.gd` for
  R45 this cycle; do not open either.
- **No scoring, no simulation, no settlement edits.** `FightSimulation.gd`,
  `RoundScoring.gd`, `JudgePanel.gd`, `PostFightRead.gd`, `ScorecardRead.gd`
  and `_apply_fight_result` (`:10340`) are read-only to you.
- **No save migration and no backfill.** Old rows read `absent`. Do not walk
  existing histories rewriting them.
- No new money field, no new record field, no new fame term. This makes an
  existing decision durable; it does not add a fact to the fight.
- Do not grow the saved row without need: the summary is the card, the
  totals, the decision and the range aggregates. The full event log is **not**
  persisted — it is large, and nothing reads it back.

## Files

- `Godot/scripts/BoutRead.gd` (new)
- `Godot/scripts/GameState.gd` — the record-write region at `:2390` and one
  read wrapper beside `:9620`. Nothing else in this file.
- `Godot/tests/bout_read_test.gd` (new)

## Parse gate (before any test run)

```
python Godot/tools/check_scripts.py Godot/scripts/BoutRead.gd Godot/scripts/GameState.gd Godot/tests/bout_read_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/bout_read_test.gd
```

Then `post_fight_read_test.gd`, `scorecard_read_test.gd`,
`athlete_purse_read_test.gd` and `fight_log_test.gd`, and the full suite once
before the commit — the record path is central and a save-shape change must
be proved harmless.

## Done

Digest `research/C30_DIGEST.md`, your own HANDOFF block (append only —
never rewrite another agent's), push `master`, and message Claude.

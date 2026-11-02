# TASK C33 — THE BOUT THAT WAS NOT WATCHED ON A CARD (Codex)

**Status: ASSIGNED 2026-09-07.** Engine only, one region. Found and verified
during R49; deliberately left out of that stage's scope because the settlement
capture is C30's file, not R49's.

Model: Sonnet, effort high, Fast off. One session.

## The gap

C30 gave every bout a durable read: `get_bout_read(athlete_id, bout_index)`
(`GameState.gd:9715`) returns `BoutRead.from_stored(row["bout_read"])` off an
athlete's `fight_history` row.

**Only one path ever writes that key.** `record_watched_world_bout`
(`GameState.gd:2391`) builds the capture at `:2425` and stamps it on the settled
row at `:2432` — and it is reached only when the player watches a bout **on a
world event card**. Grep proves it: `"bout_read"` is written at `:2432`, `:2466`
and `:2482`, all inside that one function.

Every other settled bout goes through `_apply_fight_result`
(`GameState.gd:10414`), whose history row is built at `:10711` and carries **no
`bout_read` at all**. That is a Grand Prix bout (`gp|`), a Contender Series bout
(`dwcs|`), a promotion bout (`promo|`), any ordinary offer settled at the weekly
rollover, and every old-model pending settled by `advance_week`'s loop. For all
of them `get_bout_read` answers `SOURCE_ABSENT` forever — while the evidence was
sitting in `pending_fight_result` the whole time and was simply dropped.

## What to build

At settlement, file the capture the freeze already holds. `pending` at
`:10280` now carries everything the CARDS half of a `BoutRead` needs:

- `method`, `scorecards`
- `decision_type`, `scoring_style` (frozen by R49, `589dd30`)
- `playback_source` with `winner_side` and `rounds_completed`

1. In `_apply_fight_result`, build a `BoutRead.capture`-shaped stored dict from
   `pending` and put it on `history_row` **before** `history.push_front` at
   `:10711`, so `get_bout_read` reads it like any watched bout.
2. `winner_side` is **derived, not guessed**: the booking athlete is always side
   `"a"` (that function's own doc comment says so and `:10252` relies on it), so
   `result == "win"` → `"a"`, `"loss"` → `"b"`, a draw → `""`. Prefer
   `playback_source["winner_side"]` when it is there.
3. Reuse `BoutRead`'s own constants and shape — do not hand-roll a dict that
   drifts from `from_stored`'s expectations. If `capture()` needs a second entry
   point to build from a filed result with no live `fight_state`, add it in
   `BoutRead.gd`; that file is yours.

## The two honesty rules, and they are the point

- **RANGE IS ABSENT HERE, AND MUST SAY SO.** `BoutRead.capture` derives its
  range block from `fight_state["log"]`, and that log dies with the ring — it is
  gone by settlement. The stored capture must carry
  `range = {"source": SOURCE_ABSENT}`. Never synthesise a range aggregate from
  the cards, and never let the range block simply go missing in a way that reads
  as evidenced.
- **NO BACKFILL.** A row already on disk without `bout_read` stays absent. This
  files evidence at settlement time, from the frozen result; it does not
  reconstruct a bout after the fact. Same discipline R49 held for
  `decision_type`, and `get_bout_read`'s own docstring already promises it:
  "Old rows never receive reconstructed evidence: they answer absent."

## Out of scope

- No scoring change, no `FightSimulation.gd`, no `JudgePanel.gd`.
- No change to `record_watched_world_bout`'s existing capture — it is correct
  and it stays the richer one, because it still has the log.
- No screen, no panel, no UI. `ScheduleHubPanel.gd` and `OfficeHubPanel.gd` are
  **Claude's this cycle (R50) — do not open them.**
- No save migration.

## Owned files

```
Godot/scripts/GameState.gd
Godot/scripts/BoutRead.gd
Godot/tests/bout_read_test.gd
```

`GameState.gd` is shared with nobody this cycle: R50 reads it and edits nothing
in it. Stay inside `_apply_fight_result` and do not touch the R49 freeze at
`:10280` beyond reading it.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/BoutRead.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/bout_read_test.gd
```

Add claims that a bout settled **without** the watched-card path now reads
EVIDENCED with its cards and its decision type, and that its range block is
ABSENT. Then:

```
--script tests/post_fight_read_test.gd
--script tests/scorecard_read_test.gd
--script tests/fight_playback_test.gd
--script tests/contender_series_test.gd
--script tests/smoke_test.gd
```

Then the full suite ONCE before the commit.

## Done

Commit and push `master`, write `research/C33_DIGEST.md` (short), and send
Claude one line: `python Tools/agent_comms.py send --from codex --to claude
--topic "C33 landed" --body "..."`. Do **not** edit `HANDOFF.md`; Claude
converts the block.

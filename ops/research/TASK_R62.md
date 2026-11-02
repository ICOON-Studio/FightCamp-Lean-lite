# TASK R62 — CLAUDE — THE BODY'S RECORD, AND WHERE EACH INJURY STANDS

Model: Opus, effort **high**, Fast off. One session, engine only.
Runs after R61 or before it — they share no file.

## Why this exists

Two pure modules landed on 2026-09-08 and **nothing in the game calls either
of them**. Grepped 2026-09-08 across `Godot/scripts` and `Godot/scenes`:

- `InjuryPhase.gd` (G17) — **zero** references outside its own test.
- `InjuryHistory.gd` (G16) — **zero** call sites; the only two hits are doc
  comments that promise a caller, `BodyReadiness.gd:611` and
  `GameState.gd:6020`.

That is the read-backlog pattern the 2026-09-07 cycle was written to end,
growing back one cycle later. R59 stored the named injury, R60 gave it a
ceiling, G16 counts the finished ones and G17 says where a live one stands —
and a screen asking "what is wrong with this fighter, and how long" still has
nothing to call.

**This task spends both, in the engine, and stops there.** Ids and numbers
only: `InjuryWords` (Q3), `RecoveryWords` (Q4) and `LedgerWords` (Q5) own every
string a player reads, and none of them may be preloaded by `GameState.gd`.

## Owned files — and only these

- `Godot/scripts/GameState.gd` (the two body seams below, nothing else)
- `Godot/tests/body_read_test.gd` (304 lines, read whole)

**`GameState.gd` is 13,877 lines — never open it whole.** The windows you
need:

- `:32-33` — the preload block; `BodyReadiness` and `RegionHistory` already sit
  here. Add the two new ones beside them.
- `:7712` — `get_body_read(athlete_id)`, the public entry.
- `:7723-7790` — `_body_read(athlete, athlete_id, career_week)`: the per-region
  row loop is `:7738-7768`, the returned dictionary `:7770-7790`.
- `:6020` — the comment that already names `InjuryHistory` as the reader of
  `body_state.injury_log`. Read it before you write; do not edit it.

`BodyReadiness.gd` is 731 lines and is **not owned** — you only call it:
`get_injuries(athlete)` at `:467` returns the live region→injury dictionary,
`get_injury_log(athlete)` at `:480` returns the newest-first finished rows.
Neither is touched.

## Not yours, this cycle

- `ProfileRevampPanel.gd` and `ScheduleHubPanel.gd` — **Cursor holds both under
  U9.** Do not open them. U9 consumes what you add here; that is the whole
  handover.
- `BodyReadiness.gd`, `InjuryHistory.gd`, `InjuryPhase.gd` — read-only.
- Any word, any label, any sentence a player reads.

## What you add

**Everything is ADDITIVE.** U9 is being written against the shape
`_body_read` returns today; a key that moves or disappears breaks it. No
existing key changes name, type or meaning.

1. **Per region, inside the row loop (`:7738-7768`), one new key: `phase`.**
   `InjuryPhase.phase(row["injury"], career_week)` when the region carries a
   live injury; `{}` when `injury` is empty. A region that is merely sore has
   no phase, and an empty dictionary is the honest answer — never a
   synthesised "cleared".

2. **On the returned dictionary (`:7770-7790`), one new key: `phase_board`.**
   `InjuryPhase.board(BodyReadiness.get_injuries(athlete), career_week)`, whole
   and unedited. It already carries `governing_region`, `weeks_to_clear`,
   `weeks_to_clear_known`, `active`, `cleared`, `unreadable` and `unknown` —
   pass every one of them through. Do not re-sort, re-key or flatten it. When
   the fighter carries no live injury the board is still built and comes back
   with empty lists; that is a valid read, not an absent one.

3. **On the returned dictionary, one new key: `record`.**
   `InjuryHistory.summarize(BodyReadiness.get_injury_log(athlete), career_week)`,
   whole and unedited — `diagnoses`, `weeks_lost`, `weeks_lost_known`,
   `unusable_rows`, `last_onset_week`, the per-region entries and its own
   `unknown` list. An old save with no `injury_log` gives an empty array, which
   `summarize` already answers with zeroes; do not special-case it.

4. **Nothing else.** No total, no severity index, no "worst injury", no
   projection. `weeks_to_clear_known: false` stays false. If you find yourself
   wanting a number G16 and G17 did not return, that number is a later ruling,
   not this task.

## The two traps

- **`weeks_lost_known` and `weeks_to_clear_known` are the point.** Both modules
  refuse to guess and say so. Folding an unknown into a zero here destroys the
  only thing U9 can use to say NO DATE SET. Assert both survive the read.
- **`get_body_read` answers for a retired fighter** (`:7703-7705`): the world
  record keeps `body_state`, so the log and the injuries resolve the same way.
  Do not gate the new keys on the roster.

## Test

Extend `Godot/tests/body_read_test.gd`. At least five new assertions:

1. A region with a live injury has a non-empty `phase` carrying `phase_id` and
   `readable`.
2. A sore, uninjured region has `phase == {}`.
3. `phase_board.governing_region` is the region with the live injury, and
   `weeks_to_clear_known` is true when its `compete_week` is readable.
4. A fighter with two resolved rows in `injury_log` reads
   `record.diagnoses == 2`, and a row that cannot name its onset week lands in
   `record.unusable_rows` rather than in the count.
5. An athlete migrated from a version-1 `body_state` (no `injury_log`, no
   `injuries`) reads `record.diagnoses == 0`, `phase_board.active` empty, and
   every pre-R62 key unchanged.

## Gate, then tests

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/body_read_test.gd
```

Focused, in this order:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/injury_phase_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/injury_history_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_readiness_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
```

Then the full suite ONCE in the background, reduced to a summary line, before
the commit. **Ceiling, not a target: 0 failures, and if something was already
red before you started, say so and push anyway.**

## Done means

`GameState.gd` and `body_read_test.gd` committed and pushed, a short
`research/R62_DIGEST.md`, and the eight-line COMPLETE block in
`HANDOFF.md` under Claude's own heading. Then tell Cursor, in one line, that
`get_body_read` now carries `phase`, `phase_board` and `record`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/GameState.gd
Godot/tests/body_read_test.gd
Godot/tests/injury_phase_test.gd
Godot/tests/injury_history_test.gd
Godot/tests/body_readiness_test.gd
Godot/tests/smoke_test.gd
research/R62_DIGEST.md
```

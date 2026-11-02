# TASK C22 — THE THREE SEQUENCES THAT DISAGREE WITH THEMSELVES (Codex)

**Status: COMPLETE 2026-09-06.** Codex commit `251463b`; pushed under operator authorization.

Model: mid tier, effort medium, Fast off.

Small, closed data task with one test consequence. **No `FightRange.gd`, no
`FightSimulation.gd`, no screen, no `.tscn`.** Per `AGENTS.md` precedence this
file beats the general rule: **write no `HANDOFF.md` block** — Claude writes it.

## Why this exists

C21 authored `range_band` / `range_delta` into all 272 catalog nodes and its
rule 4 says: **a sequence takes the band its FIRST link is thrown from.**
R36 then built combinations that walk the band, and three nodes turned out to
break that rule by two full ladder steps:

| Sequence | Authored band | First link | That link's band |
| --- | --- | --- | --- |
| `mma_jab_levelchange` | `["LONG","MID"]` | `mma_dirty_boxing` | `["CLINCH"]` |
| `mma_doubleleg_mount` | `["MID"]` | `mma_dirty_boxing` | `["CLINCH"]` |
| `muay_thai_clinch_knees` | `["CLINCH"]` | `muay_thai_straight_knee` | `["LONG","MID"]` |

R36 made the engine safe against this — `_resolve_chain` now gates chain entry
on the first link and falls back to a single action — but the data is still
wrong, and while it is wrong those three combinations can never be thrown as
combinations at the band they are drawn from. This task corrects the data and
adds the assertion that stops it recurring.

## What to do

### 1. Correct the three nodes

In `Godot/assets/data/technique_catalog.json`, set each sequence's
`match.range_band` to the band its first link is thrown from:

- `mma_jab_levelchange` → `["CLINCH"]`
- `mma_doubleleg_mount` → `["CLINCH"]`
- `muay_thai_clinch_knees` → `["LONG","MID"]`

Leave `range_delta` alone on all three — the deltas describe the net travel of
the whole chain and were authored correctly.

**Check your work against the whole catalog, not just these three.** The three
above are what a first-link comparison finds today; run the comparison over
every `kind: "sequence"` node with a `chain` and fix anything else it surfaces.
Report the count in your summary even if it is zero.

### 2. Assert it in the validator

Extend `CompetitionData.validate_technique_range_data()` (added by C21) so a
sequence whose authored `range_band` is two or more ladder steps from its
first link's band is an ERROR, with the sequence id, the first link id and
both bands in the message. Ground-only first links (no band) are skipped, not
errors.

### 3. Fix the R36 test this invalidates

`Godot/tests/fight_combo_range_test.gd` has one test —
`_test_a_chain_is_never_opened_with_a_shot_that_cannot_reach` — whose whole
premise is that `mma_jab_levelchange` is mismatched. Once you fix the data
that test stops testing anything.

**Rewrite that one function** so it builds the mismatch itself instead of
borrowing it from the catalog: inject a synthetic sequence into the actor's
`technique_cache` (the fixture `_mma_chainer` already learns
`mma_dirty_boxing`, so a synthetic node whose `chain` is
`["mma_dirty_boxing", "mma_kick_catch_slam"]` and whose own `range_band` is
`["LONG","MID"]` reproduces it exactly), then force it through
`fight_state["_forced_chain"]` the way `_forced_clinch_chain` already does.
The assertion stays the same: forced from MID, no chain is opened and the
exchange falls back to a single action.

**Change nothing else in that file.** The other twelve tests are R36's and
must still pass unmodified.

## Owned files

- `Godot/assets/data/technique_catalog.json`
- `Godot/scripts/CompetitionData.gd` (the validator only)
- `Godot/tests/technique_range_data_test.gd` (add the sequence-consistency case)
- `Godot/tests/fight_combo_range_test.gd` (**one function only**, named above)

## Do not touch

`Godot/scripts/FightRange.gd`, `Godot/scripts/FightSimulation.gd`,
`Godot/scripts/RangeRail.gd`, `Godot/scripts/RingStagePanel.gd`. R37 is
building the Range Rail in parallel and owns those.

## Anchors

- The validator C21 added: `CompetitionData.validate_technique_range_data()`,
  and its helper `_validate_technique_range_band`.
- `_load_and_validate` already appends the range report's errors.
- The gate distance the rule mirrors: `FightRange.GATE_BAND_DISTANCE`
  (`FightRange.gd:129`); the ladder `FightRange.BANDS` (`:44`).
- The engine guard that makes this safe today: the first-link check in
  `FightSimulation._resolve_chain`.
- C21's rule 4 in `research/TASK_C21.md`.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/CompetitionData.gd Godot/tests/technique_range_data_test.gd Godot/tests/fight_combo_range_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/technique_range_data_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_combo_range_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_range_test.gd
```

All three must exit 0 with zero failures, then the full suite once.

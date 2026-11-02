# Q11 DIGEST — The Three Strands of a Camp

**Agent:** qwen · **Date:** 2026-09-09

## Delivered

1. **`Godot/scripts/TrainingStrands.gd`** — new module, zero preloads, all
   static, no class_name. Six functions over the three strands
   (footwork, conditioning, technique):
   - `empty()` — fresh ledger, every strand at 0
   - `log_session(strands, strand, minutes)` — returns new dict, never mutates;
     unknown strand or minutes <= 0 returns unchanged
   - `total(strands, strand)` — minutes logged, 0 for unknown
   - `share(strands, strand)` — fraction 0.0..1.0; **0.0 on empty ledger**
   - `dominant(strands)` — most-minutes strand; **"" on tie or empty**
   - `attribute_for(strand)` — footwork→speed, conditioning→conditioning,
     technique→technique, else ""

2. **`Godot/tests/training_strands_test.gd`** — 32 assertions covering
   empty shape, no-mutation, accumulation, unknown/zero/negative ignored,
   share summing to 1.0, share 0.0 on empty, dominant on clear/tie/empty,
   attribute_for mapping and unknown.

3. **`Godot/scripts/AthleteDevelopment.gd`** — wiring only, no rebalance:
   - Bumped `CURRENT_DEVELOPMENT_VERSION` 2 → 3
   - Added `strands` field to `migrate_athlete` (after `technique_progress`)
   - Added strands logging in `train_technique`: each session logs its units
     to the strand derived from the technique's primary attribute
   - Added `_strand_for_technique` and `_strand_for_attribute` helpers
   - Preloaded `TrainingStrands` as a const

## The trap — avoided

- `dominant()` on a tie returns `""` — a fighter who split a camp evenly
  had no focus, and the caller can detect it
- `share()` on an empty ledger returns `0.0` for every strand — never a
  third each

## Results

- Parse gate: 3/3 pass (TrainingStrands, test, AthleteDevelopment)
- Focused test: 32/32 OK, 0 failures
- smoke_test: 53/53 OK, 0 failures
- Full suite: running (186 files expected, baseline 185/0 at be99096)

## Owned files

- `Godot/scripts/TrainingStrands.gd` — new
- `Godot/tests/training_strands_test.gd` — new
- `Godot/scripts/AthleteDevelopment.gd` — modified (windows at :83, :328 only)
- `research/Q11_DIGEST.md` — this file

# TASK Q11 — QWEN — THE THREE STRANDS OF A CAMP

**Owner:** qwen
**Model:** effort **medium**, Fast **off**.
You have a shell and can run the suite, so this is **module AND test together** —
the old one-file-only limit does not apply to you any more.

## Why this exists

Operator request 2026-09-09: training should be divided into strands rather than
being one undifferentiated activity. U18 D11 backs it with the England Boxing L2
day plan, which is literally *stance/guard/footwork -> straights + defenses ->
hooks/uppercuts + defenses -> padwork -> sparring -> circuits/running/skipping*.

**Three strands, not five.** The operator floated arms/torso/footwork; arms and
torso are deliberately **not** strands here, because they already mean something
else in this save — they are two of the six **body regions** used for injury and
recovery (R55, U3, and the per-region healing decision of 2026-09-07). One word
must not mean two things in one save file. Footwork survives; arms and torso stay
body regions.

## Part 1 — the module

`Godot/scripts/TrainingStrands.gd` — **zero preloads, all static, no
`class_name`, no `_ready`, no signals.** Zero preloads is not decoration: it
keeps the module checkable in isolation and keeps it out of the autoload
ordering trap.

### The contract — exact names, exact order, exact strings

```gdscript
const STRANDS := ["footwork", "conditioning", "technique"]

static func empty() -> Dictionary
static func log_session(strands: Dictionary, strand: String, minutes: int) -> Dictionary
static func total(strands: Dictionary, strand: String) -> int
static func share(strands: Dictionary, strand: String) -> float
static func dominant(strands: Dictionary) -> String
static func attribute_for(strand: String) -> String
```

- `empty()` — a fresh ledger: every strand in `STRANDS` present, each at `0`.
- `log_session(strands, strand, minutes)` — returns a **new** dictionary with
  `minutes` added to `strand`. Does **not** mutate the argument. An unrecognised
  strand, or `minutes <= 0`, returns the ledger **unchanged** — never subtract,
  never create a strand that is not in `STRANDS`.
- `total(strands, strand)` — minutes logged, `0` for an unrecognised strand or a
  ledger missing that key.
- `share(strands, strand)` — that strand's minutes over the total across all
  strands, `0.0..1.0`. **A ledger with zero total minutes returns `0.0` for
  every strand** — not `NaN`, not `1.0/3`.
- `dominant(strands)` — the strand with the most minutes. **A tie returns `""`,
  and so does an empty ledger.** A camp split evenly has no dominant strand, and
  saying it does would be a lie the caller cannot detect.
- `attribute_for(strand)` — `"footwork"` -> `"speed"`,
  `"conditioning"` -> `"conditioning"`, `"technique"` -> `"technique"`.
  Anything else -> `""`.

**`attribute_for` may only ever return one of the seven existing attributes or
the empty string.** U18 D9 refuses an eighth attribute outright; this function is
where that refusal is enforced in code, so it must not grow a new name.

## Part 2 — the test

`Godot/tests/training_strands_test.gd`. Cover: `empty()` shape; that
`log_session` does not mutate its argument; accumulation across several
sessions; the ignored cases (unknown strand, `minutes` of `0` and of `-30`);
`share` summing to `1.0` on a populated ledger and to `0.0` each on an empty
one; `dominant` returning `""` on both a tie and an empty ledger; and
`attribute_for` returning only the seven-or-empty.

## Part 3 — the wiring (small, and last)

`Godot/scripts/AthleteDevelopment.gd` is **889 lines — do not open it whole.**
`train_technique` at **`:328`** already mutates
`athlete["technique_progress"]` (initialised at `:83`). Add, beside it, a
`strands` ledger on the athlete kept with `TrainingStrands.log_session`, so a
camp records *which strand* the minutes went to and not only which technique
improved.

Read-only for now: nothing consumes it yet. **Do not change any existing
attribute's growth maths** — this task records a fact, it does not rebalance
training. Anything that reads `strands` back into a fight is a later slice.

## Owned files

- `Godot/scripts/TrainingStrands.gd` — new.
- `Godot/tests/training_strands_test.gd` — new.
- `Godot/scripts/AthleteDevelopment.gd` — **889 lines, windows only**; anchors
  `:83` (`technique_progress` init), `:328` (`train_technique`).
- `HANDOFF.md` — your own Q11 block only, max 8 lines.

**Do NOT touch** `FightSimulation.gd` (R80 owns it), `RingStagePanel.gd` (C59
and U19 own it), or `TechniqueTrainingCoordinator.gd` / `TrainingHubPanel.gd` —
the screens come after the ledger exists.

## Gate

```bash
python Godot/tools/check_scripts.py Godot/scripts/TrainingStrands.gd Godot/tests/training_strands_test.gd Godot/scripts/AthleteDevelopment.gd
```
Then focused, then the suite once in the background before the commit:
```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/training_strands_test.gd
python Godot/tools/run_tests.py
```
`fails=0`, or better than you found it — if you fix a pre-existing failure too,
say so and push. Never gate on an exact count.

Remember R75: **rc=0 is not a pass.** A GDScript runtime error still exits 0 —
read the runner's `SUITE total=N fails=M` line, not the exit code.

## The trap

**`dominant` on a tie must return `""`.** It is the one function here that is
tempting to make "helpful", and a helpful answer is a fabricated one: a fighter
who split a camp evenly between footwork and technique did not have a focus, and
a caller that gets `"footwork"` back has no way to know it was a coin flip. The
same instinct governs `share` on an empty ledger — `0.0`, never a third each.

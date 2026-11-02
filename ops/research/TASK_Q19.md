# TASK Q19 — QWEN — GrappleSeat.gd: WHERE THE TWO MEN ARE

Model: Qwen default, `--yolo`. Owner: Qwen. Base: `57d7a5b`,
`SUITE total=209 fails=0`.

---

## Why this exists

Grappling is the last thing blocking the retirement of `FightSimulation.gd`.
`G34_GRAPPLING_CONTRACT.md` (Grok, 17 sources) already decided the design; this
is the first of its two modules and it is the one nothing else depends on.

**You are one of three agents building grappling from the same contract.**
Cursor owns `GrappleResolve.gd` (the arithmetic) and Codex is writing a
contract test BLIND. None of you may read another's code. That is deliberate:
a test written against a delivered implementation only ever agrees with it.

## What to build

**ONE new file, `Godot/scripts/GrappleSeat.gd`, plus its test.** You have a
shell and Godot, so you write and run the test yourself.

Pure statics. `extends RefCounted`, `class_name GrappleSeat`. **ZERO
preloads** — no fight core, no `FightRealtime`, no autoloads. Every number it
needs is either a constant here or an argument.

### The contract — EXACT names, argument order and strings

Codex is writing a test against this text without seeing your file. A renamed
argument or a different string is a failure, not a preference.

```gdscript
const STANCES := ["standing", "clinch", "ground"]
const SEATS := ["none", "over_under", "guard", "half", "side", "mount", "back"]

## A new dictionary every call: {"stance": "standing", "seat": "none", "top": -1}
static func fresh() -> Dictionary

## Is this a legal edge? Unknown stance or seat is false, never an error.
static func is_legal(from_stance: String, from_seat: String, to_stance: String, to_seat: String) -> bool

## Ticks the new seat must be HELD before it scores. 20 Hz, integers only,
## never a float clock. 0 means it scores immediately.
static func hold_ticks(to_stance: String, to_seat: String) -> int

## Control units to credit the man on top, per SCORING tick. Integers.
static func control_units(stance: String, seat: String, has_top: bool) -> int

## Is this seat a dominant one? side, mount and back are; guard is not.
static func is_dominant(stance: String, seat: String) -> bool

## Pure. Returns a NEW dictionary; never mutates its input. An illegal edge
## returns an unchanged copy rather than an error.
static func apply(seat_state: Dictionary, to_stance: String, to_seat: String, top: int) -> Dictionary
```

### The numbers, straight from G34 §2

**Layer legality.** `standing` pairs only with seat `none` and `top == -1`.
`clinch` pairs only with `over_under`. `ground` pairs with exactly one of
`guard|half|side|mount|back`. Any other pairing is illegal.

**`hold_ticks`:**

| To | Ticks |
| --- | --- |
| `clinch` / `over_under` | 10 |
| `ground` on a takedown landing (`guard`, `half`, `side`) | 20 |
| `ground` position change into `side`, `mount`, `back` | 60 |
| back to `standing` (break or stand-up) | 0 |

60 ticks is IBJJF's three-second rule and G34 makes it **the universal
stability gate**. Judo's longer osaekomi belongs to an adapter, not here — the
engine only reports "held for N ticks".

**`control_units` per scoring tick (TickBudget `scoring`, every 20 ticks):**

| Stance / seat | Units |
| --- | --- |
| `clinch` with a top | 1 |
| `ground` + `side` / `mount` / `back` | 2 |
| `ground` + `half` | 1 |
| `ground` + `guard` | 0 to BOTH men |
| `standing` | 0 |

Guard is zero on purpose: neither MMA, wrestling nor BJJ awards control for
holding guard. Do not "fix" that.

**Knee-on-belly is NOT a sixth seat.** It is `side` with a flag, and it is a
scoring event that belongs to Cursor's module. Six ground seats would be wrong.

## The trap specific to this task

**`apply` must not mutate.** GDScript dictionaries are references and a shallow
`.duplicate()` copies the outer dictionary while SHARING every nested one. This
exact defect is what `FightTrauma._copy_face` exists to prevent — read its
comment at `Godot/scripts/FightTrauma.gd:118` before you write `apply`, and
note that a naive "it returns a new dictionary" check passes anyway. Codex's
blind test will check the input is untouched.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/scripts/GrappleSeat.gd` | new | Yours. Pure, zero preloads. |
| `Godot/tests/grapple_seat_test.gd` | new | Yours. |

**Read only these:** `research/G34_GRAPPLING_CONTRACT.md` §2 and §8
(lines 82–147 and 362–410), and `Godot/scripts/FightTrauma.gd` as the house
pattern for a pure static module. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any digest, or Cursor's branches.
`GameState.gd` is 12,900+ lines — never open it.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/GrappleSeat.gd Godot/tests/grapple_seat_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_seat_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0` and `total` at least 210. If it is
higher because a sibling task landed, say so and push. **The exit code alone is
not a pass** — a GDScript runtime error leaves rc=0, so read the runner's own
`SUITE` line.

## Done

Commit, push `master`, write `research/Q19_DIGEST.md` (short), then send
one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic "Q19-done" --body "<commit> <suite line> <anything the contract left ambiguous>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

**If the contract is ambiguous, report the ambiguity rather than silently
resolving it.** G33T did exactly that and it was the right call.

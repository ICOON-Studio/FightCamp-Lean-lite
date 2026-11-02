# TASK G32T — CODEX — THE TEST FOR A TRAUMA MODULE YOU WILL NOT SEE

Model: Sonnet, medium effort, Fast on. Owner: Codex. Base: `dd6a545`,
`SUITE total=202 fails=0`. Deliverable: ONE new file,
`Godot/tests/fight_trauma_test.gd`.

---

## The point of this task, and why it is separate

Grok is writing `Godot/scripts/FightTrauma.gd` right now, from the contract
reproduced below. **You are writing its test from the SAME contract, without
reading its code.** That is the whole design: a test written against an
implementation only ever agrees with it, and this project has now been saved
twice by an independently written test going red for the right reason — G30T
found `MAX_REST_FRACTION` was a real defect, and G31T found
`output_multiplier(1.0)` returning a value fractionally below its own floor
because `1.0 - (1.0 - 0.45)` is not 0.45 in IEEE754.

**So: do not open `Godot/scripts/FightTrauma.gd`.** Not to "check the shape",
not to "confirm a name". If it has not landed when you start, write the test
anyway — it will go red, and that is a correct state to hand back. Say so in
your mail rather than waiting.

**Contract disagreements are the deliverable, not a failure.** If your test
goes red and you believe the contract is right, report the disagreement and let
Claude reconcile. Do NOT edit the module to make your test pass.

## THE CONTRACT — the same words Grok was given

`class_name FightTrauma`, `extends RefCounted`, statics only, zero preloads.

```gdscript
const SITES := ["left_brow", "right_brow", "left_eye", "right_eye", "nose", "lip"]
const KINDS := ["cut", "swelling"]
const MAX_PIPS := 4

## A fighter with an unmarked face. A NEW dictionary every call:
##   { "<site>": { "cut": 0, "swelling": 0 }, ... } for all six sites.
static func fresh() -> Dictionary

## 0..MAX_PIPS. An unknown site or kind returns 0 - never an error, never -1.
static func severity(trauma: Dictionary, site: String, kind: String) -> int

## 0.0..1.0. `force` is 0.0..1.0. RISES with `current_pips` (damaged tissue
## opens more easily) but is EXACTLY 0.0 at MAX_PIPS.
static func aggravate_chance(force: float, current_pips: int) -> float

## Applies one blow. Returns a NEW dictionary and NEVER mutates `trauma`.
## `roll` is the caller's draw: the module owns no RNG. The pip is added when
## `roll < aggravate_chance(force, current)`, and never otherwise.
## An unknown site or kind returns an unchanged copy.
static func aggravate(trauma: Dictionary, site: String, kind: String, force: float, roll: float) -> Dictionary

## The worst single mark: { "site": String, "kind": String, "pips": int }.
## An unmarked face returns pips 0 and EMPTY STRINGS for site and kind.
## Ties break by SITES order, then KINDS order, so the answer is predictable.
static func worst(trauma: Dictionary) -> Dictionary

## Every pip on the face added together. Unmarked is 0.
static func total_pips(trauma: Dictionary) -> int

## EXACTLY: 0 -> ""  1 -> "NICK"  2 -> "CUT"  3 -> "BAD CUT"  4 -> "SEVERE".
## Out of range clamps into it; never returns anything else.
static func words(pips: int) -> String
```

Guarantees to assert, and these are the contract's own words:

1. **`aggravate` is PURE** — returns a new dictionary, leaves the input
   untouched. **This is the one most likely to find a real defect**, because a
   Dictionary is a reference type and a shallow `.duplicate()` shares the
   per-site inner dictionaries. Assert the ORIGINAL is unchanged after a call
   that definitely added a pip — that is what a shallow copy fails.
2. A pip is never lost and never skips: one call adds **at most one** pip, to
   at most one site/kind, and never decreases.
3. `MAX_PIPS` is a hard ceiling, **reachable** by repeated calls and never
   exceeded; `aggravate_chance` is exactly 0.0 there.
4. NAN and INF are safe on every float argument and resolve to the HARMLESS
   end — no pip, chance 0.0.
5. Deterministic: same inputs, same output.
6. `severity`, `worst`, `total_pips`, `words` never throw on a malformed or
   empty dictionary — they return the empty answer.

## How to write it so it survives Grok's choices

`aggravate_chance`'s exact curve is **authored by Grok and is not in the
contract.** So do not assert a number. Assert the RELATIONSHIPS the contract
does state:

* it is bounded 0.0..1.0 for every input;
* it is non-decreasing in `current_pips` below `MAX_PIPS`;
* it is non-decreasing in `force`;
* it is exactly 0.0 at `MAX_PIPS`.

A test that pins `aggravate_chance(0.5, 1) == 0.14` is a test that goes red on
the first tuning pass and tells us nothing. **Assert the shape, not the value.**

To exercise `aggravate` deterministically, drive it with `roll = 0.0` (always
below any positive chance, so the pip lands) and `roll = 1.0` (never below, so
it does not). That gives you both directions without an RNG and without knowing
the curve.

**Assert the feature OCCURS, not that it is permitted.** All five `words`
strings must be produced, and `worst` must actually return each kind at some
point — a branch nothing can reach is this project's most expensive recurring
defect and has shipped here four times.

## Owned files

| File | Note |
| --- | --- |
| `Godot/tests/fight_trauma_test.gd` | **Yours. New. The only file you create.** |

Read-only: `Godot/tests/fatigue_curve_test.gd` if you want the house style for
a contract test of exactly this shape. **Do not read**
`Godot/scripts/FightTrauma.gd` — that is the point of the task. Do not read
`HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any digest, or
`GameState.gd` (12,900+ lines — never open it whole).

Print a final line in the house shape so the runner can read it, e.g.
`FIGHT_TRAUMA_TEST PASS (N checks)` / `FIGHT_TRAUMA_TEST FAILS=N`, and exit
non-zero on failure. **A test that prints no line of its own is failed by the
runner**, and rc=0 alone is never a pass (R75).

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/tests/fight_trauma_test.gd
```

A parse error HANGS a headless run until the timeout instead of failing it, so
this gate is not optional.

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_trauma_test.gd
python Godot/tools/run_tests.py
```

**Gate as a CEILING, never an exact count:** `fails=1 or better`. If
`FightTrauma.gd` has not landed, your test is the one failure and that is
expected — **push it and say so.** If it lands and everything passes, that is
better than the gate and you push that too. Never withhold a better result.

## GDScript traps

`var x := <call>` fails when the call returns Variant — `.get()` and `.size()`
on an untyped value both do; write the type. **Reusing a variable name inside
one function is a parse error**, even across separate `if`/`for` blocks — and a
test that sweeps SITES × KINDS is exactly where that bites. `%` in a format
string must be `%%`.

## When you are done

```
git add -- Godot/tests/fight_trauma_test.gd
git commit && git push origin master
python Tools/agent_comms.py send --from codex --to claude --topic g32t-done --body "<one line: check count, suite total, and EVERY contract disagreement you found - or 'module had not landed'>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

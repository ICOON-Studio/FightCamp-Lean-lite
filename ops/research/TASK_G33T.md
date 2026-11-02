# TASK G33T — QWEN — THE TEST FOR A CORNER YOU WILL NOT SEE

Model: default CLI, high effort, Fast off. Owner: Qwen.
**Reassigned from Cursor to Qwen, 2026-09-09**: Cursor keeps U25, and Claude cannot
write this one because it has already read `CornerAdvice.gd` in full - which would
make the test agree with the code by construction, the exact failure this split exists
to prevent. Qwen has a shell and has never seen the module. Base: `c885c5f`,
`SUITE total=204 fails=0`.

You own `Godot/tests/corner_advice_test.gd` (new). It is the only file you write.

---

## THE ONE RULE THAT MAKES THIS TASK WORTH DOING

**Do not open `Godot/scripts/CornerAdvice.gd`.** Not to peek, not to check a
threshold, not to resolve an ambiguity. Grok wrote it from the contract below;
you write the test from the same contract, without sight of the file. A test
written against an implementation only ever agrees with it, which is how this
project shipped seven pieces of correct, tested, unreachable code.

The blind split has now worked three times — G30T, G31T and G32T each found real
contract disagreements this way, and G32T agreed with Grok's module at 210
checks. **Where the module disagrees with this contract, report it; do not adapt
the test to match the code.** That report is the deliverable's real value.

## THE CONTRACT — the same text Grok was given

`Godot/scripts/CornerAdvice.gd`. Statics only: no `class_name`, no `extends`
beyond implicit, no nodes, no signals, no `_ready`. **Zero preloads and zero
`load()`** — every number is passed in by the caller. No RNG. Pure: never
mutates an argument, returns new dictionaries.

```
const URGENCIES := ["steady", "warning", "critical"]

static func advise(
	head_condition: float,      # 0..100, continuous attrition
	body_condition: float,      # 0..100
	stamina: float,             # 1..100, the tank
	heart_rate: int,            # bpm
	cardio_zone: String,        # "recovery" | "aerobic" | "threshold" | "redline"
	worst_trauma_pips: int,     # 0..4
	worst_trauma_site: String,  # "left_brow"|"right_brow"|"left_eye"|"right_eye"|"nose"|"lip"|""
	round_number: int,          # 1-based, the round just finished
	rounds_total: int,
	losing_on_cards: bool
) -> Dictionary
```

Returns exactly these five keys:

```
"line": String        # what the corner says. Non-empty, always.
"urgency": String     # one of URGENCIES
"focus": String       # one of "defence"|"output"|"breathe"|"body"|"close_it"
"cut_work": bool      # true when the corner must work a mark this round
"reasons": Array      # Array of String, the inputs that drove it. Never empty.
```

And:

```
static func urgency_of(head_condition: float, stamina: float, worst_trauma_pips: int) -> String
```

**`advise`'s `"urgency"` must equal `urgency_of` called with the same three
values.** Assert that directly and over a sweep — it is the single most likely
place for the module to have written its thresholds twice and drifted.

### What it must decide

- `cut_work` is true when `worst_trauma_pips >= 2`. At 3 or 4 the urgency cannot
  be `"steady"`.
- A redline heart rate **or** a tank under about a quarter makes `focus`
  `"breathe"`, whatever else is true.
- A head condition low enough to be in danger makes `focus` `"defence"` and
  urgency `"critical"`.
- `losing_on_cards` in the LAST round, with the man otherwise able, makes `focus`
  `"close_it"`. **It must not do that in round 1 of 12** — assert both.
- Nothing in danger, nothing losing: `focus` is `"output"` or `"body"`, urgency
  `"steady"`.
- `reasons` is never empty, even for a fighter in perfect condition.
- Breathing and danger win over tactics where rules collide.

**The contract deliberately does not pin the exact thresholds** — "low enough to
be in danger" and "about a quarter" are the module's to choose. So test the
BEHAVIOUR at unambiguous extremes (head 2.0 is danger; head 100.0 is not; tank
1.0 is gassed; tank 100.0 is not) and the ORDERING between them, never a specific
cut point. A test that pins 28.0 is a test that fails on a defensible retune.

### Robustness to exercise

`NAN` and `INF` for every float, and negatives: never crash, never an empty
`"line"`, never an urgency outside `URGENCIES`. Out-of-range
`worst_trauma_pips` (−3, 99) clamp rather than crash. An unrecognised
`cardio_zone` or `worst_trauma_site` is treated as unremarkable, not an error.
`worst_trauma_site` empty with pips above 0 is contradictory input — the module
picks a behaviour and comments it, so assert only that it does not crash and
still returns a valid dictionary. `rounds_total` of 1, and `round_number`
greater than `rounds_total`.

Also assert **purity**: call `advise` twice with identical arguments and get
equal dictionaries, and confirm the returned `reasons` array can be mutated by
the caller without affecting a later call.

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/tests/corner_advice_test.gd` | new | Yours, and the only file you write. |

Load the module with `load("res://scripts/CornerAdvice.gd")` inside
`_initialize()` and **fail gracefully with a printed line if it is absent**,
the way `cardio_test.gd` and `fight_trauma_test.gd` do — that keeps the suite
honest if the file ever moves. For the shape of a contract test to copy, read
`Godot/tests/cardio_test.gd`. **Do not read `Godot/scripts/CornerAdvice.gd`.**
Never open `GameState.gd` (12,900+ lines).

## Gates

1. Print your own summary line and your own `failures=N`. **The exit code alone
   is not a pass** (R75): a GDScript runtime error leaves rc=0 and a test that
   never reached its counter still prints "0 failures".
2. Report every contract disagreement in your mail rather than silently
   adapting. If you find none, say that too — it is a real result.
3. Do not weaken an assertion to make the suite green.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/tests/corner_advice_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/corner_advice_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`, `total` at least 205. A sibling task
(C66, Codex) is expected to be RED by design while it waits for R87 — if the only
failure is `fight_reaches_its_modules_test.gd`, that is not yours. Say so and
push.

## The trap specific to this task

**Pinning a threshold you were not given.** The contract says "low enough to be
in danger" on purpose. If you assert `head_condition == 28.0` flips the urgency,
you have tested Grok's arithmetic rather than the contract, and the next
defensible retune goes red for no reason — which teaches everyone to re-pin
instead of to look. Test at extremes and test the ordering.

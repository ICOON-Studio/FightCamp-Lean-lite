# TASK G33 — GROK — WHAT THE CORNER SAYS BETWEEN ROUNDS

Model: Grok, high effort. Owner: Grok. Deliverable: **ONE new file**,
`Godot/scripts/CornerAdvice.gd`.

**DO NOT WRITE A TEST.** Its test is a separate task (`G33T`) written from this
same contract by another agent who will not see your code. That split is
deliberate: a test written against an implementation only ever agrees with it.
Send the module alone.

---

## What this is

Between rounds a corner tells his fighter one thing. Not a stat dump — the single
instruction that matters given the state of the man in front of him. This module
turns his condition into that instruction.

The fight already models everything needed: a continuous head and body condition,
a stamina tank, a heart rate (`Cardio.gd`) and discrete facial trauma in pips
(`FightTrauma.gd`). What is missing is the judgement — "he is cut over the left
eye and breathing at 182, so the instruction is *keep your hands up and box*."

## Rules for this file, and they are absolute

- **Statics only.** No `class_name`, no `extends` beyond the implicit, no nodes,
  no signals, no `_ready`.
- **ZERO preloads and zero `load()`.** You have no checkout and no Godot, so
  this file must be testable in a throwaway project holding only itself. Every
  number it needs is **passed in by the caller**. If you find yourself wanting
  `Cardio.zone(...)`, take the zone as a `String` argument instead.
- **No RNG.** No `randf`, no `RandomNumberGenerator`. If a choice needs
  randomness, take a `roll: float` argument in 0.0..1.0 from the caller. This is
  the house pattern and it is what keeps a seeded fight seeded.
- **Pure.** Never mutate an argument. Return new dictionaries.

## THE CONTRACT — exact names, exact argument order, exact strings

An unseen test calls exactly this. Do not rename, do not reorder, do not add a
required argument, do not change a returned string's spelling or case.

```
const URGENCIES := ["steady", "warning", "critical"]

static func advise(
	head_condition: float,      # 0..100, continuous attrition
	body_condition: float,      # 0..100
	stamina: float,             # 1..100, the tank
	heart_rate: int,            # bpm
	cardio_zone: String,        # "recovery" | "aerobic" | "threshold" | "redline"
	worst_trauma_pips: int,     # 0..4
	worst_trauma_site: String,  # "left_brow" | "right_brow" | "left_eye" | "right_eye" | "nose" | "lip" | ""
	round_number: int,          # 1-based, the round just finished
	rounds_total: int,
	losing_on_cards: bool
) -> Dictionary
```

Returns exactly these five keys:

```
{
	"line": String,        # what the corner says. Non-empty, always.
	"urgency": String,     # one of URGENCIES
	"focus": String,       # one of "defence" | "output" | "breathe" | "body" | "close_it"
	"cut_work": bool,      # true when the corner must work a mark this round
	"reasons": Array,      # Array of String, the inputs that drove it. Never empty.
}
```

Also provide, because the screen wants the urgency without the full advice:

```
static func urgency_of(head_condition: float, stamina: float, worst_trauma_pips: int) -> String
```

`advise`'s `"urgency"` must equal `urgency_of` called with the same three
values — the test will check that they agree, so derive one from the other rather
than writing the thresholds twice.

## What it must decide

- `cut_work` is true when `worst_trauma_pips >= 2`. At 3 or 4 the urgency cannot
  be `"steady"`.
- A redline heart rate or a tank under about a quarter makes `focus`
  `"breathe"`, whatever else is true — a man who cannot breathe cannot execute
  anything else.
- A head condition low enough to be in danger makes `focus` `"defence"` and
  urgency `"critical"`.
- `losing_on_cards` in the LAST round, with the man otherwise able, makes `focus`
  `"close_it"`. It must not do that in round 1 of 12.
- Nothing in danger, nothing losing: `focus` is `"output"` or `"body"`, urgency
  `"steady"`.
- `reasons` names the inputs that actually drove the choice, as short lowercase
  strings. Never empty, even for a fighter in perfect condition.

Where two rules collide, breathing and danger win over tactics. Say your
precedence order in a comment at the top of the file — the test will exercise
collisions, and an implicit order is a decision made without noticing.

## Robustness the test will exercise

- `NAN` and `INF` for any float, and negative values: never crash, never return
  an empty `"line"`, never return an urgency outside `URGENCIES`.
- Out-of-range `worst_trauma_pips` (−3, 99): clamp, do not crash.
- An unrecognised `cardio_zone` or `worst_trauma_site`: treat as unremarkable
  rather than erroring.
- `worst_trauma_site` empty with `worst_trauma_pips` above 0 is contradictory
  input — pick a behaviour and comment it.
- `rounds_total` of 1, and `round_number` greater than `rounds_total`.

## Style, so it reads like the rest of the codebase

Tabs, not spaces. `##` doc comments above each function saying **why**, not what.
Type every declaration: `var x: float = ...`, never a bare `var x := <call>`
whose type GDScript must infer from a Variant — that is a parse error here and it
costs a whole cycle. A `%` inside a format string must be `%%`. Never reuse a
variable name inside one function, even across separate `if` or `for` blocks.

## How this is delivered

Send the **full text of `Godot/scripts/CornerAdvice.gd`** back in your reply. No
git commands, no test command, no `agent_comms.py` — you have no checkout, and a
repo test command is a command you cannot run. Claude splices the file in, runs
the parse gate and the real suite, and writes your `HANDOFF.md` block. Do not
edit `HANDOFF.md`.

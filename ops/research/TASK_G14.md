# TASK G14 — GROK — THE MATCHMAKER'S EYE: IS THIS A FIGHT THAT SHOULD BE MADE?

**Status: COMPLETE (2026-09-07, `c3f24d9`).** A pure module. Zero preloads, no
autoloads, no `GameState`, no scene, no file I/O. Everything it needs arrives
as an argument. It is testable on its own in a throwaway Godot project — see
`research/SANDBOX_MODULE_TESTING.md`. **Claude runs the real suite after
you push; you are never asked to.**

Model: top tier, effort medium, Fast off. One session.

## Why this exists

The game has one matchmaking rule and it is a filter, not a judgement:
`_promotion_opponent_pool()` in `GameState.gd` keeps candidates of the same
discipline, sex, weight class and non-retired status, then sorts by the
absolute gap in rating. That is enough for a promotion picking from its own
roster. It is nowhere near enough for the level this cycle opens — the amateur
circuit, where the fighters are 0-0 and 1-0 and 9-2, where rating means very
little and EXPERIENCE means almost everything, and where the wrong pairing is
not a boring fight but a dangerous one.

A real matchmaker does not sort by rating. They ask: same weight, same sex, is
one of them a debutant, how many fights apart are these two, how recently did
either of them get stopped, and would anyone sanction this. **That judgement is
this module.**

## What you build

`Godot/scripts/AmateurMatchmaking.gd` — a `class_name`-less script of `static
func`s, in the house style of `EntityPathway.gd` (read that file if you want
the tone: doc comments above each function that say WHY, and a refusal that is
never silent). No `preload`, no `load`, no `const X := preload(...)`.

### The API, exactly

```gdscript
## Verdict grades, most even first.
const GRADE_EVEN := "even"
const GRADE_STEP_UP := "step_up"
const GRADE_STEP_DOWN := "step_down"
const GRADE_UNSAFE := "unsafe"

static func experience(record: Dictionary) -> int
static func is_debut(record: Dictionary) -> bool
static func legality(fighter: Dictionary, candidate: Dictionary) -> Dictionary
static func grade(fighter: Dictionary, candidate: Dictionary) -> String
static func assess(fighter: Dictionary, candidate: Dictionary) -> Dictionary
static func rank(fighter: Dictionary, pool: Array) -> Array
```

**The shapes.** A `fighter` / `candidate` dictionary carries only what a caller
can hand you, and every key is optional with an honest default:

- `name: String`, `id: String`
- `record: {wins:int, losses:int, draws:int}` — may be missing entirely
- `weight_class: String`, `sex: String`
- `held_until_week: int` — a medical suspension's end week, 0 for none
- `week: int` — the current career week (on the FIGHTER dictionary; a candidate
  carries its own `held_until_week` and the fighter's `week` is the clock for
  both). If `week` is absent, a hold can never be evaluated and the hold is
  reported UNKNOWN rather than clear — see below.
- `stopped_last_bout: bool` — the last defeat was a KO/TKO
- `weeks_since_last_bout: int` — -1 when unknown

**`legality()`** returns `{"ok": bool, "reason": String, "unknown": Array}`.
`ok` is false with a plain-English reason for: different sex ("FEMALES NEVER
FIGHT MALES" is a standing project rule and is absolute), different weight
class, either fighter under a live medical hold, or the same person on both
sides. `unknown` lists every field that was absent and would have mattered.
**A missing field is never permission.** If you cannot tell whether a candidate
is under a hold, the pairing is not legal-and-clear — it is legal-and-UNKNOWN,
and the caller is told which fact is missing so a screen can say so.

**`grade()`** is the matchmaker's read of an already-legal pairing:

- `GRADE_EVEN` — the fight a matchmaker would make without thinking.
- `GRADE_STEP_UP` — the candidate is meaningfully more experienced; a real but
  defensible ask.
- `GRADE_STEP_DOWN` — the fighter is the more experienced one.
- `GRADE_UNSAFE` — the pairing a sanctioning body would refuse. A debutant
  against someone with a substantial record is the canonical case.

You choose the thresholds and you **document every one of them in a comment
that says what it is and that it is authored, not sourced.** This project's
standing rule is that an unsourced constant is allowed as long as it is
labelled honestly — see the head of `Godot/scripts/Aging.gd` for the pattern.
Do not pretend a threshold came from a study.

**`assess()`** is the one call a screen wants: it returns
`{"legal": bool, "reason": String, "grade": String, "gap": int,
"unknown": Array, "line": String}` where `line` is one short sentence a UI can
print as-is ("ONE FIGHT EACH — AN EVEN FIRST BOUT", "SEVEN FIGHTS TO NONE —
NOBODY WOULD SANCTION THIS"). Uppercase, in the style of the refusal strings in
`GameState.book_fight()`.

**`rank()`** returns the pool sorted best-match-first: legal before illegal,
even before step, and `id` ascending as the final tiebreak so the order is
**totally deterministic**. No `RandomNumberGenerator` anywhere in this file —
not seeded, not at all. The caller wants the same list twice.

## Rules

- Zero preloads. Zero autoload identifiers. Nothing outside the arguments.
- Never mutate an argument. Return new dictionaries; `duplicate(true)` anything
  you pass back out.
- `var x := <call>` fails when the call returns Variant (`.get()` on an untyped
  value). Write the type: `var n: int = int(record.get("wins", 0))`.
- Reusing a variable name inside one function is a parse error in GDScript,
  even across separate `if` / `for` blocks.
- You are NOT ruling the amateur circuit. Cursor's U4 pass is ruling how a
  fight is booked, what money moves, and when a fighter turns pro, in parallel
  with you. Stay inside the pairing question and do not model channels, fees,
  records-by-ruleset or the pro door.

## Owned files

- `Godot/scripts/AmateurMatchmaking.gd` (new)
- `Godot/tests/amateur_matchmaking_test.gd` (new — write it in the shape of the
  other files in `Godot/tests/`; **Claude runs it**, you do not)

Nothing else. **Do not edit `HANDOFF.md`, `GameState.gd`, `TASKS.md` or any
existing file.** Claude splices and reports.

## When you are done

Push the two files. That is the whole handoff — Claude picks them up, runs the
parse gate and the suite, and writes your block.

## The one trap

**`grade()` must never read `rating`.** The pool this module will be handed is
full of amateurs, and a generated rating is the one number that already exists
and the one number that means nothing at 0-0. Rank on the RECORD and the hold.
If you find yourself wanting a rating to break a tie, use the id.

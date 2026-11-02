# TASK U66 — CURSOR — BALANCE IS A STATE: THE KUZUSHI MODULE, SCALAR FIRST

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: ONE NEW SCRIPT plus ONE NEW TEST, and NOTHING ELSE IS EDITED.**
Nothing in the tree calls this module yet, so it cannot break another test. Parse
gate on both files, then your own test, and **STOP**.

```
python Godot/tools/check_scripts.py Godot/scripts/BalanceState.gd Godot/tests/balance_state_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/balance_state_test.gd
```

**Do NOT run `run_tests.py` at all** — not with `--only`, not without. The full
suite is Claude's, once, at integration. **ONLY ONE GODOT AT A TIME in this
checkout**: if a `Godot_v4.7.2-stable_win64_console.exe` is already running, wait.
(One run shows as TWO processes — the console exe spawns the windowed exe as a
child. That is one Godot, not two.)

## Owned files

- `Godot/scripts/BalanceState.gd` — **NEW, yours alone.**
- `Godot/tests/balance_state_test.gd` — **NEW, yours alone.**

Touch nothing else. Do **NOT** edit `GrappleResolve.gd`, `FightSimulation.gd`,
`FightRealtime.gd`, the catalogue, any other test, or `HANDOFF.md`.
`GameState.gd` is 12,938 lines — you do not need it, never open it.

## Why this exists

The operator ruled on 2026-09-12 that **balance is a STATE, not an eighth
attribute**, and that the first pass ships **scalar plus stance — no 8-direction
vector**. This module is that state, on its own, before anything is wired to it.

Read these two, and only these two, for the design. Both are short:

- `research/R131_BALANCE_BREAK_SPEC.md` — the spec. Its **section 9** carries
  the operator's ruling and its **section 7 is WITHDRAWN**; the replacement table
  is in section 9.1.
- `research/G59_BALANCE_RECOVERY.md` **section 1 only** — the four decay
  cases with their honesty labels.

You may also read `Godot/scripts/GrappleResolve.gd` (166 lines, read it whole) to
see the seam this module will eventually serve — `takedown_resolve` at `:44`
returns `{"success": false, "grade": 0, "to_seat": "none"}` when a shot fails, and
today that costs the attacker nothing. **You are not wiring it. Look and stop.**

## The contract — exact names, because an unseen test will call these

`BalanceState` is `class_name BalanceState extends RefCounted`, **pure statics,
ZERO preloads.** A state is a plain Dictionary the caller owns and stores; the
module never holds state itself.

```
static func new_state() -> Dictionary
static func apply_break(state: Dictionary, magnitude: float, cause: String,
                        now_s: float, ceiling: float = MAGNITUDE_CEILING) -> Dictionary
static func kuzushi_at(state: Dictionary, now_s: float) -> float
static func is_position_handover(state: Dictionary) -> bool
static func direction_modelled() -> bool
```

- `cause` is exactly one of `"kuzushi"`, `"sweep"`, `"stagger"`, `"stuffed_shot"`.
  **Any other string is a caller bug — return the state unchanged and push an
  error.** Do not silently accept an unknown cause; that is the `IGNORED` class
  U65 just spent a census proving is the dangerous one.
- `kuzushi_at` returns **0.0–1.0**, where 0.0 is balanced. This is the number
  `GrappleResolve` will later multiply into `defender_score *= (1.0 - kuzushi)`.
- A state dict **always carries `"direction": "unmodelled"`** and
  `direction_modelled()` **always returns `false`** in this pass. That is not a
  placeholder to be quietly filled in later — see "The honesty rule" below.

## The four causes, and they do NOT share one curve

From G59 section 1. **Each constant carries its honesty label as a comment, in the
words G59 used** — that is the deliverable as much as the arithmetic is:

| cause | behaviour | G59's label |
|---|---|---|
| `kuzushi` | **convert in 0.2–0.6 s or it is gone.** Near-BINARY: hold near-full, then drop to zero. NOT a linear fade. | documented |
| `sweep` | decays over ~0.5–1.5 s | **BORROWED from time-to-stabilisation literature — the comment must say so** |
| `stagger` | decays over ~0.5–2.0 s | **game precedent plus TTS, NOT fight-lab data — the comment must say so** |
| `stuffed_shot` | **DOES NOT DECAY. It is a position handover.** | pedagogy |

**R131 section 7's `magnitude * 0.1` linear fade is WITHDRAWN. Do not implement
it.** One curve for all four cases is the wrong answer here and the table above
is why.

**`stuffed_shot` is the one that will tempt you into the wrong shape.** The
operator ruled that a failed takedown breaks the ATTACKER'S own balance — so it
must cost him. But G59 says a sprawled-on shooter is not carrying a number that
fades, he is in a taught next position (*"post up or get choked"*). So
`apply_break(..., "stuffed_shot", ...)` sets `is_position_handover(state) == true`
and **`kuzushi_at` does not decay toward zero with time for that cause** — it is
cleared by the caller resolving the position, not by the clock. Implementing it as
`magnitude` on a timer is the cheap reading of a correct ruling, and it models the
single case the research names as not-a-fade.

## THE CEILING MUST BE DERIVED, NOT COPIED

`magnitude` arrives as a raw authored `balance_break` value (the catalogue's are
single digits to low teens); `kuzushi` is 0.0–1.0. Something has to normalise.

**`MAGNITUDE_CEILING` is a const in the module with a documented default — and
your TEST derives the real maximum from the data and asserts the default still
covers it.** Read every `balance_break`, `balance` and `kick_balance` value out of
`Godot/assets/data/technique_catalog.json` in the test, take the max, and assert
`MAGNITUDE_CEILING >= that`. **Print the derived number in the test output.**

This is the whole point and it is the rule this repo paid for nine times in one
day: **a gate that keeps its own copy of the answer drifts silently the moment the
data moves.** A hardcoded `assert(MAGNITUDE_CEILING == 16.0)` is the failure, not
the gate. Derive it.

`apply_break` clamps to the ceiling and **must not silently swallow an
over-ceiling value** — clamp AND report it in the returned state so a later
catalogue edit is visible rather than invisible.

## THE HONESTY RULE — this is a condition the operator's answer came with

R131 section 4 says: ship the scalar *"knowing the direction is missing, rather
than discovering later that every break was treated as identical."* The operator
chose scalar-plus-stance **with that condition attached**, so it is not optional.

- `direction_modelled()` returns `false` and the state says `"unmodelled"`.
- The module's doc comment states plainly that **a break along a weak line and a
  break along a strong line are worth the same today**, and that this is a known
  recorded deficiency, not an oversight.
- **Do NOT invent a direction**, do not derive one from stance, and do not add a
  `direction` argument "for later". `orthodox`/`southpaw` already exists on every
  fighter and is what will define the weak lines when the vector lands — it is not
  yours to consume in this pass.

A module that quietly claimed a direction it does not have would be the M19 lie
wearing a compass.

## The test

`balance_state_test.gd`. **Assert the quantity a caller would use — `kuzushi_at`'s
returned float — never a getter you wrote to check your own work.** This repo has
had that finding three times running.

1. Each of the four causes reaches its own branch, asserted by **behaviour over
   time**, not by reading back the `cause` string you just stored.
2. `kuzushi` at +0.1 s is near-full and at +0.8 s is **zero** — and assert it is
   NOT a straight line between them (sample the middle; a linear fade would pass a
   two-point test, which is exactly how the withdrawn curve would sneak back in).
3. `sweep` and `stagger` are both decayed to zero by their upper bounds, and
   `stagger` still carries something at 1.0 s where `sweep` may not.
4. `stuffed_shot`: `is_position_handover` is `true`, and **`kuzushi_at` is
   unchanged after 5.0 s of clock** — the clock does not clear it.
5. An unknown `cause` string leaves the state **byte-identical** to what went in.
6. The derived-ceiling check above, with the derived number printed.
7. `direction_modelled()` is `false` and every state carries
   `"direction": "unmodelled"`.

**This module needs no fighters at all.** If you find yourself building two,
**they may not be identical** — not the same stats, not an empty `stats` block
(the key is `stats`; `attributes` silently yields an empty one and has shipped
three bugs), not the same frame or plan — and both must be legal for the ruleset
they are in. Far better here: do not build fighters.

## Done

- `check_scripts.py` clean on both files; your own test green. **No suite run.**
- `git status -s` FIRST — another agent has work in flight in this checkout —
  then `git add --` your **two explicit paths only**. Never `git add -A`, never a
  bare `git stash` / `reset --hard` / `checkout .` / `clean`.
- Commit ending `Co-Authored-By: Cursor <noreply@cursor.com>`, then push.
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --topic U66-done --body "<hash> ceiling_default=<n> ceiling_derived=<n> checks=<n> failures=<n>"`
- **Do NOT edit `HANDOFF.md` or `AgentComms/roadmap.json`** — Claude writes your
  block. On U65 you wrote a HANDOFF block and a roadmap edit that were not yours;
  the census itself was good work, but those two files are a shared surface where
  a concurrent write eats somebody's live claim.

## GDScript traps

- `var x := <call>` fails when the call returns Variant — `.get()` on an untyped
  Dictionary is the usual one here. Write the type: `var m: float = float(...)`.
- A `%` inside a format string must be `%%`.
- Reusing a variable name inside one function is a parse error **even across
  separate `if`/`for` blocks**.
- **Parse gate BEFORE the test.** A parse error does not fail a headless run, it
  HANGS it for 600 seconds.
- rc=0 is NOT a pass. A GDScript runtime error exits 0, and a test that prints
  nothing is a failure.
- Use only `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe`.

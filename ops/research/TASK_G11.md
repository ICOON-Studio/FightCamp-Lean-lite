# TASK G11 — THE EXIT: ROLES AND LICENCE GATES (Grok)

**Status: OPEN (assigned 2026-09-07).** A pure module and its test, blocking
nothing. Read this file and nothing else — everything you need is carried
here.

Model: mid tier, effort medium, Fast off.

## What to build

`Godot/scripts/FormerRoles.gd` — a pure, stateless module that answers what a
fighter may do **after** their last fight, and whether a comeback is even
permitted. Plus `Godot/tests/former_roles_test.gd`.

**ZERO preloads. Statics only. No node access, no RNG, no `GameState`, no
`Aging`, no `UIKit`.** Every fact you need is passed in by the caller. That is
what makes it testable in a throwaway Godot project holding only your two
files — see `research/SANDBOX_MODULE_TESTING.md`.

## Why this exists

The game can now end a career (R51/R52) but has no idea what the person
becomes. "A retired fighter becomes staff at your gym" is a mechanic that
lives or dies on whether it is real, so John studied it (J11, landed
2026-09-07). **The decisions below are already made. Encode them; do not
re-derive them and do not add to them.**

## J11's rulings, carried here in full — this is your whole source

- **D1. The share of fighters who stay in the sport is UNKNOWN.** No source
  gives a rate. So the module encodes **roles and licence gates**, never a
  "stays in sport" probability. There is no percentage anywhere in this file.
- **D3. A comeback is UNKNOWN as a rate and is gated on MEDICAL FLAGS, never
  rolled.** No unretire lottery. If the flags are clear, a comeback is
  *permitted*; whether it happens is somebody else's decision, not a dice
  roll here.
- **D5. Medical and licence outrank what the person wants.** If a licence is
  denied or a medical hold is live, the answer is no regardless of desire.
- **D4. A fighter with no wins does not map to coaching skill.** Do not
  invent `fighter_wins -> coach_skill`. A winless fighter is still eligible
  to be a cornerman; the record does not grade the coach.
- **D7. The vocabulary is ROLE + RETIRED**, e.g. "coach, retired". The person
  is not "a former". **D8: dual roles are real** — someone can hold more than
  one, so roles are an ARRAY, never a single string.
- **D9. There is a third exit the game does not model: commission-FORCED
  retirement.** Not chosen, not injury — the licence is refused and the
  career is over. It must be one of the exit kinds.
- **D2. The gym keeping a fighter on as staff is an AUTHORED OFFER, not a
  lottery.** This module says whether an offer is *permissible*; it never
  decides whether it is made.

## The contract

```gdscript
## Roles this person may hold after their last fight. Always an array (D8),
## possibly empty. Order is stable so a screen can print it without sorting.
static func roles_for(facts: Dictionary) -> Array

## Whether the licence and the body permit each thing, and WHY not.
## Returns {"can_fight": bool, "can_corner": bool, "why": String}.
## `why` is a short player-facing reason, empty when nothing is blocked.
static func licence_state(facts: Dictionary) -> Dictionary

## Is a return to competition PERMITTED? Never a probability (D3).
## Returns {"permitted": bool, "why": String}.
static func comeback_gate(facts: Dictionary) -> Dictionary

## How this career ended: "chose" | "medical" | "commission_forced" (D9).
## "" when the facts do not say - never a guess.
static func exit_kind(facts: Dictionary) -> String

## "coach, retired" style label from roles_for() (D7). Never "a former".
static func role_label(roles: Array) -> String
```

`facts` is a plain dictionary the caller fills. Read only these keys, and
**treat a missing key as "not known", never as a default that reads as a
fact**:

| key | type | meaning |
| --- | --- | --- |
| `age` | int | years |
| `record` | Dictionary | `{"wins", "losses", "draws"}` |
| `licence_denied` | bool | a commission refused the licence |
| `medical_hold` | bool | a hold is live right now |
| `head_trauma_flag` | bool | the KO/TKO ladder is active |
| `years_in_sport` | int | how long they have been in it |
| `held_title` | bool | held a belt at any point |
| `wants_to_continue` | bool | what the person wants (D5: loses to the gates) |

## Rules the tests must prove

1. `licence_denied` or `medical_hold` beats `wants_to_continue` every time (D5).
2. `comeback_gate` returns a **bool and a reason**, never a number (D3).
3. A winless fighter still gets a cornerman role (D4).
4. `roles_for` returns an ARRAY and can return more than one (D8).
5. `exit_kind` returns `"commission_forced"` when the licence is denied (D9),
   and `""` when the facts do not say.
6. A missing key never becomes a confident answer.
7. **No percentage, rate, chance or probability appears anywhere in the
   module.** Grep your own file for "chance", "rate", "percent", "%" before
   you finish — J11's central refusal is that these do not exist.

## GDScript traps that cost a fix cycle here

- `var x := <call>` fails when the call returns Variant (`.get()` on an
  untyped value). Write the type: `var n: int = ...`.
- Reusing a variable name inside one function is a parse error, even across
  separate `if` / `for` blocks.
- `%` inside a format string must be `%%`.
- Tabs, not spaces.

## Testing

You have no repo checkout and no shell, so **you are not expected to run the
project suite** — Claude runs it after you push. Write
`Godot/tests/former_roles_test.gd` in the same shape as the other tests
(`extends SceneTree`, `_initialize()`, a `_check(condition, message)` counter,
`quit(1 if failures > 0 else 0)`), and make it loadable with only your two
files present.

## Done

Push `Godot/scripts/FormerRoles.gd` and `Godot/tests/former_roles_test.gd`.
**Do not edit `HANDOFF.md`** — Claude writes your block, splices your module
into the suite and reports the result. Do not poll for it.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/FormerRoles.gd
Godot/tests/former_roles_test.gd
```

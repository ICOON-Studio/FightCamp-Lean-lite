# TASK C67 — CODEX — THE BLIND CONTRACT TEST FOR GRAPPLING

Model: GPT-5, high effort. Owner: Codex. Base: `57d7a5b`,
`SUITE total=209 fails=0`.

---

## Why this exists

C66 was the test that would have caught all seven unreachable modules, and it
worked: it shipped RED BY DESIGN, measured the problem in numbers, and R87 made
it green honestly. **This is that pattern applied before the code exists rather
than after.**

Grappling is the last thing blocking the retirement of `FightSimulation.gd`.
Qwen is building `GrappleSeat.gd` and Cursor is building `GrappleResolve.gd`,
both from `G34_GRAPPLING_CONTRACT.md`. **You are writing the test for both, from
the same contract, WITHOUT EVER OPENING EITHER MODULE.**

The blind split has now worked four times (G30T, G31T, G32T, G33T) with no
contract disagreements. It is kept because **a test written against a delivered
implementation only ever agrees with it.** You are the only party who can
disagree with the two of them.

## What to build

**ONE new file, `Godot/tests/grapple_contract_test.gd`.**

**It will be RED when you push it, and that is correct.** Neither module exists
yet. Ship it red, exactly as C66 did.

### The one thing that would make this task worthless

**It must fail LOUDLY and for the right reason when a module is missing — never
vacuously.** A test that skips its assertions because `GrappleSeat.gd` is not
there yet, prints nothing and exits 0, is worse than no test: it would go green
the moment the file appears, whatever is in it. So:

* `load()` each module inside `_initialize()`, never a top-level `preload` —
  a preload of a non-existent script makes this file fail to COMPILE, and a
  parse error HANGS a headless test until the timeout (rc=124) instead of
  failing it.
* If a module is absent, count that as a real failure with a named message and
  keep going to the other one.
* Print your own `failures=N` line and `quit(1 if failures > 0 else 0)`.
* Report a witness count alongside the failure count, the way C66 prints its
  summary — a refusal count of zero proves nothing if nothing was ever built.

### What to assert

The contract is `G34_GRAPPLING_CONTRACT.md` §2, §3, §5 and §8. Read those and
nothing else. The exact signatures the two builders were handed:

```gdscript
# GrappleSeat.gd — pure, zero preloads
const STANCES := ["standing", "clinch", "ground"]
const SEATS := ["none", "over_under", "guard", "half", "side", "mount", "back"]
static func fresh() -> Dictionary
static func is_legal(from_stance: String, from_seat: String, to_stance: String, to_seat: String) -> bool
static func hold_ticks(to_stance: String, to_seat: String) -> int
static func control_units(stance: String, seat: String, has_top: bool) -> int
static func is_dominant(stance: String, seat: String) -> bool
static func apply(seat_state: Dictionary, to_stance: String, to_seat: String, top: int) -> Dictionary

# GrappleResolve.gd — pure, caller passes the roll, preloads FatigueCurve only
static func takedown_resolve(attacker: Dictionary, defender: Dictionary, from_stance: String,
	fatigue_atk: float, fatigue_def: float, roll: float) -> Dictionary
static func position_resolve(attacker: Dictionary, defender: Dictionary, from_seat: String,
	fatigue_atk: float, fatigue_def: float, roll: float) -> Dictionary
static func submission_advance(progress: int, attacker: Dictionary, defender: Dictionary,
	fatigue_def: float, roll: float) -> Dictionary
static func position_points(kind: String, to_seat: String) -> int
```

Cover at least these, and judge by ORDERING and BOUNDS rather than by pinning
magic numbers wherever the contract calls a figure tunable:

1. **The vocabularies are exactly G34's**, in G34's order, with no sixth ground
   seat. Knee-on-belly is `side` plus a scoring kind, never a seat.
2. **Layer legality.** `standing` only with `none`, `clinch` only with
   `over_under`, `ground` only with the five. Illegal pairings are refused
   without erroring.
3. **`hold_ticks`** — 10 into clinch, 20 on a takedown landing, 60 for a ground
   position change, 0 back to standing. Integers, never a float clock.
4. **`control_units`** — clinch-with-top 1, side/mount/back 2, half 1, **guard 0
   to BOTH men**, standing 0. Guard being zero is the one a plausible
   implementation gets wrong.
5. **`apply` is pure.** Its input dictionary AND every nested value are
   unchanged afterwards. A shallow `.duplicate()` passes a naive "returns a new
   dictionary" check while still mutating the caller's nested seat — this is
   the exact defect `FightTrauma._copy_face` was written against, and it is the
   likeliest defect in the delivered file.
6. **The roll contract.** `takedown_resolve` is a pure function of its
   arguments: the same arguments give the same answer every time, and sweeping
   `roll` from 0.0 to 1.0 crosses from success to failure **exactly once** and
   never back. If it draws any randomness of its own, that monotonic sweep is
   what catches it.
7. **`p` is bounded to 0.08..0.88.** A hopeless attacker still lands one
   sometimes; an overwhelming one still gets stuffed. Assert both ends with
   extreme stat dictionaries.
8. **Fatigue has the right SIGN and the right target.** A tired attacker
   succeeds less; a tired defender is taken down more. Assert the direction,
   not the magnitude.
9. **`position_points`** matches G34's table exactly — pass→side 3, sweep 2,
   mount 4, back 4, knee_on_belly 2, exposure 2, step_out 1. Unknown kinds are
   0, not an error.
10. **Submissions are RARE.** `finished` is never true below progress 100, and
    a sweep of committed attempts at full progress finishes on the order of 1
    in 6 to 1 in 8 — not every time. Report the measured rate in your summary
    line. About one MMA fight in five ends by submission (19.3% over 8,591 UFC
    bouts); that is the fight-level ceiling, not the per-attempt rate.
11. **Junk input is refused, not crashed.** Unknown stances, unknown seats,
    NaN/INF fatigue and rolls, missing stat keys. A missing stat defaults to 50.

## The trap specific to this task

**Do not write assertions you cannot justify from G34.** Where the contract
says "tunable" or "recommendation, not a citation" — the clinch power/grapple
split, the exact `finish_p`, the grade threshold — assert the PROPERTY (a
throw is rarer than a plain takedown; a fitter grappler wins more often), never
the number. Pinning a tunable would force the builders to match an arbitrary
choice you made, and the first person to tune it would have to edit your test
to do it. That is how a contract test becomes a tax.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/tests/grapple_contract_test.gd` | new | Yours, and yours alone. |
| `research/C67_DIGEST.md` | new | Yours. Short. |

**Read only these:** `research/G34_GRAPPLING_CONTRACT.md` (436 lines,
read whole — it is the contract) and `Godot/tests/fight_reaches_its_modules_test.gd`
(175 lines, read whole — it is your own C66 and the shape to copy for a
red-by-design integration test).

**Do NOT read** `Godot/scripts/GrappleSeat.gd` or `Godot/scripts/GrappleResolve.gd`
if they have appeared, any branch of Cursor's, `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest. `GameState.gd` is
12,900+ lines — never open it. `FightRealtime.gd` is 1,117 lines and is not
yours.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/tests/grapple_contract_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_contract_test.gd
python Godot/tools/run_tests.py
```

**This one is a FLOOR, not a ceiling, and it is the opposite of the usual gate:
your test SHOULD fail until the modules land.** The suite should read
`total=210 fails=1` with your file as the single failure, and the failure
message must name the missing module. If it reads `fails=0` while the modules
do not exist, your test is vacuous — that is the one outcome you must not push.
**The exit code alone is not a pass**: a GDScript runtime error leaves rc=0, so
read the runner's own `SUITE` line.

## Done

Commit, push `master`, write `C67_DIGEST.md` saying exactly which contract
clauses you asserted and which you deliberately left as properties rather than
pins, then send one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic "C67-done" --body "<commit> <suite line> <check count> <anything G34 left genuinely ambiguous>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

**Report ambiguities rather than resolving them silently.** G33T found a real
one in the corner contract and saying so was the right call.

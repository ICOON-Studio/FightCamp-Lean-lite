# TASK U29 — CURSOR — THE BLIND TEST FOR GrappleAdapter

Model: **Cursor, `-p --force --trust`.** Owner: Cursor. Base: `master` after
U28. Assigned 2026-09-10.

---

## Why this exists

Qwen is building `Godot/scripts/GrappleAdapter.gd` as Q22, typing it from
`G37_THE_ADAPTER_FOLD.md`. **You are writing the test for it blind, from the
same research file, without reading a line of what Qwen typed.**

That arrangement has paid for itself three times on this arc: C67's blind test
found nothing wrong with `GrappleSeat.gd`, Qwen found a real precedence defect
in C67's test from failure output alone, and running it exposed a hole in the
contract that neither module author had noticed. **A test written against an
implementation only ever agrees with it.** This one is written against the
source.

## Your source, and your only source

**`research/G37_THE_ADAPTER_FOLD.md`.** Read it whole. Everything you
assert must trace to it. `G34_GRAPPLING_CONTRACT.md` §1/§2/§8 is available for
the exact event and seat vocabulary — `sed -n` those sections only.

## The contract — the API, so you need not read the module

```gdscript
static func rulesets() -> Array                      # ["ijf","uww","ibjjf","abc"]
static func scores_grappling(ruleset: String) -> bool
static func award(ruleset: String, event: Dictionary) -> Dictionary
static func hold_gates_seconds(ruleset: String) -> Dictionary
static func advantage(ruleset: String, situation: Dictionary) -> int
static func stall(ruleset: String) -> Dictionary
static func submission_meaning(ruleset: String) -> String
```

`award()` returns `{"kind": String, "points": int, "counter": String}`.
**`points` is `-1` when the ruleset does not score that emission, never `0`.**
`kind` is `"not_scored"` in that case. Unknown ruleset or unknown event
returns the refusing shape rather than crashing.

## What to assert

1. **The four conversion tables, per ruleset, from G37 §1.** Walk every event
   in G34's vocabulary against every ruleset and assert the awarded points and
   kind. Where G37 says "not scored", assert `points == -1` **and** that it is
   not `0` — those are different claims.
2. **Judo scores no takedown.** G37 §1.A: a wrestling shot is not nage-waza.
   This is the mapping most likely to be wrong by instinct.
3. **UWW's bands** — 2 for a controlled takedown, 4 feet-to-danger, 5 grand
   amplitude in danger, 2 per exposure, 1 for a reversal.
4. **IBJJF's gated positions** — pass 3, mount 4, back 4, takedown 2, all
   after the 3-second gate; `half`, `guard`, `standing` and `clinch` score
   nothing.
5. **MMA awards no points for anything.** ABC publishes no event-to-point
   table; every `award()` for `abc` must be evidence-only, never a number.
   **If the module returns points for MMA, that is a disagreement and you
   report it.**
6. **`hold_gates_seconds`**: `ijf` is 5/10/20, `ibjjf` is 3, and **`uww` and
   `abc` are EMPTY** — assert emptiness explicitly, not a dictionary of zeros.
7. **`advantage()` is IBJJF-only.** Assert it fires on a scoring seat reached
   with the gate not completed and the sequence over, that it does NOT fire
   while the sequence can still complete (G37 quotes Art. 5.5), and that every
   other ruleset returns 0 always.
8. **`step_out` is not scored for ANY ruleset, INCLUDING UWW.** See below.
9. **UWW never returns a submission finish** — freestyle has no submissions.
10. **Junk in, refusal out**: unknown ruleset, unknown event, empty dictionary,
    missing keys. No crash, and the refusing shape every time.

## The assertion that matters most

**`step_out` must be "not scored" for UWW.** UWW's rulebook *does* award 1
point for it, so a careful reader who checks the UWW rules instead of G37 will
"correct" this and be wrong. G37 §4 refuses it on purpose: the engine tracks a
scalar separation, a step-out is a 2-D fact about who crossed first, and
`separation > RING_RADIUS` is a wall-walk that fires when two men separate —
the opposite of a wrestler driven off the circle. Same structural refuse R85
applied to taekwondo.

**Assert the refusal.** If the module scores a UWW step-out, the module is
wrong and your red test is the deliverable.

## What NOT to do

* **Do not read `Godot/scripts/GrappleAdapter.gd`.** Not to check a key name,
  not to "confirm the shape", not at the end. The signatures above are the
  contract. If G37 is genuinely ambiguous, assert what G37 says and report the
  ambiguity — a disagreement is the deliverable, not a problem to smooth over.
* **Do not edit `Godot/tests/grapple_adapter_test.gd`** — that is Qwen's own
  test, a different file. Yours is new.
* Do not touch `FightRealtime.gd` (Claude, R91), `GrappleSeat.gd`,
  `GrappleResolve.gd`, `GradeLadder.gd`, or `DevelopmentPanel.gd` (Codex, C69).

## Owned files

| File | Note |
| --- | --- |
| `Godot/tests/grapple_adapter_contract_test.gd` | New. The only file you write. |
| `research/U29_DIGEST.md` | New. Short: what you asserted, and every disagreement. |

**`GameState.gd` is 14,769 lines and has nothing to do with this task — never
open it.** Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`
or any other digest.

House test shape: a `_check(cond, label)` helper, a printed
`GRAPPLE_ADAPTER_CONTRACT_TEST PASS (N checks)` on success and an explicit
`failures=N` line otherwise. **A test that prints nothing of its own is scored
a failure by the runner.**

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/tests/grapple_adapter_contract_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_adapter_contract_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count.** If Q22 has landed, target `fails=0`. **If Q22
has NOT landed, your test will be red and that is CORRECT** — push it red and
say so, exactly as C67 was pushed red before `GrappleResolve.gd` existed.
Never soften an assertion to make a missing module look present. Another agent
may be running Godot concurrently; a suite line claiming everything failed is
contention, so re-run rather than panic.

## Done

Commit and **push `master` directly.** Write `research/U29_DIGEST.md`,
then send one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic "U29-done" --body "<commit> <suite line> <red-by-design or green> <any disagreement>"
```

`agent_comms.py` writes the mail file but does **not** stage it — `git add` it
into your commit. Stage explicit paths only; the checkout is shared. Do NOT
edit `HANDOFF.md`.

## The trap specific to this task

**Count and quote exactly.** A smoke test asked you the line count of an
89-line file and you answered 91. This task is nothing but exact values —
`-1` versus `0`, 2 versus 4 versus 5, an empty dictionary versus one holding
zeros. Every number you assert must come from G37's text, quoted, not from an
impression of what a ruleset "probably" awards. When in doubt, re-read the row
rather than recalling it.

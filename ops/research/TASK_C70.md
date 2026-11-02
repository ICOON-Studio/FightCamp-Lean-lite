# TASK C70 — CODEX — THE BLIND TEST HAS A BLIND SPOT

Model: **Codex, high effort, Fast mode off.** Owner: Codex. Base: `master`
after R90's merge of U26.

**THE WORLD CHANGED UNDER THIS TASK ON 2026-09-10 — read this before the rest.**
R90 merged Cursor's `GrappleResolve.gd`, so this test is **no longer red
because a module is missing**. It now runs end to end against both real
modules: `witnesses=550`, `submission_rate=18/121 (0.149)`, and **exactly one
failing assertion — line 92, the confirmed defect below.** Every other
assertion in your 236 lines passes against two modules you never read. Wherever
this file says "red by design", read: red on one line.

**Do this one BEFORE C69.** It is small, and it is about to become
load-bearing.

---

## Why this exists

You wrote `Godot/tests/grapple_contract_test.gd` blind, from `G34` alone,
against two modules you had never seen. That arrangement has now paid for
itself twice: it caught nothing wrong with Qwen's `GrappleSeat.gd`, and Qwen —
reading only the failure output — found a defect in **your test**.

The test is red by design today because `GrappleResolve.gd` does not exist on
master yet. Cursor has now landed it on `cursor/u26-grapple-resolve-fb05` and
Claude merges it in R90. **The moment that merge happens this test stops being
a placeholder and starts being the gate on three agents' work.** A wrong
assertion in it will either pass something broken or fail something correct,
and both are worse than red.

## The confirmed defect

`Godot/tests/grapple_contract_test.gd:92`:

```gdscript
_check(not seat_script.is_dominant("clinch", "over_under") == false,
    "clinch over_under has a defined dominance classification")
```

GDScript binds `==` more tightly than `not`, so this parses as
`not (is_dominant(...) == false)`. It therefore **passes only when
clinch/over_under IS dominant** — the opposite of what the label reads like —
and it can never test what it claims to. The label says "has a defined
dominance classification", which is not a thing a boolean-returning function
can fail to have, so the assertion is also meaningless as written even once
the precedence is fixed.

**Decide what G34 actually says** about whether a clinch with a top is a
dominant seat, and write the assertion that tests it. Note for context, not as
an answer: the Q19 contract lists `side`, `mount` and `back` as dominant and
`guard` as not, and gives clinch-with-a-top **1** control unit against 2 for
the dominant ground seats. Reason from G34, not from that summary.

## What to do

1. **Fix line 92** so it asserts the real rule with a label that says what it
   asserts.
2. **Re-read the whole 236-line file for the same CLASS of error**, not just
   that line. You are looking for: `not X == Y` precedence traps, assertions
   whose label and condition disagree, assertions that cannot fail, and
   assertions that would pass on a module that did the opposite thing. Report
   what you find and what you looked at, including "nothing else of this
   class" if that is the answer.
3. **Check every assertion still matches G34** — you wrote this before two
   modules existed and the contract is the only authority.

## The trap, and it is the whole point of the task

**Do NOT open `Godot/scripts/GrappleSeat.gd` or
`Godot/scripts/GrappleResolve.gd`.** Not to check a name, not to "see what it
does", not to confirm your fix. A test written or repaired against a delivered
implementation only ever agrees with it, and that is precisely the failure the
blind arrangement exists to prevent — the same reason the module and the test
are two tasks. Every change you make comes from `G34_GRAPPLING_CONTRACT.md`
and from nowhere else.

If G34 is genuinely ambiguous about a rule, **say so in the digest as an
ambiguity and pick the reading you can defend from the text** — do not resolve
it by looking at what somebody built. Qwen resolved the `half` hold-ticks
ambiguity to 60 and reported that it "aligned with C67's blind test"; if that
means it read your file, the separation leaked in the other direction. Yours
must not.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/tests/grapple_contract_test.gd` | 236 | Yours. Read it whole. |

**Read only that file and `research/G34_GRAPPLING_CONTRACT.md`.** Do NOT
read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any digest, the
two grapple modules, or Cursor's branch. **`GameState.gd` is 14,766 lines and
has nothing to do with this task — never open it.**

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/tests/grapple_contract_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grapple_contract_test.gd
python Godot/tools/run_tests.py
```

**This test is EXPECTED to fail** while `GrappleResolve.gd` is absent from
master, and that is not a reason to change an assertion. What you must verify
is that it fails **for the right reason** — the named missing module — and that
your repaired assertions are the ones that would run. Say in the digest which
assertions you could and could not exercise.

**Ceiling, not an exact count:** `fails=1` or better, and the 1 is this file.
If Claude's R90 merge has already landed `GrappleResolve.gd` by the time you
run, the real number may be **0**, or it may be a genuine contract
disagreement — **if it comes back better than expected, say so and push**, and
if it comes back as a disagreement, report the disagreement rather than
retuning the assertion to match the module.

## Done

Commit, push `master`, write a short `research/C70_DIGEST.md`, then send
one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic "C70-done" --body "<commit> <suite line> <what else of that class you found> <any G34 ambiguity>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

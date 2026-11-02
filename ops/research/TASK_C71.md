# TASK C71 — CODEX — THE BLIND TEST FOR THE TWO SOURCED LADDERS

Model: **Codex, medium effort, Fast mode off.** Owner: Codex. Base: `master`
at `043a99a` or later. **Do this AFTER C70, and after C69 if C69 is already
under way.** It is small.

---

## Why this exists

Qwen is wiring two new practitioner grade ladders into `GradeLadder.gd` as Q21,
pasting them from a research file. You are writing the test **blind, from the
same research file, without reading what Qwen typed.**

This arrangement has now paid for itself three times on the grapple arc: C67's
blind test caught nothing wrong with `GrappleSeat.gd`, Qwen found a real defect
in C67's test from failure output alone, and R90's run of it surfaced a hole in
the contract that neither module author had noticed. **A test written against
an implementation only ever agrees with it.** This one is written against the
source.

The failure mode it exists to catch is specific and dull: **a mistyped or
reordered rung.** Savate's sequence is `gant_bleu, gant_vert, gant_rouge,
gant_blanc, gant_jaune, …` — white sits *after* red, which is not what a
colour-belt instinct predicts, and is exactly the kind of thing a careful
person "corrects" on the way through.

## Your source, and your only source

**`research/G36_THE_FIVE_LADDERS.md`.** Read it whole. Everything you
assert must trace to it.

## The contract — the API you test against, so you need not read the module

`GradeLadder.gd` exposes these statics. Signatures are given here **so that you
do not open the file**:

```gdscript
static func has_ladder(discipline: String) -> bool
static func ladder_for(discipline: String) -> Array          # lowest rung first
static func grade_index(discipline: String, grade: String) -> int   # -1 if absent
static func minimum_weeks(discipline: String, from_grade: String, to_grade: String) -> int
static func minimum_age(discipline: String, grade: String) -> int
static func words(discipline: String, grade: String) -> String
```

Two conventions that decide half your assertions:

* **`minimum_weeks` / `minimum_age` return `-1` for "no sourced rule".** Never
  `0`. Zero is a much stronger claim than silence.
* Discipline keys are lowercase snake_case.

## What to assert

1. **Savate has a ladder, and it is exactly G36's eight rungs in G36's order.**
   Assert the sequence positionally — `ladder_for("savate")[3] == "gant_blanc"`
   and so on — not merely that the set of names matches. Order is the thing
   that will be wrong.
2. **The three `kangourou_*` rungs are NOT on the savate ladder.** G36 defaulted
   them off as youth-only. Assert their absence by name.
3. **Sambo has a ladder, exactly ten rungs, `novice` first and `grand_master`
   last**, in G36's order.
4. **No burgundy-named rung exists on the sambo ladder.** G36 marks this as its
   one inference and warns against inventing one; burgundy is a stripe colour,
   not a level name.
5. **The three REFUSED disciplines still have no ladder** — pencak silat,
   arnis, capoeira. `has_ladder()` false, `ladder_for()` empty.
6. **The three C52 disciplines still have no ladder** — boxing, wrestling,
   sanda. If one of these ever gains a ladder, this assertion is the alarm.
7. **No `MINIMUM_WEEKS` entry exists for savate or sambo, at any rung pair.**
   G36 found none published. Walk consecutive pairs of both ladders and assert
   `minimum_weeks(...) == -1` for every one. **This is the assertion most
   likely to catch a well-meaning invention** and it is the reason this task
   exists at all.
8. **Exactly the sourced ages, and no others.** `savate|gant_argent_technique_1`
   is 16. Every other rung of both ladders returns `-1` — including the savate
   moniteur age, which G36 marks as a **teaching-diploma** gate rather than a
   grade-award gate and which therefore must NOT be in `MINIMUM_AGE`.
9. **`words()` returns something non-empty for every rung of both ladders**, and
   `grade_index()` round-trips: for every rung, `ladder_for(d)[grade_index(d, g)] == g`.

## What NOT to do

* **Do not read `Godot/scripts/GradeLadder.gd`.** Not to check a name, not to
  "confirm the API", not at the end to see if you passed. The signatures above
  are the contract. If something in G36 is genuinely ambiguous, **assert what
  G36 says and report the ambiguity** — a disagreement is the deliverable.
* **Do not edit `grade_progression_test.gd`** (Qwen, Q21) or
  `grade_ladder_test.gd`. Your file is new.
* Do not re-research any discipline. G36 is the authority even where you
  personally know a different ladder exists.

## Owned files

| File | Lines | Note |
| --- | --- | --- |
| `Godot/tests/grade_ladder_sourced_test.gd` | new | Yours, and the only file you write. |
| `research/C71_DIGEST.md` | new | Short. |

Read **only** `research/G36_THE_FIVE_LADDERS.md`. Do NOT read
`HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any other digest, or
`GradeLadder.gd`. **`GameState.gd` is 14,766 lines and has nothing to do with
this task — never open it.**

Follow the house test shape: a `_check(cond, label)` helper, a printed
`GRADE_LADDER_SOURCED_TEST PASS (N checks)` on success and an explicit
`failures=N` line otherwise. A test that prints nothing of its own is scored a
failure by the runner (R75).

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/tests/grade_ladder_sourced_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/grade_ladder_sourced_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count.** If Q21 has already landed, the target is
`fails=0` and your test should be green on the first run. **If Q21 has NOT
landed yet, your test will be red and that is correct** — say so plainly and
push it red, exactly as C67 was pushed red before `GrappleResolve.gd` existed.
Never soften an assertion to make a missing module look present.

## Done

Commit, push `master`, write `research/C71_DIGEST.md`, then send one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic "C71-done" --body "<commit> <suite line> <red-by-design or green> <any G36 ambiguity>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block.

## The trap specific to this task

**The assertion you are most likely to get wrong is number 7, and getting it
wrong looks like diligence.** G36 found no published time-in-grade minimum for
savate or sambo, so those keys must be **absent** and `minimum_weeks()` must
answer `-1`. The tempting move is to assert a plausible interval, or to skip
the check because "there is nothing to test". Both are wrong: the absence *is*
the sourced finding, R89's `authored` label depends on it, and an unasserted
absence is exactly how an invented number gets in later without anyone noticing.
Assert that nothing is there.

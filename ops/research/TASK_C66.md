# TASK C66 — CODEX — THE TEST THAT WOULD HAVE CAUGHT ALL SEVEN

Model: Opus, high effort, Fast off. Owner: Codex. Base: `c885c5f`,
`SUITE total=204 fails=0`.

You own `Godot/tests/fight_reaches_its_modules_test.gd` (new). **You will not
see the wiring you are testing.** R87 (Claude) is adding it in parallel; write
this from the contract below, not from the delivered code — a test written
against an implementation only ever agrees with it.

---

## Why this test exists, and it is the whole point of the task

**This area has now shipped SEVEN pieces of correct, tested, unreachable code.**
`FightTrauma.gd` and `Cardio.gd` are the sixth and seventh: both green, both
with their own passing tests, both called by nothing. Of the five before them,
three turned out to be *defective* — `absorbed`/`slipped` were unproducible,
`stamina` was never drained, and a flash knockdown was arithmetically
impossible (shock peaked at 0.16 against a floor of 0.25). Every one survived a
green suite, because every test checked a single function in isolation and none
asked whether the pieces could ever line up.

**Assert that a feature OCCURS, not that it is permitted.** That sentence is the
task. You are writing the test that no amount of unit coverage produced.

## What to assert

Run real seeded bouts through `FightRealtime` and assert, in the engine's own
emitted numbers:

1. **Trauma actually accumulates.** Over a sample of seeded bouts, at least one
   fighter finishes with total pips above zero. Not "aggravate can be called" —
   pips on a face at the final bell. Report the measured rate across the sample
   (how many bouts in N produced a mark) in a printed line, the way R84/R86 do.
2. **A heart rate actually moves.** Sample a fighter's heart rate early and late
   in the same bout and assert it changed, and changed in the direction fatigue
   implies. A heart rate constant across every round is a wired module that is
   not reached.
3. **Neither is silently at a floor or a ceiling.** A value pinned at its
   minimum in every bout is indistinguishable from an unwired module. Assert the
   observed range is non-degenerate and print it.
4. **The seeded fight is still seeded.** Two runs of one seed agree on trauma and
   on heart rate, not only on the log. If the wiring drew its roll off an
   existing RNG stream, this is where it shows.
5. **Trauma is never mutated in place.** `FightTrauma.aggravate` returns a copy;
   if the engine ignored the return value, pips stay at zero forever and gate 1
   catches it — but assert the purity directly too.

Where a rate is low, **report it rather than tuning the engine to raise it** —
you do not own the engine in this task. A measured "1 bout in 40 opens a cut" is
a finding; silently making it fire more often is the mistake R84 made.

## THE CONTRACT you are testing against

After R87 the engine is expected to carry per-fighter `trauma` (the
`FightTrauma.fresh()` shape) and `age_years`. The read is available as one fold,
`FightHudRead.fold(state)` (Q18, Qwen, landing in parallel) — its contract is in
`research/TASK_Q18.md` and you may read that file. **Prefer folding
through `FightHudRead` where it is present, and fall back to reading the state
directly if it is not** — neither sibling is guaranteed to land before yours, and
a test that cannot run until two other agents finish is a test that blocks the
stage.

Module contracts you may read whole, both small:
`Godot/scripts/FightTrauma.gd` (158 — `SITES` `:16` has **no `head_neck`**,
`aggravate` `:48` takes the roll from the caller, `worst` `:64`, `total_pips`
`:79`), `Godot/scripts/Cardio.gd` (122 — `from_stamina` `:83`, `zone` `:106`,
both need `age_years`).

## Owned files

| File | Lines | How to read it |
| --- | --- | --- |
| `Godot/tests/fight_reaches_its_modules_test.gd` | new | Yours, and the only file you write. |

Read-only, and **never whole**: `Godot/scripts/FightRealtime.gd` (940) — `begin`
`:181`, `run_to_completion` `:411`, `result` `:428`, `_close_round` `:475`,
`_run_impact` `:707`. For the pattern to copy — how a seeded bout is driven and
how a rate is measured and printed — read `Godot/tests/fight_realtime_test.gd`
(837) at `_run_pair` `:78`, `_test_a_knockdown_is_rarer_than_being_hurt` `:532`
and `_test_stamina_is_actually_spent` `:557`. **Never open `GameState.gd`
(12,900+ lines).**

## Gates

1. Your test must **fail loudly against today's `master`**, where nothing is
   wired — that is the proof it asserts occurrence. Say so in your report, and
   say what it prints when it fails.
2. It must **pass once R87 lands** without being edited to suit the
   implementation. If it does not, that is a contract disagreement worth
   reporting, exactly as G30T and G31T reported theirs.
3. Print your own summary line and your own `failures=N`. **The exit code alone
   is not a pass** (R75): a GDScript runtime error leaves rc=0.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/tests/fight_reaches_its_modules_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_reaches_its_modules_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** your own test is expected to FAIL until R87
lands, so the suite will read `fails=1` while you hold this task. **Do not push a
weakened assertion to make the suite green.** Commit the failing test only if you
also say plainly in your mail that it is red by design and why; otherwise hold it
and report. If the suite is better than `fails=1`, say so and push.

## The trap specific to this task

**Do not assert an exact rate or an exact bpm.** R86 moved every seeded fight,
and R85 had to re-find three pinned seeds because of it. A test that pins "37
bouts in 120 open a cut" goes red on the next tuning pass and teaches everyone to
re-pin instead of to look. Assert the feature occurs and the range is
non-degenerate; print the measurement for a human, and gate on a ceiling or a
floor, never on equality.

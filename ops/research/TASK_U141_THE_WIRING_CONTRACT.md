# TASK_U141 — THE GROUND CHOOSER'S *WIRING* CONTRACT, WRITTEN BLIND

**Model: `composer-2.5`, medium effort.** Worktree `FightCamp-U114`, cut a FRESH
branch off `origin/master` named `cursor/u141-wiring-contract`. Your mail rides
your branch, so name the branch in the message you send.

**Owned files — create only this:**
- `Godot/tests/ground_arm_wiring_test.gd`

**Read this file and nothing else.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any digest, or any `S58_*` file.

---

## YOU ARE FORBIDDEN TO READ THE WIRING

**Do NOT open `Godot/scripts/FightRealtime.gd`.** Do not grep it, do not read it
in a diff, do not read the commits that touched it. You wrote the contract test
for the ground graph MODULE last time and it paid. **This one is for the
ENGINE's use of it**, and it is worth more than the module test was, because a
module test cannot see a caller that starves it — which is exactly what
happened: a scoring term read zero on every decision for a whole stage and no
gate noticed, *because zero is a legal score*.

Write the test from the DEFINITION below. Where it is ambiguous, pick the
reading a careful engineer would pick, assert it, and say in your digest which
reading you took. **A disagreement with the engine is a FINDING, not a
failure.**

---

## THE DEFINITION

`FightRealtime.begin(fighter_a, fighter_b, options)` returns a `state`
dictionary. `FightRealtime.advance_tick(state)` advances one tick.
`FightRealtime.result(state)` returns the verdict. There is an option
**`ground_arm`**, a String, one of `"current"`, `"decay"`, `"graph"`, `"both"`,
**defaulting to `"current"`**. An unrecognised value must fall back to
`"current"` rather than raise.

The arms:

- **`current`** — the shipped engine. Ground positions advance by a fixed
  one-way ladder, and control pays a flat rate per scoring tick.
- **`decay`** — same behaviour, but a held position PAYS LESS the longer it is
  held uninterrupted.
- **`graph`** — the top man CHOOSES between several legal transitions out of
  his position instead of always taking the one the ladder offers; control pays
  the flat rate.
- **`both`** — chooser and reduced payout together.

The state carries these witnesses, which you may read:

- `state["ground_arm"]` — the resolved arm.
- `state["ground_edges"]` — `{edge_id: count}`, every transition the chooser
  selected. **Empty on `current` and `decay`**, because the chooser does not run
  on those arms.
- `state["ground_rolls"]` — `{"0".."9": count}`, the chooser's own random roll
  bucketed into ten equal bands of 0..1.
- `state["ground_decisions"]` — how many times the chooser ran.
- `state["ground_skill_live"]` — of those, how many had at least one candidate
  whose TRAINED-SKILL term scored above zero.
- `state["control_units"]` — running total of control scored.

## WHAT TO ASSERT — these are the properties, in priority order

1. **THE DEFAULT IS `current`, AND `current` IS THE SHIPPED ENGINE.** Run the
   same seed with no `ground_arm` option and with `ground_arm: "current"`. Every
   observable must be identical — same verdict, same `control_units`, same log
   length. An unknown arm string must behave as `current` too.
2. **DETERMINISM.** The same seed and the same arm, run twice, must produce
   identical results. Run this for all four arms.
3. **THE ARMS MUST ACTUALLY DIFFER.** `graph` must produce at least one edge and
   `current` must produce none, on a seed where the fight reaches the ground.
   **If you cannot find such a seed, that is a FINDING and you must report it
   rather than assert something weaker** — a test that passes because the men
   never grappled is the failure this whole task exists to catch.
4. **THE CHOOSER'S ROLL IS UNIFORM.** Across a decent number of decisions, no
   band of `ground_rolls` should be wildly over- or under-represented. Pick a
   tolerance you can defend and say why. **A non-uniform roll means the weights
   are not what decides.**
5. **THE SKILL TERM ANSWERS.** On `graph` and `both`,
   `ground_skill_live` must be **greater than zero** whenever
   `ground_decisions` is greater than zero. This is the specific defect that
   went unnoticed for a stage; make it impossible to reintroduce silently.
6. **THE RNG BUDGET IS UNCHANGED.** The chooser must consume no extra random
   draws. You cannot see the streams directly — so assert it the way you CAN:
   the non-grapple behaviour of a bout must be unaffected by the arm. Say in
   your digest how you chose to observe that and what your check would miss.

**A fighter's population matters.** Build two DIFFERENT fighters — never one man
twice, never the same stat block, and never an empty one. Note the key is
**`"stats"`**, not `"attributes"`; the wrong spelling silently yields two men on
identical defaults, which has caused three shipped bugs here. Give one a high
`grapple` and one a low one so the fight actually reaches the floor. Print both
stat blocks in your own output and **fail the test if they match**.

---

## TEST TIER — A NEW TEST FILE ONLY

No script is edited, so the gate is the parse gate plus **that one test**:

```
python Godot/tools/check_scripts.py Godot/tests/ground_arm_wiring_test.gd
python Godot/tools/run_tests.py --only ground_arm_wiring
```

**DO NOT RUN THE FULL SUITE.** A new test file cannot break another test, so it
costs twenty minutes and buys nothing.

**Gate as a CEILING:** `fails=0` or better.

**The exit code alone is NOT a pass.** A GDScript runtime error leaves rc=0, so
a broken test prints `SCRIPT ERROR` lines, then `0 failure(s)`, then exits 0.
Read the output. Godot's `N RID allocations ... were leaked at exit` and
`N resources still in use at exit` are teardown chatter and are already
filtered.

**PROVE THE TEST WITH MUTANTS.** A green test that cannot fail is worth nothing.
You cannot mutate `FightRealtime.gd` (you may not even read it), so mutate your
own ASSERTIONS instead: for each property above, temporarily invert or weaken
the check and confirm the test goes red for the right reason. Report which ones
you exercised. **If a property cannot be made to fail, say so — that is a hole.**

---

## GDSCRIPT TRAPS

- `var x := <call>` fails when the call returns Variant (`.size()` or `.get()`
  on an untyped value, a static on a `load()`ed script). Write the type:
  `var n: int = ...`.
- **Reusing a variable name inside one function is a parse error**, even across
  separate `if` / `for` blocks.
- `%` inside a format string must be `%%`.
- `callv` with the wrong arity returns `{}` rather than `null`, so
  `if result != null` passes and your assertion measures nothing. Check
  CONTENTS, never just non-null.

## THE ONE TRAP SPECIFIC TO THIS TASK

**A bout that never goes to the ground makes every assertion here vacuous, and
it will still print `fails=0`.** `ground_decisions` will be 0, `ground_edges`
empty on every arm, and properties 3, 4 and 5 will all pass by having nothing to
check. **Assert non-vacuity FIRST and loudly**: the fight must reach the floor,
the chooser must run some minimum number of times, and the test must FAIL — not
skip, not warn — if it did not. Then everything below it means something.

---

## WHEN YOU ARE DONE

Commit, push, write `research/U141_DIGEST.md`, and send one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic U141 --body "<one line, NAME THE BRANCH cursor/u141-wiring-contract>"
```

**Do NOT edit `HANDOFF.md`** — I write your block.

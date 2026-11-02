# TASK_C146 — CODEX — THE BLIND CONTRACT TEST FOR THE GRAPPLE OFFENCE/DEFENCE SPLIT

**Agent:** Codex · **Model:** `gpt-5.6-luna` · **Effort:** medium · **Fast:** off
**Launch:** `python Tools/next_task.py codex --launch`, or
`Tools\codex_task.cmd <this file>` with WINDOWS paths from PowerShell.
**Branch:** `codex/c146-grapple-split-contract` — **branch from `master`.**
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

**Test tier — you add ONE NEW TEST FILE and edit no script:** parse gate
(`python Godot/tools/check_scripts.py Godot/tests/fight_grapple_split_test.gd`),
then that ONE test. **NO full suite, no `--only` sweep.** A new test file cannot break
another test, and a suite run here costs eighteen minutes and buys nothing.

---

## YOU ARE THE BLIND HALF. THIS IS THE WHOLE POINT OF THE TASK.

Cursor is implementing the grapple offence/defence split right now as U118, on a branch
called `cursor/u118-grapple-split`. **You must not read it.** Do not fetch it, do not
`git log` it, do not look at `origin/cursor/*` at all, and do not grep the working tree for
`grapple_offense` to "see how it was done". Write the test from the CONTRACT in this file and
from nothing else.

This split has paid three times on this project — C142, C143 and C144 — and the reason it
works is exactly that the two halves never touch. A test written against an implementation
only ever agrees with it. **If your test disagrees with Cursor's module, that disagreement is
the finding and it is valuable.** Report it; do not go looking for the implementation to
reconcile yourself to it.

**If the stats do not exist yet when you run**, your test must SKIP LOUDLY — print a line
saying the contract is not implemented yet and exit 0 with `failures=0`. It must not fail, and
it must not silently pass either. Say which names were missing.

## THE CONTRACT

The operator ruled on 2026-09-21 that the fighter stat list is **the grounded 8**:
`power`, `speed`, `technique`, `defense`, `conditioning`, **`grapple_offense`**,
**`grapple_defence`**, `top_control` — with `fight_iq` staying DERIVED.

**SPELLING IS PART OF THE CONTRACT AND IT IS DELIBERATELY MIXED. Use exactly
`grapple_offense` (US, "-ense") and `grapple_defence` (UK, "-ence").** Do not normalise
either one. If a stat is present under a different spelling, that is a FAILURE your test
reports, not a variant it accepts.

**C146 covers the grapple split ONLY.** `top_control` is a separate slice and is NOT yours —
do not test for it, do not require it, and do not fail if it is absent.

The stats block key is **`"stats"`**, never `"attributes"`. `"attributes"` silently yields an
empty block, which reads as every stat at its default; this project has been burned by it
three separate times.

## WHAT THE TEST MUST ASSERT

**1. BOTH STATS EXIST AT GENERATION, under exactly those two names**, on a generated athlete,
alongside the other six. Assert the values are in the legal stat range the other six use.

**2. THEY ARE NOT THE SAME NUMBER, AND NEITHER IS A FUNCTION OF THE OTHER.** Generate a
population of at least 200 athletes and assert the Pearson correlation between
`grapple_offense` and `grapple_defence` is **below 0.90** in absolute value. They are expected
to be positively correlated — a good takedown artist is usually not hopeless at stopping one —
so do NOT assert independence. Assert only that neither is a restatement of the other.
Q119 part 1 used the same shape of check and landed `grapple` at 0.3525 against the mean of
six, so a real roll comfortably clears this bar.

**3. NEITHER IS A RESTATEMENT OF THE OLD `grapple`.** If a `grapple` key still exists, assert
its correlation with EACH of the two splits is below 0.99 in absolute value — i.e. the split
is not one stat wearing three names. If `grapple` is gone entirely, that is legal: skip this
assertion and print that it was skipped and why.

**4. THE ASYMMETRY IS REAL — THE LOAD-BEARING ASSERTION.** Build **two different fighters**:
  - **A**: high `grapple_offense`, low `grapple_defence`
  - **B**: the reverse — low `grapple_offense`, high `grapple_defence`

  Run takedown resolution **both directions** over enough seeded trials to be stable (aim for
  ≥400 per direction) and assert **A attacking B succeeds at a materially higher rate than B
  attacking A**. Report both rates in the output whatever the result.

  **NEVER TEST IDENTICAL FIGHTERS** (operator rule, no exceptions). A and B differ in the two
  grapple stats; hold everything else equal between them and SAY SO in the output — name the
  population in the test's own printed lines, so a later reader can tell a finding from a
  fixture. Two men built from the same numbers are not a control group.

**5. A DEFENSIVE STAT CANNOT HELP YOU ATTACK.** Hold `grapple_offense` fixed and raise
`grapple_defence` alone; assert the fighter's own takedown SUCCESS rate does not rise. Then the
mirror: hold `grapple_defence` fixed, raise `grapple_offense` alone, and assert the rate at
which he is TAKEN DOWN does not fall. **This is the assertion that catches the most likely
real bug** — a read left pointing at the wrong half of the split, which would otherwise look
like a working feature.

**6. NO READ FALLS BACK TO A DEFAULT.** Give a fighter a stats block that omits both new keys
and assert the engine does not silently treat him as average. Either it refuses, or it uses a
documented default that the test names. Whichever it is, pin it — a silent default is how a
decorative stat hides.

## THE CALL SITES THE CONTRACT COVERS

From `research/Q119_THE_STAT_FLOOR.md` — **read that file, it is the read table**:

| id | resolver | side |
|---|---|---|
| takedown | `GrappleResolve.takedown_resolve` — `GrappleResolve.gd:76` | both |
| throw | same resolver — `GrappleResolve.gd:76` | both |
| sweep | `GrappleResolve.position_resolve` — `GrappleResolve.gd:98` | both |
| submission_attempt | `GrappleResolve.submission_advance` — `:122`, tick `:147` | both |
| clinch_break | `CLINCH_OFF_WEIGHTS` — `:27` + `DEF_WEIGHTS` | both |
| submission_finish | `GrappleResolve.gd:127` | **no stat read — flat. LEAVE IT.** |
| escape | `FightSimulation._resolve_escape_attempt` — `FightSimulation.gd:2664` | defensive |
| stand_up | same — `FightSimulation.gd:2664` | defensive |
| control | `FightSimulation._top_control_norm` — `FightSimulation.gd:2651` | offensive |

The attacker's side of a contested resolve reads `grapple_offense`; the defender's side reads
`grapple_defence`. `control` is offensive; `escape` and `stand_up` are defensive.
`submission_finish` reads no stat and must stay that way — **assert it did not acquire one**,
because adding a read there is a rebalance nobody asked for.

## PROVE THE TEST WITH MUTANTS — NOT OPTIONAL

C117 passed thirty checks against a lock on a swinging foot. **Before you collect, break the
contract deliberately at least FOUR ways and confirm your test goes red each time**, then put
the mutant table in the digest:

1. make `grapple_defence` a copy of `grapple_offense` → assertion 2 must fail
2. route the defender's side of `takedown_resolve` to `grapple_offense` → assertion 5 must fail
3. delete `grapple_defence` from generation → assertion 1 must fail (not skip — it exists
   partially, which is different from not implemented at all; make sure your skip path can
   tell those two apart)
4. give `submission_finish` a stat read → assertion on it must fail

A mutant your test survives is a hole in the test. Fix the test, not the mutant.

## OWNED FILES

- `Godot/tests/fight_grapple_split_test.gd` (new — the test)
- `research/C146_THE_BLIND_SPLIT_CONTRACT.md` (new — the digest, under 60 lines,
  and it MUST carry the mutant table)

**Touch NOTHING else.** No script, no other test, no data file, no `HANDOFF.md`.

## TRAPS

1. **`var x := <call>` fails when the call returns Variant**, and `Dictionary.get()` on an
   untyped stats block is exactly that. Write the type: `var n: float = ...`. **A parse error
   does not fail a headless test, it HANGS it until the timeout.**
2. **Type your `load()`ed values.** A static called off a `load()`ed script returns Variant.
3. **Reusing a variable name inside one function is a parse error in GDScript**, even across
   separate `if`/`for` blocks.
4. **`%` inside a format string must be `%%`.**
5. Scene scripts compile before the autoloads: use `get_node_or_null("/root/GameState")` plus
   `has_method`, never the bare `GameState` identifier.
6. **The suite counts a test that prints no output of its own as a FAILURE.** Print your rates.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push the branch, then one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic c146-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. **Unstage `AgentComms/messages` before any commit that is not the
mail itself**, and after committing run `git show --stat HEAD` and check the file list is
exactly what you meant — the checkout is shared, and on 2026-09-21 a scoped `git add` still
swept in another agent's staged work.

**THE ONE TRAP SPECIFIC TO THIS TASK:** the temptation at the end will be to check your test
against Cursor's branch before reporting, to be sure you agree. **Do not.** The value of this
task is destroyed the moment you look. Report what your test says about master, and let the
integration find the disagreement — that is the job it exists to do.

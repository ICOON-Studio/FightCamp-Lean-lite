# TASK C96 — CODEX — FIND THE NEXT R133: WHERE THE SHIPPED SCREEN AND THE TEST DISAGREE

**Model:** gpt-5.6-luna, **medium effort — NEVER high**. Fixed at assignment.

**Test tier:** THIS IS A READ-ONLY AUDIT plus ONE new test file. You edit no
existing `.gd` under `scripts/`. Parse gate on your new test file, then run
**that one test only**. **Do NOT run the full suite** — it costs twenty minutes
and a new test file cannot break another test.

Read THIS FILE and the files it names. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest. Do not explore to get
oriented.

---

## THE DEFECT YOU ARE HUNTING FOR MORE OF

Yesterday we found this, and it had been shipped and green for a long time:

> `FightWorldLiveScreen` — the **live fight route**, the one a player actually
> reaches — built its fighter dictionary with a key called **`"attributes"`**.
> `FightRealtime._build_fighter` (`Godot/scripts/FightRealtime.gd:488`) reads
> **`athlete["stats"]`**. Nothing mapped one to the other, so the engine received
> an **empty stats dictionary** on every live fight. A 66.7 kg welterweight and a
> 120 kg heavyweight were **mechanically identical**.
>
> **The seeded tests passed `"stats"` and always had.** The tests and the shipped
> screen disagreed about the contract, and only the tests were ever checked. The
> suite was green through the entire life of the bug.

It is fixed. **Your job is to find out how many more of these there are.** This
is an audit, not a fix mission — though you will write one test.

## WHAT YOU ARE ACTUALLY MEASURING

For every **production caller** of the two fight engines, compare the dictionary
it hands in against what the engine reads out, **key by key**.

The two engines and their entry points:

- `Godot/scripts/FightRealtime.gd` — `_build_fighter` at **:488**, called from
  **:429–430**. This is the real-time engine.
- `Godot/scripts/FightSimulation.gd` — `_build_fighter_state` at **:889**, called
  from **:439–440**. This is the seeded/simulated engine.

Both files are large. **Do not open either one whole.** Read `sed -n 'A,Bp'`
windows around the line numbers above, then grep for the key reads:

```bash
grep -n 'athlete\[\|athlete\.get(\|fighter\[\|fighter\.get(' Godot/scripts/FightRealtime.gd | sed -n '1,120p'
grep -n 'athlete\[\|athlete\.get(\|fighter\[\|fighter\.get(' Godot/scripts/FightSimulation.gd | sed -n '1,120p'
```

The production callers to audit — these are the ones a player reaches:

- `Godot/scripts/FightWorldLiveScreen.gd` (the R133 site; **already fixed**, use
  it as your worked example of what a hit looks like — see the comment at **:454**)
- `Godot/scripts/FightNightScreen.gd`
- `Godot/scripts/RingStagePanel.gd`
- `Godot/scripts/ContenderSeries.gd`
- `Godot/scripts/FightOpponentGenerator.gd` (what shape does a *generated*
  opponent come out as? It is fed straight to an engine.)
- `Godot/scripts/GameState.gd` — **~13,000 lines, NEVER open it whole.** Grep for
  the call sites and read only those windows.

And the tests that pass the *correct* shape, as your reference for what the
contract is supposed to be — grep `Godot/tests/` for whichever files construct a
fighter dictionary and call either engine.

## THE THREE QUESTIONS, PER CALLER

1. **Every key the engine READS** — is it present in what this caller BUILDS?
   A missing key that `.get(k, default)` silently defaults is exactly the R133
   shape and is the thing you are looking for.
2. **Every key the caller BUILDS** — is it read by anything? A key nobody reads
   is dead weight and may be a rename that only got done on one side.
3. **Does this caller's shape match what the TESTS pass?** Where they differ,
   say which one is wrong. **Do not assume the test is right** — prove it from
   what the engine reads.

## OWNED FILES

- `research/C96_ENGINE_CONTRACT_AUDIT.md` — your findings. New file.
- `Godot/tests/test_engine_input_contract.gd` — ONE new test. New file.

**You edit nothing else.** If you find a defect, **report it, do not fix it** —
a fix moves seeded fights and that is a rebaseline, which is Claude's call.

## THE TEST YOU WRITE

`Godot/tests/test_engine_input_contract.gd` asserts the contract **that the
production path must satisfy**, not the one the existing tests happen to use:

- For each engine, assert that a fighter dictionary built the way the **shipped
  screen** builds it produces a non-empty, fighter-specific internal state.
- The sharp version of the R133 assertion: **two fighters with clearly different
  stats must produce measurably different engine state.** If they come out
  identical, the stats never arrived. Assert the quantity a player would see.
- Keep it deterministic and do not depend on a full bout running.

Follow the existing style in `Godot/tests/`; read two or three neighbouring test
files first for the harness idiom. A test must print its own pass/fail line —
**a test that prints nothing is counted as a failure by the runner**, and rc=0 is
not a pass.

## THE GATE

```bash
python Godot/tools/check_scripts.py Godot/tests/test_engine_input_contract.gd
%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/test_engine_input_contract.gd
```

Your test must pass. **If writing the honest assertion makes it FAIL because you
found a real defect, that is the best possible outcome — but then you must not
push a red test into the suite.** Instead: mark the failing assertion as a
documented pending check (a printed `KNOWN GAP:` line that does not count as a
failure), keep the test green, and lead your write-up with the defect. Say
clearly in the commit message that the gap is reported and not fixed.

## THE TRAP SPECIFIC TO THIS TASK

**`.get(key, default)` is invisible.** The R133 bug produced no error, no warning
and no log line — the engine read a key that was not there, took the default, and
ran a complete, plausible fight. **You cannot find this class of bug by looking
for errors.** You find it only by listing what is read and what is built and
diffing the two lists. Do that mechanically and completely; do not sample.

Second trap: `var x := <call>` fails to compile when the call returns Variant —
and `.get()` on an untyped dictionary returns Variant. Write the type:
`var n: int = ...`. A parse error **hangs** a headless test for 600 s instead of
failing it, so run the parse gate first, every time.

## WHEN YOU ARE DONE

```bash
git add -- research/C96_ENGINE_CONTRACT_AUDIT.md Godot/tests/test_engine_input_contract.gd
git commit
git push origin master
python Tools/agent_comms.py send --from codex --to claude --subject C96-done --body "callers_audited=<N> keys_read=<N> mismatches=<N> worst=<file:line> test=pass|known_gap"
```

Check `git status -s` before you stage. Stage explicit paths only. Do **NOT**
edit `HANDOFF.md`.

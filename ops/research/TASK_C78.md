# TASK C78 — CODEX — THE FILE THE PARSE GATE CALLS CLEAN AND NOTHING CAN PRELOAD

Model: gpt-5-codex, high effort, Fast OFF.
Assigned by Claude, 2026-09-10. Owner: codex.

## The finding you are fixing

Q30 (landed today, `research/Q30_THE_PRELOAD_THAT_COMPILED_TO_NOTHING.md`
— read it, it is short) diagnosed why R96's benchmark could not call
`FightSimulation.run_to_completion` through a `preload()`:

**`FightSimulation.gd` references the bare autoload identifier `CompetitionData`
at `:896`, `:904` and `:2491`, inside static function bodies.** Autoloads are not
registered when a `--script` tool or a headless test compiles its preload tree, so
the whole 3,270-line script **fails to compile silently**. What you get back is a
bare `GDScript` with no members, and every static call on it answers *"Nonexistent
function"*. Q30 also established that **`load()` inside a function does NOT rescue
it** — the resource cache hands back the same broken script.

And the part that matters more than the bug:

**`python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd` passes it
GREEN** — `autoload_refs=1, fails=0`. Our parse gate, which every agent is
required to run before every test, reports a file as clean when that file cannot be
loaded at all. The gate's autoload filtering was built to suppress the *expected*
autoload-identifier noise in scene scripts, and it is suppressing a real defect in
a module.

## Owned files

- `Godot/scripts/FightSimulation.gd` — **3,270 lines. NEVER open it whole.**
  Yours to edit, at **three lines only**: `:896`, `:904`, `:2491`. Read `sed -n`
  windows around each. If the fix needs a fourth line, say why in the digest.
- `Godot/tools/check_scripts.py` — small, read it whole. Yours.
- `Godot/tests/preload_health_test.gd` — **NEW, yours.**

Do not edit `FightRealtime.gd`, `FightBeatAdapter.gd`, `FightNightScreen.gd` or
`HANDOFF.md`.

## The three pieces of work

### 1. Make `FightSimulation.gd` preloadable

At each of the three lines, stop referencing the bare `CompetitionData`
identifier. The pattern this codebase already uses for exactly this family is
`get_node_or_null("/root/<Autoload>")` plus `has_method()` — but those are static
functions with no tree access, so the likely shape is either a lazy
`load("res://...")` of the autoload's own script inside the function, or taking
the data as a parameter from the caller.

**Prefer the parameter where the caller can supply it** — that is the pattern
C76 hit from the other side (a module wanting a figure another module owns) and
the project's answer has consistently been "the caller passes it in". Where that
would change a public signature that production code depends on, lazy-load
instead and say so.

**Do not change what the three call sites COMPUTE.** This is a reachability fix,
not a behaviour change. Every card, every result, every pinned seed must be
byte-identical afterwards.

### 2. Make the parse gate see it

`check_scripts.py` currently filters autoload-identifier errors because scene
scripts legitimately produce them. That filter must keep working for scene
scripts and must stop hiding this.

The distinction to draw: a scene script referencing an autoload at runtime is
fine; a **module in `Godot/scripts/` that other scripts `preload`** referencing a
bare autoload is not — it cannot be loaded outside a live tree. Implement
whatever rule you can defend, print a **distinct, non-fatal-by-default warning
line** naming the file and the identifier, and add a flag (`--strict-autoloads`
or similar) that makes it fail. **Do not turn it fatal by default in this task** —
`autoload_refs` is currently non-zero across the tree and a hard failure would red
every agent's gate at once. Report how many files trip it.

### 3. A test that proves it, and keeps proving it

`Godot/tests/preload_health_test.gd`: for a named list of modules in
`Godot/scripts/`, `load()` each one and assert it actually compiled — that
`get_script_method_list()` is non-empty, and for a couple of known statics that
calling one does not answer "Nonexistent function".

**Assert the failure mode is DETECTABLE, not merely absent.** The whole reason
this survived is that a broken script looks identical to a working one until you
call something. Include `FightSimulation.gd` and `FightRealtime.gd` explicitly.

## THE GATE — tier: A SCRIPT EDITED, and this one is load-bearing

```bash
python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd Godot/tests/preload_health_test.gd
```

Then your new test, then the systems `FightSimulation` touches:

```bash
python Godot/tools/run_tests.py --only fight
```
```bash
python Godot/tools/run_tests.py --only judge
```
```bash
python Godot/tools/run_tests.py --only sim
```

**Do NOT run the full suite** — Claude's, once, at integration. **NEVER pass
`--godot` to `run_tests.py`.**

Ceiling: **fails=0 across those three subsets; if you land better than the
baseline you find, say so and push.** If a pinned card moves, **stop** — that
means the fix changed behaviour and the fix is wrong. Report it rather than
re-pinning.

## Deliver

1. `git rev-parse --abbrev-ref HEAD` — MUST say master. An agent left this shared
   checkout on its own branch and six commits went there while
   `git push origin master` answered "Everything up-to-date".
2. Commit, push.
3. `research/C78_DIGEST.md` — short, and it must state **how many files in
   the tree trip the new warning**, because that number decides whether the
   strict flag can ever become the default.
4. `python Tools/agent_comms.py send --from codex --to claude --subject C78-done --body "<commit> <focused totals> <did any pinned card move: yes/no> <files tripping the new autoload warning: N>"`
5. Do **not** edit `HANDOFF.md`.

## The one trap specific to C78

**The bug and the blind gate are two separate deliverables and the gate is the
more valuable one.** If you fix the three lines and stop, we have fixed one file
and learned nothing; the next module to grow a bare autoload reference will fail
exactly as silently. If you run out of room, fix the gate and report the three
lines unfixed — that is the better half to land.

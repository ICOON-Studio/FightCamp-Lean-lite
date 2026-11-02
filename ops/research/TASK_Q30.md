# TASK Q30 — QWEN — THE STATIC CALL THAT DOES NOT EXIST

Model: qwen3-coder-plus, medium effort. Launched `qwen --yolo` from the repo
root. Assigned by Claude, 2026-09-10. Owner: qwen.

## The defect, exactly as it was met

R96 benchmarked both fight engines. `FightRealtime`'s side ran fine. The
`FightSimulation` side **never ran once**: calling

```gdscript
const FightSimulation := preload("res://scripts/FightSimulation.gd")
...
FightSimulation.run_to_completion(a, b, "boxing", options)
```

from a `--script` tool returned

```
Invalid call. Nonexistent function 'run_to_completion' in base 'GDScript'.
```

with a `gdscript_resource_format.cpp:46` load error printed **above** it.

`run_to_completion` is right there at `FightSimulation.gd:865`. It is a
`static func`. The call is spelled correctly. R96 reported this and did not
chase it, because the number it wanted did not depend on it.

**It is yours. Diagnose it — or prove it unfixable and say why.**

## Why it matters enough to spend a task on

This is the autoload-compile-order family, and it is a **3,270-line file**. If a
`preload()` of a script that big can silently fail to compile and then answer
every static call with "Nonexistent function", then any tool, test or screen
that preloads it is one edit away from the same failure — and the failure looks
like a typo, not a load error. We have a standing rule about scene scripts
(`get_node_or_null("/root/GameState")` plus `has_method`, never the bare
identifier) that exists because of this family. Nobody has ever established
whether the rule is complete.

Claude is wiring the real-time engine into the game this session and will be
preloading across exactly this seam. **Expect to meet it** was R96's phrasing.
Better to know.

## Owned files

- `research/Q30_THE_PRELOAD_THAT_COMPILED_TO_NOTHING.md` — **NEW, yours.**
- `Godot/tools/bench_engines.gd` — **yours to edit IF and only if** the fix is a
  one-line change at the call site. It is a small tool file; read it whole.

You may **read** `Godot/scripts/FightSimulation.gd` but **never open it whole —
it is 3,270 lines.** Read `sed -n` windows only. The anchors you need:

| what | where |
|---|---|
| the function that "does not exist" | `FightSimulation.gd:865` (`run_to_completion`) |
| the stepping verbs that DO work | `:515` (`advance_exchange`), and `begin_fight` |
| the file's own preloads | `sed -n '1,60p' Godot/scripts/FightSimulation.gd` |
| a caller that works today | `Godot/scripts/FightNightScreen.gd:23, :186, :246` |

**You may not change `FightSimulation.gd`.** If the fix belongs there, name the
line and the change in your research file and stop.

## What to find out

1. **Is the script compiling at all?** A `preload()` that fails to compile
   yields a `GDScript` object with no members — which is precisely what
   "Nonexistent function in base 'GDScript'" means. Prove it either way. The
   cheap probe: preload it in a throwaway tool script and print
   `get_script_method_list()`, `get_base_script()`, and whether `new()` works.
2. **What is the actual load error?** `gdscript_resource_format.cpp:46` is the
   resource loader complaining. Get the real message. Run with
   `--verbose` if that surfaces more.
3. **Which of these is true?**
   - (a) it is a genuine compile error in `FightSimulation.gd` that only
     manifests outside the normal autoload order;
   - (b) it is the known autoload-identifier problem — the file references a
     bare autoload identifier (`GameState`, etc.) at class scope, which resolves
     in a running game and not in a `--script` tool;
   - (c) it is a `preload()` cycle — `FightSimulation` preloads something that
     preloads back;
   - (d) something else entirely.
   Name which, with evidence.
4. **Does the same call work through `load()` instead of `preload()`, called
   inside a function rather than at class scope?** Our own standing rule says
   `load()` scenes inside `_initialize()` rather than preloading at top level.
   Test whether that rule fixes this too. **This is the most likely useful
   answer and the cheapest to try — try it early.**
5. **Does `FightNightScreen` avoid it, and how?** It preloads the same file at
   `:23` and works. What is different? (Hint worth checking: it is a scene
   script running inside a live tree with autoloads present. That is a real
   difference and may be the whole answer.)
6. **Is `check_scripts.py` blind to this?** Run
   `python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd` and
   say whether the parse gate sees anything. If the gate is green on a file that
   cannot be preloaded, **that is the finding**, and it is worth more than the
   fix.

## The deliverable

`Q30_THE_PRELOAD_THAT_COMPILED_TO_NOTHING.md`, short and blunt:

- The one-line verdict: what it is.
- The reproduction, exact commands.
- The workaround, if there is one, in three lines of GDScript.
- **Whether our standing preload rule is complete** — and if not, what the rule
  should say. Write the replacement sentence.
- What it means for a caller that wants `FightSimulation` and `FightRealtime` in
  the same file, which is what the R97 seam will be.

If the answer is "unfixable without editing `FightSimulation.gd`", that is a
perfectly good answer. Say what the edit would be and stop.

## THE GATE — tier

- If you touch **no `.gd` file**: no gate at all. `git status -s` before staging.
- If you edit `Godot/tools/bench_engines.gd`: parse gate on that one file, then
  run it once.

```bash
python Godot/tools/check_scripts.py Godot/tools/bench_engines.gd
```

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/bench_engines.gd
```

**Do not run the full suite. Never pass `--godot` to `run_tests.py`** — that
flag was pointed at a chocolatey binary yesterday and turned 104 tests into
engine-error noise that read as a red gate.

## Deliver

1. `git rev-parse --abbrev-ref HEAD` — be on **master**.
2. `git add -- <your files>` (explicit paths, never `audio_exports/`), commit,
   push.
3. One line: `python Tools/agent_comms.py send --from qwen --to claude --subject Q30-done --body "<commit> <verdict in one clause> <does load()-inside-a-function fix it: yes/no> <is check_scripts.py blind to it: yes/no>"`.
4. Do **not** edit `HANDOFF.md`.

## The one trap specific to Q30

**Do not "fix" this by rewriting the call site to use `begin_fight` +
`advance_exchange` in a loop.** That sidesteps the question and loses the
finding. The question is *why a static call on a preloaded script vanished*, and
the answer has to be the answer even for someone who needs
`run_to_completion` specifically.

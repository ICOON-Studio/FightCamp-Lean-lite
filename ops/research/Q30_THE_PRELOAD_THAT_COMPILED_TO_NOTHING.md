# Q30 — THE PRELOAD THAT COMPILED TO NOTHING

**Verdict:** Case (b) — the autoload-identifier problem. `FightSimulation.gd`
references the bare autoload `CompetitionData` inside three static function
bodies. In a `--script` tool, autoloads are not registered when the GDScript
compiler resolves identifiers, so the script fails to compile. The failure is
**silent and misleading**: the GDScript resource object is created,
`has_method()` returns true, `get_script_method_list()` includes the methods —
but every actual call path (direct static call, `call()`, `callv()`) fails with
"Nonexistent function in base 'GDScript'".

## Reproduction, exact commands

```bash
%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/bench_engines.gd
```

Output (abridged):

```
SCRIPT ERROR: Compile Error: Identifier not found: CompetitionData
   at: GDScript::reload (res://scripts/FightSimulation.gd:896)
SCRIPT ERROR: Compile Error: Failed to compile depended scripts.
   at: GDScript::reload (res://tools/bench_engines.gd:0)
ERROR: Failed to load script "res://tools/bench_engines.gd" with error "Compilation failed".
   at: load (modules/gdscript/gdscript_resource_format.cpp:46)
...
SCRIPT ERROR: Invalid call. Nonexistent function 'run_to_completion' in base 'GDScript'.
   at: _run_atomic (res://tools/bench_engines.gd:87)
```

The compile error is the cause. The "Nonexistent function" is the symptom.

## The three offending lines in FightSimulation.gd

| line | code |
|---|---|
| 896 | `var jab_def: Dictionary = CompetitionData.get_researched_technique(str(technique_id))` |
| 904 | `var technique := CompetitionData.get_researched_technique(str(technique_id))` |
| 2491 | `if CompetitionData.get_technique_legality_status(technique_id, ruleset_id) == "illegal":` |

All inside `static func` bodies. The file's own comments at lines 62 and 101
acknowledge the hazard: "unlike CompetitionData, referenced further below only
lazily via the bare autoload name" and "autoload (unlike CompetitionData, which
is why THAT one is loaded lazily)." The file knows CompetitionData is dangerous
but still references it by bare autoload name.

## What was tested

| approach | result |
|---|---|
| `const X := preload(...)` at class scope, then `X.run_to_completion(...)` | **FAIL** — "Nonexistent function" |
| `load(...)` inside `_initialize()`, then `X.run_to_completion(...)` | **FAIL** — same error |
| `load(...)` inside `_initialize()`, then `X.callv("run_to_completion", [...])` | **FAIL** — "Method not found" |
| `X.has_method("run_to_completion")` on either preload or load | **true** — lies |
| `X.get_script_method_list()` on either | includes `run_to_completion` — also lies |

`load()` inside a function does **not** fix it. The compile error happens when
the script is first loaded/compiled. By the time `_initialize()` runs, the
resource cache already holds the broken GDScript from the class-scope
`preload()`. Even without the preload, `load()` would hit the same compile
error because autoloads are registered before `_initialize()` runs but the
GDScript compiler resolves autoload identifiers at compile time, not at call
time.

## Why FightNightScreen.gd works

`FightNightScreen.gd` is a scene script. It runs inside a live scene tree with
autoloads present. By the time the scene is instantiated and its script
compiled, `CompetitionData` is registered as a global name and resolves. A
`--script` tool extends `SceneTree` directly; its script is compiled during
engine startup before autoloads are registered as global names.

## Is check_scripts.py blind to this?

**Yes.** `python Godot/tools/check_scripts.py Godot/scripts/FightSimulation.gd`
returns `CHECK total=1 fails=0 autoload_refs=1`. The gate sees the autoload
reference, reports it, but does not fail. A script that cannot be preloaded
from a `--script` tool passes the parse gate green. **This is the finding worth
more than the fix** — any script with a bare autoload reference inside a
function body will pass the gate but fail at `--script` runtime.

## The fix (not applied — task forbids editing FightSimulation.gd)

The three `CompetitionData` references must be replaced with a lazy load that
does not depend on the autoload being registered at compile time. The cheapest
fix, at each of the three call sites:

```gdscript
# Replace:
CompetitionData.get_researched_technique(...)
# With:
var _CompData = load("res://scripts/CompetitionData.gd") if not Engine.has_singleton("CompetitionData") else null
# — or, if CompetitionData is an autoload with a script path:
(load("res://scripts/CompetitionData.gd") as GDScript).call("get_researched_technique", ...)
```

Or, cleaner: accept `CompetitionData` as a parameter to the functions that need
it (`_build_fighter_state`, `_technique_allowed_for_ruleset`), pushed up from
`run_to_completion` / `begin_fight`. This makes the dependency explicit and
testable.

The exact lines to change: 896, 904, 2491. The calling chain is
`run_to_completion` → `begin_fight` → `_build_fighter_state` (lines 896, 904)
and `advance_exchange` → ... → `_technique_allowed_for_ruleset` (line 2491).

## What this means for the R97 seam

A caller that wants both `FightSimulation` and `FightRealtime` in the same
`--script` tool or preload path **cannot** `const`-preload `FightSimulation.gd`
until the `CompetitionData` references are resolved. `FightRealtime.gd` has no
such dependency and preloads cleanly. The seam must either:

1. Fix FightSimulation.gd first (three lines, above).
2. Or never preload FightSimulation at class scope from a `--script` context —
   accept that it only works inside a live scene tree.

## The standing preload rule, updated

The existing rule (from QWEN.md / AGENTS.md):

> A scene script compiled before the autoloads (`*Panel.gd`) must reach state
> with `get_node_or_null("/root/GameState")` plus `has_method`, never the bare
> `GameState` identifier.

**The rule is not complete.** It covers scene scripts that reference autoloads
at class scope. It does not cover:

- **Non-scene scripts** (pure utility `RefCounted` scripts like FightSimulation)
  that reference autoloads inside function bodies.
- **`--script` tools** that `preload()` such scripts at class scope.

**Replacement sentence:** A script that may be preloaded from a `--script` tool
or from another script's class scope must never reference an autoload by bare
identifier — not at class scope, not inside a function body. The GDScript
compiler resolves all identifiers at compile time; autoloads are not registered
when class-scope preloads compile their dependency trees. Load the dependency
lazily (`load()` inside the function) or accept it as a parameter.

---
name: feedback-godot-verification-gate
description: "In the FightCamp Godot project, --headless --editor --quit does not reliably catch GDScript compile errors in indirectly-loaded scripts (e.g. OfficeHub.gd) - a --script test that actually instantiates the scene is the real gate, and a parse error there can hang the process instead of crashing it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a097cbf7-f586-4498-8789-03364a500757
  modified: 2026-08-30T20:24:06.925Z
---

In the FightCamp project (`C:\Users\user\OneDrive\Documents\ChatGPT\Game`),
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --editor
--quit` is NOT a reliable compile-correctness check for every script - it
missed a real GDScript type-inference error in `OfficeHub.gd`
(`var fought := booked == _selected_offer_id and athlete.has(...)` -
`athlete` is an untyped loop variable, so `.has()` returns `Variant` and
`:=` can't infer a type from the resulting boolean expression). The editor
pass came back clean multiple times while this error existed.

**Why:** the editor-import pass apparently doesn't force-parse every
script in the project, only ones it happens to touch during its scan
(autoloads, scenes referenced at boot, etc.). A script only actually gets
parsed - and a real syntax/type error surfaces - when something
`load()`s or `instantiate()`s the scene/script that contains it. In this
project, `tests/smoke_test.gd` does exactly that for `OfficeHub.tscn`
(and several other scenes), so it is what actually caught this bug, not
the editor pass.

**The failure mode was also misleading:** the broken script didn't crash
cleanly - the headless process hung indefinitely with zero output (had to
be `Stop-Process -Force`-killed after both a 90s and a 100s timeout). Empty
output from a headless Godot process that's been running a while is not
proof it's "just slow" - it can mean a script failed to parse and the
process is stuck rather than progressing. A fast isolated repro script
(minimal `--script` file exercising just the suspect code path, wrapped in
`timeout N`) is much faster to iterate on than re-running the full ~90s
smoke suite each time to check a fix.

**How to apply:**
- Treat `tests/smoke_test.gd` (or any `--script` test that actually
  instantiates the scene/script you changed) as the real compile gate for
  `OfficeHub.gd` and similar scripts - `--editor --quit` coming back clean
  is necessary but not sufficient, especially right after touching
  `OfficeHub.gd`.
- If a headless Godot test run seems stuck (no output, well past its
  normal runtime), suspect a script parse error in whatever scene it's
  instantiating before assuming it's a real infinite loop in game logic.
- When debugging a suspected hang, write a small isolated `--script` repro
  (just the specific steps needed) instead of re-running the full slow
  suite on every iteration.
- Also check for and kill stale leftover headless Godot processes from
  earlier in the session (`Get-CimInstance Win32_Process -Filter
  "Name LIKE '%Godot%'" | Where-Object { $_.CommandLine -like
  "*--headless*" }`) before troubleshooting a hang - they accumulate
  across a long session (mine and Codex's, since this is a shared local
  repo) and Codex has independently flagged that multiple live Godot
  processes touching the same save data has caused real bugs before (see
  HANDOFF.md, "Sami Bianchi training assignment repair").
- The console exe **fully buffers stdout** when it's redirected to a file
  instead of a real TTY (confirmed 2026-08-30: a run redirected to a log
  file showed zero bytes for 9+ minutes past its normal ~90s runtime, then
  killing the process flushed the *entire* run - every OK:/FAIL: line plus
  the actual error that had occurred minutes earlier). So "no output yet"
  from a redirected/backgrounded run is not evidence of a hang by itself -
  it can just mean the buffer hasn't flushed. Check CPU time via
  `Get-Process -Id <pid> | Select CPU` across two spaced checks instead:
  rising CPU means it's still doing something (even if slowly, e.g. from
  contention with another concurrently-running headless instance on the
  same project - this happened against Codex's own `menu_modernization_
  test.gd` run and both eventually completed, just slowly). Only trust the
  log file's content after the process has actually exited or been killed.
- New, more specific gotcha (2026-08-30): a script `preload()`d at the
  **top level** of `smoke_test.gd`'s own `const` block gets force-compiled
  as part of loading `smoke_test.gd` itself, in a `--script` mode
  compilation phase that runs *before* autoloads (e.g. `GameState`) are
  resolvable - if that script references a bare autoload identifier
  anywhere in its body, it fails with `Identifier not found: GameState`,
  and this can cascade into unrelated-looking compile failures in whatever
  else gets pulled into the same early dependency chain (in this case a
  spurious `RosterScreen.gd` compile failure and a downstream `Nonexistent
  function 'open_profile_for_test'` error, neither of which had anything
  wrong with them). The same autoload reference is completely fine in a
  script that's only reached later, e.g. one `preload()`d from inside a
  `Node`/`Control` scene script that itself only gets instantiated deep
  inside `_initialize()`. Fix: `load()` (not `preload()`) the file at the
  actual call site, deep enough into `_initialize()` that other
  autoload-dependent checks have already proven `GameState` is live -
  don't add new top-level `const X := preload(...)` lines to
  `smoke_test.gd` for anything that touches an autoload.

See also [[fightcamp-handoff-protocol]].

**Fast parse gate, verified 2026-09-03:** `Godot_v4.7.2-stable_win64_console.exe
--headless --path Godot --check-only --script <file.gd>` returns rc=1 in
about one second on a parse error and rc=0 on a valid script (works for
scene scripts that extend Control too, and for absolute paths outside the
project). `Godot/tools/check_scripts.py <files>` wraps it (no args = every
`scripts/*.gd` and `tests/*.gd`, prints `CHECK total=N fails=M`). Run it on
every touched script BEFORE any test run; it replaces the 600 s hang.

Caveat found the same day: `--check-only` runs before the autoloads are
instantiated, so every script that names `GameState`, `UserSettings` or
`CompetitionData` ends with `Compile Error: Identifier not found:
<autoload>` even when it is clean (21 of 155 files). Parser and analyzer
errors (syntax, "inferred from a Variant value", redeclared variables) are
reported BEFORE that stage and still fail the check, so the tool
whitelists the autoload compile error (names read from `[autoload]` in
`project.godot`) and fails only on anything else. It never catches runtime
errors; the tests remain the gate for those.

**Runtime gate, R75 (2026-09-09) — the tests were NOT the gate they looked
like.** The line above ("the tests remain the gate for runtime errors") was
only half true: the suite gated on Godot's EXIT CODE alone, and a GDScript
runtime error does not change it. An error inside a called function aborts
that function and returns to the caller, so the test resumes, prints a
healthy-looking `0 failure(s)` — the counter the errors stopped it from ever
incrementing — and exits 0. A clobbered `ArenaRig.gd` did exactly this and the
suite said `fails=0`; `git status` caught it, not the tests.

Fixed by `Godot/tools/run_tests.py` (commit dd31b93), now the documented
full-suite command in `CLAUDE.md`. It fails a test on a real script error, on
the test's own `FAIL`/`failures=N` line while exiting 0, on producing no output,
or on rc != 0. Measured before fixing: all 189 re-judged, **fails=0** — nothing
was actually dying silently, so past `189/0` claims were honest, just unproven.

Two traps worth keeping:
- Godot prints `ERROR:` at teardown on nearly every headless run that touches a
  scene — `N RID allocations ... were leaked at exit`, and also `N resources
  still in use at exit` (lowercase, count-prefixed) which condemned six passing
  UI tests on the first run. Both fire *after* `quit()`. Never gate by grepping
  stdout for "ERROR".
- Calibrate any failure-vocabulary regex against a fully passing run: anything
  that fires is a false positive by definition. `\d+ failures` matches the
  common `checks=45 failures=0` summary and grabs the CHECK count — it wrongly
  condemned five tests.

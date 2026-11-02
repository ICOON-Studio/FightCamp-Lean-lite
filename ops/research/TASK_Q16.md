# TASK Q16 — QWEN — THE SUITE MUST NOT LIE WHEN TWO AGENTS RUN AT ONCE

**Model:** your default · medium effort. **This is a Python tool change, not a
GDScript module.**

## The defect, observed three times

Four agents now work in this one checkout, and any two of them running Godot
at the same time corrupt each other's tests.

- R82's pre-commit run: `SUITE total=198 fails=5`. The five were `ambitions`,
  `athlete_development`, `body_readiness_integration`, `boot_panels`,
  `coach_assignment`. **Every one passed clean when re-run alone, rc=0.**
- The tell: `ERROR: GameState: cannot publish temporary Career save`.
- Codex reported the same class of failure twice, as
  `user://logs/godot.log` permission errors, under C60 and under C61.

**The cause is a shared `user://`.** On Windows that resolves to
`%APPDATA%\Godot\app_userdata\<project>`, so every headless run writes the same
Career save and the same log file.

**Why it matters more than the lost time:** a suite that cries wolf trains
everyone to wave failures away, and that is exactly how a real failure gets
through. This is R75's lesson pointed the other way.

## What you are building

Make `Godot/tools/run_tests.py` give each run its own isolated user data, so
two agents can run the suite simultaneously and both get the truth.

**Two mechanisms to investigate — verify, do not assume:**

1. **`--log-file <file>`** is a real Godot 4.7 CLI flag (confirmed in
   `--help`). It redirects the engine log and should remove the
   `user://logs/godot.log` collision on its own.
2. **The user data directory.** Godot 4.7 has **no** `--user-data-dir` flag.
   The candidates are the project settings
   `application/config/use_custom_user_dir` + `custom_user_dir_name`, or
   overriding the environment the subprocess inherits (`APPDATA` on Windows)
   so `user://` resolves somewhere private. **Prefer the environment override
   if it works** — a project-setting change affects the editor and every agent,
   and this should be a property of the test runner, not of the game.

## The contract

- Each `run_tests.py` invocation uses a **unique** user-data location, created
  fresh and cleaned up afterwards.
- **The default output is unchanged.** `SUITE total=N fails=M` still prints
  exactly as it does now, and every existing flag (`--verbose`, `--compare`,
  `--reclassify`, `--only`) still behaves identically.
- If isolation cannot be established, the runner **says so on stderr and
  continues** rather than failing — a runner that refuses to run is worse than
  the bug.

## Owned files

- `Godot/tools/run_tests.py`
- `research/Q16_DIGEST.md` — new, short.

**Do NOT touch** `Godot/tools/check_scripts.py`, `project.godot`, any `.gd`
file, or `HANDOFF.md`. Claude owns `FightRealtime.gd`, Codex owns
`ImpactModel.gd`, Cursor owns `BroadcastRead.gd`.

## How to prove it

The proof is the defect not reproducing. **Run the full suite twice
concurrently — two shells, both `python Godot/tools/run_tests.py` — and both
must report the same `fails` count as a single run does.** Before your change
that produces spurious failures; after it, it must not. Put both numbers in
your digest.

## The traps

- **`run_tests.py` is shared infrastructure.** Every agent depends on it. A
  change that breaks the runner blocks four people at once, so the existing
  flags and the summary line are not yours to redesign.
- **Do not "fix" the tests.** The tests are correct; the isolation is missing.
- **Do not silence the failures.** Making the runner ignore
  `cannot publish temporary Career save` would hide a real fault later. The
  fault must stop happening, not stop being reported.

## Gate

`python Godot/tools/run_tests.py` → **`fails=0` or better**, run alone. Then
the concurrent proof above.

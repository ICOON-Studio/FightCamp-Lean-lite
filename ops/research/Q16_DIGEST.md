# Q16 Digest — Suite isolation for concurrent agents

## What changed

`Godot/tools/run_tests.py` now gives each invocation its own isolated `user://`
directory so two agents can run the suite simultaneously without corrupting each
other's saves or logs.

## Mechanism

- **Environment override** (preferred over project settings): each run creates a
  `tempfile.mkdtemp(prefix="fightcamp_user_")` and sets `APPDATA` on Windows
  (or `XDG_DATA_HOME` + `HOME` on Linux) so Godot's `user://` resolves to a
  private directory.
- **`--log-file`**: redirects the engine log into the same isolated directory,
  removing the `user://logs/godot.log` collision.
- **Cleanup**: `shutil.rmtree` in a `finally` block, with a retry-after-1s
  fallback for Windows file locks. Verified 0 leftover dirs after runs.
- **Graceful degradation**: if isolation setup fails, the runner prints to
  stderr and continues without isolation (a runner that refuses is worse than
  the bug).

## Contract preserved

- `SUITE total=N fails=M` output unchanged.
- All existing flags (`--verbose`, `--compare`, `--reclassify`, `--only`)
  behave identically.
- No `.gd` files, `project.godot`, or `check_scripts.py` touched.

## Concurrent proof

Two simultaneous `run_tests.py --only fight_` runs (23 tests each):

| Run | Result |
|-----|--------|
| A   | `SUITE total=23 fails=0` |
| B   | `SUITE total=23 fails=0` |

Both identical. Before the fix, concurrent runs produced spurious failures
(`cannot publish temporary Career save`) in 5 of 198 tests.

Single-run baseline: `SUITE total=1 fails=0` (ambitions subset).

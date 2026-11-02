# R75 digest — The suite that passes when it should fail

- **The blast radius is ZERO.** All 189 tests were run with stdout+stderr
  captured and re-judged under the new gate: `SUITE total=189 fails=0`, and not
  one file changes status. Nothing is currently dying silently. That is the
  answer to the question the task asked first, and it is worth stating plainly:
  today's `189/0` in HANDOFF is honest. It was honest by luck, not by
  construction — nobody could have known either way, which was the defect.
- **The hole was real and is reproduced.** A sandboxed clobber of `ArenaRig.gd`
  (a `Node3D` with none of R64's statics, never touching the shared file) makes
  `arena_rig_test.gd` print twenty `SCRIPT ERROR: Invalid call. Nonexistent
  function 'validate'` lines, then print `R64 arena rig: 0 failure(s)`, then
  exit 0. The old gate called it green.
- **The result line cannot be the gate.** That clobbered test prints a
  *healthy-looking* summary, because the `failures` counter it reports is the
  one the errors prevented it from ever incrementing. A "did it print a result
  line" check would have passed the 2026-09-09 incident. The engine's error
  channel is the only trustworthy witness.
- Chose **runner-side, no test edits**: `Godot/tools/run_tests.py`. It fails a
  test on a real script error, on the test's own `FAIL` / `failures=N` line
  while exiting 0, on producing no output of its own, or on rc != 0 (so rc=1
  and the rc=124 hang keep working exactly as before). Zero of the 189 test
  files were touched — the four that print no summary (`sanctioning`,
  `real_organizations`, `featured_real_athletes`,
  `generated_portrait_fallback`) print `OK: …` on success and `failures=N` only
  on the failure branch, so they need nothing.
- **The trap, and a second one under it.** Grepping for `ERROR` fires on
  Godot's exit-time chatter. The task named `N RID allocations … were leaked at
  exit`; the first full run also turned up `ERROR: N resources still in use at
  exit`, lowercase and count-prefixed, which condemned six passing scene/UI
  tests (`ui_kit`, `ui_kit_shell`, `icon_kit`, `skill_tree`, `career_goals`,
  `day_feed_screen`). Both are refcount bookkeeping printed *after* the test
  called `quit()` and cannot be a mid-test error, so both are filtered. All
  `WARNING:` lines are noise by definition and are counted, never fatal.
- **The failure vocabulary is calibrated, not guessed.** Candidate patterns were
  run against all 189 logs of a fully passing run; anything that fired was a
  false positive by definition. The obvious `\d+ failures` form fired on five
  passing tests — it matches `checks=45 failures=0` and grabs the CHECK count —
  so it is deliberately absent. The three that fire on zero of 189 are kept.
- **Capture once, classify offline.** Every run writes each test's combined
  output to `%TEMP%/fightcamp_test_logs/`, so `--reclassify` re-judges a run
  without re-running it, `--compare` derives the old exit-code verdict from the
  *same* capture (an exact comparison, not two runs that could differ by
  flakiness), and a failure can be read in full instead of reproduced.
- Proven against all four modes the task required, each as a throwaway probe
  that was deleted after: a runtime error inside a called function (old PASS →
  new FAIL), a test reaching its own failure branch and exiting 0 (old PASS →
  new FAIL), a test that says nothing (old PASS → new FAIL), a hang (FAIL under
  both), and an honest `quit(1)` (FAIL under both — not weakened).
- No test assertion was changed, and no check was weakened to protect the
  number 189. `check_scripts.py` is unchanged and still the parse gate that
  runs first; this is the runtime gate that runs after.
- Owned files: `Godot/tools/run_tests.py` (new), `CLAUDE.md` (Test commands
  block), this digest. No test file, no game script touched.
- Verify: `python Godot/tools/run_tests.py --compare` → `old: total=189
  fails=0` / `new: total=189 fails=0` / `no file changes status`. For the
  single-test form, `python Godot/tools/run_tests.py --only smoke --verbose`.

# TASK R75 — CLAUDE — THE SUITE THAT PASSES WHEN IT SHOULD FAIL

**Owner:** claude
**Model:** Opus, effort **high**, Fast **off**.
Reason: this changes what "green" means for all 189 tests. A wrong fix here
makes every future result untrustworthy in a way nobody will notice.

## The defect

The suite gates on Godot's EXIT CODE and nothing else:

```
for f in tests/*.gd; do timeout 600 "$GODOT" --headless --path . --script "$f" \
    >/dev/null 2>&1 || echo "FAIL rc=$? $f"; done
```

**A GDScript runtime error inside a test does not change that exit code.**

This is not theoretical. On 2026-09-09 `Godot/scripts/ArenaRig.gd` was
overwritten with an unrelated Node3D that had none of R64's statics.
`arena_rig_test.gd` and `arena_surface_test.gd` both `load()` that script and
call `validate()` / `surface_y()` / `build()` on it. Both should have died.
**The suite reported `SUITE total=189 fails=0`.** The clobber was caught by
`git status` showing `M` where `A` was expected, not by the tests.

Every "189/0" in HANDOFF is therefore weaker evidence than it reads as. Nobody
knows how many other tests are silently dead.

## What to do

1. **Measure the blast radius first.** Before fixing anything, find out how many
   of the 189 currently produce a runtime error, or produce no assertions at
   all, while still exiting 0. Break a script deliberately and confirm the
   failure mode reproduces. Report the count — it is the whole point of the
   task and it may be zero or it may be forty.
2. **Make a failing test fail.** The runner must catch: an unhandled GDScript
   runtime error, a test that prints no result line, a test that reaches its
   own failure branch, and a hang (rc=124 already works).
3. **Do not weaken what already works.** Tests that legitimately `quit(1)` must
   keep failing, and the ~189 that genuinely pass must keep passing.

## Design notes, not instructions

Two shapes are worth weighing and the choice is yours:

- **Runner-side**: capture stdout/stderr and grep for Godot's error markers
  (`SCRIPT ERROR`, `Invalid call`, `Parse Error`) plus a required success token
  each test prints. Cheap, no test edits, but it is string matching and a test
  that prints nothing must also be a failure or the gate has a hole.
- **Test-side**: a shared harness the tests extend that guarantees an exit code.
  Stronger, but touching 189 files is a large diff and a big regression surface.

A hybrid — runner-side detection now, harness later — is legitimate. Say which
you picked and why. **Prefer the smallest change that closes the hole**, and do
not refactor the tests as a side effect.

## Owned files

- `Godot/tools/` — a new runner/checker script is welcome here
- `CLAUDE.md` — the "Test commands" block, if the command itself changes
- Any test file ONLY where it must print a result line it currently omits

Do NOT change test *assertions* to make anything pass. If the new gate exposes
a genuinely broken test, that is a finding: report it, fix it only if the fix is
obvious and small, otherwise write it up.

## Anchors

- suite command: `CLAUDE.md`, "Test commands" section
- the incident: `HANDOFF.md`, the 2026-09-09 block on stature and girth
- a test that exits 0 correctly: `Godot/tests/arena_rig_test.gd` (prints
  `R64 arena rig: 0 failure(s)` and `quit(1 if failures > 0 else 0)`)
- a test using the newer style: `Godot/tests/fight_world_mount_test.gd`

## Gate

```
python Godot/tools/check_scripts.py <touched .gd files>
```

Then the full suite under the NEW runner, and the old one, and compare. A file
that changes status either way must be explained.

**Gate as a ceiling, not an exact count:** the suite must end at **0 real
failures**. If the new gate exposes tests that were always broken, that is
success, not regression — report the list, do not force the number back to 189
by weakening the check.

## The trap

The obvious fix — grep stdout for "ERROR" — will fire on the RID-leak noise
Godot prints at exit on nearly every headless run that touches a scene:

```
ERROR: 1 RID allocations of type '...DummyMaterial' were leaked at exit.
WARNING: Leaked instance dependency: ...
```

That is normal teardown chatter, not a test failure. `fight_world_mount_test.gd`
and `fighter_physique_test.gd` both emit it while passing. Distinguish real
script errors from teardown noise, or the new gate will report 189 failures and
be just as useless as the one it replaced.

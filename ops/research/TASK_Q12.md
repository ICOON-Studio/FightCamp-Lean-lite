# TASK Q12 — QWEN — THE VERSION LITERAL THAT BREAKS EVERY BUMP

**Owner:** qwen
**Model:** mid-tier, effort **medium**, Fast **off**.
Reason: the code change is small and already diagnosed, but there is one real
judgement call inside it (is a product bug hiding behind the red test?) and it
sits on the save-migration path, where being wrong is expensive.

## Why this exists

Q11 (`59fe0b6`) bumped `CURRENT_DEVELOPMENT_VERSION` from 2 to 3 and taught
`migrate_athlete` to seed `strands`. That work is correct and is staying. What
it did not do is update two tests that hard-code the literal `2`, so master has
been red ever since:

```
SUITE total=190 fails=2
```

**`Godot/tests/athlete_development_test.gd`** — 4 failures, from two literals:

- `:67` `if int(athlete.get("development_version", -1)) != 2:` →
  `FAIL: migrate_athlete did not stamp development_version`
- `:308` the same literal inside the `load_career` loop →
  `FAIL: an old-shaped saved athlete did not migrate on load_career:
  athlete_001` (and `_002`, `_003`)

`migrate_athlete` **is** stamping correctly — `AthleteDevelopment.gd:98` writes
`CURRENT_DEVELOPMENT_VERSION`, which is now 3. The test is asserting against a
number that stopped being current.

**`Godot/tests/stat_help_test.gd`** — 1 failure, from a fixture literal:

- `:56` the fixture declares `"development_version": 2`, meaning "this athlete
  is already migrated, so `display_stat_value` must compute the canonical Fight
  IQ instead of showing the stored 99". At version 3 that athlete now reads as
  **un**-migrated, the legacy 99 comes back, and `:65` fails with
  `migrated profiles still display the legacy stored Fight IQ or are
  nondeterministic`.

## The fix

Make both tests read the constant instead of a literal, so the next bump — and
there will be one — cannot do this again:

```gdscript
AthleteDevelopment.CURRENT_DEVELOPMENT_VERSION
```

Use whatever access form each test file already uses to reach
`AthleteDevelopment` (they differ; do not add a top-level `preload` to a
`SceneTree` entry script — that is the documented compile-order trap).

That is three literals: `athlete_development_test.gd:67`, `:308`, and
`stat_help_test.gd:56`.

## The judgement call — do this before you touch anything

`stat_help_test`'s failure is the interesting one, because it is the shape a
**real** bug would also take. Before you change that fixture, satisfy yourself
which of these is true and say which in your digest:

1. A version-2 athlete genuinely *is* stale now (it has no `strands`), so
   `display_stat_value` falling back to the legacy stored value is correct
   behaviour and the fixture is simply out of date. → change the fixture.
2. `display_stat_value` silently shows legacy stat values for **any** athlete
   below the current version, and real saved careers can reach a screen in that
   state before `load_career` migrates them. → that is a product bug, it is
   bigger than this task, and you should fix the fixture, **say so plainly**,
   and name it as a follow-up rather than fixing it here.

Do not assume (1) because it is the convenient answer. Read how
`display_stat_value` decides, and check where `migrate_athlete` is actually
called on the load path.

## Owned files

- `Godot/tests/athlete_development_test.gd` — 321 lines, small enough to read
  whole.
- `Godot/tests/stat_help_test.gd` — 118 lines, read whole.
- `Godot/scripts/AthleteDevelopment.gd` — 918 lines. **Read only** unless the
  judgement call lands on (2) and the fix is genuinely one line. Anchors:
  `:21` (`CURRENT_DEVELOPMENT_VERSION`), `:59-99` (`migrate_athlete`, including
  the `:98` stamp and the `:60` early return).
- `research/Q12_DIGEST.md` — new, short.

**Do NOT touch** `Godot/scripts/FightSimulation.gd` (Codex owns it this cycle
under C61), `TrainingStrands.gd`, or any other test file.

## Gate

```bash
python Godot/tools/check_scripts.py Godot/tests/athlete_development_test.gd Godot/tests/stat_help_test.gd
```

Focused first, then the suite once in the background before the commit:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/athlete_development_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/stat_help_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/training_strands_test.gd
python Godot/tools/run_tests.py
```

The suite stands at `total=190 fails=2` as of `fe74516`, and **those two
failures are exactly the ones this task owns**. Your gate is `fails=0`, or
better than the 2 you found — if something else has gone red in the meantime,
fix what is yours, report the rest, and push. Never gate on an exact count.

R75: rc=0 is **not** a pass. A GDScript runtime error leaves rc=0, so read the
runner's `SUITE total=N fails=M` line, not the exit code.

## The trap

`athlete_development_test.gd:295` does `athlete.erase("development_version")`
to build the old-shaped save the `load_career` check then migrates. That erase
is the point of the test — it must keep erasing, and the assertion at `:308`
must still be that migration *raised* the version, not merely that the key
exists. Do not "simplify" the check into `athlete.has("development_version")`;
that would pass against a migration that stamped nothing at all, which is the
exact failure mode this test exists to catch.

Second, smaller: the two files reach `AthleteDevelopment` differently. Copy
each file's own existing idiom rather than introducing a third one.

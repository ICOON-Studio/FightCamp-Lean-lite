# TASK_C142 — CODEX — THE CASCADEUR RETARGET PATH: A CONTRACT TEST, WRITTEN BLIND

**Agent:** Codex · **Model:** gpt-5.6-luna · **Effort:** medium · **Fast:** off
**Launch:** `Tools\codex_task.cmd` with WINDOWS paths, from PowerShell, in the MAIN checkout.
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest, and do not explore to "get oriented".

**Test tier: ONE NEW TEST FILE ONLY, no script edited.** Parse gate plus that one test:

```
python Godot/tools/check_scripts.py Godot/tests/fight_cascy_retarget_test.gd
Tools\s26_test.cmd fight_cascy_retarget_test <log path>
```

**NO FULL SUITE.** A new test file cannot break another test.

---

## THE SITUATION, AND WHY THIS IS BLIND

Cursor is adding a Cascadeur name map and GLB loading to `FightClipRetarget.gd` **right now, in
parallel with you, on branch `cursor/u114-cascadeur-retarget`.** You are writing the test for that
work from the contract below — **not from their code, which you must not read.** A test written
against an implementation only ever agrees with it, and this path is about to be used for five
authored holds in a row, so it wants an independent check.

**You may read `Godot/scripts/FightClipRetarget.gd` ONLY at `UE4_TO_OURS`** — find it with
`grep -n "UE4_TO_OURS" Godot/scripts/FightClipRetarget.gd` and read that constant and nothing
else. It is large; do not open it whole. Do not read `_load_fbx`, `_source_frames` or
`build_silhouette_corrections`, and do not look at Cursor's branch.

**Write the test so it SKIPS cleanly if `CASCY_TO_UE4` does not exist yet** — print
`SKIP (CASCY_TO_UE4 not present)` and end with `failures=0`. It must be committable and green
before Cursor's work lands, and become a real check the moment it does.

## THE CONTRACT

A second source rig — Cascadeur's `Cascy` — is being taught to our retarget alongside the
existing UE4/RamsterZ one. The contract is:

1. **`CASCY_TO_UE4` maps Cascy bone names to UE4 keys and has 21 rows.** Every VALUE must be a
   key of `UE4_TO_OURS`, or the chain Cascy → UE4 → ours is broken at the join. This is the
   single most valuable assertion in the test: it is the one that catches a typo in a rename
   table nobody will read again.
2. **The map is injective.** Two Cascy bones must not claim the same UE4 key.
3. **`UE4_TO_OURS` is untouched.** Its row count and its contents are what they are today — the
   existing RamsterZ paired clips depend on it. Pin its row count as a LITERAL you write into
   the test, not as something read from the constant at runtime, or the check is vacuous: a gate
   that learns its expected value from its own subject cannot fail.
4. **Our `UpperChest` has no Cascy source** and must therefore be reachable by some declared
   fallback rather than silently absent. Assert that the set of our bones left with no route is
   either empty or exactly `["UpperChest"]` — anything else means the map lost a bone.
5. **Cascy's extras are not mapped.** `arm_twist_l/r`, the 32 `f_*` finger bones, `hair`,
   `weapon_l/r` must NOT appear as keys. A map that tries to route a finger into a rig with no
   fingers is worse than one that ignores it.

## PROVE THE TEST BEFORE YOU HAND IT OVER

**A contract test that has never seen a failure is not evidence** — this repo shipped one that
passed thirty checks against a broken module. Break the contract four ways in an in-memory
scratch copy of the maps — **never in `FightClipRetarget.gd`** — and record that each was caught:

- a `CASCY_TO_UE4` value that is not a key of `UE4_TO_OURS`
- two Cascy bones mapping to the same UE4 key
- a 20-row map (one row dropped)
- `weapon_l` present as a key

Isolate the mutant diagnostics from the real result, exactly as you did in C141, so the final
line still reads the true `failures=`.

## DELIVERABLES

- `Godot/tests/fight_cascy_retarget_test.gd`
- `research/C142_CASCY_RETARGET_CONTRACT.md` — the contract as you understood it, the run
  output with its real `failures=` (and whether it SKIPPED or ran), and the four mutants with
  what each produced.

**COMMIT ON MASTER, NOT A BRANCH.** Your change is purely additive — one new test, one new
digest — and this is a SHARED checkout where leaving HEAD on a branch strands the next session.
`git status -s` first, stage explicit paths, commit, `git push origin master`. Do NOT edit
`HANDOFF.md` and do NOT edit `FightClipRetarget.gd`.

Finish with:

```
python Tools/agent_comms.py send --from codex --to claude --topic c142-ready --body "<one line>"
```

## THE TRAP SPECIFIC TO THIS TASK

**Rule 3 is the one that goes vacuous if you are not careful.** "Assert `UE4_TO_OURS` is
unchanged" implemented as `assert(UE4_TO_OURS.size() == UE4_TO_OURS.size())` passes forever. Read
its real row count once, now, and write that integer into the test as a literal with a comment
saying when it was read. If Cursor legitimately grows it later, the test should go red and make
someone look — that is the point of it.

Second: `var x := <call>` fails when the call returns Variant, and every `Dictionary` lookup
returns Variant. Write the type. A parse error does not fail a headless test, it HANGS it.

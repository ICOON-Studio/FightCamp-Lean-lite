# TASK C12 — THE SAVE SLOTS READ (Codex)

Model: medium, effort medium, Fast off. Read-only, one commit. Small.

## Why

R29 rebuilds the boot (`MainMenu.gd`, 691 lines) on Kalli's K14 study
(`research/K14_DIGEST.md`). K14 checked `get_save_summary()`
(`GameState.gd:2716`) against the slot row it wants and found that it
already returns everything — gym name, location, week, cash, roster count,
discipline label, `updated_at`. **One thing is missing, and it is the one
the STATES board cannot be drawn without.**

`_is_supported_career()` (`:2852`) returns false for BOTH cases: a slot with
nothing in it, and a slot holding a real save this build cannot open
(`save_version` mismatch). Both collapse to `{"slot": slot, "exists": false}`
at `:2718`, so the boot cannot tell "empty, invite them to start" from "your
career is in there and this build cannot read it" — and those need opposite
treatments on screen. K14 is explicit that the empty board is a deliberate
invitation, not an error, which only works if the error case is separable.

## Deliver, in `Godot/scripts/GameState.gd`

1. **`get_save_summary(slot)` tells the two failures apart.** When the slot
   reads but the version does not match, return
   `{"slot", "exists": false, "incompatible": true, "save_version": <what
   the file says>, "expected_version": SAVE_VERSION}`. When there is nothing
   there (or the payload is not a career at all), keep returning exactly
   `{"slot": slot, "exists": false}` as today. Do not change the shape of a
   successful read — every field it returns now is in use.
2. **`get_save_slots() -> Array`** — one entry per slot, `1..SAVE_SLOT_COUNT`
   (`:73`), in slot order, each the summary above plus `"newest": bool` on
   the one with the latest `updated_at`. The boot draws three rows and marks
   one; doing that from three separate calls plus a fourth for the latest is
   the kind of thing that drifts. `get_latest_save_summary()` (`:2802`)
   already picks the newest — use the same comparison, do not invent a
   second one.
3. **`get_latest_save_summary()` keeps ignoring incompatible slots.** It
   filters on `exists` today, so an incompatible slot must not start
   qualifying as "latest" and offering a CONTINUE that cannot work.

## Rules

- **Read-only. No writes, no new save fields, no migration.** Deciding what
  to DO about an incompatible save is a product call the user has not made;
  this task only makes the state visible.
- `_read_save` is the only reader; do not add a second parse path.
- An invalid slot number returns the same empty shape, not an error.
- Do not touch `SAVE_VERSION` or `_is_supported_career`'s rule. If you want
  to reuse it, split the version check out rather than loosening it.

## Owned files

- `Godot/scripts/GameState.gd`
- NEW `Godot/tests/save_slots_api_test.gd`

Nothing else. R29 owns the boot screens and is not started.

## Parse gate, before any test run

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/save_slots_api_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/save_slots_api_test.gd
```

Write a real save, then hand-edit its `save_version` in the save file to
prove the incompatible branch against an actual file rather than a mocked
dictionary — that is the whole point of the task. Use an isolated
`save_dir_override`, as the other API tests do.

Then `smoke_test.gd`, then the full suite once before the commit (Git Bash,
from `Godot/`, `GODOT` = the console exe): `for f in tests/*.gd; do timeout
600 "$GODOT" --headless --path . --script "$f" >/dev/null 2>&1 || echo "FAIL
rc=$? $f"; done`.

The gate is yours. One note from C11: if the suite ever appears to hang or a
scene fails to load, check `git status` first — a concurrent stage may have
a file mid-deletion in the shared tree, which is not a failure of your work.

## Finish

Check `git status -s` first, `git add -- <your files>` only, one commit,
push `master` (it is the same GitHub remote every agent shares; C11 needed
no separate approval), then convert your `HANDOFF.md` block to COMPLETE with
the hash (max 8 lines) and write `research/C12_DIGEST.md`.

`HANDOFF.md` has mixed line endings. Append your block without reformatting
anyone else's, and never rewrite another agent's block.

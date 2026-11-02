# TASK_C156 — CODEX — THE STAT ROW'S CONTRACT TEST, WRITTEN BLIND

**Owner:** codex
**Model:** `gpt-5.6-luna`, MEDIUM. (Not astra — this is a contract test, not 3D
animation design.)
**Test tier:** parse gate, then YOUR ONE NEW TEST ONLY. A new test file cannot
break another test, so do NOT run the suite.

## Why you and not Cursor

Cursor is building `UIKit.stat_row` right now under TASK_U127. **You are writing
the witness from the contract below, without seeing its implementation.** Do not
read `Godot/scripts/UIKit.gd`, `UITokens.gd` or `ProfileRevampPanel.gd`, and do
not read `TASK_U127.md`. A test written by the author of the code only agrees with
it.

This split has now paid off four times running — C142, C152, C154 and C155, the
last of which caught two real defects the moment its subject landed.

## Owned files

- `Godot/tests/ui_stat_row_contract_test.gd` — CREATE. Yours alone.
- `research/C156_DIGEST.md` — CREATE.

Do NOT edit `HANDOFF.md`.

## The contract

`res://scripts/UIKit.gd` will expose:

```
static func stat_row(label: String, value: Variant, max_value: float = 100.0,
        opts: Dictionary = {}) -> Control
```

`res://scripts/UITokens.gd` will expose a spacing base and a stat-row height as
named constants.

What must hold:

1. **IT RETURNS A LIVE `Control`**, not null, for a plain call
   `stat_row("Power", 72)`.
2. **HEIGHT IS 30 px.** Read it off the returned node's
   `custom_minimum_size.y` (or `size.y` once it has a minimum). Assert **exactly
   30**, not "about 30" — it is a named constant, so it is exact or it is wrong.
3. **THREE COLUMNS, IN ORDER: label, bar, number.** Walk the returned node's
   children and assert there are three layout children in that left-to-right
   order. The label carries the label text; the number carries the value.
4. **THE BAR IS 55% OF THE ROW WIDTH.** Give the row an explicit width (say
   400 px), let it lay out, and assert the bar's width is within 2 px of
   `0.55 * 400`. **This is the check most likely to catch a placeholder** — a
   stubbed row usually lets the bar fill.
5. **THE NUMBER IS RIGHT-ALIGNED AND TABULAR.** Assert the number node's
   horizontal alignment is `HORIZONTAL_ALIGNMENT_RIGHT`.
6. **AN INTEGER RENDERS WITHOUT A DECIMAL POINT.** `stat_row("Power", 72)` must
   produce the text `72`, never `72.0`. **Assert the STRING**, not the number —
   this is a formatting contract and only the string can fail it.
7. **A FLOAT RENDERS WITH AT MOST ONE DECIMAL.** `7.85` becomes `7.9` or `7.8`,
   never `7.85`.
8. **`opts["show_bar"] = false` REMOVES THE BAR** and keeps label and number.
   Assert the child count drops.
9. **VALUE IS CLAMPED TO `max_value`.** A value above it must not produce a bar
   wider than the bar's own track, and a negative value must not produce a
   negative width.
10. **`UITokens` SPACING IS A MULTIPLE OF 4.** Whatever base it exposes, assert it
    is a positive multiple of 4 — that holds whether the base is 4 or 8, and it is
    the only part of that argument the contract can settle.

## SKIP CLEANLY IF THE SUBJECT IS ABSENT

If `UIKit` has no `stat_row` method, print `SKIP — UIKit.stat_row not present yet`
and `quit(0)`. **That is what makes this file committable and green from the first
minute** — and it will skip today, because Cursor has not landed it. Say in your
digest that it skipped, so nobody reads the skip as a pass.

## THE TRAPS, AND EACH ONE HAS FAILED A TEST IN THIS PROJECT

1. **A `SceneTree` script's `_initialize()` runs BEFORE the tree is running.**
   `get_root()` returns the root Window and **that Window is not itself in the
   tree**, so `add_child` does not put anything in the tree either — measured
   2026-09-22. **A `Control` will not lay out until it is in a running tree**, so
   to check widths you must `await process_frame` first and add your row under a
   parent that IS in the tree. If sizes all read 0, that is the cause.
2. **`free()`, never `queue_free()`**, for anything you instantiate — a queued
   free is never processed and Godot prints `ERROR: Pages in use exist at exit in
   PagedAllocator`.
3. **`run_tests.py` fails a test on ANY line starting `ERROR:`.** Your test can be
   perfectly correct and still be condemned for either of the above.
4. **Your diagnostics must not use the runner's words.** It scans the log for
   lines starting `FAIL`/`FAILED`, any `failures=N` with N>0, any `N failure(s)`.
   Use `checks_failed=` for anything you print deliberately.

End with `checks=N failures=0` and `quit(1 if failures > 0 else 0)`.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/ui_stat_row_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ui_stat_row_contract_test.gd
```

Ceiling: it runs, reaches either its SKIP or `failures=0`, rc=0, and **zero lines
starting `ERROR:`**.

## PROVE IT WITH MUTANTS — AND THIS TIME ACTUALLY RUN THEM

On C155 you delivered a green test and **declined the mutant pass**, reasoning
that mutating an implementation copy "would not establish a contract witness".
**That is the wrong way round.** A green contract test proves nothing until it has
been seen to go red, and the mutant does not need to know anything about the test.
Claude ran it for you and got red=4 missed=0 — the test was fine, but nobody knew
that until it ran.

So: once `stat_row` exists, or against a minimal stub you write yourself at
**`/tmp/mutant_uikit.gd`** (NOT under `Godot/scripts/` — you are pinned to the main
checkout and a scratch file at the real path lands where the implementation goes),
break it four ways and confirm each is caught:

1. row height 28 instead of 30
2. bar at 100% width instead of 55%
3. the number left-aligned
4. an integer formatted as `72.0`

Report which check caught each. **A mutant your test does not catch is a check you
have not written.** If a pattern does not match the file, print `PATTERN-MISS` —
that is not a caught defect.

## Deliver

Commit, push, write the digest, and send one line with
`python Tools/agent_comms.py send --from codex --to claude --subject c156-ready`.

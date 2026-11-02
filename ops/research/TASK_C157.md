# TASK_C157 — CODEX — THE REGION PANEL'S CONTRACT TEST, WRITTEN BLIND

**Owner:** codex
**Model:** `gpt-5.6-luna`, MEDIUM. (Not astra — a contract test is not 3D
animation design.)
**Test tier:** parse gate, then YOUR ONE NEW TEST ONLY. A new test file cannot
break another test; do NOT run the suite.

## Why you, and why blind

Cursor is building `UIKit.region_panel` under TASK_U128 in a worktree you cannot
see. You write the witness from the contract below. **Do not read
`Godot/scripts/UIKit.gd`, `UITokens.gd`, `TASK_U128.md`, or any file under
`Godot/tests/ui_*`.**

The split paid off for the fifth time on 2026-09-22: C156 skipped green while
`stat_row` was absent, then FAILED three checks the moment U127 landed — and all
three were real defects (a fourth child, an upper-cased label). 14 of its 17
checks agreed with an implementation it had never seen. That is what a blind
witness is for.

## Owned files

- `Godot/tests/ui_region_panel_contract_test.gd` — CREATE. Yours alone.
- `research/C157_DIGEST.md` — CREATE.

Do NOT edit `HANDOFF.md`.

## The contract (from G64 §2, which both of you were handed)

`res://scripts/UIKit.gd` will expose:

```
static func region_panel(regions: Array, opts: Dictionary = {}) -> Control
```

`regions` is six `{ "key": String, "label": String, "value": float }` in the
order `head_neck, torso_core, left_arm, right_arm, left_leg, right_leg`.

What must hold:

1. **IT RETURNS A LIVE `Control`** for six well-formed regions.
2. **PANEL IS 220 × 164.** Read `custom_minimum_size`; assert exactly.
3. **SEVEN LAYOUT CHILDREN: one header, then six rows, in region order.** The
   header carries the text `BODY` and no number.
4. **EACH ROW IS 24 px TALL** — not 30. This is the check most likely to catch a
   panel that simply stacked `stat_row`s at the profile pitch.
5. **EACH ROW IS THREE COLUMNS, label | bar | number, LEFT TO RIGHT** — and the
   order is the SAME when `opts["side"]` is `"a"` and when it is `"b"`. A
   mirrored panel fails.
6. **THE BAR IS 112 px** (55% of the 204 px inner row), within 2 px.
7. **THE NUMBER IS ALWAYS SHOWN**, right-aligned, tabular integer: `0` renders
   `0`, `100` renders `100`, `72.4` renders `72`.
8. **THE LABEL CARRIES THE LABEL TEXT VERBATIM** — `"L ARM"` reads `L ARM`.
9. **FIVE REGIONS IS AN ERROR, NOT A FOUR-ROW PANEL.** Assert it returns null or
   pushes an error and does not silently build five rows.

## SKIP CLEANLY IF THE SUBJECT IS ABSENT

If `UIKit` has no `region_panel`, print `SKIP — region_panel not present yet`
and exit 0 with `checks=0 failures=0`. That is what makes you committable today.

## THE MUTANT PASS — NOT OPTIONAL

Write a minimal stub at **`/tmp/mutant_uikit_panel.gd`** (NOT under
`Godot/scripts/`; you are pinned to the main checkout and a scratch file at the
real path lands where the implementation goes). Run the UNMUTATED stub first so
you know the harness works, then break it four ways and confirm each is caught:

1. row pitch 30 instead of 24
2. columns mirrored on side `"b"`
3. header omitted (six children, not seven)
4. bar at 100% width

Print `PATTERN-MISS` for any pattern that did not match — GDScript here is
TAB-indented and a space-indented pattern silently never matches. **A mutant your
test does not catch is a check you have not written.**

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/ui_region_panel_contract_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ui_region_panel_contract_test.gd
```

## Deliver

`git restore --staged AgentComms/messages`, stage explicit paths, commit, push,
write the digest, and send one line with
`python Tools/agent_comms.py send --from codex --to claude --subject c157-ready`.

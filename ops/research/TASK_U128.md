# TASK_U128 — CURSOR — THE REGION PANEL, ONCE, IN UIKit

**Owner:** cursor
**Model:** `composer-2.5`, MEDIUM. `-p --force --trust --workspace <wt>`
**Test tier:** parse gate on every touched `.gd`, then `run_tests.py --only ui`
and SEPARATELY `--only screen`. **`--only` DOES NOT STACK** — one per invocation,
read `total=` to confirm how many ran. **No full suite.**

## Why this is the second UI job

U127 shipped `UIKit.stat_row` at 30 px and it is the profile's row. G64 landed
the fight-night HUD the same day and its region panel REUSES the stat-row column
contract at a TIGHTER pitch, with the arithmetic for why:

> 6×30 = 180, plus name + health + HR + ticker + dock = 334, which blows the 320
> bottom band. 24 px still clears SIZE_MIN 12.

Two landed documents specify this component completely — G64 owns every pixel,
M23 owns every state. You are building the thing they agreed on.

## What to build — `UIKit.region_panel(...)`

```
static func region_panel(regions: Array, opts: Dictionary = {}) -> Control
```

`regions` is six entries `{ "key": String, "label": String, "value": float }` in
the fixed order `head_neck, torso_core, left_arm, right_arm, left_leg, right_leg`
(labels `HEAD · TORSO · L ARM · R ARM · L LEG · R LEG`, from G64 §2).

**Geometry, every number from G64 §2 — do not invent a pixel:**
- Panel **220 × 164**. Header **20 px** carrying the text `BODY` and no number.
- Six rows at **24 px pitch** (six rows = 144). Row is `label | bar | number`,
  LEFT TO RIGHT, same on both corners — **NEVER MIRRORED** (`opts["side"]` is
  accepted and changes nothing about column order; identity is dock side).
- Label **52 px** left, 12 px type. Bar **112 px = 55% of the 204 px inner row**.
  Number **40 px** right, tabular integer 0–100, 14 px type, **always shown,
  including 0 and 100.**
- Long labels: ellipsis, never wrap (same trap as U127).

**Reuse, do not duplicate.** `stat_row` already does `label | bar 55% | number`.
Give it a `pitch` opt (default `UITokens.STAT_ROW_HEIGHT` = 30) and build each
region row THROUGH it at 24 — the column contract must come from ONE place. If
`stat_row`'s current geometry cannot take a pitch without a rewrite, say so in the
digest and stop rather than forking a second row.

**State, from M23 — read `research/M23_REGION_READOUT.md` §"States":** each
region carries a state derived from `value`, and the bar shows it as **fill% plus
a hatch** (M23's second channel beside colour). Colours come from `UITokens`
(M22). You do not choose a colour; you look one up.

## Owned files, with real sizes

- `Godot/scripts/UIKit.gd` — **7,4xx lines. NEVER open it whole.** `grep -n
  'static func stat_row'` and read a `sed -n` window; add `region_panel` right
  after it.
- `Godot/scripts/UITokens.gd` — ~265 lines, read whole. Add
  `STAT_ROW_PITCH_HUD := 24` and the panel/header/column constants as NAMED
  constants; a bare 24 inline has no handle.
- `Godot/tests/ui_region_panel_test.gd` — CREATE. Your own witness.
- `research/U128_DIGEST.md` — CREATE.

Do NOT edit `HANDOFF.md`. Do NOT read `TASK_C157.md`.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/UIKit.gd Godot/scripts/UITokens.gd Godot/tests/ui_region_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ui_region_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ui_stat_row_contract_test.gd
python Godot/tools/run_tests.py --only ui
python Godot/tools/run_tests.py --only screen
```

**`ui_stat_row_contract_test.gd` must stay at `checks=18 failures=0`.** It is
the blind witness that caught two defects in U127 the moment it landed; if adding
a `pitch` opt changes its reading, you have changed the profile row's contract
and that is a regression, not a feature.

## THE TRAP

**A fourth child.** U127 added a hairline separator as a fourth child of the row
and the blind contract test failed it — three columns means `get_child_count()
== 3`, and with the bar hidden, 2. Draw nothing decorative inside a row. The
same applies to the panel: header plus six rows, nothing else.

**Second trap: `caps()` calls `to_upper()`.** The label carries the label text
verbatim. G64's labels are already capitals; pass them as given.

## Deliver

Commit on a branch, push, write the digest, and send one line with
`python Tools/agent_comms.py send --from cursor --to claude --subject u128-ready`.
**Unstage `AgentComms/messages` before you commit.**

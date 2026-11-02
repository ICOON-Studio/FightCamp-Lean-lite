# TASK C36 — FORMER: THE GYM REMEMBERS WHO IT RETIRED (Codex)

**Status: OPEN (assigned 2026-09-07).** Runs in parallel with R53. Read the
"Do not touch" list before you open anything — R53 is live in the same
checkout and owns the profile.

Model: top tier, effort medium, Fast off. One session.

## Why this exists

`GameState.get_retirements()` (`GameState.gd:7311`) has **no caller outside
`Godot/tests/`**. R51b records every retirement the gym grants and nothing
ever reads it back, so a career the player ended leaves no trace they can
open. K25 (Kalli, landed 2026-09-07) ruled where it goes, and this task is
that ruling and nothing more.

## The ruling you are building (K25, already decided — do not re-litigate)

- **FORMER lives under OFFICE.** Not GYM: GYM is who trains tomorrow, and
  `UIKit.squad_row` stays active roster only. Not a new rail item (K10).
- A row is `name · retired age · retired week`. **Tap opens that fighter's
  profile**, which is where K24's epilogue is read.
- An optional count ("3 former").
- **Refused, explicitly: a trophy cabinet, a highlight reel, a belt museum.**
- RETIRED ink is `MUTED` (M11), never BAD and never GOLD.
- Honest-number grammar: a figure the game does not know is **withheld as an
  em-dash**, never a guess and never asterisk wallpaper.

**Put it on a fourth OFFICE tab, `former`.** K25's sketch shows it as a
section under staff/paper, and either reading satisfies the ruling; the list
grows without bound across a career and THE DESK already carries the desk,
the gym week, the runway, the purse, the sponsor and a side column, so a tab
is the honest home. If you judge the desk section truer once you see it, that
is your call — say which you built and why in the digest.

## Owned files

- `Godot/scripts/OfficeHubPanel.gd` — **1,437 lines: do not open it whole.**
  Read `sed -n 'A,Bp'` windows at the anchors below.
- `Godot/tests/office_hub_panel_test.gd` (extend), and a new
  `Godot/tests/office_former_test.gd` if the panel test gets crowded.

**Do not touch — R53 is live in this tree and owns them:**
`Godot/scripts/ProfileRevampPanel.gd`, `Godot/scripts/GameState.gd`,
`Godot/tests/profile_revamp_test.gd`, `Godot/tests/aging_test.gd`.
Also not yours: `Aging.gd` (R52), `WorldPopulation.gd` (C34),
`CareerEpilogue.gd` (G9).

## Anchors

| file:line | what |
| --- | --- |
| `OfficeHubPanel.gd:66` | `const TABS := ["desk", "books", "promotions"]` |
| `OfficeHubPanel.gd:67` | `const TAB_LABELS := ["THE DESK", "THE BOOKS", "PROMOTIONS"]` |
| `OfficeHubPanel.gd:154` | `rebuild()` — the tab switch that dispatches to `_build_*` |
| `OfficeHubPanel.gd:814` | `_build_books()` — the list-with-header pattern to mirror |
| `OfficeHubPanel.gd:1146` | `_build_empty(headline, line)` — use it for "no former fighters yet" |
| `OfficeHubPanel.gd:1241` | `TABS`-indexed tab selection |
| `GameState.gd:7311` | `get_retirements()` — **read it, never edit it** |

## What `get_retirements()` actually returns

Newest first, each entry written at `GameState.gd:7296`:

```gdscript
{"week": int, "athlete_id": String, "name": String,
 "age": int, "record": Dictionary, "reason": String}
```

That is the whole record. **`age` is the retired age and `week` is the
retired career week** — K25's "retired_age / retired_week" are these two, not
new fields.

**There is no belt field.** K25 calls a belt note "at most one" and optional:
adding one would mean editing `GameState.gd`, which is R53's this week, so
**do not**. Ship without it and note it in the digest as available later.

## Scope

1. The `former` tab: count in the label or header, rows newest first.
2. A row opens `ProfileRevampPanel` for that `athlete_id`. **The retired
   profile's own contents are R53's** — you deliver the path to it, not the
   epilogue. If the profile does not yet render a retired fighter well, that
   is expected this week; do not build a second profile.
3. Empty state through `_build_empty()`. A gym that has retired nobody is the
   normal early game, not an error.
4. A row whose figure is missing prints an em-dash. Never fabricate an age.

## The traps

- A retired fighter is **off the roster** and lives in the world population
  (`GameState.gd:689 get_world_athlete_by_id`). `get_athlete()` will not find
  them. Route by `athlete_id` and let the profile resolve it.
- A Control with full-rect anchors must never have `size` assigned when it is
  mounted (R31): that writes the OFFSETS and the node ends up twice its
  parent. Let the anchors fill it and pass the size down.
- Scene scripts compile before the autoloads: reach GameState through
  `get_node_or_null("/root/GameState")` plus `has_method`, never the bare
  identifier.
- A `Label` outside a Container does not autowrap — break lines with `\n`.
- No new UIKit factory and no new token (K10 / M11 standing).

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/OfficeHubPanel.gd
```

## Tests

```
--script tests/office_hub_panel_test.gd
--script tests/office_hub_api_test.gd
--script tests/office_nav_and_profile_overlay_test.gd
```

Then the full suite ONCE in the background before the commit.

## Done

Commit and push `master`, write `research/C36_DIGEST.md` (short),
convert your own block in `HANDOFF.md` to COMPLETE (max 8 lines, nobody
else's), regenerate `TASKS.md`, and send one line with
`python Tools/agent_comms.py send --from codex --to claude --topic "C36 ..."`.

**Header format matters:** a `### ` header must END with the
`(COMPLETE 2026-09-07)` parenthesis. Put the commit hash in the `**Status:**`
line instead — a trailing period after the parenthesis used to drop the task
off the board and out of `TASKS.md` silently. `board` now prints a WARNING if
it cannot read a header; check that line before you finish.

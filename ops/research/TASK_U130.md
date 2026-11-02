# TASK_U130 - CURSOR - THE POST-FIGHT RESULT BLOCK AND CAUSATION BOX

**Owner:** cursor
**Model:** `composer-2.5`, MEDIUM. `-p --force --trust --workspace <worktree>`
**Test tier:** parse gate on every touched `.gd`, then
`python Godot/tools/run_tests.py --only ui`. `--only` DOES NOT STACK - one
substring per invocation, read `total=` to confirm how many ran. Do NOT run the
full suite.

## Why this, and it is fully specified already

`research/G66_POST_FIGHT_SURFACE.md` landed this morning (Grok, 75
sources) and places the post-fight screen to the pixel. Your U128
(`region_panel`) and U129 (`scored_card`) both landed clean on the same kind of
spec. This is the third.

**Read `G66_POST_FIGHT_SURFACE.md` sections 2 and 4 ONLY.** You do not need the
rest of the document and you must not re-derive G64 or G65.

## What to build

### `UIKit.result_block(...)` - G66 section 2

- Frame **840 x 64**. Two lines, not one.
- Line 1: `WINNER def. LOSER` - **28 px**, h=36, tabular surnames.
- Line 2: `METHOD · R n M:SS` - **18 px**, h=24. Method tokens: `UD`, `SD`,
  `KO`, `TKO`, `SUB`, and `RTD` / `DQ` / `NC`.
- **DRAW:** line 1 is `D. SURNAME vs D. SURNAME · DRAW · R n M:SS`; the method
  line still carries the time.
- **NC:** line 1 names both; line 2 starts `NC`.
- A method token the list does not contain returns `null` - **without
  `push_error`**, exactly the way `region_panel` rejects a five-region input, so
  the suite does not read your intentional negative case as an engine error.

### `UIKit.causation_box(...)` - G66 section 4

- Frame **840 x 148**. Header **16 px tall, 12 px type, label `CAUSE`** and no
  sentence in it.
- **5 fixed line slots**, pitch **22 px**, type **14 px**, pad 16 / 16.
- Arithmetic that must hold: `16 + 16 header + 5*22 + 16 = 148`.
- **THE BOX DOES NOT GROW AND DOES NOT SHRINK.** Fewer than five bullets leaves
  empty slots at full height. More than five is a caller error - return `null`,
  again without `push_error`.
- **72 characters hard per line, no wrap.** Over-length text **ellipsises**; it
  never wraps to a second slot and never starts a sixth.

## Owned files

`Godot/scripts/UIKit.gd`, `Godot/scripts/UITokens.gd` if a token is genuinely
missing, the kit-book entries, and a new `Godot/tests/ui_post_fight_test.gd`.
Nothing else.

**BIG FILE WARNING:** `Godot/scripts/UIKit.gd` is large - do not read it whole.
Find your own `scored_card` with `grep -n "func scored_card"
Godot/scripts/UIKit.gd` and read a `sed -n` window around it; it is the exact
shape of this job, including the reject path and the tabular-number handling.
`Godot/scripts/GameState.gd` is ~12,900 lines and this task does not need it.

## Gate, with the real numbers

```
python Godot/tools/check_scripts.py Godot/scripts/UIKit.gd <any other touched .gd>
python Godot/tools/run_tests.py --only ui
```
`--only ui` is **total=15** today and must stay **fails=0**. It includes:

- `ui_stat_row_contract_test.gd` **checks=18 failures=0**
- `ui_region_panel_contract_test.gd` **checks=86 failures=0**
- `ui_kit_book_test.gd` - **317 variants, 317 renders, 0 failures** as of
  2026-09-22.

**The exit code alone is NOT a pass** - a GDScript runtime error still exits 0.
Read the printed checks/failures line; treat any `ERROR:` line as a failure.

**EVERY NEW PUBLIC `UIKit` FACTORY NEEDS A KIT-BOOK ENTRY, and then its PNG.**
`ui_kit_book_test` went red twice this week for exactly this. After adding the
entries run **`tools/render_kit.gd` WITHOUT `--headless`**:
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --path Godot --script tools/render_kit.gd
```
and commit the new PNGs under `DesignLibrary/kit/renders`.

## Delivery

Cut a FRESH branch off `origin/master` first - your worktree sits on
`cursor/u129-scored-card`, already merged. Commit with explicit paths
(`git add -- <files>`), never `git add -A`. Push YOUR BRANCH, not master. Write
`research/U130_DIGEST.md` and send one line:
```
python Tools/agent_comms.py send --from cursor --to claude --subject u130-ready --body "..."
```
Your mail must be ON THE BRANCH YOU PUSH or Claude's inbox reads unread=0. Do
NOT edit `HANDOFF.md`.

## WHAT ALREADY EXISTS - READ BEFORE YOU START (operator rule 2026-09-22)

**"The agents should have all available information on existing researches and
tools."** This checkout holds **789 research documents, 220 Godot tools and 116
drivers**, and until today no task file told you they were there.

`RESEARCH_INDEX.md` at the repo root is the generated list - one line per
artefact, with what it is. **GREP IT, DO NOT READ IT WHOLE** (it is 213 KB;
reading it costs more than the exploration it replaces):

```
grep -in '<your topic>' RESEARCH_INDEX.md
```

Worth a grep here: `G64`, `G65`, `G66`, `kit`, `UIKit`, `stat_row`.

Then read the two or three that match, and nothing else. **A research document
is a FINDING, not an instruction** - it reports what was true when it was
written. If it names a file, a function or a flag, check that still exists
before building on it.

**AND A NEGATIVE RESULT IS A RESULT.** Several documents record that something
does NOT work - paired clip generation, a purchasable grappling pack, a numbered
referee break clock. Those are the most expensive findings in the set, and
re-running one wastes your whole pass.

**If the index shows something already answers part of your task, SAY SO in
your digest and build on it** rather than deriving it again. If it shows
something that CONTRADICTS your result, say that too - a contradiction found
early is worth more than a clean number found late.

## THE ONE TRAP FOR THIS TASK

**The 72-character budget is a MEASURE, not a `length()`.** G66 derives it from
an advance of about 8 px per cap at 14 px against an inner measure locked to
576 px - `576 / 8 = 72`. Clip on the measured width using the same font metric
the rest of the kit uses, not on `String.length()`, or a line of narrow
characters will ellipsise while it still fits and a line of wide ones will
overflow the box G66 says must never grow. Assert BOTH directions in your test.

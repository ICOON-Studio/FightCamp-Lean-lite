# TASK U17 — CURSOR — THE GRAND PRIX BLOCK THAT EATS THE FIGHT LOG

Model: Composer, effort **medium**, Fast off.

**Agent:** cursor · **Opened:** 2026-09-08 · **Follows:** U16 (`1c5c8b3`..merge)

## Why this exists — measured, not assumed

U16 shipped and is correct for the contract it was given. But the GRAND PRIX
block sizes the FRAME FROM THE DATA, and the FIGHT RECORD tab has a fixed
height, so a decorated fighter loses the bottom row of the tab.

`ProfileRevampPanel.gd:1347` `_build_record`:

```gdscript
gp_block_h = 36.0 + float(gp.size()) * 32.0      # grows without bound
...
var row2_y := arc_h + 8.0 + gp_block_h
_fill_log(_frame_at(body, "FIGHT LOG ...", Vector2(0.0, row2_y), Vector2(1010.0, h - row2_y), "slate"))
_fill_numbers(_frame_at(body, "THE NUMBERS ...", Vector2(1022.0, row2_y), Vector2(472.0, h - row2_y), "slate"))
```

`body.size.y` is **498** on this tab (`HEIGHT 850` − `y 352`; `record` is not
in `DEEP_TABS`). `arc_h` is 232. So the bottom row gets `258 - (44 + 32n)`.

**Measured in a headless probe, not calculated:**

| Grand Prix wins | FIGHT LOG frame | its body |
| --- | --- | --- |
| 0 | 258 | 224 — today's layout, correct |
| 3 | 118 | 84 |
| 5 | 54 | 20 |
| **6** | 22 | **0 — the log's contents are gone** |
| **7+** | **0** | **0 — the frame itself is gone** |

Godot clamps at zero instead of going negative, so there is no error and no
crash: at seven Grand Prix wins the FIGHT LOG and THE NUMBERS **silently
disappear** from the fighter's record. Seven is reachable — a grappler who
wins a couple of Grand Prix a year passes it inside a normal career.

## The fix — adopt the contract the fight log already uses

`_fill_log` at `:1633` already solves exactly this, and U16 inverted it:

```gdscript
var max_rows: int = maxi(1, int((b.size.y - 24.0) / row_h))
for i in mini(log.size(), max_rows):
```

**The frame is a budget; the rows are derived from it.** The header carries the
true total (`"... · %d BOUTS" % log.size()`), so a capped list hides nothing.

Do the same for GRAND PRIX:

1. `const GP_BLOCK_H := 132.0` — a fixed budget (36 + 3 rows × 32), used only
   when the array is non-empty. `row2_y` therefore never exceeds
   `232 + 8 + 132 + 8 = 380`, leaving the bottom row **118px at worst**.
2. `_fill_grand_prix` (`:1399`) derives its row count from `b.size.y` the way
   `_fill_log` does, and stops at `mini(titles.size(), max_rows)`.
3. The frame title carries the TRUE count, not the shown count:
   `"GRAND PRIX  ·  %d WIN%s"` — singular at 1, plural otherwise. Follow the
   `%s`/`%d` plural idiom already used for `TITLE FIGHT%s` at `:1395`.

## Owned files

* `Godot/scripts/ProfileRevampPanel.gd` — 3,282 lines. **Never open it whole.**
  Read `sed -n '1340,1440p'` for `_build_record` / `_fill_grand_prix` /
  `_grand_prix_line_words`, and `sed -n '1633,1660p'` for the `_fill_log`
  pattern you are copying. Constants are at `:24-36`.
* `Godot/tests/profile_revamp_test.gd` — 847 lines. The U16 block starts at the
  `# --- U16: Grand Prix wins on the record, not a belt ---` comment.

Nothing else. Do NOT touch `GameState.gd`, `UIKit.gd` or `HANDOFF.md`.

## What must stay true (U16's tests already assert these — keep them green)

* Absent key and `[]` both draw NO frame, and `row2_y` stays exactly
  `arc_h + 8.0`, so the log sits where it does today.
* Newest first.
* No belt language anywhere in the block: no CHAMPION, DEFEND, REIGN, BELT.
* `event_results` is never read. `grand_prix_titles` is taken once in `_read()`.

## New assertions this task owes

* With **20** titles: the FIGHT LOG frame exists and its body height is `> 0`;
  the same for THE NUMBERS. This is the regression that would have caught it.
* With 20 titles: `_count_named(body, "GrandPrixRow")` is the capped number,
  not 20.
* With 20 titles: the GRAND PRIX frame title states **20**, so the cap hides
  nothing.
* With 2 titles (U16's existing case): still exactly 2 rows, unchanged.

## Gate

Parse gate first, then the focused test, then the suite ONCE in the background:

```
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/tests/profile_revamp_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
```

The suite counts FILES, and U17 adds assertions to `profile_revamp_test.gd`
rather than a new test file — so the total stays **187 and must not rise**.
Gate on failures only: **0 failures**. If you finish with fewer failures than
you started with, say so and push; never hold a better result back.

## The trap

`gp_block_h += 8.0` after the frame is built (`:1367`) is a spacer, not part of
the frame — keep that separation when you swap in the constant, or the block
and the log will overlap by 8px. And the frame's SIZE is what `_fill_grand_prix`
reads to derive rows, so set the size before you fill it, exactly as
`_build_record` already does for the log.

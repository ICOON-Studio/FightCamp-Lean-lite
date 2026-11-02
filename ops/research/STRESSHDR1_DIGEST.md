# STRESSHDR1 DIGEST (S212) — Profile Header Stress Bar and Career Wear Pill

- Agent: Antigravity (`agy`, free tier)
- Worktree: `E:/FightCamp/wt/STRESSHDR1`
- Branch: `agy/stresshdr1` (cut from `origin/cursor/profile2e`)
- Task: `research/TASK_STRESSHDR1.md`

## 1. Files and Lines Changed

### `Godot/scripts/ui/ProfileOverview.gd`
- **Lines 19–24**:
  - Added preloads for `StressCauses` (`res://scripts/rules/StressCauses.gd`) and `StressRules` (`res://scripts/rules/StressRules.gd`).
  - Added named constants for Career Wear thresholds:
    ```gdscript
    const CAREER_WEAR_LOW: float = 25.0
    const CAREER_WEAR_MED: float = 50.0
    const CAREER_WEAR_HIGH: float = 75.0
    ```
- **Lines 266–273**:
  - Added helper `static func _career_wear_color(wear: float) -> Color` mapping wear to 4 band colours (< 25 green, < 50 yellow/amber, < 75 orange, else red) reusing `ProfileTabsLayout` constants (`GREEN`, `AMBER`, `ORANGE`, `RED`).
- **Lines 276–440 (`_build_banner`)**:
  - Shrunk `Identity` label width from 940 px to 500 px (`Vector2(470, 6)`, `Vector2(500, 22)`, ending at x = 970).
  - Added `StressBar` `Control` (`Vector2(990, 5)`, `Vector2(230, 22)`):
    - Rendered only when athlete has stress data (`athlete.get("stress") is Dictionary and not empty`).
    - Contains:
      - Label `"Title"`: `"STRESS"` (`Vector2(0, 0)`, `Vector2(52, 22)`, font 12 bold, color `#94A3B8`).
      - Control `"Bar"` (`Vector2(58, 7)`, `Vector2(60, 8)`): dark background rect `"Bg"` (60x8, `#1E293B`) + fill rect `"Fill"` filled to `stress / 100.0 * 60.0` in band colour (`ProfileTabsLayout._stress_band_color(band)`).
      - Label `"Badge"`: `"<stress int> <BAND>"` (e.g. `"62 STRAINED"`, `Vector2(126, 0)`, `Vector2(104, 22)`, font 12 bold, in band colour).
    - Tooltip set to `StressCauses.tooltip(stress_state)`.
    - `mouse_filter = Control.MOUSE_FILTER_STOP` enabled so tooltip displays on hover.
  - Added `WearPill` `Panel` (`Vector2(1240, 5)`, `Vector2(160, 22)`):
    - Rendered only when athlete has `career_wear` (`athlete.has("career_wear") and athlete.get("career_wear") != null`).
    - Styled with rounded `StyleBoxFlat` (corner radius 10) in wear band colour.
    - Contains centered Label `"Label"`: `"CAREER WEAR %d%%" % wear_int` (`Vector2(0, 0)`, `Vector2(160, 22)`, font 11 bold, white `#FFFFFF`).
    - Tooltip set to `"Career wear %d/100 - knockdowns, hard fights and age add to it; it never fully heals" % wear_int`.
    - `mouse_filter = Control.MOUSE_FILTER_STOP` enabled so tooltip displays on hover.
  - Preserved all five original banner labels (`Name`, `Nickname`, `Identity`, `Morale`, `Composure`) and their left-to-right order.
  - Overall banner width (1888 px) and position maintained.

### `Godot/tests/profile_overview_test.gd`
- **Lines 5–6**:
  - Added preloads for `StressCauses` and `StressRules`.
- **Lines 114–162 (`_test_build`)**:
  - Test case (b): Verified athlete without stress (`bare`) has no `"StressBar"` and no `"WearPill"`.
  - Built `hdr_athlete` with stress 62 and log entries from 2x `hard_day` and 1x `cut_3_5` via `StressRules.apply()`, plus `career_wear: 40.0`.
  - Test case (a): Verified node `"StressBar"` exists on `hdr_view`, its `tooltip_text == StressCauses.tooltip(st_state)`, `mouse_filter == MOUSE_FILTER_STOP`, and child `"Badge"` text contains `"62"`.
  - Test case (c): Verified node `"WearPill"` exists, has `mouse_filter == MOUSE_FILTER_STOP`, and child `"Label"` text contains `"40"`.
  - Test case (d): Verified no child rects overlap inside `hdr_banner` (pairwise `Rect2.intersects()` comparison across all children: `Name`, `Nickname`, `Identity`, `StressBar`, `WearPill`, `Morale`, `Composure`).

## 2. Geometry Layout Summary Inside Banner
- Banner bounds: `Rect2(16, 82, 1888, 32)`
- Child rects:
  - `Name`: `Rect2(12, 3, 280, 26)` -> span [12, 292]
  - `Nickname`: `Rect2(300, 6, 160, 22)` -> span [300, 460]
  - `Identity`: `Rect2(470, 6, 500, 22)` -> span [470, 970]
  - `StressBar`: `Rect2(990, 5, 230, 22)` -> span [990, 1220]
  - `WearPill`: `Rect2(1240, 5, 160, 22)` -> span [1240, 1400]
  - `Morale`: `Rect2(1430, 6, 190, 22)` -> span [1430, 1620]
  - `Composure`: `Rect2(1630, 6, 250, 22)` -> span [1630, 1880]
- All spans are strictly non-overlapping, with clear visual margins between segments.

## 3. Notes / Unsure Items
- `StressCauses.gd` was assigned to Arena in `TASK_STRESSTIP1` to land on `master`. Worktree `E:/FightCamp/wt/STRESSHDR1` was branched from `origin/cursor/profile2e` which predated that merge. As per task specification ("The tooltip text is ALREADY WRITTEN: StressCauses.tooltip(state) - do not write another"), we preloaded and consumed `StressCauses.gd` directly without rewriting it. It will resolve cleanly once Claude runs the integration rebase/merge with `master`.
- No shell, git, grep, or Godot commands were executed, strictly adhering to the file-tools-only constraint.

# U8 DIGEST — THE CAREER AS YEARS, NOT ONLY BOUTS

Cursor · 2026-09-08 · `GameState.gd` (compose only) + `ProfileRevampPanel.gd` + `profile_revamp_test.gd`. Top tier / high / Fast off.

## What shipped

G10 `CareerArc.build` is spent. `get_fighter_card()` composes it as `career_arc` beside R53's aging read, **inside the disposable career copy**, above the restore. Empty log → `{}`. Debut week is the oldest row. Birth age is `age - (card_week - debut_week) / 52`, floored at 0. Window is `{from: peak_from, to: peak_to}` when the aging read is `ok`, else `{}`.

FIGHT RECORD draws a year spine under the amateur line: one cell per laid-out year (year, fight count, W-L-D). `in_window` years take R53's TEXT_2; others are unmarked. Summary names busiest and best; idle gap only when `longest_gap_weeks > 0`. One year is one cell, not a stretched bar. No fights: the frame is unchanged, no spine.

No new UIKit factory, no new token, `CareerArc.gd` untouched. K24: the spine never prints declining / past peak / washed.

## Gate

`python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/ProfileRevampPanel.gd` — pass.

`tests/profile_revamp_test.gd` 0 failures. `tests/career_arc_test.gd` 0. `tests/fighter_card_test.gd` 45/45. `tests/smoke_test.gd` 0. Full suite **168/168**.

## Left

U9 (unblocked by R59 + Q3). Branch `cursor/u8-career-arc-years-73b7`. Please write the HANDOFF block if this one conflicts; I also appended an 8-line COMPLETE under U6.

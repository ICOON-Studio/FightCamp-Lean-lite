# U205 digest — week in review

**Date:** 2026-10-01  
**Branch:** `cursor/u205-week-in-review`

## What works

- Sunday `continue_day()` no longer drops `advance_week()`'s report: it is stashed on `GameState` and opens the `week_review` set-piece before any crowning route.
- `WeekReviewPanel.build_read()` turns that report plus `get_next_week_hooks()` into money tiles (icon + tooltip), fighter deltas, results, and next-week hooks — testable without mounting the scene.
- Player dismisses with **NEXT WEEK**, ESC, or click outside; leaving clears the stash and still chains crowning when pending.

## Evidence

- `Godot/tests/week_review_test.gd` — seven Continues, route + read contracts.
- Stills: `previews/u205/week_review.png` (from `Godot/tools/CaptureU205WeekReview.gd`).

## Next

- Operator watch: one full career week in the `.exe` — confirm count-ups feel right with menu effects on (U204).

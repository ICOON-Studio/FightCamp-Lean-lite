# TASK U205 - WEEK IN REVIEW: the week pays out on screen, and hands the player a reason for one more (UI, Cursor)
Owner: Cursor (composer). Worktree D:/FightCamp/wt/U205, branch cursor/u205-week-in-review (from master).
Operator 2026-10-01, verbatim: "prioritize game loop to be fun and addictive not boring everything needs to have a meaning
and reward the player for progressing and try to get the feeling of just one more turn" + "use icons when its possible to
skip text (with the necessary toolltip of course)". S137_LOOP_PLAN.md row L1.

## Why (measured S137)
`CareerRoot.on_continue()` (Godot/scripts/CareerRoot.gd ~270) calls `GameState.continue_day()` and DISCARDS the result.
When the 7th day completes, `advance_day()` returns `advance_week()`'s whole report with `week_completed: true`
(GameState.gd: advance_day ~7127, advance_week ~7287, its return ~7669): upkeep, payroll, billed, membership_income,
sponsorship_income, fight_results, body_results, technique_results, discipline_results, world_results, injury_results,
cancelled_fights. Only the news headlines survive (`_push_news`). The week's reward is computed and thrown away - the
player presses CONTINUE and learns nothing about what his work bought. D66_STRICT_REVIEW.md #1/#7/#9 name this.

## Prior research
`python Tools/prior_research.py week report inbox summary turn end reward`; D66_STRICT_REVIEW.md; DayFeedPanel.gd header
(THE DAY briefing, K18); WeeklyObjectives.gd (3 objectives a week, rewards); the crowning route pattern in
CareerRoot.on_continue (a route pushed after continue, `router.push("crowning")`); DesignLibrary/GLOSSARY.md.

## What would a human do?
Civilization's turn summary + Football Manager's weekly inbox digest + Motorsport Manager's race-weekend payout: a single
card that opens after the week ends, in this order: (1) MONEY - in vs out, net, as icon tiles; (2) YOUR FIGHTERS - per
fighter the attribute ticks, techniques learned / reps, breakthroughs, injuries (only what moved); (3) RESULTS - fights,
ranking moves, objectives paid; (4) NEXT WEEK - one hook line per thing that is ABOUT to happen (a booked fight in N weeks,
an offer expiring, a fighter 1 rep from a breakthrough, an objective nearly done). One button: NEXT WEEK. ESC / click
outside closes. Short animation (count-ups via UiFx.count_up, already on master from U204). Never more than one screen tall.

## Art direction (operator, binding)
Icons over text wherever an icon carries the meaning, each with a framed tooltip (GLOSSARY "Icon with tooltip": title,
total, breakdown per source). Icons: `UIKit.icon_plate(<lucide name>)` from Godot/assets/icons/lucide (banknote, trending-up,
trending-down, dumbbell, biceps-flexed, sparkles, bandage, trophy, medal, calendar-clock, hourglass, target...). Tooltips:
`UIKit.tip(node, {"text": ...})` (TipLayer autoload). Bright and alive (house rule).

## Owned files
- NEW `Godot/scripts/WeekReviewPanel.gd` (+ a route `week_review` in SceneRouter.gd, ONE line, setpiece or overlay tier as
  crowning does) - a static `build_read(report: Dictionary, next_week: Dictionary) -> Dictionary` that a test can read
  without a scene, and the panel that draws it.
- `Godot/scripts/CareerRoot.gd`: on_continue keeps the step; when `week_completed` is true, stash the report on GameState
  (a field or a tiny `set_last_week_report()` in GameState.gd) and push `week_review` (before the crowning push; crowning
  still follows). Name every edited line range.
- `Godot/scripts/GameState.gd`: ONLY a getter/setter for the last week report and a `get_next_week_hooks()` read built
  from existing getters (booked fight due week, offer deadlines, breakthrough progress, objective progress). No rule changes.
- NEW `Godot/tests/week_review_test.gd`: drive a real career 7 days with CONTINUE (as the walk tests do) -> the route opens,
  the read holds the money net = income - costs from the report, every tile has an icon + tooltip, a fighter with no change
  shows no row, and the NEXT WEEK list names a booked fight's weeks-out. Control: a mid-week CONTINUE opens nothing.
- Stills (hidden windowed) -> `previews/u205/`; OPEN THEM. `research/U205_DIGEST.md`.
- Never edit HANDOFF.md.

## Tests
Parse gate on every touched .gd; the new test; then
`python Godot/tools/run_tests.py --jobs 2 --only week_review,career_root,day_feed,weekly_objectives,smoke,schedule_hub,ui_fx`.
Watchdog first: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`.

## The one trap
Full-rect-anchored Controls: never assign `size` on mount; `remove_child` before `queue_free` on rebuilds. Tests and render
tools run with transitions/effects OFF (UiFx.set_effects(false)) - never await a tween in a test.

## Finish
git add by explicit path, commit, git push -u origin cursor/u205-week-in-review. Do not stop at "written".

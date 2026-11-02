# TASK WIRE-DRAWERS A - the skip button opens the SkipDay preview in the side drawer (S199)
Model: Codex gpt-6-luna medium. Worktree E:/FightCamp/wt/WIREDRAWERS, NEW branch codex/wire-drawers:
`git fetch && git worktree add E:/FightCamp/wt/WIREDRAWERS -b codex/wire-drawers origin/master` (already done by the launcher prep).

## Prior research
Ludo r32 5.3 (skip a day = coach runs it, preview of what you lose; operator Q-S196-3 "approve all"); TASK_DRAWER1.md,
TASK_SKIPDAY1A.md (SkipDay.gd merged), TASK_TICKER1 (morning ticker). Right-third drawer = DrawerHost (merged, pure UI, tested).

## What would a human do?
Press the "..." skip button in the top time bar, see a drawer slide over the right 38% with "82% of a full day ... Lead Hook 2 misses 45
drill minutes ... ends at 34 stamina", with CONFIRM SKIP and CANCEL. Time is paused while it is open. Confirm -> the day is skipped as today.

## Prefab check
None needed: DrawerHost + SkipDay + ClubSpeedControls exist.

## Owned files
- `Godot/scripts/GymHallPanel.gd` (edit: `_on_ticker_skip` at ~line 202, handlers at ~190; read in windows, it is large)
- `Godot/scripts/ui/DrawerHost.gd` (211 lines, read-only unless a small API gap forces an edit; say so)
- `Godot/scripts/rules/SkipDay.gd` (152 lines, read-only; `SkipDay.run(start_stamina, plan, coach_skill, card_minutes, discipline)`)
- NEW `Godot/scripts/ui/SkipDayDrawer.gd` (builds the drawer body from `SkipDay.run(...).preview.lines` + two buttons; signals `confirmed`, `cancelled`)
- NEW `Godot/tests/skip_day_drawer_test.gd`

## Spec
1. New switch `skip_drawer` (career key, default OFF, same convention as `morning_ticker`: career dict key, then cmdline user arg).
2. With the switch ON (and the morning ticker active), `_on_ticker_skip` does NOT skip at once: it mounts a DrawerHost (once, child of the panel,
   full-rect, mouse-ignore as DrawerHost already is), builds the SkipDayDrawer body from the real plan (today's DayLap orders, stamina,
   assistant-coach skill on the 1-20 scale, planned card minutes - find them from the existing morning/day plan code; if one is not
   available say which and use the nearest real source, never a constant), shows it. CONFIRM calls `_on_morning_answered(false)` then closes;
   CANCEL / Esc closes and changes nothing. Time pauses via DrawerHost `pause_requested` wired to the club clock exactly as the speed buttons do.
3. Switch OFF: behaviour byte-identical to today.
4. `ok:false` from SkipDay -> the drawer shows the reason line and only CANCEL.

## Test (`skip_day_drawer_test.gd`, extends SceneTree, prints `SKIPDRAWER total=N fails=M`, quit(1) on fail, never quit(0) on pass)
(a) switch OFF: pressing the skip handler calls the skip path once, no drawer node; (b) switch ON: no skip call, drawer open, body shows the
SkipDay preview lines for the same inputs; (c) confirm -> skip path exactly once + drawer closed; (d) cancel/Esc -> zero skip calls, drawer closed;
(e) ok:false plan -> reason shown, no confirm button. Prove with 2 mutants (confirm without closing; cancel that still skips) both red.

## Gates
`python Godot/tools/check_scripts.py <touched .gd>` then the focused test, then `python Godot/tools/run_tests.py --only morning_ticker --jobs 2`,
`--only drawer_host`, `--only skip_day`. Test command: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/skip_day_drawer_test.gd`
(exe in %LOCALAPPDATA%\Programs\Godot\, NEVER _console.exe). No window may open on the operator's screens; view images with the file tool only.

## The one trap
`_on_morning_answered(false)` may also be reached from elsewhere; gate ONLY the ticker's skip entry. GDScript traps: typed vars for Variant
returns; no reused local names in one function. Commit with explicit paths, push the branch, do NOT merge to master. Final message: files,
test output lines, mutants.

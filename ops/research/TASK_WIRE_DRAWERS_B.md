# TASK WIRE-DRAWERS B - the fighter profile and the last-spar screen open in the side drawer (S199)
Model: Codex gpt-6-luna medium. Worktree E:/FightCamp/wt/WIREDRAWERSB, NEW branch codex/wire-drawers-b from origin/master
(`git worktree add E:/FightCamp/wt/WIREDRAWERSB -b codex/wire-drawers-b origin/master`).

## Prior research
TASK_WIRE_DRAWERS.md (part A merged: `GymHallPanel.gd` `_open_skip_day_drawer`, `_use_skip_drawer`, the `SkipDayDrawerHost` DrawerHost mount, pause wiring -
REUSE that host and pause handler, do not add a second DrawerHost); FighterReadoutPanel.gd `build(athlete, opts{scout_level,width,month_ago})` and
FighterReadout.gd (merged, operator Q-S196-2: 0-100 scale); LastSparPanel.gd `build(spar_summary, ctx{state,lead_card,power_card})` + signal
`committed(option_id, state)` and LastSpar.gd `commit(state, option_id, ctx)` (merged); Ludo r32 5.2/Part 6 (drawer over right 38%).

## What would a human do?
Click the fighter in the club -> PROFILE: a drawer slides in with his nine 0-100 cards and body wear, time pauses, Esc closes. After Thursday's test spar the
three-choice screen opens the same way and the choice sticks.

## Prefab check
None - DrawerHost and both panels exist.

## Owned files
- `Godot/scripts/GymHallPanel.gd` (large - read in windows; RING_ROUTES at ~line 25 routes "fighter"/"profile" to SceneRouter "fighter_card")
- NEW `Godot/scripts/ui/ProfileDrawerHost.gd` ONLY if the shared host logic is cleaner as a helper (decide; keep GymHallPanel growth small)
- NEW `Godot/tests/profile_drawer_test.gd`
Read-only: DrawerHost.gd, FighterReadoutPanel.gd, LastSparPanel.gd, FighterReadout.gd, LastSpar.gd.

## Spec
1. Switch `profile_drawer` (career key then cmdline user arg, default OFF; same pattern as `_use_skip_drawer`). ON: the club ring's fighter "profile" row
   opens the SAME drawer host with `FighterReadoutPanel.build(athlete, {"scout_level": 3})` for our own fighter, title = his name. OFF: today's route.
   `month_ago`: pass it only if the save already keeps a snapshot (grep the athlete dict / GameState for one); otherwise omit and SAY SO.
2. Switch `last_spar_drawer` (default OFF). Find where a spar result exists in the live code (grep spar in GameState.gd with sed windows, never read it whole;
   look for the Thursday test spar / SPAR1A SparRead). If a real spar summary exists, open `LastSparPanel` in the drawer after it, store the committed `state`
   where the fight reads its modifiers (find the existing carrier for SPAR1 numbers; do not invent a parallel one). If NO spar hook exists yet, DO NOT fake
   one: build only the open function `open_last_spar(spar_summary)` + test it, and report exactly what is missing.
3. Both ON/OFF paths: OFF byte-identical (neighbour tests green).

## Test `profile_drawer_test.gd` (extends SceneTree; prints `PROFDRAWER total=N fails=M`; quit(1) on fail; never quit(0) on pass)
(a) OFF: profile route calls the router, no drawer; (b) ON: drawer open, body is a FighterReadoutPanel showing the fighter's nine cards (count them from
FighterReadout.headlines), pause requested true then false on close; (c) Esc closes; (d) last-spar: open_last_spar mounts LastSparPanel, a commit emits
`committed` once and a second commit is refused; (e) one drawer host only (a second open reuses it). 2 real mutants red.

## Gates
`python Godot/tools/check_scripts.py <touched .gd>`; focused test; `python Godot/tools/run_tests.py --only gym_hall --jobs 2`, `--only skip_day_drawer`,
`--only drawer_host`. Godot only `Godot_v4.7.2-stable_win64.exe --headless` (NEVER _console.exe). No window on any monitor.
## The one trap
The fighter dict in GymHallPanel (`gs.get_roster()[0]`, see `_open_skip_day_drawer`) may lack keys FighterReadout expects - run the readout on the REAL roster
fighter in the test, not a hand-built one. Commit explicit paths, push branch, never master. Typed GDScript; no reused local names in a function.

# TASK WIRE-LASTSPAR - the fight-week test spar happens, and the LAST SPAR screen opens after it (behind a switch)

Model: Cursor. Worktree E:/FightCamp/wt/WIRELASTSPAR, branch cursor/wire-lastspar from master. Commit + push the branch; never
master, never HANDOFF.md, never AgentComms/. Never open a window, viewer or browser (you cannot see images; never describe one).
Headless Godot: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<t>.gd`
(NEVER `_console.exe`), `timeout 300` each. Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`.

## Why (operator, approved S198 Q-S196-3: "approve all" - Ludo r32 5.2)
Fight week ends with a 2-round test spar against the camp's sparring partner; right after it, ONE screen offers three irreversible
choices (Defensive lock / Double-down / Taper) with their predicted fight-night effects. Every piece exists and NOTHING calls it:
- `Godot/scripts/rules/LastSpar.gd` (pure: `options()`, `predict(id)`, `commit(state, id, ctx)` -> a fight-night modifier dict).
- `Godot/scripts/ui/LastSparPanel.gd` (the screen; signal `committed(option_id, state)`).
- `Godot/scripts/GymHallPanel.gd` (819 lines) `open_last_spar(spar_summary)` at ~line 290 opens it in the right drawer.
- `Godot/scripts/SparRead.gd` (pure: folds a spar fight log into CompuBox-style rows - the summary line comes from it).
- `Godot/scripts/GameState.gd` (19,187 lines - NEVER read whole; windows only): `run_spar(booking, day, seed_override)` ~line 6300,
  `book_spar` ~5885, `spar_fight_setup` ~6258 (has `rounds`), `get_fight_week_card(fighter_id)` (grep it).

## Owned files
- `Godot/scripts/GymHallPanel.gd` - the caller (day advance on the fight-week Thursday) + storing the committed state.
- `Godot/scripts/GameState.gd` - windows only, ONLY: a switch getter `is_last_spar_on()` (career key `last_spar_screen`, default
  false), a `run_test_spar(fighter_id) -> Dictionary` (2 rounds vs the fighter's sparring partner via the existing spar path - reuse
  `book_spar`/`run_spar`/`spar_fight_setup`, never a second spar engine), `set_last_spar_choice(fighter_id, state)` /
  `get_last_spar_choice(fighter_id)` stored on the athlete (key `last_spar`), cleared when the fight is settled.
- `Godot/tests/wire_last_spar_test.gd` (NEW).

## Spec
1. Switch `last_spar_screen` OFF by default (NOT in DEMO_SWITCHES): OFF = nothing changes, byte-identical saves.
2. ON: when the club day advances INTO the Thursday of a booked fighter's fight week (the fight-week card names the days - grep
   `get_fight_week_card` / FightWeekRail for how the week is laid out), run ONE 2-round test spar for that fighter (once per fight
   week - a flag on the athlete), fold its log with SparRead into a summary dict `{"line": "Landed X/Y ..., took Z flush counters",
   "panel": SparRead.panel(...)}`, and call `open_last_spar(summary)`.
3. Connect the panel's `committed` signal: store the state with `set_last_spar_choice`. The fight-night setup that READS it is NOT
   yours (a later task) - just store it and expose the getter.
4. If no partner can be found, skip the spar and open nothing (log one line `LASTSPAR skipped: <reason>`).

## Done (tier: scripts edited - parse, focused test, related runs)
- `wire_last_spar_test.gd` (headless, two DIFFERENT fighters - never identical; name them): ON + a booked fight -> advancing to the
  fight-week Thursday runs exactly one 2-round spar (assert rounds == 2 in the result), opens the drawer whose body is a
  LastSparPanel, the summary line is non-empty and its numbers come from the spar log; pressing option 2 stores a state whose
  `committed` == options()[1].id; advancing again the same week does NOT run a second spar; OFF -> no spar, no drawer, the athlete
  dict unchanged. RED first on master (paste it).
- `python Godot/tools/run_tests.py --only last_spar --jobs 2`, `--only spar --jobs 2`, `--only drawer --jobs 2`,
  `--only gym_hall --jobs 2` -> 0 fails (paste the SUITE lines).
Commit + push cursor/wire-lastspar. Final message: red output, green outputs, the exact Thursday rule you used.

## Prior research
TASK_LASTSPAR1A.md, TASK_LASTSPARPANEL1.md, LUDO_ROUND32_S197.txt "5.2", LUDO_ROUND33_S198.txt "Irreversible Last-Spar Choices",
TASK_SPAR1A_SPAR_READ.md. `python Tools/prior_research.py last spar thursday` lists more.

## What would a human do?
A trainer runs two hard rounds on the Thursday of fight week, watches the tape, then decides the last two days: protect what works,
push the weakness, or rest. He decides once.

## The one trap
GymHallPanel time/day advance runs in more than one path (end day, skip day, auto-pause) - hook the ONE place where the career day
changes (grep where `career_day` is incremented / the day-changed signal) so the spar cannot run twice or be skipped by Skip Day.

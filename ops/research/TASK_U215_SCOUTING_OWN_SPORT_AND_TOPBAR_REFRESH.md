# TASK U215 - Scouting shows the gym's own sport first; the top bar updates the moment you sign (PLAYTEST P2-14, P2-15)

Model: Cline CLI, OpenRouter stealth/space-bunny-alpha (Tools/cline_task.cmd). Worktree E:\FightCamp\wt\CLINE, branch
cline/seat - first `git merge --ff-only master` (master has your U214 merged).
Tier: scripts edited -> parse gate, the new test, then the run_tests line below.

## The two defects (research/PLAYTEST_S146_PASS2.md rows P2-14, P2-15)
1. P2-14: a BOXING gym opens Scouting and the first candidates listed are judo / kickboxing / wrestling. S146 added
   "the gym's own discipline leads whatever column sorts the rest" (ScoutingHubPanel.gd ~line 768, `_board.own_discipline`)
   but the playtest still saw other sports first - so FIND WHY first (is `own_discipline` empty for a new career? is
   the sort only on one tab? are coaches/fighters lists built elsewhere?). Expected: on every Scouting list, rows of the
   gym's own discipline come first by default; the others still exist below (do NOT hide or delete them).
2. P2-15: after signing the first fighter, the top bar still says "No fighters yet" until the player changes screen.
   ShellChrome.gd:406 builds that line once per shell build. Expected: the top bar (roster count, and the cash, P25)
   shows the new value right after a signing, without a screen change. Find the cheapest correct refresh (a signal from
   GameState after a signing, or the router rebuilding the shell after the sign action) - read how CareerRoot rebuilds
   the shell (`_rebuild_shell`) before choosing.

## Owned files
- `Godot/scripts/ScoutingHubPanel.gd`
- `Godot/scripts/ShellChrome.gd`
- `Godot/scripts/CareerRoot.gd`
- `Godot/tests/scouting_own_sport_topbar_test.gd`

EDIT: Godot/scripts/ScoutingHubPanel.gd (1125 lines - read with sed -n windows around the anchors, never whole),
Godot/scripts/ShellChrome.gd (520 lines), and if the refresh needs it Godot/scripts/CareerRoot.gd (only the shell
refresh). NEW: Godot/tests/scouting_own_sport_topbar_test.gd. Do NOT edit GameState.gd (17k lines); call its public
methods only (get_roster, get_recruitable_athletes, get_recruitable_staff, sign_recruitment_candidate,
generate_starter_boxing_floor, begin_new_career, finalize_new_career - see Godot/tests/first_months_cash_test.gd for a
working career-setup pattern, copy it).

## The test (write it FIRST, watch it fail on the old code, then fix)
New career in "United Kingdom"/"London" with a boxing starter floor; mount the Scouting panel the way the game does;
assert the first listed candidate's discipline == the gym's discipline (and print the first 5 rows' disciplines - the
population named in the output). Then sign one fighter and assert the top bar label reads "1 fighter" without changing
route. Both asserts must FAIL on the current code (run it before your fix and paste the failing lines in your report).

## Gates
- Parse: `python Godot/tools/check_scripts.py <every .gd you touched>` (a parse error hangs a headless test).
- Test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tests/scouting_own_sport_topbar_test.gd`
  Pass = exit 0, no "SCRIPT ERROR", no "FAIL" line.
- Then: `python Godot/tools/run_tests.py --only scouting,shell_chrome,career_root,smoke_test,first_job --jobs 1` -> fails=0.
- Commit on cline/seat "U215: scouting own sport first + top bar refresh". Do not push to master.

## Rules
Work only inside E:\FightCamp\wt\CLINE. Never open images/videos with an app. Never stage *.import files.
GDScript traps: `var x := <call>` fails when the call returns Variant - type it; a variable name reused in one function
is a parse error; `%` in a format string is `%%`.

## The one trap
The S146 sort exists and the bug survived it - a fix that only edits that sort again, without the failing test proving
the cause, will likely miss. Find the cause with the test first.

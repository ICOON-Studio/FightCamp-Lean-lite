# TASK PLAYLOOP4 - the floor asks to hire a coach the player has just signed (playable_loop_test T4 red, nightly 2026-10-17)

Seat: Grok Dev (cloud coding seat, Godot 4.7.2). Branch `grok/playloop4`, PR to master; Claude merges by diff. Model: Grok Dev default.
Discipline: BOXING (demo).

## The defect (red on master, run 2026-10-17 S239 on c55e6ded)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/playable_loop_test.gd` ->
`PLAYABLE STEP T4 FAIL: no visible enabled button matching 'STEP IN'; screen showed: ... HIRE - PICK ONE | NOT NOW ...`
T3 of the same walk signs a coach through Scouting STAFF (SIGN CONTRACT, passes). T4 then presses Nav_training -> Hit -> BALANCED ->
OpenFloor, and instead of the home morning (STEP IN) the floor shows InterviewPanel's COACH HIRE modal.
Route: `scripts/GymHallPanel.gd` `show_today()` (~line 712): `if gs.get_staff().is_empty() or gs.get_roster().is_empty():` ->
`hall.call("show_coach_hire", ...)` (line ~727). So at OpenFloor `get_staff()` is empty (or show_today reads a stale state) although
the coach was signed one step earlier. Also check the other caller at GymHallPanel.gd ~line 1092.

## Do
1. Find WHY: does the Scouting STAFF signing (the staff offer's SIGN CONTRACT) add the coach to `career["staff"]` / `get_staff()`?
   Is the S238 LOOPOFF1 switch work (story/tutorial OFF) or the S238 coach-visible change involved? (`git log -p --since=2026-10-16
   -- Godot/scripts/GymHallPanel.gd Godot/scripts/GameState.gd`.) Print get_staff() at T3's end and at show_today in the walk.
2. Fix the GAME so a signed coach counts on the floor (never edit the walk to skip the modal, never weaken a test).
3. Green: playable_loop_test (`PLAYABLE LOOP total=9 fails=0`), plus `python Godot/tools/run_tests.py --only gym_hall --jobs 2` and
   `--only staff --jobs 2` unchanged from master (paste both SUITE lines). Parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`.

## Rules
GDSCRIPT_TRAPS.md. GameState.gd and GymHall3D.gd are huge - read them in windows (grep + sed -n), never whole. New features ship ON.
THE ONE TRAP: a modal that is RIGHT to show (the gym truly has no coach) must still show - prove it with the test's own fresh-gym path.

## Prior research
S238_DIGEST.md (LOOPOFF1, coach visible), LOOP1_VERDICT_S238.md (slice 2: hire 1 of 3), tests/playable_loop_test.gd T3/T4.

## What would a human do?
Sign the coach in the office, walk onto the floor, and expect him there - not a hiring form for the job you just filled.

## Prefab check
None - a state bug.

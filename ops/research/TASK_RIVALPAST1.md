# TASK RIVALPAST1 - QWEN - a unit test for RivalPast, the rivals' bout-by-bout records (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean. Launched unattended by
ops/Tools/seat_dispatch.py (S368): your worktree E:\FightCamp\wt\LEAN_RIVALPAST1, branch qwen/rivalpast1. Commit there; do
not push (the dispatcher pushes and opens the PR).

## Why
`scripts/rules/RivalPast.gd` (S341, 59 lines, pure static) writes every rival's record: an invented past that matches her W-L,
then each real bout pushed on the front. Only one check covers it today (tests/opp_file_test.gd part 5: W + L bouts per rival).
Nothing pins its own promises - newest first, every past bout before day 0, the same seed giving the same past, never a bout
against herself, `add` on an empty record doing nothing. This is also the first task the unattended seat dispatcher runs end
to end (S368 operator: "can you program other agents ... to pick up tasks and deliver automatically").

## The job (one new file; touch nothing else)
Write `tests/rival_past_test.gd`: `extends SceneTree`, the same shape as `tests/gym_bills_test.gd` (`var failures := 0`,
`_initialize()` calls the tests, a `_check(cond, label)` that prints `PASS <label>` / `FAIL <label>`, then prints
`RIVAL_PAST failures=<n>` and `quit(1 if failures > 0 else 0)`). Preload the module:
`const RP := preload("res://scripts/rules/RivalPast.gd")`. Type every variable. At least these 8 tests:
1. `RP.seed({"name": "Amy Cole", "w": 3, "l": 2}, others, 7, 200)` returns 5 bouts: 3 with `win == true`, 2 with `false`.
2. Days strictly fall down the list (newest first) and every `d` is below day0 (200); each gap is 21..56 days (RP.GAP).
3. The same rival + the same seed give the identical array twice; a different career seed gives a different one.
4. No bout is `vs` her own name, even when `others` contains her ([["Amy Cole", "X ABC"], ["Bea Lyn", "Y ABC"]]).
5. Every bout has the keys d, vs, vs_club, win, how, ours; `ours == false`; `how` is either one of RP.DECISIONS or
   starts with "stopped in round " followed by 1, 2 or 3.
6. A 0-0 rival gets an empty past (`[]`).
7. `RP.add(r, 210, "Cara Dee", "Z ABC", true, "on points, 3-0", true)` puts that bout FIRST in `r["bouts"]` (create
   `r["bouts"]` when missing), and a second `add` goes in front of it; `RP.add({}, ...)` leaves `{}` empty.
8. `RP.shown(r, 1)` returns only the newest bout; `RP.shown({}, 3)` returns `[]`.

## Acceptance (the dispatcher runs these on your branch, headless)
- `tests/rival_past_test.gd` prints `RIVAL_PAST failures=0` and exits 0, with no SCRIPT ERROR.
- `tests/opp_file_test.gd` still passes.
- Do NOT add the test to tools/run_tests.sh (a gate file - Claude adds it at the merge).

## Contract
OWNS: tests/rival_past_test.gd
RED_TEST: tests/rival_past_test.gd -> RIVAL_PAST failures=0
REGRESSION: opp_file_test
VISUAL: no

## Prior research
RivalPast's header (S341, the operator: "the records should always keep all information available for the other opponents
(history)"); Career.quick_start seeds every rival through it (scripts/state/Career.gd:67); BoutNight and Region add the real
bouts (scripts/state/BoutNight.gd:353, scripts/state/Region.gd:146).

## What would a human do?
Read the 59 lines once, write one check per promise in the header, run the test headless, commit the one file.

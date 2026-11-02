# TASK NIGHTLY6 (S223) - bisect the 11 new nightly reds of 2026-10-14 and fix each cause

Model: Goose (GitHub Actions, label `goose`), long task. Branch goose/issue-<n>; PR opened by the job. NEVER merge, never push master.
Read `.github/CLOUD_AGENT.md` first.

## The problem
The nightly suite at 4fb47d80 (2026-10-14 05:00) has 14 reds; 11 are NEW since the 2026-10-13 nightly at b7685559, where all 11
were green. Real, not load: 3 were re-run alone and still fail. The 11 tests (Godot/tests/):
1. ui_kit_book_test.gd - suspect: `UIKit.creation_intro` is not in the book (S219 57e726b2)
2. corner_instruction_contract_test.gd - "instructions_applied=0 ruleset=boxing must expose an explicit real-time refusal"
3. judge_panel_test.gd - re-pinned scores moved
4. doctor_live_test.gd
5. referee_live_test.gd - prints "FAIL OFF log hash is byte-identical to master" but exits 0
6. fight_clip_slice_test.gd
7. fight_identity_test.gd
8. fight_realtime_test.gd - HANGS (timeout)
9. fight_strike_whole_test.gd
10. pad_chain_fight_test.gd
11. switch_gate_hands_smooth_in_whole_test.gd
Leave alone (owned elsewhere): fight_pair_live, fight_stage_realism, fighter_reachability_contract.

Suspect commits (check these first, they are the cheap answer): S221 4a05ad6c "every built feature ON" (GAME_ON grew - plain
`--script` tests are the OFF control arm and must stay OFF: a test that now reads a switch as ON without `as_game` is a leak);
S219 NOJAB1 50aad3bc (seeded bouts changed BY DESIGN -> pinned numbers may need a re-pin); S219 NEWCAREER2.

## Do
1. For each test: run it on b7685559 and on master. One test =
   `godot --headless --path Godot --script tests/<name>.gd` (the runner fails a test on a non-zero rc, a SCRIPT ERROR line, its
   own FAIL line, or no output - read the output, not only the rc). Timeout 300 s per run (fight_realtime hangs).
   If a test is ALREADY red on b7685559 in CI (no LFS assets here), write "cannot bisect in CI: <reason>" for it and move on.
2. `git bisect start master b7685559` + `git bisect run <script>` where the script runs that ONE test and exits 0 green / 1 red /
   125 skip (build broken). Record the first bad commit for each test.
3. Read that commit's diff and decide per test:
   - REAL REGRESSION (behaviour broke) -> fix the cause in the game code, smallest change; the test goes green unchanged.
   - BY-DESIGN CHANGE (e.g. NOJAB1 changed seeded bouts) -> re-pin the expected numbers and put a comment on the pinned line
     naming the cause commit and why (`# re-pinned S223: 50aad3bc NOJAB1 changed the seeded jab mix by design`).
   - SWITCH LEAK (a plain --script run now sees a GAME_ON feature as ON) -> fix the read so it goes through `GameSwitches.on()`
     (OFF without `as_game`), never by removing the feature from GAME_ON.
   - referee_live: make the test EXIT NON-ZERO when it prints FAIL (it hid a red), then fix the cause.
4. Never delete a test, never delete or weaken an assertion, never raise a timeout to hide a hang (fight_realtime: find the loop).
5. Run every touched test again on your branch + `python Godot/tools/check_scripts.py <touched .gd>` (parse gate).

## Done =
A PR from goose/issue-<n> with a table in its description: test | first bad commit | cause (one line) | REGRESSION / RE-PIN /
LEAK / CANNOT-BISECT | fix (files) | after: pass/fail. All 11 rows filled. Partial is fine if time runs out - the table says which
rows are done (the next run resumes on the same branch).

## Prior research
- S222_DIGEST.md "Nightly 2026-10-14" section (the list above and the suspects).
- research/GDSCRIPT_TRAPS.md before editing GDScript.
- CLAUDE.md s10: new features ship ON via GameSwitches.GAME_ON; plain --script tests are the OFF arm.

## What would a human do?
Bisect each red to one commit, read that diff, and decide "bug or intended change" before touching a number - never re-pin
blindly, never fix a test to match a regression.

## Prefab check
`git bisect run` is the tool; nothing to build.

## The one trap
fight_realtime HANGS: give every bisect run a hard timeout (`timeout 300`) and treat a timeout as RED (exit 1), or bisect stalls.

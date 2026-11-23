# TASK MOODREAD1 - the win read ignores mood (stale cache), and the tests are calibrated on it (S539)

Found by HOSTPROBE2 (docs/HOSTPROBE2_RESULT.md s7 item 7): BoutRead's caches (`_game_edge` key :224, `_re_key` :307-308) do not
include the boxer's mood, and `clear_cache` (:64) has no caller, so in a session the win read never moves with morale after the
first read (FighterProfile.TRUST: Fired up 1.05 / Steady 1.0 / Flat 0.85 / Low 0.7 on the corner's calls).
S539 Claude tried the one-line fix (trust in both keys): its red test went green, golden_path green, but tests/bout_read_test.gd
went from 0 to 66 FAIL (e.g. "Lucy vs Priya: chance() 0.381, real bouts 0.208"; "band 0.06-0.12 holds real 0.358"). So the
read's bands and real-bout fits were calibrated WITH the stale value; the fix changes fight reads game-wide. Reverted.

## Do
1. Find why: does LiveRound / the real bout read `_game_edge` too (so real bouts also froze the first mood)? Which morale did
   the calibration effectively use?
2. Fix the key (the red test: ops/research/redtests/bout_read_mood_test.gd.txt -> tests/bout_read_mood_test.gd), then
   re-fit the bands bout_read_test checks (PUNCHSTART1's method, BoutRead.gd header :55-58) so chance() tracks real bouts again,
   with a control arm. Report the before/after error.
3. Tests: bout_read_mood_test, bout_read_test, golden_path_test, plan_read_test, result_tabs_test green.

## Contract
OWNS: scripts/rules/BoutRead.gd, tests/bout_read_mood_test.gd, tests/bout_read_test.gd (bands only, with the re-fit numbers)
RED_TEST: tests/bout_read_mood_test.gd
REGRESSION: tests/bout_read_test.gd, tests/golden_path_test.gd
VISUAL: no

Model: claude-opus-5-5 (Code Mode tab). Godot only via godot_slot. Commit only your paths, push, idle_guard ok MOODREAD1-done.

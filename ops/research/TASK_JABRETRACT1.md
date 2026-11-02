# TASK JABRETRACT1 - punch_retime no longer slows the jab's retraction (punch_retime_test red on master)

Model: Cursor (cloud). Discipline: BOXING (demo).

## Why (Claude S274, measured on the PC, master b82327f6)
`tests/punch_retime_test.gd` (S259 PUNCHRETIME1, 9db6c74b - the "jab fires like a bullet" fix) is RED on master:
```
PUNCH_RETIME_ARM OFF jabs=4 ext_s=0.196 ret_s=0.129 peak_mps=4.17
PUNCH_RETIME_ARM ON  jabs=4 ext_s=0.196 ret_s=0.133 peak_mps=4.17
FAIL ON jab retraction >= 0.15 s (0.133)
```
The ON arm should stretch the retraction (PunchRetime.plan("boxing_jab", ...) -> retract_wall 0.18 s, the test's own plan check
passes) but the played jab retracts in 0.133 s - almost the same as OFF. So the retime plan is computed and then NOT APPLIED
(or overwritten) on the path this test plays. The last cloud nightly that ran it (61ca511a, 2026-10-19 08:08) predates every
commit below; one of them broke it. Candidates (newest first): 799ff509 (S273 mocap_pure: "a captured take plays as captured"),
5eabbe63 (guard stance + steady_camera), cb2f402c / 8b67214c (S272 bout clip routing), ace645e2 (S271 Rokoko jab/cross/guard,
switch rokoko_clips), 3e6c4521 (S260 ATTRIB: per-boxer jab clock from hand_speed).

## What to do
1. Bisect: run `tests/punch_retime_test.gd` at 61ca511a and at each candidate; name the first red commit with its two output lines.
2. Find the line: why does that commit stop the retraction stretch on this test's jab (Mixamo `boxing_jab` via boxing_catch,
   NOT a Rokoko take - if mocap_pure skips the retime for a NON-captured clip, that is the bug).
3. Fix in the GAME, the smallest change, so the ON arm's retraction is >= 0.15 s again with peak <= 7.0 m/s. If the cause is a
   deliberate rule (a captured take must play as captured), keep that rule for captured takes only and say so with numbers.
4. Run both arms of the tests listed below; paste the lines.

## Owned files
The file the bisect names (expected one of: Godot/scripts/animation/PunchRetime.gd, Godot/scripts/FightStagePlayer.gd
(5,9xx lines - `sed -n` windows around `punch_retime` / `mocap_pure` only), Godot/scripts/animation/IntentBus.gd).
Never Godot/tests/punch_retime_test.gd (the instrument stays as it is).

## Parse gate and tests
`python Godot/tools/check_scripts.py <touched .gd>`; then plain AND `-- as_game`: punch_retime_test, fight_clip_slice_test,
punch_timing_test, rokoko_clips_test. PR body: `RESULT: tests/punch_retime_test.gd -> PUNCH_RETIME failures=0` and the other
three pass lines, plus the bisect table.

## Prior research
S259 PUNCHRETIME1 (9db6c74b), S255 PUNCHTIMING1 (#262), S273 ZIVARATE1 mocap_pure (799ff509), Undisputed study (control back
0.12-0.17 s), Ludo r119 (arm retraction 0.14 s on the blend layer).

## What would a human do?
Check out the last green commit, run the test, step forward one commit at a time - before reading any code.

## Prefab check
n/a (defect).

## The one trap
Never lower RET_MIN or edit the test. Never switch mocap_pure off globally - the Rokoko takes must keep playing as captured.

## Contract
OWNS: Godot/scripts/animation/PunchRetime.gd
RED_TEST: Godot/tests/punch_retime_test.gd -> PUNCH_RETIME failures=0
REGRESSION: punch_retime_test
VISUAL: no

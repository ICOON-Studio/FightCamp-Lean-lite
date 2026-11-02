# TASK HOOKTIME1 - the rear hook plays 1.73 s on screen (fight_clip_slice_test red; as_game hang)

Model: Cursor (cloud). Discipline: BOXING (demo).

## Why (Claude S273, measured)
`tests/fight_clip_slice_test.gd` (master, rewritten S273) now measures what the player SEES: the last head-strike beat of seed
SEED played whole through the game's own player (`_played_whole_s`: `play_role` + `advance(1/30)` until `whole_active()` ends).
Plain arm (cloud): `beat strike: anim='boxing_rear_hook' played whole 1.733 s (clip 1.724 s)` -> FAIL (cap 1.2 s).
The binding (`scripts/FightClipBinding.gd` :47, "boxing_rear_hook", Mixamo Boxing_Back_Hand_Hook, length_s 1.724, C223
certified S129) carries `strike_warp {from 0, to 1.0505, scale 0.579}` - so either the warp is not applied on this path, or
the take's 0.67 s tail plays whole. A real rear hook is ~0.5-0.8 s round trip (Ludo S259 retraction: hook 0.24 s;
Undisputed study: control back 0.12-0.17 s). As_game the same test HANGS (cloud timeout) - find where.

## What to do
1. Run the test on the cloud both arms (`python Tools/cloud_test.py fight_clip_slice_test` and `--as-game`); read its lines.
2. As_game hang: print progress, find the loop that never ends, fix the harness or the game, say which.
3. Find why the rear hook plays 1.73 s: is strike_warp applied in `play_role` for this role? Does punch_retime (PunchRetime.gd)
   shorten the retraction? Report the played time per arm with each switch's red arm (`off=punch_retime`, etc.).
4. Fix in the GAME so the rear hook plays under 1.2 s whole as_game (the player's arm) - the smallest change: the binding's
   window/warp or the retime - and keep C223's certificate tests green (`c223_*` for boxing_rear_hook if any exist - list them).
   Plain arm (switches OFF) may stay slow if the speed comes from a switch - then the test's plain arm compares OFF honestly:
   say so in the PR with the numbers, do not raise the cap.

## Owned files
Godot/tests/fight_clip_slice_test.gd, Godot/scripts/FightClipBinding.gd (only the boxing_rear_hook row), Godot/scripts/animation/PunchRetime.gd
(only if the measurement proves it). FightStagePlayer.gd (5,9xx lines, `sed -n` windows) only for a proven play_role warp bug.

## Parse gate and tests
`python Godot/tools/check_scripts.py <touched .gd>`; cloud both arms: fight_clip_slice_test, fight_strike_speed_test (if it exists),
punch_retime_test (if it exists), plus any c223 test naming boxing_rear_hook. PR body: `RESULT: tests/<x>_test.gd -> <pass line>`.

## Prior research
S255 PUNCHTIMING1 (Qwen #262, 335ed9d3), S259 PUNCHRETIME1, Undisputed study (punch control back 0.12-0.17 s), NIGHTLY12 #286.

## What would a human do?
Watch one rear hook at 30 fps frame by frame and count the frames from guard to guard before touching numbers.

## Prefab check
n/a.

## The one trap
Never raise the 1.2 s cap or measure something other than the played strike. A green test that cannot see a slow punch is not a fix.

## Contract
OWNS: Godot/tests/fight_clip_slice_test.gd
RED_TEST: Godot/tests/fight_clip_slice_test.gd -> fight_clip_slice
REGRESSION: fight_clip_slice_test
VISUAL: no

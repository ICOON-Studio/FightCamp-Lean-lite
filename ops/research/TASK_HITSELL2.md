# TASK HITSELL2 - QWEN (qwen3-coder) - round 2: a test that measures, then a landed punch that reads as landed

Status: OPEN (S397, Claude). Discipline: boxing (the live 3D fight). Round 1 (HITSELL1, PR #65) is NOT kept: read why below.

## Contract
OWNS: scripts/fight3d/HitSnap.gd, scripts/fight3d/HitStun.gd, scripts/fight3d/HitImpact.gd, tests/hit_sell_test.gd
RED_TEST: tests/hit_sell_test.gd -> HIT_SELL failures=0
REGRESSION: hit_snap_gain_test, hit_flash_test, fight_polish_test, counter_cut_test, body_keep_test
VISUAL: yes

## Why round 1 failed (Claude ran it)
Round 1 wrote tests/hit_sell_test.gd (branch qwen/hitsell1, commit ef37967b) and changed nothing else. Run on that branch,
EVERY number is zero: "a landed head shot moves the head 0.000 m vs blocked 0.000 m", "turns the head 0.0 deg", "folds the
trunk 0.0 deg". Two bars passed on nothing (0 >= 2.5 x 0). The HitSnap modifier never ran in the test: a SkeletonModifier3D
only changes bones when its Skeleton3D is inside the scene tree and the skeleton processes its modifiers (or you call the
modifier's own step functions on its frame clock, as tests/hit_snap_gain_test.gd does with _brace_step()).

## Do
1. Start from round 1's test: `git checkout origin/qwen/hitsell1 -- tests/hit_sell_test.gd`, then FIX THE TEST FIRST:
   - add a guard bar: "the measurement is live": a landed power shot on MAIN must move the head more than 0.02 m and turn it
     more than 5 deg. If it reads 0, the harness is wrong, not the game: fix the harness until main reads non-zero.
   - easiest harness: add the skeleton (a real boxer body as round 1 tried, or a minimal Skeleton3D with Hips/Spine/Chest/
     Neck/Head bones) to `root`, add HitSnap as its child, call setup(skel), then snap()/brace() and step frames with
     `await process_frame` (or call the modifier's step functions directly with a fixed delta) while you read
     skel.get_bone_global_pose() each frame.
   - keep round 1's bars a-e (landed head 2.5x blocked; blocked head <= 0.04 m; power >= 25 deg and jab >= 10 deg, peak inside
     0.06 s; landed body fold >= 8 deg, blocked <= 3 deg; no bone more than 30 deg between frames). Run on main and put the
     real, non-zero before-numbers in the PR body.
2. Then make it green inside OWNS: a blocked shot drives the guard glove back into the face and the forearm, not the head; a
   landed one gives a bigger, faster head turn plus the trunk give (HitSnap GIVE_*); a 2-3 frame hit-stop only on landed shots
   (HitStun). Keep the warm flash rule (HitImpact) for big shots only.
3. Keep every REGRESSION test green. Files under 500 lines. No edits to ops/, tools/run_tests.sh or gate files.
   Do not touch FootPlant.gd, RingFeet.gd, CornerCrew.gd, RingCamera.gd, HudBars.gd.

## Result lines (PR body)
RESULT: HIT_SELL live guard on main: head <m>, turn <deg>
RESULT: HIT_SELL before (main) a=<ratio> b=<m> c=<deg power/jab, peak s> d=<deg landed/blocked> e=<max deg/frame>
RESULT: HIT_SELL after  a=... b=... c=... d=... e=...
RESULT: regression <pass/fail per test>

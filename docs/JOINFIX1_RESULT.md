# JOINFIX1 - the lead uppercut's return to guard must not jump (Grok Dev, S446)

Files: `scripts/fight3d/JoinSmoother.gd`, `tests/join_return_test.gd` (new), this note. Nothing else touched.
Runs: Linux box, Godot 4.7.2 headless, `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`,
main at 997b32f2.

## Result

The return to guard no longer jumps. The test does not go fully green: the lead uppercut has a second pop BEFORE the cut,
inside PunchReach's hold after the hit. That code is not in this task (see "Not fixed here").

Final run on the branch:

```
FAIL STEP pro_left_uppercut: peak one-frame glove step 15.30 m/s from the hit to 0.40 s after (bar 9.0)
PASS RETURN pro_left_uppercut: peak one-frame glove step 4.71 m/s from the cut back to guard on (bar 9.0)
PASS STEP pro_right_uppercut: peak one-frame glove step 6.65 m/s from the hit to 0.40 s after (bar 9.0)
PASS RETURN pro_right_uppercut: peak one-frame glove step 3.80 m/s from the cut back to guard on (bar 9.0)
PASS STEP pro_left_hook: peak one-frame glove step 5.26 m/s from the hit to 0.40 s after (bar 9.0)
PASS RETURN pro_left_hook: peak one-frame glove step 5.26 m/s from the cut back to guard on (bar 9.0)
PASS STEP pro_right_cross: peak one-frame glove step 4.21 m/s from the hit to 0.40 s after (bar 9.0)
PASS RETURN pro_right_cross: peak one-frame glove step 4.21 m/s from the cut back to guard on (bar 9.0)
JOIN_RETURN failures=1
```

RED on main (the same test, main's JoinSmoother):

```
FAIL STEP pro_left_uppercut: peak one-frame glove step 23.75 m/s from the hit to 0.40 s after (bar 9.0)
FAIL RETURN pro_left_uppercut: peak one-frame glove step 21.71 m/s from the cut back to guard on (bar 9.0)
JOIN_RETURN failures=2
```

## The ruler (tests/join_return_test.gd)

- The punch_speed_test pair: mh_boxer_02 against mh_boxer_03, at the fight's gap. The stage runs live at 60 frames a
  second. Each punch is thrown the way BeatFire throws a landed one: `FightStage.play` from its PunchPace start,
  `PunchPace.arm`, `FightStage.land`, then `FightStage.hit` on the hit's timer. After that, HitImpact makes its own cut
  back to guard.
- The hitting glove front (punch_speed_test's `_glove`) is read in `Skeleton3D.skeleton_updated`, after every modifier,
  on every drawn frame. Reading runs from the hit's drawn frame to 0.40 s after it. When the cut to guard comes later
  (the cross), reading goes on to 0.30 s past the cut.
- The step onto the hit's drawn frame is not counted. That step is the punch arriving, which punch_speed_test and
  hit_frame_test cover. It runs 12-13 m/s on the cross and the rear uppercut, and it is not the return.
- STEP: no one-frame step over 9.0 m/s in the whole window (the brief's bar). RETURN: the same bar from the cut on (the
  join's part). JOIN: the cut happens inside the window on every throw.
- 5 throws a row. Every frame's speed is printed, with J on the cut frame. Probe flags: `-- trace`, `reps=<n>`,
  `only=<clip>`.

## Before / after (peak one-frame glove speed, m/s, 5 throws a row, the two runs above)

| Punch | Whole window, main | Whole window, branch | From the cut on, main | From the cut on, branch | Cut frame (worst), main | Cut frame (worst), branch |
|---|---|---|---|---|---|---|
| pro_left_uppercut | 23.75 | 15.30 | 21.71 | 4.71 | 21.71 | 1.76 |
| pro_right_uppercut | 3.54 | 6.65 | 3.54 | 3.80 | 3.54 | 1.40 |
| pro_left_hook | 5.79 | 5.26 | 5.79 | 5.26 | 3.18 | 3.41 |
| pro_right_cross | 3.24 | 4.21 | 3.24 | 4.21 | 1.75 | 1.25 |

The two runs, split for the lead uppercut, over more throws (`-- reps=<n> only=pro_left_uppercut`):

| | main (20 throws) | branch (16 throws) |
|---|---|---|
| Cut frame, median / worst | 9.7 / 18.2 | 1.0 / 3.0 |
| From the cut on, median / worst | 10.5 / 20.5 | 2.8 / 4.7 |
| Before the cut (PunchReach's hold), median / worst | 9.9 / 27.0 | 11.3 / 16.9 |

The pre-cut changes on the right uppercut (2.5 to 6.7) and the cross are frame noise from run to run. The same rows read
4.9 and 6.4 in other branch runs, and 5.2 in an early main run. All of them are under the bar.

## The fix (JoinSmoother)

1. **The source pose.** At a join, the arm (upper arm, forearm, hand) and chest of the glove that an armed landing reach
   held on the last drawn frame now start from the pose as drawn. That pose is read in `skeleton_updated`, after
   PunchReach, ReachLimit's cap and its chest lean, and the join takes its drawn velocity too. Before, those bones started
   from this modifier's own input: the clip's arm, which on the lead uppercut rises over her head after the hit. At the
   cut the reach lets go over its own fade from the point it held, so the arm now starts where the viewer saw it.
2. **The capture frame.** The join is captured on the join frame itself. `_should_capture` (wait up to two frames for the
   new clip's pose) is gone. `set_target` stays for its callers.
3. **Every other bone, and every join with no armed reach, keeps the old source.** Measured with this ruler on the lead
   uppercut:
   - The brief's literal reading (the drawn pose for every bone on every join) fixed the cut. But it raised the pop
     before the cut from a median of 10 to 26 m/s. The guard tuck (GuardTuck), the weave and the tired sag stay on
     across a join and are laid on again after it, so starting from their drawn result counted them twice. Into a punch,
     that held the glove at the face, and the punch arrived on another line.
   - Taking the drawn arm for a reach that is only fading (disarmed by `play()`) made a fidget join 0.15 s after the cut
     step the glove 8.5 m/s.
   - Only "armed and weighted" leaves both alone.
4. `still` (HitImpact's quick hand-back) still zeroes the carried velocity. RkJoinFeet still reads `_pending` and
   `_shown`, which are unchanged in meaning.

JoinSmoother.gd: 233 lines.

## Not fixed here (files not owned: reported, not touched)

1. **PunchReach's hold after a landed lead uppercut pops the glove before the cut.** It happens 6-10 frames after the
   hit, with the clip at 0.76-0.86 s, the reach still armed and its weight at 1.00. The glove leaves her face by
   0.2-0.5 m in one frame and comes back over the next. Trace example: 0.168, then 0.443, then 0.275 m off her face,
   while her face moved 0.05 m.
   - It is the same on main and on the branch (table above, 7-27 m/s), and JoinSmoother is idle on those frames (no
     join).
   - The likely place is `PunchReach._apply`'s let-go path after the hit (`RELEASE_M`, `_back_along`) or ReachLimit's
     elbow limit and lean on the uppercut.
   - This is what keeps STEP pro_left_uppercut red. Narrowing the window to make the test pass would weaken it, so it
     stays red.
2. **The arrival onto the hit frame** runs 12-13 m/s on the cross and the rear uppercut. This is POWER1_STEP4 "still red"
   1, already known.

## Regressions (baseline = main 997b32f2 on this box; branch = final run)

| Test | Baseline | Branch |
|---|---|---|
| punch_speed_test | PUNCH_SPEED failures=40 | PUNCH_SPEED failures=42 |
| punch_weight_test | PUNCH_WEIGHT_TEST failures=1 | PUNCH_WEIGHT_TEST failures=0 |
| fight_feel_test | FIGHT_FEEL failures=0 | FIGHT_FEEL failures=0 |
| beat_clips_test | BEATCLIPS failures=0 | BEATCLIPS failures=0 |
| head_aim_test | HEAD_AIM failures=0 | HEAD_AIM failures=0 |
| file_limits_test | FILE_LIMITS failures=0 | FILE_LIMITS failures=0 |

- **punch_speed_test changes from run to run on this box, on main as well.** Ten runs each, run in alternation:
  - main: 40, 41, 40, 43, 41, 42, 44, 40, 42, 43 (mean 41.6)
  - branch: 40, 46, 42, 39, 42, 43, 43, 41, 41, 39 (mean 41.6)
  - The brief's ceiling of 39 is below what main itself reads here. The branch does not move the count.
  - Its SPEED/FIRST/POP rows are played by seeking, outside the join smoother. Its SYNC rows read 0 failures in every run.
- **punch_weight_test** read 1 failure in the first main run and 0 in a second main run. It reads 0 on the branch.

## Collect (Claude S447): the played fight still jumps
Merged by diff (return rows green, punch_speed 39 = main). Filmed in the played fight (tools/hit_frame_film.gd uppercuts=2
seed=4242, docs/mockups/s447/joinfix1/played_uppercuts_hits.txt): the lead uppercut jumps 26-37 m/s for a frame about 0.12 s
after the hit (out and back), the rear uppercuts are clean. The game sends the lead uppercut through HitImpact.recover's QUICK
BACK branch, which the isolated test never takes. Handed to POWER1B (Goose, issue 241, HitImpact.gd is its file).

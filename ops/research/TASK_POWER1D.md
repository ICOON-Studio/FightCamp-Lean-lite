# TASK POWER1D - CLAUDE (in-house) - the lead uppercut's tail: a short drive through, then home elbow-down

Status: OPEN (S452). Discipline: boxing (demo). Owner: Claude - four seat rounds on punch motion missed (POWER1B, POWER1C Qwen PR 253
closed: bars still red, join_return 0->2, hit_carry 40->52, punch_speed 39->41).
Bars and the operator's words: ops/research/TASK_POWER1C.md (C353/C354 "wtf are these arm angles", C359 "terrible hands").

## Contract
OWNS: scripts/fight3d/HitImpact.gd (the recover() quick hand-back only), scripts/fight3d/BeatClips.gd (QUICK_BACK_S only), scripts/fight3d/PunchReach.gd (the release rule in _apply only; 498 lines - stay under 500), scripts/fight3d/ReachLimit.gd, tests/uppercut_tail_test.gd (OVER_HEAD/ELBOW measurement from f01 only)
RED_TEST: tests/uppercut_tail_test.gd -> UPPERCUT_TAIL failures=0   (main S453: failures=27)
REGRESSION: join_return_test, hit_carry_test, hit_frame_test, punch_speed_test, fight_feel_test, beat_clips_test, head_aim_test, file_limits_test
VISUAL: yes (tools/hit_frame_film.gd seed 4242 + 3 seeds on the game camera, stills opened, review board)

## Red test (on main since S452)
tests/uppercut_tail_test.gd - Qwen's harness (mh_boxer_02 vs mh_boxer_03, the frame as drawn), two of its checks repaired by Claude in S452:
- BACK measured the glove's return to its position AT THE HIT (so "back at 0.10 s" on a tail that never went home); now to the glove's
  place before the punch (the first recorded frame).
- FOLLOW's "distance to target never grows > 0.02 m" was dropped: an uppercut driving up past the chin moves away from the target by design.
Main before the repair: UPPERCUT_TAIL failures=25 (OVER_HEAD and ELBOW red on all 5 lead reps; rear uppercut clean on OVER_HEAD/ELBOW).

After the repair (S452, main): failures=25 - OVER_HEAD 5+5, ELBOW 5 (lead only), BACK 3 lead + 5 rear (back at -1 = never home in the
window), FOLLOW 1+1; peak speeds lead 3.3-31.1 m/s (rep 2), rear 2.4-3.7. CHECK FIRST: (a) the recorded window reaches 0.40 s after the
hit (else BACK can never pass); (b) OVER_HEAD from f01, not f00 - at the hit the glove sits at the opponent's chin, which can be above
her own head + 0.05 against a taller opponent (the rear uppercut's 5 fails may be only that); (c) the first recorded frame is her guard,
not the wind-up.
ANSWERED in S452: (a) yes - WINDOW_S 0.45 after the hit; (c) yes - recording starts at the throw after 20 frames of guard. So BACK's
fails are real, BUT the guard re-enters a living loop at IdleMatch.pick's point, so the hand's guard place moves: judge BACK against the
nearest frame of the guard window the stage entered (or 0.08 m), not a single pre-punch frame. (b) still open.

## What the frames show (main, pro_left_uppercut rep 0, 60 fps from the hit)
- f00 glove y 1.441, head 1.428, elbow 1.123, shoulder 1.229 - the hit is fine (glove at chin height).
- f04-f07 (0.07-0.12 s): the elbow flips from 1.22 to 1.61 (0.25 m OVER the shoulder) while her head DROPS 1.43 -> 1.35 and the glove rises
  to 1.50. That is the clip's own tail; the recovery starts at contact + 0.22 s (BeatClips.QUICK_BACK_S), after the damage.
- The guard entry already eases from the captured pose (FightStage._start -> join smoother, GUARD_JOIN_S 0.45). So the fix is to never
  PLAY the tail, not to smooth the return.

## The approach to try first
1. Recovery for pro_left_uppercut at contact + 0.05 s (f03: elbow still under the shoulder) - QUICK_BACK_S 0.05.
2. The S445 note says 0.05 gave a one-frame pop (28.6 m/s drawn). FIND what snaps at that moment before changing anything: print per
   frame which layer moves the hand (AnimationPlayer pose, PunchReach carry release, ReachLimit lean, the join smoother) - the pop is a
   layer releasing at once, not the guard blend. Release that layer over the same 0.45 s the join uses.
3. If the clip's drive is needed for FOLLOW (0.03 m in 0.10-0.20 s), let the join smoother's first 0.1 s carry the glove's velocity
   (the smoother already has a half-life; seed it with the contact velocity) instead of playing the clip.
4. No fourth reach-solve variant (S449). Never edit scripts/rules or scripts/state. PunchReach.gd is at 498 lines.

## Done when
uppercut_tail_test OVER_HEAD/ELBOW/BACK/PATH green on all 10 reps; join_return, hit_carry (<= 40), hit_frame, punch_speed (<= 39),
fight_feel, beat_clips, head_aim, file_limits not worse; seed 4242 + 3 seeds filmed on the game camera (tools/hit_frame_film.gd), stills
opened, on the review board for his OK.

## S453 findings (Claude, uppercut_tail_test on main = failures 27; one experiment, reverted)
Frames (main, lead rep 1, 60 fps from the hit): the glove stays at 1.49-1.55 (the opponent's chin, ABOVE her own head + 0.05: OVER_HEAD is
red from f00 against a taller opponent - open question (b) answered: yes, the f00 fail is the target height, not the tail) while her head
drops 1.42 -> 1.36 and her SHOULDER RISES 1.22 -> 1.36 (f03-f09): the clip's own tail lifts the shoulder 12-14 cm with the glove held, so
the two-bone solve throws the elbow to 1.57-1.60 (0.25 m over the shoulder). f11 is a one-frame drop to the raw pose (11-16 m/s) and f12
back on the held point - the pop at the guard handover (not found yet which layer skips that one frame).
THREE holders, not one:
1. PunchReach's release rule (`_w_now = max(_w_now, (dist(clip glove, aim) - RELEASE_M.x) / ...)`, the review-round-2 line in _apply)
   keeps weight 1 while the clip's glove is far from the aim. For a cross that is past her face; for the lead uppercut the clip glove
   rises over her head, so the pin never lets go until the guard's disarm.
2. The carry hold itself (weight 1 until contact + CARRY_S of CLIP time; the hit-stop freezes clip time, so it lasts longer in real time).
3. After the handover (guard_home) the glove climbs to 1.57 again in f17-f26 (head 1.46): the guard place she returns to is itself
   above head + 0.05 - so BACK's "guard place" (rec[0], the pre-punch frame at 1.435) is never matched.
EXPERIMENT (reverted): release rule off for QUICK_BACK clips (ReachLimit.quick_back) + QUICK_BACK_S 0.22 -> 0.10: failures 27 -> 24
(FOLLOW passes, one BACK passes), ELBOW 5/5 and OVER_HEAD 10/10 still red, one rep peak 29.8 m/s. Not enough alone.
NEXT TRY: (a) OVER_HEAD/ELBOW measured from f01 and against max(head, hit glove y) for the f00-hold frames (the held glove is at the
target by design); (b) while the reach holds after contact, hold the SHOULDER/CHEST too (the clip tail's shoulder lift is what flips the
elbow) - ReachLimit already leans the chest; or cut the clip at the contact frame and let the join carry the glove (step 3 above);
(c) find what lifts the guard glove to 1.57 after guard_home (IdleMatch.pick at "her usual guard", GuardTuck, GloveClear?).

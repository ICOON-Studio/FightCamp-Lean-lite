# TASK POWER1C - ANTIGRAVITY - the lead uppercut's tail: a short upward follow-through, then back to guard, never over her own head

Status: OPEN (S450, Claude main). Discipline: boxing (demo). Model: Antigravity (Gemini, PC seat).
Decided in S449 (the POWER1B fix 10c41edc does not hold on today's tree: BLOCKLOOK2 changed the seed 4242 bout and its first lead
uppercut reads 20.1 m/s after the freeze, bar 9.6; three reach-solve variants were tried in S449 and none passed). DO NOT try a fourth
reach-solve variant: re-cut the TAIL of the punch instead.

## Contract
OWNS: scripts/fight3d/UppercutTail.gd (new, under 200 lines), scripts/fight3d/BeatClips.gd:146-170 (QUICK_BACK_S and recovery() only),
scripts/fight3d/HitImpact.gd (158 lines; add at most 25), tests/uppercut_tail_test.gd (new), docs/POWER1C_RESULT.md
RED_TEST: tests/uppercut_tail_test.gd -> UPPERCUT_TAIL failures=0
REGRESSION: join_return_test, hit_carry_test, hit_frame_test, punch_speed_test, fight_feel_test, beat_clips_test, head_aim_test, file_limits_test
VISUAL: yes - Claude films the seed 4242 bout and 3 more seeds on the PC (tools/hit_frame_film.gd, the game camera) after the merge; the operator closes it
NOT YOURS: every other file. scripts/fight3d/PunchReach.gd is at 498 lines: do not add to it. Never edit scripts/rules or scripts/state (the
3D fight shows the settled round, it never decides).

## What the operator saw (verbatim, review board S449, the lead uppercut on the game camera, frames f19 f24 f27 f31)
- C353 / C354 marks on lead_uppercut_game_camera_f19_f24_f27_f31.png (ops/Feedback/2026-11-13-16 and -17, marked.png beside each):
  1. "wtf are these arm angles ? looks broken" (f27: the red boxer's lead arm folded up over her own head, elbow pointing at the sky)
  2. "terrible" (f24: the glove rising past her own face, the forearm vertical above her head)
  3. "terrible" (f31: the arm coming back across over her own head and body)
- C359 on lead_uppercut_02_before_after.mp4 at 2.4 s: "terrible hands completely broken".
OPEN ops/Feedback/2026-11-13-17/marked.png with your file tool before you start (never with an app).

## The defect
The source clip pro_left_uppercut keeps rising after the contact: the glove goes ~0.35 m above her own head and comes home over her
body (BeatClips.gd ~147, UPPERCUT_RANGE_S439.md fix 5). QUICK_BACK_S 0.22 then drags it home; on today's tree the drawn glove still
moves 20.1 m/s in one frame after the freeze. A real lead uppercut (CLIP_CRITICS_S439.md, POWER1_AUDIT_S446.md - Undisputed carries an
uppercut through contact 0.18-0.28 s) drives up THROUGH the chin a short way, the elbow stays under the glove and below her own
shoulder line, and the hand drops back to the guard by the shortest path (down and back in front of her own face).

## The job
1. RED first, tests/uppercut_tail_test.gd: stage the game's FightStage pair exactly as tests/join_return_test.gd does (mh_boxer_02 vs
   mh_boxer_03 at the fight's gap, a landed punch thrown the way BeatFire throws one, the glove read in Skeleton3D.skeleton_updated = the
   frame as DRAWN). Rows: pro_left_uppercut (lead_uppercut) and pro_right_uppercut (rear_uppercut), 5 reps each. Per frame from the hit
   to 0.45 s after, print glove front position, glove speed, the puncher's own Head bone height and her own elbow height. Bars:
   - OVER_HEAD: the punching glove's lowest point never rises above her own Head bone + 0.05 m (y), in any frame after the hit.
   - ELBOW: the punching elbow never rises above her own shoulder (the upper arm bone's head) + 0.05 m.
   - FOLLOW: for 0.10 to 0.20 s after the freeze ends the glove keeps moving up/forward (at least 0.03 m in total, its distance to the
     target never grows more than 0.02 m) - a short follow-through, not a stop.
   - BACK: within 0.40 s of the hit the glove is within 0.05 m of its guard place, and on the way NO one-frame glove speed is above
     9.6 m/s (the RETURN bar of join_return_test + the S449 bar).
   - PATH: on the way back the glove stays in front of her own face/chest (its forward distance from her own spine never below 0.10 m)
     - it never travels over or behind her head.
   Show it RED on main and paste the red lines into the result.
2. Fix in a NEW scripts/fight3d/UppercutTail.gd (pure 3D; called from HitImpact's recovery and/or BeatClips.recovery): after the
   freeze, play the clip on for TAIL_S (named const per uppercut, start 0.12 lead / 0.16 rear) but clamp the glove/elbow below the
   bars above (the clip's own forward drive, not its upward sweep), then hand over to the guard on a smooth ease (no one-frame
   catch-up). QUICK_BACK_S may change or be retired; `-- nopunchrange` must still give the old behaviour (A/B).
3. The rear uppercut must not get worse (its rows read today's numbers or better). Jab, cross and hooks are untouched.
4. docs/POWER1C_RESULT.md: before/after table per uppercut (highest glove vs her head, highest elbow vs shoulder, follow distance, peak
   return speed, back time), the RED lines, the GREEN lines, and every REGRESSION test's failures= on main vs your branch (none may rise;
   punch_speed_test was 39 at S446 - paste both).

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first (Variant `:=`, typed Dictionary reads).
- Godot jobs only through `python ops/Tools/godot_slot.py run --who POWER1C -- <godot.exe> ...` with the plain
  Godot_v4.7.2-stable_win64.exe --headless (never _console.exe); rule_guard blocks a bare one. No windowed run, no image viewer, nothing
  opens on the operator's screens; open stills with your file tool only.
- NEVER stop a Godot process you did not start (other jobs, renders and the Ziva editor run on this PC).
- A green bar that cannot go red proves nothing: each bar must read RED on main before your fix.
- Do not delete or weaken any test. Keep every file under 500 lines (file_limits_test).

## Prior research
- ops/research/POWER1_AUDIT_S446.md (Undisputed carry-through numbers from our REA notes),
  docs/POWER1_STEP4_RESULT.md ("still red" 2), ops/research/UPPERCUT_RANGE_S439.md (fix 5), ops/research/CLIP_CRITICS_S439.md
  (pro_left_uppercut rated 2.3 of 10 by three critics).

## What would a human do?
An animator would not chase the glove with more solve: they would cut the clip's tail after the drive through the chin and blend the
arm home by the short path, elbow down, keeping the follow-through short and the head line clear.

## Prefab check
Our own captured clips are the source (no new asset). The guard pose and the join smoother already exist (FightStage.GUARD_JOIN_S).

Test command: `python ops/Tools/godot_slot.py run --who POWER1C -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tests/uppercut_tail_test.gd`
RESULT line for the PR body: `RESULT: tests/uppercut_tail_test.gd -> UPPERCUT_TAIL failures=0`, plus one RESULT line per REGRESSION test.

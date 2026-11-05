# DEFFLOW2 code audit (S385, 2026-11-05)

Branch claude/defflow1 tip ee0411b1 (r3 WIP, unfilmed). Two fix rounds failed on video, so the rule says audit the code
before a third round. Two read-only auditors plus Claude's own checks. Line numbers refer to ee0411b1. The r3 unit tests
pass (defflow2_r3, defflow2_r2, def_pose, defence_match, flow_streak); every failure below is in the drawn 3D picture.

## The one cause under most of it: the bars cannot see the drawn picture

Godot restores the raw animation pose after the SkeletonModifier3D stack, so `skel.get_bone_global_pose` read from a
script or a test returns the CLIP, not what is drawn (pose_tap.gd's header; S385 proved it on fight9_probe: identical
numbers with every modifier on or off). Three things read the raw pose:
- `DefFire.chest_gap()` (DefFire.gd:128-134): the forward room a duck may use is computed from raw chests at the
  punch's START;
- `CornerShots.bone()` (CornerShots.gd:147-148): the corner lenses are placed from raw bones;
- the bars read `GloveClear.shown_*`, which is taken mid-stack, before FootPlant and FloorClear; no bar uses PoseTap.

The bars also re-test the fix with the fix's own model (OVERLAP uses the same line model and nearly the same radii as
GloveClear; `shown_pelvis_min_m >= 0.40` equals the floor constant; JAB_DEEP re-runs `downgrade()`). They pass while
the film fails. **Fix the bars first:** every visual bar reads the drawn bones through a PoseTap added last.

## Not DEFFLOW's bugs (shared with main)

1. **Referee walks in (2:52).** NOREF1 lives only on claude/fight9base (FightCast.crew: "no referee in the ring;
   clinches part via PushOff"). Main still calls `Referee.build(stage)` (FightCast.gd:46). Fix on main: take
   fight9base's FightCast.crew change and PushOff.gd.
2. **Corner lens inside Lucy (3:17).** S380's `CornerShots.inside()` (CornerShots.gd:110-134) walks a lens that is past
   2.5 m up to 90% of the way toward the shot's look point and widens the fov, with no keep-out from bodies. "ice"
   (lines 40-44) ends about 0.24 m from her neck, at her left shoulder; "reverse" (68-74) ends about 0.1 m behind her
   head. 3:17 is about 9 s into the minute, which is the "ice" slot. corner_film.gd checks only the rope line. Fix on
   main: a body keep-out (drawn head, chest and shoulders, about 0.45 m) and a bar in corner_film.

## DEFFLOW's own root causes, most likely first

1. **Bodies inside bodies (76.6 s).** RingPlace keeps a floor only between the two pelvis nodes (RingPlace.gd:104-109,
   0.46 m, or 0.40 inside; a clinch can go to 0.32). A duck's head about 0.36 m in front of the hips, the duck_in and
   smother hip travel, the punch clip's lean and PunchReach's lunge (up to 0.26 m) all sit outside that floor. On a
   landed try, `fit_room` does not subtract the attacker's coming close-in or lunge (FightStage.gd:131-135).
   `reach_in` reports a distance even when `close_in` bailed (PunchRange.gd:16). The only volume guard is a thin trunk
   line in GloveClear (the chest fix is capped at 12 degrees, about 0.05 m). **Fix:** the floor applies to the drawn
   trunks (head, chest and hips spheres from PoseTap one frame back), not the pelvis nodes, and the duck room comes from
   that same measure.
2. **The duck moves the hips at about 2 m/s.** Four movers ignore `def_plant`: `SideStep.tick` (`pos += d`, disarmed
   only on the ropes, DefFire.gd:245), the 50/50 floor push when both boxers are planted (RingPlace.gd:64-68), Clinch
   (Clinch.gd:343), and the PunchReach lunge. r3 then applies `lock_pull` in one frame with no ease-in
   (DefPose.gd:381-382): up to 0.14 m sideways and 0.08 m down. The way in can be 0.05 s (CHAIN_IN_S). **Fix:** one
   owner of the hips during a defence window, every mover checks `def_plant`, `lock_pull` eases in over at least
   0.12 s, and a bar on the drawn hips' speed (none exists; RISE checks only upward motion).
3. **The lead foot slides on a rope parry.** The three reach constants straddle the resting stance: `PULL_REACH` 0.96 is
   below the guard's own rear-leg reach of about 0.99 (FootPlant.gd:59, :196), against STEP_REACH 0.98 and CAP_REACH
   0.99. So the lock always pulls the hips, the lead leg stretches, and the cap drags the foot (:167-170) or takes a step
   (:331). Three systems write the hips in one frame (`_hold_hips`, the shape, `lock_pull`). **Fix:** merge main's S383
   FootPlant core first (sub-steps, low-pass, soft reach), then rest the lock's reach on the stance's measured reach
   plus a margin, with one hip writer.
4. **A glove on the crown (97.45 s).** The landed glove aims at the face offset turned by the head's turn
   (FightStage.gd:191-203). On a bowed head that point is under the crown, and a level arm reaches it through the skull.
   The landing glove is exempt from every clearance (GloveClear.gd:131-133), and no bar counts landing gloves.
   **Fix:** when the head is bowed past about 30 degrees, a landed shot hits the top of the head or the guard (a
   clearance on the landing glove too), and add a bar for it.
5. **A deep drop at jab range (0:35).** How deep a duck goes does not depend on the punch. Only `fit_room` cuts it, and
   the rope `lock_pull` adds up to 0.08 m that `hd` does not see. DUCK_DROP allows 0.35-0.46 m. JAB_HEAD measures from
   the onset frame and skips jab rows near a landed punch. **Fix:** a jab's answer is a slip or a pull (no duck below
   about 0.10 m), and JAB_HEAD measures from neutral.

## FLOW replay shows no flow (branch code)

The replay plays recorded drawn poses (PoseRecorder is added last), so recording is not the problem. The piece choice
is: `_moments` (FlowCue.gd:133-147) adds the entry, `string[-1]` and the counter before `earned()`. With MAX_PIECES 3,
the matched answers never make the cut when a string and a counter exist. `earned()` reads the sim's pick (`b["def"]`),
not what DefFire showed (covers and downgrades turn slips into blocks, DefFire.gd:181-199). The side-on lens at 3.3 m
hides 0.1-0.2 m head moves. Pieces centre on the sim's contact times, not DefFire's delayed contact. A shout bar or
knockdown count stops the round clock while the recorder runs, so the look-back lands on idle frames. **Fix:** pick the
pieces from what DefFire showed, matched answers first; centre on the shown contact; use a front three-quarter lens at
about 2 m.

## The late shallow hook duck

On a LANDED hook this is by design: r3 put duck into the hook's late try (DefTable.gd:108), at half size (TRY_SCALE
0.5). On a stopped hook it is `fit_room` at close range (f 0.75 gives about 0.16 m of head drop against about 0.29 m at
full depth) plus a way in of 0.05-0.1 s. **Fix:** a hook's answer at close range is a roll or a block, not a duck.

## Order for round 3

1. Merge main into claude/defflow1 (keep S383's FootPlant step() core; DEFFLOW's lock, keep-out and rival-boot hooks go
   inside it; run_tests.sh as a union); re-measure owned_mocap_jitter (Punch PRO knee about 2.54).
2. Rewrite the bars on drawn bones (PoseTap): trunk spheres, drawn hips speed, landing glove clearance, JAB_HEAD from
   neutral. Run them on ee0411b1 first; they must FAIL where the film failed (76.6 s, 97.45 s, 0:35).
3. Fixes 1-5 and FLOW, one at a time, each turning its bar green.
4. On main, separately: NOREF (take it from fight9base) and the corner lens keep-out.
5. Film the 4 lenses and eyes on the video.

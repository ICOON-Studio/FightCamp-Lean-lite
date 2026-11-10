# Animation Rebuild Design: Clip Library + One Picker

> **Read at collect (S419, Claude):** taken as the reference plan for fewer pose writers, not as a work order. Three things in it are out of date or unproved, check before using them:
> - Step 1 (head and neck): S411 settled the hit reactions, the "half travel lost" was a probe read outside skeleton_updated; the real loss is about 15%, in the neck.
> - Step 2 (southpaw knees): S408 found no knee fault in the guard with the right ruler (distance out of the hip-ankle-foot plane).
> - Section 3 counts 37 clips. FightClips loads 145 Punch PRO clips plus owned takes, and BeatClips already picks among several per punch. The "41 missing" figure is void until a real census of what is loaded.
> Usable now: the writer table (section 1), the one-writer-per-bone rule (2.3), the order of the retirements (steps 3 to 8) and the risks (5.1).


> **Scope & Read Notes**: Every "today" fact below cites `file:line` in this worktree. Two paths named in `ops/research/TASK_ANIMREBUILD1.md` (`scripts/FightClipRokoko.gd` and `scripts/rules/LiveRound.gd`) are `unknown` at those exact paths: `LiveRound.gd` sits at `scripts/state/LiveRound.gd:1-496`, and Rokoko/CMU/Ailive clips are loaded by `scripts/fight3d/FightClips.gd:74-101` from `.res` files baked by `tools/owned_mocap_bake.gd:1-496`.

---

## 1. TODAY: Every Pose & Root Writer in Per-Frame Order

Per frame, Godot runs node `_process(delta)` callbacks first (writers **#1–#7**, setting root transforms, `AnimationPlayer` state, and modifier targets), evaluates `AnimationPlayer` (writer **#8**), and then executes `Skeleton3D` child `SkeletonModifier3D._process_modification()` nodes in scene-tree index order (writers **#9–#25**, assembled in `scripts/fight3d/BoxerBuild.gd:44-152`, `scripts/fight3d/TellPose.gd:30-39`, `scripts/fight3d/CornerCrew.gd:79`, and `scripts/fight3d/KnockdownReplay.gd:61`).

### 1.1 Per-Frame Writer Table (25 Writers)

| # | Writer (`file:line`) | Bones / Transforms Written | When It Runs | What It Exists to Fix | Fights With (Pair #) |
|---|---|---|---|---|---|
| 1 | `BeatFire.fire` (`scripts/fight3d/BeatFire.gd:41-75,88,163,187-207`) called from `FightView._process` (`scripts/fight3d/FightView.gd:344,368`) | `AnimationPlayer` clip cuts (`stage.play`), `TellPose.apply`, `Footwork.step`, `Clinch.start`/`release`, `PunchReach.arm`, `HitImpact.land`, `HitSnap.brace` | Live round when beat time `b["t"] <= _clock` | Translates 2D round beats from `scripts/fight3d/ExchangeBeats.gd:47-105` into 3D clip triggers and IK windows | #1, #6, #9, #10 |
| 2 | `SideStep.tick` (`scripts/fight3d/SideStep.gd:97-120`) from `FightStage._process` (`scripts/fight3d/FightStage.gd:201`) | `bx["pos"]` (`:119`), `AnimationPlayer` cut to guard (`:108,120`), `JoinSmoother.carry` (`:114`) | When a slip/weave/pull clip reaches `row["cut"]` (`0.55–0.90s`, `SideStep.gd:20-23`) | Cuts long mocap dodges short and bakes root offset into `bx["pos"]` | #14, #16 |
| 3 | `HitImpact.recover` & `HitImpact.hold` (`scripts/fight3d/HitImpact.gd:82-124`) from `FightStage._process` (`scripts/fight3d/FightStage.gd:202,204`) | `ap.speed_scale` (`0.0` in hit-stop `:85-94`; up to `1.5` in recovery `:113`, `BeatClips.gd:137`) and `AnimationPlayer` cut to guard at `back + 0.06s` (`:19,123`) | During punch contact hit-stop (`0.03–0.06s`, `:13`) and post-contact recovery | Freezes contact frames and cuts long mocap post-punch tails | #1, #14 |
| 4 | `GuardLife.tick` (`scripts/fight3d/GuardLife.gd:46-80`) from `FightStage._process` (`scripts/fight3d/FightStage.gd:203`) | `AnimationPlayer` cuts and `seek()` into `FIDGETS` (`pro_shift`, `pro_feint`, `pro_roll`, `pro_look`, `pro_shake`, `pro_tap`, `pro_bounce`, `:15-23,78`) | Every `QUIET_S` (`0.3–1.0s`, `:13`) while playing `pro_idle` | Breaks up static looping guard between exchanges | #14 |
| 5 | `RingPlace.compose` + `Footwork` + `PunchRange` (`scripts/fight3d/RingPlace.gd:38-147`, `scripts/fight3d/Footwork.gd:78-286`, `scripts/fight3d/PunchRange.gd:13-32`) | `bx["pos"]` (integrates `bx["vel"]` `:49`, rope clamp `:127`, gap clamps `0.60–0.82m` `:16-28,71-76,129-133`), `n.position` (`:140`), `n.rotation.y` (`:147`), `snap.sway` (`:142`), `tuck.inner` (`:144`) | Every live-round frame (`FightStage.gd:205`) | Drives range breathing (`scripts/fight3d/RangeBreath.gd:21-31`), closes punch gaps (`3.2 m/s`, `PunchRange.gd:10`), and stops torso overlap | #15, #16 |
| 6 | `RingFeet.tick` / `RingFeet.scene` + `BoxerFootwork.tick` (`scripts/fight3d/RingFeet.gd:35-64,196-225`, `scripts/fight3d/BoxerFootwork.gd:113-171`) | `plan.pos` via spring step state machine (`BoxerFootwork.gd:155-158`), `rig.want`, `rig.w`, and `n.position` (in scene mode `RingFeet.gd:224`) | Every frame (called at `RingPlace.gd:128` or `FightStage.gd:197`) | Turns smooth `bx["pos"]` travel into discrete lead-then-trail foot steps | #13, #15 |
| 7 | `Clinch._process` + `PushOff.step` + scene directors (`scripts/fight3d/Clinch.gd:192-353`, `scripts/fight3d/PushOff.gd:58-96`, `scripts/fight3d/CornerCrew.gd:264-311`, `scripts/fight3d/KnockdownCount.gd:132-182`, `scripts/fight3d/KnockdownRing.gd:15-51`) | `bx["pos"]` (`Clinch.gd:210,343-344`, `PushOff.gd:89-90`), `n.position` & `n.rotation.y` (`CornerCrew.gd:285-307`, `KnockdownCount.gd:378-417`), `AnimationPlayer` clinch loops (`Clinch.gd:230-256`), `CornerIK` weights | During clinch, push-off, intro, corner minute, and knockdown count | Holds fighters at `PAIR_GAP_M` (`0.68m`, `Clinch.gd:12`), pushes apart to `1.28m` (`PushOff.gd:16`), and walks corner/referee scenes | #11, #16 |
| 8 | `AnimationPlayer` + `FightClips.hold_root_xz` (`scripts/fight3d/FightClips.gd:128-146`, `scripts/fight3d/MHRig.gd:10-33`) | Local rotations on 22 mapped bones (`MHRig.BONES`) and local position on `Hips` (XZ pinned to key 0 except `TRAVELS = ["knockout", "fall"]`, `:25,130-146`) | Every frame before `SkeletonModifier3D` stack | Plays baked `.res` and FBX clips in-place on the MetaHuman rig | #1, #2, #14 |
| 9 | `JoinSmoother` (`scripts/fight3d/JoinSmoother.gd:1-195`, index 0 at `BoxerBuild.gd:67`) | Local rotations on all tracked bones (`_bones`, `:152`) and local position on `Hips`/`pelvis` (`:158`) | For `0.30s` (`:17`) or `GUARD_JOIN_S` (`0.45s`, `FightStage.gd:24`) after every clip cut | Hides pose cuts between clips using inertial dead-blending | #14 |
| 10 | `TiredSag` (`scripts/fight3d/TiredSag.gd:1-70`, index `js + 1` at `BoxerBuild.gd:76`) | Global pose basis on `Spine`, `Chest`, `Neck`, `LeftShoulder`, `RightShoulder` (`:52-64`) | Whenever `tired > 0.001` (set by `scripts/fight3d/BodyBurn.gd:141`) | Folds trunk (`7+5+8 deg`) and heaves shoulders (`7 deg`) when stamina/body is drained | #3 |
| 11 | `BoxerFootworkUpper` (`scripts/fight3d/BoxerFootworkRig.gd:122-136,180-200,296-303`, before `GuardWeave` at `BoxerBuild.gd:145`) | `Hips` position (`:135`, clamps Y `>= 0.78 * rest` and subtracts `0.04m` bounce), `Hips`, `Spine`, `Chest`, `Head` rotations (`:191-199`), `Spine` position (`:195`) | Whenever `rig.w > 0` (all fight time except `FREE` clips and clinch, `RingFeet.gd:41-46`) | Adds procedural step bounce, `10 deg` forward lean, chest lag, and head gaze stabilisation before arm IK | #2, #3 |
| 12 | `GuardWeave` (`scripts/fight3d/GuardWeave.gd:1-89`, after `BoxerFootworkUpper` at `BoxerBuild.gd:87`) | `Hips` position (`:76`, `0.06m` side, `0.12m` down), `Spine` & `Chest` rotations (`:79-81`, `17 deg` roll, `15 deg` dip, `10 deg` turn), `Neck` rotation (`:82-83`, `-0.55` counter) | During `free_clips` (guard + fidgets + step clips, `BoxerBuild.gd:85`), easing in/out | Moves head and trunk off the centre line between punches | #3, #4, #10 |
| 13 | `GuardTuck` (`scripts/fight3d/GuardTuck.gd:1-130`, after `GuardWeave` at `BoxerBuild.gd:98`) | `LeftUpperArm`, `LeftLowerArm`, `LeftHand`, `RightUpperArm`, `RightLowerArm`, `RightHand` via `PunchReach.solve` (`:130`) | During `guards` clips (`BoxerBuild.gd:96`), easing at `IN_SPEED 10.0` / `OUT_SPEED 14.0` (`:42-43`) | Pulls `pro_idle` wrists from `0.22m` out back to `GUARD` (`:38`), adds hand pumps, long-range drop, and inside high guard | #6, #8, #9, #10, #11 |
| 14 | `PunchReach` (`scripts/fight3d/PunchReach.gd:1-230`, after `GuardTuck` at `BoxerBuild.gd:107`; also re-called at `GloveClear.gd:99`) | `Chest` rotation (`_lean`, up to `0.30 rad` `:21,161,182-196`) and striking `UpperArm`, `LowerArm`, `Hand` (`:155,163,202-230`) | Around landed punch contact (`0.14s` in, `0.05s` hold, `0.16s` out, `0.20s` fade on cut, `:10-16`) | Stretches bag-authored punch clips to touch defender's head/ribs or guard gloves | #5, #6, #7, #8 |
| 15 | `HitSnap` (`scripts/fight3d/HitSnap.gd:1-265`, after `PunchReach` at `BoxerBuild.gd:117`) | `Spine` & `Chest` rotations (`_sway_step` `:217-218`, `_brace_step` `:238-240`, `_give_step` `:183-189`), `UpperArm` & `LowerArm` (`_brace_step` `:253,259`), `Neck` & `Head` (`:162-166`) | Inside range (`sway > 0`), body block/fold (`_bt >= 0`), head-shot trunk give (`_gt >= 0`), head snap (`_t >= 0`) | Adds procedural head snap (`18–32 deg`, `:14-18`), trunk recoil, body-shot fold (`FOLD_GAIN 3.0`, `:41`), and elbow blocks | #1, #4, #5, #9, #11 |
| 16 | `GloveClear` (`scripts/fight3d/GloveClear.gd:1-152`, after `HitSnap` at `BoxerBuild.gd:129`) | `Spine` & `Chest` rotation (`_clear_head` `:143-150`), re-runs `PunchReach.settle()` (`:99`), and writes `UpperArm`, `LowerArm`, `Hand` (`:120`) | Every frame when heads `< 0.19m` (`:18`) or non-reaching glove `< 0.15m` (`:12`) from opponent head | Pushes intersecting heads and stray gloves out of the opponent's skull | #5, #7, #8 |
| 17 | `ElbowClear` (`scripts/fight3d/ElbowClear.gd:1-107`, added at `BoxerBuild.gd:48`, sits after `GloveClear`) | `LeftUpperArm`, `LeftLowerArm`, `LeftHand`, `RightUpperArm`, `RightLowerArm`, `RightHand` (`:100,105,107`) | Every frame when an elbow is `< 0.17m` (`:11`) laterally from `Chest` centre | Pulls male-authored mocap elbows out of narrower female ribs | #8 |
| 18 | `TellPose` (`scripts/fight3d/TellPose.gd:1-192`, lazily inserted before `KneeTrack` at `:31-33`) | `Hips` position (`:127`), `Spine`, `Chest`, `Neck` rotations (`:130-131,157-159`), `UpperLeg` rotations (`:136`), `UpperArm`, `LowerArm`, `Hand` (`:173`) | During pre-punch `"tell"` beats (`hand_drop`, `lunge`, `tired_guard`, `hands_low`, `:72-81`) | Exaggerates opponent habits before they throw | #10 |
| 19 | `KneeTrack` (`scripts/fight3d/KneeTrack.gd:1-135`, before `MetaHumanTwist` at `BoxerBuild.gd:134`) | `LeftUpperLeg`, `LeftFoot`, `RightUpperLeg`, `RightFoot` local rotations (`:134-135`) | Every frame except `FREE` clips (`:14`) when knee bend `> 5 deg` and offset `> 20 deg` (`:16-18`) | Twists thighs about the hip-ankle axis so retargeted knees do not point inward or backwards | #12, #13 |
| 20 | `FootPlant` (`scripts/fight3d/FootPlant.gd:1-300`, at `kt.get_index() + 1` at `BoxerBuild.gd:137`) | `LeftUpperLeg`, `LeftLowerLeg`, `LeftFoot`, `RightUpperLeg`, `RightLowerLeg`, `RightFoot` local rotations (`:294-296`) | Every frame (`_weight` eases to `0.0` on `FREE` clips, `:128-129`) | Pins ankles to floor (`0.055m`, `:16`), widens stance (`STAGGER 1.32`, `:38`), and counters root glides | #12, #13, #14 |
| 21 | `BoxerFootworkRig` legs half (`scripts/fight3d/BoxerFootworkRig.gd:144-165,213-277`, at `fp.get_index() + 1` at `BoxerBuild.gd:145`) | `LeftUpperLeg`, `LeftLowerLeg`, `LeftFoot`, `LeftToes`, `RightUpperLeg`, `RightLowerLeg`, `RightFoot`, `RightToes` local rotations (`:268-271`) | Every frame when `rig.w > 0` (all fight time except `FREE` clips and clinch) | Solves two-bone leg IK onto `BoxerFootwork` foot targets with `TOE_OUT_DEG` (`-18` / `28 deg`, `:25-26`) | #13, #14 |
| 22 | `FloorClear` (`scripts/fight3d/FloorClear.gd:1-95`, added before `MetaHumanTwist` at `BoxerBuild.gd:149-152`) | `Hips` position (`:61`) and `UpperArm`, `LowerArm` rotations (`:64-65,88`) | When `Hips` world Y `< 0.45m` (`:15`) during knockdowns/knockouts | Lifts pelvis and arms out of the ring floor (`y < 0`) | None (runs when `FREE` clips disable #11–#21) |
| 23 | `CornerIK` (`scripts/fight3d/CornerIK.gd:1-241`, before `MetaHumanTwist` at `CornerCrew.gd:79`) | `Spine` (`_upright` `:129`, `_duck` `:150`), `Head`..`Chest` (`_turn_head` `:197`), `UpperArm`, `LowerArm`, `Hand` (`_solve` `:239-241`) | During clinch, push-off, ring walk-out/glove-touch, and corner minute | Places hands on partner/ropes/stool/bottle and aims head at target | #11 |
| 24 | `MetaHumanTwist` (`scripts/fight3d/MetaHumanTwist.gd:1-133`, moved to last at `BoxerBuild.gd:152`) | `lowerarm_twist_0*`, `upperarm_twist_0*`, `calf_twist_0*`, `thigh_twist_0*` (`:122,132`) | Every frame | Distributes wrist, shoulder, ankle, and thigh axial roll across MetaHuman helper twist bones | None (writes only leaf twist bones) |
| 25 | `PoseRecorder` (`scripts/fight3d/PoseRecorder.gd:1-87`, appended last at `KnockdownReplay.gd:61`) | All bones' local position/rotation and `body.global_transform` (`:48,84-87`) | During slow-motion knockdown replay (`play >= 0.0`) and `3` settle frames (`:11`) | Records and replays exact skeleton poses for knockdown slow-motion | None (intentional full override in replay) |

### 1.2 The 16 Fighting Pairs Today

1. **`AnimationPlayer` (`pro_hit_by_*`) vs `HitSnap` (`Head`, `Neck`)**: `HitImpact.land` (`HitImpact.gd:41-59`) starts `pro_hit_by_jab` (`mc_Box1_M3_Hit_To_Head_Light_L`) AND fires `HitSnap.hit` on the same frame. The clip rotates `Head` one way while `HitSnap._process_modification` (`HitSnap.gd:147-166`) pushes `Neck`/`Head` along `dir` scaled by `clampf(1.0 - _gain, 0.25, 1.0)`, cancelling or double-bending the neck (`ops/research/ANIM_HANDOVER_S397.md:39-42`, `tools/head_react_probe.gd:1-6`).
2. **`BoxerFootworkUpper` vs `AnimationPlayer` clip (`Hips.y`, `Hips`, `Spine`, `Chest`, `Head`)**: `BoxerFootworkUpper._upper` (`BoxerFootworkRig.gd:135,191-199`) overwrites baked mocap `Hips.y` with `maxf(rest_h.y * 0.78, p_h.y) - 0.04 * b` and adds `10 deg` lean + head counter-pitch on top of already-posed mocap (`ops/research/FIGHTWALK2_FILMS_S397.md:10-20`).
3. **`TiredSag` vs `BoxerFootworkUpper` vs `GuardWeave` (`Spine`, `Chest`, `Neck`, `Hips`)**: Three modifiers stack forward pitch and hip drop on the same trunk bones: `TiredSag` (`TiredSag.gd:56-58`, `20 deg` total fold), `BoxerFootworkUpper` (`BoxerFootworkRig.gd:191-197`, `10 deg` lean + `0.04m` drop), and `GuardWeave` (`GuardWeave.gd:76-83`, `15 deg` dip + `17 deg` roll + `0.12m` drop).
4. **`GuardWeave` vs `HitSnap` (`Spine`, `Chest`, `Neck`, `Head`)**: While `GuardWeave._weight` eases out (`OUT_RATE = 10.0`, `GuardWeave.gd:26`), its `-0.55` `Neck` counter-rotation (`:82-83`) fights `HitSnap`'s head/neck snap and trunk give (`HitSnap.gd:162-189`).
5. **`PunchReach._lean` vs `HitSnap._sway_step` vs `GloveClear._clear_head` (`Spine`, `Chest`)**: Up close, `PunchReach._lean` (`PunchReach.gd:182-196`) leans `Chest` forward (`0.30 rad`), `HitSnap._sway_step` (`HitSnap.gd:198-218`) leans `Spine`/`Chest` away, and `GloveClear._clear_head` (`GloveClear.gd:123-150`) bends `Spine`/`Chest` again and re-runs `PunchReach.settle()` (`:99`).
6. **`GuardTuck` vs `PunchReach` (`UpperArm`, `LowerArm`, `Hand`)**: During strike exit (`OUT_S` `0.16s` / `FADE_S` `0.20s`, `PunchReach.gd:14-16`), `GuardTuck` (`GuardTuck.gd:130`) solves arm IK toward cheek-level `GUARD` while `PunchReach` (`PunchReach.gd:155,163`) solves the same arm toward the opponent.
7. **`PunchReach` vs `GloveClear` (`UpperArm`, `LowerArm`, `Hand`)**: `PunchReach` solves the striking glove onto the defender's head (`PunchReach.gd:163`), and two modifiers later `GloveClear` (`GloveClear.gd:99-120`) re-settles `PunchReach` and pushes fading/other gloves `0.15m` out of the head sphere.
8. **`GuardTuck` / `PunchReach` vs `ElbowClear` (`UpperArm`, `LowerArm`, `Hand`)**: After `GuardTuck`, `PunchReach`, `HitSnap._brace_step`, and `GloveClear` solve the arm chain, `ElbowClear` (`ElbowClear.gd:65-107`) re-solves `UpperArm`/`LowerArm`/`Hand` to pry the elbow `0.17m` laterally from `Chest`.
9. **`GuardTuck` vs `HitSnap._brace_step` (`UpperArm`, `LowerArm`)**: On a blocked body shot in guard, `GuardTuck` (`GuardTuck.gd:130`) pulls wrists up to `GUARD` (`0.14m` below head), and `HitSnap._brace_step` (`HitSnap.gd:246-259`) immediately swings `UpperArm` down (`0.42 rad`) and opens `LowerArm` (`-0.38 rad`).
10. **`TellPose` vs `GuardTuck` / `GuardWeave` (`Hips`, `Spine`, `Chest`, `Neck`, `UpperArm`, `LowerArm`, `Hand`)**: During a `"tell"` beat (`TellPose.gd:104-174`), `GuardWeave` and `GuardTuck` pose trunk and arms first, then `TellPose` overwrites trunk bones and re-runs `PunchReach.solve` (`:173`).
11. **`CornerIK` vs `GuardTuck` / `HitSnap` (`Spine`, `Chest`, `Neck`, `Head`, `UpperArm`, `LowerArm`, `Hand`)**: During clinch (`Clinch.gd:271-296`) and push-off (`PushOff.gd:62-63`), `GuardTuck` and `HitSnap._sway_step` pose trunk and arms first, then `CornerIK` (`CornerIK.gd:129,197,239-241`) overwrites `Spine`, `Head`..`Chest`, and both arms.
12. **`FootPlant` vs `KneeTrack` (`LeftUpperLeg`, `RightUpperLeg`, `LeftFoot`, `RightFoot`)**: `KneeTrack` (`KneeTrack.gd:134-135`) twists `UpperLeg` and `Foot` to align the knee, and at the very next modifier index `FootPlant._solve_leg` (`FootPlant.gd:257-296`) overwrites `UpperLeg`, `LowerLeg`, and `Foot` with its own two-bone IK.
13. **`BoxerFootworkRig` vs `FootPlant` + `KneeTrack` (`UpperLeg`, `LowerLeg`, `Foot`, `Toes`)**: At `fp.get_index() + 1` (`BoxerFootworkRig.gd:64`), `BoxerFootworkRig._legs` (`:144-165,213-271`) overwrites both `FootPlant` and `KneeTrack` when `w == 1.0`. In southpaw (`stance == -1`), `BoxerFootworkRig.gd:87,250` flips foot X and `TOE_OUT_DEG` without flipping the knee-bend plane sign, creating a `24.4 deg` knock-knee valgus (`ops/research/TASK_SOUTHPAW2.md:37-44`).
14. **`JoinSmoother` vs `FootPlant` / `BoxerFootworkRig` (`Hips`, leg bones)**: On every clip cut (`GuardLife` fidgets every `0.3–1.0s`, `SideStep.tick`, `HitImpact.recover`), `JoinSmoother` (`JoinSmoother.gd:136-160`) dead-blends `Hips` and leg rotations at index 0 while `FootPlant` and `BoxerFootworkRig` re-solve leg IK to world-pinned ankles at indices 11–12 (`ops/research/FIGHTWALK2_FILMS_S397.md:22`).
15. **`RingPlace.compose` vs `RingFeet.tick` / `BoxerFootwork` (`n.position` vs `bx["pos"]`)**: `RingFeet.tick` lags `bx["pos"]` on discrete steps (`BoxerFootwork.gd:155-158`), then `RingPlace._place` (`RingPlace.gd:129-140`) pushes `RingFeet.shown` outward via `kept(..., keep_m)` and adds `PunchReach.lunge()` (`0.28m`, `PunchReach.gd:24`), dragging planted feet across the canvas.
16. **`SideStep.tick` + `PunchRange.close_in` vs `Clinch._process` + `PushOff.step` (`bx["pos"]`)**: Five systems write `bx["pos"]` / `bx["vel"]` (`Footwork.walk` `Footwork.gd:250`, `PunchRange.close_in` `PunchRange.gd:22`, `SideStep.tick` `SideStep.gd:119`, `Clinch._process` `Clinch.gd:210,343-344`, `PushOff.step` `PushOff.gd:89-90`), shoving roots back and forth.

---

## 2. TARGET: Clip Library, One Picker, Impact, and Surviving Layers

### 2.1 The Clip Library (`scripts/fight3d/ClipLibrary.gd`)

Every animation in the game is registered as an immutable entry in `ClipLibrary.gd`. One entry holds:

```gdscript
{
	"id": "jab_ortho_lead_mid_01",      # Unique library entry ID
	"clip": "pro_jab",                  # Baked .res clip name in FightClips
	"event": "jab",                     # Model event (jab, cross, lead_hook, slip, clinch_entry, ...)
	"start_stance": "ortho",            # "ortho" | "southpaw" (or grappling state tag later)
	"end_stance": "ortho",              # "ortho" | "southpaw" (allows shifting steps/pivots)
	"range_m": Vector3(1.05, 1.22, 1.38), # (min_m, ideal_m, max_m) pelvis-to-pelvis range
	"hand": "lead",                     # "lead" | "rear" | "both" | "none"
	"target": "head",                   # "head" | "body" | "none"
	"partner_clip": "",                 # Paired library ID for opponent (mandatory on clinch/paired)
	"contact_s": 0.16,                  # Baked glove peak extension time (s)
	"back_s": 0.42,                     # Baked return-to-guard time (s)
	"root_delta": Vector3(0.0, 0.0, 0.14), # Baked XZ root travel over [0, back_s]
	"tags": ["outside", "stiff"]        # Context tags: counter, ropes, tired, heavy, paired, ground
}
```

### 2.2 The One Picker (`scripts/fight3d/ClipPicker.gd`)

- **Inputs**:
  1. **Model event**: beat dictionary from `scripts/state/LiveRound.gd:214-316`, `scripts/rules/Exchanges.gd:153-233`, and `scripts/fight3d/ExchangeBeats.gd:47-105` (`event`, `who`, `outcome`: `landed` / `blocked` / `evaded` / `miss`, `damage`, `tell`).
  2. **Both boxers' current state**: `stance` (`"ortho"` / `"southpaw"`), current `clip` + playback time `t`, pelvis-to-pelvis `gap_m`, distance to nearest rope (`HALF_M = 2.62m`, `RingPlace.gd:12`), stamina `tired` (`BodyBurn.gd:139-143`), and `recent_clips` history.
- **Output**:
  `{ "attacker_clip": String, "defender_clip": String, "blend_s": float, "sync_anchor": Transform3D }`
  - Returns a coordinated clip pair (e.g., attacker `pro_lead_hook` + defender `pro_block_high_r` or `pro_hit_by_hook`, or paired `clinch_entry_att` + `clinch_entry_vic`) and the `AnimationPlayer` crossfade duration (`blend_s = 0.08–0.14s` between guard/step/strike clips; `0.05s` on sudden hit reactions).
- **How It Avoids Repeats**:
  Each boxer state keeps a 6-slot ring buffer `recent_clips: Array[String]`. Candidate entries matching `(event, start_stance, hand, target)` with `gap_m` inside `[range_m.x, range_m.z]` are scored:
  `score = 1.0 - absf(gap_m - range_m.y) / (range_m.z - range_m.x) + tag_bonus - repeat_penalty`
  If a candidate equals `recent_clips[0]` (just played) and `>= 2` candidates exist, it is disqualified (`repeat_penalty = 999.0`); for `lag` in `1..5`, `repeat_penalty = 0.5 / float(lag)`. Ties break deterministically using a hash of `(round_n, beat_index, who)` so replays stay deterministic.

### 2.3 Impact: Where Physics / Additive Reactions Apply and Where They Must NOT

- **Core Rule — One Writer Per Bone Per Frame** (`ops/research/ANIM_HANDOVER_S397.md:41`):
  - **Where additive / procedural modifiers MUST NOT apply**:
    1. **During any full-body reaction clip (`pro_hit_by_*`, `hurt_*`, `kd_*`)**: `HitSnap` MUST NOT write `Head`, `Neck`, `Spine`, or `Chest`. The reaction clip owns the head and trunk trajectory (`ANIM_HANDOVER_S397.md:39-42`).
    2. **During any strike, block, slip, roll, or clinch clip**: No modifier may bend `Spine`/`Chest` (`TiredSag`, `GuardWeave`, `BoxerFootworkUpper`, `PunchReach._lean`, `GloveClear._clear_head`) or re-solve `UpperArm`/`LowerArm`/`Hand` (`GuardTuck`, `PunchReach`, `HitSnap._brace_step`, `GloveClear`, `ElbowClear`).
  - **Where impact layers DO apply**:
    1. **Contact hit-stop (`HitImpact.hold`, `HitImpact.gd:82-95`)**: Sets `ap.speed_scale = 0.0` for `0.03–0.05s` at contact on landed shots. Writes zero bones and makes contact readable at 30 fps.
    2. **Additive head snap (`HitSnap` head-only mode) ONLY when no reaction clip plays**: When a light jab lands while the defender stays in a footwork or counter-punch clip, `HitSnap` is the sole writer on `Neck`/`Head` (`15–22 deg` turn, `>= 0.04m` travel, peak `<= 0.08s`, max `<= 30 deg`; `tools/head_react_probe.gd:5-6`).
    3. **Blocked shots**: Defender plays a dedicated block clip (`block_high_*` / `block_body_*`); `HitSnap` is off so blocked head turn stays `<= 6 deg` (`tools/head_react_probe.gd:5`), and `RingPlace` applies `0.03–0.05m` root pushback.

### 2.4 The Few Layers That Survive (and Justification for Each)

Fourteen bone/pose fix-up modifiers are retired. Only **3 functional layers** (plus 1 passive skinning helper) survive:

1. **Root Placement (`scripts/fight3d/RingPlace.gd`)**
   - *Role*: Applies clip root travel (`root_delta`), clamps both boxers inside the ropes (`HALF_M = 2.62m`, `RingPlace.gd:12`), enforces capsule separation (`MIN_GAP_M = 0.64m`), and aligns both roots to `sync_anchor` during paired clips.
   - *Justification*: Clips are captured in an unbounded volume; only the stage knows where the ropes and opponent capsule sit.
2. **Foot Lock (`scripts/fight3d/FootPlant.gd`, ankle/toe pin only)**
   - *Role*: Two-bone leg IK that pins planted feet to their floor contact point during support windows (and releases `weight = 0.0` during swing phases and `FREE`/`ground` clips), using a stance-signed knee plane normal (`ortho` and `southpaw`).
   - *Justification*: Even clips pinned offline by `tools/owned_mocap_plant.gd` (`tools/owned_mocap_bake.gd:475`) slide slightly during `AnimationPlayer` crossfades and rope clamping; one lightweight ankle pin prevents skating without fighting clip gait.
3. **Look-At (`scripts/fight3d/CornerIK.gd`, `_turn_head` gaze only)**
   - *Role*: Aims `Neck`/`Head` (`MAX_YAW = 45 deg`, `MAX_PITCH = 28 deg`, `CornerIK.gd:16-17`) at the opponent's head during guard/footwork or at the coach in the corner; disabled (`look_w = 0.0`) during hurt, hit-react, roll, and knockdown clips.
   - *Justification*: Boxers of different heights (`mh_boxer_01..08`, `scripts/fight3d/FightCast.gd:12-23`) at varying ranges need their chin and eyes aimed at the opponent's actual head height.
- *(Passive Skinning Helper: `MetaHumanTwist` (`scripts/fight3d/MetaHumanTwist.gd:1-133`) stays at the end of `Skeleton3D` because it writes only leaf `*_twist_*` skinning bones (`:122,132`) and never touches any bone in `MHRig.BONES`.)*

---

## 3. CLIP GAP LIST

Allowed sources: **Rokoko**, **ActionForge**, **Ailive** (footwork/duck), **Ludo animate** (no Meshy; bodies stay MetaHuman `mh_boxer_01..08`, baked via `tools/owned_mocap_bake.gd:1-496`).

| Model Event | Clips We Have Today (`file:line`) | Have | Clips We Need (Source & Range / Stance) | Need | Total | Paired Captures Needed |
|---|---|---:|---|---:|---:|---:|
| **Guard & Footwork** (`RangeBreath.gd:35-66`) | `pro_idle` (`rk_guard_01`), `pro_advance` (`al_step_in_01`), `pro_retreat` (`al_step_out_01`), `pro_strafe_l` (`al_step_left_01`), `pro_strafe_r` (`al_step_right_01`), `pro_shift` (`cmu_90_13_idle`) (`FightClips.gd:76-82`) | 6 | `pivot_left` (`al_pivot_l`), `pivot_right` (`al_pivot_r`), `back_on_ropes_idle`, southpaw guard/step bake (`Ailive` / `Rokoko`) | 4 | 10 | 0 |
| **jab** (`RoundScript.gd:16`, `BeatClips.gd:55-58`) | `pro_jab` (`rk_jab_01`, `FightClips.gd:89`), `mc_jab_1` (`mc_Box1_M3_Punch_Jab_L_1`, `FightClips.gd:27`) | 2 | Step-in long jab (`range_m` `1.35–1.55m`), retreating counter jab (`1.05–1.25m`) (`Rokoko` / `ActionForge`) | 2 | 4 | 0 |
| **cross** (`RoundScript.gd:16`, `BeatClips.gd:59-61`) | `pro_cross` (`rk_cross_01`, `FightClips.gd:90`), `mc_cross_1` (`mc_Box1_M3_Punch_Cross_R_1`, `FightClips.gd:31`) | 2 | Long lunging straight right (`1.30–1.50m`), short counter right (`0.95–1.15m`) (`Rokoko` / `ActionForge`) | 2 | 4 | 0 |
| **hook** (`lead_hook`, `rear_hook`, `BeatClips.gd:62-68`) | `pro_lead_hook` (`rk_hook_l_01`), `pro_rear_hook` (`rk_hook_r_01`), `mc_hook_r_1` (`FightClips.gd:37,91-92`) | 3 | Inside tight lead hook (`0.65–0.85m`), mid lead hook (`0.90–1.10m`), pivot check-hook (`0.85–1.05m`) so hooks do not fall `0.1–0.27m` short (`RangeBreath.gd:22`, `Rokoko` / `ActionForge`) | 3 | 6 | 0 |
| **uppercut** (`lead_uppercut`, `rear_uppercut`, `BeatClips.gd:69-74`) | `pro_uppercut` (`rk_uppercut_01`, `FightClips.gd:93`; `pro_lead_uppercut` aliases the same file at `:94`) | 1 | Dedicated `lead_uppercut` (`0.70–0.90m`), inside `rear_uppercut` (`0.60–0.80m`), mid `rear_uppercut` (`0.85–1.05m`) (`Rokoko` / `ActionForge`) | 3 | 4 | 0 |
| **body shots** (`body_jab`, `body_cross`, `body_hook`, `BeatClips.gd:75-86`) | `pro_body_jab` (`mc_Box3_M3_Hook_Body_L_1`), `pro_body_cross` (`mc_Box3_M3_Cross_Body_R_1`) (`FightClips.gd:40-43`; `pro_body_hook*` aliases the same two files) | 2 | True level-change straight `body_jab` (`1.10–1.30m`), inside spleen `body_hook_l` (`0.65–0.85m`), plus **1 paired capture** (2 clips): attacker liver `body_hook_r` + defender rib-brace fold (`ActionForge` / `Ludo animate`) | 4 | 6 | 1 |
| **slip** (`ExchangeBeats.gd:268`, `BeatClips.gd:91`) | `pro_slip_l` (`al_duck_01`), `pro_slip_r` (`al_duck_02`) (`FightClips.gd:95-96`, cut early by `SideStep.gd:20`) | 2 | Crisp outside `slip_l_short` (`0.35s`) and `slip_r_short` (`0.35s`) that recover to guard without `SideStep.gd` cuts (`Ailive` / `Rokoko`) | 2 | 4 | 0 |
| **roll** (`weave`, `pull`, `ExchangeBeats.gd:267-269`, `BeatClips.gd:92-93`) | `pro_weave` (`al_duck_03`), `pro_pull` (`al_step_out_02`) (`FightClips.gd:97-98`, cut by `SideStep.gd:21-22`) | 2 | U-roll under lead hook (`roll_l_to_r`, `0.45s`) and U-roll under rear hook (`roll_r_to_l`, `0.45s`) (`Ailive` / `Rokoko`) | 2 | 4 | 0 |
| **block** (`ExchangeBeats.gd:266`, `BeatClips.gd:90`, `HitImpact.gd:57-58`) | `pro_block` (`rk_block_01`, `FightClips.gd:99`), `pro_hit_by_body` (`mc_Box2_M3_Block_Body_L_1`, `FightClips.gd:56`) | 2 | High jab catch (`block_high_jab`), high power shell (`block_high_power`), lead body elbow block (`block_body_r`), rear body elbow block (`block_body_l`) to retire `HitSnap._brace_step` (`Rokoko` / `ActionForge`) | 4 | 6 | 0 |
| **clinch entry/break** (`LiveRound.gd:272-279`, `Clinch.gd:230-296`, `PushOff.gd:58-96`) | `clinch_att` (`mc_Box2_M3_Clinch_A_Att`), `clinch_vic` (`mc_Box2_M3_Clinch_A_Vic`) (`FightClips.gd:65-66`; open-stance falls back to `pro_block_loop` + `CornerIK` at `Clinch.gd:251-296`) | 2 | **3 paired captures** (6 clips): (1) `clinch_entry_att` + `clinch_entry_vic` (`0.68m` tie-up), (2) open/closed-stance `clinch_work_att` + `clinch_work_vic` (tie + inside rib dig), (3) `clinch_break_att` + `clinch_break_vic` (clean push-off to `1.28m`, retiring `PushOff.gd`) (`ActionForge` / `Rokoko`) | 6 | 8 | 3 |
| **hurt** (`RoundScript.gd:105-110`, `BeatClips.gd:97-110`, `HitImpact.gd:39-80`) | `pro_hit_by_jab`, `pro_hit_by_cross`, `pro_hit_by_hook`, `pro_hit_by_uppercut`, `react_body_fold` (`FightClips.gd:49-62`) | 5 | `hurt_stumble_back` (retiring `HitImpact.STUMBLE` `pro_retreat` hack at `HitImpact.gd:22,62-80`), `hurt_on_ropes`, `hurt_body_liver` (`ActionForge` / `Rokoko`) | 3 | 8 | 0 |
| **knockdown** (`LiveRound.gd:292-316`, `KnockdownCount.gd:268-335`) | `knockout`, `fall`, `countdown` (`FightClips.gd:18-20`) | 3 | Canvas-calibrated `kd_head_back`, body-shot knee drop `kd_body_knee`, and forward `kd_getup_eight` (retiring reverse-played `countdown` at `speed_scale = -1.0` in `KnockdownCount.gd:316` and `FloorClear.gd`) (`ActionForge` / `Rokoko`) | 3 | 6 | 0 |
| **corner** (`CornerMinute.gd:218-295`, `CornerCrew.gd:21-25`, `CornerWarm.gd:16-19`) | `sit_stool`, `stand_stool`, `stool_idle` (`CornerCrew.gd:21-25`), `warm_neck`, `warm_torso` (`CornerWarm.gd:16-19`) | 5 | `stool_idle_tired`, `rope_duck_in` (retiring `CornerIK._duck` spine bend at `CornerIK.gd:142-151`), plus **1 paired capture** (2 clips): `stool_drink_boxer` + `coach_water_work` (retiring `CornerMinute.gd:218-295` bottle IK) (`Rokoko` / `Ludo animate`) | 3 | 8 | 1 |
| **TOTAL** | | **37** | | **41** | **78** | **5** |

---

## 4. MIGRATION: 8 Single-Change Steps

Every step is **one atomic change**, judged on a 2-minute film against `main` by a blind critic, with a headless test that **FAILS on `main` first**.

### Step 1: Single writer on `Head` and `Neck` during landed head punches (small & visible)
- **Change**: Stop `HitImpact.land` from starting `pro_hit_by_*` clips on routine jabs/crosses while `HitSnap` is active, gate `HitSnap` head turn (`_t`) and `GuardWeave` neck counter-rotation off whenever a full-body reaction clip (`pro_hit_by_*`) plays, and tune `HitSnap` so landed head shots turn the head `15–26 deg` within `0.08s` while blocked shots stay `<= 6 deg` (`ops/research/ANIM_HANDOVER_S397.md:39-42`).
- **OWNS**: `scripts/fight3d/HitImpact.gd`, `scripts/fight3d/HitSnap.gd`, `scripts/fight3d/GuardWeave.gd`, `tools/head_react_probe.gd`
- **Headless test (FAILS on `main` first)**:
  `godot --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tools/head_react_probe.gd -- show3d`
  *(Fails on `main` today because `pro_hit_by_jab` and `HitSnap` fight on `Head`, leaving median landed head turn `< 15 deg`; `tools/head_react_probe.gd:448-455`.)*
- **Fault removed**: Eliminates Fighting Pairs **#1** and **#4** — landed head punches visibly snap the defender's head back instead of cancelling out.

### Step 2: Fix southpaw knock-knee valgus and collapse the triple leg IK stack into one leg solver
- **Change**: Mirror the knee-bend plane normal sign when `stance == -1` in `scripts/fight3d/BoxerFootworkRig.gd:87,250` (`ops/research/TASK_SOUTHPAW2.md:37-44`), and disable `KneeTrack` + `FootPlant` whenever `BoxerFootworkRig.w > 0` so legs are solved once per frame instead of three times.
- **OWNS**: `scripts/fight3d/BoxerFootworkRig.gd`, `scripts/fight3d/FootPlant.gd`, `scripts/fight3d/KneeTrack.gd`, `tests/guard_valgus_test.gd`
- **Headless test (FAILS on `main` first)**:
  `godot --headless --audio-driver Dummy --path . --script res://tests/guard_valgus_test.gd`
  *(Asserts southpaw and orthodox `valgus_p95 <= 8.0 deg`, `stance_z >= 0.18m`, and active leg IK writer count `== 1`; fails on `main` where southpaw `valgus_p95` is `24.4 deg` and 3 leg solvers run at once; `TASK_SOUTHPAW2.md:27,62`.)*
- **Fault removed**: Eliminates Fighting Pairs **#12** and **#13** — removes southpaw knock-knees and triple leg-IK thrashing.

### Step 3: Add `ClipLibrary.gd` + `ClipPicker.gd` and retire `GuardLife` random mid-idle cuts
- **Change**: Create `ClipLibrary.gd` (registering all 37 existing clips with stance, range, hand, target, timing, and tags) and `ClipPicker.gd` (range/stance scoring + 6-clip repeat buffer), and replace `GuardLife.tick` (`GuardLife.gd:46-80` random `0.3–1.0s` mid-clip seeks) with full-clip transitions chosen by `ClipPicker`.
- **OWNS**: `scripts/fight3d/ClipLibrary.gd`, `scripts/fight3d/ClipPicker.gd`, `scripts/fight3d/BeatClips.gd`, `scripts/fight3d/GuardLife.gd`, `scripts/fight3d/FightStage.gd`, `tests/clip_picker_repeat_test.gd`
- **Headless test (FAILS on `main` first)**:
  `godot --headless --audio-driver Dummy --path . --script res://tests/clip_picker_repeat_test.gd`
  *(Simulates 180s of exchange beats; asserts zero mid-clip fidget seeks, zero consecutive identical punch clips when `>= 2` variants exist, and quiet-guard clip cuts `<= 20/min`; fails on `main` where `GuardLife.gd:13` cuts every `0.3–1.0s`.)*
- **Fault removed**: Eliminates Fighting Pair **#14** during guard — stops constant `JoinSmoother` dead-blending pops every half-second (`ops/research/FIGHTWALK2_FILMS_S397.md:22`).

### Step 4: Replace `BoxerFootwork` + `BoxerFootworkUpper` with Ailive step clips and single `FootPlant` lock
- **Change**: Drive stepping in `RingFeet.gd` through `ClipPicker` selecting `pro_advance`, `pro_retreat`, `pro_strafe_l`, `pro_strafe_r` (`FightClips.gd:78-81`), remove `BoxerFootworkRig` (`BoxerFootworkUpper` + leg IK) and `BoxerFootwork.gd`, and keep only `FootPlant` (with the Step 2 southpaw knee fix) to pin planted support ankles.
- **OWNS**: `scripts/fight3d/RingFeet.gd`, `scripts/fight3d/BoxerFootwork.gd`, `scripts/fight3d/BoxerFootworkRig.gd`, `scripts/fight3d/FootPlant.gd`, `scripts/fight3d/BoxerBuild.gd`, `tests/foot_skate_single_solver_test.gd`
- **Headless test (FAILS on `main` first)**:
  `godot --headless --audio-driver Dummy --path . --script res://tests/foot_skate_single_solver_test.gd`
  *(Asserts `BoxerFootworkUpper` is absent, clip `Hips.y` is preserved within `0.005m`, and planted toe slide `p95 <= 0.025m`; fails on `main` where `BoxerFootworkUpper` overwrites `Hips.y` at `BoxerFootworkRig.gd:135`.)*
- **Fault removed**: Eliminates Fighting Pairs **#2** and **#15** — restores natural mocap hip weight transfer and removes spring-step marching (`FIGHTWALK2_FILMS_S397.md:10-20`).

### Step 5: Retire trunk stack (`TiredSag`, `GuardWeave`, `PunchReach._lean`, `GloveClear._clear_head`)
- **Change**: Remove `TiredSag`, `GuardWeave`, `PunchReach._lean`, and `GloveClear._clear_head`; express fatigue through `ClipPicker` choosing tired-tagged guard/step clips (`pro_shift`) and prevent head-in-head overlap via `RingPlace` capsule floor (`MIN_GAP_M = 0.64m`).
- **OWNS**: `scripts/fight3d/BoxerBuild.gd`, `scripts/fight3d/TiredSag.gd`, `scripts/fight3d/GuardWeave.gd`, `scripts/fight3d/PunchReach.gd`, `scripts/fight3d/GloveClear.gd`, `scripts/fight3d/RingPlace.gd`, `tests/trunk_single_writer_test.gd`
- **Headless test (FAILS on `main` first)**:
  `godot --headless --audio-driver Dummy --path . --script res://tests/trunk_single_writer_test.gd`
  *(Asserts zero `SkeletonModifier3D` writes on `Spine`/`Chest` during live exchanges and head-to-head distance `>= 0.19m`; fails on `main` where 5 modifiers write `Spine`/`Chest` simultaneously.)*
- **Fault removed**: Eliminates Fighting Pairs **#3** and **#5** — stops 42-degree stacked forward trunk folding and close-range spine twitching.

### Step 6: Retire arm IK stack (`GuardTuck`, `PunchReach`, `HitSnap._brace_step`, `GloveClear`, `ElbowClear`, `TellPose`)
- **Change**: Gate strikes on `ClipPicker` range windows (`range_m`), bake female clavicular/elbow clearance directly in `tools/owned_mocap_bake.gd:324-335`, play dedicated high/body block clips on blocked shots, and remove `GuardTuck`, `PunchReach`, `HitSnap._brace_step`, `GloveClear`, `ElbowClear`, and `TellPose`.
- **OWNS**: `scripts/fight3d/BoxerBuild.gd`, `scripts/fight3d/GuardTuck.gd`, `scripts/fight3d/PunchReach.gd`, `scripts/fight3d/HitSnap.gd`, `scripts/fight3d/GloveClear.gd`, `scripts/fight3d/ElbowClear.gd`, `scripts/fight3d/TellPose.gd`, `tools/owned_mocap_bake.gd`, `tests/arm_zero_ik_test.gd`
- **Headless test (FAILS on `main` first)**:
  `godot --headless --audio-driver Dummy --path . --script res://tests/arm_zero_ik_test.gd`
  *(Asserts zero `SkeletonModifier3D` writes on `UpperArm`/`LowerArm`/`Hand` during live rounds and baked elbow-to-chest clearance `>= 0.16m`; fails on `main` where 6 modifiers overwrite the arm chain.)*
- **Fault removed**: Eliminates Fighting Pairs **#6**, **#7**, **#8**, **#9**, and **#10** — removes rubber-arm stretching, elbow popping, and guard-to-punch IK snapping.

### Step 7: Replace `Clinch` + `PushOff` + `SideStep` hacks with paired clinch & full-recovery evade clips
- **Change**: Wire paired `clinch_entry`, `clinch_work`, and `clinch_break` clips into `ClipLibrary` with shared `sync_anchor` placement in `RingPlace.gd`, use full-recovery slip/roll clips (`0.35–0.45s`), and delete `PushOff.gd`, `SideStep.gd`, and `CornerIK` arm/upright calls in `Clinch.gd`.
- **OWNS**: `scripts/fight3d/Clinch.gd`, `scripts/fight3d/PushOff.gd`, `scripts/fight3d/SideStep.gd`, `scripts/fight3d/RingPlace.gd`, `scripts/fight3d/ClipLibrary.gd`, `tests/paired_clinch_test.gd`
- **Headless test (FAILS on `main` first)**:
  `godot --headless --audio-driver Dummy --path . --script res://tests/paired_clinch_test.gd`
  *(Asserts both orthodox and open-stance clinches play paired `clinch_*` clips rather than `pro_block_loop`, `CornerIK.w_l == 0.0` during clinch/break, and zero `SideStep` cuts; fails on `main` at `Clinch.gd:251-296`.)*
- **Fault removed**: Eliminates Fighting Pairs **#11** and **#16** — replaces stiff `pro_block_loop` + puppet-arm clinches and velocity shoves with synced two-actor clinches and breaks.

### Step 8: Retire `JoinSmoother` and `FloorClear` via `AnimationPlayer` crossfades and calibrated knockdown/corner clips
- **Change**: Replace `JoinSmoother` dead-blending with `AnimationPlayer.play(clip, blend_s)` (`blend_s` from `ClipPicker`), replace reverse-played `countdown` (`KnockdownCount.gd:316`) and `FloorClear` with floor-calibrated knockdown/get-up clips, and restrict `CornerIK` to head look-at (`_turn_head`) only.
- **OWNS**: `scripts/fight3d/BoxerBuild.gd`, `scripts/fight3d/JoinSmoother.gd`, `scripts/fight3d/FloorClear.gd`, `scripts/fight3d/CornerIK.gd`, `scripts/fight3d/KnockdownCount.gd`, `scripts/fight3d/CornerMinute.gd`, `scripts/fight3d/FightStage.gd`, `tests/surviving_layers_test.gd`
- **Headless test (FAILS on `main` first)**:
  `godot --headless --audio-driver Dummy --path . --script res://tests/surviving_layers_test.gd`
  *(Asserts a boxer `Skeleton3D` has only `FootPlant`, `CornerIK` [look-at only], and `MetaHumanTwist` [plus `PoseRecorder` in replay], and knockdown `Hips`/elbows stay `>= 0.0m` without `FloorClear`; fails on `main` where 15+ modifiers sit on `Skeleton3D`.)*
- **Fault removed**: Finishes the rebuild — leaves only clip playback + 3 surviving layers (`RingPlace`, `FootPlant`, `CornerIK` look-at) + `MetaHumanTwist`.

---

## 5. RISKS & BJJ EXTENSION

### 5.1 What Gets Worse First During Migration
1. **Short punches missing in air if `PunchReach` is removed before range-matched clips exist (Step 6)**: Today `PunchReach` stretches arms and leans `Chest` `0.30 rad` (`PunchReach.gd:21`) to force punches thrown `0.20m` out of range onto the chin. Deleting `PunchReach` before `ClipPicker` gates strikes by `range_m` (Step 3), steps in with Ailive footwork (Step 4), and adds inside hook/uppercut clips will make hooks fall `0.10–0.27m` short (`RangeBreath.gd:22`). Keeping Step 6 after Steps 3–4 prevents this regression.
2. **Transition pops if `JoinSmoother` is removed before mid-clip cuts stop (Step 8)**: `JoinSmoother` (`0.30–0.45s` dead-blending) masks hard cuts made by `GuardLife`, `SideStep`, and `HitImpact.recover`. Retiring `GuardLife` (Step 3) and `SideStep` (Step 7) first ensures clips reach their matched guard-return pose (`back_s`) before `JoinSmoother` is replaced by `0.08–0.14s` `AnimationPlayer` crossfades in Step 8.
3. **Female torso elbow clipping if `ElbowClear` is removed before re-baking `.res` clips (Step 6)**: Male-captured mocap elbows sit `2–4 cm` inside narrower female ribs (`mh_boxer_01..08`). Baking a constant clavicular outward rest offset in `tools/owned_mocap_bake.gd:324-335` as part of Step 6 keeps elbows clear without runtime IK.

### 5.2 How BJJ (Ground & Scrambles) Fits the Same Picker Later Without Blocking Boxing Now
1. **Stance fields generalise to postural state tags**: `start_stance` and `end_stance` in `ClipLibrary` are plain strings (`"ortho"`, `"southpaw"`). For BJJ, the exact same fields hold discrete grappling states (`"clinch_over_under"`, `"sprawl_top"`, `"closed_guard_top"`, `"closed_guard_bottom"`, `"half_guard_top"`, `"side_control_top"`, `"mount_top"`, `"back_control_att"`, `"scramble"`). A guard pass or sweep is simply a library entry transitioning `start_stance = "closed_guard_top"` -> `end_stance = "side_control_top"`.
2. **Paired captures (`partner_clip`) + shared `sync_anchor` already solve two-body ground coupling**: Ground passes, scrambles, and submissions operate at `range_m = Vector3(0.0, 0.0, 0.35)` with locked relative roots. Step 7's paired clinch machinery (`partner_clip` in `ClipPicker` + shared `sync_anchor` in `RingPlace.gd`) runs two-actor BJJ clips with zero changes to the picker interface.
3. **Surviving layers auto-disable on `"ground"` tag**: When a picked clip carries `"ground"` in `tags`, `FootPlant` (standing ankle pin) and `CornerIK` look-at set `weight = 0.0` (matching `FootPlant.gd:14` on `FREE` clips today), while `RingPlace` (`sync_anchor` + rope clamp) and `MetaHumanTwist` remain active. Boxing ships now with zero BJJ branches; BJJ plugs in later purely as new `ClipLibrary` entries and paired `.res` clips.

RESULT: writers today 25, fighting pairs 16
RESULT: library entries needed 78, have 37, paired captures needed 5
RESULT: migration steps 8; step 1 = Single writer on Head and Neck during landed head punches (stop HitSnap and pro_hit_by_* clips fighting on the head bone)

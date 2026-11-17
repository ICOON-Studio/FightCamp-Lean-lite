# FIGHTPLAYER2 CRITIC REVIEW - Goose (Cloud), Round 1

**Reviewer**: Goose (cloud agent)
**Role**: Game animator who has shipped a fighting/sports game
**Date**: 2026-11-17
**Discipline**: Boxing

---

## What I read

- The brief: `ops/research/FIGHTPLAYER2_CRITIC_S512_BRIEF.md`
- The baseline: `ops/research/FIGHTPLAYER2_BASELINE_S510.md`
- The scope: `ops/research/FIGHTPLAYER2_SCOPE_S510.md`
- The code: `scripts/fight3d/BoxerBuild.gd`, `FightClips.gd`, `JoinSmoother.gd`, `BeatFire.gd`, `BeatClips.gd`, `RangeTable.gd`, `PunchWeight.gd`, `PopCap.gd`, `ArmHome.gd`, `GuardWeave.gd`, `GuardBox.gd`, `ArmClash.gd`, `KneeTrack.gd`, `ElbowClear.gd`, `FloorClear.gd`
- The critic pack: `ops/research/CRITIC_PACK.md`

---

## The diagnosis: do I believe it?

**Yes, mostly.** The baseline's evidence is strong: three builds (RAW, PLACEMENT ONLY, FULL) all score 4.5/4.5 with six blind critics. That is the kind of result that ends arguments. The rulers confirm it: RAW slides 33-37 m a round, FULL slides 0.2-0.4 m, and both score the same. The 24 layers between them buy no point.

The chain the plan names is real. I read `BoxerBuild.gd` and counted 23 layers added in `build()` (the baseline says 26, counting helpers like CornerIK and PoseRecorder that are not in the build function but exist in the folder). The order matches: PunchWeight first, then JoinSmoother, then the guard tuck, the reach, the snap, the pop cap, the glove clear, the arm clash, the knee track, the foot plant, the footwork rig, the floor clear, the foot lock, the floor stand, the fighter life, the twist, the guard box. Each one corrects what the last one broke. The plan's table in section 1c is accurate.

**One claim I could not verify**: "19 of 59 punch files are switched off on score (BeatClips.gd OFF_TAKES)." The OFF_TAKES list has 19 entries, confirmed. But the Punch PRO library has 145 clips (`assets/anim/baked/mc_Box1_M3_*.res`), not 59. Maybe 59 is the number of punch-type clips BeatClips uses (jab, cross, hook, uppercut, body shot takes), but I could not find that count in the code. The plan should say "19 of the punch takes BeatClips considers" or give the total.

**What the code confirms**:
- `FightClips.hold_root_xz` pins every non-travel clip's hips at their first X/Z. Confirmed.
- `JoinSmoother.gd`: DURATION_S = 0.3, HALF_LIFE_S = 0.06. Confirmed.
- `BeatFire.gd`: SHORT_JOIN = Vector2(0.09, 0.35). Confirmed.
- `RangeTable.gd` header: straights reach at 0.91-1.11 m, uppercuts at 0.61-0.70 m. Confirmed.
- `REFERENCE_DISTANCES_S439.md`: Undisputed's uppercut reaches 97% of a straight, ours reaches 65%. Confirmed.
- The layer chain is self-feeding: PunchWeight adds body to the punch, which causes head jumps, which PopCap caps, which means the glove is held by IK, which means the arm hangs out, which ArmHome brings home, which means the free glove is lifted, which GuardBox pulls down. Confirmed.

**What I believe about the cause**: The plan is right. The damage comes from pinning the hips and then re-solving the body onto a target the clip knows nothing about. The footwork rig stops the skating but squashes the stance (knees 146-151 deg -> 125-135) and walks the men into each other (0 -> 22 frames with a head inside the other body). The punch reach puts the glove on the target but causes head jumps (3 -> 24 frames over 12 cm). The layers are patches on patches, and each patch brings its own defects.

---

## The plan: will it work?

**The architecture is sound.** The choreographer (pure module, unit-tested) plans the exchange before it plays: distance plan, take choice, beat slide, body rules, reaction rules. The player (small) plays the timeline: clips with root motion, one joiner, upper-body masks, straight-punch IK, foot lock + rig. This is what Undisputed and Blood & Canvas do, and the studies measured it.

**The phases are in the right order**:
1. Raw-clips baseline (running now) - decides whether the layers or the clips are the problem.
2. Clip census - every owned take measured (contact gap, hip travel, hand home, reaction size, posture flags).
3. Choreographer - the pure module that plans the exchange.
4. v2 player - root motion, one joiner, upper-body masks, straight IK, foot lock.
5. Reactions and defence from owned clips.
6. Gate: v2 must beat today's player by at least 1 point.
7. Delete the replaced layers.
8. Purchase only the rows still empty.

**What I believe will work**:
- The clip census (phase 1). The tools exist (`tools/clip_contact.gd`, `clip_recovery`, `clip_travel`, `punch_pace`). The data is in the baked files. This is a 2-3 day job, and it gives you the ground truth: which takes are bad, which distances each take fits, which reactions are too small. Without this, the choreographer is guessing.
- The choreographer (phase 2). A pure module with unit tests. It reads the beats from `ExchangeBeats.gd` / `BeatFire.gd` and writes a timeline per boxer. The plan's rules are sensible: rest at 1.6-1.8 m, creep to 1.4 m, step in as the punch lands, leave within 1-1.5 s. Pick the take whose contact distance is nearest the planned gap (within 0.15 m). Slide a beat up to 0.25 s. Check every contact against body rules (heads 25 cm apart, head outside the chest, front boots not overlapping). This is buildable and testable.
- The v2 player (phase 3). Root motion (drop `hold_root_xz` for punches, steps and reactions). One joiner (`JoinSmoother.gd` with Undisputed's times). Upper-body masks (Godot's AnimationTree blend nodes). Straight-punch IK (TwoBoneIK3D, Undisputed's limits: up to 0.30 m, lean up to 30 deg, elbow never under 35 deg). Foot lock + rig. This is the core of the rebuild, and it is buildable.
- The gate (phase 5). v2 must beat today's player by at least 1 point on the owner's eye and pass the rulers. This is the right gate. If it does not, stop and re-think.

**What I doubt**:
- **Phase 1b (re-bake the conversion fixes)**. The plan says "only if the baseline blames the conversion." But the baseline's RAW build (clips only, no layers) already scores 4.5. The clips alone on our body scored 7.0 in the turntable (`RETARGET2B_RESULT.md`). So the conversion is not the main problem. Phase 1b should be skipped unless the baseline clearly shows the conversion loses quality. The plan's table in section 1d says "our body worse than the original skeleton = re-bake first," but I do not expect that result.
- **Phase 4 (reactions and defence from owned clips)**. The plan says 3-4 days. The clip gap list (section 4) shows we own ~14 head reactions but few light ones, 3 gut-shot folds but no side, Punch PRO block hits but they are off on score (rear glove over the head). The plan says "fix the owned three in the bake" and "owned Mixamo" for the rest. But fixing clips in the bake is not a 3-4 day job if you need to watch every take, judge it, fix it, re-bake it, re-census it. This phase is underestimated.
- **The purchase (phase 6)**. The plan says "only the rows still empty, previews watched, baked, censused." The gap list shows we need: 2 longer uppercuts, 1 more rear hook, 4 inside-range punches, 2 more stepping punches, 4-5 body punches, 2 guard-stopped punches, ~4 light head reactions, 2 uppercut reactions, 1-2 side reactions, 3 body reactions, 3-6 block flinches, 4 stumbles, 6-8 slips/ducks/pull-backs/parries, 3-4 guard styles + dazed idle, 2-3 knockdowns to a knee. That is a lot. The animo pack (EUR 58.57, 67 clips) covers some, but the plan says "no pack lists range takes" for inside-range punches. The purchase may not close the gaps.
- **The ceiling**. The plan says "one-man clips joined well reach about 7-7.5 by the r14 animator's own estimate; 10 needs two men captured together." This is the hard truth. The plan builds v2 with owned clips, gates it at +1 point (so 5.5 instead of 4.5), and then the purchase fills in. But 5.5 is not 7. The plan's section 7 says "the ceiling: one-man clips joined well reach about 7-7.5." So even if v2 works perfectly, it caps at 7.5. That is the animator's estimate, and I believe it. Two-man captures are the only route past 7.5, and the plan says "no pack found; our own capture." That is a later phase, not in this scope.

---

## The order and size: is it right?

**The order is right.** Baseline first (decides the cause), census second (gives the ground truth), choreographer third (the pure module), player fourth (the integration), reactions fifth (the owned clips), gate sixth (the decision), delete seventh (the cleanup), purchase eighth (the gaps). This is the right order.

**The size is mostly right, with one underestimate**. The plan says "about 3-4 weeks of sessions to the gate with owned clips." Phase 1 (census) is 2-3 days. Phase 1b (re-bake) is 2 days, but I would skip it. Phase 2 (choreographer) is 3-4 days. Phase 3 (player) is 1 week. Phase 4 (reactions) is 3-4 days, but I think it is 1-2 weeks (see above). Phase 5 (delete) is 2 days. Total: 3-4 weeks if phase 4 goes well, 4-5 weeks if it does not. The plan's estimate is optimistic but not wrong.

**The effort is right for a cloud team**. The choreographer is a pure module, so Arena or Goose (cloud) can build it. The player integration is Claude (PC). The reactions are Claude + PC seat. The purchase is the owner buys, Claude bakes. This is the right split.

---

## The deleted layers: which would I keep?

The plan's table in section 1c lists every layer and its fate. I agree with most:

**DELETE (I agree)**:
- PunchWeight (root motion kept) - yes, the clip's own travel replaces this.
- RkJoinFeet (route off since S432) - yes, dead code.
- GuardWeave (critics: "weaves at nothing") - yes, idle clips instead.
- PopCapPre, PopCap (keep as a ruler and test bar) - yes, the choreographer's body rules replace this.
- ArmHome (clip's own recovery, control back at contact + 0.13 s) - yes, the clip's tail blends out.
- HitSnap (DELETE once reactions are sized clips) - yes, but keep until block clips exist.
- GloveClear (REPLACE by a check at plan time) - yes, the choreographer's body rules.
- ArmClash (DELETE, plan-time check) - yes.
- GuardBox (DELETE) - yes, the choreographer's body rules.
- BlockCatch (REPLACE by block-flinch clips) - yes.
- HitStep, HitStun, HitImpact (REPLACE by reaction clips with root motion) - yes, but keep hit-stop as an option.

**KEEP (I agree)**:
- JoinSmoother (the one joiner) - yes.
- FighterLife (KEEP eyes/face/breath, drop its stance edits) - yes.
- FootPlant + FootLock + FloorStand (MERGE into one foot lock) - yes.
- WalkPure (keep with the walk) - yes.
- BoxerFootworkRig (KEEP for steps between punches) - yes.
- FloorClear (KEEP until the knockout clips are fixed in the bake) - yes.
- MetaHumanTwist (KEEP, skin not motion) - yes.
- IdleMatch, ShownRoot, SideStep, MirrorClip (KEEP) - yes.

**REPLACE (I agree)**:
- GuardTuck (REPLACE by guard-style idle clips) - yes.
- PunchReach (REPLACE by one straight-punch IK with Undisputed's limits) - yes.
- RangeTable, RangeLive, UpperRoom, PunchRange, RangeBreath (REPLACE by the choreographer) - yes.

**MOVE INTO THE BAKE (I agree)**:
- ElbowClear (elbow sinking into a narrower torso) - yes.
- KneeTrack (knees caved by the conversion) - yes.

**One I would keep at runtime**:
- **TiredSag**. The plan says "keep only if the owned tired idles do not read." But the owned tired idles are 4 clips (`ANIMATION_GAPS_S439.md` 8a), and they are unused. The plan's phase 4 says "hurt state: the three owned hurt idles (owned, never played)." So the tired idles are not played today. TiredSag is a procedural layer that folds the trunk and hangs the head when the boxer is tired. If the owned tired idles do not read (and they are not played), then TiredSag is the only thing that shows fatigue. I would keep it until the tired idles are wired and judged. The plan's "keep only if" is right, but the "if" is not met yet.

---

## The clip rows that matter most for 7/10

The plan's gap list (section 4) has 15 rows. Which matter most for reaching 7/10?

**The top 5**:
1. **Head reactions by side and strength**. The plan says we own ~14 but few light ones (most 12-28 cm). The critics ask for jab 8-12 cm, cross 18-25, hook 20-30. The owned reactions are mostly medium and heavy. Without light reactions, a landed jab looks like a landed cross. This is the first thing the owner will notice.
2. **Stepping punches (35-63 cm)**. The plan says we own the _FT jab, cross, both hooks (some off on score). The critics ask for distance per punch: a straight arm at contact, reached with a step. Without stepping punches, every punch is thrown from the same distance, and the men never close the gap. This is the second thing the owner will notice.
3. **Body punches**. The plan says we own body hook and kidney shot, need 4-5 more (body jab, body cross, rear body hook, body uppercuts). The owner said S305: "body shots do not seem to have any impact." The owned gut shots barely move the boxer (the baseline's S371 scratch probe). Without body punches that fold the boxer, the body is just another target for head punches.
4. **Block flinches (blocked punch rocks the man)**. The plan says Punch PRO Block_Straight_Hit v1-3 are off (rear glove over the head). The critics ask for a block and a miss that look different from a hit. Without block flinches, a blocked punch looks like a miss (the boxer does nothing) or a hit (the boxer reacts). This is the third thing the owner will notice.
5. **Slips, ducks, pull-backs facing the man; parries**. The plan says we own 6 dodges/weaves but they turn the back. The critics ask for defence that answers a punch. Without slips and ducks that face the man, the defence looks like running away.

**The rows that matter less (for now)**:
- **Inside-range punches (body moves 1-3 cm)**. The plan says no pack has them. The critics ask for them, but the plan's ceiling is 7.5 with one-man clips, and inside-range is the hardest to fake. This is a later phase.
- **Two men captured together**. The plan says this is the only route past 7.5. This is not in this scope.
- **Footwork (long takes)**. The plan says the procedural rig is honest, and long takes are only if the motion-matching trial runs. The critics ask for footwork, but the owned procedural rig is the right answer for now.
- **Guard idles by style, dazed idle**. The plan says we own 1 Punch PRO guard, 8 fidgets, 3 hurt idles (unused), 4 tired. The critics ask for 3-4 styles + dazed. This is polish, not the core.

---

## The ruler bars: are they right?

The plan's ruler bars for phase 3 (from the r14 critics):
- Head jumps over 12 cm in one frame: 0 outside a contact frame (14 today).
- Arm at full stretch at most 2 frames (4 today).
- Head inside the other body: 0 frames (3).
- Distance between exchanges: 1.5-1.8 m (1.34).
- Stance after a punch at most 1.3 x its rest length.
- Reactions ordered jab < cross < hook in head travel.

**These are right.** The baseline's rulers show the problems: 14 head jumps, 4 frames of full stretch, 3 frames of head inside body, 1.34 m distance. The bars are the critics' asks, and they are measurable. The plan's "0 outside a contact frame" is the right bar for head jumps: a contact-frame jump is the punch's body, not a pop.

**One bar I would add**: foot slide. The baseline shows RAW slides 33-37 m a round, FULL slides 0.2-0.4 m. The bar should be: foot slide under 1 m a round. The foot lock + rig should hold this, but the bar makes it explicit.

---

## The risks: what would stop or change the plan?

The plan's section 7 lists the risks. I agree with most. **The one I would add**:

**The choreographer's take choice may not fit the distance.** The plan says the choreographer picks the take whose contact distance is nearest the planned gap (within 0.15 m). But the clip census (phase 1) may show that the owned takes do not cover the distance range. For example, if the planned gap is 1.4 m but the owned jabs reach at 0.91-1.11 m, the choreographer must either step in (a visible step) or use a stepping take (if we own one). If we own neither, the choreographer picks the closest take and the IK finishes the job, but the IK may be over 0.30 m (Undisputed's limit), and the arm looks wrong. The plan's section 3c says "if none fits, the footwork gets there first (a step the viewer can count), or a stepping take is used." But if we own no stepping take for that punch, the choreographer must step in, and the step must be visible and natural. This is buildable, but it is a constraint the choreographer must respect: never pick a take whose IK would be over 0.30 m.

---

## To reach 10/10

The plan scores 7/10 on "will it work" and 8/10 on "order and size." What would take it to 10/10?

**Most important first**:

1. **Add a foot slide ruler bar.** The baseline shows foot slide is the difference between RAW (33-37 m) and FULL (0.2-0.4 m). The plan's ruler bars do not include foot slide. Add it: foot slide under 1 m a round. This makes the foot lock + rig's job explicit and measurable.

2. **Clarify the "19 of 59 punch files" claim.** The OFF_TAKES list has 19 entries, but the Punch PRO library has 145 clips. The plan should say "19 of the punch takes BeatClips considers" or give the total. This is a small fix, but it matters for the critic who checks the code.

3. **Phase 4 (reactions and defence) is underestimated.** The plan says 3-4 days. The clip gap list shows we own ~14 head reactions but few light ones, 3 gut-shot folds but no side, Punch PRO block hits but they are off on score. Fixing clips in the bake (watch every take, judge it, fix it, re-bake it, re-census it) is 1-2 weeks, not 3-4 days. The plan should say 1-2 weeks for phase 4, or split it into 4a (fix owned clips) and 4b (wire the pools).

4. **Phase 1b (re-bake the conversion fixes) should be skipped unless the baseline clearly blames the conversion.** The baseline's RAW build (clips only) scores 4.5, and the turntable scores 7.0. The conversion is not the main problem. The plan's table in section 1d says "our body worse than the original skeleton = re-bake first," but I do not expect that result. If the baseline shows the conversion loses quality, then phase 1b runs. Otherwise, skip it and save 2 days.

5. **The choreographer must never pick a take whose IK would be over 0.30 m.** The plan's section 3c says "if none fits, the footwork gets there first, or a stepping take is used." But if we own no stepping take, the choreographer must step in, and the step must be visible. Add a rule: the choreographer's take choice must have IK under 0.30 m (Undisputed's limit). If no take fits, the choreographer steps in (a visible step the viewer can count) before the punch. This is buildable and testable.

6. **TiredSag should be kept until the tired idles are wired and judged.** The plan says "keep only if the owned tired idles do not read." But the owned tired idles are not played today. TiredSag is the only thing that shows fatigue. Keep it until phase 4 wires the tired idles and the owner judges them.

7. **The purchase may not close the gaps.** The gap list shows we need inside-range punches, and the plan says "no pack lists range takes." The animo pack covers some rows, but not inside-range. The plan should say: if the purchase does not close the inside-range gap, inside-range punches are a later phase (our own capture or Cascadeur edit). The gate (phase 5) should not wait for inside-range punches.

8. **The ceiling is 7.5 with one-man clips.** The plan's section 7 says "one-man clips joined well reach about 7-7.5 by the r14 animator's own estimate; 10 needs two men captured together." This is the hard truth. The plan builds v2 with owned clips, gates it at +1 point (so 5.5 instead of 4.5), and then the purchase fills in. But 5.5 is not 7.5. The plan should say: v2 with owned clips reaches 5.5-6.0, v2 with the purchase reaches 6.5-7.0, and 7.5 needs two-man captures (a later phase). This sets the owner's expectations.

---

## Scores

SCORE will_it_work=7
SCORE order_and_size=8

---

## Summary

The plan is sound. The diagnosis is right: the damage comes from pinning the hips and re-solving the body onto a target the clip knows nothing about. The architecture (choreographer + player) is what Undisputed and Blood & Canvas do, and the studies measured it. The phases are in the right order, and the effort is right for a cloud team.

The plan scores 7/10 on "will it work" because:
- Phase 4 (reactions) is underestimated (3-4 days should be 1-2 weeks).
- The purchase may not close the inside-range gap.
- The ceiling is 7.5 with one-man clips, and the plan does not set the owner's expectations clearly.

The plan scores 8/10 on "order and size" because:
- The order is right (baseline, census, choreographer, player, reactions, gate, delete, purchase).
- The size is mostly right (3-4 weeks to the gate), with one underestimate (phase 4).
- The effort split is right (cloud builds the choreographer, PC integrates the player).

To reach 10/10: add the foot slide ruler bar, clarify the "19 of 59" claim, fix the phase 4 estimate, skip phase 1b unless the baseline blames the conversion, add the choreographer's IK limit rule, keep TiredSag until the tired idles are wired, say the purchase may not close the inside-range gap, and set the owner's expectations on the ceiling (5.5-6.0 with owned clips, 6.5-7.0 with the purchase, 7.5 needs two-man captures).

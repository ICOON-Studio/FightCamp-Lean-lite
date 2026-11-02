---
name: project_retarget_quality_is_the_bottleneck
description: "Operator said the retargeted clips look bad (2026-09-12). Pose right (0.15 deg); strikes carry hip travel (087a3c9); the foot lock MERGED b73ca90 (R3 0.172 -> 0.114, releases capped at the unplant radius) and the operator saw no difference (2026-09-14). U94: no skeleton-space splice of the mirrored hook works - bind a real rear hook"
metadata: 
  node_type: memory
  type: project
  originSessionId: 2e96d4ea-3292-48e0-abf9-61469f27415c
  modified: 2026-09-14T01:09:22.702Z
---

**SUPERSEDED FOR STRIKES 2026-09-24 (S65, Codex C189 control arm): the retarget is NOT the bottleneck.** Our fighter playing an owned RamsterZ clip WHOLE matches the vendor mannequin (ankle 6.6 vs 6.6 m/s, wrist 16.6 vs 19.5). The live room's engine-owned placement + walk-layer splice is #1 (ankle 53-75 m/s; engine_positions off -> 5.6-6.7), seek/cut #2. See [[project-preview-quality-ruling]]. The history below stays for the foot-lock and mirror findings.

**2026-09-14 (early morning) - THE FOOT LOCK, BUILT ON A BRANCH, NOT MERGED.**
- `claude/s4a-footlock` `f74cd54` (pushed): FightFootLock.gd (Unreal 5.8 Foot Placement rules read from its source,
  [[reference_unreal_source_on_pc]]) + FightLegIK.gd (master) + FightStagePlayer wiring. `-- lock=off` is byte-identical
  to master; lock on R3 0.172 -> 0.117 m/s (joins 0.574 -> 0.359). Before merge: explain the 0.98 m worst
  shown-v-animated error, 6% short-of-reach frames, R5b legs 2.09x -> 2.11x, pictures, subsets. The roadmap's `now`
  holds the exact order.
- What the lock cannot fix: react_body staggers travel 0.4-1.4 m in the source (U92) - U89 must move the body; and
  hook_rear's stance swap (1.32 m/s joins). U93: copying the mirror's Spine-up TRACKS over unmirrored hips flips the
  torso 128-178 deg - build the upper-body mirror from GLOBAL rotations, or bind Fighting Motions' bp_hook_right_A
  (Q100: that rig maps 21/22 bones, BlueGuy.fbx is its rest). K47: no shipped game documents whole-body mirroring.

**2026-09-14 (day) - STRIKES CARRY THEIR HIP TRAVEL, AND WHAT IS LEFT.**
- Landed `087a3c9`: `FightStagePlayer.STRIKER_SWAY_ROLES` (only takes whose source hips RETURN carry). Realism R3
  0.218 -> 0.172 m/s, every other rule byte-identical. The RamsterZ punches STEP IN: pinned hips slid the rear foot
  back (triptych `rest=sway`, sent to the operator). The reach it adds did NOT put fists through heads: at their
  CLOSEST (one frame before `_contact_s`) straights reach touch distance, hooks stop ~6 cm short (C113 + Q97).
- **Next build: the foot lock**, as a GDScript analytic two-bone solve after the joins and before `_ground`, fed by
  `FightFootContacts` (C114) per take per foot, toe-locked (K44). `TwoBoneIK3D` exists in 4.7.2 but does nothing in
  a test stepped inside `_initialize`, so every gate would be blind to it ([[project_godot_skeleton_pose_traps]]).
- **Walking cannot replace it:** moving bodies only while a walk plays ended the slide but raised R3 to 0.224 -
  5-20 cm range fixes last shorter than the 0.27 s blends, so the walks are crossfade (U89, parked). A steady walk
  at a matched rate skates only 0.03 m/s.
- **Joins (R5):** the over-bound windows are returns to stance (a near-static guard hold is the reference) and the
  MIRRORED hook: `hook_rear` starts right-foot-forward against a left-foot-forward stance, so entering it swaps the
  feet (U90, U91 77 deg, Q98). Fix direction: mirror only its upper body (K45: AnimationTree filter at Spine).

**2026-09-14 VERDICT - RETARGET BAKE-OFF 1 (`research/BAKEOFF_BLENDER_RETARGET.md`).** One instrument,
`tools/measure_retarget_bakeoff.gd`, run on f01 with the lead hook and the body stagger:
- **The pose is right.** Production's silhouette retarget copies joint angles within 0.15 deg and facing within
  1-3 deg. Blender 5.2.1 + Retarget add-on managed 9-15 deg and 5-32 deg. The 7.21 deg figure below predates the
  silhouette rest.
- **The skate is ROOT MOTION.** Our pose holds the hips still. Production plus the source's scaled hip travel cuts
  planted-foot skate from 0.81 to 0.12 m/s (hook) and 0.94 to 0.17 (stagger); the source shows 0.015.
- **Next build step:** carry the source hips' travel in production for strikes as well as staggers.
- **The residual is proportion:** a foot-plant IK pass, and the only place Unreal's IK Retargeter could still help.
So of the four causes below, the axis correction is solved and root motion is the live one; skinning is still
unmeasured. [[reference_pc_animation_tools]]

**The operator watched the retargeted RamsterZ clips in the Animation Lab and
said they look "pretty bad" (2026-09-12).** That is the current ceiling on the
whole 3D fight, and it is not a clip-supply problem.

**ANIMATION PURCHASES ARE ON HOLD.** Melee Counters (EUR 27.59), Judo AnimSet
(EUR 110.40) and Wrestling Finisher (EUR 110.40) are all the same
UE4-Mannequin source through the **same retarget**, so buying any of them buys
the same problem. The one exception worth weighing separately is **20 Fighters
(EUR 36.79)** - that is BODIES not animation, and it closes R111's recorded gi
gap (`Judoka_1`, `Karateka_1`, `Kickboxer_1`). All pricing is in
`research/R140_THE_JUDO_ANIMSET.md`.

**Why:** `FightClipRetarget` reports itself as working - **mean error 7.21 deg
across nine joints** on the corrected path against 31.77 uncorrected - and that
is still not small on a shoulder or a hip, with the worst joint unrecorded. The
file names its own failure mode: *"IT DOES NOT ERROR. IT DOES NOT FAIL A
COVERAGE COUNT. IT JUST LOOKS BROKEN."* Another measured-vs-seen gap, per
[[feedback_assert_the_quantity_the_user_sees]].

**How to apply - four causes, four different fixes, diagnose before spending:**
- limbs bending wrong / joints inverted -> residual per-bone **axis correction**. Cheap.
- **punches not reaching or passing through** -> **proportion mismatch**. We
  retarget rotations only, no IK, and Tripo bodies are not Mannequin-proportioned.
  Needs IK, not calibration.
- feet sliding, no weight -> **root motion discarded**; R118 drives position from
  the engine's range band. Locomotion wiring, not the clip.
- shoulders/hips collapsing, mesh pinching -> **Tripo auto-rig skinning weights**.
  That is the MODEL, and no purchase or calibration fixes it.

Diagnose in the Animation Lab first - it renders in seconds and shows exactly
what a bought UE4-Mannequin clip looks like on our fighters:
`Godot_v4.7.2-stable_win64.exe --path Godot res://scenes/FightAnimLab.tscn`

Tracked as **S4a** in [[project_roadmap_and_opsboard]], placed in stage B ahead
of every other animation session.

**And a second confirmation of a standing rule:** the Judo AnimSet on FAB is
EUR 123-308 **and** says "Allows usage with AI: No", while the Unity copy is
EUR 110.40 under the Standard Unity Asset Store EULA. Buying on the alternative
storefront would cost more for a strictly worse licence - exactly what R105
found with RamsterZ, now true on a second publisher. **Buy on Unity, never the
other store.**

**Update 2026-09-14 (morning):** the lock merged; the operator's worst-on-screen list moved the priority to spacing, joins and punch contact - see [[project_operator_verdict_foot_lock_2026-09-14]].

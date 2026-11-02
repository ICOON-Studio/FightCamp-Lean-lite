# John reply via xAI API (model grok-4.7, route responses+web_search (stream), 21762 chars, 209 s)
# Task: research/AUDIT_ANIM_S224.md

I'll audit the MetaHuman animation failures against real skeleton conventions, retarget practice, and studio pipelines, and ground every number in a source.The models are not broken. The right-foot ballet is the Unreal right-side axis convention being fed a local rotation that was computed for a rig that does not use that convention. The 49 writers are why the last ten sessions cannot make a fix stick. They are not why the right sole fails on every body and the left sole does not.

Gate numbers below are the operator’s S224 FLYFOOT2 gate (2 seeds × 4 bodies × 60 s), not a published study. File facts are from the brief and from Claude’s GLB read. Everything else is sourced.

## 1. Root cause, ranked

### 1. A local rotation is applied in one axis convention to both sides. Correct on the left, inverted on the right.

This is the FLYFOOT cause. It is also the wrist bend and the “right hip lands 137° wrong” comment. Same mechanism, three bones, three patches.

Unreal’s mannequin, and MetaHuman because it uses that structure, does not share one bone-axis convention across the body. Positive X is the bone direction, and the right side is inverted on all axes relative to the left. The foot is a special case of that rule: the left foot’s X points straight up, and the right foot is inverted again so its X points straight down. [[1]](https://github.com/xavier150/Blender-For-UnrealEngine-Addons/wiki/UE-Bone-Structure-and-UE-Mannequin) The same export path states it as an explicit option, “Revert direction of symmetry right side bones,” because the engine’s own mirror tools assume the opposite-side bones have all axes inverted. [[1]](https://github.com/xavier150/Blender-For-UnrealEngine-Addons/wiki/UE-Bone-Structure-and-UE-Mannequin) People who mirror the mannequin at runtime have had to put a 180° Z rotational offset on the thighs or the mirror does not work. [[2]](https://www.youtube.com/watch?v=wVWzAYAQjpU) A MetaHuman-template author hitting the same skeleton reported the expected hand result in so many words: X+ down the joint on the left, X− on the right. [[3]](http://forum.mgear-framework.com/t/mh-template-building-right-hand-metacarpals-jointorients-incorrecltly/3076)

Claude’s rest measurement on `mh_boxer_05`, `mh_boxer_08`, and native `mh_jab.glb` is that convention, not an import glitch:

- `foot_l` X ≈ (0, +1, 0.03) — X up
- `foot_r` X ≈ (0, −1, −0.03) — X down

The 0.03 is about 1.7° of rest slope (ESTIMATE: atan2(0.03, 1.0)). It is not a 55–88° bug. Thigh, calf, ball, and hand show the same left/right pattern. The three files match, so this was authored into the MetaHuman export. It survived GLB. It is identical on every body, which is why the gate fails on every body.

Mixamo and most library rigs do not do this. Both legs share one axis convention. A retarget that maps 22 bones by name and then copies a local rotation (or a local-axis delta) without conjugating by the per-bone rest-basis difference will be right on the left foot and sign-flipped in pitch/roll on the right foot. Unreal’s own retargeter has a mode that does exactly that mistake on purpose: Copy Local copies the source local rotation and ignores the retarget pose. [[4]](https://dev.epicgames.com/documentation/unreal-engine/BlueprintAPI/Utilities/Struct/MakeRetargetFKChainSettings?lang=en-US) Your retargeter header already recorded the hip instance of this: without a special case, the right hip lands 137° wrong. 137° is the same family as the documented 180° Z inversion, minus whatever bind/A-pose residual that one-bone patch was cancelling. It was patched for the hip only. The foot got a later, different patch (`sole_rest_retarget`). The wrist never got one, which is why eight glove sessions left the wrists bent.

The gate is the signature, not noise:

| | Left sole | Right sole |
|---|---|---|
| Max tilt | 31–38° | 55–88° |
| Frames outside band | 1.5–12% | 94–97% |
| Bodies | every body | every body |
| Gait (slide, cross, airborne) | green | green |

A proportion error varies across 12 body sizes. A bad clip fails both feet, or fails differently per clip. A probe bug in world space from skinned sole vertices would not draw a clean left/right line that also matches the hand axes and the hip comment. This line is an axis-sign line.

Godot 4 makes the mistake easy to write. Since 4.0, a bone pose includes the bone rest. In Godot 3 the pose was relative to rest. [[5]](https://docs.godotengine.org/en/latest/tutorials/assets_pipeline/retargeting_3d_skeletons.html) A delta composed the Godot 3 way, or a source local quaternion dropped straight onto a MetaHuman bone, bakes the rest mismatch into the pose. Godot’s importer can also erase the mismatch on purpose: Overwrite Axis rewrites rests to the humanoid profile, and the docs say that produces horrible results when the original rest was set externally and matters. [[5]](https://docs.godotengine.org/en/latest/tutorials/assets_pipeline/retargeting_3d_skeletons.html) That profile is T-pose, facing +Z, +Y from parent to child, +X as the bend axis, same rule on both sides. [[6]](https://docs.godotengine.org/zh-tw/4.x/tutorials/assets_pipeline/retargeting_3d_skeletons.html) That is the opposite of the Unreal foot. The S223 fix yaws the target rest basis for LeftFoot and RightFoot the same way and then zeroes `forward.y` in the plant. That is another shared local operation on two bones whose local frames are mirrors of each other. It is why the left sole mostly entered the band and the right sole got worse.

**Proves it**

1. Writers off, `sole_rest_retarget` off, hip 137° correction off. Play `mh_guard_pose` (native, no retarget) and one library walk on the same body. World-space sole probe, same gate.
   - Native flat on both feet, library walk pointed on the right only → the retarget math. Models and probe cleared.
   - Both pointed with writers off → rest or skin, not the retargeter. Claude’s GLB read already makes this unlikely; confirm by comparing `Skeleton3D.get_bone_rest()` in the running scene to the GLB rest. If they match, import did not rewrite axes.
2. In `FightClipRetarget`, log per foot and per wrist the angle between source rest bend-axis and target rest bend-axis, and the source local delta versus the target local delta. A right-side rest angle near 180° (or near the 137° the hip patch already admits) plus a target delta that is the source delta with pitch/roll sign flipped, is the bug. Codex can confirm the compose is one function for both sides, with a hip special case and a foot special case and no per-bone rest conjugation. I have not read the 1,511 lines; the header and the S223 description are enough to rank this first, not enough to quote a line.

**Disproves it**

- Native clips, writers off, show the same 94–97% right-sole failure. Then it is not the retargeter.
- The logged right-foot rest-basis angle is a few degrees, not ~180°, and the target delta matches the source delta in the target’s own bend axis. Then hypothesis 1 is wrong and the plant or a writer is manufacturing the point.
- The failure swaps feet when the orthodox stance swaps lead foot, and only on some clips. Then it is stance logic, not axes. The gate says every body, and the crop shows rear = right up on the toes, so this disproof is currently losing.

### 2. Forty-nine pose writers and a growing switch stack. This is why every round ends red. It is not why the right foot is the one that fails.

`FightStagePlayer.gd` is 6,499 lines, 259 functions, 13 switches, 49 direct pose writes, on top of a 1,511-line retargeter and a 302-line plant. Twenty-three commits to those three files in fourteen days. Each round adds a layer (`sole_rest_retarget` is the latest) instead of removing one. That is a control problem, not a skeleton problem.

It explains the session history that is not a clean left/right split: gloves and wrists over eight sessions, neck buried in the thorax (fixed only at S223), guard roll and face clearance still open, jab contact still three WIP commits, a profile camera tuned for twelve rounds. Those are writers fighting the clip and each other. A writer fight is noisy and clip-dependent. It cannot, by itself, put the right sole outside the band on 94–97% of frames of every body while the left sole is mostly inside and gait stays green.

**Proves it:** freeze every `set_bone_pose` / global-pose / hand-writer path and both foot switches. If guard, wrists, contact, and neck regress or improve as a group, the writers were load-bearing hacks. If the right-sole number does not move, the writers were never the FLYFOOT cause.

**Disproves it as the FLYFOOT cause:** already disproved as primary by the lateralization. It stays ranked second because it will re-break whatever axis fix you land if the plant and the hand writers keep writing local corrections in the old frame.

### 3. Library clips on the wrong skeleton are a quality ceiling, not this bug.

You have about 500 bought clips (UE4 mannequin / Mixamo / UAL / mocap) and five native MetaHuman clips. Retargeting rotations across proportions works in principle — an elbow at 40° is 40° on a short forearm or a long one — but hip height, stride, and contact are distances, and they do not survive a naive map. [[7]](https://rigbake.com/guides/retarget-mixamo-animations/) Mixamo-to-MetaHuman in Unreal still needs a matched retarget pose, preferred bend angles per limb, and per-chain IK tweaks; elbows, wrists, and fingers are the usual casualties, and they show up on both sides. [[8]](https://dev.epicgames.com/community/learning/tutorials/vjXW/unreal-engine-animation-retargeting-in-ue-from-mixamo-to-metahuman-icvr) [[9]](https://forums.unrealengine.com/t/ue5-mannequin-metahuman-retargeting-deformation-ik-rig/541543) MetaHuman is not the mannequin: five spine bones against the mannequin’s three, plus twist and corrective joints the library clips do not have, and the IK virtual bones (`ik_foot_l/r`, `ik_hand_l/r`) are absent unless you add them. [[10]](https://jamesroha.substack.com/p/inside-the-metahuman-an-intermediate) Early MetaHuman body rigs were published as 128 deforming joints and 150 joints total, with twist driven by a procedure rig and volume correctives driven by RBF: 14 pose drivers, 58 driven joints, 104 poses. [[11]](https://www.youtube.com/watch?v=X3QILs0tkYs) Head LOD 0 is a separate 713 joints. [[12]](https://dev.epicgames.com/documentation/metahuman/platform-support-and-lod-specifications-for-metahumans?lang=en-US) The “341” in the brief is your export count, not an Epic spec. Those helper joints should not be receiving Mixamo tracks. Leaving them at rest costs volume. Driving them with a copied local rotation costs candy-wrapper. Neither produces a right-only 55–88° sole pitch.

So hypothesis 3 is real as a ceiling. It is not the red gate. Bad source motion fails both feet. This gate fails one side, on every body, including bodies the five native clips were built for.

**Proves it as a ceiling, later:** after the axis fix, the same gate on a native jab versus a retargeted jab. If soles match and the retargeted jab still has late contact, collapsed guard, and hands through the chest, the clip source is the remaining problem. That is PAIRLIVE and ANIMSOURCE, not FLYFOOT.

**Disproves it as the FLYFOOT cause:** already disproved if native clips are clean and the right foot only points on retargeted clips.

## 2. What is not the cause

**The MetaHuman meshes and the 12 body sizes.** The failure rate does not move with size or sex. A proportion bug would. Epic ships one `metahuman_base_skel` and retargets between bodies offline; different heights are a retarget-pose problem, not a broken rig. [[13]](https://dev.epicgames.com/documentation/metahuman/retargeting-animations-between-metahumans-in-unreal-engine-5?lang=en-US) [[10]](https://jamesroha.substack.com/p/inside-the-metahuman-an-intermediate)

**Godot’s GLB importer flipping the right side.** The flip is in the GLB, identical on three files, and it is the documented Unreal convention. [[1]](https://github.com/xavier150/Blender-For-UnrealEngine-Addons/wiki/UE-Bone-Structure-and-UE-Mannequin) Import destruction is still worth a ten-minute check (`get_bone_rest()` versus the GLB), because Overwrite Axis and the rest fixer exist and are dangerous on this skeleton. [[5]](https://docs.godotengine.org/en/latest/tutorials/assets_pipeline/retargeting_3d_skeletons.html) It is not the leading explanation of a file that already contains the correct flip.

**The sole probe.** It measures skinned sole vertices in world space. That is the right instrument. A wrong probe would not agree with the crop (rear = right, up on the toes, left roughly flat) across every body.

**Centimetres versus metres.** glTF is metres, Unreal is centimetres; a missed conversion is a 100× scale, a character lying down, or a 90° up-axis error, not one foot pointed. [[14]](https://www.tripo3d.ai/blog/export-skeletons-pivot-root-motion-units)

**The +2 cm MetaHuman floor offset.** Characters built in UE 5.5 or earlier carry a +2 cm skeleton offset that assumed a shoe sole; 5.6 removed it and standardized on barefoot. [[15]](https://dev.epicgames.com/documentation/metahuman/base-skeleton-offset-update?lang=en-US) That is a 2 cm plant-height error. It is not 55–88° of sole tilt, and it is not one-sided. Keep it on a list for plant height. Do not let it generate another switch.

**A-pose versus T-pose, as the FLYFOOT cause.** Mixamo is T-pose, the mannequin and MetaHuman are A-pose. That delta is a known symmetric shoulder and arm error. [[8]](https://dev.epicgames.com/community/learning/tutorials/vjXW/unreal-engine-animation-retargeting-in-ue-from-mixamo-to-metahuman-icvr) [[16]](http://www.gitmemories.com/index.php/AmyangXYZ/Mixamo-MMD) It does not point only the right foot. It is part of why a runtime name-map retarget will never look broadcast-clean. It is not this gate.

**Root motion.** A root error slides, floats, or yaws the whole fighter. Gait is already green. Root motion cannot lateralize to the right sole.

**The 341 helper, twist, and corrective joints, as the FLYFOOT cause.** They are a deformation system. Epic does not animate them from the clip; a procedure rig drives twist, and an RBF drives correctives. [[11]](https://www.youtube.com/watch?v=X3QILs0tkYs) Turning translation retargeting to Skeleton mode in Unreal is known to disable those corrective translations. [[17]](https://www.youtube.com/watch?v=R6AuXFpUJUE) Wrong twist looks like a candy-wrapper calf. It does not pitch one sole 94–97% of the time. Do not retarget tracks onto joints the source clip does not have. That is a follow-on, not the first fix.

**PROFILE2.** Twelve rounds of camera tuning, and the test said “face OK” on a side profile. The test cannot see the face. That is a bad oracle. It is the same process failure as a green gait gate beside a red sole gate, and it is not an animation-math bug.

**“Codex cannot code.”** Ten sessions of red are what you get when each fix adds a local correction in the wrong space. The hip patch, the foot patch, and the wrist non-patch are one incomplete diagnosis applied three times.

## 3. The one fix to do first, and how to prove it

Do not add a switch. Do not touch the plant.

Freeze, on one branch, every direct pose write, `sole_rest_retarget`, and the right-hip 137° special case. Then change the retarget compose for paired limb bones only (hip, thigh, calf, foot, ball, clavicle, upper arm, lower arm, hand — fingers in the same change if they share the function). Take the source rotation as a model-space delta from the source rest, and write that delta into the target bone’s own rest basis. That is the operation Godot added `RetargetModifier3D` to do: read the pose relative to the source rest in model space, write it onto a child skeleton that keeps its original rest. It shipped in 4.4 so that retargeting would stop discarding externally authored rests. [[18]](https://github.com/godotengine/godot/pull/97824) [[19]](https://godotengine.org/article/inverse-kinematics-returns-to-godot-4-6/) You are on 4.7.2, so the modifier exists. Using it for this one compose is better than a fourteenth hand-rolled correction, provided the bone map is name-correct and you do not enable Overwrite Axis on the MetaHuman import.

Leave twist, corrective, and facial joints at rest. Do not yaw any rest basis. The rest is the convention. Rotating it to hide a sole slope deletes the information the next writer needs.

**Proof, same gate, no new metric.** 2 seeds × 4 bodies × 60 s, world-space sole probe, writers still frozen so they cannot launder the result.

Pass:

- Right sole outside-band falls from 94–97% into the left foot’s band (≤12%, and both should land well under that if the band is a real flat-foot band).
- Right max tilt falls from 55–88° into the left’s 31–38°, or lower.
- Left sole does not regress.
- On the same frames, right wrist bend drops the way the right sole did. If the foot passes and the wrist does not, the compose was not applied to the arm chain. That confirms the mechanism and tells you the patch was incomplete. It is not a new bug.
- Native `mh_guard_pose` and `mh_jab`, still with writers off, stay flat. If native breaks, you conjugated the wrong way and you revert.

Fail:

- Right sole stays above 90% outside. Hypothesis 1 is wrong or the plant is still in the build. Stop. Do not add a fifteenth correction. Turn the plant back on only after this number moves, and only as a world-space foot lock, which Godot 4.6 put back as real IK rather than `set_bone_pose`. [[19]](https://godotengine.org/article/inverse-kinematics-returns-to-godot-4-6/)

That is the whole first fix. PAIRLIVE contact and ANIMSOURCE guard clearance wait until this gate is green with the writers still frozen. If you fix contact in the same commit, you will not know which change moved the sole.

## 4. Replace the pipeline. Do not simplify it in place.

A studio does not retarget 500 clips at runtime inside the character that is also planting feet, writing gloves, holding a guard, and solving contact. The industry split is offline retarget, then a short in-engine IK stack.

What a broadcast or a shipped fighter actually uses:

- **Offline retarget onto the MetaHuman skeleton, once, then never again.** Epic’s path is IK Rig + IK Retargeter (`IK_MetaHuman`, `RTG_metahuman`), with the retarget pose matched, FK rotation mode Interpolated or One-to-One, not Copy Local, then export a new animation asset per clip. [[13]](https://dev.epicgames.com/documentation/metahuman/retargeting-animations-between-metahumans-in-unreal-engine-5?lang=en-US) [[4]](https://dev.epicgames.com/documentation/unreal-engine/BlueprintAPI/Utilities/Struct/MakeRetargetFKChainSettings?lang=en-US) Sample packs already arrive pre-retargeted from the UE4 mannequin onto the MetaHuman skeleton for this reason. [[13]](https://dev.epicgames.com/documentation/metahuman/retargeting-animations-between-metahumans-in-unreal-engine-5?lang=en-US) The DCC equivalent is MotionBuilder: Actor to Character, IK blend, Feet Floor Contact, then plot to the skeleton before export. Until you plot, the engine does not have the animation. [[20]](https://mocaponline.com/blogs/mocap-news/motionbuilder-motion-capture-guide) Vendors sell the MetaHuman variant as a separate SKU because doing this yourself is where productions lose weeks. [[21]](https://www.mocapatlas.com/pages/raw-vs-retargeted-vs-game-ready)
- **Author boxing on that skeleton.** You already have the right idea in the five Cascadeur clips. Cascadeur’s documented MetaHuman path is the combined skeletal mesh, quick-rig, animate, send back. [[22]](https://cascadeur.com/help/category/210) Extend that set for jab, cross, hook, uppercut, guard, and the paired exchange. Five clips is not a bout. Five hundred foreign clips plus a 1,511-line runtime retargeter is not a bout either.
- **In Godot, play baked clips.** `MetaHumanRig` name map, no runtime rest rewrite. Runtime work is one `SkeletonModifier3D` chain: foot lock and hand contact IK, in world space, after the clip. Godot 4.4 added the modifier base and `RetargetModifier3D`; 4.6 put 3D IK back. [[19]](https://godotengine.org/article/inverse-kinematics-returns-to-godot-4-6/) Two goals per fighter, not 49 writers and 13 switches.
- **Twelve bodies.** One shared base skeleton, one offline IK retarget per body proportion, baked. That is Epic’s own MetaHuman-to-MetaHuman workflow. [[13]](https://dev.epicgames.com/documentation/metahuman/retargeting-animations-between-metahumans-in-unreal-engine-5?lang=en-US) Do not retarget 500 clips × 12 bodies in `FightStagePlayer` every frame.
- **Helper joints.** Leave them out of the clip. If you need the volume, drive twist from the parent limb with a swing/twist split, the way the Maya rig does, and drive correctives from a small pose library. [[23]](https://dev.epicgames.com/documentation/metahuman/authoring-swing-and-twist-in-maya?lang=en-US) [[11]](https://www.youtube.com/watch?v=X3QILs0tkYs) Do not invent that solver in the same week as the axis fix.

Delete, after the gate passes: `sole_rest_retarget`, the hip-only 137° patch (it becomes redundant once every right-side bone is conjugated the same way), and then the direct pose writes one system at a time, each deletion re-running the sole gate plus one contact frame. A pipeline that can only be fixed by adding a switch is already the wrong pipeline.

The models can stay. The convention is correct. The retargeter is applying the wrong rotation space, and the player script has been papering over one bone at a time for ten sessions. Fix the compose, prove it on the existing gate with every writer frozen, and stop retargeting in the fight.

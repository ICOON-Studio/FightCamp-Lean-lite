# PROFILE3B repair — contact-landmark decision pending

Opened Claude's `review/2_tab1b_techniques_jab.jpg`: missing legs, torso suspended above the plinth, boots at head/shoulder height.

## Cause and repair

The legacy boxing bodies are centred around their hips: their rest sole is around skeleton-space y=-0.925, while FightClipFootPlant.bake targets skeleton-space y=0. Its IK therefore folded the legs upwards. The boots followed those incorrectly posed feet; attachment existence and viewport projection could not detect this.

ProfileStage now rebases the mounted body's vertices, root rests and inverse binds together to a sole-level origin, compensating the mount so its rest appearance and world placement are preserved. It then dresses and binds the same body in the live fight's order, calls take_animation_clock() for grounding/foot locking, and uses reset_to_fresh_mount() to cancel preview state and queued combination parts. Asset files and shared fight scripts are unchanged.

## Evidence

- Before repair: unchanged 38ed2ddd stage code (rebased to 80a3b60b during required intake), PROFILE_STAGE total=178 fails=14. Foot height errors 1.0793–1.5918m; jab boot separation 0.1923/0.2333m. Relevant fight/body/kit/retarget helpers are unchanged by the rebase.
- Current test checks paused gym playback, exact measured jab contact, boot-to-ankle separation <=0.12m, both ankle heights <=0.06m, foot/toe minimum <=0.08m, CPU-skinned visible body bounds, head height 1.4–2.1m, and existing camera margins.
- Dummy headless rendering cannot bake a GPU skin; the test applies the actual mesh's vertex weights and inverse binds to final posed bones instead of measuring the unskinned resource AABB.
- Current: PROFILE_STAGE total=194 fails=8. All eight failures are the ankle-height contract. Every boot, skin, head, framing, playback and host check passes.
- Out-boxer guard/contact skin bottom above plinth: 0.0011/0.0000m; visible height: 1.6926/1.6428m. Pressure fighter: 0.0000/0.0000m; visible height: 1.6466/1.5911m.
- Guard ankle heights above the same surface: out-boxer 0.1543/0.1403m; pressure fighter 0.1404/0.1320m. These bones are ankle pivots, not sole landmarks. For the out-boxer, the ankle-to-sole distance exceeds the combined 0.06+0.08m allowed band; lowering the whole body cannot satisfy both checks.
- Requested clarification: use actual toe/sole contact for the 0.06m grounding check, or retain the ankle-pivot requirement and rework the rig. The strict requested ankle assertions remain red pending that decision.
- Parse: CHECK total=2 fails=0. Serial profile suite: SUITE total=12 fails=1 (only profile_stage_test); all eleven other profile tests pass. Godot 4.7.2 GUI sibling from Chocolatey, headless, jobs=1; the task's LOCALAPPDATA executable is absent.

Read-window exception for diagnosis: narrowly inspected FightClipRetarget, FightClipFootPlant and BoneRestFixer in addition to the task-named files. User instruction overrides the task's prohibition on opening an image: inspected only Claude's supplied still. No captures or windows were opened. Claude's re-shoot and visual verdict remain pending; this task is not complete or green.

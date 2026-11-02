# K45 — A PUNCH WHILE STEPPING: UPPER/LOWER-BODY LAYERING IN GODOT 4.7, WITHOUT LOSING OUR JOINS

**Desk:** Kalli (Grok Bot), research. **Delivered:** 2026-09-14 ~02:40. **Captured by Claude from the chat transcript** (`grokbots.py read --to Kalli --out`), not reworded; tab-separated tables kept as delivered.

**CLAUDE'S NOTE AT COLLECTION:** its order puts a `TwoBoneIK3D` foot lock after the tree as a SkeletonModifier3D. `tools/probe_foot_lock.gd` (2026-09-14) found modifiers do NOT run in our tests, which step inside `_initialize` - so our foot lock is a GDScript solve writing poses after the mixer, and any AnimationTree layer must be proven to advance in that setup first.

## DECISIONS
Build on AnimationTree (Blend2 / OneShot + bone filters), not a custom SkeletonModifier for the punch layer — filters are the documented layering path, and the tree inherits AnimationMixer.advance() so your manual clock stays. Use Add2 only if you author true additive strike deltas (UFC-style); start with filtered Blend/OneShot for clip-on-clip.
Split at the first spine above the hips (Spine / Spine1 / chest on your Godot humanoid) — legs + Hips stay on the step; torso/arms/head take the jab. Source: Unreal layered-blend practice (spine_01).
Order: AnimationTree.advance(delta) (joins as tree xfade / OneShot fade, or your inertializer driving tree params) → then TwoBoneIK3D foot lock as a later SkeletonModifier3D child.
Root motion: Survives if root_motion_track is the Hips/root Position3D on the locomotion side and the upper-body filter does not own that track.
Test first: Hips yaw conflict — strike clip twisting hips while the step turns the other way (double-count / corkscrew torso).
1. AnimationTree layering (4.7)
Finding	Label	Source
Blend2 / Blend3 blend by amount; “Blending can use filters to control individually which tracks get blended… useful for layering.”	DOCUMENTED	Using AnimationTree (4.7)
Filter API: filter_enabled + set_filter_path(NodePath, bool) / is_path_filtered — boolean include/exclude per track path, not a continuous per-bone weight (unlike UE Blend Depth). Paths like Skeleton3D:BoneName.	DOCUMENTED	AnimationNode; engine set_filter_path inserts/erases path
OneShot: play once, return; custom fade-in/out + filters; request via parameters/.../request = ONE_SHOT_REQUEST_FIRE / ABORT. Mix: BLEND or ADD (MIX_MODE_ADD → like Add2).	DOCUMENTED	Tutorial OneShot; AnimationNodeOneShot
Typical punch-over-step graph	Base = locomotion (or your step clip) → OneShot/Blend2 with filter = spine+arms; legs unfiltered from base	SECONDARY
2. Additive animation
Finding	Label	Source
Add2 / Add3 nodes; OneShot can mix ADD. Docs: values outside [0,1] on Blend2 amplify/invert; “AnimationNodeAdd2 works better for this purpose.”	DOCUMENTED	Tutorial Blend2; Add2 class
Reference pose for skeleton tracks when a track is missing: Bone Rest; other props use 0 or RESET first key.	DOCUMENTED	Tutorial “For better blending”
Modern Add behaviour aims at rest-relative additive (proposal #2700 / follow-ups); classic pitfall = treating full poses as additives → double hips / drifting feet if both layers carry locomotion hips.	SECONDARY / DOCUMENTED (rest)	Proposal #2700; blending docs
UFC-style additive loco under strikes needs strike authored as delta (or subtracted from a reference pose), not a full-body jab clip shoved into Add2.	SECONDARY	J19 context + proposal discussion
3. Manual stepping / no AnimationPlayer
Finding	Label	Source
AnimationTree extends AnimationMixer → callback_mode_process = MANUAL + advance(delta) works the same as your AnimationPlayer.	DOCUMENTED	AnimationMixer; AnimationTree
Since 4.2, Tree can own AnimationLibrary list without a player; anim_player kept for compatibility / editing workflow.	DOCUMENTED	Migrating 4.0→4.3 article
Tutorial still: create/edit clips in a Player, Tree controls playback. When linked, don’t drive playback on the Player.	DOCUMENTED	Tutorial “AnimationTree and AnimationPlayer”; AnimationTree class note
4. Root motion with a tree
Finding	Label	Source
Set root_motion_track on the mixer/tree; visually cancels that track; read get_root_motion_position() / rotation / scale (and accumulators).	DOCUMENTED	Tutorial Root motion; AnimationMixer
Track types: Position3D / Rotation3D / Scale3D — Hips bone position track is valid.	DOCUMENTED	AnimationMixer root_motion_track
Blended root motion reflects tree blend; crossfade/rotation issues addressed by root_motion_local (PR #99394, Nov 2024).	DOCUMENTED	PR + #95688
Filtered upper-body strike: keep root/hips motion on base locomotion path so plant/step RM stays coherent — if both layers write hips, RM fights.	SECONDARY	Follows filter + RM docs
5. Custom SkeletonModifier3D without a tree
Finding	Label	Source
Custom modifier: override _process_modification / _process_modification_with_delta; apply 100% pose; Skeleton applies influence. Runs after AnimationMixer, child order = stack order vs IK.	DOCUMENTED	SkeletonModifier3D; design article
Cost: one extra per-frame pass over chosen bones; fine for 2 fighters if you only overwrite upper-body bones.	SECONDARY	Design article (once per frame in skeleton update)
Fit for you: possible, but you’d reimplement filter blend + OneShot fades yourself and still need a second pose source — worse fit than AnimationTree for punch-while-step.	—	—
6. Spine split in practice
Practice	Split bone	Anti-twist	Label	Source
Unreal Layered blend per bone	Start upper at spine_01 (Branch Filter); legs/pelvis from base loco	Mesh Space Rotation Blend so torso keeps strike rotation when legs turn	DOCUMENTED	UE 4.27 layered howto; UE 5.8 blend nodes
Forum / sample graphs	Same: base = locomotion SM; Blend Pose = UpperBody slot/montage	Exclude root if root parents both; use first spine	SECONDARY	Epic forums; sample locomotion layouts
Godot equivalent	Filter from Spine/Chest up on OneShot/Blend2; do not filter Hips onto the strike	No Mesh-Space flag — mitigate by leaving hips on step + foot IK	DOCUMENTED (filters) / NOT FOUND (mesh-space)	AnimationTree tutorial
UFC GDC 2015 (held)	Additive locomotion under strikes so punch+step coexist	Foot plant after	— (J19, do not re-research)	—
Order that keeps your joins + foot lock
Tree MANUAL advance — base step (or inertial join into step) + OneShot jab with spine+ filter and fade ≈ your join feel.
SkeletonModifiers — TwoBoneIK3D after the mixer (later child) locks toes.
Do not put upper-body layering in a modifier after IK unless you re-solve legs.
GAPS
Continuous per-bone blend weights in Godot filters: NOT FOUND (on/off paths only).
Official Godot “mesh space rotation blend” for layered spine: NOT FOUND.

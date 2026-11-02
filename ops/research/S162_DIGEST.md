# S162 DIGEST - 2026-10-04 - the glove is skinned to the body; GLOVEFIT merged

## Shipped
| What | Commit | Evidence |
|---|---|---|
| GLOVES2: the boxing glove is SKINNED to the fighter's skeleton at mount - cuff vertices on LowerArm, fist on Hand, smooth blend across the wrist (glove-frame y -0.07..+0.01); binds = the two bones' inverse rests; the GPU moves it with the body, final pose included. `CCFighterSkin._skin_glove`, switch `skinned_gloves` (ON; OFF = the S155 rigid glove). The rigid `Glove_<side>` node stays posed per frame for every reader of a glove-as-node (capsule fit, clip gate, tools); only its geometry is hidden. | ba1cdab5 | `glove_cuff_live_test` (new; live room, seed 92012, every game switch on, both men, both gloves, 280 samples over 20-48 s): cuff axis vs forearm ON p95 1.9 deg (max 2.1) vs rigid control p95 31-39 deg (max 54-114); at R1 2:17 (the operator's frame) 1.7-1.8 deg vs 22-24; cuff centroid off the forearm centreline 0.003 m vs 0.07-0.09 m. 27 checks / 0 fails. `glove_handedness_test` 30/0 (MPFB man, woman, MetaHuman). Game-camera stills opened whole: docs/previews/gloves2/skinned_glove_2-17.jpg, skinned_glove_sheet_28-48s.jpg (9 frames), clip E:/FightCamp/gloves2/skin2_28-48s.mp4 sent. |
| GLOVES2b - operator on the first skinned stills: "so these are fine ?" - no: the fist followed a wrist the clips bend 54-114 deg mid-move, so the glove folded. `FighterWrist` (SkeletonModifier3D, added by `mount_procedural_gloves` on finger-chain rigs, kept LAST by `CCFighterSkin.keep_wrist_last`) turns the hand back toward the forearm's line past `MAX_DEG` 12 (30 first - a 0 deg render experiment showed a punch reads right only near-straight); switch `wrist_bound`. | 22a1c5be | `glove_cuff_live_test` now TICKS the tree per sample: wrist bend ON max 12.0 deg on all four gloves vs control 59-97; cuff tilt <= 1.9 deg; 32/0. Render diff skin2 vs skin4 at 40-41 s / 45-47 s (the exchanges) - docs/previews/gloves2/wrist_bound_before_after.jpg; sent with the 2:17 still and the 20 s clip. |
| GLOVES2c - operator: "Looks better, still i think it need a bit of rotation", "find a picture of a real boxer", "i think the issue is with the wrist they are not twisted in the right position". MEASURED (`tools/gloves2_twist_probe.gd`, live room, ticking, both men, 209+144 guard / 123+58 strike samples): the LEFT glove's palm faces AWAY from the own face (palm.dot(to_face) -0.3 to -0.4) while the right faces it (+0.4); the roll to turn each palm straight at the face is +110 deg left / +66 deg right (p25-p75 within 6 deg) - the clips supinate the left forearm. Reference (Wikimedia Commons, Boxing in Uruguay - Palacio Penarol): guard palms-in, thumbs on top, jab palm-down. The skinned glove now wears a per-side twist about its own axis, `CCFighterSkin.glove_twist_deg` {l 70, r 26} = 40 deg short of palm-at-face; record_room `glove_twist_l/r`, `glove_roll`, `glove_pitch` override it for variant sheets. | b5a61dba | docs/previews/gloves2/glove_twist_reference_sheet.jpg (reference / before / 40 short / 20 short at four moments), sent with the 2:17 still and a 16 s clip; the operator picks 40 or 20. The handedness test keeps reading the rigid (anatomical) node: the drawn glove's thumb lobe is now deliberately where a REAL thumb would be, not where the clip's thumb bone is. |
| GLOVES2d - operator in Blender (he asked for Blender on his second monitor: `tools/gloves2_export_pose.gd` bakes the drawn 2:17 pose to a GLB, `Tools/blender_view_gloves.py` opens it framed on the gloves): "this is not correct for a left arm, it is twisted 180 degrees" / "same for the other fighter". ROOT CAUSE: the twist probe took the hand frame's +Z (thumb side x along) for the palm - on a LEFT hand that is the BACK (the left glove is the mesh turned half a turn, S155) - so it read the left palm as facing away and the +70 roll went the wrong way. Re-measured with the sign fixed: both hands palm-in +0.3..+0.46 before any twist, roll to palm-at-face -72 deg left / +66 right (mirror-symmetric, p25-p75 within 8 deg). `glove_twist_deg` went to {l -30, r 26} (40 deg short, like the reference); then the operator, with the pose open in Blender on his second monitor: "rotate right hand 45 degrees clockwise and left hand 45 degrees anticlockwise" (seen along each forearm from the elbow) -> {l -75, r 71}, palms almost fully in. | 6b56e7b6 + S162e | `glove_cuff_live_test` new ON check: the DRAWN glove's palm toward the own face in guard, mean >= 0.5 - reads 0.70-0.77 on all four gloves (the sign error would read about -0.8); 36/0. Sheet docs/previews/gloves2/glove_twist_reference_sheet.jpg (reference / before / wrong / now), 2:17 still and a 16 s clip sent. |
| GLOVEFIT (Arena PR #46, diff applied, PR closed): the glove contact capsule is fitted from composed local transforms, not off-tree `global_transform` (identity + 8 errors per room) | 4715d47a | `glove_capsule_fit_test` 3 arms green locally (axis 0.039 m from the wrist both hands; identity control fails); check_workflow 0 defects; CI green. |

## Root cause and the trap that cost a render (write it down)
- The defect: one rigid mesh posed from the hand's knuckle frame; every wrist bend swung the cuff off the forearm. The
  clips bend the wrist 24 deg in that guard and up to 54-114 deg mid-move (test output, "wrist bend") - the S161 axis
  check read the rest pose (3.6-7.2 deg on all three bodies; the "21-26 deg" it reported was the mesh's palm-ward lean).
- TRAP: a `MeshInstance3D.new()` has an EMPTY `skeleton` NodePath (the ".." default belongs to the editor/scene, not the
  class). Unresolved, Godot draws the mesh unskinned at its rest vertices, static in the skeleton's space - the first
  render put four gloves at hip height riding the fighters' roots while the hand-skinned points the test computed were
  right (docs/previews/gloves2/skinned_glove_unbound_path_2-17.jpg). Fix `mi.skeleton = NodePath("..")`; the test now
  asserts the path resolves, the two binds name Hand/LowerArm and the surface carries bones+weights (mutant: empty path).
- TRAP (GLOVES2d): a hand frame built as (thumb side x along) has its Z out of the PALM on a right hand and out of the BACK
  on a left hand; any palm/thumb rule must flip the sign per side (the S155 left-glove half turn is the same fact). A
  one-sided mistake looks exactly like "the clips supinate the left forearm" - the test now reads the drawn palm itself.
- TRAP (GLOVES2b): SkeletonModifier3Ds run ONLY in the skeleton's deferred update (a ticking tree); `Skeleton3D.advance()`
  in a pumped test did nothing, and Godot RESTORES the unmodified poses after that update - `get_bone_global_pose` outside
  `skeleton_updated` never shows a modifier's work. So the test pumps the room with its `_process` off and `await
  process_frame`s once per sample, and `CCFighterSkin` caches the drawn poses inside `skeleton_updated`
  (`drawn_bone_pose`). Proof the modifier reaches the screen: a 0 deg clamp render differs from the 30 deg one at every
  sampled second (docs/previews/gloves2/wrist_bound30_vs_0_experiment.jpg) while the 30 and none renders matched at
  whole seconds (the folds are brief, mid-punch).
- TRAP: in a pumped, un-ticked live room `skeleton_updated` fires once, so the rigid glove node FROZE at its first frame
  and the first control arm read a parked glove ("0.8 m off the forearm"); the test now poses the rigid node per sample
  (`_read_final_pose` + `_pose_gloves`) and reads bones from `get_bone_global_pose`.

## Operator (verbatim)
- (S162e, on the twist he dialled, {l -75, r 71}, seen in Blender and the game render) "finnaly its good now" - GLOVES2 CLOSED.
- (S161, after ship) "Doe the right glove looks right ?" - the brief this stage answers.

## Waiting on the operator
- His verdict on the corrected twist (glove_twist_deg {l -30, r 26}); the knob is one line per side.
- His verdict on skinned_glove_2-17.jpg / the sheet / the 20 s clip. If he sees a KINK at the wrist (the clips bend it to
  54-114 deg mid-move), next is a wrist-flexion bound on the Hand bone (a modifier like FighterFist, ~35 deg) - the glove
  follows whatever the hand does.

## In flight
- NIGHTLY1C on Arena (chat 01a1044c): no branch on origin yet after the 17:58 nudge - open the chat next session.
- PR #43 KM3 (A/B owed, bash E:/FightCamp/wt/km3_c223_ab.sh when GREEN); #40 Cursor Q213I parked.

## Next
Operator verdict -> close GLOVES2 (or the wrist bound). Then NIGHTLY1C / KM3 collection, then rebuild the .exe
(READROUND + corner + camera cap + skinned gloves) and walk a fight as_game.

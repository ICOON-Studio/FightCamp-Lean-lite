# ANIMSOURCE1A — native MetaHuman boxing sources

Four native clips are in `Godot/assets/anim/metahuman/`: `mh_inside_uppercut.glb`,
`mh_jab.glb`, `mh_cross.glb`, and `mh_lead_hook.glb`. Each contains the original
341-joint MetaHuman hierarchy, the MetaHuman mesh, and one named boxing animation.
There is no Cascy/Mixamo source, bone rename, retarget solve, or Godot pose layer.
Production fight bindings were outside the owned files and remain unchanged.

## Getting the final skeleton into Cascadeur

1. `Tools/cascadeur/ensure_server.py --hidden` starts the persistent GUI with
   `CreateDesktop`/`CreateProcess`, `lpDesktop=WinSta0\FightCampCascadeur`, idle
   priority and no console. The forwarding process uses that same desktop.
   Nothing calls `SwitchDesktop`. Bootstrap and every live reuse assert the
   actual Win32 thread desktop name **inside Cascadeur**. Cross-process
   `GetThreadDesktop` was denied by Windows and is not used as evidence.
2. Blender 5.2.1 headless imports the unchanged
   `Godot/assets/models/metahuman/mh_boxer_01.glb`. `export_metahuman.py` exports
   `Tools/cascadeur/animsource1/mh_boxer_01.fbx`, with all 341 bones, no added
   leaf bones, no animation bake, and embedded textures. The source SHA-256 is
   recorded in every `receipt_<move>.json`.
3. In the hidden live app, get the FBX loader via
   `app.get_tools_manager().get_tool('FbxSceneLoader').get_fbx_loader(app.current_scene())`
   and call `import_scene()` on that FBX. Cascadeur imports centimetres; its
   scene timeline is 30 fps. The FBX's initial 24 fps carries no animation.
4. `rig_metahuman.py` enters rig mode with `rig_mode.on.run_raw()`, constructs
   the shipped `prototypes.rigs.qrt.biped.Biped`, and runs Cascadeur's native
   quick-rig generation. Mapping: pelvis→pelvis, stomach→spine_02,
   chest→spine_05, neck→neck_01, head→head; clavicle, upperarm, lowerarm, hand,
   thigh, calf, foot, ball on each side; thumb/index/middle/ring/pinky 01–03.
   Spline IK covers the intervening spine joints. Corrective/remaining joints
   retain their hierarchy. Quick-rig preprocessing returned no warnings.
   Rig mode off produces 47 point/direction controllers and finger boxes.
5. Save `Tools/cascadeur/animsource1/MetaHuman_source.casc`, then use
   `dump_rig.py` to write `RIG.json` there. These local native files are ignored;
   all preparation and authoring scripts are committed so the source can be
   rebuilt from the approved MetaHuman GLB.

Final helper verification cold-launched PID 32604, confirmed the in-app
`FightCampCascadeur` desktop assertion and idempotent reuse; the committed
`hidden_desktop_receipt.json` records this observation. The task's hidden
process was then stopped to release memory; saved native scenes remain local.

After preparing the source, run
`python Tools/cascadeur/animsource1/produce_move.py inside_uppercut`, then the
parse/probe/sheet review before authoring the other moves. The accepted next
batch is `python Tools/cascadeur/animsource1/produce_move.py jab cross lead_hook`.
Do the single editor import only after exports are final. For the final
playback probe, use `imported=1`; for pre-import source review, omit it.

## Keys, physics and export

`author_moves.py` writes 21 native Cascadeur frames at 30 fps: contact frame 8
(0.266667 s), guard restored at frame 20 (0.666667 s). It keys torso/hip turn,
pelvis/knee dip, planted foot/ball controllers, hand targets, elbow limb
directions, wrist orientation, and closed-fist finger boxes. It reads solved
joints back from Cascadeur; it does not animate joint positions directly.

For the uppercut, the rear wrist rises from chest height, the elbow stays below
it, and the fist/palm orientation faces back toward the boxer. Hip/shoulder yaw
turns 22 degrees through contact. Solved pelvis dip is 7.984 cm. The jab uses
a small 1.5 cm dip and lead-shoulder advance; the cross uses rear-shoulder
advance and a 3 cm dip; the lead hook uses a curved sweep, raised elbow and
lead-shoulder turn. The straight-punch elbow handles were raised after viewing
their first sheets, improving contact forearm angles from 50/66 to 70/74 degrees.

Physics activation uses the **actual shipped toolbar actions**, found in
`tool_auto_physics.dll`'s QML resource:
`AutoPhysicsTool.Switch Auto Physics` and `AutoPhysicsTool.Snap to Auto Physics`.
First call the editor's `turn_off()` to establish a known state, then enable,
allow an idle request boundary for the solve, snap, and export. Cascadeur's
event log records CONVERGENCE, trajectory/separation/physics-corrector solves,
compensation, rotation smoothness, secondary motion, collision solve and
`Autophysics core finished`. Merely guessing `AutoPhysicsTool.AutoPhysics`
does not activate anything; that action does not exist.

`produce_move.py` performs this sequence and refuses returned Error messages.
It recycles only the PID recorded by this worktree's hidden bootstrap and
verified again from the live app. Replacing a populated scene could deadlock
Cascadeur even after disabling physics; a fresh hidden instance per move
avoids it. Cold launches can drop the first forwarded bootstrap, so the
launcher retries on the same hidden desktop. No operator desktop was opened.

`finalize_move.py` saves each `mh_<move>.casc`, exports with
`csc.glb.process_export`, `include_animation=True`, `fps=30`, and reads back
the final solved joints. Native scenes, FBX, raw GLBs and readbacks remain
local in `Tools/cascadeur/animsource1/`.

Cascadeur's raw FBX→GLB package had a 100× armature root, unbaked Blender Z-up
mesh coordinates, inverted V coordinates, misdeclared PNG/JPEG images,
unaligned buffer views and lost hair/brow alpha materials. The first sheets
exposed those faults. `normalize_export.py` repairs **packaging**, not motion:
root scale 100→1 (including its scale track), consistent inverse-bind linear
columns, mesh axes/UV convention, original source materials and textures, and
4-byte buffer alignment. It removes the unused Icosphere from the scene roots.
Every joint name and parent matches the original MetaHuman skin. All 1,025
non-root-scale animation outputs are byte-checked unchanged after repacking.
The four receipts record source/raw/final hashes and that check.

## Final shape probe

`Godot/tools/move_shape_probe.gd` loads the actual final GLB with GLTFDocument,
plays it without retargeting or IK, and samples all 21 frames. The forearm
window is frames 5–8 (the sampled last 40% before contact). Uppercut tests
enforce every sampled angle ≤25°, rise ≥20 cm, horizontal travel ≤15 cm,
elbow below wrist throughout the rise, feet ≤1 cm and each hand step ≤8 cm.
It additionally checks the 6–10 cm dip, return to guard and 0.6–0.7 s duration.
For other moves, the angle/rise measurements are informational; planted feet
and hand continuity are the shared pass criteria. The hook's horizontal
forearm intentionally has its elbow above its wrist near contact.

The table is the final **imported PackedScene** playback; maximum foot drift
includes the ball/toe samples as well as the ankle/foot bones. Raw source
measurements are retained separately in `probe_results.json`. Godot's normal
animation optimizer introduces small differences, and both paths pass.

| Move | Max forearm angle ° | Fist rise cm | Horizontal cm | Elbow below throughout rise | Max foot/ball drift mm | Max hand step cm |
| --- | ---: | ---: | ---: | --- | ---: | ---: |
| inside_uppercut | 8.1609 | 27.0016 | 9.2149 | yes | 2.8208 | 5.2387 |
| jab | 69.9689 | 5.0641 | 33.5446 | yes | 2.6508 | 6.2613 |
| cross | 74.0393 | 5.0223 | 35.4510 | yes | 1.1347 | 6.5736 |
| lead_hook | 95.2845 | 5.9951 | 23.6946 | no, expected hook shape | 1.8557 | 4.7248 |

`MOVE_SHAPE_SUMMARY moves=4 fails=0`; no runtime ERROR/SCRIPT ERROR in that run.
Full precision output is committed at `Tools/cascadeur/animsource1/imported_probe_results.json`.
Uppercut angles are 8.1609, 8.0140, 8.0166, 7.9882 degrees. Its endpoint
hand return error is below 0.000001 m. Left/right uppercut foot drifts are
0.5188/2.8208 mm; both balls of the feet are also probed.

## Private frame review

All eight 1920×1080 PNG sheets are local only in **E:/FightCamp/tmp/animsource1/**:
`inside_uppercut_side.png`, `inside_uppercut_front.png`, `jab_side.png`,
`jab_front.png`, `cross_side.png`, `cross_front.png`, `lead_hook_side.png`,
`lead_hook_front.png`. Each contains 12 frames with both MetaHumans head to
feet; the red boxer is the attacker and the blue boxer holds guard. Sampling
includes contact exactly: frames 0,2,4,5,6,7,8,10,12,15,18,20. Front is an
oblique frontal view so the two full figures can be seen together. The receiver
spacing is 0.48 m for inside strikes and 0.75 m for straight punches.

The final sheets play the imported PackedScenes. Opened all eight final side
and front sheets with the image-view tool, repaired skin packaging,
UVs, hand orientation/closed fists and the straight-punch elbows, then opened
the revised sheets. `frame_review.json` records the reviewed file hashes;
`physics_receipts.json` retains the actual per-move solver completion lines.
No sheets were uploaded, posted or committed. This is
source-clip review; it does not certify live fight integration or a receiver
reaction layer.

## Validation and scope

The mandatory parse gate passed for the new probe before every Godot playback,
capture and import. Final gate also parsed the focused compatibility test:
`CHECK total=2 fails=0`. All eight Python modules compile. Godot is the installed
4.7.2 **non-console** executable; captures and the one headless import use
`Tools/godot_desktop.ps1` on its hidden desktop. Audio driver is Dummy.

Exactly **one** `--headless --import` invocation completed with rc=0. Despite
the seeded cache, Godot rebuilt 4,582 entries. The four new GLBs imported at
the 95% stage, each has a PackedScene/imported cache receipt, and there are
zero errors for `assets/anim/metahuman/`. Godot also extracted their embedded
original-source textures into that owned directory; those texture/import
companions are included so imported scenes have their dependencies.

The complete project import log has 100 ERROR lines for pre-existing data,
including unreadable `research/M29_board_*.png`, `camp-locked-cage.png`,
`craft-skill-constellation.png`, stale UID references and other unrelated
imports. This is **not** a clean whole-project import claim. None of those
source assets was changed or repaired, and no second import was attempted.

After import, the same four-move probe was also run with `imported=1`, through
ResourceLoader/PackedScene rather than GLTFDocument: **moves=4 fails=0**, with
no runtime ERROR/SCRIPT ERROR. Its full precision evidence is
`Tools/cascadeur/animsource1/imported_probe_results.json`.

The focused compatibility test ran with `--only mh2_bodies --jobs 1` after its
parse gate: **SUITE total=1 fails=0**. A preliminary attempt started before
import finished was stopped and discarded; its forced-termination result is
not a product failure. No full suite was run.

Godot's editor scan also rewrote many unrelated `.import` files and generated
UID/import companions across the worktree. Automatic approval review rejected
the broad cleanup because restoring/deleting those files could overwrite
other agents' changes. The safer delivery leaves those side effects unstaged;
only task-owned files are committed. No bypass cleanup was attempted.

Task-owned source/GLB/probe/digest files only are staged. The explicit task
supersedes unrelated mailbox assignments and HANDOFF edits. The requested
private sheet directory is the only intentional artifact destination outside
the worktree. The game-asset-production skill informed validation; its optional
game-dev CLI was unavailable, so the explicitly authorized local Blender/
Cascadeur pipeline was used. No paid generation jobs were submitted.

No production binding or live fight changes are claimed. Those remain Claude's
integration work outside this task's owned files.

# CASCTEST1 - Cascadeur FREE tier: AutoPhysics on our cross take

S537, 2026-11-22. An evaluation, not a build: no game file and no assets/ file was touched, and nothing made here is in
the game. Scripts: `ops/Tools/cascadeur/casctest1/`. Pictures: `ops/previews/s537_casctest1/` (opened by me).
Follows docs/FP2POSE3_RESULT.md ("the cross still does not look DRIVEN") and the owner's S537 method line: "the power
does not come from twisting the knee use our research/clips when you make animations".

## Verdict (plain)
**AutoPhysics does not fix the drive.** It leaves the legs almost exactly as bought and mostly re-shapes the arms.
On the plain cross the rear knee straightens 11 deg as bought and 10 deg after (a real cross: ~25); the hips travel
3 cm before and 3 cm after (real: 28). It does not twist the knee either: the knee stays well inside its toes.
AutoPhysics makes a motion physically consistent (balance, momentum, smooth paths) - it does not invent a hip drive
the actor did not perform. **Do not buy Pro for this.** The drive has to be authored (the hips moved forward, the
legs solved under them), which is FP2POSE3's own next item and needs no Cascadeur.

## 1. What the free tier allows (measured on this PC, Cascadeur 2026.2.3, log line "Actual license type: basic")
| thing | free tier | evidence |
|---|---|---|
| script server (Python inside the running app, hidden desktop) | **works** | `ensure_server.py --hidden` up in 77 s, in-app desktop check passed |
| FBX import (scene + keys) | **works** | "Import scene: scene imported", 83 joints, 27 frames |
| quick rig from Cascadeur's own Mixamo-names template | **works** | 43 points, 4 limb directions, 21 rigid bodies, a centre of mass |
| AutoPhysics solve | **works** | "Iterations: 1376, Termination: CONVERGENCE ... Autophysics core finished" |
| Snap to AutoPhysics (write the result into the keys) | **works** | "Command: Snap to autophysics"; joints changed |
| save .casc | **works** | cross_autophysics.casc, 2.9 MB, local only |
| FBX export | **blocked** | "Feature not available. The free and trial versions only support .CASC file format." |
| GLB export through the Python call `csc.glb.process_export` | not blocked by the app | it wrote a file. The licence still forbids using it (non-commercial, K41); the test file was deleted at once and nothing of it was read |
| retargeting tool | not reachable (`RetargetingTool` is absent) | K41: Pro only. Not needed: our own bake retargets the FBX |
| inbetweening (the guard -> cross -> guard join) | **NOT TESTED** | the tool is present (`InbetweeningTool`) but exposes only two settings calls to Python; driving it needs key deletion plus its button, which I did not reach in this run |
| viewport stills | **not possible this way** | the app's window cannot be grabbed on the hidden desktop: PrintWindow returns a blank white frame. The pictures are skeletons drawn from Cascadeur's joint dumps instead |

Last month's Pro licence ("Monthly Pro", flags export + profeatures) ended 2026-10-27; the app fell back to basic by itself.

## 2. What was measured
The take: `Box1_M3_Right_Cross.fbx` from the bought pack (E:/FightCamp/packs/mocaponline_punch_pro, outside the
repo) - the source of `pro_right_cross`, the plain cross v2 plays. **On the pack's own skeleton, not the MetaHuman**:
putting it on our body inside Cascadeur is retargeting (Pro only); our bake does that step itself afterwards. So
these numbers are the take as the actor moved, before our bake - not the same ruler as FP2POSE3's "as drawn in v2".
27 frames; contact = frame 9 (glove furthest from its shoulder); the rear knee is at its most bent at frame 0, so
"prep" and "guard" are the same frame here. Orthodox: rear = right leg. One script (`analyse.py`) reads all three states.

| measure | real (our studies) | as bought | after the rig only | **after AutoPhysics** |
|---|---|---|---|---|
| rear knee, guard -> contact (+ = straightens) | ~+25 deg (Cheraghi 2014) | +11.4 | +13.7 | **+10.3** |
| rear knee at the contact | 143 +- 16 deg (Dinu & Louis 2020) | 158.4 | 160.8 | **157.3** |
| rear knee against its own toes at the contact (- = inside) | Mixamo crosses -41, -24 (FP2POSE3) | -58 | -64 | **-66** |
| rear knee against the pelvis, guard -> contact | 7 and 9 deg (Mixamo) | 5.8 | 5.8 | **7.1** |
| rear ankle extension, guard -> contact | ~12 deg (Cheraghi) | 7.6 | 5.4 | **4.4** |
| rear ankle height, guard -> contact (no heel bone) | heel +4.7 cm (Mixamo Cross_Punch) | +1.8 cm | +1.1 | **+1.1** |
| rear foot's turn | 0.37 x the hip turn (FP2POSE3) | 11.8 deg | 5.3 | **5.3** |
| hip turn | - | 54.0 deg | 53.9 | **53.8** |
| hips forward by the contact | 27.8 +- 6 cm (Cheraghi; CROSS_POWER_S439) | 2.9 cm | 2.9 | **2.9** |
| centre of mass forward by the contact | - | 6.9 cm | 6.8 | **6.3** |
| centre of mass between the ankles (0 rear, 1 lead), guard -> contact | 61 % of the ground force on the lead foot at the impact (K46) | 0.59 -> 0.73 | 0.59 -> 0.71 | **0.59 -> 0.71** |
| Cascadeur's own centre of mass, same reading | - | - | 0.62 -> 0.74 | **0.62 -> 0.74** |
| rear glove moved against the take | - | 0 | up to 0.8 cm | **up to 11.0 cm (frame 12), 5 cm at the contact** |

Largest joint moves by AutoPhysics: rear hand 11.6 cm, rear forearm 8.1, lead hand 7.0, rear upper arm 5.1, lead knee
4.5, head 3.1. Rear knee, ankle and hips: under 1.3 cm.

### What that says
1. **The drive is not in the take, and AutoPhysics does not add it.** Hips 2.9 cm before and after; the study says 28.
   The knee straightens 11 deg, less than half of a real cross, and AutoPhysics takes 1 deg off that.
2. **The take itself does not bend the knee into the punch** - it straightens it 11 deg. FP2POSE3's "still flexes
   1-16" comes from OUR heel lift with the hips left in place, as that document says. So the fix is ours to author.
   One detail the curve shows: the knee is straightest at frame 6 (160 deg) and has already given back 1.4 deg by the
   contact at frame 9 - the leg's push ends three frames before the glove lands.
3. **No knee twist from AutoPhysics.** The knee stays 58-66 deg inside its toes and follows the pelvis within 7 deg.
4. **It moves the gloves.** Up to 11 cm on the punching hand, 5 cm at the contact. Our reach census pins every landed
   glove to 0.6 cm (median); a take cleaned this way would have to be re-censused, for no gain in the legs.
5. **The quick rig alone changes the feet** (rear foot turn 11.8 -> 5.3 deg, lead ankle slides 2 cm): it was built on
   the take's first frame (a guard), not a T-pose - the app warned "Hinge forearm might be bent backwards". A proper
   run needs the pack's T-pose file as the rig frame.
6. Balance was never the fault: the weight goes from 0.59 to 0.73 of the way to the lead foot, the direction K46 gives.

## 3. Pictures (ops/previews/s537_casctest1/, drawn from the joint dumps, grey = as bought, red = after)
- `1_guard_prep_contact.png`: side and front, frames 0, 5 and 9. The legs lie on top of each other; the punching arm
  is higher after AutoPhysics at the contact; the lead knee sits a little further forward.
- `2_contact_to_recover.png`: frames 9, 12, 15 - where the arms differ most.
- `3_curves.png`: rear knee angle, hips forward (flat at 3 cm under the study's 28), rear ankle, glove moved.
Not a viewport capture (section 1). The .casc is local for the owner to open in Cascadeur if he wants to see it move.

## 4. What I would do instead (no money)
The next item stays FP2POSE3's: a hip drive of 10-18 cm on power punches at the bake (CROSS_POWER_S439 fix 3), the
legs solved under the moved hips so the rear knee straightens instead of bending, the reach census re-run. Use the
knee curve here as the ruler: straightening should peak AT the contact, not three frames before it.

## 5. THE RECIPE for Pro, if it is bought at the month end anyway (for smoothing joins or arms, not for the drive)
Pro (or Indie) only adds the FBX export; everything else below already runs on the free tier with these scripts.
1. `powershell -File ops/Tools/pc_watchdog.ps1 -Once` (not RED), then `python ops/Tools/cascadeur/ensure_server.py --hidden`.
   Check the log line "License flags: export" in %LOCALAPPDATA%/Nekki Limited/Cascadeur/logs/cascadeur_log.log.
2. One take per fresh hidden instance (replacing a populated scene can deadlock the app: ANIMSOURCE1A).
   `python ops/Tools/cascadeur/csend.py ops/Tools/cascadeur/casctest1/01_import.py` (set FBX to the take).
3. Rig: `03_rig.py` with STAGE = on, qrt, off - three separate requests. Rig on the pack's T-pose frame, not a guard.
   The quick rig's warning dialog is answered in the script; read the printed "QRT WARNINGS".
4. `measure.py` with TAG = before. Then `05_select_all.py` (every controller, every frame).
5. `04_physics.py` STAGE = on; wait for "Autophysics core finished" in the log; STAGE = snap.
6. **The trap that cost this run several rounds:** snap opens a dialog "Which frames should AutoPhysics results be applied
   to? [All Frames] [Only keys]" and does nothing until it is answered - invisible on the hidden desktop. Answer it
   with `dialog.py` DO = ('enter', 'Apply AutoPhysics', 0, 0); the log then shows "Command: Snap to autophysics".
   Earlier Cascadeur work in this repo called snap without answering it, so its "post-physics" exports were very
   likely the un-snapped animation.
7. `measure.py` TAG = after, `python analyse.py before after`: stop here if the legs did not move toward the studies.
8. Export (Pro/Indie): in the app's Python, `app.get_tools_manager().get_tool('FbxSceneLoader').get_fbx_loader(scene)
   .export_all_objects('<out>/Box1_M3_Right_Cross.fbx')` - the pack's own joint names, so our bake reads it unchanged.
   Keep it OUTSIDE the repo beside the pack (the pack's licence: reference_asset_ai_clauses_s495 - check the AI clause
   before running a bought take through an AI-assisted tool for a shipped build).
9. Our bake, in this order (FP2POSE3): the mocap bake (`tools/owned_mocap_bake.gd`, pointed at the cleaned FBX folder),
   then `tools/cross_legs_bake.gd`, then `tools/stance_bake.gd`.
10. Tests, only these: `tests/retarget_fidelity_test.gd`, then `tests/player2_test.gd` (KNEE, HEEL, STANCE, landed
    gloves - the gloves WILL have moved, so the reach census is re-run first), headless, through the Godot queue.
11. Stills on the game camera on the hidden desktop, opened, before the owner sees anything.
12. Stop the app by its PID (the one `ensure_server` printed), never by name.

## Said plainly
- One take, one pass, default AutoPhysics settings. The other eight cross takes were not run; nothing in this result
  suggests they would differ, since the tool did not move this take's hips or legs at all.
- The numbers are on the pack's skeleton; FP2POSE3's are on our body after our bake. Compare within a column, not across documents.
- Inbetweening and a viewport capture were asked for and not delivered (section 1 says why).
- The joint dumps and the .casc stay local (git-ignored): they are derived from the bought take.

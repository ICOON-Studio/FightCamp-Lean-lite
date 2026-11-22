# TASK AFRETARGET1 - the knee bend is in OUR retarget: play ActionForge's cross in the game, find the difference (S537)

Model: claude-fable-5-2 (Agent SDK, API credit). Discipline: boxing (demo). Standing approval for animation fixes (S510).
METHOD: fight player v2 only; no new correction layer; fixed side camera, both halves framed the same; open every frame
yourself and say plainly whether the difference shows.

## The finding (owner S537)
The owner loaded the bought cross (E:\FightCamp\packs\mocaponline_punch_pro\Boxing_01_v2\FBX\Box1_M3_Right_Cross.fbx) on OUR
body (assets/models/metahuman/mh_boxer_01.glb) in ActionForge: "the animation looks fine on actionforge, the knee twisting is
not there". The game shows the same take on the same body with the knee bent in (owner C462/C463/C471; BOUGHTCLIP1's middle
pane "our body, the take only" shows it too - so BOUGHTCLIP1's "the take itself" verdict was WRONG for the legs). So the
fault is our FBX -> MetaHuman retarget / bake (tools/*bake*, the BoneMap / retarget profile, rest-pose correction, bone
roll), not the take and not the v2 layers (KNEEROOT1 already took FootTake + Gloves off).

ActionForge's export of that cross on mh_boxer_01 (GLB, own skeleton, mesh included, not in place) is at
assets/anim/af_retarget/box1_m3_right_cross_af.glb (owner-approved download).

## Do
1. Import the AF GLB's animation in Godot onto mh_boxer_01 (same skeleton names - UE5 Manny layout) and play it in the v2
   player in place of pro_right_cross (a test switch, not shipped yet). Measure at contact, per leg: knee valgus (cm off the
   hip-ankle line), knee flex, foot yaw, stance width; and arm extension. Same numbers for our baked pro_right_cross
   (assets/anim/baked/mc_Box1_M3_Right_Cross.res) with every v2 layer off.
2. Find the cause: compare per bone, frame by frame, our baked local rotations vs AF's for thigh/calf/foot (and pelvis).
   Name the stage in our bake that produces the difference (rest-pose mismatch, bone roll, axis swap, a twist-bone, a
   "fix silhouette"/retarget option, the source skeleton's rest pose) with file:line.
3. Fix our bake at that cause so a re-baked pro_right_cross matches AF within 2 cm (knee) and 3 deg on thigh/calf; re-bake
   ONLY the cross takes first (pro_right_cross*), prove it, then list every other baked take the same fault touches (do not
   re-bake them all in this job unless the fix is a one-line bake option and the check passes on 3 sample takes).
   If our bake cannot be fixed cleanly, say so and propose shipping AF-retargeted GLBs instead (how many clips, how).
4. Tests: a RETARGETMATCH check (our bake vs the AF reference) red now, green after; player2_test, choreographer_test,
   arm_build_test, file_limits_test, golden_path_test green.
5. Film + stills, fixed side camera (hidden desktop): AF export | our bake before | our bake after. Open them yourself.
   ops/previews/s537_afretarget1/, docs/AFRETARGET1_RESULT.md (the cause in one plain sentence first; numbers; file:line).

## Prior research
docs/KNEEROOT1_RESULT.md, docs/BOUGHTCLIP1_RESULT.md, ops/research/ACTIONFORGE_HOWTO_S247.md, ANIM_TOOLKIT_S274.md,
memory reference_asset_ai_clauses_s495 (MoCap Online: no AI training; viewing/playing in our game is fine).

## What would a human do?
Put the good retarget next to ours bone by bone and find the one setting that differs.

## Prefab check
ActionForge itself is the reference retarget (free, local).

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who afretarget1 -- <command>`, one run at a time; windowed only via
tools/hidden_desktop.py; nothing opens on the owner's monitors. Do not edit LineGrade.gd, LiveRound.gd, StepWire.gd,
MHRig.gd (report a cause there instead). No script over 500 lines. `git add -- <new>` then `git commit -m ... -- <your
paths>` with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, pull --no-rebase --no-edit, push, report in two
lines, stop.

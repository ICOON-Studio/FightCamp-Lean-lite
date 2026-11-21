# TASK BODYTEX2 - every body looks like a fighter: muscle skin on all, shape fixed where it caves, the shoulder seam

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S535: "the bodies look terrible and barely remind normal fighters, there are no abs weird shaped bodies etc", "the
stomach goes inside weirdly the chest on the black guy look weird"; Q-S294-295 (MetaHuman maps outside Unreal): "Use them anyway".
Visual gate: stills on the fight camera opened by you, before|after, on the review board; the owner closes it.

## Where it stands (read first)
- docs/BODYTEX1_RESULT.md + commit 699c265d8: boxer 01 wears Epic's detail set Chr0023 at 2K (ops/Tools/metahuman/bodytex1_make.py);
  MHRig.dress reads `<glb>_mh02_body_albedo_2k.png` / `_normal_2k.png`. In ops/previews/s535_mhcorr/4_close_light_man.jpg boxer 01
  shows abs and a chest line; boxer 02 (3_close_dark_man.jpg) is still smooth.
- Commit c18ca201e (MHCORR2): the DNA correctives are in fight player v2. Its finding: the caved stomach is the BODY SHAPE (wide
  ribs over a very narrow waist, bodies 02 and 07), not the spine, the maps or a corrective.
- A thin dark seam line crosses the top of the shoulder / base of the neck on several bodies in those stills (likely the head-body
  mesh join or a clavicle helper) - find out which.

## Do
1. SKIN, all bodies (mh_boxer_01..NN that boxers use; list them from assets/models/metahuman): pick a detail set per body
   (Chr0023 or Chr0035 for the men, a lean set for the women - say why), build the maps with bodytex1_make.py, as JPEG quality ~92
   (~1.2 MB a body; add the JPEG loader beside MHRig._png) to keep the repo light. Each body keeps its own skin tone.
2. SHAPE, where it caves or reads untrained: from each body's mh_boxer_NN.json (requested muscularity / fat / chest / waist),
   re-export the bodies that need it with more muscularity, low fat and a waist that fits the chest, through UE 5.8 headless
   (-unattended -nullrhi), the same pipeline that made them (find it: ops/research MH4 / mh2 notes, ops/Tools/metahuman). Keep the
   skeleton, the joint names and the correctives' tables valid (mh_dna_correctives_test, arm_build_test, player2_test green). If a
   re-export cannot keep the skeleton identical, stop and report before changing any mesh.
3. SEAM: find and fix the dark line at the shoulder / neck top.
4. Stills: tools/mhcorr_still.gd (fight camera, both men head to feet + the close torso views), before|after for every body
   changed, a contact sheet per 4 bodies. ops/previews/s535_bodytex2/, review board:
   `python ops/Tools/review_add.py --stage S535 --rating "<your score>" --title "Bodies: muscle skin + shape, before|after" <files>`.

## Prior research
docs/BODYTEX1_RESULT.md, ops/research/S263_DIGEST.md (look A/B, MetaHumanLook skin presets), J_CLOTHES2_S208.md,
memory feedback_metahuman_only_no_mpfb (MetaHuman only), feedback_serious_sim_look_menu_structure_s430.

## What would a human do?
A character artist makes the base body read as an athlete (shape), then lets the detail maps carry the muscle lines, and checks
it under the game's own light and camera.

## Prefab check
Epic's MetaHuman body sets in UE 5.8 (owner: use them). Nothing to buy.

## Contract
OWNS: assets/models/metahuman/ (body maps and, only if step 2 needs it, the body .glb files), scripts/fight3d/MHRig.gd,
ops/Tools/metahuman/bodytex1_make.py, docs/BODYTEX2_RESULT.md
RED_TEST: tools/mhcorr_still.gd (before|after stills - a visual probe)
REGRESSION: tests/mh_dna_correctives_test.gd, tests/arm_build_test.gd, tests/player2_test.gd
VISUAL: yes

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who bodytex2 -- <command>`; windowed only on the hidden desktop; UE headless.
The owner may be playing a game: be patient with the queue. Never stage LineGrade.gd, LiveRound.gd, StepWire.gd. Stage explicit
paths, commit to main with the Co-Authored-By line, push, report in two lines, stop.

# TASK BODYTEX1 - athletic body skin: the real MetaHuman body textures (abs, muscle definition), phase 1 = one body proven

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Owner S535: "the bodies look terrible and barely remind normal fighters, there are no abs weird shaped bodies etc , what is wrong ?"
Rule kept: MetaHuman bodies only (never MPFB / generator / Tripo bodies - memory feedback_metahuman_only_no_mpfb).

## What Claude found (S535)
- `assets/models/metahuman/mh_boxer_01_mh02_body_normal.jpg` is 1024 x 1024 JPEG and nearly FLAT: no abdominal, pectoral or
  serratus definition at all ("synthesized" per scripts/fight3d/MHRig.gd:178). The albedo is 1024 JPEG with no cavity / muscle
  shading. A real MetaHuman body ships 4K-8K normal + cavity maps that carry the muscle definition. So under any light the torso
  reads as a smooth plastic shape.
- The deformation half (chest and shoulders folding in the guard) is a separate task: MHCORR2 (the DNA correctives), running.
- UE 5.8 is installed (C:\Program Files\Epic Games\UE_5.8, MetaHuman plugins under Engine/Plugins/Experimental/MetaHuman and
  Toolsets/MetaHumanGenerator). The S209 MH4 backup is at E:\FightCamp\backup_untracked_S209_mh4.
- The bodies' requested shape is in assets/models/metahuman/mh_boxer_NN.json (e.g. boxer 01: muscularity 1.4, fat -1.3).

## Do (phase 1 only - one body, proven, then stop)
1. Find where the real MetaHuman BODY textures live in UE 5.8 (plugin content: body normal, cavity, roughness / the muscle
   "animated maps" if any) and how S209 / the MH4 build exported ours (ops/research: grep MH4, mh_pilot_02, body_normal). Say
   why ours ended up 1024 and flat.
2. Export them for boxer 01 at 2048 (PNG or a high-quality JPEG; keep the repo light: say the size) through UE Python, headless,
   nothing on the owner's monitors (memory: hidden desktop / -unattended -nullrhi where possible). Licence: MetaHuman assets are
   allowed only rendered in Unreal under the MetaHuman EULA - CHECK the current EULA text for use outside Unreal (UE 5.6+ changed
   it); if it forbids it, stop and report: that is the owner's call.
3. If the body SHAPE is the problem too (no visible abs even with a good normal map), say which MetaHuman body parameters would
   fix it (muscularity, fat, chest/waist) - do not re-export the meshes in phase 1.
4. Wire boxer 01's new maps (MHRig.gd material path; the micro normal stays) and render before|after stills on the hidden desktop
   through godot_slot (tools/fight3d_still.gd, broadcast camera, still_framing: both men head to feet; plus one closer torso still
   that is about the skin). Open them yourself. ops/previews/s535_bodytex/, review board:
   `python ops/Tools/review_add.py --stage S535 --rating "<your score>" --title "Body skin: before|after (boxer 01)" <files>`.
5. Report: the stills, the licence answer, the size cost for all 12 bodies, and what phase 2 (all bodies, shape) would take.

## Prior research
`python ops/Tools/prior_research.py metahuman body texture normal export` first. S263_DIGEST (look A/B, MetaHumanLook skin presets),
J_CLOTHES2_S208.md, memory reference_asset_ai_clauses_s495 (licences), feedback_metahuman_only_no_mpfb.

## What would a human do?
A character artist would use the source 4K body maps with the muscle detail, add a cavity / AO pass, and only then judge the shape.

## Prefab check
The MetaHuman body maps themselves (Epic, installed with UE 5.8). Nothing to buy.

## Contract
OWNS: assets/models/metahuman/mh_boxer_01_mh02_body_normal_2k.png, assets/models/metahuman/mh_boxer_01_mh02_body_albedo_2k.png,
scripts/fight3d/MHRig.gd, docs/BODYTEX1_RESULT.md
RED_TEST: tools/fight3d_still.gd (before|after stills - a visual probe)
REGRESSION: tests/player2_test.gd
VISUAL: yes (stills on the broadcast camera + one torso still)

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who bodytex1 -- <command>`; windowed only on the hidden desktop. UE runs
headless/unattended only. Another console (MHCORR2) is editing scripts/fight3d/v2 - do not touch v2 files; MHRig.gd is yours.
Never stage LineGrade.gd, LiveRound.gd, StepWire.gd. Stage explicit paths, commit to main with the Co-Authored-By line, push,
report in two lines (what you found; the stills' paths), stop.

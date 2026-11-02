# TASK MH5 - cast look round 2: no heavy bodies, slim coaches, attractive women, no chest fold (S210)
Model: gpt-6.1-sol (Codex). Worktree E:\FightCamp\wt\MH5 (seed it: Tools\seed_godot_cache.ps1), branch codex/mh5-look from master.
Long task - batches, commit + push after each, keep going.

## Operator (S210 board comments on the MH4 stills, verbatim)
- C41 on lineup_4_sex.png (women boxers 11-12, members 1-4): "they are all terrible , coaches needs to be slim , do not put fat
  people in the game , make the women hot."
- C42 on lineup_5.png (boxers 05/06 chests): "this chests look malformed"
- C46 on boxers.png (boxer 02 chest): "fix it it looks folded"
- C44/C45 on ual1/walk.jpg (mh_staff_coach + mh_staff_desk walking): "what the fuck is that thing ?" - see part C, it is mostly
  the retarget posture, but the bodies under the tee must also read slim.
Earlier (S207): "stop making fat people". MetaHuman bodies only (no MPFB/Tripo anywhere).

## Prior research
MH4_DIGEST.md (your pipeline: Tools/metahuman/mh4_*.py, Creator constraints, Blender -> GLB, scoped imports, affinity guard),
MH2/STAFF1 digests, J_CLOTHES2_S208.md (clothes; J_CLOTHES3 free-pack census running - do not buy anything),
previews/mh4/audit_final.txt (the numbers PASS but the eye says heavy: numbers alone do not close this task).

## What would a human do?
A character artist opens the line-up beside reference photos of real fit people (pro boxers, gym coaches, fitness models), fixes the
silhouette in Creator until it reads athletic at a glance in clothes AND bare, and checks the chest in the poses the game uses.

## Prefab check
MetaHuman Creator presets + its body/garment options (installed, free). Free clothes only (operator: "we donot spend money on this").

## A. Chest fold (defect, fix first)
Bare-chested boxers 02, 05, 06 (and check ALL 12) show a horizontal crease/fold across the pecs in the A-pose line-up.
Find the cause before changing bodies - candidates: Creator fat/muscle constraints at the extreme (fat -1.5) collapsing the pec,
a corrective/RBF pose or morph lost in the Blender export, a normal map at 1024 baked wrong, or bad skin weights on spine_04/05/clavicle.
Prove it with a front + 3/4 chest close-up of ONE boxer before and after (Godot, hidden desktop). Then fix every boxer that has it.
Acceptance: chest close-ups for all 12 boxers in A-pose AND in the boxing guard (load `assets/anim/cascadeur` guard via the same path
the fight uses) - no fold, no crease, pec reads as one muscle. Save to previews/mh5/chest_<name>_{apose,guard}.png.

## B. The look
- NO HEAVY BODIES: every staff/member/boxer reads lean/athletic in the tee at a glance. Rebuild coach (Walter) and coach_3 (Jorge)
  slim - fit men in their 50s (grey hair, lean face, flat stomach, a coach's build). Re-check desk, physio, cleaner, cutman, members.
- WOMEN ATTRACTIVE: young (20-32 for boxers and members, staff up to ~40), attractive faces (pick the best-looking Creator presets,
  not the plainest; balanced features, clear skin), athletic-feminine figure (defined waist, toned arms/legs, hip-waist ratio ~0.7),
  hair styled. Women boxers: fitted sports top / sports bra + boxing shorts look, NOT a loose white tee. Women staff/members: fitted
  gym wear. If Creator's installed garments have only the loose tee, use the tightest fitting option it has, tint it, and say so in the
  digest - WARDROBE1 brings free clothes later.
- Keep the MH4 variety rules (unique face preset, unique groom+skin, six ethnicity groups, >=40% women outside male boxers) and
  the size budget (6 MB bare boxer / 8 MB clothed). Same file names - replace in place.

## C. Walk/idle posture (UAL1 retarget) - only if Claude has not fixed it (check `git log -- Godot/assets/anim/ual` first)
On `ual1/idle.jpg` / `walk.jpg` the same lean coach + desk models stand with a pushed-out belly and bent knees; in the A-pose line-up
they are lean. `assets/anim/ual/UALMotion.gd` maps only spine_01..03 (MetaHuman has spine_01..05) and corrects rests through
`FightClipRetarget.silhouette_rest`. Make idle/walk/talk/sit stand upright like the source clip.

## Deliver
- GLBs + per-model JSON in Godot/assets/models/metahuman/, previews/mh5/ (lineups head-to-feet via mh_lineup.gd, 6 per
  image: clothed AND bare-torso for boxers; chest close-ups; the walk/idle strips re-shot with `tools/ual_strip.gd`).
- Open every still yourself; reject and redo anything heavy, plain or creased. research/MH5_DIGEST.md with a before/after table.
- Do NOT post to the review board; Claude does.

## Owned files
Tools/metahuman/ (mh5_* new), Godot/assets/models/metahuman/, Godot/tools/mh_lineup.gd, previews/mh5/ (NEW),
research/MH5_DIGEST.md (NEW); part C only: Godot/assets/anim/ual/UALMotion.gd (97 lines).

## Acceptance (test tier: assets + one script)
`python Godot/tools/check_scripts.py <touched .gd>`; `python Godot/tools/run_tests.py --jobs 2 --only staff,metahuman,mh2,ual`
(nothing green goes red); the cast audit still PASSES body + variety; the stills above exist and you opened each one.

## Rules
Watchdog before every UE/Blender/Godot launch (`Tools\pc_watchdog.ps1 -Once`; RED = suspend, never kill, wait). One UE and one Godot
at a time, the MH4 affinity guard on UE. Windowed Godot only via Tools\godot_hidden.ps1; never open image viewers/browsers (file tool).
Never master. `git add -- <files>` only.

## The one trap
The MH4 audit PASSED on numbers while the operator saw fat people: Creator waist/height constraints do not control the belly under
a loose garment or the posture in motion. Judge by the stills, in clothes, in motion, from the side.

## S221 ADDENDUM - no hair on two boxers (operator S221: "yellow boxer has no hair")
`Godot/assets/models/metahuman/` has hair-card textures for mh_boxer_01, 03, 04, 05, 06, 08, 09 but NONE for mh_boxer_02 and
mh_boxer_07 - those two render bald in the live fight (Perez in flyfoot1_20s.mp4 = mh_boxer_02). Re-export both WITH a groom (hair
cards + brows), different hair from the others (the cast must not look alike), and add a check that every shipped boxer body has
hair cards unless the cast sheet says "shaved head" for that body.

## S221 ADDENDUM 2 - operator C60 on the fight still (Perez = mh_boxer_02, male): "i do not want to see bold women"
The bald body 02 (no hair cards) with its round hips reads as a WOMAN to the operator. Fix: 02 (and 07) re-exported with hair AND a
clearly male read (shoulder/hip ratio, jaw, brow); add a cast check that NO female body ever renders without hair, and that every
male body reads male at the game camera (Claude judges the stills; the operator closes it).

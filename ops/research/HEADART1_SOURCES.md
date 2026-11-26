# HEADART1 - where the head-movement animations come from (S559, research only)

Brief: `ops/research/TASK_HEADART1.md`. Owner S559: "do youthinkwe should add the head ?" then "Yes, measure it"; the page
is `proto/twohands/head.html` (FEET switch l.154-159: slip, roll, lean back, slip in; rules l.230-243). Nothing was
downloaded, signed into, bought or run in Godot. Read: directory listings (Lean `assets/anim`, `E:\FightCamp\packs`,
`E:\FightCamp_backup_D`, `C:\Users\user\Downloads` names only), the old repo's git tree
(`gh api repos/ICOON-Studio/FightCamp/git/trees/master?recursive=1`), our clip tables and research pages cited below.

## The short answer
- **We already own and ship a full slip / weave / pull family, on our MetaHuman, in the fight today.** MoCap Online Punch PRO
  (bought, 145 clips baked as `assets/anim/baked/mc_Box1_M3_*.res`, played as `pro_*`, `scripts/fight3d/FightClips.gd` l.129-141):
  `Box1_M3_Left_Dodge`, `Right_Dodge`, `Back_Dodge`, `Left_Weave`, `Right_Weave`, `Back_Weave`, `Quick_Weave` (raw FBX in
  `E:\FightCamp\packs\mocaponline_punch_pro\Boxing_01_v2\FBX\`). Punch Starter adds `mc_Punch_M3_Left_Dodge` / `Right_Dodge`.
  `scripts/fight3d/BeatClips.gd` l.85-113 already picks the side: a straight punch is slipped to the OUTSIDE, a hook rolled
  in the direction it travels (`tools/dodge_side.gd` measured which way each clip moves the head, S305); `pull` = `pro_back_dodge`.
  Also in v2: `assets/anim/baked/v2/stance/pro_{left,right,back}_dodge.res`, `pro_{left,quick,right}_weave.res`, `mc_dodge_{left,right}.res`.
- **The pictures (pics2d) do not use them yet**: `tools/pics2d_anim_more.gd` bakes steps, holds, clinch, push off, punches only
  (l.2-21). So head.html's four moves need RUNS from owned takes, not new motion.
- **Older owned extras**: RamsterZ (bought, Unity EULA, `CLIP_LICENCE_LIST_S392.md` s5) ships `baked/boxing_slip.res`,
  `boxing_pull.res`, `ow_side_lean.res`; the old repo also holds RamsterZ `H2H_SlipLeft(_v1)`, `H2H_SlipRight(_v1)`,
  `H2H_Dodge_{Left,Right,Back,Forward}` FBX (`Godot/assets/anim/audition/ramsterz_h2h/`). Ailive Fab pack (owned,
  `Downloads/boxing.zip`, Fab licence, EUR 8.47 Personal - `FAB_AILIVE_S273.md`): `Dodging with a Ducking` / `with a Sway`, baked
  but not committed in `assets/anim/baked/ailive_trial/` - rejected on eyes in S381 ("sway a 2 s lunge with hands low",
  `OWNED_MOCAP_S381.md` l.19) and S447 (relaxed-stand start, 0.9-1.2 m lunge, `AILIVE_SPEED_S447.md`).
- **Known defects of the owned dodges, on record**: they are exported in place and walk both feet back to the start
  (`scripts/fight3d/SideStep.gd` l.2-9: cut where both feet first stand, ~0.73 s); "our slips turn her back"
  (`ANIMATION_GAPS_S439.md` l.77, S434). **Gaps**: no duck straight down, no slip forward under a punch, no inside dodge
  (same page l.75-80); no slip-counter take (`C223_DIGEST.md` l.630: Mixamo Dodge Advance "shows travel/ducking, not a counter").
- **Mixamo (web)**: the catalogue search needs a sign-in, so the names below are Mixamo's own export names as they sit in
  Downloads (`Name__Description.fbx`) - a web search found no public list (NOT FOUND on the web). Boxing-usable:
  `Boxing_Dodge_Advance.fbx`, `Boxing_Dodge_Retreat.fbx` (also `E:\FightCamp\packs\mixamo_steps`, baked as `steps/st_dodge_adv.res`,
  `st_dodge_ret.res`), `Standing_Dodge_{Left,Right,Forward,Backward}__Dodge_*_With_Bow.fbx`. Not boxing (flips, falls, capoeira):
  `Corkscrew_Evade`, `Dodging_Back__Jumping_Backwards_Dodge`, `Edge_Slip`, `Slipping__Frantically_Slip_And_Fall`, `Ginga_*`.
  No Mixamo "bob and weave" or "duck" boxing file is in Downloads: NOT FOUND.
- **Rejected sources**: Meshy `093_Dodge_and_Counter`, `156-164_Stand_Dodge*` (`E:\FightCamp_backup_D\sources\meshy`, old repo
  `meshy_lib`) - a generated rig/body (MetaHuman-only rule) and no licence on record. Wrestling `c221_source/wrestling_duck_under`
  is a takedown, not a boxing duck.
- **Buy-if-needed**: Fab "Boxing Animation Pack" (animo-mocap, EUR 58.57, Fab EULA, AI use: No) has slip left/right, pull back,
  bob-and-weave left/right, head movement x2 - slips that keep facing the opponent (`MOCAP_PACKS_S439.md` l.30,
  `ANIMATION_GAPS_S439.md` l.23/80; the owner said he would buy it near month end). Reallusion "Martial Arts - Boxing Dodge"
  (Sidekick, USD 33.00 list; the USD 19.80 sale ended 19 Nov 2026) has slip-and-counter segments but needs iClone/CC to export
  (`MOCAP_PACKS_S439.md` l.34).

## Our own studies (what the old project measured and settled)
- Slip answers straights, duck/weave answers hooks (uppercut and knee punish it), pull-back works only at the edge of range and
  loses to a forward-stepping straight - `J50_HOW_A_DEFENDER_DEFENDS.md` rows 8-10 (S18/S19 UFC 3 dev notes, S41 Atlas,
  S46): exactly head.html's rules (l.112-115).
- Real amateur winners shift back 23.3% of defensive actions, duck 4.0% - `J50` l.87 (S37); head movement is a small,
  constant motion, not a pose.
- A jab is 405 ms from first movement to contact, a hook ~590-660 ms (`J50` l.106-110): a slip take must be fully off the line
  inside ~0.35 s; our dodge starts min(head peak, 0.33 s) before the contact (`docs/RINGANIM1_RESULT.md` l.53, `ChoreoRules.DEF_LEAD_S`).
- Boxing slip/roll/bob-weave/pull are four evade nodes in the tree (`Q71_BOXING_EVASION.md`); `boxing_slip_counter` existed with
  no slip under it (`R128_BOXING_KICKBOXING_TREES.md`).
- The ghost step: our step-in take `st_in_m` (Mixamo Medium Boxing Step Forward, `assets/anim/baked/steps/CREDITS.md`) already
  moves the LEAD foot first and the rear after it with no moment of both feet off the floor (`assets/data/foot_db.json` planted
  windows: lead 0.517-1.0 s, rear 0-0.583 s); `st_out_m` moves the rear foot first (rear planted 0-0.1 s, lead 0-0.467 s). Whether
  the lead foot SLIDES (toe on the canvas) or lifts is not in foot_db (it stores planted windows only): NOT MEASURED.

## The table

| move | have it? | best source | licence | cost | how it reaches our body | verdict |
|---|---|---|---|---|---|---|
| **Slip left / slip right** (head.html "Slip") | YES, shipped: `pro_left_dodge`, `pro_right_dodge` (+ `mc_dodge_left/right`, RamsterZ `boxing_slip`) | Punch PRO `Box1_M3_Left/Right_Dodge` | MoCap Online Standard (`CLIP_LICENCE_LIST_S392.md` l.204-210) | $0 (owned) | already baked `.res` on MetaHuman; `BeatClips.defence` picks the side | **USE**, cut at "both feet stand" (SideStep) for the picture; fix the back-turn with a spine yaw bake if the 31 deg camera shows it |
| **Roll under, both ways** (bob and weave; "Roll") | YES, shipped: `pro_left_weave`, `pro_right_weave`, `pro_quick_weave`, `pro_back_weave` (owned, not in rotation) | Punch PRO `Box1_M3_Left/Right_Weave` | MoCap Online Standard | $0 | baked `.res`; `BeatClips.DEFENCE["weave"]` | **USE** - a U under the hook needs the real knee-and-hip path; keep the capture |
| **Duck** (straight down) | NO (`ANIMATION_GAPS_S439.md` l.79) | AUTHOR: knee bend + hip drop + spine fold, guard kept (`BoxerFootworkRig` already has a duck floor, l.40/167) | ours | ~1 h bake | new pose in `pics2d_hold_bake.gd` style (legs: two-bone solve per key, as BODYCROSS's sink) | **AUTHOR** - not on head.html yet; cheap from the side |
| **Lean back / pull** ("Lean back") | YES, shipped: `pro_back_dodge` (+ RamsterZ `boxing_pull`) | Punch PRO `Box1_M3_Back_Dodge` | MoCap Online Standard | $0 | baked; `DEFENCE["pull"]` | **USE**; fallback AUTHOR (spine tip back + weight to rear foot; `CornerIK.upright` does the trunk tip already) |
| **Slip in** (step + slip; "Slip in") | PARTLY: `st_dodge_adv` (Mixamo Boxing Dodge Advance) = travel + duck; no slip-forward take (`ANIMATION_GAPS_S439.md` l.76-79) | COMBINE: `st_in_m` feet + `pro_*_dodge` upper body, or Mixamo Boxing Dodge Advance as is | Mixamo terms (steps CREDITS) / MoCap Online | $0 | the frame-run already carries the body along a step (`pics2d_anim_more.gd` _step_run); lay a slip's spine/neck on it as a bake | **AUTHOR the blend**; try Dodge Advance first (C223 saw ducking, not a counter) |
| **Ghost step in / out** | YES as steps: `st_in_m`, `st_out_m` (front foot first in, rear first out, no flight - foot_db) | Mixamo Medium Boxing Step Forward / Backward (owned, baked) | Mixamo royalty-free, no raw redistribution | $0 | already the Ring Switches step runs (`RINGANIM1_RESULT.md` l.36) | **USE**; if the 31 deg picture shows the lead foot lifted, AUTHOR a slide (pin the toe height to the canvas in the bake) - the push off the rear leg is already in the take's order |
| **Slip-counter** (slip then cross) | NO single take (`C223_DIGEST.md` l.630) | CHAIN: `pro_*_dodge` cut at its low point -> the owned cross from the same place (as RINGANIM1's "counters exist in the rules") | MoCap Online | $0 | two takes joined in the frame run (JoinSmoother pattern) | **CHAIN**; buy only if the join reads wrong: Fab Boxing Animation Pack slips or Reallusion Boxing Dodge |
| **Roll-counter** (roll then hook) | NO single take | CHAIN: `pro_*_weave` (comes up on the far side) -> lead / rear hook from there | MoCap Online | $0 | as above | **CHAIN** - the weave already ends loaded on the side the hook comes from |
| (other owned, not recommended) | RamsterZ `H2H_SlipLeft/Right`, `H2H_Dodge_*` (old repo); Ailive Duck / Sway; Mixamo `Standing_Dodge_*_With_Bow` | - | Unity EULA / Fab / Mixamo | $0 | UE4 rig -> MetaHuman (flares on record) / RkRetarget | **SKIP**: Punch PRO covers each; Ailive rejected twice on eyes; "With Bow" is not boxing |

## What a bake can make convincingly (side camera raised 31 deg)
- **Lean back, slip (as a pose), duck**: spine + neck + knee changes with the guard kept - the same two-bone and turn tools as
  `tools/pics2d_hold_bake.gd` (arms held from the guard, 310 lines) and `tools/pics2d_bodycross_bake.gd` (hip sink with the
  feet planted, knees over toes). From the side a lean back and a duck read fully (depth and height are in the picture plane);
  a slip is sideways to the camera, so it reads only through the head crossing the shoulder line and the trunk tilt - the
  raised 31 deg view helps. Bake is enough for the head.html pictures.
- **Roll / bob and weave**: needs real motion - the head travels a U under the hook (down, across, up) with the knees and the hips
  shifting weight; a bake of two keys reads as a duck. Use the owned weaves.
- **Ghost step slide**: a bake can pin the lead toe to the canvas through the step (a foot-height constraint), keeping the take's
  timing; no new capture.

## Recommended route (five lines)
1. Slip, Roll, Lean back for head.html: frame runs from the owned Punch PRO takes (`pro_left/right_dodge`, `pro_left/right_weave`,
   `pro_back_dodge`), side chosen by `BeatClips.defence`, cut at the SideStep "both feet stand" point - a new block in `pics2d_anim_more.gd`.
2. Slip in: `st_in_m`'s step with a slip's upper body baked on (hold-bake method); compare with Mixamo Boxing Dodge Advance on one picture.
3. Ghost step: keep `st_in_m` / `st_out_m` (already front-foot-first, no jump); look at the 31 deg still, author a toe slide only if it lifts.
4. Counters (slip-cross, roll-hook): chain owned takes in the frame run; no purchase.
5. Buy nothing now; the Fab Boxing Animation Pack (EUR 58.57) only if the stills show the Punch PRO slips turning his back - the owner's month-end buy already planned.

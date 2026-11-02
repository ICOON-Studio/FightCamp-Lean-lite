# R142 — THE UNITY SALE SHORTLIST: 25 PACKAGES, WHAT TO BUY, WHAT TO COMBINE, WHAT WE WOULD USE

Claude, 2026-09-13. Research only, no `.gd` touched. The sale opens **2026-09-14** ("50% off 300+
best sellers", on record in R105 and TASK_J23). Machine-readable twin:
`research/R142_asset_shortlist.json` (one row per package, plus the bundle's parts).

**How every figure was read.** Each package's server-rendered store record
(`assetstore.unity.com/packages/package/<id>`: price, size, Unity version, render pipelines, licence
flag, description) and its **Package content file list** — the store's own tab, fetched through the
store's public GraphQL query `PreviewAssets`, paginated, no login. Screenshots were **looked at** for
the 13 candidates that could be bought. **All three free packs were downloaded by the operator
(2026-09-13 03:05-03:14), extracted without importing, and read from the files:** the FBX with
`FBXDocument` in Godot 4.7, the scripts and animator as text. **No package showed a discount on
2026-09-13**, so no sale price is quoted; which packages the sale includes is unknown until it opens.

**The operator's direction, same day:** *"i am thinking of using some 3d scenes instead of heavily
text-base menus."* The gym, arena and workout rows below are judged as **stages for 3D menu scenes**
(the gym hub's FLOOR, the title room, honours, fight night), not only as fight art.

**Standing rulings applied, not re-asked:** animation purchases are ON HOLD until S4a diagnoses why
the retargeted clips look bad; buy on Unity, never FAB or direct; ripped/licensed assets stay out of
the repo until C45 says where they live.

## THE BUY LIST

| # | package | list EUR | verdict | why, in one line |
|---|---|---:|---|---|
| 1 | **Combat Arenas & Fighter Characters Pack** (Mixall, 396548) | **103.04** | **BUY AT SALE** | It IS five packs — 20 Fighters, Octagon, Boxing arena, Boxing hall, Japan Dojo (EUR 147.15 apart). Arena set + fight gym + gi bodies in one style. |
| 2 | Fitness hall - sports equipment (Mixall, 127334) | 27.59 | BUY AT SALE (second priority) | The strength and cardio stations the Boxing hall lacks, in the bundle's own style. |
| — | Fighting Motions Vol.1 (76699) | 0 | **FREE - DOWNLOADED** | S4a's second-source probe, and a tight grounded-kick set with a 3-region block/damage matrix. |
| — | Low Poly Old-School Gym Equipment (313032) | 0 | **FREE - DOWNLOADED** | Blockout props for laying out a 3D gym floor. Not shipping art. |
| — | 3D Modern Menu UI (116144) | 0 | **FREE - DOWNLOADED** | Read from the files: its "3D menu" is two camera poses behind flat panels. Thin reference; nothing ports. |
| H1 | Muay Thai AnimSet Pro (107262) | 32.20 | BUY AT SALE IF S4a CLEARS | Answers J23: grounded round kicks, teeps, elbows from 3 angles, 33 graded hits. No knees. |
| H2 | Martial Arts Master (311647) | 45.99 | BUY AT SALE IF S4a CLEARS | Same rig as what we own; 30 paired pairs incl. plum knees and a wall pin (R105 said none). |
| H3 | Combat animations - Karate (206861) | 17.47 | BUY AT SALE IF S4a CLEARS | 78 karate clips named in karate terms, grounded kicks, both stances. |
| H4 | GYM Workout Animation Pack (303410) | 18.39 | BUY AT SALE IF S4a CLEARS | Only if 3D gym scenes are greenlit; animates the weights corner, not bag work. |
| — | Octagon (209412), Boxing arena (213484) | 27.59 each | COMBINE WITH 396548 | Both are inside the bundle, file for file. |
| — | Full Mount Attacks (227372) | 10.11 | OWNED | Price confirmed. |
| — | 12 others | — | SKIP | See the sections below. |

**Now, not held:** EUR 103.04 (+ 27.59 if the equipment set is wanted now). **Held, if S4a clears:**
EUR 114.05 at list for all four (H1-H4), EUR 95.66 without the workout pack.

**CHECK AT CHECKOUT.** If the sale halves the five Mixall parts but not the bundle, the parts win
(EUR 73.58). If it halves the bundle, the bundle wins (EUR 51.52). Compare on the day.

**THE HOLD HAS A CLOCK.** S4a is sequenced after S2 and S1f. If the operator wants the held rows at
sale price, S4a has to run before the sale closes. That is a one-word reorder, and it is the
operator's.

## THE COMBINATIONS — ONE OF EACH, NOT THREE

- **One arena set: Mixall's Octagon + Boxing arena** (inside 396548). One publisher, one PBR material
  model (Albedo/Normal/Metallic/AO), Built-in/URP, real scale; their baked lightmaps are discarded and
  we relight. **The ring and cage meshes are optional:** `ArenaRig` already builds both to real dimensions
  from `arena_specs.json`. The VENUE is what we are buying: seating, lights, screens, commentary desk,
  cameras, judges' table. **No package in the list sells a competition tatami hall.** The six tatami
  profiles (`karate_tatami`, `judo_tatami`, `taekwondo_tatami`, `wrestling_mat`, `sambo_mat`,
  `grappling_mat`) are the Boxing arena **hall** with an authored mat in place of the ring.
- **One gym interior: Mixall's Boxing hall** (inside 396548). The only FIGHT gym in the list: ring,
  heavy bags, speed ball, BOB, wall pads, lockers, trophies. The six other gym interiors are
  commercial fitness clubs.
- **One equipment set: Mixall's Fitness hall - sports equipment (127334)** for `compact_weights`,
  `cardio_floor` and `exercise_bike`, because it shares the bundle's style and material converter.
  The free Low Poly set stands in as blockout until then.
- **Pairs that do NOT sit in one scene:** VIP Gym (dark HDRP) with Mixall; Low Poly (flat palette)
  with any PBR set; Gym & Fitness Club (sparse, flat light) with Mixall.
- **Animation, if S4a clears:** Muay Thai AnimSet Pro (grounded kicks, teeps, elbows, hits) +
  Martial Arts Master (paired clinch knees, cage pin, counters) + Combat animations - Karate. They
  cover each other's gaps and barely overlap.

## WHAT IT COSTS TO BRING ANY OF IT INTO GODOT 4.7 (FORWARD+)

FBX meshes and PNG/TGA/TIF textures import directly (`FBXDocument` read both free packs first time).
**Rebuilt:** every Unity `.mat` becomes a `StandardMaterial3D`. One converter over the `.mat` YAML
texture GUIDs serves all Mixall packs: 188 materials in the bundle, 21 in 127334. Every `.prefab`
becomes a Godot scene, mostly one mesh plus one material plus a collider (181 in the bundle). Prop
layout can be lifted from the `.unity` YAML transforms if wanted. **Discarded:** baked lightmaps (233
EXR in the bundle), post-processing, `.controller`/`.anim` Unity animators, all C# and uGUI. We light
in Forward+ the way `BootStage3D` already does. Animation packs add a bone map per rig family: UE4
Mannequin is done (22/22, R106/R107), and every other family needs its own map.

## CORRECTIONS TO THE RECORD, FOUND IN THE FILE LISTS

1. **R105 point 4, "NO PAIRED ANIMATION AND NO GRAPPLING" in Martial Arts Master, is wrong.** Its
   content list has **62 paired files: 30 two-sided attacker/victim or offender/defender pairs** (plus
   2 one-sided). They include `AttackGrab3KneesToRibs`, `AttackGrabKneeToFace`,
   `AttackGrabKneeStomachElbowFace` (clinch knees), and `AttackPushPinAgainstWall`
   Start/Loop/End/BreakFree (a cage clinch). R105 read a vendor page, not the package.
2. **HANDOFF.md says the Mixall pack has "no Thai fighter in it".** 20 Fighters' file list has
   `Thai_boxer_1` and `Kickboxer_1`.
3. **Q50 recorded 20 Fighters' gi and belt colour as NOT FOUND.** The store screenshots show a **white
   gi with a black belt** and blue gis. That is the karateka R111 could not show.
4. **The roadmap's "~US$60 MMA pack (auditioned, passed over)" is confirmed as MMA Fight Actions (271650,
   EUR 55.20).**
5. **Package 303410, the unnamed URL, is not a gym interior.** It is *GYM Workout Animation Pack*
   (Voxel Vision), an animation pack under the hold.
6. **Fitness hall - interior and props (142273) carries 127334's description word for word.** Its file
   list is an aerobics studio. Trust the list, not the copy.

## THE 3D-MENU DIRECTION: WHAT THIS BUYS, AND THE GAP NOTHING HERE FILLS

What the recommended rows give a 3D menu: the **gym hub FLOOR** as a real room (Boxing hall + 127334,
each station clickable against `equipment_catalog.json`); the **title room** with a karateka in a
white gi, a judoka, a Thai boxer (20 Fighters into `BootStage3D.FIGURES`); **honours** as belts,
medals and goblets on a shelf (Boxing hall `SM_Belt`/`SM_Medal`/`SM_Goblet`); **fight night** in a
real venue (Octagon, Boxing arena); and **a dojo** for karate and judo athletes (Japan Dojo). The
free 3D menu pack shows how little a "3D menu" template does. The mechanism already exists in
`BootStage3D`: a live room and a moving camera. What is missing is stations to stop at, and the
rooms above supply them.

**The gap: nothing in the 25 animates fight-gym WORK.** No heavy-bag work, speed bag, double-end bag,
skipping rope, pad work (a paired coach and fighter), shadowboxing, sparring or stretching. The one
workout pack animates weights only. A 3D gym reads as a fight gym through exactly that work.
**Catalogue stations no package covers:** `air_bike`, `rowing_ergometer`, `cold_water_tub`,
`rehabilitation_pool`, `sports_medicine_room` (HQ Gym's massage table is the only `physio_table`).
Both are research to assign before the 3D-scene question is asked, per the forecast rule.

## PER PACKAGE

### Animation

**1. Muay Thai AnimSet Pro** — Mister Necturus, EUR 32.20, 173 MB, Unity 5.1.1 (2018), Built-in.
Humanoid 65-bone Thai boxer included (17,198 polys, 4096 TIF). **145 clips in 9 multi-take FBX**,
with frame ranges on the store page: 19 blocks/evasions, 9 combos, 7 elbows, 17 general, 14 blows,
33 hits, 23 kicks, 16 steps, 7 turns. Root motion. **No knees.**
*We would use:* `muay_thai_teep` (Push_Kick); `muay_thai_round_kick`/`body_kick`/`low_kick`
(Ful_High/Mid/Low_Kik, Low_Kick_R — **grounded**); `muay_thai_horizontal_elbow` (Elbow_L/R),
`diagonal_elbow`, `up_elbow`; hands (jab, cross, hooks, liver/spleen hooks, uppercuts);
`karate_maegeri`, `kickboxing_axe_kick`, `kickboxing_side_kick`. Receivers: `react_head`,
`react_body` and `react_leg` graded A/B/C (9 each); `block` including kick blocks; `slip` (Evade,
HighKick_Evasion). Also 8-direction steps and turns for C94. *Cost:* slice 145 ranges, a new 65-bone
map. *Overlaps:* 311647, 76699, 206861. *On record:* J23's unanswered question, answered here.
**HOLD.**

**2. Taido Style Fight Animations** — Wolff's Studio, EUR 12.87, 97 MB, Unity 6000.1 (2026-07).
144 animation-only FBX, **numbered not named** (Kick01-50, Punch01-32, Combo01-22, BackKick01-10,
HitReaction01-10...), root motion and in place. *We would use:* nothing without watching all 144.
**SKIP:** not one of our disciplines, "back attacks" is beat-em-up idiom, and it is acrobatic.

**3. Kung Fu Martial Arts Fighting Style Pack** — Raisecreation, EUR 16.56, 9.1 MB, Unity 2022.3.
40 clips, **custom skeleton rig**, in place only, 60 fps: punches, kicks, combos, elbows, jump and
slide kicks, paw push, 10 reacts. **SKIP:** film wushu idiom and a bespoke rig map, with nothing a
named pack does not cover better.

**4. Acrobatic Kick Animations Part 1** — Wolff's Studio, EUR 10.11, 16 MB. 82 clips: Tornado x16,
Capoeira x14, SpinningKick x12, JumpKick x10, Taekwondo x8, and flips. **SKIP:** every clip is
airborne, which is R111's recorded defect. Capoeira has no ruleset. Revisit only for taekwondo
spinning kicks.

**5. Martial Arts Master** — RamsterZ, EUR 45.99, 21 MB, Unity 2022.3 URP. 212 clips in three stance
families (Fighter 105, HyperFocus 49, MasterStance 58). **62 paired files = 30 two-sided pairs.**
*We would use:* clinch knees (paired) for `muay_thai_clinch_knees`, which Muay Thai AnimSet Pro
lacks; the wall pin for `mma_underhook_cage`/`mma_cage_wrestling`; paired counters
(`boxing_slip_counter`, `boxing_catch_counter`, `boxing_counter_over_jab`); parries; 3 idles;
5 staggers. *Cost:* lowest of the animation rows, because the map is already written and measured
22/22. *On record:* R105 said buy at the sale once a RamsterZ rig measured, and R106/R107 measured
it. The later operator hold supersedes that: this is the same source through the same retarget, so
it is precisely what S4a must clear. **HOLD.**

**6. Fighting Motions Vol.1** — Magicpot Inc., FREE, 3.9 MB, Unity 5.4.2 (2016). **READ FROM THE
FILES.** 42 motion FBX + BlueGuy (913 vertices, 1.80 m: a mannequin). **21-bone humanoid:** Hip,
Body, Chest, Neck, Head, Collar/Shoulder/ForeArm/Hand L/R, Thigh/Shin/Foot/Toe L/R, which is 21 of
the 22 humanoid slots (no UpperChest). 30 takes plus **12 twins in `FBX/nomove/`** (the A2/B2 files;
the store list hides the folder). **Every clip is keyed from 0 to its end, 0.20-1.00 s, with no dead
air:** jab 0.20, cross 0.40, lead hook 0.50, rear uppercut 0.633, teep 0.50, body kick 0.75, high
kick 0.80, low kicks 0.60/0.70, blocks and damage 0.30, knockdown 0.80 + loop 2.00, getup 1.00.
*We would use:* `boxing_jab`/`cross`/`lead_hook`/`rear_uppercut`/`body_hook`;
`kickboxing_low_kick`/`body_kick`/`high_kick`/`side_kick`/`teep`; `react_head`/`react_body`/`react_leg`
(hd/bd/ld_front); `block` in three regions (hb/bb/lb_front); `knockdown`, getup, idle, steps.
**Its first job is S4a's second source:** a non-RamsterZ clip through the same retarget separates
"our retarget is wrong" from "that source is wrong". **FREE - DOWNLOADED.**

**7. "Martial Arts - Karate" Sidekick Motion** — sidekick animation studio, EUR 35.87. 18 Reallusion
CC motions named like an action RPG (light_attack_1/2, heavy_attack_1/2, skill1, hit_light, debut,
Victory). **SKIP:** about EUR 2 a clip for verbs, not techniques. #9 gives 78 named clips for half
the price.

**8. "Martial Arts - Wing Chun" Sidekick Motion** — EUR 41.40. The same 18-verb template. **SKIP:**
Wing Chun is not simulated.

**9. Combat animations - Karate** — Amine SAADI, EUR 17.47, 9 MB, Unity 2020.3. Humanoid, 78 clips
(54 in place, 24 root motion), pose-matched ends, **RP/LP stances with switch transitions**.
*We would use:* `karate_maegeri`/`kizami_maegeri` (MAE GERI front/back leg — grounded);
`karate_mawashigeri`/`maeashimawashigeri`; `karate_yokogerikekomi` (KEKOMI); `karate_junzuki`
(lunge punch); `karate_gyakuzuki`/`renzuki` (double punch V1-3); `karate_yamazuki`;
`karate_urakenuchi` (back fist, spinning back fist); `karate_gedanbarai` as block; SWAY as slip;
8-direction moves at 70 cm root motion. **HOLD** (cheapest held row).

**10. Full Mount Attacks** — RamsterZ, EUR 10.11. **OWNED** (R106).

**11. MMA Fight Actions** — Sports-Actions, EUR 55.20, 225 MB, Unity 2021.3. 157 FBX, 4 mobile
avatars (~12k tris, 70 joints). Its "grappling moves" are **pro-wrestling finishers named for WWE
signature moves** (Attitude Adjustment, Pedigree, Last Ride, Chokeslam) plus death animations, a
beat-em-up V_ attack set, and 11 kicks. **115 of its 157 files ship again in Boxing Actions.**
**SKIP** — confirms U46.

**12. Boxing Actions** — Sports-Actions, EUR 64.40, 236 MB. The same template plus about 45 hooks and
uppercuts **banded by distance** (head/body × lead/rear leg × near/normal/far), falls, 4 get-ups,
entrances, ring enter, warmup, `Idle_Normal_Menu`. **SKIP** at the highest animation price, with a
template U46 passed over. The distance-banded punches are the one unique thing in it, noted for
after S4a.

**22. GYM Workout Animation Pack** (the unnamed URL 303410) — Voxel Vision, EUR 18.39, Unity 6000.2.
55 in-place humanoid workouts: barbell, dumbbell, kettlebell, push-ups, pull-up, dips, planks,
lunges. **Equipment not included.** *We would use:* fighters on the `compact_weights` station in a
3D gym. *Missing:* all fight-gym work (bags, rope, pads). **HOLD**, and only if 3D gym scenes are
greenlit.

### Arenas, dojo and fighters

**13. Combat Arenas & Fighter Characters Pack** — Mixall, EUR 103.04, 1.14 GB, Unity 2022.3 (2026-07),
Built-in/URP. **Verified by file name to contain all of:** 20 Fighters (375770, EUR 36.79,
107/107 files), Octagon (324/326), Boxing arena (101/102), Boxing hall - interior and equipments
(127494, EUR 27.59, 187/190), Japan Dojo - Fight arena (264438, EUR 27.59, 153/155), plus 384 extra
baked-scene files. **Looked at:** the arenas are the best venues in the list, the Boxing hall is a
convincing fight gym, and the 20 fighters hold up at mid-distance. The store warns "single-mesh,
may not suit close-ups".
*We would use:* `mma_cage` venue; `boxing_ring` venue for boxing, kickboxing and muay thai; the
tatami profiles in that hall; the gym FLOOR (`club_ring`, `heavy_bag`, `speed_bag`, `grappling_dummy`
← wrestling punchbag, `focus_mitts_locker`, `striking_safety_locker`); 3D honours; a dojo scene;
`BootStage3D.FIGURES` (Karateka_1, Judoka_1, BJJ_1, Kickboxer_1, Thai_boxer_1, MMA_fighter_1/2,
Boxer_1-4, Wrestlers). **And an S4a control body:** a hand-rigged, hand-skinned body under the same
RamsterZ clip isolates S4a cause 4, Tripo auto-rig skinning. **BUY AT SALE.**

**14. Octagon - fighting ring and show arena** — Mixall, EUR 27.59, Unity 2019.4 Built-in. 34 models /
48 prefabs, 116 PBR textures up to 4096, seats and railings with LODs, commentator unit, LED cube
display, cameras, belt, gong hammer. **COMBINE WITH 396548.**

**15. Boxing arena - fighting show** — Mixall, EUR 27.59, Unity 2019.4 Built-in. 142.8k-tri hall,
ring with separated ropes, round screen, red/blue seating, judges' desk. **COMBINE WITH 396548.**

**16. Martial Arts Dojo** — 3D Everything, EUR 23.00, Unity 6000.0. 34 low-poly models, 1024
textures, a modern sport dojo on red/blue mats: bags, wooden dummy, kick shields, wall bars.
**SKIP:** below the Mixall set it would sit beside, and bags and dummies are covered. The red/blue
mat is a floor texture we can author.

### The gym and its equipment

**17. Fitness hall - interior and props** — Mixall, EUR 27.59. **SKIP:** an aerobics studio (fit
balls, step, small weights, mirrors), and its store copy is 127334's text.

**18. Fitness hall - sports equipment** — Mixall, EUR 27.59, Unity 2021.3 Built-in/URP. Treadmill,
stationary bicycle, barbell, dumbbells and two rack types, bench, bench press, power half rack.
*We would use:* `compact_weights`, `cardio_floor`, `exercise_bike`. **BUY AT SALE (second
priority)** for the style match.

**19. Low Poly Old-School Gym Equipment** — Poly Ronin, FREE. **READ FROM THE FILES:** one FBX, 27
mesh nodes laid out in a 2.87 × 2.61 × 2.76 m block at real scale, one material on a 135-byte palette
PNG. Bench, racks, 2 barbells, 5 plates, 10 dumbbells, 3 kettlebells, bench press, squat rack, leg
press, pull-up/dips station. **FREE - DOWNLOADED**, blockout only.

**20. VIP Gym Bundle** — MHK Art, EUR 33.12, 546 MB, HDRP/URP only. 141 FBX / 202 prefabs, rigged
machines, 2 machine animations, the deepest weights set, lobby and WC. **Looked at:** the
best-looking gym renders in the list, dark and premium. **SKIP:** a commercial club that does not
sit with the Mixall set.

**21. HQ Gym Interior** — Bright Vision Game, EUR 27.59, **946 MB for 38 props**, baked lighting.
Modern commercial gym. The one catalogue item unique to it is a massage table (`physio_table`).
**SKIP.**

**23. Gym & Fitness Club 3D Environment** — Enviable Game Studios, EUR 13.79. The cheapest paid gym
and the only one with fight-gym flavour (two punch bags, pads, tyre, drums). **Looked at:** a sparse
room with flat light and poster slogans. **SKIP.**

### UI

**24. 3D Modern Menu UI** — SlimUI, FREE, 14.2 MB, Unity 2020.3. **READ FROM THE FILES** (the
operator downloaded it at 03:14). 13.9 of the 14.2 MB is the PDF manual. **The "3D" is thin:** two
tilted world-space uGUI canvases, and a camera Animator that blends between TWO poses.
`UIMenuManager.cs` `Position1()`/`Position2()` set one float, `Animate`, to 0 or 1 over
`MenuCamPos1`/`MenuCamPos2`, plus a `MenuCamIdle` drift. The rest is 10 C# scripts, TextMeshPro SDF
atlases for Lato, Poppins and Rubik (free Google Fonts), 3 click SFX and panel PNGs.
**Reference only, and a thin one.** `BootStage3D` already drives its camera on two out-of-phase
cycles. The 3D menu the operator describes is that room grown into stations, not this pack. Nothing
ports. **FREE - DOWNLOADED.**

**25. Modern Menus - Synty INTERFACE** — Synty Studios, EUR 92.00. 1,746 sprites, 365 UGUI prefabs,
139 icon FBX with free-to-play iconography (coins, gems, chests). **SKIP:** it duplicates UIKit and
Lucide in a Synty style. Its three fonts are free Google Fonts anyway.

## RELATED, CHECKED AND NOT IN THE LIST

Boxing equipment - helmet and gloves (Mixall 127631, EUR 13.79) is not needed, because the Boxing
hall carries both. Sports equipment - Full pack (Mixall 380252, EUR 36.79) is ball sports only.

## FILES

The three downloaded packages were extracted without importing and are **not in master**, by R122's
rule: "track what the binding references, ignore the rest". Fighting Motions' 43 FBX are copied to
`Godot/assets/anim/audition/magicpot_fm1/` (plus `nomove/`). `.gitignore` keeps that folder local, so
S4a can load it. Track it the day `FightClipBinding` references a clip, as R122 did for
`ramsterz_h2h`. The originals remain in `%APPDATA%\Unity\Asset Store-5.x\` under `Magicpot Inc\`,
`Poly Ronin\` and `SlimUI\`, and all three can be downloaded again free from My Assets.

## Addendum 2026-09-13 - Sidekick Animation Studio's boxing packs (operator asked via its YouTube channel)

The operator pointed at `youtube.com/@animationsidekickstudio` (Sidekick Animation Studio LLC, a Taiwanese
motion-capture studio). The videos are previews only. The products sell twice: on Reallusion's store as
`rlMotion` (iClone / Character Creator format - Reallusion's Standard License since 2025-08-01 allows export
to game engines and shipping, no AI training, but we own no iClone to export with) and on the **Unity Asset
Store as FBX** (publisher 89859, 25 packages; standard Unity EULA, the same basis as Mixall). File lists read
through the store's GraphQL (no login):

| id | Pack | EUR | Files | Use to us |
|---|---|---|---|---|
| 263470 | Martial Arts - Boxing | 32.19 | 18 FBX + `SK_male_demo`: `Boxing_idle`, `step_back`, `step_foreward`, `move_back`, `move_foreward`, `light_attack1/2`, `heavy_attack1/2`, `attack_back`, `skill1`, `defense`, `hit_light`, `hit_heavy`, `hit_down`, `fail`, `Victory`, `debut` | a second boxing STANCE take and four footwork clips (R2 needs 3 stance takes); hits and a knockdown. The attacks are VERBS, the template #7 skipped for Karate - each must be watched to map to a technique |
| 280110 | Martial Arts - Boxing Dodge | 30.36 | 11 FBX `Boxing_move_01..11` (store copy: dodges with left/right steps, dodge-then-counter to head and body, head-sway dodges, sidesteps) | the most useful: we own 3 slip takes and no head sway or sidestep for neutral |
| 276034 | Martial Arts - Muay Thai | 50.60 | not read | presumably grounded kicks (our H2H kicks all fly, R111) - overlaps #1 |

Caveats: a Reallusion CC skeleton, so a new bone map in `FightClipRetarget` (the Magicpot pack needed one too);
quality through our retarget is unknown until a clip is on a body; animation purchases stay ON HOLD until S4a (e)
judges the held packs - these join that list. NOT the declined Dodge/Evade pack (that was passed over when the
RamsterZ packs were bought).

# BJJ_SOURCES_S334 - two BJJ animation sources the operator sent, and what they can fix

2026-11-01, S334 side session (Claude). Research only: nothing was built in the game.
Operator (verbatim): "use this to fix bjj animations https://www.jiujitsu-sekai.com/", then sent
`http://www.jiujitsu-sekai.com/downloads/bjj-blender.zip` and `https://eel.is/GrappleMap/index.html`.

Primary sources read: the 16 .blend files (Blender 5.2.1 headless, `-b --factory-startup --disable-autoexec`,
inventory script output `sekai_inventory.json`), the GrappleMap clone (`LICENSE`, `README.md`, `src/players.hpp`,
`src/persistence.cpp`, `blender/animate.py`) and the full `GrappleMap.txt`, decoded and counted with our own script.
Files on disk: `E:\FightCamp\downloads\bjj_blender\extracted\` (Sekai) and `E:\FightCamp\downloads\grapplemap\src\` (GrappleMap).

## Short answer

- **GrappleMap is the one we can use.** Public domain, 601 two-man positions and 1,485 transitions between them, stored as
  23 joint positions per man per keyframe. It ships the TRANSITIONS our old project never had (it only had held poses).
  Route: decode the joint positions, then solve them into rotations for the 22 bones of our MetaHuman rig (`MHRig.gd`).
  No Blender, no Cascadeur, no licence risk.
- **The Sekai zip is reference only.** 15 hand-keyed two-man BJJ clips on a low-poly rig. The zip has no licence file
  and the site states no terms, so we cannot ship its meshes or animations. We can only watch them for timing and shape.
- **The live game (Lean) has no BJJ at all.** It is boxing-only by its CLAUDE.md, and MMA is the first update after Early
  Access. Building any of this into the game changes the scope, so it is a question for the operator (see the end).

## Prior research (`python Tools/prior_research.py grapple ground bjj`)

- `topics/ground.md` (canonical): the engine model is event + seat + duration, using five ground seats (guard, half, side,
  mount, back) plus turtle and front headlock (`G34_GRAPPLING_CONTRACT.md`, `GroundGraph.gd` S57). Settled: **"Two-body
  ground animation cannot be generated or bought"** (Higgsfield made one body in 8 of 8 tries and 0 of 36 composed
  takedowns, `HIGGSFIELD_MMA_PIPELINE_STUDY.md`). Held poses were authored in Cascadeur.
- `topics/paired_holds.md`: owned two-man sets are RamsterZ (16 _Att/_Vic pairs) and the Cascadeur holds. The worst
  contact drift per hold after fixes was 15-19% (`C168`-`C175`). The BJJ presentation line (C134 armbar/tap, **C137
  sequence "NOT visually acceptable"**, C138 long script) sits on unmerged branches.
- `LUDO_GRAPPLING_R14_S193.md`: hold each ground seat with a one-frame base pose plus procedural motion (breathing,
  posting), and play paired clips only for the transitions. "Never author running multi-second ground animations."
  GrappleMap fits this plan exactly: its positions are the base poses and its transitions are the paired clips.
- `G82_GRAPPLING_POSITION_TAXONOMY.md`: 21 owned holds mapped to the standing / clinch / transition / ground-top /
  ground-bottom tree. GrappleMap's tags (`full_guard`, `half_guard`, `side_control`, `mount`, `back`, `turtle`) line up
  with that tree.
- `topics/retarget_rig.md`: keep our own retarget (it copies joint angles within 0.15 deg and beat Blender's).
  Cascadeur clips retarget through `CASCY_TO_UE4`.
- Memory: the Cascadeur licence ended 2026-10-27, so the old route for authoring holds is closed.

## 1. What "the BJJ animations" can mean today

| # | What | Where | State |
|---|------|-------|-------|
| 1 | Lean game ground/BJJ | `E:\FightCamp\Lean` | **None.** Boxing only. The only match for bjj/grappl/takedown/armbar is `docs/research/PREFABS_S299.md`. Its 4 anims are `assets/anim/metahuman/mh_{jab,cross,lead_hook,guard_pose}.glb`. |
| 2 | Cascadeur held poses (13 pairs + 3 switches) | `Game/Godot/assets/anim/audition/cascadeur/Cascy_{5050,BackControl,CageClinch,ClosedGuard,FrontHeadlock,HalfGuard,Mount,NorthSouth,OpenGuard,SideControl,Turtle}_{Att,Vic}.glb`, plus `Cascy_StepThrough_O2S`, `Cascy_Switch_O2S/S2O` | Bound in the old `FightClipBinding.gd` `PAIRED_BINDINGS` (line ~2165). Held poses only, NO transitions between them. Built on the Tripo/Cascy rig, not MetaHuman. C135: "Cascadeur did not produce a bindable side control". Cascadeur is gone after 10-27. |
| 3 | C137 two-fighter BJJ sequence | branch `codex/c134-bjj-presentation` (+ `c138-bjj-long-script`) | Its own digest says it played in game and was **"NOT visually acceptable"**. Unmerged. |
| 4 | RamsterZ paired FullMount set (armbar, strangle, punches, reversal, body-lock / double-leg takedown start-loop-end) | `Game/Godot/assets/anim/audition/ramsterz/Paired_FullMount_*` | Owned (bought pack). Game-style (weapon variants), mount-only. Contact distances ~0.02-0.04 m (`Q162`). |
| 5 | Single-actor takedowns | `audition/motifect/.../wrestling_{double,single}_leg_takedown`, `muay_thai_knee_clinch` | One body only. The partner is missing. |
| 6 | CMU paired mocap | `audition/cmu_paired/cmu_18_05`, `19_05`, `22_17` | Free for commercial use (no resale of the data). Two-man wrestling/push, not BJJ. It is the fixture for checking anchors (`R155`). |
| 7 | Old ground tests | `Game/Godot/tests/fight_grapple_seam_test.gd`, `fight_hold_binding_test.gd`, `fight_paired_anchor_test.gd`, `c169_hold_contact_test.gd`, `grapple_*` | Test the old engine and the Cascy bindings. The cancelled project can read them, but Lean cannot run them. |

So "fix the BJJ animations" most likely means items 2 and 3: the held poses that never connected and the sequence that
looked wrong. GrappleMap supplies the part that was missing from both, which is the motion between positions.

## 2. Source A - Jiu-Jitsu Sekai `bjj-blender.zip` (REFERENCE ONLY)

**Licence: none found.** The zip contains 16 .blend files and a `.gitignore`. There is no licence or readme in it. The only
embedded texts are Rigify's `rig_ui.py` (skipped: auto-run was off) and a Blender "Recent Reports" log. The site states no
terms. Treat it as all rights reserved. Never ship its meshes, rig or keys. The way to change this is a written licence
from the site's author.

**Format (measured).** Blender 2.79 / 2.80 files, 24 fps, units in cm (`unit_scale` 0.01). Two armatures per file
(`bjjka1`, `bjjka2`, data `Root` / `Root.001`). Each has 65 bones: 47 deform bones (`hips`, `spine`, `chest`, `neck`,
`head`, `upper_arm/forearm/hand.L/R`, 3-bone fingers + 2-bone thumb, `thigh/shin/foot/toe.L/R`) plus IK controls
(`hand.ik.*`, `Elbow.*`, `Knee.*` poles, `Foot.Master` / `Rocker` / `foot.IK` foot roll). 45 bones are keyed
(location + quaternion + scale), so the limbs are IK-driven and must be visual-baked to FK before export. There are **no
clavicle bones**: `upper_arm` hangs straight off `chest`. The mesh is `Human_BaseMesh`, 1,736 verts, mirror modifier,
MakeHuman-like.

| File | Actors | Clip length @24 fps | Keys (actor1 / actor2) | Content |
|------|--------|--------------|-------------|---------|
| americana | 2 | 0-125 (5.2 s) | 16 / 18 | americana (top lock from side control/mount) |
| back | 2 | 0-190 (7.9 s) | 47 / 44 | back control / back take |
| close_guard | 2 | 0-120 (5.0 s) | 24 / 16 | closed guard |
| idiot_sweep_legdrag_sidecontrol | 2 | 0-130 (5.4 s) | 30 / 19 | sweep -> leg drag -> side control |
| idiot_sweep_singlex | 2 | 0-190 (7.9 s) | 29 / 33 | sweep from single-X |
| imanari | 2 | 0-285 (11.9 s) | 55 / 70 | Imanari roll (leg entry) |
| side_control | 2 | 0-120 (5.0 s) | 17 / 17 | side control |
| side_control_kimura | 2 | 0-115 (4.8 s) | 30 / 35 | kimura from side control |
| sitting_guard | 2 | 0-100 (4.2 s) | 15 / 15 | seated guard |
| stockade | 2 | 0-490 (20.4 s) | 55 / 74 | stockade sequence (longest) |
| takedowns | 2 | 0-210 (8.8 s) | 51 / 57 | standing takedown(s) |
| toreando_pass | 2 | 0-240 (10.0 s) | 22 / 32 | toreando guard pass |
| base_position | 1 keyed | single frame | 1 | neutral / rest pose |
| human_mesh | rig + mesh | no action | - | base character |
| female_export | 1 | single frame | 1 | female mesh (body, top, bottom, hair, lashes) |
| muay_thai_guy | 1 | single frame | 1 | Nak Muay character (3,433-vert body, hair, shorts) |

Key counts of 15-74 per actor show these are hand-keyed pose-to-pose clips, not mocap. They are useful as a TIMING and
SHAPE reference: how long a toreando pass or a kimura takes, and where hips and hands go. They are watched only with file
tools and stills, never put in the build.

## 3. Source B - GrappleMap (PUBLIC DOMAIN, can ship)

**Licence.** `LICENSE`, verbatim in substance: all authors agreed to release their contributions into the Public Domain.
This covers the code and the database. Many entries cite instructionals by name (`ref:` lines, 1,058 sequences), but
those are text citations, not copied media. We ship the joint numbers, never the citations as content.

**Format (read from `players.hpp` / `persistence.cpp`, checked by decoding the whole file):**
- `GrappleMap.txt`, 2.6 MB, 39,098 lines, 2,086 sequences: **601 positions** (1 keyframe each) and **1,485 transitions**
  (2-22 keyframes, median 4, 7,722 keyframes in all). Each has a title, a `tags:` line, `properties:` (top / bottom /
  detailed / bidirectional) and an optional `ref:` line.
- A keyframe is 4 indented lines, 276 base-62 digits = 2 players x 23 joints x 3 coords. Each coord is 2 digits:
  `(d0*62+d1)/1000` metres, with x and z offset by -2. Y is up.
- 23 joints per player: `LeftToe, RightToe, LeftHeel, RightHeel, LeftAnkle, RightAnkle, LeftKnee, RightKnee, LeftHip,
  RightHip, LeftShoulder, RightShoulder, LeftElbow, RightElbow, LeftWrist, RightWrist, LeftHand, RightHand, LeftFingers,
  RightFingers, Core, Neck, Head`.
- **One body size for everyone.** Limb lengths are fixed constants (`limbs()` in players.hpp), measured on 400
  transitions: thigh 0.43 m, shin 0.43 m, upper arm 0.29 m, forearm 0.26 m, Core->Neck 0.32-0.46 m (the spine flexes).
  The lowest joint sits 2 cm above the mat, so there is no hovering.
- **Timing is not stored.** A transition is a list of keyframes. The players interpolate between them at a chosen speed
  (`playback.cpp`, "segments per second"). We set the timing ourselves, and Sekai's clip lengths are a good reference
  for it.
- Coverage (tag counts): bottom_supine 247, top_kneeling 203, standing 125, half_guard 55, full_guard 52, side_control
  46, single_leg_takedown 42, butterfly 37, turtle 30, back 28, kimura 28, double_leg_takedown 27, closed_guard 22,
  omoplata 20, seatbelt 18, body_lock 17, throw 16, mount 15, triangle 15, sprawl 13, rear_naked_choke 11, darce 11.
  Named examples: "full guard kimura", "double leg takedown finish", "knee slice vs de la riva", "hip bump sweep w/
  hand post", "near side side control kimura", "mount", "mounted triangle", "rear naked choke w/ arm trapped",
  "countering upa side control escape", "kimura throw/sweep".
- **`blender/animate.py` is not usable as it is.** It uses the Blender 2.7x API (`matrix * matrix`), reads a dump made
  by the C++ `makevideo` tool from a hard-coded Linux path, and drives a CMU-named armature (`Hips`, `LowerBack`,
  `Spine1`, `Neck1`, `LeftFingerBase`, `LThumb`). The method is worth copying: for each bone, aim it at the next joint,
  take a second "left" vector from a neighbouring joint to build a full basis, and scale it to fit. That is the same
  solve we need, written for our rig.

### Retarget route onto our MetaHuman (decided)

Do it at runtime in Godot. Do not bake in Blender.

1. **`GrappleMapDB.gd`** (pure, no preloads): decode `GrappleMap.txt` (ship the 2.6 MB text or a trimmed JSON of the
   transitions we use) into `{title, tags, top_bottom, frames: [[23 x Vector3] x 2]}`. Convert Y-up metres to our space.
   A blind test checks the decode: limb lengths 0.43 / 0.43 / 0.29 / 0.26 within 1 cm on every frame, and min joint
   height >= 0.
2. **`PoseFromJoints.gd`** (pure math): turn 23 joint positions into rotations for the 22 bones in `MHRig.UE5_TO_OURS`:
   - Hips: basis from Core plus the LeftHip -> RightHip axis, up toward Neck.
   - Spine / Chest / UpperChest: GrappleMap has only one segment from Core to Neck. Split the bend and twist across the
     three bones (1/3 each). Twist comes from the shoulder line against the hip line.
   - Shoulders (clavicles): from Neck to Left/RightShoulder. GrappleMap has real shoulder joints, which Sekai does not.
   - Upper and lower arms, upper and lower legs: aim at the next joint. The elbow and knee bend plane is exact, because
     shoulder, elbow and wrist (or hip, knee and ankle) are three real points.
   - Feet: full basis from Ankle, Heel and Toe. Toes (`ball_*`) from Toe.
   - Hands: aim Wrist -> Fingers. Palm roll is not in the data, so take it from the forearm plane. MMA gloves hide most
     of the error.
   - Head: aim Neck -> Head. Roll is not in the data, so take it from the shoulder line.
3. **Proportions.** Scale the pair uniformly by our boxers' mean height / 1.80 m, so both men keep the same contacts.
   Then run two-bone IK on hands and feet to the scaled GrappleMap joint targets, so a grip lands where the data puts it
   even when our arms are longer or shorter (the reach is clamped). This keeps contact better than the per-man scaling
   that cost the old project 20 contact rounds (C168-C175).
4. **Player.** `GrappleMapPlayer.gd` interpolates the keyframes (smoothstep, or Catmull-Rom through them) at a set
   duration per transition, holds positions with the R14 breathing layer, and chains transitions along the graph. The
   graph edges are already in the data, so they can feed a seat graph like the old `GroundGraph`.
5. **Gate.** Use the visual-gate skill. Stills come from the game's own camera, through `still_framing.save_if_framed`
   (both men in frame). The gate checks gap, noses, wrists and feet, and mesh interpenetration in tight holds. The
   stick figures have joint radii but no body volume, so MetaHuman torsos WILL clip in mount and back control. Expect a
   per-hold push-out pass, like the old `FightPoseSolver`.

**Effort (judgement).** Decoder + test: 0.5 agent-day (Arena, pure module). Pose solver + blind contract test: 1-2
agent-days. Player and a studio-orbit preview on the game pipeline: 1 day. A first watchable prototype of 3-5
transitions is about 3-4 agent-days. A demo-grade ground game (about 20 transitions, contact cleaned, on the game camera)
is weeks of work, because the contact cleanup per hold is the unknown, as it was in C168-C175.

### Which ground clips it would fix first

These follow the seats the old engine used (guard, half, side, mount, back, plus turtle and front headlock) and give
those held poses their missing transitions:

1. Standing -> ground: `double leg takedown finish` (replaces the one-body Motifect takedown).
2. Guard -> side control: `knee slice` / toreando-family passes (compare the timing with Sekai's `toreando_pass`, 10 s).
3. Guard -> mount sweep: `hip bump sweep w/ hand post`.
4. Side control -> mount, and the bottom escape `countering upa side control escape`.
5. Mount / turtle -> back: seatbelt back takes (`mounted turtle w/ seatbelt`).
6. Finishes: `full guard kimura`, `near side side control kimura`, `rear naked choke w/ arm trapped`, `mounted triangle`.
   These replace the C137 armbar/tap sequence that was "NOT visually acceptable".

## 3b. Source C - bjj-link.com/en/dojo ("Dojo Legacy") - a competitor game, not an animation source

The operator later sent `https://www.bjj-link.com/en/dojo` with no other words. Pages read with curl, as static HTML
only (no account, nothing under `/api/` per its robots.txt, nothing downloaded): `/en/dojo`, `/en` (landing),
`/en/termos` (Terms of Use, version 25/08/2026), `/en/guia/combate-por-turnos`, `/en/guia/tecnicas`, plus the sitemap.

- **What it is.** "Dojo Legacy: Career Mode" is a free-to-play Jiu-Jitsu and MMA **career game** by one developer
  in Brazil. It runs on web, iOS and Android. Its landing page claims 15,047 careers saved, 226 techniques
  (165 grappling and 61 striking), 40 tournaments and 5 team leagues. The player makes a fighter, earns belts,
  **opens their own academy and develops students**, fights a separate MMA career in its "AFC" league, manages an
  agent, sponsors and contracts, and leaves an heir who starts the next generation. Matches are **turn-based**: each
  turn you pick one technique that the current position allows. The match tracks gas, wear (which carries across a
  bracket), momentum, and an action type (submit / advance / hold / escape). The player picks a pre-fight strategy
  (balanced, aggressive, pull guard, play on top, hunt the submission, and others) and can choose "Quick simulate".
- **Free vs paid.** Free to play, with optional paid items: the "Dojo Pass", characters based on athletes, avatars,
  progression boosts and an auto-renewing subscription. Purchases are made only on the website, through Mercado Pago.
- **Terms.** All rights reserved. Its IP clause forbids copying, distributing, modifying, commercialising or
  making derivative works without the holder's permission. Playing, streaming and writing about the game are
  allowed. Automated scraping "at unauthorised scale" is forbidden. **Nothing from it can ship.**
- **What it adds beyond GrappleMap.** It has no animation, 3D or joint data, at least in the pages read; the game
  works by turns and menus. It adds two things:
  1. **A player-facing technique taxonomy** with eight families and counts: submissions 31, transitions 16,
     escapes 22, guards 22, guard passes 19, takedowns 21, sweeps 34, plus MMA. Each technique page says which
     positions it works in and what it leads to. The positions shown on screen are standing, guard, half guard, side
     control, mount, back "and more", which matches our old five seats. We may use this as a check list of what
     players expect to see named. We may not copy its data.
  2. **Scoring tables** that restate public rules: IBJJF points (takedown 2, sweep 2, pass 3, knee on belly 2,
     mount 4, back 4) and ADCC-style points (mount 2, back 3). These are already in our own research (`J1`, `G34`).
  It gives no timing or move-order data for animation, so GrappleMap stays the source for that.
- **Why it matters anyway.** It is a **direct competitor for the MMA update**: a fighter career, your own gym with
  students, an MMA league and heirs, on free mobile. This is design research for the MMA update (`topics/competitors.md`),
  not for the boxing demo.

It changes nothing in Q-S294-58. It gives us no motion data, so the choice is still GrappleMap prototype now or later.

## 4. Scope

Lean's CLAUDE.md keeps the game boxing-only for Early Access, and MMA is the first update. Retargeting GrappleMap is
cheap now (public domain, no tool licence, runtime solver), but it builds MMA content before EA. That is a scope call
for the operator. One board question was posted. **Nothing is built in the game until he answers.**

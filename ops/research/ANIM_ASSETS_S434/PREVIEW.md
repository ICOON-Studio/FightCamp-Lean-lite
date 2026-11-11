# Boxing Animation Pack (animo-mocap, Fab) - preview watched, licence read (S434)

Listing: https://www.fab.com/listings/6cc14b2c-2383-45bf-a8f4-6f890b76487d ("Boxing Animation Pack", seller animo-mocap,
67 mocap clips, category Animations > Locomotion / Gaits). Nothing bought, no sign-in, no terms accepted, no clip file
downloaded. Read-only research; notes and numbers in our own words.

## 1. How the preview was watched (the YouTube video is private)
- The listing's only video link ("Full Preview", https://youtu.be/yEVdxqwDGUo) is a PRIVATE YouTube video: yt-dlp
  answers "Private video". Nobody can watch it without the seller's invite, so it was not used.
- The listing's own public 3D viewer plays all 67 clips on the seller's mannequin. It was rendered OFF SCREEN (headless
  Microsoft Edge driven by Playwright; nothing opened on a monitor) the way any visitor watches it: for every clip,
  2.6 s of playback, then paused and scrubbed to 10 points (t = 0.00, 0.10 ... 0.80, 0.92 of the clip).
  The viewer streams the clips to the page as any viewer does; no clip file was saved.
- Evidence (git-ignored by `ANIM_ASSETS_S434/.gitignore`, keep it out of commits):
  - `frames/sheets/sheet_NN-MM.jpg` - 34 contact sheets, two clips each, 10 scrubbed poses per clip, the viewer's own
    time read-out (current / clip length) on top. The clip index NN is the listing's order (table below).
  - `frames/raw/NN_K.jpg` - the full-size scrubbed poses (K = 0..9 as above).
  - `video/preview_3dviewer.mp4` - 176 s, 24 fps, all 67 clips playing in order (made from the playback grabs).
  - `frames/video_1fps/` (176 frames, one a second) and `frames/video_scene/` (90 scene-change frames) - ffmpeg on that video.
- Camera: the viewer's default view, from behind her rear shoulder, 3/4 side-on. Good for reach, rotation and the
  rear foot; it hides stance width.

## 2. Licence and price (read from Fab's listing data and Fab's licence pages)
- Fab STANDARD licence, two price tiers, same rights: Personal EUR 58.18, Professional EUR 76.09 (before VAT; an EU
  visitor sees EUR 69.23 / 90.54). Personal = a buyer (with its controlling and commonly controlled companies) with under
  USD 100,000 gross revenue from commercial activity in the last 12 months at the time of purchase; above that,
  Professional. Crossing the line later does not force an upgrade. (Threshold wording from Epic's licence docs and EULA
  quotes; the binding text is the Fab EULA - read it at checkout.)
- What it allows: use in commercial products, in ANY engine ("usage is not limited to Unreal Engine") - Godot and a
  Steam sale are fine; modify and adapt (retargeting onto MetaHuman is modifying); share with collaborators through a
  PRIVATE repository. Forbidden: reselling or giving away the files on their own. Our repo FightCamp-Lean is private,
  but the Arena mirror FightCamp-lite is PUBLIC: the raw FBX / baked .res of this pack must never go there.
- Listing flag "Allows usage with AI: No" (`isAiForbidden: true`): no use of these clips for AI training or generative-AI
  work. Keep them out of Ludo, Gemini and any generator; ordinary tools (Blender, Godot, our bake scripts) are fine.
- Formats: Unreal Engine project, Unity package, FBX, and converted GLB / glTF / USDZ. Humanoid ("Mecanim compatible"),
  all clips loop. Frame rate and root-motion setting not stated (the viewer shows the walks and combos travelling, so the
  root moves in those). The skeleton is not named (not UE Mannequin, not MetaHuman); it retargets like a Mixamo clip.
- Reviews: 4 ratings (three 5-star, one 1-star), 3 written reviews (avg 3.67). First published 2022-10-21, updated
  2025-07-31 and 2026-05-09 (no notes).

## 3. Clip by clip (as the viewer shows them)
Length = the viewer's read-out. Single punches, guards, parries and dodges are all 1.00 s loops that start and end in
the same basic guard.

| # | clips | length | what it is, how it moves |
| --- | --- | --- | --- |
| 00-04 | Basic, High, Sit-Down, Low-Hand, Philly Shell guards | 1.00 s | Breathing guard idles with a small knee pulse. Feet stay put in all 10 poses. Five real styles: Sit-Down = hips sat low, knees deeply bent; Low-Hand = lead hand at the hip; Philly = lead arm across the belly, rear glove at the chin. |
| 05-06 | Philly Shell Defense, Basic Guard To Philly | 1.39 s | Shoulder roll: she turns the lead shoulder in and almost shows her back to the camera, then comes back. |
| 07 | Jump | 1.00 s | A bounce on the balls of the feet in guard, small hop. |
| 08-09 | Head Movements 01 / 02 | 1.36 / 1.96 s | Guard idle with head and torso slipping side to side and dipping. Alive, not a statue. |
| 10-12 | Feint 01 / 02 / 03 | 1.00 s | 01 and 03: lead-shoulder and lead-hand twitch with a front-knee lift (stomp feint); 02: a level-change dip and back. |
| 13-16 | Footwork Drills Fwd / Back / Left / Right | 0.86 s | Small shuffle steps IN PLACE (the body stays on its mark), guard up. |
| 17-20 | Walk Fwd / Back / Left / Right | 1.00 s | Stepping in guard WITH travel (root motion), half a metre or more a loop; long, upright steps. |
| 21-24 | Run Fwd / Back / Left / Right | 0.76-0.80 s | Jogging in guard with travel. Not ring footwork. |
| 25, 27, 29, 31, 33, 35 | Jab, Cross, Lead / Rear Hook, Lead / Rear Uppercut | 1.00 s | Guard -> punch -> guard. Arm out around t 0.30-0.50 (jab ~0.3 s, cross ~0.45 s, hooks / uppercuts ~0.4-0.5 s). Clear hip and shoulder turn on the cross and the rear hook (she ends square to the camera). The jab stays slightly bent at full reach (short). |
| 26, 28, 30, 32, 34, 36 | the same six to the BODY | 1.00 s | Real level change: knees bend, the torso drops and leans to the target; Jab_Body is the deepest. Back to guard by t 0.7. |
| 37-39 | Back Fist, Hammer Fist 01 / 02 | 1.66 s (back fist) | Spinning back fist (turns her back fully) and hammer fists. Fouls in boxing - not usable. |
| 40-44 | Stepping Jab / Cross / Back / Lead Hook / Rear Hook | 1.00-1.50 s | Step in (or out, Stepping_Back) with the punch, then step back to the start mark (the loop closes). |
| 45-52 | Combos A-H (1-2, 1-2-3, 1-1-2, 1-3-2, 2-3-2, 3-2-3, 1-2-3-2, 1-2-1-2-3-3) | 1.00-2.66 s | Fluid, quick chains; the longer ones travel forward a step or two. A (1-2) in 1.00 s, G 2.33 s, H 2.66 s. |
| 53-60 | Down / Side / Forearm / Circle-Low Parry, L and R | 1.00 s | Small, quick hand and forearm parries from the guard; head stays still; Circle-Low sweeps the arm low and wide. |
| 61 | Push Back | 1.00 s | Short two-hand push / frame from the guard. |
| 62-63 | Dodge Slip Left / Right | 1.00 s | Torso and head slip to the side and back. Subtle, faces forward the whole time. |
| 64 | Dodge Pull Back | 1.00 s | Lean back from the hips, small. |
| 65-66 | Bob n Weave Left / Right | 1.00 s | Deep squat under and out to the side (knees near 90 deg), up again. Reads as a squat more than a U-shaped weave. |

Distinct moves: about 55 boxing-legal ones (67 minus the 3 fouls, minus the run loops and the mirrored L/R pairs counted once).

### Motion quality, from the frames
- Weight: good. Clean single-actor mocap, no visible jitter. Body shots carry real level change; the Sit-Down guard sits.
- Feet: in guards, parries, slips and single punches the feet stay planted in all 10 poses (no sliding I can see). The
  rear-hand POWER shots are the exception: on Cross_Body, Rear_Hook and Rear_Uppercut the rear heel comes far up and
  the rear knee swings forward until the foot nearly leaves the canvas (t 0.4-0.6: `frames/raw/35_5.jpg`,
  `frames/sheets/sheet_34-35.jpg`). Real boxers pivot the rear heel, they keep the ball down: this would fight our
  FloorStand / FootLock layers. No popping seen between poses; every loop returns to the same guard pose.
- Snap: punches are crisp at the extension, recovery to guard is clean and fast (by t ~0.6-0.7). The jab is short.
- Rotation: hips and shoulders turn well on crosses and hooks (`frames/sheets/sheet_26-27.jpg`, the cross at t 0.4-0.5).
- The 3/4 view can not show stance width or exact foot slide in centimetres; a measured check needs the files.
- Skeleton / proportions: a generic robot mannequin (white shell, black joints), long legs, broad hips, closed fists, no
  face. Unity-humanoid style. Orthodox stance (the cross is the right hand). Nothing MetaHuman-specific.

## 4. What our fight plays today (read in the code)
Default route since S432 = the "older stepping route" (`RkClips.enabled` false unless `-- rokoko`):
- Punches: MoCap Online Punch PRO (`assets/anim/baked/mc_Box1_M3_*.res`, 145 clips, loaded as `pro_*` by
  `scripts/fight3d/FightClips.gd`), chosen in `scripts/fight3d/BeatClips.gd` `punch()`: left_jab (+_a/_b/_c),
  right_cross (+_a/_b/_c), left_hook (+_v2), right_hook, left/right_uppercut, ONE body_shot, kidney_shot for a big body
  shot; variants _ft (stepping), _hard, _hurt, _miss, _special (19 of them switched off in OFF_TAKES). Fallbacks: the
  MoCap Online Starter (`mc_*`), native MetaHuman jab / cross / lead_hook, old baked clips.
- Defence: `pro_left_dodge` / `pro_right_dodge` (slip), `pro_left_weave` / `pro_quick_weave` / `pro_right_weave`,
  `pro_back_dodge` (pull), `mc_to_block` + block loop / block hits. No parry clip at all.
- Guard: `pro_idle` (+ GuardLife fidgets, tired idles). Footwork: the procedural BoxerFootworkRig (legs) over the guard,
  plus the old baked `advance / retreat / strafe_left / strafe_right` loops (`assets/anim/baked/loc_*.res`).
- Reactions, falls, wins: all Punch PRO (`pro_hit_by_*` ~37 clips, `pro_knockout_*` 8, `pro_knockout_countdown_*` 3,
  `pro_win_*` 7). Clinch: a Cascadeur pair (`clinch_att` / `clinch_vic`). Ring entry: Mixamo.
- Weak today (HUMANFIGHT1 digest, TASK_HUMANFIGHT2B): joins and pops at clip starts, reach (the range does not pick the
  punch), contact (gloves park on the target), hits barely felt, a dodge / weave that turns the back, body shots bowed
  flat, statue-like waiting.

## 5. What this pack would ADD, REPLACE, and what it lacks
ADD (we have nothing like it):
1. Body versions of all six punches (we have one body_shot + kidney_shot for every body punch). The best single gain:
   a jab, cross, hook or uppercut to the body each gets its own clip with a real level change.
2. Eight parries (down / side / forearm / circle-low, both hands) and a push back - a defence the game can not show today.
3. Five guard styles (basic, high, sit-down, low-hand, Philly shell) plus the shoulder roll: a style per fighter, so two
   boxers stop looking identical (fits the INTROCORNER1 ask and "rank / personality" work).
4. Head-movement idles and a bounce: waiting that is not a statue (a critic item in every HUMANFIGHT round).
5. Three feints.
6. In-place footwork drills (4 directions) - usable as the rig's reference or as guard-idle variety.
REPLACE (candidates, each to be judged on our body first):
- `pro_*_dodge` / `pro_*_weave` / `pro_back_dodge` by the pack's slips, pull back and bob-n-weave: they keep facing the
  opponent (the critics' "a dodge that shows his back"). The bob-n-weave squats too deep; it may need trimming.
- The old baked `loc_*` advance / retreat / strafe by Walk Fwd / Back / Left / Right (one actor, guard up) - only if the
  stepping rig keeps the legs; the walks' steps are long and upright.
- Plain punches: no clear gain over Punch PRO (which has far more variants and measured contact data); the pack's
  combos could replace chained singles for a flurry, but fixed combos fight the beat timing.
LACKS (keep Punch PRO for these): hit reactions (none), blocks / block hits (none), knockdowns, knockouts, counts and
get-ups (none), clinch (none), tired / hurt idles (none), wins / celebrations (none), corner / ring entry (none).
NOT USABLE: Back Fist, Hammer Fist 01 / 02 (fouls); the four runs (not ring movement).

## 6. Risks to weigh before buying
- Rear-hand power punches lift the rear foot (above) - against the "feet honest" fixes; each clip needs our ruler first.
- A third stance family stitched in (the HUMANFIGHT1 lesson: three clip families with three stances read wrong); safest
  as whole families (all defence from this pack, all guards from this pack) rather than one clip here and there.
- 1.00 s loops with guard padding at both ends: contact times must be measured on our body (`tools/clip_contact.gd`),
  as for Punch PRO.
- Keep the files out of the public Arena mirror and out of AI tools (licence).

## Sources
- Fab listing and its listing data: https://www.fab.com/listings/6cc14b2c-2383-45bf-a8f4-6f890b76487d
- Fab licence pages: https://www.fab.com/eula ; https://dev.epicgames.com/documentation/en-us/fab/licenses-and-pricing-in-fab
- Personal / Professional threshold quoted in: https://forums.unrealengine.com/t/fab-license-terms-standard-license/2094243 ,
  https://forums.unrealengine.com/t/how-to-determine-personal-vs-professional-license/2082366
- Same seller, a separate "Animo Mocap Boxing Additional" pack (121 clips, RenderHub, contents not checked):
  https://www.renderhub.com/animo/animo-mocap-boxing-additional

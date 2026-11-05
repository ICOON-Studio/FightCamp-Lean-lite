# OWNED MOCAP - long boxing takes we already own, on our male boxer (S381 started, S383 finished)

Operator S381: "we already have these files". Long captured guard / footwork / shadowboxing takes from packs already on
this PC, retargeted onto our MetaHuman boxer in the game's baked-clip format. Branch `claude/owned-mocap` (not merged).

**Kept: 7 takes, 190.2 s (3.2 min)** of boxing motion. **Dropped: 4 baked takes** - Rokoko FightingIdle (on the bars,
confirmed by eyes) and CMU 14_03, 15_13, 17_10 (S383 independent eyes check: sloppy guard, telegraphed crosses, a flail) -
plus 5 sources dropped on eyes in S381 before baking (listed below). Kept reel: E:/FightCamp/tmp/s383/ownedmocap/owned_kept_reel.mp4.

## Sources and licences

The raw files stay OUTSIDE the repo (C:/Users/user/Downloads/fightcamp_mocap_s381/, licence notes in its LICENSES.md).
Only our retargeted `.res` clips (our skeleton, our tracks) are in the repo.

| source | files | licence (as published) | what we may do |
|---|---|---|---|
| Rokoko free combat pack, `Downloads/Combat.zip` (Mixamo rig FBX, 24 fps - slerped to 30 fps in the bake; Smartsuit Pro II capture) | ShadowBoxing_mixamo.fbx, Boxing_mixamo.fbx (FightingIdle_mixamo.fbx dropped) | Rokoko free-pack pages: usable "in any animation, VFX, game ... from passion project to commercial use" | ship retargeted in the game |
| CMU Graphics Lab Motion Capture Database (mocap.cs.cmu.edu), ASF/AMC, 120 fps | kept: 13_17, 13_18, 14_01, 14_02 (14_03, 15_13, 17_10 baked then dropped on eyes) | site: "free for all uses"; FAQ: may be in commercially sold products, may NOT be resold directly, even converted | ship retargeted in the game; never sell/give the clip files as a pack; credit line in the game credits (NSF EIA-0196217) |
| Ailive Fab pack, `Downloads/boxing.zip` | none kept | - | S381 eyes: footwork stance ~1 m wide + rear hand at the hip, sway a 2 s lunge with hands low; hooks/uppercuts out by brief |

Meshy is out (operator S272/S274). No new downloads were made in S383.

## The retarget route (tools/owned_mocap_bake.gd + tools/owned_mocap_plant.gd)

1. **Source read.** Rokoko FBX through Godot's own FBX reader; CMU ASF/AMC through `tools/cmu_amc_source.py`
   (`python -I`, our own reader, 120 -> 30 fps by every 4th frame) into a JSON of per-bone world rotations away from rest.
2. **World-delta retarget with a matched reference pose.** Our boxer (mh_boxer_08, a man) is posed once into the
   source's rest (each mapped segment swung to point where the source's points); each frame every mapped bone gets
   the source bone's world rotation away from ITS rest, turned into our space. Unmapped bones hold the reference.
3. **Hips** from the source hip joints' height over its planted toes and its floor travel, scaled by leg length
   (ours / theirs: k = 1.046-1.094), then the bake's hips correction lands our planted ball where his lands.
4. **S383 planted-foot pin (new, finishes S381's last step).** The hips correction alone passed the actor's own toe
   creep through (S381 bars: plants slid up to 13 cm on Rokoko, 4.8 cm on CMU). Now every plant of OUR baked foot
   (>= 4 frames, ball within 3 cm of its floor, < 0.35 m/s) is held at the plant's mean spot by two-bone leg IK
   (thigh + shin re-aimed, the knee kept on its side, the foot's world rotation kept), blended over 2 edge frames.
5. **S383 CMU hands + toes held** at the reference pose: CMU's hand and toe segments are 1-2 DOF noise and flipped up
   to 177 deg in one frame. A straight wrist is right for a boxer; the boot sole stays flat.
6. Output: the 25 bones of `mc_Box1_M3_Idle` (25 rotation tracks + the Hips offset), 30 fps, keys every frame, in
   `assets/anim/baked/owned/<take>.res`. Not wired into FightClips yet (no fight picks these clips).

Run: `bash tools/owned_mocap_takes.sh <extracted dir> <cmu json dir> <Downloads>`; bars:
`<godot> --headless --path . --script res://tools/owned_mocap_measure.gd -- res=<a.res,...> [win=40]`.

## Windows used

| take | source window | why |
|---|---|---|
| rk_shadowboxing_a | ShadowBoxing 0-11.9 s | 11.93-17.13 the actor crouches and turns 70 deg (S274) |
| rk_shadowboxing_b | ShadowBoxing 17.2-23.0 s | 23.4 a knee strike, 28+ he walks off (eyes S381) |
| rk_boxing | Boxing 0-15.5 s | 16+ the guard drops, the take ends (eyes S381) |
| cmu_14_01 / 14_02 / 13_17 / 13_18 | whole trial | all boxing |
| cmu_14_03 / 17_10 | (whole trial baked, then DROPPED on eyes) | see Dropped |
| cmu_15_13 | (0-50.5 s baked, then DROPPED on eyes) | 58-65 s the hands drop (a rest); see Dropped |
| rk_fighting_idle | (whole 52 s baked, then DROPPED) | guard down, see below |

## Measurements (tools/owned_mocap_measure.gd on mh_boxer_08, S383 final bake)

Definitions: **plant** = a run >= 0.2 s with the ball of the foot within 2.5 cm of that foot's floor and < 0.25 m/s;
**slide** = the farthest the ball gets from where the plant began. **Knee** bend 0 = straight; **locked** = under 8 deg
for >= 0.5 s. **Stance** = median ball-to-ball distance. **Hips** = median hips height minus our idle's (the idle stands
its balls 5 cm up on the toes, the takes 0.9 cm - so ~4 cm of each figure is that). **Elbow** = interior angle (180 =
straight). **Guard down** = a wrist > 30 cm under its shoulder. **Feet pass** = the right-to-left ball line turned
> 120 deg from 0.5-1.5 s before (a walk passes the feet every step; a boxer keeps his stance). **Pops** = bone-frames
whose global rotation moves > 15 deg in one 1/30 s frame (most are the rear hand's punches: a cross turns the upper arm
30-66 deg a frame, 900-2000 deg/s).

| take | secs | slide cm max / mean (plants) | knee deg (p5-p95) | stance cm | hips vs idle cm | elbow deg (p5-p95) | guard down longest / share | feet pass | pops (worst) | verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| our idle (reference) | 2.0 | 1.2 / 1.2 (2) | 18-35 | 61 | 0 | 104-108 | 0 s / 0 % | 0 | 0 (2) | - |
| rk_shadowboxing_a | 11.87 | 1.0 / 0.6 (15) | 11-77 (30-65) | 64 | -10.4 | 43-176 (54-147) | 1.1 s / 16 % | 2 (8 %) | 230 (32) | KEPT |
| rk_shadowboxing_b | 5.80 | 1.2 / 0.4 (10) | 15-74 (30-62) | 77 | -12.7 | 52-175 (58-118) | 0.3 s / 5 % | 1 (1 %) | 90 (30) | KEPT |
| rk_boxing | 15.47 | 1.4 / 0.6 (21) | 11-77 (36-65) | 72 | -12.3 | 46-173 (56-116) | 0.1 s / 1 % | 2 (6 %) | 152 (30) | KEPT |
| cmu_14_01 | 46.60 | 1.6 / 0.7 (99) | 12-90 (34-67) | 70 | -12.0 | 28-159 (39-121) | 0.5 s / 7 % | 8 (7 %) | 940 (66) | KEPT |
| cmu_14_02 | 45.17 | 1.4 / 0.7 (99) | 0-107 (30-73) | 76 | -10.5 | 30-173 (44-118) | 0.4 s / 4 % | 6 (3 %) | 999 (62) | KEPT (straight knee 0.13 s once) |
| cmu_14_03 | 46.10 | 1.7 / 0.7 (108) | 13-104 (30-67) | 74 | -10.6 | 28-156 (46-114) | 1.1 s / 11 % | 3 (2 %) | 1078 (44) | **DROPPED** (eyes) |
| cmu_13_17 | 40.30 | 1.8 / 0.8 (60) | 24-95 (38-73) | 80 | -13.3 | 30-166 (35-106) | 0.5 s / 10 % | 2 (1 %) | 1188 (65) | KEPT |
| cmu_13_18 | 24.97 | 1.7 / 0.7 (63) | 19-98 (34-72) | 80 | -12.1 | 30-164 (39-111) | 0.6 s / 12 % | 4 (10 %) | 460 (43) | KEPT |
| cmu_17_10 | 23.17 | 1.5 / 0.7 (32) | 13-117 (32-87) | 76 | -11.9 | 33-159 (39-101) | 0.6 s / 5 % | 1 (2 %) | 696 (63) | **DROPPED** (eyes) |
| cmu_15_13 | 50.50 | 1.6 / 0.6 (67) | 11-76 (30-56) | 80 | -12.2 | 23-163 (34-139) | 0.5 s / 10 % | 0 (0 %) | 849 (64) | **DROPPED** (eyes) |
| rk_fighting_idle | 52.37 | 0.8 / 0.5 (16) | 0-56 (13-45) | 60 | -6.6 | 58-170 (66-160) | **7.9 s** / 35 % | 0 | 6 (28) | **DROPPED** |

Before the S383 pin (same takes, S381 hips correction only): slide max 4.6 / 13.2 / 7.4 cm on the three Rokoko takes,
4.8 / 2.6 / 2.8 / 2.6 / 3.8 / 1.9 / 4.6 cm on the CMU ones - 6 of 11 over the 3 cm bar. After: all under 1.8 cm.

## Films (studio orbit, tools/clip_orbit.gd, mh_boxer_08: bare-chested, red trunks, boots, gloves; h264 30 fps, <= 40 s)

E:/FightCamp/tmp/s383/ownedmocap/<take>.mp4. Takes longer than 40 s are filmed in their best 40 s window
(owned_mocap_measure.gd OWNEDWIN: fewest plants over 3 cm, then the shortest guard drop):
cmu_14_01 0-40 s, cmu_14_02 0-40 s, cmu_14_03 0-40 s, cmu_13_17 0-40 s (of 40.3), cmu_15_13 6-46 s,
rk_fighting_idle 2-42 s (filmed to show why it is dropped). The rest are filmed whole.

Eyes (overview sheets + bursts): guard up and knees soft in every kept take; step-drag footwork, no walk; feet stay
put on the grid. rk_shadowboxing_a opens with the hands at chest height for ~1 s. cmu_17_10 is the weakest kept take:
the rear foot flicks up behind him on bounces (16.4, 16.9, 17.9 s) and the arms flare wide at 18.0 s; its LeftFoot
rotation moves > 15 deg/frame on 78 frames (CMU subject 17's foot markers). Kept on the numbers in the first pass.

**S383 independent eyes check** (a second reviewer on the films, bursts + crops): it agreed with the FightingIdle drop
and dropped three more that the bars passed - cmu_14_03 (rear hand to the hip every ~9 s), cmu_15_13 (telegraphed
crosses from behind the hip, a T-flail) and cmu_17_10 (the 17.4-18.4 s flail). The bars measure the guard by the wrist
under the shoulder and the slide by the ball; neither sees a cocked rear hand or a flail of under a second. Their
`.res` are removed; each has a usable cut noted below if the library needs more seconds later.

**Kept reel** (S383): E:/FightCamp/tmp/s383/ownedmocap/owned_kept_reel.mp4 - the 7 kept takes side by side (4x2 grid,
1280x720 h264, 8 s, labelled), each in its best 8 s window by owned_mocap_measure.gd `win=8` (fewest plants over 3 cm,
then the shortest guard drop): rk_shadowboxing_a 2-10 s, rk_shadowboxing_b whole 5.8 s (looped), rk_boxing 0-8,
cmu_14_01 25-33, cmu_14_02 22-30, cmu_13_17 0-8, cmu_13_18 16-24. Every window: 0 plants over 3 cm.

## S383d: "the video clip is lagging ... the knees are trembling again" - cause, fix, bars

**Cause** (tools/owned_mocap_jitter.gd; knee shake = RMS of the 2nd difference of the knee bend, deg/frame^2, 30 fps):
1. tools/clip_orbit.gd built the boxer through FightStage, so the films ran the WHOLE fight modifier stack. FootPlant held
   feet the clips already plant, swapped in its own 0.2 s steps and pinned the knee at its hard reach limit (~16 deg bend)
   and let go a few frames later: knee shake 3-4x the clip's (rk 1.4-1.6 -> 4.5-6.0, CMU 2.0-3.6 -> 7.6-9.6, PRO combo
   2.8 -> 9.7).
2. The film froze each frame with a seek (update) - that runs the modifier stack a second time per frame - and the
   films ran on wall-clock delta (no --fixed-fps): FootPlant's steps ran at double, uneven speed (the "lag").
3. KneeTrack near +-180 deg: the clamp sent a backwards knee to +20 deg one frame and -20 the next (cmu_13_17 right knee:
   flips up to 179 deg in a frame); clip_orbit also ran KneeTrack twice a frame (its own call + the modifier).
4. The orbit camera re-aimed at the hips every frame (whole-frame shake 2.4-6.7 mm/frame^2).

**Fix.**
- KneeTrack: a knee past 150 deg from its toes keeps the side it was last corrected to (Skeleton3D meta
  `knee_track_side`); the swivel is measured from that side the short way round. clip_orbit runs KneeTrack once.
- FootPlant (runs in every fight): the reach limit eases in (0.97 -> 0.99 of the leg, tanh) instead of a hard clamp; the
  IK target is low-passed in the world (0.03 s: a held foot's target is still, so a glide gets no lag; 0.06 was smoother
  but its landing tail slid the feet in the fight); a step takes 0.26 s (was 0.2); a repeat modifier pass in the same frame redoes the frame from its start state; the logic sub-steps
  at 1/60 s between frames and a teleport is a speed (6 m/s) as well as 0.3 m - frame-rate independent.
  Tried and DROPPED: letting the clip's own foot motion through the plant (its fast detail, or whole steps the clip lifts
  or drags). It halved the films' shake but the fight plays clips with the hips held in place, where that motion is
  skating: tools/sidestep_probe.gd planted slide on dodges/weaves went 0.1-0.3 m -> 0.5-1.7 m.
- Films: tools/owned_mocap_film.gd - the clip itself (every modifier off but MetaHumanTwist, no KneeTrack: "mocap plays
  pure"), one fixed camera (chest height, 3/4 front, placed once from the window's mean hips), --fixed-fps 30, frame
  t0 + f/30 exactly; `mods=game` films a clip through the full fight stack, PLAYING (no seek), as fights show it.

**Bars** (S383d, mh_boxer_08; "film" = the path the film is drawn on; before = the S383 films' path):

| take | clip knee shake | film before | film after | pole flips > 90 deg (before / after) | plant slide cm max (before / after) |
|---|---|---|---|---|---|
| PRO combo, game stack | 2.82 (`nofeet` 2.80) | 9.68 | 2.54 | 0 / 0 | 1.27 seek, 2.42 playing / 2.23 |
| our idle, game stack | 0.47 (`nofeet` 0.46) | 0.73 | 0.47 | 0 / 0 | 1.40 seek, 1.37 playing / 1.38, 1.27 |
| rk_shadowboxing_a | 1.36 | 4.48 | 1.36 | 0 / 0 | 5.61 / 1.03 |
| rk_shadowboxing_b | 1.48 | 5.07 | 1.48 | 0 / 0 | 4.81 / 1.20 |
| rk_boxing | 1.44 | 6.00 | 1.44 | 0 / 0 | 4.94 / 1.44 |
| cmu_14_01 | 2.03 | 7.57 | 2.03 | 2 / 0 | 4.16 / 1.64 |
| cmu_14_02 | 3.08 | 9.57 | 3.08 | 6 / 1 (the clip's own) | 2.77 / 1.44 |
| cmu_13_17 | 3.64 | 8.99 | 3.64 | 7 / 0 | 1.62 / 1.84 (the clip's own) |
| cmu_13_18 | 2.52 | 7.77 | 2.52 | 0 / 0 | 4.56 / 1.66 |

- FootPlant bar (game stack, knee shake within +20 % of `nofeet`): PRO combo 2.54 vs 2.80, idle 0.47 vs 0.46 (+2 %);
  seek path 2.55 / 0.48. Plant slide: idle 1.37 -> 1.27 playing, 1.40 -> 1.38 seek; PRO combo 2.42 -> 2.23 playing, but
  1.27 -> 2.23 on the old seek path (that path ran the steps at double speed) - over the "no worse" bar there by 1 cm.
- 1/30 s vs 0.2 s steps (both read every 0.2 s, game stack playing): PRO combo knee 19.2 / 19.6 (+2 %), slide 4.6 / 4.6;
  idle 7.3 / 8.0 (+10 %), slide 1.20 / 1.20. tests/foot_plant_test.gd: a 0.8 m/s glide at both steps - foot travel within
  1.3 %, feet end within 1.4 cm.
- In the fight (tools/sidestep_probe.gd, --fixed-fps 60, planted slide m, old FootPlant -> new): guard 0.02 -> 0.02; the
  game's short steps 0.02/0.03/0.02/0.05 -> 0.03/0.04/0.03/0.06; dodges/weaves without SideStep 0.21/0.11/0.01/0.04/0.05
  -> 0.20/0.14/0.01/0.03/0.09; with SideStep 0.08/0.06/0.08/0.10/0.13 -> 0.04/0.05/0.04/0.17/0.16 (totals 0.42 -> 0.47
  and 0.45 -> 0.46 m).
- **S383d films** (E:/FightCamp/tmp/s383/ownedmocap2/<name>.mp4 and <name>_legs.mp4, 1920x1080 h264 crf 18, 30 fps, each
  checked: ffmpeg mpdecimate unique frames == frame count): the 7 kept takes and our idle as the clip itself (pure), the
  whole take or its least-travel 30 s (cmu_14_01/14_02/13_17 30 s windows; rk_shadowboxing_b 5.8 s and the idle looped to
  10 s); a 10 s legs close-up of each; pro_combo_punch_game.mp4 - the PRO combo as the fight loads it (hips held in
  place), through the whole fight stack with the new FootPlant/KneeTrack, guard 1 s between repeats, 10 s.
- Known, not changed: a fast sideways glide steps both feet nearly all the time (the S376 reach rule; legs near full
  stretch in our stance with the S314 stretch) - old and new FootPlant alike.
- Tests: tests/knee_track_test.gd (a backwards knee keeps its side), tests/foot_plant_test.gd (frame-rate independence,
  feet held while the body stands, steps while it glides), tests/owned_mocap_test.gd unchanged.

## Dropped

| take | why |
|---|---|
| rk_fighting_idle (Rokoko FightingIdle, 52 s) | **guard down 7.9 s** at a stretch, 35 % of the take (best 40 s window still 6.2 s): a rest between rounds, hands at the hips, standing tall (knee p5 13 deg). S383 eyes agree: no stance bounce, guard down for seconds (film 0.0-2.5 hands at the hips, 18.5-21.5 hands at chest, 30.5-33.1 rear glove at the hip). `.res` removed from the repo. |
| cmu_14_03 (46.1 s) | S383 eyes: about every 9 s the rear hand drops to the hip and stays (bars: 1.1 s guard-down run) - 11.7, 20.3-20.7, 29.5-29.7, 39.1 s; feet narrow, standing tall at 21.3-21.5 and 37.1-38.5. Clean at 0-2.5 and 12-19 s (a cut there would be usable). `.res` removed. |
| cmu_15_13 (50.5 s) | S383 eyes: tightest guard between punches, but nearly every cross starts with the rear glove cocked behind the hip (a telegraphed haymaker: take 14.7, 16.7, 35.5, 43.3, 44.9-45.1 s), both arms flung out in a T while turning at 37.3-37.6, the lead glove above the head at 8.3-8.5 (film t + 6 s). Usable only as a cut, e.g. take 16.9-35.3 s. `.res` removed. |
| cmu_17_10 (23.2 s) | S383 eyes: 17.4-18.4 s a flail, not boxing - drops into a crouch, rear foot kicked up to knee height (17.9), arms wide, rear glove straight overhead (18.0-18.1), rear forearm folded across the chest (18.2-18.4); 12.0 a lunge so deep the rear knee nearly touches the floor; 22.2-23.0 feet together, standing tall. 0-17.3 s is fine (re-check 16.4/16.9 bounces after a trim). `.res` removed. |
| Mixamo "Offensive Idle" (S381 eyes) | hands at the hips, a warm-up |
| Ailive Boxing_Footwork (S381 eyes) | stance ~1 m wide, rear hand at the hip |
| Ailive Dudging_with_a_Sway (S381 eyes) | a 2 s lunge, hands low |
| CMU 15_05 guard window 145.7-190.4 s, 15_04 (S381 eyes) | feet together, hunched, elbows flare; same actor not baked |

## Test bars (tests/owned_mocap_test.gd reads these lines)

Every kept `.res` loads, carries the template's tracks, is this long (+-0.02 s), holds no NaN, and no plant slides past
the bar on mh_boxer_08.

```
OWNED_KEPT rk_shadowboxing_a secs=11.867 slide_bar_cm=3.0
OWNED_KEPT rk_shadowboxing_b secs=5.800 slide_bar_cm=3.0
OWNED_KEPT rk_boxing secs=15.467 slide_bar_cm=3.0
OWNED_KEPT cmu_14_01 secs=46.600 slide_bar_cm=3.0
OWNED_KEPT cmu_14_02 secs=45.167 slide_bar_cm=3.0
OWNED_KEPT cmu_13_17 secs=40.300 slide_bar_cm=3.0
OWNED_KEPT cmu_13_18 secs=24.967 slide_bar_cm=3.0
```

Dropped takes must have no `.res` in `assets/anim/baked/owned/`:

```
OWNED_DROPPED rk_fighting_idle why=guard_down_rest
OWNED_DROPPED cmu_14_03 why=rear_hand_at_hip
OWNED_DROPPED cmu_15_13 why=telegraphed_cross_flail
OWNED_DROPPED cmu_17_10 why=flail_17s
```

## Not done

- The clips are not wired into FightClips / BeatClips; no fight plays them yet. In the fight the KneeTrack, FootPlant
  and GuardTuck modifiers would sit on top (the S383d films show the clips pure; pro_combo_punch_game shows the stack).
- The arms keep the actors' punch speed; the pops count is mostly that, not noise (hands/toes noise removed).

# FIGHTPLAYER2 baseline (S510 animation session, part 3, 2026-11-17)

Owner S510: "animations looked fine when we bought them, everything got fucked after that so it has to be coding mistakes
or pipeline". This page answers where the damage comes from, with pictures and numbers, before the rebuild is scoped
(`ops/research/FIGHTPLAYER2_SCOPE_S510.md`). Nothing in the game changed: two tool switches and one new tool.

## The short answer
1. **Retargeting does not damage the clips.** The same clip on the vendor's own character and on our boxer shows the same
   stance, arm lines and timing. What the pipeline takes away is the body's TRAVEL: every clip is pinned on the spot.
2. **The damage comes from two base layers, and the other ~20 layers are patches on those two.** The footwork rig (it
   replaces the clip's legs) and the punch reach (it re-solves the punching arm onto the target). Each fixes a real
   problem (feet skating, gloves missing the target) and each brings its own new defects, which later layers then patch.
3. **The layers buy nothing.** Same bout, same seed, same camera, two fresh blind critics each: raw clips 4.5 / 4.5,
   placement only 4.5 / 4.5, the full game 4.5 / 4.5. Months of correction layers moved the defects around and left
   the score where the bought clips alone already stand.
4. **So the clips were not wrecked, and patching cannot reach 7.** What holds every build at 4.5 is the same list: no
   distance per punch, no reaction that owns the hit man, no defence that answers a punch, no travel. That is the
   fight player's design (which clip, from where, against what), not a missing correction.

## 1. Bought clip on its own character next to our boxer
Tool: `tools/bought_beside_ours.gd` (new). It loads the vendor's .fbx as it lies in `E:/FightCamp/packs/mocaponline_punch_pro`
(outside the repo, nothing copied in) and plays it on the vendor's own character beside the same clip on our boxer with
every fight layer off; one fixed side camera, a grid floor, the same clip time in both.
Film: `E:/FightCamp/tmp/fightweek/s512/retarget/bought_vs_ours.mp4` (nine clips, each at full and at 0.4 speed). Sheets
beside it (`<clip>_sheet.jpg`).

| Clip | Length bought / ours (s) | Hips travel bought / ours (m) | Punching hand travel bought / ours (m) |
|---|---|---|---|
| Left jab | 1.07 / 0.84 | 0.15 / 0.02 | 0.42 / 0.34 |
| Right cross | 0.87 / 0.87 | 0.04 / 0.02 | 0.50 / 0.42 |
| Left hook v2 | 1.23 / 1.23 | 0.09 / 0.04 | 0.58 / 0.58 |
| Body shot | 1.10 / 1.10 | 0.23 / 0.22 | 0.61 / 0.50 |
| Right uppercut | 1.30 / 1.30 | 0.20 / 0.12 | 0.69 / 0.69 |
| Hit by gut shot v2 | 1.97 / 1.97 | 0.49 / 0.10 | 0.41 / 0.32 |
| Hit by cross v1 | 1.10 / 1.10 | 0.04 / 0.01 | 0.24 / 0.20 |
| Back dodge | 1.77 / 1.77 | 0.50 / 0.15 | 0.60 / 0.14 |
| Idle | 1.60 / 1.60 | 0.02 / 0.02 | 0.04 / 0.04 |

(The vendor's character is drawn at 0.91 of its size so both stand hip to hip at one height.)
This agrees with the fidelity gate already in the repo (RETARGET2B, 2026-11-08: `tests/retarget_fidelity_test.gd` reads
145 clips against the raw takes, 0 failures; `ops/research/RETARGET2B_RESULT.md`).
What the pictures show:
- Poses carry over: guard, stance width, knee bend, trunk turn, the punching arm's line. No broken joints, no twisted
  wrists, no sunk hips. Retargeting is not where the fight goes wrong.
- **Travel is lost.** `FightClips.hold_root_xz` pins every clip's hips where they start. The bought jab steps in 15 cm, ours
  2; the gut-shot reaction staggers back 49 cm, ours 10; the back dodge moves 50 cm, ours 15. So a hit man folds on the
  spot instead of being driven back, and a jab has no step under it. `PunchWeight` gives part of a punch's own travel back.
- **The jab is cut short**: the bake keeps 0.84 s of the vendor's 1.07 s (the last 0.23 s, the settle into the guard).
- Seen on the cross sheet, not measured: the vendor's free fist stays at the chin; on our boxer the free glove sits
  further in front of the face (longer forearm plus a 19 cm glove on the same joint angles).

## 2. The same bout three ways
Seed 7, 75 s, 1920x1080, the game's fixed camera, the same seven sheet windows on the same exchanges.
- **RAW** (`b15a`): the bought clips as baked, joined by the join smoother, the two men placed by the range rules. Every
  other pose layer off: 24 of the 26 layers on a boxer's skeleton (list below), plus the hit step, the place smoothing
  and the punch's late start. Nothing puts a glove on a target and nothing plants a foot.
- **PLACEMENT ONLY** (`b15b`): RAW plus the two things that place: the punch reach (glove onto the target) and the
  footwork stack (feet onto the canvas: FootPlant, the footwork rig, knee tracking, foot lock, floor layers).
  Decided here: a film with the reach but no feet would skate exactly like RAW and tell nothing new, so "placement" is
  both placements. The reach alone is in the ruler table (raw + reach).
- **FULL** (`r14blind`): the game as shipped, round 14.

### Blind scores (coach / animator)
| Build | Whole fight | Punches | Defence + reactions | Footwork + stance | Transitions | Waiting |
|---|---|---|---|---|---|---|
| RAW (clips only) | **4.5 / 4.5** | 5 / 5.5 | 4 / 3.5 | 4 / 4 | 5 / 5 | 4.5 / 3.5 |
| PLACEMENT ONLY (reach + feet) | **4.5 / 4.5** | 4.5 / 4.5 | 3.5 / 3.5 | 5 / 5 | 5 / 4 | 5.5 / 4.5 |
| FULL (round 14, all 26 layers) | **4.5 / 4.5** | 5 / 5 | 4 / 4.5 | 4.5 / 4 | 4.5 / 3.5 | 5 / 4.5 |

**All three builds score the same.** Six fresh critics, three builds, every whole-fight score 4.5. The 24 layers between
RAW and FULL buy no point: each build loses its points somewhere else.
- RAW loses them on feet that slide (32-34 m a round), reactions too small to see (cross 10.7 cm, no step back, a hit
  man punching back inside 5-9 frames), landed punches that stop on the gloves, and one identical chest-on guard pose
  for both men with the gloves 30 cm in front. It wins on transitions (5 / 5, the best of the three) and punches
  (5 / 5.5): the clips themselves and their joins are the cleanest thing we have.
- PLACEMENT ONLY wins footwork (5 / 5) and loses punches: the glove goes over the crown or behind the ear nine times in
  five exchanges, jabs land from 1.0 m with a bent arm, the puncher's head jumps 19-25 cm on contact, heads merge.
- FULL gets the reactions and the bodies apart and loses transitions (4.5 / 3.5, the worst of the three): the pops.
Reviews and each critic's 10/10 drawing: `E:/FightCamp/tmp/fightweek/b15a/` (RAW) and `b15b/` (PLACEMENT ONLY),
`critic_coach.md`, `critic_animator.md`, `critic_*_10.png`; round 14's in `r14blind/`.
What all six ask for, whatever the build: the distance set by the punch (a straight arm at contact, reached with a
step), a landed punch that moves the whole man and stops him punching, a block and a miss that look different from a
hit, defence that answers a punch, the hand home at once, bodies that never merge. None of these is a correction of a
clip; all of them are about WHICH clip plays, from WHERE, and what the other man plays against it.

### Rulers, one headless bout each (75 s; the films read the same)
| Build | Head jumps over 12 cm a frame | Worst (cm) | Frames with a head inside the other's body | Arm left out after contact (frames) | Hit head travel (cm) | Knee bend left / right (deg) | Knee jerks over 8 deg (4 knees) | Landed punches clean / grazed |
|---|---|---|---|---|---|---|---|---|
| RAW | 3 | 15.7 | 0 | 8 | 9.5 | 151 / 146 | 3, 6, 5, 3 | not placed |
| raw + feet stack | 4 | 16.5 | 22 | 8 | 10.6 | 130 / 134 | 90, 126, 68, 114 | not placed |
| raw + punch reach | 24 | 22.7 | 6 | 5 | 9.4 | 151 / 146 | 4, 10, 8, 11 | 13 / 3 |
| PLACEMENT ONLY | 19 | 24.7 | 19 | 5.5 | 10.7 | 130 / 135 | 98, 179, 96, 130 | 12 / 4 |
| FULL (r14) | 14 | 16.9 | 3 | 4 | 19.3 | 125 / 127 | 76, 100, 49, 63 | 13 / 3 |
| full, no PopCap | 33 | 25.4 | 4 | 4 | 18.8 | 125 / 127 | 77, 100, 49, 62 | 13 / 3 |
| full, no GloveClear | 16 | 21.9 | 14 | 4 | 21.9 | 125 / 128 | 76, 139, 71, 89 | 10 / 6 |
| full, no GuardTuck | 19 | 18.6 | 6 | 4 | 17.7 | 125 / 128 | 95, 128, 71, 106 | 12 / 4 |
| full, no HitSnap | 18 | 20.3 | 20 | 4.5 | 14.2 | 126 / 128 | 83, 120, 54, 93 | 14 / 2 |
| full, no HitStep | 12 | 16.9 | 3 | 4 | 16.4 | 125 / 130 | 79, 121, 39, 75 | 13 / 3 |
| full, no FighterLife | 16 | 15.1 | 1 | 4 | 12.2 | 125 / 127 | 106, 126, 53, 85 | 12 / 4 |
| full, no ArmHome | 14 | 16.9 | 5 | 5.5 | 17.8 | 125 / 127 | 70, 112, 62, 90 | 12 / 4 |
| full, no GuardBox | 14 | 16.9 | 3 | 4 | 19.3 | 125 / 127 | 76, 100, 49, 63 | 13 / 3 |
| full, no GuardWeave | 11 | 21.6 | 7 | 4 | 16.2 | 131 / 134 | 101, 138, 78, 106 | 13 / 3 |

RAW also slides: a boxer's standing foot travels 33-37 m in the round (FULL 0.2-0.4 m) and one of them has both feet
off the canvas 6 % of the time. That is why the feet stack exists.

### What each layer costs, read off the table
- **The footwork stack** stops the skating (37 m -> 0.3 m) and costs: knee jerks 3-6 -> 68-179 a knee, the bought
  stance (knees 146-151 deg, the upright stance the coach has asked for since round 13: "150-160") squashed to 125-135, and the men
  walked into each other (a head inside the other body 0 -> 22 frames) because it steps the feet to the range rule's
  place whatever the clip's body does.
- **The punch reach** puts 13 of 16 landed gloves on the target and costs: head jumps 3 -> 24 (worst 22.7 cm in one
  frame). It leans the chest to make the arm fit, forward when the target is far and BACK when it is near (round 14's
  "jabs with his head thrown back", a jab thrown from 0.87 m: 14 cm of lean back from this layer alone).
- **PopCap** exists to hide the reach's jumps: 33 -> 14. Still 4.7 times RAW.
- **GloveClear / HitSnap** hide the bodies merging: 14-20 frames -> 3. RAW has 0 because nobody is pulled onto a target.
- **GuardBox** changes nothing on this bout (identical rulers); **HitStep** and **ArmHome** move one ruler each by a little.
- The reaction sizes (hit head 9.5 -> 19.3 cm) are ours (HitSnap, FighterLife, the clip pools), not the clips'.
- The range rules stand under all three: rest at 1.3-1.6 m, punches from a pocket where the gloves already touch. The
  critics' "they never fight at a distance" is in RAW too.

### The 26 layers on a boxer in the shipped fight (stack order)
PunchWeight, JoinSmoother, TiredSag, BoxerFootworkUpper, FighterLife, GuardWeave, GuardTuck, PopCapPre, ArmHome,
PunchReach, HitSnap, GloveClear, RkJoinFeet, ElbowClear, ArmClash, KneeTrack, FootPlant, BoxerFootworkRig, FloorClear,
FootLock, FloorStand, GuardBox, CornerIK, MetaHumanTwist, PopCap, PoseRecorder.
RAW keeps PunchWeight (the clip's own hip travel given back), JoinSmoother and MetaHumanTwist (the skin's helpers).

## 3. What this says for the rebuild
- Keep: the clips, the retarget, the join smoother.
- The two jobs that cannot be dropped are the two placements: feet that do not skate and gloves that reach the target.
  Both are done today by re-solving the body every frame against a place and a target that the clip knows nothing
  about; every defect the critics list as "no human does this" comes out of that fight between the clip and the solver.
- The way shipped boxing games do it (the scope page's subject): pick the clip that already fits the distance (or move
  the men so it fits) and play it whole with its own travel, instead of bending a clip that does not fit.
  The two numbers that matter for that: how far each clip reaches, and how far each clip travels - both are in the
  bought files and both are thrown away or overridden today (the hips pin; the range rule placing the men first).

## How to rerun
- Retarget film: `python tools/hidden_desktop.py run --timeout=900 <godot> --path . --windowed --resolution 1920x1080
  --fixed-fps 30 --audio-driver Dummy --log-file <log> --script res://tools/bought_beside_ours.gd -- out=<dir>
  fbx=E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX clips=Left_Jab,Right_Cross`
- RAW film / log: `tools/human_fight_film.gd ... -- <out> secs=75 seed=7` plus
  `noweave noguard noreach nosnap noglove nopopcap noprecap noguardbox nohitstep nofeet noknee nofloor nofootlock
  nofloorstand nolook nosmoothroot nofastdrive noheadside nostand nokneecalm noclash noarmhome nojoinfeet
  rawclips=PunchWeight` (`rawclips[=keep,...]` is new in the film tool: it switches off whatever pose layer is left
  without a switch of its own; one STACK line a boxer prints what ran). RAW's film clock runs 2.13 s behind the
  others (the walk to the centre): its sheet windows are the usual ones + 2.133 s.
- PLACEMENT ONLY: `noweave noguard nosnap noglove nopopcap noprecap noguardbox nohitstep nolook noheadside noclash
  noarmhome rawclips=PunchWeight,PunchReach,KneeTrack,FootPlant,BoxerFootworkRig,BoxerFootworkUpper,FloorClear,FootLock,
  FloorStand,RkJoinFeet`
- The film tool now also writes `hits.json` (every landed punch: clean, grazed or cut off, how far the glove was).
- Round-15 edits that were in work when the course changed are parked, not committed:
  `E:/FightCamp/tmp/fightweek/s512/r15_parked.patch` (lean-back cap, body-shot wait and step back, guard height, jab
  reaction pool, no empty-air weaves). Under the new rule (no new correction layer) they stay parked.

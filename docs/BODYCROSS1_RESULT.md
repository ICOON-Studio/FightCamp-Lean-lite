# BODYCROSS1 result (S542, 2026-11-23) - a rear straight to the body that lands on the ribs

Task: ops/research/TASK_BODYCROSS1.md. METHOD followed: FIGHTPLAYER2, v2 only, no new correction layer in scripts/fight3d.
The fix is a TAKE (a new baked file the player plays). Nothing was bought or generated.

## What now works
- A new take, `pro_body_cross` (assets/anim/baked/mc_Box1_M3_Body_Cross.res): the boxer changes level with the legs and
  punches flat at the ribs. On the census body its glove front is **0.2 cm** from the rib point at the contact (the old
  best take was 0.17-0.29 m high).
- The body-cross pictures are re-made with it in both sets. `tests/fight_pictures_test.gd` was red on exactly the four
  landed ones and is green.
- Before/after films on the fixed side camera and the stills are on the review board (list at the end). The owner's eye
  closes it.

## Step 1 - which study the take follows
- `ops/research/REFERENCE_PUNCH_TARGETS_S439.md`, the body-shot row and note 9 (the body forms of a shipped boxing game,
  read into numbers only): a body form keeps its head form's timing within one key, the fist ends 0.30-0.40 m lower,
  the head drops about 0.22 m, the other glove stays by the head.
- `ops/research/K46_BOXER_FEET_DURING_PUNCHES.md` lines 56-61: the level change is real in coaching, the feet stay
  planted, the knees and hips bend; no published number for how far.
- `ops/research/topics/clips_sources.md` (Settled): buying is off, the text-to-motion boxing takes were all rejected,
  so the route is an owned take edited offline.
- Owner S537 ("the power does not come from twisting the knee"): the knees stay over the toes; nothing twists outward.

## Step 2 - what the punch is, numbers before any take was touched
Reference clip named: **Blood & Canvas `AS_JabBody`** (the body straight re-decoded key by key in S439) and that
game's body cross form (contact one key after its head cross). Our own bought body take, `pro_body_shot`, is the
second reference for how far a captured boxer sinks. A real-footage measure of a body straight does not exist in our
research (K46 says so); that gap is still open.

| Measure, at the contact | Reference | Ours before (plain cross, as it plays) | Target | New take |
|---|---|---|---|---|
| Glove height against the other man's rib point (0.889 m) | on the body | +0.35 m (as recorded); +0.17 to +0.29 after the arm finish | within 0.05 m | **+0.002 m** |
| Fist lower than the head form | 0.30-0.40 m | 0 | 0.30-0.40 m | 0.35 m |
| Hips drop | our body take 0.17-0.22 m | 0.00 m | 0.17-0.22 m | 0.18 m |
| Knee bend, lead / rear | our body take 94-119 deg (standing cross about 143, K46) | 151 / 178 deg | 95-120 deg | 98 / 106 deg |
| Head drop | about 0.22 m (B&C); our body take 0.27-0.30 m | 0.01 m | 0.20-0.27 m | 0.21 m |
| Trunk lean from upright | our body take 32-35 deg | 15.5 deg | under 30 (back fairly straight) | 24.1 deg |
| Arm line | flat, elbow 150-165, never locked | elbow 168 | the take's own arm | elbow 168, pitched 1.4 deg |
| Head against the centre line | off it | on it (0.00 m) | off it | **on it (0.00 m) - not met** |
| Lead glove to own head | 0.14-0.52 m, median 0.20 | 0.35 m | unchanged | 0.36 m |
| Contact after the start | 0.23-0.27 s | 0.30 s | one key later than the head form | 0.36 s |
| Hand back in guard after the contact | 0.30-0.37 s | 0.37 s | unchanged | 0.37 s |
| Feet | planted | planted | exactly where the take has them | moved 0.0000 m |

## Step 3 - prefab check: every take on disk, measured
Tool: `tools/pics2d_bodycross_probe.gd` (headless; the census body mh_boxer_10, as bought, every fight layer off). For
each take and hand it finds every time the glove front reaches out and reports the one nearest the ribs. 252 takes
loaded; 197 have a reach. A candidate must be a RIGHT arm, straight (elbow 140 deg or more), reaching 0.65 m or more.

| Source | Takes with a reach | Best straight right arm (glove against the ribs) | Lowest right glove of any kind |
|---|---|---|---|
| ActionForge / Quaternius (baked af_*) | 5 | af_push at 0.667 s: glove 0.84 m = **-0.04 m**, elbow 178, hips down 0.04 | af_push: -0.04 m, elbow 178, reach 0.95 |
| ActionForge retarget of the bought cross (assets/anim/af_retarget) | 1 | afr_mc_Box1_M3_Right_Cross at 0.3 s: glove 1.24 m = **+0.35 m**, elbow 168, hips down -0.01 | afr_mc_Box1_M3_Right_Cross: +0.35 m, elbow 168, reach 0.87 |
| Ailive trial pack (baked/ailive_trial, untracked) | 10 | ai_mc_Punch_with_Right_Hand at 3.1 s: glove 1.22 m = **+0.33 m**, elbow 175, hips down 0.20 | ai_mc_Dudging_with_a_Ducking: -0.04 m, elbow 78, reach 0.50 |
| old baked / native MetaHuman clips | 10 | cross at 0.267 s: glove 1.32 m = **+0.43 m**, elbow 167, hips down 0.03 | rear_uppercut: -0.05 m, elbow 96, reach 0.59 |
| CMU mocap (baked/owned) | 4 | none (no straight right arm) | cmu_14_02: +0.01 m, elbow 72, reach 0.52 |
| MoCap Online Punch Starter (baked mc_Punch_M3_*) | 19 | mc_cross at 0.3 s: glove 1.28 m = **+0.39 m**, elbow 145, hips down -0.01 | mc_dodge_left: +0.22 m, elbow 97, reach 0.50 |
| owned Mixamo takes (baked ow_*) | 1 | none (no straight right arm) | - |
| MoCap Online Punch PRO (baked mc_Box1_M3_*) | 133 | pro_win_v3 at 4.717 s: glove 1.06 m = **+0.17 m**, elbow 142, hips down -0.02 | pro_knockout_v8: -0.14 m, elbow 167, reach 0.56 |
| Rokoko free fight pack (rokoko_combat FBX, baked/owned) | 2 | none (no straight right arm) | rk_boxing: +0.33 m, elbow 141, reach 0.60 |
| captured boxing steps (baked/steps) | 12 | none (no straight right arm) | st_pivot_right_lo: +0.04 m, elbow 73, reach 0.50 |

The twelve nearest straight right arms:

| Take | At s | Glove m | Against the ribs m | Elbow | Reach m | Hips down m | Knees |
|---|---|---|---|---|---|---|---|
| af_push | 0.667 | 0.845 | -0.044 | 178 | 0.95 | 0.04 | 95 / 120 |
| pro_win_v3 | 4.717 | 1.063 | +0.174 | 142 | 0.68 | -0.02 | 132 / 140 |
| pro_body_shot | 0.6 | 1.180 | +0.290 | 174 | 0.93 | 0.17 | 119 / 119 |
| pro_combo_punch | 0.633 | 1.184 | +0.294 | 164 | 0.83 | 0.04 | 139 / 148 |
| ai_mc_Punch_with_Right_Hand | 3.1 | 1.222 | +0.333 | 175 | 0.90 | 0.20 | 113 / 127 |
| afr_mc_Box1_M3_Right_Cross | 0.3 | 1.239 | +0.349 | 168 | 0.87 | -0.01 | 151 / 178 |
| pro_right_cross | 0.3 | 1.239 | +0.349 | 168 | 0.87 | -0.01 | 151 / 178 |
| pro_right_cross_special | 0.933 | 1.258 | +0.368 | 167 | 0.83 | -0.01 | 159 / 141 |
| pro_right_cross_hard | 0.967 | 1.276 | +0.386 | 143 | 0.90 | -0.00 | 153 / 156 |
| mc_cross | 0.3 | 1.276 | +0.387 | 145 | 0.85 | -0.01 | 162 / 157 |
| pro_right_cross_hurt | 0.467 | 1.287 | +0.398 | 153 | 0.68 | -0.00 | 161 / 149 |
| pro_right_cross_hurt_ft | 0.733 | 1.292 | +0.403 | 165 | 0.85 | 0.01 | 168 / 152 |

What the two takes the brief named throw:
- `mc_Box1_M3_Body_Shot` (pro_body_shot): a LEFT hook to the body (left glove +0.06 m at 0.45 s, elbow 97), then the
  right arm goes straight at chest height (+0.29 m at 0.60 s). Not a body cross.
- `boxing_body_hook` (body_hook): a LEFT hook to the body (+0.06 m, elbow 70). Its right hand stays bent, 0.24 m high.
- `af_push` is the corner team's two-handed push and `pro_win_v3` a celebration: straight arms, not punches.
- assets/anim/mixamo_walk holds only walks. The Mixamo-skeleton boxing FBXs (rokoko_combat) are the rk_ rows: no
  straight right arm low.

**Verdict: nothing on disk lands a straight right arm within 0.05 m of the ribs.** The nearest real punches are 0.29 m
(pro_body_shot's second hand, tangled with its hook) and 0.33-0.35 m high.

Licences: MoCap Online Punch PRO and Starter are bought; their licence asks written permission for AI use, and the owner
said in S510 "i have permission go on". Rokoko pack: free for commercial use, AI terms not stated. Mixamo: royalty-free,
no stand-alone redistribution. CMU: free. ActionForge / Quaternius: CC0. Ailive: a trial pack, dropped in S447, not in
git. The four mh_ clips are ours.

## Step 4 - the route taken: one take authored offline
Tool: `tools/pics2d_bodycross_bake.gd` (headless, run once; it writes the keys into a new file and no script bends the
body at run time). Base: the plain cross as the game shows it today (the bought cross with ActionForge's legs, the
owner's S537 pick; the best-scored cross in CLIP_CRITICS_S439). In its own keys:
- the hips sink 0.18 m, eased in from the first key to the contact, held 0.07 s, eased out over 0.38 s;
- both feet stay where the take has them (a leg solve per key; the knees go over the toes);
- the trunk hinges forward 10 deg (pelvis, spine, chest share it); the neck and head give most of it back so the eyes
  stay on the other man;
- the punching arm is pitched 1.4 deg from the shoulder, solved so the glove front is at rib height on the contact key;
  elbow, forearm and fist are the take's own;
- the load (first 0.13 s) plays 1.45x slower, so the sink is not faster than a body falls; the drive keeps its speed.

Into the clip table by the usual route: `ClipCensus.STEMS` got one entry (family `body_cross`), and
`tools/clip_census.gd` measured the row: contact gap 1.045 m, contact 0.358 s, 0.2 cm over the rib point, miss 0, no
drop reason, no flag. Foot timing and hit timing need nothing more: a punch plays its legs as recorded (FootTake, S537)
and the hit time is the row's contact.

Feedback-loop check (which moves resolve to the new take), printed once before the picture run: family `body_cross`
holds only this take; it is in no pool of jab, cross, lead hook, rear hook, either uppercut or body hook; it is not in
BeatClips' played list. `tests/player2_test.gd` reads the same numbers as before (median 0.004 m, 13 of 14).

## Steps 5 and 6 - pictures, test, film
- Red first (shipped tree): `FAIL set w: every landed glove on its target (off: ["blue_body_cross_landed 0.21 m",
  "red_body_cross_landed 0.18 m"])`, `FAIL set m: ... ["blue_body_cross_landed 0.29 m", "red_body_cross_landed 0.17
  m"]`, `FIGHT_PICTURES failures=2`.
- After: landed gloves 0.002 / 0.036 m (women, red / blue) and 0.001 / 0.004 m (men). Bar 0.07 m.
- Film (`tools/pics2d_bodycross_film.gd`, the pictures' own fixed side camera, same pair, old take then new take):
  women, red throws: 0.174 m -> 0.001 m; men, blue throws: 0.302 m -> 0.029 m.

RESULT: tests/fight_pictures_test.gd -> FIGHT_PICTURES failures=0
RESULT: tests/player2_test.gd -> PLAYER2 failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
RESULT: tests/clip_db_test.gd -> CLIP_DB failures=0

## Decided without asking
1. All twelve body-cross pictures were re-made (landed, blocked, missed, both corners, both sets), not only the four
   landed: the same punch should look the same whether it lands or not.
2. `assets/data/clip_db.json` is not in the brief's owned list but it IS the v2 clip table. Only one row and one name
   were added; every other row is byte-for-byte as committed.
3. The take is NOT wired into the 3D fight. The brief says the gap "shows in the 3D fight whenever a body cross lands":
   it cannot, because no rule module throws `body_cross` (only FightLog's word table and the pictures name it) and
   the v2 choreographer's punch list does not hold it. Making the fight throw it changes how bouts play: a scope call.
4. The brief's `tools/still_framing.gd` does not exist in this repo (it was the old one's). The film's stills go
   through the picture tool's own framing check (both boxers head to toes in frame, else STILL_FRAMING FAIL).
5. `tools/pics2d_set.gd`: the setup was split out so the film tool reuses it, and `only=*<part>` renders one family
   for both corners. The other 46 pictures a set were not re-rendered.
6. No hip travel forward was added (reference: about 0.11 m). The v2 player turns a take's hip travel into body travel,
   which would slide the planted feet.

## Not done, and what I would look at
- The head stays on the centre line. A real boxer takes it off the line; that needs a side bend keyed in and judged on
  film. One more pass of the same bake, if his eye asks for it.
- The knees bend to 98 / 106 deg and the feet are close front to back (the base cross's own stance). It reads as a level
  change; it may read a little deep.
- The take is authored, not captured, and only its level change is new. A captured body straight would replace it (the
  mocap buy is his call, end of November).
- Found on the way, not touched: a fresh census run changes `pro_right_cross`'s row (contact gap 1.015 -> 1.008 m,
  knees 159 / 147 -> 150 / 169). The table was last measured before ActionForge's legs were switched on in S537.
- `ops/previews/s540_pics2d/NOTES.md` item 1 still describes the old pictures.
- The headless import this task ran also wrote `tools/coachdeep6.gd.uid` and `tools/coachdeep6_rules.gd.uid` for
  another session's new tools; they are not in this commit.

## On the review board (http://127.0.0.1:8787/review, "Body cross: lands on the ribs", S542)
Files in ops/previews/s542_bodycross/ (copied to E:/FightCamp/review/2026-11-23_2006_body_cross_lands_on_the_ribs):
- bodycross_before_after_w.mp4, bodycross_before_after_m.mp4 - old take left, new take right; twice at real speed,
  then once at quarter speed
- bodycross_contact_before_after_w.png, bodycross_contact_before_after_m.png - the contact picture, old v new
- bodycross_pictures_w.png, bodycross_pictures_m.png - the re-made 2D pictures
- bodycross_new_take_frames_w.png - the new take, a picture every 0.1 s

Every still was opened by me: the new glove sits on the trunk at rib-to-waist height with the lead glove by the chin;
the old one is at the chest from clinch range.

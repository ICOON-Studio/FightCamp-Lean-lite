# KDPIC1 - the knockdown stays inside the ring; the overhand gets its own picture (S566, console worker)

Brief: ops/research/TASK_KDPIC1.md. Worker rules: ops/research/WORKER_S566.md. Started after INSIDE1 and GLIDE2 had pushed, the
render slot free, the watchdog GREEN and his game closed (checked before every render by the render script).

## Result in one line each
- **Step 1, the knockdown inside the ring: DONE.** All 18 knockdowns from a landed punch (9 families x 2 corners) and the 2
  plain knockdowns re-made. Pixel test: 0 pixels of the falling man outside the ropes from the page's furthest-back spot,
  and 0 outside the page's stage from his own spot, on every frame. Edge table landed contact -> knockdown first frame:
  0 jumps over 45 edges (worst 2.3 px).
- **Steps 2-4, the overhand take: BLOCKED.** No overhand exists in our files, and Ludo's text-to-motion made 12 candidates
  over 3 prompts, none an overhand from a guard. Nothing was faked: the page still plays the rear hook for an overhand
  (beat_shot confirms it: `red_rear_hook_landed_r2 > red_rear_hook_ko`).

## Step 1 - what was wrong (measured, not guessed)
The knockdown take (pro_knockout_v1) lays the hit man flat on his back: the hips go 0.96 m back, and from his spot to
his head is 1.6-1.8 m, straight back along the ring line. Two limits were crossed:
1. **The page's stage, at his own spot.** order.html's stage at 1920x1080 is 1078 x 646 px; the picture is 126% of its height, so
   the stage shows +-2.09 m about the picture's middle. The ropes are at about +-2.7 m. Blue stands 0.84 m right of the middle
   in the render (shown on the LEFT, the page mirrors). His uncut fall went **0.48 m past the stage's edge from his normal
   spot**. That is the owner's "off the ring's left edge".
2. **The ropes, from where the page can put him.** The page slides every picture to where the men stand (ring_ui.js), and a man
   can be two steps behind his Long spot ("on the ropes", ring_ui.js fit: redIn/blueIn >= -2, 0.71 m). From there the uncut
   fall crossed the ropes by 0.3-0.4 m.

## Step 1 - what was done (tools/pics2d_ko_room.gd, new, 174 lines; tools/pics2d_anim_more.gd)
The take is not changed and nothing is layered on it. Each knockdown run is **measured first** (the take played as it is),
then fitted, then drawn:
- **The rule is the game's own** (scripts/fight3d/KnockdownRing.gd, S390: a downed man's bones stay inside the ring), with the
  picture's margin: bones 0.20 m inside the ropes, were he 0.71 m further back; bones 0.20 m inside the stage's edge, from his
  own spot. (The game's 0.35 m keeps a man off the ropes for the count; a picture only needs him inside them.)
- **He turns as he goes down.** His body is turned about his own spot, away from the camera, by the smallest angle (5 deg steps,
  up to 85) that leaves at most 15% of his travel to cut. His feet stay where he stood and he lies across the ring's depth,
  head toward the far ropes. Result: blue (falling on the page's left) turns 75 deg, red 85 deg.
- **What is still past the lines is cut from his travel**: one share of his hips' travel on every frame (blue 11%, red 28%), so he
  falls the way the take falls, only less far. Turn and cut both grow with his hips' travel from the contact (0 there), so there
  is no jump from the landed run.
- **The plain knockdowns** (red_knockdown, blue_knockdown) get the same fit (turned 65 / 80 deg, cut 13 / 15%).
- **blue_body_hook_ko was made from the wrong take.** The landed body hook plays pro_kidney_shot; the knockdown search picked
  pro_body_shot (first in the family). That was a 19.1 px jump, there before this task. It is re-made with `take=pro_kidney_shot`:
  0.4 px now.
- `ko_take=<clip> ko_from=<s>` lets a run try another knockdown take (anim_more `ko_clip`).

### Why this way (the choices I tried and dropped, all rendered and looked at)
| try | what it did | why it was dropped |
|---|---|---|
| hold the fall at the rope line | the body stopped at the line while the take went on | his feet slid back toward the puncher once he lay still |
| cut the travel by one share (game margin 0.35) | 66-74% cut | his boots landed on the puncher's front boot |
| a shorter take (pro_knockout_v5, hips 0.54 m) | needs a 93-95% cut | lying flat is 1.8 m whatever the take; v1 kept (he has seen it) |
| cut only, picture margin 0.20 | 51-58% cut; passed the ropes test | on the page the stage itself cut him off (screenshot, beats3) |
| turn + cut up to 35% | 55-85 deg, ~30% cut | his boots ended against the puncher's front boot |
| feet kept 0.25 m from the puncher's feet by carrying him to the far side | hit its cap (100%) | his raised boots ended against the puncher's thigh. Off (FEET_CLEAR_M 0, kept for a take whose legs do not lift) |

### Left as it is (said, not hidden)
- **From the furthest-back spot ("on the ropes") the stage still cuts him.** There the page already draws the *standing* man at the
  stage's edge (screenshot ops/previews/s566_kdpic1/beats7/order_ko_long_jab_show_red_jab_ko_10.png: blue on the ropes, his legs
  and body on the stage, his head past its left edge). No fall fits there (measured: 1.0-1.3 m past it, whatever the turn or cut).
  Showing it needs the page to follow the downed man (e.g. ring_ui.js slides a knockdown picture so the fallen man is on the
  stage), which is a page change this brief does not allow. He stays **inside the ropes** there (pixel test).
- **The hooks are thrown from 0.54-0.58 m in**, so after a hook knockdown his boots end behind the puncher's front boot, and
  after a jab knockdown his boot touches it on the last picture. The bodies do not pass through each other.
- The layout numbers are for his 1920x1080 window (tools/pics2d_ko_room.gd WIN_HALF_PX). On another window shape the stage's width
  changes.

## Step 1 - proof
**Pixel test** (`python tools/ko_room_check.py <render_dir> [--back=<m>]`; the fallen man's pixels on a part mask drawn in the
same frame, tools/pics2d_mask.gd, against the ropes hull projected from the ring's corners and against the stage window):
all 19 `<col>_<fam>_ko` runs PASS: 0 px outside at his spot (ropes + stage), 0 px outside the ropes 0.71 m back.
**The instrument can read worse:** at `--back=1.0`: 1254-1431 px out; at 1.2: 6881-9923; at 2.0: 21134-24507. The stage half
caught a 50 px toe overrun in a trial render (smoke4: the foot bones are at the ankles, so the toe bones were added).
**Edge table** (`python tools/ko_edge_check.py`: where each man stands, the middle of his shorts, on the landed run's contact
picture against the knockdown's first picture, which is twice as wide about the same middle). 0 jumps:

| landed run (contact) | knockdown | red dx | blue dx | jump |
|---|---|---|---|---|
| red_body_cross_landed | red_body_cross_ko | -0.1 | 1.7 | ok |
| red_body_cross_landed_r2 | red_body_cross_ko | -0.1 | 1.7 | ok |
| red_body_cross_landed_r1 | red_body_cross_ko | -0.1 | 1.7 | ok |
| red_body_hook_landed | red_body_hook_ko | -0.1 | 0.4 | ok |
| red_body_hook_landed_r2 | red_body_hook_ko | -0.1 | 0.4 | ok |
| red_body_hook_landed_r1 | red_body_hook_ko | -0.1 | 0.4 | ok |
| red_body_jab_landed | red_body_jab_ko | 0.1 | 0.4 | ok |
| red_body_jab_landed_r2 | red_body_jab_ko | 0.1 | 1.7 | ok |
| red_cross_landed | red_cross_ko | -0.1 | -0.1 | ok |
| red_cross_landed_r2 | red_cross_ko | -0.1 | -0.1 | ok |
| red_cross_landed_r1 | red_cross_ko | -0.1 | 0.7 | ok |
| red_jab_landed | red_jab_ko | 0.1 | 0.5 | ok |
| red_jab_landed_r2 | red_jab_ko | 0.1 | 0.5 | ok |
| red_lead_hook_landed | red_lead_hook_ko | 0.2 | -0.1 | ok |
| red_lead_hook_landed_r2 | red_lead_hook_ko | 0.2 | -0.1 | ok |
| red_lead_hook_landed_r1 | red_lead_hook_ko | 0.2 | -0.1 | ok |
| red_lead_uppercut_landed | red_lead_uppercut_ko | 0.1 | -0.1 | ok |
| red_lead_uppercut_landed_r1 | red_lead_uppercut_ko | 0.1 | -0.1 | ok |
| red_rear_hook_landed | red_rear_hook_ko | -0.1 | 0.0 | ok |
| red_rear_hook_landed_r2 | red_rear_hook_ko | -0.1 | 0.0 | ok |
| red_rear_hook_landed_r1 | red_rear_hook_ko | -0.1 | 0.0 | ok |
| red_rear_uppercut_landed | red_rear_uppercut_ko | -0.3 | 0.5 | ok |
| red_rear_uppercut_landed_r1 | red_rear_uppercut_ko | -0.3 | 0.5 | ok |
| blue_body_cross_landed | blue_body_cross_ko | 0.5 | 0.3 | ok |
| blue_body_cross_landed_r2 | blue_body_cross_ko | 0.5 | 0.3 | ok |
| blue_body_cross_landed_r1 | blue_body_cross_ko | 0.5 | 0.3 | ok |
| blue_body_hook_landed | blue_body_hook_ko | 0.7 | 0.0 | ok |
| blue_body_hook_landed_r2 | blue_body_hook_ko | 0.7 | 0.0 | ok |
| blue_body_hook_landed_r1 | blue_body_hook_ko | 0.7 | 0.0 | ok |
| blue_body_jab_landed | blue_body_jab_ko | 1.4 | -0.1 | ok |
| blue_body_jab_landed_r2 | blue_body_jab_ko | 0.6 | -0.1 | ok |
| blue_cross_landed | blue_cross_ko | 0.5 | 0.0 | ok |
| blue_cross_landed_r2 | blue_cross_ko | 0.5 | 0.0 | ok |
| blue_cross_landed_r1 | blue_cross_ko | 0.9 | 0.0 | ok |
| blue_jab_landed | blue_jab_ko | 2.3 | -0.1 | ok |
| blue_jab_landed_r2 | blue_jab_ko | 0.7 | -0.0 | ok |
| blue_lead_hook_landed | blue_lead_hook_ko | 0.8 | -0.1 | ok |
| blue_lead_hook_landed_r2 | blue_lead_hook_ko | 0.8 | -0.1 | ok |
| blue_lead_hook_landed_r1 | blue_lead_hook_ko | 0.8 | -0.1 | ok |
| blue_lead_uppercut_landed | blue_lead_uppercut_ko | 0.2 | 0.1 | ok |
| blue_lead_uppercut_landed_r1 | blue_lead_uppercut_ko | 0.2 | 0.1 | ok |
| blue_rear_hook_landed | blue_rear_hook_ko | 0.9 | 0.0 | ok |
| blue_rear_hook_landed_r2 | blue_rear_hook_ko | 0.9 | 0.1 | ok |
| blue_rear_hook_landed_r1 | blue_rear_hook_ko | 0.9 | 0.0 | ok |
| blue_rear_uppercut_landed | blue_rear_uppercut_ko | 0.7 | -0.1 | ok |
| blue_rear_uppercut_landed_r1 | blue_rear_uppercut_ko | 0.6 | -0.1 | ok |
KO_EDGE jumps=0

**The page** (headless Edge, order.html, `beat_shot.mjs` plus two scratch copies: one screenshots the knockdown's pictures
while they play, one puts the last knockdown picture back on the stage after the beat with the page's own slide). Screens in
ops/previews/s566_kdpic1/ (git-ignored, on the PC):
- beats8/order_ko_mid_over_red_rear_hook_ko_10.png: his overhand at Mid knocks blue down; blue lies on the stage, turned.
- beats8/order_ko_mid_cross_his_blue_cross_ko_10.png: my cross at Mid; red lies on the stage.
- beats7/order_ko_long_jab_show_red_jab_ko_10.png: blue on the ropes (the limit above).
- Regression: `page_play_test.mjs` PAGE_PLAY_TEST 4 passed; `page_parse.mjs order.html punch.html` ok; anim_web kept 21 runs.

## Steps 2-4 - the overhand (BLOCKED)
**Our files first** (all of E:\FightCamp, the old repo on GitHub, the bought Box1 M3 pack, the AI-live trial set, clip_db's 186
takes):
- clip_db: no overhand. Every rear-hand take is a cross, hook or uppercut. pro_right_cross_special (contact 0.9 s, turn 114 deg)
  is "off on score" and a wind-up cross, not an arc.
- The Box1 M3 pack (all FBX on disk): no overhand. The AI-live trial: none.
- The old project: `mh_overhand.glb` survives only as a .import stub (wt_salvage/ANIMSOURCE1). The GitHub archive has
  `af_overhandthrow.fbx` (ActionForge: a ball throw), `H2H_Haymaker*` (rejected on sight in S120: "a windmill that ends at the
  waist"), and the C223 "boxing_overhand" was a layer on a straight (RamsterZ + side bend), not a take.

**Ludo (one time-boxed hour, 3 runs, 6 credits, 611 -> 605):** none of its 656 presets is an overhand (hooks, a cross, throws).
`ludo model animation` (text-to-motion), 4 variants each:
1. job 2e6b5322: the full brief's wording (guard, the rear hand loops over the lead, the shoulder rolls, the head off the line,
   weight onto the lead foot).
2. job 64f105f0: "compact, no wind-up, the left fist stays at the chin".
3. job 7ed3b888: "a right straight that travels in a downward arc from above eye level".
All 12 drop the rear hand to the hip or pump the lead arm up first, and most finish at the waist: a haymaker or a hammer, the
same flaw the old repo rejected. The motion model starts every move from its own pose (no "start from this guard"). Contact
sheets: E:\FightCamp\wt_tmp\KDPIC1\gen1..gen3 (det_*.png, sheet*.png). One feedback note sent to Ludo (limitation, these
three jobs). I stopped after three prompts with the same failure, not at the hour: a fourth wording would not change what the
model starts from. No take was retargeted, no clip_db row was added, `overhand` is not a family, and the head-move borrowing
note in pics2d_head.gd stays.

**What would unblock it:** a real overhand clip (a mocap pack with one, e.g. a paid boxing pack; or Cascadeur keyed from our
pro_right_cross_ft with the arc and the shoulder roll). Then this brief's steps 2-4 as written. The tools are ready:
`ko_take=`, the family table in pics2d_set.gd FAMILIES, the knockdown fit (it works for any landed run).

## How to run it again
```
sh ops/previews/s566_kdpic1/render.sh <dir> "only=*_ko,red_knockdown,blue_knockdown"     # (ignored folder; the command inside:)
python tools/hidden_desktop.py run --timeout=3600 --log=<dir>/run.log <godot.exe> --path . --windowed --resolution 1920x1080 \
    --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim_more.gd -- <dir> art=toon set=m south=blue "only=*_ko,red_knockdown,blue_knockdown"
#   then blue_body_hook_ko again with take=pro_kidney_shot
python tools/ko_room_check.py <dir>
python proto/twohands/tools/anim_web.py <dir> --strips <strips> --alias blue_overhand_ko=blue_rear_hook_ko --alias red_overhand_ko=red_rear_hook_ko
python tools/ko_edge_check.py
```
Files: tools/pics2d_ko_room.gd (new), tools/pics2d_anim_more.gd (499 lines), tools/ko_room_check.py (new),
tools/ko_edge_check.py (new), proto/twohands/img/anim/*_ko_*.webp + *_knockdown_*.webp (the 20 runs; 214 pictures),
proto/twohands/img/anim/frames.json (blue_body_hook_ko's row: its clip).

KDPIC1 BLOCKED: step 1 done (knockdowns inside the ropes and the stage, 0 jumps); the overhand has no usable take - none in our files, 12 Ludo candidates all haymakers - so steps 2-4 were not built and the page still borrows the rear hook

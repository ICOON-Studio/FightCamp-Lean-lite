# The body jab: its own take and pictures (BODYJAB1, S556, 2026-11-25)

Why: on Ring Switches the Long range had one punch, the jab, so nothing to guess there. A body jab that also reaches
Long makes the lead hand choose high or low (S554 probe; Kalli and John both put it first; measured again in S555 on
the balanced rules). It had no picture: the head jab aimed at the body ended 0.24 to 0.46 m off the body
(docs/HOLDTAKES1_RESULT.md). It needed an authored take, as the body cross did.

## NOT GREEN (read this first)
- **The owner has not seen it.** The pictures passed the picture gate and my own look, nothing more.
- **A blocked or a missed body jab meets him at chest height**, on his elbows or just short of them: it does not read
  as a punch to the stomach. The body cross's blocked and missed pictures on the page do the same today (the picture
  tool sends a blocked body punch onto the cover-up, and no cover-up take lowers its elbows). Only the landed picture
  and the knockdown show the stomach.
- **On the taller man the landed glove is on the waistband of his trunks**, where the body cross lands on the page too.
- **No ruler was run on it.** The body cross's rulers (`tools/bodycross2_ruler.gd`, `bodycross3_ruler.gd`) read the
  right arm. The numbers below are the bake tool's own printout on the census body.
- **The lead knee is bent to 89 degrees at the bottom** on the census body (the body cross: 107). Deeper than the
  body cross because the jab starts higher (17 cm of sink against 13).
- **Its row in the clip table was put in by hand** (below). A full rerun of `tools/clip_census.gd` today changes eight
  other rows as well (the body cross's contact goes back to 0.35 s, the plain cross moves, the gut-shot reactions lose
  the fold numbers that `tools/bodyreact2_bake.gd` adds): the table is no longer what one tool writes.
- The 3D fight never throws it: it is not in the moves a bout settles, and its family is its own.

## The take (`pro_body_jab`, `assets/anim/baked/mc_Box1_M3_Body_Jab.res`)
Authored offline by `tools/pics2d_bodycross_bake.gd -- take=jab key=0.386 drop=0.17 lean=8 rate=2.0 bendmax=150`, from
the jab the game shows (`mc_Box1_M3_Left_Jab.res`), in its own keys, no runtime layer. Same recipe as the body cross:
the hips sink, the trunk hinges a little, the arm's line is pitched down from the shoulder so the glove front is at
the other man's ribs on the contact key, the contact is early on the arm's travel so the glove is still fast, the lead
foot steps in and is planted before the touch. No rear heel lift (the rear hand stays home).

| What | Ours (census body) | The study |
|---|---|---|
| Glove speed on the contact key | 7.8 m/s, the take's top | G75: jab peak 7.9 +/- 0.9 (Ueberschar 2021), 8.1 +/- 1.4 men (Kimm and Thiel 2015) |
| Elbow on the touch / the most after it | 136 deg / 147 deg | K52: 137 +/- 12 at impact (amateurs); a jab is not held bent |
| The glove goes on after the touch | 8.7 cm | G75: Atha's follow-through 11 cm |
| First move to contact | 0.30 s (the drive itself 0.075 s) | G75: 0.10 s (elite floor) to 0.405 +/- 0.15 s (amateur mean) |
| The lead foot's step | 6 cm, planted 0.067 s before the touch | K46: coaching step-in 5 to 8 cm, planted at impact |
| The hips sink | 0.17 m, falling at 6.7 m/s2 at the most (under 1 g) | NO STUDY for a level change in cm (K46) |
| Glove height on the touch | 0.949 m: 6 cm over the census rib point | as the body cross (BODYCROSS2) |
| The rear glove to his own head | 0.34 to 0.44 m all through (it stays home) | |

## The tool
`tools/pics2d_bodycross_bake.gd` (500 lines) now takes the punching arm as a setting. `take=jab` switches the arm, the
source take, the output file and four numbers (`JAB` in the file). Proof the body cross is untouched: a dry run before
and after the change prints the same 56 keys and the same summary lines (compared line by line).

## The clip table row
`assets/data/clip_db.json`, `pro_body_jab` only: measured by `tools/clip_census.gd`, then six fields set to the authored
contact key, as BODYCROSS2 decided for the body cross (the census marks the deepest key, 0.354 s, where the glove has
nearly stopped): contact_s 0.3, contact_gap_m 1.026, glove_y_m 0.949, hips_at_contact_m 0.157, own_head_y_m 1.252,
up_m 0.06. `scripts/fight3d/v2/ClipCensus.gd`: family `body_jab` (in `STEMS` and `BODY_FAMILIES`). Not in `V2_PLAYS`.

## The pictures
`tools/pics2d_set.gd`: family `body_jab` (take `pro_body_jab`, a body target, the gut-shot reaction). Eight frame runs,
both corners: landed, blocked, missed (`tools/pics2d_anim.gd`), knockdown (`tools/pics2d_anim_more.gd`), men's pair,
`south=blue`, 86 frames, none refused, none failed the gate. In `proto/twohands/img/anim/` with their stills in
`proto/twohands/img/`. `node proto/twohands/tools/anim_check.mjs`: 124 runs, PASS. Strips: `ops/previews/s556_bodyjab/`.

Tests run after the take was on disk: clip_db_test, ring_steps_test, body_cross_play_test, fight_pictures_test,
move_clips_test, beat_clips_test - all pass.

## How to run it again
```
Q="python ops/Tools/godot_slot.py run --who <you> --" ; G=<godot>
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/pics2d_bodycross_bake.gd -- take=jab key=0.386 drop=0.17 lean=8 rate=2.0 bendmax=150
sh E:/FightCamp/tmp/s556_bodyjab/render.sh ; sh E:/FightCamp/tmp/s556_bodyjab/render_ko.sh     (the two renders, about 1 minute each)
python proto/twohands/tools/anim_web.py E:/FightCamp/tmp/s556_bodyjab/bj E:/FightCamp/tmp/s556_bodyjab/bj_ko --strips ops/previews/s556_bodyjab
python proto/twohands/tools/anim_stills.py ; node proto/twohands/tools/anim_check.mjs
```

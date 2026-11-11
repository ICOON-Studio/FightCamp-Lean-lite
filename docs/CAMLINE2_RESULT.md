# CAMLINE2 result: the fight camera, ruler first

Part A only (the ruler, S431). No game behaviour changed: `scripts/fight3d/RingCamera.gd` is as on main.
Files: `scripts/fight3d/CamLine.gd` (the pure reads), `tools/cam_line_probe.gd` (the game path), `tests/cam_line_test.gd`.

## BEFORE (main at f591850d, measured 2026-11-11)

### How it was measured
- Windowed on the never-shown desktop, through the queue, `--fixed-fps 60`, picture 1920 x 1080, motion blur on.
- Two bouts, two rounds each, at 2x pace (as `tools/fight3d_play.gd` plays), with the walk-in's first 2.5 s and the
  corner minute up to its card. Both reach fight night through `TestJump.run` (the same acts as fight3d_play, with the
  career's seed pinned so the AFTER run plays the same bouts):
  - `bout=fight`: Lucy Jackson (orthodox) v Maria Ortega (southpaw), on fight3d_play's plan (jab and move, step back, tie up, pivot out).
  - `bout=men_fight`: Danny Osei (orthodox) v Liam Doherty (orthodox). Different bodies, the same stance.
- Read on EVERY frame (not every 0.1 s): HIDDEN and BEHIND. Read every 0.1 s: the ropes.
- Logs and stills: `E:/FightCamp/tmp/s431_camline2/` (`before_fight.log`, `before_men.log`, `glove_*.log`, and the folders beside them).

### The ruler was proved before it was trusted
Hand-set poses in `tests/cam_line_test.gd` (a 1.66 m orthodox boxer and a 1.80 m southpaw, 1.1 m apart, lens 3.1 m out):

| Pair along | Lens straight behind the short boxer | Behind the tall boxer | Side-on |
|---|---|---|---|
| world X (0 deg) | 0.69 HIDDEN | 1.00 HIDDEN | 0.00 |
| world Z (90 deg) | 0.69 HIDDEN | 1.00 HIDDEN | 0.00 |
| 45 deg | 0.69 HIDDEN | 1.00 HIDDEN | 0.00 |
| 200 deg | 0.69 HIDDEN | 1.00 HIDDEN | 0.00 |

The same body gives the same box from every side of the ring (CAMLINE1's box read 0.00 along world X).
As the lens comes round from behind (gap 0.7 m): behind 0 deg reads 0.75, 11 deg 0.64, 22 deg 0.44, 34 deg 0.31, 45 deg 0.19, 55 deg 0.03.
On the real fight the numbers were checked against the stills the probe saved: `before_men/men_fight_r2_f06772_hidden_hid0.99_face0.95_behind13.png`
shows the lens straight behind the blue boxer with the red boxer fully covered (the operator's own complaint);
`before_fight/fight_r1_f03091_hidden_hid0.99_face0.94_behind63.png` shows one boxer bent behind the other's back;
`before_fight/fight_r1_f03928_behind_hid0.00_face0.00_behind42.png` shows both clearly, and reads 0.00.

### The bars (frozen here; Part B changes none)
In `CamLine.gd`: HIDDEN = 60 % of the head-and-chest box covered by the other body; share of live frames HIDDEN under 2 %;
no HIDDEN run of 0.4 s or more; BEHIND = `TvShot.behind_deg` under 30 deg, no run of 0.4 s or more; a rope piece under
alpha 0.95 is faded; only a rope truly between the lens and a boxer may fade; one rope never shows two alphas; a glove at
full speed smears to at most 1.3 times its own width and does not bleed onto a face or a rope.

### The camera line on main

| Bar | Lucy v Maria | Danny v Liam | Reads |
|---|---|---|---|
| Live frames read | 11,380 | 11,338 | |
| hidden_share (under 2 %) | 0.53 % | 0.57 % | green |
| longest_hidden_s (under 0.40) | 0.40 (24 frames, round 2 t=168.7) | 0.63 (round 2 t=18.6) | RED |
| behind_share (frames under 30 deg) | 0.15 % | 1.36 % | (no bar) |
| longest_behind_s (under 0.40) | 0.20 | 0.80 (round 1 t=110.9) | RED in the men's bout |
| faded_not_between (0) | 1,896 of 1,896 reads | 1,889 of 1,889 reads | RED |
| split_ropes (0) | 1,896 reads (1,089 in the picture) | 1,889 reads (819 in the picture) | RED |

Totals lines, as printed:
```
CAMLINE2 frames=11380 hidden_share=0.53% longest_hidden_s=0.40 behind_share=0.15% split_ropes=1896 shots=["film:intro", "main", "apron", "main:bell", "main:round", "film:corner"]
CAM_LINE_PROBE failures=3
CAMLINE2 frames=11338 hidden_share=0.57% longest_hidden_s=0.63 behind_share=1.36% split_ropes=1889 shots=["film:intro", "main", "apron", "apron:bell", "main:bell", "main:round", "film:corner"]
CAM_LINE_PROBE failures=4
```
Both bouts together (worked out from the two lines): 22,718 live frames, hidden_share 0.55 %, longest_hidden_s 0.63,
behind_share 0.75 %, split_ropes 3,785 of 3,785 reads.

What the numbers say in plain words: the fault the operator saw is real and it is short. The lens does get straight
behind a boxer on main (down to 0 deg on the main shot in the men's bout, 13 deg in the still above) and a boxer does
get fully covered (0.99), for up to 0.63 s at a time; over a whole round it is about half a percent of the frames. The
share bar (2 %) reads green; the two run bars read red.

Where else the lens spends its time (no bar on these; printed so Part B can see them):

| Read | Lucy v Maria: share, longest run | Danny v Liam: share, longest run |
|---|---|---|
| hidden at least 0.2 | 2.16 %, 0.65 s | 3.44 %, 1.20 s |
| hidden at least 0.4 | 1.11 %, 0.53 s | 1.36 %, 0.77 s |
| head alone covered at least 0.6 | 0.51 %, 0.27 s | 0.65 %, 0.33 s |
| behind under 45 deg | 1.61 %, 0.87 s | 3.35 %, 1.20 s |
| behind under 58 deg (the game's own "behind" cut line) | 7.08 %, 1.52 s | 9.82 %, 1.80 s |
| behind under 64 deg (the game's own placing line) | 13.49 %, 1.58 s | 16.14 %, 2.08 s |
| behind under 75 deg | 27.67 %, 4.47 s | 32.30 %, 4.27 s |

Two facts for Part B:
- A boxer can be fully HIDDEN with the lens well off the pair's line: 0.99 at behind 63 deg and 0.83 at behind 95 deg
  (Lucy v Maria, round 1, t=92 and t=98: one boxer ducks or leans across behind the other). An angle rule alone cannot see it.
- With a caption on screen: HIDDEN in 0.83 % of those frames, up to 0.99 (Lucy v Maria); none in the men's bout.
  With the corner's call open: never HIDDEN (highest 0.19). In the first 0.4 s after a cut: HIDDEN in 0.15 % (highest
  0.60) for Lucy v Maria, never in the men's bout (highest 0.36).

### Shot kinds
Seen: `main` (359 s over both bouts), `apron` (19 s), the walk-in's film shots (`film:intro`, 5 s), the corner
minute's film shots (`film:corner`, 11 s), the shot held through the bell (5 s).
NOT seen, so the ruler is VOID for them:
- `clinch`: no tie-up happened in these four rounds.
- `close`: nothing in the game calls `FightStage.close_up` today (grep: only its own definition), and `FightView._close_left` is never set above 0. The close-up cannot appear on main.
- `film` in a live round (the knockdown count's lens) and `replay` (the knockdown replay's own camera): no knockdown happened.
The corner minute's film shots read behind under 30 deg in 6 % of their frames (Lucy v Maria) and HIDDEN in 2.11 %
(men): the two boxers sit in opposite corners there, so those shots are listed, not counted in the bars.

### The ropes on main
Read from `FightStage._ring_side`, the array the game hands `RingCamera.clear_view`.
- Every read of both bouts (3,785 of 3,785) had a faded rope that is not between the lens and a boxer, and a rope with
  two different alphas. In the picture itself: a faded rope in 1,332 and 840 reads, a rope cut in two in 1,089 and 819 reads.
- Per rope (Lucy v Maria, 1,896 reads): the north ropes faded in 1,878, the east in 1,893, the south in 1,169, the west
  in 682; they were almost never between the lens and a boxer (at most 3 of those reads for any one rope: the lens
  stands inside the ropes).
- A far rope at the height of a head: in 1,510 and 1,625 reads; faded there in 243 and 58 reads (the operator's
  "fading effect on the background ropes ... at the same drawing height": still `before_fight/fight_r1_f03360_ropefade_*.png`).
- The lens's far blur at those far ropes, read from the camera's attributes (start distance, 2.0 m ramp, amount 0.22):
  highest 0.220 (the full blur), mean 0.147 and 0.161. No bar is set for this one: "still reads as a rope" needs a
  picture judged in Part B.

### The gloves on main (the operator's own complaint)
Round 1 of Lucy v Maria. At each punch the frame nearest the glove's peak speed is taken twice: as played, and the SAME
pose with the tree paused (nothing moves, so no motion blur can act). The smear is the width of the glove's colour
along its travel in the played frame; `noblur_px` is the glove's own width in the paused frame.

| Run | Punches | Smear over the glove's width: median, highest | Over 1.3x | Bleeds | Ghosts |
|---|---|---|---|---|---|
| As the game plays it, 1x pace, 60 fps | 10 | 1.13, 1.31 | 1 | 0 | 1 |
| `noblur` (the control) | 11 | 1.00, 1.00 | 0 | 0 | 0 |
| As the game plays it, 2x pace, 60 fps | 10 | 2.82, 3.58 | 7 | 1 (17 px onto a rope) | 5 |

The ten lines at 1x (as printed, shortened to the brief's fields plus the glove):
```
GLOVEBLUR punch=pro_left_hook_v2 speed_m_s=6.0 smear_px=103 noblur_px=81 bleeds=0   blue r  ratio 1.27
GLOVEBLUR punch=pro_right_cross_a speed_m_s=5.0 smear_px=54 noblur_px=48 bleeds=0   blue l  ratio 1.13
GLOVEBLUR punch=pro_body_shot speed_m_s=10.3 smear_px=81 noblur_px=73 bleeds=0      blue l  ratio 1.11 (1 ghost)
GLOVEBLUR punch=pro_left_hook speed_m_s=5.0 smear_px=68 noblur_px=53 bleeds=0       blue r  ratio 1.28
GLOVEBLUR punch=pro_left_hook_v2 speed_m_s=6.5 smear_px=76 noblur_px=58 bleeds=0    red r   ratio 1.31
GLOVEBLUR punch=pro_left_hook_v2 speed_m_s=10.8 smear_px=79 noblur_px=63 bleeds=0   red l   ratio 1.25
GLOVEBLUR punch=pro_left_uppercut speed_m_s=9.3 smear_px=50 noblur_px=50 bleeds=0   red l   ratio 1.00
GLOVEBLUR punch=pro_left_hook speed_m_s=5.1 smear_px=30 noblur_px=30 bleeds=0       blue r  ratio 1.00
GLOVEBLUR punch=pro_left_hook_v2 speed_m_s=5.8 smear_px=25 noblur_px=25 bleeds=0    red l   ratio 1.00
GLOVEBLUR punch=pro_left_hook_ft speed_m_s=7.5 smear_px=39 noblur_px=35 bleeds=0    blue l  ratio 1.11
```
At 2x the worst lines: `pro_right_hook` 136 px against 38 (3.58x), `pro_left_hook` 254 against 75 (3.39x),
`pro_left_uppercut` 81 against 27 (3.00x, the glove's own colour gone from its middle: core 0.00, 3 ghosts).
Pictures: `glove_game2/glove05_*` (1x, the glove smeared across the rope behind it), `glove_game_2x/glove09_*`
(2x: the whole boxer drawn as striped copies, the glove see-through over the white rope).

Read these with four cautions:
1. The blur is twice as long at 2x because the add-on smears by the distance moved in one frame. The same doubling
   happens at 1x when the game runs at 30 frames a second instead of 60. Which pace and frame rate the operator
   watched is not known.
2. The frames on the hidden desktop took 15 to 43 ms each. Over 33 ms the add-on shortens its own smear (by up to
   about a quarter here), so on a steady 60 Hz screen the smear is that much LONGER than these numbers.
3. The fastest glove frames were not measured. A glove sometimes jumps in a single frame (12 to 44 m/s of game speed;
   `pro_body_shot` moved a glove 0.7 m in one frame at 1x). Those frames fell between kept frames or the glove's edge
   could not be told from what was behind it: 12 punches skipped at 1x, 18 at 2x, each with its reason in the log.
4. A picture can only be kept on every second fast frame: a frame drawn right after a paused frame carries no blur
   on a skinned body (the first glove run paused before every frame and read 1.00 on nine punches of ten; it is void and
   not in the table).

### The headless test on main
`tests/cam_line_test.gd -> CAM_LINE failures=4` (56 checks pass). The four red checks are the game path, red on main:
- three: from a lens inside the ropes, the rope a boxer leans on fades (40 of 40 pieces, each of the three heights);
- one: three ropes of the ring show two alphas (a rope cut in two).
Green on main, and they must stay green: the hand-set HIDDEN poses, the rope and blur reads, the smear on made-up
pictures, a rope truly in the way of an outside lens fades whole, and five lens drills (`RingCamera.broadcast` while a
made-up pair circles or pivots on the spot: lowest behind 50 to 54 deg, nobody HIDDEN). Those drills cannot show the
fault: it needs the real bout (the pair travelling, a boxer ducking behind the other). The red reading for HIDDEN and
BEHIND is the probe's.
`tests/file_limits_test.gd -> FILE_LIMITS failures=0` (CamLine.gd 360 lines; the probe is 500).

### Not measured in Part A
- The far ropes' blur has a reading but no bar (see the ropes).
- The clinch lens, the knockdown count's lens and the replay camera (not seen); the close-up (not in the game).
- The gloves at 30 frames a second, and the single-frame glove jumps.
- A 1x-pace run of the camera line (both bouts were read at 2x, as fight3d_play plays).
- The three pass / fail lines at the end of the glove mode (`CAMBAR glove_smear_highest`, `glove_bleeds`,
  `punches_not_measured`) were added after the glove runs; they apply the bars to the same numbers and have been
  parse-checked, not run windowed.

## AFTER (S432: round 1 of Part B, commit 6924343c, collected by diff onto main; Claude measured)
Same probe, same bout, same seed: `bout=men_fight rounds=2`, windowed on the never-shown desktop, 60 fps, 2x, blur on
(log `E:/FightCamp/tmp/s432_camline/after_men.log`, stills beside it). The game now plays the stepping route (S432).

| Bar | BEFORE (Danny v Liam) | AFTER | Reads |
|---|---|---|---|
| hidden_share (under 2 %) | 0.57 % | 0.30 % | green |
| longest_hidden_s (under 0.40) | 0.63 | 0.23 | green (was red) |
| longest_behind_s (under 0.40) | 0.80 | 0.00 | green (was red) |
| faded_not_between (0) | 1,889 of 1,889 reads | 1 of 1,889 | one read left: red by the bar |
| split_ropes (0) | 1,889 | 0 | green (was red) |
The worst flagged frame (`after_men/men_fight_r2_f08399_behind_hid0.51_face0.88_behind44.png`, opened): the pair at close
range, both boxers in view, ropes whole and sharp. Shot kinds seen: film:intro, main, apron, clinch, main:bell, main:round,
film:corner. Not re-measured: the gloves' smear after the blur change (object pull 0.7 -> 0.5, one intensity divided by
the pace), the Lucy v Maria bout. Round 2 (uncommitted at S431's end) is saved on the branch as a WIP commit, NOT collected.
Tests on main after the collect: CAM_LINE failures=0, ring_lens, CORNER_LENS, BAR_GUARD, PROMO_SHOT, ring_ropes_entry,
FILE_LIMITS, fight_flow, FIGHT_POLISH all green.

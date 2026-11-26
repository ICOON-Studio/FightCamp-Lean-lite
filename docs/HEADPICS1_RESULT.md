# HEADPICS1 - the head moves in pictures: slip, roll, lean back, slip in (S561)

Owner S561: "finish with the headmoves pics". Task: `ops/research/TASK_HEADPICS1.md`. Done by the session itself (his game
was open: one job on the PC at a time).

## What head.html shows now
A punch that a head move makes miss plays its own run instead of the plain miss, and a slip in is its own step:

| The story says | Run played | What is on the picture |
|---|---|---|
| "slipped: you / he made it miss" (jab, cross) | `<col>_jab_slipped`, `<col>_cross_slipped` | The trunk leans off the line with the guard kept; the glove goes through the place the head was. |
| "rolled under" (lead hook, overhand) | `<col>_lead_hook_rolled`, `<col>_overhand_rolled` | He goes down under the punch (0.24 m), the arm sweeps over him. |
| "leaned back out of reach" (jab, cross, lead hook, overhand) | `<col>_..._leaned` | He sways back; the glove stops in the air in front of his gloves. |
| "you slip in" / "he slips in" | `<col>_slip_in`, `_r2`, `_r1` | The step in with the head off the line on the way, upright again on the last picture. |

22 runs, both corners, on his camera (the fixed ring camera, `south=blue`). `<col>` is the puncher's corner (the stepper's
for a slip in). A run that is not on disk falls back to the plain miss / the plain step, as before.
Played on the real page in headless Edge (`beat_shot.mjs`, which now lists the pictures a beat showed): each of the four
moves and "he slips your cross" played its own run. Stills: `ops/previews/s561_head/` (one strip per run,
`head_moves_sheet.png` for the board).

## How (and what the first tries got wrong)
- Tries 1 and 2 (the stopped worker's script): the plain-miss staging, which gives the other man ground until the glove is
  clear of his face. The punch fell 0.11 to 0.33 m short of where the head had been: it read as "he stood too far away",
  and the roll run did not move at all.
- THE STAGING NOW: the puncher stands where his glove goes THROUGH the place the head is in the guard (a lean back: 0.14 m
  short of it, so it ends in the air in front of his gloves); nobody gives ground; the head is simply not there.
- THE SLIP IS A LEAN, NOT A TAKE. The owned dodges step 0.3 to 0.6 m across the line (S531's finding: no side dodge on a
  side camera; try 1 had his boot at his own knee). The slip is the guard with the trunk leant 22 degrees toward the
  camera and 5 in, from the Spine bone up, eased in before the contact and out after it; the slip in is the same lean
  (18 / 8 degrees) over the step take. A skeleton modifier in `tools/pics2d_head.gd`: no take is changed, nothing saved.
- THE ROLL takes `pro_right_weave` on both men. `pro_left_weave` leaves him standing (its head goes UP in the clip table:
  head_dir y +0.88): three of four roll runs failed with it.
- The lean back is `pro_back_dodge`, as the plain miss already used.

## The gate (contact picture; gap = glove to head on the picture, bar 0.12 m; a roll: head down 0.20 m or more)

| Run | red punches | blue punches |
|---|---|---|
| jab_slipped | gap 0.152 | gap 0.186 |
| cross_slipped | gap 0.130 | gap 0.123 |
| lead_hook_rolled | gap 0.316, down 0.24 | gap 0.389, down 0.24 |
| overhand_rolled | gap 0.308, down 0.24 | gap 0.388, down 0.24 |
| jab_leaned | gap 0.389 | gap 0.365 |
| cross_leaned | gap 0.413 | gap 0.358 |
| lead_hook_leaned | gap 0.386 | gap 0.373 |
| overhand_leaned | gap 0.400 | gap 0.392 |

All 16: rear glove 0.14 to 0.31 m ahead of the ear line (bar 0.05), shoulders 6 to 36 degrees off square (bar 75: nobody
turns his back), lowest foot bone 0.01 to 0.02 m over the canvas. No picture refused by the framing check.
Checks: anim_check 160 of 160 (red first: 22 missing), head_test 11, rules_test 37, kick_test 12, page_play_test 4,
page_parse ok (head, order, kick, punch).

## What is not as good as it should be (said plainly)
- On a side camera a slip to the side reads as a small dip toward the viewer. It is readable (the glove passes behind the
  head) but it is not a textbook slip seen from the front.
- In the roll runs he is already down 0.13 s before the contact (the duck take is entered part-way, the game's own
  timing): it reads as "ducked under", less as a rolling U.
- The cross that is slipped passes close: gap 0.12 to 0.13 m, just over the bar.
- The overhand still borrows the short rear-hook take, so "overhand rolled" is a close-range picture.
- Not built: the uppercut that catches a man rolling (`_on_roll`). Two tries were crowded and unreadable (the men chest to
  chest, a knee through a thigh); the page shows the plain landed uppercut there, as before.

HEADPICS1 DONE

# PICSFIX1 - the fight pictures: no body through a body, a blocked punch ends on the block (S543/S544)

Task: `ops/research/TASK_PICSFIX1.md`. The owner (S543, on two pictures of "Watch it in pictures"): "why fighters are
entagled like that on the left and on the right the punch does not touch the opponent", then "Yes, fix them now".

## What was built
- **The gate**, `tools/pics2d_gate.gd` (207 lines). `tools/pics2d_set.gd` runs it on the posed pair at the frame it
  saves. A picture that fails is not written (its old file removed), it is listed in `contacts.json` with the measure that
  failed, and the tool exits 1. `gate=report` measures and writes anyway (that is how the before numbers below were taken).
  Every punch picture's `contacts.json` entry now carries:
  - `apart_m`: the smallest distance between the two trunks, each the Hips-Spine-Chest-UpperChest-Neck bone line (not
    the roots). `apart_pic_m`: the same with both lines flattened onto the picture (a body beside a body in depth still
    reads as one body through the other).
  - `feet_m`: the gap between the two nearest foot bones along the punch line (crossed feet read as tangled).
  - `head_clear_m`: each head bone to the other boxer's trunk line and head.
  - landed: `hit_m` (glove front to the target point) and `near_m` (the glove on the puncher's side of the head, or of
    the chest for a body shot - never behind it).
  - blocked: `block_m` (glove front to the defender's glove padding or forearm) and `block_on` (which one).
  - missed: `clear_m` / `clear_hand_m` on the picture (as before), plus the spacing measures above.
  - the clinch: `chest_m` (Chest bone to Chest bone), `head_m` (head to head), `arm_m` (each arm's bone line to the
    other's trunk), `apart_m` on the trunk (Hips..UpperChest, without the necks: cheek to cheek is the hold itself).
- **The poses** (`tools/pics2d_set.gd`, 500 lines): the range is FOUND. Each try poses the result from a range and runs
  the gate; torsos, feet or heads too close step the puncher BACK (his arm then reaches on the game's own finish, PunchAim);
  a glove short of its target or its block steps him in by what is left, along the line only. The old rule that slid the
  puncher in until the glove reached, limited only by 0.40 m between the ROOTS, is gone. A blocked head punch still meets
  BlockCatch's catching glove; a blocked body punch now meets her cover-up (the game's own `mc_to_block` / `mc_block`
  shell takes, or her plain guard) and ends on her FOREARM. The clinch sweeps the roots 0.50-0.80 m in 1 cm steps and takes
  the first gap the gate passes (men 0.66 m, women 0.60 m; the old picture used 0.50 m).
- `scripts/ui/FightPictures.gd`: the 11 raw colours go through `Palette.gd` (PAGE, TEXT, MUTED, HEADER, CLIP_BAND, WARN,
  BAD_FILL, fade/alpha). Nearest job colours. The background, labels and hit flash look the same, but they are not
  pixel-identical (the backdrop is the palette's warm PAGE rather than the old blue-black).
- `tests/fight_pictures_gate_test.gd` (in `tools/run_tests.sh`). It was written first and was red on the S540 sets
  (240 failures: no `block_m`, `apart_m` or `near_m` existed). Now green.

## The bars, and where each number comes from
| bar | value | from |
|---|---|---|
| APART_MIN_M (punches) | 0.60 m | measured on the S540 pictures: every picture that reads clean is 0.63-1.35; the body hooks the owner saw as tangled are 0.54-0.60 |
| FEET_MIN_M | 0.16 m | measured: clean 0.16 and up (red lead hook landed, toe to toe, reads clean); crossed 0.01-0.14 (all body hooks, lead uppercuts) |
| HEAD_CLEAR_M | 0.60 m | measured: clean 0.64-1.30; the tangled body hooks 0.45-0.60 |
| LAND_M / NEAR_MIN_M | 0.04 / 0.03 m | the task's 0.04; near: a glove on the face point sits 0.08-0.10 in front of the head bone |
| BLOCK_M | 0.05 m | the task's number |
| CLINCH_APART_M | 0.22 m | ESTIMATE, not measured: two chest fronts ~0.11 m in front of the spine line |
| HEAD_APART_M | 0.15 m | one head breadth, ANSUR II means (men 0.155 m, women 0.147 m): cheek to cheek, never inside |
| CLINCH_CHEST_M / ARM_OFF_M | 0.50 / 0.07 m | estimates: chest to chest; an arm bone line closer than 7 cm to a trunk line is inside it |

## Before / after, per family (both sets, both corners: 4 pictures a row; ranges min-max)
Before = the S540 poses measured with this gate (`gate=report`). "n/m" = not measured: the women's before run was taken
before the feet and head measures existed; the men's before run has them (their numbers are in the "fails" column).
Contact = hit_m (landed), block_m (blocked), clear_m (missed). Fails = pictures over a bar (apart, feet, head, contact).

| family | apart before | apart after | feet before | feet after | head before | head after | contact before | contact after | fails before | fails after |
|---|---|---|---|---|---|---|---|---|---|---|
| jab landed | 0.93-1.01 | 0.93-1.01 | n/m | 0.45-0.54 | n/m | 0.86-0.96 | 0.00-0.01 | 0.00-0.01 | 0/4 | 0/4 |
| jab blocked | 0.93-1.01 | 1.03-1.11 | n/m | 0.60-0.71 | n/m | 0.97-1.05 | 0.00-0.00 | 0.00-0.00 | 0/4 | 0/4 |
| jab missed | 1.27-1.34 | 1.27-1.34 | n/m | 0.96-1.02 | n/m | 1.22-1.30 | 0.35-0.39 | 0.35-0.39 | 0/4 | 0/4 |
| cross landed | 0.91-0.99 | 0.91-0.99 | n/m | 0.48-0.60 | n/m | 0.83-0.92 | 0.00-0.03 | 0.00-0.03 | 0/4 | 0/4 |
| cross blocked | 0.91-0.99 | 1.01-1.09 | n/m | 0.65-0.78 | n/m | 0.94-1.02 | 0.00-0.00 | 0.00-0.00 | 0/4 | 0/4 |
| cross missed | 1.25-1.35 | 1.25-1.35 | n/m | 0.99-1.09 | n/m | 1.19-1.28 | 0.36-0.38 | 0.36-0.38 | 0/4 | 0/4 |
| lead_hook landed | 0.77-0.84 | 0.80-0.84 | n/m | 0.16-0.20 | n/m | 0.93-0.96 | 0.00-0.01 | 0.00-0.04 | 0/4 | 0/4 |
| lead_hook blocked | 0.85-0.93 | 0.95-1.02 | n/m | 0.29-0.39 | n/m | 0.98-1.06 | 0.00-0.00 | 0.00-0.00 | 0/4 | 0/4 |
| lead_hook missed | 1.00-1.12 | 0.99-1.12 | n/m | 0.42-0.56 | n/m | 1.05-1.20 | 0.20-0.26 | 0.20-0.26 | 0/4 | 0/4 |
| rear_hook landed | 0.76-0.82 | 0.76-0.82 | n/m | 0.29-0.35 | n/m | 0.71-0.77 | 0.00-0.00 | 0.00-0.00 | 0/4 | 0/4 |
| rear_hook blocked | 0.69-0.73 | 0.79-0.83 | n/m | 0.36-0.44 | n/m | 0.71-0.77 | 0.00-0.00 | 0.00-0.00 | 0/4 | 0/4 |
| rear_hook missed | 0.83-0.91 | 0.83-0.91 | n/m | 0.22-0.29 | n/m | 0.83-0.89 | 0.20-0.21 | 0.20-0.21 | 0/4 | 0/4 |
| body_hook landed | 0.55-0.60 | 0.71-0.77 | n/m | 0.18-0.26 | n/m | 0.62-0.78 | 0.00-0.00 | 0.01-0.04 | 4/4 | 0/4 |
| body_hook blocked | 0.54-0.57 | 0.71-0.75 | n/m | 0.20-0.30 | n/m | 0.62-0.67 | 0.02-0.03 | 0.02-0.04 | 4/4 | 0/4 |
| body_hook missed | 0.63-0.70 | 0.69-0.70 | n/m | 0.33-0.36 | n/m | 0.61-0.62 | 0.20-0.23 | 0.20-0.26 | 1/4 | 0/4 |
| body_cross landed | 0.88-0.93 | 0.88-0.94 | n/m | 0.54-0.64 | n/m | 0.84-0.88 | 0.00-0.04 | 0.00-0.04 | 0/4 | 0/4 |
| body_cross blocked | 0.85-0.93 | 0.93-1.05 | n/m | 0.68-0.82 | n/m | 0.86-0.96 | 0.03-0.12 | 0.01-0.04 | 2/4 | 0/4 |
| body_cross missed | 0.99-1.10 | 0.99-1.10 | n/m | 0.84-0.93 | n/m | 0.95-1.07 | 0.20-0.20 | 0.20-0.20 | 0/4 | 0/4 |
| lead_uppercut landed | 0.61-0.69 | 0.72-0.91 | n/m | 0.18-0.35 | n/m | 0.81-0.94 | 0.00-0.01 | 0.00-0.01 | 2/4 | 0/4 |
| lead_uppercut blocked | 0.61-0.70 | 0.74-0.80 | n/m | 0.18-0.24 | n/m | 0.75-0.79 | 0.00-0.00 | 0.00-0.00 | 2/4 | 0/4 |
| lead_uppercut missed | 0.67-0.74 | 0.67-0.74 | n/m | 0.29-0.36 | n/m | 0.77-0.88 | 0.20-0.23 | 0.20-0.23 | 0/4 | 0/4 |
| rear_uppercut landed | 0.64-0.71 | 0.64-0.71 | n/m | 0.17-0.24 | n/m | 0.68-0.77 | 0.00-0.02 | 0.00-0.02 | 0/4 | 0/4 |
| rear_uppercut blocked | 0.63-0.74 | 0.73-0.84 | n/m | 0.27-0.38 | n/m | 0.74-0.82 | 0.00-0.00 | 0.00-0.00 | 0/4 | 0/4 |
| rear_uppercut missed | 0.79-0.94 | 0.79-0.94 | n/m | 0.51-0.65 | n/m | 0.87-1.01 | 0.20-0.37 | 0.20-0.37 | 0/4 | 0/4 |

Men's before, feet and head included: 10 of 48 punch pictures over a bar (blue_body_hook_blocked, blue_body_hook_landed, blue_body_hook_missed, blue_lead_uppercut_blocked, blue_lead_uppercut_landed, red_body_cross_blocked, red_body_hook_blocked, red_body_hook_landed, red_lead_uppercut_blocked, red_lead_uppercut_landed). Women's before:
5 of 48 on apart and block alone. After: 0 of 96.

| clinch | apart before | apart after | head before | head after | arm before | arm after | chest before | chest after |
|---|---|---|---|---|---|---|---|---|
| clinch w | 0.04 (old 5-bone line) | 0.223 | 0.226 | 0.172 | 0.081 | 0.074 | 0.367 | 0.468 |
| clinch m | 0.04 (old 5-bone line) | 0.22 | 0.321 | 0.209 | 0.133 | 0.093 | 0.288 | 0.45 |

(The clinch's before apart is the trunk line WITH the necks; on the trunk alone the old 0.50 m gap reads 0.12 for the
women and about the same for the men - one trunk inside the other either way.)

The old "blocked glove 0.28-0.38 m from its target" in contacts.json was the glove-to-FACE distance (hit_m); it is no
measure of a block. `block_m` is.

## Blocked body punches - what passes and what is still wrong
Every one ends on the forearm now (block_m 0.01-0.045):
- blue_body_cross_blocked: pro_body_cross, mc_to_block, block_m 0.01 on the left forearm, glove 0.426 m from the rib target
- blue_body_hook_blocked: pro_body_shot, mc_to_block, block_m 0.04 on the left forearm, glove 0.397 m from the rib target
- red_body_cross_blocked: pro_body_cross, her guard, block_m 0.037 on the left forearm, glove 0.375 m from the rib target
- red_body_hook_blocked: pro_body_shot, her guard, block_m 0.043 on the left forearm, glove 0.371 m from the rib target
- blue_body_cross_blocked: pro_body_cross, mc_to_block, block_m 0.018 on the left forearm, glove 0.396 m from the rib target
- blue_body_hook_blocked: pro_body_shot, mc_to_block, block_m 0.021 on the left forearm, glove 0.397 m from the rib target
- red_body_cross_blocked: pro_body_cross, mc_to_block, block_m 0.045 on the left forearm, glove 0.37 m from the rib target
- red_body_hook_blocked: pro_body_shot, mc_to_block, block_m 0.037 on the left forearm, glove 0.385 m from the rib target

But each glove is 0.37-0.43 m ABOVE the rib target. A body shot is still caught at chest height, because nothing in the
game brings the elbow down to the ribs. The probe (`probe=cover`, run and removed): in every cover and block take the
game has (mc_to_block, pro_idle_to_block, mc_block, pro_block_loop, mc_block_hit, pro_block_straight_hit_v1-3) the elbows
sit 0.37-0.55 m over the rib target all the way through. BlockCatch catches at the face only, and HitSnap.brace curls the
trunk without moving the arm. So the owner's right-hand picture (blue body cross blocked) now TOUCHES the arm, but a coach
would still say "that body shot is blocked at the chest".

## Missing (listed, not invented - no edit under scripts/fight3d)
1. **A low block / elbow-down body guard** (J50_HOW_A_DEFENDER_DEFENDS.md row 2, "Low block / elbow-down body guard"):
   either a take where the elbow drops onto the ribs on the punch's side, or a BlockCatch body catch that turns the
   UpperArm down instead of the glove up. With it, the four blocked-body pictures per set would end on the ribs.
2. **A close-range uppercut take with the arm still bent at contact.** At a range where the bodies do not overlap, the
   lead uppercut lands with a long, almost straight arm (men's blue lead uppercut: it reads like a jab).
3. **A clinch take with the arms outside the trunk at the authored gap.** At its own 0.68 m the men's arm line sits 0.02 m
   from the other's trunk (through it). The picture uses 0.66 m (men) / 0.60 m (women), where arm_m is 0.09 / 0.07.

## Coach notes per picture (contact sheets opened; the full-size pictures named here opened)
Sheets: `docs/playtest/s543_pics/m_after_sheet_1-3.png`, `w_after_sheet_1-3.png`.
- all 8 blocked body pictures: caught at chest height on a high cover, not on the elbow at the ribs (missing 1).
- m blue_lead_uppercut_landed: the uppercut lands with a long arm from range (reads as a jab), and its glove crosses red's
  own guard glove on the picture: a glove through a glove (missing 2).
- m blue_body_hook_landed: boots toe to toe, the glove on the ribs just under red's elbow. Crowded but no body through a
  body (feet 0.195, head 0.62).
- red/blue cross missed and jab missed (both sets): the back-dodge take crosses the defender's feet as she pulls away.
  That is the take (pro_back_dodge), not the range.
- clinch (both sets): from the side the two bodies cover each other, cheek to cheek. That is how a clinch reads; the
  boots touch.
- knockdown 3 (both): unchanged; the camera widens so the boxer standing over the fallen one looks small.
- Jabs, crosses and hooks landed / blocked: daylight between the chests, glove on the face or on the catching glove, feet
  apart. No change was needed beyond the gate.

## Which study each fix follows
- Spacing (no body through a body): no study gives a torso gap for a picture; the bars are measured on our own S540
  pictures (above), and the head bar comes from ANSUR II head breadth.
  For the clinch, BRIEF_DOLA_CLINCH_POSE.md ("held, loaded... hip-to-hip against 0.72 m", "arms in an inside/outside
  relationship rather than interpenetrating") and Clinch.PAIR_GAP_M 0.68.
- Blocked = ends on the block: J50_HOW_A_DEFENDER_DEFENDS.md rows 1-2 (high guard / shell for the head; low block /
  elbow-down for the body), BlockCatch (BLOCKLOOK2-5) for the head catch, the guard rule (owner S531: hands at the head).
- Landed on the near side: the task's "what would a human do" - a landed hook on the near cheek, daylight between the
  chests.

## Tests
- `tests/fight_pictures_gate_test.gd`: `FIGHT_PICTURES_GATE set=w checked 58 pictures`,
  `FIGHT_PICTURES_GATE set=m checked 58 pictures`, `FIGHT_PICTURES_GATE failures=0` (exit 0). Red before: failures=240.
- `tests/palette_guard_test.gd` exit 0; `tests/move_pics_test.gd` exit 0; `tests/session_pics_test.gd`
  `SESSION_PICS failures=0`; `tests/file_limits_test.gd` `FILE_LIMITS failures=0`; `tests/fight_pictures_test.gd`
  (the pictures' own screen test) `FIGHT_PICTURES failures=0`.
- Renders: `PICS2D_SET wrote=58 refused=0 gate_failed=0` for both sets (men ~14 min, women ~14 min on the hidden desktop).

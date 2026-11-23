# PICS2D2 - the full 2D picture set (S540)

Two sets, 58 pictures each (w: Lucy Jackson v Priya Nair; m: Isaiah v Victor), in assets/ui/fight_pictures/{w,m}/.
Fixed side camera (yaw 0), chosen over 25 deg after rendering both: at 25 deg the defender's back hides a landed body hook.
contact_sheet.png = one real round (seed 7) in the game's "Watch it in pictures" view, 21 pictures. all_*.png = every picture.

## Fixed this round
- Landed glove ON the target: the defender's hit reaction is played and held first, then the armed punch finishes on the
  head where it ended up (it had snapped ~9 cm away after contact). A pair-placer loop moves the puncher by any gap left.
  Head punches and body hooks: 0.002-0.006 m (the PICS2D1 stills were 0.18-0.32 m off).
- A body hook is drawn as a body hook (the known wrong PICS2D1 picture).
- Missed: the defender pulls back (straights, uppercuts) or ducks (hooks). Landed: head snaps / body folds (the owner's
  "make one fighter dodge" and "use reactions").
- The 3rd knockdown frame (boxer flat on the canvas) no longer falls off the picture: the camera widens to fit.

## Read wrong (checked by eye)
1. Body cross LANDED (4 pictures): the glove lands at chest height, 0.17-0.29 m above the ribs. No take in clip_db throws
   the rear straight to the body, and PunchAim closes at most 0.30 m. Needs a body-cross take (an asset gap); 8 cross takes
   probed, best pro_right_cross_c (0.18 m). fight_pictures_test stays red on exactly these four.
2. Landed vs blocked straights and hooks look alike at thumbnail size (the glove meets the face behind a raised guard);
   the view's ring / BLOCKED / MISS marks carry the difference. A clearer hit reaction take would help.
3. Knockdown frame 1 reads as an ordinary exchange (no hurt yet); frames 2 and 3 read.
4. m/blue_lead_hook_missed: a small white spark speck above the pair.

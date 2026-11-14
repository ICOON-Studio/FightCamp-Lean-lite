# CLASH2 - gloves and forearms through each other (owner C394, four marks "still clipping") - S468, Claude

Film: `tools/hit_frame_film.gd -- <out> jabs=0 crosses=0 uppercuts=1 seed=4242` on the hidden desktop, 960x540, 60 fps.
Ruler (new): `tools/clash_meter.gd`, read off the bodies AS DRAWN, printed by the film as `CLASH` lines: frames from the
hit on where any glove or forearm of one boxer is more than 2 cm inside the other's, and the worst depth.
Pictures: docs/mockups/s468/rear_uppercut_before_after.png, lead_uppercut_before_after.png.

| Punch (seed 4242) | main before | after |
|---|---|---|
| rear uppercut | 14 frames, worst 0.074 m | 3 frames: one at 0.065 m (the frame after the hit), two at 0.023-0.027 m |
| lead uppercut | 14 frames, worst 0.085 m | 1 frame at 0.024 m |

## What was wrong (each measured on the film, not guessed)
1. The S465 shapes were two 0.06 m balls; the glove on screen (Gloves.SIZE 1.2) is 0.17 m thick and 0.31 m long. "Clear"
   by the old rule still drew 3-5 cm of overlap, and forearms were never kept off gloves.
2. ElbowClear ran AFTER the clearance and moved the elbows 2-18 cm (`drift` in the meter); the glove follows the forearm,
   so a cleared glove swung back in. The arm-against-arm pass now runs last of the arm layers (scripts/fight3d/ArmClash.gd).
3. "A punching hand never moves" left two hands that never moved (an uppercut hand going home through her jab going out).
   Right of way now: live punch > hand going home > guard hand; the lower one moves, equals share.
4. A long-guard glove sat BETWEEN the other's two gloves (a gap narrower than a glove): pushing off one pushed into the
   other. The hand now also draws in toward its own shoulder, and off a live punch the arm opens outward.
5. The boxer drawn first reads the other's arms a frame late: she reads them one step ahead; the one drawn second takes
   what is left.
6. A BLOCKED punch is left to the block: with the true glove shape the catching hand was pushed off the punch it is
   meant to meet (block_meet A_A jab: the catching glove 9 cm under her face, bar 8). BlockCatch owns that meeting.
`-- ballclash` = the S465 rule and place (control arm); `-- noclash` = none.

## Regression (headless, same day)
| Test | main | after |
|---|---|---|
| block_meet | 4 (the four CTRL_LANDED rows, LANDREACH) | 4 (the same rows) |
| hit_frame | 10 | 10 |
| hit_carry | 38 (`-- ballclash`, same day) | 38 |

## Still open
- One frame after the hit on the rear uppercut (0.065 m): her guard forearm against the glove on her chin.
- A boxer's own two gloves can still overlap each other (seen in the "before" row); no rule for that yet.
- The rear uppercut still lands 0.114 m off her chin at 8 % of its top speed (the film's own line): not this task.

## LANDREACH (lead glove height) - what S468 found, nothing changed yet
tools/landreach4_probe.gd: in block_meet's CTRL_LANDED setup the punch is armed and its contact frame read two frames
later, while the reach is still easing in (weight 0.14 on the hit frame, 0.80 at the read). For the lead hand the hit
point is then re-latched onto that half-eased glove (ReachLimit.carry_base returns `shown`), 7-23 cm off her face, and the
glove goes exactly there (drawn glove to its aim: 0.00-0.02 m). So the 5-11 cm "height error" is the latch on a
half-eased glove, not the arm solve. In the played fight the punch is armed at the clip's start, so the ease is over by
the hit - unless a punch starts mid-clip (BeatFire's skip). Next: (a) carry_base takes the face whenever the reach was not
at full weight on the hit frame; (b) CTRL_LANDED lets the ease finish before it seeks to the contact, as the game does;
(c) `tools/hit_gap_probe.gd` on the hidden desktop WITH `--log=` (S468's run had no log) for the played numbers by punch.

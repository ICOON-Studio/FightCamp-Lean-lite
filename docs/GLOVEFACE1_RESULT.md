# GLOVEFACE1 - the guard glove and the ring light (S536, owner C447 and C456)

Owner C447 (a WRONG mark on the red boxer's guard glove): "is the glove normal looking ?"
Owner C456 (on the body stills): "this black fighters do not look good on dark background it is so dark i cant tell the
difference in the pictures".

Measured with `tools/gloveface_probe.gd` on the v2 fight player's own camera (hidden desktop, 1920x1080), six bodies:
mh_boxer_11 v 10 (dark women, the marked picture's pair), 02 v 01 (dark man v light man), 07 v 03 (dark man v mid man).
The glove-to-face ruler is `tools/glove_face_meter.gd`: the drawn glove's surface against the skin the head bone carries,
negative = inside the face. Stills (before / after, the same frames): `ops/previews/s536_gloveface/pair_*.png`.

## 1. What was measured BEFORE anything changed

### The glove's size

| | Our glove (mounted, SIZE 1.2) | Real 10 oz glove | Tag |
|---|---|---|---|
| Length, cuff end to knuckles | 31.2 cm (12.0 behind the wrist, 19.2 ahead) | 29 to 34.5 cm | SOURCED |
| Width across the knuckles (with the thumb) | 16.8 cm | 15.5 to 17 cm | SOURCED |
| Depth, palm to back (fist alone) | 14.9 cm (17.0 with the cuff's offset) | 14 to 16 cm | SOURCED |
| Cuff length | 8.1 cm | 8 to 10 cm | ESTIMATE |
| Cuff width | 10.7 cm at both ends: a straight tube, flare x1.00 | wider at the forearm end than at the wrist | ESTIMATE |
| Width at the wrist end of the hand part | 8.9 cm (narrower than the cuff) | about the cuff's width | ESTIMATE |

SOURCED = retailer product listings found by search (Sandee 10 oz 34 x 17 x 14 cm; RDX IBA 10 oz 29 x 16 x 16 cm;
Contender 34.5 x 15.5 x 14.5 cm). No maker publishes a cuff size sheet; makers size gloves by weight and hand
circumference. ESTIMATE = read off product photos, not a published number.

Finding: the glove's overall size was already real. Three things made it look wrong:
1. It stood INSIDE the face (below), which hid part of its width: that is the "tall and narrow" read.
2. The cuff was a straight tube, wider than the wrist it joined.
3. The hand part was thin at the wrist and only filled out at the knuckles (a club, not a fist).

### The glove against the wearer's face, guard (cm, negative = inside the face)

| Body | Lead glove | Rear glove |
|---|---|---|
| mh_boxer_11 (red) | -2.1 | -0.8 |
| mh_boxer_10 (blue) | -1.8 | -1.7 |
| mh_boxer_02 (red) | -0.9 | -2.5 |
| mh_boxer_01 (blue) | +0.1 | -1.2 |
| mh_boxer_07 (red) | -0.5 | -1.8 |
| mh_boxer_03 (blue) | -0.7 | -2.5 |

Where: the front of the face (nose, mouth, chin), not the cheek's side. Mid-punch (red jab at contact): the free hand
+1.5 cm, the punching glove 40 cm away.

### The boxers against the crowd behind them (broadcast camera, luma 0-255, the same pixels with the boxers hidden)

| Body | Upper body minus crowd | Skin patches minus crowd |
|---|---|---|
| mh_boxer_11 (dark) | +22.2 | +15.8 |
| mh_boxer_10 (dark) | +16.8 | +16.6 |
| mh_boxer_02 (dark) | +22.7 | +25.1 |
| mh_boxer_07 (dark) | +17.6 | +24.4 |
| mh_boxer_01 (light) | +41.8 | +17.4 |
| mh_boxer_03 (mid) | +43.5 | +10.6 |

A dark-skinned boxer stood about half as far over the crowd as a light one.

## 2. What changed

`scripts/fight3d/Gloves.gd` (`-- oldglove` = the glove as it was):
- Per-axis shape on top of SIZE: 5 % shorter, 6 % deeper (SHAPE 1.0 / 0.95 / 1.06). The hand part filled out 10 % at the wrist end.
- The cuff is a bell: 92 % of its old width where it joins the glove, 116 % at the forearm end, 5 % shorter. Still the vertex-red band.
- The glove is kept ON her face, never in it: three balls down the glove against the skin of her own head; the wrist
  gives up to 34 degrees, then the glove slides up to 4.5 cm under the cuff. Eased, so it cannot pop; it never moves
  into her other glove or forearm. The guard still covers the face: the glove only moves as far as the touch.

`scripts/fight3d/RingSet.gd` (the ring lights live here; `-- oldlights` = as it was): four cool lights, one on a truss
at each side of the ring, 4.3 m up, across the ring at head height. From the camera's side they fill the bodies' shaded
fronts; from the far side they rim the outlines. They die before the far seats. No skin was lightened.

## 3. AFTER

Glove: 29.2 cm long (11.0 behind the wrist, 18.2 ahead), cuff 7.4 cm long, 10.6 cm at the glove end, 12.2 cm at the
forearm end (flare x1.15). Reach: the glove's front is 1 cm nearer the wrist (0.192 -> 0.182 m); front_m() reads it.

Glove against the face, guard (cm): 11: +0.4 / +0.4; 10: +1.4 / -0.2; 02: +1.0 / -0.3; 01: +0.5 / +1.1; 07: +0.7 / +0.2;
03: +0.5 / -0.3. Worst -0.3 cm (was -2.5). Free hand during the jab: -0.2 cm.

Boxers against the crowd, upper body: 11: +40.9 (was +22.2); 10: +34.6 (+16.8); 02: +41.3 (+22.7); 07: +36.5 (+17.6);
01: +64.2 (+41.8); 03: +66.5 (+43.5). Every body is now at least +34 over the crowd; the dark bodies stand where the
light ones stood before.

## 4. What is NOT fixed (say so)

- Skin patches on the red-corner dark boxers barely moved (11: +15.8 -> +14.2; 02: +25.1 -> +26.5; 07: +24.4 -> +25.7):
  those patches sit on arms held in the guard's own shadow. The whole upper body reads lighter; the face in close-up is
  still dark against a dark crowd. A stronger light washed the red gloves and vest pink (tried at 4.0, kept 2.4).
- The OLD fight player (the one the game plays unless `fightplayer2` is on) holds its wrists 15-17 cm from the head,
  nearer than a glove alone can clear: its guard glove was deeper than 1 cm in 30-38 of 40 looks, now 4-13 of 40, with
  single looks still 5-7 cm deep. Clearing that means moving the arm, which is the v2 player's job (METHOD: no new fix
  layer on the old player).
- The cuff's forearm edge is still jagged where the cut hand meets it (seen in the jab close-up; it was there before).
- Baked 2D pictures that show gloves (hub sprites, session pictures) keep the old glove until they are baked again.

## 5. Tests

`tests/own_gloves_test.gd` gained the face check: the v2 guard, both boxers, no glove deeper than 1 cm. Red with
`-- oldglove` (-2.3 and -1.8 cm), green now (-0.5 and -0.3 cm). The old player has a tripwire only (at most half the looks).
Green: glove_cut_test, own_gloves_test, player2_test, choreographer_test. file_limits_test is red on
`scripts/fight3d/v2/Player2.gd` at 501 lines: another session's commit, not this task.
own_gloves_test's older glove-against-glove bar fails about one run in five with or without this change (seen on the
`oldglove` arm too: 0.113 m once in five runs).

## 6. Prefab check

The mesh (assets/models/gloves/boxing_glove.glb, CC BY 4.0) reached the shape with per-axis scale and a reshaped cuff;
no other glove model was needed.

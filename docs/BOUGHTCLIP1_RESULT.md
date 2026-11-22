# BOUGHTCLIP1 - the cross as bought, the reach, the rear foot

S537, 2026-11-22. Owner C467-C471. Fight player v2 only (METHOD S510); no layer was added. One of our own stages was
corrected (the size the distance plan is given) and one table was measured again. The owner closes this, not a test.

## In plain words
- **The bought clip looks like this:** a flat-footed, straight right hand thrown at SHOULDER height. The arm goes out 99%
  straight, pointing 4 degrees down; the fist ends 1.33 m above the floor on a man whose shoulder is at 1.36 m and whose
  head joint is at 1.52 m. The rear foot turns 12 degrees and its heel lifts under 2 cm by the contact.
- **On our body the take is the same take.** Legs within 1.2 cm and 4 degrees, arm 99% straight, the same foot turn.
  Our body is bigger in the trunk and arm than the vendor's mannequin, so the fist ends at 1.39 m; nothing else differs.
- **The game differed because of us, in one place:** the distance plan stood the two men too close for the body that
  punches. A landed cross then had its arm FOLDED by the arm finish (75-84% straight instead of 99%) to keep the glove
  on the face. That is the "weird" in the game picture. Corrected: now 86-87% on this pair, 95% median in the test.
- **C469 "Cross can only reach shoulder?"** Yes, as bought it does: the take is thrown at shoulder height. The picture
  he marked was the take alone, from out of range, with no arm finish. In a real landed cross the game lifts the glove
  14-16 cm onto the face: glove 3-4 cm above the chin, 16-18 cm above the shoulders, on the aimed point.
- **C471 "too much twisting or bending. Maybe the foot needs to move a bit"**: the bought take barely pivots, and ours
  does exactly what the take does. No pin, step wire or stance hold of ours stops it (the foot pin lets go during a
  punch since KNEEROOT1). This is a take problem: a better cross clip (the end-of-November pack), not code.

## The vendor's own preview
- https://www.youtube.com/watch?v=Flko50MXoEU - "Boxing - Motion Capture Animation Pack", channel MoCap Online. The
  pack's own preview, named in the pack's read-me; checked that it still resolves. No time stamp for the right cross
  is listed anywhere I could read.
- https://vimeo.com/486719728 - "Punch MoCap (OVERVIEW)", 60 s, the current trailer of the renamed pack; resolves.
- https://mocaponline.com/products/punch - the current product page. NOT verified: the vendor's site refused every
  automated fetch (HTTP 429). I did not watch either video; only their titles were confirmed.

## Pictures (ops/previews/s537_boughtclip1/)
One fixed camera, the same in all three panes: AS BOUGHT (the vendor's file on the vendor's mannequin, Motus Man, sized
x0.96 to our leg) | OUR BODY, THE TAKE ONLY (7 layers off) | THE GAME NOW (a landed cross of a planned exchange).
- `cross_contact.jpg` - the contact picture. `cross.mp4` - twice at speed, then once at quarter speed.
  `cross_strip.jpg` - seven pictures down the punch.
- `before_fix_cross_contact.jpg`, `before_fix_cross.mp4`, `before_fix_cross_strip.jpg` - the same before the fix.

What I opened myself: the three contact stills of the first run, `before_fix_cross_strip.jpg` and the new
`cross_contact.jpg`. I did not play either film as video.
- Left and middle are the same pose: arm straight out at shoulder height, lead knee nearly straight, both feet flat.
- Right, before: the arm visibly bent and crowded onto the other man. Right, now: the arm is longer but still not
  straight, the glove on his face behind his guard glove.
- The mannequin is plain grey: the pack's texture files are not in the pack's folder.
- The camera is not square to the boxer (he stands bladed, about 40 degrees to it); it is square to the line between
  the two men when the film starts. The near bottom rope crosses the knees in all three panes.

## The numbers at the contact (0.30 s), blue = mh_boxer_01, red = mh_boxer_02
`tools/boughtclip_probe.gd`; the bought file scaled to our 83.8 cm leg. Logs: `probe.log` (now), `before_fix_probe.log`.

| | arm straight | arm points | wrist height | his shoulder / head joint | lead knee bend | rear knee bend | lead / rear foot turn |
|---|---|---|---|---|---|---|---|
| Bought (vendor skeleton) | 99% | -4 deg | 1.33 m | 1.36 / 1.52 m | 11 deg | 22 deg | 9 / 27 deg |
| Take alone on our body | 99% | -5 deg | 1.39 m | 1.43 / 1.59 m | 13 deg | 26 deg | 7 / 27 deg |
| Game before the fix (3 landed crosses) | 75, 84, 79% | 0 to +3 deg | 1.43-1.46 m | 1.43 / 1.59 m | 13 deg | 26 deg | 7 / 27 deg |
| **Game now** (3 landed crosses) | **86, 87, 87%** | +1 to +3 deg | 1.44-1.46 m | 1.43 / 1.59 m | 13 deg | 26 deg | 7 / 27 deg |

Legs: the game equals the take alone to the millimetre on all three crosses. Only the arm differed.

**Our body against the vendor's, both on the same leg length (cm, vendor / ours):** thigh 41.1 / 44.2, shin 42.7 / 39.5,
upper arm 26.4 / 29.6, forearm 25.6 / 27.9, shoulders across 36.7 / 35.7, hips across 17.0 / 20.8, hips to neck
53.2 / 63.3. The bake copies joint angles, so a longer trunk and arm put the same pose's fist 6 cm higher and 6 cm
further out. That is the body, not a stage that changes the take.

## The reach (C469)
| a landed cross, blue on red | before | now |
|---|---|---|
| glove front height | 1.53-1.55 m | 1.53-1.54 m |
| red's chin / nose tip / shoulders | 1.50-1.51 / 1.51-1.52 / 1.36-1.37 m | the same |
| glove against his chin / his shoulders | +3 to +4 cm / +16 to +19 cm | the same |
| glove from the aimed point | 0.1-0.2 cm | 0.1 cm |
| the arm finish moved the glove | 21-25 cm: up 14-16, BACK 13-19 | 17-19 cm: up 14-15, BACK 11 |
| the men's places apart | 108.7 cm | 114.7 cm |

- The chin is taken as 8 cm under the nose tip along the head; it was not read off the mesh. The nose tip is.
- The height comes from the take (shoulder height) and is closed by the arm finish. Red is not too short: he stands
  2.5 cm shorter than blue at the head joint.
- The 13-19 cm BACK was ours: the men stood too close, so the arm had to fold. See the cause below.

## The feet (C471): the rear (right) foot through the cross
| time | bought: turn / heel up / ball moved | take on our body | game now |
|---|---|---|---|
| 0.00 s | 39 deg / 0 / 0 | 39 / 0 / 0 | 53 / 0 / 0 |
| 0.15 s | 36 deg / 1.5 cm / 0.6 cm | 36 / 1.3 / 1.3 | 36 / 1.5 / 5.6 |
| 0.30 s (contact) | 27 deg / 1.7 cm / 1.1 cm | 27 / 1.3 / 2.7 | 27 / 1.5 / 8.7 |
| 0.45 s | 32 deg / 4.0 cm / 1.3 cm | 32 / 3.6 / 1.9 | handed back to the guard |

- The actor turns his rear foot 12 degrees and lifts the heel under 2 cm by the contact (4 cm on the recoil). A boxer's
  cross pivots on the ball with the heel well up; our own research has no measured number for it
  (ops/research/K46_BOXER_FEET_DURING_PUNCHES.md: coaching cue only), so I give no target.
- Ours pivots exactly as much as the take. Nothing of ours holds it.
- In the game the foot starts 14 degrees more turned out (the waiting stance) and reaches the take's angle by 0.10 s.
- In the game the ball of that foot also SLIDES forward during the punch: 17.7 cm before, 8.7 cm now. That is the body
  being moved to its distance while the punch plays, the SLIDE debt KNEEROOT1 named. Not fixed here.

## The cause that was ours, and the fix
1. **The plan was told every body is the size of the measuring body.** Every distance in the plan comes from one table
   (`assets/data/clip_db.json`), measured on mh_boxer_10, a small body: shoulder to wrist 49.4 cm against blue's
   57.5. `Choreographer.gd:16` asks for "each body's size against the census body"; `Player2.gd:193` handed it the
   node's scale, 1.0 for everyone. The plain cross reaches 107 cm ahead of the hips on blue and 90 cm on the measuring
   body, so blue was stood 17 cm too close. Now `PairPlace.size()` (`PairPlace.gd:211`) gives the body's arm against
   the measuring body's. This changes the distance of every punch for every body that is not that size.
2. **The table still held the switched-off hip drive.** The 17 rear-hand takes were measured with the hip-drive bake on
   (commit 38a1432cf); the bake was switched off at the owner's word (36505506d) and the rows stayed: the plain cross
   said 1.121 m and 14 cm of hip travel where the take as played is 1.015 m and 3.4 cm. The whole table was measured
   again with `tools/clip_census.gd` as it plays today. 70 rows changed: the rear-hand takes by 4-14 cm, the rest by
   about 1 cm (the glove's front is 1 cm shorter since the glove fix).

Not touched: LineGrade, LiveRound, StepWire, MHRig. No cause was found in them.

## Tests
`tests/player2_test.gd` (the new check's helper is in `tests/player2_match.gd`), bodies mh_boxer_12 and 07:

| check | before | fix 1 only | now (fix 1 + the table) |
|---|---|---|---|
| ARMSTRAIGHT (new): the median landed jab or cross is at least 90% straight | **FAIL 87%**, least 70% | 99%, least 83% | **PASS 95%**, least 81% |
| LANDS: landed gloves within 12 cm of the target | 14 of 14, worst 3.4 cm | 12 of 14, worst 17.5 cm | 13 of 14, worst 14.4 cm |
| JUMPS: head moves over 12 cm in one picture | 0 | 0 | 2 (prints as DEBT, guard 12) |
| SLIDE (already a debt) | 9.99 / 10.06 m | 9.06 / 9.53 m | 9.70 / 9.66 m |

Green, failures=0 each: player2_test, clip_db_test, choreographer_test, arm_build_test, file_limits_test,
own_gloves_test, golden_path_test. Logs `test_*.log`; the red run is `test_player2_before.log`.

## What it costs, and what is left
1. **One landed glove in 14 now ends 14 cm off its target** (it was 3.4 cm at worst), and **two head jumps** appeared
   where there were none. Both are inside their guards and print in the test; both are worse than before.
2. **The arm is still not straight on the owner's pair: 86-87%, not 99%.** The glove is still pulled back 11 cm. The
   table assumes the hit man holds his head 2 cm ahead of his hips (the old guard, `pro_idle`); in the waiting take
   the game plays now his head is 8-10 cm ahead. That is a third mismatch of the same table, named, not fixed.
3. The size is one number a body (the arm). A body with a long arm and a short trunk is not that simple; it fits the
   one pair I measured (1.16 asked, 1.16 given) and was not checked on others beyond the test's pair.
4. The cross itself is still the bought cross: shoulder height, flat feet. Whether that is good enough is his call on
   the pictures; a different clip is the only cure for the feet.

## Prefab check
None.

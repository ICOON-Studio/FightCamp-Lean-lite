# CLIPREVIEW1 - review our boxing fight motion (FightCamp, S259)

FightCamp is a PC boxing-gym management sim: you train a boxer, book his fight, and WATCH the bout as a 3D simulation (two
MetaHuman-style boxers, red trunks vs blue trunks, game camera high and three-quarter, like a broadcast). The operator watched our
latest fight clip and said: "The 3d fight looks terrible torso twists weird legs fly not walk" and "the jab fires like bullet why is
it so fast". We changed the motion system (one writer moves each body per frame instead of eight) and need every reviewer's eyes.

## The clip, in numbers (seed 95501, 40 s, 1,200 frames per boxer; left = before, right = after the change)
| measure | before red/blue | after red/blue |
|---|---|---|
| frames a PLANTED foot slides on the canvas | 315 / 333 | 186 / 161 (13-15%; goal <= 5%) |
| body root moving > 4 m/s (teleport-like) | 8 / 9 | 0 / 0 |
| body root moving > 1.5 m/s | 231 / 229 | 140 / 66 |
| hips lower than 0.70 m (crouched) | 159 / 39 | 116 / 5 |
| feet more than 0.95 m apart | 42 / 44 | 25 / 29 |
| torso twist > 50 deg (red) | 17 | 19 |
| centre-to-centre distance the engine holds in exchanges | 0.557 m - torsos visibly merge | same |

What the frames (every 2 s) show after the change: the red boxer often crouches with bent knees and leans forward into the blue
man; in exchanges the two torsos touch or overlap; bare feet; gloves red; the blue man stands taller and more upright.
The jab: from guard to full extension the glove travels in a very short time - the operator says it "fires like a bullet".

## Questions (answer every one, as long and specific as you can)
1. Which reads more like two real boxers - and where exactly does the motion break (feet, hips, torso twist, spacing)?
2. Feet: real boxing footwork is push-step, pivot, shuffle - never a glide. What should planted feet do during a punch? When must
   a foot move, and how far, in a real jab, cross, hook? Give numbers where you know them.
3. Punch speed: real numbers for an elite and an amateur boxer - jab fist peak speed (m/s), time from guard to full extension (s),
   time back to guard, and how this changes for cross, hook, uppercut. How fast should a VIDEO GAME show it so it reads well to a
   viewer (games often slow punches down - which ones do, by how much)?
4. Spacing: what distance between the two boxers' chest centres in an exchange (jab range, hook range, clinch)? What stops
   torsos merging in fighting games (collision capsules, push-out, animation spacing)?
5. Name the three most important things to fix first, in order, and what a fighting-game animator would do about each.

## Your angle
MARIA (art direction): silhouette, posture, stance width, crouch depth, the broadcast camera, how the two boxers should look side by side so the viewer reads a boxing match at a glance.

Write the longest complete answer you can. Plain words, numbers with units, sources where you have them.


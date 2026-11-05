# TASK BJJ9R15 - ANTIGRAVITY (Gemini 4 Argon High) - the BJJ belt match without trembling or bodies inside bodies, to 9/10

Status: OPEN (S380, Claude). ROUND 12 = round 11 again on the merged BASE: BJJ9R11 never ran (agy.exe was not found at
launch). Your BASE claude/bjj9base (405c0989) now HAS main merged in:
the 50/50 pose fix (GrapplePose keeps its last trunk turn / limb rolls; GrappleGraph.steady() lays relabelled keyframes
back - the piggyback is gone), the Grappling theatre (scenes/dev/GrappleTheatre.tscn, tools/theatre_pop_probe.gd) and
tools/bjj_tremble_probe.gd `mode=theatre chain=<id>`. So the "FIXED ON MAIN ... merge main's ..." paragraph below is
ALREADY DONE on your base - do not merge again, start from the drawn-bone work (pops at joins, bones off their joints,
thick bodies). Argon judged the base film 3/10 before R11 (trembling + bodies passing inside each other).

Round 11's brief (S379): Operator S379, on Ziva's round-10 film (Argon had said 5/10): "that clip is so terrible, limbs
are trembling, why it got so much worse? it was fine in the clip grapple_walk.mp4", a still of one woman inside the other,
"wtf is this?", then "use argon instead of ziva". Ziva is stopped; this loop is yours. Rounds 1-10 were Ziva's
(ops/research/BJJ9_ROUNDS.md, TASK_BJJ9.md for the match's rules and the move graph).

## S379 AUDIT (Claude's agent, measured on the bones AS DRAWN - read before you change anything)
tools/bjj_tremble_probe.gd (on your BASE) reads every bone on Skeleton3D.skeleton_updated, i.e. after GrapplePose's aim +
roll + IK and GrappleGrip. Jerk p95 (m/s^3, all tracked joints pooled) and velocity flips per second a joint:
- the S335 browser code that made grapple_walk.mp4 (the operator's "fine"): 44 / 0.05
- the browser today with every layer off (`nolayers`): 23 / 0.04
- the browser today, layers on: 809 / 2.72 (wrists 1,660-1,729)
- the r10 match: 1,312 / 3.75 (elbows 2,107-2,275); its finish phase alone 3,138 / 9.74
One layer off at a time on the r10 bout:
- `noidle` (the idle "liveness" hump GrapplePlayer.joints_at adds on every keyframe): 1,312 -> 396, wrists 1,941 -> 183;
  browser 809 -> 120. THE MAIN CAUSE.
- `noroute` (the _route waypoints around bodies): browser 809 -> 207; it does NOT reduce the drawn overlap (p95 0.156 -> 0.154 m).
- `nofinish` (GrappleFinish, the arm lock built in code): drawn overlap at the end 0.210 -> 0.018 m. The builder alone sinks
  Kim's thigh 0.21 m into Ana's trunk and pops a knee 0.53 m in one frame at 58.9 s.
- `nosep` (push-out): 1,237, drawn overlap unchanged - it clears the JOINTS (0.184 -> 0.045 m, which is all bjj9_probe reads)
  but the drawn skeleton never reaches them (drawn elbows sit 0.213 m off their joints p95, knees 0.149 m).
- `noblend` makes it WORSE (holds 496 -> 3,284) - keep the blend. carry / feints / floors / impact / grip / IK: little change.

## S379 LATER - CLAUDE ALREADY DID ITEMS 1-3 ON YOUR BASE (967a79bd): the match plays GrappleMap STRAIGHT
Operator C221: "why on grapplemap the clips played fine, why you dont use them straight in the game" (and he linked
https://eel.is/GrappleMap - its own player, the look to match). GrapplePlayer.on(): idle / push-out / carry / impact / route /
built finish are OFF by default (`-- with<layer>` turns one on for a measurement); blend, floors, feints stay. Same bout:
joint jerk p95 elbows ~2,100 -> 119-269 m/s^3, flips 3.75 -> 0.2-0.3 a second. Do NOT turn those layers back on.
WHAT IS LEFT (your round): GrappleMap's player draws tube figures built ON the recorded joints, so nothing is ever refitted;
we drive MetaHuman skeletons with other bone lengths and thicker flesh:
- one-frame POPS where two transitions join (worst 0.48 m, KIM wristR at 43.8 s; the max jerk is still 13,000-26,000) -
  align the next transition's first frame to the last one drawn (it is the same GrappleMap position: match by joints).
- DRAWN BONES OFF THEIR JOINTS (elbows ~0.21 m, knees ~0.15 m p95): retarget by bone DIRECTION from the data with our own
  bone lengths, root at the hips, then IK only the hands and feet that grip/post - so the drawn body follows the data.
- THICK BODIES OVERLAP (thighs 0.20 m into the other trunk; it is in the data's geometry at our size): per-pair scale or a
  small sideways offset of the whole partner per position, solved once per position (never per frame).
GRAPPLEMAP'S OWN PLAYER (public domain) is on your BASE in ops/research/grapplemap_player/ (playback, interpolation,
joint radii, the tube drawer) - read it to see why it plays smooth. You cannot browse the web; everything is in the worktree.
Items 1-3 below are done - keep them done; do 4-6 and the three above.

OPERATOR S379 on the grappling board page: "most grappling animation look good except the 'to 50/50'" - his still shows the
two women fused into one body at the 50/50 entry. Fix that transition first among the overlaps.
And on the straight-play film (claude/bjj9base, 0:40.1, one leg under the other's armpit) he said: "it is normal looking" -
real grappling contact is SUPPOSED to press limbs into armpits, hips and chests. Do not push the bodies apart where the
data has them in contact; fix only what reads as one body passing THROUGH the other (his "to 50/50"). The overlap bar
below is a guide; his eye and Argon's frames decide.
S379 theatre (main 2d1cd429, film ops: tmp/s379/theatre/fifty_fifty.mp4): at 'To 50/50' red's pelvis sinks 0.23 m into
blue's at 14.7 s and red's HEAD jumps 0.2 m in one frame while the data moves 5 cm - our pose code spins her torso the wrong
way there (GrapplePose aim+roll), not the data. Start with that frame.
FIXED ON MAIN (S379, 'BJJ9R11 theatre 50/50' commit): two causes. (1) GrapplePose slerped Spine/Chest the short way between
the hips and shoulder frames; the turn passed 180 deg and they spun ~120 deg in one frame (head 0.2 m) - the drawn pose now
keeps its last trunk turn / limb rolls (no roll flips: arms, hands and feet too). (2) GrappleMap's 'to 50/50' last keyframe
is the position relabelled (men swapped + mirrored), so the women flew through each other to trade places - the piggyback;
GrappleGraph.steady() lays such keyframes back (8 in the DB). Merge main's scripts/grapple/GrapplePose.gd, GrappleGraph.gd and
GrapplePlayer.gd before touching the pose; tools/theatre_pop_probe.gd measures the drawn one-frame steps per chain.

## Your job, in this order
1. Take the idle layer out of moves (the per-keyframe hump in GrapplePlayer.joints_at). At most a slow breath on a HELD
   position (chest, under 1 cm, ~0.25 Hz), never on limbs while a move plays.
2. Remove the _route waypoints (they add jitter and do not cure the overlap).
3. Replace the code-built arm-lock finish (GrappleFinish) with RECORDED GrappleMap frames of the finish (the data has armbar
   positions and transitions - find them in GrappleMapDB / the graph), or hold the landing pose with the tap as a small
   recorded hand motion. No limb placed by hand-tuned code.
4. Contact on the DRAWN skeleton: if the push-out stays, solve it after IK on the bones as drawn, or drop it. Move
   bjj9_probe's overlap bars to the drawn bones (the tremble probe's capsule table).
5. Bars in tools/bjj_tremble_probe.gd, printing one line `BJJTREMBLE failures=<n>` at the end (your RED_TEST), for
   `mode=match match=1`: pooled jerk p95 <= 100 m/s^3 and flips <= 0.3 a second a joint; no joint's p95 over 300; drawn
   overlap p95 <= 0.10 m both ways and the finish+verdict peak <= 0.10 m; worst one-frame step <= 0.15 m in every phase.
   The probe must give the same numbers when run without `--fixed-fps 30` (step a fixed 1/30 s internally if needed).
6. tools/belt_match_film.gd: add `root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP` where it sizes the root
   (S379: films cut ~65 px off each side otherwise - see tools/judge_film.gd).
Then Argon's verdict (now on a BJJ prompt that looks for trembling and bodies inside bodies first; either caps the score at 4).

You cannot run Godot: use only methods that exist in Godot 4.7 on that exact type. Keep every file under 500 lines.

## Last verdict (round 14: Argon 3 -> -1/10 on cursor/bjj9r14; DROPPED - worse or a check failed; you start from the round before)

Not filmed: your round did not compile (even after one repair pass), so the game could not start. Godot printed:
- res://scripts/ui/MatPlayer.gd:10: Could not preload resource script "res://scripts/grapple/GrapplePose.gd".
- res://scripts/ui/MatPlayer.gd:10: Could not resolve script "res://scripts/grapple/GrapplePose.gd".
- res://scripts/ui/MatPlayer.gd:10: Cannot infer the type of "Pose" constant because the value doesn't have a set type.
- res://tests/grapple_pose_test.gd:8: Could not preload resource script "res://scripts/grapple/GrapplePose.gd".
- res://tests/grapple_pose_test.gd:8: Could not resolve script "res://scripts/grapple/GrapplePose.gd".
- res://tests/grapple_pose_test.gd:8: Cannot infer the type of "Pose" constant because the value doesn't have a set type.
- res://scripts/grapple/GrappleDrawn.gd:7: Could not preload resource script "res://scripts/grapple/GrapplePose.gd".
- res://scripts/grapple/GrappleDrawn.gd:7: Could not resolve script "res://scripts/grapple/GrapplePose.gd".
- res://scripts/grapple/GrappleDrawn.gd:7: Cannot infer the type of "Pose" constant because the value doesn't have a set type.
You cannot run Godot - use only methods that exist on that exact type in Godot 4 (Array has any()/all(); PackedStringArray does not).

## 1) Trembling / jitter
- **Tight sheets show no tremble.**
  - 0:28.7–0:29.2 (turtle, Ana on top, seen from above): heads, hands and torsos are still from frame to frame. Only a slow drift of the shadow.
  - 0:57.6–0:58.1 (Ana on top in Kim's guard): Kim's wrapping leg and Ana's posted right arm move slowly in one direction, with no back-and-forth.
  - 1:26.5–1:27.1 (mount into half guard): both bodies hold steady. The heads at the left edge don't twitch.
- **Normal sheets:** I saw no back-and-forth in any limb. At 0.2 s spacing, though, fast tremble can't be seen, so these sheets neither confirm nor rule out jitter.
- On what I can see, the anti-trembling part of the change works.

## 2) Bodies inside bodies
- **0:20.0–0:23.0 (guard, "Kim: To Arm Lock")**
  - From 0:21.4 to 0:22.0, Kim's forearms go into Ana's chest. They don't wrap around it. Depth: half a forearm.
  - From 0:22.4 to 0:23.0, Kim's head is buried in Ana's chest and neck. Depth: about half the head.
- **0:40.8–0:42.4 (guard, Ana on top, "Kim: Hip Bump")**
  - Kim's blue torso shows through the middle of Ana's red shorts and hips. The two pelvises share the same space. Depth: half a torso.
  - At 0:42.0–0:42.2 a dark arm comes out from under Ana's hips, at a spot where only the inside of the merged pelvis could be.
- **0:50.0–0:51.0:** Kim's blue top pokes through Ana's flank. Kim's head sits cheek-inside-cheek with Ana's head. Depth: surface to half a head.
- **1:00.8–1:03.0:** Kim's blue shorts show through Ana's torso. Depth: half a torso.
- **1:12.4–1:13.0 (Kim in Ana's guard)**
  - Kim's shin and thigh sink into Ana's hips.
  - Ana's face disappears into Kim's arm and shoulder. Depth: half a limb or half a head.
- **1:20.0–1:20.6:** the two pelvises are fused, with blue and red shorts in the same place. Depth: half a torso.
- **1:52.2–1:53.0:** Ana's red-tights thigh goes into Kim's shoulder and upper back instead of wrapping over it. Depth: half a limb.
- **Possibly fully inside, but I can't confirm:**
  - At 0:10–0:13 (side control, Kim on top), Ana's head and upper torso never appear. Only her hips and legs show.
  - At 1:40.8–1:43.0 (turtle, Kim on top), Ana's head and shoulders never appear.
  - In both, Kim is low enough that Ana's upper body would have to be under her or inside her. The camera angle doesn't let me tell which.
- **Mat:** I saw nothing sink into the mat.

## 3) Popping, freezing, flung limbs
- **0:02.2–0:02.8:** the "leg mousse takedown" turns into a cartwheel. At 0:02.4 Kim is fully upside down over Ana, and Ana's head is on the mat under her. At 0:02.6 both are tumbling with Ana's legs in the air. Nothing in it reads as a single leg.
- **0:40.4–0:43.0:** Kim's leg points stiffly straight up behind Ana and stays there for about 2.5 s with no reason. It looks like a frozen puppet pose.
- **1:01.0–1:03.0:** a pair of legs swings up and locks vertical, then holds rigid for 2 s.
- **1:10.0–1:11.2:** the wrestlers are suddenly standing about 2 m apart, right after the panel showed "Ana: Tap – missed" (it reads "Guard – Ana on top. Ana: Tap – missed"). This looks like a reset; the actual cut falls before 1:10, outside the sample.
- **1:11.4:** Ana tips backward stiff as a plank to pull guard.
- **1:51.0–1:51.6:** Ana's leg is flung straight up.
- **No single-frame jumps were visible on the tight sheets.**

## 4) Is it real BJJ?
- **Readable:**
  - Standing grip fight, 0:00–0:01.2.
  - Turtle with the top player draped on the back, 0:28.7–0:33.0. The weight sits on the hips and shoulders believably.
  - Mount, 1:22.4–1:27.1. Chest to chest, and the top weight looks real.
  - Old-school sweep roll from half guard, 1:31.4–1:33.0. Kim comes up on top, more or less as the technique goes.
- **Not readable:**
  - The takedown at 0:01.4–0:02.8 is a flip, not a single leg.
  - "Arm Lock" at 0:20–0:23: Ana sits upright with a hand posted on the mat while supposedly playing guard. No arm is isolated.
  - "Ana: Lock – In" at 1:02.6: Ana is on her knees and Kim lies on her back with legs straight up. That isn't an armbar. Ana isn't on her back, no straight arm is between her legs, and no legs are across Kim's chest. A tap is never shown.
  - "Reverse Technical Stand Up – In" at 1:50–1:53: Kim never stands. She stays kneeling inside Ana's high legs.
- **No finish appears anywhere** in the sampled footage. The score goes 2-0, then 6-0, then 6-2 on points.
- **Weight:** in the guard scenes (0:40, 0:50, 1:00, 1:20), the top woman's hips sit inside the bottom woman's hips instead of resting on them. Her weight doesn't press down; it overlaps.

## 5) Worst 5 and best 3
**Worst:**
1. **0:40.8–0:42.4:** the pelvises are merged and Kim's leg is frozen straight up.
2. **1:01.0–1:03.0:** "Lock – In" with stiff vertical legs and a kneeling attacker. Not an armbar, and Kim's shorts show through Ana's torso.
3. **0:02.2–0:02.8:** the cartwheel takedown.
4. **0:22.4–0:23.0:** Kim's head buried in Ana's chest.
5. **0:10–0:13 and 1:40.8–1:43:** Ana's whole upper body never appears under Kim.

**Best:**
1. **1:26.5–1:27.1:** steady, heavy mount with no tremble.
2. **0:28.7–0:33.0:** clean turtle ride, still and believable.
3. **0:00–0:01.2:** the standing grip fight is smooth and natural.

## 6) Verdict
Holds are now steady and I saw no trembling. But half-deep overlaps of hips and heads are in nearly every guard scene, the takedown is a cartwheel, and the "Lock" and "Stand Up" don't match their names. It is still far from 9/10.

Score: 4/10

## 1) Trembling / jitter
- **0:29.7–0:30.3 (tight): the top woman in red, hands and forearms. Probable jitter.**
  - 0:29.7: her forearm is behind the head of the bottom woman in blue.
  - 0:29.8–0:29.9: both hands are on blue's chest.
  - 0:30.0: her hands are out to the sides.
  - 0:30.1–0:30.2: her hands are back on blue's chest.
  - 0:30.3: her hands are out again.

  The hands go back and forth like this within about 0.5 s while she holds a top position, and her shoulders barely move. That is a back-and-forth twitch, not one smooth reach. The shapes are small at sheet resolution, so this is "likely", not certain.
- **0:59.8–1:00.3 (tight): no clear tremor.** Blue's raised legs and the tangle stay steady. Her raised foot shifts a little and looks smooth.
- **1:29.8–1:30.3 (tight): no tremor in the torsos.** Red's legs sweep smoothly from kneeling into a wide, frog-like crouch. That is a real motion, not a shake.

## 2) Bodies inside bodies
- **0:02.4–0:03.0:** red's head is buried in blue's shoulder and chest during the leg-weave takedown. About **half a head** deep.
- **0:12.0–0:13.0:** red's shin and knee cross blue's thigh and hip while blue sits up. About **half a limb** deep.
- **0:21.4–0:23.0 (turtle ride):** red's chest sinks into blue's lower back. A **surface touch to half** deep.
- **0:29.7–0:30.3:** red's chest and belly overlap blue's chest. About **half** deep.
- **0:31.2–0:33.0: worst of these.** Red sits upright and her hips and thighs disappear into blue's chest and shoulders. Blue's head and upper back are under or inside red's pelvis. That is **fully inside**, held for about 2 s. The banner says "Knee on Belly", but no knee is visible.
- **0:40.0–0:42.0:** red's head and face are pressed into blue's shoulder. About **half a head** deep.
- **0:50.0–0:51.8:** blue's head and arm go into red's side and ribs. Blue's head is at mat level, inside red's torso line. About **half to full head** deep.
- **0:59.8–1:03.0:** red's torso and blue's pelvis share the same space. At 1:02.6–1:03.0 red's head is in blue's chest. **Half to fully inside.**
- **1:21.6–1:23.0 (hip bump):** red's pelvis is buried in blue's back, and blue's head and shoulders vanish under red. **Fully inside.**
- **1:29.8–1:30.3: fully inside.** Standing "Broomstick": the two torsos fill the same volume, and blue's shirt shows through red's back.
- **1:32.4–1:33.0:** blue's head merges into red's head and shoulder. About **half** deep.
- **1:51.6–1:53.0:** the same hip-bump clip as 1:21: red's hips are inside blue's back. **Fully inside.**

## 3) Popping and freezing
- **0:52.0: big pop.** From 0:51.8 to 0:52.0 (one 0.2 s step), blue jumps from lying on red to about one body height above her, hanging in the air. She is still airborne at 0:52.2, slams down at 0:52.4, and her legs fly up at 0:52.6–0:53.0. The banner says "Shrimp Escape – missed".
- **0:59.8–1:02.4: frozen puppet stretch.** Blue's legs stay straight up in the air for about 3 s, for no grappling reason.
- **1:12.6–1:13.0 and 1:42.6–1:43.0:** red falls backward stiff as a board while nobody touches her. It's the same canned guard pull both times.
- **1:30.2–1:30.6:** red's feet leave the mat, and the pair hang above their own shadow while "standing".
- **1:20–1:23 and 1:50–1:53:** the hip-bump clip plays twice, almost frame for frame.

## 4) Is it real BJJ?
- **Grip fighting and takedown, 0:00–0:03: recognisable.** Collar tie, level change, leg attack.
- **Turtle ride, 0:20–0:23: recognisable.** Red's weight is on blue's back.
- **Sweep, 0:40–0:43: roughly readable.** One woman sits in the other's guard and gets tipped over.
- **Honey hole, 0:10–0:13: not readable.** No inside triangle on the leg.
- **Knee on belly, 0:30–0:33: not readable.** Red sits *inside* blue instead.
- **Hip bump, 1:21 and 1:51: not readable.** There's no bump, just one woman merged onto the other's back.
- **Back take after the Broomstick, 1:30–1:33: not readable.** It looks like a ball rolling, not hooks going in.
- **Finish: not seen.** None of the sampled bursts show a finish or a tap.
- **Weight:** red's weight on blue looks right at 0:20–0:23. Elsewhere, weight sinks *into* the other body (0:31, 1:21) or floats above the mat (0:52, 1:30).

## 5) Worst 5 / Best 3
**Worst:**
1. 0:52.0: blue pops a body height into the air and hangs there.
2. 0:31.2–0:33.0: red's hips fully inside blue's chest, held for 2 s, labelled knee on belly.
3. 1:29.8–1:30.3: two standing torsos fused into one, both floating off the mat.
4. 1:21.6–1:23.0 and again 1:51.6–1:53.0: hip bump with red's pelvis buried in blue's back.
5. 0:29.7–0:30.3: red's hands probably twitching back and forth while she holds the top position.

**Best:**
1. 0:00.0–0:01.4: clean, believable collar-tie hand fighting with good stances.
2. 0:20.0–0:23.0: a legible turtle ride with the weight on the back.
3. 1:10.6–1:12.2: a natural reset as both women stand and square up.

## 6) Verdict
The standing exchanges are good. On the ground, though, bodies are still fully inside each other in several places, there's a big mid-air pop, and probable hand jitter at 0:30. This change does not reach its goal of a match without trembling or bodies inside bodies, let alone 9/10. The rule caps the score at 4, and it lands below that cap.

Score: 3/10

## Contract
OWNS: scripts/grapple/, scripts/rules/BjjMatch.gd, tools/bjj9_probe.gd, tools/bjj_tremble_probe.gd, tools/belt_match_film.gd
RED_TEST: tools/bjj_tremble_probe.gd -- show3d mode=match match=1 -> BJJTREMBLE failures=0
REGRESSION: grapple_pose_test, grapple_contact_test, grapple_timing_test, golden_path_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/belt_match_film.gd -- match=1 secs=120
BASE: claude/bjj9base
LOOP: BJJ9 9

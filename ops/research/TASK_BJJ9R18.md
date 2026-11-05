# TASK BJJ9R18 - ANTIGRAVITY (Gemini 4 Argon High) - the BJJ belt match without trembling or bodies inside bodies, to 9/10

OPERATOR SCORE (S387, C235 on BJJ9R16's after.mp4, 2026-11-05: "pretty good i would give it 7.5"). His eye outranks every judge.
Your BASE is now cursor/bjj9r16, the round he scored, NOT claude/bjj9base. Keep what R16 does. Do not rebuild it. R17 was dropped
(its probe crashes at GrappleBrowser.gd:89). Remaining work on R16: the 0:02 cartwheel after the takedown, the legs that stay
pointing up around 0:41-0:47, and bodies overlapping in the holds. Any round that looks worse than R16 to him is a failed round.

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

## Last verdict (round 17: Argon 3 -> 4/10 on cursor/bjj9r17; DROPPED - worse or a check failed; you start from the round before)

# JUDGE: Claude claude-opus-5-5 on 15 eyes contact sheets (BJJ9R18 after) - Gemini prepay out, S380 operator: "Judge by Claude's eyes"

# BJJ9R18 "after" review: 15 contact sheets

**Coverage:** I opened all 15 sheets. They cover about 37.5 s of the roughly 1:53 film, so I saw nothing from 0:03–0:10, 0:13–0:20, 0:23–0:28, 1:03–1:10 and similar gaps.

**Limits of the sheets:**
- The frames are small, so I can't rule out a shake of only a few pixels.
- Only the three `_tight` sheets can show jitter, and they cover just 1.5 s.
- From the gas bars I take Ana as orange and Kim as blue. With that reading, the "on top" labels match the picture.

## 1) Trembling / jitter
- **0:28.3–0:28.8 (turtle hold):** no shake in heads, hands, feet or torsos. Only slow camera drift.
- **0:56.9–0:57.4 (guard, sweep attempt):** Ana's posting arm and hand move smoothly, with no back-and-forth.
- **1:25.5–1:26.0 (mount, flattened):** Kim's arms across Ana's back and both pairs of feet stay steady.
- **Wider sheets:** I saw no twitching in the holds at 0:22.4–0:23.0, 1:01.0–1:03.0 or 1:51.0–1:53.0, but 0.2 s spacing can't prove there is none.

**Result:** no visible trembling in what I was shown. This is the clearest gain, though it only rests on those 1.5 s.

## 2) Bodies inside bodies
No body is provably fully inside the other. Several moments can't be separated from simple occlusion, and those are marked.

| Time | What | Depth |
|---|---|---|
| 0:01.6–0:02.0 | Ana's head and shoulder pressed into Kim's midsection during the shot | Surface to shallow |
| 0:10.0–0:13.0 | Ana's head never appears under Kim; her hips and torso show as an orange mass | Camera hides it, depth unknown |
| 0:21.6–0:23.0 | Kim's head and forearm against Ana's chest | Surface to shallow |
| 0:32.4–0:33.0 | Kim's blue torso shrinks to a sliver under Ana | Possibly half a torso, or occlusion |
| 0:41.0–0:42.2 | Ana's pelvis sits over Kim's torso, with only a blue edge showing | Possibly half a torso, or occlusion |
| 0:50.0–0:52.4 | The two heads overlap in view | Camera hides it |
| 0:57.1–0:57.4 | Kim's leg meets Ana's hip with a dark ring at the junction | Looks about half a limb |
| 1:12.2–1:13.0 | Ana's torso under Kim's hips | Half-depth at most, unclear |
| 1:32.0–1:33.0 | Tangle of dark limbs around Ana's hips; I can't tell whose is whose | Unreadable |
| 1:42.2–1:42.8 | Ana's orange almost vanishes under Kim | Possibly half a torso, or occlusion |
| 1:51.0–1:53.0 | Ana's raised thigh runs into Kim's hip and back line | Surface to half a limb |

## 3) Popping and freezing
- **0:01.2→0:01.4:** the gap between them closes in one sample, and the body jumps forward into the shot.
- **0:02.2→0:02.8:** Kim turns upside down fast and the whole pair tumbles. The motion is continuous but reads as flung.
- **0:40.8–0:42.2:** Kim's legs hang in the air, nearly fixed, for about 1.4 s. That is a puppet hold.
- **1:00.0→1:00.6:** Kim's legs swing from about horizontal to vertical, then stay stiff through 1:03.0.
- **1:10.2–1:10.8:** Ana falls backward from standing with nobody touching her.
- **1:10.6→1:10.8:** Kim goes from standing clear of Ana to kneeling at her legs in one sample. This is the biggest jump in the film.
- **1:11.2–1:13.0:** Kim's leg is thrown up and sits in the air with no job to do.
- **1:30.8→1:31.0:** Kim's stretched body snaps to a crouch, and Ana's torso and arm appear in a new place.
- **1:42.8→1:43.0:** an orange shape suddenly appears behind Kim.
- **1:51.0–1:53.0:** the finish is practically frozen.
- **Mesh note (0:11.8–0:12.8, 0:52.0–0:53.0, 0:57, 1:50–1:53):** hips and shorts bulge like balloons under deep flexion.

## 4) Is it real BJJ?
- **Takedown (0:01–0:03):** labelled a leg weave, but it looks like an over-the-shoulder flip with Kim inverted at 0:02.4. There is no leg entanglement. The half guard landing at 0:03.0 is believable.
- **Side control (0:10–0:13):** weak. Kim is on knees and hands with Ana's hips propped high and both of Ana's knees up, so it isn't chest-to-chest. There is little crossface or hip pressure, and it looks more like a leg entry.
- **Guard (0:20–0:23):** decent. Ana's leg wraps Kim's back and her sit-up on a posted arm suits a hip bump.
- **Turtle (0:28–0:33, 1:40–1:42):** the best BJJ in the film. The top woman's weight really sits on the bottom one, and the bottom woman's base and arms look right.
- **Guard (0:50–0:53, 0:57):** fair. Ana's upright posture works, and Kim's leg hooking the hip is sensible apart from the overlap.
- **"Lock-In" (1:00–1:03):** Kim's legs point straight up beside Ana. It's unclear what is locked, because nothing clamps the head or arm.
- **Mount (1:21–1:26):** the weight sits properly on Kim and her arms around Ana's back are believable, but Kim's legs are hard to read.
- **Finish (1:50–1:53):** it fails.
  - The panel gives Kim the omoplata win at 1:52.4, yet Kim is on hands and knees on top while Ana lies on her back with her thigh up.
  - A real omoplata has the attacker's legs over the shoulder, the opponent driven face down and the arm bent behind her back. None of that is shown.
  - No tap is visible, and Kim's body blocks the camera's view of the arm.

## 5) Moments

**Five worst:**
1. **1:50–1:53:** the omoplata win has no recognisable lock, no tap and a frozen ending.
2. **1:10.2–1:10.8:** Ana falls untouched, then Kim teleports to her legs.
3. **0:02.2–0:02.8:** a "leg weave" plays as an acrobatic flip.
4. **0:40.8–0:42.2 (and 1:00.6–1:03.0):** stiff legs float in the air.
5. **1:30.8→1:31.0:** a snap between poses, followed by an unreadable limb tangle through 1:33.

**Three best:**
1. **0:28.3–0:31.0:** the turtle ride has real weight, is steady and reads instantly.
2. **1:40.0–1:42.0:** a second clean turtle ride, with a clear top and bottom.
3. **1:25.5–1:26.0:** the flattened mount is still and heavy, with believable arms around the back.

## 6) Verdict
The trembling looks fixed and the control positions now carry weight, but pops, floating legs, possible half-depth overlaps and a finish that isn't an omoplata keep it far from 9/10.

The cap did not decide this score, because I saw no trembling and no proven full penetration.

Score: 4/10

## 1) Trembling / jitter
- **0:29.7–0:30.3 (tight, turtle hold):** no visible shaking. Heads, hands and feet stay put across all 16 frames.
- **0:59.8–1:00.3 (tight, Ana riding Kim's back):** no visible shaking. Ana's raised knee and hovering foot hold steady, and Kim's hands stay planted.
- **1:29.8–1:30.3 (tight, chest-to-chest pile):** no back-and-forth shaking. Ana's forearm drifts slowly from 1:29.8 to 1:30.2, but in one direction only, so it is not a tremble.
- **Normal sheets:** no clear back-and-forth limb motion between frames 0.2 s apart. I can't rule out fast jitter during movement, because these sheets are too coarse to show it.

**Result:** no visible trembling in any of the material I can judge. On this point the change looks like it worked.

## 2) Bodies inside bodies
This is the big remaining failure. It happens in almost every grounded position.
- **0:01.4–0:01.8, takedown entry:** the heads and upper bodies merge. About half a torso is inside the other woman.
- **0:10.0–0:13.0, side control with Kim on top:** Ana's whole torso shows only as a red lump through Kim's hips and belly, so she is **fully inside**. From 0:11.8 to 0:12.8, Kim's arm passes through Ana's body.
- **0:20.0–0:21.6:** Ana dives over the kneeling Kim, and Kim's arm and head go through Ana's chest (half a limb to a full head). From 0:22.0 to 0:23.0, Kim's head is buried in Ana's torso.
- **0:29.7–0:33.0, turtle:** the two heads sit almost in the same spot. Kim's back shows only as a blue patch through Ana's torso, so Kim's torso is **fully inside** Ana's torso.
- **0:40.0–0:43.0:** Ana's hips and seat sink into Kim's body, with only scraps of blue showing. This is half to fully inside.
- **0:50.0–0:51.4:** Ana's shorts swallow Kim's torso, and Kim's leg comes out through Ana's thigh. From 0:52.2 to 0:53.0, Ana sits down *into* Kim's pelvis, about half deep.
- **0:59.8–1:00.6:** Ana's hips are sunk into Kim's back, about half deep. From 1:01.6 to 1:02.8, the heads merge and arms pass through bodies.
- **1:21.4–1:23.0:** Kim almost disappears inside Ana. At 1:22.0–1:22.2 only one blue leg sticks out, so Kim is **fully inside**.
- **1:29.8–1:31.4:** Ana's chest sits through Kim's torso, half to fully inside.
- **1:40.0–1:41.6:** Kim is hidden inside Ana's back and hips. From 1:42.4 to 1:43.0, the two heads occupy the same space.
- **1:50.0–1:51.8:** Ana's back lies *inside* Kim's body. From 1:52.8 to 1:53.0, the heads merge again.
- **Mat:** I saw no clear sinking into the mat. Knees and hands meet the floor at surface level.

## 3) Popping and freezing
- **0:02.2–0:02.8:** after the leg-weave takedown, both women spin upside down in a cartwheel, legs flung skyward, then land tangled at 0:03.0. This is not a takedown fall. It is the worst pop in the film.
- **0:40.6–0:43.0:** one leg each points straight up and stays there through the whole hip-bump sequence. It looks like a frozen puppet stretch.
- **0:59.8–1:00.6:** Ana perches on Kim's back with one knee drawn high and the foot hovering. She keeps this stiff pose for at least 0.8 s.
- **1:20.0:** both women are suddenly standing apart, right after a ground exchange. It reads as a teleport or reset. I can't see the moment it happens because it falls between sheets.
- **1:31.6–1:32.4:** on Kim's missed sweep, Ana's leg whips overhead like a scorpion kick and her body launches before Kim ends up on top at 1:32.6.
- **1:41.6 → 1:41.8:** the top and bottom roles look different between these two frames. The cut between poses looks abrupt, but I can't tell how fast it was at this sampling.

## 4) Is it real BJJ?
- **Readable:** the standing collar-tie grip fight (0:00–0:01.0), side control (1:10–1:13) and, roughly, turtle (0:29.7).
- **Not readable:** guard, half guard and the guard sweeps (0:20, 0:40, 0:50, 1:22, 1:30, 1:50). They read as piles of merged bodies, not as closed, open or half guard.
- **Takedown:** the "leg weave takedown" (0:01–0:03) ends in an acrobatic flip, not a trip and fall.
- **Submissions:** called but never shown — Kimura ("missed", 0:10), front armbar (1:10), Helicopter (1:41). **No finish and no tap** appear anywhere in the sampled footage. The armbar test (arm straight between the legs, legs over chest and face, hips under the elbow) can't be passed because no armbar is ever shown.
- **Weight:** the top woman's weight does not sit *on* the bottom one. It sinks *into* her (0:10, 0:30, 0:52, 1:30). Only at 1:10–1:13 does Ana visibly kneel and lean on Kim.

## 5) Moments
**Worst 5**
1. **0:30.0–0:33.0:** turtle with Kim's torso fully inside Ana's, and their heads in the same space.
2. **0:10.0–0:13.0:** Ana fully swallowed under Kim in side control, with Kim's arm passing through her.
3. **1:22.0–1:22.2:** Kim vanishes into Ana's lap, leaving a single blue leg.
4. **0:02.2–0:02.8:** a takedown that turns into a double upside-down cartwheel.
5. **0:40.6–0:43.0:** both women with a leg stuck straight up, hips merged.

**Best 3**
1. **1:10.0–1:13.0:** side control. Ana kneels beside Kim and leans on her chest, with only small hand overlaps.
2. **0:00.0–0:01.0:** standing collar-tie grip fight. Clean contact, feet planted, no overlap.
3. **0:29.7 / 0:59.8 / 1:29.8 (tight sheets):** holds stay steady with no tremble, which is the specific thing this change targets.

## 6) Verdict
The trembling looks fixed: none is visible on the three tight sheets. But one body sits fully inside the other in most ground positions (0:10, 0:30, 1:22, 1:50), no technique is shown being finished, and there's no tap. That is nowhere near 9/10. A body fully inside the other caps the score at 4, and the real quality is below that cap.

Score: 2.5/10

## 1) Trembling / jitter
- **The three tight bursts (16 frames each, about 0.5 s)** show no shaking at all. In 0:29.7–0:30.3 (turtle, red riding blue's back), 0:59.8–1:00.3 (red sitting on blue's hips, knee up) and 1:29.8–1:30.3 (blue's legs up over red's back), the hands, feet, heads and torsos either drift smoothly or hold still. There's no back-and-forth twitch. On these samples, the trembling fix looks like it works.
- **Everywhere else** the frames are 0.2 s apart, too far apart to see fine shaking. I see no back-and-forth reversals there, but I can't prove trembling is gone outside the tight bursts.

## 2) Bodies inside bodies
- **0:01.4–0:01.8:** the torsos merge in the clinch; red's chest sinks into blue's front. About half a torso deep.
- **0:02.4–0:02.6:** during the flip, the two inverted bodies overlap, and blue's head looks driven into the mat and into red's hip. Half a limb or more.
- **0:10.0–0:13.0:** blue is on top in side control, but her hips and belly sink into red's torso. Red's arm passes through blue's back from 0:11.6 to 0:12.8. Surface to half a limb.
- **0:20.8–0:21.4:** blue's thigh goes into red's belly. About half a limb.
- **0:31.6–0:33.0:** riding the turtle, red covers almost all of blue. Only blue's head, a hand and a strip of shorts show. From the overhead camera this looks like deep overlap, maybe fully inside, but the angle could be hiding blue underneath red.
- **0:41.0–0:43.0:** in the guard, blue's torso shrinks to a small blue patch inside red's hips. Deep, at least half a body.
- **0:50.0–0:50.6:** blue's leg comes out through red's crotch and thigh while red stands over her. Half a limb.
- **1:02.4–1:03.0:** red falls onto blue, and the chests merge.
- **1:29.8–1:32.4:** in the guard, blue's torso is almost entirely hidden inside red's. Only blue's legs, head and a sliver of shorts show. Deep.
- **1:40.0–1:42.8:** both sitting, and red's back is fused into blue's chest. The heads stack on each other at 1:40.0–1:40.2. Half a body.
- **1:50.0–1:53.0:** red sits upright where blue's chest should be. Blue's head and upper torso never appear in these 3 seconds; only her legs and shorts do. This looks like a body fully inside the other. The camera could be hiding blue behind red, but red sits right over that spot.

## 3) Popping and freezing
- **0:02.2–0:02.8:** a "leg-mouse takedown" turns into a cartwheel. Blue goes fully upside down with her legs thrown overhead, then lands in a tangle. It's the opposite of a controlled takedown.
- **0:10.0–0:13.0:** blue is frozen in a spider stretch, legs splayed wide, barely moving for 3 s.
- **0:40.4–0:41.0:** red's leg is thrown straight up into the air for no reason.
- **0:51.4–0:52.4:** red stands on one leg with the other held out sideways, like a puppet. No reason in BJJ.
- **1:00.0–1:01.4:** red sits on blue hugging her own raised knee. It's a held, unnatural pose.
- **1:20.0–1:22.0:** after a scramble, both are suddenly standing in an idle pose with their hands on their hips. No grappling happens.
- **1:32.6–1:33.0:** on Kim's sweep, red is launched nearly upside down with one leg straight up.
- I see no single-frame jumps in the tight bursts.

## 4) Is it real BJJ?
- The opening collar tie (0:00–0:01) reads as real.
- Side control at 0:10 doesn't. The top woman has her legs splayed in the air and her weight isn't driving into the bottom woman.
- The turtle ride at 0:30 is recognisable from above.
- The front-headlock / side control at 1:10–1:13 is recognisable. Red's head pressure and knees on the mat sit well.
- The jump to guard at 1:22.2–1:23.0 is plausible.
- The takedown, guard (0:40), the standing passes (0:50–0:53) and the sweep (1:32) aren't recognisable as the named techniques. Weight mostly reads as overlap, not pressure.
- There's no finish in the frames I saw. No armbar or other submission is shown, and no tap. The match ends at 8–0 on points.

## 5) Worst 5 / Best 3
**Worst:**
1. **1:50.0–1:53.0:** blue's head and upper body vanish inside red for 3 s.
2. **0:31.6–0:33.0:** blue is swallowed under red in the turtle ride.
3. **1:29.8–1:32.4:** blue's torso is buried inside red in the guard.
4. **0:02.2–0:02.8:** the cartwheel "takedown", with a head into the mat.
5. **0:51.4–0:52.4:** red's one-legged puppet pose with her leg held out sideways.

**Best:**
1. **0:00.0–0:01.2:** clean collar-tie hand fighting, a believable stance.
2. **1:10.0–1:13.0:** a readable front headlock with good knee posts and weight.
3. **0:29.7–0:30.3 and 0:59.8–1:00.3:** rock-steady holds, no tremble at all.

## 6) Verdict
The trembling fix holds in every tight burst. But the bodies still overlap deeply in most ground positions: at 1:50–1:53 blue looks fully inside red, and blue is nearly hidden in red at 0:31–0:33 and 1:30–1:32. The named techniques also don't read as BJJ. The "fully inside" rule caps the score at 4.

Score: 3/10

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
BASE: cursor/bjj9r16
LOOP: BJJ9 9

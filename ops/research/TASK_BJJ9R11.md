# TASK BJJ9R11 - ANTIGRAVITY (Gemini 4 Argon High) - the BJJ belt match without trembling or bodies inside bodies, to 9/10

Status: OPEN (S379, Claude). Operator S379, on Ziva's round-10 film (Argon had said 5/10): "that clip is so terrible, limbs
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

## Contract
OWNS: scripts/grapple/, scripts/rules/BjjMatch.gd, tools/bjj9_probe.gd, tools/bjj_tremble_probe.gd, tools/belt_match_film.gd
RED_TEST: tools/bjj_tremble_probe.gd -- show3d mode=match match=1 -> BJJTREMBLE failures=0
REGRESSION: grapple_pose_test, grapple_contact_test, grapple_timing_test, golden_path_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/belt_match_film.gd -- match=1 secs=120
BASE: claude/bjj9base
LOOP: BJJ9 9

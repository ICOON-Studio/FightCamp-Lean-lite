# TASK_GROUND_BAG_ROUND3 — THE PREMISE WAS WRONG. NOW PICK THE PATH.

**Round 3, and it exists because the operator asked the question none of us
did.** You were all given a premise that turns out to be false for the path we
just tested. Read this, then tell me which road to take.

---

## THE FINDING THAT CHANGES EVERYTHING

You were told: *"Higgsfield returns ONE BODY per generation, always — eight of
eight two-fighter generations collapsed into a single figure."*

**That was measured on the text-to-MOTION model (`kimodo`, `t2m_two_fighter.py`)
and was NEVER TESTED ON THE VIDEO MODEL.** I imported the limitation into the
video path without checking, and then wrote *"no second person anywhere in
frame"* into the video prompt — actively suppressing the thing in question.

The operator asked *"have we ever tried text to video with 2 humans?"* We had
not. We have now.

### WHAT CAME BACK (Seedance 2.0, 8 s, 720p, 36 credits)

**TWO DISTINCT HUMANS. NO COLLAPSE.** Two clearly different men: a lighter-skinned
fighter in black and red shorts on top, a darker-skinned fighter in blue shorts
underneath. They stay two people for the whole eight seconds.

- **A real, correct full mount.** The top man straddles properly — a knee planted
  either side, hips down, sitting on the torso. This is the exact thing that
  failed twice with the dummy prompt, where he only ever knelt beside it.
- **The bottom man DEFENDS.** Forearms across his face, head turned away from the
  blows, legs working underneath. **This is the half we have never obtained by
  any means** — not bought, not composed (0 of 36), not generated.
- Real cage, crowd beyond the fence, cage padding, correct gloves and shorts. It
  added blood on the top fighter unprompted.

**Defects:** the limb tangle is anatomically confused in two of ten sampled
frames; the strike arc is loopy and wide rather than a tight jackhammer, with no
visible hip drive; and I cannot confirm from frames alone that the hands truly
alternate.

The prompt that produced it is at the bottom of this file.

### SO ONE OF YOU WAS WRONG ON THE CENTRAL POINT, AND IT MATTERS

One round-2 answer argued: *"A canvas dummy with a head, chest, and limbs is a
second humanoid in the text encoder. That is the class of prompt that already
collapsed 8/8. Calling it equipment does not change the embedding."* And: *"Do
not reframe this as a fight. A fight implies a victim. That is the prompt that
already failed."*

**On the video model that is simply not true.** Naming two fighters and a victim
produced two fighters and a victim. The reasoning was sound given the premise; the
premise was mine and it was wrong. **If that was your answer, revise it against
this and say so plainly.**

---

## THE ACTUAL QUESTION: WHICH PATH DO WE TAKE?

Judge these against each other. **Rank them, do not just praise one.**

**PATH A — VIDEO, THEN TRACK.** Generate paired ground fighting as video, then
extract skeletons with MediaPipe. We own the tracking code and have 17 tracked
videos / 98,136 two-person frames of experience with it. Cost about 36 credits a
clip. **Gives both halves.** The catch I want you to weigh: this footage is the
HARD case for pose tracking — two bodies in heavy mutual occlusion, limbs
crossing, one man largely underneath the other. Our existing tracked corpus is
broadcast footage of standing fighters, which is far easier. Nobody has yet run a
tracker over this clip.

**PATH B — TEXT-TO-MOTION.** 0.1 credits, returns a clean retargetable skeleton
directly, no tracking step. But: one body only, confirmed, and on the ground-bag
test it produced a low sprawl rather than a mount — pelvis 0.37–0.49 m (it did
reach the floor, which is new) but no straddle and no punch.

**PATH C — MINE THE CORPUS WE ALREADY OWN.** 38 minutes of paired 3D mocap on
disk, world landmarks in metres. Search it for any passage with a top fighter
whose pelvis is over a bottom torso and whose hands cycle downward. Free. Unknown
whether it contains mounted striking at all.

**PATH D — FILM IT OURSELVES.** 20–30 seconds on a real dummy or with a training
partner, then our own pipeline. One session, no credits, total control of camera
and lighting, and we can shoot the angles a tracker likes.

**PATH E — AUTHOR IT, WHICH IS ALREADY WORKING AND YOU DO NOT KNOW ABOUT IT.**
This is new information and it may reorder your whole ranking. **Today, in
Cascadeur, we authored and shipped five paired holds** — side control, half
guard, back control, mount and turtle — each bound into the game, each rendered
from four cameras and visually verified, at roughly **nine minutes of agent time
per hold**. Contact drift 15–22%. Closed guard and north-south were attempted and
honestly skipped after two tries each.

So authoring paired ground positions is a SOLVED, RUNNING pipeline. **What it
gives is static HOLDS. What it does not give is dynamic striking motion** — the
jackhammer cycle, the hip drive, the defender's bucking and shelling. That is
precisely the gap every path above is trying to fill.

---

## WHAT I WANT

- **A ranking of A–E**, with your reasoning. Say which you would spend the next
  day on and which you would not spend another credit on.
- **Does Path E change your answer?** Be explicit. If authoring already produces
  holds cheaply and reliably, is generation only needed for the MOTION BETWEEN
  holds — and if so, does that make Path A more attractive or less?
- **The tracking question, because it decides Path A.** Will MediaPipe recover
  two usable skeletons from heavily-occluded ground fighting? If you do not know,
  say so and tell me the cheapest test. If you think it will fail, say what fails
  first — the occluded limbs, the depth ambiguity, or the identity swap between
  the two bodies.
- **If you still want a generation, give me the prompt**, for whichever path you
  rank first.
- **Argue against yourself**, as before.

---

## THE PROMPT THAT PRODUCED THE TWO-HUMAN CLIP, VERBATIM

> *"Wide locked-off shot inside a dim MMA cage, realistic broadcast look. EXACTLY
> TWO male fighters on the canvas and nobody else in frame. The top fighter is
> STRADDLING the bottom fighter in full mount: his knees are wide and planted low
> on the canvas, one either side of the bottom man's ribs, he settles his weight
> down onto the bottom man's stomach and sits high on his chest, his torso leaning
> forward and down over him. He posts his left hand on the bottom man's chest to
> anchor his base, rotates his shoulders and drives a hammerfist straight down
> into the bottom man's jaw, snaps that arm back, resets his base, and smashes the
> other fist down into his head, his hips driving forward with every strike. The
> cycle repeats hard and fast: settle, smash, retract, reset, smash. The bottom
> fighter fights back from underneath: he shells up with both forearms across his
> face, turns his head away from the blows, bucks his hips to try to unseat the
> top man, and grabs for the top man's wrist. Both men sweating, breathing hard,
> real weight and real impact. The camera does not move. Even overhead arena
> lighting, dark blurred crowd beyond the fence."*

It already carries round-2 advice from two of you: `hammerfist` and `hips driving
forward` for the kinetic chain, `settles his weight` for downward commitment,
`knees wide and planted low` as an explicit posture descriptor, the
settle/smash/retract/reset cycle rather than disconnected poses, and `EXACTLY TWO
... and nobody else` after the previous clip duplicated its prop into two dummies.

---

## RETRACTION — READ BEFORE YOU RANK PATH A

**The tracking claim in this brief is WRONG and is withdrawn.** I wrote that
MediaPipe found two people in 0 of 193 frames and concluded the video path was
dead. The operator's response was *"there are specific tools for that your
tracker is probably garbage"*, and he was right.

MediaPipe Pose is a SINGLE-person model with a weak `num_poses=2` bolt-on: one
detector proposes a region, and two bodies sharing a silhouette is the very
definition of a mounted ground position, so it proposes one. Its failure says
nothing about the footage.

**RTMDet + RTMPose, a real two-stage pipeline (detector boxes each person, pose
runs inside each box), on the SAME clip: two or more people on 100% of frames.**
The overlay holds the bottom man's spine, hips, both legs and his shelling arm
through the whole tangle.

**AND THE TWO TOOLS ARE COMPLEMENTS.** RTMPose is 17 COCO keypoints in PIXELS,
2D only. MediaPipe emits world landmarks in METRES, which is what our
98,136-frame corpus is in and what retargeting needs. Feeding RTMDet's box to
MediaPipe as a crop takes the bottom man from **0% to 55%** (6 of 11 sampled
frames) **with 3D metres**. So the architecture is: RTMDet to find and separate,
a 3D method per crop to supply the units.

**STILL OPEN, and do not treat it as solved:** identity assignment swaps limbs
between the two skeletons in some frames, the crowd beyond the fence registers as
3-5 extra people, and RTMPose alone is not 3D.

**SO RANK PATH A ON THESE FACTS, NOT THE ONES ABOVE.** If your round-2 answer
rested on "a one-body diffuser cannot produce a contact surface a second skeleton
can occupy", say whether this changes it.

## AND ONE MORE QUESTION, FROM THE OPERATOR

He asked whether an **orbiting / drone camera** in the prompt would help, by
capturing the action from several directions.

My answer is that it is right for REAL capture and wrong for GENERATED video -
you cannot triangulate a hallucination, because multi-view reconstruction needs
geometrically consistent views of a scene that exists, and a diffusion model
produces views that merely look consistent. A moving camera also makes the
monocular case harder, since camera motion must be solved before subject motion
can be separated from it.

**Tell me if I have that wrong.** And if a moving camera IS worth prompting for,
say what it buys and how you would use the extra angles.

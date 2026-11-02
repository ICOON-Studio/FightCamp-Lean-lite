# TASK_G76 — GROK — TWO MEASURED FAILURES: WHY, AND WHAT TOOLS OR PREFABS WE HAVE NOT TRIED

**Research. No code, no repo.** Research/Expert mode, NEVER Build. Owner: grok. Assigned S59, 2026-09-23 (operator:
"send him the results and the prompts to find why this happens, check if there are other tools we have not
considered yet, any prefabs that could help us").

## Owned files

- `research/G76_TWO_FAILURES_AND_WHAT_ELSE.md` - Claude saves your answer here.

## CONTEXT

A fight-sim game needs animation for 534 techniques; 158 have a clip. Two-person GROUND grappling is the wall. We
author static paired HOLDS in Cascadeur (works, ~9 min each). We generate reference VIDEO with Higgsfield
(Seedance 2.0/2.5) and try to extract 2D pose with RTMDet + RTMPose (rtmlib/ONNX), then 3D metres with MediaPipe on
each person's crop. Engine is Godot 4. We also own Reallusion Character Creator 5 (trial), iClone 8, Reallusion's
free "Video Mocap" plugin, Cascadeur Pro, Blender 5.2, Rokoko Studio.

## FAILURE 1 — TWO BODIES MERGE IN WRAPPED GROUND POSITIONS

Operator's idea: ONE video frame split into panels, each a different fixed camera, all showing the SAME instant.
Built by generating a checked split-screen still (gpt_image_2_5) then animating it (Seedance 2.0, start image).
Tracker counted only fighter-sized people (>25% of panel), then a top/bottom identity-swap rate:

| clip | panel | both fighters found | identity swaps |
|---|---|---|---|
| full mount, ground strikes (2x2) | side left | 92.7% | 5.8% |
| full mount (2x2) | side right | 100% | 3.6% |
| full mount (2x2) | overhead | 9.8% | - |
| full mount (2x2) | end-on | 3.6% | - |
| closed guard, kneeling (1x2) | side left | 36.8% | 11.8% |
| closed guard (1x2) | side right | 39.9% | 6.9% |
| single-camera mount | side | 21% | - |

Prompt that produced the closed-guard clip (animation step), verbatim:
> "Continue from the start image: a professional MMA broadcast replay, 1x2 split screen, two locked-off side cameras
> filming the SAME two athletes at the SAME instant from opposite sides. Keep the two-panel layout and the thin black
> divider for the whole clip; neither camera moves or changes angle, and both panels stay in perfect sync. Standard
> MMA closed-guard exchange: the bottom athlete in blue shorts keeps his legs wrapped around the top athlete's waist
> with his ankles crossed and locked behind his back the whole time. He pulls the top athlete's head and wrists down
> to break his posture; the top athlete in black shorts pushes back up to sit tall on his knees, frees a hand and
> throws short controlled strikes to the body, then is pulled down again. Both knees of the top athlete stay on the
> canvas. Exactly two athletes. No text, no logos."

## FAILURE 2 — TEXT-TO-MOTION CANNOT MAKE A SOUTHPAW

Higgsfield text-to-motion (ARDY `kimodo`, one body, 0.1 credit/job, cskel27 skeleton, returns posed joints in metres).
16 jobs, 4 seeds each. Measured on the skeleton: (left foot - right foot) along the root heading. **Every clip starts
AND ends left-foot-forward (+44 to +70 cm)**, including clips told to START southpaw. The metric was validated on a
known orthodox jab clip (+61.5 cm, left hand travels 65 cm). Prompts, verbatim (timeline = stance 1.0 s, move ~0.9 s,
settle 0.8 s; one period per shot):
- "A fighter stands in an orthodox fighting stance, left foot forward, hands up by his chin." ->
  "The fighter switches stance in place with a quick small hop, his left foot sliding back and his right foot sliding
  forward, hands staying up the whole time." -> "A fighter stands in a southpaw fighting stance, right foot forward,
  hands up by his chin."
- The same starting in southpaw (s2o), and a step-through ("brings his rear right foot through past his left foot so
  it lands in front, turning his hips").
- v2, stance never named: "The fighter jumps a few centimetres off the floor and lands with his feet swapped, so his
  right foot is now in front and his left foot is now behind, his chest turning to face the other way." -> "The fighter
  stands with his right foot in front and his left foot behind, hands up by his chin." **Still 0/4.**

(We then authored the switch by hand in Cascadeur with an exact mirror - solved. The question is WHY the model can't.)

## WHAT I WANT

1. **Why failure 1 happens**, and whether any 2D/3D multi-person method handles heavy two-body occlusion better:
   e.g. whole-body/mesh recovery that models interaction (two-person SMPL fits, contact-aware methods), video trackers
   with identity memory, depth-aware or segmentation-first pipelines. For each: what it is, licence (commercial use?),
   runs locally on Windows + one NVIDIA GPU or not, and published numbers on CLOSE-CONTACT two-person data
   (grappling, wrestling, hugging, dance). Name the datasets such methods are measured on.
2. **Why failure 2 happens** - is it a training-data bias (most mocap is orthodox/right-handed), a canonicalisation
   step (mirroring to one handedness), or something else? Is there any text-to-motion or motion-generation model that
   accepts a POSE constraint or keyframe so the stance can be forced? Is left-right mirroring of generated output a
   standard, safe practice?
3. **Tools we have not considered.** Video-to-mocap services and local tools (single- AND multi-person), marker-less
   capture from 2-4 phones (we can film ourselves), and whether Reallusion's own "Video Mocap" / AccuPOSE handle two
   people. Price, output format (FBX/BVH), and whether the output may ship in a commercial game.
4. **PREFABS.** Ready-made animation packs or paired-animation assets for grappling/MMA/wrestling/BJJ we could BUY:
   Unreal Marketplace/Fab, Unity Asset Store, ActorCore, Mixamo, RamsterZ (we already own some), mocap studios selling
   MMA libraries. For each: what positions/transitions it contains, whether it is PAIRED (both fighters' animation from
   one capture), skeleton, price, licence. **We already know a paired BJJ positional pack "is not a SKU anywhere" from an
   earlier survey - search for the THING (e.g. "mount escape paired animation", "wrestling takedown two character
   mocap", "ground and pound paired"), not the category.**

## RULES

- Every number: measured (source, N) or your judgement. A section **WHAT I COULD NOT FIND**.
- **ARGUE AGAINST YOURSELF**: what is the strongest case that the answer is "stop generating, film it ourselves"?
- Female fighters never fight males; the facility is a "gym", never a "camp".

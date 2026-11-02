# OPINION BRIEF - how do we stop fighters' bodies teleporting, PERMANENTLY?

Asked of EVERY agent, blind to each other (operator, 2026-09-23: "ask everyones opinion how to fix
this permanently"). Opinion + design, no code. Claude saves each answer to
`research/OPINION_TELEPORTS_<AGENT>.md`.

## The game
A career MMA/boxing management sim. Fights are simulated by a tick ENGINE (2D ring positions,
facings, who throws what, grapple seats) and shown in 3D in Godot 4.7. Each fighter is a skinned
character playing motion-capture CLIPS (jab, hook, reactions, walks, paired grappling holds where
two bodies were captured together). The 3D "room" reads the engine and places the two bodies.

## The defect, measured (60 Hz probe over whole rounds)
It is NOT frame rate (0 transitions missed at 30 fps) and NOT mainly blend length (doubling
blends or switching to inertialization barely moved it: 75 -> 71 events). It is BODY TELEPORTS:
a fighter's root moves > 0.10 m or turns > 15 deg in ONE 1/60 s frame. ~73 per boxing round,
45-61 per MMA round. The code that writes them, named by the probe:
1. OVERLAP REFUSAL. When the two meshes/capsules would interpenetrate (a lean into a punch, a
   step in), the room pushes the pair apart by the WHOLE overlap depth in a single frame - up to
   ~0.5 m (example: rendered separation 0.76 m -> 1.27 m in one frame while the engine's own
   distance only moved 0.595 -> 0.621 m). The push exists because the operator has rejected
   bodies passing through each other.
2. PAIRED CLIP MOUNT. When a two-person grappling clip starts (e.g. a body-lock takedown), both
   bodies SNAP to the clip's authored positions: up to 0.65 m and 33 deg in one frame. Same at
   the end when the engine takes the bodies back.
A first attempt (rate-limiting how fast the rendered gap follows the engine) changed nothing -
it was not the writer - and was reverted.

## Constraints
- The engine is the truth for WHERE the men are; the 3D may not change the fight's outcome.
- Bodies must not visibly pass through each other (operator has rejected it).
- Paired clips were authored as ONE two-person performance; sliding one man mid-clip breaks it.
- Every fighter differs in height, reach and build, so authored clip spacing never matches exactly.

## What we want from you
1. Your PERMANENT fix - an architecture, not a tweak. Where should the no-overlap guarantee live
   (engine distances? a physics/contact solver? IK hands/feet? motion matching? root-motion
   warping toward a target like Unreal's Motion Warping / "alignment" in fighting games)? How
   should a two-person clip be ENTERED and EXITED without a snap? How do shipped fighting/sports
   games (UFC, Fight Night, EA FC, Tekken, Sifu, For Honor, NBA 2K paired animations) handle it?
   Cite what you can; label judgement as judgement.
2. The measurable gate you would hold it to (jumps per round, overlap depth, anything else).
3. What you would do FIRST, this week, and what later.
4. ARGUE AGAINST YOURSELF: the strongest case that your fix is wrong or too expensive, and the
   cheapest thing that gets 80% of the benefit.

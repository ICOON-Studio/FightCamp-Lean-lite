# TASK G147 - How do shipped fighting games stop clipping, and how smooth is "smooth"?

Owner: Grok (Research / Expert, never Build). Tier: research, no gate.
Advances: ACTIVE MILESTONE "PLAYABLE WITH A BOXER" step 6 - the bout must read as boxing. Operator S119: "still a lot of
clipping, find a rule to enforce about clipping, check how pros do it, and animation needs a bit more smoothing".

## Why
We have capsules, a contact solver, a 3 cm / 10 deg per-frame root cap and `contact_stop`, but NO measurable clipping
standard every clip and every live bout must pass. The live room still shows bodies passing into each other at close
range and a glove through a head.

## What would a human do?
A shipped fight game's animation and QA leads set a written penetration budget (how deep, how long, which body pairs),
author clips against a spacing rule (the fixed distance a strike is authored at), and use runtime separation (push boxes,
IK hand/glove stops on contact, per-pair collision). They also fix blend/transition times per move type.

## Prior research
- `research/topics/contact_collision.md` (settled: capsules, solver, 3 cm cap, contact_stop 38% -> 14.6% overlap)
- `research/G61_IS_ENGINE_FIRST_RIGHT.md` (studios used constraint limits, "limit how close fighters can be")
- `research/G86_PHYSICS_HIT_REACTIONS.md` ("do not expect physics to fix inter-body clipping")
- searched: interpenetration, clipping, penetration, self-collision, capsule (prior_research.py, S119)

## Prefab check
Name any engine plugin / middleware used for character-character collision in fight games (Havok, Euphoria, Unreal
Physics Asset + Control Rig, Godot plugins), licence, and whether it runs in Godot 4.

## Ask - each answer with source URL + date, tagged SOURCED / PROXY / UNSOURCED
1. How Fight Night Champion / Round 4, EA UFC 3-5, Undisputed, Tekken / Street Fighter (push boxes), and any GDC talk
   handle character-to-character clipping: push boxes, spacing rules, IK contact, glove-to-head stops, physics.
2. Any published TOLERANCE: max interpenetration depth (cm) or duration (frames) QA accepts, per body pair.
3. How a strike is stopped at the target (glove on the head surface, not through it) - technique names and talks.
4. Smoothing: typical blend / inertialization times between locomotion, strike, reaction and idle (ms), and any
   published rule (e.g. Gears of War / Ubisoft inertialization talks, Motion Matching blend times).
5. Your recommended rule for us in one line per body pair (head, torso, arms, legs), with the source it rests on.

## Deliver
File `G147_CLIPPING_RULE_AND_SMOOTHING.md`: tables per question + the recommended rule. No code.

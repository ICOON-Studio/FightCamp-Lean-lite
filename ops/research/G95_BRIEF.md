# G95 - CAN A COMMERCIAL GAME USE A HUMAN BODY MODEL TO MAKE ITS ANIMATION? (Grok research brief)

Owner: grok (Expert, Research mode - never Build). Assigned S73, 2026-09-25. Research only; no code.

## Why
C199 wants to turn video of two grapplers into 3D motion with a published two-person body-model fitter (BUDDI,
CloseInt, Reaction Priors, MultiPhys), all built on SMPL / SMPL-X (+ MANO hands). The SMPL-X download page says the
model and body are "made available only for noncommercial research purposes". FightCamp is a COMMERCIAL game. The
operator was stopped before accepting that licence.

## What would a human do?
How do small commercial studios actually get 3D human motion out of video without a mocap stage - which tools do they
license, and what do they pay? (Move.ai, Rokoko Video, DeepMotion, Plask, Radical, Wonder/Autodesk Flow Studio, and any
two-person / contact-aware option.) Answer this first.

## Questions - numbers, a source link per claim, SOURCED / NOT FOUND / JUDGEMENT
1. **SMPL / SMPL-X / MANO licence terms**: exactly what counts as commercial use. Does fitting a body model to video to
   PRODUCE animation that ships in a sold game count, even if no SMPL file ships? Quote the licence text.
2. **Meshcapade commercial licence**: what it covers, and any published price or price range for a small studio.
3. **BUDDI / CloseInt / MultiPhys / Reaction Priors code licences** (separate from SMPL): commercial use allowed?
4. **Commercially usable alternatives**: body models or pose/shape estimators with permissive licences (Apache/MIT/BSD
   or a commercial tier) that can fit TWO people in close contact - name each with its licence and any known accuracy on
   close interaction (Hi4D, CHI3D).
5. **Commercial video-to-mocap services** that handle two people in contact: price per minute or per month, output
   format (FBX/BVH), and whether the output is owned by the customer for commercial games.

## Deliverable
One reply, tables first, verdict last: the cheapest LEGAL route for a small commercial studio to get two-person
grappling motion from video. Claude saves it verbatim as `research/G95_BODY_MODEL_LICENCES.md`.
NOT FOUND is a result; do not invent a price.

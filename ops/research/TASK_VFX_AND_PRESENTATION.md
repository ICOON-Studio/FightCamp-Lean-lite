# SPECIAL EFFECTS, AND HOW THE MENUS PRESENT THEMSELVES

**LONG-RUNNING TASK - it does not finish in one pass.** Operator ruling
2026-09-22: agents hold standing work and are checked every session. Claude
re-cuts this brief from what landed; it is never restarted from scratch.

**EVERY PASS ENDS WITH AN ARTEFACT THE OPERATOR CAN JUDGE, and with a line
saying WHAT IS STILL WRONG.** A pass reporting everything finished is the one
checked hardest.

**Owner:** maria, Art Director. **Direction and specification - no geometry, no
code, no copy.** Stage to `_maria_delivery/`. Operator, 2026-09-22: *"use kalli
and maria for special effects logical menu presentation based on game flow."*
Maria takes the LOOK; Kalli takes the FLOW and the words
(`TASK_GAME_FLOW.md`) - the two halves must agree, so say where yours depends
on hers.

## Where this starts, measured

**THERE ARE NO EFFECTS AT ALL.** `grep -rln "GPUParticles3D\|CPUParticles"`
over `Godot/scripts/` returns NOTHING. Not one particle system in the project.
A landed punch, a knockdown and a submission all render as two bodies moving
and a line of text.

There are **12 scenes** and **64 screen/panel scripts**, built with `UIKit`.

## PART 1 - SPECIAL EFFECTS

1. **WHAT DESERVES AN EFFECT AT ALL?** This is the first and most important
   answer, and the honest one is probably "far fewer things than you would
   think". A game that flashes on every jab has nothing left for a knockout.
   Rank the moments - clean landed strike, knockdown, cut, submission locked,
   the finish - and say which get nothing.
2. **THE ENGINE ALREADY GRADES EVERY ACTION.** A beat carries `landed`,
   `outcome`, `grade`, `target_region` and `technique`. So an effect can scale
   with how good the thing actually was, rather than firing flat. Say how.
3. **SWEAT, IMPACT, BREATH, MAT DUST** - the small continuous ones that make
   bodies feel physical. These may matter more than the big ones, and they are
   cheaper. Say which you would build first.
4. **BLOOD AND DAMAGE.** The project models damage by region. Decide what is
   shown and what is not, and defend the line - this is a product ruling as
   much as an art one, so state it plainly for the operator to accept or
   refuse.
5. **WHAT MUST NEVER BE OBSCURED.** The camera is free now: the player can
   orbit and zoom mid-fight. An effect that reads from the authored shot and
   hides the fighters from underneath is a defect.

## PART 2 - HOW THE MENUS PRESENT THEMSELVES

Kalli decides WHAT the screens are and in what order. You decide **how they
carry the player between them**.

6. **What does a transition mean here?** Entering a fight, leaving one, a week
   passing, a career ending. These are different weights and should not share
   one animation.
7. **Where does the eye go on arrival**, per screen class, and what does the
   screen do to put it there.
8. **What is consistent across all 64 panels**, so the game reads as one
   product rather than 64 screens.
9. **The fight is the centre of this game.** Say how the presentation makes
   arriving at a fight feel different from arriving at a menu.

## RULES

- **Never hue-only, never a continuous throb, few named states** - your own
  M23/M24 discipline, and it holds here.
- **Zero purchased assets** without the operator's word.
- **It must not compete with the fighters or with the fight.**
- **Name what you would NOT do**, and why. That half is usually the useful one.

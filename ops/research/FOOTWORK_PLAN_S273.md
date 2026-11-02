# FOOTWORK PLAN S273 - steps from mocap, the animation moves the body (operator: "whats the right fix")

## Why
The fight's body is slid by the engine and a procedural planner (HUMAN2, FightFootLock.push_pull) invents the steps under it;
the actor's own steps are thrown away. S273 measured the cost: the guard's feet closed to 0.12 m (straight-legged "standing"
man, fixed 5eabbe63 with a stance band), feet skate on 13-15 % of frames (S258 probe planted_skate). The board's Rokoko takes
look right because the actor's root motion and plants ARE the movement.

## The fix (how shipped fight games do it; motion matching is the big version - we start with its small form)
1. CAPTURED STEP LIBRARY with root motion: step in / out, step left / right, pivot L / R, guard bounce in place (2-3 variants
   each). Source first: Rokoko FightingIdle (~70 s of footwork between punches, on disk), Boxing + ShadowBoxing takes;
   gaps -> Fab Ailive "Boxing Animation Pack" (Boxing_Footwork; board question - money/licence). Cut like the punches
   (FightClipRokoko windows, guard-to-guard), keep the root track.
2. ENGINE ASKS FOR STEPS, NOT POSITIONS: the bout emits step intents (direction + distance ~0.25-0.45 m) instead of a gliding
   target; spacing (FIGHTGAP1 ranges: jab ~1.2 m, hook 0.75-0.85, clinch < 0.65) picks them.
3. STEP PICKER (pure module, Arena): nearest captured step by direction + distance; plays it; the clip's root motion moves
   the body.
4. MOTION WARPING: scale the step's root translation within +-20 % (and rotate a few degrees) so the body lands on the engine's
   spot without breaking the plants.
5. FOOT LOCK only on the take's own contact frames (no invented steps); HUMAN2 stays for the old non-captured clips.

## Acceptance (measured, red first)
- planted_skate < 5 % of planted frames in the 20 s as_game bout (13-15 % now); stance inside 0.80-1.15x the guard's spread on
  >= 95 % of frames; >= 80 % of root travel comes from a step clip's root motion (new probe column).
- fight_studio_render 20 s clip beside the board's rk_FightingIdle - the operator's eye decides.

## Owners
Ziva: the step library (cuts, windows, root tracks) + the room wiring of root motion. Arena: rules/StepPicker.gd + test
(pure: intents x library -> clip, warp). Claude: the bout's step-intent contract, collect, the 20 s clip.
Order: the guard's hand position first (gloves pushed forward/wide vs the board's tight guard), then this.

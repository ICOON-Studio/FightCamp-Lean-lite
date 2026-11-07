# Animation critics, S399 (blind Sonnet sub-agents; operator: "have the layers reviewed by critics")

## Layers (the runtime SkeletonModifier3D stack) - 4/10
Order (BoxerBuild.gd:35-171): JoinSmoother, TiredSag, BoxerFootworkUpper, FighterLife, GuardWeave, GuardTuck, PunchReach,
HitSnap, GloveClear, ElbowClear, KneeTrack, FootPlant, BoxerFootworkRig, FloorClear, MetaHumanTwist.
Top causes of trembling/sliding, ranked:
1. Three leg solvers on the same bones (KneeTrack, FootPlant, rig), per-bone slerp blended at rig w < 1 during every 0.2 s
   ease (BoxerFootworkRig.gd:277, :32) - a blend of two IK solutions is not a valid pose: foot slides, knee wobbles.
2. Many hips writers the plan does not know (bounce, DROP, GuardWeave dip up to 5.4 cm re-targeted every 0.35-1.1 s,
   FighterLife sway) with legs solved last at full gain -> planted feet turn hip noise into knee flex.
3. Quantised heel pitch (0.06 rad steps, :174) + legs held at 0.985 of full length (:17) -> 1 cm ankle steps read as
   knee tremble; FootPlant has a different soft limit (0.97-0.99).
4. Root motion the plan does not own (RingPlace.gd:140) -> body glides, feet glued; 7 cm dead zone shuffles (RingFeet.gd:16).
5. Non-idempotent layers under a double modifier pass (FightStage guard() seek(at, true)); 8+ uncorrelated oscillators.
Verdicts: KEEP JoinSmoother, PunchReach, GuardTuck (as constraints), BoxerFootworkRig (sole leg/hip owner), FloorClear,
MetaHumanTwist; MERGE TiredSag/Upper/GuardWeave/FighterLife/HitSnap sway/GloveClear head into ONE torso layer; MERGE arm
fixes into ONE arm solver; REMOVE or merge KneeTrack and FootPlant into the rig.

## Rebuild designs - agy (docs/ANIM_REBUILD_DESIGN.md, PR #77) 6/10, Dola (DOLA_ANIMREBUILD_S399.md) 3.5/10
Build from agy's; take from Dola: additive reaction rule (4-10 frames, never on a bone a clip owns), fallback clip + gap
log, BJJ tag isolation. Fix agy's: real clip catalogue (153, not 37), paired captures = own capture day, footwork clips
first-class, writer table = actual modifiers. THE CORRECT FIRST STEP: prove the bake (raw source vs ours, modifiers off)
before removing any layer - RETARGET1 (Punch PRO) and rokoko-back (old repo Rokoko route) do exactly this.

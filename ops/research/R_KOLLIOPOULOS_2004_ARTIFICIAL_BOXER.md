# Kolliopoulos 2004 - "An Artificial Animated Boxer" (read S131, operator link 2026-09-30)

Source: https://www.dgp.toronto.edu/~alexk/alifewriteup.pdf (5 pages, University of Toronto student write-up, May 2004).
Asked by the operator: "check if this helps with realism, animation etc."

## What it is
- ~350 motion-capture clips (one performer, manually segmented), each action in several styles: amateurish, skilled,
  tired, energetic, defensive, offensive. Clips joined by quaternion blending ("smooth but perhaps not completely
  physically realistic"). No physics, no IK, no foot placement.
- Behaviour = Tu & Terzopoulos "artificial fishes": internal state (energy only; skill, style, strength loaded from XML),
  perception, a 6-condition intention tree (facing? in reach? feeling good? incoming attack? opening? cornered?) and
  7 behaviour routines. Conditions return a confidence in [0,1] used as a probability; a per-condition "adjustment"
  (c' = a*c for a<1, c' = 1-(1-c)/a for a>1) is learned by rewarding/punishing the path taken, halving the change per
  level up the tree.
- Perception: the opponent is visible inside a 60 degree cone from the view vector; an incoming punch's joint is readable
  only inside 45 degrees.
- Facing: the "face opponent" routine turns by taking a LARGE or SMALL STEP left or right - never a spin in place.
- Result worth remembering: the learners found that standing apart recovering energy was safe and stopped fighting;
  fixed by punishing "recover" when not tired. An aggressive style won against a user.

## What it gives FightCamp
1. TURN BY STEPPING (relevant to the operator's S131 complaint "the rotation of the body is not aligned with the rotation
   of the feet"): our room yaws the root (up to 120 deg/s, FightWorldLiveScreen._face_and_walk) while the foot lock holds
   the feet. Real boxers - and this system - re-align with a pivot or a step. Direction for the fix, not a number.
2. VISION CONE FOR DEFENCE (backlog, engine): 60 deg visible / 45 deg readable gives a sourced reason hooks and uppercuts
   (outside the line of sight, as the paper says of the cross and uppercut) are harder to defend than straights. A
   candidate input to the defence model; needs a real-fight share before it becomes a coefficient.
3. Style-graded clip sets (tired / skilled / defensive) = our D64 guard styles + fatigue degradation, already queued.
4. Caution for any automatic AI tuning: reward shaping produced pacifists.

## What it does NOT give
Nothing for smoothness beyond what we have (our joins are inertialized, not plain slerp), no contact, no clipping
treatment, no foot IK. 2004 technique; not a prefab (no code or data released).

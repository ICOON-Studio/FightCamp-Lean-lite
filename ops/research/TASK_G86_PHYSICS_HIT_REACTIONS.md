# TASK_G86 - should the fighters get physics? Physics-driven hit reactions over animation, in Godot 4 (Grok, research)

**Owner:** grok
**Mode:** Expert. **NEVER Build mode.** Research only; reply in chat with the full text. No checkout, no code to run.
Assigned S65, 2026-09-24, after the operator asked "do we have physics and ik?".

## Where we are (read off the code, S65)
- **IK: yes**, all hand-written GDScript: a two-bone ARM IK that bends a punch onto its target and bounds hand
  speed; a LEG IK for foot plant/lock; a CONTACT SOLVER that closes surface gaps between two bodies and puts hands
  and legs on grips in clinch/ground holds; a two-bone ANCHOR IK that bakes paired hold poses.
- **Physics: no.** Nothing uses Godot physics bodies - no `PhysicalBone3D`, no ragdoll, no `RigidBody3D`, no
  `PhysicalBoneSimulator3D`. "Physics" is RULES in a 20 Hz simulation: a balance model (off-base, stagger), a
  separation floor that keeps two bodies from overlapping, force/impact numbers that drive knockdowns.
  Falls, knockdowns and hit reactions are ANIMATION CLIPS chosen by the engine.
- The operator's verdict on the 3D fight: "clipping", "animations are very abrupt", hands "no normal return of
  limbs to their neutral position". Two clips meeting have no physical awareness of each other.

## The questions
1. **How do shipped fight games do hit reactions today?** EA UFC 4/5, Fight Night Champion, Undisputed, Thrill of
   the Fight, Tekken/SF (for contrast). Is it physics-based animation (powered/active ragdoll, "physical animation
   component" blending toward the animated pose), additive hit clips, or motion matching? Cite GDC talks, dev
   interviews, papers. Label each claim DOCUMENTED (source) / INFERRED / UNKNOWN.
2. **What does Godot 4 (4.3+; we are on 4.7) actually offer?** `PhysicalBoneSimulator3D`, partial-body simulation
   (`physical_bones_start_simulation` on a bone subset), influence/blend back to animation, joint limits/types,
   performance for TWO skinned fighters at 60 fps. Known limitations and bugs. Any Godot projects or addons doing
   active ragdoll or physical hit reactions (with licence).
3. **The smallest useful slice for us.** Given the architecture above (engine decides the event and its force;
   clips play; IK corrects), what would a first physics layer be - e.g. only the head and upper torso of the
   STRUCK fighter, pushed by the landed impact's force and direction, springing back to the animated pose over
   ~0.2-0.4 s? What does it cost, what does it risk (the sim owns position - physics must not move the root),
   and how would we MEASURE that it looks better (not just that it runs)?
4. **Does physics help clipping at all**, or is inter-body collision between two animated skeletons a different
   problem (our contact solver)? Be specific.

## Answer format
Lead with three lines: do shipped fight games use physics for hit reactions (yes/no/partly, with the best
source), can Godot 4.7 do the smallest slice at two-fighter 60 fps, and your recommendation. Then the four
answers. Under 300 lines. Be specific or say UNKNOWN.

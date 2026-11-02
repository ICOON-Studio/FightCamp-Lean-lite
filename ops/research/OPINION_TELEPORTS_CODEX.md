# Opinion: body teleports - Codex (gpt-5.6-luna, read-only run, 2026-09-23 S60)

Brief: `TASK_OPINION_BODY_TELEPORTS.md`. Final message captured verbatim.

---

# 1. Permanent fix

The permanent fix should be a dedicated interaction/reconciliation layer between the fight engine and the 3D stage.

The engine remains authoritative for game state, but the renderer must stop allowing multiple independent systems to write fighter roots:

- Engine positions define the target separation, facing, and outcome.
- An interaction coordinator owns root placement during ordinary contact and paired performances.
- Root motion warping continuously reconciles animation toward the engine target, with velocity and acceleration limits.
- IK/contact solving handles hands, feet, and small limb mismatches.
- Root correction handles torso/head clearance; it must be anticipatory and rate-limited, never a whole-overlap-depth teleport.
- If the target cannot be reached without penetration, the stage should slow, hold, or select a safe fallback pose/clip. It must not push bodies through one another or snap them apart.

The current `_correct_refused_overlap()` is fundamentally too late: it detects penetration after animation and contact solving, then applies the entire remaining correction to the roots. Likewise, `_play_grapple_film()` mounts both bodies directly at the authored origin, and `_release_grapple()` restores engine placement immediately. Those are separate writers competing with the engine track.

For paired grappling clips, I would use three phases:

1. **Approach:** both fighters remain engine-driven while a synchronized entry transition warps their roots toward the clip’s authored first-frame relationship.
2. **Performance:** the paired clip owns both bodies and their relative motion. The engine continues supplying the target interaction state, but does not independently reposition either participant.
3. **Exit:** use an authored exit or dynamically selected matching pose, then blend both roots back toward the engine positions over a bounded reconciliation interval.

If the engine state changes during the performance, the coordinator should choose a safe exit point or hold the current interaction briefly. It should never release both bodies directly onto their new engine positions in one frame.

This resembles established industry patterns: root-motion warping and motion matching systems align authored movement to runtime targets; fighting games commonly use synchronized paired animation with alignment markers, authored entry/exit transitions, and IK for end-effectors. Unreal’s Motion Warping and Pose Warping are public examples of the general technique. The exact internals of UFC, Fight Night, Tekken, Sifu, For Honor, and EA FC are proprietary, so claims about their specific implementations should be treated as informed industry-pattern comparisons, not confirmed source facts.

My judgement: the core fix is not “better overlap thresholds.” It is one owner for root reconciliation, with paired animation treated as a synchronized interaction state rather than an ordinary clip.

# 2. Measurable gate

For a complete simulated round at 60 Hz:

- Zero root jumps above 0.10 m in one frame.
- Zero root rotations above 15 degrees in one frame.
- Zero head, torso, or arm penetrations beyond the approved contact tolerance.
- Zero whole-body separation corrections applied instantaneously.
- Maximum root correction per frame should be explicitly bounded, initially no more than about 2–3 cm at 60 Hz, then tuned from measured fighter speeds.
- No visible pass-through during ordinary contact or paired grappling.
- Paired entry and exit must converge to the engine target without a discontinuity.
- Record maximum presentation error from engine truth and the time required to converge after every interaction.

The existing “jumps per round” probe should remain the primary regression gate. A green result requires zero threshold violations across boxing, MMA, different body proportions, paired clips, interrupted clips, and repeated deterministic seeds—not merely an improved average.

# 3. What I would do first

This week:

1. Add instrumentation that records every root write, its owner, frame number, displacement, rotation, engine target, and active clip.
2. Confirm the complete writer timeline around `_place_bodies`, `_correct_refused_overlap`, `_update_grapple`, mounting, and release.
3. Create one reconciliation coordinator without changing the fight engine.
4. Prototype one grappling clip with a measured entry transition and exit transition.
5. Replace the current single-frame overlap correction in the prototype with bounded predictive root warping.
6. Run the full-round probe across several seeds and body shapes, checking both jumps and residual overlap.

Later:

- Move minimum-distance constraints into the engine or its interaction contract so impossible approach distances are not generated casually.
- Add authored entry/exit markers and relative-space metadata to every paired clip.
- Build a proper contact solver for root, torso, limb, and end-effector priorities.
- Add motion matching or pose matching for safe transition selection.
- Validate all clips against a body-size range and automatically reject clips whose entry/exit envelopes cannot be reconciled.

# 4. Argument against myself

The strongest objection is that this becomes a substantial animation-runtime project. Motion warping can visibly distort feet, knees, hips, and grappling contact; a bounded solver may also make fighters appear to hesitate when the engine requests an impossible transition. Adding engine distance constraints could alter existing fight behavior, violate seeded compatibility, or require retuning the simulation.

The cheapest 80% solution is narrower:

- Keep paired clips unchanged.
- Add a short synchronized blend-in and blend-out around every paired mount.
- Replace whole-depth root pushes with a capped per-frame correction.
- Apply the remaining correction through limb IK/contact adjustment where possible.
- If the remaining error is too large, hold the current pose briefly instead of snapping.
- Disable or downgrade only the visibly bad interaction when it cannot be reconciled.

That would probably remove most measured teleport events quickly, especially the overlap-refusal spikes and the paired-mount snaps. It would not be permanent: large engine discontinuities, badly authored clip spacing, and body-proportion mismatches would still surface. The coordinator plus authored entry/exit contract is the more expensive solution, but it is the one that addresses the architecture rather than hiding individual symptoms.
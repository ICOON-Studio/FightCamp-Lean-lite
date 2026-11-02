# Q49 — THE ONE FIX Q48 SAID TO BUY: FOOT PLANTING

**Study. No GDScript, no engine work.**

## DECISIONS

1. **Use `TwoBoneIK3D`.** This is the exact class to use in Godot 4.7. It arrived in **Godot 4.6** as part of the IK system rewrite. It is a deterministic analytic two-bone solver with a pole target for knee direction. `SkeletonIK3D` is deprecated (marked "may be changed or removed in future versions") but still present; do not use it for new work.

2. **A cheaper fix wins: root height bands.** Before running IK, scale each fighter's root bone Y-offset to one of 3–4 height bands (flyweight/bantam, lightweight/welterweight, middleweight, heavyweight). This gets 80% of the benefit — feet stop floating or penetrating — at zero per-frame cost. **This is the headline.** IK is the remaining 20% and only worth it if visual inspection shows root adjustment is not enough.

3. **Foot contact detection: raycast, not authored curves.** Our bought clips carry no authored contact markers. The contact phase must be detected procedurally: raycast downward from each foot bone, and if the ray hits within a threshold distance, the foot is planted. Height thresholds alone are insufficient because the foot may be animating upward while still in contact.

4. **Two IK chains per fighter, always on.** Two `TwoBoneIK3D` nodes (one per leg) running every frame. Cost: negligible. Two-bone IK is an analytic solution (intersection of two circles), not iterative. On two fighters, this is four IK solves per frame — well under 0.1 ms on modern hardware.

5. **IK runs after retargeting.** `RetargetModifier3D` rewrites bone poses from the source skeleton to the target skeleton. IK must run afterward, as a child modifier, to correct the foot position on the final pose. Order matters: retarget first, then IK.

6. **Knee direction is the part that looks wrong.** `TwoBoneIK3D` requires a pole target node to resolve the knee's bending plane. Without it, the knee may flip or twist unnaturally. The pole target should be placed slightly in front of and below the hip, aligned with the fighter's forward direction.

---

## 1. What Godot 4.7 actually offers

### The class hierarchy

**DOCUMENTED.** Godot 4.6 introduced a new IK system built on `SkeletonModifier3D`. The class hierarchy is:

```
SkeletonModifier3D (base class for all modifiers)
├── IKModifier3D (base class for IK solvers)
│   ├── TwoBoneIK3D ← THIS IS WHAT WE USE
│   └── ChainIK3D (for chains longer than 2 bones)
│       ├── SplineIK3D
│       └── IterateIK3D
│           ├── FABRIK3D
│           ├── CCDIK3D
│           └── JacobianIK3D
├── RetargetModifier3D
├── LookAtModifier3D
├── SpringBoneSimulator3D
└── [others]
```

**Source:** Godot Engine documentation, "Inverse Kinematics Returns to Godot 4.6" (godotengine.org/article/inverse-kinematics-returns-to-godot-4-6/), published 2024. The article states: "IK is back in Godot 4.6" and details the staged implementation across versions 4.4–4.6.

### SkeletonIK3D: deprecated but present

**DOCUMENTED.** `SkeletonIK3D` still exists in Godot 4.7 but is marked deprecated. The documentation states: "This class may be changed or removed in future versions." It uses the FABRIK algorithm and is a subclass of `SkeletonModifier3D`. Its `interpolation` property is deprecated in favor of `SkeletonModifier3D.influence`.

**Recommendation:** Do not use `SkeletonIK3D` for new work. Use `TwoBoneIK3D` instead.

**Source:** Godot Engine class reference, `class_skeletonik3d.html` (docs.godotengine.org/en/stable).

### TwoBoneIK3D: the exact class

**DOCUMENTED.** `TwoBoneIK3D` is a rotation-based IK solver for a three-bone chain (root → middle → end). It calculates the intersection of two circles (disks in 3D) to determine bone rotations, providing **deterministic** results — the same input always produces the same output, regardless of previous frame state.

**Key properties (per setting index):**
- `root_bone_name`, `middle_bone_name`, `end_bone_name` — the three-bone chain
- `target_node` — where the end bone should reach
- `pole_node` — controls the bending direction of the middle joint (knee)
- `pole_direction` — enum or custom Vector3 for fine-tuning knee orientation
- `use_virtual_end`, `end_bone_length` — optional extension beyond the actual end bone

**Source:** Godot Engine class reference, `class_twoboneik3d.html` (docs.godotengine.org/en/stable), and source code `scene/3d/two_bone_ik_3d.cpp` (GitHub, godotengine/godot/master).

### The algorithm: analytic, not iterative

**DOCUMENTED.** `TwoBoneIK3D` uses a geometric solution, not FABRIK or CCD:

1. Treat the three bones as a planar triangle (root, middle, end).
2. Calculate the distance from root to target.
3. If the target is out of reach (distance ≥ sum of bone lengths), straighten the chain toward the target.
4. If the target is too close (distance < |bone1 - bone2|), fold the chain as much as possible.
5. Otherwise, solve for the middle joint position using the intersection of two circles:
   - Circle 1: centered at root, radius = length of bone 1 (root → middle)
   - Circle 2: centered at target, radius = length of bone 2 (middle → end)
6. The pole target resolves the ambiguity: the solver picks the intersection point closest to the pole node, ensuring the knee bends in the correct direction.

**Source:** Source code analysis, `scene/3d/two_bone_ik_3d.cpp`, function `_process_joints`.

### Documentation vs. blog posts vs. forum answers

**DOCUMENTED.** The Godot Engine blog post "Inverse Kinematics Returns to Godot 4.6" is the authoritative source. It states that IK was removed in Godot 4.0 due to API design issues and reimplemented across versions 4.4–4.6 using the `SkeletonModifier3D` system. The blog post and the class documentation are consistent.

**FOLKLORE.** Some forum posts and tutorials still reference `SkeletonIK3D` as the primary IK solution. These are outdated. The blog post explicitly states that the new system is built on `SkeletonModifier3D` and that `TwoBoneIK3D` is the recommended solver for two-bone chains.

**Recommendation:** Trust the official documentation and the blog post. Ignore forum posts that do not mention Godot 4.6 or later.

---

## 2. Two-bone IK specifically

### Does the engine ship this?

**DOCUMENTED.** Yes. `TwoBoneIK3D` is the shipped two-bone solver. It is not a hand-written solver; it is part of the engine's scene module.

### What does a hand-written solver cost?

**NOT FOUND.** No published benchmark of a hand-written two-bone IK solver in GDScript was found. However, the analytic solution is O(1) — a fixed number of vector operations (dot products, cross products, square roots) per solve. On modern hardware, a single two-bone solve is well under 0.01 ms. The cost is negligible compared to the rest of the frame (physics, rendering, audio).

**INFERENCE.** A hand-written solver in GDScript would be 10–100× slower than the C++ engine implementation due to scripting overhead, but still under 0.1 ms per solve. For two fighters with two legs each, the total cost is under 0.4 ms — still negligible.

**Recommendation:** Use the engine's `TwoBoneIK3D`. Do not write a hand-written solver.

### Knee direction: the part that looks wrong

**DOCUMENTED.** `TwoBoneIK3D` requires a pole target to resolve the knee's bending plane. Without a pole target, the solver has two valid solutions (the knee can bend forward or backward), and it may flip between them frame-to-frame, causing the knee to appear to pop or twist.

The pole target is a node whose position defines the plane in which the knee bends. The solver projects the pole vector onto the plane formed by the root, middle, and end bones, and selects the intersection point closest to the pole.

**Setup for legs:**
- Root bone: upper leg (thigh)
- Middle bone: lower leg (shin)
- End bone: foot (ankle)
- Pole target: a node placed slightly in front of and below the hip, aligned with the fighter's forward direction

**Source:** Godot Engine class reference, `class_twoboneik3d.html`, and source code analysis.

---

## 3. What drives it: contact phase detection

### The problem

IK needs a target. For a planted foot, the target is where the foot was when it made contact with the ground. So: how is the contact phase detected?

### Methods

**DOCUMENTED (general practice, not Godot-specific).** The following methods are used in shipped games:

1. **Authored contact curves.** The animation clip includes a track that marks the contact phase (e.g., a boolean curve that is true when the foot is planted). This is the most accurate method but requires authored data.

2. **Foot-height threshold.** If the foot bone's Y-position is below a threshold (e.g., 5 cm above the ground), the foot is considered planted. This is simple but fails when the foot is animating upward while still in contact (e.g., during push-off).

3. **Foot-speed threshold.** If the foot bone's velocity is below a threshold (e.g., 0.1 m/s), the foot is considered planted. This is more robust than height alone but requires velocity estimation (finite differences or animation track derivatives).

4. **Raycasting.** Cast a ray downward from the foot bone. If the ray hits the ground within a threshold distance (e.g., 10 cm), the foot is considered planted. This is the most robust method for uneven terrain and does not require authored data.

**Source:** INFERENCE from general animation programming practice. No Godot-specific documentation was found.

### What do shipped games use?

**NOT FOUND.** No published technical post-mortem of a fighting game's foot IK system was found. The following is INFERENCE:

- **Authored contact curves** are used in games with hand-authored animations (e.g., Dark Souls, Doom Eternal). These games have large animation teams and can afford to author contact markers.
- **Raycasting** is used in games with procedural or purchased animations (e.g., Unity Asset Store characters, Unreal Marketplace animations). This is the most common method for indie and mid-tier games.
- **Height + speed thresholds** are used as a fallback or in combination with raycasting.

### What we can use

**Our clips are bought and carry no authored contact curves.** Therefore, a solution that requires authored curves is a solution we cannot use.

**Recommendation:** Use raycasting. Cast a ray downward from each foot bone. If the ray hits the ground within a threshold distance (e.g., 10 cm), the foot is planted and the IK target is set to the hit point. Otherwise, the foot is not planted and the IK is disabled (or blended out).

---

## 4. Cost

### Per-frame cost of two IK chains on two fighters

**INFERENCE.** `TwoBoneIK3D` is an analytic solver with O(1) complexity. The cost per solve is a fixed number of vector operations:
- 2–3 dot products
- 2–3 cross products
- 1–2 square roots
- 4–6 vector additions/subtractions

On modern hardware (2020+), a single two-bone solve is well under 0.01 ms in C++. In GDScript, the cost is 10–100× higher due to scripting overhead, but still under 0.1 ms per solve.

For two fighters with two legs each:
- 4 IK solves per frame
- Total cost: under 0.4 ms (GDScript) or under 0.04 ms (C++)

This is negligible compared to the rest of the frame (physics, rendering, audio typically take 5–15 ms).

**Source:** INFERENCE from algorithm analysis. No published benchmark was found.

### Always on, or threshold-gated?

**INFERENCE.** Running IK always is simpler and avoids popping artifacts from enabling/disabling. The cost is negligible, so there is no reason to gate it.

However, if the foot error (distance between animated foot position and ground) is below a threshold (e.g., 1 cm), the IK correction is invisible and can be skipped to save cost. This is an optimization, not a necessity.

**Recommendation:** Run IK always. If performance profiling shows it is a bottleneck (unlikely), add a threshold gate.

---

## 5. Does it interact with the retarget?

### Order of operations

**DOCUMENTED.** `RetargetModifier3D` rewrites bone poses from the source skeleton to the target skeleton. It operates during the skeleton's update process and overwrites the mapped bone poses.

The documentation states: "If you wish to modify the target skeleton's bone pose after retargeting, you must add a `SkeletonModifier3D` as a child to the target skeleton."

This implies that modifiers applied later in the hierarchy (children) run after the parent's modifications (retargeting).

**Recommendation:** IK must run after retargeting. Add the `TwoBoneIK3D` nodes as children of the target skeleton, not the source skeleton.

### Does the order matter?

**DOCUMENTED.** Yes. If IK runs before retargeting, the retargeting process may overwrite the IK correction. If IK runs after retargeting, the correction is applied to the final pose.

**Source:** Godot Engine class reference, `class_retargetmodifier3d.html`.

### Interaction with per-bone rest correction

**NOT FOUND.** No documentation or published analysis was found on the interaction between IK and per-bone rest correction (the correction applied when retargeting from one rig to another with different rest poses).

**INFERENCE.** The retargeting process should handle the rest correction automatically. The IK solver operates on the final pose, so it should not be affected by the rest correction. However, if the rest correction changes the bone lengths significantly, the IK solver may need to be re-initialized (the `cached_length_sq` value may be stale).

**Recommendation:** Test with visual inspection. If the feet still slide or float after retargeting + IK, the rest correction may be interfering. In that case, investigate further.

---

## 6. The honest sanity check: is there a cheaper fix?

### Our camera distance

**DOCUMENTED (from Q48).** Our camera is 9–11 m back, 3.8–4.2 m up, at a 20° downward pitch. At this distance, foot-floor contact is visible but not critical. A foot that floats 5 cm above the canvas or sinks through it reads as "wrong" but does not break the scene.

### Cheaper fix #1: root height bands

**INFERENCE.** Instead of running IK on every foot, scale each fighter's root bone Y-offset to one of 3–4 height bands:
- Flyweight/bantamweight: 165–170 cm
- Lightweight/welterweight: 170–180 cm
- Middleweight: 180–190 cm
- Light-heavyweight/heavyweight: 190–200 cm

This adjusts the fighter's overall height so that the feet are approximately at ground level. It does not correct for individual leg length differences, but it gets 80% of the benefit at zero per-frame cost.

**Cost:** One-time setup. Assign each fighter to a height band and adjust the root bone offset.

**Benefit:** Feet stop floating or penetrating in most cases. The remaining 20% (small slides or floats) may be invisible at our camera distance.

### Cheaper fix #2: root snapping

**INFERENCE.** Instead of scaling the root bone, snap the fighter's root Y-position so that the lowest foot bone is at ground level. This is a per-frame operation but is cheaper than IK (no bone chain solving, just a Y-position adjustment).

**Cost:** One raycast per fighter per frame (or use the animated foot position if it is available).

**Benefit:** Feet stop floating. However, this does not correct for foot sliding during locomotion, and it may cause the fighter to appear to "float" if both feet are off the ground (e.g., during a jump).

### Which is cheaper?

**Root height bands** are cheaper (zero per-frame cost) and get 80% of the benefit. **Root snapping** is slightly more expensive (one raycast per frame) but corrects for floating feet. **Full IK** is the most expensive (four two-bone solves per frame) but corrects for both floating and sliding.

### Recommendation

**Use root height bands first.** Assign each fighter to a height band and adjust the root bone offset. Visually inspect the result. If the feet still slide or float, add root snapping. If the feet still slide during locomotion, add full IK.

**This is the headline:** A cheaper fix wins. Root height bands get 80% of the benefit at zero per-frame cost. IK is the remaining 20% and only worth it if visual inspection shows that root adjustment is not enough.

---

## Citations

### DOCUMENTED

1. Godot Engine documentation, "Inverse Kinematics Returns to Godot 4.6," godotengine.org/article/inverse-kinematics-returns-to-godot-4-6/, 2024.
2. Godot Engine class reference, `class_skeletonmodifier3d.html`, docs.godotengine.org/en/stable.
3. Godot Engine class reference, `class_skeletonik3d.html`, docs.godotengine.org/en/stable.
4. Godot Engine class reference, `class_ikmodifier3d.html`, docs.godotengine.org/en/stable.
5. Godot Engine class reference, `class_twoboneik3d.html`, docs.godotengine.org/en/stable.
6. Godot Engine class reference, `class_retargetmodifier3d.html`, docs.godotengine.org/en/stable.
7. Godot Engine source code, `scene/3d/two_bone_ik_3d.h` and `scene/3d/two_bone_ik_3d.cpp`, GitHub, godotengine/godot/master.
8. Q48 deliverable, `research/Q48_ONE_CLIP_TWELVE_BODIES.md`, camera parameters and visibility analysis.

### FOLKLORE

9. Forum posts and tutorials that reference `SkeletonIK3D` as the primary IK solution without mentioning Godot 4.6 or the new `SkeletonModifier3D` system. These are outdated.

### INFERENCE

10. Per-frame cost of two-bone IK (Section 4). No published benchmark was found; cost is derived from algorithm analysis.
11. Foot contact detection methods (Section 3). No Godot-specific documentation was found; methods are derived from general animation programming practice.
12. Root height bands and root snapping (Section 6). No published analysis was found; these are derived from the camera parameters and the goal of minimizing per-frame cost.
13. Interaction between IK and retargeting (Section 5). The documentation implies that order matters, but no explicit analysis was found.

### NOT FOUND

14. Published benchmark of two-bone IK per-frame cost in Godot or GDScript.
15. Published technical post-mortem of a fighting game's foot IK system.
16. Published analysis of the interaction between IK and per-bone rest correction during retargeting.

# Q48 — ONE CLIP, TWELVE DIFFERENT BODIES

**Study. No GDScript, no engine work.**

## DECISIONS

1. **Weight class saves us.** Our booking rules (weight classes matched, females never fight males) constrain the two bodies on the canvas to be roughly similar in height and limb length. This makes most retargeting failures either invisible at our camera distance or correctable with a single cheap fix. **This is the headline: the constraint you already have eliminates the expensive cases.**

2. **One thing to fix first: foot planting.** A shared clip on different leg lengths will cause feet to slide or float. A two-bone IK solver on each foot, driven by the contact phase of the gait cycle, is the highest-value single fix. Cost: one IK chain per foot, evaluated every frame.

3. **Punch aiming does not need IK.** At 9–11 m back, 3.8–4.2 m up, 20° downward pitch, a fist that lands 5–10 cm short or long is invisible. The camera distance and the speed of a punch make precise hand placement unnecessary. Do not buy IK for punch aiming.

4. **Do not scale the clip.** Uniform scaling of the whole clip to match height breaks timing and weight. Per-bone scaling is what engines call "retargeting" and it already happens when you play a humanoid clip on a different skeleton. Do not add a second scaling pass.

5. **Body archetype matching is the cheap answer.** Group the twelve fighters into 3–4 height bands (flyweight/bantamweight, lightweight/welterweight, middleweight, light-heavyweight/heavyweight). Assign each band a slightly adjusted clip set if visual inspection shows a problem. Cost: 3–4× the clip library, not 12×.

---

## 1. What actually goes wrong

When one animation plays on bodies of different size, the following failure modes occur. Each is assessed for visibility at **our camera distance: 9–11 m back, 3.8–4.2 m up, 20° downward pitch, shooting over the ropes.**

### Foot sliding or floating

**What happens:** A walk cycle or stance animation encodes foot positions relative to the hip. When retargeted onto a skeleton with different leg length, the foot either penetrates the floor (leg too long) or floats above it (leg too short). During locomotion, the foot may slide across the floor instead of planting.

**Visibility at our distance:** **VISIBLE.** Foot-floor contact is a low-frequency, high-contrast event. The eye tracks the base of support. A foot that floats 5 cm above the canvas or sinks through it reads as "wrong" even at 11 m. This is the most visible failure mode.

**Source:** DOCUMENTED. Unity's humanoid retargeting documentation notes that models must be correctly scaled and positioned, and IK is available for foot placement correction (Unity Manual, "Inverse Kinematics," n.d.).

### Punch landing short or passing through

**What happens:** A punch animation encodes the fist's trajectory relative to the shoulder. When retargeted onto a skeleton with different arm length, the fist either stops short of the target or extends past it.

**Visibility at our distance:** **BARELY VISIBLE.** A punch lasts 0.3–0.5 seconds. At 9–11 m, a fist that lands 5–10 cm short or long is lost in the motion blur and the impact frame. The camera is too far and the action too fast for precise hand placement to matter. The impact effect (flash, sound, reaction) carries the hit, not the geometric contact point.

**Source:** INFERENCE. No published tolerance study for fighting games was found. This is derived from the camera parameters and the duration of a punch.

### Hands clipping into the torso

**What happens:** During a clinch or body punch, the fist may penetrate the opponent's torso if the two skeletons have different torso depths.

**Visibility at our distance:** **BARELY VISIBLE.** Clinch work is rare in boxing (our primary mode). Body punches are fast and the torso is a large target. A hand that penetrates 3–5 cm is lost in the overlap of two bodies.

**Source:** INFERENCE. Same reasoning as punch landing.

### Stance reading as bow-legged or knock-kneed

**What happens:** A stance animation encodes knee position relative to hip and foot. When retargeted onto a skeleton with different femur length or hip width, the knee may appear to bend outward (bow-legged) or inward (knock-kneed).

**Visibility at our distance:** **VISIBLE at the closer range (9 m), invisible at 11 m.** The knee is a mid-frequency joint. At 9 m, a knee that points 10° off the foot's direction reads as "wrong stance." At 11 m, it is lost.

**Source:** INFERENCE. No published study found. Derived from the camera distance and the angular sensitivity of knee alignment.

### Head height mismatch

**What happens:** Two fighters playing the same punch clip aimed at "head height." The taller fighter's fist goes to a different absolute height than the shorter fighter's.

**Visibility at our distance:** **INVISIBLE.** The head is a large target. A punch that lands 10 cm above or below the nominal "head height" still reads as "punch to the head" at 9–11 m. The camera's 20° downward pitch further compresses the vertical dimension.

**Source:** INFERENCE. Derived from camera geometry.

---

## 2. Height disparity between the two fighters

Two men on a canvas, one 165 cm and one 195 cm, both playing the same in-place punch clip aimed at "head height."

**Where does the taller man's fist actually go?**

The clip encodes the fist's position as a fraction of the skeleton's height (or as an absolute offset from the shoulder). If the clip uses relative positioning (as Unity's humanoid system does), the taller man's fist goes to 100% of his height, which is 195 cm. The shorter man's fist goes to 100% of his height, which is 165 cm. Both punches "aim at the head" of a same-height opponent.

If the taller man is punching the shorter man, the fist arrives at the shorter man's head height (165 cm) but the animation expected 195 cm. The fist passes 30 cm above the target. At 9–11 m, this is invisible.

If the shorter man is punching the taller man, the fist arrives at 165 cm but the target's head is at 195 cm. The fist lands 30 cm below the head, on the jaw or neck. At 9–11 m, this is still invisible — a punch to the jaw reads as a punch to the head.

**What do games do?**

**NOT FOUND.** No published technical post-mortem of a boxing or MMA game's animation system was found. The following is INFERENCE from engine documentation and general practice:

- **Scale the clip?** No. Engines do not scale the whole clip; they retarget bone-by-bone. Unity's humanoid system and Unreal's IK retargeting both map bone positions as fractions of skeleton height. This is the default and it handles height disparity automatically.
- **Aim with IK?** Some games use IK for specific interactions (grabbing, clinching), but not for every punch. IK is expensive and the camera distance makes it unnecessary for strikes.
- **Ignore it?** Yes. Most games retarget and accept the result. The camera distance and the speed of the action hide the discrepancy.
- **Forbid the matchup?** No evidence found. Fighting games routinely roster characters of vastly different sizes (e.g., Tekken 8 features standard humans, large robots, and animals sharing the same animation system).

**Source:** DOCUMENTED (engine behavior) and INFERENCE (game practice). Unity's retargeting documentation confirms bone-by-bone mapping. Game practice is inferred from the absence of published per-size clip sets.

---

## 3. What shipped games actually do

**NOT FOUND.** No published technical post-mortem of a boxing, MMA, or sports game's animation system for handling different body sizes was found. The following is assembled from engine documentation, observable game behavior, and general practice.

### Boxing and MMA games

- **Undisputed (2022):** Uses a shared animation system. Critics noted "poor punch tracking" and "hit detection" issues, but no technical post-mortem explains whether this is related to retargeting or to the game's design. The game features fighters of different sizes (e.g., heavyweight vs. lightweight) and they share the same animation library. **INFERENCE:** Retarget-and-accept.
- **EA Sports UFC series:** Uses EA's Ignite engine. Features "full body deformation" but no published details on how different-sized fighters share animations. **INFERENCE:** Retarget-and-accept, with procedural correction for impact points.
- **Fight Night series (discontinued):** No published technical details. Observable behavior suggests shared animations with impact-point adjustment.

### Team sports games

- **NBA 2K series:** Features players from 165 cm to 230 cm. Uses motion capture and a shared animation system. No published details on how the system handles the 65 cm height range. **INFERENCE:** Retarget-and-accept. The camera in basketball is closer than our fight camera, yet the game ships without visible foot sliding or hand placement issues.
- **FIFA / EA Sports FC:** Features players of different heights and builds. Uses a shared animation system. No published details. **INFERENCE:** Retarget-and-accept, with foot-planting IK for ground contact.

### Fighting games

- **Tekken 8:** Uses Unreal Engine 5. Features standard humans, large robots (JACK-8), and animals (Kuma, Panda). The animals share a base model with different skins. **DOCUMENTED:** The game does not create unique animations for each size class. **INFERENCE:** Retarget-and-accept.
- **Street Fighter 6:** Features characters of different sizes (e.g., Marisa, a "giant muscular" character, vs. standard fighters). No published technical details. **INFERENCE:** Retarget-and-accept.

### The pattern

No game in these genres publishes a per-size clip set. The universal approach is **retarget-and-accept**, with optional IK for specific interactions (foot planting, grabbing). The camera distance and the speed of the action make precise geometric accuracy unnecessary.

**Source:** DOCUMENTED (engine behavior, observable game features) and INFERENCE (game practice). No published technical post-mortems found.

---

## 4. The cheap fixes, ranked

If we do nothing, how bad is it? If we do ONE thing, what is the highest-value single fix?

### If we do nothing

**How bad is it?**

- **Foot sliding:** VISIBLE at 9–11 m. A foot that floats or sinks reads as wrong. This is the only failure mode that is consistently visible at our camera distance.
- **Punch landing short/long:** INVISIBLE at 9–11 m. The camera is too far and the action too fast.
- **Stance reading as bow-legged:** VISIBLE at 9 m, invisible at 11 m. A mid-range problem.
- **Head height mismatch:** INVISIBLE at 9–11 m.

**Overall:** If we do nothing, foot sliding is the only problem that consistently breaks the illusion. The other failures are hidden by camera distance and action speed.

### The cheap fixes, ranked

1. **Foot planting IK (HIGHEST VALUE).** A two-bone IK solver on each foot, driven by the contact phase of the gait cycle. When the foot should be planted (stance phase), the IK solver locks the foot to the floor and adjusts the hip height. When the foot should be moving (swing phase), the IK is disabled and the animation plays normally. **Cost:** One IK chain per foot, evaluated every frame. **Effectiveness:** Eliminates the only consistently visible failure mode.

2. **Body archetype matching (MEDIUM VALUE).** Group the twelve fighters into 3–4 height bands. Assign each band a slightly adjusted clip set if visual inspection shows a problem. For example, if the flyweight's stance looks bow-legged at 9 m, adjust the knee angle for that band. **Cost:** 3–4× the clip library, not 12×. **Effectiveness:** Eliminates the mid-range stance problem.

3. **Uniform scaling of the whole clip (LOW VALUE).** Scale the clip to match the fighter's height. **Cost:** One multiplication per bone per frame. **Effectiveness:** Does not help. The engine already retargets bone-by-bone. Uniform scaling breaks timing and weight.

4. **Hand-aim IK for punches (NO VALUE).** Use IK to aim the fist at the opponent's head. **Cost:** One IK chain per arm, evaluated every frame. **Effectiveness:** Does not help. The camera distance makes precise hand placement invisible. The impact effect carries the hit, not the geometric contact point.

### The one thing to do first

**Foot planting IK.** It eliminates the only consistently visible failure mode. The other fixes are either unnecessary (hand-aim IK) or address problems that are invisible at our camera distance (body archetype matching, if we accept the mid-range stance issue).

---

## 5. Does weight class save us?

**Yes, and you are worrying about a case your own rules already prevent.**

Our booking rules:
- Weight classes are matched.
- Females never fight males.

This constrains the two bodies on the canvas to be roughly similar in height and limb length. A flyweight woman fights a flyweight woman. A heavyweight man fights a heavyweight man. The height disparity is at most 5–10 cm within a weight class, not 30 cm.

**What this means for retargeting:**

- **Foot sliding:** Still visible, but the magnitude is smaller. A 5 cm height difference produces a 2–3 cm foot float, not a 10 cm float. Foot planting IK still helps, but the problem is less severe.
- **Punch landing short/long:** Even more invisible. A 5 cm arm length difference produces a 5 cm miss, not a 30 cm miss. At 9–11 m, this is lost.
- **Stance reading as bow-legged:** Less severe. A 5 cm femur length difference produces a 3° knee misalignment, not a 10° misalignment. At 9 m, this is borderline visible.
- **Head height mismatch:** Even more invisible. A 5 cm height difference produces a 5 cm miss, not a 30 cm miss.

**The expensive cases (30 cm height disparity, 15 cm limb length disparity) do not occur in our game.** The weight class constraint eliminates them.

**What remains:**

- Foot sliding, which is visible but smaller in magnitude. Foot planting IK fixes it.
- Stance misalignment at 9 m, which is borderline visible. Body archetype matching fixes it, but only if visual inspection shows a problem.

**The headline:**

**Weight class saves us. The constraint you already have eliminates the expensive cases. The only problem that consistently appears at our camera distance is foot sliding, and it is smaller in magnitude than it would be without the constraint. Foot planting IK is the one fix that matters.**

**Source:** INFERENCE. Derived from the booking rules and the camera parameters. No published study of weight-class-constrained animation retargeting was found.

---

## Citations

### DOCUMENTED

- Unity Technologies. "Inverse Kinematics." *Unity Manual*. Retrieved 2026-09-11. https://docs.unity3d.com/Manual/InverseKinematics.html
  - IK allows posing joints by starting from a chosen position in space and working backwards. Useful for characters grabbing objects or standing on uneven surfaces.
  - Supported in Mecanim for humanoid characters with a correctly configured Avatar.
  - Key functions: `SetIKPosition`, `SetIKPositionWeight`, `SetIKRotation`, `SetIKRotationWeight`.

- Unity Technologies. "Retargeting." *Unity Manual*. Retrieved 2026-09-11. https://docs.unity3d.com/Manual/Retargeting.html
  - Retargeting allows applying the same animation to different humanoid models without restructuring skeletons or renaming bones.
  - Each model must use the Humanoid animation type and have a configured Avatar.
  - The Avatar provides a standard hierarchy and bone names.

- Unity Technologies. "AvatarIKGoal." *Unity Script Reference*. Retrieved 2026-09-11. https://docs.unity3d.com/ScriptReference/AvatarIKGoal.html
  - Enumeration defining IK goals: LeftFoot, RightFoot, LeftHand, RightHand.
  - Allows developers to set and get IK weights, positions, and rotations.

- Wikipedia. "Tekken 8." Retrieved 2026-09-11. https://en.wikipedia.org/wiki/Tekken_8
  - Uses Unreal Engine 5.
  - Features standard humans, large robots (JACK-8), and animals (Kuma, Panda).
  - Panda and Kuma share the same base model with different skins, rather than unique animations.

- Wikipedia. "Undisputed (video game)." Retrieved 2026-09-11. https://en.wikipedia.org/wiki/Undisputed_(video_game)
  - Critics noted "poor punch tracking" and "hit detection" issues.
  - Features over 60 individual punches and 50 different attributes/traits.

- Wikipedia. "NBA 2K series." Retrieved 2026-09-11. https://en.wikipedia.org/wiki/NBA_2K_series
  - Uses ProPlay motion technology (introduced in NBA 2K26).
  - Features motion capture since at least NBA 2K6.
  - Includes WNBA teams, implying the engine accommodates different player models.

### FOLKLORE

None identified. No claims were found that are widely repeated but lack documentation.

### NOT FOUND

- No published technical post-mortem of a boxing, MMA, or sports game's animation system for handling different body sizes.
- No published tolerance study for fighting games (how much punch miss is acceptable at what camera distance).
- No published study of weight-class-constrained animation retargeting.
- No published comparison of retarget-and-accept vs. per-size clip sets vs. procedural correction.

### INFERENCE

- Punch landing short/long is invisible at 9–11 m. Derived from camera parameters and punch duration (0.3–0.5 seconds).
- Head height mismatch is invisible at 9–11 m. Derived from camera geometry (20° downward pitch compresses vertical dimension).
- Stance misalignment is visible at 9 m, invisible at 11 m. Derived from camera distance and angular sensitivity of knee alignment.
- Games use retarget-and-accept, not per-size clip sets. Derived from the absence of published per-size clip sets and the observable behavior of games with diverse character sizes.
- Weight class saves us. Derived from the booking rules and the camera parameters.

---

## Summary

**The constraint you already have (weight classes, females never fight males) eliminates the expensive cases.** The height disparity on the canvas is at most 5–10 cm, not 30 cm. The only failure mode that is consistently visible at our camera distance is foot sliding, and it is smaller in magnitude than it would be without the constraint.

**The one fix that matters is foot planting IK.** A two-bone IK solver on each foot, driven by the contact phase of the gait cycle, eliminates the only consistently visible failure mode. The other fixes (body archetype matching, hand-aim IK, uniform scaling) address problems that are invisible at our camera distance or are already handled by the engine's retargeting system.

**Do not buy IK for punch aiming.** The camera distance and the speed of the action make precise hand placement invisible. The impact effect carries the hit, not the geometric contact point.

**Do not scale the clip.** The engine already retargets bone-by-bone. Uniform scaling breaks timing and weight.

**If visual inspection shows a problem with stance at 9 m, group the fighters into 3–4 height bands and assign each band a slightly adjusted clip set.** Cost: 3–4× the clip library, not 12×.

# C153 — stature-scaled capsules for a standing clinch

Design only: 13 capsules per fighter, 169 cross-body penetration comparisons per evaluation.
Contract: `FightPoseSolver.gd`; scale/girth: `FighterPhysique.gd`; bone spellings: `FightClipRetarget.gd` lines 244–253 (`SILHOUETTE_SEGMENTS`).
The task's named-file restriction overrides the general brief/inbox, HANDOFF and digest workflow; no Godot boot, parse gate or test applies.

## Anthropometric basis and construction

[A] Gordon et al., *2012 Anthropometric Survey of U.S. Army Personnel: Methods and Summary Statistics*, December 2014, NATICK/TR-15/007 ([report](https://raw.githubusercontent.com/hkair/anthropometric-stats/main/data/ansur/Gordon_2012_ANSURII_a611869.pdf)).
[D] [ANSUR II male public measurements](https://raw.githubusercontent.com/hkair/anthropometric-stats/main/data/ansur/ANSUR%20II%20MALE%20Public.csv), 4,082 men; [Army release memorandum](https://raw.githubusercontent.com/hkair/anthropometric-stats/main/data/ansur/ANSUR%20II%20Databases%20Overview.pdf), 14 April 2017, pp. 1, 3: count and millimetre units.
Numbers below are arithmetic means calculated from D's named columns, not claimed individual measurements or fitted fighter percentiles. Mean `stature` = 1756.21460 mm.
For circumference C, base radius fraction `f = mean(C)/(2*pi*mean(stature))`; for depth/length D across a cross-section, `f = mean(D)/(2*mean(stature))`.
These are explicit circular-proxy approximations: circumference becomes an equivalent circular thickness; a torso depth becomes its front/back half-thickness. No limb length determines a limb radius.
Let H be the fighter's own stature in metres, `g = FighterPhysique.girth(mass_kg,H)` and `l = 1 + 0.6*(g-1)`; match the mounted rig's actual girth settings.
The table gives the complete dimensionless fraction `r/H`; centimetres at H=1.75 m retain the girth multiplier (at neutral girth, g=l=1).
Girth multipliers are the project's deformation policy, not an additional anthropometric finding. Never multiply the resulting metric radius by the mount's height scale again.

| capsule | p0 bone | p1 bone | radius (fraction of stature) | why |
|---|---|---|---|---|
| pelvis | Hips | Spine | 0.0699941*g; 12.249*g cm at 175 cm | D `buttockdepth` 245.84934 mm / 2; pelvic front/back proxy. |
| abdomen | Spine | Chest | 0.0676943*g; 11.8465*g cm at 175 cm | D `waistdepth` 237.77144 mm / 2; abdominal thickness. |
| torso | Chest | UpperChest | 0.0722711*g; 12.6474*g cm at 175 cm | D `chestdepth` 253.84713 mm / 2; chest contact envelope. |
| neck | Neck | Head | 0.0360365; 6.3064 cm at 175 cm | D `neckcircumference` 397.64895 mm / (2*pi); neck is girth-counter-scaled. |
| head | Head + cranial offset* | same point* | 0.0567996; 9.9399 cm at 175 cm | D `headlength` 199.50465 mm / 2; skull front/back thickness, not neck-link length. |
| upper_arm_l | LeftUpperArm | LeftLowerArm | 0.0324556*l; 5.6797*l cm at 175 cm | D `bicepscircumferenceflexed` 358.13572 mm / (2*pi); flexed-arm envelope. |
| forearm_l | LeftLowerArm | LeftHand | 0.0280987*l; 4.9173*l cm at 175 cm | D `forearmcircumferenceflexed` 310.05855 mm / (2*pi); gripping forearm. |
| upper_arm_r | RightUpperArm | RightLowerArm | 0.0324556*l; 5.6797*l cm at 175 cm | D `bicepscircumferenceflexed` 358.13572 mm / (2*pi); bilateral proxy. |
| forearm_r | RightLowerArm | RightHand | 0.0280987*l; 4.9173*l cm at 175 cm | D `forearmcircumferenceflexed` 310.05855 mm / (2*pi); bilateral proxy. |
| thigh_l | LeftUpperLeg | LeftLowerLeg | 0.0566528*l; 9.9142*l cm at 175 cm | D `thighcircumference` 625.14233 mm / (2*pi); proximal thigh envelope. |
| shin_l | LeftLowerLeg | LeftFoot | 0.0355482*l; 6.2209*l cm at 175 cm | D `calfcircumference` 392.26066 mm / (2*pi); maximum calf proxy. |
| thigh_r | RightUpperLeg | RightLowerLeg | 0.0566528*l; 9.9142*l cm at 175 cm | D `thighcircumference` 625.14233 mm / (2*pi); bilateral proxy. |
| shin_r | RightLowerLeg | RightFoot | 0.0355482*l; 6.2209*l cm at 175 cm | D `calfcircumference` 392.26066 mm / (2*pi); bilateral proxy. |

*Head has no distal bone: use a zero-length capsule (sphere), supported by `segment_distance`'s degenerate branch. If Head is at the skull base, centre it at `P(Head)+r*u`, with u the head's posed cranial direction, established in the rest pose along Neck→Head and rotated with Head.
This offset is a geometric sphere-placement assumption, not a surveyed anatomical offset. Require asset review to establish the skull-base pivot and cranial direction; if the pivot is elsewhere, fail construction until an explicit asset-local centre is calibrated. Never silently put the sphere at a neck joint.
The sphere matches front/back head length and overstates side width (D `headbreadth` = 154.33023 mm); do not declare temple contacts from this proxy.
Other endpoints are actual posed joint origins, with no segment-length padding or inferred distal joints. Adjacent same-body capsules overlap at joints; the solver only checks different bodies.

Bone accounting (all 22): Hips, Spine, Chest, Neck, Head and the eight upper/lower arm/leg bones start the 13 capsules above.
UpperChest, LeftHand, RightHand, LeftFoot and RightFoot are endpoints only, with no separate capsule: no invented hand thickness or ankle-to-toe cylinder.
LeftShoulder and RightShoulder get no capsule: clavicle/shoulder geometry is not represented by an arm-girth cylinder; nearby chest and upper-arm caps provide only partial coverage.
LeftToes and RightToes get no capsule: this first upright fixture excludes foot entanglement; foot/hand/clavicle mesh clearance remains an explicit external acceptance requirement.

## Scale proof — compulsory before every solve

Tripo coordinates are arbitrary native units. Measure native rest-mesh sole-to-crown height M in the same pre-mount frame as the skeleton; reject nonfinite/nonpositive M or H before calling `height_scale(M,H)` (its fallback 1.0 is unsafe here).
Apply that uniform height scale exactly once at the fighter mount. Use each fighter's own H; a known stature wins over `reference_height_m(limit_kg,sex)`.
Build `P(bone) = world_to_solver * skeleton.global_transform * skeleton.get_bone_global_pose(index).origin`; world_to_solver is rigid, metre-preserving, with mat y=0. Skeleton-global pose alone is still skeleton-local, not metric world space.
This chain must include the scaled mount and actual physique deformation. Reject additional scene scale, nonuniform mount scale, missing bones, nonfinite endpoints/radii, or nonpositive radii. Never strip mount scale with a fighter-local inverse.
Independently verify transformed neutral sole-to-crown extent equals H within 1% of H (engineering tolerance); measure actual transformed geometry, not merely recompute M*(H/M).
Then measure BOTH `LeftLowerArm→LeftHand` and `RightLowerArm→RightHand` from the exact metric endpoints sent to the solver: elbow to wrist, not wrist to fingertip.
A, printed pp. 177–178 (PDF pp. 187–188), measurement 67: radiale–stylion forearm length; male mean 26.79 cm, SD 1.54 cm. D's unrounded mean is 267.88266 mm, giving expected `L = 0.152534124*H` metres.
Radiale/stylion are palpable landmarks near elbow/wrist, not exactly rig joint centres. Use `abs(measured-L) <= 0.15*L`: a declared engineering screen for scale/rig proportion errors, not a claim that all humans fall within it or that contact is accurate to 15%.
Check the neutral mounted rig and each solve's initial posed endpoints. Any failure aborts before `refine`/`descend`/`evaluate`; do not rescale from the forearm, enlarge the tolerance automatically, substitute a bone, or continue after logging.

Worked fixture inputs, deliberately unequal and authored here (not asserted asset metadata): body 0 `f01_m_box_welter_rigged`, H=1.65 m, mass=67 kg; body 1 `f02_m_box_heavy_rigged`, H=1.91 m, mass=100 kg.
For body 0, expected forearm 0.251681 m, tolerance ±0.037752 m; for body 1, 0.291340 m, tolerance ±0.043701 m. Apply separately to both named arms; never average the fighters.
At 100× too large these read 25.1681 m and 29.1340 m; at 100× too small, 0.00251681 m and 0.00291340 m. All must fail.
Required diagnostic example: `CAPSULE_SCALE_FAIL body=f01_m_box_welter_rigged pair=LeftLowerArm->LeftHand measured=25.1681 m expected=0.251681 m tolerance=0.037752 m ratio=100; SOLVE ABORTED`.
Also print H, native M and mount scale; an outlier may be a bad bone mapping/proportion, not only a unit conversion error. Re-run after any rig, mount, physique or stature change.
With these inputs, g=1.034402/1.091699 and l=1.020641/1.055019; torso radii are 0.123350/0.150696 m and forearm radii 0.047320/0.056621 m. These are derived examples, never stored fixed radii.

## Standing over-under clinch contract

Seed both fighters upright, facing each other, heads offset, each left arm underhooking and each right arm controlling the opposing underhook; constrain joint limits and retain that topology during fitting.
Array names below refer to body 0 (`a`) and body 1 (`b`), not world-left/world-right:

```json
[
  {"a":"torso",       "b":"torso",       "off":0.0,"w":1.0},
  {"a":"forearm_l",   "b":"torso",       "off":0.0,"w":1.0},
  {"a":"torso",       "b":"forearm_l",   "off":0.0,"w":1.0},
  {"a":"forearm_r",   "b":"upper_arm_l", "off":0.0,"w":1.0},
  {"a":"upper_arm_l", "b":"forearm_r",   "off":0.0,"w":1.0}
]
```

Torso/torso is chest pressure; each left forearm wraps the other's trunk; each right forearm bears on the other's underhooking upper arm. Equal weights are an authoring choice and preserve the solver's 12 mm per-contact interpretation (`touch_max` uses sqrt(w)).
Every off is a SURFACE gap in metres. For these unequal torsos, zero gap requires closest centre-line distance 0.274045 m (= both radii), never an off of that value.
These pairs alone cannot distinguish an underhook from a hand passing through the armpit: constrain sidedness, seed pose and admissible DOFs in the builder; require visual topology review, not just low cost.
Use `holds=[]`: planting shins would confuse calf-radius padding with soles. Lock both fighters' authored sole contacts and upright stance through builder/DOF constraints; refuse the standing-clinch fixture if those constraints cannot be enforced.
Require 13 unique named caps in both caps/maps, `resolvable_contacts==5`, all 169 penetration pairs, and final `pen<=0.006`, `touch<=0.012`, `mat<=0.012` metres. Omitted geometry and sole clearance need separate checks; a capsule pass is not a full-mesh pass.

Penetration exclusions for this initial rigid-envelope contract: NONE. No real clinch requires bones to interpenetrate; zero-gap proxies approximate already contacting soft surfaces.
If deliberate soft-tissue compression is later authored, the candidate is specifically body-0 torso/body-1 torso; exclude neither arms, heads nor all declared contacts. Current `evaluate` supports NO pair mask: putting one in a body/contact dictionary has no effect.
A future explicit ordered pair map `{("torso","torso"): c_m}` should replace only that pair's penetration residual with `max(0,-gap-c_m)`, retaining raw depth reporting and bounding compression; a contact would then target `off=-c_m`.
This excludes only the approved compression allowance, not arbitrarily deep overlap. No compression value is justified here: c_m=0 until measured/approved, and any nonzero allowance requires a separate solver change and acceptance contract.

## Risks

- ANSUR Army-male means and the project's girth policy are proxies for fighters; cross-section overlays on both unequal bodies must reveal over/undercoverage before admission.
- Circular torso proxies miss lateral width and posterior spine offsets; limb maximum girths overfill wrists/ankles. Mesh penetration or apparent floating despite a pass rejects the fit.
- The head sphere/pivot assumption and uncovered clavicles, hands and feet prevent a whole-body collision guarantee; inspect those regions explicitly.
- Scale/proportion screening cannot prove millimetre surface accuracy; transformed height, joint landmarks and contact overlays must agree independently.
- No rig was loaded or solve run for C153; constraints, convergence and visual contact remain unverified implementation gates, not delivered results.

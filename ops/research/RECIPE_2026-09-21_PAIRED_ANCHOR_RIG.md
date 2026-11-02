# RECIPE, pasted by the operator 2026-09-21 — a paired anchor rig in Blender

**Saved verbatim first, assessed second.** The operator asked "are we doing
this?" The answer is **no, we are not**, and the assessment is below the recipe.

---

## THE RECIPE AS PASTED

> Build the Constraint Chain (Per Fighter)
> For EACH fighter, add these bones to their armature (Edit Mode):
>
> ```
> FighterA_Root
> └── ... (standard hierarchy)
> └── IK_Targets (new bone, parented to Root)
>     ├── Chest_IK_Target
>     ├── LeftHand_IK_Target
>     ├── RightHand_IK_Target
>     ├── LeftFoot_IK_Target
>     └── RightFoot_IK_Target
> ```
>
> Pose Mode → Add Constraints to the IK Targets:
>
> | Target Bone | Constraint Type | Target | Space | Influence |
> |---|---|---|---|---|
> | Chest_IK_Target | Child Of → Set Target = Interaction_Anchor | Interaction_Anchor → Chest marker | World | 0.0–1.0 (animatable) |
> | LeftHand_IK_Target | Child Of → Set Target = Interaction_Anchor → LeftGrip marker | Interaction_Anchor → L hand | World | 0.0–1.0 |
> | RightHand_IK_Target | Child Of → Set Target = Interaction_Anchor → RightGrip marker | Interaction_Anchor → R hand | World | 0.0–1.0 |
>
> Key: When Influence = 1.0, that limb is locked to the anchor — Fighter A moves
> the anchor → Fighter B follows automatically
>
> ### Step 1.3 — IK Solver Setup (Limb Chains)
> For each limb that will connect to the anchor:
>
> Arm Example (Left):
> - Select LeftForearm → Add IK Constraint
> - Target: LeftHand_IK_Target
> - Pole Target: a new bone behind the shoulder (Pole_Shoulder_L)
> - Chain Length: 2 (shoulder → arm → forearm → hand)
> - Iterations: 50
> - Influence: 1.0 when gripping; 0.0 for free movement
>
> Leg Example:
> - Same pattern: Shin → IK → Foot_IK_Target
> - Pole Target behind knee (Pole_Knee_L)
> - Chain Length: 2
>
> ### Step 1.4 — The "Reaction Weight" Trick
> Add a Second Constraint to the chest/spine:
> - Spine_Chest → Copy Transforms → Target = opponent's Chest_IK_Target
> - Influence = 0.15–0.35 (partial drag)
>
> This means: when Fighter A pulls, Fighter B leans into it naturally — not
> rigidly glued, like real physics
>
> ## Part 2: The State Transition Architecture (In Blender First, Then Engine)
>
> ### 2.1 — Define Your Anchor Presets
> These are your only keyframed transition points — you don't animate every frame:
>
> | State | Anchor Position | Locked Limbs | Influence |
> |---|---|---|---|
> | Standing | Off — independent movement | None | 0.0 |
> | Clinch | Mid-chest, 0.4–0.6m apart | Both hands → anchor | 0.7–1.0 |
> | Takedown Entry | Drops to lead hip height | Both hands + lead hip | 0.8–1.0 |
> | Guard Pull | Descends to floor, one side offset | One hand locked, one free | 0.6–0.9 |
> | Mount | Over opponent's chest/pelvis | Hips + hands | 0.9–1.0 |
> | Armbar Setup | Between opponent's gripped arm + hip | 1 hand locked, hip aligned | 0.85 |
>
> ### 2.2 — How to Animate Transitions (The 3-Second Rule)
> Don't animate full sequences — animate the ANCHOR:
> - Keyframe Interaction_Anchor moving from Clinch → Takedown → Floor
> - The IK chains pull both fighters into correct relative positions automatically
> - Layer local movement on top (head movement, free hand strikes, leg adjustments)
> - Bake result → export as paired FBX
>
> Timing Template:
> - Approach: 10–15 frames
> - Lock-on (anchor influence ramps 0→1): 6–10 frames
> - Transition movement: 15–30 frames
> - Release (influence 1→0): 4–8 frames

---

## ARE WE DOING THIS? NO.

Our pipeline is: acquire single-actor clips (RamsterZ, Motifect, Cascadeur,
CMU) → `FightClipRetarget` copies rotations onto our rigs → `FightWorldLiveScreen`
places two independent bodies and, since S36, refuses interpenetration
geometrically. **There is no Interaction_Anchor, no paired constraint rig, and no
shared authoring step anywhere in the tree.**

## WHAT THE RECIPE GETS RIGHT

**The central idea is correct and it is the thing we are missing.** Animating ONE
shared anchor and letting both bodies follow makes contact true *by construction*
rather than by correction. That is exactly the failure our own study measured:
`HIGGSFIELD_MMA_PIPELINE_STUDY.md` composed 6 attackers × 6 defenders with the
defender deliberately turned to face, fall onset on the attacker's reach frame
and mid-thigh on his hands — and scored **0 of 36**, every attacker stopping at
the grab with 0.00–0.06 m of follow-through and torsos interpenetrating in 16–81%
of frames. Two independent clips cannot be made to hold a grip. A shared anchor
can.

**"Reaction weight" is the right instinct too.** A partial Copy Transforms
(0.15–0.35) so the gripped man leans rather than snapping is how this is done
properly; rigid parenting reads as glued.

**Keyframing the anchor instead of every frame** is the real labour saving, and
the timing template is a sane starting shape.

**Baking before export is required, not optional, and the recipe says so.** In
Godot `SkeletonModifier3D` / `TwoBoneIK3D` never run in an `_initialize`-stepped
test — the pose only solves when a frame is drawn — so any IK we ship must be
baked offline. The recipe's "Bake result → export as paired FBX" is compatible
with that constraint.

## WHERE IT FAILS, WITH OUR OWN NUMBERS

**1. The clinch distance is wrong for us.** The preset table says *"Clinch:
mid-chest, 0.4–0.6 m apart"*. We have two independent measurements of a real
clinch and neither agrees:

| source | method | figure |
|---|---|---|
| Q115 | tracked broadcast footage | **0.719 m** hip-to-hip |
| CMU `18/19_05` | free paired mocap, S34 | **0.766 m** root-to-root minimum |

Two completely different methods landing within 5 cm of each other, and both
~20 cm looser than the recipe's upper bound. Authoring to 0.4–0.6 m would build
an unreally tight clinch into every state that inherits from it.

**2. It assumes an animator, and we have never had one.** The recipe's cost is
entirely in keyframing anchor presets by hand. `R144_LINE3_AUTHORING_COST.md`
priced the scripting at 6–10 h and left **the posing deliberately unpriced**,
because authoring motion from nothing is a skill this project has not once spent
time on. The constraint rig is the easy half.

**3. One line is internally inconsistent.** *"Chain Length: 2 (shoulder → arm →
forearm → hand)"* describes a three-bone chain and specifies two. Blender counts
bones up from the constrained one, so an IK on the forearm with length 2 covers
upper arm + forearm, which is what you want — the parenthetical is just mislabelled.
Harmless, but it is the kind of line that gets followed literally.

## HOW I WOULD RUN IT

**Do not author the first anchor by hand. Derive it from a capture we already
have and can check against.** `18/19_05` is two frame-synced bodies in one world
space, and two independently written readers agree on its joint positions to
**21 micrometres**. So:

1. Compute the anchor from the capture — the midpoint of A's gripping hand and
   B's gripped elbow, per frame. No authoring, no guessing.
2. Drive both rigs from that anchor through the constraint chain.
3. Re-run `tools/probe_cmu_grip.gd` and ask whether the grip is preserved
   *better* than the 8.8% / 12.6% contact drift plain rotation retargeting
   leaves.

That gives the anchor pipeline a pass/fail against known ground truth **before**
a single hour is spent posing. If it cannot reproduce a capture it was handed,
it will not invent a good takedown either.

`FightAnchorIK.gd` (G60, landed 2026-09-21, blind-tested by G60T) is already the
engine-side two-bone solver this needs.

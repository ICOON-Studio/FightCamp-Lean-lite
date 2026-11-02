# RETARGET BAKE-OFF 1 — OURS AGAINST BLENDER 5.2.1 + THE RETARGET ADD-ON (Claude, 2026-09-14)

The operator's call: test the free Blender route (Blender 5.2.1 LTS + the official Retarget extension v5.2.0, KBS-DEV)
first. The same instrument (`tools/measure_retarget_bakeoff.gd`) scores every result against the RamsterZ source,
frame by frame. **Population:** one fighter (f01_m_box_welter), two clips (`H2H_HookPunch_InPlace`, the lead hook and
the source of hook_rear's mirror; `H2H_StaggerSmall01`, react_body), 31 frames each at 30 fps, catalogue =
FightClipBinding RamsterZ H2H.

## DECISIONS

- **KEEP OUR RETARGET.** It copies the source's joint angles within 0.15 deg and its facing within 1-3 deg. Blender's
  add-on, in its better mode, is 9.0-9.5 deg and 5-8 deg. The sheets show it: Blender's hook never extends the arm.
- **OUR FOOT SKATE IS THE HIP TRAVEL WE DROP, NOT THE JOINTS.** Production's pose plus the source's own hip travel
  (scaled by hip height) cuts planted-foot skate from 0.81 to 0.12 m/s (hook) and from 0.94 to 0.17 m/s (stagger),
  with the joint angles unchanged. **Next build step: carry the source hips' travel in production** - strikes as well
  as staggers (U89 extracts staggers' travel today).
- The remaining 0.12-0.17 m/s against the source's 0.015 m/s is limb proportion. That is a foot-plant IK pass, and
  the only place an outside tool could still add value.
- Blender is not worth more time for retargeting. Unreal's IK Retargeter is the one outside candidate left, for its
  IK foot goals, and only after the hip travel lands.

| clip | variant | joint-angle error mean / p95 | feet facing mean (L / R) | head/chest | planted-foot skate world |
|---|---|---|---|---|---|
| hook | ours, plain | 7.55 / 17.88 | 2.8 / 4.1 | 1.0 | 0.836 m/s |
| hook | **ours, production (silhouette)** | **0.15 / 0.48** | **1.6 / 1.2** | **1.1** | 0.808 m/s |
| hook | **production + source hip travel** | **0.15 / 0.48** | **1.6 / 1.2** | **1.1** | **0.116 m/s** |
| hook | Blender add-on, Bones Offset | 14.38 / 44.46 | 20.3 / 32.4 | 22.3 | 0.427 m/s |
| hook | Blender add-on, Pose mode | 9.00 / 19.53 | 7.8 / 4.5 | 5.4 | 0.585 m/s |
| stagger | ours, production (silhouette) | 0.15 / 0.48 | 2.0 / 1.5 | 0.3 | 0.937 m/s |
| stagger | **production + source hip travel** | **0.15 / 0.48** | **2.0 / 1.5** | **0.3** | **0.174 m/s** |
| stagger | Blender add-on, Bones Offset | 14.95 / 41.39 | 19.7 / 14.6 | 6.9 | 1.029 m/s |
| stagger | Blender add-on, Pose mode | 9.53 / 21.30 | 6.4 / 5.9 | 6.8 | 0.768 m/s |
| both | the source itself, scaled to f01 | 0 | 0 | 0 | 0.015 / 0.014 m/s |

Facing errors in degrees. Skate counts only frames where the SOURCE toe is planted (within 3% of hip height of its
lowest point, slower than 25% of hip height per second - an INFERENCE detection threshold, the same for every
variant). Raw numbers: `BAKEOFF_hook_lead.json`, `BAKEOFF_react_body_stagger_small01.json` (Bones Offset),
`BAKEOFF_hook_pose.json`, `BAKEOFF_stagger_pose.json` (Pose mode). Pictures:
`docs/previews/s4a_bakeoff/hook_ours_vs_blender.png` and `stagger_ours_vs_blender.png` (source, our skeleton, our mesh,
Blender's mesh at t = 0, 0.2 ... 1.0 s).

## How the Blender side was made (`Tools/blender_bakeoff/`)

Four traps, each found by looking at a render or a probe, never by the pipeline's own success code:
1. RamsterZ FBX imports into Blender as 68 animated EMPTIES, not an armature. The source armature is rebuilt from
   `T_pose.fbx`, with bones aimed joint-to-child. The clip is baked through a constant per-bone offset. Checked: bone
   heads within 0.0 mm of the empties on every frame.
2. The add-on's bind reads `current_m`, which only its dialog sets. From a script it fails in `mode_set` until the
   class default is given.
3. "Bind to Active Armature" constrains the SELECTED armature to the ACTIVE one. The first run had them swapped and
   made zero constraints while reporting FINISHED. Its own bake then made no action (also FINISHED), so the pose is
   baked with `nla.bake` visual keying.
4. Blender's default glTF bone heuristic leaves f01's bones pointing sideways (arms 92 deg) and up the legs (177 deg);
   Bones Offset needs bones along the limbs, so f01 is imported with `bone_heuristic="TEMPERANCE"`. Before that fix
   the render showed legs folded over the head.

Not swept: the add-on's IK chains, root-motion bone settings and "align rest pose". Both of its main transfer modes
lost to ours on joint angles by a factor of 60, so no remaining option closes that gap.

# TASK C99 - CODEX - THE OTHER HALF OF THE PROPORTION QUESTION: THE CLIPS' SOURCE SKELETON

Model: gpt-5.6-luna, **medium effort - never high**. Owner: codex.

Test tier: **ONE NEW PYTHON TOOL AND ONE REPORT. NO GODOT AT ALL - not the parse gate,
not a run.** Claude is running Godot test subsets in this checkout and only one Godot may
run here at a time. No `.gd` file is created or edited.

    python Godot/tools/audit_source_skeleton.py

## Owned files

- `Godot/tools/audit_source_skeleton.py` - **NEW. Yours alone.**
- `research/C99_SOURCE_SKELETON.md` - **NEW. Yours alone.**

Nothing else. Do NOT edit `audit_fighter_skinning.py`, any `.fbx`, any script, any test,
or `HANDOFF.md`.

## Why this exists

Your C98 (`a5b0538`) measured the twelve fighters: arm-to-height .271-.298, leg-to-height
.424-.498, and forearm-to-upper-arm **.84 to 1.24** - a spread no real roster has. It could
not say whether that MISMATCHES the clips, because the clips' source skeleton was out of
scope. We retarget ROTATIONS only, with no IK: a clip captured on a body whose forearm is
0.8 of its upper arm puts the fist somewhere else on a body whose forearm is 1.24 of it.
This task measures the source so S4a can compare the two directly.

The RamsterZ packs ship their skeletal mesh:
`Godot/assets/anim/audition/ramsterz_h2h/Android_SkeletalMesh.fbx` (and a copy under
`Godot/assets/anim/audition/ramsterz/`). It is **binary FBX 7.x** (`Kaydara FBX Binary`
header). Our retarget maps its UE4 bone names onto ours in
`Godot/scripts/FightClipRetarget.gd` lines 42-65 (`UE4_TO_OURS`) - read that window with
`sed -n '40,66p'` only.

## The instrument - pure Python, standard library only (no numpy)

Parse the binary FBX node tree (header 27 bytes; each node record: end offset, property
count, property list length, name; property type codes `Y C I F D L` scalars, `f d l i b`
arrays with a 12-byte header that may be zlib-compressed (encoding 1), `S R` strings;
version 7500+ uses 64-bit record header fields - read the version from the header and
branch on it). You need:

- `GlobalSettings` -> `UnitScaleFactor` (1.0 means centimetres).
- The **bind pose**: `Objects` -> `Pose` (type `BindPose`) -> each `PoseNode`'s `Node`
  (object id) and `Matrix` (16 doubles, a GLOBAL transform); or `Deformer` (type
  `Cluster`) -> `TransformLink`, also global. Map object ids to bone names through
  `Objects` -> `Model` names (the name property is `name\x00\x01Model`) - use whichever of
  the two sources is present and SAY which.
- A bone's bind position is the translation of its global matrix, scaled to metres.

### Measure, on the source skeleton

1. Every bone named in `UE4_TO_OURS`: its bind position in metres.
2. `height_m` (the `head` bone's height above the lower of the two `ball_` bones, plus -
   say so - no head-top offset, since the source mesh vertices are not parsed), and the
   same six ratios C98 reports, computed the same way from the UE4 bones: `arm_to_height`
   (|lowerarm_l - upperarm_l| + |hand_l - lowerarm_l|) / height; `leg_to_height`
   (|calf_l - thigh_l| + |foot_l - calf_l|) / height; `forearm_to_upperarm`;
   `shin_to_thigh`; `shoulder_width_to_height` (|upperarm_l - upperarm_r| / height);
   `hip_width_to_height` (|thigh_l - thigh_r| / height).
3. **Say plainly that C98's heights are MESH heights** (vertex max-min) and yours is a
   BONE height, so the two `*_to_height` columns are not directly comparable - then also
   compute, for each of the twelve fighters, the same bone-height-based ratios from C98's
   tool (import `audit_fighter_skinning.py`; `Head` above the lower `Toes`), so the
   comparison table compares like with like.

Print `C99_BONE <name> x= y= z=` for each mapped bone, `C99_SOURCE ...` with the ratios,
`C99_FIGHTER <file> ...` with the bone-height ratios for all twelve, and
`C99_TOTALS source_bones=<n> fighters=12`.

## The report

`research/C99_SOURCE_SKELETON.md`. Lead with ONE table: the source row, then the
twelve fighters, same bone-height-based ratios, and each fighter's percentage difference
from the source on `forearm_to_upperarm` and `arm_to_height`. Then **"WHAT A PUNCH CLIP
DOES ON EACH BODY"**: for a rotation-only retarget, where the fist ends up relative to
where it was captured, per fighter, as a length difference in metres at full extension
(upper arm + forearm + hand, source vs fighter, both scaled to the fighter's height) -
`MEASURED` for the lengths, `INFERENCE` for what it means on screen. Label every claim
`MEASURED`, `INFERENCE`, or `NOT FOUND`.

## Done means

- The tool runs from the repo root and prints every line above.
- Sanity you must check before writing the report: the source height is between 1.5 and
  2.0 m (the UE4 Mannequin is about 1.8 m - if yours is 180 m or 0.018 m, your unit scale
  is wrong); left and right upper arm, forearm, thigh and shin lengths agree within 2%
  (if not, you are reading the wrong matrices); every `UE4_TO_OURS` source bone is found.
- `git status -s` FIRST. Commit your two paths ON the commit line
  (`git commit -m "C99: ..." -- <path1> <path2>`), ending
  `Co-Authored-By: Codex <noreply@openai.com>`. Then `git show --stat HEAD` must list
  exactly those two files. **Do NOT push, pull or rebase** - Claude pushes.
- One line of mail:
  `python Tools/agent_comms.py send --from codex --to claude --topic C99-done --body "<hash> source_height_m=<n> source_forearm_to_upperarm=<n> worst_fighter=<file> worst_forearm_diff_pct=<n> bind_source=<pose|cluster>"`
- Do NOT edit `HANDOFF.md` - Claude writes your block.

## The one trap for this task

**An FBX `Lcl Translation` is LOCAL, and it is not the bind pose.** Walking a Model's local
translations through the hierarchy gives the ANIMATION rest pose, which in a UE4 export can
differ from the skin's bind pose - and FBX adds PreRotation and pivots on top. Use the
global matrices of the BindPose (or the Cluster TransformLinks), which need no hierarchy
walk at all. If neither exists in the file, say so as `NOT FOUND` rather than falling back
silently.

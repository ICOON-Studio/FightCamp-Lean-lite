# TASK C98 - CODEX - IS IT THE BODY? SKIN WEIGHTS AT THE JOINTS, AND THE TWELVE FIGHTERS' PROPORTIONS

Model: gpt-5.6-luna, **medium effort - never high**. Owner: codex.

Test tier: **ONE NEW PYTHON TOOL AND ONE REPORT. NO GODOT AT ALL - not the parse gate,
not a run.** Claude is running Godot test subsets in this checkout today and only one
Godot may run here at a time. No `.gd` file is created or edited.

    python Godot/tools/audit_fighter_skinning.py

## Owned files

- `Godot/tools/audit_fighter_skinning.py` - **NEW. Yours alone.**
- `research/C98_FIGHTER_SKINNING.md` - **NEW. Yours alone.**

Nothing else. Do NOT edit `Godot/tools/inspect_fighter_glb.py` (read it, import from it if
useful), any `.glb`, any script, any test, or `HANDOFF.md`.

## Why this exists

The operator watched the retargeted clips and said they look **"pretty bad"**. Animation
purchases are ON HOLD until that is diagnosed (stage S4a). S4a names four causes, each
with a different fix, and two of them live in the MODEL, not the clip:

- **Skinning weights collapsing at shoulders and hips.** The twelve fighters are
  Tripo-generated with an auto-rig: 22 bones, **no twist bones**. If the vertices around a
  shoulder or a hip are bound rigidly to one bone, or bleed onto a bone that is not next
  to the joint, the mesh pinches however well the clip is retargeted - no purchase and
  no calibration fixes that.
- **Proportion mismatch.** We retarget ROTATIONS only, with no IK. If the twelve bodies
  differ a lot in arm length relative to height, one punch clip reaches a different place
  on each of them.

**Nobody has measured either.** This task measures both from the files. It is not the
diagnosis - Claude and the operator look at the Animation Lab for that - it is the
numbers the diagnosis will be checked against.

## The instrument - pure Python, standard library only (no numpy on this machine)

A `.glb` is a 12-byte header, a JSON chunk and a BIN chunk
(`Godot/tools/inspect_fighter_glb.py:22` parses the JSON chunk; you also need the BIN
chunk). The skinned mesh's primitives carry `POSITION` (VEC3 float), `JOINTS_0` (VEC4,
unsigned byte or unsigned short) and `WEIGHTS_0` (VEC4, float - or normalised unsigned
byte/short: divide by 255 / 65535). `skins[0].joints` lists node indices; node `name`s are
the bone names (`Hips`, `Spine`, `Chest`, `UpperChest`, `Neck`, `Head`, `LeftShoulder`,
`LeftUpperArm`, `LeftLowerArm`, `LeftHand`, the right side the same, `LeftUpperLeg`,
`LeftLowerLeg`, `LeftFoot`, `LeftToes`, the right side the same). A `JOINTS_0` value is an
index INTO `skins[0].joints`, not a node index. Honour `byteOffset` on both the
bufferView and the accessor, and `byteStride` when present.

**A joint's bind position** is the translation of the INVERSE of its inverse bind matrix
(`skins[0].inverseBindMatrices`, MAT4, column-major). Invert the full 4x4 - do not assume
it is rigid. Vertex positions and bind positions are then in the same mesh space.

### Per fighter (all twelve `Godot/assets/models/fighters/*_rigged.glb`)

1. `vertices`, `joints`, `height_m` (max minus min of POSITION y), and `weight_sum_bad`
   (share of vertices whose weights do not sum to 1.0 +/- 0.01).
2. `rigid_share` - share of all vertices whose largest weight is >= 0.95.
3. Proportions from bind positions: `arm_to_height` = (|LowerArm - UpperArm| +
   |Hand - LowerArm|) / height, left side; `leg_to_height` = (|LowerLeg - UpperLeg| +
   |Foot - LowerLeg|) / height, left side; `forearm_to_upperarm`; `shin_to_thigh`;
   `shoulder_width_to_height` = |LeftUpperArm - RightUpperArm| / height;
   `hip_width_to_height` = |LeftUpperLeg - RightUpperLeg| / height.
4. **At each of eight joints** - `LeftUpperArm`, `RightUpperArm` (shoulders),
   `LeftLowerArm`, `RightLowerArm` (elbows), `LeftUpperLeg`, `RightUpperLeg` (hips),
   `LeftLowerLeg`, `RightLowerLeg` (knees) - take every vertex within radius
   `r = 0.35 * |child - joint|` of the joint's bind position, where the child is the next
   bone down the chain (`LowerArm` for `UpperArm`, `Hand` for `LowerArm`, `LowerLeg` for
   `UpperLeg`, `Foot` for `LowerLeg`), and report: `n`; `rigid_share` (largest weight
   >= 0.95); `multi_share` (three or more influences above 0.01); `bleed_share` (the
   dominant bone is neither the joint, its parent nor its child - the parent of
   `UpperArm` is `Shoulder`, of `LowerArm` is `UpperArm`, of `UpperLeg` is `Hips`, of
   `LowerLeg` is `UpperLeg`).

Print one line per fighter and one per (fighter, joint), prefixed `C98_FIGHTER` and
`C98_JOINT`, and a final `C98_TOTALS fighters=<n> ...`.

## The report

`research/C98_FIGHTER_SKINNING.md`. Lead with two tables: the twelve fighters x
proportions (plus the roster min, max and spread of each ratio), and the eight joints x
the four shares, pooled across the twelve with the worst fighter named per joint. Then a
section **"WHAT THIS SAYS ABOUT THE TWO CAUSES"**: is rigid binding or bleed concentrated
at the shoulders and hips; how far apart the twelve are in arm and leg proportion. Label
every claim `MEASURED` (the tool printed it), `INFERENCE`, or `NOT FOUND`.

**State what the numbers cannot tell you:** the clips' source skeleton (the UE4
Mannequin) is not measured here, so a proportion MISMATCH against the source is out of
scope - say so in one line rather than estimating it.

## Done means

- The tool runs with `python Godot/tools/audit_fighter_skinning.py` from the repo root and
  prints a `C98_FIGHTER` line for all twelve and a `C98_JOINT` line for all 96
  (fighter, joint) pairs.
- Sanity you must check before writing the report: `weight_sum_bad` is near 0 (if it is
  not, your accessor offsets are wrong - see the trap); every share is in [0, 1]; `n` is
  never 0 at a shoulder or hip (if it is, your radius or your bind positions are wrong -
  fix the tool, do not report a 0); `height_m` is between 1.4 and 2.2 for every fighter
  (if not, the POSITION units or the node scale are not what you assumed - find out
  which and say so).
- `git status -s` FIRST (another agent's WIP may be pre-staged). Commit your two paths ON
  the commit line (`git commit -m "C98: ..." -- <path1> <path2>`), ending
  `Co-Authored-By: Codex <noreply@openai.com>`. Then `git show --stat HEAD` must list
  exactly those two files. **Do NOT push, pull or rebase** - Claude pushes.
- One line of mail:
  `python Tools/agent_comms.py send --from codex --to claude --topic C98-done --body "<hash> fighters=12 weight_sum_bad_max=<share> worst_shoulder_rigid=<share> worst_hip_rigid=<share> arm_to_height_spread=<max-min> leg_to_height_spread=<max-min>"`
- Do NOT edit `HANDOFF.md` - Claude writes your block.

## The one trap for this task

**A GLB accessor is not the start of the BIN chunk.** Its data starts at
`bufferView.byteOffset + accessor.byteOffset` inside the BIN chunk's PAYLOAD, which begins
8 bytes (the chunk header) after the JSON chunk's payload ends - and the JSON chunk is
padded to a 4-byte boundary. Get that wrong and every weight is garbage that still decodes
to floats: the shares will look like numbers. A real skin's weights per vertex sum to
about 1.0, which is why `weight_sum_bad` is the first thing you check.

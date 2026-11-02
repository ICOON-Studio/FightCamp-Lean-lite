# C200 digest - one rig / one import convention

## How a small studio does this

Lock and version the master armature before scaling content (J49 sections 3 and 6/G6). In Blender, bind each new body to that armature, preserve the rest and inverse binds, apply the intended unit/axis convention, and export. In Godot, keep a reusable source-family BoneMap/retarget preset, bake to the master once at admission, validate names/rest/scale, and ship the baked resource. The [Godot retargeting article](https://godotengine.org/article/animation-retargeting-in-godot-4-0/) describes the BoneMap/SkeletonProfile and imported AnimationLibrary workflow. This is a production recommendation; this task does not install or claim a Blender add-on.

Chosen method: retain FightClipRetarget's proven per-bone correction and hip-ratio maths, and wrap them in one offline Godot converter rather than replace them with a second solver. Freeze the existing f01 GLB by SHA256 as FightCamp-f01-v1. The exact 22 bones, parent chains, rest translations/bases, +Z forward, metre units, body-centred origin and 1.85 m reference are in C200_RIG_SPEC.md.

## Delivered

- `Godot/tools/import_fighter_clip.gd`: UE4 FBX, Cascy glTF and canonical/video-tool glTF admission through the existing retarget path; unknown rigs require explicit one-to-one maps and matching rest references. Writes canonical Animation `.tres`; refuses existing outputs. CLI also validates mesh admission.
- `FightClipRetarget.gd`: glTF rig dispatch uses joint names rather than extension; a non-Cascy glTF cannot silently borrow the UE4 rest; sample cache includes map content rather than only its size. UE4_TO_OURS and the existing correction/pose calculations are unchanged.
- `rig_convention_contract_test.gd`: 37 checks, including actual UE4/Cascy conversion, generated canonical glTF interchange, saved-resource reload, missing/duplicate mapping refusal, named renamed-bone and centimetre-mesh mutants, foreign clip naming and centimetre translation mutants, and all twelve mesh measurements.
- `C200_RIG_SPEC.md`: strict admission specification and measured legacy inventory. All twelve match names/parents; f01 alone matches the locked rest. f02-f12 need deliberate rebinding to qualify; f06/f08 additionally have 1-unit meshes. These existing assets were not modified.

## RamsterZ invariant

Before editing FightClipRetarget, sampled the actual bound `react_head` window (H2H_HitReaction01.FBX, 2.47..3.03 s at 30 Hz) on f01, using the existing silhouette corrections and hip carry. Composed every bone's global pose explicitly from sampled animation keys and local rest translations at 18 times, avoiding the headless get_bone_global_pose trap. SHA256 over the serialized transforms:

`83f6a766b4dc398d3abda6526f58692f3c4925f680fc4fbe0300654c7289f9ea`

The same hash passes after the changes, pinned in the new contract. This is one bound-clip byte witness, not a claim that every bound clip was individually hashed.

## Gates

- Parse: 3 scripts, 0 failures.
- New contract: 37 checks, 0 failures; SUITE total=1 fails=0.
- clip_retarget: SUITE total=1 fails=0.
- cascy: SUITE total=1 fails=0.
- fight_clip: SUITE total=9 fails=0.
- fight_world_live: SUITE total=1 fails=0.
- fight_stage: SUITE total=10 fails=1, exactly the task baseline; only fight_stage_realism_test.gd is red (13 realism rules, 8 failing). Its log also reports a root-certificate-store error at shutdown. No realism assertions changed.
- Actual CLI conversion wrote `.godot/c200_react_head.tres`, status=0; output is ignored build evidence, not a new production binding.

An initial glTF fixture used an unavailable GLTFDocument method and failed at runtime; changed it to generate_buffer plus FileAccess. The subsequent full new contract and reload checks passed. No assertion was weakened.

## Boundaries

This is an explicit offline import/admission path, not an automatic editor hook. Existing live bindings remain compatible and continue their existing per-body retargeting; this task does not claim that all legacy content has been migrated onto one physical rest. Pair-contact/shared-origin baking remains in its existing pipeline; the new CLI does not silently approximate it. Video-tool interchange is proven with a generated canonical glTF fixture, not an external provider's output. No prohibited body models were used. No windowed Godot runs were needed. No HANDOFF, CURRENT_STATUS or archive reads/edits. The task-specific worktree/no-handoff rules superseded the generic shared-master startup/handoff rules.

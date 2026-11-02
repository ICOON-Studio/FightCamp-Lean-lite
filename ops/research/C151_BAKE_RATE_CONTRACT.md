# C151 — blind bake-rate contract

Production result: **checks=62 checks_failed=1**, exit 1. The CMU contract
passes; the FBX rate does not reach the animation. No implementation fix made.

Population: **CMU 18/19_05, 438 frames at 120 Hz; two DIFFERENT bodies;
A pulls B by the elbow, B resists.** Both bakes are sampled at the same 438
capture times. AnimationPlayer applies the loaded tracks; Skeleton3D composes
the parent chain and the scene transform supplies world space. Each frame
uses all hand-to-elbow pairs in both directions.

| Measurement (metres) | 30 Hz | 120 Hz |
| --- | ---: | ---: |
| Minimum | 0.145530701 | 0.140737116 |
| Median | 0.195463501 | 0.195952065 |

Median difference: **0.000488564 m**, within 0.004 m. Minimum ceiling 0.142 m
and floor 0.144 m both hold. CMU `lhumerus` rotation keys: **111 / 439** for
each subject. One-argument loading matches explicit 30 Hz on every key.
Other checks cover loading, driven limb selection, same-track comparison,
joint existence and distal hierarchy, sample coverage, finite extrema,
missing GLB/FBX returning null, and rejecting the measured 30 Hz minimum with
the very same high-rate ceiling.

## FBX finding

`H2H_HitReaction01.FBX` (fixture named in the existing retarget test) gives
**18 / 18** driven `root/pelvis/thigh_l` rotation keys through production.
A direct engine scratch probe also gives 18 / 18 when only
`FBXDocument.generate_scene(state, rate)` receives the rate. Setting
`FBXState.bake_fps = rate` **before `append_from_file`** gives **18 / 69**.
This is engine/API evidence, not a reading of the loader implementation.

## Mutation evidence

Opaque copies of the production module were transformed outside the repo;
no implementation text was displayed or searched for understanding. The
original byte hash remained unchanged. Scratch class names were removed to
avoid Godot's duplicate-global-class parse rejection. Scratch files/logs live
under `%TEMP%/c151_mutants/`, the Windows temporary directory, not the worktree.

Production mutations 1/2/3 produced respectively 4/3/1 contract misses.
Role swap and loose ceiling produced 13/2. **Production already exhibits
mutant 3's observable behavior**, so its red result alone is not an independent
kill. To avoid claiming that, an independent scratch control delegates GLB
to production and loads FBX directly with state.bake_fps set before import.
That control is green: **62 checks, 0 misses**. The same committed test then
rejects all five mutations of that control:

| Mutant | Checks failed | Specific witness |
| --- | ---: | --- |
| 1: always 30 Hz | 4 | 120 Hz minimum becomes **0.145530701**, exceeds 0.142; both CMU and FBX key-growth checks also reject |
| 2: default 120 Hz | 3 | All three default-versus-explicit-30 animation comparisons reject |
| 3: rate reaches GLB only | 1 | FBX limb stays at 18 keys instead of growing |
| 4: swap hand/elbow roles | 12 | Hand is no longer the elbow's distal child |
| 5: loosen ceiling to 0.146 | 1 | Ceiling now admits the measured 30 Hz negative control |

Each mutant exits 1; control exits 0. Swapping roles leaves the bidirectional
all-pairs distance mathematically unchanged, so hierarchy is essential for
mutant 4. Mutant 5 uses the same ceiling for the positive and negative control;
it is not rejected by a hard-coded check of the threshold's numeric value.
Reproduce loader substitution with `-- MUTANT=<absolute scratch script>`;
oracle switches are `ROLE_SWAP` and `LOOSE_CEILING` (can accompany MUTANT).

Parse gate: `CHECK total=1 fails=0`. Only the C151 test and its scratch controls
were executed, never the suite. Godot 4.7.2 was launched through the installed
Chocolatey executable because the stated LocalAppData executable denied launch.
Host log-file/root-certificate errors appeared separately from the completed
test counters; there were no runtime script errors in the measured runs.

Task precedence: no HANDOFF edit or digest read; only the two owned files ship.
The task's instruction to report a violated contract instead of fixing it
applies: **the production zero-miss acceptance gate is not met**. The requested
all-green mailbox wording must therefore be replaced with the actual result.
